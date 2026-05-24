 #!/bin/bash

# you need to set these
ROOTPATH="/home/USERNAME/.steam/debian-installation/steamapps/common/Portal 2 Community Edition/"
GAMEPATH="p2ce/" 
USEWINE=1 #right now this does not work without wine becuse p2ce

MDLSRCPATH="${GAMEPATH}mdlsrc"

STUDIOMDLPATH="bin/linux64/studiomdl"
STUDIOMDLPATHWIN="bin/win64/studiomdl.exe"

shopt -s globstar

cd "${ROOTPATH}"

for file in ${MDLSRCPATH}/**/*.qc; do
    echo "   "
    echo "   "
    echo "$file"
    echo "   "

    if [ $USEWINE -eq 1 ]; then

    COMPILECOMMAND=("wine" ${STUDIOMDLPATHWIN} "$file")
    "${COMPILECOMMAND[@]}"

    else

    COMPILECOMMAND=("./${STUDIOMDLPATH}" "$file")
    "${COMPILECOMMAND[@]}"

    fi

done
