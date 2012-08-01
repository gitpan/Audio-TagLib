use Test::More tests => 7;

BEGIN { use_ok('Audio::TagLib::ID3v2::FrameFactory') };

my @methods = qw(createFrame defaultTextEncoding
                 setDefaultTextEncoding instance);
can_ok("Audio::TagLib::ID3v2::FrameFactory", @methods) 					or 
	diag("can_ok failed");

# The constructor for FrameFactory is protected. Use this instead
my $ff = Audio::TagLib::ID3v2::FrameFactory->instance();
isa_ok($ff, "Audio::TagLib::ID3v2::FrameFactory") 						or 
	diag("method instance() failed");
# TIT2 - title
my $data = Audio::TagLib::ByteVector->new('TIT2', 4);
isa_ok($data, "Audio::TagLib::ByteVector") 					        	or 
	diag("method new ByteVector() failed");
my $header = Audio::TagLib::ID3v2::Header->new($data);
isa_ok($header, "Audio::TagLib::ID3v2::Header") 					   	or 
	diag("method new Header() failed");
=if 0
TODO: {
    local $TODO = "Error in id3v2framefactory.cpp";
    # There's an error in id3v2framefactory.cpp, 101. 
    # The fix installed is to chage <= to !=
    # The fix will remain in until final testing
    my $frame = $ff->createFrame($data);
    isa_ok($frame, "Audio::TagLib::ID3v2::Frame")                           or
        diag("method createFrame(data) failed");
    $frame = $ff->createFrame($data, 1);
    isa_ok($frame, "Audio::TagLib::ID3v2::Frame")                           or
        diag("method createFrame(data, synchSafeInts) failed");
    $frame = $ff->createFrame($data, 4);
    isa_ok($frame, "Audio::TagLib::ID3v2::Frame")                           or
        diag("method createFrame(data, version) failed");
    $frame = $ff->createFrame($data, $header);
    isa_ok($frame, "Audio::TagLib::ID3v2::Frame")                           or
        diag("method createFrame(data, header) failed");
    # CPAN perl 5.17.2  Can't call method "setText" on an undefined value
    $frame->setText(Audio::TagLib::String->new('Twas brillig'));
}
=cut
cmp_ok($ff->defaultTextEncoding(), 'eq', 'Latin1')                      or
    diag("method defaultTextEncoding() failed");
$ff->setDefaultTextEncoding('UTF8');
cmp_ok($ff->defaultTextEncoding(), 'eq', 'UTF8')                        or
    diag("method defaultTextEncoding() failed");
