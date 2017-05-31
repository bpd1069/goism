VERSION=0.1.0
PREFIX=/usr/local
DESTDIR=
DST=$(DESTDIR)$(PREFIX)
EMACS_GOPATH=~/.emacs.d/Go.el
GOPATH=$(shell pwd)

all: lisp translate_package

lisp:
	mkdir -p build
	go build -o build/build_lisp \
		-ldflags "-X main.Version=${VERSION}" \
		main/build_lisp
	build/build_lisp > build/Go.el
	emacs -Q --batch -f batch-byte-compile build/Go.el

translate_package:
	go build -o bin/goel_translate_package main/translate_package

clean:
	rm -rf build/* bin/*

install:
	mkdir -p $(EMACS_GOPATH)/src/emacs
	cp -R src/emacs/lisp $(EMACS_GOPATH)/src/emacs/
	cp -R src/emacs/example $(EMACS_GOPATH)/src/emacs/
	cp -R src/emacs/emacs $(EMACS_GOPATH)/src/emacs/
	cp bin/goel_translate_package $(DST)/bin/
	chmod 755 $(DST)/bin/goel_translate_package

uninstall:
	rm $(DST)/bin/goel_translate_package

.PHONY: all lisp translate_package clean install uninstall
