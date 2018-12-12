
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
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
  800040:	68 00 20 80 00       	push   $0x802000
  800045:	e8 f9 01 00 00       	call   800243 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 a2 0b 00 00       	call   800c00 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 4c 20 80 00       	push   $0x80204c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 8b 07 00 00       	call   8007fe <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 20 20 80 00       	push   $0x802020
  800085:	6a 0e                	push   $0xe
  800087:	68 0a 20 80 00       	push   $0x80200a
  80008c:	e8 9f 00 00 00       	call   800130 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 14 0e 00 00       	call   800eb5 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 1c 20 80 00       	push   $0x80201c
  8000ae:	e8 90 01 00 00       	call   800243 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 1c 20 80 00       	push   $0x80201c
  8000c0:	e8 7e 01 00 00       	call   800243 <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d5:	e8 07 0b 00 00       	call   800be1 <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	89 c2                	mov    %eax,%edx
  8000e1:	c1 e2 05             	shl    $0x5,%edx
  8000e4:	29 c2                	sub    %eax,%edx
  8000e6:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000ed:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f2:	85 db                	test   %ebx,%ebx
  8000f4:	7e 07                	jle    8000fd <libmain+0x33>
		binaryname = argv[0];
  8000f6:	8b 06                	mov    (%esi),%eax
  8000f8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	56                   	push   %esi
  800101:	53                   	push   %ebx
  800102:	e8 8a ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800107:	e8 0a 00 00 00       	call   800116 <exit>
}
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800112:	5b                   	pop    %ebx
  800113:	5e                   	pop    %esi
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80011c:	e8 d4 0f 00 00       	call   8010f5 <close_all>
	sys_env_destroy(0);
  800121:	83 ec 0c             	sub    $0xc,%esp
  800124:	6a 00                	push   $0x0
  800126:	e8 75 0a 00 00       	call   800ba0 <sys_env_destroy>
}
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	57                   	push   %edi
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
  800136:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80013c:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80013f:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800145:	e8 97 0a 00 00       	call   800be1 <sys_getenvid>
  80014a:	83 ec 04             	sub    $0x4,%esp
  80014d:	ff 75 0c             	pushl  0xc(%ebp)
  800150:	ff 75 08             	pushl  0x8(%ebp)
  800153:	53                   	push   %ebx
  800154:	50                   	push   %eax
  800155:	68 78 20 80 00       	push   $0x802078
  80015a:	68 00 01 00 00       	push   $0x100
  80015f:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800165:	56                   	push   %esi
  800166:	e8 93 06 00 00       	call   8007fe <snprintf>
  80016b:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80016d:	83 c4 20             	add    $0x20,%esp
  800170:	57                   	push   %edi
  800171:	ff 75 10             	pushl  0x10(%ebp)
  800174:	bf 00 01 00 00       	mov    $0x100,%edi
  800179:	89 f8                	mov    %edi,%eax
  80017b:	29 d8                	sub    %ebx,%eax
  80017d:	50                   	push   %eax
  80017e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800181:	50                   	push   %eax
  800182:	e8 22 06 00 00       	call   8007a9 <vsnprintf>
  800187:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800189:	83 c4 0c             	add    $0xc,%esp
  80018c:	68 a3 24 80 00       	push   $0x8024a3
  800191:	29 df                	sub    %ebx,%edi
  800193:	57                   	push   %edi
  800194:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800197:	50                   	push   %eax
  800198:	e8 61 06 00 00       	call   8007fe <snprintf>
	sys_cputs(buf, r);
  80019d:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8001a0:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8001a2:	53                   	push   %ebx
  8001a3:	56                   	push   %esi
  8001a4:	e8 ba 09 00 00       	call   800b63 <sys_cputs>
  8001a9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ac:	cc                   	int3   
  8001ad:	eb fd                	jmp    8001ac <_panic+0x7c>

008001af <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 04             	sub    $0x4,%esp
  8001b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b9:	8b 13                	mov    (%ebx),%edx
  8001bb:	8d 42 01             	lea    0x1(%edx),%eax
  8001be:	89 03                	mov    %eax,(%ebx)
  8001c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cc:	74 08                	je     8001d6 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ce:	ff 43 04             	incl   0x4(%ebx)
}
  8001d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001d4:	c9                   	leave  
  8001d5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	68 ff 00 00 00       	push   $0xff
  8001de:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e1:	50                   	push   %eax
  8001e2:	e8 7c 09 00 00       	call   800b63 <sys_cputs>
		b->idx = 0;
  8001e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	eb dc                	jmp    8001ce <putch+0x1f>

008001f2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800202:	00 00 00 
	b.cnt = 0;
  800205:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80020f:	ff 75 0c             	pushl  0xc(%ebp)
  800212:	ff 75 08             	pushl  0x8(%ebp)
  800215:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	68 af 01 80 00       	push   $0x8001af
  800221:	e8 17 01 00 00       	call   80033d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800226:	83 c4 08             	add    $0x8,%esp
  800229:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80022f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800235:	50                   	push   %eax
  800236:	e8 28 09 00 00       	call   800b63 <sys_cputs>

	return b.cnt;
}
  80023b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800249:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80024c:	50                   	push   %eax
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	e8 9d ff ff ff       	call   8001f2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	57                   	push   %edi
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	83 ec 1c             	sub    $0x1c,%esp
  800260:	89 c7                	mov    %eax,%edi
  800262:	89 d6                	mov    %edx,%esi
  800264:	8b 45 08             	mov    0x8(%ebp),%eax
  800267:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80026d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800270:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800273:	bb 00 00 00 00       	mov    $0x0,%ebx
  800278:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80027b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80027e:	39 d3                	cmp    %edx,%ebx
  800280:	72 05                	jb     800287 <printnum+0x30>
  800282:	39 45 10             	cmp    %eax,0x10(%ebp)
  800285:	77 78                	ja     8002ff <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 18             	pushl  0x18(%ebp)
  80028d:	8b 45 14             	mov    0x14(%ebp),%eax
  800290:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800293:	53                   	push   %ebx
  800294:	ff 75 10             	pushl  0x10(%ebp)
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029d:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 ed 1a 00 00       	call   801d98 <__udivdi3>
  8002ab:	83 c4 18             	add    $0x18,%esp
  8002ae:	52                   	push   %edx
  8002af:	50                   	push   %eax
  8002b0:	89 f2                	mov    %esi,%edx
  8002b2:	89 f8                	mov    %edi,%eax
  8002b4:	e8 9e ff ff ff       	call   800257 <printnum>
  8002b9:	83 c4 20             	add    $0x20,%esp
  8002bc:	eb 11                	jmp    8002cf <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	56                   	push   %esi
  8002c2:	ff 75 18             	pushl  0x18(%ebp)
  8002c5:	ff d7                	call   *%edi
  8002c7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ca:	4b                   	dec    %ebx
  8002cb:	85 db                	test   %ebx,%ebx
  8002cd:	7f ef                	jg     8002be <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002cf:	83 ec 08             	sub    $0x8,%esp
  8002d2:	56                   	push   %esi
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 c1 1b 00 00       	call   801ea8 <__umoddi3>
  8002e7:	83 c4 14             	add    $0x14,%esp
  8002ea:	0f be 80 9b 20 80 00 	movsbl 0x80209b(%eax),%eax
  8002f1:	50                   	push   %eax
  8002f2:	ff d7                	call   *%edi
}
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    
  8002ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800302:	eb c6                	jmp    8002ca <printnum+0x73>

00800304 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80030a:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	3b 50 04             	cmp    0x4(%eax),%edx
  800312:	73 0a                	jae    80031e <sprintputch+0x1a>
		*b->buf++ = ch;
  800314:	8d 4a 01             	lea    0x1(%edx),%ecx
  800317:	89 08                	mov    %ecx,(%eax)
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	88 02                	mov    %al,(%edx)
}
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <printfmt>:
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800326:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800329:	50                   	push   %eax
  80032a:	ff 75 10             	pushl  0x10(%ebp)
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	e8 05 00 00 00       	call   80033d <vprintfmt>
}
  800338:	83 c4 10             	add    $0x10,%esp
  80033b:	c9                   	leave  
  80033c:	c3                   	ret    

0080033d <vprintfmt>:
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
  800343:	83 ec 2c             	sub    $0x2c,%esp
  800346:	8b 75 08             	mov    0x8(%ebp),%esi
  800349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80034c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80034f:	e9 ae 03 00 00       	jmp    800702 <vprintfmt+0x3c5>
  800354:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800358:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80035f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800366:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80036d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8d 47 01             	lea    0x1(%edi),%eax
  800375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800378:	8a 17                	mov    (%edi),%dl
  80037a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037d:	3c 55                	cmp    $0x55,%al
  80037f:	0f 87 fe 03 00 00    	ja     800783 <vprintfmt+0x446>
  800385:	0f b6 c0             	movzbl %al,%eax
  800388:	ff 24 85 e0 21 80 00 	jmp    *0x8021e0(,%eax,4)
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800392:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800396:	eb da                	jmp    800372 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80039b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80039f:	eb d1                	jmp    800372 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	0f b6 d2             	movzbl %dl,%edx
  8003a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003af:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8003b8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003bb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003be:	83 f9 09             	cmp    $0x9,%ecx
  8003c1:	77 52                	ja     800415 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8003c3:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8003c4:	eb e9                	jmp    8003af <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8003c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d1:	8d 40 04             	lea    0x4(%eax),%eax
  8003d4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003de:	79 92                	jns    800372 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003ed:	eb 83                	jmp    800372 <vprintfmt+0x35>
  8003ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f3:	78 08                	js     8003fd <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f8:	e9 75 ff ff ff       	jmp    800372 <vprintfmt+0x35>
  8003fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800404:	eb ef                	jmp    8003f5 <vprintfmt+0xb8>
  800406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800409:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800410:	e9 5d ff ff ff       	jmp    800372 <vprintfmt+0x35>
  800415:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800418:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80041b:	eb bd                	jmp    8003da <vprintfmt+0x9d>
			lflag++;
  80041d:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800421:	e9 4c ff ff ff       	jmp    800372 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	8d 78 04             	lea    0x4(%eax),%edi
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	53                   	push   %ebx
  800430:	ff 30                	pushl  (%eax)
  800432:	ff d6                	call   *%esi
			break;
  800434:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800437:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043a:	e9 c0 02 00 00       	jmp    8006ff <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	8d 78 04             	lea    0x4(%eax),%edi
  800445:	8b 00                	mov    (%eax),%eax
  800447:	85 c0                	test   %eax,%eax
  800449:	78 2a                	js     800475 <vprintfmt+0x138>
  80044b:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044d:	83 f8 0f             	cmp    $0xf,%eax
  800450:	7f 27                	jg     800479 <vprintfmt+0x13c>
  800452:	8b 04 85 40 23 80 00 	mov    0x802340(,%eax,4),%eax
  800459:	85 c0                	test   %eax,%eax
  80045b:	74 1c                	je     800479 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80045d:	50                   	push   %eax
  80045e:	68 71 24 80 00       	push   $0x802471
  800463:	53                   	push   %ebx
  800464:	56                   	push   %esi
  800465:	e8 b6 fe ff ff       	call   800320 <printfmt>
  80046a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800470:	e9 8a 02 00 00       	jmp    8006ff <vprintfmt+0x3c2>
  800475:	f7 d8                	neg    %eax
  800477:	eb d2                	jmp    80044b <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800479:	52                   	push   %edx
  80047a:	68 b3 20 80 00       	push   $0x8020b3
  80047f:	53                   	push   %ebx
  800480:	56                   	push   %esi
  800481:	e8 9a fe ff ff       	call   800320 <printfmt>
  800486:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800489:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048c:	e9 6e 02 00 00       	jmp    8006ff <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	83 c0 04             	add    $0x4,%eax
  800497:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8b 38                	mov    (%eax),%edi
  80049f:	85 ff                	test   %edi,%edi
  8004a1:	74 39                	je     8004dc <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8004a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a7:	0f 8e a9 00 00 00    	jle    800556 <vprintfmt+0x219>
  8004ad:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004b1:	0f 84 a7 00 00 00    	je     80055e <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	ff 75 d0             	pushl  -0x30(%ebp)
  8004bd:	57                   	push   %edi
  8004be:	e8 6b 03 00 00       	call   80082e <strnlen>
  8004c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c6:	29 c1                	sub    %eax,%ecx
  8004c8:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004cb:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004ce:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004d8:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004da:	eb 14                	jmp    8004f0 <vprintfmt+0x1b3>
				p = "(null)";
  8004dc:	bf ac 20 80 00       	mov    $0x8020ac,%edi
  8004e1:	eb c0                	jmp    8004a3 <vprintfmt+0x166>
					putch(padc, putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ea:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ec:	4f                   	dec    %edi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	85 ff                	test   %edi,%edi
  8004f2:	7f ef                	jg     8004e3 <vprintfmt+0x1a6>
  8004f4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004f7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004fa:	89 c8                	mov    %ecx,%eax
  8004fc:	85 c9                	test   %ecx,%ecx
  8004fe:	78 10                	js     800510 <vprintfmt+0x1d3>
  800500:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800503:	29 c1                	sub    %eax,%ecx
  800505:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800508:	89 75 08             	mov    %esi,0x8(%ebp)
  80050b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80050e:	eb 15                	jmp    800525 <vprintfmt+0x1e8>
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	eb e9                	jmp    800500 <vprintfmt+0x1c3>
					putch(ch, putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	53                   	push   %ebx
  80051b:	52                   	push   %edx
  80051c:	ff 55 08             	call   *0x8(%ebp)
  80051f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800522:	ff 4d e0             	decl   -0x20(%ebp)
  800525:	47                   	inc    %edi
  800526:	8a 47 ff             	mov    -0x1(%edi),%al
  800529:	0f be d0             	movsbl %al,%edx
  80052c:	85 d2                	test   %edx,%edx
  80052e:	74 59                	je     800589 <vprintfmt+0x24c>
  800530:	85 f6                	test   %esi,%esi
  800532:	78 03                	js     800537 <vprintfmt+0x1fa>
  800534:	4e                   	dec    %esi
  800535:	78 2f                	js     800566 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800537:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80053b:	74 da                	je     800517 <vprintfmt+0x1da>
  80053d:	0f be c0             	movsbl %al,%eax
  800540:	83 e8 20             	sub    $0x20,%eax
  800543:	83 f8 5e             	cmp    $0x5e,%eax
  800546:	76 cf                	jbe    800517 <vprintfmt+0x1da>
					putch('?', putdat);
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	53                   	push   %ebx
  80054c:	6a 3f                	push   $0x3f
  80054e:	ff 55 08             	call   *0x8(%ebp)
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	eb cc                	jmp    800522 <vprintfmt+0x1e5>
  800556:	89 75 08             	mov    %esi,0x8(%ebp)
  800559:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80055c:	eb c7                	jmp    800525 <vprintfmt+0x1e8>
  80055e:	89 75 08             	mov    %esi,0x8(%ebp)
  800561:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800564:	eb bf                	jmp    800525 <vprintfmt+0x1e8>
  800566:	8b 75 08             	mov    0x8(%ebp),%esi
  800569:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80056c:	eb 0c                	jmp    80057a <vprintfmt+0x23d>
				putch(' ', putdat);
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	53                   	push   %ebx
  800572:	6a 20                	push   $0x20
  800574:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800576:	4f                   	dec    %edi
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	85 ff                	test   %edi,%edi
  80057c:	7f f0                	jg     80056e <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
  800584:	e9 76 01 00 00       	jmp    8006ff <vprintfmt+0x3c2>
  800589:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80058c:	8b 75 08             	mov    0x8(%ebp),%esi
  80058f:	eb e9                	jmp    80057a <vprintfmt+0x23d>
	if (lflag >= 2)
  800591:	83 f9 01             	cmp    $0x1,%ecx
  800594:	7f 1f                	jg     8005b5 <vprintfmt+0x278>
	else if (lflag)
  800596:	85 c9                	test   %ecx,%ecx
  800598:	75 48                	jne    8005e2 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	89 c1                	mov    %eax,%ecx
  8005a4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 04             	lea    0x4(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b3:	eb 17                	jmp    8005cc <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 50 04             	mov    0x4(%eax),%edx
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8d 40 08             	lea    0x8(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005cf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8005d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005d6:	78 25                	js     8005fd <vprintfmt+0x2c0>
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dd:	e9 03 01 00 00       	jmp    8006e5 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ea:	89 c1                	mov    %eax,%ecx
  8005ec:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fb:	eb cf                	jmp    8005cc <vprintfmt+0x28f>
				putch('-', putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	53                   	push   %ebx
  800601:	6a 2d                	push   $0x2d
  800603:	ff d6                	call   *%esi
				num = -(long long) num;
  800605:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800608:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80060b:	f7 da                	neg    %edx
  80060d:	83 d1 00             	adc    $0x0,%ecx
  800610:	f7 d9                	neg    %ecx
  800612:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800615:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061a:	e9 c6 00 00 00       	jmp    8006e5 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80061f:	83 f9 01             	cmp    $0x1,%ecx
  800622:	7f 1e                	jg     800642 <vprintfmt+0x305>
	else if (lflag)
  800624:	85 c9                	test   %ecx,%ecx
  800626:	75 32                	jne    80065a <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 10                	mov    (%eax),%edx
  80062d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800638:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063d:	e9 a3 00 00 00       	jmp    8006e5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	8b 48 04             	mov    0x4(%eax),%ecx
  80064a:	8d 40 08             	lea    0x8(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800650:	b8 0a 00 00 00       	mov    $0xa,%eax
  800655:	e9 8b 00 00 00       	jmp    8006e5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066f:	eb 74                	jmp    8006e5 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800671:	83 f9 01             	cmp    $0x1,%ecx
  800674:	7f 1b                	jg     800691 <vprintfmt+0x354>
	else if (lflag)
  800676:	85 c9                	test   %ecx,%ecx
  800678:	75 2c                	jne    8006a6 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 10                	mov    (%eax),%edx
  80067f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800684:	8d 40 04             	lea    0x4(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068a:	b8 08 00 00 00       	mov    $0x8,%eax
  80068f:	eb 54                	jmp    8006e5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 10                	mov    (%eax),%edx
  800696:	8b 48 04             	mov    0x4(%eax),%ecx
  800699:	8d 40 08             	lea    0x8(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80069f:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a4:	eb 3f                	jmp    8006e5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bb:	eb 28                	jmp    8006e5 <vprintfmt+0x3a8>
			putch('0', putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	53                   	push   %ebx
  8006c1:	6a 30                	push   $0x30
  8006c3:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c5:	83 c4 08             	add    $0x8,%esp
  8006c8:	53                   	push   %ebx
  8006c9:	6a 78                	push   $0x78
  8006cb:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 10                	mov    (%eax),%edx
  8006d2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006d7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006da:	8d 40 04             	lea    0x4(%eax),%eax
  8006dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ec:	57                   	push   %edi
  8006ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f0:	50                   	push   %eax
  8006f1:	51                   	push   %ecx
  8006f2:	52                   	push   %edx
  8006f3:	89 da                	mov    %ebx,%edx
  8006f5:	89 f0                	mov    %esi,%eax
  8006f7:	e8 5b fb ff ff       	call   800257 <printnum>
			break;
  8006fc:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800702:	47                   	inc    %edi
  800703:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800707:	83 f8 25             	cmp    $0x25,%eax
  80070a:	0f 84 44 fc ff ff    	je     800354 <vprintfmt+0x17>
			if (ch == '\0')
  800710:	85 c0                	test   %eax,%eax
  800712:	0f 84 89 00 00 00    	je     8007a1 <vprintfmt+0x464>
			putch(ch, putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	50                   	push   %eax
  80071d:	ff d6                	call   *%esi
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	eb de                	jmp    800702 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800724:	83 f9 01             	cmp    $0x1,%ecx
  800727:	7f 1b                	jg     800744 <vprintfmt+0x407>
	else if (lflag)
  800729:	85 c9                	test   %ecx,%ecx
  80072b:	75 2c                	jne    800759 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	b9 00 00 00 00       	mov    $0x0,%ecx
  800737:	8d 40 04             	lea    0x4(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073d:	b8 10 00 00 00       	mov    $0x10,%eax
  800742:	eb a1                	jmp    8006e5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 10                	mov    (%eax),%edx
  800749:	8b 48 04             	mov    0x4(%eax),%ecx
  80074c:	8d 40 08             	lea    0x8(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800752:	b8 10 00 00 00       	mov    $0x10,%eax
  800757:	eb 8c                	jmp    8006e5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 10                	mov    (%eax),%edx
  80075e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800763:	8d 40 04             	lea    0x4(%eax),%eax
  800766:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800769:	b8 10 00 00 00       	mov    $0x10,%eax
  80076e:	e9 72 ff ff ff       	jmp    8006e5 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	6a 25                	push   $0x25
  800779:	ff d6                	call   *%esi
			break;
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	e9 7c ff ff ff       	jmp    8006ff <vprintfmt+0x3c2>
			putch('%', putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 25                	push   $0x25
  800789:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	89 f8                	mov    %edi,%eax
  800790:	eb 01                	jmp    800793 <vprintfmt+0x456>
  800792:	48                   	dec    %eax
  800793:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800797:	75 f9                	jne    800792 <vprintfmt+0x455>
  800799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079c:	e9 5e ff ff ff       	jmp    8006ff <vprintfmt+0x3c2>
}
  8007a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a4:	5b                   	pop    %ebx
  8007a5:	5e                   	pop    %esi
  8007a6:	5f                   	pop    %edi
  8007a7:	5d                   	pop    %ebp
  8007a8:	c3                   	ret    

008007a9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	83 ec 18             	sub    $0x18,%esp
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c6:	85 c0                	test   %eax,%eax
  8007c8:	74 26                	je     8007f0 <vsnprintf+0x47>
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	7e 29                	jle    8007f7 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ce:	ff 75 14             	pushl  0x14(%ebp)
  8007d1:	ff 75 10             	pushl  0x10(%ebp)
  8007d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d7:	50                   	push   %eax
  8007d8:	68 04 03 80 00       	push   $0x800304
  8007dd:	e8 5b fb ff ff       	call   80033d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    
		return -E_INVAL;
  8007f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f5:	eb f7                	jmp    8007ee <vsnprintf+0x45>
  8007f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007fc:	eb f0                	jmp    8007ee <vsnprintf+0x45>

008007fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800804:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800807:	50                   	push   %eax
  800808:	ff 75 10             	pushl  0x10(%ebp)
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	ff 75 08             	pushl  0x8(%ebp)
  800811:	e8 93 ff ff ff       	call   8007a9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800816:	c9                   	leave  
  800817:	c3                   	ret    

00800818 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
  800823:	eb 01                	jmp    800826 <strlen+0xe>
		n++;
  800825:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800826:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80082a:	75 f9                	jne    800825 <strlen+0xd>
	return n;
}
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800834:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800837:	b8 00 00 00 00       	mov    $0x0,%eax
  80083c:	eb 01                	jmp    80083f <strnlen+0x11>
		n++;
  80083e:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083f:	39 d0                	cmp    %edx,%eax
  800841:	74 06                	je     800849 <strnlen+0x1b>
  800843:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800847:	75 f5                	jne    80083e <strnlen+0x10>
	return n;
}
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	53                   	push   %ebx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800855:	89 c2                	mov    %eax,%edx
  800857:	42                   	inc    %edx
  800858:	41                   	inc    %ecx
  800859:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80085c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80085f:	84 db                	test   %bl,%bl
  800861:	75 f4                	jne    800857 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800863:	5b                   	pop    %ebx
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	53                   	push   %ebx
  80086a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80086d:	53                   	push   %ebx
  80086e:	e8 a5 ff ff ff       	call   800818 <strlen>
  800873:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	01 d8                	add    %ebx,%eax
  80087b:	50                   	push   %eax
  80087c:	e8 ca ff ff ff       	call   80084b <strcpy>
	return dst;
}
  800881:	89 d8                	mov    %ebx,%eax
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	56                   	push   %esi
  80088c:	53                   	push   %ebx
  80088d:	8b 75 08             	mov    0x8(%ebp),%esi
  800890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800893:	89 f3                	mov    %esi,%ebx
  800895:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800898:	89 f2                	mov    %esi,%edx
  80089a:	eb 0c                	jmp    8008a8 <strncpy+0x20>
		*dst++ = *src;
  80089c:	42                   	inc    %edx
  80089d:	8a 01                	mov    (%ecx),%al
  80089f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008a2:	80 39 01             	cmpb   $0x1,(%ecx)
  8008a5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008a8:	39 da                	cmp    %ebx,%edx
  8008aa:	75 f0                	jne    80089c <strncpy+0x14>
	}
	return ret;
}
  8008ac:	89 f0                	mov    %esi,%eax
  8008ae:	5b                   	pop    %ebx
  8008af:	5e                   	pop    %esi
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bd:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008c0:	85 c0                	test   %eax,%eax
  8008c2:	74 20                	je     8008e4 <strlcpy+0x32>
  8008c4:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8008c8:	89 f0                	mov    %esi,%eax
  8008ca:	eb 05                	jmp    8008d1 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008cc:	40                   	inc    %eax
  8008cd:	42                   	inc    %edx
  8008ce:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008d1:	39 d8                	cmp    %ebx,%eax
  8008d3:	74 06                	je     8008db <strlcpy+0x29>
  8008d5:	8a 0a                	mov    (%edx),%cl
  8008d7:	84 c9                	test   %cl,%cl
  8008d9:	75 f1                	jne    8008cc <strlcpy+0x1a>
		*dst = '\0';
  8008db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008de:	29 f0                	sub    %esi,%eax
}
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    
  8008e4:	89 f0                	mov    %esi,%eax
  8008e6:	eb f6                	jmp    8008de <strlcpy+0x2c>

008008e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f1:	eb 02                	jmp    8008f5 <strcmp+0xd>
		p++, q++;
  8008f3:	41                   	inc    %ecx
  8008f4:	42                   	inc    %edx
	while (*p && *p == *q)
  8008f5:	8a 01                	mov    (%ecx),%al
  8008f7:	84 c0                	test   %al,%al
  8008f9:	74 04                	je     8008ff <strcmp+0x17>
  8008fb:	3a 02                	cmp    (%edx),%al
  8008fd:	74 f4                	je     8008f3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ff:	0f b6 c0             	movzbl %al,%eax
  800902:	0f b6 12             	movzbl (%edx),%edx
  800905:	29 d0                	sub    %edx,%eax
}
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 55 0c             	mov    0xc(%ebp),%edx
  800913:	89 c3                	mov    %eax,%ebx
  800915:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800918:	eb 02                	jmp    80091c <strncmp+0x13>
		n--, p++, q++;
  80091a:	40                   	inc    %eax
  80091b:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  80091c:	39 d8                	cmp    %ebx,%eax
  80091e:	74 15                	je     800935 <strncmp+0x2c>
  800920:	8a 08                	mov    (%eax),%cl
  800922:	84 c9                	test   %cl,%cl
  800924:	74 04                	je     80092a <strncmp+0x21>
  800926:	3a 0a                	cmp    (%edx),%cl
  800928:	74 f0                	je     80091a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80092a:	0f b6 00             	movzbl (%eax),%eax
  80092d:	0f b6 12             	movzbl (%edx),%edx
  800930:	29 d0                	sub    %edx,%eax
}
  800932:	5b                   	pop    %ebx
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    
		return 0;
  800935:	b8 00 00 00 00       	mov    $0x0,%eax
  80093a:	eb f6                	jmp    800932 <strncmp+0x29>

0080093c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800945:	8a 10                	mov    (%eax),%dl
  800947:	84 d2                	test   %dl,%dl
  800949:	74 07                	je     800952 <strchr+0x16>
		if (*s == c)
  80094b:	38 ca                	cmp    %cl,%dl
  80094d:	74 08                	je     800957 <strchr+0x1b>
	for (; *s; s++)
  80094f:	40                   	inc    %eax
  800950:	eb f3                	jmp    800945 <strchr+0x9>
			return (char *) s;
	return 0;
  800952:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800962:	8a 10                	mov    (%eax),%dl
  800964:	84 d2                	test   %dl,%dl
  800966:	74 07                	je     80096f <strfind+0x16>
		if (*s == c)
  800968:	38 ca                	cmp    %cl,%dl
  80096a:	74 03                	je     80096f <strfind+0x16>
	for (; *s; s++)
  80096c:	40                   	inc    %eax
  80096d:	eb f3                	jmp    800962 <strfind+0x9>
			break;
	return (char *) s;
}
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	57                   	push   %edi
  800975:	56                   	push   %esi
  800976:	53                   	push   %ebx
  800977:	8b 7d 08             	mov    0x8(%ebp),%edi
  80097a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80097d:	85 c9                	test   %ecx,%ecx
  80097f:	74 13                	je     800994 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800981:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800987:	75 05                	jne    80098e <memset+0x1d>
  800989:	f6 c1 03             	test   $0x3,%cl
  80098c:	74 0d                	je     80099b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80098e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800991:	fc                   	cld    
  800992:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800994:	89 f8                	mov    %edi,%eax
  800996:	5b                   	pop    %ebx
  800997:	5e                   	pop    %esi
  800998:	5f                   	pop    %edi
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    
		c &= 0xFF;
  80099b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80099f:	89 d3                	mov    %edx,%ebx
  8009a1:	c1 e3 08             	shl    $0x8,%ebx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 18             	shl    $0x18,%eax
  8009a9:	89 d6                	mov    %edx,%esi
  8009ab:	c1 e6 10             	shl    $0x10,%esi
  8009ae:	09 f0                	or     %esi,%eax
  8009b0:	09 c2                	or     %eax,%edx
  8009b2:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009b4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b7:	89 d0                	mov    %edx,%eax
  8009b9:	fc                   	cld    
  8009ba:	f3 ab                	rep stos %eax,%es:(%edi)
  8009bc:	eb d6                	jmp    800994 <memset+0x23>

008009be <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	57                   	push   %edi
  8009c2:	56                   	push   %esi
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009cc:	39 c6                	cmp    %eax,%esi
  8009ce:	73 33                	jae    800a03 <memmove+0x45>
  8009d0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d3:	39 d0                	cmp    %edx,%eax
  8009d5:	73 2c                	jae    800a03 <memmove+0x45>
		s += n;
		d += n;
  8009d7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009da:	89 d6                	mov    %edx,%esi
  8009dc:	09 fe                	or     %edi,%esi
  8009de:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e4:	75 13                	jne    8009f9 <memmove+0x3b>
  8009e6:	f6 c1 03             	test   $0x3,%cl
  8009e9:	75 0e                	jne    8009f9 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009eb:	83 ef 04             	sub    $0x4,%edi
  8009ee:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009f4:	fd                   	std    
  8009f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f7:	eb 07                	jmp    800a00 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009f9:	4f                   	dec    %edi
  8009fa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009fd:	fd                   	std    
  8009fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a00:	fc                   	cld    
  800a01:	eb 13                	jmp    800a16 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a03:	89 f2                	mov    %esi,%edx
  800a05:	09 c2                	or     %eax,%edx
  800a07:	f6 c2 03             	test   $0x3,%dl
  800a0a:	75 05                	jne    800a11 <memmove+0x53>
  800a0c:	f6 c1 03             	test   $0x3,%cl
  800a0f:	74 09                	je     800a1a <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a11:	89 c7                	mov    %eax,%edi
  800a13:	fc                   	cld    
  800a14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a16:	5e                   	pop    %esi
  800a17:	5f                   	pop    %edi
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a1d:	89 c7                	mov    %eax,%edi
  800a1f:	fc                   	cld    
  800a20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a22:	eb f2                	jmp    800a16 <memmove+0x58>

00800a24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a27:	ff 75 10             	pushl  0x10(%ebp)
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	e8 89 ff ff ff       	call   8009be <memmove>
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	56                   	push   %esi
  800a3b:	53                   	push   %ebx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	89 c6                	mov    %eax,%esi
  800a41:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800a44:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a47:	39 f0                	cmp    %esi,%eax
  800a49:	74 16                	je     800a61 <memcmp+0x2a>
		if (*s1 != *s2)
  800a4b:	8a 08                	mov    (%eax),%cl
  800a4d:	8a 1a                	mov    (%edx),%bl
  800a4f:	38 d9                	cmp    %bl,%cl
  800a51:	75 04                	jne    800a57 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a53:	40                   	inc    %eax
  800a54:	42                   	inc    %edx
  800a55:	eb f0                	jmp    800a47 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a57:	0f b6 c1             	movzbl %cl,%eax
  800a5a:	0f b6 db             	movzbl %bl,%ebx
  800a5d:	29 d8                	sub    %ebx,%eax
  800a5f:	eb 05                	jmp    800a66 <memcmp+0x2f>
	}

	return 0;
  800a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a66:	5b                   	pop    %ebx
  800a67:	5e                   	pop    %esi
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a73:	89 c2                	mov    %eax,%edx
  800a75:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a78:	39 d0                	cmp    %edx,%eax
  800a7a:	73 07                	jae    800a83 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a7c:	38 08                	cmp    %cl,(%eax)
  800a7e:	74 03                	je     800a83 <memfind+0x19>
	for (; s < ends; s++)
  800a80:	40                   	inc    %eax
  800a81:	eb f5                	jmp    800a78 <memfind+0xe>
			break;
	return (void *) s;
}
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	57                   	push   %edi
  800a89:	56                   	push   %esi
  800a8a:	53                   	push   %ebx
  800a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a8e:	eb 01                	jmp    800a91 <strtol+0xc>
		s++;
  800a90:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a91:	8a 01                	mov    (%ecx),%al
  800a93:	3c 20                	cmp    $0x20,%al
  800a95:	74 f9                	je     800a90 <strtol+0xb>
  800a97:	3c 09                	cmp    $0x9,%al
  800a99:	74 f5                	je     800a90 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a9b:	3c 2b                	cmp    $0x2b,%al
  800a9d:	74 2b                	je     800aca <strtol+0x45>
		s++;
	else if (*s == '-')
  800a9f:	3c 2d                	cmp    $0x2d,%al
  800aa1:	74 2f                	je     800ad2 <strtol+0x4d>
	int neg = 0;
  800aa3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa8:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800aaf:	75 12                	jne    800ac3 <strtol+0x3e>
  800ab1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab4:	74 24                	je     800ada <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ab6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aba:	75 07                	jne    800ac3 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800abc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac8:	eb 4e                	jmp    800b18 <strtol+0x93>
		s++;
  800aca:	41                   	inc    %ecx
	int neg = 0;
  800acb:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad0:	eb d6                	jmp    800aa8 <strtol+0x23>
		s++, neg = 1;
  800ad2:	41                   	inc    %ecx
  800ad3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad8:	eb ce                	jmp    800aa8 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ada:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ade:	74 10                	je     800af0 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800ae0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ae4:	75 dd                	jne    800ac3 <strtol+0x3e>
		s++, base = 8;
  800ae6:	41                   	inc    %ecx
  800ae7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800aee:	eb d3                	jmp    800ac3 <strtol+0x3e>
		s += 2, base = 16;
  800af0:	83 c1 02             	add    $0x2,%ecx
  800af3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800afa:	eb c7                	jmp    800ac3 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800afc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aff:	89 f3                	mov    %esi,%ebx
  800b01:	80 fb 19             	cmp    $0x19,%bl
  800b04:	77 24                	ja     800b2a <strtol+0xa5>
			dig = *s - 'a' + 10;
  800b06:	0f be d2             	movsbl %dl,%edx
  800b09:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b0c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b0f:	7d 2b                	jge    800b3c <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800b11:	41                   	inc    %ecx
  800b12:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b16:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b18:	8a 11                	mov    (%ecx),%dl
  800b1a:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b1d:	80 fb 09             	cmp    $0x9,%bl
  800b20:	77 da                	ja     800afc <strtol+0x77>
			dig = *s - '0';
  800b22:	0f be d2             	movsbl %dl,%edx
  800b25:	83 ea 30             	sub    $0x30,%edx
  800b28:	eb e2                	jmp    800b0c <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b2a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b2d:	89 f3                	mov    %esi,%ebx
  800b2f:	80 fb 19             	cmp    $0x19,%bl
  800b32:	77 08                	ja     800b3c <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b34:	0f be d2             	movsbl %dl,%edx
  800b37:	83 ea 37             	sub    $0x37,%edx
  800b3a:	eb d0                	jmp    800b0c <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b40:	74 05                	je     800b47 <strtol+0xc2>
		*endptr = (char *) s;
  800b42:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b45:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b47:	85 ff                	test   %edi,%edi
  800b49:	74 02                	je     800b4d <strtol+0xc8>
  800b4b:	f7 d8                	neg    %eax
}
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <atoi>:

int
atoi(const char *s)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b55:	6a 0a                	push   $0xa
  800b57:	6a 00                	push   $0x0
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 24 ff ff ff       	call   800a85 <strtol>
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b71:	8b 55 08             	mov    0x8(%ebp),%edx
  800b74:	89 c3                	mov    %eax,%ebx
  800b76:	89 c7                	mov    %eax,%edi
  800b78:	89 c6                	mov    %eax,%esi
  800b7a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b7c:	5b                   	pop    %ebx
  800b7d:	5e                   	pop    %esi
  800b7e:	5f                   	pop    %edi
  800b7f:	5d                   	pop    %ebp
  800b80:	c3                   	ret    

00800b81 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	57                   	push   %edi
  800b85:	56                   	push   %esi
  800b86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b87:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8c:	b8 01 00 00 00       	mov    $0x1,%eax
  800b91:	89 d1                	mov    %edx,%ecx
  800b93:	89 d3                	mov    %edx,%ebx
  800b95:	89 d7                	mov    %edx,%edi
  800b97:	89 d6                	mov    %edx,%esi
  800b99:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
  800ba6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bae:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb6:	89 cb                	mov    %ecx,%ebx
  800bb8:	89 cf                	mov    %ecx,%edi
  800bba:	89 ce                	mov    %ecx,%esi
  800bbc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbe:	85 c0                	test   %eax,%eax
  800bc0:	7f 08                	jg     800bca <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bca:	83 ec 0c             	sub    $0xc,%esp
  800bcd:	50                   	push   %eax
  800bce:	6a 03                	push   $0x3
  800bd0:	68 9f 23 80 00       	push   $0x80239f
  800bd5:	6a 23                	push   $0x23
  800bd7:	68 bc 23 80 00       	push   $0x8023bc
  800bdc:	e8 4f f5 ff ff       	call   800130 <_panic>

00800be1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	57                   	push   %edi
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bec:	b8 02 00 00 00       	mov    $0x2,%eax
  800bf1:	89 d1                	mov    %edx,%ecx
  800bf3:	89 d3                	mov    %edx,%ebx
  800bf5:	89 d7                	mov    %edx,%edi
  800bf7:	89 d6                	mov    %edx,%esi
  800bf9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	57                   	push   %edi
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c09:	be 00 00 00 00       	mov    $0x0,%esi
  800c0e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c1c:	89 f7                	mov    %esi,%edi
  800c1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c20:	85 c0                	test   %eax,%eax
  800c22:	7f 08                	jg     800c2c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2c:	83 ec 0c             	sub    $0xc,%esp
  800c2f:	50                   	push   %eax
  800c30:	6a 04                	push   $0x4
  800c32:	68 9f 23 80 00       	push   $0x80239f
  800c37:	6a 23                	push   $0x23
  800c39:	68 bc 23 80 00       	push   $0x8023bc
  800c3e:	e8 ed f4 ff ff       	call   800130 <_panic>

00800c43 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4c:	b8 05 00 00 00       	mov    $0x5,%eax
  800c51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c5d:	8b 75 18             	mov    0x18(%ebp),%esi
  800c60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c62:	85 c0                	test   %eax,%eax
  800c64:	7f 08                	jg     800c6e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6e:	83 ec 0c             	sub    $0xc,%esp
  800c71:	50                   	push   %eax
  800c72:	6a 05                	push   $0x5
  800c74:	68 9f 23 80 00       	push   $0x80239f
  800c79:	6a 23                	push   $0x23
  800c7b:	68 bc 23 80 00       	push   $0x8023bc
  800c80:	e8 ab f4 ff ff       	call   800130 <_panic>

00800c85 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c93:	b8 06 00 00 00       	mov    $0x6,%eax
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9e:	89 df                	mov    %ebx,%edi
  800ca0:	89 de                	mov    %ebx,%esi
  800ca2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	7f 08                	jg     800cb0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb0:	83 ec 0c             	sub    $0xc,%esp
  800cb3:	50                   	push   %eax
  800cb4:	6a 06                	push   $0x6
  800cb6:	68 9f 23 80 00       	push   $0x80239f
  800cbb:	6a 23                	push   $0x23
  800cbd:	68 bc 23 80 00       	push   $0x8023bc
  800cc2:	e8 69 f4 ff ff       	call   800130 <_panic>

00800cc7 <sys_yield>:

void
sys_yield(void)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd7:	89 d1                	mov    %edx,%ecx
  800cd9:	89 d3                	mov    %edx,%ebx
  800cdb:	89 d7                	mov    %edx,%edi
  800cdd:	89 d6                	mov    %edx,%esi
  800cdf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	57                   	push   %edi
  800cea:	56                   	push   %esi
  800ceb:	53                   	push   %ebx
  800cec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cef:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	89 df                	mov    %ebx,%edi
  800d01:	89 de                	mov    %ebx,%esi
  800d03:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d05:	85 c0                	test   %eax,%eax
  800d07:	7f 08                	jg     800d11 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0c:	5b                   	pop    %ebx
  800d0d:	5e                   	pop    %esi
  800d0e:	5f                   	pop    %edi
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d11:	83 ec 0c             	sub    $0xc,%esp
  800d14:	50                   	push   %eax
  800d15:	6a 08                	push   $0x8
  800d17:	68 9f 23 80 00       	push   $0x80239f
  800d1c:	6a 23                	push   $0x23
  800d1e:	68 bc 23 80 00       	push   $0x8023bc
  800d23:	e8 08 f4 ff ff       	call   800130 <_panic>

00800d28 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d36:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	89 cb                	mov    %ecx,%ebx
  800d40:	89 cf                	mov    %ecx,%edi
  800d42:	89 ce                	mov    %ecx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 0c                	push   $0xc
  800d58:	68 9f 23 80 00       	push   $0x80239f
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 bc 23 80 00       	push   $0x8023bc
  800d64:	e8 c7 f3 ff ff       	call   800130 <_panic>

00800d69 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d77:	b8 09 00 00 00       	mov    $0x9,%eax
  800d7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	89 df                	mov    %ebx,%edi
  800d84:	89 de                	mov    %ebx,%esi
  800d86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	7f 08                	jg     800d94 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d94:	83 ec 0c             	sub    $0xc,%esp
  800d97:	50                   	push   %eax
  800d98:	6a 09                	push   $0x9
  800d9a:	68 9f 23 80 00       	push   $0x80239f
  800d9f:	6a 23                	push   $0x23
  800da1:	68 bc 23 80 00       	push   $0x8023bc
  800da6:	e8 85 f3 ff ff       	call   800130 <_panic>

00800dab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
  800db1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	89 df                	mov    %ebx,%edi
  800dc6:	89 de                	mov    %ebx,%esi
  800dc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	7f 08                	jg     800dd6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd6:	83 ec 0c             	sub    $0xc,%esp
  800dd9:	50                   	push   %eax
  800dda:	6a 0a                	push   $0xa
  800ddc:	68 9f 23 80 00       	push   $0x80239f
  800de1:	6a 23                	push   $0x23
  800de3:	68 bc 23 80 00       	push   $0x8023bc
  800de8:	e8 43 f3 ff ff       	call   800130 <_panic>

00800ded <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df3:	be 00 00 00 00       	mov    $0x0,%esi
  800df8:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	8b 55 08             	mov    0x8(%ebp),%edx
  800e03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e06:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e09:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e23:	8b 55 08             	mov    0x8(%ebp),%edx
  800e26:	89 cb                	mov    %ecx,%ebx
  800e28:	89 cf                	mov    %ecx,%edi
  800e2a:	89 ce                	mov    %ecx,%esi
  800e2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	7f 08                	jg     800e3a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	50                   	push   %eax
  800e3e:	6a 0e                	push   $0xe
  800e40:	68 9f 23 80 00       	push   $0x80239f
  800e45:	6a 23                	push   $0x23
  800e47:	68 bc 23 80 00       	push   $0x8023bc
  800e4c:	e8 df f2 ff ff       	call   800130 <_panic>

00800e51 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	57                   	push   %edi
  800e55:	56                   	push   %esi
  800e56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e57:	be 00 00 00 00       	mov    $0x0,%esi
  800e5c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6a:	89 f7                	mov    %esi,%edi
  800e6c:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e79:	be 00 00 00 00       	mov    $0x0,%esi
  800e7e:	b8 10 00 00 00       	mov    $0x10,%eax
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8c:	89 f7                	mov    %esi,%edi
  800e8e:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea0:	b8 11 00 00 00       	mov    $0x11,%eax
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	89 cb                	mov    %ecx,%ebx
  800eaa:	89 cf                	mov    %ecx,%edi
  800eac:	89 ce                	mov    %ecx,%esi
  800eae:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800ebb:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800ec2:	74 0a                	je     800ece <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800ecc:	c9                   	leave  
  800ecd:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  800ece:	e8 0e fd ff ff       	call   800be1 <sys_getenvid>
  800ed3:	83 ec 04             	sub    $0x4,%esp
  800ed6:	6a 07                	push   $0x7
  800ed8:	68 00 f0 bf ee       	push   $0xeebff000
  800edd:	50                   	push   %eax
  800ede:	e8 1d fd ff ff       	call   800c00 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  800ee3:	e8 f9 fc ff ff       	call   800be1 <sys_getenvid>
  800ee8:	83 c4 08             	add    $0x8,%esp
  800eeb:	68 fb 0e 80 00       	push   $0x800efb
  800ef0:	50                   	push   %eax
  800ef1:	e8 b5 fe ff ff       	call   800dab <sys_env_set_pgfault_upcall>
  800ef6:	83 c4 10             	add    $0x10,%esp
  800ef9:	eb c9                	jmp    800ec4 <set_pgfault_handler+0xf>

00800efb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800efb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800efc:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800f01:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f03:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  800f06:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800f0a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800f0e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800f11:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800f13:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  800f17:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800f1a:	61                   	popa   
	addl $4, %esp
  800f1b:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  800f1e:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800f1f:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800f20:	c3                   	ret    

00800f21 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	05 00 00 00 30       	add    $0x30000000,%eax
  800f2c:	c1 e8 0c             	shr    $0xc,%eax
}
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    

00800f31 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f41:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    

00800f48 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f4e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	c1 ea 16             	shr    $0x16,%edx
  800f58:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f5f:	f6 c2 01             	test   $0x1,%dl
  800f62:	74 2a                	je     800f8e <fd_alloc+0x46>
  800f64:	89 c2                	mov    %eax,%edx
  800f66:	c1 ea 0c             	shr    $0xc,%edx
  800f69:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f70:	f6 c2 01             	test   $0x1,%dl
  800f73:	74 19                	je     800f8e <fd_alloc+0x46>
  800f75:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f7a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f7f:	75 d2                	jne    800f53 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f81:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f87:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f8c:	eb 07                	jmp    800f95 <fd_alloc+0x4d>
			*fd_store = fd;
  800f8e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f9a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800f9e:	77 39                	ja     800fd9 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	c1 e0 0c             	shl    $0xc,%eax
  800fa6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fab:	89 c2                	mov    %eax,%edx
  800fad:	c1 ea 16             	shr    $0x16,%edx
  800fb0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fb7:	f6 c2 01             	test   $0x1,%dl
  800fba:	74 24                	je     800fe0 <fd_lookup+0x49>
  800fbc:	89 c2                	mov    %eax,%edx
  800fbe:	c1 ea 0c             	shr    $0xc,%edx
  800fc1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fc8:	f6 c2 01             	test   $0x1,%dl
  800fcb:	74 1a                	je     800fe7 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	89 02                	mov    %eax,(%edx)
	return 0;
  800fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    
		return -E_INVAL;
  800fd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fde:	eb f7                	jmp    800fd7 <fd_lookup+0x40>
		return -E_INVAL;
  800fe0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe5:	eb f0                	jmp    800fd7 <fd_lookup+0x40>
  800fe7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fec:	eb e9                	jmp    800fd7 <fd_lookup+0x40>

00800fee <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 08             	sub    $0x8,%esp
  800ff4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff7:	ba 48 24 80 00       	mov    $0x802448,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ffc:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801001:	39 08                	cmp    %ecx,(%eax)
  801003:	74 33                	je     801038 <dev_lookup+0x4a>
  801005:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801008:	8b 02                	mov    (%edx),%eax
  80100a:	85 c0                	test   %eax,%eax
  80100c:	75 f3                	jne    801001 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80100e:	a1 04 40 80 00       	mov    0x804004,%eax
  801013:	8b 40 48             	mov    0x48(%eax),%eax
  801016:	83 ec 04             	sub    $0x4,%esp
  801019:	51                   	push   %ecx
  80101a:	50                   	push   %eax
  80101b:	68 cc 23 80 00       	push   $0x8023cc
  801020:	e8 1e f2 ff ff       	call   800243 <cprintf>
	*dev = 0;
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    
			*dev = devtab[i];
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80103d:	b8 00 00 00 00       	mov    $0x0,%eax
  801042:	eb f2                	jmp    801036 <dev_lookup+0x48>

00801044 <fd_close>:
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	57                   	push   %edi
  801048:	56                   	push   %esi
  801049:	53                   	push   %ebx
  80104a:	83 ec 1c             	sub    $0x1c,%esp
  80104d:	8b 75 08             	mov    0x8(%ebp),%esi
  801050:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801053:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801056:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801057:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80105d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801060:	50                   	push   %eax
  801061:	e8 31 ff ff ff       	call   800f97 <fd_lookup>
  801066:	89 c7                	mov    %eax,%edi
  801068:	83 c4 08             	add    $0x8,%esp
  80106b:	85 c0                	test   %eax,%eax
  80106d:	78 05                	js     801074 <fd_close+0x30>
	    || fd != fd2)
  80106f:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801072:	74 13                	je     801087 <fd_close+0x43>
		return (must_exist ? r : 0);
  801074:	84 db                	test   %bl,%bl
  801076:	75 05                	jne    80107d <fd_close+0x39>
  801078:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80107d:	89 f8                	mov    %edi,%eax
  80107f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801082:	5b                   	pop    %ebx
  801083:	5e                   	pop    %esi
  801084:	5f                   	pop    %edi
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801087:	83 ec 08             	sub    $0x8,%esp
  80108a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80108d:	50                   	push   %eax
  80108e:	ff 36                	pushl  (%esi)
  801090:	e8 59 ff ff ff       	call   800fee <dev_lookup>
  801095:	89 c7                	mov    %eax,%edi
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	85 c0                	test   %eax,%eax
  80109c:	78 15                	js     8010b3 <fd_close+0x6f>
		if (dev->dev_close)
  80109e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010a1:	8b 40 10             	mov    0x10(%eax),%eax
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	74 1b                	je     8010c3 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8010a8:	83 ec 0c             	sub    $0xc,%esp
  8010ab:	56                   	push   %esi
  8010ac:	ff d0                	call   *%eax
  8010ae:	89 c7                	mov    %eax,%edi
  8010b0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	56                   	push   %esi
  8010b7:	6a 00                	push   $0x0
  8010b9:	e8 c7 fb ff ff       	call   800c85 <sys_page_unmap>
	return r;
  8010be:	83 c4 10             	add    $0x10,%esp
  8010c1:	eb ba                	jmp    80107d <fd_close+0x39>
			r = 0;
  8010c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c8:	eb e9                	jmp    8010b3 <fd_close+0x6f>

008010ca <close>:

int
close(int fdnum)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d3:	50                   	push   %eax
  8010d4:	ff 75 08             	pushl  0x8(%ebp)
  8010d7:	e8 bb fe ff ff       	call   800f97 <fd_lookup>
  8010dc:	83 c4 08             	add    $0x8,%esp
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	78 10                	js     8010f3 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010e3:	83 ec 08             	sub    $0x8,%esp
  8010e6:	6a 01                	push   $0x1
  8010e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010eb:	e8 54 ff ff ff       	call   801044 <fd_close>
  8010f0:	83 c4 10             	add    $0x10,%esp
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <close_all>:

void
close_all(void)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	53                   	push   %ebx
  8010f9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010fc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801101:	83 ec 0c             	sub    $0xc,%esp
  801104:	53                   	push   %ebx
  801105:	e8 c0 ff ff ff       	call   8010ca <close>
	for (i = 0; i < MAXFD; i++)
  80110a:	43                   	inc    %ebx
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	83 fb 20             	cmp    $0x20,%ebx
  801111:	75 ee                	jne    801101 <close_all+0xc>
}
  801113:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801116:	c9                   	leave  
  801117:	c3                   	ret    

00801118 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	57                   	push   %edi
  80111c:	56                   	push   %esi
  80111d:	53                   	push   %ebx
  80111e:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801121:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801124:	50                   	push   %eax
  801125:	ff 75 08             	pushl  0x8(%ebp)
  801128:	e8 6a fe ff ff       	call   800f97 <fd_lookup>
  80112d:	89 c3                	mov    %eax,%ebx
  80112f:	83 c4 08             	add    $0x8,%esp
  801132:	85 c0                	test   %eax,%eax
  801134:	0f 88 81 00 00 00    	js     8011bb <dup+0xa3>
		return r;
	close(newfdnum);
  80113a:	83 ec 0c             	sub    $0xc,%esp
  80113d:	ff 75 0c             	pushl  0xc(%ebp)
  801140:	e8 85 ff ff ff       	call   8010ca <close>

	newfd = INDEX2FD(newfdnum);
  801145:	8b 75 0c             	mov    0xc(%ebp),%esi
  801148:	c1 e6 0c             	shl    $0xc,%esi
  80114b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801151:	83 c4 04             	add    $0x4,%esp
  801154:	ff 75 e4             	pushl  -0x1c(%ebp)
  801157:	e8 d5 fd ff ff       	call   800f31 <fd2data>
  80115c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80115e:	89 34 24             	mov    %esi,(%esp)
  801161:	e8 cb fd ff ff       	call   800f31 <fd2data>
  801166:	83 c4 10             	add    $0x10,%esp
  801169:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80116b:	89 d8                	mov    %ebx,%eax
  80116d:	c1 e8 16             	shr    $0x16,%eax
  801170:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801177:	a8 01                	test   $0x1,%al
  801179:	74 11                	je     80118c <dup+0x74>
  80117b:	89 d8                	mov    %ebx,%eax
  80117d:	c1 e8 0c             	shr    $0xc,%eax
  801180:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801187:	f6 c2 01             	test   $0x1,%dl
  80118a:	75 39                	jne    8011c5 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80118c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80118f:	89 d0                	mov    %edx,%eax
  801191:	c1 e8 0c             	shr    $0xc,%eax
  801194:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	25 07 0e 00 00       	and    $0xe07,%eax
  8011a3:	50                   	push   %eax
  8011a4:	56                   	push   %esi
  8011a5:	6a 00                	push   $0x0
  8011a7:	52                   	push   %edx
  8011a8:	6a 00                	push   $0x0
  8011aa:	e8 94 fa ff ff       	call   800c43 <sys_page_map>
  8011af:	89 c3                	mov    %eax,%ebx
  8011b1:	83 c4 20             	add    $0x20,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	78 31                	js     8011e9 <dup+0xd1>
		goto err;

	return newfdnum;
  8011b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011bb:	89 d8                	mov    %ebx,%eax
  8011bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c0:	5b                   	pop    %ebx
  8011c1:	5e                   	pop    %esi
  8011c2:	5f                   	pop    %edi
  8011c3:	5d                   	pop    %ebp
  8011c4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011c5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8011d4:	50                   	push   %eax
  8011d5:	57                   	push   %edi
  8011d6:	6a 00                	push   $0x0
  8011d8:	53                   	push   %ebx
  8011d9:	6a 00                	push   $0x0
  8011db:	e8 63 fa ff ff       	call   800c43 <sys_page_map>
  8011e0:	89 c3                	mov    %eax,%ebx
  8011e2:	83 c4 20             	add    $0x20,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	79 a3                	jns    80118c <dup+0x74>
	sys_page_unmap(0, newfd);
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	56                   	push   %esi
  8011ed:	6a 00                	push   $0x0
  8011ef:	e8 91 fa ff ff       	call   800c85 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011f4:	83 c4 08             	add    $0x8,%esp
  8011f7:	57                   	push   %edi
  8011f8:	6a 00                	push   $0x0
  8011fa:	e8 86 fa ff ff       	call   800c85 <sys_page_unmap>
	return r;
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	eb b7                	jmp    8011bb <dup+0xa3>

00801204 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	53                   	push   %ebx
  801208:	83 ec 14             	sub    $0x14,%esp
  80120b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80120e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801211:	50                   	push   %eax
  801212:	53                   	push   %ebx
  801213:	e8 7f fd ff ff       	call   800f97 <fd_lookup>
  801218:	83 c4 08             	add    $0x8,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	78 3f                	js     80125e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80121f:	83 ec 08             	sub    $0x8,%esp
  801222:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801225:	50                   	push   %eax
  801226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801229:	ff 30                	pushl  (%eax)
  80122b:	e8 be fd ff ff       	call   800fee <dev_lookup>
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	78 27                	js     80125e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801237:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123a:	8b 42 08             	mov    0x8(%edx),%eax
  80123d:	83 e0 03             	and    $0x3,%eax
  801240:	83 f8 01             	cmp    $0x1,%eax
  801243:	74 1e                	je     801263 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801248:	8b 40 08             	mov    0x8(%eax),%eax
  80124b:	85 c0                	test   %eax,%eax
  80124d:	74 35                	je     801284 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	ff 75 10             	pushl  0x10(%ebp)
  801255:	ff 75 0c             	pushl  0xc(%ebp)
  801258:	52                   	push   %edx
  801259:	ff d0                	call   *%eax
  80125b:	83 c4 10             	add    $0x10,%esp
}
  80125e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801261:	c9                   	leave  
  801262:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801263:	a1 04 40 80 00       	mov    0x804004,%eax
  801268:	8b 40 48             	mov    0x48(%eax),%eax
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	53                   	push   %ebx
  80126f:	50                   	push   %eax
  801270:	68 0d 24 80 00       	push   $0x80240d
  801275:	e8 c9 ef ff ff       	call   800243 <cprintf>
		return -E_INVAL;
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801282:	eb da                	jmp    80125e <read+0x5a>
		return -E_NOT_SUPP;
  801284:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801289:	eb d3                	jmp    80125e <read+0x5a>

0080128b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	57                   	push   %edi
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	83 ec 0c             	sub    $0xc,%esp
  801294:	8b 7d 08             	mov    0x8(%ebp),%edi
  801297:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80129a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129f:	39 f3                	cmp    %esi,%ebx
  8012a1:	73 25                	jae    8012c8 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012a3:	83 ec 04             	sub    $0x4,%esp
  8012a6:	89 f0                	mov    %esi,%eax
  8012a8:	29 d8                	sub    %ebx,%eax
  8012aa:	50                   	push   %eax
  8012ab:	89 d8                	mov    %ebx,%eax
  8012ad:	03 45 0c             	add    0xc(%ebp),%eax
  8012b0:	50                   	push   %eax
  8012b1:	57                   	push   %edi
  8012b2:	e8 4d ff ff ff       	call   801204 <read>
		if (m < 0)
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	78 08                	js     8012c6 <readn+0x3b>
			return m;
		if (m == 0)
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 06                	je     8012c8 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012c2:	01 c3                	add    %eax,%ebx
  8012c4:	eb d9                	jmp    80129f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012c6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012c8:	89 d8                	mov    %ebx,%eax
  8012ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cd:	5b                   	pop    %ebx
  8012ce:	5e                   	pop    %esi
  8012cf:	5f                   	pop    %edi
  8012d0:	5d                   	pop    %ebp
  8012d1:	c3                   	ret    

008012d2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	53                   	push   %ebx
  8012d6:	83 ec 14             	sub    $0x14,%esp
  8012d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012df:	50                   	push   %eax
  8012e0:	53                   	push   %ebx
  8012e1:	e8 b1 fc ff ff       	call   800f97 <fd_lookup>
  8012e6:	83 c4 08             	add    $0x8,%esp
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	78 3a                	js     801327 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f3:	50                   	push   %eax
  8012f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f7:	ff 30                	pushl  (%eax)
  8012f9:	e8 f0 fc ff ff       	call   800fee <dev_lookup>
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	78 22                	js     801327 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801308:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80130c:	74 1e                	je     80132c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80130e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801311:	8b 52 0c             	mov    0xc(%edx),%edx
  801314:	85 d2                	test   %edx,%edx
  801316:	74 35                	je     80134d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801318:	83 ec 04             	sub    $0x4,%esp
  80131b:	ff 75 10             	pushl  0x10(%ebp)
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	ff d2                	call   *%edx
  801324:	83 c4 10             	add    $0x10,%esp
}
  801327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80132c:	a1 04 40 80 00       	mov    0x804004,%eax
  801331:	8b 40 48             	mov    0x48(%eax),%eax
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	53                   	push   %ebx
  801338:	50                   	push   %eax
  801339:	68 29 24 80 00       	push   $0x802429
  80133e:	e8 00 ef ff ff       	call   800243 <cprintf>
		return -E_INVAL;
  801343:	83 c4 10             	add    $0x10,%esp
  801346:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134b:	eb da                	jmp    801327 <write+0x55>
		return -E_NOT_SUPP;
  80134d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801352:	eb d3                	jmp    801327 <write+0x55>

00801354 <seek>:

int
seek(int fdnum, off_t offset)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80135a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80135d:	50                   	push   %eax
  80135e:	ff 75 08             	pushl  0x8(%ebp)
  801361:	e8 31 fc ff ff       	call   800f97 <fd_lookup>
  801366:	83 c4 08             	add    $0x8,%esp
  801369:	85 c0                	test   %eax,%eax
  80136b:	78 0e                	js     80137b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801376:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	53                   	push   %ebx
  801381:	83 ec 14             	sub    $0x14,%esp
  801384:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801387:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80138a:	50                   	push   %eax
  80138b:	53                   	push   %ebx
  80138c:	e8 06 fc ff ff       	call   800f97 <fd_lookup>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	78 37                	js     8013cf <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801398:	83 ec 08             	sub    $0x8,%esp
  80139b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139e:	50                   	push   %eax
  80139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a2:	ff 30                	pushl  (%eax)
  8013a4:	e8 45 fc ff ff       	call   800fee <dev_lookup>
  8013a9:	83 c4 10             	add    $0x10,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	78 1f                	js     8013cf <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b7:	74 1b                	je     8013d4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bc:	8b 52 18             	mov    0x18(%edx),%edx
  8013bf:	85 d2                	test   %edx,%edx
  8013c1:	74 32                	je     8013f5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	ff 75 0c             	pushl  0xc(%ebp)
  8013c9:	50                   	push   %eax
  8013ca:	ff d2                	call   *%edx
  8013cc:	83 c4 10             	add    $0x10,%esp
}
  8013cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013d4:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013d9:	8b 40 48             	mov    0x48(%eax),%eax
  8013dc:	83 ec 04             	sub    $0x4,%esp
  8013df:	53                   	push   %ebx
  8013e0:	50                   	push   %eax
  8013e1:	68 ec 23 80 00       	push   $0x8023ec
  8013e6:	e8 58 ee ff ff       	call   800243 <cprintf>
		return -E_INVAL;
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f3:	eb da                	jmp    8013cf <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013fa:	eb d3                	jmp    8013cf <ftruncate+0x52>

008013fc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	53                   	push   %ebx
  801400:	83 ec 14             	sub    $0x14,%esp
  801403:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801406:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801409:	50                   	push   %eax
  80140a:	ff 75 08             	pushl  0x8(%ebp)
  80140d:	e8 85 fb ff ff       	call   800f97 <fd_lookup>
  801412:	83 c4 08             	add    $0x8,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	78 4b                	js     801464 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801423:	ff 30                	pushl  (%eax)
  801425:	e8 c4 fb ff ff       	call   800fee <dev_lookup>
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 33                	js     801464 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801434:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801438:	74 2f                	je     801469 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80143a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80143d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801444:	00 00 00 
	stat->st_type = 0;
  801447:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80144e:	00 00 00 
	stat->st_dev = dev;
  801451:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	53                   	push   %ebx
  80145b:	ff 75 f0             	pushl  -0x10(%ebp)
  80145e:	ff 50 14             	call   *0x14(%eax)
  801461:	83 c4 10             	add    $0x10,%esp
}
  801464:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801467:	c9                   	leave  
  801468:	c3                   	ret    
		return -E_NOT_SUPP;
  801469:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146e:	eb f4                	jmp    801464 <fstat+0x68>

00801470 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	56                   	push   %esi
  801474:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	6a 00                	push   $0x0
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 34 02 00 00       	call   8016b6 <open>
  801482:	89 c3                	mov    %eax,%ebx
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 1b                	js     8014a6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80148b:	83 ec 08             	sub    $0x8,%esp
  80148e:	ff 75 0c             	pushl  0xc(%ebp)
  801491:	50                   	push   %eax
  801492:	e8 65 ff ff ff       	call   8013fc <fstat>
  801497:	89 c6                	mov    %eax,%esi
	close(fd);
  801499:	89 1c 24             	mov    %ebx,(%esp)
  80149c:	e8 29 fc ff ff       	call   8010ca <close>
	return r;
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	89 f3                	mov    %esi,%ebx
}
  8014a6:	89 d8                	mov    %ebx,%eax
  8014a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ab:	5b                   	pop    %ebx
  8014ac:	5e                   	pop    %esi
  8014ad:	5d                   	pop    %ebp
  8014ae:	c3                   	ret    

008014af <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	56                   	push   %esi
  8014b3:	53                   	push   %ebx
  8014b4:	89 c6                	mov    %eax,%esi
  8014b6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014b8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014bf:	74 27                	je     8014e8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014c1:	6a 07                	push   $0x7
  8014c3:	68 00 50 80 00       	push   $0x805000
  8014c8:	56                   	push   %esi
  8014c9:	ff 35 00 40 80 00    	pushl  0x804000
  8014cf:	e8 e1 07 00 00       	call   801cb5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014d4:	83 c4 0c             	add    $0xc,%esp
  8014d7:	6a 00                	push   $0x0
  8014d9:	53                   	push   %ebx
  8014da:	6a 00                	push   $0x0
  8014dc:	e8 4b 07 00 00       	call   801c2c <ipc_recv>
}
  8014e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e4:	5b                   	pop    %ebx
  8014e5:	5e                   	pop    %esi
  8014e6:	5d                   	pop    %ebp
  8014e7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014e8:	83 ec 0c             	sub    $0xc,%esp
  8014eb:	6a 01                	push   $0x1
  8014ed:	e8 1f 08 00 00       	call   801d11 <ipc_find_env>
  8014f2:	a3 00 40 80 00       	mov    %eax,0x804000
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	eb c5                	jmp    8014c1 <fsipc+0x12>

008014fc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8b 40 0c             	mov    0xc(%eax),%eax
  801508:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801515:	ba 00 00 00 00       	mov    $0x0,%edx
  80151a:	b8 02 00 00 00       	mov    $0x2,%eax
  80151f:	e8 8b ff ff ff       	call   8014af <fsipc>
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <devfile_flush>:
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8b 40 0c             	mov    0xc(%eax),%eax
  801532:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801537:	ba 00 00 00 00       	mov    $0x0,%edx
  80153c:	b8 06 00 00 00       	mov    $0x6,%eax
  801541:	e8 69 ff ff ff       	call   8014af <fsipc>
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <devfile_stat>:
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	53                   	push   %ebx
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	8b 40 0c             	mov    0xc(%eax),%eax
  801558:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80155d:	ba 00 00 00 00       	mov    $0x0,%edx
  801562:	b8 05 00 00 00       	mov    $0x5,%eax
  801567:	e8 43 ff ff ff       	call   8014af <fsipc>
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 2c                	js     80159c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801570:	83 ec 08             	sub    $0x8,%esp
  801573:	68 00 50 80 00       	push   $0x805000
  801578:	53                   	push   %ebx
  801579:	e8 cd f2 ff ff       	call   80084b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80157e:	a1 80 50 80 00       	mov    0x805080,%eax
  801583:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801589:	a1 84 50 80 00       	mov    0x805084,%eax
  80158e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <devfile_write>:
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	53                   	push   %ebx
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8015ab:	89 d8                	mov    %ebx,%eax
  8015ad:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8015b3:	76 05                	jbe    8015ba <devfile_write+0x19>
  8015b5:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c0:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8015c6:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	50                   	push   %eax
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	68 08 50 80 00       	push   $0x805008
  8015d7:	e8 e2 f3 ff ff       	call   8009be <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8015dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e1:	b8 04 00 00 00       	mov    $0x4,%eax
  8015e6:	e8 c4 fe ff ff       	call   8014af <fsipc>
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 0b                	js     8015fd <devfile_write+0x5c>
	assert(r <= n);
  8015f2:	39 c3                	cmp    %eax,%ebx
  8015f4:	72 0c                	jb     801602 <devfile_write+0x61>
	assert(r <= PGSIZE);
  8015f6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015fb:	7f 1e                	jg     80161b <devfile_write+0x7a>
}
  8015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801600:	c9                   	leave  
  801601:	c3                   	ret    
	assert(r <= n);
  801602:	68 58 24 80 00       	push   $0x802458
  801607:	68 5f 24 80 00       	push   $0x80245f
  80160c:	68 98 00 00 00       	push   $0x98
  801611:	68 74 24 80 00       	push   $0x802474
  801616:	e8 15 eb ff ff       	call   800130 <_panic>
	assert(r <= PGSIZE);
  80161b:	68 7f 24 80 00       	push   $0x80247f
  801620:	68 5f 24 80 00       	push   $0x80245f
  801625:	68 99 00 00 00       	push   $0x99
  80162a:	68 74 24 80 00       	push   $0x802474
  80162f:	e8 fc ea ff ff       	call   800130 <_panic>

00801634 <devfile_read>:
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	56                   	push   %esi
  801638:	53                   	push   %ebx
  801639:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8b 40 0c             	mov    0xc(%eax),%eax
  801642:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801647:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80164d:	ba 00 00 00 00       	mov    $0x0,%edx
  801652:	b8 03 00 00 00       	mov    $0x3,%eax
  801657:	e8 53 fe ff ff       	call   8014af <fsipc>
  80165c:	89 c3                	mov    %eax,%ebx
  80165e:	85 c0                	test   %eax,%eax
  801660:	78 1f                	js     801681 <devfile_read+0x4d>
	assert(r <= n);
  801662:	39 c6                	cmp    %eax,%esi
  801664:	72 24                	jb     80168a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801666:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80166b:	7f 33                	jg     8016a0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80166d:	83 ec 04             	sub    $0x4,%esp
  801670:	50                   	push   %eax
  801671:	68 00 50 80 00       	push   $0x805000
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	e8 40 f3 ff ff       	call   8009be <memmove>
	return r;
  80167e:	83 c4 10             	add    $0x10,%esp
}
  801681:	89 d8                	mov    %ebx,%eax
  801683:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801686:	5b                   	pop    %ebx
  801687:	5e                   	pop    %esi
  801688:	5d                   	pop    %ebp
  801689:	c3                   	ret    
	assert(r <= n);
  80168a:	68 58 24 80 00       	push   $0x802458
  80168f:	68 5f 24 80 00       	push   $0x80245f
  801694:	6a 7c                	push   $0x7c
  801696:	68 74 24 80 00       	push   $0x802474
  80169b:	e8 90 ea ff ff       	call   800130 <_panic>
	assert(r <= PGSIZE);
  8016a0:	68 7f 24 80 00       	push   $0x80247f
  8016a5:	68 5f 24 80 00       	push   $0x80245f
  8016aa:	6a 7d                	push   $0x7d
  8016ac:	68 74 24 80 00       	push   $0x802474
  8016b1:	e8 7a ea ff ff       	call   800130 <_panic>

008016b6 <open>:
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	56                   	push   %esi
  8016ba:	53                   	push   %ebx
  8016bb:	83 ec 1c             	sub    $0x1c,%esp
  8016be:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016c1:	56                   	push   %esi
  8016c2:	e8 51 f1 ff ff       	call   800818 <strlen>
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016cf:	7f 6c                	jg     80173d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016d1:	83 ec 0c             	sub    $0xc,%esp
  8016d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d7:	50                   	push   %eax
  8016d8:	e8 6b f8 ff ff       	call   800f48 <fd_alloc>
  8016dd:	89 c3                	mov    %eax,%ebx
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	78 3c                	js     801722 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	56                   	push   %esi
  8016ea:	68 00 50 80 00       	push   $0x805000
  8016ef:	e8 57 f1 ff ff       	call   80084b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801704:	e8 a6 fd ff ff       	call   8014af <fsipc>
  801709:	89 c3                	mov    %eax,%ebx
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	85 c0                	test   %eax,%eax
  801710:	78 19                	js     80172b <open+0x75>
	return fd2num(fd);
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	ff 75 f4             	pushl  -0xc(%ebp)
  801718:	e8 04 f8 ff ff       	call   800f21 <fd2num>
  80171d:	89 c3                	mov    %eax,%ebx
  80171f:	83 c4 10             	add    $0x10,%esp
}
  801722:	89 d8                	mov    %ebx,%eax
  801724:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801727:	5b                   	pop    %ebx
  801728:	5e                   	pop    %esi
  801729:	5d                   	pop    %ebp
  80172a:	c3                   	ret    
		fd_close(fd, 0);
  80172b:	83 ec 08             	sub    $0x8,%esp
  80172e:	6a 00                	push   $0x0
  801730:	ff 75 f4             	pushl  -0xc(%ebp)
  801733:	e8 0c f9 ff ff       	call   801044 <fd_close>
		return r;
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	eb e5                	jmp    801722 <open+0x6c>
		return -E_BAD_PATH;
  80173d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801742:	eb de                	jmp    801722 <open+0x6c>

00801744 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	b8 08 00 00 00       	mov    $0x8,%eax
  801754:	e8 56 fd ff ff       	call   8014af <fsipc>
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	56                   	push   %esi
  80175f:	53                   	push   %ebx
  801760:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	e8 c3 f7 ff ff       	call   800f31 <fd2data>
  80176e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801770:	83 c4 08             	add    $0x8,%esp
  801773:	68 8b 24 80 00       	push   $0x80248b
  801778:	53                   	push   %ebx
  801779:	e8 cd f0 ff ff       	call   80084b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80177e:	8b 46 04             	mov    0x4(%esi),%eax
  801781:	2b 06                	sub    (%esi),%eax
  801783:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801789:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801790:	10 00 00 
	stat->st_dev = &devpipe;
  801793:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80179a:	30 80 00 
	return 0;
}
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a5:	5b                   	pop    %ebx
  8017a6:	5e                   	pop    %esi
  8017a7:	5d                   	pop    %ebp
  8017a8:	c3                   	ret    

008017a9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017b3:	53                   	push   %ebx
  8017b4:	6a 00                	push   $0x0
  8017b6:	e8 ca f4 ff ff       	call   800c85 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017bb:	89 1c 24             	mov    %ebx,(%esp)
  8017be:	e8 6e f7 ff ff       	call   800f31 <fd2data>
  8017c3:	83 c4 08             	add    $0x8,%esp
  8017c6:	50                   	push   %eax
  8017c7:	6a 00                	push   $0x0
  8017c9:	e8 b7 f4 ff ff       	call   800c85 <sys_page_unmap>
}
  8017ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <_pipeisclosed>:
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	57                   	push   %edi
  8017d7:	56                   	push   %esi
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 1c             	sub    $0x1c,%esp
  8017dc:	89 c7                	mov    %eax,%edi
  8017de:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017e0:	a1 04 40 80 00       	mov    0x804004,%eax
  8017e5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017e8:	83 ec 0c             	sub    $0xc,%esp
  8017eb:	57                   	push   %edi
  8017ec:	e8 62 05 00 00       	call   801d53 <pageref>
  8017f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017f4:	89 34 24             	mov    %esi,(%esp)
  8017f7:	e8 57 05 00 00       	call   801d53 <pageref>
		nn = thisenv->env_runs;
  8017fc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801802:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	39 cb                	cmp    %ecx,%ebx
  80180a:	74 1b                	je     801827 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80180c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80180f:	75 cf                	jne    8017e0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801811:	8b 42 58             	mov    0x58(%edx),%eax
  801814:	6a 01                	push   $0x1
  801816:	50                   	push   %eax
  801817:	53                   	push   %ebx
  801818:	68 92 24 80 00       	push   $0x802492
  80181d:	e8 21 ea ff ff       	call   800243 <cprintf>
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	eb b9                	jmp    8017e0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801827:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80182a:	0f 94 c0             	sete   %al
  80182d:	0f b6 c0             	movzbl %al,%eax
}
  801830:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801833:	5b                   	pop    %ebx
  801834:	5e                   	pop    %esi
  801835:	5f                   	pop    %edi
  801836:	5d                   	pop    %ebp
  801837:	c3                   	ret    

00801838 <devpipe_write>:
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	57                   	push   %edi
  80183c:	56                   	push   %esi
  80183d:	53                   	push   %ebx
  80183e:	83 ec 18             	sub    $0x18,%esp
  801841:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801844:	56                   	push   %esi
  801845:	e8 e7 f6 ff ff       	call   800f31 <fd2data>
  80184a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	bf 00 00 00 00       	mov    $0x0,%edi
  801854:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801857:	74 41                	je     80189a <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801859:	8b 53 04             	mov    0x4(%ebx),%edx
  80185c:	8b 03                	mov    (%ebx),%eax
  80185e:	83 c0 20             	add    $0x20,%eax
  801861:	39 c2                	cmp    %eax,%edx
  801863:	72 14                	jb     801879 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801865:	89 da                	mov    %ebx,%edx
  801867:	89 f0                	mov    %esi,%eax
  801869:	e8 65 ff ff ff       	call   8017d3 <_pipeisclosed>
  80186e:	85 c0                	test   %eax,%eax
  801870:	75 2c                	jne    80189e <devpipe_write+0x66>
			sys_yield();
  801872:	e8 50 f4 ff ff       	call   800cc7 <sys_yield>
  801877:	eb e0                	jmp    801859 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187c:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  80187f:	89 d0                	mov    %edx,%eax
  801881:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801886:	78 0b                	js     801893 <devpipe_write+0x5b>
  801888:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  80188c:	42                   	inc    %edx
  80188d:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801890:	47                   	inc    %edi
  801891:	eb c1                	jmp    801854 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801893:	48                   	dec    %eax
  801894:	83 c8 e0             	or     $0xffffffe0,%eax
  801897:	40                   	inc    %eax
  801898:	eb ee                	jmp    801888 <devpipe_write+0x50>
	return i;
  80189a:	89 f8                	mov    %edi,%eax
  80189c:	eb 05                	jmp    8018a3 <devpipe_write+0x6b>
				return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5f                   	pop    %edi
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    

008018ab <devpipe_read>:
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	57                   	push   %edi
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 18             	sub    $0x18,%esp
  8018b4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018b7:	57                   	push   %edi
  8018b8:	e8 74 f6 ff ff       	call   800f31 <fd2data>
  8018bd:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c7:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8018ca:	74 46                	je     801912 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  8018cc:	8b 06                	mov    (%esi),%eax
  8018ce:	3b 46 04             	cmp    0x4(%esi),%eax
  8018d1:	75 22                	jne    8018f5 <devpipe_read+0x4a>
			if (i > 0)
  8018d3:	85 db                	test   %ebx,%ebx
  8018d5:	74 0a                	je     8018e1 <devpipe_read+0x36>
				return i;
  8018d7:	89 d8                	mov    %ebx,%eax
}
  8018d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018dc:	5b                   	pop    %ebx
  8018dd:	5e                   	pop    %esi
  8018de:	5f                   	pop    %edi
  8018df:	5d                   	pop    %ebp
  8018e0:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  8018e1:	89 f2                	mov    %esi,%edx
  8018e3:	89 f8                	mov    %edi,%eax
  8018e5:	e8 e9 fe ff ff       	call   8017d3 <_pipeisclosed>
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	75 28                	jne    801916 <devpipe_read+0x6b>
			sys_yield();
  8018ee:	e8 d4 f3 ff ff       	call   800cc7 <sys_yield>
  8018f3:	eb d7                	jmp    8018cc <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018f5:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8018fa:	78 0f                	js     80190b <devpipe_read+0x60>
  8018fc:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801900:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801903:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801906:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801908:	43                   	inc    %ebx
  801909:	eb bc                	jmp    8018c7 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80190b:	48                   	dec    %eax
  80190c:	83 c8 e0             	or     $0xffffffe0,%eax
  80190f:	40                   	inc    %eax
  801910:	eb ea                	jmp    8018fc <devpipe_read+0x51>
	return i;
  801912:	89 d8                	mov    %ebx,%eax
  801914:	eb c3                	jmp    8018d9 <devpipe_read+0x2e>
				return 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	eb bc                	jmp    8018d9 <devpipe_read+0x2e>

0080191d <pipe>:
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
  801922:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801925:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801928:	50                   	push   %eax
  801929:	e8 1a f6 ff ff       	call   800f48 <fd_alloc>
  80192e:	89 c3                	mov    %eax,%ebx
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	85 c0                	test   %eax,%eax
  801935:	0f 88 2a 01 00 00    	js     801a65 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 07 04 00 00       	push   $0x407
  801943:	ff 75 f4             	pushl  -0xc(%ebp)
  801946:	6a 00                	push   $0x0
  801948:	e8 b3 f2 ff ff       	call   800c00 <sys_page_alloc>
  80194d:	89 c3                	mov    %eax,%ebx
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	85 c0                	test   %eax,%eax
  801954:	0f 88 0b 01 00 00    	js     801a65 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  80195a:	83 ec 0c             	sub    $0xc,%esp
  80195d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801960:	50                   	push   %eax
  801961:	e8 e2 f5 ff ff       	call   800f48 <fd_alloc>
  801966:	89 c3                	mov    %eax,%ebx
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	0f 88 e2 00 00 00    	js     801a55 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	68 07 04 00 00       	push   $0x407
  80197b:	ff 75 f0             	pushl  -0x10(%ebp)
  80197e:	6a 00                	push   $0x0
  801980:	e8 7b f2 ff ff       	call   800c00 <sys_page_alloc>
  801985:	89 c3                	mov    %eax,%ebx
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	85 c0                	test   %eax,%eax
  80198c:	0f 88 c3 00 00 00    	js     801a55 <pipe+0x138>
	va = fd2data(fd0);
  801992:	83 ec 0c             	sub    $0xc,%esp
  801995:	ff 75 f4             	pushl  -0xc(%ebp)
  801998:	e8 94 f5 ff ff       	call   800f31 <fd2data>
  80199d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80199f:	83 c4 0c             	add    $0xc,%esp
  8019a2:	68 07 04 00 00       	push   $0x407
  8019a7:	50                   	push   %eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	e8 51 f2 ff ff       	call   800c00 <sys_page_alloc>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	0f 88 89 00 00 00    	js     801a45 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c2:	e8 6a f5 ff ff       	call   800f31 <fd2data>
  8019c7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019ce:	50                   	push   %eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	56                   	push   %esi
  8019d2:	6a 00                	push   $0x0
  8019d4:	e8 6a f2 ff ff       	call   800c43 <sys_page_map>
  8019d9:	89 c3                	mov    %eax,%ebx
  8019db:	83 c4 20             	add    $0x20,%esp
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 55                	js     801a37 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  8019e2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8019ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8019f7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a00:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a05:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a0c:	83 ec 0c             	sub    $0xc,%esp
  801a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a12:	e8 0a f5 ff ff       	call   800f21 <fd2num>
  801a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a1c:	83 c4 04             	add    $0x4,%esp
  801a1f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a22:	e8 fa f4 ff ff       	call   800f21 <fd2num>
  801a27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a35:	eb 2e                	jmp    801a65 <pipe+0x148>
	sys_page_unmap(0, va);
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	56                   	push   %esi
  801a3b:	6a 00                	push   $0x0
  801a3d:	e8 43 f2 ff ff       	call   800c85 <sys_page_unmap>
  801a42:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a45:	83 ec 08             	sub    $0x8,%esp
  801a48:	ff 75 f0             	pushl  -0x10(%ebp)
  801a4b:	6a 00                	push   $0x0
  801a4d:	e8 33 f2 ff ff       	call   800c85 <sys_page_unmap>
  801a52:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a55:	83 ec 08             	sub    $0x8,%esp
  801a58:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5b:	6a 00                	push   $0x0
  801a5d:	e8 23 f2 ff ff       	call   800c85 <sys_page_unmap>
  801a62:	83 c4 10             	add    $0x10,%esp
}
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5e                   	pop    %esi
  801a6c:	5d                   	pop    %ebp
  801a6d:	c3                   	ret    

00801a6e <pipeisclosed>:
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a77:	50                   	push   %eax
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	e8 17 f5 ff ff       	call   800f97 <fd_lookup>
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	85 c0                	test   %eax,%eax
  801a85:	78 18                	js     801a9f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a87:	83 ec 0c             	sub    $0xc,%esp
  801a8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8d:	e8 9f f4 ff ff       	call   800f31 <fd2data>
	return _pipeisclosed(fd, p);
  801a92:	89 c2                	mov    %eax,%edx
  801a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a97:	e8 37 fd ff ff       	call   8017d3 <_pipeisclosed>
  801a9c:	83 c4 10             	add    $0x10,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    

00801aab <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	53                   	push   %ebx
  801aaf:	83 ec 0c             	sub    $0xc,%esp
  801ab2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801ab5:	68 aa 24 80 00       	push   $0x8024aa
  801aba:	53                   	push   %ebx
  801abb:	e8 8b ed ff ff       	call   80084b <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801ac0:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801ac7:	20 00 00 
	return 0;
}
  801aca:	b8 00 00 00 00       	mov    $0x0,%eax
  801acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <devcons_write>:
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	57                   	push   %edi
  801ad8:	56                   	push   %esi
  801ad9:	53                   	push   %ebx
  801ada:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ae0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ae5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801aeb:	eb 1d                	jmp    801b0a <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	53                   	push   %ebx
  801af1:	03 45 0c             	add    0xc(%ebp),%eax
  801af4:	50                   	push   %eax
  801af5:	57                   	push   %edi
  801af6:	e8 c3 ee ff ff       	call   8009be <memmove>
		sys_cputs(buf, m);
  801afb:	83 c4 08             	add    $0x8,%esp
  801afe:	53                   	push   %ebx
  801aff:	57                   	push   %edi
  801b00:	e8 5e f0 ff ff       	call   800b63 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b05:	01 de                	add    %ebx,%esi
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	89 f0                	mov    %esi,%eax
  801b0c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b0f:	73 11                	jae    801b22 <devcons_write+0x4e>
		m = n - tot;
  801b11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b14:	29 f3                	sub    %esi,%ebx
  801b16:	83 fb 7f             	cmp    $0x7f,%ebx
  801b19:	76 d2                	jbe    801aed <devcons_write+0x19>
  801b1b:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801b20:	eb cb                	jmp    801aed <devcons_write+0x19>
}
  801b22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b25:	5b                   	pop    %ebx
  801b26:	5e                   	pop    %esi
  801b27:	5f                   	pop    %edi
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    

00801b2a <devcons_read>:
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801b30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b34:	75 0c                	jne    801b42 <devcons_read+0x18>
		return 0;
  801b36:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3b:	eb 21                	jmp    801b5e <devcons_read+0x34>
		sys_yield();
  801b3d:	e8 85 f1 ff ff       	call   800cc7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801b42:	e8 3a f0 ff ff       	call   800b81 <sys_cgetc>
  801b47:	85 c0                	test   %eax,%eax
  801b49:	74 f2                	je     801b3d <devcons_read+0x13>
	if (c < 0)
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 0f                	js     801b5e <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801b4f:	83 f8 04             	cmp    $0x4,%eax
  801b52:	74 0c                	je     801b60 <devcons_read+0x36>
	*(char*)vbuf = c;
  801b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b57:	88 02                	mov    %al,(%edx)
	return 1;
  801b59:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    
		return 0;
  801b60:	b8 00 00 00 00       	mov    $0x0,%eax
  801b65:	eb f7                	jmp    801b5e <devcons_read+0x34>

00801b67 <cputchar>:
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b73:	6a 01                	push   $0x1
  801b75:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b78:	50                   	push   %eax
  801b79:	e8 e5 ef ff ff       	call   800b63 <sys_cputs>
}
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <getchar>:
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b89:	6a 01                	push   $0x1
  801b8b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b8e:	50                   	push   %eax
  801b8f:	6a 00                	push   $0x0
  801b91:	e8 6e f6 ff ff       	call   801204 <read>
	if (r < 0)
  801b96:	83 c4 10             	add    $0x10,%esp
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 08                	js     801ba5 <getchar+0x22>
	if (r < 1)
  801b9d:	85 c0                	test   %eax,%eax
  801b9f:	7e 06                	jle    801ba7 <getchar+0x24>
	return c;
  801ba1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    
		return -E_EOF;
  801ba7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801bac:	eb f7                	jmp    801ba5 <getchar+0x22>

00801bae <iscons>:
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb7:	50                   	push   %eax
  801bb8:	ff 75 08             	pushl  0x8(%ebp)
  801bbb:	e8 d7 f3 ff ff       	call   800f97 <fd_lookup>
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 11                	js     801bd8 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bca:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bd0:	39 10                	cmp    %edx,(%eax)
  801bd2:	0f 94 c0             	sete   %al
  801bd5:	0f b6 c0             	movzbl %al,%eax
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <opencons>:
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801be0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be3:	50                   	push   %eax
  801be4:	e8 5f f3 ff ff       	call   800f48 <fd_alloc>
  801be9:	83 c4 10             	add    $0x10,%esp
  801bec:	85 c0                	test   %eax,%eax
  801bee:	78 3a                	js     801c2a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	68 07 04 00 00       	push   $0x407
  801bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfb:	6a 00                	push   $0x0
  801bfd:	e8 fe ef ff ff       	call   800c00 <sys_page_alloc>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	85 c0                	test   %eax,%eax
  801c07:	78 21                	js     801c2a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801c09:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c17:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	50                   	push   %eax
  801c22:	e8 fa f2 ff ff       	call   800f21 <fd2num>
  801c27:	83 c4 10             	add    $0x10,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	57                   	push   %edi
  801c30:	56                   	push   %esi
  801c31:	53                   	push   %ebx
  801c32:	83 ec 0c             	sub    $0xc,%esp
  801c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c38:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c3b:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801c3e:	85 ff                	test   %edi,%edi
  801c40:	74 53                	je     801c95 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801c42:	83 ec 0c             	sub    $0xc,%esp
  801c45:	57                   	push   %edi
  801c46:	e8 c5 f1 ff ff       	call   800e10 <sys_ipc_recv>
  801c4b:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801c4e:	85 db                	test   %ebx,%ebx
  801c50:	74 0b                	je     801c5d <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801c52:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c58:	8b 52 74             	mov    0x74(%edx),%edx
  801c5b:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801c5d:	85 f6                	test   %esi,%esi
  801c5f:	74 0f                	je     801c70 <ipc_recv+0x44>
  801c61:	85 ff                	test   %edi,%edi
  801c63:	74 0b                	je     801c70 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801c65:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c6b:	8b 52 78             	mov    0x78(%edx),%edx
  801c6e:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801c70:	85 c0                	test   %eax,%eax
  801c72:	74 30                	je     801ca4 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801c74:	85 db                	test   %ebx,%ebx
  801c76:	74 06                	je     801c7e <ipc_recv+0x52>
      		*from_env_store = 0;
  801c78:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801c7e:	85 f6                	test   %esi,%esi
  801c80:	74 2c                	je     801cae <ipc_recv+0x82>
      		*perm_store = 0;
  801c82:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c90:	5b                   	pop    %ebx
  801c91:	5e                   	pop    %esi
  801c92:	5f                   	pop    %edi
  801c93:	5d                   	pop    %ebp
  801c94:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801c95:	83 ec 0c             	sub    $0xc,%esp
  801c98:	6a ff                	push   $0xffffffff
  801c9a:	e8 71 f1 ff ff       	call   800e10 <sys_ipc_recv>
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	eb aa                	jmp    801c4e <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801ca4:	a1 04 40 80 00       	mov    0x804004,%eax
  801ca9:	8b 40 70             	mov    0x70(%eax),%eax
  801cac:	eb df                	jmp    801c8d <ipc_recv+0x61>
		return -1;
  801cae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801cb3:	eb d8                	jmp    801c8d <ipc_recv+0x61>

00801cb5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	57                   	push   %edi
  801cb9:	56                   	push   %esi
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 0c             	sub    $0xc,%esp
  801cbe:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cc4:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801cc7:	85 db                	test   %ebx,%ebx
  801cc9:	75 22                	jne    801ced <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801ccb:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801cd0:	eb 1b                	jmp    801ced <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801cd2:	68 b8 24 80 00       	push   $0x8024b8
  801cd7:	68 5f 24 80 00       	push   $0x80245f
  801cdc:	6a 48                	push   $0x48
  801cde:	68 dc 24 80 00       	push   $0x8024dc
  801ce3:	e8 48 e4 ff ff       	call   800130 <_panic>
		sys_yield();
  801ce8:	e8 da ef ff ff       	call   800cc7 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801ced:	57                   	push   %edi
  801cee:	53                   	push   %ebx
  801cef:	56                   	push   %esi
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	e8 f5 f0 ff ff       	call   800ded <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801cfe:	74 e8                	je     801ce8 <ipc_send+0x33>
  801d00:	85 c0                	test   %eax,%eax
  801d02:	75 ce                	jne    801cd2 <ipc_send+0x1d>
		sys_yield();
  801d04:	e8 be ef ff ff       	call   800cc7 <sys_yield>
		
	}
	
}
  801d09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5e                   	pop    %esi
  801d0e:	5f                   	pop    %edi
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    

00801d11 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d1c:	89 c2                	mov    %eax,%edx
  801d1e:	c1 e2 05             	shl    $0x5,%edx
  801d21:	29 c2                	sub    %eax,%edx
  801d23:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801d2a:	8b 52 50             	mov    0x50(%edx),%edx
  801d2d:	39 ca                	cmp    %ecx,%edx
  801d2f:	74 0f                	je     801d40 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801d31:	40                   	inc    %eax
  801d32:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d37:	75 e3                	jne    801d1c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3e:	eb 11                	jmp    801d51 <ipc_find_env+0x40>
			return envs[i].env_id;
  801d40:	89 c2                	mov    %eax,%edx
  801d42:	c1 e2 05             	shl    $0x5,%edx
  801d45:	29 c2                	sub    %eax,%edx
  801d47:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801d4e:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    

00801d53 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	c1 e8 16             	shr    $0x16,%eax
  801d5c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d63:	a8 01                	test   $0x1,%al
  801d65:	74 21                	je     801d88 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	c1 e8 0c             	shr    $0xc,%eax
  801d6d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d74:	a8 01                	test   $0x1,%al
  801d76:	74 17                	je     801d8f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d78:	c1 e8 0c             	shr    $0xc,%eax
  801d7b:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801d82:	ef 
  801d83:	0f b7 c0             	movzwl %ax,%eax
  801d86:	eb 05                	jmp    801d8d <pageref+0x3a>
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	5d                   	pop    %ebp
  801d8e:	c3                   	ret    
		return 0;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d94:	eb f7                	jmp    801d8d <pageref+0x3a>
  801d96:	66 90                	xchg   %ax,%ax

00801d98 <__udivdi3>:
  801d98:	55                   	push   %ebp
  801d99:	57                   	push   %edi
  801d9a:	56                   	push   %esi
  801d9b:	53                   	push   %ebx
  801d9c:	83 ec 1c             	sub    $0x1c,%esp
  801d9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801da3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801da7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801daf:	89 ca                	mov    %ecx,%edx
  801db1:	89 f8                	mov    %edi,%eax
  801db3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801db7:	85 f6                	test   %esi,%esi
  801db9:	75 2d                	jne    801de8 <__udivdi3+0x50>
  801dbb:	39 cf                	cmp    %ecx,%edi
  801dbd:	77 65                	ja     801e24 <__udivdi3+0x8c>
  801dbf:	89 fd                	mov    %edi,%ebp
  801dc1:	85 ff                	test   %edi,%edi
  801dc3:	75 0b                	jne    801dd0 <__udivdi3+0x38>
  801dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dca:	31 d2                	xor    %edx,%edx
  801dcc:	f7 f7                	div    %edi
  801dce:	89 c5                	mov    %eax,%ebp
  801dd0:	31 d2                	xor    %edx,%edx
  801dd2:	89 c8                	mov    %ecx,%eax
  801dd4:	f7 f5                	div    %ebp
  801dd6:	89 c1                	mov    %eax,%ecx
  801dd8:	89 d8                	mov    %ebx,%eax
  801dda:	f7 f5                	div    %ebp
  801ddc:	89 cf                	mov    %ecx,%edi
  801dde:	89 fa                	mov    %edi,%edx
  801de0:	83 c4 1c             	add    $0x1c,%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5f                   	pop    %edi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    
  801de8:	39 ce                	cmp    %ecx,%esi
  801dea:	77 28                	ja     801e14 <__udivdi3+0x7c>
  801dec:	0f bd fe             	bsr    %esi,%edi
  801def:	83 f7 1f             	xor    $0x1f,%edi
  801df2:	75 40                	jne    801e34 <__udivdi3+0x9c>
  801df4:	39 ce                	cmp    %ecx,%esi
  801df6:	72 0a                	jb     801e02 <__udivdi3+0x6a>
  801df8:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801dfc:	0f 87 9e 00 00 00    	ja     801ea0 <__udivdi3+0x108>
  801e02:	b8 01 00 00 00       	mov    $0x1,%eax
  801e07:	89 fa                	mov    %edi,%edx
  801e09:	83 c4 1c             	add    $0x1c,%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5f                   	pop    %edi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    
  801e11:	8d 76 00             	lea    0x0(%esi),%esi
  801e14:	31 ff                	xor    %edi,%edi
  801e16:	31 c0                	xor    %eax,%eax
  801e18:	89 fa                	mov    %edi,%edx
  801e1a:	83 c4 1c             	add    $0x1c,%esp
  801e1d:	5b                   	pop    %ebx
  801e1e:	5e                   	pop    %esi
  801e1f:	5f                   	pop    %edi
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	89 d8                	mov    %ebx,%eax
  801e26:	f7 f7                	div    %edi
  801e28:	31 ff                	xor    %edi,%edi
  801e2a:	89 fa                	mov    %edi,%edx
  801e2c:	83 c4 1c             	add    $0x1c,%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    
  801e34:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e39:	29 fd                	sub    %edi,%ebp
  801e3b:	89 f9                	mov    %edi,%ecx
  801e3d:	d3 e6                	shl    %cl,%esi
  801e3f:	89 c3                	mov    %eax,%ebx
  801e41:	89 e9                	mov    %ebp,%ecx
  801e43:	d3 eb                	shr    %cl,%ebx
  801e45:	89 d9                	mov    %ebx,%ecx
  801e47:	09 f1                	or     %esi,%ecx
  801e49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e4d:	89 f9                	mov    %edi,%ecx
  801e4f:	d3 e0                	shl    %cl,%eax
  801e51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e55:	89 d6                	mov    %edx,%esi
  801e57:	89 e9                	mov    %ebp,%ecx
  801e59:	d3 ee                	shr    %cl,%esi
  801e5b:	89 f9                	mov    %edi,%ecx
  801e5d:	d3 e2                	shl    %cl,%edx
  801e5f:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e63:	89 e9                	mov    %ebp,%ecx
  801e65:	d3 eb                	shr    %cl,%ebx
  801e67:	09 da                	or     %ebx,%edx
  801e69:	89 d0                	mov    %edx,%eax
  801e6b:	89 f2                	mov    %esi,%edx
  801e6d:	f7 74 24 08          	divl   0x8(%esp)
  801e71:	89 d6                	mov    %edx,%esi
  801e73:	89 c3                	mov    %eax,%ebx
  801e75:	f7 64 24 0c          	mull   0xc(%esp)
  801e79:	39 d6                	cmp    %edx,%esi
  801e7b:	72 17                	jb     801e94 <__udivdi3+0xfc>
  801e7d:	74 09                	je     801e88 <__udivdi3+0xf0>
  801e7f:	89 d8                	mov    %ebx,%eax
  801e81:	31 ff                	xor    %edi,%edi
  801e83:	e9 56 ff ff ff       	jmp    801dde <__udivdi3+0x46>
  801e88:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e8c:	89 f9                	mov    %edi,%ecx
  801e8e:	d3 e2                	shl    %cl,%edx
  801e90:	39 c2                	cmp    %eax,%edx
  801e92:	73 eb                	jae    801e7f <__udivdi3+0xe7>
  801e94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e97:	31 ff                	xor    %edi,%edi
  801e99:	e9 40 ff ff ff       	jmp    801dde <__udivdi3+0x46>
  801e9e:	66 90                	xchg   %ax,%ax
  801ea0:	31 c0                	xor    %eax,%eax
  801ea2:	e9 37 ff ff ff       	jmp    801dde <__udivdi3+0x46>
  801ea7:	90                   	nop

00801ea8 <__umoddi3>:
  801ea8:	55                   	push   %ebp
  801ea9:	57                   	push   %edi
  801eaa:	56                   	push   %esi
  801eab:	53                   	push   %ebx
  801eac:	83 ec 1c             	sub    $0x1c,%esp
  801eaf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801eb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ebb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ebf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ec3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ec7:	89 3c 24             	mov    %edi,(%esp)
  801eca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ece:	89 f2                	mov    %esi,%edx
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	75 18                	jne    801eec <__umoddi3+0x44>
  801ed4:	39 f7                	cmp    %esi,%edi
  801ed6:	0f 86 a0 00 00 00    	jbe    801f7c <__umoddi3+0xd4>
  801edc:	89 c8                	mov    %ecx,%eax
  801ede:	f7 f7                	div    %edi
  801ee0:	89 d0                	mov    %edx,%eax
  801ee2:	31 d2                	xor    %edx,%edx
  801ee4:	83 c4 1c             	add    $0x1c,%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    
  801eec:	89 f3                	mov    %esi,%ebx
  801eee:	39 f0                	cmp    %esi,%eax
  801ef0:	0f 87 a6 00 00 00    	ja     801f9c <__umoddi3+0xf4>
  801ef6:	0f bd e8             	bsr    %eax,%ebp
  801ef9:	83 f5 1f             	xor    $0x1f,%ebp
  801efc:	0f 84 a6 00 00 00    	je     801fa8 <__umoddi3+0x100>
  801f02:	bf 20 00 00 00       	mov    $0x20,%edi
  801f07:	29 ef                	sub    %ebp,%edi
  801f09:	89 e9                	mov    %ebp,%ecx
  801f0b:	d3 e0                	shl    %cl,%eax
  801f0d:	8b 34 24             	mov    (%esp),%esi
  801f10:	89 f2                	mov    %esi,%edx
  801f12:	89 f9                	mov    %edi,%ecx
  801f14:	d3 ea                	shr    %cl,%edx
  801f16:	09 c2                	or     %eax,%edx
  801f18:	89 14 24             	mov    %edx,(%esp)
  801f1b:	89 f2                	mov    %esi,%edx
  801f1d:	89 e9                	mov    %ebp,%ecx
  801f1f:	d3 e2                	shl    %cl,%edx
  801f21:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f25:	89 de                	mov    %ebx,%esi
  801f27:	89 f9                	mov    %edi,%ecx
  801f29:	d3 ee                	shr    %cl,%esi
  801f2b:	89 e9                	mov    %ebp,%ecx
  801f2d:	d3 e3                	shl    %cl,%ebx
  801f2f:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f33:	89 d0                	mov    %edx,%eax
  801f35:	89 f9                	mov    %edi,%ecx
  801f37:	d3 e8                	shr    %cl,%eax
  801f39:	09 d8                	or     %ebx,%eax
  801f3b:	89 d3                	mov    %edx,%ebx
  801f3d:	89 e9                	mov    %ebp,%ecx
  801f3f:	d3 e3                	shl    %cl,%ebx
  801f41:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f45:	89 f2                	mov    %esi,%edx
  801f47:	f7 34 24             	divl   (%esp)
  801f4a:	89 d6                	mov    %edx,%esi
  801f4c:	f7 64 24 04          	mull   0x4(%esp)
  801f50:	89 c3                	mov    %eax,%ebx
  801f52:	89 d1                	mov    %edx,%ecx
  801f54:	39 d6                	cmp    %edx,%esi
  801f56:	72 7c                	jb     801fd4 <__umoddi3+0x12c>
  801f58:	74 72                	je     801fcc <__umoddi3+0x124>
  801f5a:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f5e:	29 da                	sub    %ebx,%edx
  801f60:	19 ce                	sbb    %ecx,%esi
  801f62:	89 f0                	mov    %esi,%eax
  801f64:	89 f9                	mov    %edi,%ecx
  801f66:	d3 e0                	shl    %cl,%eax
  801f68:	89 e9                	mov    %ebp,%ecx
  801f6a:	d3 ea                	shr    %cl,%edx
  801f6c:	09 d0                	or     %edx,%eax
  801f6e:	89 e9                	mov    %ebp,%ecx
  801f70:	d3 ee                	shr    %cl,%esi
  801f72:	89 f2                	mov    %esi,%edx
  801f74:	83 c4 1c             	add    $0x1c,%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5f                   	pop    %edi
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    
  801f7c:	89 fd                	mov    %edi,%ebp
  801f7e:	85 ff                	test   %edi,%edi
  801f80:	75 0b                	jne    801f8d <__umoddi3+0xe5>
  801f82:	b8 01 00 00 00       	mov    $0x1,%eax
  801f87:	31 d2                	xor    %edx,%edx
  801f89:	f7 f7                	div    %edi
  801f8b:	89 c5                	mov    %eax,%ebp
  801f8d:	89 f0                	mov    %esi,%eax
  801f8f:	31 d2                	xor    %edx,%edx
  801f91:	f7 f5                	div    %ebp
  801f93:	89 c8                	mov    %ecx,%eax
  801f95:	f7 f5                	div    %ebp
  801f97:	e9 44 ff ff ff       	jmp    801ee0 <__umoddi3+0x38>
  801f9c:	89 c8                	mov    %ecx,%eax
  801f9e:	89 f2                	mov    %esi,%edx
  801fa0:	83 c4 1c             	add    $0x1c,%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5f                   	pop    %edi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    
  801fa8:	39 f0                	cmp    %esi,%eax
  801faa:	72 05                	jb     801fb1 <__umoddi3+0x109>
  801fac:	39 0c 24             	cmp    %ecx,(%esp)
  801faf:	77 0c                	ja     801fbd <__umoddi3+0x115>
  801fb1:	89 f2                	mov    %esi,%edx
  801fb3:	29 f9                	sub    %edi,%ecx
  801fb5:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fb9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fbd:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fc1:	83 c4 1c             	add    $0x1c,%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5f                   	pop    %edi
  801fc7:	5d                   	pop    %ebp
  801fc8:	c3                   	ret    
  801fc9:	8d 76 00             	lea    0x0(%esi),%esi
  801fcc:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801fd0:	73 88                	jae    801f5a <__umoddi3+0xb2>
  801fd2:	66 90                	xchg   %ax,%ax
  801fd4:	2b 44 24 04          	sub    0x4(%esp),%eax
  801fd8:	1b 14 24             	sbb    (%esp),%edx
  801fdb:	89 d1                	mov    %edx,%ecx
  801fdd:	89 c3                	mov    %eax,%ebx
  801fdf:	e9 76 ff ff ff       	jmp    801f5a <__umoddi3+0xb2>
