This is a basic script for compiling maps on linux with wine and native hammer addons

**Setup**
1. place the script into your portal 2 root
2. open up the script with whatever text editor you like
3. set the P2PATH varible at the top to the path of your portal 2 install
4. set the FINALMAPPATH to the highst dlc
5. change the game if neccery, but for portal 2 it is not
6. USEBEE is if you have bee installed with its new vvis and vrad, to use the orignal set this flag to one, if not leave it at 0

To use postcompiler you will need to download and add the linux postcompiler binarys from https://github.com/TeamSpen210/HammerAddons/actions
Select the latest build then download the linux binarys for it, after that just place them where the windows binaries are.

**Usage**
the command is set up as: ./compilemap.sh [flag] -m [mapname]
for mapname use the mapname without a file exstionton
For most compiles -a uses all compile steps and -o uses all compile steps without postcompiler enabled

**All flags**

* -m [mapname]
* -f  run with fast settings
* -v  run vvis
* -r  run vrad
* -p  run post compiler
* -b  run vbsp
* -c  copy bsp
* -a  all (-vrpbc)
* -o  all without postcompiler (-vrbc)
