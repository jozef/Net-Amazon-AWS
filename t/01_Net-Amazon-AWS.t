#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 6;
use Test::Differences;
use Test::Exception;

use FindBin qw($Bin);
use lib "$Bin/lib";

BEGIN {
    use_ok ( 'Net::Amazon::AWS' ) or exit;
}

exit main();

sub main {
	my $aws = Net::Amazon::AWS->new('AWSAccessKeyId' => 'ABCDEFGHIJKLMNOP');
	ok($aws->item_search_client, 'we should have client to call item_serach');
	
    my $result = $aws->item_search(
        'Title'       => 'Perl Best Practices',
        'SearchIndex' => 'Books',
    );
    
    ok($result, 'we have a result');
    is($result->{'Request'}->{'IsValid'}, 'False', '... a failed request');

    SKIP: {
    	skip 'set $ENV{"AWSAccessKeyId"} to test successfull lookups', 2
    		if not defined $ENV{'AWSAccessKeyId'};
    	
    	my $aws = Net::Amazon::AWS->new();
		my $result = $aws->item_search(
			'Title'       => 'Perl Best Practices',
			'SearchIndex' => 'Books',
		);
		cmp_ok($result->{'TotalResults'}, '>', 0, 'some items for "Perl Best Practices"');
		ok(scalar (grep { $_->{'ASIN'} eq '0596001738' } @{$result->{'Item'}}), 'one of them is should be the "right one" - 0596001738')
    	
	}
	
	return 0;
}
