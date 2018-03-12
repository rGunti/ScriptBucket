#!/bin/bash

# Clone and CD into it
git clone https://github.com/pimoroni/displayotron.git /tmp/dot3k
cd /tmp/dot3k/library

# Install (Py2 & Py3)
python ./setup.py install
python3 ./setup.py install
