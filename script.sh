declare -A APKS=(['Lightning-Browser']='app-lightningPlus-release-signed-aligned.apk'
['orbot']='Orbot-signed-aligned.apk'
['droidwall']='MainActivity-release.apk'
['hackerskeyboard']='hackerskeyboard-release.apk')

for i in ${!APKS[@]}
do
  URL=$(curl https://api.github.com/repos/galeksandrp/$i/releases/latest | jq -r ".assets[]|select(.name==\"${APKS[$i]}\").browser_download_url")
  wget $URL
  echo "location /${APKS[$i]} {return $URL;}"
done
