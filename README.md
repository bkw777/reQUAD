# reQUAD
![](PCB/reQUAD_top.jpg)
![](PCB/reQUAD_bottom.jpg)
![](PCB/reQUAD.svg)

## About
This is a derivative of [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD) by Steve Adolph.

## Differences from the original
The original design uses a set/reset flipflop with a capacitor-resistor-diode power-on-reset circuit, which Steve says doesn't always reset properly.

This design uses a non-reset flipflop, no power-on-reset resistor-cap circuit, and is instead simply powered at all times along with the ram.

Aside from that, this PCB is drawn new from scratch, and the components are different versions & packages.

## Building
PCB from [OSHPark](https://oshpark.com/shared_projects/KVu4cEJX) or [PCBWAY](https://www.pcbway.com/project/shareproject/reQUAD_RAM_Expansion_for_TRS_80_Model_100_8690cd19.html)  
[BOM](https://www.digikey.com/short/m5tj4941)

The component legs are all tiny, but all parts can be soldered manually using the drag technique.

To solder the main PCB DIP legs, put some tacky flux on all the holes and insert all the pins,  
then put the the whole thing into a breadboard or a socket,  
then solder two opposite corner pins from the top, then all the rest.

## Using
Use the software & directions for the original [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD)

## Thanks
Many thanks to Steve Adolph for sharing his original design and allowing this derivative.