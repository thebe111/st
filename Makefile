.POSIX:
include config.mk

SRC = src/st.c src/x.c
OBJ = $(SRC:.c=.o)

.PHONY: all
all: options st

.PHONY: options
options:
	@echo st build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

%.o: %.c
	$(CC) $(STCFLAGS) -c $< -o $(subst src/, build/, $@)

st.o: src/include/config.h src/include/st.h src/include/win.h
x.o: src/include/arg.h src/include/config.h src/include/st.h src/include/win.h

$(OBJ): src/include/config.h config.mk

st: $(OBJ)
	$(CC) -o build/$@ $(subst src/, build/, $(OBJ)) $(STLDFLAGS)

.PHONY: clean
clean:
	rm -f build/* st-$(VERSION).tar.gz

.PHONY: dist
dist: clean
	mkdir -p st-$(VERSION)
	cp -R FAQ LICENSE Makefile README config.mk src docs st-$(VERSION)
	tar -cf - st-$(VERSION) | gzip > st-$(VERSION).tar.gz
	rm -rf st-$(VERSION)

.PHONY: install
install: st
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f build/st $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < docs/st.1 > $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1
	tic -sx docs/st.info
	@echo Please see the README file regarding the terminfo entry of st.

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1

