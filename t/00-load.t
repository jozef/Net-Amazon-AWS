#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Net::Amazon::AWS' );
}

diag( "Testing Net::Amazon::AWS $Net::Amazon::AWS::VERSION, Perl $], $^X" );
