#!/bin/bash

#--Skript als root ausführen!--

#Script beenden, falls lock-Datei vorhanden
if [ -e /home/pi/upload.lock ]
then
  echo "Upload-Script already running...exiting"
  exit
fi

touch /home/pi/upload.lock

#Lösche lock-Datei nach Scriptende oder -abbruch
trap 'rm /home/pi/upload.lock' EXIT

#___________Code in here___________:

#Lösche alte Dateien (älter als 7 Tage)
find /home/pi/upload/Kamera*/ -mtime +7 -print -exec rm {} \;
find /home/pi/upload/Kamera*/ -type d -empty -delete -print

#Erstelle Unterordner fuer einen Tag
foldername=$(date +%Y%m%d)
mkdir -p /home/pi/upload/Kamera1/"$foldername"
mkdir -p /home/pi/upload/Kamera2/"$foldername"
mkdir -p /home/pi/upload/Kamera3/"$foldername"
mkdir -p /home/pi/upload/Kamera4/"$foldername"

#Verschiebe neue Dateien in upload-Ordner
argument="-ahv --remove-source-files --no-perms --omit-dir-times --exclude '.*'"
rsync $argument /home/pi/FTP/Kamera1/F*/snap/*.jpg  /home/pi/upload/Kamera1/$foldername
rsync $argument /home/pi/FTP/Kamera2/F*/snap/*.jpg  /home/pi/upload/Kamera2/$foldername
rsync $argument /home/pi/FTP/Kamera3/*.jpg          /home/pi/upload/Kamera3/$foldername
rsync $argument /home/pi/FTP/Kamera4/*.jpg          /home/pi/upload/Kamera4/$foldername

#Upload in den Dropbox-Ordner "Kamera"
/usr/sbin/rclone -v sync /home/pi/upload/ remote:Kamera
/usr/sbin/rclone -v rmdirs remote:Kamera


Zeit_upload=$(TZ=":Europe/Berlin" date)
echo $Zeit_upload "Dropbox Upload ausgeführt." >> /home/pi/upload/log/kameraupload.log

#__________________________________
