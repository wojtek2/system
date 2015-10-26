/* *********************************************************************************************************
   *						kernel.ld					           *
   *						Autor:Gandzia40					           *
   * 						wersja: pre-alpha					   *
   *						2014							   *
   *********************************************************************************************************
   
   Skrypt linkera ld służacy do linkowania pliku jądra
*/


OUTPUT_FORMAT("elf32-i386"); /* Format pliku wyjściowego: binarny*/
STARTUP(grub.o); /* Pierwszy najgówniejszy plik wejściowy */
INPUT
(      
      grub.o
      init.o
      kernel.o      
      ./include/bdds.o
      ./include/exceptions.o
      ./include/mem.o
      ./include/tasks.o
      /*./include/temp.o*/
)

/*OUTPUT(kernel.elf); /* Nazwa pliku wyjściowego */
ENTRY(InitKernel)

SECTIONS
{
  . = 0x100000;    
  .text ALIGN(0x1000) : { 
    text = .; 
    *(.text)
   }
    
  .bss ALIGN(0x1000) : { bss = .; *(.bss)}
  .KernelPDESect ALIGN(0x1000) : { *(.KernelPDESect)}
  .KernelPTESect ALIGN(0x1000) : { *(.KernelPTESect)}
 end = .; 
}
