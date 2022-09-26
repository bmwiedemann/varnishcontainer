FROM opensuse/leap:latest

COPY container/server-http-repo.key /root/server-http-repo.key

RUN rpmkeys --import /root/server-http-repo.key \
    && zypper ar https://download.opensuse.org/repositories/server:/http/15.4/ http \
    && zypper -n install varnish

COPY container /root

ENTRYPOINT ["/root/entry.pl"]
