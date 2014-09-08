#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  MPEG_Header.pm
#
#        USAGE:  Provides build_header, not exported.
#
#  DESCRIPTION:  Returns a MPEG header.
#
#      OPTIONS:  --- None
# REQUIREMENTS:  --- None
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Geoffrey Leach (), geoff@hughes.net
#      VERSION:  1.0
#      CREATED:  12/09/2013 10:13:28 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

# Reference taglib-1.9.1 doc TagLib::MPEG::Header
# and http://www.mp3-tech.org/programmer/frame_header.html
# file:///usr/local/doc/HTML/Perl/pod/perlfunc.html#vec%20EXPR,OFFSET,BITS

package MPEG_Header;

our %header = ('FrameSync'     => [31,21],    # Frame sync (all bits must be set)
               'VersionID'     => [20,19],    # MPEG Audio version ID
               'Layer'         => [18,17],    # Layer description
               'Protection'    => [16,16],    # Protection bit
               'BitRate'       => [15,12],    # Bitrate index
               'SamplingRate'  => [11,10],    # Sampling rate frequency index 
               'Padding'       => [9,9],      # Padding bit
               'Private'       => [8,8],      # Private bit. This one is only informative.
               'ChannelMode'   => [7,6],      # Channel Mode
               'ModeExtension' => [5,4],      # Mode extension (Only used in Joint stereo)
               'Copyright'     => [3,3],      # Copyright
               'Original'      => [2,2],      # Original
               'Emphasis'      => [1,0],      # Emphasis
             );

our %NumericOK = ('BitRate' => 1,
                  'SamplingRate' => 1,
                  'ModeExtension' => 1,
                  'FrameSync' => 1,
                 );

our %VersionID = ('2.5' => 0b00,
                  '2'   => 0b10,
                  '1'   => 0b11,
                 );

our %Layer = ('III' => 0b01,
              'II'  => 0b10,
              'I'   => 0b11,
             );

our %Protection = ('Protected'    => 0b0,
                   'NotProtected' => 0b1,
                  );

our %Padding = ('Pad'   => 0b1,
                'NoPad' => 0b0,
               );

our %Private = ('No'  => 0b0,
                'Yes' => 0b1,
               );

our %ChannelMode = ('Stereo'        => 0b00,
                    'JointStereo'   => 0b01,
                    'DualChannel'   => 0b10,
                    'SingleChannel' => 0b11,
                   );

our %Copyright = ('No', => 0b0,
                  'Yes' => 0b1,
                 );

our %Original = ('No'  => 0b0,
                 'Yes' => 0b1,
                );

our %Emphasis = ('None' => 0b00,
                 '5015' => 0b01,
                 'CCIT' => 0b11,
                );

sub _set_header_field {
    my ($hdr, $field, $value) = @_;
    die "Field $field is not defined in the MPEG header\n" unless $header{$field};
    my $first = $header{$field}->[0];
    my $last = $header{$field}->[1];
    $hdr  = pack("B*", "0"x32) unless defined $hdr;

    # Field value assignment

    if ( not exists $NumericOK{$field} ) {
        # Possible symbolic reference
        no strict 'refs'; # For symbolic reference
        # Numeric values are not OK for this field.
        # We should have a valid literal value
        die "$value is not defined for $field\n" unless exists $$field{$value};
        # Get the value for the literal
        $value = $$field{$value};
    }
    #print "Field: $field\[$first,$last\] <= "; printf "0x%x\n", $value;
    return $hdr if $value == 0;

    # Assign bits from right to left in the field defined by first..last
    # We control the for loop with $value, picking off one bit at a time.
    # The loop is not executed if the position to be set is not set in value.
    # Correct function depends on $value not having more set bits than desired.
    # The taglib C++ code appears (no doc!) to expect big-ended data organization
    # What we're doing here is moving from the input order to an organization
    # that when deoded by the taglib code results in the same ordering.
    # I'm told that tablib uses UTF-16BE internally, which would explain it?
    for (my $pos = $last; $value; $value >>= 1, $pos ++) {
        next unless $value & 1;
        # We're being asked to set the bit at position $pos.
        
        #printf "value %b\n", $value;
        # Calculate byte and bit to o be set
        #print "pos $pos\n";
        my $byte = int $pos / 8;
        my $bit = int $pos % 8;
        # Reverse the nibbles in the selected byte
        my $newbit = 7 - $bit;
        #my $newbit = $bit >= 4 ? $bit - 4 : 7 - $bit;
        #print "byte $byte bit $bit => new bit $newbit\n";

        # Re-icalculate the offset, that being the bit position in the word
        my $newpos = ($byte * 8) + $newbit;
        #print "new pos $newpos\n";

        # Assignment numbers from 0 on the left, newpos is 0 on right
        vec($hdr, 31- $newpos, 1) = 1;
        #print "Header is now ";
        #printf "b %-s\n", unpack("b*", $hdr);
    }

    return $hdr;
}

sub build_header {
    my %args = @_;
    my $header;
    $header = _set_header_field( $header, 'FrameSync', 0x7ff); # All headers have this
    foreach my $key ( keys %args ) {
        $header = _set_header_field( $header, $key, $args{$key} );
    }
    return $header;
}

1;

