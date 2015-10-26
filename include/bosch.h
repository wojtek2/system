/*
 ***************************************************************************************
 *					bosch.h				               *
 * 					Wersja: pre-alpha			       *
 * 					e-mail:gandzia40@wp.pl			       *
 * 					2014					       *
 ***************************************************************************************
 Plik zawiera definicje makr ułatwiające korzystanie z debuggingu w emulatorze Bosch   */
 
 #if DEBUG == 1 /*Sprawdza czy zadeklarowane jest makro DEBUG i czy jego wartość wynosi. Jeżeli nie wtedy wspomaganie debuggowania jest nie aktywne.
		  DEBUG zazwyczaj definiowane jest już w linii poleceń gcc (-D DEBUG=1), jednak oczywiście możliwe jest także zdefiniowanie w kodzie programu.*/
    #define HALT asm("cli\nhlt"); /*iii*/
    #define BOCHSDBG asm("xchg %bx,%bx ; BOCHS DEBUG") ; /*Powoduje zatrzymanie emulatora Bochs i przejście do debuggera */
    
#else
    #define BOCHSDBG 	
#endif  