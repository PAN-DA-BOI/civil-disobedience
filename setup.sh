#!/bin/sh

echo "Installing and updating packages..."
sudo apt update
sudo apt upgrade -y

echo "Installing display drivers..."
sudo apt install -y device-tree-compiler

# Create and compile the Device Tree Overlay for ILI9488
echo "Creating and compiling Device Tree Overlay for ILI9488..."
cat <<EOT | sudo tee ili9488-overlay.dts > /dev/null
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

sudo dtc -@ -I dts -O dtb -o ili9488-overlay.dtbo ili9488-overlay.dts
sudo mv ili9488-overlay.dtbo /boot/overlays/

# Configure the bootloader
echo "Configuring the bootloader..."
echo "overlays=spi-spidev ili9488" | sudo tee -a /boot/armbianEnv.txt
echo "param_spidev_spi_bus=1" | sudo tee -a /boot/armbianEnv.txt

# Create a systemd service to run the Python script on boot
echo "Creating a systemd service to run the Python script on boot..."
SERVICE_CONTENT="[Unit]
Description=My Python GUI
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/bin/python3 /home/$(whoami)/main/main.py
User=$(whoami)

[Install]
WantedBy=multi-user.target"

echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/my_gui.service > /dev/null

sudo systemctl enable my_gui.service
sudo systemctl start my_gui.service

# Install Python and necessary libraries
echo "Installing Python and necessary libraries..."
sudo apt install -y python3 python3-pip
sudo apt install python3-pyqt5
sudo pip3 install --upgrade OPi.GPIO

# Open up SSH on port 2220
echo "Installing and configuring OpenSSH..."
sudo apt install -y openssh-server
sudo sed -i 's/#Port 22/Port 2220/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Remove desktop environment
echo "Removing desktop environment..."
sudo mv ./xinitrc /etc/X11/xinit/

echo "Setup complete. Please reboot your device."
