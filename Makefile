TARGET := /usr/local
SCHROOT := /etc/schroot

install:
	install -o root -g root schsh makeschsh $(TARGET)/bin/
	install -o root -g root -d $(SCHROOT)/user/
	install -o root -g root -m 644 schroot/user/* $(SCHROOT)/user/
