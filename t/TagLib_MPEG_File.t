use Test::More tests => 14;

BEGIN { use_ok('Audio::TagLib::MPEG::File') };

my @methods = qw(new DESTROY ID3v2Tag ID3v1Tag APETag
                 setID3v2FrameFactory strip firstFrameOffset nextFrameOffset
                 previousFrameOffset lastFrameOffset name tag audioProperties save
                 readBlock writeBlock find rfind insert removeBlock readOnly isOpen
                 isValid seek clear tell length);
can_ok("Audio::TagLib::MPEG::File", @methods) 						or 
	diag("can_ok failed");

my $file = "sample/guitar.mp3";
my $i = Audio::TagLib::MPEG::File->new($file);
isa_ok($i, "Audio::TagLib::MPEG::File") 							or 
	diag("method new(file) failed");
isa_ok($i->tag(), "Audio::TagLib::Tag") 							or 
	diag("method tag() failed");
isa_ok($i->audioProperties(), "Audio::TagLib::MPEG::Properties") 	or 
	diag("method audioProperties() failed");
isa_ok($i->ID3v2Tag(1), "Audio::TagLib::ID3v2::Tag") 				or 
	diag("method ID3v2Tag(t) failed");
isa_ok($i->ID3v1Tag(1), "Audio::TagLib::ID3v1::Tag") 				or 
	diag("method ID3v1Tag(t) failed");
isa_ok($i->APETag(1), "Audio::TagLib::APE::Tag") 					or 
	diag("method APETag(t) failed");
ok($i->strip("APE")) 											    or 
	diag("method strip(tags) failed");
$i->setID3v2FrameFactory(Audio::TagLib::ID3v2::FrameFactory->instance());
SKIP: {
skip "save(), to aviod stomping test data", 1 if 1;
ok(not $i->save()) 													or 
	diag("method save() failed");
}
cmp_ok($i->firstFrameOffset(), "==", 104) 							or 
	diag("method firstFrameOffset() failed");
cmp_ok($i->nextFrameOffset(925), "==", 940) 						or 
	diag("method nextFrameOffset(p) failed");
cmp_ok($i->previousFrameOffset(27690), "==", 27585) 				or 
	diag("method previousFrameOffset(p) failed");
cmp_ok($i->lastFrameOffset(), "==", -1) 				    		or 
	diag("method lastFrameOffset() failed");
