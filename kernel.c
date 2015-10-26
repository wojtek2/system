/*
 ***************************************************************************************
 *					kernel.c				       *
 * 					Wersja: pre-alpha			       *
 * 					e-mail:gandzia40@wp.pl			       *
 * 					2014					       *
 ***************************************************************************************
 Główny plik źródłowy jądra. Scala niektóre pliki z podfolderu include oraz zawiera podstawowe struktury i typy danych systemu.
 Zawiera całe API jądra dosŧępne dla progamisty.
 */
#include "./include/data.h"
#include <stdarg.h>
/*Deklaracje danych jądra. To tutaj zostanie przydzielona pamięć dla nich*/
/*struktury:*/
struct _GDTS GDTS[GDTSMAX]; //Tablica GDT
struct _IDTS IDTS[IDTSMAX]; //Tablica IDT
struct _GDTDescr GDTDescr; //pseudodeskryptor GDT
struct _IDTDescr IDTDescr; //pseudodeskryptor IDT

struct _Tasks Tasks[TASKMAX]; // Tablica zawierająca podstawowe informacje na temat procesów. Wpis nr 0 nie jest procesem -> są to informacje na temat jądra systemu,
struct TSSSeg *ActTaskTSS;

volatile struct _PDE KernelPDEA;
volatile struct _PTE KernelPTEA;
/*volatile struct  _PDE KernelPDE; //Wpis z katalogiem stron użytkowanym przez jądro, tymczasowo przez proces init i cały system
volatile struct  _PTE KernelPTEs[0x11]; //Tablica z stronami zajmowanymi przez system, tymczasowo przez proces init i cały system.*/
volatile struct  _PDE KernelPDE __attribute__((section( ".KernelPDESect" )aligned(0x2000)));
volatile struct  _PTE KernelPTEs[0x200] __attribute__((section( ".KernelPTESect" )aligned(0x2000)));
volatile struct TSSSeg KernelTSS;
/*zmienne globalne:*/
/*Zmienne globalne:*/
volatile u32int TasksN=0;
u16int GDTC; //Ilość wpisów w tablicy GDT
volatile u16int KernelSegmentInRM; //Segment jądra w trybie rzeczywistym
volatile u16int KernelBase; //Adres fizyczny jądra, KernelSegmentInRM*0x10

volatile uchar ActTaskPrvLevel; // Poziom uprzywilejowania aktualnie wykonywanego zadania. 0 - poziom najwyższy (jądra), 3 - najniższy


uchar  KernelState=0; // Stan pracy jądra. 0 - preinit -po wczytaniu a przed zainicjowaniem, 16 bitowy tryb rzeczywisty
u16int OldCallStack=0; //Poprzednia wartość zmiennej CallStack
u16int CallStack=0; //Stos wywołań procedur systemowych. Zawiera numer aktualnie wykonywanej procedury systemowej.

volatile u32int ActTaskN; //Numer aktualnie wykonywanego zadania w tablicy procesoów

volatile u32int TasksN; //Aktualna ilość procesów.
volatile u32int ActTaskTickCount; //Licznik kwantów czasu aktualnego zadania
volatile u32int ActTaskMaxTick;  //Ilość kwantów czasu aktualnego zadania

/*Zmienne przechowujące wartości tymczasowe:*/
volatile u32int SystemClockEAX; //Zmienna tymczasowo przechowuje wartość rejestru EAX podczas przełączania zadania

volatile u32int SystemClockESP; //Zmienna tymczasowo przechowuje zawartość rejestru ESP podczas przełączania zadania

inline void outb(u16int port,uchar value) { /* Odpowiednik assemblerowego rozkazu outb. Procedura wysyła wartość value do portu port */
  asm volatile ( "outb %0, %1" : : "a"(value), "Nd"(port) );
}

inline uchar inb(u16int port) { /* Odpowiednik assemblerowego rozkazu inb. Procedura pobiera wartość z portu port */
  uchar ret;
    asm volatile ( "inb %1, %0" : "=a"(ret) : "Nd"(port) );   
    return ret;
}
					      


void DelayLoop(u16int x) { /* Pętla opóźniająca, w istocie zwykła pętla for nie robiąca nic poza zliczaniem. Może być stoswana do opóźnień przy operacjach I/O. X - ilość przebiegów pętli */
  u16int temp;
  for (temp=0; temp != x; temp++) {
  }
}





void inline EmptyInterrupt() { /* Pusta procedura obsługi przerywania, nie robi nic poza wyjściem z przerywania. Służy do obsługi przeyrwań sprzętowych nie zablokowanych przez zamaskowanie przerwyań w PIC. Na początku wszytskie przerywania są skierowane na tą procedurę. */
  asm("leave\n"
      "iret\n");
}




uchar EditGDTEntry(uchar Index,u32int Size,u32int Base,uchar A,uchar RW,uchar CE,uchar T,uchar S,uchar DPL,uchar P,uchar AVL,uchar D,uchar G) { /* Funkcja edytuje wpis w tablicy GDT. Parametry : index - numer wpisu; Pozostałe parametry zgodne ze znaczeniem parametrów opisanych w strukturze GDTS. Zwracane: 0 - funkcja wykonana poprawnie; 1 - Index > max numer wpisu */
  u32int temp;
  if (Index > GDTSMAX - 1) {
    return 1;
  }
  temp = Size;
  GDTS[Index].Size1 = temp & 0xFFFF;
  GDTS[Index].Base1 = Base & 0xFFFF;
  temp = Base;
  temp = temp & 0xFF0000;
  temp = temp >> 16;
  GDTS[Index].Base2 = temp;
  GDTS[Index].A = A;
  GDTS[Index].RW = RW;
  GDTS[Index].CE = CE;
  GDTS[Index].T = T;
  GDTS[Index].S = S;
  GDTS[Index].DPL = DPL;
  GDTS[Index].P = P;
  temp = Size;
  temp = temp & 0xF0000;
  temp = temp >> 16;
  
  GDTS[Index].Size2 = temp;
  GDTS[Index].AVL = AVL;
  GDTS[Index].Zero = 0;
  GDTS[Index].D = D;
  GDTS[Index].G = G;
  
  temp = Base;
  temp = temp & 0xFF000000;
  temp = temp >> 24;
  return 0;
}
  

void BOCHSDBGputc(uchar c) { /* Procedura wyświetla znak w konsoli BOCHS, za pomocą portu 0xE9. Przydatne do debuggowania. C - znak do wyświetlenia */
  #if DEBUG == 1 /*Sprawdza czy zadeklarowane jest makro DEBUG i czy jego wartość wynosi. Jeżeli nie wtedy wspomaganie debuggowania jest nie aktywne.
		  DEBUG zazwyczaj definiowane jest już w linii poleceń gcc (-D DEBUG=1), jednak oczywiście możliwe jest także zdefiniowanie w kodzie programu.*/
    outb(0xE9,c);
    
    
    
    
#else
    

#endif
}

void BOCHSDBGprintf(uchar text[],...) {/* Procedura wyświetla tekst w konsoli bochs za pomocą portu 0xE9. Przydatna do debugowania */
#if DEBUG == 1 /*Sprawdza czy zadeklarowane jest makro DEBUG i czy jego wartość wynosi. Jeżeli nie wtedy wspomaganie debuggowania jest nie aktywne.
		  DEBUG zazwyczaj definiowane jest już w linii poleceń gcc (-D DEBUG=1), jednak oczywiście możliwe jest także zdefiniowanie w kodzie programu.*/
    
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
	      
	      BOCHSDBGputc('0');
	      BOCHSDBGputc('x');	      
	      for (temp2=0;temp2 < strlen;temp2++) {
		BOCHSDBGputc(ArgStr[temp2]);
	      }
	      break;
	     case 'u': 
	      ArgInt = va_arg( parg,u32int);
	      strlen=IntToStr(ArgInt,ArgStr);
	      
	      for (temp2=0;temp2 < strlen;temp2++) {
		BOCHSDBGputc(ArgStr[temp2]);
	      }
	      break;
	     case 'c':
	       ArgStrP = va_arg( parg,uchar*);	       
	       for (temp2=0;ArgStrP[temp2] != '\0';temp2++) BOCHSDBGputc(ArgStrP[temp2]);
	       break;
	    default: 	      
	      BOCHSDBGputc('%');
	      BOCHSDBGputc(text[temp+1]);
	      break;
	  }
	  temp++;
	} else 
	{	  
	  BOCHSDBGputc(text[temp]);
	}
	break;
    }
  }
  va_end(parg);
#else
    
   
#endif
}

/*DO USUNIĘCIA:*/
volatile u16int SystemClockSS;