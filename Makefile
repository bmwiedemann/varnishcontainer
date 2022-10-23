DESTDIR=
PREFIX:=/usr/local
ETC:=/etc
install:
	install -m 755 -p helper/varnishlog $(DESTDIR)${PREFIX}/bin/
	install -m 755 -p helper/varnishstat $(DESTDIR)${PREFIX}/bin/
	install -m 755 -p helper/varnish_reload_vcl $(DESTDIR)${PREFIX}/bin/
	install -m 644 -p helper/logrotate.d.varnish $(DESTDIR)$(ETC)/logrotate.d/varnish
