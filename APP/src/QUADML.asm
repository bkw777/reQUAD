; 0QUAD ML
; Feb 2015

;-----------------------------------------------------------------------
; variables, macros etc
;-----------------------------------------------------------------------
;#include	"../common/variables.asm"

offset:	.equ	08460h



;--------------------------------------------------------------------------
; QUADML program - compiled directly and appended to the .BA program
;--------------------------------------------------------------------------

; note - removing Line Feed control under F6
; - no need for PNOTAB functions
; note - removing TERM hook stuff

;-------------------------------------------------------
; compile this separately


		.org	08001h      
;--------------------------------------------------------------------------	
file1_nextline11:
	.dw	file1_nextline12 - file1_nextline11 + offset	; pointer to next line
	.db	0ah					; line number			
	.db	01h	
	
	.db	0b9h,"32793:Ver 1.00"
	
	.db	00	
;--------------------------------------------------------------------------	
file1_nextline12:
	.dw	file1_nextline13 - file1_nextline11 + offset	; pointer to next line
	.db	14h					; line number			
	.db	01h					


    

			LXI 	H, CHSNS_hook  
			SHLD    0FAE0H		; set up hook CHSNS
;			LXI 	H,termhook 	
;			SHLD    0FB0CH 		; set up hook TELCOM(TERM-F6)
;			LXI 	H, 08552H	     
;			SHLD    0FAE4H  	; set up hook PNOTAB 
			JMP     05797H   	; jump to menu start


; subroutine, called from CHSNS
CHSNS_hook: 		DI                        
			INX 	SP 
			INX 	SP 
			XTHL                      
			DCX 	SP 
			DCX 	SP  
			PUSH 	PSW                  
			MOV 	A,H 
			CPI     05DH 
			JNZ     exit_hook 
			MOV 	A,L 
			CPI     078H 
			JNZ     exit_hook
			POP 	H                    
			POP 	H                    
			POP 	H                    
			POP 	H                    
			EI                        
			JMP      screen_init       	; in MENU; modify display   


exit_hook: 		POP 	PSW               	; repair stack and exit when not in MENU    
			INX 	SP	
			INX 	SP  	
			XTHL                      
			DCX 	SP 	
			DCX 	SP   	
			EI                        
			RET                       


remote_command:					; b holds command number, routine updated for target bank
						; c is likely used to communicate return bank number in command 0
			DI 
			
			
target_bank_val:	mvi 	a, 01h		; corrected in command 0
			dcr	a		; can't have a zero in the code, so use 1-4		   
			OUT     080H           	; updated for my module
			                       
;			MOV 	A,B 
;			MOV 	A,C  	      
;			MOV 	A,D     	
;			MOV 	A,E   		; delay after bank switch
;			MOV 	A,H     	
;			MOV 	A,L      
;			MOV 	A,M  
			 
			SHLD    temp_hl_store  	; store value of hl in 8605, 8606
			XRA 	A             	
			MOV 	H,A  	       
	      		MOV 	L,A    	
			DAD 	SP    	
			SHLD    SP_STORE  	; store stack pointer at 860a, 860b 
			LXI 	h, 0FDFFH 	; point to ALTLCD 
			MOV 	A,B     	; test for command 0
			ANA 	A          	
			JZ      stack_ALTLCD    ; if b was zero, jump ahead
			LHLD    0F678H  	; else load hl with f678 top of available ram
stack_ALTLCD:		SPHL 
			LXI 	h, return_to_source_bank   	; return bank switch
			PUSH 	H                   
			PUSH 	D                ; temp store   
			LXI 	h, command_table  
			XRA 	A            	
			MOV 	D,A    	
			MOV 	E,B       	; de holds 00,b - b holds command number 	
			DAD 	D		; hl = hl + 2*DE
			DAD 	D		
			MOV 	E,M    		
			INX 	H	
			MOV 	D,M          	; load de with command address
			XCHG       	
			SHLD     cmd_addr+1  	; modify routine call based on parameter sent in B
			POP 	D 		; recover from stack
			LHLD     temp_hl_store 	
cmd_addr:
			JMP      cmd1          ;jump to the selected subroutine



command_table:  	.dw	cmd0        	;subroutine-- appears to set up the power up stack pointer      
			.dw	cmd1      	;subroutine --- looks like it clears out space for files     
			.dw	cmd2          	;subroutine  I'm guessing it creates a .do file entry
			.dw	cmd3   		;increment d and  hl, store c at hl
			.dw	cmd4      	;NEW statement??
			.dw	cmd5    	; make ba space
			.dw	cmd6    	; rename or name
			.dw	cmd7   		;subroutine-- I'm guessing it creates a basic file entry  
			.dw	cmd8      	; make space for CO
			.dw	cmd9   		;subroutine  I'm guessing it creates a .co file entry
			.dw	0ffFFh       
        

	.db	00	
;--------------------------------------------------------------------------	
file1_nextline13:
	.dw	file1_nextline14 - file1_nextline11 + offset	; pointer to next line
	.db	01eh					; line number			
	.db	001h					
            


;subroutine, seems to set up the display
screen_init:
			LXI 	h, 01B01H  
			CALL    0427CH 		;Set the current cursor position (H=Row,L=Col)
			MVI 	D, 0DH    
			CALL    print_d_at_hl  	; prints D spaces at screen location HL
			LXI 	h, 01E01H   
			CALL    0427CH  	
			CALL    sub052   	; decides if the number should be from file size (.CO, .BA,.DO) or free memory
			PUSH 	B                   
			POP 	H                    
			CALL   	039D4H    	; Print binary number in HL at current position
			LXI 	h, 02501H 
			LXI 	D, hashtag  
			CALL    printloop_D_HL    
			CALL    get_dir_entry_info          
			LXI 	h, 0108H
			LXI 	D, fnk_keys1  
			CPI     0B0H            
			JNZ     fnk_key_txt          
			LXI 	D, fnk_keys2

fnk_key_txt:		CALL    printloop_D_HL    
			CALL    get_key     
			MOV 	B,A        
			XRA 	A                     
			CMP 	B      		; key = 0?               
			JZ      process_fnkey  
			MOV 	A,B           
			CPI     00DH   		; key = enter?
			JZ      058F7H  	; Handle ENTER key from MENU command loop
			LXI 	B,  screen_init 	
			PUSH 	B                   
			CPI     021H   	
			RNC                       
			CPI     020H            
			JNZ      sub007  
			MVI 	A,   01CH   
sub007: 		PUSH 	PSW                  
			LDA     0FDEEH 
			MOV 	E,A          
			POP 	PSW                   
			SUI     01CH    
			JMP     058A9H    	; jump back into Handle backspace key from MENU command loop


;subroutine
process_fnkey:   	LXI 	h,  screen_init  
			PUSH 	H                   
			CALL     get_dir_entry_info          
			CPI      0B0H            
			LDA      0FF98H 
			LXI 	h,  07D33H  	; Boot routine, RST 0 or Reset vector target - initialization. 
			JZ       switch_to_bank          
			RRC        		; not on a built in ROM, so process fn keys differently	
			DI                        
			JC       bank_switch1        ; fnkey 1   Bnk1
			RRC               	    
			RRC         	
		 	EI                        
			RRC               	
			JC       copy_file   	 ; fnkey 4  Copy
			RRC                  
			JC       kill_file           ; fnkey 5 Kill
			RRC             
			JC       name_file         ; fnkey 6  Name
			RRC              	    
;			JC       Lfo_file   	  ; fnkey 7   Lfo?  -not needed
			RRC               
			JC       Exit           ; fnkey 8  Exit
			RET                       

			
;subroutine - waits for and gets a key
get_key:	   	CALL    013DBH    	; Check keyboard queue
			PUSH 	PSW                  
			CZ      05A15H   	; Print time ,day,date on first line w/o CLS
			POP 	PSW                   
			JZ      get_key      
			CALL    05D64H   	; Wait for char from keyboard & convert to uppercase
			RET                       

;subroutine
			RST 7			;??

return_to_source_bank:
			SHLD    temp_hl_store 
			LHLD    SP_STORE  
			SPHL                      
			LHLD    temp_hl_store 

return_bank_val:	mvi 	a, 01h		; corrected in command 0
			dcr	a		; can't have a zero in the code, so use 1-4		   
			OUT      080H           ; updated for my module
     
			EI                        
			RET                       

; subroutine  some kind of self modifying jump table based on accumulator contents
; presumably for 4 banks, one per entry
switch_to_bank:		DI
			xra	a
			mov	b,a                 
			RRC     	
			JC      bank_switch1          
			RRC          	
			JC      bank_switch2          
			RRC       	     
			JC      bank_switch3          	       
			RRC            
			JC      bank_switch4        	       
			EI                        
			RET                                       

	.db	00	
;--------------------------------------------------------------------------	
file1_nextline14:
	.dw	file1_nextline15 - file1_nextline11 + offset	; pointer to next line
	.db	028h					; line number			
	.db	001h					
            

;subroutines for bank switching
bank_switch4:		inr 	b		; a=3
bank_switch3:		inr 	b		; a=2
bank_switch2:		inr 	b		; a=1
bank_switch1:		mov	a,b		; a=0
			OUT     080H    
			PCHL                      

                     
; resets hooks
;sub015:
;			SHLD    0FB0CH 		; TELCOM(TERM-F6) 
;			SHLD   	0FB0CH  	; TELCOM(TERM-F6)  
;			SHLD   	0FAE4H 		; PNOTAB            
Exit_hooks:		SHLD    0FAE0H  	; CHSNS             
			JMP     05797H   	; MENU start



;subroutine - called before file sizes are calculated
;appears to offset the value loaded in HL by an amount determined by the contents of FDEE
;returns with a start address of selected file in the directory, which is in a table at FDA1
;returns with first byte of file's directory entry in A

get_dir_entry_info:	LDA     0FDEEH  	;memory location in alt LCD, stores the file selection on the screen 
			LXI 	h, 0FDA1H  	; holds some table that has directory entry      
			LXI 	D,  00102H 	; 258  , 11 bytes per file name  24 file names
			DCR 	D           	

sub018:			ORA 	A                     
			JZ      sub017          
			DAD 	D           
			DCR 	A         	
			JMP     sub018        ;  loop back as a is decremented from initial value in FDEE

;subroutine
sub017:   		CALL     05AE4H    	; Get start address of file at M, returns with address in HL
			MOV 	A,M           ;    load a with first byte of file
	 		RET                       


;subroutine used in copy -- traps the conditions for what cannot be copied
copy_trap:		CALL     get_dir_entry_info        ; this routine returns with the first byte of the indicated file  
			CPI      0B0H            
			JZ       beeperror  	; one pop and beep  
			CPI      0F0H            
			JZ       beeperror  	; one pop and beep
			RET                       

;subroutine
kill_file: 		CALL     copy_trap          
			PUSH 	H                   
			CALL     erase_line_8 
			LXI 	h,  00108H 
			LXI 	D,  Kill  	
			CALL     printloop_D_HL   	
			POP 	H                    
			PUSH 	H                   
			CALL     print_entry_name   	  
			LXI 	h,  AreYouSure  	
			CALL     printloop          
			CALL     get_key  	
			CPI      059H    	   
			POP 	H                    
			RNZ                       
			PUSH H                   
			CALL     05AE3H    	; Get start address of file at M
			XCHG                      
			POP 	H                    
			MOV 	A,M          	  
			CPI      080H            
			JZ       kill_BA   	; kill basic file
			CALL     kill_DO_CO       ; kill DO or CO file
			JMP      05797H    	; MENU start

kill_DO_CO:		PUSH 	H                   
			JMP      01FB2H   		

kill_BA:		CALL     02017H   	
			JMP      05797H    	;MENU start

beeperror2:		POP 	H                    
beeperror:  		POP 	H                    
beeperror1:		CALL     04229H   	; BEEP statement
			RET                       

;subroutine
printloop_D_HL:		PUSH 	D                   
			CALL     0427CH   	;Set the current cursor position (H=Row,L=Col)
			POP 	H                    
			CALL     printloop          
			RET                       


erase_line_8:		LXI 	h,  00108H  	
			MVI 	D,   028H   	

; prints D spaces at screen location HL
print_d_at_hl:		PUSH 	D                   
			CALL     0427CH   	; Set the current cursor position (H=Row,L=Col)
			POP 	D                    
print_d_at_hl1:		MVI 	A,   020H  	
			RST 	4                   ; RST 4 Send character in A to screen/printer  
			DCR 	D             	
			JNZ     print_d_at_hl1		; loop back if d not zero
			RET                       

;subroutine
copy_file:		CALL     copy_trap         ; traps the conditions for what cannot be copied
			PUSH 	H                   
			CALL     setup_copy         	; at this point, its a copyable file
			POP 	H                    	; identifies target bank.
			JNZ      beeperror1   	   
	 		MOV 	A,M           	
			CPI      0A0H            
			JZ       copy_CO          
			CPI      080H            
			JZ       copy_BA   	   
			CPI      0C0H            
			JNZ      beeperror1   	   
			CALL     copy_DO          
			CALL     find_DO_file_end        
			PUSH 	H                   
			INX 	B           	  
			PUSH 	B                   
			PUSH 	B                   
			POP 	D                    
			CALL     remote_cmd1   	; make space for DO       
			POP 	B                    
			POP 	D                    
			JC       beeperror1   	     
			CALL     remote_copy_BC_bytes         
			CALL     remote_cmd2   		; make entry       
			RET                       

     

	.db	00               

;--------------------------------------------------------------------------	
file1_nextline15:
	.dw	file1_nextline16 - file1_nextline11 + offset	; pointer to next line
	.db	032h					; line number			
	.db	01h		

; - called in copy-- identifies target bank.
setup_copy:   		CALL     erase_line_8     
			LXI 	h,  00108H  	
			LXI 	D,  DestinationBank  	
			CALL     printloop_D_HL   		;      print it out
			CALL     012CBH    		; waits for character of input from key,
			LXI 	h,  source_bank 	
			CMP 	M               	
			JZ       bperror          ; if same bank, error
			CPI      031H    	 
			JC       bperror       	; error  
			CPI      035H     	; 31-34 valid
			JC       init_copy         


bperror:		POP 	H                    
			JMP      beeperror   

;subroutine called in copy -- is this the only copy path?
; calls command 0
; contains source bank info
; enter with a holding target bank
init_copy:		sui	30h        		; corrects selection for actual number needeed for target bank  
			STA     target_bank_val+1  	; store this number internally--self modifying  
			LDA     source_bank  		; load source bank 
			sui	30h         		; this is the source number...corrected
			MOV 	C,A           		; place a in C (corrected source number) 
			XRA 	A                  	; zero a 
			MOV 	B,A          		; place a in B  
			CALL    remote_command   	; call remote command
			RET                       

;copy routines that are called remotely

;subroutine-- initialize target bank : appears to set up the power up stack pointer
cmd0:			MOV 	A,C  	
			STA      return_bank_val+1  	    
			LHLD     0F652H  		; unknown ram location , has something to do with current program running   
			XCHG              	 
			LXI 	h,  05906H  	
			RST 	3                 	 
			RNZ                    ;return if not the same   
			SHLD     0F5F2H  	; store hl into power up stack pointer  
			RET                    


;subroutine --- looks like it clears out space for .DO files
cmd1:			PUSH 	D                   
			POP 	B                    
			LHLD     0FBAEH  	; looks like end of .ba files   
			CALL     06B6DH   	; Insert BC spaces at M
			LHLD     0FBAEH  	     
			RET                       
 

;subroutine  I'm guessing it creates a .do file entry
cmd2:  			CALL     020E4H          ;NAME statement??
			XCHG                      
			LHLD     0FBAEH  	;get end of basic files pointer 
			XCHG                      
		 	MVI 	A,   0C0H    	
			DCX 	D	 
			JMP      make_CO_DO_entry   	  

;subroutine
cmd3: 			MOV 	M,C        	      
			INX 	D	
			INX 	H           	
			RET                       

;subroutine
cmd4:  			CALL     02105H  	;NEW statement??
			CALL     02146H   	;NEW statement??
			JMP      return_to_source_bank  	    


;subroutine
cmd5:  			PUSH 	D                   
			POP 	B                    
			LHLD     0F67CH        
			CALL     06B6DH  	;Insert BC spaces at M
			RC                        
			CALL     0213EH   	;NEW statement??
			LHLD     0F67CH  	  
			RET                     


;subrountine
cmd6:  			CALL     02146H   	;  NEW statement??
			CALL     020AFH         ; NAME statement??
			RNZ                       
			LXI 	h,  0FFFFH 	  
			INX 	H            	
			SHLD     0F67EH  	
			LHLD     0F652H  ;current program running
			PUSH 	H                   
			LXI 	h,  cmd6_1  	     
			SHLD     0F652H 	   
			CALL     020E4H         ; NAME statement??
cmd6_1:			POP 	H                    
			SHLD     0F652H  	    
			RET                       


;subroutine-- I'm guessing it creates a basic file entry
cmd7:  			CALL     02146H   ;NEW statement??
			CALL     020E4H          ;NAME statement??
			SHLD     0FA8CH 	      
			MVI A,   080H    	   
			XCHG                      
			LHLD     0F67CH  	
			XCHG                      
			CALL     02239H   ; open a text file at (FC93H)??
			CALL     021D4H   ;  NEW statement??
			RET     


;subroutine
cmd8:			PUSH 	D                   
			POP 	B                    
			LHLD     0FBB0H 	  
			PUSH 	H                   
			LHLD     0FBB2H  	 
			PUSH 	H                   
			CALL     06B6DH   ; Insert BC spaces at M
			POP 	D                    
			POP 	H                    
			RC                        
			SHLD     0FBB0H  	     
			XCHG                      
			RET            

;subroutine  I'm guessing it creates a .co file entry
cmd9: 			XCHG                      
			CALL     020E4H        ;  NAME statement??
			MVI 	A,   0A0H    	     

make_CO_DO_entry:	CALL     02239H   ; open a text file at (FC93H)
			CALL     02146H   	;    NEW statement??
			RET                       


                  

;subroutine
remote_cmd1: 		MVI 	B,   001H  	
			CALL     remote_command   	   
			RET                       

;subroutine
remote_cmd2:   		MVI 	B,   002H   	
			CALL     remote_command   	    
			RET                       

;subroutine
sub040:  		INX 	h          	
			INX 	h       	
			INX 	h         	 
			LXI 	D,  0FC93H  	   
			LXI 	B,  00108H  	
			DCR 	B             	
			XCHG                      
			CALL     remote_copy_BC_bytes         
			RET                       

;subroutine
remote_copy_BC_bytes_1: PUSH 	B                   
			LDAX 	D	  
			MOV 	C,A          	 
			MVI 	B,   003H    	
			CALL     remote_command   	 
			POP 	B                    
			DCX 	B	
remote_copy_BC_bytes:	MOV 	A,B          	 
			ORA 	C                     
			JNZ      remote_copy_BC_bytes_1   	
			RET                       


;subroutine
find_DO_file_end:  	CALL     get_dir_entry_info         
find_DO_end:		CALL     05AE3H  	;Get start address of file at M
			PUSH 	H                   
			LXI 	B,  0FFFFH  	
			INX 	B	
			MVI 	A,   01AH   	
find_DO_end_1:		CMP 	M                     
			INX 	H	
			INX 	B	
			JNZ     find_DO_end_1   	    
			DCX 	B	
			POP 	H                    
			RET                       

;subrountine
copy_BA:   		CALL     copy_DO          
			CALL     remote_cmd4          
			CALL     get_BA_entry_size          
			PUSH 	D                   
			PUSH 	B                   
			POP 	D                    
			CALL     remote_cmd5      	; make BA space    
			POP 	D                    
			JC       beeperror1   	
			CALL     remote_copy_BC_bytes         
			CALL     remote_cmd7          ; make BA entry
			RET                       

	.db	00               

;--------------------------------------------------------------------------	
file1_nextline16:
	.dw	file1_nextline17 - file1_nextline11 + offset	; pointer to next line
	.db	03ch					; line number			
	.db	01h	               


remote_cmd6:  		MVI 	B,   006H    	
			CALL     remote_command   	   
			RET                       

remote_cmd5:		MVI 	B,   005H    	
			CALL     remote_command   	     
			RET                       


remote_cmd7: 		MVI 	B,   007H    	
			CALL     remote_command  	 
			RET                       
			
remote_cmd4: 			MVI 	B,   004H  	   
			CALL     remote_command   	     
			RET                       


;subroutine - calculates the size number for a basic program
get_BA_entry_size:  	CALL     get_dir_entry_info        ;  get first byte of selected file's directory entry, load HL and A
get_BA_size:		CALL     05AE3H    ;Get start address of file at M
			XCHG                      
			PUSH 	D                   
			CALL     005F4H    ;Builds BASIC line pointers.
			POP 	D                    
			INX 	H	   
			CALL    HLmDE          
			DCX 	B	
			DCX 	B	
			RET                       

HLmDE:  		MOV 	A,L          	
			SUB 	E                     
			MOV 	C,A     	
			MOV 	A,H       	
			SBB 	D                     
			MOV 	B,A          	
			RET                       


;subroutine
copy_CO:		CALL     copy_DO          
			CALL     get_CO_entry_size          
			PUSH 	D                   
			PUSH 	B                   
			POP 	D                    
			CALL     remote_cmd8  	    ; make space 
			POP 	D                    
			JC       beeperror1   	
			PUSH	 H                   
			CALL     remote_copy_BC_bytes         
			POP 	H                    
			CALL     remote_cmd9 	   ; make entry
			RET                       

;subroutine - calculates the size of a machine language program
get_CO_entry_size:	CALL     get_dir_entry_info          
get_CO_size:		CALL     05AE3H  	;Get start address of file at M
			PUSH 	H                   
			CALL     021A4H    ; NEW statement??
	 		POP 	D                    
			CALL     HLmDE          
			RET                       

remote_cmd8: 		MVI 	B,   008H    	
			CALL     remote_command   	    
			RET                       
           
remote_cmd9: 		MVI 	B,   009H    	
			CALL     remote_command  	
			RET                       

	.db	00               

;--------------------------------------------------------------------------	
file1_nextline17:
	.dw	file1_nextline18 - file1_nextline11 + offset	; pointer to next line
	.db	046h					; line number			
	.db	01h	               
               

;subroutine
sub052:  		CALL     get_dir_entry_info       ;   get first byte of selected file directory entry
			CPI      0B0H         ;   test for rom program
			JZ       getsize   	     
			CPI      0F0H          ;  test for trigger file
			JZ       getsize  	   
			CPI      080H           ; test for basic program
			JZ       get_BA_size          
			CPI      0A0H         ;   test for machine language
			JZ       get_CO_size          
			JMP      find_DO_end  	     


;subroutine - calculates size displayed for rom programs, or trigger files (shows system free memory)
getsize:		LHLD     0FBB2H  	       
			XCHG                      
			LHLD     0F678H  	    
			CALL     HLmDE          
			LXI 	h,  0FFF2H 	   
			DAD 	B	 
			PUSH 	H                   
			POP 	B                    
			RET                       

;subroutine
name_file:		CALL     erase_line_8  	
			LXI 	h,  00108H  	
			LXI 	D,  rename  		
			CALL     printloop_D_HL  	   
			CALL     copy_name_to_buffer   	 
			CALL     get_dir_entry_info          
			PUSH 	H                   
			CALL     print_entry_name 	  
			LXI 	h,  To  	      
			CALL     printloop          
			CALL     04644H  	;Input and display (no "?") line and store  
			CALL     make_name          
			CALL     cmd6	    
			POP 	H                    
			JNZ      beeperror1  	   
			INX 	H	   
			INX 	H
			INX 	H      	  
			LXI 	D,  0FC93H  	  
			MVI 	B,   008H    	
			CALL     03469H   	;  Move M bytes from (DE) to M with increment 
			JMP      05797H   	;  MENU start



make_name:		LXI 	h,  0F685H  	; look at input buffer    
			LXI 	D,  0FC93H  	; look at name buffer
			MVI 	B,   006H  	
			MOV 	A,M          	
			ANA 	A                     
			JZ       beeperror2  	 ; if input buffer = 0
			CPI      041H    	 
			JC       beeperror2   	 ; if input buffer char < "A"   
make_name_1:		CALL     00FE9H    	;  Convert A to uppercase
			STAX 	D	
			DCR 	B         	
			RZ                        
			INX 	H	  
			INX 	D	
			MOV	A,M      	
			ANA 	A                     
			JZ       make_name_2          
			CPI      02EH   	   
			JNZ      make_name_1         
make_name_2:		MVI 	A,   020H   	      
			DCX 	H	
			JMP      make_name_1          

prtloop:		INX 	H          	
printloop:		MOV 	A,M        	
			INR 	A             	
			RZ                        
			DCR 	A        	
			RST 	4                     
			JNZ      prtloop          
			RET                       


print_name_loop:  	INX 	H	  
print_name:		MOV 	A,M          	
			RST 	4                     
			DCR 	B            	      
			JNZ      print_name_loop         
			RET                       


copy_DO:		CALL     sub040  	 
			CALL     remote_cmd6   	    
			RZ                        
			CALL     copy_name_to_buffer   	    
			CALL     erase_line_8   	     
			LXI 	h,  00108H 	 
			LXI 	D,  Nameofnewfile  	
			CALL     printloop_D_HL  	     
			CALL     04644H   ; Input and display (no "?") line and store
			CALL     make_name          
			LXI 	h,  0FC93H 	      
			MOV 	D,H         	   
			MOV 	E,L         	 
			LXI 	B,  00106H 	
			DCR 	B            	  
			CALL     remote_copy_BC_bytes         
			CALL     remote_cmd6   	     
			JNZ      beeperror  	      
			RET                       

;subroutine
print_entry_name:	INX 	H	 
			INX 	H	  
			INX 	H	   
			MVI 	B,   008H    	
			JMP      print_name
         
copy_name_to_buffer:	CALL     get_dir_entry_info          
			INX 	H	 
			INX 	H	  
			INX 	H     
			LXI 	D,  0FC93H  	
			XCHG                      
			MVI 	B,   008H    	   
			JMP      03469H   	;Move M bytes from (DE) to M with increment


Exit:  			LXI 	h,  07FF3H  	   
;			LDA      0FFA2H  	      ; don't know what FFA2 is  KEYGPC??
;			RRC              	    
;			JC       sub015          
			JMP      Exit_hooks          

; subroutine called from TELCOM(TERM-F6)
;termhook:   		CALL     04231H   ;  CLS statement
;			CALL     01F3AH   ;  FILES statement
;			CALL     07EACH    ; Display number of free bytes on LCD
;			CALL     04222H  ;  Send CRLF to screen or printer
;			RET                       

;subroutine
;Lfo_file:  		LXI 	h,  ptr100  	   
;			MOV 	A,M          	    
;	 		CPI      06EH     	; compare 4th character to 'n'
;			JZ       sub064   	; if n then jump ahead     
;			MVI	 M,   06EH   	; set to 'n'     
;			MVI 	A,   0C0H   	; set to RNZ 
;			STA      redirect  	   
;			RET                       

;sub064:  		MVI 	M,   066H    	;  set to 'f'
;			MVI 	A,   0C9H   	 ; set to RET  
;			STA      redirect  	; self modifying code
;			CPI      00DH   	 ; called from PNOTAB
;redirect:  		RET                       ; either RET or RNZ

;			CALL     06D3FH   ; Send character in A to the printer
;			MVI A,   00AH   	   
;			RET                       

       

	.db	00               

;--------------------------------------------------------------------------	
file1_nextline18:
	.dw	file1_nextline19 - file1_nextline11 + offset	; pointer to next line
	.db	050h					; line number			
	.db	01h	               
                            

fnk_keys2:	.db	"Bnk1 Bnk2 Bnk3 Bnk4 "
		.db	"                   "
		.DB	0ffh    

fnk_keys1:   	.db	"Bnk1           Copy "
               	.db	"Kill Name      "   ; erased Lfo
;ptr100:         .db	"f "
               	.db	"Exit"      
		.db	0FFh                                     


Kill:		.db	"Kill "
		.db	0FFh                      
                                   
AreYouSure:	.db 	" Are You Sure ? Y/N " 
		.DB	0ffh                                  
                                    
DestinationBank:	.db	"Destination Bank ? "
		.DB	0ffh                                     

hashtag:	.db	"#"
source_bank:	.db	"1"       
		.DB	0ffh  

             
rename:	 	.db     "Rename : "                   
		.DB	0ffh                                

Nameofnewfile:   .db     "Name of new file  "      
		.DB	0ffh                      

To:		.db     " To "
		.DB	0ffh     
		

	.db	00               

;--------------------------------------------------------------------------	
file1_nextline19:
		.dw	file1_nextline20 - file1_nextline11 + offset	; pointer to next line  ; temp hl store
temp_hl_store:	.db	01Fh, 08ch					; line number		; sp store	
             
; hide data in line number and pointer to next line   
	.db	00    
	
;--------------------------------------------------------------------------	
file1_nextline20:
		.dw	file1_nextline21 - file1_nextline11 + offset	; pointer to next line  ; temp hl store
SP_STORE:	.db	0c8h, 0f3h					; line number		; sp store	
             
; hide data in line number and pointer to next line   
	.db	00               
           

;--------------------------------------------------------------------------	
file1_nextline21:
	.dw	file1_nextline22 - file1_nextline11 + offset	; pointer to next line
	.db	0e8h, 0Fdh					; line number			


		.db	0A3h         ; print           
	   	.db	"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqr"


	.db	00h
	
;--------------------------------------------------------------------------	
file1_nextline22:
;	.db	00h,00h			; end of program
file1_end:


	.END

	

