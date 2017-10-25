import os, commandeer, httpclient, json, strutils, gitapi, rdstdin, tables, ospaths, colorize, posix, math

const API_BASE = "https://api.github.com/"
const AUTH_URI = "http://bit.ly/2lblo9n" # "https://github.com/login/oauth/authorize?client_id=413c2fd24e15c914f36a&scope=repo"
const BANNER = slurp("./banner.txt")

proc askForAuthKey(): string =
  result = readLineFromStdin "Please paste the code you were given here: "
  if result.len < 1:
    result = askForAuthKey()

proc authenticate() =
  discard readLineFromStdin "In order to access private repositories massclone needs to be given access to them. Please navigate to " & AUTH_URI & " in your browser. When you've authenticated press return to continue."
  var auth_key = askForAuthKey()
  var tmp = getTempDir() / "massclone" / "secret"
  createDir(getTempDir() / "massclone")
  writeFile(tmp, auth_key)

proc getAuthKey(): string =
  var tmp = getTempDir() / "massclone" / "secret"
  var exists = fileExists(tmp)
  if exists: result = readFile(tmp)
  else: result = ""

proc fetchReposForUser(username: string, limit: int, private: bool = false): JsonNode =
  var client = newHttpClient()
  var api_hook = API_BASE / "users" / username / "repos?per_page=" & limit.intToStr()
  if private:
    var key = getAuthKey()
    if key.isNilOrEmpty(): echo("You haven't authenticated with GitHub yet. Please run the 'auth' command.")
    else:
      api_hook = API_BASE / "user/repos?per_page=" & limit.intToStr() & "&access_token=" & key & "&type=all"
  var response = client.getContent(api_hook)
  echo(api_hook)
  result = parseJson(response)

proc cloneRepos(username: string, destination: string, ssl: bool = false, limit: int = 200, private: bool = false) =
  var response = fetchReposForUser(username, limit, private)
  var repos: Table[string, string] = initTable[string, string](nextPowerOfTwo(limit))
  for repo in response:
      var name = repo["full_name"].getStr()
      echo("Queuing " & name)
      if ssl:
          repos.add(name, repo["ssh_url"].getStr())
      else:
          repos.add(name, repo["clone_url"].getStr())
  echo("You are about to clone " & repos.len().intToStr() & " repo(s). This may take a while.")
  var cont = readLineFromStdin "Do you want to continue? [Y/n] "
  cont = cont.toLowerAscii()
  if cont == "n":
    echo("Exiting")
    quit()
  for name, repo in repos:
      var path = destination / name
      echo("Cloning " & repo & "...")
      discard gitClone(repo, path)

proc main() =
  var generalHelp = fgGreen(BANNER) & """


 Massclone is a tool that allows you to clone entire GitHub accounts with a single command.

 Usage:
  massclone clone <github username> --dest ./clones
  massclone clone <github username> --ssl --limit 15

  # Authenticate with GitHub to clone private repos
  massclone auth # Authenticate interactively

Massclone was written by @watzon using Nim. If you find a bug please report it using the GitHub issue tracker. https://github.com/watzon/massclone/issues
"""
  var cloneUsage = """Usage: massclone clone [options] <username>
  
  Options:
  --help           		- Show this message.
  --dest, -d <path>		- Set the destination path.
  --limit, -l <int>		- Limit the number of repos to clone.
  --ssl, -s <bool>		- Use ssh to pull repos? Requires a private key to be set up.
  --private, -p <bool>	- Include private repositories. You will need to authenticate.
  
  All options are optional.
  """

  var authUsage = """Usage: massclone auth

The auth command allows you to authenticate with GitHub and gives this tool access to private repositories.
"""
  
  commandline:
    subcommand clone, "clone":
      argument username, string
      option destination, string, "dest", "d", "."
      option limit, int, "limit", "l", 200
      option usessl, bool, "ssl", "s", false
      option private, bool, "private", "p", false
      exitoption "help", "h", cloneUsage
    subcommand auth, "auth":
      exitoption "help", "h", authUsage
    exitoption "help", "h", generalHelp
    errormsg "You made a mistake!"

  if clone:
    cloneRepos(username, destination, usessl, limit, private)
  
  if auth:
    authenticate()

main()