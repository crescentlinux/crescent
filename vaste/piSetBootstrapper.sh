#!/usr/bin/env sh
set -o pipefail

if [ ! -e /System ]; then
  echo " You are running this script on a non-macOS system."
  echo " vaste, Asahi Linux and Crescent Linux are all intended for Apple Silicon."
  exit 1
fi

#if [ -e /vst ]; then
#  echo " [>] vaste is already installed on this system."
#  echo " Skipping procedure and starting Asahi bootstrapper."
#  curl -L --no-progress-meter https://raw.githubusercontent.com/crescentlinux/crescent/main/apple-m1-asahi/crescm1.txt | sh
#fi

if [ -e /Users/$USER/.vaste ]; then
rm -rf /Users/$USER/.vaste
fi

misc=/System/Volumes/iSCPreboot

vol() {
  local result=$(
      /bin/df "$1" \
      | /usr/bin/sed -e 1d -e 's,  , ,g' -e s,/Volumes/,, \
      | cut -d' ' -f 9-
  )
  if [[ $result == / ]] ; then
    /bin/ls -l /Volumes \
    | /usr/bin/sed -n -e 's,, ,g' -e 's, -> /$,,p' \
    | cut -d' ' -f 9-
  else
    echo "$result"
  fi
}

echo " Welcome to the pre-installation setup, $USER"
echo " You're currently in piSetBootstrapper, whose function is to set up"
echo " the vaste volume before bootstrapping the Asahi Linux installer."
echo " You can check information about vaste and its source code at:"
echo " https://github.com/crescentlinux/vaste"

echo " [>] You may be asked for your password during this process."
export vaste=/vst
export PATH=/Users/vastra/.vaste/bin:/vst/var/vaste/profiles/default/bin:$PATH

/usr/sbin/diskutil info disk0s2 | grep -i "Disk Size" | grep -Eo ":[^']*GB|TB" | sed 's/\.*: *//' | sed 's/\.*GB*//' | while read o; do
  vsize=$(echo "scale=0;$o-2" | bc)g
  
  /usr/sbin/diskutil apfs resizeContainer disk0s2 $vsize
  /usr/sbin/diskutil addPartition disk0s2 fat32 'vaste' 308m

  echo "UUID=34CF6596-EAC5-48FA-8B89-70215E439BF9 /vst apfs rw,noauto,nobrowse,suid,owners" | sudo tee -a /etc/fstab

  diskutil list | grep -o "vaste[^']*" | grep -o "disk[^']*" | while read i; do
  vaste=$i
  mount $vaste /vst
  mkdir ~/.vaste
  cd ~/.vaste

  echo " [>] Locating files.."
  mkdir System && mkdir System/Library && mkdir System/Library/CoreServices
  cd System/Library/CoreServices
  
  touch "PlatformSupport.plist"
  touch "SystemVersion.plist"
cat > PlatformSupport.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>SupportedBoardIds</key>
	<array>
		<string>Mac-CAD6701F7CEA0921</string>
		<string>Mac-551B86E5744E2388</string>
		<string>Mac-EE2EBD4B90B839A8</string>
		<string>Mac-B4831CEBD52A0C4C</string>
		<string>Mac-827FB448E656EC26</string>
		<string>Mac-4B682C642B45593E</string>
		<string>Mac-77F17D7DA9285301</string>
		<string>Mac-BE088AF8C5EB4FA2</string>
		<string>Mac-7BA5B2D9E42DDD94</string>
		<string>Mac-AA95B1DDAB278B95</string>
		<string>Mac-63001698E7A34814</string>
		<string>Mac-226CB3C6A851A671</string>
		<string>Mac-827FAC58A8FDFA22</string>
		<string>Mac-E1008331FDC96864</string>
		<string>Mac-27AD2F918AE68F61</string>
		<string>Mac-7BA5B2DFE22DDD8C</string>
		<string>Mac-CFF7D910A743CAAF</string>
		<string>Mac-AF89B6D9451A490B</string>
		<string>Mac-53FDB3D8DB8CA971</string>
		<string>Mac-5F9802EFE386AA28</string>
		<string>Mac-A61BADE1FDAD7B05</string>
		<string>Mac-E7203C0F68AA0004</string>
		<string>Mac-0CFF9C7C2B63DF8D</string>
		<string>Mac-937A206F2EE63C01</string>
		<string>Mac-1E7E29AD0135F9BC</string>
		<string>Mac-112818653D3AABFC</string>
		<string>VMM-x86_64</string>
	</array>
	<key>SupportedModelProperties</key>
	<array>
		<string>MacBookPro14,2</string>
		<string>MacBookPro14,3</string>
		<string>MacBook10,1</string>
		<string>MacBookPro14,1</string>
		<string>MacBookPro15,2</string>
		<string>iMac18,1</string>
		<string>iMac18,2</string>
		<string>iMac18,3</string>
		<string>iMacPro1,1</string>
		<string>iMac19,1</string>
		<string>iMac19,2</string>
		<string>MacBookAir8,2</string>
		<string>MacBookAir8,1</string>
		<string>MacBookPro16,1</string>
		<string>MacPro7,1</string>
		<string>Macmini8,1</string>
		<string>iMac20,1</string>
		<string>iMac20,2</string>
		<string>MacBookPro15,4</string>
		<string>MacBookPro16,2</string>
		<string>MacBookPro16,4</string>
		<string>MacBookPro16,3</string>
		<string>MacBookAir9,1</string>
		<string>MacBookPro15,1</string>
		<string>MacBookPro15,3</string>
	</array>
</dict>
</plist>
EOF

cat > SystemVersion.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>BuildID</key>
	<string>6D7985AA-1FC0-11EE-9A31-1D9F48A5D1B1</string>
	<key>ProductBuildVersion</key>
	<string>22G74</string>
	<key>ProductCopyright</key>
	<string>1983-2023 Apple Inc.</string>
	<key>ProductName</key>
	<string>macOS</string>
	<key>ProductUserVisibleVersion</key>
	<string>13.5 (stub)</string>
	<key>ProductVersion</key>
	<string>13.5</string>
	<key>iOSSupportVersion</key>
	<string>16.6</string>
</dict>
</plist>
EOF

  mkdir usr && mkdir usr/standalone
  curl --no-progress-meter https://raw.githubusercontent.com/crescentlinux/crescent/main/vaste/
  
  cp -r ~/.vaste/* /vst
  /usr/sbin/diskutil unmountDisk $vaste
  mount -t ms-dos -o rdonly $vaste
  
done
   done

   echo " [>] Completed setup."
   echo " [>] Starting Asahi Linux Installer.."
   curl -L --no-progress-meter https://raw.githubusercontent.com/crescentlinux/crescent/main/apple-m1-asahi/crescm1.txt | sh
