use Test::More tests => 8;

BEGIN { use_ok('Audio::TagLib::ID3v1::GenreMap::Iterator') };

my @methods = qw(new DESTROY data next last);
can_ok("Audio::TagLib::ID3v1::GenreMap::Iterator", @methods) or diag("can_ok failed");

my $genremap = Audio::TagLib::ID3v1->genreMap();
my $i = $genremap->begin();
isa_ok($i, "Audio::TagLib::ID3v1::GenreMap::Iterator") 				or 
	diag("method Audio::TagLib::ID3v1::genreMap() failed");
isa_ok(Audio::TagLib::ID3v1::GenreMap::Iterator->new(), 
	"Audio::TagLib::ID3v1::GenreMap::Iterator") 					or 
	diag("method new() failed");
isa_ok(Audio::TagLib::ID3v1::GenreMap::Iterator->new($i), 
	"Audio::TagLib::ID3v1::GenreMap::Iterator") 					or 
	diag("method new(i) failed");

cmp_ok($i->data(), "==", 123) 										or 
	diag("method data() failed");
cmp_ok($i->next()->data(), "==", 34) 								or 
	diag("method next() failed");
cmp_ok((--$i)->data(), "==", 123) 									or 
	diag("method last() failed");
