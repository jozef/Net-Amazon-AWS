package Net::Amazon::AWS;

=head1 NAME

Net::Amazon::AWS - interface to Amazon Associates Web Services

=head1 SYNOPSIS

    use Net::Amazon::AWS;

    my $aws = Net::Amazon::AWS->new(
        'AWSAccessKeyId' => 'ABCDEFGHIJKLMNOP',
    );
    my $results = $aws->item_search(
        'Title'       => 'Perl Best Practices',
        'SearchIndex' => 'Books',
    );

=head1 DESCRIPTION

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

use File::Spec;
use File::Basename 'dirname';

has 'AWSAccessKeyId' => (is => 'rw', isa => 'Str', default => $ENV{'AWSAccessKeyId'});

has 'item_search_client' => (
    is      => 'rw',
    isa     => 'CodeRef',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->_aws_wsdl->compileClient('ItemSearch')
    },
);
has 'item_lookup_client' => (
    is      => 'rw',
    isa     => 'CodeRef',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->_aws_wsdl->compileClient('ItemLookup')
    },
);

=head1 METHODS

=head2 new

Object constructor.

=head2 item_search

=cut

sub item_search {
    my $self = shift;
    
    # get search request hash with setting some default values
    my %req  = (
        'SearchIndex'    => 'All',
        'AWSAccessKeyId' => $self->AWSAccessKeyId,
        @_
    );
    
    my $response = $self->item_search_client->({
        'AWSAccessKeyId' => delete $req{AWSAccessKeyId},
        'Request'        => [ \%req, ],
    });
    
    return eval { ${$response->{'body'}->{'Items'}}[0] };
}

sub item_lookup {
    my $self = shift;
    
    # get search request hash with setting some default values
    my %req  = (
        'AWSAccessKeyId' => $self->AWSAccessKeyId,
        @_
    );
    
    my $response = $self->item_lookup_client->({
        'AWSAccessKeyId' => delete $req{AWSAccessKeyId},
        'Request'        => [ \%req, ],
    });
    
    return eval { ${$response->{'body'}->{'Items'}}[0] };
}

my $_aws_wsdl;
sub _aws_wsdl {
    return $_aws_wsdl
        if defined $_aws_wsdl;
    
    $_aws_wsdl = XML::Compile::WSDL11->new(
        File::Spec->catfile(
            dirname($INC{File::Spec->catfile('Net', 'Amazon', 'AWS.pm')}),
            'AWSECommerceService.wsdl'
        )
    );
    
    return $_aws_wsdl;
}

=head1 AUTHOR

Jozef Kutej, C<< <jkutej@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-amazon-aws at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Amazon-AWS>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Amazon::AWS


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Amazon-AWS>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Amazon-AWS>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Amazon-AWS>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-Amazon-AWS>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Jozef Kutej, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

'let it flow, let it flow';
