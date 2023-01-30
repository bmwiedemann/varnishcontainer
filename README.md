## Goal

build a container for use in docker/podman
that is easy to use for organizations or at home
that prevents duplicate downloads of rpms from mirrors/download.o.o


## Usage

    podman build --tag nginxcache .
    podman run --name nginxcache --volume /var/cache/nginx:/var/cache/nginx --rm -d -p 8080:80 localhost/nginxcache --localmirrorserver 134.76.12.6 --localmirrorpath=/pub/linux/suse/opensuse/ --storagesize 4G
    curl -v localhost:8080/tumbleweed/repo/oss/media.1/products
    podman exec -ti nginxcache nginxcachestat
    podman generate systemd --new --name nginxcache > /etc/systemd/system/nginxcachecontainer.service
    http_proxy=http://$IP:8080/ zypper ref # only works with http://download.o.o or http://mirrorcache.o.o repos, but not with https and not with /path/to/opensuse/
    nginxcache_reload # after test-editing the generated .conf

Might also use baseurl=http://$IP:8080/PATH in /etc/zypp/repos.d/

## License

GPLv2

## Contribute

Open issues and pull-requests on https://github.com/bmwiedemann/varnishcontainer
