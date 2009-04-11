#!/usr/bin/env perl

use strict;
use warnings;

use Net::Amazon::AWS;

my $aws = Net::Amazon::AWS->new();
my $result = $aws->item_search(
	'Title'       => 'Perl Best Practices',
	'SearchIndex' => 'Books',
);

use Data::Dumper; print "dump> ", Dumper(\$result), "\n";
