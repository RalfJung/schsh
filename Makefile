TARGET := /usr/local
SCHROOT := /etc/schroot

install:
	install -o root -g root -m 755 schsh makeschsh schsh-rrsync $(TARGET)/bin/
	install -o root -g root -m 755 -d $(SCHROOT)/schsh/
	install -o root -g root -m 644 schroot/schsh/* $(SCHROOT)/schsh/
	install -o root -g root -m 755 schroot/setup.d/* $(SCHROOT)/setup.d/
	install -o root -g root -m 755 -d /var/lib/schsh/
