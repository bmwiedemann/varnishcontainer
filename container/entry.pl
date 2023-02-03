#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $dir = "/root";

my %options = qw(
backendserver       http://$host$request_uri
storagesize         5G
ttl                 4m
);

my @options = qw(
        backendserver=s
        storagesize=s
        ttl=s
        debug!
        );
if(!GetOptions(\%options, @options)) {die "invalid option. @ARGV\n"}

my $conf;
if($options{debug}) {
    open($conf, ">&STDOUT");
    $dir = "container";
} else {
    open($conf, ">", "/etc/nginx/vhosts.d/downloadcontentcache.conf") or die "error writing .conf: $!";
}
open(my $template, "<", "$dir/downloadcontentcache.conf.in") or die "error reading downloadcontentcache.conf.in: $!";

my $line=0;
sub handle_lines($$);
sub handle_lines($$)
{ my ($fd, $skiptoendif) = @_;

    while(<$fd>) {
        #print $conf $line++, "$skiptoendif ";
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
        print $conf $_;
    }
}

handle_lines($template, 0);
close $template;
close $conf;

system(qw(cp -a /root/nginx.conf /etc/nginx/));
unless($options{debug}) {
    system(qw(/usr/sbin/nginx -g), "daemon off;", @ARGV);
    die "nginx terminated: $? $!";
}
