## Goal

build a container for use in docker/podman
that is easy to use for organizations or at home
that prevents duplicate downloads of rpms from mirrors/download.o.o


## Usage

    podman build .
    podman run -d -p 8080:80 $image
    curl -v localhost:8080/tumbleweed/repo/oss/media.1/products

