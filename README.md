# reQUAD

![](../../raw/main/reQUAD.jpg)
![](../../raw/main/PCB/out/reQUAD.f.jpg)
![](../../raw/main/PCB/out/reQUAD.b.jpg)
![](../../raw/main/PCB/out/reQUAD.top.jpg)
![](../../raw/main/PCB/out/reQUAD.bottom.jpg)
![](../../raw/main/PCB/out/reQUAD.svg)

## About
This is a derivative of [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD) by Steve Adolph.

## Differences from the original
Removed the resistor-cap power-on-reset circuit and resettable flip-flop for a simple flip-flop.  
Added battery and battery-change cap.  
Added pulldown on the sram CE2.

## To Build it
PCB [PCBWAY](https://www.pcbway.com/project/shareproject/reQUAD_RAM_Expansion_for_TRS_80_Model_100_8690cd19.html)  
BOM [DigiKey](https://www.digikey.com/short/z47bn0mw)

Build notes,  
The pin 1 mark on DA1, BAV756S, is tiny and faint, but there is one, you just need a lot of magnification and light. The markings look like `.A7t` and the . is at pin 1. The pinout is not symmetric, and so the part must be installed in the correct orientation.

## To Use it

### Manual Control
Switch banks by typing `OUT 128,n` in BASIC, where n is the desired bank number from 0 to 3,  

`OUT 128,0` switches to bank 1  
`OUT 128,1` switches to bank 2  
`OUT 128,2` switches to bank 3  
`OUT 128,3` switches to bank 4  

And then immediately press the reset button on the back of the machine.

### Software Control
Install [0QUAD](APP/)

Refer to the docs for the original [QUAD](http://bitchin100.com/wiki/index.php?title=QUAD)

### Example Installing 0QUAD using dl2 and teeny
(this will wipe all data)

On the pc, install [dl2](github.com/bkw777/dl2)

On the 100. in BASIC: `OUT 128,0`  
Then do a cold reset: CTRL+BREAK+RESET

On the pc:
```
$ cd APP
$ dl -v -b TEENY.100 && dl -v -u
```

On the 100, in BASIC: `RUN "COM:98N1ENN"`  
Press ENTER at the end of the TEENY install to accept the default install location.  
`CLEAR 0,62213`  
Press F8 to exit to the main menu and run TEENY.CO  
Use TEENY to copy QUAD.BA from the pc  
```
> L QUAD  .BA
> Q
```
Run QUAD.BA  
Answer "1" to the "Which bank?" question.  

0QUAD is now installed in bank 1, but is invisible.

Type `0QUAD` at the main menu (not in BASIC) to run 0QUAD

Now the top-right corner will show "#1" to show that you are currently in bank 1.  
Press F1 to pull up the bank-switch menu, then press F2 to switch to bank 2.

You are now in bank 2 which is a new bank of new blank ram.

Install 0QUAD in bank 2 by repeating everything after the OUT command above.  
This includes do the CTRL+BREAK+RESET to ensure all the ram in this bank starts out clear instead of random before you start using it.  
Answer "2" at the "Which bank?" question.  
Repeat again for banks 3 and 4.

Once 0QUAD is installed in all banks, you can use it to switch from any bank to any other bank, and you don't need to press the reset button after each switch when using 0QUAD to switch.

## Thanks
Thanks to Steve Adolph for sharing his original design and allowing this derivative.
