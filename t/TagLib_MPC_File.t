use Test::More tests => 8;

BEGIN { use_ok('Audio::TagLib::MPC::File') };

my @methods = qw(new DESTROY ID3v1Tag APETag remove name tag
audioProperties save readBlock writeBlock find rfind insert
removeBlock readOnly isOpen isValid seek clear tell length );
can_ok("Audio::TagLib::MPC::File", @methods) 							or 
	diag("can_ok failed");

my $file = "sample/guitar.mp3";
my $i = Audio::TagLib::MPC::File->new($file);
isa_ok($i, "Audio::TagLib::MPC::File") 								or 
	diag("method new(file) failed");
isa_ok($i->tag(), "Audio::TagLib::Tag") 								or 
	diag("method tag() failed");
isa_ok($i->audioProperties(), "Audio::TagLib::MPC::Properties") 		or 
	diag("method audioProperties() failed");
isa_ok($i->ID3v1Tag(1), "Audio::TagLib::ID3v1::Tag") 					or 
	diag("method ID3v1Tag(t) failed");
isa_ok($i->APETag(1), "Audio::TagLib::APE::Tag") 						or 
	diag("method APETag(t) failed");
SKIP: {
skip "save() skipped", 1 if 1;
ok(not $i->save()) 												or 
	diag("method save() failed");
}
