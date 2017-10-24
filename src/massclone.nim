import commandeer, httpclient, json, strutils, gitapi, rdstdin, tables, ospaths

var usageString = """Usage: massclone [options] <username>

Options:
--help           	- Show this message
--dest, -d <path>	- Set the destination path
--limit, -l <int>	- Limit the number of repos to clone
--ssl, -s <bool>	- Use ssh to pull repos? Requires a private key to be set up.

All options are optional.
"""

commandline:
  argument username, string
  option destination, string, "dest", "d", "."
  option limit, int, "limit", "l", 200
  option usessl, bool, "ssl", "s", false
  exitoption "help", "h", usageString
  errormsg "You made a mistake!"

var api_hook = "https://api.github.com/users/" & username & "/repos?per_page=" & limit.intToStr()
var client = newHttpClient()
var response = client.getContent(api_hook)
var responseJson = parseJson(response)

# echo(responseJson.pretty())

var repos: Table[string, string] = initTable[string, string](limit)
for repo in responseJson:
    var name = repo["name"].getStr()
    if usessl:
        repos.add(name, repo["ssh_url"].getStr())
    else:
        repos.add(name, repo["clone_url"].getStr())

echo("You are about to clone " & repos.len().intToStr() & " repos. This may take a while.")
var cont = readLineFromStdin "Do you want to continue? [Y/n] "
cont = cont.toLowerAscii()

if cont == "n":
    quit()

for name, repo in repos:
    var path = destination / name
    echo("Cloning " & repo & "...")
    discard gitClone(repo, path)