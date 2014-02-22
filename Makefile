TARGET := /usr/local
SCHROOT := /etc/schroot

install:
	install -o root -g root schsh makeschsh schsh-rrsync $(TARGET)/bin/
	install -o root -g root -d $(SCHROOT)/schsh/
	install -o root -g root -m 644 schroot/schsh/* $(SCHROOT)/schsh/
	install -o root -g root -d /var/lib/schsh/
