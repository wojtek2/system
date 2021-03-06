;********************************************************************************************************************
;*                                      floppy.asm                                                                  *
;*                                      Autor:Gandzia40                                                             *
;*                                      e-mail:Gandzia40@wp.pl                                                      *
;*                                      0.1                                                                         *
;*                                      2012                                                                        *
;********************************************************************************************************************
; Program rozruchowy umieszczany w pierwszym sektorze dysku. Wczytuje plik o podanej nazwie pod wskazany adres, a nas
; t�pnie przekazuje mu sterowanie, pocz�wszy od drugiego bajtu tego� pliku.
; Program posiada dodatkowe funkcje wkompilowywane w zale�no�ci od podanych dyrektyw preprocesora:
;  - wy�wietlenie tekstu powitalnego ��cznie z formatowaniem w zale�no�ci od dyrektywy
;  - za�adowanie pliku o podanej nazwie pod wskazany adres
;  - sprawdzenie, czy plik zawiera na pocz�tku sekwencj� 0xAA55 w zale�no�ci od dyrektywy
;  - wy�wietlenie trzech r�nych tekst�w z formatowaniem w razie b��d�w: braku pliku, odczytu, b�edu w pliku (braku sekwencji
;    0xAA55 )i reset CPU b�d� ponowienie pr�by rozruchu (wyw�oanie int 0x19) w zale�no�ci od dyrektywy
; Program zosta� przygotowany dla kompilatora NASM
; Maksymalna wielko�� pliku do wczytania to 64 KB
; ZWRACANE:
; Po poprawnym za?adowaniu pliku i skoku adres gdzie za?adowano plik zawarty jest w rejestrach AX:BX
;---------------------------------------------------------------------------------------------------------------
;SPIS TRE�CI:                                       |NR. LINII
;---------------------------------------------------------------------------------------------------------------
;1.Metka i podstawowy opis                          | 1
;2.Definicje wkompilowuj�ce kod                     |
;Definicje wkompilowuj�ce kod:

%DEFINE Welcome 'ON' ;Czy wy�wietla� tekst powitalny, ON - tekst b�dzie wy�wietlany, OFF - nie. Tekst w zmiennej WelcomeText
%DEFINE WelcomeFormat 7 ; Format tekstu powitania
%DEFINE CheckAA55 'OFF' ; Czy sprawdza� obecno�� s�owa 0xAA55, ON-tak, OFF-nie
%DEFINE ResetIfError 'ON' ; Czy uruchamia� ponownie komputer w razie wyst�pienia b��du. ON - komputer b�dzie uruchamiany ponownie
                         ; OFF - po wyst�pieniu b��du b�dzie ponowiona pr�ba rozruchu (int 0x19)
%DEFINE ErrorFormat  0x8C   ; Format tekstu b��du.

;DEFINE:

;Adres pod kt�ry zostanie wczytany plik:
%DEFINE DestinationSegment 0x0050  ;Segment
%DEFINE DestinationOffset 0 ;Offset

%DEFINE BufferOffset 0x201 ; Offset wzgl�dem segmentu 0x7C0, w kt�rym b�dzie si� znajdowa� bufor na dane potrzebne do obs�ugi FAT

[ORG 0]
start:
 jmp SetRegs
 OSName db 'GADAOS  '             ; 8 znakowa nazwa systemu operacyjnego. Nie wykorzystane znaki nale�y zape�ni� spacjami
 BytesPerSector dw 0x200          ; Liczba bajt�w na sektor
 SectorPerCluster db 0x1          ; Liczba sektor�w na klaster
 ReservedSectors dw 0x1           ; Liczba zarezerwowanych sektor�w
 FATn            db 0x2           ; Liczba tablic FAT
 MaxElInRoot     dw 0x0E0         ; Maksymalna liczba element�w w katalogu g��wnym
 AllSectors      dw 0x0B40        ; Liczba wszystkich sektor�w
 MDB             db 0x0F0         ; Bajt deskryptora no�nika
 SectorPerFAT    dw 9             ; Liczba sektor�w na tablice FAT
 SectorPerTrack  dw 0x12         ; Liczba sektor�w na �cie�k�
 Heads           dw 0x2          ; Licbza g�owic
 HiddenSectors   dd 0             ; Liczba ukrytych sektor�w
 AllSect32MB     dd 0             ; Liczba sektor�w, je�eli wolumin jest wi�kszy od 32 MB
 DriveNum        db 0             ; Numer nap�du
 Reserved        db 0             ; Pole zarezerwowane
 ExtSig          db 0x29          ; Rozszerzona sygnatura sektora rozruchowego
 SerialNumber    dd 0x0FFFFFFFF   ; Numer seryjny woluminu
 DiskLabel       db 'NAZWA_VOLUM' ; 11 znakowa etykieta woluminu.Niewykorzystane znaki zast�pi� spacjami
 FSName          db 'FAT12   '    ; 8 znakowa nazwa systemu plik�w. Niewykorzystane znaki zast�pi� spacjami

 ;Procedury programu:
 ;----------------------------------------------------------------------------------------------------------------------------------------------
 ReadCluster: ;Procedura obliczaj�ca adres C,H,S klastra i wczytuj�ca go.
 ;PARAMETRY:
 ;DX - numer klastra
 ;ES:BX - adres gdzie ma zosta� wczytany
  push bx
  mov ax, dx
  mov bx, dx
  xor dx, dx
  mov cx, [SectorPerTrack]
  div cx
  inc dx
  push dx
  xor dx, dx
  mov cx, [Heads]
  div cx
  pop cx
  mov ch, al
  mov dh, dl
  xor dl, dl
  pop bx
  Call ReadSector
  ret

 CmpText: ; Funkcja por�wnuj�ca dwa �a�cuchy zako�czone 0, i zwracaj�ca 1 gdy s� takie same b�d� 0 gdy r�ne.Nie uwzgl�dnia wielko�ci liter
 ;PARAMETRY:
 ;DS:SI,ES:DI - adresy ci�g�w zako�czonych 0 do por�wnania
 ;CX - ilo�� znak�w do por�wnania, 0 - por�wnanie a� do wyst�pienia ko�ca w dowolnym z �a�cuch�w
 ;ZWRACANE:
 ;  CF=0 -ci�gi r�ne
 ;  CF=1 - ci�gi takie same
 cld
 repe cmpsb
 jne .NotEqu
 stc
 ret
 .NotEqu:
 clc
 ret

 ;-------------------------------------------------------------------------------------------------------------------

 printf: ; Procedura wy�wietlaj�ca tekst na ekaranie. W DS:SI adres ze zmienn� zawieraj�c� tekst do wy�wietlenia zako�czony 0, w BL format tresktu
  .PrintfLoop:
   mov ah,0xE ;Funkcja wy�wietlaj�ca znak
   mov al,[ds:si] ;Pobranie kodu znaku do rejestru AL
   cmp al,0
   je .PrintfEnd
   mov bh,0
   int 0x10
   inc si
   jmp .PrintfLoop
  .PrintfEnd:
   ret
 ;-------------------------------------------------------------------------------------------------------------------
 ErrorProc: ;Procedura obs�ugi b��d�w, wy�wietla tekst i podejmuje dalsze kroki w zale�no�ci od dyrektywy "ResetIfError". W DS:SI tekst b��du
  mov bl,ErrorFormat
  call printf
  mov ax,0
  int 0x16
  %IFIDN <ResetIfError>,<'ON'>
    mov al,0x0FE
    out 0x64,al
    hlt
  %ELSE
    mov ax,0
    int 0x19
  %ENDIF
 ;-------------------------------------------------------------------------------------------------------------------
 ReadSector: ; Procedura odczytuj�ca sektory z dysku. W CH - numer �cie�ki w CL - numer sektora DH - numer g�owicy ES:BX - adres gdzie sektor ma by� wczytany
  push ax
  mov ah,0x2
  mov al,1
  mov dl,0
  int 0x13
  jc .ReadSectorError
  pop ax
  ret
  .ReadSectorError:

  mov si,IOErrorText
  call ErrorProc
  ;-------------------------------------------------------------------------------------------------------------------
  ;-------------------------------------------------------------------------------------------------------------------


  SetRegs: ;Ustawienie rejestr�w segmentowych na poprawne dla programu
   mov ax,0x7C0
   mov ds,ax
   mov es,ax
   mov ss,ax
   mov sp,0xFFFF
   push 0x7c0
   push begin

   retf ;Skok do g��wnego kodu programu, poprzez daleki powr�t z procedury.Parametry od�o�one na stosie powy�ej
  begin:;G��wny kod programu:
   %IFIDN <Welcome>,<'ON'>
    mov si,WelcomeText
    mov bl,WelcomeFormat
    call printf
    
   %ENDIF
   ; Poszukiwanie w katalogu g��wnym pliku o podanej nazwie
   ;Wczytanie  pierwszego sektora z katalogiem g��wnym
   mov cx,2
   mov dh,1
   mov bx,BufferOffset
   Call ReadSector
   mov ax,0
   .FindFileLoop: ;P�tla poszukiwawcza. W AX - numer aktualnie przetwarzanego wpisu w aktualnie przetwarzanym sektorze
                  ;                            katalogu g��wnego (max 15)
                  ;                     W Cl - numer aktualnie wczytanego sektora katalogu g��wnego (2-15)
     ;obliczenie pozycji aktualnego wpisu w buforze, wpis ma 32 bajty, wiec mno�ymy AX przez 32
     push ax
     push cx
     mov bx,32
     mul bx
     ;Por�wnanie nazwy pliku:
     mov si,FileName
     mov di,ax
     add di,BufferOffset
     mov cx,8
     push di
     Call CmpText
     pop di
     jne .FindFileLoopNext ;Je�eli nazwa nie jest t� nazw�, przej�cie do przetwarzania nast�pnego wpisu
     ;Por�wanie rozszerzenia pliku:
     mov si,FileName+9
     add di,0x8
     mov cx,3
     push di
     Call CmpText
     jne .FindFileLoopNext ;Je�eli nie to rozszrzenie, przej�cie do przetwarzania nast�pnego wpisu
     pop di
     mov di,BufferOffset
     add di,0x1A
     add di,ax
     mov dx,[ds:di] ; W DX numer pierwszego klastra
     jmp .LoadFile ;Je�eli program doszed� do tego momentu, oznacza to �e plik o podanej nazwie zosta� znaleziony, i przej�cie do procedury jego za�adowania

     .FindFileLoopNext:
       pop cx
       pop ax
       inc ax
       cmp ax,16 ;Je�eli przetworzono ju� wszystkie wpisy w aktualnym sektorze, przejscie do zaladowania nastepnego
       je .FindFileLoopLoadNextSector
       jmp .FindFileLoop

     .FindFileLoopLoadNextSector:
       inc cl
       cmp cl,16 ;Je�eli numer nast�pnego sektora do wczytania to 16, oznacza to �e przetworzyli�my ju� wszystkie sektory przeznaczone na katalog g��wny i
                 ;plik nie zosta� odnaleziony
       je .FileNotFound
       ;Wczytanie nast�pnego sektora
       mov ch,0
       mov dh,1
       mov bx,BufferOffset
       Call ReadSector
       mov ax,0
       jmp .FindFileLoop
   .FileNotFound:
     mov si,FileNotFoundText
     call ErrorProc

   .LoadFile:
      
      push dx
      mov cx,2
      mov bx,BufferOffset
      .LoadFatLoop: ;p�tla wczytuj�ca ca�� tablic� FAT pod adres wskazany przez CS:BufferOffset
       mov dh,0
       Call ReadSector
       inc cl
       add bx,512
       cmp cl,11
       jne .LoadFatLoop
      pop dx
      push DestinationSegment
      pop es
      mov bx,DestinationOffset
      .LoadFileLoop:
        ;Odczytanie podanego klastra z dysku
        cmp dx,0xFF7 ; Je�eli wi�ksze, oznacza to koniec pliku
        jae .GoToFile ; Przej�cie do procedury, kt�ra odda sterowanie wczytanemu plikowi
        push dx
        add dx,31
        Call ReadCluster;
        add bx,512
        pop dx
        ;Odczytanie numeru nast�pnego klastra z tablicy FAT.
        mov ax,dx
        shr dx,1 ; Obliczenie numeru pozycji w kt�rej zapisany jest nast�pny numer klastra. Aktualny numer klastra to numer pozycji gdzie zapisany jest numer nast�pnego klastra.
                 ; poniewa� pozycje zajmuj� 12 bit�w, czyli 1,5 bajta, nale�y przemno�y� aktualny numer klastra przez 1.5, przesuni�cie o jeden bit w prawo dokonuje tego.
        add dx,ax
        mov si,dx
        mov dx,0
        mov di,2
        div di ; W poprzednim kroku wczytali�my 16 bit�w numeru klastra, a numer klastra ma 12 bit�w, wi�c pozosta�e bity trzeba przesun�� lub wyzerowa�, w zale�no�ci czy numer aktualnego klastra jest parzysty czy nie
        mov ax,[ds:si+BufferOffset] ;Odczytanie numeru nast�pnego klastra
        cmp dx,0
        je .Parrity

        .NotParrity: ;Nie parzysty, przesuni�cie numeru nast�pnego klastra w prawo o 4
         shr ax,4
         mov dx,ax
         jmp .LoadFileLoop
        .Parrity: ;Parzysty, numer nast�pnego klastra AND 0xFFF
         and ax,0xFFF
         mov dx,ax
         jmp .LoadFileLoop

   .GoToFile: ; Procedura oddaj�ca sterowanie wczytanemu plikowi
    mov eax ,0000h
    mov dx,03f2h
    out dx,ax ;stop floppy motor
    mov si,JumpText
    mov bl,WelcomeFormat
    call printf
    mov bx,DestinationOffset
    %IFIDN <CheckAA55>,<'ON'> ; Je�eli w��czone sprawdzanie 0xAA55
     mov ax,[es:DestinationOffset]
     mov bx,push DestinationOffset+2
     cmp ax,0xAA55
     je .Jump
     mov si,FileNotFoundText
     Call ErrorProc
    %ENDIF
    .Jump:
     mov ax, DestinationSegment     
     push DestinationSegment
     push bx     
     retf

   ;ZMIENNE PROGRAMU:
   %IFIDN <Welcome>,<'ON'>
    WelcomeText db 'Booting...',10,13,0 ; Zmienna z tekstem powitalnym, musi by� zako�czona 0
   %ENDIF
   IOErrorText  db 'I/O Error.Press any key to reset',0 ;Zmienna z tekstem b��du odczytu
   JumpText	db 'Jump',10,13,0
   FileNotFoundText db 'File not found.Press any key to reset',0 ;Zmienna z tekstem b��du braku pliku
   FileName db 'KERNEL  .BIN' ;12 znakowa (11 znak�w nazwy + obowi�zkowo kropka) nazwa pliku do odnalezienia

times 510 - ($-start) db 0 ;Dope�nienie zerami do 510 bajt�w
db 0x55
db 0xAA
