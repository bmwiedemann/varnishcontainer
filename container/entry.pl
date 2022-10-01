#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $dir = "/root";

my %options = qw(
backendserver       downloadcontent2b.opensuse.org
backendport         80
localmirrorport     80
localmirrorpath     /
storagesize         5G
ttl                 60
grace               60
);

my @options = qw(
        backendserver=s backendport=i
        localmirrorserver=s localmirrorport=i localmirrorpath=s
        storagesize=s
        ttl=i
        grace=i
        debug!
        );
if(!GetOptions(\%options, @options)) {die "invalid option. @ARGV\n"}

my $vcl;
if($options{debug}) {
    open($vcl, ">&STDOUT");
    $dir = "container";
} else {
    open($vcl, ">", "/etc/varnish/vcl.conf") or die "error writing vcl.conf: $!";
}
open(my $template, "<", "$dir/vcl.conf.in") or die "error reading vcl.conf.in: $!";

my $line=0;
sub handle_lines($$);
sub handle_lines($$)
{ my ($fd, $skiptoendif) = @_;

    while(<$fd>) {
        #print $vcl $line++, "$skiptoendif ";
        if(m/\{%\s*if(.*)\s*%\}/) {
            handle_lines($fd, ($skiptoendif or !eval($1)));
            next;
        }
        if(m/\{%\s*endif\s*%\}/) {
            return
        }
        if($skiptoendif>0) {
            next;
        }
        s/\{\{([^{}]*)\}\}/$options{$1}||""/ge;
        print $vcl $_;
    }
}

handle_lines($template, 0);
close $template;
close $vcl;

unless($options{debug}) {
    system(qw(/usr/sbin/varnishd -P /run/varnishd.pid -F -f /etc/varnish/vcl.conf -T:6082 -s), "file,/var/cache/varnish,$options{storagesize}", "-j", "unix,user=varnish", "-a", ":80,HTTP", "-a", ":81,PROXY", @ARGV);
    die "varnishd terminated: $? $!";
}
