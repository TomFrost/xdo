NAME    := xdo
VERCMD  ?= git describe 2> /dev/null
VERSION := $(shell $(VERCMD) || cat VERSION)

CPPFLAGS += -D_POSIX_C_SOURCE=200112L -DVERSION=\"$(VERSION)\"
CFLAGS   += -std=c99 -pedantic -Wall -Wextra
LDLIBS   := -lxcb -lxcb-icccm -lxcb-ewmh -lxcb-xtest

PREFIX    ?= /usr/local
BINPREFIX ?= $(PREFIX)/bin
MANPREFIX ?= $(PREFIX)/share/man

SRC := $(wildcard *.c)
OBJ := $(SRC:.c=.o)

all: $(NAME)

debug: CFLAGS += -O0 -g
debug: $(NAME)

include Sourcedeps

$(OBJ): Makefile

$(NAME): $(OBJ)

install:
	mkdir -p "$(DESTDIR)$(BINPREFIX)"
	cp -p $(NAME) "$(DESTDIR)$(BINPREFIX)"
	mkdir -p "$(DESTDIR)$(MANPREFIX)/man1"
	cp -p doc/$(NAME).1 "$(DESTDIR)$(MANPREFIX)/man1"

uninstall:
	rm -f "$(DESTDIR)$(BINPREFIX)/$(NAME)"
	rm -f $(DESTDIR)$(MANPREFIX)/man1/$(NAME).1

doc:
	a2x -v -d manpage -f manpage -a revnumber=$(VERSION) doc/$(NAME).1.txt

clean:
	rm -f $(OBJ) $(NAME)

.PHONY: all debug install uninstall doc clean
