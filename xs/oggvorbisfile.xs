#include "vorbisfile.h"

MODULE = Audio::TagLib			PACKAGE = Audio::TagLib::Ogg::Vorbis::File
PROTOTYPES: ENABLE

################################################################
# 
# PUBLIC MEMBER FUNCTIONS
# 
################################################################

void
TagLib::Ogg::Vorbis::File::new(file, readProperties=true, propertiesStyle=TagLib::AudioProperties::Average)
	char * file
	bool readProperties
	TagLib::AudioProperties::ReadStyle propertiesStyle
CODE:
	TagLib::Ogg::Vorbis::File::File(file, readProperties, propertiesStyle);

void 
TagLib::Ogg::Vorbis::File::DESTROY()
CODE:
	if(!SvREADONLY(SvRV(ST(0))))
		delete THIS;

TagLib::Ogg::XiphComment *
TagLib::Ogg::Vorbis::File::tag()
CODE:
	RETVAL = THIS->tag();
OUTPUT:
    RETVAL

TagLib::Vorbis::Properties *
TagLib::Ogg::Vorbis::File::audioProperties()
CODE:
	RETVAL = THIS->audioProperties();
OUTPUT:
	RETVAL

bool 
TagLib::Ogg::Vorbis::File::save()
CODE:
	RETVAL = THIS->save();
OUTPUT:
	RETVAL

