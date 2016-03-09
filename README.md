# node-nfc-poll
exec's 'nfc-list' in a loop and reports back nfc tag names

### Hardware

 * PN532 Breakout Board
 * Raspberry Pi 2
 * Hook up wires


1. hooked up via FTDI
2. libnfc
3. [This Tutorial] https://learn.adafruit.com/adafruit-nfc-rfid-on-raspberry-pi/overview


## Install ZeroRPC

(On a Raspberry Pi 2 B w/ Raspbian)

[Don't Forget!][http://askubuntu.com/questions/365074/cannot-install-zeromq-package-from-chris-lea-zeromq-in-12-04/388770#388770]

```
sudo add-apt-repository ppa:chris-lea/zeromq
sudo apt-get update
sudo apt-get install libzmq3-dbg libzmq3-dev libzmq3
npm install zerorpc
```
