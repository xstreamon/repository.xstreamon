#!/bin/bash
# Author: L0RE
# This Script Generates a new Inventory for a new Version or New Plugin
REPO=/root/repo/repository.xstreamon
if [ "$1" != "" ]
then
    REPO="$1"
fi
if [ -f "$(pwd)/addons.xml" ]
then
    REPO="$(pwd)"
fi
if [ ! -f "$REPO/addons.xml" ]
then
    echo "repo path nicht korrekt"
    exit 0
fi
ZIP="$(command -v zip)"
if [ "$ZIP" = "" ]
then
    echo "zip fehlt. eg: apt-get install zip"
    exit 0
fi


cd $REPO/../addons
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' >$REPO/addons.xml
echo '<addons>' >> $REPO/addons.xml
for name in *; do
   VERSION=`cat $name/addon.xml|grep \<addon|grep $name |sed 's/.*version="\([^"]*\)"*.*/\1/g'`
     if [ ! -d "$REPO/zips/$name/" ]; then
	mkdir $REPO/zips/$name
     fi
     if [ ! -f "$REPO/zips/$name/$name-$VERSION.zip" ]; then
       zip -r --exclude=*.git* $REPO/zips//$name/$name-$VERSION.zip $name -x \*.zip
     fi
   cat $name/addon.xml|grep -v "<?xml " >> $REPO/addons.xml
   echo "" >> $REPO/addons.xml
echo $name
done
 echo "</addons>" >> $REPO/addons.xml
 md5sum  $REPO/addons.xml > $REPO/addons.xml.md5
