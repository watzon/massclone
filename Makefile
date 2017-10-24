.PHONY: default

deps:
	nimble install -D

linux:
	nim c -d:linux -o:./bin/massclone ./src/massclone.nim

windows:
	nim c -d:crosswin -o:./bin/massclone.exe ./src/massclone.nim

install:
	cp ./bin/massclone /usr/local/bin

clean:
	rm -rf ./src/nimcache
	rm ./bin/massclone*

default: linux