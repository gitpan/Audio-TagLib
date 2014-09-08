use Test::More tests => 15;

use lib './include';
use MPEG_Header;

BEGIN { use_ok('Audio::TagLib::MPEG::Header') };

my @methods = qw(new DESTROY isValid version layer protectionEnabled
                 bitrate sampleRate isPadded channelMode isCopyrighted isOriginal
                 frameLength copy);
can_ok("Audio::TagLib::MPEG::Header", @methods) 					or 
	diag("can_ok failed");

# Reference taglib-1.9.1 doc TagLib::MPEG::Header
# and http://www.mp3-tech.org/programmer/frame_header.html

my $mpeg_header = MPEG_Header::build_header( 'VersionID'    => 2,
                                             'Layer'        => 'III',
                                             'Protection'   => 'NotProtected',
                                             'BitRate'      => 0b1000, # 64 kbps for V2 and L3
                                             'SamplingRate' => 0b10, # 16000 Hz for V2
                                             'Padding'      => 'Pad',
                                             'ChannelMode'  => 'Stereo',
                                             'Copyright'    => 'No',
                                             'Original'     => 'Yes',
                                             'Emphasis'     => 'CCIT',
                                           );
my $data = Audio::TagLib::ByteVector->new ( $mpeg_header );
my $header = Audio::TagLib::MPEG::Header->new($data);

isa_ok($header, "Audio::TagLib::MPEG::Header") 						 or 
	diag("method new() failed");

cmp_ok($header->version(), 'eq', 'Version2')                         or
	diag("method version() failed");

cmp_ok($header->layer(), '==', 3 )                                   or
	diag("method layer() failed");

# Table lookup [layer][version]
cmp_ok($header->samplesPerFrame(), '==', 576)                        or
	diag("method samplesPerFrame() failed");

cmp_ok($header->sampleRate(), '==', 16000)                           or
	diag("method sampleRate() failed");

cmp_ok($header->protectionEnabled(), '==', 0)                        or
	diag("method protectionEnabled() failed");

cmp_ok($header->isValid(), '==', 1)                                  or
	diag("method isValid() failed");

cmp_ok($header->isPadded(), '==', 1)                                 or
	diag("method isPadded() failed");

cmp_ok($header->isOriginal(), '==', 1)                               or
	diag("method isOriginal() failed");

cmp_ok($header->isCopyrighted(), '==', 0)                            or
	diag("method isCopyrighted() failed");

cmp_ok($header->frameLength(), '==', 289)                            or
	diag("method frameLength() failed");

cmp_ok($header->channelMode(), 'eq', 'Stereo')                       or
	diag("method channelMode() failed");

cmp_ok($header->bitrate(), '==', 64)                                 or
	diag("method bitrate() failed");
