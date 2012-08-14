use 5.008001;
use ExtUtils::MakeMaker;
use Config;

sub bail($) {
    my $reason = shift;
    warn $reason;
    exit(0);
}

# Check TagLib (taglib.so) is installed.
# Note that this depends on the search path -- 
# If the one you want is down-path, then modify your
# PATH environment variable, or edit for a fixed path

bail("Please install the taglib C++ library first. \nI need the package that has taglib-config")
  unless system('taglib-config --version > /dev/null') == 0;
  
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
    $libs .= ' -liconv';
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
);

