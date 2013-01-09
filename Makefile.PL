use 5.008001;
use ExtUtils::MakeMaker;
use Config;

sub bail($) {
    my $reason = shift;
    warn $reason;
    exit(0);
}

# Patch Festus Hagen rt.cpan.org #79942
# Patch Festus Hagen 1.62.fh1 - rt.cpan.org #82298

my $tl_static = 'false';
foreach (@ARGV) {
    if ($_ =~ m/TAGLIB_STATIC/is) {
      $tl_static = 'true';
    }
}

# Check TagLib (taglib.so) is installed.
# Note that this depends on the search path -- 
# If the one you want is down-path, then modify your
# PATH environment variable, or edit for a fixed path
# WINDOWS NOTE: Taglib library names:
#   For a shared Taglib build:
#     libtag.dll and libtag.dll.a
#   For a static Taglib build:
#     libtag.a

# Patch Festus Hagen rt.cpan.org #79942
if ($Config{'osname'} eq 'MSWin32') {
    bail("\nPlease install the taglib C++ library.\n  taglib-config.cmd needs to be located via the PATH statement.\n")
        unless system('taglib-config --version > NUL') == 0;
} else {
    bail("Please install the taglib C++ library first. \nI need the package that has taglib-config")
        unless system('taglib-config --version > /dev/null') == 0;
}
  
chomp(my $libver = qx{taglib-config --version});

# Configure compiler
my $CC = 'g++';

# Configure libraries
chomp(my $libs   = qx{taglib-config --libs});

# Configure compile flags
my $cflags = $Config{'ccflags'};

# Configure includes
# ./include has a needed .h
chomp(my $inc = qx{taglib-config --cflags});
$inc  = $Config{'incpath'} . '  -I./include ' . $inc;

# Configure ld flags
my $ldd =  $Config{'lddlflags'} . ' ' .
           $Config{'ccdlflags'} . ' ' . $Config{'cccdlflags'};

# Configure various os-es
my $define;
if ( $Config{'osname'} eq 'darwin' ) {
    $define = '-D_BSD_ICONV -DNO_DOXYGEN';
    $libs .= ' -L/System/Library/Perl/lib/'. $Config{version}. ' -lperl -liconv';
}
elsif ( $Config{'osname'} eq 'freebsd' ) {
    $define = '-D_BSD_ICONV -DNO_DOXYGEN';
# Patch Festus Hagen rt.cpan.org #79942
#   $libs .= ' -liconv';
    if ($tl_static eq 'true') {
        print "Statically linking with Taglib...\n";
        $define .= ' -DTAGLIB_STATIC';
        $libs .= ' -liconv -lz';
    } else {
        print "Dynamically linking with Taglib...\n";
        $libs .= ' -liconv';
    }
}
elsif ( $Config{'osname'} eq 'MSWin32' ) {
    $define = '-DNO_DOXYGEN';
    if ($tl_static eq 'true') {
        # Taglib is built Static. (libtag.a)
        print "Statically linking with Taglib...\n";
        $define .= ' -DTAGLIB_STATIC';
        $libs .= ' -llibiconv -llibz';
    } else {
        # Taglib is built Shared. (libtag.dll.a)
        print "Dynamically linking with Taglib...\n";
        # '.dll' must remain as the first element, it gets appended to taglib
        $libs .= '.dll -llibiconv';
    }
}

#$Verbose = 2;
WriteMakefile(
    NAME              => 'Audio::TagLib',
    MIN_PERL_VERSION  => '5.008001',
    VERSION_FROM      => 'lib/Audio/TagLib.pm', 
    LICENSE           => 'perl',
    CC                => $CC,
    LD                => '$(CC)',
    XSOPT             => '-C++ -hiertype',
    CCFLAGS           => $cflags,
    LIBS              => $libs, 
    DEFINE            => $define,
    INC               => $inc,
    LDDLFLAGS         => $ldd,
    (
        $Config{'version'} >= 5.005        
        ?                                                     
          (
            ABSTRACT_FROM => 'lib/Audio/TagLib.pm',
            AUTHOR        => 'Geoffrey Leach <gleach@cpan.org>'
          )
        : ()
    ),
    PREREQ_PM => {
        "Encode"       => 0,
        "Test::Deep"   => 0,
        "File::Slurp"  => 0,
        "Test::More"   => 0,
        "Test::Output" => 0,
    },
     "CONFIGURE_REQUIRES" => {
        "ExtUtils::MakeMaker" => 0,
        "Config"              => 0,
    },
    "META_MERGE" => {
        "no_index" => {
            "directory" => "lib/Audio/TagLib",
        }
    }
);

