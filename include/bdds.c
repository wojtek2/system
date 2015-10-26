/*
 ***********************************************************************************************************
 *						Bdds.c						   *
 * 						Wersja:pre-alpha					   *
 * 						e-mail:Gandzia40@wp.pl					   *
 * 						2014							   *
 ***********************************************************************************************************
 Plik aktualnie tymczasowo dołączany do głównego pliku jądra kernel.c, zawierający podstawowe procedury obsługujce podstawowe urządzenia systemowe (ekran, klawiaturę, FDD, PIC,DMA) zarówno w trybie rzeczyw
 istym jak i chronionym. Zalążek sterownika Basic Device Drivers.*/
#include "data.h"
#include <stdarg.h>
/*Kontroler przerwań (PIC 8259A) */


void PICInitInPM() { /*Przygotowuje system obsługi przerwań sprzętowych do pracy w trybie chronionym.Mskuje wszystkie przerywania maskowalne */
  uchar temp;
  SetCallStack(9)
  
  
  /*Najpierw zamaskowanie wszystkich przerwań */ 
  /*Najpier zamaskowanie przerwań w układach master i slave */  
  outb(0x21,0xFF);
  outb(0x0A1,0xFF);
  
  
  
  /*Następnie przygotowanie układów do pracy w trybie chronionym CPU.Master: */
  outb(0x20,0x11); //Wysłanie bajtu ICW1 do układu master
  DelayLoop(100); //Opóźnienie
  outb(0x21,0x20); //Wysłanie bajtu ICW2 do układu master, ten bajt to przemieszczenie wektora przerwań. W trybie chronionym procesor rezerwuje pierwsze 32 przerywania do własnych celów, dlatego pierwsze przerywanie sprzętowe w idt ma wartość 32
  DelayLoop(100); //Opóźnienie
  outb(0x21,4); //Wysłanie ICW3
  DelayLoop(100); //Opóźnienie
  outb(0x21,1); //Wysłanie ICW4
  /*Układ slave: */
  outb(0x0A0,0x11); //Wysłanie ICW1
  DelayLoop(100);
  outb(0x0A1,0x28); //Wysłanie bajtu ICW2 do układu slave, ten bajt to przemieszczenie wektora przerwań. 
  DelayLoop(100);
  outb(0x0A1,2); //Wysłanie ICW3  
  DelayLoop(100); //Opóźnienie
  outb(0x0A1,1); //Wysłanie ICW4
  DelayLoop(100);
  /*Ponowne zamaskowanie przerwań */
  DelayLoop(100); //Opóźnienie
  outb(0x21,0xFF);
  DelayLoop(100); //Opóźnienie
  outb(0x0A1,0xFF);  
  ReturnCallStack
}
void EnableIRQ(uchar IRQ,uchar PIC) { /* procedura włącza podane przerywanie sprżetowe w kontrolerze przerwań. Parametry: IRQ numer przerywania sprzętowego,PIC - 0 układ master 1 -układ slave */
  u16int Port;
  uchar OCW1,temp;
  if (PIC == 0) {Port = 0x21; } else { Port = 0xA1;}
  if (IRQ == 0) {
    OCW1 = 1;
  }
  else {
    OCW1 = 1 << IRQ;
  }
  temp = inb(Port);
  DelayLoop(1);
  
  OCW1= temp ^ OCW1;
  
  outb(Port,OCW1);
}

void DisableIRQ(uchar IRQ,uchar PIC) { /* procedura wyłącza podane przerywanie sprżetowe w kontrolerze przerwań. Parametry: IRQ numer przerywania sprzętowego,PIC - 0 układ master 1 -układ slave */
  u16int Port;
  uchar OCW1,temp;
  if (PIC == 0) {Port = 0x21; } else { Port = 0xA1;}
  if (IRQ == 0) {
    OCW1 = 1;
  }
  else {
    OCW1 = 1 << IRQ;
  }
  
  
  temp = inb(Port);
  DelayLoop(1);    
  OCW1= temp | OCW1;
  outb(Port,OCW1);  
  
}


/*Ekran:*/
uchar TextColor=7; //Kolor aktualnie wyświetlanego tekstu przez kprintf. Poprzednie teksty nie są zmieniane.
uchar CurX = 0; /*Pozycja kursora na ekranie */
uchar CurY = 0;
void kputc(uchar c) { /* Wstawia znak o odpowiednim kolorze w pozycję kursora i przesuwa kursor. Działa w trybie chronionym.PARAMETRY: c - znak; color - kolor znaku */   	
    u16int temp;
    SetCallStack(7);
    if (CurX >79) {
      CurX = 0;
      CurY++;
      if (CurY > 24) CurY = 0;
    }
    temp = (80*CurY+CurX)*2;        
    
    asm(	
        "pushw %%es\n"
        "movw $0x20,%%ax\n"
        "movw %%ax,%%es\n"
	//"movw $[cont],%%si\n"	
	"movb %[chr],%%es:(%%si)\n"
	//"movb $66,%%es:(0)\n"
	"inc %%si\n"
	"movb TextColor,%%al\n"
	"movb %%al,%%es:(%%si)\n"
        "popw %%es\n"	
       :
       : [cont] "S"(temp), [chr] "r"(c)
       : "%ax"
       );	
    CurX++;    
    ReturnCallStack
}	
   

void kprintf(uchar text[],...) {/* Standardowa procedura printf z biblioteki stdio.Działa zarówno w trybie rzeczywistym jak i chronionym */

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
  SetCallStack(6)
  temp=0;
  temp2=0;
  strlen=0;
  ArgInt = 0;
  
  for (temp=0;text[temp] != '\0' & temp <= 65535;temp++) {
    switch (text[temp]) {
      case '\n':
	  SetCurPos(0,CurY+1);  	
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
	      
	      kputc('0');
	      kputc('x');	      
	      for (temp2=0;temp2 < strlen;temp2++) {
		kputc(ArgStr[temp2]);
	      }
	      break;
	     case 'u': 
	      ArgInt = va_arg( parg,u32int);
	      strlen=IntToStr(ArgInt,ArgStr);
	      
	      for (temp2=0;temp2 < strlen;temp2++) {
		kputc(ArgStr[temp2]);
	      }
	      break;
	     case 'c':
	       ArgStrP = va_arg( parg,uchar*);	       
	       for (temp2=0;ArgStrP[temp2] != '\0';temp2++) kputc(ArgStrP[temp2]);
	       break;
	    default: 	      
	      kputc('%');
	      kputc(text[temp+1]);
	      break;
	  }
	  temp++;
	} else 
	{	  
	  kputc(text[temp]);
	}
	break;
    }
  }
  va_end(parg);
  ReturnCallStack
}

void SetCurPos(uchar x,uchar y) {  //Procedura ustawia pozycję kursora. PARAMETRY : x,y - pozycja kursora, X musi być <= 79 a Y <= 24, w przeciwnym wypadku procedura ustawia X badź Y na 0. 
  
  if (x > 80) x = 0;
  if (y > 25) y = 0;
  CurX = x;
  CurY = y;
 
}
void kprintFAILED() { /* Procedura wyświetla czerwony migający tekst:[FAILED] na końcu linii. */
  uchar OldCol;
  OldCol = TextColor;
  TextColor = 4 | 128;
  SetCurPos(71,CurY);
  kprintf("[FAILED]\n");
  TextColor = OldCol;
}

void kprintOK() { /* Procedura wyświetla zielony tekst:[OK] na końcu linii. */
  uchar OldCol;
  OldCol = TextColor;
  TextColor = 2;
  SetCurPos(76,CurY);
  kprintf("[OK]\n");
  TextColor = OldCol;
}

void ClearScreen() { /*Procedura czyści ekran */
  u16int temp;
  SetCurPos(0,0);
  for (temp = 0; temp <= 1896; temp++) kputc(' ');
  SetCurPos(0,0);
}
  