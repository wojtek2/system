/********************************************************************************************************************************
 *						tasks.c										*
 *						Wersja: pre-alpha								*
 *						e-mail:gandzia40@wp.pl								*
 *						2014										*
 ********************************************************************************************************************************
 
 Plik zawiera niezbędne procedury i funkcje służące podstawowej obsłudze wątków i procesów, oraz zawiera planistę.
 Samo jądro nie obsługuje żadnego formatu plików wykonywalnych, wczytanie pliku wykonywalnego do pamięci leży w gestii innych części 
 systemu.
 
 */
#include "data.h"
 

u32int AddToProcessList(u32int EntryPoint,uchar PrvLevel,u32int EFLAGS,u16int SS0,u16int SS1,u16int SS2,u16int SS,u32int ESP0,u32int ESP1,u32int ESP2,u32int ESP,u16int IOMAP,u32int PDBR,u32int MaxTicks) /*Funkcja tworzy wpis w tablicy procesów.Utworzony proces ma status 2	 Parametry: 
														     EntryPoint - punkt wejścia
														     PrvLevel - poziom uprzywilejowania, 0,1,2,3
														     EFLAGS - rejestr FLAG
														     SS0 - selektor segmentu stosu, gdy program przechodzi na 0 poziom uprzywilejowania (np. wystąpienie przerwania, bądź wywołanie funkcji systemowej, furtki, itp)
														     SS1 - selektor segmentu stosu, gdy program przechodzi na 1 poziom uprzywilejowania (np. wystąpienie przerwania, bądź wywołanie funkcji systemowej, furtki, itp)
														     SS2 - selektor segmentu stosu, gdy program przechodzi na 2 poziom uprzywilejowania (np. wystąpienie przerwania, bądź wywołanie funkcji systemowej, furtki, itp)
														     SS - selektor segmentu stosu, gdy program pracuje na swoim domyślnym poziomie uprzywilejowania (zadeklarowanym w parametrze PrvLevel)
														     
														     ESP0 - zawartość rejestru ESP, gdy program przechodzi na 0 poziom uprzywilejowania (np. wystąpienie przerwania, bądź wywołanie funkcji systemowej, furtki, itp)
														     ESP1 - zawartość rejestru ESP, gdy program przechodzi na 1 poziom uprzywilejowania (np. wystąpienie przerwania, bądź wywołanie funkcji systemowej, furtki, itp)
														     ESP2 - zawartość rejestru ESP, gdy program przechodzi na 2 poziom uprzywilejowania (np. wystąpienie przerwania, bądź wywołanie funkcji systemowej, furtki, itp)
														     ESP - zawartość rejestru ESP, gdy program pracuje na swoim domyślnym poziomie uprzywilejowania (zadeklarowanym w parametrze PrvLevel)
														     IOMAP - adres tablicy zezwoleń we/wy (narazie nie wykorzystywane)
														     PDBR - wartość rejestru CR3, adres katalogu stron (aktualnie stronnicowanie nie jest wykorzystywane)
														     MaxTicks - ilość tyknięć zegara systemowego przeznaczonego dla zadania, ilość czasu CPU
													  Zwracane:  PID procesu( tymczasowo nic nie jest zwracane */
  {
   struct TSSSeg *temp;
   u32int temp2;
   TasksN++;
   Tasks[TasksN].State=1;
   Tasks[TasksN].PrvLevel = PrvLevel;
   switch (PrvLevel) {
     case 0: 
       Tasks[TasksN].TSS.CS = KernelCS ;
       Tasks[TasksN].CodeSegment = KernelCS;
       break;
     case 1:
       Tasks[TasksN].TSS.CS = Prv1CS ;
       Tasks[TasksN].CodeSegment = Prv1CS;
       break;
     case 2:
       Tasks[TasksN].TSS.CS = Prv2CS ;
       Tasks[TasksN].CodeSegment = Prv2CS;
       break;
     case 3:
       Tasks[TasksN].TSS.CS = Prv3CS;
       Tasks[TasksN].CodeSegment = Prv3CS;
       break;
   }
   
   Tasks[TasksN].DataSegment = Prv3DS;
   Tasks[TasksN].StackSegment = SS;
   Tasks[TasksN].EntryPoint = EntryPoint;      
   Tasks[TasksN].PDBR = PDBR;      
   Tasks[TasksN].TickCount = 0;   
   Tasks[TasksN].MaxTick = MaxTicks;   
   
   Tasks[TasksN-1].TSSNext = &Tasks[TasksN].TSS;
   Tasks[TasksN-1].Next = TasksN;
   Tasks[TasksN].Next = 1;
   Tasks[TasksN].TSSNext = &Tasks[1].TSS;
   
   Tasks[TasksN].TSS.Back = 0;
   Tasks[TasksN].TSS.ESP0 = ESP0;
   Tasks[TasksN].TSS.ESP1 = ESP1;
   Tasks[TasksN].TSS.ESP2 = ESP2;
   Tasks[TasksN].TSS.ESP = ESP;
   
   Tasks[TasksN].TSS.EAX = 0;
   Tasks[TasksN].TSS.EBX = 0;
   Tasks[TasksN].TSS.ECX = 0;
   Tasks[TasksN].TSS.EDX = 0;   
   Tasks[TasksN].TSS.EBP = 0;
   Tasks[TasksN].TSS.ESI = 0;
   Tasks[TasksN].TSS.EDI = 0;
   
   Tasks[TasksN].TSS.EFLAGS = EFLAGS;
   
   Tasks[TasksN].TSS.ES = Prv3DS;     
   Tasks[TasksN].TSS.DS = Prv3DS;
   Tasks[TasksN].TSS.FS = Prv3DS;
   Tasks[TasksN].TSS.GS = Prv3DS;
   Tasks[TasksN].TSS.SS0 = SS0;
   Tasks[TasksN].TSS.SS1 = SS1;
   Tasks[TasksN].TSS.SS2 = SS2;
   Tasks[TasksN].TSS.SS = SS;
   
   
   Tasks[TasksN].TSS.LDT = 0;
   Tasks[TasksN].TSS.TRAP = 0;
   Tasks[TasksN].TSS.IOMAP = IOMAP;
   Tasks[TasksN].TSS.CR3 = PDBR;
   Tasks[TasksN].TSS.EIP = EntryPoint;
   
   
   return 0;
}



void SetClockFrequency() /* Procedura ustawia częsotliwość generatora nr 0 zegara czasu rzeczywistego, czyli tego który wyzwala IRQ 0 i jest podstawą przełączania zadań oraz odmierzania czasu rzeczywistego.
			     Częstotliwość zapisana jest w stałej ClockFrequency */
  {
    #define DelayConst 1000
    uchar LSB;
    uchar MSB;
    u16int temp;
    asm("cli");
    temp = 1193180 / ClockFrequency; //Wyliczenie współczynnika podziału
    LSB = temp & 0xFF; //Wyliczenie mniej znaczącego bajtu licznika
    MSB = (temp & 0xFF00) >> 8; //Wyliczenie bardziej znaczącego bajtu licznika
    
    outb(0x43,0x34); // Rozkaz programowania układu 8254, Generator 0 ,rozkaz  zapisu mniej znaczącego bajtu licznika (LSB), tryb pracy 2
    DelayLoop(DelayConst);
    outb(0x40,LSB); // Wysłanie mniej znaczącego bajtu
    DelayLoop(DelayConst);
    /*outb(0x43,0x24); // Rozkaz programowania układu 8254, Generator 0 ,rozkaz  zapisu bardziej znaczącego bajtu licznika (MSB), tryb pracy 2
    DelayLoop(DelayConst);*/
    outb(0x40,MSB); // Wysłanie bardziej znaczącego bajtu
    DelayLoop(DelayConst);
    /*outb(0x43,0x4); */
    
  }

uchar CallToTask(u32int TaskN) /* Funkcja dokonuje przeskoku do zadania podanego w parametrze TaskN. Następuje przełączenie zadania podobnbe do tego, jakie następuje w procedurze SystemClock. Procesor podejmie wykonanie od pierwszej instrukji procesu
				  ZWRACANE: 0 - OK
					    1 - Numer zadania podany w TaskN jest większy niż ilość wszystkich zadań (TasksN)					    
					    */
{
  struct TSSSeg *temp;
  u16int temp2;
  if (TaskN > TasksN) {
    return 1;
  }
  else
  {
  
  }
  return 0;
}


void SystemClock() /* Procedura zegara systemowego, jest wektorem IRQ 0. Obsługuje zegar czasu rzeczywistego oraz wywołuje planistę krótkoterminowego                       
                      
                      Przełączanie będzie odbywać się z pominięciem sprzętowego mechanizmu TSS, za pomocą operacji stosowych pusha, popa, push i pop, oraz z wykorzystaniem
                      dalekiego powrotu z przerywania. Ze względu na optymalizację, większość kodu tej procedury zostanie zapisana w Assemblerze.
                      */
{ 
  //BOCHSDBG
  asm("cli\n" 
      "movl %esp,SystemClockESP\n" //Zachowanie rejestru ESP w zmiennej tymczasowej
      
      "movw %ss,%sp\n" //TYMCZASOWO!!!:Zmiana selektora segmentu stosu na selektor stosu jądra
      "movw %sp,SystemClockSS\n"
      "movw $0x18,%sp\n"
      "movw %sp,%ss\n"
      
      "movl ActTaskTSS,%esp\n"  
      "addl $72,%esp\n" //W ESP, adres w TSS gdzie za pomocą pusha zachowamy rejestry ogólnego przeznaczenia
      "pusha \n" //Zachowanie rejestów ogólnego przeznaczenia
      
      "movw SystemClockSS,%sp\n" //TYMCZASOWO!!!: Odtworzenie selektora segmentu stosu
      "movw %sp,%ss\n"
      
      "movl SystemClockESP,%esp\n" //Odtworzenie ESP
      "movl ActTaskTSS,%eax\n"
      "cmpb $0,ActTaskPrvLevel\n" // Jeżeli poziom uprzywilejowania przerywanego wątku jest taki sam jak tej procedury, ESP  przerwanego wątku nie jest pobierany ze stosu, a trzeba go wyliczyć ręcznie       
      "jne SystemClockSaveStateGetESPFromStack\n"
      "movl %esp,%ebx\n"  
      /* W NAWIASIE WARTOŚCI PRAWIDŁOWE, PO USUNIĘCIU EditGDTEntry */
      "addl $24,%ebx\n" //W EBX ESP przerwanego wątku (16)
      "jmp SystemClockSaveStateNext\n"
      
      "SystemClockSaveStateGetESPFromStack:\n"
      "movl 24(%esp),%ebx\n" //W EBX esp przerwanego wątku (16)
      "SystemClockSaveStateNext:\n"
      "movl %ebx,84(%eax)\n" // Zapisanie w TSS ESP przerwanego programu
      "movl 8(%esp),%ebx\n" // W EBX EBP programu (0)
      "movl %ebx,48(%eax)\n" //Zachowanie EBP w TSS
      "movl 12(%esp),%ebx\n" //W EBX EIP przerwanego wątku (4)
      "movl %ebx,72(%eax)\n" //Zachowanie EIP w TSS
      
      
      
  );
  
  ActTaskTSS = Tasks[ActTaskN].TSSNext;
  ActTaskN = Tasks[ActTaskN].Next;
  ActTaskPrvLevel = Tasks[ActTaskN].PrvLevel;
  /*TYMCZASOWO: */
  EditGDTEntry(5,sizeof(Tasks[ActTaskN].TSS),(u32int) &Tasks[ActTaskN].TSS,1,0,0,1,0,0,1,0,1,0);
  asm("movw $0x28,%ax\n"       
      "ltr %ax\n");
  /*Odtworzenie stanu następnego zadania */
  asm("movw %ss,%sp\n" //TYMCZASOWO!!!:Zmiana selektora segmentu stosu na selektor stosu jądra
      "movw %sp,SystemClockSS\n"
      "movw $0x18,%sp\n"
      "movw %sp,%ss\n"
      
      "movl ActTaskTSS,%esp\n"
      "addl $40,%esp\n" //Przygotowanie ESP do przywrócenia rejestów ogólnego przeznaczenia
      "popa\n" //Przywrócenie zawartości rejestrów ogólnego przeznaczenia
      
      
      
      "cmpb $0,ActTaskPrvLevel\n"  /* W zależności od poziomu uprzywilejowania wznawianego procesu, wybór metody przywrócenia rejestrów EIP,CS,EFLAGS,ESP,SS i skoku.
				     Jak poziom uprzywilejowania jest różny od 0, procedura jest dużo prostrza, sprowadza się do wykonania rozkazu iret.
				     A jak poziom uorzywilejowania wynosi 0, proces ten jest bardziej skomplikowany */
       
      "je SystemClockRestoreStateWithoutChangePrvLevel\n"
      "movl %eax,SystemClockEAX\n" 
      "movb $0x20,%al\n"
       "outb %al,$0x20\n" //EOI
       
       "movl SystemClockEAX,%eax\n"
       
      "iret\n" //Powrót z przerywania. Skok do zadania ze zmianą poziomu uprzywilejowania
       "SystemClockRestoreStateWithoutChangePrvLevel:\n" // Skok do zadania bez zmiany poziomu uprzywilejowania       
       "movl %eax,SystemClockEAX\n" 
       "addl $8,%esp\n" //Dodanie 8 do ESP powoduje, że ESP teraz wskazuje na EFLAGS odtwarzanego programu
       "popfl\n" //Wpisanie do rejestru EFLAGS przerwanego programu
       
       "movl -12(%esp),%eax\n" //Pobranie adresu do skoku
       
       
       "movl 4(%esp),%eax\n" //W EAX SS odtwarzanego zadania
       
       "popl %esp\n" // Odtworzenie %ESP
       "movl %eax,%ss\n" //Odtworzenie %SS
       
       "movb $0x20,%al\n"
       "outb %al,$0x20\n" //EOI
       
       
       
       
       
       "movl SystemClockEAX,%eax\n"
       
      
       
       "jmp *-12(%esp)\n"); //I Skok
}





