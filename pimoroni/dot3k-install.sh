#!/bin/bash

# Clone and CD into it
git clone https://github.com/pimoroni/displayotron.git /tmp/dot3k
cd /tmp/dot3k/library

# Install (Py2 & Py3)
sudo python ./setup.py install
sudo python3 ./setup.py install

# Cleanup
cd /tmp
sudo rm -rf /tmp/dot3k
