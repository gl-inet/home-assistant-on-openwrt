It is a shell script aiming to install HomeAssistant(https://github.com/home-assistant/home-assistant) on an OpwenWRT(https://github.com/openwrt/openwrt) OS.  

Before installation, make sure that your device has at least 400+ MB Flash and 150+ MB RAM left. Then use command `./install.sh` to start the installation. 
After installation finished, use command `hass` to start the HomeAssistant. Note that the first start will download and install some dependent python module.
It may take 20~30 minutes. Network connection problem will cause start failure. While don't worry, retry `hass` usually works.

