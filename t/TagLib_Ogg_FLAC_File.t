use Test::More q(no_plan);

BEGIN { use_ok('Audio::TagLib::Ogg::FLAC::File') };

my @methods = qw(new DESTROY streamLength packet setPacket firstPageHeader
lastPageHeader name tag audioProperties save
readBlock writeBlock find rfind insert removeBlock readOnly isOpen
isValid seek clear tell length );
can_ok("Audio::TagLib::Ogg::FLAC::File", @methods) 					or 
	diag("can_ok failed");

SKIP: {
skip "more test needed", 1 if 1;
ok(1);
}
