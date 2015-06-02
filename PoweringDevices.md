

# Overview #

All currently supported devices will run on 12v DC power.  This page is dedicated to the various ways we get that power to the devices.

# Device Specifics #

There are two classes of devices we use: ["Power over Ethernet" (PoE)](http://en.wikipedia.org/wiki/Power_over_Ethernet), and Non-POE.  As follows:

## PoE Devices ##

Most of the devices we use in the current version of fabfi use PoE.  All the Ubiquiti devices we use fit into this category.  ubiquiti devices use a particular type of PoE called ["passive" PoE](http://en.wikipedia.org/wiki/Power_over_Ethernet#Passive).  Passive PoE supplies positive voltage (12-15V) on pins 4-5 of the ethernet cable, completing the circuit over pins 7-8 ([see here for cat5 pinout](http://en.wikipedia.org/wiki/Category_5_cable)).  Out of the box, these devices are powered by a PoE injector that runs on AC power and provides 15V DC.  This injector is placed inline on the ethernet cable like so:

![http://fabfi.googlecode.com/svn/wiki/images/Devices/StockPOE.png](http://fabfi.googlecode.com/svn/wiki/images/Devices/StockPOE.png)

It is also possible to inject power via a number of other means by modifying the cat5 cable as shown here:

http://fabfi.googlecode.com/svn/wiki/images/Devices/POEHack.JPG

power mods are discussed in more detail below.

## Non-PoE Devices ##

Both the linksys wrt160nl and the switches we use are powered directly by 12V AC-DC power adaptors.  For these devices, the center pin on the plug is generally positive.

**Importantly, the linksys devices and many commodity switches DO NOT support PoE** in particular, the switchports on the linksys are wires such that plugging a PoE cable into the switch will short-circuit the cable.

When using PoE devices with the linksys or a non-PoE switch, it is important to make sure the end that connects to the switch is NOT powered.  For the supplied PoE injectors, this means that the LAN end goes to the linksys or switch.  For modified cables, this means that leads 4-5 and 7-8 be removed from the end connected to the linksys or switch.

For a device you're not sure about, check the resistance between all four possible combinations of power and ground lines with a multimeter.  If you don't get a very very large resistance value, you can be sure that PoE will not work with the device.

## Power Requirements ##

The values in the following section were tested empirically using a benchtop power supply.  Power is calculated for tx/rx operation and idle operation.  When sizing panels for systems with significant idle time (such as systems with little activity at night), you can scale the power requirements like this:

```
    (Peak W)*(tx/rx fraction) + (Idle W)*(1 - tx/rx fraction)=requred power (W)
```

We haven't done any testing of duty cycle.  In our calculations we conservatively guess ...

### Device Tests ###

![http://fabfi.googlecode.com/svn/wiki/images/Devices/pwrtest.jpg](http://fabfi.googlecode.com/svn/wiki/images/Devices/pwrtest.jpg)

The following applies to all the tests below:
  * Operating Volatge = 12.0 Volts
  * Test resolution +/- .01A
  * Iperf tests are done with simultaneous send-receive between the laptop and the remote device in the photo above, passing through the middle device, which is under test.
  * changing radio output power had little effect on draw
  * For multi-port devices, each additional idle device adds .02A
  * For multiple port devices, all four switchports are assumed active (not internet port).  Active, but idle, ports had the same draw as transmitting ones in our tests.
  * Internet port on devices such as linksys is assumed empty.

#### UBIQUITI NANO M5 LOCO ####
```
    MODE: STA
    Idle: 0.27 A
    Peak: 0.43 A

    MODE: AP
    Idle: 0.28 A
    Peak: 0.43 A

    Idle Power: 3.4W
    Peak Power: 5.2W
```

#### UBIQUITI NANO M2 LOCO ####
```
    MODE: Client AP
    Idle: 0.22 A
    Peak: 0.39 A

    Idle Power: 2.7W
    Peak Power: 4.7W
```

#### UBIQUITI PICO M2 HP ####
```
    MODE: AP
    Idle: 0.24 A
    Peak: 0.41 A

    Idle Power: 2.9W
    Peak Power: 5.0W
```

#### LINKSYS WRT160NL ####
```
 
    MODE: AP+ADHOC
    Idle: 0.25 A
    Peak: 0.40 A


    Idle Power: 3.0W
    Peak Power: 5.0W
```

# Power Supplies #

Currently we use a variety of power solutions.  Major components include:

  * Sundaya Apple 5 charge controller
  * Jacobs 5A variable voltage DC power supply
  * Jacobs 7Ah Sealed gel batteries
  * Instek 650VA UPS
  * 15W Solar panels

## Solar Power ##

Solar power is a reliable and convenient way to power devices, however you must do a little calculation to make sure you choose the correct capacity for your area:

  1. Calculate the power requirements of your devices.  These are usually much LESS than what it says on the datasheets, as we measure [above](PoweringDevices#Power_Requirements.md)
  1. Multiply the total number of watts for your device by 24 (hours) to get watts/day.
  1. Divide this number by a safety factor to make sure you have enough power.  The safety factor is the fraction of the total panel power that you want your devices to require, We're using 80% (0.8)
  1. Find the hours of sunlight for your area [Solar radiation calculator](http://rredc.nrel.gov/solar/calculators/PVWATTS/version1/)
  1. Divide the number you got in 3 by the lowest kWh/m^2/day value from the resulting chart in 4 to get the required wattage of your panel.


# Batteries #

Beat the marketing hype and learn all about batteries with [this FAQ](http://www.windsun.com/Batteries/Battery_FAQ.htm).

## Sizing ##

The amount of battery you need is based on the amount of time you need to run without power (or sun).  Batteries are generally rated in Ah (amp\*hours), which is the number of hours the battery can supply a 1 Amp load at it's specified voltage (usually 12V).

To size a battery system you calculate the following
```
 power required (W) *  battery runtime (h) / battery safety factor / battery voltage (V) = required capacity (Ah) 
```

The battery safety is equal to the fraction of the battery's capacity that you want to consume (it should NEVER be more than 0.8).  We use 0.5.  We use 24 hours for battery runtime.