# reQUAD
![](../../raw/main/PCB/reQUAD_f.jpg)
![](../../raw/main/PCB/reQUAD_b.jpg)
![](../../raw/main/PCB/reQUAD_top.jpg)
![](../../raw/main/PCB/reQUAD_bottom.jpg)
![](../../raw/main/PCB/reQUAD.svg)

## About
This is a derivative of [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD) by Steve Adolph.

## Differences from the original
Removed the resistor-cap power-on-reset circuit and resettable flip-flop that tried to ensure that the unit always resets to bank 1.

Instead, the bank-selection flip-flop is a non-resettable type and is kept powered at all times along with the SRAM.  
\[ 2022-10-13: This didn't work as expected. The unit functions well, but seems to always reset to bank 1 at power-on, where it was expected maintain the bank-selection state while on standby. At power-on, you should be in the same bank you were in at power-off. Always resetting to bank 1 would be fine as long as it's certain. That is exactly what the original power-on-reset circuit tried to explicitly ensure. But it is unknown if this can be counted on to happen every time. Perhaps the flip-flop doesn't need to be maintained after all, or perhaps all of the extra logic needs to stay powered instead of just the flip-flop. The unit appears to function correctly otherwise.  \]

New PCB design.

## To Build it
PCB [PCBWAY](https://www.pcbway.com/project/shareproject/reQUAD_RAM_Expansion_for_TRS_80_Model_100_8690cd19.html)  
BOM [DigiKey](https://www.digikey.com/short/vjmw4r5c)

## To Use it
At it's most BASIC (pun intended), switch banks by typing ```OUT 128,n``` in BASIC, where n is the desired bank number from 0 to 3, and then press the reset button on the back of the machine, but do NOT power-cycle.

```OUT 128,0``` switches to bank 1  
```OUT 128,1``` switches to bank 2  
```OUT 128,2``` switches to bank 3  
```OUT 128,3``` switches to bank 4  

Then press the reset button on the back of the machine, or you may do a full cold-reset (ctrl-break-reset) if you want to wipe the current bank.  
Don't power-cycle, as that will switch you back to bank 1, or possibly a random bank.

The OUT command only performs the hardware/electrical switch, and the reset button restarts the main rom in the new ram environment.  
You should always press the reset button immediately after the OUT command, even if the OUT command didn't appear to have any effect or appear to cause any errors, because the system is in an inconsisntent insane state after the hardware switch until the main rom is restarted.  

Because of this, this low level method should only be used as part of the one-time initial setup or as a last resort or other special cases.  

For normal usage, see the directions and software for the original [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD).  

You should use either the simple bank-switch program (BANK.DO) or 0QUAD (QUAD.BA) for normal operation.  

Copies of QUAD.BA and BANK.DO are included in the APP directory in this repo.

## Thanks
Steve Adolph for sharing his original design and allowing this derivative.
