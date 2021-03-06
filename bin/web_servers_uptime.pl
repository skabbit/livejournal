#!/usr/bin/perl
use strict;
use LWP::UserAgent;
use HTTP::Request;
use Getopt::Long;
use lib "$ENV{LJHOME}/cgi-bin";
use LJ::AdminTools qw(get_hosts_from_varnish_file);
use Time::HiRes qw//;

my $usage = <<"USAGE";
$0 - script to check uptime of servers
Usage:
    $0 [options] [list of servers]
Options:
    --vcl=file  Load list of servers from given varnish config file
                By default, "etc/production.vcl" is used
    --help      Show this help and exit
USAGE

my ($need_help, $vcl_file);
GetOptions(
    "vcl=s" =>  \$vcl_file,
    "help"  =>  \$need_help,
) or die $usage;
die $usage if $need_help;

my @servers = (@ARGV) 
    ? @ARGV 
    : get_hosts_from_varnish_file( $vcl_file || "$ENV{LJHOME}/etc/production.vcl");

my $now = time;

print "Server -> Uptime\n";
foreach my $server (@servers){
    chomp $server;
    print "$server -> ";
    my $t0 = [Time::HiRes::gettimeofday()];
    my $uptime = get_uptime($server);
    my $req_duration = Time::HiRes::tv_interval($t0);
    if ($uptime) {
        my $str = localtime($uptime);
        print "$uptime ($str), i.e. " . ($now - $uptime) . " sec, got in $req_duration sec";
    }
    print "\n";
}

sub get_uptime {
    my $server = shift;
    
    my $request = HTTP::Request->new('GET' => "http://$server/uptime.bml");
    $request->header(Host => 'www.livejournal.com');
    my $ua = LWP::UserAgent->new;
    my $response = $ua->request($request);
    if ($response->is_success) {
        return int $response->content;
    } else {
        warn "$server: ", $response->status_line;
        return;
    }
}


