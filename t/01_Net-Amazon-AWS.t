#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 8;
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
        skip 'set $ENV{"AWSAccessKeyId"} to test successfull lookups', 4
            if not defined $ENV{'AWSAccessKeyId'};
        
        $aws = Net::Amazon::AWS->new();
        $result = $aws->item_search(
            'Title'       => 'Perl Best Practices',
            'SearchIndex' => 'Books',
        );
        cmp_ok($result->{'TotalResults'}, '>', 0, 'some items for "Perl Best Practices"');
        ok(scalar (grep { $_->{'ASIN'} eq '0596001738' } @{$result->{'Item'}}), 'one of them is should be the "right one" - 0596001738');
        
        # based on ASIN lookup
        $result = $aws->item_lookup(
            'IdType' => 'ASIN',
            'ItemId' => '0596001738',
        );
        
        is(scalar @{$result->{'Item'}}, 1, 'one result for ASIN lookup');
        
        my $item = shift @{$result->{'Item'}};
        is($item->{'ItemAttributes'}->{'Title'}, 'Perl Best Practices', '0596001738 => "Perl Best Practices"')
        
    }
    
    return 0;
}
