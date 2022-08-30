# reQUAD
![](PCB/reQUAD_top.jpg)
![](PCB/reQUAD_bottom.jpg)
![](PCB/reQUAD.svg)

## About
This is a derivative of [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD) by Steve Adolph.

## Differences from the original
Removed the resistor-cap power-on-reset. The bank-selection logic is powered at all times by VMEM along with the ram.

New PCB design.

## Build it
PCB from [OSHPark](https://oshpark.com/shared_projects/kmJ52kFx) or [PCBWAY](https://www.pcbway.com/project/shareproject/reQUAD_RAM_Expansion_for_TRS_80_Model_100_8690cd19.html)  
[BOM](https://www.digikey.com/short/mt3jtw7q)

Note for PCBWAY: change "Min Track/Spacing:" to "6/6mil"  
When you order from PCBWAY the site preloads several settings and options automatically based on examining the gerbers.  
For this pcb for some reason it selects "Min Track/Spacing: 4/4mil", which makes the initial price over $50 before shipping.  
There are actually no traces or spaces under 6 mils on the board, so just manually change "Min Track/Spacing:" to "6/6mil" and the price drops to $5

## Usage
Use the software & directions for the original [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD)

Note, this version of the device will select an unpredictable random bank on the first power-on after installing.  
Don't assume you are in bank #0 until after you use either the simple bank-switch program or 0QUAD to explicitly switch to a bank the first time.

## Thanks
Steve Adolph for sharing his original design and allowing this derivative.
