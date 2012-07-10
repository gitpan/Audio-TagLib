use Test::More q(no_plan);

BEGIN { use_ok('Audio::TagLib::MPEG::Header') };

my @methods = qw(new DESTROY isValid version layer protectionEnabled
bitrate sampleRate isPadded channelMode isCopyrighted isOriginal
frameLength copy);
can_ok("Audio::TagLib::MPEG::Header", @methods) 					or 
	diag("can_ok failed");

SKIP: {
skip "more test needed", 1 if 1;
ok(1);
}
