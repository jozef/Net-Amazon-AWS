#!/usr/bin/env perl

=head1 NAME

look-up.pl - look up items in Amazon

=head1 SYNOPSIS

    look-up.pl [--access-key=ABC] search_string
    
        --access-key=ABCEDFGHIJKLMNOPQ
            can be set also via AWSAccessKeyId environmental variable
        --search-index=Books
            where to look for. Default is "All".

=head1 DESCRIPTION

=cut


use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

use Net::Amazon::AWS;

use FindBin '$Bin';

exit main();

sub main {
    my $help;
    my $access_key = $ENV{AWSAccessKeyId};
    my $look_up;
    my $search_index = 'All';
    my $asin;
    GetOptions(
        'help|h'         => \$help,
        'access-key=s'   => \$access_key,
        'search-index=s' => \$search_index,
        'asin'           => \$asin,
    ) or pod2usage;
    pod2usage if $help;
    
    $look_up = join(' ', @ARGV);
    pod2usage if not $look_up;
    
    my $aws = Net::Amazon::AWS->new();
    $aws->AWSAccessKeyId($access_key)
        if defined $access_key;    
    pod2usage if not $aws->AWSAccessKeyId;
    
    my $result;
    # lookup for ASIN
    if ($asin) {
        $result = $aws->item_lookup(
            'IdType' => 'ASIN',
            'ItemId' => $look_up,
            'ResponseGroup' => 'ItemAttributes',
        );
    }
    # search for the rest
    else {
        $result = $aws->item_search(
            'Title'       => $look_up,
            'SearchIndex' => $search_index,
        );
    }
    
    use Data::Dumper;
    print Dumper([ $result ]);
    
    return 0;
}
