#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $dir="/root";
#my $dir="container";

my %options=qw(
httpport            80
proxyport           81
backendserver       downloadcontent2b.opensuse.org
backendport         80
localmirrorport     80
storagesize         5G
ttl                 60
grace               60
);

my @options=qw(
        httpport=i
        proxyport=i
        backendserver=s backendport=i
        localmirrorserver=s localmirrorport=i
        ttl=i
        grace=i
        purgeacl=s
        );
if(!GetOptions(\%options, @options) || (@ARGV && $ARGV[0] ne "")) {die "invalid option. @ARGV\n"}

open(my $template, "<", "$dir/vcl.conf.in") or die "error reading vcl.conf.in: $!";
open(my $vcl, ">", "/etc/varnish/vcl.conf") or die "error writing vcl.conf: $!";

while(<$template>) {
    s/\{\{([^{}]*)}}/$options{$1}/ge;
    print $vcl $_;
}

close $template;
close $vcl;

system(qw(/usr/sbin/varnishd -P /run/varnishd.pid -F -j unix,user=varnish -f /etc/varnish/vcl.conf -T:6082 -s), "file,/var/cache/varnish,$options{storagesize}", "-a", ":$options{httpport},HTTP", "-a", ":$options{proxyport},PROXY");
die "varnishd terminated: $? $!";
