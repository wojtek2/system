/*
 ***************************************************************************************
 *					exceptions.c				       *
 * 					Wersja: pre-alpha			       *
 * 					e-mail:gandzia40@wp.pl			       *
 * 					2014					       *
 ***************************************************************************************
 Plik zawiera procedury obsługujące wyjątki i błedy występujące podczas pracy jądrą i aplikacjii użytkowych. Zawiera również tymczasowo procedurę krenel panic,
 która tak jak w linuxie wywoływana jest podczas wsytąpienia wyjątku w pracy jądra, wyświetlająca komunikat i szczegółowy stan systemu, wykonuje inne procedury sygnalizacyjne i zawiesza system.
 */

#include "data.h"



void DivBy0Exception(u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS)  { /*Procedura obsługi wyjątku, podane parametry są odkładane na stos automatycznie poprzez CPU.													      
											       SS,ESP - parametr, których należy używać tylko w przypadku gdy, poziom uprzywilejowania odczytywany z parametru CS jest różny od 0,
											       W przeciwnej możliwości ESP należy wyliczyć ręcznie.
											       
											       Obsługa błedu dzielenia przez 0. Numer przerywania:0 */
  u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = 0;
 
  KernelPanic(Regs,"Divide by 0");
  HALT
  
}
void OffsetTooLargeException(u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS) {/* Ten wyjątek jest generowany, gdy podany offset przekracza granicę segmentu.Numer przerywania:5 */
 u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = 0;
 
  KernelPanic(Regs,"Offset to large exception");
  HALT
}
void UnknowInstruction(u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS) { /*Wyjątek wysŧepuje gdy procesor podczas wykonywania kodu napotka na niedozwolony kod rozkazu.Numer przerywania:6 */
 u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = 0;
 
  KernelPanic(Regs,"Unknown instruction");
  HALT  
}
void DoubleFault(u32int ErrorCode,u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS) { /*Jest to wyjątek podwójnego błędu, występuje gdy podczas przekazywania sterowania do obsługi jakiegoś wyjątku pojawi się inny wyjątek.
                       Przykładowo jeżeli podczas wykonywania programu procesor napotka na nieobecny segment / stronę, generuje wyjątek, a kod obsługujący ten wyjątek również jest nieobecny w pamięci
                       procesor generuje wyjątek podwójnego błędu (DoubleFault) Jeżeli i podczas generowania wyjątku podwójnego błedu nastąpi jakiś wyjątek, wtedy wystąpi zjawisko
                       potrójnego błędu (Triple Fault) a procesor wygeneruje sprzętowy sygnał RESET i nastąpi reset komputera. Triple fault można użyć do obsługi procedury resetującej komputer, 
                       jest to znacznie prostsze niż użycie kontrolera klawiatury. Numer przerywania:8 */ 
   u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = ErrorCode;
 
  KernelPanic(Regs,"Double fault exception");
  HALT
}

void TSSException(u32int ErrorCode,u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS) { /* CPU generuje ten wyjątek, jeżeli podczas przełączania zadania wystąpi błąd podczas operowania na segmencie TSS zadania.Numer przerywania:10 */
   u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = ErrorCode;
 
  KernelPanic(Regs,"TSS Exception");
  HALT
}

void SegNotPresentException(u32int ErrorCode,u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS) {/* Brak segmentu. Numer przerywania:11 */
   u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = ErrorCode;
 
  KernelPanic(Regs,"Segment not present exception");
  HALT
}

void SSException(u32int ErrorCode,u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS) { /* Wyjątek generowany z powodu błędnych operacji w segmencie stosu (np segmentu stosu nie ma w pamięci ) Numer przerywania:12 */
   u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = ErrorCode;
 
  KernelPanic(Regs,"SS exception");
  HALT
}
void GeneralProtectionException(u32int ErrorCode,u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS) { /* Wyjtek generowany gdy wystąpi naruszenie mechanizmu ochrony. Naruszeniem mechanizmu ochrony nzaywamy grupę błędów:
				    Próbę wykoniania rozkazu niedozwolnego w aktualnym poziomie uprzywilejowania; Próbę bezpośredniego odwołania się do segmentu o wyższym poziomie uprzywilejowania (niższym DPL) Numer przerywania:13*/
   u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = ErrorCode;
 
  KernelPanic(Regs,"General protection exception");
  HALT
}
void PageFaultExceptopn(u32int ErrorCode,u32int EIP,u32int CS,u32int EFLAGS,u32int ESP,u32int SS) {
   u32int TempESP;
  u32int TempEBP;
  u32int CR0;
  u32int CR2;
  u32int CR3;
  u32int CR4;
  
  u32int Nothing;
  struct _Regs Regs;													      
  BOCHSDBG 
  
  asm("cli\n");   
  asm("subl $4,%ebp\n");
  
  asm("movl %%esp,%[TempESP]\n"
      "leal 40%[Regs],%%esp\n" //W ESP adres w Regs gdzie zachowujemy rejestry ogólnego przeznacznenia
      "pusha \n" //Zachowanie rejestrów ogólnego przeznaczenia
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP
      "movl 96(%%esp),%%esp\n"
      "movl %%esp,%[TempEBP]\n" //Zachowanie EBP programu który spowodował błąd
      "movl %[TempESP],%%esp\n" //Przywrócenie ESP      
      :
      : [Regs] "m" (Regs), [TempESP] "m" (TempESP), [TempEBP] "m" (TempEBP)
      :);
  if (CS & 3 != 0) {
    Regs.SS = SS;
    Regs.ESP = ESP;
  } else
  {
    Regs.SS = KernelSS;
    asm("movl %%esp,%[TempESP]\n"
        "addl $128,%[TempESP]\n"
        :
        :[TempESP] "m" (TempESP)
        :);
    Regs.ESP = TempESP;
  }
  Regs.EFLAGS = EFLAGS;
  asm("movl %%cr0,%%eax\n"
      "movl %%eax,%[CR0]\n"
      "movl %%cr2,%%eax\n"
      "movl %%eax,%[CR2]\n"
      "movl %%cr3,%%eax\n"
      "movl %%eax,%[CR3]\n"
      "movl %%cr4,%%eax\n"
      "movl %%eax,%[CR4]\n"
      :
      : [CR0] "m" (CR0), [CR2] "m" (CR2), [CR3] "m" (CR3), [CR4] "m" (CR4)
      :"%eax");
  Regs.CR0 = CR0;
  Regs.CR2 = CR2;
  Regs.CR3 = CR3;
  Regs.CR4 = CR4;
  Regs.CS = CS;
  Regs.EIP = EIP;
  Regs.DS = Prv3DS;
  Regs.ES = Prv3DS;
  Regs.GS = Prv3DS;
  Regs.FS = Prv3DS;
  Regs.ErrorCode = ErrorCode;
 
  KernelPanic(Regs,"Page fault exception");
  HALT}/* Brak strony. Numer przerywania:14 */

void KernelPanic(struct _Regs Regs, uchar Message[]) { /* Legendarna procedura, która wywoływana jest podczas wystąpienia błędu w pracy jądra. Wyświetla komunikat, dodatkowe parametry,miejsce wystąpienia błędu,stan rejestrów, stan danych systemowych,itp, następnie zawiesza system    */
  u16int temp,temp2;  
  u32int *temp3;        
  
  ClearScreen();
  kprintf("Kernel panic!!!%c in kernel area at: %x:%x.\n\rCall stack:%x.\n\rRegisters:\n\r",Message,Regs.CS,Regs.EIP,CallStack);
  kprintf("Error code: %x\n\r",Regs.ErrorCode);
  kprintf("EAX: %x  EBX: %x  ECX: %x \n\r",Regs.EAX,Regs.EBX,Regs.ECX);
  kprintf("EDX: %x  ESI: %x  EDI: %x \n\r",Regs.EDX,Regs.ESI,Regs.EDI);
  kprintf("EBP: %x  ESP: %x  EFLAGS: %x  \n\r",Regs.EBP,Regs.ESP,Regs.EFLAGS);
  kprintf("Segment registers:\n\r");
  kprintf("CS: %x DS: %x ES: %x \n\r",Regs.CS,Regs.DS,Regs.ES);
  kprintf("SS: %x GS: %x FS: %x \n\r",Regs.SS,Regs.GS,Regs.FS);
  kprintf("Control registers (CRx):\n\rCR0: %x CR1: Reserved CR2: %x CR3: %x CR4: %x\n\r",Regs.CR0,Regs.CR2,Regs.CR3,Regs.CR4);
  
  kprintf("Task state register: 5 \n\r");
 
  temp3 = 0;
  BOCHSDBG  
  kprintf("System halted!!!\n\r");  
  asm("cli\n"
      "hlt\n");
  
}
void SetExceptions() { /*Procedura inicjuje obsługę wyjątków, poprzez wpisanie odpowiednich wartości do tablicy IDT 
			 Numer funkcji: 8*/
  u32int temp2;
  SetCallStack(8)
  
  /*for (temp=0;temp != 100;temp++) {*
    
  IDTS[temp].Offset1 = &DivBy0Exception; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[temp].Selector = 0x8; //Selektor segmentu jądra
  IDTS[temp].Zero = 0;
  IDTS[temp].W=0;
  IDTS[temp].MB3=3;
  IDTS[temp].D=1;
  IDTS[temp].Zero2 = 0;
  IDTS[temp].DPL = 0;
  IDTS[temp].P = 1;
  IDTS[temp].Offset2 = 0;
  //}*/
  temp2 = (u32int) & DivBy0Exception;
  IDTS[0].Offset1 = temp2 & 0xFFFF; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[0].Selector = 0x8; //Selektor segmentu jądra
  IDTS[0].Zero = 0;
  IDTS[0].W=0;
  IDTS[0].MB3=3;
  IDTS[0].D=1;
  IDTS[0].Zero2 = 0;
  IDTS[0].DPL = 0;
  IDTS[0].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[0].Offset2 =  temp2 >> 16 ;
  
  temp2 = (u32int) & OffsetTooLargeException;
  IDTS[5].Offset1 = temp2 & 0xFFFF; // Wpisanie offsetu procedury obsługi wyjątku  
  IDTS[5].Selector = 0x8; //Selektor segmentu jądra
  IDTS[5].Zero = 0;
  IDTS[5].W=0;
  IDTS[5].MB3=3;
  IDTS[5].D=1;
  IDTS[5].Zero2 = 0;
  IDTS[5].DPL = 0;
  IDTS[5].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[5].Offset2 =  temp2 >> 16 ;
  
  temp2 = (u32int) & UnknowInstruction;
  IDTS[6].Offset1 = temp2 & 0xFFFF; // Wpisanie offsetu procedury obsługi wyjątku ; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[6].Selector = 0x8; //Selektor segmentu jądra
  IDTS[6].Zero = 0;
  IDTS[6].W=0;
  IDTS[6].MB3=3;
  IDTS[6].D=1;
  IDTS[6].Zero2 = 0;
  IDTS[6].DPL = 0;
  IDTS[6].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[6].Offset2 = temp2 >> 16 ;
  
  temp2 = (u32int) & DoubleFault;
  IDTS[8].Offset1 = temp2 & 0xFFFF;; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[8].Selector = 0x8; //Selektor segmentu jądra
  IDTS[8].Zero = 0;
  IDTS[8].W=0;
  IDTS[8].MB3=3;
  IDTS[8].D=1;
  IDTS[8].Zero2 = 0;
  IDTS[8].DPL = 0;
  IDTS[8].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[8].Offset2 = temp2 >> 16 ;
  
  temp2 = (u32int) & TSSException;
  IDTS[10].Offset1 = temp2 & 0xFFFF; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[10].Selector = 0x8; //Selektor segmentu jądra
  IDTS[10].Zero = 0;
  IDTS[10].W=0;
  IDTS[10].MB3=3;
  IDTS[10].D=1;
  IDTS[10].Zero2 = 0;
  IDTS[10].DPL = 0;
  IDTS[10].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[10].Offset2 = temp2 >> 16;
  
  temp2 = (u32int) & SegNotPresentException;
  IDTS[11].Offset1 = temp2 & 0xFFFF; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[11].Selector = 0x8; //Selektor segmentu jądra
  IDTS[11].Zero = 0;
  IDTS[11].W=0;
  IDTS[11].MB3=3;
  IDTS[11].D=1;
  IDTS[11].Zero2 = 0;
  IDTS[11].DPL = 0;
  IDTS[11].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[11].Offset2 = temp2 >> 16;
  
  temp2 = (u32int) & SSException;
  IDTS[12].Offset1 = temp2 & 0xFFFF; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[12].Selector = 0x8; //Selektor segmentu jądra
  IDTS[12].Zero = 0;
  IDTS[12].W=0;
  IDTS[12].MB3=3;
  IDTS[12].D=1;
  IDTS[12].Zero2 = 0;
  IDTS[12].DPL = 0;
  IDTS[12].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[12].Offset2 = temp2 >> 16;
  
  temp2 = (u32int) & GeneralProtectionException;
  IDTS[13].Offset1 = temp2 & 0xFFFF; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[13].Selector = 0x8; //Selektor segmentu jądra
  IDTS[13].Zero = 0;
  IDTS[13].W=0;
  IDTS[13].MB3=3;
  IDTS[13].D=1;
  IDTS[13].Zero2 = 0;
  IDTS[13].DPL = 0;
  IDTS[13].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[13].Offset2 = temp2 >> 16;
  
  temp2 = (u32int) & PageFaultExceptopn;
  IDTS[14].Offset1 = temp2 & 0xFFFF; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[14].Selector = 0x8; //Selektor segmentu jądra
  IDTS[14].Zero = 0;
  IDTS[14].W=0;
  IDTS[14].MB3=3;
  IDTS[14].D=1;
  IDTS[14].Zero2 = 0;
  IDTS[14].DPL = 0;
  IDTS[14].P = 1;
  temp2 = temp2 & 0xFFFF0000;
  IDTS[14].Offset2 = temp2 >> 16;
  ReturnCallStack
  /*IDTS[0].Offset1 = 1; // Wpisanie offsetu procedury obsługi wyjątku
  IDTS[0].Selector = 0; //Selektor segmentu jądra
  IDTS[0].Zero = 0;
  IDTS[0].W=0;
  IDTS[0].MB3=0;
  IDTS[0].D=0;
  IDTS[0].Zero2 = 0;
  IDTS[0].DPL = 0;
  IDTS[0].P = 0;
  IDTS[0].Offset2 = 0;*/
}