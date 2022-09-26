#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $dir = "/root";

my %options = qw(
backendserver       downloadcontent2b.opensuse.org
backendport         80
localmirrorport     80
storagesize         5G
ttl                 60
grace               60
);

my @options = qw(
        backendserver=s backendport=i
        localmirrorserver=s localmirrorport=i
        ttl=i
        grace=i
        purgeacl=s
        debug!
        );
if(!GetOptions(\%options, @options) || (@ARGV && $ARGV[0] ne "")) {die "invalid option. @ARGV\n"}

my $vcl;
if($options{debug}) {
    open($vcl, ">&STDOUT");
    $dir = "container";
} else {
    open($vcl, ">", "/etc/varnish/vcl.conf") or die "error writing vcl.conf: $!";
}
open(my $template, "<", "$dir/vcl.conf.in") or die "error reading vcl.conf.in: $!";

while(<$template>) {
    s/\{\{([^{}]*)}}/$options{$1}/ge;
    print $vcl $_;
}

close $template;
close $vcl;

unless($options{debug}) {
    system(qw(/usr/sbin/varnishd -P /run/varnishd.pid -F -f /etc/varnish/vcl.conf -T:6082 -s), "file,/var/cache/varnish,$options{storagesize}", "-j", "unix,user=varnish", "-a", ":80,HTTP", "-a", ":81,PROXY");
    die "varnishd terminated: $? $!";
}
