FROM opensuse/leap:latest

COPY container /root

RUN rpmkeys --import /root/server-http-repo.key \
    && zypper ar https://download.opensuse.org/repositories/server:/http/15.4/ http \
    && zypper -n install varnish

ENTRYPOINT ["/root/entry.pl"]
