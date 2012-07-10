use Test::More tests => 3;

BEGIN { use_ok('Audio::TagLib::Vorbis::File') };

my @methods = qw(DESTROY packet setPacket firstPageHeader
                 lastPageHeader name tag audioProperties save
                 readBlock writeBlock find rfind insert removeBlock readOnly isOpen
                 isValid seek clear tell length );
can_ok("Audio::TagLib::Vorbis::File", @methods) 					    or 
	diag("can_ok failed");

TODO: {
    local $TODO = "Audio::TagLib::Vorbis::File has no new" if 1;

    can_ok("Audio::TagLib::Vorbis::File", "new")                        or
        diag("can_ok failed");
    my $file = "sample/guitar.ogg";
    my $i = Audio::TagLib::Vorbis::File->new($file);
    isa_ok($i, "Audio::TagLib::Vorbis::File") 							or 
        diag("method new(file) failed");
    isa_ok($i->tag(), "Audio::TagLib::Ogg::XiphComment") 				or 
        diag("method tag() failed");
    isa_ok($i->audioProperties(), "Audio::TagLib::Vorbis::Properties")  or 
        diag("method audioProperties() failed");
    SKIP: {
        skip "save() skipped to avoid stepping on test data", 0 if 1;
    }
}
