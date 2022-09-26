## Goal

build a container for use in docker/podman
that is easy to use for organizations or at home
that prevents duplicate downloads of rpms from mirrors/download.o.o


## Usage

    podman build .
    podman run -d -p 8080:80 $image --localmirrorserver 134.76.12.6 --localmirrorpath=/pub/linux/suse/opensuse/ --storagesize 4G
    curl -v localhost:8080/tumbleweed/repo/oss/media.1/products
    podman exec -ti $containerid varnishstat
    http_proxy=http://$IP:8080/ zypper ref # only works with http://download.o.o repos

Might also use baseurl=http://$IP:8080/PATH in /etc/zypp/repos.d/

## License

GPLv2

## Contribute

Open issues and pull-requests on https://github.com/bmwiedemann/varnishcontainer
