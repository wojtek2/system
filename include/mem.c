/*
 ***********************************************************************************************************
 *						mem.c						           *
 * 						Wersja:pre-alpha					   *
 * 						e-mail:Gandzia40@wp.pl					   *
 * 						2014							   *
 *********************************************************************************************************** 
 Jeden z plików wchodzących w skład jądra systemu, odpowiadający za allokację pamięci i obsługę pamięci wirtualnej.
 
 Jądro systemu pracuje w trybie chronionym, faktycznie nie wykorzystując segmentacji do rozdzielenia przestrzeni procesów,korzystając z płaskiego modelu pamięci( wszystkie segmenty używane zarówno przez system, jak i procesy użytkownika
 mają adres bazowy 0 i wielkość 4 294 967 295).
 Do segregacji pamięci procesów wykorzystywany jest mechanizm stronicowania, poprzez różne katalogi stron poszczególnych procesów.
 Pewne strony są wspólne dla całego systemu, są to strony z jądrem i niektóre strony procesów użytkownika.
 Strony jądra systemu nie podlegają przeniesieniu do pamięci SWAP.
 PDBR zawiera 1024 PDE ( elementów katalogu stron, bity 22-31 adresu logicznego).Element katalogu stron zawiera adres odpowiedniej tablicy stron, koniecznej do dalszego przetwarzania. Każdy PDE
 zawiera 1024 PTE  
 Adres PDBR zawarty jest w rejestrze CR3
 
 Adresy liniowe 0 - 10 485 760 (10 MB, 2560 stron) są zarezerwowane dla jądra, i wspólne dla każdego zadania w systemie. Są mapowane 1:1, tzn. np. adres liniowy 0x800 oznacza adres fizyczny 0x800 
 
 */




#include "data.h"



volatile u32int RAMFree=0x2000000; //Całkowita ilość wolnego miejsca w RAM Tymczasowo 32 MB
volatile u32int RAMSize=0x2000000; //Całkowita wielkość pamięci RAM Tymczasowo 32 MB
volatile u32int SwapSize; //Wielkość pamęci SWAP

volatile u32int FreeSwapSize; //Ilość wolnej pamięci wymiany
volatile u32int LinearPDBase; /*Adres liniowy katalogu stron. Odnosi się do pocżatku przestrzeni adresowej,nie do segmentu danych, więc jeżeli chcemy operować na katalogu stron za pomocą wskaźników, w adres wskaźnika należy wpisać 
                       LinearPDBase- adres bazowy segmentu danych. */
u32int FramesN=0; //Ilość ramek w tablicy FramesN                       
u32int ClosestFreeFrame=0; //Najbliższa wolna ramka względem ramki nr 0.
u32int Frames[0x20000]; //Tablica zawierajaća informację o zajętości ramek. 1 bit opisuje 1 ramkę, czyli 4 KB. Jeden wpis opisuje 32 ramki, czyli 128 KB 


void LinearAddressToPDEPTE(u32int LinearAddress,u16int *PDE,u16int *PTE,u16int *Ofs) { /*Funkcja wyodrębnia z adresu liniowego numer wpisu w katalogu stron, numer wpisu w tablicy stron, oraz offset w stosunku do początku strony. 
                                                                                         PARAMETRY: LinearAddress - adres liniowy do przetworzenia
                                                                                         ZWRACANE: *PDE - numer wpisu w katalogu stron
                                                                                                   *PTE - numer wpisu w tablicy stron
                                                                                                   *Ofs - offset */
  *PDE = (LinearAddress & 0xFFE00000) >> 0x16;
  *PTE = (LinearAddress & 0x1FF000) >> 0xC;
  *Ofs = LinearAddress & 0xFFF;
}
void ChangeFrameBit(u32int FrameN,uchar Bit) { /*Procedura ustawia bit zajętości ramki o numerze FrameN,Bit - 0 lub 1 */ 
    u32int temp;
    u32int temp2;
    u32int temp3;
    u32int temp4;
    u32int Address;
    
    /* Zmiana bitu : */     
    temp = FrameN / 32;
    temp2 = FrameN % 32;
    temp3 = Frames[temp];
    if (Bit == 1) { 
      temp3 = temp3 | (1 << temp2);
    }
    else {
      temp3 = temp3 & !(1 << temp2);
    }  
    
    Frames[temp] = temp3;
} 
uchar GetFrameBit(u32int FrameN) { /* Funkcja zwraca stan bitu zajętości ramki o numerze FrameN */
    u32int temp;
    u32int temp2;
    u32int temp3;
    u32int temp4;
    u32int Address;
    
    /* Zmiana bitu : */     
    temp = FrameN / 32;
    temp2 = FrameN % 32;
    temp3 = Frames[temp];  
    temp3 = temp3 & (1 << temp2);
    if (temp3 == 0) {
      return 0;
    } else return 1;
}
void FindClosestFreeFrameBit() { /* Funkcja wyszukuje aktualnie najbliższej wolnej ramki, i zwraca jej numer w zmiennej ClosestFreeFrame */
   u32int temp;
   u32int temp2;
   u32int temp3;
   u32int temp4;
   if (RAMFree != 0) {
    /* Poszukiwanie nowej wolnej ramki: */
      for (temp4=ClosestFreeFrame; temp4 <= FramesN; temp4++) {
      
        temp = temp4 / 32;
        temp2 = temp4 % 32;
        temp3 = Frames[temp];
        temp3 = temp3 & (1 << temp2);
        if (temp3==0) {
	  ClosestFreeFrame = temp4;
	  return 0;
        }
      }
    
      for (temp4=0; temp4 <= ClosestFreeFrame; temp4++) {
      
        temp = temp4 / 32;
        temp2 = temp4 % 32;
        temp3 = Frames[temp];
        temp3 = temp3 & (1 << temp2);
        if (temp3==0) {
	  ClosestFreeFrame = temp4;
	  return 0;
        }
      }
      return 0;
    }
    else return 0;
}
u32int SetClosestFreeFrameBit() { /* Funkcja ustawia bit zajętości aktualnie najbliższej wolnej ramki, oraz poszukuje następnej aktualnie wolnej ramki. ZWRACANE: Adres fizyczny aktualnie wolnej ramki */
    u32int temp;
    u32int temp2;
    u32int temp3;
    u32int temp4;
    u32int Address;
    
    /* Ustawienie bitu : */     
    temp = ClosestFreeFrame / 32;
    temp2 = ClosestFreeFrame % 32;
    temp3 = Frames[temp];
    temp3 = temp3 | (1 << temp2);
    Frames[temp] = temp3;
    
    Address = ClosestFreeFrame * 0x1000;
    if (RAMFree != 0) {
    /* Poszukiwanie nowej wolnej ramki: */
      for (temp4=ClosestFreeFrame; temp4 <= FramesN; temp4++) {
      
        temp = temp4 / 32;
        temp2 = temp4 % 32;
        temp3 = Frames[temp];
        temp3 = temp3 & (1 << temp2);
        if (temp3==0) {
	  ClosestFreeFrame = temp4;
	  return Address;
        }
      }
    
      for (temp4=0; temp4 <= ClosestFreeFrame; temp4++) {
      
        temp = temp4 / 32;
        temp2 = temp4 % 32;
        temp3 = Frames[temp];
        temp3 = temp3 & (1 << temp2);
        if (temp3==0) {
	  ClosestFreeFrame = temp4;
	  return Address;
        }
      }
      return Address;
    }
    else return Address;
  }
uchar AllocPsyhicalMemory(u32int PDBR,u32int PTEB,u32int Psyhical,u32int Logical,u32int Size,struct _PDE *PDEA,struct _PTE *PTEA) { /* Funkcja allokuje pamięć, jednak w przeciwieństwie do zwykłej funkcji AllocMem umożliwia określenie adresu fizycznego
															   pod którym znajdują się allokowane strony. W pamięci fizycznej allokuje ciagły obszar, jeżeli nie można zaallokować ciągłego obszaru to wtedy zgłasza błąd.
															   PARAMETRY:
															   PDBR - Adres fizyczny początku katalogu stron, inaczej rejestr CR3
															   PTEB - Adres fizyczny początku obszaru gdzie znajdują się tablice stron
															   Psyhical - Początkowy adres fizyczny
															   Logical - Początkowy adres logiczny, potrzebny do określenia katalogu stron i strony
															   PDEA - atrybuty katalogów stron
															   PTEA - atrybuty stron
															   ZWRACANE :
															   0 - OK															   
															   1 - Nie można zaallokować obszaru, gdyż ramki zawarte pod podanym adresem są już zajęte, a nie można ich przenieść do pamięci SWAP
								 							   */
  u32int temp;
  u32int temp2;
  u32int temp3;
  u16int PDEn;
  u16int PTEn;
  u32int LinearAddress;
  u32int PDEAddr;
  u32int PTEAddr;
  u16int Offset;
  struct _PDE *PDE;
  struct _PTE *PTE;
  
  
  temp2 = Psyhical + Size / 4096;
  for (temp == Psyhical / 4096;temp <= temp2; temp++) { // Pętla sprawdzająca czy podany obszar pamięci fizycznej jest wolny. Psychical % 4096 - obliczenie numeru pierwszej ramki . (Psyhical+Size) % 4096 - numer ostatniej ramki 
    if (GetFrameBit(temp) !=0) return 1;
  }
  LinearAddress = Logical;
  temp2 = Psyhical + Size / 4096;
  temp = 0;
  
  for (temp == Psyhical / 4096;temp <= temp2; temp++) { /* Pętla allokująca podany obszar. Tworzy odpowiednie struktury */
    
    ChangeFrameBit(temp,1); 
    LinearAddressToPDEPTE(LinearAddress,&PDEn,&PTEn,&Offset); // Obiczenie nr wpisu w katalogu stron, i tablicy stron
    
    PDEAddr = PDEn * 4 +PDBR; //Obliczenie adresu wpisu w katalogu stron
    /* Utworzenie wpisu w katalogu stron */
    PDE = PDEAddr;
    PDE -> P = 1;//PDEA -> P;
    PDE -> RW = PDEA -> RW;
    PDE -> US = PDEA -> US;
    PDE -> PWT = PDEA -> PWT;
    PDE -> PCD = PDEA -> PCD;
    PDE -> A = PDEA -> A;
    PDE -> Zero = 0;
    PDE -> PageSize = PDEA -> PageSize;
    PDE -> G = PDEA -> G;
    PDE -> AVL = PDEA -> AVL;
    temp3 = PTEB+PDEn*4096;
    temp3 = temp3 >> 12;
    PDE -> Base = temp3;
    
    PTE = PTEB+PTEn*4;
    PTE -> P = 1;//PTEA -> P;
    PTE -> RW = PTEA -> RW;
    PTE -> US = PTEA -> US;
    PTE -> PWT = PTEA -> PWT;
    PTE -> PCD = PTEA -> PCD;
    PTE -> A = PTEA -> A;
    PTE -> D = PTEA -> D;
    PTE -> Zero = 0;
    PTE -> G = PTEA -> G;
    PTE -> AVL = PTEA -> AVL;
    temp3 = Psyhical + PTEn*4096;
    temp3 = temp3 >> 12;
    PTE -> Base = temp3;
    //Psyhical + PTEn*4096;
    LinearAddress = LinearAddress + 4096;
    
  }
  FindClosestFreeFrameBit();
  return 0;
}
    
    
  
  
  


uchar AllocMemoryWithAttribs(u32int Task,u32int Size, struct _PDE *PDEAttribs,struct _PTE *PTEAttribs) { /* Funkcja allokuje pamięć dla podanego zadania, jeżeli niema odpowiedniej ilości wolnej pamięci
												    wtedy następuje przeniesienie odpowiedniej ilości danych z pamięci RAM do swap. Dodatkowo umożliwia podanie parametrów
												    allokowanej pamięci												    
												    PARAMETRY: Task - numer zadania, dla którego allokujemy pamięć
												               Size - wielkość allkowanej pamięci w bajtach
												               PDEAttribs,PTEAttribs - atrybuty PDE i PTE
												    ZWRACANE:
												               0 - pamięć została przydzielona
												               1 - ilość wolnej pamięci w systemie (RAM + SWAP) jest mniejsza niż porządana ilość
												               2 - Numer zadania jest więlszy niż ilość zadań w systemie */
												               
												    
  u32int Pages;    //Ilość stron(ramek) do allokacji  
  u32int temp;
  u32int PDBR;     //Adres katalogu stron zadania
  u32int PDEn,PTEn;
  struct _PDE *PDE; //Wskaźnik na aktualnie przetwarzany PDE
  struct _PTE *PTE; //Wskażnik na aktualnie przetwarzany PTE
  
  if (RAMSize+FreeSwapSize < Size) {
    return 1;
  }
  if (Task > TasksN-1) { return 2;}
  
  if (Size > RAMFree) { /* Jeżeli ilość aktualnie wolnej pamięci RAM jest mniejsza niż wymagana, trzeba część przenieść do pamęci SWAP *
  
			    /* PRZENOSZENIE DO SWAP */
  }
  if (Size == 0) return 0;
  asm("cli\n"); //Tymczasowo wyłączenie przerwań
  DisablePaging
  /*asm("movl %cr0,%eax\n" /* Tymczasowo wyłączenie stronicowania *
      "andl $0x7FFFFFFF,%eax\n" //Wyzerowanie bitu stronicowania
      "movl %eax,%cr0\n");      */
  Pages  = Size / 4096 -1; //Obliczenie ilości stron do zaalokowania  
  PDBR = Tasks[Task].PDBR;  
  PDEn = Tasks[Task].PDEsN;
  PTEn = Tasks[Task].PTEsN;
  for (temp =0; temp <= Pages ; temp++) { /*Pętla tworząca PDE i PTE */        
    if (PTEn == 1024) { /* Jak tablica stron (PDE) jest pełna, trzeba stworzyć nową tablicę stron */      
      PDE = (u32int) PDBR + PDEn*4; //Adres nowego PDE w PDBR
      PDE -> P = 1;
      PDE -> RW = PDEAttribs -> RW;
      PDE -> US = PDEAttribs -> US;
      PDE -> PWT = PDEAttribs -> PWT;
      PDE -> PCD = PDEAttribs -> PCD;
      PDE -> A = PDEAttribs -> A;
      PDE -> Zero = 0;
      PDE -> PageSize = PDEAttribs -> PageSize;
      PDE -> G = PDEAttribs -> G;
      PDE -> AVL = PDEAttribs -> AVL; 
      PDE -> Base = SetClosestFreeFrameBit() >> 12; //Znalezienie aktualnie wolnej ramki dla tablicy stron */
      PDEn++;
      PTEn = 1;
    }
    PDE = (u32int) PDBR+(PDEn-1)*4; //Adres aktualnie ostatniego PDE. w PDBR
    PTE = (PDE -> Base+(PTEn-1)*4) << 12; //Adres aktualnego PTE(aktualnej strony)
    PTE -> P = PTEAttribs -> P;
    PTE -> RW = PTEAttribs -> RW;
    PTE -> US = PTEAttribs -> US;
    PTE -> PWT = PTEAttribs -> PWT;
    PTE -> PCD = PTEAttribs -> PCD;
    PTE -> A = PTEAttribs -> A;
    PTE -> D = PTEAttribs -> D;
    PTE -> Zero = 0;
    PTE -> G = PTEAttribs -> G;
    PTE -> AVL = PTEAttribs -> AVL;
    PTE -> Base = SetClosestFreeFrameBit() >> 12; //Znalezienie aktualnie wolnej ramki dla strony
    PTEn++;
  }
  Tasks[Task].PDEsN = PDEn;
  Tasks[Task].PTEsN = PTEn;
  Tasks[Task].MemSize = Tasks[Task].MemSize + Size;
  PagingEnable      
  asm("sti\n"); //Włączenie przerwań
  return 0;
}
  
 uchar AllocMemory(u32int Task,u32int Size) { /*Funkcja allokuje pamięć dla podanego zadania, z domyślnymi atrybutami zapisanymi w Task. PDEDefault i PTEDefault. 
					     PARAMETRY: Task - numer zadania, dla którego allokujemy pamięć
					                Size - wielkość allokowanej pamięci w bajtach
					     ZWRACANE: Takie same jak w przypadku AllocMemoryWithAttribs */
  uchar temp;
  temp = AllocMemoryWithAttribs(Task,Size,&Tasks[Task].PDEDefault,&Tasks[Task].PTEDefault);
  return temp;
}   
    

  
  
  
                                   
                                     
                                     