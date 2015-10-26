/*
 ***************************************************************************************
 *					data.h				       *
 * 					Wersja: pre-alpha			       *
 * 					e-mail:gandzia40@wp.pl			       *
 * 					2014					       *
 ***************************************************************************************
 Plik nagłówkowy zawierający definicje podstawowych typów danych, makr i struktur wykorzystywanych w całym jądrze.
 */


/*Makra:*/

 #if DEBUG == 1 /*Sprawdza czy zadeklarowane jest makro DEBUG i czy jego wartość wynosi. Jeżeli nie wtedy wspomaganie debuggowania jest nie aktywne.
		  DEBUG zazwyczaj definiowane jest już w linii poleceń gcc (-D DEBUG=1), jednak oczywiście możliwe jest także zdefiniowanie w kodzie programu.*/
    
    
    
    #define BOCHSDBG asm volatile ("xchg %bx,%bx\n #BOCHS DEBUG"); /*Powoduje zatrzymanie emulatora Bochs i przejście do debuggera */
    
    
#else
    #define BOCHSDBG 	

#endif
#define DisablePaging asm("pushl %eax \n movl %cr0,%eax\n  andl $0x7FFFFFFF,%eax\n movl %eax,%cr0\n popl %eax"); // Makro wyłącza stronnicowanie
#define PagingEnable asm("pushl %eax \n movl %cr0,%eax\n  or $0x80000000,%eax \n movl %eax,%cr0 \n popl %eax"); // Makro włącza stronnicowanie      
            
#define HALT asm("cli\nhlt # BOCHS DEBUG"); /*Zawiesza komputer lub emulator */
#define SetCallStack(xxx) OldCallStack = CallStack;   /*Makro zmienia wartość zmiennej CallStack(stosu wywołań procedrur systemowych), zachowując poprzednią wartość.Musi znajdować się na początku funkcji. */	\
                          CallStack = xxx;         \  
                          
#define ReturnCallStack   CallStack = OldCallStack;   /*Makro przywraca wartość zmiennej CallStack(stosu wywołań procedrur systemowych) po zakończeniu pracy funkcjii. Musi znajdować się na końcu kodu funkcji. */


		       
			 
			 
#define PIC_EOI		0x20 //Rozkaz wysyłany do PIC informujący o zakończeniu obsługi przerywania sprzętowego

					 
                              
#define GDTSMAX 256 //Maksyamalna ilość wpisów w tablicy GDT. Musi być większa niż 1, gdyż pierwszy wpis to tzw. Null Descriptor
#define IDTSMAX 256 //Maksyamalna ilość wpisów w tablicy IDT. Maksymalna ilość przerwań obsługiwana przez jądro.
#define TASKMAX 0xA //Wielkość tablicy zadań
#define ClockFrequency 10 // Częstotliwość zegara systemowego. Zgear ten odpowiada za przełączanie zadań i odmierzanie czasu rzeczywistego 
#define SizeOfTaskEntry i // Wielkość wpisu w tablicy Tasks

#define KernelSS 0x18 //Selektor segmentu stosu dla kodu o poziomie uprzywilejowania 0 ( jądra) 
#define KernelCS 0x8 //Selektor segmentu kodu dla poziomu uprzywilejowania 0
#define Prv1CS 0x31 //Selektor segmentu kodu dla poziomu uprzywilejowania 1
#define Prv2CS 0x3A //Selektor segmentu kodu dla poziomu uprzywilejowania 2
#define Prv3CS 0x43 //Selektor segmentu kodu dla poziomu uprzywilejowania 3
#define Prv3DS 0x13 //Selektor segmentu danych dla całego systemu, posiada poziom uprzywilejowania 3

#define KernelSpaceEndAddress 10485760 //Wielkość pamięci zarezerwowanej dla jądra (jej końcowy adres, bo zaczyna się od 0, (10 MB, 2560 stron)). Są mapowane 1:1, tzn. np. adres liniowy 0x800 oznacza adres fizyczny 0x800   
/* Deklaracje podstawowych typów danych : */
typedef unsigned short u16int; /* u16int - 16 bitowa ca³kowita bez znaku */
typedef signed short int s16int; /* 16 bitowa ca³kowita ze znakiem */
typedef signed char schar; // 8 bitowa ze znakiem
typedef unsigned char uchar; /* 8 bitowa ze bez znaku */
typedef unsigned int u32int; /*32 bitowa ca³kowita bez znaku */
typedef signed int   s32int; /*32 bitowa ca³kowita ze znakiem*/

/*Definicje struktur: */

struct _Frames { /* Struktura opisująca ramki, konieczna do obsługi pamięci wirtualnej */
  u32int Base; //Adres bazowy ramki
  uchar Free; //1 - ramka wolna - 0 ramka zajęta i stronę w ramce trzeba przenieść do pamięci Swap
};
struct _GDTS { /* Struktura definiuj¹ca wpis w tablicy segmentów GDT */
  u16int  Size1; //Limit segmentu bity (15..0),je¿eli Size1 i Size2 = 0 wtedy segment jest wolny 
  u16int  Base1; // Baza segmentu bity (15..0) 
  uchar   Base2; 
  
  u16int   A:1;
  u16int   RW:1;
  u16int   CE:1;
  u16int   T:1;
  u16int   S:1;
  u16int   DPL:2;
  u16int   P:1;  
  
  u16int   Size2:4;
  u16int   AVL:1;
  u16int   Zero:1;
  u16int   D:1;
  u16int   G:1;
  uchar Base3;  
};

struct _IDTS { /*Struktura wpisu w tablicy IDT */
  u16int  Offset1; /* Bity 15..0 offsetu procedury obs³ugi przerywania w segmencie */
  u16int  Selector; /* 16 bitowy selektor segmentu z procedur¹ obs³ugi przerywania */
  uchar   Zero;  //Zawsze musi być 0!!!
  u16int  W:1;   //0 - deskryptor dotyczy furtki przerywania, 1- pułapki
  u16int  MB3:2;  //Musi być 3 !!!
  u16int  D:1;    //Tryb pracy procesora przy obsłudze przerywania lub pułapki ( 0- 16 bitowy procesorów 80286 1- 32 bitowy 80386 lub lepszych)
  u16int  Zero2:1; //Musi być 0
  u16int  DPL:2; //Poziom uprzywilejowania
  u16int  P:1;    //Bit określa czy segment w ktróym zawarty jest program obsługi przerywania jest obecny w pamięci czy też nie     
  u16int  Offset2; /* Bity 31..16 offsetu */
};

struct _GDTDescr { /*Struktura psedudodeskryptora GDT */
  u16int  Size; /* Wielkoæ GDT w bajtach. Wzór do obliczenia: iloæ wpisów*8-1 */
  u16int  AddrL; /* M³odsze 16 bitów adresu fizycznego tablicy GDT */
  uchar  AddrH; /* Starsze 16 bitów adresu fizycznego tablicy GDT */
};

struct _IDTDescr { /*Struktura psedudodeskryptora IDT */
  u16int  Size; /* Wielkość IDT w bajtach. Wzór do obliczenia: iloæ wpisów*8-1 */
  u16int  AddrL; /* M³odsze 16 bitów adresu fizycznego tablicy IDT */
  uchar  AddrH; /* Starsze 16 bitów adresu fizycznego tablicy IDT */
};


   
struct TSSSeg { /* Struktura służąca do operowania na segmentach stanu zadania,nie jest całkowicie kompatybilna z sprzętowym TSS w procesorach(została zamieniona
  kolejność rejestrów ogólnego przeznaczenia), ponieważ w systemie przełączanie zadań odbywa się na bardziej na drodze programowej, jednak
  struktura ta musi być utrzymywana ze względu na to że jest potrzebna podczas zmiany poziomu uprzywilejowania aktualnie wykonywanego kodu. Podczas zmiany poziomu
  uprzywilejowania pod uwagę brane są tylko pola od ESP0 do SS2 i SS3, zawartość reszty może być dowolna. Przełączanie zadań bez zmiany poziomu uprzywilejowania będzie odbywać się za poomocą
  rozkazów stosu pusha, popa, push i pop i trzeba było dostosować strukturę do rozkazu pusha*/
  u32int Back;  //Selektor TSS poprzedniego zadania
  u32int ESP0;  //Wierchołek stosu zadania w 0 poziomie uprzywilejowania
  u32int SS0;  //Selektor stosu zadania w 0 poziomie uprzywilejowania
  u32int ESP1;  //Wierchołek stosu zadania w 1 poziomie uprzywilejowania
  u32int SS1;  //Selektor stosu zadania w 1 poziomie uprzywilejowania
  u32int ESP2;  //Wierchołek stosu zadania w 2 poziomie uprzywilejowania
  u32int SS2;  //Selektor stosu zadania w 2 poziomie uprzywilejowania
  u32int CR3; 
  u32int ES;
  
  
  u32int FS; //10
  
  u32int EDI; 
  u32int ESI;
  u32int EBP;
  
  u32int DS; //Ta wartość jest ignorowana. W całym systemie wartość DS jest taka sama
  u32int EBX; 
  u32int EDX;
  u32int ECX;
  u32int EAX; //18
    
  u32int EIP; //19, bajt 72
  u32int CS;
  u32int EFLAGS; 
  u32int ESP; 
  u32int SS;
  u32int GS;
  u32int LDT; //W systemie nie wykorzystywane,25 pozycja, bajt 100
  u16int TRAP; //Bit pracy krokowej przeznaczony dla debuggerów.Jeżeli wynosi 1, wtedy po przełączeniu zadania wywoływany jest wyjątek nr 1 //27
  u16int IOMAP; //Adres względny tablicy zezwoleń we/wy //29
};
struct _Regs { /* Struktura służąca do przechowywania zawartości rejestórw w przypadku wystąpenia wyjątku celem wyświetlenia ich zawartości */
  u32int ES;
  
  
  u32int FS; 
  
  u32int EDI; 
  u32int ESI;
  u32int EBP;
  
  u32int DS; //Ta wartość jest ignorowana. W całym systemie wartość DS jest taka sama
  u32int EBX; 
  u32int EDX;
  u32int ECX;
  u32int EAX; //Pozycja nr 10 
    
  u32int EIP; //Offset instrukcji która wywołała wyjątek, pozycja nr 11
  u32int CS;
  u32int EFLAGS; 
  u32int ESP; //Pozycja nr 14
  u32int SS;
  u32int GS;
  
  u16int TRAP; //Bit pracy krokowej przeznaczony dla debuggerów.Jeżeli wynosi 1, wtedy po przełączeniu zadania wywoływany jest wyjątek nr 1 //27
  u16int IOMAP; //Adres względny tablicy zezwoleń we/wy //29
  u32int CR0;
  u32int CR1;
  u32int CR2;
  u32int CR3;
  u32int CR4;      
  u32int ErrorCode; //Kod błędu zawierający dodatkowe informacje
};



struct _PDE { /*Strukrura opisująca wpis w katalogu stron */
  u16int P:1; //Bit ten określa czy tablica stron jest dostępna
  u16int RW:1; //Jeżeli bit jest ustawiony, zapis do tej grupy stron jest możliy tylko gdy kod ma poziom uprzywilejowania superwisor( bit U/S=0) i gdy bit WP w cr0 wynosi 0. W przeciwnym wpdaku zapis do tych stron jest możliwy przez program o uprzywilejowaniu user
  u16int US:1; //Bit określa poziom uprzywilejowania stron w tej tablicy, 0 - poziom najwyższy 1 - poziom użytkownika
  u16int PWT:1; //Alogrytm pracy pamięci podręcznej
  u16int PCD:1;
  u16int A:1; //Bit ten jest ustawiany przez procesor jeżeli doszło do odwołania do tablicy stron wksazywanej przez to PDE.
  u16int Zero:1; //Zawsze 0
  u16int PageSize:1; //0 - storny o rozmiarze 4 KB,1 - strony o rozmiarze 4 MB( dla stornicowania 32 bitowego) lub @MB ( dla stronicowania z rozszerzonym adresie fizycznym)
  u16int G:1; //Bit ma znaczenie wtedy gdy jest ustawiony bit PGE w CR4, jeżeli bit wynosi 1 wtedy wpis PDE istniejący w tablicy TLB nie zostanie usunięty
  u16int AVL:3; // 7 - wpis jest prawidłowy, a katalog stron dosŧpny  
  u32int Base:20; // 20 starszych bitów strony w której znajduje się tablica stron
};

struct _PTE { /*Struktura opisująca stronę pamięci */
  u16int P:1; //Bit ten określa czy strona jest dostępna
  u16int RW:1; //Jeżeli bit jest ustawiony, zapis do tej  strony jest możliy tylko gdy kod ma poziom uprzywilejowania superwisor( bit U/S=0) i gdy bit WP w cr0 wynosi 0. W przeciwnym wpdaku zapis do strony jest możliwy przez program o uprzywilejowaniu user
  u16int US:1; //Bit określa poziom uprzywilejowania strony, 0 - poziom najwyższy 1 - poziom użytkownika
  u16int PWT:1; //Alogrytm pracy pamięci podręcznej
  u16int PCD:1;
  u16int A:1; //Bit ten jest ustawiany przez procesor jeżeli doszło do odwołania do stron wksazywanej przez to PTE.
  u16int D:1; //Bit określa rodzaj odwołania do strony,  0 - operacja odczytu 1 - operacja zapisu
  u16int Zero:1; //Zawsze 0
  u16int G:1; //Bit ma znaczenie wtedy gdy jest ustawiony bit PGE w CR4, jeżeli bit wynosi 1 wtedy wpis PDE istniejący w tablicy TLB nie zostanie usunięty
  u16int AVL:3;
  u32int Base:20; // 20 starszych bitów adresu początku ramki
}PTE;
struct _Tasks { /* Struktura przechowuje informacje na temat procesów */
  u32int PID;  //Numer ID procesu  
  u32int EntryPoint; //Punkt wejścia do procesu (gównego wątku procesu)
  u16int CodeSegment; //Selektor segmentu kodu głównego wątku procesu
  u16int DataSegment; //Selektor segmentu danych głównego wątku procesu
  u16int StackSegment; //Selektor segmentu stosu głównego wątku procesu
  uchar State; //Stan procesu. 0 - proces pracuje normalnie,1 - proces w trakcie tworzenia  2- proces zawieszony 3 - proces zombie 
  uchar TickCount; //Zmienna zawiera ilość wykonanych kwantów czasu procesora . Jeżeli przekroczy ustaloną wartość wtedy zadanie zostanie przełączone
  uchar MaxTick; //Liczba kwantów czasu procesora po przekroczeniu której następuje przełączenie zadania.
  uchar PrvLevel; //Domyślny poziom uprzywilejowania
  
  struct TSSSeg TSS; //"Segment" stanu zadania, TSS
  
  struct TSSSeg *TSSNext; //Adres bazowy segmentu stanu następnego zadania       
  struct _PDE PDEDefault; //Domyślne parametry dla tablic stron
  struct _PTE PTEDefault; //Domyślne parametry dla stron
  u32int Next; //Index następnego zadania
  u32int PDBR; // Fizyczny adres katalogu stron,inaczej 20 najstarszych bitów rejestru CR3
  u16int PDEsN; // Ilość wpisów w katalogu stron (liczone od 1)
  u16int PTEsN; //Ilość wpisów w akutalnie ostatnim PDE (liczone od 1)
  u32int MemSize; //Całkowita wielkość pamięci przydzielona zadaniu (całkowity dostępny adres liniowy)
  
}; //UWAGA!!! : PRZY KAŻDEJ ZMIANIE TEJ STRUKTURY, NALEŻY WYLICZYĆ JEJ WIELKOŚĆ I ZMIENIĆ STAŁĄ SizeOfTaskEntry !!! UWAGA !!!

/*extern:*/
/*struktury:*/
extern struct _GDTS GDTS[GDTSMAX]; //Tablica GDT
extern struct _IDTS IDTS[IDTSMAX]; //Tablica IDT
extern struct _GDTDescr GDTDescr; //pseudodeskryptor GDT
extern struct _IDTDescr IDTDescr; //pseudodeskryptor IDT
extern struct TSSSeg *ActTaskTSS; //Wskaźnik do segmentu stanu aktualnie wykonywanego zadania
extern volatile struct TSSSeg KernelTSS;  //Segment stanu zadania 0 



extern volatile struct _PDE KernelPDE __attribute__((section( ".KernelPDESect" )aligned(0x2000)));  //__attribute__((section (".KernelPDESect"))); //Wpis z katalogiem stron użytkowanym przez jądro, tymczasowo przez proces init i cały system
extern volatile struct _PTE KernelPTEs[0x200];  //__attribute__((section (".KernelPTESect"))); //Tablica z stronami zajmowanymi przez system, tymczasowo przez proces init i cały system.*/

/*zmienne globalne:*/
/*Zmienne globalne:*/
extern u16int GDTC; //Ilość wpisów w tablicy GDT

extern u32int Frames[0x20000]; //Tablica zawierajaća informację o zajętości ramek. 1 bit opisuje 1 ramkę, czyli 4 KB. Jeden wpis opisuje 32 ramki, czyli 128 KB 
extern u32int Pages[0x20000]; //Tablica zawierająca informację o stronach przeniesionych do pamięci SWAP
extern struct _Tasks Tasks[0xA]; // Tablica zawierająca podstawowe informacje na temat procesów. Wpis nr 0 nie jest procesem -> są to informacje na temat jądra systemu,
 

extern u32int FramesN; //Ilość ramek w tablicy FramesN
extern u32int ClosestFreeFrame; //Najbliższa wolna ramka względem ramki nr 0.



extern volatile u32int RAMSize; //Całkowita wielkość pamięci RAM
extern volatile u32int RAMFree; //Całkowita ilość wolnego miejsca w RAM
extern volatile u32int FreeSwapSize; //Ilość wolnego miejsca w pamięci wirtualnej

extern volatile u16int KernelSegment; // w Trybie rzeczywistym zawiera segment w którym znajduje się jądro systemu, naotmiast w trybie chronionym jego selektor
extern volatile u16int KernelSegmentInRM; //Segment jądra w trybie rzeczywistym
extern volatile u16int KernelBase; //Adres fizyczny jądra, KernelSegmentInRM*0x10

extern  uchar  KernelState; // Stan pracy jądra. 0 - preinit -po wczytaniu a przed zainicjowaniem, 16 bitowy tryb rzeczywisty
extern  u16int OldCallStack; //Poprzednia wartość zmiennej CallStack
extern  u16int CallStack; //Stos wywołań procedur systemowych. Zawiera numer aktualnie wykonywanej procedury systemowej.
extern volatile u32int TasksN; //Aktualna ilość procesów.
extern volatile u32int ActTaskN; //Numer aktualnie wykonywanego zadania w tablicy procesoów
extern volatile u32int SwapSize; //Wielkość pamęci SWAP

extern volatile uchar ActTaskPrvLevel; // Poziom uprzywilejowania aktualnie wykonywanego zadania. 0 - poziom najwyższy (jądra), 3 - najniższy


extern volatile u32int ActTaskTickCount; //Licznik kwantów czasu aktualnego zadania
extern volatile u32int ActTaskMaxTick;  //Ilość kwantów czasu aktualnego zadania

extern uchar TextColor; 
extern uchar CurX; /*Pozycja kursora na ekranie */
extern uchar CurY;

/*Zmienne przechowujące wartości tymczasowe:*/
extern volatile u32int SystemClockEAX; //Zmienna tymczasowo przechowuje wartość rejestru EAX podczas przełączania zadania

extern volatile u32int SystemClockESP; //Zmienna tymczasowo przechowuje zawartość rejestru ESP podczas przełączania zadania

/*procedury:*/

extern void ChangeFrameBit(u32int FrameN,uchar Bit);  /*Procedura ustawia bit zajętości ramki o numerze FrameN,Bit - 0 lub 1 */ 
extern uchar AllocPages(u32int Task,u32int LinearBaseAddress,struct _PDE *PDEAttributes,struct _PTE *PTEAttributes,u16int PagesN);
extern void kprintf(uchar text[],...); /* Standardowa procedura printf z biblioteki stdio.Działa zarówno w trybie rzeczywistym jak i chronionym */
extern void inline EmptyInterrupt();

extern void SystemClock();
/*DO USUNIĘCIA:*/
extern u32int SetClosestFreeFrameBit();
extern volatile struct _PDE KernelPDEA;
extern volatile struct _PTE KernelPTEA;
extern volatile u16int SystemClockSS;