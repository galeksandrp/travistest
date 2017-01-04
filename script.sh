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

declare -A APKS2=(['keepassdroid']='app-flavor1-release.apk'
['adaway']='AdAway-release.apk'
['fdroid']='app-release.apk'
['authenticator']='AuthenticatorApp-playStore-release.apk')

for i in ${!APKS2[@]}
do
  URL=$(curl https://api.github.com/repos/galeksandrp/travistest/releases/tags/deploy-$i | jq -r ".assets[]|select(.name==\"${APKS2[$i]}\").browser_download_url")
  wget $URL
  echo "location /${APKS2[$i]} {return $URL;}"
done
