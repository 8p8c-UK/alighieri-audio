#!/bin/bash
# Alighieri setup script (powered by INDUSTRIAL)

CHOICE=$(whiptail --title "Alighieri Audio Setup" --menu "Choose an option:" 20 78 10 \
    "1" "Install Alighieri Core (PipeWire AES67/RAVENNA)" \
    "2" "Setup PTP Grandmaster (XG210 Router)" \
    "3" "Configure Audio VLAN (192.168.2.x)" \
    "4" "Setup Wi-Fi Mesh Control (192.168.1.x)" \
    "5" "Install MQTT Control Plane" \
    "6" "Configure UMC1820/UMC202 Interfaces" \
    "7" "Enable Bluetooth PAN (Tablet Control)" \
    "8" "Test Full System" \
    "9" "Enable Pro Features (Subscription)" \
    "10" "Exit" 3>&1 1>&2 2>&3)

case $CHOICE in
    1) whiptail --msgbox "Installing PipeWire and AES67/RAVENNA..." 8 60
       sudo apt update
       sudo apt install -y pipewire pipewire-bin wireplumber linuxptp avahi-daemon
       cp configs/pipewire-aes67.conf ~/.config/pipewire/
       systemctl --user restart pipewire pipewire-pulse wireplumber
       ;;
    2) whiptail --msgbox "Setting up PTP Grandmaster on eth1.2..." 8 60
       sudo ptp4l -i eth1.2 -m
       ;;
    3) whiptail --msgbox "Configuring audio VLAN (192.168.2.x)..." 8 60
       sudo nmcli con add type vlan ifname eth1.2 id 2 ipv4.method manual ipv4.addresses 192.168.2.1/24
       ;;
    4) whiptail --msgbox "Setting up Wi-Fi mesh control..." 8 60
       sudo nmcli con add type wifi ifname wlan0 con-name mesh-control wifi.mode mesh wifi.ssid alighieri-mesh wifi.security wpa-psk wifi.psk "securepassword" wifi.channel 6 ipv4.addresses 192.168.1.11/24
       ;;
    5) whiptail --msgbox "Installing MQTT control plane..." 8 60
       sudo apt install -y mosquitto mosquitto-clients
       cp scripts/control.sh /usr/local/bin/alighieri-control.sh
       ;;
    6) whiptail --msgbox "Configuring UMC1820/UMC202..." 8 60
       arecord -l
       ;;
    7) whiptail --msgbox "Enabling Bluetooth PAN..." 8 60
       sudo apt install -y bluez bluez-tools
       sudo bt-adapter --set Discoverable 1
       sudo bt-network -c nap eth0
       ;;
    8) whiptail --msgbox "Testing system..." 8 60
       speaker-test -D hw:1,0 -c 2 -r 48000
       ;;
    9) if [ -f /etc/alighieri/pro.key ]; then
           whiptail --msgbox "Pro Features: GUI, Updates, Support" 8 60
           sudo apt install -y nginx nodejs npm
           cp -r web/* /var/www/alighieri/
       else
           whiptail --msgbox "Pro features require subscription: alighieri.audio/pro" 8 60
       fi
       ;;
    10) exit 0 ;;
esac
