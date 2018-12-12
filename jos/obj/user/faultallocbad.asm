
obj/user/faultallocbad.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 e0 1f 80 00       	push   $0x801fe0
  800045:	e8 e4 01 00 00       	call   80022e <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 8d 0b 00 00       	call   800beb <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 2c 20 80 00       	push   $0x80202c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 76 07 00 00       	call   8007e9 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 00 20 80 00       	push   $0x802000
  800085:	6a 0f                	push   $0xf
  800087:	68 ea 1f 80 00       	push   $0x801fea
  80008c:	e8 8a 00 00 00       	call   80011b <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 ff 0d 00 00       	call   800ea0 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 9e 0a 00 00       	call   800b4e <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 07 0b 00 00       	call   800bcc <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	89 c2                	mov    %eax,%edx
  8000cc:	c1 e2 05             	shl    $0x5,%edx
  8000cf:	29 c2                	sub    %eax,%edx
  8000d1:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000d8:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000dd:	85 db                	test   %ebx,%ebx
  8000df:	7e 07                	jle    8000e8 <libmain+0x33>
		binaryname = argv[0];
  8000e1:	8b 06                	mov    (%esi),%eax
  8000e3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e8:	83 ec 08             	sub    $0x8,%esp
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	e8 9f ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000f2:	e8 0a 00 00 00       	call   800101 <exit>
}
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fd:	5b                   	pop    %ebx
  8000fe:	5e                   	pop    %esi
  8000ff:	5d                   	pop    %ebp
  800100:	c3                   	ret    

00800101 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800107:	e8 d4 0f 00 00       	call   8010e0 <close_all>
	sys_env_destroy(0);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	6a 00                	push   $0x0
  800111:	e8 75 0a 00 00       	call   800b8b <sys_env_destroy>
}
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	c9                   	leave  
  80011a:	c3                   	ret    

0080011b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80011b:	55                   	push   %ebp
  80011c:	89 e5                	mov    %esp,%ebp
  80011e:	57                   	push   %edi
  80011f:	56                   	push   %esi
  800120:	53                   	push   %ebx
  800121:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800127:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80012a:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800130:	e8 97 0a 00 00       	call   800bcc <sys_getenvid>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	ff 75 0c             	pushl  0xc(%ebp)
  80013b:	ff 75 08             	pushl  0x8(%ebp)
  80013e:	53                   	push   %ebx
  80013f:	50                   	push   %eax
  800140:	68 58 20 80 00       	push   $0x802058
  800145:	68 00 01 00 00       	push   $0x100
  80014a:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800150:	56                   	push   %esi
  800151:	e8 93 06 00 00       	call   8007e9 <snprintf>
  800156:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800158:	83 c4 20             	add    $0x20,%esp
  80015b:	57                   	push   %edi
  80015c:	ff 75 10             	pushl  0x10(%ebp)
  80015f:	bf 00 01 00 00       	mov    $0x100,%edi
  800164:	89 f8                	mov    %edi,%eax
  800166:	29 d8                	sub    %ebx,%eax
  800168:	50                   	push   %eax
  800169:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80016c:	50                   	push   %eax
  80016d:	e8 22 06 00 00       	call   800794 <vsnprintf>
  800172:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800174:	83 c4 0c             	add    $0xc,%esp
  800177:	68 83 24 80 00       	push   $0x802483
  80017c:	29 df                	sub    %ebx,%edi
  80017e:	57                   	push   %edi
  80017f:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800182:	50                   	push   %eax
  800183:	e8 61 06 00 00       	call   8007e9 <snprintf>
	sys_cputs(buf, r);
  800188:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80018b:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80018d:	53                   	push   %ebx
  80018e:	56                   	push   %esi
  80018f:	e8 ba 09 00 00       	call   800b4e <sys_cputs>
  800194:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800197:	cc                   	int3   
  800198:	eb fd                	jmp    800197 <_panic+0x7c>

0080019a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	53                   	push   %ebx
  80019e:	83 ec 04             	sub    $0x4,%esp
  8001a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a4:	8b 13                	mov    (%ebx),%edx
  8001a6:	8d 42 01             	lea    0x1(%edx),%eax
  8001a9:	89 03                	mov    %eax,(%ebx)
  8001ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b7:	74 08                	je     8001c1 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b9:	ff 43 04             	incl   0x4(%ebx)
}
  8001bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bf:	c9                   	leave  
  8001c0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	68 ff 00 00 00       	push   $0xff
  8001c9:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cc:	50                   	push   %eax
  8001cd:	e8 7c 09 00 00       	call   800b4e <sys_cputs>
		b->idx = 0;
  8001d2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d8:	83 c4 10             	add    $0x10,%esp
  8001db:	eb dc                	jmp    8001b9 <putch+0x1f>

008001dd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ed:	00 00 00 
	b.cnt = 0;
  8001f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fa:	ff 75 0c             	pushl  0xc(%ebp)
  8001fd:	ff 75 08             	pushl  0x8(%ebp)
  800200:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800206:	50                   	push   %eax
  800207:	68 9a 01 80 00       	push   $0x80019a
  80020c:	e8 17 01 00 00       	call   800328 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800211:	83 c4 08             	add    $0x8,%esp
  800214:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800220:	50                   	push   %eax
  800221:	e8 28 09 00 00       	call   800b4e <sys_cputs>

	return b.cnt;
}
  800226:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800234:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800237:	50                   	push   %eax
  800238:	ff 75 08             	pushl  0x8(%ebp)
  80023b:	e8 9d ff ff ff       	call   8001dd <vcprintf>
	va_end(ap);

	return cnt;
}
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	57                   	push   %edi
  800246:	56                   	push   %esi
  800247:	53                   	push   %ebx
  800248:	83 ec 1c             	sub    $0x1c,%esp
  80024b:	89 c7                	mov    %eax,%edi
  80024d:	89 d6                	mov    %edx,%esi
  80024f:	8b 45 08             	mov    0x8(%ebp),%eax
  800252:	8b 55 0c             	mov    0xc(%ebp),%edx
  800255:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800258:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80025e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800263:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800266:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800269:	39 d3                	cmp    %edx,%ebx
  80026b:	72 05                	jb     800272 <printnum+0x30>
  80026d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800270:	77 78                	ja     8002ea <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	ff 75 18             	pushl  0x18(%ebp)
  800278:	8b 45 14             	mov    0x14(%ebp),%eax
  80027b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80027e:	53                   	push   %ebx
  80027f:	ff 75 10             	pushl  0x10(%ebp)
  800282:	83 ec 08             	sub    $0x8,%esp
  800285:	ff 75 e4             	pushl  -0x1c(%ebp)
  800288:	ff 75 e0             	pushl  -0x20(%ebp)
  80028b:	ff 75 dc             	pushl  -0x24(%ebp)
  80028e:	ff 75 d8             	pushl  -0x28(%ebp)
  800291:	e8 ee 1a 00 00       	call   801d84 <__udivdi3>
  800296:	83 c4 18             	add    $0x18,%esp
  800299:	52                   	push   %edx
  80029a:	50                   	push   %eax
  80029b:	89 f2                	mov    %esi,%edx
  80029d:	89 f8                	mov    %edi,%eax
  80029f:	e8 9e ff ff ff       	call   800242 <printnum>
  8002a4:	83 c4 20             	add    $0x20,%esp
  8002a7:	eb 11                	jmp    8002ba <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	56                   	push   %esi
  8002ad:	ff 75 18             	pushl  0x18(%ebp)
  8002b0:	ff d7                	call   *%edi
  8002b2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b5:	4b                   	dec    %ebx
  8002b6:	85 db                	test   %ebx,%ebx
  8002b8:	7f ef                	jg     8002a9 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	56                   	push   %esi
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cd:	e8 c2 1b 00 00       	call   801e94 <__umoddi3>
  8002d2:	83 c4 14             	add    $0x14,%esp
  8002d5:	0f be 80 7b 20 80 00 	movsbl 0x80207b(%eax),%eax
  8002dc:	50                   	push   %eax
  8002dd:	ff d7                	call   *%edi
}
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e5:	5b                   	pop    %ebx
  8002e6:	5e                   	pop    %esi
  8002e7:	5f                   	pop    %edi
  8002e8:	5d                   	pop    %ebp
  8002e9:	c3                   	ret    
  8002ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ed:	eb c6                	jmp    8002b5 <printnum+0x73>

008002ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f5:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8002f8:	8b 10                	mov    (%eax),%edx
  8002fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8002fd:	73 0a                	jae    800309 <sprintputch+0x1a>
		*b->buf++ = ch;
  8002ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800302:	89 08                	mov    %ecx,(%eax)
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	88 02                	mov    %al,(%edx)
}
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <printfmt>:
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800311:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800314:	50                   	push   %eax
  800315:	ff 75 10             	pushl  0x10(%ebp)
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 05 00 00 00       	call   800328 <vprintfmt>
}
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <vprintfmt>:
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 2c             	sub    $0x2c,%esp
  800331:	8b 75 08             	mov    0x8(%ebp),%esi
  800334:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800337:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033a:	e9 ae 03 00 00       	jmp    8006ed <vprintfmt+0x3c5>
  80033f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800343:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80034a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800351:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800358:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8d 47 01             	lea    0x1(%edi),%eax
  800360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800363:	8a 17                	mov    (%edi),%dl
  800365:	8d 42 dd             	lea    -0x23(%edx),%eax
  800368:	3c 55                	cmp    $0x55,%al
  80036a:	0f 87 fe 03 00 00    	ja     80076e <vprintfmt+0x446>
  800370:	0f b6 c0             	movzbl %al,%eax
  800373:	ff 24 85 c0 21 80 00 	jmp    *0x8021c0(,%eax,4)
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800381:	eb da                	jmp    80035d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800386:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80038a:	eb d1                	jmp    80035d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	0f b6 d2             	movzbl %dl,%edx
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800392:	b8 00 00 00 00       	mov    $0x0,%eax
  800397:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039d:	01 c0                	add    %eax,%eax
  80039f:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8003a3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a9:	83 f9 09             	cmp    $0x9,%ecx
  8003ac:	77 52                	ja     800400 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8003ae:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8003af:	eb e9                	jmp    80039a <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bc:	8d 40 04             	lea    0x4(%eax),%eax
  8003bf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c9:	79 92                	jns    80035d <vprintfmt+0x35>
				width = precision, precision = -1;
  8003cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d8:	eb 83                	jmp    80035d <vprintfmt+0x35>
  8003da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003de:	78 08                	js     8003e8 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e3:	e9 75 ff ff ff       	jmp    80035d <vprintfmt+0x35>
  8003e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ef:	eb ef                	jmp    8003e0 <vprintfmt+0xb8>
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003fb:	e9 5d ff ff ff       	jmp    80035d <vprintfmt+0x35>
  800400:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800403:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800406:	eb bd                	jmp    8003c5 <vprintfmt+0x9d>
			lflag++;
  800408:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80040c:	e9 4c ff ff ff       	jmp    80035d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800411:	8b 45 14             	mov    0x14(%ebp),%eax
  800414:	8d 78 04             	lea    0x4(%eax),%edi
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	53                   	push   %ebx
  80041b:	ff 30                	pushl  (%eax)
  80041d:	ff d6                	call   *%esi
			break;
  80041f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800422:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800425:	e9 c0 02 00 00       	jmp    8006ea <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	8d 78 04             	lea    0x4(%eax),%edi
  800430:	8b 00                	mov    (%eax),%eax
  800432:	85 c0                	test   %eax,%eax
  800434:	78 2a                	js     800460 <vprintfmt+0x138>
  800436:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800438:	83 f8 0f             	cmp    $0xf,%eax
  80043b:	7f 27                	jg     800464 <vprintfmt+0x13c>
  80043d:	8b 04 85 20 23 80 00 	mov    0x802320(,%eax,4),%eax
  800444:	85 c0                	test   %eax,%eax
  800446:	74 1c                	je     800464 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800448:	50                   	push   %eax
  800449:	68 51 24 80 00       	push   $0x802451
  80044e:	53                   	push   %ebx
  80044f:	56                   	push   %esi
  800450:	e8 b6 fe ff ff       	call   80030b <printfmt>
  800455:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800458:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045b:	e9 8a 02 00 00       	jmp    8006ea <vprintfmt+0x3c2>
  800460:	f7 d8                	neg    %eax
  800462:	eb d2                	jmp    800436 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800464:	52                   	push   %edx
  800465:	68 93 20 80 00       	push   $0x802093
  80046a:	53                   	push   %ebx
  80046b:	56                   	push   %esi
  80046c:	e8 9a fe ff ff       	call   80030b <printfmt>
  800471:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800477:	e9 6e 02 00 00       	jmp    8006ea <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	83 c0 04             	add    $0x4,%eax
  800482:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8b 38                	mov    (%eax),%edi
  80048a:	85 ff                	test   %edi,%edi
  80048c:	74 39                	je     8004c7 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80048e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800492:	0f 8e a9 00 00 00    	jle    800541 <vprintfmt+0x219>
  800498:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80049c:	0f 84 a7 00 00 00    	je     800549 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a8:	57                   	push   %edi
  8004a9:	e8 6b 03 00 00       	call   800819 <strnlen>
  8004ae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b1:	29 c1                	sub    %eax,%ecx
  8004b3:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004b6:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b9:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004c3:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c5:	eb 14                	jmp    8004db <vprintfmt+0x1b3>
				p = "(null)";
  8004c7:	bf 8c 20 80 00       	mov    $0x80208c,%edi
  8004cc:	eb c0                	jmp    80048e <vprintfmt+0x166>
					putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	4f                   	dec    %edi
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	85 ff                	test   %edi,%edi
  8004dd:	7f ef                	jg     8004ce <vprintfmt+0x1a6>
  8004df:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004e2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004e5:	89 c8                	mov    %ecx,%eax
  8004e7:	85 c9                	test   %ecx,%ecx
  8004e9:	78 10                	js     8004fb <vprintfmt+0x1d3>
  8004eb:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004ee:	29 c1                	sub    %eax,%ecx
  8004f0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f9:	eb 15                	jmp    800510 <vprintfmt+0x1e8>
  8004fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800500:	eb e9                	jmp    8004eb <vprintfmt+0x1c3>
					putch(ch, putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	52                   	push   %edx
  800507:	ff 55 08             	call   *0x8(%ebp)
  80050a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050d:	ff 4d e0             	decl   -0x20(%ebp)
  800510:	47                   	inc    %edi
  800511:	8a 47 ff             	mov    -0x1(%edi),%al
  800514:	0f be d0             	movsbl %al,%edx
  800517:	85 d2                	test   %edx,%edx
  800519:	74 59                	je     800574 <vprintfmt+0x24c>
  80051b:	85 f6                	test   %esi,%esi
  80051d:	78 03                	js     800522 <vprintfmt+0x1fa>
  80051f:	4e                   	dec    %esi
  800520:	78 2f                	js     800551 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800522:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800526:	74 da                	je     800502 <vprintfmt+0x1da>
  800528:	0f be c0             	movsbl %al,%eax
  80052b:	83 e8 20             	sub    $0x20,%eax
  80052e:	83 f8 5e             	cmp    $0x5e,%eax
  800531:	76 cf                	jbe    800502 <vprintfmt+0x1da>
					putch('?', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 3f                	push   $0x3f
  800539:	ff 55 08             	call   *0x8(%ebp)
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	eb cc                	jmp    80050d <vprintfmt+0x1e5>
  800541:	89 75 08             	mov    %esi,0x8(%ebp)
  800544:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800547:	eb c7                	jmp    800510 <vprintfmt+0x1e8>
  800549:	89 75 08             	mov    %esi,0x8(%ebp)
  80054c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054f:	eb bf                	jmp    800510 <vprintfmt+0x1e8>
  800551:	8b 75 08             	mov    0x8(%ebp),%esi
  800554:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800557:	eb 0c                	jmp    800565 <vprintfmt+0x23d>
				putch(' ', putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	6a 20                	push   $0x20
  80055f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800561:	4f                   	dec    %edi
  800562:	83 c4 10             	add    $0x10,%esp
  800565:	85 ff                	test   %edi,%edi
  800567:	7f f0                	jg     800559 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800569:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
  80056f:	e9 76 01 00 00       	jmp    8006ea <vprintfmt+0x3c2>
  800574:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800577:	8b 75 08             	mov    0x8(%ebp),%esi
  80057a:	eb e9                	jmp    800565 <vprintfmt+0x23d>
	if (lflag >= 2)
  80057c:	83 f9 01             	cmp    $0x1,%ecx
  80057f:	7f 1f                	jg     8005a0 <vprintfmt+0x278>
	else if (lflag)
  800581:	85 c9                	test   %ecx,%ecx
  800583:	75 48                	jne    8005cd <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058d:	89 c1                	mov    %eax,%ecx
  80058f:	c1 f9 1f             	sar    $0x1f,%ecx
  800592:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 40 04             	lea    0x4(%eax),%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
  80059e:	eb 17                	jmp    8005b7 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8b 50 04             	mov    0x4(%eax),%edx
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8d 40 08             	lea    0x8(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8005bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005c1:	78 25                	js     8005e8 <vprintfmt+0x2c0>
			base = 10;
  8005c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c8:	e9 03 01 00 00       	jmp    8006d0 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	89 c1                	mov    %eax,%ecx
  8005d7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	eb cf                	jmp    8005b7 <vprintfmt+0x28f>
				putch('-', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	6a 2d                	push   $0x2d
  8005ee:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005f6:	f7 da                	neg    %edx
  8005f8:	83 d1 00             	adc    $0x0,%ecx
  8005fb:	f7 d9                	neg    %ecx
  8005fd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
  800605:	e9 c6 00 00 00       	jmp    8006d0 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80060a:	83 f9 01             	cmp    $0x1,%ecx
  80060d:	7f 1e                	jg     80062d <vprintfmt+0x305>
	else if (lflag)
  80060f:	85 c9                	test   %ecx,%ecx
  800611:	75 32                	jne    800645 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 10                	mov    (%eax),%edx
  800618:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061d:	8d 40 04             	lea    0x4(%eax),%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800623:	b8 0a 00 00 00       	mov    $0xa,%eax
  800628:	e9 a3 00 00 00       	jmp    8006d0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 10                	mov    (%eax),%edx
  800632:	8b 48 04             	mov    0x4(%eax),%ecx
  800635:	8d 40 08             	lea    0x8(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800640:	e9 8b 00 00 00       	jmp    8006d0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 10                	mov    (%eax),%edx
  80064a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800655:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065a:	eb 74                	jmp    8006d0 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80065c:	83 f9 01             	cmp    $0x1,%ecx
  80065f:	7f 1b                	jg     80067c <vprintfmt+0x354>
	else if (lflag)
  800661:	85 c9                	test   %ecx,%ecx
  800663:	75 2c                	jne    800691 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8b 10                	mov    (%eax),%edx
  80066a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80066f:	8d 40 04             	lea    0x4(%eax),%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800675:	b8 08 00 00 00       	mov    $0x8,%eax
  80067a:	eb 54                	jmp    8006d0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 10                	mov    (%eax),%edx
  800681:	8b 48 04             	mov    0x4(%eax),%ecx
  800684:	8d 40 08             	lea    0x8(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068a:	b8 08 00 00 00       	mov    $0x8,%eax
  80068f:	eb 3f                	jmp    8006d0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 10                	mov    (%eax),%edx
  800696:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069b:	8d 40 04             	lea    0x4(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a6:	eb 28                	jmp    8006d0 <vprintfmt+0x3a8>
			putch('0', putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	53                   	push   %ebx
  8006ac:	6a 30                	push   $0x30
  8006ae:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b0:	83 c4 08             	add    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	6a 78                	push   $0x78
  8006b6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 10                	mov    (%eax),%edx
  8006bd:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006c2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006d0:	83 ec 0c             	sub    $0xc,%esp
  8006d3:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006d7:	57                   	push   %edi
  8006d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006db:	50                   	push   %eax
  8006dc:	51                   	push   %ecx
  8006dd:	52                   	push   %edx
  8006de:	89 da                	mov    %ebx,%edx
  8006e0:	89 f0                	mov    %esi,%eax
  8006e2:	e8 5b fb ff ff       	call   800242 <printnum>
			break;
  8006e7:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ed:	47                   	inc    %edi
  8006ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f2:	83 f8 25             	cmp    $0x25,%eax
  8006f5:	0f 84 44 fc ff ff    	je     80033f <vprintfmt+0x17>
			if (ch == '\0')
  8006fb:	85 c0                	test   %eax,%eax
  8006fd:	0f 84 89 00 00 00    	je     80078c <vprintfmt+0x464>
			putch(ch, putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	50                   	push   %eax
  800708:	ff d6                	call   *%esi
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	eb de                	jmp    8006ed <vprintfmt+0x3c5>
	if (lflag >= 2)
  80070f:	83 f9 01             	cmp    $0x1,%ecx
  800712:	7f 1b                	jg     80072f <vprintfmt+0x407>
	else if (lflag)
  800714:	85 c9                	test   %ecx,%ecx
  800716:	75 2c                	jne    800744 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 10                	mov    (%eax),%edx
  80071d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800722:	8d 40 04             	lea    0x4(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800728:	b8 10 00 00 00       	mov    $0x10,%eax
  80072d:	eb a1                	jmp    8006d0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 10                	mov    (%eax),%edx
  800734:	8b 48 04             	mov    0x4(%eax),%ecx
  800737:	8d 40 08             	lea    0x8(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073d:	b8 10 00 00 00       	mov    $0x10,%eax
  800742:	eb 8c                	jmp    8006d0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 10                	mov    (%eax),%edx
  800749:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074e:	8d 40 04             	lea    0x4(%eax),%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800754:	b8 10 00 00 00       	mov    $0x10,%eax
  800759:	e9 72 ff ff ff       	jmp    8006d0 <vprintfmt+0x3a8>
			putch(ch, putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 25                	push   $0x25
  800764:	ff d6                	call   *%esi
			break;
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	e9 7c ff ff ff       	jmp    8006ea <vprintfmt+0x3c2>
			putch('%', putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	53                   	push   %ebx
  800772:	6a 25                	push   $0x25
  800774:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	89 f8                	mov    %edi,%eax
  80077b:	eb 01                	jmp    80077e <vprintfmt+0x456>
  80077d:	48                   	dec    %eax
  80077e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800782:	75 f9                	jne    80077d <vprintfmt+0x455>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800787:	e9 5e ff ff ff       	jmp    8006ea <vprintfmt+0x3c2>
}
  80078c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078f:	5b                   	pop    %ebx
  800790:	5e                   	pop    %esi
  800791:	5f                   	pop    %edi
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 18             	sub    $0x18,%esp
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b1:	85 c0                	test   %eax,%eax
  8007b3:	74 26                	je     8007db <vsnprintf+0x47>
  8007b5:	85 d2                	test   %edx,%edx
  8007b7:	7e 29                	jle    8007e2 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b9:	ff 75 14             	pushl  0x14(%ebp)
  8007bc:	ff 75 10             	pushl  0x10(%ebp)
  8007bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c2:	50                   	push   %eax
  8007c3:	68 ef 02 80 00       	push   $0x8002ef
  8007c8:	e8 5b fb ff ff       	call   800328 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d6:	83 c4 10             	add    $0x10,%esp
}
  8007d9:	c9                   	leave  
  8007da:	c3                   	ret    
		return -E_INVAL;
  8007db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e0:	eb f7                	jmp    8007d9 <vsnprintf+0x45>
  8007e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e7:	eb f0                	jmp    8007d9 <vsnprintf+0x45>

008007e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ef:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f2:	50                   	push   %eax
  8007f3:	ff 75 10             	pushl  0x10(%ebp)
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	ff 75 08             	pushl  0x8(%ebp)
  8007fc:	e8 93 ff ff ff       	call   800794 <vsnprintf>
	va_end(ap);

	return rc;
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800809:	b8 00 00 00 00       	mov    $0x0,%eax
  80080e:	eb 01                	jmp    800811 <strlen+0xe>
		n++;
  800810:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800811:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800815:	75 f9                	jne    800810 <strlen+0xd>
	return n;
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800822:	b8 00 00 00 00       	mov    $0x0,%eax
  800827:	eb 01                	jmp    80082a <strnlen+0x11>
		n++;
  800829:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082a:	39 d0                	cmp    %edx,%eax
  80082c:	74 06                	je     800834 <strnlen+0x1b>
  80082e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800832:	75 f5                	jne    800829 <strnlen+0x10>
	return n;
}
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	53                   	push   %ebx
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800840:	89 c2                	mov    %eax,%edx
  800842:	42                   	inc    %edx
  800843:	41                   	inc    %ecx
  800844:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800847:	88 5a ff             	mov    %bl,-0x1(%edx)
  80084a:	84 db                	test   %bl,%bl
  80084c:	75 f4                	jne    800842 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80084e:	5b                   	pop    %ebx
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	53                   	push   %ebx
  800855:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800858:	53                   	push   %ebx
  800859:	e8 a5 ff ff ff       	call   800803 <strlen>
  80085e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	01 d8                	add    %ebx,%eax
  800866:	50                   	push   %eax
  800867:	e8 ca ff ff ff       	call   800836 <strcpy>
	return dst;
}
  80086c:	89 d8                	mov    %ebx,%eax
  80086e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800871:	c9                   	leave  
  800872:	c3                   	ret    

00800873 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	56                   	push   %esi
  800877:	53                   	push   %ebx
  800878:	8b 75 08             	mov    0x8(%ebp),%esi
  80087b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087e:	89 f3                	mov    %esi,%ebx
  800880:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800883:	89 f2                	mov    %esi,%edx
  800885:	eb 0c                	jmp    800893 <strncpy+0x20>
		*dst++ = *src;
  800887:	42                   	inc    %edx
  800888:	8a 01                	mov    (%ecx),%al
  80088a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80088d:	80 39 01             	cmpb   $0x1,(%ecx)
  800890:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800893:	39 da                	cmp    %ebx,%edx
  800895:	75 f0                	jne    800887 <strncpy+0x14>
	}
	return ret;
}
  800897:	89 f0                	mov    %esi,%eax
  800899:	5b                   	pop    %ebx
  80089a:	5e                   	pop    %esi
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	56                   	push   %esi
  8008a1:	53                   	push   %ebx
  8008a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a8:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ab:	85 c0                	test   %eax,%eax
  8008ad:	74 20                	je     8008cf <strlcpy+0x32>
  8008af:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8008b3:	89 f0                	mov    %esi,%eax
  8008b5:	eb 05                	jmp    8008bc <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b7:	40                   	inc    %eax
  8008b8:	42                   	inc    %edx
  8008b9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008bc:	39 d8                	cmp    %ebx,%eax
  8008be:	74 06                	je     8008c6 <strlcpy+0x29>
  8008c0:	8a 0a                	mov    (%edx),%cl
  8008c2:	84 c9                	test   %cl,%cl
  8008c4:	75 f1                	jne    8008b7 <strlcpy+0x1a>
		*dst = '\0';
  8008c6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008c9:	29 f0                	sub    %esi,%eax
}
  8008cb:	5b                   	pop    %ebx
  8008cc:	5e                   	pop    %esi
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	eb f6                	jmp    8008c9 <strlcpy+0x2c>

008008d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008dc:	eb 02                	jmp    8008e0 <strcmp+0xd>
		p++, q++;
  8008de:	41                   	inc    %ecx
  8008df:	42                   	inc    %edx
	while (*p && *p == *q)
  8008e0:	8a 01                	mov    (%ecx),%al
  8008e2:	84 c0                	test   %al,%al
  8008e4:	74 04                	je     8008ea <strcmp+0x17>
  8008e6:	3a 02                	cmp    (%edx),%al
  8008e8:	74 f4                	je     8008de <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ea:	0f b6 c0             	movzbl %al,%eax
  8008ed:	0f b6 12             	movzbl (%edx),%edx
  8008f0:	29 d0                	sub    %edx,%eax
}
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	53                   	push   %ebx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	89 c3                	mov    %eax,%ebx
  800900:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800903:	eb 02                	jmp    800907 <strncmp+0x13>
		n--, p++, q++;
  800905:	40                   	inc    %eax
  800906:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800907:	39 d8                	cmp    %ebx,%eax
  800909:	74 15                	je     800920 <strncmp+0x2c>
  80090b:	8a 08                	mov    (%eax),%cl
  80090d:	84 c9                	test   %cl,%cl
  80090f:	74 04                	je     800915 <strncmp+0x21>
  800911:	3a 0a                	cmp    (%edx),%cl
  800913:	74 f0                	je     800905 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800915:	0f b6 00             	movzbl (%eax),%eax
  800918:	0f b6 12             	movzbl (%edx),%edx
  80091b:	29 d0                	sub    %edx,%eax
}
  80091d:	5b                   	pop    %ebx
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    
		return 0;
  800920:	b8 00 00 00 00       	mov    $0x0,%eax
  800925:	eb f6                	jmp    80091d <strncmp+0x29>

00800927 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800930:	8a 10                	mov    (%eax),%dl
  800932:	84 d2                	test   %dl,%dl
  800934:	74 07                	je     80093d <strchr+0x16>
		if (*s == c)
  800936:	38 ca                	cmp    %cl,%dl
  800938:	74 08                	je     800942 <strchr+0x1b>
	for (; *s; s++)
  80093a:	40                   	inc    %eax
  80093b:	eb f3                	jmp    800930 <strchr+0x9>
			return (char *) s;
	return 0;
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80094d:	8a 10                	mov    (%eax),%dl
  80094f:	84 d2                	test   %dl,%dl
  800951:	74 07                	je     80095a <strfind+0x16>
		if (*s == c)
  800953:	38 ca                	cmp    %cl,%dl
  800955:	74 03                	je     80095a <strfind+0x16>
	for (; *s; s++)
  800957:	40                   	inc    %eax
  800958:	eb f3                	jmp    80094d <strfind+0x9>
			break;
	return (char *) s;
}
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	57                   	push   %edi
  800960:	56                   	push   %esi
  800961:	53                   	push   %ebx
  800962:	8b 7d 08             	mov    0x8(%ebp),%edi
  800965:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800968:	85 c9                	test   %ecx,%ecx
  80096a:	74 13                	je     80097f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80096c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800972:	75 05                	jne    800979 <memset+0x1d>
  800974:	f6 c1 03             	test   $0x3,%cl
  800977:	74 0d                	je     800986 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097c:	fc                   	cld    
  80097d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80097f:	89 f8                	mov    %edi,%eax
  800981:	5b                   	pop    %ebx
  800982:	5e                   	pop    %esi
  800983:	5f                   	pop    %edi
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    
		c &= 0xFF;
  800986:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80098a:	89 d3                	mov    %edx,%ebx
  80098c:	c1 e3 08             	shl    $0x8,%ebx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	c1 e0 18             	shl    $0x18,%eax
  800994:	89 d6                	mov    %edx,%esi
  800996:	c1 e6 10             	shl    $0x10,%esi
  800999:	09 f0                	or     %esi,%eax
  80099b:	09 c2                	or     %eax,%edx
  80099d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80099f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009a2:	89 d0                	mov    %edx,%eax
  8009a4:	fc                   	cld    
  8009a5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a7:	eb d6                	jmp    80097f <memset+0x23>

008009a9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	57                   	push   %edi
  8009ad:	56                   	push   %esi
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b7:	39 c6                	cmp    %eax,%esi
  8009b9:	73 33                	jae    8009ee <memmove+0x45>
  8009bb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009be:	39 d0                	cmp    %edx,%eax
  8009c0:	73 2c                	jae    8009ee <memmove+0x45>
		s += n;
		d += n;
  8009c2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c5:	89 d6                	mov    %edx,%esi
  8009c7:	09 fe                	or     %edi,%esi
  8009c9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009cf:	75 13                	jne    8009e4 <memmove+0x3b>
  8009d1:	f6 c1 03             	test   $0x3,%cl
  8009d4:	75 0e                	jne    8009e4 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d6:	83 ef 04             	sub    $0x4,%edi
  8009d9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009df:	fd                   	std    
  8009e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e2:	eb 07                	jmp    8009eb <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e4:	4f                   	dec    %edi
  8009e5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e8:	fd                   	std    
  8009e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009eb:	fc                   	cld    
  8009ec:	eb 13                	jmp    800a01 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ee:	89 f2                	mov    %esi,%edx
  8009f0:	09 c2                	or     %eax,%edx
  8009f2:	f6 c2 03             	test   $0x3,%dl
  8009f5:	75 05                	jne    8009fc <memmove+0x53>
  8009f7:	f6 c1 03             	test   $0x3,%cl
  8009fa:	74 09                	je     800a05 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009fc:	89 c7                	mov    %eax,%edi
  8009fe:	fc                   	cld    
  8009ff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a01:	5e                   	pop    %esi
  800a02:	5f                   	pop    %edi
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a05:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a08:	89 c7                	mov    %eax,%edi
  800a0a:	fc                   	cld    
  800a0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0d:	eb f2                	jmp    800a01 <memmove+0x58>

00800a0f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a12:	ff 75 10             	pushl  0x10(%ebp)
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	ff 75 08             	pushl  0x8(%ebp)
  800a1b:	e8 89 ff ff ff       	call   8009a9 <memmove>
}
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	56                   	push   %esi
  800a26:	53                   	push   %ebx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	89 c6                	mov    %eax,%esi
  800a2c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a32:	39 f0                	cmp    %esi,%eax
  800a34:	74 16                	je     800a4c <memcmp+0x2a>
		if (*s1 != *s2)
  800a36:	8a 08                	mov    (%eax),%cl
  800a38:	8a 1a                	mov    (%edx),%bl
  800a3a:	38 d9                	cmp    %bl,%cl
  800a3c:	75 04                	jne    800a42 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a3e:	40                   	inc    %eax
  800a3f:	42                   	inc    %edx
  800a40:	eb f0                	jmp    800a32 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a42:	0f b6 c1             	movzbl %cl,%eax
  800a45:	0f b6 db             	movzbl %bl,%ebx
  800a48:	29 d8                	sub    %ebx,%eax
  800a4a:	eb 05                	jmp    800a51 <memcmp+0x2f>
	}

	return 0;
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a51:	5b                   	pop    %ebx
  800a52:	5e                   	pop    %esi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5e:	89 c2                	mov    %eax,%edx
  800a60:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a63:	39 d0                	cmp    %edx,%eax
  800a65:	73 07                	jae    800a6e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a67:	38 08                	cmp    %cl,(%eax)
  800a69:	74 03                	je     800a6e <memfind+0x19>
	for (; s < ends; s++)
  800a6b:	40                   	inc    %eax
  800a6c:	eb f5                	jmp    800a63 <memfind+0xe>
			break;
	return (void *) s;
}
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	57                   	push   %edi
  800a74:	56                   	push   %esi
  800a75:	53                   	push   %ebx
  800a76:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a79:	eb 01                	jmp    800a7c <strtol+0xc>
		s++;
  800a7b:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a7c:	8a 01                	mov    (%ecx),%al
  800a7e:	3c 20                	cmp    $0x20,%al
  800a80:	74 f9                	je     800a7b <strtol+0xb>
  800a82:	3c 09                	cmp    $0x9,%al
  800a84:	74 f5                	je     800a7b <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a86:	3c 2b                	cmp    $0x2b,%al
  800a88:	74 2b                	je     800ab5 <strtol+0x45>
		s++;
	else if (*s == '-')
  800a8a:	3c 2d                	cmp    $0x2d,%al
  800a8c:	74 2f                	je     800abd <strtol+0x4d>
	int neg = 0;
  800a8e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a93:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a9a:	75 12                	jne    800aae <strtol+0x3e>
  800a9c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9f:	74 24                	je     800ac5 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa5:	75 07                	jne    800aae <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	eb 4e                	jmp    800b03 <strtol+0x93>
		s++;
  800ab5:	41                   	inc    %ecx
	int neg = 0;
  800ab6:	bf 00 00 00 00       	mov    $0x0,%edi
  800abb:	eb d6                	jmp    800a93 <strtol+0x23>
		s++, neg = 1;
  800abd:	41                   	inc    %ecx
  800abe:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac3:	eb ce                	jmp    800a93 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac9:	74 10                	je     800adb <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800acb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acf:	75 dd                	jne    800aae <strtol+0x3e>
		s++, base = 8;
  800ad1:	41                   	inc    %ecx
  800ad2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ad9:	eb d3                	jmp    800aae <strtol+0x3e>
		s += 2, base = 16;
  800adb:	83 c1 02             	add    $0x2,%ecx
  800ade:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ae5:	eb c7                	jmp    800aae <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ae7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aea:	89 f3                	mov    %esi,%ebx
  800aec:	80 fb 19             	cmp    $0x19,%bl
  800aef:	77 24                	ja     800b15 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800af1:	0f be d2             	movsbl %dl,%edx
  800af4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800afa:	7d 2b                	jge    800b27 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800afc:	41                   	inc    %ecx
  800afd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b01:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b03:	8a 11                	mov    (%ecx),%dl
  800b05:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b08:	80 fb 09             	cmp    $0x9,%bl
  800b0b:	77 da                	ja     800ae7 <strtol+0x77>
			dig = *s - '0';
  800b0d:	0f be d2             	movsbl %dl,%edx
  800b10:	83 ea 30             	sub    $0x30,%edx
  800b13:	eb e2                	jmp    800af7 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b15:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b18:	89 f3                	mov    %esi,%ebx
  800b1a:	80 fb 19             	cmp    $0x19,%bl
  800b1d:	77 08                	ja     800b27 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b1f:	0f be d2             	movsbl %dl,%edx
  800b22:	83 ea 37             	sub    $0x37,%edx
  800b25:	eb d0                	jmp    800af7 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2b:	74 05                	je     800b32 <strtol+0xc2>
		*endptr = (char *) s;
  800b2d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b30:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b32:	85 ff                	test   %edi,%edi
  800b34:	74 02                	je     800b38 <strtol+0xc8>
  800b36:	f7 d8                	neg    %eax
}
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <atoi>:

int
atoi(const char *s)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b40:	6a 0a                	push   $0xa
  800b42:	6a 00                	push   $0x0
  800b44:	ff 75 08             	pushl  0x8(%ebp)
  800b47:	e8 24 ff ff ff       	call   800a70 <strtol>
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5f:	89 c3                	mov    %eax,%ebx
  800b61:	89 c7                	mov    %eax,%edi
  800b63:	89 c6                	mov    %eax,%esi
  800b65:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5f                   	pop    %edi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	57                   	push   %edi
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
  800b77:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7c:	89 d1                	mov    %edx,%ecx
  800b7e:	89 d3                	mov    %edx,%ebx
  800b80:	89 d7                	mov    %edx,%edi
  800b82:	89 d6                	mov    %edx,%esi
  800b84:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5f                   	pop    %edi
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	57                   	push   %edi
  800b8f:	56                   	push   %esi
  800b90:	53                   	push   %ebx
  800b91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b99:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba1:	89 cb                	mov    %ecx,%ebx
  800ba3:	89 cf                	mov    %ecx,%edi
  800ba5:	89 ce                	mov    %ecx,%esi
  800ba7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba9:	85 c0                	test   %eax,%eax
  800bab:	7f 08                	jg     800bb5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb5:	83 ec 0c             	sub    $0xc,%esp
  800bb8:	50                   	push   %eax
  800bb9:	6a 03                	push   $0x3
  800bbb:	68 7f 23 80 00       	push   $0x80237f
  800bc0:	6a 23                	push   $0x23
  800bc2:	68 9c 23 80 00       	push   $0x80239c
  800bc7:	e8 4f f5 ff ff       	call   80011b <_panic>

00800bcc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd7:	b8 02 00 00 00       	mov    $0x2,%eax
  800bdc:	89 d1                	mov    %edx,%ecx
  800bde:	89 d3                	mov    %edx,%ebx
  800be0:	89 d7                	mov    %edx,%edi
  800be2:	89 d6                	mov    %edx,%esi
  800be4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
  800bf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf4:	be 00 00 00 00       	mov    $0x0,%esi
  800bf9:	b8 04 00 00 00       	mov    $0x4,%eax
  800bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c01:	8b 55 08             	mov    0x8(%ebp),%edx
  800c04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c07:	89 f7                	mov    %esi,%edi
  800c09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0b:	85 c0                	test   %eax,%eax
  800c0d:	7f 08                	jg     800c17 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c17:	83 ec 0c             	sub    $0xc,%esp
  800c1a:	50                   	push   %eax
  800c1b:	6a 04                	push   $0x4
  800c1d:	68 7f 23 80 00       	push   $0x80237f
  800c22:	6a 23                	push   $0x23
  800c24:	68 9c 23 80 00       	push   $0x80239c
  800c29:	e8 ed f4 ff ff       	call   80011b <_panic>

00800c2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c37:	b8 05 00 00 00       	mov    $0x5,%eax
  800c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c48:	8b 75 18             	mov    0x18(%ebp),%esi
  800c4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4d:	85 c0                	test   %eax,%eax
  800c4f:	7f 08                	jg     800c59 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5f                   	pop    %edi
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c59:	83 ec 0c             	sub    $0xc,%esp
  800c5c:	50                   	push   %eax
  800c5d:	6a 05                	push   $0x5
  800c5f:	68 7f 23 80 00       	push   $0x80237f
  800c64:	6a 23                	push   $0x23
  800c66:	68 9c 23 80 00       	push   $0x80239c
  800c6b:	e8 ab f4 ff ff       	call   80011b <_panic>

00800c70 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
  800c76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	89 df                	mov    %ebx,%edi
  800c8b:	89 de                	mov    %ebx,%esi
  800c8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	7f 08                	jg     800c9b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	50                   	push   %eax
  800c9f:	6a 06                	push   $0x6
  800ca1:	68 7f 23 80 00       	push   $0x80237f
  800ca6:	6a 23                	push   $0x23
  800ca8:	68 9c 23 80 00       	push   $0x80239c
  800cad:	e8 69 f4 ff ff       	call   80011b <_panic>

00800cb2 <sys_yield>:

void
sys_yield(void)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	57                   	push   %edi
  800cb6:	56                   	push   %esi
  800cb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc2:	89 d1                	mov    %edx,%ecx
  800cc4:	89 d3                	mov    %edx,%ebx
  800cc6:	89 d7                	mov    %edx,%edi
  800cc8:	89 d6                	mov    %edx,%esi
  800cca:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdf:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cea:	89 df                	mov    %ebx,%edi
  800cec:	89 de                	mov    %ebx,%esi
  800cee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	7f 08                	jg     800cfc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 08                	push   $0x8
  800d02:	68 7f 23 80 00       	push   $0x80237f
  800d07:	6a 23                	push   $0x23
  800d09:	68 9c 23 80 00       	push   $0x80239c
  800d0e:	e8 08 f4 ff ff       	call   80011b <_panic>

00800d13 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	89 cb                	mov    %ecx,%ebx
  800d2b:	89 cf                	mov    %ecx,%edi
  800d2d:	89 ce                	mov    %ecx,%esi
  800d2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d31:	85 c0                	test   %eax,%eax
  800d33:	7f 08                	jg     800d3d <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3d:	83 ec 0c             	sub    $0xc,%esp
  800d40:	50                   	push   %eax
  800d41:	6a 0c                	push   $0xc
  800d43:	68 7f 23 80 00       	push   $0x80237f
  800d48:	6a 23                	push   $0x23
  800d4a:	68 9c 23 80 00       	push   $0x80239c
  800d4f:	e8 c7 f3 ff ff       	call   80011b <_panic>

00800d54 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d62:	b8 09 00 00 00       	mov    $0x9,%eax
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	89 df                	mov    %ebx,%edi
  800d6f:	89 de                	mov    %ebx,%esi
  800d71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	7f 08                	jg     800d7f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7f:	83 ec 0c             	sub    $0xc,%esp
  800d82:	50                   	push   %eax
  800d83:	6a 09                	push   $0x9
  800d85:	68 7f 23 80 00       	push   $0x80237f
  800d8a:	6a 23                	push   $0x23
  800d8c:	68 9c 23 80 00       	push   $0x80239c
  800d91:	e8 85 f3 ff ff       	call   80011b <_panic>

00800d96 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
  800d9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dac:	8b 55 08             	mov    0x8(%ebp),%edx
  800daf:	89 df                	mov    %ebx,%edi
  800db1:	89 de                	mov    %ebx,%esi
  800db3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	7f 08                	jg     800dc1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc1:	83 ec 0c             	sub    $0xc,%esp
  800dc4:	50                   	push   %eax
  800dc5:	6a 0a                	push   $0xa
  800dc7:	68 7f 23 80 00       	push   $0x80237f
  800dcc:	6a 23                	push   $0x23
  800dce:	68 9c 23 80 00       	push   $0x80239c
  800dd3:	e8 43 f3 ff ff       	call   80011b <_panic>

00800dd8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dde:	be 00 00 00 00       	mov    $0x0,%esi
  800de3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e09:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	89 cb                	mov    %ecx,%ebx
  800e13:	89 cf                	mov    %ecx,%edi
  800e15:	89 ce                	mov    %ecx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 0e                	push   $0xe
  800e2b:	68 7f 23 80 00       	push   $0x80237f
  800e30:	6a 23                	push   $0x23
  800e32:	68 9c 23 80 00       	push   $0x80239c
  800e37:	e8 df f2 ff ff       	call   80011b <_panic>

00800e3c <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e42:	be 00 00 00 00       	mov    $0x0,%esi
  800e47:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e55:	89 f7                	mov    %esi,%edi
  800e57:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e64:	be 00 00 00 00       	mov    $0x0,%esi
  800e69:	b8 10 00 00 00       	mov    $0x10,%eax
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
  800e74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e77:	89 f7                	mov    %esi,%edi
  800e79:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e86:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8b:	b8 11 00 00 00       	mov    $0x11,%eax
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	89 cb                	mov    %ecx,%ebx
  800e95:	89 cf                	mov    %ecx,%edi
  800e97:	89 ce                	mov    %ecx,%esi
  800e99:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800ea6:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800ead:	74 0a                	je     800eb9 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  800eb9:	e8 0e fd ff ff       	call   800bcc <sys_getenvid>
  800ebe:	83 ec 04             	sub    $0x4,%esp
  800ec1:	6a 07                	push   $0x7
  800ec3:	68 00 f0 bf ee       	push   $0xeebff000
  800ec8:	50                   	push   %eax
  800ec9:	e8 1d fd ff ff       	call   800beb <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  800ece:	e8 f9 fc ff ff       	call   800bcc <sys_getenvid>
  800ed3:	83 c4 08             	add    $0x8,%esp
  800ed6:	68 e6 0e 80 00       	push   $0x800ee6
  800edb:	50                   	push   %eax
  800edc:	e8 b5 fe ff ff       	call   800d96 <sys_env_set_pgfault_upcall>
  800ee1:	83 c4 10             	add    $0x10,%esp
  800ee4:	eb c9                	jmp    800eaf <set_pgfault_handler+0xf>

00800ee6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800ee6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800ee7:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800eec:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800eee:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  800ef1:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800ef5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800ef9:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800efc:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800efe:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  800f02:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800f05:	61                   	popa   
	addl $4, %esp
  800f06:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  800f09:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800f0a:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800f0b:	c3                   	ret    

00800f0c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	05 00 00 00 30       	add    $0x30000000,%eax
  800f17:	c1 e8 0c             	shr    $0xc,%eax
}
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f2c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f39:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f3e:	89 c2                	mov    %eax,%edx
  800f40:	c1 ea 16             	shr    $0x16,%edx
  800f43:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f4a:	f6 c2 01             	test   $0x1,%dl
  800f4d:	74 2a                	je     800f79 <fd_alloc+0x46>
  800f4f:	89 c2                	mov    %eax,%edx
  800f51:	c1 ea 0c             	shr    $0xc,%edx
  800f54:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f5b:	f6 c2 01             	test   $0x1,%dl
  800f5e:	74 19                	je     800f79 <fd_alloc+0x46>
  800f60:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f65:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f6a:	75 d2                	jne    800f3e <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f6c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f72:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f77:	eb 07                	jmp    800f80 <fd_alloc+0x4d>
			*fd_store = fd;
  800f79:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f85:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800f89:	77 39                	ja     800fc4 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	c1 e0 0c             	shl    $0xc,%eax
  800f91:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f96:	89 c2                	mov    %eax,%edx
  800f98:	c1 ea 16             	shr    $0x16,%edx
  800f9b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fa2:	f6 c2 01             	test   $0x1,%dl
  800fa5:	74 24                	je     800fcb <fd_lookup+0x49>
  800fa7:	89 c2                	mov    %eax,%edx
  800fa9:	c1 ea 0c             	shr    $0xc,%edx
  800fac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb3:	f6 c2 01             	test   $0x1,%dl
  800fb6:	74 1a                	je     800fd2 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbb:	89 02                	mov    %eax,(%edx)
	return 0;
  800fbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    
		return -E_INVAL;
  800fc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc9:	eb f7                	jmp    800fc2 <fd_lookup+0x40>
		return -E_INVAL;
  800fcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd0:	eb f0                	jmp    800fc2 <fd_lookup+0x40>
  800fd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd7:	eb e9                	jmp    800fc2 <fd_lookup+0x40>

00800fd9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 08             	sub    $0x8,%esp
  800fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe2:	ba 28 24 80 00       	mov    $0x802428,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800fe7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fec:	39 08                	cmp    %ecx,(%eax)
  800fee:	74 33                	je     801023 <dev_lookup+0x4a>
  800ff0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ff3:	8b 02                	mov    (%edx),%eax
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	75 f3                	jne    800fec <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ff9:	a1 04 40 80 00       	mov    0x804004,%eax
  800ffe:	8b 40 48             	mov    0x48(%eax),%eax
  801001:	83 ec 04             	sub    $0x4,%esp
  801004:	51                   	push   %ecx
  801005:	50                   	push   %eax
  801006:	68 ac 23 80 00       	push   $0x8023ac
  80100b:	e8 1e f2 ff ff       	call   80022e <cprintf>
	*dev = 0;
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801021:	c9                   	leave  
  801022:	c3                   	ret    
			*dev = devtab[i];
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	89 01                	mov    %eax,(%ecx)
			return 0;
  801028:	b8 00 00 00 00       	mov    $0x0,%eax
  80102d:	eb f2                	jmp    801021 <dev_lookup+0x48>

0080102f <fd_close>:
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	57                   	push   %edi
  801033:	56                   	push   %esi
  801034:	53                   	push   %ebx
  801035:	83 ec 1c             	sub    $0x1c,%esp
  801038:	8b 75 08             	mov    0x8(%ebp),%esi
  80103b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80103e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801041:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801042:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801048:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80104b:	50                   	push   %eax
  80104c:	e8 31 ff ff ff       	call   800f82 <fd_lookup>
  801051:	89 c7                	mov    %eax,%edi
  801053:	83 c4 08             	add    $0x8,%esp
  801056:	85 c0                	test   %eax,%eax
  801058:	78 05                	js     80105f <fd_close+0x30>
	    || fd != fd2)
  80105a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  80105d:	74 13                	je     801072 <fd_close+0x43>
		return (must_exist ? r : 0);
  80105f:	84 db                	test   %bl,%bl
  801061:	75 05                	jne    801068 <fd_close+0x39>
  801063:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801068:	89 f8                	mov    %edi,%eax
  80106a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5f                   	pop    %edi
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801072:	83 ec 08             	sub    $0x8,%esp
  801075:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	ff 36                	pushl  (%esi)
  80107b:	e8 59 ff ff ff       	call   800fd9 <dev_lookup>
  801080:	89 c7                	mov    %eax,%edi
  801082:	83 c4 10             	add    $0x10,%esp
  801085:	85 c0                	test   %eax,%eax
  801087:	78 15                	js     80109e <fd_close+0x6f>
		if (dev->dev_close)
  801089:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80108c:	8b 40 10             	mov    0x10(%eax),%eax
  80108f:	85 c0                	test   %eax,%eax
  801091:	74 1b                	je     8010ae <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801093:	83 ec 0c             	sub    $0xc,%esp
  801096:	56                   	push   %esi
  801097:	ff d0                	call   *%eax
  801099:	89 c7                	mov    %eax,%edi
  80109b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80109e:	83 ec 08             	sub    $0x8,%esp
  8010a1:	56                   	push   %esi
  8010a2:	6a 00                	push   $0x0
  8010a4:	e8 c7 fb ff ff       	call   800c70 <sys_page_unmap>
	return r;
  8010a9:	83 c4 10             	add    $0x10,%esp
  8010ac:	eb ba                	jmp    801068 <fd_close+0x39>
			r = 0;
  8010ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8010b3:	eb e9                	jmp    80109e <fd_close+0x6f>

008010b5 <close>:

int
close(int fdnum)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010be:	50                   	push   %eax
  8010bf:	ff 75 08             	pushl  0x8(%ebp)
  8010c2:	e8 bb fe ff ff       	call   800f82 <fd_lookup>
  8010c7:	83 c4 08             	add    $0x8,%esp
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	78 10                	js     8010de <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	6a 01                	push   $0x1
  8010d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d6:	e8 54 ff ff ff       	call   80102f <fd_close>
  8010db:	83 c4 10             	add    $0x10,%esp
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <close_all>:

void
close_all(void)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010e7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010ec:	83 ec 0c             	sub    $0xc,%esp
  8010ef:	53                   	push   %ebx
  8010f0:	e8 c0 ff ff ff       	call   8010b5 <close>
	for (i = 0; i < MAXFD; i++)
  8010f5:	43                   	inc    %ebx
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	83 fb 20             	cmp    $0x20,%ebx
  8010fc:	75 ee                	jne    8010ec <close_all+0xc>
}
  8010fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	57                   	push   %edi
  801107:	56                   	push   %esi
  801108:	53                   	push   %ebx
  801109:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80110c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80110f:	50                   	push   %eax
  801110:	ff 75 08             	pushl  0x8(%ebp)
  801113:	e8 6a fe ff ff       	call   800f82 <fd_lookup>
  801118:	89 c3                	mov    %eax,%ebx
  80111a:	83 c4 08             	add    $0x8,%esp
  80111d:	85 c0                	test   %eax,%eax
  80111f:	0f 88 81 00 00 00    	js     8011a6 <dup+0xa3>
		return r;
	close(newfdnum);
  801125:	83 ec 0c             	sub    $0xc,%esp
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	e8 85 ff ff ff       	call   8010b5 <close>

	newfd = INDEX2FD(newfdnum);
  801130:	8b 75 0c             	mov    0xc(%ebp),%esi
  801133:	c1 e6 0c             	shl    $0xc,%esi
  801136:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80113c:	83 c4 04             	add    $0x4,%esp
  80113f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801142:	e8 d5 fd ff ff       	call   800f1c <fd2data>
  801147:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801149:	89 34 24             	mov    %esi,(%esp)
  80114c:	e8 cb fd ff ff       	call   800f1c <fd2data>
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801156:	89 d8                	mov    %ebx,%eax
  801158:	c1 e8 16             	shr    $0x16,%eax
  80115b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801162:	a8 01                	test   $0x1,%al
  801164:	74 11                	je     801177 <dup+0x74>
  801166:	89 d8                	mov    %ebx,%eax
  801168:	c1 e8 0c             	shr    $0xc,%eax
  80116b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801172:	f6 c2 01             	test   $0x1,%dl
  801175:	75 39                	jne    8011b0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801177:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80117a:	89 d0                	mov    %edx,%eax
  80117c:	c1 e8 0c             	shr    $0xc,%eax
  80117f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801186:	83 ec 0c             	sub    $0xc,%esp
  801189:	25 07 0e 00 00       	and    $0xe07,%eax
  80118e:	50                   	push   %eax
  80118f:	56                   	push   %esi
  801190:	6a 00                	push   $0x0
  801192:	52                   	push   %edx
  801193:	6a 00                	push   $0x0
  801195:	e8 94 fa ff ff       	call   800c2e <sys_page_map>
  80119a:	89 c3                	mov    %eax,%ebx
  80119c:	83 c4 20             	add    $0x20,%esp
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	78 31                	js     8011d4 <dup+0xd1>
		goto err;

	return newfdnum;
  8011a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011a6:	89 d8                	mov    %ebx,%eax
  8011a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5f                   	pop    %edi
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b7:	83 ec 0c             	sub    $0xc,%esp
  8011ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8011bf:	50                   	push   %eax
  8011c0:	57                   	push   %edi
  8011c1:	6a 00                	push   $0x0
  8011c3:	53                   	push   %ebx
  8011c4:	6a 00                	push   $0x0
  8011c6:	e8 63 fa ff ff       	call   800c2e <sys_page_map>
  8011cb:	89 c3                	mov    %eax,%ebx
  8011cd:	83 c4 20             	add    $0x20,%esp
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	79 a3                	jns    801177 <dup+0x74>
	sys_page_unmap(0, newfd);
  8011d4:	83 ec 08             	sub    $0x8,%esp
  8011d7:	56                   	push   %esi
  8011d8:	6a 00                	push   $0x0
  8011da:	e8 91 fa ff ff       	call   800c70 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011df:	83 c4 08             	add    $0x8,%esp
  8011e2:	57                   	push   %edi
  8011e3:	6a 00                	push   $0x0
  8011e5:	e8 86 fa ff ff       	call   800c70 <sys_page_unmap>
	return r;
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	eb b7                	jmp    8011a6 <dup+0xa3>

008011ef <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	53                   	push   %ebx
  8011f3:	83 ec 14             	sub    $0x14,%esp
  8011f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011fc:	50                   	push   %eax
  8011fd:	53                   	push   %ebx
  8011fe:	e8 7f fd ff ff       	call   800f82 <fd_lookup>
  801203:	83 c4 08             	add    $0x8,%esp
  801206:	85 c0                	test   %eax,%eax
  801208:	78 3f                	js     801249 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80120a:	83 ec 08             	sub    $0x8,%esp
  80120d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801210:	50                   	push   %eax
  801211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801214:	ff 30                	pushl  (%eax)
  801216:	e8 be fd ff ff       	call   800fd9 <dev_lookup>
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	85 c0                	test   %eax,%eax
  801220:	78 27                	js     801249 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801222:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801225:	8b 42 08             	mov    0x8(%edx),%eax
  801228:	83 e0 03             	and    $0x3,%eax
  80122b:	83 f8 01             	cmp    $0x1,%eax
  80122e:	74 1e                	je     80124e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801233:	8b 40 08             	mov    0x8(%eax),%eax
  801236:	85 c0                	test   %eax,%eax
  801238:	74 35                	je     80126f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80123a:	83 ec 04             	sub    $0x4,%esp
  80123d:	ff 75 10             	pushl  0x10(%ebp)
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	52                   	push   %edx
  801244:	ff d0                	call   *%eax
  801246:	83 c4 10             	add    $0x10,%esp
}
  801249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80124e:	a1 04 40 80 00       	mov    0x804004,%eax
  801253:	8b 40 48             	mov    0x48(%eax),%eax
  801256:	83 ec 04             	sub    $0x4,%esp
  801259:	53                   	push   %ebx
  80125a:	50                   	push   %eax
  80125b:	68 ed 23 80 00       	push   $0x8023ed
  801260:	e8 c9 ef ff ff       	call   80022e <cprintf>
		return -E_INVAL;
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126d:	eb da                	jmp    801249 <read+0x5a>
		return -E_NOT_SUPP;
  80126f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801274:	eb d3                	jmp    801249 <read+0x5a>

00801276 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	57                   	push   %edi
  80127a:	56                   	push   %esi
  80127b:	53                   	push   %ebx
  80127c:	83 ec 0c             	sub    $0xc,%esp
  80127f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801282:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801285:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128a:	39 f3                	cmp    %esi,%ebx
  80128c:	73 25                	jae    8012b3 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80128e:	83 ec 04             	sub    $0x4,%esp
  801291:	89 f0                	mov    %esi,%eax
  801293:	29 d8                	sub    %ebx,%eax
  801295:	50                   	push   %eax
  801296:	89 d8                	mov    %ebx,%eax
  801298:	03 45 0c             	add    0xc(%ebp),%eax
  80129b:	50                   	push   %eax
  80129c:	57                   	push   %edi
  80129d:	e8 4d ff ff ff       	call   8011ef <read>
		if (m < 0)
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	78 08                	js     8012b1 <readn+0x3b>
			return m;
		if (m == 0)
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	74 06                	je     8012b3 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012ad:	01 c3                	add    %eax,%ebx
  8012af:	eb d9                	jmp    80128a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012b3:	89 d8                	mov    %ebx,%eax
  8012b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5f                   	pop    %edi
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	53                   	push   %ebx
  8012c1:	83 ec 14             	sub    $0x14,%esp
  8012c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ca:	50                   	push   %eax
  8012cb:	53                   	push   %ebx
  8012cc:	e8 b1 fc ff ff       	call   800f82 <fd_lookup>
  8012d1:	83 c4 08             	add    $0x8,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	78 3a                	js     801312 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012de:	50                   	push   %eax
  8012df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e2:	ff 30                	pushl  (%eax)
  8012e4:	e8 f0 fc ff ff       	call   800fd9 <dev_lookup>
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	78 22                	js     801312 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012f7:	74 1e                	je     801317 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fc:	8b 52 0c             	mov    0xc(%edx),%edx
  8012ff:	85 d2                	test   %edx,%edx
  801301:	74 35                	je     801338 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801303:	83 ec 04             	sub    $0x4,%esp
  801306:	ff 75 10             	pushl  0x10(%ebp)
  801309:	ff 75 0c             	pushl  0xc(%ebp)
  80130c:	50                   	push   %eax
  80130d:	ff d2                	call   *%edx
  80130f:	83 c4 10             	add    $0x10,%esp
}
  801312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801315:	c9                   	leave  
  801316:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801317:	a1 04 40 80 00       	mov    0x804004,%eax
  80131c:	8b 40 48             	mov    0x48(%eax),%eax
  80131f:	83 ec 04             	sub    $0x4,%esp
  801322:	53                   	push   %ebx
  801323:	50                   	push   %eax
  801324:	68 09 24 80 00       	push   $0x802409
  801329:	e8 00 ef ff ff       	call   80022e <cprintf>
		return -E_INVAL;
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801336:	eb da                	jmp    801312 <write+0x55>
		return -E_NOT_SUPP;
  801338:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133d:	eb d3                	jmp    801312 <write+0x55>

0080133f <seek>:

int
seek(int fdnum, off_t offset)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801345:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801348:	50                   	push   %eax
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	e8 31 fc ff ff       	call   800f82 <fd_lookup>
  801351:	83 c4 08             	add    $0x8,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 0e                	js     801366 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801358:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801361:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	53                   	push   %ebx
  80136c:	83 ec 14             	sub    $0x14,%esp
  80136f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801372:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801375:	50                   	push   %eax
  801376:	53                   	push   %ebx
  801377:	e8 06 fc ff ff       	call   800f82 <fd_lookup>
  80137c:	83 c4 08             	add    $0x8,%esp
  80137f:	85 c0                	test   %eax,%eax
  801381:	78 37                	js     8013ba <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801383:	83 ec 08             	sub    $0x8,%esp
  801386:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801389:	50                   	push   %eax
  80138a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138d:	ff 30                	pushl  (%eax)
  80138f:	e8 45 fc ff ff       	call   800fd9 <dev_lookup>
  801394:	83 c4 10             	add    $0x10,%esp
  801397:	85 c0                	test   %eax,%eax
  801399:	78 1f                	js     8013ba <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a2:	74 1b                	je     8013bf <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a7:	8b 52 18             	mov    0x18(%edx),%edx
  8013aa:	85 d2                	test   %edx,%edx
  8013ac:	74 32                	je     8013e0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	ff 75 0c             	pushl  0xc(%ebp)
  8013b4:	50                   	push   %eax
  8013b5:	ff d2                	call   *%edx
  8013b7:	83 c4 10             	add    $0x10,%esp
}
  8013ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013bf:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013c4:	8b 40 48             	mov    0x48(%eax),%eax
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	53                   	push   %ebx
  8013cb:	50                   	push   %eax
  8013cc:	68 cc 23 80 00       	push   $0x8023cc
  8013d1:	e8 58 ee ff ff       	call   80022e <cprintf>
		return -E_INVAL;
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013de:	eb da                	jmp    8013ba <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013e0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e5:	eb d3                	jmp    8013ba <ftruncate+0x52>

008013e7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	53                   	push   %ebx
  8013eb:	83 ec 14             	sub    $0x14,%esp
  8013ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f4:	50                   	push   %eax
  8013f5:	ff 75 08             	pushl  0x8(%ebp)
  8013f8:	e8 85 fb ff ff       	call   800f82 <fd_lookup>
  8013fd:	83 c4 08             	add    $0x8,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	78 4b                	js     80144f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801404:	83 ec 08             	sub    $0x8,%esp
  801407:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140a:	50                   	push   %eax
  80140b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140e:	ff 30                	pushl  (%eax)
  801410:	e8 c4 fb ff ff       	call   800fd9 <dev_lookup>
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 33                	js     80144f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80141c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801423:	74 2f                	je     801454 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801425:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801428:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80142f:	00 00 00 
	stat->st_type = 0;
  801432:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801439:	00 00 00 
	stat->st_dev = dev;
  80143c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801442:	83 ec 08             	sub    $0x8,%esp
  801445:	53                   	push   %ebx
  801446:	ff 75 f0             	pushl  -0x10(%ebp)
  801449:	ff 50 14             	call   *0x14(%eax)
  80144c:	83 c4 10             	add    $0x10,%esp
}
  80144f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801452:	c9                   	leave  
  801453:	c3                   	ret    
		return -E_NOT_SUPP;
  801454:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801459:	eb f4                	jmp    80144f <fstat+0x68>

0080145b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	56                   	push   %esi
  80145f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	6a 00                	push   $0x0
  801465:	ff 75 08             	pushl  0x8(%ebp)
  801468:	e8 34 02 00 00       	call   8016a1 <open>
  80146d:	89 c3                	mov    %eax,%ebx
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	85 c0                	test   %eax,%eax
  801474:	78 1b                	js     801491 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	50                   	push   %eax
  80147d:	e8 65 ff ff ff       	call   8013e7 <fstat>
  801482:	89 c6                	mov    %eax,%esi
	close(fd);
  801484:	89 1c 24             	mov    %ebx,(%esp)
  801487:	e8 29 fc ff ff       	call   8010b5 <close>
	return r;
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	89 f3                	mov    %esi,%ebx
}
  801491:	89 d8                	mov    %ebx,%eax
  801493:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801496:	5b                   	pop    %ebx
  801497:	5e                   	pop    %esi
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    

0080149a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	56                   	push   %esi
  80149e:	53                   	push   %ebx
  80149f:	89 c6                	mov    %eax,%esi
  8014a1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014a3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014aa:	74 27                	je     8014d3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ac:	6a 07                	push   $0x7
  8014ae:	68 00 50 80 00       	push   $0x805000
  8014b3:	56                   	push   %esi
  8014b4:	ff 35 00 40 80 00    	pushl  0x804000
  8014ba:	e8 e1 07 00 00       	call   801ca0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014bf:	83 c4 0c             	add    $0xc,%esp
  8014c2:	6a 00                	push   $0x0
  8014c4:	53                   	push   %ebx
  8014c5:	6a 00                	push   $0x0
  8014c7:	e8 4b 07 00 00       	call   801c17 <ipc_recv>
}
  8014cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014cf:	5b                   	pop    %ebx
  8014d0:	5e                   	pop    %esi
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	6a 01                	push   $0x1
  8014d8:	e8 1f 08 00 00       	call   801cfc <ipc_find_env>
  8014dd:	a3 00 40 80 00       	mov    %eax,0x804000
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	eb c5                	jmp    8014ac <fsipc+0x12>

008014e7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801500:	ba 00 00 00 00       	mov    $0x0,%edx
  801505:	b8 02 00 00 00       	mov    $0x2,%eax
  80150a:	e8 8b ff ff ff       	call   80149a <fsipc>
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <devfile_flush>:
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8b 40 0c             	mov    0xc(%eax),%eax
  80151d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801522:	ba 00 00 00 00       	mov    $0x0,%edx
  801527:	b8 06 00 00 00       	mov    $0x6,%eax
  80152c:	e8 69 ff ff ff       	call   80149a <fsipc>
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <devfile_stat>:
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	53                   	push   %ebx
  801537:	83 ec 04             	sub    $0x4,%esp
  80153a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8b 40 0c             	mov    0xc(%eax),%eax
  801543:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801548:	ba 00 00 00 00       	mov    $0x0,%edx
  80154d:	b8 05 00 00 00       	mov    $0x5,%eax
  801552:	e8 43 ff ff ff       	call   80149a <fsipc>
  801557:	85 c0                	test   %eax,%eax
  801559:	78 2c                	js     801587 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80155b:	83 ec 08             	sub    $0x8,%esp
  80155e:	68 00 50 80 00       	push   $0x805000
  801563:	53                   	push   %ebx
  801564:	e8 cd f2 ff ff       	call   800836 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801569:	a1 80 50 80 00       	mov    0x805080,%eax
  80156e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801574:	a1 84 50 80 00       	mov    0x805084,%eax
  801579:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <devfile_write>:
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	53                   	push   %ebx
  801590:	83 ec 04             	sub    $0x4,%esp
  801593:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801596:	89 d8                	mov    %ebx,%eax
  801598:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80159e:	76 05                	jbe    8015a5 <devfile_write+0x19>
  8015a0:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a8:	8b 52 0c             	mov    0xc(%edx),%edx
  8015ab:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8015b1:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	68 08 50 80 00       	push   $0x805008
  8015c2:	e8 e2 f3 ff ff       	call   8009a9 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8015c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cc:	b8 04 00 00 00       	mov    $0x4,%eax
  8015d1:	e8 c4 fe ff ff       	call   80149a <fsipc>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 0b                	js     8015e8 <devfile_write+0x5c>
	assert(r <= n);
  8015dd:	39 c3                	cmp    %eax,%ebx
  8015df:	72 0c                	jb     8015ed <devfile_write+0x61>
	assert(r <= PGSIZE);
  8015e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015e6:	7f 1e                	jg     801606 <devfile_write+0x7a>
}
  8015e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    
	assert(r <= n);
  8015ed:	68 38 24 80 00       	push   $0x802438
  8015f2:	68 3f 24 80 00       	push   $0x80243f
  8015f7:	68 98 00 00 00       	push   $0x98
  8015fc:	68 54 24 80 00       	push   $0x802454
  801601:	e8 15 eb ff ff       	call   80011b <_panic>
	assert(r <= PGSIZE);
  801606:	68 5f 24 80 00       	push   $0x80245f
  80160b:	68 3f 24 80 00       	push   $0x80243f
  801610:	68 99 00 00 00       	push   $0x99
  801615:	68 54 24 80 00       	push   $0x802454
  80161a:	e8 fc ea ff ff       	call   80011b <_panic>

0080161f <devfile_read>:
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	56                   	push   %esi
  801623:	53                   	push   %ebx
  801624:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8b 40 0c             	mov    0xc(%eax),%eax
  80162d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801632:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801638:	ba 00 00 00 00       	mov    $0x0,%edx
  80163d:	b8 03 00 00 00       	mov    $0x3,%eax
  801642:	e8 53 fe ff ff       	call   80149a <fsipc>
  801647:	89 c3                	mov    %eax,%ebx
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 1f                	js     80166c <devfile_read+0x4d>
	assert(r <= n);
  80164d:	39 c6                	cmp    %eax,%esi
  80164f:	72 24                	jb     801675 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801651:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801656:	7f 33                	jg     80168b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	50                   	push   %eax
  80165c:	68 00 50 80 00       	push   $0x805000
  801661:	ff 75 0c             	pushl  0xc(%ebp)
  801664:	e8 40 f3 ff ff       	call   8009a9 <memmove>
	return r;
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	89 d8                	mov    %ebx,%eax
  80166e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5d                   	pop    %ebp
  801674:	c3                   	ret    
	assert(r <= n);
  801675:	68 38 24 80 00       	push   $0x802438
  80167a:	68 3f 24 80 00       	push   $0x80243f
  80167f:	6a 7c                	push   $0x7c
  801681:	68 54 24 80 00       	push   $0x802454
  801686:	e8 90 ea ff ff       	call   80011b <_panic>
	assert(r <= PGSIZE);
  80168b:	68 5f 24 80 00       	push   $0x80245f
  801690:	68 3f 24 80 00       	push   $0x80243f
  801695:	6a 7d                	push   $0x7d
  801697:	68 54 24 80 00       	push   $0x802454
  80169c:	e8 7a ea ff ff       	call   80011b <_panic>

008016a1 <open>:
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	56                   	push   %esi
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 1c             	sub    $0x1c,%esp
  8016a9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016ac:	56                   	push   %esi
  8016ad:	e8 51 f1 ff ff       	call   800803 <strlen>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016ba:	7f 6c                	jg     801728 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016bc:	83 ec 0c             	sub    $0xc,%esp
  8016bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c2:	50                   	push   %eax
  8016c3:	e8 6b f8 ff ff       	call   800f33 <fd_alloc>
  8016c8:	89 c3                	mov    %eax,%ebx
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 3c                	js     80170d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	56                   	push   %esi
  8016d5:	68 00 50 80 00       	push   $0x805000
  8016da:	e8 57 f1 ff ff       	call   800836 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ef:	e8 a6 fd ff ff       	call   80149a <fsipc>
  8016f4:	89 c3                	mov    %eax,%ebx
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 19                	js     801716 <open+0x75>
	return fd2num(fd);
  8016fd:	83 ec 0c             	sub    $0xc,%esp
  801700:	ff 75 f4             	pushl  -0xc(%ebp)
  801703:	e8 04 f8 ff ff       	call   800f0c <fd2num>
  801708:	89 c3                	mov    %eax,%ebx
  80170a:	83 c4 10             	add    $0x10,%esp
}
  80170d:	89 d8                	mov    %ebx,%eax
  80170f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801712:	5b                   	pop    %ebx
  801713:	5e                   	pop    %esi
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    
		fd_close(fd, 0);
  801716:	83 ec 08             	sub    $0x8,%esp
  801719:	6a 00                	push   $0x0
  80171b:	ff 75 f4             	pushl  -0xc(%ebp)
  80171e:	e8 0c f9 ff ff       	call   80102f <fd_close>
		return r;
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	eb e5                	jmp    80170d <open+0x6c>
		return -E_BAD_PATH;
  801728:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80172d:	eb de                	jmp    80170d <open+0x6c>

0080172f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801735:	ba 00 00 00 00       	mov    $0x0,%edx
  80173a:	b8 08 00 00 00       	mov    $0x8,%eax
  80173f:	e8 56 fd ff ff       	call   80149a <fsipc>
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	56                   	push   %esi
  80174a:	53                   	push   %ebx
  80174b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	e8 c3 f7 ff ff       	call   800f1c <fd2data>
  801759:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80175b:	83 c4 08             	add    $0x8,%esp
  80175e:	68 6b 24 80 00       	push   $0x80246b
  801763:	53                   	push   %ebx
  801764:	e8 cd f0 ff ff       	call   800836 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801769:	8b 46 04             	mov    0x4(%esi),%eax
  80176c:	2b 06                	sub    (%esi),%eax
  80176e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801774:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  80177b:	10 00 00 
	stat->st_dev = &devpipe;
  80177e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801785:	30 80 00 
	return 0;
}
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801790:	5b                   	pop    %ebx
  801791:	5e                   	pop    %esi
  801792:	5d                   	pop    %ebp
  801793:	c3                   	ret    

00801794 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	53                   	push   %ebx
  801798:	83 ec 0c             	sub    $0xc,%esp
  80179b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80179e:	53                   	push   %ebx
  80179f:	6a 00                	push   $0x0
  8017a1:	e8 ca f4 ff ff       	call   800c70 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017a6:	89 1c 24             	mov    %ebx,(%esp)
  8017a9:	e8 6e f7 ff ff       	call   800f1c <fd2data>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	50                   	push   %eax
  8017b2:	6a 00                	push   $0x0
  8017b4:	e8 b7 f4 ff ff       	call   800c70 <sys_page_unmap>
}
  8017b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <_pipeisclosed>:
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	57                   	push   %edi
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
  8017c4:	83 ec 1c             	sub    $0x1c,%esp
  8017c7:	89 c7                	mov    %eax,%edi
  8017c9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8017d0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017d3:	83 ec 0c             	sub    $0xc,%esp
  8017d6:	57                   	push   %edi
  8017d7:	e8 62 05 00 00       	call   801d3e <pageref>
  8017dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017df:	89 34 24             	mov    %esi,(%esp)
  8017e2:	e8 57 05 00 00       	call   801d3e <pageref>
		nn = thisenv->env_runs;
  8017e7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8017ed:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	39 cb                	cmp    %ecx,%ebx
  8017f5:	74 1b                	je     801812 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8017f7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017fa:	75 cf                	jne    8017cb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017fc:	8b 42 58             	mov    0x58(%edx),%eax
  8017ff:	6a 01                	push   $0x1
  801801:	50                   	push   %eax
  801802:	53                   	push   %ebx
  801803:	68 72 24 80 00       	push   $0x802472
  801808:	e8 21 ea ff ff       	call   80022e <cprintf>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb b9                	jmp    8017cb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801812:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801815:	0f 94 c0             	sete   %al
  801818:	0f b6 c0             	movzbl %al,%eax
}
  80181b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181e:	5b                   	pop    %ebx
  80181f:	5e                   	pop    %esi
  801820:	5f                   	pop    %edi
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    

00801823 <devpipe_write>:
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	57                   	push   %edi
  801827:	56                   	push   %esi
  801828:	53                   	push   %ebx
  801829:	83 ec 18             	sub    $0x18,%esp
  80182c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80182f:	56                   	push   %esi
  801830:	e8 e7 f6 ff ff       	call   800f1c <fd2data>
  801835:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	bf 00 00 00 00       	mov    $0x0,%edi
  80183f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801842:	74 41                	je     801885 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801844:	8b 53 04             	mov    0x4(%ebx),%edx
  801847:	8b 03                	mov    (%ebx),%eax
  801849:	83 c0 20             	add    $0x20,%eax
  80184c:	39 c2                	cmp    %eax,%edx
  80184e:	72 14                	jb     801864 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801850:	89 da                	mov    %ebx,%edx
  801852:	89 f0                	mov    %esi,%eax
  801854:	e8 65 ff ff ff       	call   8017be <_pipeisclosed>
  801859:	85 c0                	test   %eax,%eax
  80185b:	75 2c                	jne    801889 <devpipe_write+0x66>
			sys_yield();
  80185d:	e8 50 f4 ff ff       	call   800cb2 <sys_yield>
  801862:	eb e0                	jmp    801844 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801864:	8b 45 0c             	mov    0xc(%ebp),%eax
  801867:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801871:	78 0b                	js     80187e <devpipe_write+0x5b>
  801873:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801877:	42                   	inc    %edx
  801878:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80187b:	47                   	inc    %edi
  80187c:	eb c1                	jmp    80183f <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80187e:	48                   	dec    %eax
  80187f:	83 c8 e0             	or     $0xffffffe0,%eax
  801882:	40                   	inc    %eax
  801883:	eb ee                	jmp    801873 <devpipe_write+0x50>
	return i;
  801885:	89 f8                	mov    %edi,%eax
  801887:	eb 05                	jmp    80188e <devpipe_write+0x6b>
				return 0;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5f                   	pop    %edi
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    

00801896 <devpipe_read>:
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	57                   	push   %edi
  80189a:	56                   	push   %esi
  80189b:	53                   	push   %ebx
  80189c:	83 ec 18             	sub    $0x18,%esp
  80189f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018a2:	57                   	push   %edi
  8018a3:	e8 74 f6 ff ff       	call   800f1c <fd2data>
  8018a8:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018b2:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8018b5:	74 46                	je     8018fd <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  8018b7:	8b 06                	mov    (%esi),%eax
  8018b9:	3b 46 04             	cmp    0x4(%esi),%eax
  8018bc:	75 22                	jne    8018e0 <devpipe_read+0x4a>
			if (i > 0)
  8018be:	85 db                	test   %ebx,%ebx
  8018c0:	74 0a                	je     8018cc <devpipe_read+0x36>
				return i;
  8018c2:	89 d8                	mov    %ebx,%eax
}
  8018c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5f                   	pop    %edi
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  8018cc:	89 f2                	mov    %esi,%edx
  8018ce:	89 f8                	mov    %edi,%eax
  8018d0:	e8 e9 fe ff ff       	call   8017be <_pipeisclosed>
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	75 28                	jne    801901 <devpipe_read+0x6b>
			sys_yield();
  8018d9:	e8 d4 f3 ff ff       	call   800cb2 <sys_yield>
  8018de:	eb d7                	jmp    8018b7 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018e0:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8018e5:	78 0f                	js     8018f6 <devpipe_read+0x60>
  8018e7:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8018eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ee:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8018f1:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8018f3:	43                   	inc    %ebx
  8018f4:	eb bc                	jmp    8018b2 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018f6:	48                   	dec    %eax
  8018f7:	83 c8 e0             	or     $0xffffffe0,%eax
  8018fa:	40                   	inc    %eax
  8018fb:	eb ea                	jmp    8018e7 <devpipe_read+0x51>
	return i;
  8018fd:	89 d8                	mov    %ebx,%eax
  8018ff:	eb c3                	jmp    8018c4 <devpipe_read+0x2e>
				return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
  801906:	eb bc                	jmp    8018c4 <devpipe_read+0x2e>

00801908 <pipe>:
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	56                   	push   %esi
  80190c:	53                   	push   %ebx
  80190d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801910:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801913:	50                   	push   %eax
  801914:	e8 1a f6 ff ff       	call   800f33 <fd_alloc>
  801919:	89 c3                	mov    %eax,%ebx
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	85 c0                	test   %eax,%eax
  801920:	0f 88 2a 01 00 00    	js     801a50 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	68 07 04 00 00       	push   $0x407
  80192e:	ff 75 f4             	pushl  -0xc(%ebp)
  801931:	6a 00                	push   $0x0
  801933:	e8 b3 f2 ff ff       	call   800beb <sys_page_alloc>
  801938:	89 c3                	mov    %eax,%ebx
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	85 c0                	test   %eax,%eax
  80193f:	0f 88 0b 01 00 00    	js     801a50 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194b:	50                   	push   %eax
  80194c:	e8 e2 f5 ff ff       	call   800f33 <fd_alloc>
  801951:	89 c3                	mov    %eax,%ebx
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	0f 88 e2 00 00 00    	js     801a40 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	68 07 04 00 00       	push   $0x407
  801966:	ff 75 f0             	pushl  -0x10(%ebp)
  801969:	6a 00                	push   $0x0
  80196b:	e8 7b f2 ff ff       	call   800beb <sys_page_alloc>
  801970:	89 c3                	mov    %eax,%ebx
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	85 c0                	test   %eax,%eax
  801977:	0f 88 c3 00 00 00    	js     801a40 <pipe+0x138>
	va = fd2data(fd0);
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	ff 75 f4             	pushl  -0xc(%ebp)
  801983:	e8 94 f5 ff ff       	call   800f1c <fd2data>
  801988:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80198a:	83 c4 0c             	add    $0xc,%esp
  80198d:	68 07 04 00 00       	push   $0x407
  801992:	50                   	push   %eax
  801993:	6a 00                	push   $0x0
  801995:	e8 51 f2 ff ff       	call   800beb <sys_page_alloc>
  80199a:	89 c3                	mov    %eax,%ebx
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	0f 88 89 00 00 00    	js     801a30 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019a7:	83 ec 0c             	sub    $0xc,%esp
  8019aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ad:	e8 6a f5 ff ff       	call   800f1c <fd2data>
  8019b2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019b9:	50                   	push   %eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	56                   	push   %esi
  8019bd:	6a 00                	push   $0x0
  8019bf:	e8 6a f2 ff ff       	call   800c2e <sys_page_map>
  8019c4:	89 c3                	mov    %eax,%ebx
  8019c6:	83 c4 20             	add    $0x20,%esp
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	78 55                	js     801a22 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  8019cd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8019d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8019e2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019eb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8019ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fd:	e8 0a f5 ff ff       	call   800f0c <fd2num>
  801a02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a05:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a07:	83 c4 04             	add    $0x4,%esp
  801a0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a0d:	e8 fa f4 ff ff       	call   800f0c <fd2num>
  801a12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a15:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a20:	eb 2e                	jmp    801a50 <pipe+0x148>
	sys_page_unmap(0, va);
  801a22:	83 ec 08             	sub    $0x8,%esp
  801a25:	56                   	push   %esi
  801a26:	6a 00                	push   $0x0
  801a28:	e8 43 f2 ff ff       	call   800c70 <sys_page_unmap>
  801a2d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a30:	83 ec 08             	sub    $0x8,%esp
  801a33:	ff 75 f0             	pushl  -0x10(%ebp)
  801a36:	6a 00                	push   $0x0
  801a38:	e8 33 f2 ff ff       	call   800c70 <sys_page_unmap>
  801a3d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a40:	83 ec 08             	sub    $0x8,%esp
  801a43:	ff 75 f4             	pushl  -0xc(%ebp)
  801a46:	6a 00                	push   $0x0
  801a48:	e8 23 f2 ff ff       	call   800c70 <sys_page_unmap>
  801a4d:	83 c4 10             	add    $0x10,%esp
}
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    

00801a59 <pipeisclosed>:
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	e8 17 f5 ff ff       	call   800f82 <fd_lookup>
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 18                	js     801a8a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a72:	83 ec 0c             	sub    $0xc,%esp
  801a75:	ff 75 f4             	pushl  -0xc(%ebp)
  801a78:	e8 9f f4 ff ff       	call   800f1c <fd2data>
	return _pipeisclosed(fd, p);
  801a7d:	89 c2                	mov    %eax,%edx
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	e8 37 fd ff ff       	call   8017be <_pipeisclosed>
  801a87:	83 c4 10             	add    $0x10,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a94:	5d                   	pop    %ebp
  801a95:	c3                   	ret    

00801a96 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	53                   	push   %ebx
  801a9a:	83 ec 0c             	sub    $0xc,%esp
  801a9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801aa0:	68 8a 24 80 00       	push   $0x80248a
  801aa5:	53                   	push   %ebx
  801aa6:	e8 8b ed ff ff       	call   800836 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801aab:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801ab2:	20 00 00 
	return 0;
}
  801ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <devcons_write>:
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	57                   	push   %edi
  801ac3:	56                   	push   %esi
  801ac4:	53                   	push   %ebx
  801ac5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801acb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ad0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ad6:	eb 1d                	jmp    801af5 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	53                   	push   %ebx
  801adc:	03 45 0c             	add    0xc(%ebp),%eax
  801adf:	50                   	push   %eax
  801ae0:	57                   	push   %edi
  801ae1:	e8 c3 ee ff ff       	call   8009a9 <memmove>
		sys_cputs(buf, m);
  801ae6:	83 c4 08             	add    $0x8,%esp
  801ae9:	53                   	push   %ebx
  801aea:	57                   	push   %edi
  801aeb:	e8 5e f0 ff ff       	call   800b4e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801af0:	01 de                	add    %ebx,%esi
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	89 f0                	mov    %esi,%eax
  801af7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801afa:	73 11                	jae    801b0d <devcons_write+0x4e>
		m = n - tot;
  801afc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801aff:	29 f3                	sub    %esi,%ebx
  801b01:	83 fb 7f             	cmp    $0x7f,%ebx
  801b04:	76 d2                	jbe    801ad8 <devcons_write+0x19>
  801b06:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801b0b:	eb cb                	jmp    801ad8 <devcons_write+0x19>
}
  801b0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b10:	5b                   	pop    %ebx
  801b11:	5e                   	pop    %esi
  801b12:	5f                   	pop    %edi
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    

00801b15 <devcons_read>:
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801b1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b1f:	75 0c                	jne    801b2d <devcons_read+0x18>
		return 0;
  801b21:	b8 00 00 00 00       	mov    $0x0,%eax
  801b26:	eb 21                	jmp    801b49 <devcons_read+0x34>
		sys_yield();
  801b28:	e8 85 f1 ff ff       	call   800cb2 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801b2d:	e8 3a f0 ff ff       	call   800b6c <sys_cgetc>
  801b32:	85 c0                	test   %eax,%eax
  801b34:	74 f2                	je     801b28 <devcons_read+0x13>
	if (c < 0)
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 0f                	js     801b49 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801b3a:	83 f8 04             	cmp    $0x4,%eax
  801b3d:	74 0c                	je     801b4b <devcons_read+0x36>
	*(char*)vbuf = c;
  801b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b42:	88 02                	mov    %al,(%edx)
	return 1;
  801b44:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    
		return 0;
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b50:	eb f7                	jmp    801b49 <devcons_read+0x34>

00801b52 <cputchar>:
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b5e:	6a 01                	push   $0x1
  801b60:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b63:	50                   	push   %eax
  801b64:	e8 e5 ef ff ff       	call   800b4e <sys_cputs>
}
  801b69:	83 c4 10             	add    $0x10,%esp
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <getchar>:
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b74:	6a 01                	push   $0x1
  801b76:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b79:	50                   	push   %eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	e8 6e f6 ff ff       	call   8011ef <read>
	if (r < 0)
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 08                	js     801b90 <getchar+0x22>
	if (r < 1)
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	7e 06                	jle    801b92 <getchar+0x24>
	return c;
  801b8c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    
		return -E_EOF;
  801b92:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801b97:	eb f7                	jmp    801b90 <getchar+0x22>

00801b99 <iscons>:
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba2:	50                   	push   %eax
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	e8 d7 f3 ff ff       	call   800f82 <fd_lookup>
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 11                	js     801bc3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bbb:	39 10                	cmp    %edx,(%eax)
  801bbd:	0f 94 c0             	sete   %al
  801bc0:	0f b6 c0             	movzbl %al,%eax
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <opencons>:
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801bcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bce:	50                   	push   %eax
  801bcf:	e8 5f f3 ff ff       	call   800f33 <fd_alloc>
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	78 3a                	js     801c15 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	68 07 04 00 00       	push   $0x407
  801be3:	ff 75 f4             	pushl  -0xc(%ebp)
  801be6:	6a 00                	push   $0x0
  801be8:	e8 fe ef ff ff       	call   800beb <sys_page_alloc>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	78 21                	js     801c15 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801bf4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c02:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	50                   	push   %eax
  801c0d:	e8 fa f2 ff ff       	call   800f0c <fd2num>
  801c12:	83 c4 10             	add    $0x10,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	57                   	push   %edi
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
  801c1d:	83 ec 0c             	sub    $0xc,%esp
  801c20:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c23:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c26:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801c29:	85 ff                	test   %edi,%edi
  801c2b:	74 53                	je     801c80 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801c2d:	83 ec 0c             	sub    $0xc,%esp
  801c30:	57                   	push   %edi
  801c31:	e8 c5 f1 ff ff       	call   800dfb <sys_ipc_recv>
  801c36:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801c39:	85 db                	test   %ebx,%ebx
  801c3b:	74 0b                	je     801c48 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801c3d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c43:	8b 52 74             	mov    0x74(%edx),%edx
  801c46:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801c48:	85 f6                	test   %esi,%esi
  801c4a:	74 0f                	je     801c5b <ipc_recv+0x44>
  801c4c:	85 ff                	test   %edi,%edi
  801c4e:	74 0b                	je     801c5b <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801c50:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c56:	8b 52 78             	mov    0x78(%edx),%edx
  801c59:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	74 30                	je     801c8f <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801c5f:	85 db                	test   %ebx,%ebx
  801c61:	74 06                	je     801c69 <ipc_recv+0x52>
      		*from_env_store = 0;
  801c63:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801c69:	85 f6                	test   %esi,%esi
  801c6b:	74 2c                	je     801c99 <ipc_recv+0x82>
      		*perm_store = 0;
  801c6d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801c73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801c80:	83 ec 0c             	sub    $0xc,%esp
  801c83:	6a ff                	push   $0xffffffff
  801c85:	e8 71 f1 ff ff       	call   800dfb <sys_ipc_recv>
  801c8a:	83 c4 10             	add    $0x10,%esp
  801c8d:	eb aa                	jmp    801c39 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801c8f:	a1 04 40 80 00       	mov    0x804004,%eax
  801c94:	8b 40 70             	mov    0x70(%eax),%eax
  801c97:	eb df                	jmp    801c78 <ipc_recv+0x61>
		return -1;
  801c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c9e:	eb d8                	jmp    801c78 <ipc_recv+0x61>

00801ca0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	57                   	push   %edi
  801ca4:	56                   	push   %esi
  801ca5:	53                   	push   %ebx
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801caf:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801cb2:	85 db                	test   %ebx,%ebx
  801cb4:	75 22                	jne    801cd8 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801cb6:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801cbb:	eb 1b                	jmp    801cd8 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801cbd:	68 98 24 80 00       	push   $0x802498
  801cc2:	68 3f 24 80 00       	push   $0x80243f
  801cc7:	6a 48                	push   $0x48
  801cc9:	68 bc 24 80 00       	push   $0x8024bc
  801cce:	e8 48 e4 ff ff       	call   80011b <_panic>
		sys_yield();
  801cd3:	e8 da ef ff ff       	call   800cb2 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801cd8:	57                   	push   %edi
  801cd9:	53                   	push   %ebx
  801cda:	56                   	push   %esi
  801cdb:	ff 75 08             	pushl  0x8(%ebp)
  801cde:	e8 f5 f0 ff ff       	call   800dd8 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ce9:	74 e8                	je     801cd3 <ipc_send+0x33>
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	75 ce                	jne    801cbd <ipc_send+0x1d>
		sys_yield();
  801cef:	e8 be ef ff ff       	call   800cb2 <sys_yield>
		
	}
	
}
  801cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    

00801cfc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d07:	89 c2                	mov    %eax,%edx
  801d09:	c1 e2 05             	shl    $0x5,%edx
  801d0c:	29 c2                	sub    %eax,%edx
  801d0e:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801d15:	8b 52 50             	mov    0x50(%edx),%edx
  801d18:	39 ca                	cmp    %ecx,%edx
  801d1a:	74 0f                	je     801d2b <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801d1c:	40                   	inc    %eax
  801d1d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d22:	75 e3                	jne    801d07 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d24:	b8 00 00 00 00       	mov    $0x0,%eax
  801d29:	eb 11                	jmp    801d3c <ipc_find_env+0x40>
			return envs[i].env_id;
  801d2b:	89 c2                	mov    %eax,%edx
  801d2d:	c1 e2 05             	shl    $0x5,%edx
  801d30:	29 c2                	sub    %eax,%edx
  801d32:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801d39:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    

00801d3e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	c1 e8 16             	shr    $0x16,%eax
  801d47:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d4e:	a8 01                	test   $0x1,%al
  801d50:	74 21                	je     801d73 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	c1 e8 0c             	shr    $0xc,%eax
  801d58:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d5f:	a8 01                	test   $0x1,%al
  801d61:	74 17                	je     801d7a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d63:	c1 e8 0c             	shr    $0xc,%eax
  801d66:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801d6d:	ef 
  801d6e:	0f b7 c0             	movzwl %ax,%eax
  801d71:	eb 05                	jmp    801d78 <pageref+0x3a>
		return 0;
  801d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    
		return 0;
  801d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7f:	eb f7                	jmp    801d78 <pageref+0x3a>
  801d81:	66 90                	xchg   %ax,%ax
  801d83:	90                   	nop

00801d84 <__udivdi3>:
  801d84:	55                   	push   %ebp
  801d85:	57                   	push   %edi
  801d86:	56                   	push   %esi
  801d87:	53                   	push   %ebx
  801d88:	83 ec 1c             	sub    $0x1c,%esp
  801d8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d97:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d9b:	89 ca                	mov    %ecx,%edx
  801d9d:	89 f8                	mov    %edi,%eax
  801d9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801da3:	85 f6                	test   %esi,%esi
  801da5:	75 2d                	jne    801dd4 <__udivdi3+0x50>
  801da7:	39 cf                	cmp    %ecx,%edi
  801da9:	77 65                	ja     801e10 <__udivdi3+0x8c>
  801dab:	89 fd                	mov    %edi,%ebp
  801dad:	85 ff                	test   %edi,%edi
  801daf:	75 0b                	jne    801dbc <__udivdi3+0x38>
  801db1:	b8 01 00 00 00       	mov    $0x1,%eax
  801db6:	31 d2                	xor    %edx,%edx
  801db8:	f7 f7                	div    %edi
  801dba:	89 c5                	mov    %eax,%ebp
  801dbc:	31 d2                	xor    %edx,%edx
  801dbe:	89 c8                	mov    %ecx,%eax
  801dc0:	f7 f5                	div    %ebp
  801dc2:	89 c1                	mov    %eax,%ecx
  801dc4:	89 d8                	mov    %ebx,%eax
  801dc6:	f7 f5                	div    %ebp
  801dc8:	89 cf                	mov    %ecx,%edi
  801dca:	89 fa                	mov    %edi,%edx
  801dcc:	83 c4 1c             	add    $0x1c,%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5f                   	pop    %edi
  801dd2:	5d                   	pop    %ebp
  801dd3:	c3                   	ret    
  801dd4:	39 ce                	cmp    %ecx,%esi
  801dd6:	77 28                	ja     801e00 <__udivdi3+0x7c>
  801dd8:	0f bd fe             	bsr    %esi,%edi
  801ddb:	83 f7 1f             	xor    $0x1f,%edi
  801dde:	75 40                	jne    801e20 <__udivdi3+0x9c>
  801de0:	39 ce                	cmp    %ecx,%esi
  801de2:	72 0a                	jb     801dee <__udivdi3+0x6a>
  801de4:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801de8:	0f 87 9e 00 00 00    	ja     801e8c <__udivdi3+0x108>
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	89 fa                	mov    %edi,%edx
  801df5:	83 c4 1c             	add    $0x1c,%esp
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5f                   	pop    %edi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    
  801dfd:	8d 76 00             	lea    0x0(%esi),%esi
  801e00:	31 ff                	xor    %edi,%edi
  801e02:	31 c0                	xor    %eax,%eax
  801e04:	89 fa                	mov    %edi,%edx
  801e06:	83 c4 1c             	add    $0x1c,%esp
  801e09:	5b                   	pop    %ebx
  801e0a:	5e                   	pop    %esi
  801e0b:	5f                   	pop    %edi
  801e0c:	5d                   	pop    %ebp
  801e0d:	c3                   	ret    
  801e0e:	66 90                	xchg   %ax,%ax
  801e10:	89 d8                	mov    %ebx,%eax
  801e12:	f7 f7                	div    %edi
  801e14:	31 ff                	xor    %edi,%edi
  801e16:	89 fa                	mov    %edi,%edx
  801e18:	83 c4 1c             	add    $0x1c,%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5e                   	pop    %esi
  801e1d:	5f                   	pop    %edi
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    
  801e20:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e25:	29 fd                	sub    %edi,%ebp
  801e27:	89 f9                	mov    %edi,%ecx
  801e29:	d3 e6                	shl    %cl,%esi
  801e2b:	89 c3                	mov    %eax,%ebx
  801e2d:	89 e9                	mov    %ebp,%ecx
  801e2f:	d3 eb                	shr    %cl,%ebx
  801e31:	89 d9                	mov    %ebx,%ecx
  801e33:	09 f1                	or     %esi,%ecx
  801e35:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e39:	89 f9                	mov    %edi,%ecx
  801e3b:	d3 e0                	shl    %cl,%eax
  801e3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e41:	89 d6                	mov    %edx,%esi
  801e43:	89 e9                	mov    %ebp,%ecx
  801e45:	d3 ee                	shr    %cl,%esi
  801e47:	89 f9                	mov    %edi,%ecx
  801e49:	d3 e2                	shl    %cl,%edx
  801e4b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e4f:	89 e9                	mov    %ebp,%ecx
  801e51:	d3 eb                	shr    %cl,%ebx
  801e53:	09 da                	or     %ebx,%edx
  801e55:	89 d0                	mov    %edx,%eax
  801e57:	89 f2                	mov    %esi,%edx
  801e59:	f7 74 24 08          	divl   0x8(%esp)
  801e5d:	89 d6                	mov    %edx,%esi
  801e5f:	89 c3                	mov    %eax,%ebx
  801e61:	f7 64 24 0c          	mull   0xc(%esp)
  801e65:	39 d6                	cmp    %edx,%esi
  801e67:	72 17                	jb     801e80 <__udivdi3+0xfc>
  801e69:	74 09                	je     801e74 <__udivdi3+0xf0>
  801e6b:	89 d8                	mov    %ebx,%eax
  801e6d:	31 ff                	xor    %edi,%edi
  801e6f:	e9 56 ff ff ff       	jmp    801dca <__udivdi3+0x46>
  801e74:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e78:	89 f9                	mov    %edi,%ecx
  801e7a:	d3 e2                	shl    %cl,%edx
  801e7c:	39 c2                	cmp    %eax,%edx
  801e7e:	73 eb                	jae    801e6b <__udivdi3+0xe7>
  801e80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e83:	31 ff                	xor    %edi,%edi
  801e85:	e9 40 ff ff ff       	jmp    801dca <__udivdi3+0x46>
  801e8a:	66 90                	xchg   %ax,%ax
  801e8c:	31 c0                	xor    %eax,%eax
  801e8e:	e9 37 ff ff ff       	jmp    801dca <__udivdi3+0x46>
  801e93:	90                   	nop

00801e94 <__umoddi3>:
  801e94:	55                   	push   %ebp
  801e95:	57                   	push   %edi
  801e96:	56                   	push   %esi
  801e97:	53                   	push   %ebx
  801e98:	83 ec 1c             	sub    $0x1c,%esp
  801e9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ea3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ea7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801eab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eaf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eb3:	89 3c 24             	mov    %edi,(%esp)
  801eb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eba:	89 f2                	mov    %esi,%edx
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	75 18                	jne    801ed8 <__umoddi3+0x44>
  801ec0:	39 f7                	cmp    %esi,%edi
  801ec2:	0f 86 a0 00 00 00    	jbe    801f68 <__umoddi3+0xd4>
  801ec8:	89 c8                	mov    %ecx,%eax
  801eca:	f7 f7                	div    %edi
  801ecc:	89 d0                	mov    %edx,%eax
  801ece:	31 d2                	xor    %edx,%edx
  801ed0:	83 c4 1c             	add    $0x1c,%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5f                   	pop    %edi
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    
  801ed8:	89 f3                	mov    %esi,%ebx
  801eda:	39 f0                	cmp    %esi,%eax
  801edc:	0f 87 a6 00 00 00    	ja     801f88 <__umoddi3+0xf4>
  801ee2:	0f bd e8             	bsr    %eax,%ebp
  801ee5:	83 f5 1f             	xor    $0x1f,%ebp
  801ee8:	0f 84 a6 00 00 00    	je     801f94 <__umoddi3+0x100>
  801eee:	bf 20 00 00 00       	mov    $0x20,%edi
  801ef3:	29 ef                	sub    %ebp,%edi
  801ef5:	89 e9                	mov    %ebp,%ecx
  801ef7:	d3 e0                	shl    %cl,%eax
  801ef9:	8b 34 24             	mov    (%esp),%esi
  801efc:	89 f2                	mov    %esi,%edx
  801efe:	89 f9                	mov    %edi,%ecx
  801f00:	d3 ea                	shr    %cl,%edx
  801f02:	09 c2                	or     %eax,%edx
  801f04:	89 14 24             	mov    %edx,(%esp)
  801f07:	89 f2                	mov    %esi,%edx
  801f09:	89 e9                	mov    %ebp,%ecx
  801f0b:	d3 e2                	shl    %cl,%edx
  801f0d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f11:	89 de                	mov    %ebx,%esi
  801f13:	89 f9                	mov    %edi,%ecx
  801f15:	d3 ee                	shr    %cl,%esi
  801f17:	89 e9                	mov    %ebp,%ecx
  801f19:	d3 e3                	shl    %cl,%ebx
  801f1b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f1f:	89 d0                	mov    %edx,%eax
  801f21:	89 f9                	mov    %edi,%ecx
  801f23:	d3 e8                	shr    %cl,%eax
  801f25:	09 d8                	or     %ebx,%eax
  801f27:	89 d3                	mov    %edx,%ebx
  801f29:	89 e9                	mov    %ebp,%ecx
  801f2b:	d3 e3                	shl    %cl,%ebx
  801f2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f31:	89 f2                	mov    %esi,%edx
  801f33:	f7 34 24             	divl   (%esp)
  801f36:	89 d6                	mov    %edx,%esi
  801f38:	f7 64 24 04          	mull   0x4(%esp)
  801f3c:	89 c3                	mov    %eax,%ebx
  801f3e:	89 d1                	mov    %edx,%ecx
  801f40:	39 d6                	cmp    %edx,%esi
  801f42:	72 7c                	jb     801fc0 <__umoddi3+0x12c>
  801f44:	74 72                	je     801fb8 <__umoddi3+0x124>
  801f46:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f4a:	29 da                	sub    %ebx,%edx
  801f4c:	19 ce                	sbb    %ecx,%esi
  801f4e:	89 f0                	mov    %esi,%eax
  801f50:	89 f9                	mov    %edi,%ecx
  801f52:	d3 e0                	shl    %cl,%eax
  801f54:	89 e9                	mov    %ebp,%ecx
  801f56:	d3 ea                	shr    %cl,%edx
  801f58:	09 d0                	or     %edx,%eax
  801f5a:	89 e9                	mov    %ebp,%ecx
  801f5c:	d3 ee                	shr    %cl,%esi
  801f5e:	89 f2                	mov    %esi,%edx
  801f60:	83 c4 1c             	add    $0x1c,%esp
  801f63:	5b                   	pop    %ebx
  801f64:	5e                   	pop    %esi
  801f65:	5f                   	pop    %edi
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    
  801f68:	89 fd                	mov    %edi,%ebp
  801f6a:	85 ff                	test   %edi,%edi
  801f6c:	75 0b                	jne    801f79 <__umoddi3+0xe5>
  801f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f73:	31 d2                	xor    %edx,%edx
  801f75:	f7 f7                	div    %edi
  801f77:	89 c5                	mov    %eax,%ebp
  801f79:	89 f0                	mov    %esi,%eax
  801f7b:	31 d2                	xor    %edx,%edx
  801f7d:	f7 f5                	div    %ebp
  801f7f:	89 c8                	mov    %ecx,%eax
  801f81:	f7 f5                	div    %ebp
  801f83:	e9 44 ff ff ff       	jmp    801ecc <__umoddi3+0x38>
  801f88:	89 c8                	mov    %ecx,%eax
  801f8a:	89 f2                	mov    %esi,%edx
  801f8c:	83 c4 1c             	add    $0x1c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
  801f94:	39 f0                	cmp    %esi,%eax
  801f96:	72 05                	jb     801f9d <__umoddi3+0x109>
  801f98:	39 0c 24             	cmp    %ecx,(%esp)
  801f9b:	77 0c                	ja     801fa9 <__umoddi3+0x115>
  801f9d:	89 f2                	mov    %esi,%edx
  801f9f:	29 f9                	sub    %edi,%ecx
  801fa1:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fa5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fa9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fad:	83 c4 1c             	add    $0x1c,%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5e                   	pop    %esi
  801fb2:	5f                   	pop    %edi
  801fb3:	5d                   	pop    %ebp
  801fb4:	c3                   	ret    
  801fb5:	8d 76 00             	lea    0x0(%esi),%esi
  801fb8:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801fbc:	73 88                	jae    801f46 <__umoddi3+0xb2>
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801fc4:	1b 14 24             	sbb    (%esp),%edx
  801fc7:	89 d1                	mov    %edx,%ecx
  801fc9:	89 c3                	mov    %eax,%ebx
  801fcb:	e9 76 ff ff ff       	jmp    801f46 <__umoddi3+0xb2>
