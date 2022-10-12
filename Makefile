PREFIX=/usr/local
install:
	install -m 755 -p helper/varnishlog ${PREFIX}/bin/
	install -m 755 -p helper/varnishstat ${PREFIX}/bin/
	install -m 755 -p helper/varnish_reload_vcl ${PREFIX}/bin/
