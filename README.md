# reQUAD
![](PCB/reQUAD_top.jpg)
![](PCB/reQUAD_bottom.jpg)
![](PCB/reQUAD.svg)

## About
This is a derivative of [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD) by Steve Adolph.

## Differences from the original
Original has resettable flipflop, powered from vcc (loses power), with resistor-cap power-on-reset  
This has plain flipflop, powered from vmem (always powered), no resistor-cap power-on-reset

Original disables internal ram by holding RAMRST high, which disables /OE on the internal ram
This disables internal ram by holding (A)* low, which disables CE on the internal ram (Steve's idea)

Aside from that, this PCB is drawn new from scratch, and the components are different versions & packages.

## Building
<!-- PCB from [OSHPark](https://oshpark.com/shared_projects/EzqwlTVX) or [PCBWAY](https://www.pcbway.com/project/shareproject/reQUAD_RAM_Expansion_for_TRS_80_Model_100_8690cd19.html)   -->
[BOM](https://www.digikey.com/short/m5tj4941) (temporary bom link, need to add a 0805 resistor, value TBD, probably very low, may even replace with a trace)

## Usage
Use the software & directions for the original [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD)

## Thanks
Many thanks to Steve Adolph for sharing his original design and allowing this derivative.
