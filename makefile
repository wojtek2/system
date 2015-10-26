ifeq ($(DEBUG),0)		
	
	ECHOT = echo "WARNING:!!! WARNING:!!! WARNING:!!! WARNING:!!!\nTo make with debug, please run make DEBUG=1 !!!\n --------------------------------------------------\n "
	CC = gcc -m32 -O0 -fno-builtin -w 
	# -w  bez wyświetlania ostrzeżeń
else
	ECHOT = echo "WARNING:!!! WARNING:!!! WARNING:!!! WARNING:!!!\nTo make without debug, please run make DEBUG=0 !!!\n --------------------------------------------------\n "
	CC = gcc -m32 -g -O0 -D DEBUG=1  -fno-builtin -w
	# -w  bez wyświetlania ostrzeżeń
endif	
LD = ld -melf_i386
LDdbg = ld -melf_i386
kernel.elf: kernel.c grub.s makefile kernel.ld init.c ./include/bdds.c ./include/mem.c ./include/temp.c ./include/data.h ./include/exceptions.c ./include/tasks.c
		
	$(ECHOT)
	
	$(CC) ./include/exceptions.c -S -o ./include/exceptions.s 
	$(CC) ./include/exceptions.c -c -o ./include/exceptions.o -Xassembler -a=./include/exceptions.lst
	
	$(CC) ./include/bdds.c -S -o ./include/bdds.s
	$(CC) ./include/bdds.c -c -o ./include/bdds.o -Xassembler -a=./include/bdds.lst
	
	$(CC) ./include/mem.c -S -o ./include/mem.s
	$(CC) ./include/mem.c -c -o ./include/mem.o -Xassembler -a=./include/mem.lst		
	
	$(CC) ./include/tasks.c -S -o ./include/tasks.s 
	$(CC) ./include/tasks.c -c -o ./include/tasks.o -Xassembler -a=./include/tasks.lst
	
	$(CC) init.c -S -o init.s
	$(CC) init.c -c -o init.o -Xassembler -a=init.lst
	
	
	$(CC) kernel.c -S -o kernel.s
	
	$(CC) kernel.c -c -o kernel.o	-Xassembler -a=./kernelo.lst
	nasm grub.s -f elf -o grub.o
	$(LD) -T  kernel.ld  -o kernel.elf
	$(LDdbg) -T kernel.ld -o kerneldbg.o
	ndisasm -b 32 kernel.elf > kernel.lst
clean:
	rm -f kernel.elf kernel.s kernel.o ./boot/floppy.bin ./include/init.s ./include/bdds.s ./include/init.o ./include/bdds.o ./include/tasks.o ./include/tasks.s


/boot/floppy.bin: ./boot/floppy.s makefile
	nasm ./boot/floppy.s -f bin -o ./boot/floppy.bin
	
	
tofdd: kernel.elf /boot/floppy.bin makefile
	-sudo umount ./vfd	
	
	sudo mount -o loop -t msdos ./a.img ./vfd
	
	sudo cp kernel.elf ./vfd/
	sudo cp ./boot/menu.cfg ./vfd/boot/menu.cfg
	-sudo umount ./vfd
	
	sudo dd if=./a.img of=/dev/fd0 bs=512  
gdb: kernel.elf /boot/floppy.bin makefile
	-sudo umount ./vfd
	
	sudo mount -o loop -t msdos ./a.img ./vfd
	
	sudo cp kernel.elf ./vfd/
	sudo cp ./boot/menu.cfg ./vfd/boot/menu.cfg
	-sudo umount ./vfd	
	
	konsole -workdir /home/wojtek/Dokumenty/programowanie/system/i386 -e bochsgdb -qf bochsrcgdb > xxx.txt
	gdb -tui 

bochs: kernel.elf /boot/floppy.bin makefile
	- sudo umount ./vfd
	
	-sudo mount -o loop -t msdos ./a.img ./vfd
	sudo cp kernel.elf ./vfd/
	sudo cp ./boot/menu.cfg ./vfd/boot/menu.cfg
	-sudo umount ./vfd	
	
	bochs -qf bochsrc
	
bochsdbg: kernel.elf /boot/floppy.bin makefile
	- sudo umount ./vfd
	
	-sudo mount -o loop -t msdos ./a.img ./vfd
	sudo cp kernel.elf ./vfd/
	sudo cp ./boot/menu.cfg ./vfd/boot/menu.cfg
	-sudo umount ./vfd	
	
	bochsdbg -qf bochsrcdbg
	
kdbg: kernel.elf /boot/floppy.bin makefile
	-sudo umount ./vfd
	
	sudo mount -o loop -t msdos ./a.img ./vfd
	
	sudo cp kernel.elf ./vfd/
	sudo cp ./boot/menu.cfg ./vfd/boot/menu.cfg
	-sudo umount ./vfd	
	
	konsole -workdir /home/wojtek/Dokumenty/programowanie/system/i386 -e bochsgdb -qf bochsrcgdb > xxx.txt
	kdbg -r localhost:1234 kernel.elf 

	