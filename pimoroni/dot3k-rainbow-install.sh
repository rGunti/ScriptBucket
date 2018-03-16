#!/bin/bash

# Install Packages
apt update
apt install -y \
    git \
    python-spidev python3-spidev \
    python-smbus python3-smbus \
    python-sn3218 python3-sn3218 \
    python-st7036 python3-st7036 \
    python-psutil \
    python-rainbowhat python3-rainbowhat

# Clone and CD into it
git clone https://github.com/pimoroni/displayotron.git /tmp/dot3k
cd /tmp/dot3k/library

# Install (Py2 & Py3)
python ./setup.py install
python3 ./setup.py install
