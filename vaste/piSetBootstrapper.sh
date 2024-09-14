#!/usr/bin/env sh
set -o pipefail

if [ ! -e /System ]; then
  echo " You are running this script on a non-macOS system."
  echo " vaste, Asahi Linux and Crescent Linux are all intended for Apple Silicon."
  exit 1
fi

#if [ -e /vast ]; then
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
export vaste=/vast
export PATH=/Users/vastra/.vaste/bin:/vast/var/vaste/profiles/default/bin:$PATH

/usr/sbin/diskutil info /dev/disk0s2 | grep -i "Disk Size" | grep -Eo ":[^']*GB|TB" | sed 's/\.*: *//' | sed 's/\.*GB*//' | while read o; do
  vsize=$(echo "scale=0;$o-2" | bc)g
  
  /usr/sbin/diskutil apfs resizeContainer /dev/disk0s2 $vsize
  /usr/sbin/diskutil addPartition /dev/disk0s2 msdos 'vaste' 308m

  echo "UUID=CB6CFCF7-5EF8-3921-AC42-1876FF5A98AC /vast msdos rw,noauto,nobrowse,suid,owners" | sudo tee -a /etc/fstab

  diskutil list | grep -o "VASTE[^']*" | grep -o "disk[^']*" | while read i; do
  vaste=$i
  sudo mount -t msdos /dev/$vaste /vast
  mkdir ~/.vaste
  cd ~/.vaste

  echo " [>] Locating files.."
  mkdir System && mkdir System/Library && mkdir System/Library/CoreServices
  mkdir usr && mkdir usr/standalone
  cd System/Library/CoreServices

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

cd .. && cd .. && cd .. && cd usr/standalone

cat > bootcaches.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PreBootPaths</key>     <!-- stored at root of any Apple_Boot -->
    <dict>
        <key>DiskLabel</key>    <!-- to be tweaked for the picker -->
        <string>/System/Library/CoreServices/.disk_label</string>
        <!-- implied .disk_label helper files -->
        <key>AdditionalPaths</key>  <!-- optional stuff at the root -->
        <array>
            <string>/.VolumeIcon.icns</string>
            <string>/System/Library/CoreServices/SystemVersion.plist</string>
            <string>/System/Library/CoreServices/PlatformSupport.plist</string>
        </array>
    </dict>

    <key>BooterPaths</key>      <!-- to be blessed appropriately -->
    <dict>
        <key>EFIBooter</key>    <!-- finderinfo[1] -> file -->
        <string>/System/Library/CoreServices/boot.efi</string>
    </dict>

    <key>PostBootPaths</key>    <!-- in RPS directories known to booter -->
    <dict>
        <key>BootConfig</key>   <!-- to be updated w/UUID in Apple_Boot -->
        <string>/Library/Preferences/SystemConfiguration/com.apple.Boot.plist</string>
        <key>EncryptedRoot</key>
        <dict>
            <key>EncryptedPropertyCache</key>
            <string>/System/Library/Caches/com.apple.corestorage/EncryptedRoot.plist.wipekey</string>
            <!-- OS doesn't require content in the root volume's ER.pl.wk -->
            <key>RootVolumePropertyCache</key>
            <false/>
            <key>DefaultResourcesDir</key>
            <string>/usr/standalone/i386/EfiLoginUI/</string>
            <!-- localized resources are optional but are all or nothing -->
            <key>LocalizationSource</key>
            <string>/System/Library/PrivateFrameworks/EFILogin.framework/Resources/EFIResourceBuilder.bundle/Contents/Resources</string>
            <key>LanguagesPref</key>
            <string>/Library/Preferences/.GlobalPreferences.plist</string>
            <key>BackgroundImage</key>
            <string>/Library/Caches/com.apple.desktop.admin.png</string>
            <key>LocalizedResourcesCache</key>
            <string>/System/Library/Caches/com.apple.corestorage/EFILoginLocalizations</string>
        </dict>
        <key>Kernelcache v1.6</key>
        <dict>
            <key>ExtensionsDir</key>
            <array>
                <string>/Library/Extensions</string>
                <string>/AppleInternal/Library/Extensions</string>
                <string>/Library/Apple/System/Library/Extensions</string>
                <string>/System/Library/Extensions</string>
            </array>
            <key>Path</key>
            <string>/Library/Apple/System/Library/PrelinkedKernels/prelinkedkernel</string>
            <key>ReadOnlyPath</key>
            <string>/System/Library/PrelinkedKernels/prelinkedkernel</string>
            <key>KernelPath</key>
            <string>/System/Library/Kernels/kernel</string>
            <key>KernelsDir</key>
            <string>/System/Library/Kernels</string>
            <key>BootKernelExtensions</key>
            <string>/System/Library/KernelCollections/BootKernelExtensions.kc</string>
            <key>SystemKernelExtensions</key>
            <string>/System/Library/KernelCollections/SystemKernelExtensions.kc</string>
            <key>BaseSystemKernelExtensions</key>
            <string>/System/Library/KernelCollections/BaseSystemKernelExtensions.kc</string>
            <key>PreferBootKernelExtensions</key>
            <true/>
            <key>Archs</key>
            <array>
                <string>x86_64</string>
            </array>
            <key>Preferred Compression</key>
            <string>lzvn</string>
        </dict>
    </dict>

    <key>bless2</key>
    <dict>
        <key>Version</key>
        <integer>1</integer>
        <key>SupportsPairedRecovery</key>
        <true/>
        <key>RestoreBundlePath</key>
        <string>./Restore</string>
        <key>BuildManifestPath</key>
        <string>./Restore/BuildManifest.plist</string>
        <key>OtherRequiredPaths</key>
        <array>
            <dict>
                <key>SourcePath</key>
                <string>./Library/Preferences/SystemConfiguration/com.apple.Boot.plist</string>
                <key>DestinationPath</key>
                <string>./Library/Preferences/SystemConfiguration/com.apple.Boot.plist</string>
            </dict>
            <dict>
                <key>SourcePath</key>
                <string>./System/Library/CoreServices/PlatformSupport.plist</string>
                <key>DestinationPath</key>
                <string>./System/Library/CoreServices/PlatformSupport.plist</string>
            </dict>
            <dict>
                <key>SourcePath</key>
                <string>./System/Library/CoreServices/SystemVersion.plist</string>
                <key>DestinationPath</key>
                <string>./System/Library/CoreServices/SystemVersion.plist</string>
            </dict>
        </array>
        <key>BootObjects</key>
        <dict>
            <key>KernelCache</key>
            <dict>
                <key>DestinationPath</key>
                <string>./System/Library/Caches/com.apple.kernelcaches/kernelcache</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>DeviceTree</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/devicetree.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>ANE</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/ANE.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>Ap,ANE1</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/ANE1.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>Ap,ANE2</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/ANE2.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>Ap,ANE3</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/ANE3.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>AVE</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/AVE.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>AOP</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/AOP.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>ISP</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/ISP.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>SIO</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/SIO.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>GFX</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/GFX.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>PMP</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/PMP.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>Ap,DCP2</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/DCP.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>InputDevice</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/InputDevice.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>Multitouch</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/Multitouch.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>SEP</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/sep-firmware.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>StaticTrustCache</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/StaticTrustCache.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>Ap,BaseSystemTrustCache</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/BaseSystemTrustCache.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>Diags</key>
            <dict>
                <key>DestinationPath</key>
                <string>./AppleInternal/Diags/bin/diag.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>iBootData</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/iBootData.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>iBoot</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/iBoot.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>PERTOS</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/PERTOS.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>PHLEET</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/PHLEET.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>RBM</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/RBM.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>SystemVolume</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/root_hash.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>BaseSystemVolume</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/base_system_root_hash.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
            <key>MtpFirmware</key>
            <dict>
                <key>DestinationPath</key>
                <string>./usr/standalone/firmware/FUD/MtpFirmware.img4</string>
                <key>ManifestRule</key>
                <integer>1</integer>
            </dict>
        </dict>
    </dict>

</dict>
</plist>
EOF

cd
  
  cp -r ~/.vaste/* /vast
  
  #/usr/sbin/diskutil unmountDisk /dev/$vaste
  # for read only settings
  #sudo mount -t msdos -o rdonly /dev/$vaste /vast
  
done
   done

   echo " [>] Completed setup."
   echo " [>] Starting Asahi Linux Installer.."
   curl -L --no-progress-meter https://raw.githubusercontent.com/crescentlinux/crescent/main/apple-m1-asahi/crescm1.txt | sh
