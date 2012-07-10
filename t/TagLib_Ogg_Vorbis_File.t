use Test::More tests => 3;

BEGIN { use_ok('Audio::TagLib::Ogg::Vorbis::File') };

my @methods = qw(DESTROY name tag audioProperties save readBlock writeBlock find rfind
                 insert removeBlock readOnly isOpen isValid seek clear tell length);
can_ok("Audio::TagLib::Ogg::Vorbis::File", @methods)   					   or 
	diag("can_ok failed");

TODO: {
    local $TODO = "Audio::TagLib::Ogg::Vorbis::File has no new" if 1;
    can_ok("Audio::TagLib::Ogg::Vorbis::File->new()")                      or
        diag("can_ok failed");

    my $file = "sample/guitar.ogg";
    my $i = Audio::TagLib::Ogg::Vorbis::File->new($file);
    isa_ok($i, "Audio::TagLib::Ogg::Vorbis::File");

    isa_ok($i->tag(), "Audio::TagLib::Ogg::XiphComment") 				    or 
        diag("method tag() failed");
    isa_ok($i->audioProperties(), "Audio::TagLib::Ogg::Vorbis::Properties") or 
        diag("method audioProperties() failed");
    SKIP: {
    skip "save() to avoid stomping on test data", 1 if 1;
    ok(not $i->save()) 													    or 
        diag("method save() failed");
    }
}
