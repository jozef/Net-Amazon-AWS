#!/usr/bin/env perl

=head1 NAME

look-up.pl - look item in Amazon

=head1 SYNOPSIS

	look-up.pl [--access-key] search_string
	
		--access-key=ABCEDFGHIJKLMNOPQ
		    can be set also via AWSAccessKeyId environmental variable

=head1 DESCRIPTION

=cut


use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

use FindBin '$Bin';

exit main();

sub main {
    my $help;
    my $access_key = $ENV{AWSAccessKeyId};
    my $look_up;
    GetOptions(
        'help|h'       => \$help,
        'access-key=s' => \$access_key,
    ) or pod2usage;
    pod2usage if $help;
    
    $look_up = join(' ', @ARGV);
    
    pod2usage if not $look_up;
    pod2usage if not $access_key;
    
	my $wsdl = XML::Compile::WSDL11->new($Bin.'/../lib/Net/Amazon/AWSECommerceService.wsdl');
	my $call = $wsdl->compileClient('ItemSearch');
	
	my $answer = $call->({
		AWSAccessKeyId => $access_key,
		Request => {
			Title       => $look_up,
			SearchIndex => 'All'
		}
	});
	
	use Data::Dumper;
	print Dumper([ $answer ]);
    
    return 0;
}

