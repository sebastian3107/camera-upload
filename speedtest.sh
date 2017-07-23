#!/bin/bash
 
date >> /home/pi/upload/log/speedtest.log
/usr/local/bin/speedtest --simple >> /home/pi/upload/log/speedtest.log
echo "" >> /home/pi/upload/log/speedtest.log
