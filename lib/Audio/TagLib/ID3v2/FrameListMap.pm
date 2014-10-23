package Audio::TagLib::ID3v2::FrameListMap;

use 5.008003;
use strict;
use warnings;

our $VERSION = '1.57';

use Audio::TagLib;

1;

__END__

=pod

=begin stopwords

Dongxu

=end stopwords

=head1 NAME

Audio::TagLib::ID3v2::FrameListMap - Perl-only class

=head1 SYNOPSIS

  use Audio::TagLib::ID3v2::FrameListMap;
  
  my $tag  = Audio::TagLib::ID3v2::Tag->new();
  $tag->setTitle(Audio::TagLib::String->new("title"));
  $tag->setArtist(Audio::TagLib::String->new("artist"));
  my $i    = $tag->frameListMap();
  print $i->size(), "\n"; # got 2

  tie my %i, ref($i), $i;
  my $l    = $i{Audio::TagLib::ByteVector->new("TIT2")};
  print $l->begin()->data()->toString()->toCString(), "\n"; # got "title"

=head1 DESCRIPTION

Implements TagLib::ID3v2::FrameListMap in C/C++ code, which is of type
TagLib::MapE<lt>L<ByteVector|Audio::TagLib::ByteVector>,
L<FrameList|Audio::TagLib::ID3v2::FrameList>E<gt>.

Optionally, you can tie an instance of ItemListMap with a hash symbol,
just like this: C<tie my %h, ref($i), $i;>, Then operate throught
I<%h>.

see L<Audio::TagLib::ID3v2::Tag::frameListMap()|Audio::TagLib::ID3v2::Tag>

=over

=item I<new()>

Constructs an empty FrameListMap.

=item I<new(L<FrameListMap|Audio::TagLib::ID3v2::FrameListMap> $m)>

Make a shallow, implicitly shared, copy of $m.

=item I<DESTROY()>

Destroys this instance of the FrameListMap.

=item I<L<Iterator|Audio::TagLib::ID3v2::FrameListMap::Iterator> begin()>

Returns an STL style iterator to the beginning of the map.

see
L<Audio::TagLib::ID3v2::FrameListMap::Iterator|Audio::TagLib::ID3v2::FrameListMap::Iterator>

=item I<L<Iterator|Audio::TagLib::ID3v2::FrameListMap::Iterator> end()>

Returns an STL style iterator to the end of the map.

see
L<Audio::TagLib::ID3v2::FrameListMap::Iterator|Audio::TagLib::ID3v2::FrameListMap::Iterator>

=item I<void insert(L<ByteVector|Audio::TagLib::ByteVector> $key,
L<FrameList|Audio::TagLib::ID3v2::FrameList> $value)>

Inserts $value under $key in the map. If a value for $key already
  exists it will be overwritten. 

=item I<void clear()>

Removes all of the elements from elements from the map. This however
will not free memory of all the items.

=item I<UV size()>

The number of elements in the map.

see I<isEmpty()>

=item I<BOOL isEmpty()>

Returns true if the map is empty.

see I<size()>

=item I<L<Iterator|Audio::TagLib::ID3v2::FrameListMap::Iterator>
find(L<ByteVector|Audio::TagLib::ByteVector> $key)>

Find the first occurance of $key.

=item I<BOOL contains(L<ByteVector|Audio::TagLib::ByteVector> $key)>

Returns true if the map contains an instance of $key.

=item I<void erase(L<Iterator|Audio::TagLib::ID3v2::FrameListMap::Iterator>
$it)>

Erase the item at $it from the list.

=item I<L<FrameList|Audio::TagLib::ID3v2::FrameList> getItem(L<ByteVector|Audio::TagLib::ByteVector>
$key)>

Returns the value associated with $key.

note This has undefined behavior if the key is not present in the map.

=item I<copy(L<FrameListMap|Audio::TagLib::ID3v2::FrameListMap> $m)>

Make a shallow, implicitly shared, copy of $m.

=back

=head2 EXPORT

None by default.



=head1 SEE ALSO

L<Audio::TagLib|Audio::TagLib>

=head1 AUTHOR

Dongxu Ma, E<lt>dongxu@cpan.orgE<gt>

=head1 MAINTAINER

Geoffrey Leach GLEACH@cpan.org

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005-2010 by Dongxu Ma

Copyright (C) 2011 - 2012 Geoffrey Leach

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
