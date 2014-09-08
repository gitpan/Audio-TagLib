use Test::More tests => 13;

BEGIN { use_ok('Audio::TagLib::File') };

my @methods = qw(DESTROY name tag audioProperties save readBlock
                 writeBlock find rfind insert removeBlock readOnly isOpen isValid seek
                 clear tell length );
can_ok("Audio::TagLib::File", @methods) 								or 
	diag("can_ok failed");

# Methods tag, audioProperties and save are pure virtual.
# As such, they are not testable here. They are supposed to
# be implemented in TagLib::FLAC::File, TagLib::MPC::File, TagLib::MPEG::File,
# TagLib::Ogg::FLAC::File, TagLib::Ogg::Speex::File, TagLib::Ogg::Vorbis::File,
# TagLib::TrueAudio::File, and TagLib::WavPack::File.

# methods writeBlock, insert, removeBlock and clear modify the data. to test, we need 
# the save() method, which is virtual, so postpone this to later.

my $file = "sample/guitar.mp3";
my $blocksize = 1024;
my $fileref = Audio::TagLib::FileRef->new($file);
my $i = $fileref->file();
is($i->name(), $file) 											        or 
	diag("method name() failed");
my $block = $i->readBlock($blocksize);
cmp_ok($block->size(), "==", $blocksize) 	                            or 
	diag("method readBlock(blocksize) failed");
cmp_ok($i->readOnly(), '==', 0)                                         or
    diag("$file was read only");
cmp_ok($i->find(Audio::TagLib::ByteVector->new("4")), "==", 505) 		or 
	diag("method find(pattern) failed");
$i->seek(0, "End");
cmp_ok($i->tell(), "==", $i->length()) 							        or 
	diag("method seek() and length() failed");
cmp_ok($i->rfind(Audio::TagLib::ByteVector->new("4"), 20), "==", -1) 	or 
	diag("method rfind(pattern, fromOffset) failed");
ok($i->isOpen()) 												        or 
	diag("method isOpen() failed");
ok($i->isValid()) 												        or 
	diag("method isValid() failed");
$i->seek(0);
cmp_ok($i->tell(), "==", 0) 									        or 
	diag("method seek() and tell() failed");

ok(Audio::TagLib::File->isReadable(__FILE__))							or 
	diag("method isReadable(file) failed");
ok(Audio::TagLib::File->isWritable(__FILE__)) 							or 
	diag("method isWritable(name) failed");
