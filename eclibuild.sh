#!/bin/bash
# -- ECLI build procedure
# -- (c) 2000-2001 - Paul G. Crismer
# -- Released under the Eiffel-Forum Licence : see forum.txt


echo "** ECLI build procedure **"

function targeterr () {
	echo    Missing argument "target-class";
	usage;
}

function creationerr () {
	echo    Missing argument "creation-feature";
	usage ;
}

function usage () {
	echo Usage : "ECLIBUILD <target-class> <creation-feature>";
	exit 1
}

function vareclierr () {
	echo Error : ECLI variable not set !;
	usage;
}

# -- path of ECLI
if test -z "$ECLI" ; then 
  vareclierr 
fi

# -- compilation variables
export LIBS=$ECLI/src/spec/se/linux/libecli_c.a
export SEFLAGS='-case_insensitive -no_style_warning'
export BUILDFLAGS='-lodbc'

#
# -- Test for target and creation feature
#
echo $1 $2

if test -z "$1" ; then
	targeterr 
fi

TARGET=$1

if test -z "$2" ; then
	creationerr 
fi

CREATION=$2

echo "*  Building $TARGET creation $CREATION"

# -- Compile
 
compile $SEFLAGS $BUILDFLAGS $LIBS $TARGET $CREATION
mv a.out $1
echo all done !

 
