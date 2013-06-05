#!/bin/bash 

usage()
{
cat << EOF
usage: $0 options

This script run to scale images into different screen sizes of android.

OPTIONS:
   -h      Show this message
   -p      Project path
   -i      input image path
   -s      scale size on XHDPI. Others will be calculated
   -o      out put image file name. This will be created in the place where it should be in android project 
EOF
}

PROJ_HOME="."
IN=
OUT=
SIZE=


while getopts “hp:i:s:o:” OPTION
do
    case $OPTION in
         h)
             usage
             exit 1
             ;;
         p)
             PROJ_HOME=$OPTARG
             ;;
         i)
             IN=$OPTARG
             ;;
         s)
             SIZE=$OPTARG
             ;;
         o)
             OUT=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

echo $PROJ_HOME $IN $SIZE $OUT


if [[ -z $PROJ_HOME ]] || [[ -z $IN ]] || [[ -z $OUT ]] || [[ -z $SIZE ]]
then
    usage
    exit 3
fi


if [ -f "$PROJ_HOME/AndroidManifest.xml" ]
then echo "Ok.."
else echo 'Please run me inside android project base directory' 
    exit 1;
fi

echo 'Running'

in="ColorMap.png"
outname="out2.png" 

XHDPI="400"

HDPI=`bc -l <<< "$XHDPI * (6/8.0)"`
MDPI=`bc -l <<< "$XHDPI * (4/8.0)"`
LDPI=`bc -l <<< "$XHDPI * (3/8.0)"`

function create_image {
    DPI=$1
    RES=$2
   if [[ -z $PROJ_HOME ]] || [[ -z $IN ]]
   then
      echo "Invalid params" 
       return
    fi
    if [ -d "$PROJ_HOME/res/drawable-$DPI" ]
    then
        outf="$PROJ_HOME/res/drawable-$DPI/$OUT" 
        echo "Creating $DPI image.. $outf"
        convert $IN -scale $RES $outf
    else
        echo "$DPI dir not found, so not creating"
    fi
}


create_image "hdpi" $HDPI
create_image "ldpi" $LDPI
create_image "mdpi" $MDPI
create_image "xhdpi" $XHDPI

echo "Done!"

