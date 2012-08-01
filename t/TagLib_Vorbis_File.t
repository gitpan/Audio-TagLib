use Test::More tests => 2;

BEGIN { use_ok('Audio::TagLib::Vorbis::File') };

my @methods = qw(DESTROY packet setPacket firstPageHeader
                 lastPageHeader name tag audioProperties save
                 readBlock writeBlock find rfind insert removeBlock readOnly isOpen
                 isValid seek clear tell length );
can_ok("Audio::TagLib::Vorbis::File", @methods) 					    or 
	diag("can_ok failed");

=if 0
TODO: {
    local $TODO = "Audio::TagLib::Vorbis::File has no new" if 1;

    can_ok("Audio::TagLib::Vorbis::File", "new")                        or
        diag("can_ok failed");
    my $file = "sample/guitar.ogg";
    # CPAN perl 5.17.2  Can't locate object method "new" via package "Audio::TagLib::Ogg::Vorbis::File"`
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
=cut
