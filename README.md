# node-nfc-poll
exec's 'nfc-list' in a loop and reports back nfc tag names

### Hardware

 * PN532 Breakout Board
 * Raspberry Pi 2
 * Hook up wires


1. hooked up via FTDI
2. libnfc
3. [This Tutorial](https://learn.adafruit.com/adafruit-nfc-rfid-on-raspberry-pi/overview) https://learn.adafruit.com/adafruit-nfc-rfid-on-raspberry-pi/overview


## Install ZeroRPC/Node

This is a Raspberry Pi 2 B w/ Raspbian project.

1. [Install NodeJS with NVM!](https://github.com/creationix/nvm)

```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
```

1. [Don't Forget!](http://askubuntu.com/questions/365074/cannot-install-zeromq-package-from-chris-lea-zeromq-in-12-04/388770#388770) http://askubuntu.com/questions/365074/cannot-install-zeromq-package-from-chris-lea-zeromq-in-12-04/388770#388770Mar

```
sudo add-apt-repository ppa:chris-lea/zeromq
sudo apt-get update
sudo apt-get install libzmq3-dbg libzmq3-dev libzmq3
npm install zerorpc
```

# Install Coffee Script

1. Coffee Script: `npm i -g coffee-script`


# Start the Project

1. Start LCD Server: `sudo python lcd.py` (@todo python deps...)
1. `sudo` for raspi-gpio: `sudo -i` (-i lets us use NVM Node!)
1. Start Node: `coffee index.coffee`

# Wiring Diagram

Sorry folks, check out the tutorial link above
