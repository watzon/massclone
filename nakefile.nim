import nake

const name = "massclone"
const flags = "-d:ssl"
const build_file = "src/massclone.nim"
const release_dir = "bin/release/"
const release_dir_win = "bin/release/win64/"
const debug_dir = "bin/debug/"
const debug_dir_win = "bin/debug/win64/"

task "release", "Build in release mode for a smaller, faster binary":
    createDir(release_dir_win)
    shell(nimExe, "c", flags, "-d:release", "-o:" & release_dir & name, build_file)
    shell(nimExe, "c", flags, "-d:release -d:crosswin  --dynlibOverride=src/libeay64.dll", "-o:" & release_dir_win & name & ".exe", build_file)
    shell("cp dlls/* " & release_dir_win)
    shell("tar -C " & release_dir & " -zcvf " & release_dir & name & "-win64.tar.gz win64")

task "debug", "Build in debug mode":
    createDir(debug_dir_win)
    shell(nimExe, "c", flags, "-d:debug", "-o:" & debug_dir & name & "-dbg", build_file)
    shell(nimExe, "c", flags, "-d:release -d:crosswin --dynlibOverride=src/libeay64.dll", "-o:" & debug_dir_win & name & ".exe", build_file)
    shell("cp dlls/* " & debug_dir_win)
    shell("tar -C " & debug_dir & " -zcvf " & debug_dir & name & "-win64-dbg.tar.gz win64")