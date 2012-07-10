use Test::More tests => 5;

BEGIN { use_ok('Audio::TagLib::Ogg::File') };

my @methods = qw(DESTROY packet setPacket firstPageHeader
lastPageHeader name tag audioProperties save
readBlock writeBlock find rfind insert removeBlock readOnly isOpen
isValid seek clear tell length );
can_ok("Audio::TagLib::Ogg::File", @methods) 							or 
	diag("can_ok failed");

my $file = "sample/guitar.ogg";
my $flacfile = Audio::TagLib::Ogg::FLAC::File->new($file);
isa_ok($flacfile->packet(0), "Audio::TagLib::ByteVector") 				or 
	diag("method packet(i) failed");
SKIP: {
skip "skip setPacket(i, p) & save()", 0 if 1;
}
isa_ok($flacfile->firstPageHeader(), "Audio::TagLib::Ogg::PageHeader") or 
	diag("method firstPageHeader() failed");
isa_ok($flacfile->lastPageHeader(), "Audio::TagLib::Ogg::PageHeader") 	or 
	diag("method lastPageHeader() failed");
