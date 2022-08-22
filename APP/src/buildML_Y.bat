@echo off
rem edit lower two lines to identify library and tasm paths
rem this file should be in same directory as the assembly

set DIR= Y:
set TASMTABS=Y:\tasm32
set ver=01

echo Creating QUADML.bin...
@echo off

%DIR%\tasm32\tasm -85 -lal -b -f00 QUADML.asm QUADML.bin

pause


