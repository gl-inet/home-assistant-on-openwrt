# Script to install HomeAssistant on OpenWRT
HomeAssistant is an open source home automation platform. It is able to track and control thousands of smart devices and offer a platform for automating control. Details on https://github.com/home-assistant/home-assistant.  
HA supports only Windows, Linux, Mac and Raspberry offically. While this project is to install the HomeAssistant on an OpenWRT OS. So that you can run a HomeAssistant on a router without having to run a 24-hours PC or Raspberry.  

## Hardware Requirements
Completely installation for HomeAssistant will take nearly 350 MB Flash and 130 MB RAM. More components require more storage.  
Recommend device is GL-S1300. It has a 8G emmc, 512 MB RAM and a Quad-core CPU. It is enough for running HA and its routing function is also completely unaffected.  
## Software Requirements
Firmware version 3.023 for GL-S1300 or above.

## Easiest installation
We recommend strongly that using our gl-homeassistant.ipk to install the HA. It provides an One-click installation script and has add HA into the system boot program.  
You can install the gl-homeassistant easily through the Web. Just search "gl-homeassistant" in the "plug-ins" and clik "install".  
Or you can manually install it in the SSH terminal typing this:  
```
opkg update
opkg install gl-homeassistant
```
After finished installing gl-homeassistant. You can using command in the SSH terminal to start the installation of HomeAssistant
```
hass-install
```
Wait for the installation finished. Usually it takes 20~30 minutes.
## Manually install
If you didn't install gl-homeassistant. There is no command named "hass-install". You have to clone this project and excute it manually.
### Clone this project
Open the OpenWRT interface through SSH. Using putty or xshell or some other tools.  
And then get into the root path and clone this project.
```
cd /root/
git clone https://github.com/gl-inet/home-assistant-on-openwrt.git
```
Note that maybe you'd install the git, use command like this
```
opkg install git git-http
```
### Start installation
Get into the project folder and start the installation. Make sure your device has connected to the Internet.
```
cd home-assistant-on-openwrt
./install.sh 
```
It will take 20~30 minutes. After finished, it will print "HomeAssistant installation finished. Use command "hass -c /data/.homeassistant" to start the HA."
## Start HomeAssistant firstly
After installation finished, use command `hass -c /data/.homeassistant` to start.  
Note that firstly start will download and install some python modules. Make sure the network is connected while first starting. It will take about 20 minutes. If it stuck or print some error messages, don't worry, interupt it and retry `hass -c /data/.homeassistant` usually works.  
It has fully started when print messages like:
```
Starting Home Assistant
Timer:starting
```
## Experience HomeAssistant
Connet to the S1300 through lan ports or wifi using your PC or Phone. Visit the address `192.168.8.1:8123` , that's the web page for HomeAssistant.  
Now you can link your smart devices together with HA.  
Questions and discussion about HA on https://community.home-assistant.io/


