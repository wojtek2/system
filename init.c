/*
 ***********************************************************************************************************
 *						init.c						   *
 * 						Wersja:pre-alpha					   *
 * 						e-mail:Gandzia40@wp.pl					   *
 * 						2014							   *
 ***********************************************************************************************************
 Pierwszy i najważniejszy proces w systemie. Plik ten jest uruchamiany zanim zostanie uruchomione jądro,przechodzi do trybu
 chronionego, i uruchamia cały sdystem.
rvl;kjrkjgtvjkrhtvbikrhtgbviuhriub 
 */

#include "./include/data.h"


void EnablePaging() { /* Procedura włącza stronicowanie */
  u32int temp2;
  u32int temp3;
  
  KernelPDEA.P = 1;
  KernelPDEA.RW = 0;
  KernelPDEA.US = 0;
  KernelPDEA.PWT = 0;
  KernelPDEA.PCD = 0;
  KernelPDEA.A = 0;
  KernelPDEA.Zero = 0;
  KernelPDEA.PageSize = 0;
  KernelPDEA.G = 0;
  KernelPDEA.AVL = 0;
  
  KernelPTEA.P = 1;
  KernelPTEA.RW = 0;
  KernelPTEA.US = 1;
  KernelPTEA.PWT = 0;
  KernelPTEA.PCD = 0;
  KernelPTEA.A = 0;
  KernelPTEA.Zero = 0;
  KernelPTEA.D = 0;
  KernelPTEA.G = 0;
  KernelPTEA.AVL = 0;
  
  AllocPsyhicalMemory(&KernelPDE,&KernelPTEs,0,0, KernelSpaceEndAddress ,&KernelPDEA,&KernelPTEA);
  BOCHSDBG
  
 
  asm(            
      "cli\n"      
      "movl %[KernelPDEOffset],%%eax\n"
      "movl %%eax,%%cr3\n"
      "movl %%cr0,%%eax\n"      
      "or $0x80000000,%%eax\n" // Ustawienie bitu odpowiedzialnego za stronicowanie
      "movl %%eax,%%cr0\n" // i start...
      "ljmp $0x8,$AfterEnablePaging\n"
      "AfterEnablePaging:\n"
      "movl $0,%%eax\n"
      
      :: [KernelPDEOffset] "r" (&KernelPDE)
      :"%eax");
}

void Log2Phy(s,o,AddrH,AddrL) u16int   s,o; u16int   *AddrH;u16int   *AddrL;
{ /* Procedura konwertuj¹ca adres logiczny na 20 bitowy adres fizyczny, wed³ug wzoru Ap=16*S+Ofs
PARAMETRY: s- segment o- offset
ZWRACANE: AddrH- starsze 16 bitów adresu fizycznego
AddrL - m³odsze 16 bitów adresu fizycznego */

  u16int   t1;
  SetCallStack(4)
  t1=s;
  t1=t1 >> 12; /*Przemieszczenie bitowe o 12 bitów w prawo, teraz 4 najstarsze bity to 4 najm³odsze bity  */
  *AddrH=t1;
  t1=s;
  t1=t1 << 4; /*Przemieszczenie bitowe o 4 bity w prawo, a 4 najmo³odsze bity zostaj¹ wyzerowane */
  *AddrL=t1+o;
  ReturnCallStack
} 

void CreateGDTIDT() { //Procedura tworzy tablice GDT i IDT, i wczytuje je za pomocą instrukcjii lgdt i lidt, tworzy w GDT desktyptory jądra.
                      //Numer funkcji: 3
  u32int temp;
  SetCallStack(3)                    
  //Stworzenie pustego deskryptora. tzw Null Deskryptora
  EditGDTEntry(0,0,0,0,0,0,0,0,0,0,0,0,0);
  
  //Stworzenie segmentu kodu dla jądra, będzie on zajmować całą przestrzeń adresową 4 GB  
  EditGDTEntry(1,0xFFFFF,0,0,1,0,1,1,0,1,0,1,1);
  //Stworzenie segmentu danych dla całego systemu, będzie on zajmować całą przestrzeń adresową 4 GB i posiadać poziom uprzywilejowania 3 
  EditGDTEntry(2,0xFFFFF,0,0,1,0,0,1,3,1,0,1,1);
  //Stworzenie segmentu stosu dla jądra
  EditGDTEntry(3,0xFFFFF,0,0,1,0,0,1,0,1,0,1,1);
  
  //Tymczasowo tworzenie segmentu ekranu dostęonego z każdego poziomu uprzywilejowania
  EditGDTEntry(4,4000,0xB8000,0,1,0,0,1, 3 ,1,0,1,0);
  
  //Segment stanu TSS
  EditGDTEntry(5,sizeof(KernelTSS),(u32int) &KernelTSS,1,0,0,1,0,0,1,0,1,0);          
  
  EditGDTEntry(6,0xFFFFF,0,0,1,1,1,1, 1 ,1,0,1,1); //Segment kodu dla procesów pracujących z poziomem uprzywilejowania 1
  EditGDTEntry(7,0xFFFFF,0,0,1,1,1,1, 2 ,1,0,1,1); //Segment kodu dla procesów pracujących z poziomem uprzywilejowania 2
  EditGDTEntry(8,0xFFFFF,0,0,1,1,1,1, 3 ,1,0,1,1); //Segment kodu dla procesów pracujących z poziomem uprzywilejowania 3
  
  GDTC=10;
  //Stworzenie deskryptorów tablic GDT i LDT
  GDTDescr.Size = GDTSMAX*8-1;
  IDTDescr.Size = IDTSMAX*8-1;
  /*Log2Phy(KernelSegment,&GDTS[0],&GDTDescr.AddrH,&GDTDescr.AddrL);    
  Log2Phy(KernelSegment,&IDTS[0],&IDTDescr.AddrH,&IDTDescr.AddrL); */
  
  temp = (u32int) &GDTS[0];
  temp = temp & 0xFFFF0000;
  temp = temp >> 16;
  GDTDescr.AddrH = temp;
  temp = (u32int) &GDTS[0];
  temp = temp & 0x0000FFFF;
  
  GDTDescr.AddrL = temp;
  
  temp = (u32int) &IDTS[0];
  temp = temp & 0xFFFF0000;
  temp = temp >> 16;
  IDTDescr.AddrH = temp;
  temp = (u32int) &IDTS[0];
  temp = temp & 0x0000FFFF;
  
  IDTDescr.AddrL = temp;
  asm("lgdt GDTDescr\n");
  asm("lidt IDTDescr\n");
  ReturnCallStack
}



u16int temp;
u32int temp2;



void InitKernel() { /* Procedura tworzy podstawowe struktury systemowe (GDT,IDT,...) uruchamia bramkę A20, uruchamia tryb chroniony,wczytuje jądro pod podany adres.
                       Numer funkcji: 2 */                          
  SetCallStack(2)
  
  /*asm("pushw %ds\n"
      "popw KernelSegment\n"
      "pushw %ds\n"
      "popw KernelSegmentInRM\n"
      
     );*/      
  //SetA20State(1);
  temp=0;
  
  CreateGDTIDT();  
  BOCHSDBG
  
  
  
  
  
  asm("ljmp $0x8,$InitKernelSetRegs\n"
      "InitKernelSetRegs:\n"
      "movl $0,%eax\n"
      "movl %eax,%cr2\n"
      "movl %eax,%cr3\n"
      "movl %eax,%cr4\n"
      "movw $0x13,%ax\n"
      "movw %ax,%ds\n"
      "movw %ax,%es\n"
      "movw %ax,%gs\n"
      "movw %ax,%fs\n"
      "movw $0x18,%ax\n"
      "movw %ax,%ss\n");

  KernelBase=KernelCS*0x10;
  
  
  /*Wypełnienie tablicy IDT wektorem do pustej procedury przerywania */
  for (temp=32;temp <= 255;temp++) {
    temp2 = (u32int) & EmptyInterrupt;
    IDTS[temp].Offset1 = temp2 & 0xFFFF;
    IDTS[temp].Selector = 0x8;
    IDTS[temp].Zero = 0;
    IDTS[temp].W = 0;
    IDTS[temp].MB3 = 3;
    IDTS[temp].D = 1;
    IDTS[temp].Zero2 = 0;
    IDTS[temp].DPL = 0;
    IDTS[temp].P = 1;
    temp2 = temp2 & 0xFFFF0000;
    IDTS[temp].Offset2 =  temp2 >> 16 ;
  } 
  FramesN = 8192; //Tymczasowa ilość ramek
  EnablePaging();  
  InitMain();
}
/*TYMCZASOWO!!!!: */
#include "./include/temp.c"

void InitMain() { /* Główna procedura  procesu init. Początkowo uruchamia cały system */
  struct _PDE *temp;
  ClearScreen();
  kprintf("GRUB");
  kprintOK();           
  SetExceptions(); //Ustawienie przerywań wyjątków 
  kprintf("Set vectors of internal exceptions");
  kprintOK();      
  PICInitInPM();
  kprintf("PIC registers set to protected mode");
  kprintOK();
  kprintf("Enable paging");
  kprintOK();  
  kprintOK();
  BOCHSDBG
  BOCHSDBGprintf("Clock \nTest\n");
  DisablePaging
  Tasks[0].PDBR=SetClosestFreeFrameBit();
  Tasks[0].PDEsN = 1;
  Tasks[0].PTEsN = 1;
  temp = Tasks[0].PDBR;
  temp -> Base = SetClosestFreeFrameBit() >> 12;
  PagingEnable
  AllocMemoryWithAttribs(0,4096,KernelPDEA,KernelPTEA);
  //Clock();
  
  /*asm( "pushl $0\n"
       "popfl\n"
       "movl 30485760,%eax\n"
       "movw $0xABCD,%cx\n"
       "movw $0,%ax\n"
       "div %ax\n"); */
  
  
  
  asm("cli\n"
      "hlt\n");
  for (;;) {
  }
  
  
  
  
  
  //HALT
}
      
      
 
