// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	cprintf("hello, world\n");
	sys_set_console_color(0x400);
	cprintf("hello, world\n");
    sys_set_console_color(0x300);
    cprintf("hello, world\n");
    sys_set_console_color(0x100);
    cprintf("hello, world\n");
    sys_set_console_color(0x200);
    cprintf("hello, world\n");
    sys_set_console_color(0x800);
    cprintf("hello, world\n");
    sys_set_console_color(0x600);
    cprintf("hello, world\n");
    sys_set_console_color(0x700);
}
