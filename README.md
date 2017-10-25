# Massclone

Massclone is a tool for bulk cloning GitHub repositories. With it you can easily clone, 3 or 300 repos with a single command. Works with private repos too! All you have to do is authenticate with GitHub.

## Usage

#### _massclone clone <username> [options]_

Clones any number of git repositories for a particular user.

*Options:*

- --ssh, -s - Use ssh to pull repositories. Only use this if you have ssh access to the account.
- --dest, -d - Specify the destination to clone everything into. Default is the current directory.
- --limit, -l - Limit the number of repositories pulled
- --private, -p - Pull private repositories as well. This will require you to be authenticated.

#### _massclone auth_

Authenticate with GitHub using OAuth2. This is the only way to pull private repositories.

To authenticate you will need to run `massclone auth` and then paste the given link in your browser. When GitHub asks if you want to allow massclone access to private repositories, say yes. GitHub will redirect you to another page and if all is well you will be given a key. Copy that key and go back to your terminal. When massclone asks for the key paste it in and press enter.

You will now be able to use the `--private` flag in conjunction with `massclone clone` to pull private repositories.

### Development

I created this tool in my spare time to play with Nim and create something potentially useful. If you have an issue or a feature request please log it in the issue tracker or create a pull request. I'd like to see this tool become even more.

## Building

To build this you will need Nim and Nimble installed. Nim is a functional language that compiles to C/C++ and Nimble is it's package manager. Make sure to add `~/.nimble/bin` to your PATH.

Once you have Nim installed and have entered the directory where you want this to be built enter the following commands

```
git clone https://github.com/watzon/massclone.git
cd massclone
nimble install
```

The `nimble install` command will build massclone and put it in `~/.nimble/bin`. You can also run `nake debug` or `nake release` to make a debug or release build. Those will be in the `bin` directory.

## Changelog

## [0.1.0] - 2017-11-24
### Added
- Command line interface
- Ability to clone public repos
- Ability to authenticate with GitHub
- Ability to pull private repos after authenticating
- Build tools to build for Windows and Linux

## License

Copyright (c) 2017-2018 Chris Watson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[0.1.0]: https://github.com/watzon/massclone/#0.1.0