### How to set up Minicom (Linux Serial app) ###

_This is primarily intended for communicating between your pc and the linksys headnode router, for the purpose of configuring and flashing it_

  * Download minicom
```
sudo apt-get install minicom
```
  * Open up a terminal window
  * Type "sudo minicom -s" _(minicom -s is for setting up minicom)_
    * The sudo here is important - since we need administrative rights to set the default settings for the minicom

Now connect your serial (or usb --> serial) connection

  * Open a new terminal window
  * Type "dmesg | grep tty" _(this command lists the devices)_
  * Check for a ttyUSB0 listing - in windows, serial ports are named com1, com4 etc. in linux they're named _tty_, and _ttyUSB_ for serial devices connected via USB.

  * Now go back to the minicom
  * Select "serial port setup"
  * Change option A (device) to "/dev/ttyUSB0" (case sensitive!)
  * And make sure that both hardware & software flow control are set to "NO"
  * Go back to main menu and select "save as dfl" (saves as default setting)
  * Select "exit" - and minicom should now launch and you should see output from your device