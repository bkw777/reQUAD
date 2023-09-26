# reQUAD
![](../../raw/main/PCB/out/reQUAD.f.jpg)
![](../../raw/main/PCB/out/reQUAD.b.jpg)
![](../../raw/main/PCB/out/reQUAD.top.jpg)
![](../../raw/main/PCB/out/reQUAD.bottom.jpg)
![](../../raw/main/PCB/out/reQUAD.svg)

## About
This is a derivative of [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD) by Steve Adolph.

## Differences from the original
Removed the resistor-cap power-on-reset circuit and resettable flip-flop for a simpler flip-flop.

Added pulldown on /CE

Added battery and battery-change cap.

## To Build it
PCB [PCBWAY](https://www.pcbway.com/project/shareproject/reQUAD_RAM_Expansion_for_TRS_80_Model_100_8690cd19.html)  
BOM [DigiKey](https://www.digikey.com/short/bmtwb9m8)

## To Use it

### low level / manual  
Switch banks by typing `OUT 128,n` in BASIC, where n is the desired bank number from 0 to 3,  

`OUT 128,0` switches to bank 1  
`OUT 128,1` switches to bank 2  
`OUT 128,2` switches to bank 3  
`OUT 128,3` switches to bank 4  

and then immediately press the reset button on the back of the machine, but do NOT power-cycle.  

### normal / convenient
Install `0QUAD`.

Refer to the docs for the original [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD)

## Thanks
Steve Adolph for sharing his original design and allowing this derivative.
