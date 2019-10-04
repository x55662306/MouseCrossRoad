INCLUDE Irvine32.inc
main EQU start@0

SYSTEMTIME STRUCT
wYear WORD ?
wMonth WORD ?
wDayOfWeek WORD ?
wDay  WORD ?
wHour  WORD ?
wMinute  WORD ?
wSecond  WORD ?
wMilliseconds WORD ?
SYSTEMTIME ENDS


.data
consoleHandle    DWORD ?
xyPos COORD <60,19> ; //the start point of main role
xyPosOfdick_R COORD<32,17>,<34,17>,<46,17>,<60,17>,<75,17>,<90,17>,<25,13>,<33,13>,<49,13>,<57,13>,<73,13>,<81,13>,<21,13>,<30,9>,<40,9>,<50,9>,<60,9>,<70,9>,<23,6>,<32,6>,<38,6>,<49,6>,<57,6>,<66,6>
xyPosOfdick_L COORD<34,15>,<75,15>,<30,11>,<70,11>,<36,8>,<50,8>
xyPosVic COORD <60,4>
xyPosRiver COORD <22,10>,<22,12>,<22,7> 
vicPlace COORD <60,4>
xyStart COORD <55,15>
dick BYTE 42h,2 DUP(3DH), 44H 
river BYTE 75 DUP(7Eh)
mainRole  BYTE  40h
blank BYTE 20h
blankMemory BYTE 3 DUP(?) ;to fulfill the unnecessary memory to avoid draw wrongly
victory BYTE 56h, 49h, 43h, 54h, 4fh, 52h, 59h
;blankMemory1 BYTE 20h 
startgame BYTE 53h,54h,41h,52h,54h
count DWORD 0
cellsWritten DWORD ?
dickCooldown SYSTEMTIME <>
attributes1 WORD 75 DUP(0Bh)
attributes2 WORD 7 DUP(0ch)
attributes3 WORD 75 DUP(0Ah)
Var_win BYTE 1h
timeNow SYSTEMTIME <>
.code
main PROC 
 INVOKE GetStdHandle, STD_OUTPUT_HANDLE ;get the Console standard output handle:
 mov consoleHandle,eax
 INVOKE  WriteConsoleOutputCharacter,
 consoleHandle,
 addr startgame,
 lengthof startgame,
 xyStart,
 addr count
 
 call Waitmsg

 
 CALL CLRSCR

 MOV EBX,0H
 INVOKE GetLocalTime, ADDR dickCooldown 
START:
 ;end point
 INVOKE  WriteConsoleOutputCharacter,
 consoleHandle,
 addr mainRole,
 lengthof mainRole,
 vicPlace,
 addr count
 
 INVOKE WriteConsoleOutputAttribute,
 consoleHandle,
 addr attributes2,
 lengthof mainRole,
 vicPlace,
 addr cellsWritten
 
 
;judge whether it die
 MOV EBX,0
 mov ecx, 6
L3:
 mov dx ,xyPosOfdick_L[ebx].x
 mov ax ,xyPosOfdick_L[ebx].y 
 push ecx
 mov ecx,4
 L4:
  .IF xyPos.x == dx  && xyPos.y == ax
   ;mov Var_win,1h
 
 call Clrscr
   mov xyPos.x ,55
   mov xyPos.y , 21
   jmp  START
  .ENDIF
 inc dx
 Loop L4
 pop ecx
 ADD ebx,4
 dec ecx
 cmp ecx,0
jne L3
 MOV EBX,0
 mov ecx, 24
L6:
 mov dx ,xyPosOfdick_R[ebx].x
 mov ax ,xyPosOfdick_R[ebx].y 
 push ecx
 mov ecx,4
 L5:
  .IF xyPos.x == dx  && xyPos.y == ax
   ;mov Var_win,1h
   call Clrscr
   mov xyPos.x ,55
   mov xyPos.y , 21
   jmp  START
  .ENDIF
 inc dx
 Loop L5
 pop ecx
 ADD ebx,4
 dec ecx
 cmp ecx,0
 jne L6
 
 ;boundary
 .IF xyPos.x > 97 || xyPos.x < 22
 call Clrscr
 mov xyPos.x ,55
 mov xyPos.y , 21
 jmp  START
  
 .ENDIF
 
 
 
;end of judge whether it die

;judge whether it win
 .IF xyPos.y == 4  &&  xyPos.x == 60
  INVOKE WriteConsoleOutputCharacter,
  consoleHandle,
  addr victory,
  lengthof victory,
  xyPosVic,
  addr count

  INVOKE WriteConsoleOutputAttribute,
  consoleHandle,
  addr attributes2,
  lengthof attributes2,
  xyPosVic,
  addr cellsWritten  
  call waitmsg
  exit
  .ENDIF
 ;mov Var_win, 0h
;end of judge whether it win

 ;--draw mainrole
 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   ; console output handle
 addr mainRole,   ; pointer to the mainRole
 lengthof mainRole,   ; size of mainRole
 xyPos,   ; coordinates of first char
 addr count    ; output countsub xyPos.y,1 
 
 ;--end of draw mainrole
    
 ;draw river
 
 INVOKE WriteConsoleOutputAttribute ,
 consoleHandle, ; console output handle
 addr attributes1, ;write attributes
 lengthof   attributes1, ; number of cells
 xyPosRiver[0], ; first cell coordinates
 addr cellsWritten ; output count

 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   
 addr river,   
 lengthof  river,   
 xyPosRiver[0],   
 addr cellsWritten
 
 INVOKE WriteConsoleOutputAttribute ,
 consoleHandle, ; console output handle
 addr attributes1, ;write attributes
 lengthof   attributes1, ; number of cells
 xyPosRiver[4], ; first cell coordinates
 addr cellsWritten ; output count
 
 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   
 addr river,   
 lengthof  river,  ;if use lengthof ,it will draw more  
 xyPosRiver[4],   
 addr cellsWritten
 
 INVOKE WriteConsoleOutputAttribute ,
 consoleHandle, ; console output handle
 addr attributes3, ;write attributes
 lengthof   attributes3, ; number of cells
 xyPosRiver[8], ; first cell coordinates
 addr cellsWritten ; output count

 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   
 addr river,   
 lengthof  river,   
 xyPosRiver[8],   
 addr cellsWritten
 
 ;end of draw river
 
 ;Draw color of 
; WriteConsoleOutputCharacter PROTO,
; handleScreenBuf:DWORD, ; console output handle
; pBuffer:PTR BYTE, ; pointer to buffer
; bufsize:DWORD, ; size of buffer
; x ; first cell coordinates
; addr cellsWritten ; output count
 
 INVOKE GetLocalTime, ADDR timeNow
 movzx ebx, timeNow.wMilliseconds
 movzx eax, dickCooldown.wMilliseconds
 sub ebx, eax
 .IF ebx < 0
  add ebx,1000
 .ENDIF
 
 .IF ebx > 100 ;|| ebx == (0-59)
 ;mainRole on the river
 .IF xyPos.y == 10 || xyPos.y == 12
 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   ; console output handle
 addr blank,   ; pointer to the mainRole
 lengthof mainRole,   ; size of mainRole
 xyPos,   ; coordinates of first char
 addr count    ; output count
 sub xyPos.x, 2
 .ENDIF
 
 .IF xyPos.y == 7
 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   ; console output handle
 addr blank,   ; pointer to the mainRole
 lengthof mainRole,   ; size of mainRole
 xyPos,   ; coordinates of first char
 addr count    ; output count
 ADD xyPos.x, 2
 .ENDIF
 ;end of mainRole on the river
 
 INVOKE GetLocalTime, ADDR dickCooldown
 push ebx
 mov ebx, 0
 mov ecx, 6
L1:
 push ecx
 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   ; console output handle
 addr blank,   ; pointer to the mainRole
 lengthof dick,   ; size of mainRole
 xyPosOfdick_L[ebx],   ; coordinates of first char
 addr count    ; output count
 
    sub xyPosOfdick_L[ebx].x,1
 .IF xyPosOfdick_L[ebx].x < 25
  add xyPosOfdick_L[ebx].x, 70
 .ENDIF
 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   ; console output handle
 addr dick,   ; pointer to the mainRole
 lengthof dick,   ; size of mainRole
 xyPosOfdick_L[ebx],   ; coordinates of first char
 addr count    ; output count
 
 add ebx, 4
 pop ecx
 dec ecx
 cmp ecx,0
 jne L1
 pop ebx
 push ebx
 mov ebx, 0
 mov ecx, 24
L2:
 push ecx
 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   ; console output handle
 addr blank,   ; pointer to the mainRole
 lengthof dick,   ; size of mainRole
 xyPosOfdick_R[ebx],   ; coordinates of first char
 addr count    ; output count
 
 
 .IF EBX <= 20
  add xyPosOfdick_R[ebx].x,2
 .ENDIF 
 .IF EBX > 20 && EBX <= 48
  add xyPosOfdick_R[ebx].x,1
 .ENDIF
 .IF EBX > 48 && EBX <= 66
  add xyPosOfdick_R[ebx].x,3
 .ENDIF
 .IF EBX > 66 
  add xyPosOfdick_R[ebx].x,3
 .ENDIF
 
 .IF xyPosOfdick_R[ebx].x > 95
  sub xyPosOfdick_R[ebx].x, 75
 .ENDIF
 
 INVOKE WriteConsoleOutputCharacter,
 consoleHandle,   ; console output handle
 addr dick,   ; pointer to the mainRole
 lengthof dick,   ; size of mainRole
 xyPosOfdick_R[ebx],   ; coordinates of first char
 addr count    ; output count
 add ebx, 4
 pop ecx
 dec ecx  ;if loop ip over 127 or -128 ,it should use this way 
 cmp ecx,0
 jne L2
 
 pop ebx
 .ENDIF
 call ReadKey
 .IF dx == VK_UP ;UP
  INVOKE WriteConsoleOutputCharacter,
  consoleHandle,   ; console output handle
  addr blank,   ; pointer to the mainRole
  lengthof mainRole,   ; size of mainRole
  xyPos,   ; coordinates of first char
  addr count    ; output count
  sub xyPos.y, 1
 .ENDIF
 .IF dx == VK_DOWN ;DOWN
  INVOKE WriteConsoleOutputCharacter,
  consoleHandle,   ; console output handle
  addr blank,   ; pointer to the mainRole
  lengthof mainRole,   ; size of mainRole
  xyPos,   ; coordinates of first char
  addr count    ; output count
  add xyPos.y, 1
 .ENDIF
 .IF dx == VK_LEFT ;LEFT
  INVOKE WriteConsoleOutputCharacter,
  consoleHandle,   ; console output handle
  addr blank,   ; pointer to the mainRole
  lengthof mainRole,   ; size of mainRole
  xyPos,   ; coordinates of first char
  addr count    ; output count
   ; output countsub xyPos.x,1
  sub xyPos.x , 1
 .ENDIF
 .IF dx == VK_RIGHT ;RIGHT
  INVOKE WriteConsoleOutputCharacter,
  consoleHandle,   ; console output handle
  addr blank,   ; pointer to the mainRole
  lengthof mainRole,   ; size of mainRole
  xyPos,   ; coordinates of first char
  addr count    ; output count
  add xyPos.x,1 
 .ENDIF
 ;--press esc to escape
 .IF dx == VK_ESCAPE
  jmp END_FUNC
 .ENDIF
; ; inspect whether it over bound
; .IF xyPos.x == 0h ;x lowerbound
;  add xyPos.x,1
;  jmp L1
; .ENDIF
; mov ax,xyBound.x 
; .IF xyPos.x == ax ;x upperbound
;  sub xyPos.x,1
;  jmp L1
; .ENDIF
; .IF xyPos.y == 0h ;y lowerbound
;  add xyPos.y,1
;  jmp L1
; .ENDIF
; mov ax,xyBound.y
; .IF xyPos.y == ax ;y upperbound
;  sub xyPos.y,1
;  jmp L1
; .ENDIF
 
jmp START

;---judge die or not
;judge_die PROC 
 ;;可以在這裡宣告變數嘛 讓值初始化
;judge_die ENDP
;--end of  judge_die

;----exit
END_FUNC:
 exit
 
;--end of exit
main ENDP
END main