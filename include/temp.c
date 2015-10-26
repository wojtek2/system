 /*
 ***********************************************************************************************************
 *						temp.c						   *
 * 						Wersja:pre-alpha					   *
 * 						e-mail:Gandzia40@wp.pl					   *
 * 						2014							   *
 ***********************************************************************************************************
 Plik tymczasowo dołączany do jądra zawierający różne tymczasowe rzeczy, przeznaczony do testowania.
 Docelowo nie będzie wchodził w skład jądra.
 */
#include <stdarg.h> 
asm(".code32");
uchar NextTask=0;
uchar temp10=1;
struct TSSSeg TaskTSS;
struct TSSSeg TaskTSS0;
struct TSSSeg TaskTSS1;
struct TSSSeg TaskTSS2;
volatile uchar StackTask0[0xFFFF];
volatile uchar StackTask1[0xFFFF];
volatile uchar StackTask1SS0[0xFFFF];


volatile uchar StackTask2[0xFFFF];
volatile uchar StackTask2SS0[0xFFFF];


volatile uchar StackTask3[0xFFFF];
volatile uchar StackTask3SS0[0xFFFF];
u32int tempx;
  
//uchar CurX=0,CurY=0; //Pozycja kursora, jeżeli procesor pracuje w trybie chronionym
void KeybIRQ() {
  BOCHSDBG
  asm("cli\n");
  TextColor=2;
  SetCurPos(0,7); 
  //kprintf("KLAWISZ :):):)\n");
  TextColor=7;
  asm("pushw %ax\n"
      "movb $0x20,%al\n"
      "outb %al,$0x20\n" //EOI
      "popw %ax\n"
      "leave\n"
      "iret\n");
}
 void Task1() {   
   
   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   BOCHSDBG
   
   
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 1");
     
     
  }
   } 
   //printf("eflags:\n\r");   
   asm("iret \n");
 }
 
 void Task2() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 2");
     
     
  }
   }
   //printf("eflags:\n\r");   
   asm("iret \n");
 }
 
 void Task3() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 3");
     
     
  }
   } 
   
   //printf("eflags:\n\r");   
   asm("iret \n");
 }

void Task4() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 4");
     
     
  }
   } 
   
   //printf("eflags:\n\r");   
   asm("iret \n");
 }

void Task5() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 5");
     
     
  }
   } 
   
   //printf("eflags:\n\r");   
   asm("iret \n");
 }

void Task6() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 6");
     
     
  }
   } 
   
   //printf("eflags:\n\r");   
   asm("iret \n");
 }

void Task7() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 7");
     
     
  }
   } 
   
   //printf("eflags:\n\r");   
   asm("iret \n");
 }

void Task8() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 8");
     
     
  }
   } 
   
   //printf("eflags:\n\r");   
   asm("iret \n");
 }
  

void Task9() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 9");
     
     
  }
   } 
   
   //printf("eflags:\n\r");   
   asm("iret \n");
 }
  
void Task10() {   
   //asm("movw $0x10,%ax\n");
   //asm("movw %ax,%ds\n");
   //BOCHSDBG
   
   SetCurPos(0,0);
   for (;;) {
   for (;;) {
     //
     
     SetCurPos(0,0);
     kprintf("Teraz dziala zadanie nr 10");
     
     
  }
   } 
   
   //printf("eflags:\n\r");   
   asm("iret \n");
 }

  
 void Clock() {
   u32int temp2;
   TasksN=0;
   ActTaskN = 1;   
   GDTC=20;
   ActTaskTSS = &Tasks[1].TSS;
   
   
     
   //Zadanie nr 1, poziom uprzywilejowania:0:
   EditGDTEntry(9,0xFFFF,(u32int) &StackTask1,0,1,0,0,1,0,1,0,1,0); //Stos zadania nr 1
   AddToProcessList((u32int) &Task1,0,0x200,0x48,0,0,0x48,0xFFFF,0xFFFF,0xFFFF,0xFFFF,0,0,0);
   
   //Zadanie nr 2, poziom uprzywilejowania:3:
   EditGDTEntry(10,0xFFFF,(u32int) &StackTask2,0,1,0,0,1, 3 ,1,0,1,0); //Stos zadania nr 2
   EditGDTEntry(11,0xFFFF,(u32int) &StackTask2SS0,0,1,0,0,1, 0 ,1,0,1,0); //Stos zadania nr 2 SS0   
   AddToProcessList((u32int) &Task2,3,0x200,0x58, 0 , 0 ,0x53,0xFFFF,0xFFFF,0xFFFF,0xFFFF,0,0,0);
   
   //Zadanie nr 3, poziom uprzywilejowania:2:
   EditGDTEntry(12,0xFFFF,(u32int) &StackTask3,0,1,0,0,1, 2 ,1,0,1,0); //Stos zadania nr 3
   EditGDTEntry(13,0xFFFF,(u32int) &StackTask3SS0,0,1,0,0,1, 0 ,1,0,1,0); //Stos zadania nr 3 SS0   
   AddToProcessList((u32int) &Task3,2,0x200,0x68, 0 , 0x62 ,0x62,0xFFFF,0xFFFF,0xFFFF,0xFFFF,0,0,0);
   
   
   EditGDTEntry(5,sizeof(Tasks[1].TSS),(u32int) &Tasks[1].TSS,1,0,0,1,0,0,1,0,1,0);
   asm("movw $0x28,%ax\n"       
      "ltr %ax\n"
      //"ljmp $0x30,$0\n" 
     );

   temp2 = (u32int) & SystemClock;
   IDTS[0x20].Offset1 = temp2& 0xFFFF;
   IDTS[0x20].Selector = 0x8;
   IDTS[0x20].Zero = 0;
   IDTS[0x20].W = 0;
   IDTS[0x20].MB3 = 3;
   IDTS[0x20].D = 1;
   IDTS[0x20].Zero2 = 0;
   IDTS[0x20].DPL = 0;
   IDTS[0x20].P = 1;
   IDTS[0x20].Offset2 = (temp2 & 0xFFFF0000) >> 16;      
   SetClockFrequency();
   EnableIRQ(0,0);
   
   temp2 = (u32int) & KeybIRQ;
   IDTS[0x21].Offset1 = temp2& 0xFFFF;
   IDTS[0x21].Selector = 0x8;
   IDTS[0x21].Zero = 0;
   IDTS[0x21].W = 0;
   IDTS[0x21].MB3 = 3;
   IDTS[0x21].D = 1;
   IDTS[0x21].Zero2 = 0;
   IDTS[0x21].DPL = 0;
   IDTS[0x21].P = 1;
   IDTS[0x21].Offset2 = (temp2 & 0xFFFF0000) >> 16;
   EnableIRQ(1,0);
   BOCHSDBGprintf("xxxcccc\n");
   BOCHSDBG   
   asm("movl $0xFFFF,%esp\n"
       "movw $0x48,%ax\n"
       "movw %ax,%ss\n"
       "sti\n");
   //CallToTask(1); 
   for (;;) {
     Task1();
   }
 }
 
 u32int tempxxx;
 u32int tempxxx2;
 
 
 

void putc(uchar c) { /* Wstawia znak w pozycję kursora i przesuwa kursor. Działa w trybie rzeczywistym i chronionym */   	
    u16int temp;
    //SetCallStack(7);
    temp = (80*CurY+CurX)*2;    
    BOCHSDBG
    asm(	
        "movw $0x20,%%ax\n"
        "movw %%ax,%%es\n"
	//"movw $[cont],%%si\n"	
	"movb %[chr],%%es:(%%si)\n"
	//"movb $66,%%es:(0)\n"
	"inc %%si\n"
	"movb TextColor,%%al\n"
	"movb %%al,%%es:(%%si)\n"
	"inc %%si\n"
       :
       : [cont] "S"(temp), [chr] "r"(c)
       : "%ax"
       );	
    CurX++;
    if (CurX > 79) {
      CurX = 0;
      CurY++;
      if (CurY > 24) CurY = 0;
    }
    //ReturnCallStack
}	
asm(".code32\n");    

void printf(uchar text[],...) {/* Standardowa procedura printf z biblioteki stdio.Działa zarówno w trybie rzeczywistym jak i chronionym */

uchar IntToStr(u32int value,uchar str[]) { //Funkcja konwertuje integer ze znakiem lub bez na string.Obcina początkowe zera PARAMETRY: value - wartość do przekonwertowania; sign - 0 bez znaku 1 ze znakiem ZWRACANE: Długość liczby; w *str napis z liczbą.  
  uchar temp;
  u32int temp2=1000000000;  
  u32int value2=value;
  uchar len=0;
  uchar c;
  uchar z=0; // Jeżeli z=0 znaczy że podczas konwersjii nie wystąpiła jeszcze cyfra >0 , a zera są obcinane.  
  for (temp=0; temp <=9; temp++) {
    c=(value2 / temp2);
    value2= value2 % temp2;    
    if (c > 0 | z == 1) {
      z=1;
      str[len]=c+48;
      len++;   
    }
    temp2=temp2 /10;
  }
  if (z == 0) {
    str[0]='0';
    return 1;
  } else return len;
}


uchar IntToHex(u32int value,uchar Hex[]) { //Funkcja konwertuje integer  na hex. Nie dodaje 0x i obcina początkowe 0.PARAMETRY: value - wartość do przekonwertowania. ZWRACANE: Długość liczby; w hex liczba w systemie szesnastkowym
  uchar temp;
  u32int temp2=0x10000000;  
  u32int value2=value;
  uchar len=0;
  uchar c;
  uchar z=0; // Jeżeli z=0 znaczy że podczas konwersjii nie wystąpiła jeszcze cyfra >0 , a zera są obcinane.
  for (temp=0; temp <=7; temp++) {
    c=(value2 / temp2);
    value2= value2 % temp2;
    if (c > 0 | z == 1) {      
      z=1;
      switch (c) {
	case 10: 
	  Hex[len]='A';
	  break;
	case 11: 
	  Hex[len]='B';
	  break;
	case 12: 
	  Hex[len]='C';
	  break;
	case 13: 
	  Hex[len]='D';
	  break;
	case 14: 
	  Hex[len]='E';
	  break;
	case 15: 
	  Hex[len]='F';
	  break;
	default:
	  Hex[len]=c+48;
	  break;
      }      
      len++;   
    }
    temp2=temp2 /16;
  }
  if (z == 0) {
    Hex[0]='0';
    return 1;
  } else return len;
}

  va_list parg;
  u16int temp,temp2;
  uchar ArgStr[11];
  uchar *ArgStrP;
  uchar strlen;
  uchar paramscount=0;
  u32int ArgInt;
  va_start(parg,text);  
  //SetCallStack(6)
  for (temp=0;text[temp] != '\0' & temp <= 65535;temp++) {
    switch (text[temp]) {
      case '\n':
	  SetCurPos(CurX,CurY+1);
	  break;
      case '\r':
	  SetCurPos(0,CurY); 
	  break;              	  
      default:	
	if (text[temp] == '%') {	  
	  switch (text[temp+1]) {
	     case 'x':
	      ArgInt = va_arg( parg,u32int);
	      strlen = IntToHex(ArgInt,ArgStr); 
	      
	      putc('0');
	      putc('x');	      
	      for (temp2=0;temp2 < strlen;temp2++) {
		putc(ArgStr[temp2]);
	      }
	      break;
	     case 'u': 
	      ArgInt = va_arg( parg,u32int);
	      strlen=IntToStr(ArgInt,ArgStr);
	      
	      for (temp2=0;temp2 < strlen;temp2++) {
		putc(ArgStr[temp2]);
	      }
	      break;
	     case 'c':
	       ArgStrP = va_arg( parg,uchar*);
	       for (temp2=0;ArgStrP[temp2] != '\0';temp2++) putc(ArgStrP[temp2]);
	       break;
	    default: 	      
	      putc('%');
	      putc(text[temp+1]);
	      break;
	  }
	  temp++;
	} else 
	{	  
	  putc(text[temp]);
	}
	break;
    }
  }
  va_end(parg);
  //ReturnCallStack
}