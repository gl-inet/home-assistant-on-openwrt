#!/bin/sh

#Compare the first version and the second version. If the first lower than the second return 0 , or return 1
CompareVersion() {
    fversion_1=`echo $1 | awk -F '.' '{print $1}'`
    fversion_2=`echo $1 | awk -F '.' '{print $2}'`
    fversion_3=`echo $1 | awk -F '.' '{print $3}'`
    sversion_1=`echo $2 | awk -F '.' '{print $1}'`
    sversion_2=`echo $2 | awk -F '.' '{print $2}'`
    sversion_3=`echo $2 | awk -F '.' '{print $3}'`


    if [ $fversion_1 -lt $sversion_1 ]; then
        return 0
    elif [ $fversion_1 -gt $sversion_1 ]; then
        return 1
    fi

    if [ $fversion_2 -lt $sversion_2 ]; then
        return 0
    elif [ $fversion_2 -gt $sversion_2 ]; then
        return 1
    fi

    if [ $fversion_3 -lt $sversion_3 ]; then
        return 0
    elif [ $fversion_3 -gt $sversion_3 ]; then
        return 1
    fi

    return 0
}

#Get into the installation path /root/
cd /root/
currentpath=`pwd`
if [ "$currentpath" != "/root" ]; then
    echo -e "\033[31m ERROR! Cannot get into installation path, exit. \033[0m"
    exit 0
fi

#Update the opkg package info
try=0
while true
do
    try=$((try+1))
    if [ $try -le 5 ]; then
        echo -e "\033[33m opkg update...... try $try. \033[0m"
        opkg update
        if [ $? -ne 0 ]; then
            continue
        else
            break
        fi
    else
        echo -e "\033[31m ERROR! opkg update failed, check the network connection, exit. \033[0m"
        exit 0
    fi
done

#Install python3.6
try=0
while true
do
    try=$((try+1))
    if [ $try -le 5 ]; then
        echo -e "\033[33m Installing python3.6...... try $try. \033[0m"
        opkg install python3
        if [ $? -ne 0 ]; then
            continue
        else
            break
        fi
    else
        echo -e "\033[31m ERROR! Install python3.6 failed, check the network connection, exit. \033[0m"
        exit 0
    fi
done


#Download and install latest pip for python3
pipreq=0
command -v pip > /dev/null 2>&1
if [ $? -eq 0 ]; then
    CompareVersion 19.1.1 `pip --version | awk '{print $2}'`
    if [ $? -eq 0 ]; then
    pipreq=1
    fi
fi

if [ $pipreq -ne 1 ]; then
    try=0
    while true
    do
        try=$((try+1))
        if [ $try -le 5 ]; then
            echo -e "\033[33m Download and install pip...... try $try. \033[0m"
            curl https://bootstrap.pypa.io/get-pip.py > get-pip.py && python3 get-pip.py
            if [ $? -ne 0 ]; then
                rm ./get-pip.py
                continue
            else
                break
            fi
        else
            echo -e "\033[31m ERROR! Install pip failed,  exit. \033[0m"
            exit 0
        fi
    done
    rm ./get-pip.py
fi

#Set pip install configuration to no-cache-dir
pip3 config set install.no-cache-dir on

#Install gcc
try=0
while true
do
    try=$((try+1))
    if [ $try -le 5 ]; then
        echo -e "\033[33m Download and install gcc...... try $try. \033[0m"
        opkg install gcc
        if [ $? -ne 0 ]; then
            continue
        else
            break
        fi
    else
        echo -e "\033[31m ERROR! Install gcc failed,  exit. \033[0m"
        exit 0
    fi
done

#Install dependent C library
opkg install python3-dev
if [ $? -ne 0 ]; then
    echo -e "\033[31m ERROR! Install python-dev failed, exit. \033[0m"
    exit 0
fi
echo -e "\033[32m Install C library......libffi \033[0m"
mkdir -p /usr/include/ffi && \
cp ./home-assistant-on-openwrt/ffi* /usr/include/ffi && \
ln -s /usr/lib/libffi.so.6.0.1 /usr/lib/libffi.so
echo -e "\033[32m Install C library......libopenssl \033[0m"
cp -r ./home-assistant-on-openwrt/openssl /usr/include/python3.6/ && \
ln -s /usr/lib/libcrypto.so.1.0.0 /usr/lib/libcrypto.so && \
ln -s /usr/lib/libssl.so.1.0.0 /usr/lib/libssl.so
echo -e "\033[32m Install C library......libsodium \033[0m"
opkg install libsodium
if [ $? -ne 0 ]; then
    echo -e "\033[31m ERROR! Install libsodium failed,  exit. \033[0m"
    exit 0
fi
cp ./home-assistant-on-openwrt/sodium.h /usr/include/python3.6/ && \
cp -r ./home-assistant-on-openwrt/sodium /usr/include/python3.6/ && \
ln -s /usr/lib/libsodium.so.23.1.0 /usr/lib/libsodium.so

#Install dependent python module
try=0
while true
do
    try=$((try+1))
    if [ $try -le 5 ]; then
        echo -e "\033[33m Install python module: PyNaCl...... try $try. \033[0m"
        SODIUM_INSTALL=system pip3 install pynacl
        if [ $? -ne 0 ]; then
            continue
        else
            break
        fi
    else
        echo -e "\033[31m ERROR! Install PyNacl failed,  exit. \033[0m"
        exit 0
    fi
done

try=0
while true
do
    try=$((try+1))
    if [ $try -le 5 ]; then
        echo -e "\033[33m Download python module: cryptography...... try $try. \033[0m"
        curl https://files.pythonhosted.org/packages/c2/95/f43d02315f4ec074219c6e3124a87eba1d2d12196c2767fadfdc07a83884/cryptography-2.7.tar.gz > cryptography-2.7.tar.gz
        if [ $? -ne 0 ]; then
            rm ./cryptography-2.7.tar.gz            
            continue
        else
            break
        fi
    else
        echo -e "\033[31m ERROR! Download cryptography failed, exit. \033[0m"
        exit 0
    fi
done
echo -e "\033[32m Install python module: cryptography...... \033[0m"
tar -xzvf cryptography-2.7.tar.gz && \
cd ./cryptography-2.7 && \
LDFLAGS=-pthread python3 setup.py install && \
cd ../
if [ $? -ne 0 ]; then
    echo -e "\033[31m ERROR! Install cryptography failed,  exit. \033[0m"
    exit 0
fi
rm -rf ./cryptography-2.7*

#Install Home Assistant
try=0
while true
do
    try=$((try+1))
    if [ $try -le 5 ]; then
        echo -e "\033[33m Install HomeAssistant...... try $try. \033[0m"
        python3 -m pip install homeassistant
        if [ $? -ne 0 ]; then
            continue
        else
            break
        fi
    else
        echo -e "\033[33m Install HomeAssistant failed, exit. \033[0m"
        exit 0
    fi
done
#Config the homeassistant
mkdir -p /data/.homeassistant
cp ./home-assistant-on-openwrt/configuration/* /data/.homeassistant/
#Install finished
echo -e "\033[32m HomeAssistant installation finished. Use command \"hass -c /data/.homeassistant\" to start it. \033[0m"
echo -e "\033[32m Note that the firstly start will take 20~30 minutes. If failed, retry it. \033[0m"
