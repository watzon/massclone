import commandeer, httpclient, json, strutils, gitapi, rdstdin, tables, ospaths

commandline:
  argument username, string
  option destination, string, "dest", "d", "."
  option repolist, string, "repos", "r"
  option limit, int, "limit", "l", 200
  option usessl, bool, "ssl", "s", false
  exitoption "help", "h",
             "Usage: massclone [--dest <=string>|--repos<=string>|--limit <=int>|--ssl <=bool>|--help] " &
             "<username>"
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