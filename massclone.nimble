# Package

version       = "0.1.0"
author        = "Chris Watson"
description   = "Easily clone all of your github repos"
license       = "MIT"

srcDir        = "src"
binDir        = "bin"
bin           = @["massclone"]

# Dependencies

requires "nim >= 0.17.2"
requires "gitapi"
requires "https://github.com/fenekku/commandeer >= 0.11.0"