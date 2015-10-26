/*
 ***********************************************************************************************************
 *						Bdds16.c						   *
 * 						Wersja:pre-alpha					   *
 * 						e-mail:Gandzia40@wp.pl					   *
 * 						2014							   *
 ***********************************************************************************************************
 Plik aktualnie tymczasowo dołączany do głównego pliku jądra kernel.c, zawierający podstawowe procedury obsługujce podstawowe urządzenia systemowe (ekran, klawiaturę, FDD, PIC,DMA) w 16 bitowym trybie rzeczyw
 istym. Zalążek sterownika Basic Device Drivers.*/

/*Ekran:*/
void printrm(text)char text[]; { /* Procedura wyświetla tekst podany w parametrze text.Działa w trybie rzeczywistym */  
  char c,temp;
  c = 14;
  
  
  for (temp=0;text[temp] != 0; temp++) {
    c = text[temp];        
    
       
    asm(".intel_syntax noprefix\n"
        "push ax\n"
	"push bx\n"
	"push cx\n"
	"push dx\n"
	"mov ah,0xE\n"	
	"mov al,%[res]\n"
	"mov bl,7\n"
	"mov bh,0\n"
	"int 0x10\n"
	"pop dx\n"
	"pop cx\n"
	"pop bx\n"
	"pop ax\n"
	".att_syntax prefix\n" 
	:
	:[res] "r" (c)
       );    
     }
  
 }