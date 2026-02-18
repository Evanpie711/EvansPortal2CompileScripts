#!/bin/bash

#-------------------------------------------------------------------------------------------------------------------
#                           Set this stuff before useing
P2PATH="/home/USERNAME/.steam/debian-installation/steamapps/common/Portal 2/" #set to the portal 2 root directory
FINALMAPPATH="portal2_dlc2/" #Set to highest dlc folder so cubemaps work becuse source is evil
GAME="portal2/" #change the game if needed
USEBEE=0 #set to 1 if you have BEE installed aand want to use vbsp_/vrad original. otherwise have as 0
#
#-------------------------------------------------------------------------------------------------------------------

MAPNAME=""

FAST=0

USEVVIS=0
USEVRAD=0
USEPOST=0
USEVBSP=0
USECOPY=0
MAPSET=0

OPTIND=1

while getopts "h?afvcrpbvm:o" opt; do
    case "$opt" in
    h|\?)
        echo "Usage: $0 [arg] [-m mapname]"
        echo ""
        echo "# -m [mapname]"
        echo "# -f (fast)"
        echo "# -v  vvis"
        echo "# -r  vrad"
        echo "# -p  post compiler"
        echo "# -b  vbsp"
        echo "# -c  copy"
        echo "# -a  all (-vrpbc)"
        echo "# -o  all without postcompiler (-vrbc)"
        exit 0
        ;;
    o)  USEVVIS=1
        USEVRAD=1
        USEVBSP=1
        USECOPY=1
        ;;
    a)  USEVVIS=1
        USEVRAD=1
        USEPOST=1
        USEVBSP=1
        USECOPY=1
        ;;
    f)  FAST=1
        ;;
    v)  USEVVIS=1
        ;;
    r)  USEVRAD=1
        ;;
    p)  USEPOST=1
        ;;
    b)  USEVBSP=1
        ;;
    c)  USECOPY=1
        ;;
    m)  MAPNAME=$OPTARG
        MAPSET=1
        echo "map: $MAPNAME"
        ;;
    esac
done

if [ $MAPSET -eq 0 ]; then
    echo "No map, Exiting"
    exit 1
fi

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift



MAPPATH="sdk_content/maps/"

GAMEDIR="$P2PATH$GAME"

POSTCOMPILERCOMMAND="./bin/postcompiler/postcompiler"

if [ $USEBEE -eq 1 ]; then
VBSPPATH="bin/vbsp_original.exe"
VVISPATH="bin/vvis.exe"
VARDPATH="bin/vrad_original.exe"
else
VBSPPATH="bin/vbsp.exe"
VVISPATH="bin/vvis.exe"
VARDPATH="bin/vrad.exe"
fi




#fast vs full options - change if you want
VVIS_ARG_FULL=()
VVIS_ARG_FAST=("-fast")

VRAD_ARG_FULL=("-hdr" "-final" "-staticproppolys" "-staticproplighting")
VRAD_ARG_FAST=("-staticproppolys" "-staticproplighting" "-fast" "-bounce 2" "-noextra" )

VRAD_ARG=()
VVIS_ARG=()

if [ $FAST -eq 1 ]; then
    VRAD_ARG=$VRAD_ARG_FAST
    VVIS_ARG=$VVIS_ARG_FAST
else
    VRAD_ARG=$VRAD_ARG_FULL
    VVIS_ARG=$VVIS_ARG_FULL
fi

MAPPATH="${P2PATH}${MAPPATH}${MAPNAME}"

if [ $USEVBSP -eq 1 ]; then
VBSPCOMMAND=(wine "./$VBSPPATH" -game "Z:$GAMEDIR" "Z:$MAPPATH")
echo -e "\e[32m---------------------------------------------------------------------"
echo "running bsp"
echo "${VBSPCOMMAND[*]}"
echo -e "---------------------------------------------------------------------\e[0m"
"${VBSPCOMMAND[@]}"
fi


if [ $USEPOST -eq 1 ]; then
FINALPOSTCOMMAND=("${POSTCOMPILERCOMMAND}" "$MAPPATH")
echo -e "\e[32m---------------------------------------------------------------------"
echo "running post compiler:"
echo "${FINALPOSTCOMMAND[*]}"
echo -e "---------------------------------------------------------------------\e[0m"
"${FINALPOSTCOMMAND[@]}"
fi



if [ $USEVVIS -eq 1 ]; then
VVISCOMMAND=(wine "./$VVISPATH")
VVISCOMMAND+=(${VVIS_ARG[@]})
VVISCOMMAND+=("-game" "Z:$GAMEDIR" "Z:$MAPPATH")
echo -e "\e[32m---------------------------------------------------------------------"
echo "running vvis"
echo "${VVISCOMMAND[*]}"
echo -e "---------------------------------------------------------------------\e[0m"
"${VVISCOMMAND[@]}"
fi



if [ $USEVRAD -eq 1 ]; then
VRADCOMMAND=("wine" "./$VARDPATH")
VRADCOMMAND+=(${VRAD_ARG[@]})
VRADCOMMAND+=("-game" "Z:$GAMEDIR" "Z:$MAPPATH")
echo -e "\e[32m---------------------------------------------------------------------"
echo "running vrad"
echo "${VRADCOMMAND[*]}"
echo -e "---------------------------------------------------------------------\e[0m"
"${VRADCOMMAND[@]}"
fi



if [ $USECOPY -eq 1 ]; then
COPYCOMMAND=(cp "${MAPPATH}.bsp" "${P2PATH}${FINALMAPPATH}maps/${MAPNAME}.bsp")
echo -e "\e[32m---------------------------------------------------------------------"
echo "copy file"
echo "${COPYCOMMAND[*]}"
echo -e "---------------------------------------------------------------------\e[0m"
"${COPYCOMMAND[@]}"
fi


# ./bin/postcompiler/postcompiler '/media/gamedisk/Program Files (x86)/Steam/steamapps/common/Portal 2/sdk_content/maps/pmamcomp_sheperdscrook.bsp'
