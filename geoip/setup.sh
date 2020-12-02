#!/bin/bash

sudo wget https://github.com/maxmind/geoipupdate/releases/download/v${geoipVersion}/geoipupdate_${geoipVersion}_linux_amd64.deb
sudo dpkg -i geoipupdate_${geoipVersion}_linux_amd64.deb
if [ -n "$AccountID" ] ; then
  sudo sed -i "/AccountID/c\AccountID $AccountID" /etc/GeoIP.conf
fi
if [ -n "$LicenseKey" ] ; then
  sudo sed -i "/LicenseKey/c\LicenseKey $LicenseKey" /etc/GeoIP.conf
fi
if [ -n "$AccountID" ] ; then
    if [ -n "$LicenseKey" ] ; then
        sudo geoipupdate
        sudo echo "2 18 * * 5 root /usr/bin/geoipupdate && chown -R web:web /usr/share/GeoIP/" > /etc/cron.d/geoip
    fi
fi