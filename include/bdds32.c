/*
 ***********************************************************************************************************
 *						Bdds32.c						   *
 * 						Wersja:pre-alpha					   *
 * 						e-mail:Gandzia40@wp.pl					   *
 * 						2014							   *
 ***********************************************************************************************************
 Plik aktualnie tymczasowo dołączany do głównego pliku jądra kernel.c, zawierający podstawowe procedury obsługujce podstawowe urządzenia systemowe (ekran, klawiaturę, FDD, PIC,DMA)  w 32 bitowym trybie chronionym. Zalążek sterownika Basic Device Drivers.*/

/*Ekran:*/
void printpm(text)char text[]; { /* Procedura wyświetla tekst podany w parametrze text.Działa w trybie chronionym */  
  char c;
  static u16int count=0;
  static uchar x=0;
  static uchar y=0;  
  u16int temp;
  GDTS[4].Size1=2000;
  GDTS[4].Base1=0x8000;
  GDTS[4].Base2=0xB;
  GDTS[4].A=0;
  GDTS[4].RW=1;
  GDTS[4].CE=0;
  GDTS[4].T=0;
  GDTS[4].S=1;
  GDTS[4].DPL=0;
  GDTS[4].P=1;
  GDTS[4].Size2=0;
  GDTS[4].AVL=0;
  GDTS[4].Zero=0;
  GDTS[4].D=1;
  GDTS[4].G=0;     
  for (temp=0; text[temp] != 0 ; temp++) {
    c=text[temp];
    if (c == "\n" ){
      y++;
      if (y == 25) y=0;
    } else if (c == "\r") x=0;
    else {
   count=80*2*y+2*x;
    
    asm(
	"movw $0x20,%%ax\n"
        "movw %%ax,%%es\n"
	//"movw $[cont],%%si\n"	
	"movb %[chr],%%es:(%%si)\n"
	//"movb $66,%%es:(0)\n"
	"inc %%si\n"
	"movb $0x7,%%es:(1)\n"	 
       :
       : [cont] "S"(count), [chr] "r"(c)
       : "%ax"
       );	
    x++;    
   }
  } 
}



 