#!/bin/sh
echo "Installing"
apt update
apt upgrade

#get display working
echo "Installing display drivers"
apt install -y device-tree-compiler

cat <<EOT > ili9488-overlay.dts
/dts-v1/;
/plugin/;

#include <dt-bindings/gpio/gpio.h>

/ {
    compatible = "allwinner,sun50i-h616";

    fragment@0 {
        target = <&spi1>;
        __overlay__ {
            #address-cells = <1>;
            #size-cells = <0>;
            status = "okay";

            ili9488@0 {
                compatible = "ilitek,ili9488";
                reg = <0>;
                spi-max-frequency = <32000000>;
                rotate = <90>;
                bgr;
                dc-gpios = <&pio 3 0 GPIO_ACTIVE_HIGH>;
                reset-gpios = <&pio 3 3 GPIO_ACTIVE_HIGH>;
                led-gpios = <&pio 0 6 GPIO_ACTIVE_HIGH>;
            };
        };
    };
};
EOT

dtc -@ -I dts -O dtb -o ili9488-overlay.dtbo ili9488-overlay.dts
mv ili9488-overlay.dtbo /boot/overlays/

# Configure the bootloader
echo "Configuring the bootloader..."
echo "overlays=spi-spidev ili9488" | tee -a /boot/armbianEnv.txt
echo "param_spidev_spi_bus=1" | tee -a /boot/armbianEnv.txt


SERVICE_CONTENT="[Unit]
Description=My Python GUI
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/bin/python3 /home/$(whoami)/main/main.py
User=$(whoami)

[Install]
WantedBy=multi-user.target"

echo "$SERVICE_CONTENT" | tee /etc/systemd/system/my_gui.service > /dev/null

systemctl enable my_gui.service
systemctl start my_gui.service

echo "Setup complete. Please reboot your device."

#remove desktop envi
echo "removing desktop enviroment"


#get python up and working
echo "Installing python"
apt install -y python3 python3-pip
pip3 install PyQt5


# Open up SSH on port 2220
echo "Installing OpenSSH"
apt install openssh-server -y
sed -i 's/#Port 22/Port 2220/' /etc/ssh/sshd_config
systemctl restart sshd
