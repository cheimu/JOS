
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 04 40 80 00       	mov    0x804004,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 20 25 80 00       	push   $0x802520
  800047:	e8 a8 01 00 00       	call   8001f4 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 3e 25 80 00       	push   $0x80253e
  800056:	68 3e 25 80 00       	push   $0x80253e
  80005b:	e8 b0 1b 00 00       	call   801c10 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(hello) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(hello) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 44 25 80 00       	push   $0x802544
  80006f:	6a 09                	push   $0x9
  800071:	68 5c 25 80 00       	push   $0x80255c
  800076:	e8 66 00 00 00       	call   8000e1 <_panic>

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	e8 07 0b 00 00       	call   800b92 <sys_getenvid>
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	89 c2                	mov    %eax,%edx
  800092:	c1 e2 05             	shl    $0x5,%edx
  800095:	29 c2                	sub    %eax,%edx
  800097:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80009e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a3:	85 db                	test   %ebx,%ebx
  8000a5:	7e 07                	jle    8000ae <libmain+0x33>
		binaryname = argv[0];
  8000a7:	8b 06                	mov    (%esi),%eax
  8000a9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	56                   	push   %esi
  8000b2:	53                   	push   %ebx
  8000b3:	e8 7b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b8:	e8 0a 00 00 00       	call   8000c7 <exit>
}
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c3:	5b                   	pop    %ebx
  8000c4:	5e                   	pop    %esi
  8000c5:	5d                   	pop    %ebp
  8000c6:	c3                   	ret    

008000c7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000cd:	e8 68 0f 00 00       	call   80103a <close_all>
	sys_env_destroy(0);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 75 0a 00 00       	call   800b51 <sys_env_destroy>
}
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	57                   	push   %edi
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  8000ed:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  8000f0:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8000f6:	e8 97 0a 00 00       	call   800b92 <sys_getenvid>
  8000fb:	83 ec 04             	sub    $0x4,%esp
  8000fe:	ff 75 0c             	pushl  0xc(%ebp)
  800101:	ff 75 08             	pushl  0x8(%ebp)
  800104:	53                   	push   %ebx
  800105:	50                   	push   %eax
  800106:	68 78 25 80 00       	push   $0x802578
  80010b:	68 00 01 00 00       	push   $0x100
  800110:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800116:	56                   	push   %esi
  800117:	e8 93 06 00 00       	call   8007af <snprintf>
  80011c:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80011e:	83 c4 20             	add    $0x20,%esp
  800121:	57                   	push   %edi
  800122:	ff 75 10             	pushl  0x10(%ebp)
  800125:	bf 00 01 00 00       	mov    $0x100,%edi
  80012a:	89 f8                	mov    %edi,%eax
  80012c:	29 d8                	sub    %ebx,%eax
  80012e:	50                   	push   %eax
  80012f:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800132:	50                   	push   %eax
  800133:	e8 22 06 00 00       	call   80075a <vsnprintf>
  800138:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80013a:	83 c4 0c             	add    $0xc,%esp
  80013d:	68 56 2a 80 00       	push   $0x802a56
  800142:	29 df                	sub    %ebx,%edi
  800144:	57                   	push   %edi
  800145:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800148:	50                   	push   %eax
  800149:	e8 61 06 00 00       	call   8007af <snprintf>
	sys_cputs(buf, r);
  80014e:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800151:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800153:	53                   	push   %ebx
  800154:	56                   	push   %esi
  800155:	e8 ba 09 00 00       	call   800b14 <sys_cputs>
  80015a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80015d:	cc                   	int3   
  80015e:	eb fd                	jmp    80015d <_panic+0x7c>

00800160 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	53                   	push   %ebx
  800164:	83 ec 04             	sub    $0x4,%esp
  800167:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016a:	8b 13                	mov    (%ebx),%edx
  80016c:	8d 42 01             	lea    0x1(%edx),%eax
  80016f:	89 03                	mov    %eax,(%ebx)
  800171:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800174:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800178:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017d:	74 08                	je     800187 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017f:	ff 43 04             	incl   0x4(%ebx)
}
  800182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800185:	c9                   	leave  
  800186:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800187:	83 ec 08             	sub    $0x8,%esp
  80018a:	68 ff 00 00 00       	push   $0xff
  80018f:	8d 43 08             	lea    0x8(%ebx),%eax
  800192:	50                   	push   %eax
  800193:	e8 7c 09 00 00       	call   800b14 <sys_cputs>
		b->idx = 0;
  800198:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019e:	83 c4 10             	add    $0x10,%esp
  8001a1:	eb dc                	jmp    80017f <putch+0x1f>

008001a3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b3:	00 00 00 
	b.cnt = 0;
  8001b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c0:	ff 75 0c             	pushl  0xc(%ebp)
  8001c3:	ff 75 08             	pushl  0x8(%ebp)
  8001c6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cc:	50                   	push   %eax
  8001cd:	68 60 01 80 00       	push   $0x800160
  8001d2:	e8 17 01 00 00       	call   8002ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d7:	83 c4 08             	add    $0x8,%esp
  8001da:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 28 09 00 00       	call   800b14 <sys_cputs>

	return b.cnt;
}
  8001ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fd:	50                   	push   %eax
  8001fe:	ff 75 08             	pushl  0x8(%ebp)
  800201:	e8 9d ff ff ff       	call   8001a3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	57                   	push   %edi
  80020c:	56                   	push   %esi
  80020d:	53                   	push   %ebx
  80020e:	83 ec 1c             	sub    $0x1c,%esp
  800211:	89 c7                	mov    %eax,%edi
  800213:	89 d6                	mov    %edx,%esi
  800215:	8b 45 08             	mov    0x8(%ebp),%eax
  800218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800221:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800224:	bb 00 00 00 00       	mov    $0x0,%ebx
  800229:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80022c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80022f:	39 d3                	cmp    %edx,%ebx
  800231:	72 05                	jb     800238 <printnum+0x30>
  800233:	39 45 10             	cmp    %eax,0x10(%ebp)
  800236:	77 78                	ja     8002b0 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 18             	pushl  0x18(%ebp)
  80023e:	8b 45 14             	mov    0x14(%ebp),%eax
  800241:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800244:	53                   	push   %ebx
  800245:	ff 75 10             	pushl  0x10(%ebp)
  800248:	83 ec 08             	sub    $0x8,%esp
  80024b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024e:	ff 75 e0             	pushl  -0x20(%ebp)
  800251:	ff 75 dc             	pushl  -0x24(%ebp)
  800254:	ff 75 d8             	pushl  -0x28(%ebp)
  800257:	e8 68 20 00 00       	call   8022c4 <__udivdi3>
  80025c:	83 c4 18             	add    $0x18,%esp
  80025f:	52                   	push   %edx
  800260:	50                   	push   %eax
  800261:	89 f2                	mov    %esi,%edx
  800263:	89 f8                	mov    %edi,%eax
  800265:	e8 9e ff ff ff       	call   800208 <printnum>
  80026a:	83 c4 20             	add    $0x20,%esp
  80026d:	eb 11                	jmp    800280 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	56                   	push   %esi
  800273:	ff 75 18             	pushl  0x18(%ebp)
  800276:	ff d7                	call   *%edi
  800278:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80027b:	4b                   	dec    %ebx
  80027c:	85 db                	test   %ebx,%ebx
  80027e:	7f ef                	jg     80026f <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	56                   	push   %esi
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028a:	ff 75 e0             	pushl  -0x20(%ebp)
  80028d:	ff 75 dc             	pushl  -0x24(%ebp)
  800290:	ff 75 d8             	pushl  -0x28(%ebp)
  800293:	e8 3c 21 00 00       	call   8023d4 <__umoddi3>
  800298:	83 c4 14             	add    $0x14,%esp
  80029b:	0f be 80 9b 25 80 00 	movsbl 0x80259b(%eax),%eax
  8002a2:	50                   	push   %eax
  8002a3:	ff d7                	call   *%edi
}
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ab:	5b                   	pop    %ebx
  8002ac:	5e                   	pop    %esi
  8002ad:	5f                   	pop    %edi
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    
  8002b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b3:	eb c6                	jmp    80027b <printnum+0x73>

008002b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002bb:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8002be:	8b 10                	mov    (%eax),%edx
  8002c0:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c3:	73 0a                	jae    8002cf <sprintputch+0x1a>
		*b->buf++ = ch;
  8002c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c8:	89 08                	mov    %ecx,(%eax)
  8002ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cd:	88 02                	mov    %al,(%edx)
}
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    

008002d1 <printfmt>:
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002da:	50                   	push   %eax
  8002db:	ff 75 10             	pushl  0x10(%ebp)
  8002de:	ff 75 0c             	pushl  0xc(%ebp)
  8002e1:	ff 75 08             	pushl  0x8(%ebp)
  8002e4:	e8 05 00 00 00       	call   8002ee <vprintfmt>
}
  8002e9:	83 c4 10             	add    $0x10,%esp
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <vprintfmt>:
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	57                   	push   %edi
  8002f2:	56                   	push   %esi
  8002f3:	53                   	push   %ebx
  8002f4:	83 ec 2c             	sub    $0x2c,%esp
  8002f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8002fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002fd:	8b 7d 10             	mov    0x10(%ebp),%edi
  800300:	e9 ae 03 00 00       	jmp    8006b3 <vprintfmt+0x3c5>
  800305:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800309:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800310:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800317:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80031e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800323:	8d 47 01             	lea    0x1(%edi),%eax
  800326:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800329:	8a 17                	mov    (%edi),%dl
  80032b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032e:	3c 55                	cmp    $0x55,%al
  800330:	0f 87 fe 03 00 00    	ja     800734 <vprintfmt+0x446>
  800336:	0f b6 c0             	movzbl %al,%eax
  800339:	ff 24 85 e0 26 80 00 	jmp    *0x8026e0(,%eax,4)
  800340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800343:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800347:	eb da                	jmp    800323 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80034c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800350:	eb d1                	jmp    800323 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800352:	0f b6 d2             	movzbl %dl,%edx
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800360:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800363:	01 c0                	add    %eax,%eax
  800365:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800369:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80036f:	83 f9 09             	cmp    $0x9,%ecx
  800372:	77 52                	ja     8003c6 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800374:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800375:	eb e9                	jmp    800360 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8d 40 04             	lea    0x4(%eax),%eax
  800385:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038f:	79 92                	jns    800323 <vprintfmt+0x35>
				width = precision, precision = -1;
  800391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800394:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800397:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80039e:	eb 83                	jmp    800323 <vprintfmt+0x35>
  8003a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a4:	78 08                	js     8003ae <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003a9:	e9 75 ff ff ff       	jmp    800323 <vprintfmt+0x35>
  8003ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003b5:	eb ef                	jmp    8003a6 <vprintfmt+0xb8>
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ba:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003c1:	e9 5d ff ff ff       	jmp    800323 <vprintfmt+0x35>
  8003c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003cc:	eb bd                	jmp    80038b <vprintfmt+0x9d>
			lflag++;
  8003ce:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d2:	e9 4c ff ff ff       	jmp    800323 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8d 78 04             	lea    0x4(%eax),%edi
  8003dd:	83 ec 08             	sub    $0x8,%esp
  8003e0:	53                   	push   %ebx
  8003e1:	ff 30                	pushl  (%eax)
  8003e3:	ff d6                	call   *%esi
			break;
  8003e5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003eb:	e9 c0 02 00 00       	jmp    8006b0 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8003f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f3:	8d 78 04             	lea    0x4(%eax),%edi
  8003f6:	8b 00                	mov    (%eax),%eax
  8003f8:	85 c0                	test   %eax,%eax
  8003fa:	78 2a                	js     800426 <vprintfmt+0x138>
  8003fc:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fe:	83 f8 0f             	cmp    $0xf,%eax
  800401:	7f 27                	jg     80042a <vprintfmt+0x13c>
  800403:	8b 04 85 40 28 80 00 	mov    0x802840(,%eax,4),%eax
  80040a:	85 c0                	test   %eax,%eax
  80040c:	74 1c                	je     80042a <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80040e:	50                   	push   %eax
  80040f:	68 71 29 80 00       	push   $0x802971
  800414:	53                   	push   %ebx
  800415:	56                   	push   %esi
  800416:	e8 b6 fe ff ff       	call   8002d1 <printfmt>
  80041b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800421:	e9 8a 02 00 00       	jmp    8006b0 <vprintfmt+0x3c2>
  800426:	f7 d8                	neg    %eax
  800428:	eb d2                	jmp    8003fc <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80042a:	52                   	push   %edx
  80042b:	68 b3 25 80 00       	push   $0x8025b3
  800430:	53                   	push   %ebx
  800431:	56                   	push   %esi
  800432:	e8 9a fe ff ff       	call   8002d1 <printfmt>
  800437:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043d:	e9 6e 02 00 00       	jmp    8006b0 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	83 c0 04             	add    $0x4,%eax
  800448:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8b 38                	mov    (%eax),%edi
  800450:	85 ff                	test   %edi,%edi
  800452:	74 39                	je     80048d <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800454:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800458:	0f 8e a9 00 00 00    	jle    800507 <vprintfmt+0x219>
  80045e:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800462:	0f 84 a7 00 00 00    	je     80050f <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	ff 75 d0             	pushl  -0x30(%ebp)
  80046e:	57                   	push   %edi
  80046f:	e8 6b 03 00 00       	call   8007df <strnlen>
  800474:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800477:	29 c1                	sub    %eax,%ecx
  800479:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80047c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80047f:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800483:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800486:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800489:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048b:	eb 14                	jmp    8004a1 <vprintfmt+0x1b3>
				p = "(null)";
  80048d:	bf ac 25 80 00       	mov    $0x8025ac,%edi
  800492:	eb c0                	jmp    800454 <vprintfmt+0x166>
					putch(padc, putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	53                   	push   %ebx
  800498:	ff 75 e0             	pushl  -0x20(%ebp)
  80049b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	4f                   	dec    %edi
  80049e:	83 c4 10             	add    $0x10,%esp
  8004a1:	85 ff                	test   %edi,%edi
  8004a3:	7f ef                	jg     800494 <vprintfmt+0x1a6>
  8004a5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004a8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004ab:	89 c8                	mov    %ecx,%eax
  8004ad:	85 c9                	test   %ecx,%ecx
  8004af:	78 10                	js     8004c1 <vprintfmt+0x1d3>
  8004b1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b4:	29 c1                	sub    %eax,%ecx
  8004b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004b9:	89 75 08             	mov    %esi,0x8(%ebp)
  8004bc:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004bf:	eb 15                	jmp    8004d6 <vprintfmt+0x1e8>
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c6:	eb e9                	jmp    8004b1 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	53                   	push   %ebx
  8004cc:	52                   	push   %edx
  8004cd:	ff 55 08             	call   *0x8(%ebp)
  8004d0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d3:	ff 4d e0             	decl   -0x20(%ebp)
  8004d6:	47                   	inc    %edi
  8004d7:	8a 47 ff             	mov    -0x1(%edi),%al
  8004da:	0f be d0             	movsbl %al,%edx
  8004dd:	85 d2                	test   %edx,%edx
  8004df:	74 59                	je     80053a <vprintfmt+0x24c>
  8004e1:	85 f6                	test   %esi,%esi
  8004e3:	78 03                	js     8004e8 <vprintfmt+0x1fa>
  8004e5:	4e                   	dec    %esi
  8004e6:	78 2f                	js     800517 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ec:	74 da                	je     8004c8 <vprintfmt+0x1da>
  8004ee:	0f be c0             	movsbl %al,%eax
  8004f1:	83 e8 20             	sub    $0x20,%eax
  8004f4:	83 f8 5e             	cmp    $0x5e,%eax
  8004f7:	76 cf                	jbe    8004c8 <vprintfmt+0x1da>
					putch('?', putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	6a 3f                	push   $0x3f
  8004ff:	ff 55 08             	call   *0x8(%ebp)
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	eb cc                	jmp    8004d3 <vprintfmt+0x1e5>
  800507:	89 75 08             	mov    %esi,0x8(%ebp)
  80050a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80050d:	eb c7                	jmp    8004d6 <vprintfmt+0x1e8>
  80050f:	89 75 08             	mov    %esi,0x8(%ebp)
  800512:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800515:	eb bf                	jmp    8004d6 <vprintfmt+0x1e8>
  800517:	8b 75 08             	mov    0x8(%ebp),%esi
  80051a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80051d:	eb 0c                	jmp    80052b <vprintfmt+0x23d>
				putch(' ', putdat);
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	53                   	push   %ebx
  800523:	6a 20                	push   $0x20
  800525:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800527:	4f                   	dec    %edi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	85 ff                	test   %edi,%edi
  80052d:	7f f0                	jg     80051f <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80052f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
  800535:	e9 76 01 00 00       	jmp    8006b0 <vprintfmt+0x3c2>
  80053a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80053d:	8b 75 08             	mov    0x8(%ebp),%esi
  800540:	eb e9                	jmp    80052b <vprintfmt+0x23d>
	if (lflag >= 2)
  800542:	83 f9 01             	cmp    $0x1,%ecx
  800545:	7f 1f                	jg     800566 <vprintfmt+0x278>
	else if (lflag)
  800547:	85 c9                	test   %ecx,%ecx
  800549:	75 48                	jne    800593 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800553:	89 c1                	mov    %eax,%ecx
  800555:	c1 f9 1f             	sar    $0x1f,%ecx
  800558:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8d 40 04             	lea    0x4(%eax),%eax
  800561:	89 45 14             	mov    %eax,0x14(%ebp)
  800564:	eb 17                	jmp    80057d <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 50 04             	mov    0x4(%eax),%edx
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800571:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 40 08             	lea    0x8(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80057d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800580:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800583:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800587:	78 25                	js     8005ae <vprintfmt+0x2c0>
			base = 10;
  800589:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058e:	e9 03 01 00 00       	jmp    800696 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059b:	89 c1                	mov    %eax,%ecx
  80059d:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ac:	eb cf                	jmp    80057d <vprintfmt+0x28f>
				putch('-', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	6a 2d                	push   $0x2d
  8005b4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bc:	f7 da                	neg    %edx
  8005be:	83 d1 00             	adc    $0x0,%ecx
  8005c1:	f7 d9                	neg    %ecx
  8005c3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cb:	e9 c6 00 00 00       	jmp    800696 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005d0:	83 f9 01             	cmp    $0x1,%ecx
  8005d3:	7f 1e                	jg     8005f3 <vprintfmt+0x305>
	else if (lflag)
  8005d5:	85 c9                	test   %ecx,%ecx
  8005d7:	75 32                	jne    80060b <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 10                	mov    (%eax),%edx
  8005de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e3:	8d 40 04             	lea    0x4(%eax),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ee:	e9 a3 00 00 00       	jmp    800696 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	8b 48 04             	mov    0x4(%eax),%ecx
  8005fb:	8d 40 08             	lea    0x8(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800601:	b8 0a 00 00 00       	mov    $0xa,%eax
  800606:	e9 8b 00 00 00       	jmp    800696 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8b 10                	mov    (%eax),%edx
  800610:	b9 00 00 00 00       	mov    $0x0,%ecx
  800615:	8d 40 04             	lea    0x4(%eax),%eax
  800618:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800620:	eb 74                	jmp    800696 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800622:	83 f9 01             	cmp    $0x1,%ecx
  800625:	7f 1b                	jg     800642 <vprintfmt+0x354>
	else if (lflag)
  800627:	85 c9                	test   %ecx,%ecx
  800629:	75 2c                	jne    800657 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8b 10                	mov    (%eax),%edx
  800630:	b9 00 00 00 00       	mov    $0x0,%ecx
  800635:	8d 40 04             	lea    0x4(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063b:	b8 08 00 00 00       	mov    $0x8,%eax
  800640:	eb 54                	jmp    800696 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	8b 48 04             	mov    0x4(%eax),%ecx
  80064a:	8d 40 08             	lea    0x8(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800650:	b8 08 00 00 00       	mov    $0x8,%eax
  800655:	eb 3f                	jmp    800696 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 10                	mov    (%eax),%edx
  80065c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800661:	8d 40 04             	lea    0x4(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800667:	b8 08 00 00 00       	mov    $0x8,%eax
  80066c:	eb 28                	jmp    800696 <vprintfmt+0x3a8>
			putch('0', putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	53                   	push   %ebx
  800672:	6a 30                	push   $0x30
  800674:	ff d6                	call   *%esi
			putch('x', putdat);
  800676:	83 c4 08             	add    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 78                	push   $0x78
  80067c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 10                	mov    (%eax),%edx
  800683:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800688:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80068b:	8d 40 04             	lea    0x4(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800691:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800696:	83 ec 0c             	sub    $0xc,%esp
  800699:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80069d:	57                   	push   %edi
  80069e:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a1:	50                   	push   %eax
  8006a2:	51                   	push   %ecx
  8006a3:	52                   	push   %edx
  8006a4:	89 da                	mov    %ebx,%edx
  8006a6:	89 f0                	mov    %esi,%eax
  8006a8:	e8 5b fb ff ff       	call   800208 <printnum>
			break;
  8006ad:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b3:	47                   	inc    %edi
  8006b4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b8:	83 f8 25             	cmp    $0x25,%eax
  8006bb:	0f 84 44 fc ff ff    	je     800305 <vprintfmt+0x17>
			if (ch == '\0')
  8006c1:	85 c0                	test   %eax,%eax
  8006c3:	0f 84 89 00 00 00    	je     800752 <vprintfmt+0x464>
			putch(ch, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	50                   	push   %eax
  8006ce:	ff d6                	call   *%esi
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	eb de                	jmp    8006b3 <vprintfmt+0x3c5>
	if (lflag >= 2)
  8006d5:	83 f9 01             	cmp    $0x1,%ecx
  8006d8:	7f 1b                	jg     8006f5 <vprintfmt+0x407>
	else if (lflag)
  8006da:	85 c9                	test   %ecx,%ecx
  8006dc:	75 2c                	jne    80070a <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 10                	mov    (%eax),%edx
  8006e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e8:	8d 40 04             	lea    0x4(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f3:	eb a1                	jmp    800696 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 10                	mov    (%eax),%edx
  8006fa:	8b 48 04             	mov    0x4(%eax),%ecx
  8006fd:	8d 40 08             	lea    0x8(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800703:	b8 10 00 00 00       	mov    $0x10,%eax
  800708:	eb 8c                	jmp    800696 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 10                	mov    (%eax),%edx
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800714:	8d 40 04             	lea    0x4(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071a:	b8 10 00 00 00       	mov    $0x10,%eax
  80071f:	e9 72 ff ff ff       	jmp    800696 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	53                   	push   %ebx
  800728:	6a 25                	push   $0x25
  80072a:	ff d6                	call   *%esi
			break;
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	e9 7c ff ff ff       	jmp    8006b0 <vprintfmt+0x3c2>
			putch('%', putdat);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	53                   	push   %ebx
  800738:	6a 25                	push   $0x25
  80073a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	89 f8                	mov    %edi,%eax
  800741:	eb 01                	jmp    800744 <vprintfmt+0x456>
  800743:	48                   	dec    %eax
  800744:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800748:	75 f9                	jne    800743 <vprintfmt+0x455>
  80074a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074d:	e9 5e ff ff ff       	jmp    8006b0 <vprintfmt+0x3c2>
}
  800752:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800755:	5b                   	pop    %ebx
  800756:	5e                   	pop    %esi
  800757:	5f                   	pop    %edi
  800758:	5d                   	pop    %ebp
  800759:	c3                   	ret    

0080075a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 18             	sub    $0x18,%esp
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800766:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800769:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80076d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800777:	85 c0                	test   %eax,%eax
  800779:	74 26                	je     8007a1 <vsnprintf+0x47>
  80077b:	85 d2                	test   %edx,%edx
  80077d:	7e 29                	jle    8007a8 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80077f:	ff 75 14             	pushl  0x14(%ebp)
  800782:	ff 75 10             	pushl  0x10(%ebp)
  800785:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800788:	50                   	push   %eax
  800789:	68 b5 02 80 00       	push   $0x8002b5
  80078e:	e8 5b fb ff ff       	call   8002ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800796:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079c:	83 c4 10             	add    $0x10,%esp
}
  80079f:	c9                   	leave  
  8007a0:	c3                   	ret    
		return -E_INVAL;
  8007a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a6:	eb f7                	jmp    80079f <vsnprintf+0x45>
  8007a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ad:	eb f0                	jmp    80079f <vsnprintf+0x45>

008007af <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b8:	50                   	push   %eax
  8007b9:	ff 75 10             	pushl  0x10(%ebp)
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	e8 93 ff ff ff       	call   80075a <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d4:	eb 01                	jmp    8007d7 <strlen+0xe>
		n++;
  8007d6:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8007d7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007db:	75 f9                	jne    8007d6 <strlen+0xd>
	return n;
}
  8007dd:	5d                   	pop    %ebp
  8007de:	c3                   	ret    

008007df <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ed:	eb 01                	jmp    8007f0 <strnlen+0x11>
		n++;
  8007ef:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f0:	39 d0                	cmp    %edx,%eax
  8007f2:	74 06                	je     8007fa <strnlen+0x1b>
  8007f4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f8:	75 f5                	jne    8007ef <strnlen+0x10>
	return n;
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	53                   	push   %ebx
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800806:	89 c2                	mov    %eax,%edx
  800808:	42                   	inc    %edx
  800809:	41                   	inc    %ecx
  80080a:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80080d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800810:	84 db                	test   %bl,%bl
  800812:	75 f4                	jne    800808 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800814:	5b                   	pop    %ebx
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80081e:	53                   	push   %ebx
  80081f:	e8 a5 ff ff ff       	call   8007c9 <strlen>
  800824:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	01 d8                	add    %ebx,%eax
  80082c:	50                   	push   %eax
  80082d:	e8 ca ff ff ff       	call   8007fc <strcpy>
	return dst;
}
  800832:	89 d8                	mov    %ebx,%eax
  800834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800837:	c9                   	leave  
  800838:	c3                   	ret    

00800839 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	56                   	push   %esi
  80083d:	53                   	push   %ebx
  80083e:	8b 75 08             	mov    0x8(%ebp),%esi
  800841:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800844:	89 f3                	mov    %esi,%ebx
  800846:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800849:	89 f2                	mov    %esi,%edx
  80084b:	eb 0c                	jmp    800859 <strncpy+0x20>
		*dst++ = *src;
  80084d:	42                   	inc    %edx
  80084e:	8a 01                	mov    (%ecx),%al
  800850:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800853:	80 39 01             	cmpb   $0x1,(%ecx)
  800856:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800859:	39 da                	cmp    %ebx,%edx
  80085b:	75 f0                	jne    80084d <strncpy+0x14>
	}
	return ret;
}
  80085d:	89 f0                	mov    %esi,%eax
  80085f:	5b                   	pop    %ebx
  800860:	5e                   	pop    %esi
  800861:	5d                   	pop    %ebp
  800862:	c3                   	ret    

00800863 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	56                   	push   %esi
  800867:	53                   	push   %ebx
  800868:	8b 75 08             	mov    0x8(%ebp),%esi
  80086b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086e:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800871:	85 c0                	test   %eax,%eax
  800873:	74 20                	je     800895 <strlcpy+0x32>
  800875:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800879:	89 f0                	mov    %esi,%eax
  80087b:	eb 05                	jmp    800882 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80087d:	40                   	inc    %eax
  80087e:	42                   	inc    %edx
  80087f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800882:	39 d8                	cmp    %ebx,%eax
  800884:	74 06                	je     80088c <strlcpy+0x29>
  800886:	8a 0a                	mov    (%edx),%cl
  800888:	84 c9                	test   %cl,%cl
  80088a:	75 f1                	jne    80087d <strlcpy+0x1a>
		*dst = '\0';
  80088c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80088f:	29 f0                	sub    %esi,%eax
}
  800891:	5b                   	pop    %ebx
  800892:	5e                   	pop    %esi
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    
  800895:	89 f0                	mov    %esi,%eax
  800897:	eb f6                	jmp    80088f <strlcpy+0x2c>

00800899 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008a2:	eb 02                	jmp    8008a6 <strcmp+0xd>
		p++, q++;
  8008a4:	41                   	inc    %ecx
  8008a5:	42                   	inc    %edx
	while (*p && *p == *q)
  8008a6:	8a 01                	mov    (%ecx),%al
  8008a8:	84 c0                	test   %al,%al
  8008aa:	74 04                	je     8008b0 <strcmp+0x17>
  8008ac:	3a 02                	cmp    (%edx),%al
  8008ae:	74 f4                	je     8008a4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b0:	0f b6 c0             	movzbl %al,%eax
  8008b3:	0f b6 12             	movzbl (%edx),%edx
  8008b6:	29 d0                	sub    %edx,%eax
}
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	53                   	push   %ebx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c4:	89 c3                	mov    %eax,%ebx
  8008c6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c9:	eb 02                	jmp    8008cd <strncmp+0x13>
		n--, p++, q++;
  8008cb:	40                   	inc    %eax
  8008cc:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8008cd:	39 d8                	cmp    %ebx,%eax
  8008cf:	74 15                	je     8008e6 <strncmp+0x2c>
  8008d1:	8a 08                	mov    (%eax),%cl
  8008d3:	84 c9                	test   %cl,%cl
  8008d5:	74 04                	je     8008db <strncmp+0x21>
  8008d7:	3a 0a                	cmp    (%edx),%cl
  8008d9:	74 f0                	je     8008cb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008db:	0f b6 00             	movzbl (%eax),%eax
  8008de:	0f b6 12             	movzbl (%edx),%edx
  8008e1:	29 d0                	sub    %edx,%eax
}
  8008e3:	5b                   	pop    %ebx
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    
		return 0;
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb f6                	jmp    8008e3 <strncmp+0x29>

008008ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008f6:	8a 10                	mov    (%eax),%dl
  8008f8:	84 d2                	test   %dl,%dl
  8008fa:	74 07                	je     800903 <strchr+0x16>
		if (*s == c)
  8008fc:	38 ca                	cmp    %cl,%dl
  8008fe:	74 08                	je     800908 <strchr+0x1b>
	for (; *s; s++)
  800900:	40                   	inc    %eax
  800901:	eb f3                	jmp    8008f6 <strchr+0x9>
			return (char *) s;
	return 0;
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800913:	8a 10                	mov    (%eax),%dl
  800915:	84 d2                	test   %dl,%dl
  800917:	74 07                	je     800920 <strfind+0x16>
		if (*s == c)
  800919:	38 ca                	cmp    %cl,%dl
  80091b:	74 03                	je     800920 <strfind+0x16>
	for (; *s; s++)
  80091d:	40                   	inc    %eax
  80091e:	eb f3                	jmp    800913 <strfind+0x9>
			break;
	return (char *) s;
}
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	57                   	push   %edi
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	8b 7d 08             	mov    0x8(%ebp),%edi
  80092b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80092e:	85 c9                	test   %ecx,%ecx
  800930:	74 13                	je     800945 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800932:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800938:	75 05                	jne    80093f <memset+0x1d>
  80093a:	f6 c1 03             	test   $0x3,%cl
  80093d:	74 0d                	je     80094c <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	fc                   	cld    
  800943:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800945:	89 f8                	mov    %edi,%eax
  800947:	5b                   	pop    %ebx
  800948:	5e                   	pop    %esi
  800949:	5f                   	pop    %edi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    
		c &= 0xFF;
  80094c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800950:	89 d3                	mov    %edx,%ebx
  800952:	c1 e3 08             	shl    $0x8,%ebx
  800955:	89 d0                	mov    %edx,%eax
  800957:	c1 e0 18             	shl    $0x18,%eax
  80095a:	89 d6                	mov    %edx,%esi
  80095c:	c1 e6 10             	shl    $0x10,%esi
  80095f:	09 f0                	or     %esi,%eax
  800961:	09 c2                	or     %eax,%edx
  800963:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800965:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800968:	89 d0                	mov    %edx,%eax
  80096a:	fc                   	cld    
  80096b:	f3 ab                	rep stos %eax,%es:(%edi)
  80096d:	eb d6                	jmp    800945 <memset+0x23>

0080096f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	57                   	push   %edi
  800973:	56                   	push   %esi
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 75 0c             	mov    0xc(%ebp),%esi
  80097a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097d:	39 c6                	cmp    %eax,%esi
  80097f:	73 33                	jae    8009b4 <memmove+0x45>
  800981:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800984:	39 d0                	cmp    %edx,%eax
  800986:	73 2c                	jae    8009b4 <memmove+0x45>
		s += n;
		d += n;
  800988:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098b:	89 d6                	mov    %edx,%esi
  80098d:	09 fe                	or     %edi,%esi
  80098f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800995:	75 13                	jne    8009aa <memmove+0x3b>
  800997:	f6 c1 03             	test   $0x3,%cl
  80099a:	75 0e                	jne    8009aa <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80099c:	83 ef 04             	sub    $0x4,%edi
  80099f:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a8:	eb 07                	jmp    8009b1 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009aa:	4f                   	dec    %edi
  8009ab:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ae:	fd                   	std    
  8009af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b1:	fc                   	cld    
  8009b2:	eb 13                	jmp    8009c7 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b4:	89 f2                	mov    %esi,%edx
  8009b6:	09 c2                	or     %eax,%edx
  8009b8:	f6 c2 03             	test   $0x3,%dl
  8009bb:	75 05                	jne    8009c2 <memmove+0x53>
  8009bd:	f6 c1 03             	test   $0x3,%cl
  8009c0:	74 09                	je     8009cb <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009c2:	89 c7                	mov    %eax,%edi
  8009c4:	fc                   	cld    
  8009c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c7:	5e                   	pop    %esi
  8009c8:	5f                   	pop    %edi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009cb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009ce:	89 c7                	mov    %eax,%edi
  8009d0:	fc                   	cld    
  8009d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d3:	eb f2                	jmp    8009c7 <memmove+0x58>

008009d5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009d8:	ff 75 10             	pushl  0x10(%ebp)
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	ff 75 08             	pushl  0x8(%ebp)
  8009e1:	e8 89 ff ff ff       	call   80096f <memmove>
}
  8009e6:	c9                   	leave  
  8009e7:	c3                   	ret    

008009e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	56                   	push   %esi
  8009ec:	53                   	push   %ebx
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	89 c6                	mov    %eax,%esi
  8009f2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  8009f5:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  8009f8:	39 f0                	cmp    %esi,%eax
  8009fa:	74 16                	je     800a12 <memcmp+0x2a>
		if (*s1 != *s2)
  8009fc:	8a 08                	mov    (%eax),%cl
  8009fe:	8a 1a                	mov    (%edx),%bl
  800a00:	38 d9                	cmp    %bl,%cl
  800a02:	75 04                	jne    800a08 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a04:	40                   	inc    %eax
  800a05:	42                   	inc    %edx
  800a06:	eb f0                	jmp    8009f8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a08:	0f b6 c1             	movzbl %cl,%eax
  800a0b:	0f b6 db             	movzbl %bl,%ebx
  800a0e:	29 d8                	sub    %ebx,%eax
  800a10:	eb 05                	jmp    800a17 <memcmp+0x2f>
	}

	return 0;
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a17:	5b                   	pop    %ebx
  800a18:	5e                   	pop    %esi
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a24:	89 c2                	mov    %eax,%edx
  800a26:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a29:	39 d0                	cmp    %edx,%eax
  800a2b:	73 07                	jae    800a34 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a2d:	38 08                	cmp    %cl,(%eax)
  800a2f:	74 03                	je     800a34 <memfind+0x19>
	for (; s < ends; s++)
  800a31:	40                   	inc    %eax
  800a32:	eb f5                	jmp    800a29 <memfind+0xe>
			break;
	return (void *) s;
}
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	57                   	push   %edi
  800a3a:	56                   	push   %esi
  800a3b:	53                   	push   %ebx
  800a3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a3f:	eb 01                	jmp    800a42 <strtol+0xc>
		s++;
  800a41:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a42:	8a 01                	mov    (%ecx),%al
  800a44:	3c 20                	cmp    $0x20,%al
  800a46:	74 f9                	je     800a41 <strtol+0xb>
  800a48:	3c 09                	cmp    $0x9,%al
  800a4a:	74 f5                	je     800a41 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a4c:	3c 2b                	cmp    $0x2b,%al
  800a4e:	74 2b                	je     800a7b <strtol+0x45>
		s++;
	else if (*s == '-')
  800a50:	3c 2d                	cmp    $0x2d,%al
  800a52:	74 2f                	je     800a83 <strtol+0x4d>
	int neg = 0;
  800a54:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a59:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a60:	75 12                	jne    800a74 <strtol+0x3e>
  800a62:	80 39 30             	cmpb   $0x30,(%ecx)
  800a65:	74 24                	je     800a8b <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a6b:	75 07                	jne    800a74 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a6d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	eb 4e                	jmp    800ac9 <strtol+0x93>
		s++;
  800a7b:	41                   	inc    %ecx
	int neg = 0;
  800a7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800a81:	eb d6                	jmp    800a59 <strtol+0x23>
		s++, neg = 1;
  800a83:	41                   	inc    %ecx
  800a84:	bf 01 00 00 00       	mov    $0x1,%edi
  800a89:	eb ce                	jmp    800a59 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a8f:	74 10                	je     800aa1 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a95:	75 dd                	jne    800a74 <strtol+0x3e>
		s++, base = 8;
  800a97:	41                   	inc    %ecx
  800a98:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a9f:	eb d3                	jmp    800a74 <strtol+0x3e>
		s += 2, base = 16;
  800aa1:	83 c1 02             	add    $0x2,%ecx
  800aa4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800aab:	eb c7                	jmp    800a74 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aad:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ab0:	89 f3                	mov    %esi,%ebx
  800ab2:	80 fb 19             	cmp    $0x19,%bl
  800ab5:	77 24                	ja     800adb <strtol+0xa5>
			dig = *s - 'a' + 10;
  800ab7:	0f be d2             	movsbl %dl,%edx
  800aba:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800abd:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac0:	7d 2b                	jge    800aed <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800ac2:	41                   	inc    %ecx
  800ac3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ac7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ac9:	8a 11                	mov    (%ecx),%dl
  800acb:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800ace:	80 fb 09             	cmp    $0x9,%bl
  800ad1:	77 da                	ja     800aad <strtol+0x77>
			dig = *s - '0';
  800ad3:	0f be d2             	movsbl %dl,%edx
  800ad6:	83 ea 30             	sub    $0x30,%edx
  800ad9:	eb e2                	jmp    800abd <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800adb:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ade:	89 f3                	mov    %esi,%ebx
  800ae0:	80 fb 19             	cmp    $0x19,%bl
  800ae3:	77 08                	ja     800aed <strtol+0xb7>
			dig = *s - 'A' + 10;
  800ae5:	0f be d2             	movsbl %dl,%edx
  800ae8:	83 ea 37             	sub    $0x37,%edx
  800aeb:	eb d0                	jmp    800abd <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af1:	74 05                	je     800af8 <strtol+0xc2>
		*endptr = (char *) s;
  800af3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800af8:	85 ff                	test   %edi,%edi
  800afa:	74 02                	je     800afe <strtol+0xc8>
  800afc:	f7 d8                	neg    %eax
}
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5f                   	pop    %edi
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <atoi>:

int
atoi(const char *s)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b06:	6a 0a                	push   $0xa
  800b08:	6a 00                	push   $0x0
  800b0a:	ff 75 08             	pushl  0x8(%ebp)
  800b0d:	e8 24 ff ff ff       	call   800a36 <strtol>
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	57                   	push   %edi
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	89 c3                	mov    %eax,%ebx
  800b27:	89 c7                	mov    %eax,%edi
  800b29:	89 c6                	mov    %eax,%esi
  800b2b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b2d:	5b                   	pop    %ebx
  800b2e:	5e                   	pop    %esi
  800b2f:	5f                   	pop    %edi
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	57                   	push   %edi
  800b36:	56                   	push   %esi
  800b37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b38:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b42:	89 d1                	mov    %edx,%ecx
  800b44:	89 d3                	mov    %edx,%ebx
  800b46:	89 d7                	mov    %edx,%edi
  800b48:	89 d6                	mov    %edx,%esi
  800b4a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5f                   	pop    %edi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	57                   	push   %edi
  800b55:	56                   	push   %esi
  800b56:	53                   	push   %ebx
  800b57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b64:	8b 55 08             	mov    0x8(%ebp),%edx
  800b67:	89 cb                	mov    %ecx,%ebx
  800b69:	89 cf                	mov    %ecx,%edi
  800b6b:	89 ce                	mov    %ecx,%esi
  800b6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b6f:	85 c0                	test   %eax,%eax
  800b71:	7f 08                	jg     800b7b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5f                   	pop    %edi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b7b:	83 ec 0c             	sub    $0xc,%esp
  800b7e:	50                   	push   %eax
  800b7f:	6a 03                	push   $0x3
  800b81:	68 9f 28 80 00       	push   $0x80289f
  800b86:	6a 23                	push   $0x23
  800b88:	68 bc 28 80 00       	push   $0x8028bc
  800b8d:	e8 4f f5 ff ff       	call   8000e1 <_panic>

00800b92 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	57                   	push   %edi
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b98:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9d:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba2:	89 d1                	mov    %edx,%ecx
  800ba4:	89 d3                	mov    %edx,%ebx
  800ba6:	89 d7                	mov    %edx,%edi
  800ba8:	89 d6                	mov    %edx,%esi
  800baa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	57                   	push   %edi
  800bb5:	56                   	push   %esi
  800bb6:	53                   	push   %ebx
  800bb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bba:	be 00 00 00 00       	mov    $0x0,%esi
  800bbf:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bcd:	89 f7                	mov    %esi,%edi
  800bcf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd1:	85 c0                	test   %eax,%eax
  800bd3:	7f 08                	jg     800bdd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd8:	5b                   	pop    %ebx
  800bd9:	5e                   	pop    %esi
  800bda:	5f                   	pop    %edi
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bdd:	83 ec 0c             	sub    $0xc,%esp
  800be0:	50                   	push   %eax
  800be1:	6a 04                	push   $0x4
  800be3:	68 9f 28 80 00       	push   $0x80289f
  800be8:	6a 23                	push   $0x23
  800bea:	68 bc 28 80 00       	push   $0x8028bc
  800bef:	e8 ed f4 ff ff       	call   8000e1 <_panic>

00800bf4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
  800bfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfd:	b8 05 00 00 00       	mov    $0x5,%eax
  800c02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c05:	8b 55 08             	mov    0x8(%ebp),%edx
  800c08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c0e:	8b 75 18             	mov    0x18(%ebp),%esi
  800c11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c13:	85 c0                	test   %eax,%eax
  800c15:	7f 08                	jg     800c1f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1f:	83 ec 0c             	sub    $0xc,%esp
  800c22:	50                   	push   %eax
  800c23:	6a 05                	push   $0x5
  800c25:	68 9f 28 80 00       	push   $0x80289f
  800c2a:	6a 23                	push   $0x23
  800c2c:	68 bc 28 80 00       	push   $0x8028bc
  800c31:	e8 ab f4 ff ff       	call   8000e1 <_panic>

00800c36 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
  800c3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c44:	b8 06 00 00 00       	mov    $0x6,%eax
  800c49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4f:	89 df                	mov    %ebx,%edi
  800c51:	89 de                	mov    %ebx,%esi
  800c53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c55:	85 c0                	test   %eax,%eax
  800c57:	7f 08                	jg     800c61 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5c:	5b                   	pop    %ebx
  800c5d:	5e                   	pop    %esi
  800c5e:	5f                   	pop    %edi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c61:	83 ec 0c             	sub    $0xc,%esp
  800c64:	50                   	push   %eax
  800c65:	6a 06                	push   $0x6
  800c67:	68 9f 28 80 00       	push   $0x80289f
  800c6c:	6a 23                	push   $0x23
  800c6e:	68 bc 28 80 00       	push   $0x8028bc
  800c73:	e8 69 f4 ff ff       	call   8000e1 <_panic>

00800c78 <sys_yield>:

void
sys_yield(void)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c83:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c88:	89 d1                	mov    %edx,%ecx
  800c8a:	89 d3                	mov    %edx,%ebx
  800c8c:	89 d7                	mov    %edx,%edi
  800c8e:	89 d6                	mov    %edx,%esi
  800c90:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca5:	b8 08 00 00 00       	mov    $0x8,%eax
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	89 df                	mov    %ebx,%edi
  800cb2:	89 de                	mov    %ebx,%esi
  800cb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	7f 08                	jg     800cc2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc2:	83 ec 0c             	sub    $0xc,%esp
  800cc5:	50                   	push   %eax
  800cc6:	6a 08                	push   $0x8
  800cc8:	68 9f 28 80 00       	push   $0x80289f
  800ccd:	6a 23                	push   $0x23
  800ccf:	68 bc 28 80 00       	push   $0x8028bc
  800cd4:	e8 08 f4 ff ff       	call   8000e1 <_panic>

00800cd9 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	89 cb                	mov    %ecx,%ebx
  800cf1:	89 cf                	mov    %ecx,%edi
  800cf3:	89 ce                	mov    %ecx,%esi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 0c                	push   $0xc
  800d09:	68 9f 28 80 00       	push   $0x80289f
  800d0e:	6a 23                	push   $0x23
  800d10:	68 bc 28 80 00       	push   $0x8028bc
  800d15:	e8 c7 f3 ff ff       	call   8000e1 <_panic>

00800d1a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
  800d20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d28:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d30:	8b 55 08             	mov    0x8(%ebp),%edx
  800d33:	89 df                	mov    %ebx,%edi
  800d35:	89 de                	mov    %ebx,%esi
  800d37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	7f 08                	jg     800d45 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d40:	5b                   	pop    %ebx
  800d41:	5e                   	pop    %esi
  800d42:	5f                   	pop    %edi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d45:	83 ec 0c             	sub    $0xc,%esp
  800d48:	50                   	push   %eax
  800d49:	6a 09                	push   $0x9
  800d4b:	68 9f 28 80 00       	push   $0x80289f
  800d50:	6a 23                	push   $0x23
  800d52:	68 bc 28 80 00       	push   $0x8028bc
  800d57:	e8 85 f3 ff ff       	call   8000e1 <_panic>

00800d5c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	89 df                	mov    %ebx,%edi
  800d77:	89 de                	mov    %ebx,%esi
  800d79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	7f 08                	jg     800d87 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d87:	83 ec 0c             	sub    $0xc,%esp
  800d8a:	50                   	push   %eax
  800d8b:	6a 0a                	push   $0xa
  800d8d:	68 9f 28 80 00       	push   $0x80289f
  800d92:	6a 23                	push   $0x23
  800d94:	68 bc 28 80 00       	push   $0x8028bc
  800d99:	e8 43 f3 ff ff       	call   8000e1 <_panic>

00800d9e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da4:	be 00 00 00 00       	mov    $0x0,%esi
  800da9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dba:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	53                   	push   %ebx
  800dc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dcf:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	89 cb                	mov    %ecx,%ebx
  800dd9:	89 cf                	mov    %ecx,%edi
  800ddb:	89 ce                	mov    %ecx,%esi
  800ddd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	7f 08                	jg     800deb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	83 ec 0c             	sub    $0xc,%esp
  800dee:	50                   	push   %eax
  800def:	6a 0e                	push   $0xe
  800df1:	68 9f 28 80 00       	push   $0x80289f
  800df6:	6a 23                	push   $0x23
  800df8:	68 bc 28 80 00       	push   $0x8028bc
  800dfd:	e8 df f2 ff ff       	call   8000e1 <_panic>

00800e02 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e08:	be 00 00 00 00       	mov    $0x0,%esi
  800e0d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1b:	89 f7                	mov    %esi,%edi
  800e1d:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2a:	be 00 00 00 00       	mov    $0x0,%esi
  800e2f:	b8 10 00 00 00       	mov    $0x10,%eax
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3d:	89 f7                	mov    %esi,%edi
  800e3f:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e51:	b8 11 00 00 00       	mov    $0x11,%eax
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	89 cb                	mov    %ecx,%ebx
  800e5b:	89 cf                	mov    %ecx,%edi
  800e5d:	89 ce                	mov    %ecx,%esi
  800e5f:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    

00800e66 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	05 00 00 00 30       	add    $0x30000000,%eax
  800e71:	c1 e8 0c             	shr    $0xc,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e86:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e93:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e98:	89 c2                	mov    %eax,%edx
  800e9a:	c1 ea 16             	shr    $0x16,%edx
  800e9d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ea4:	f6 c2 01             	test   $0x1,%dl
  800ea7:	74 2a                	je     800ed3 <fd_alloc+0x46>
  800ea9:	89 c2                	mov    %eax,%edx
  800eab:	c1 ea 0c             	shr    $0xc,%edx
  800eae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eb5:	f6 c2 01             	test   $0x1,%dl
  800eb8:	74 19                	je     800ed3 <fd_alloc+0x46>
  800eba:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ebf:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ec4:	75 d2                	jne    800e98 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ec6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ecc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ed1:	eb 07                	jmp    800eda <fd_alloc+0x4d>
			*fd_store = fd;
  800ed3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800edf:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800ee3:	77 39                	ja     800f1e <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	c1 e0 0c             	shl    $0xc,%eax
  800eeb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ef0:	89 c2                	mov    %eax,%edx
  800ef2:	c1 ea 16             	shr    $0x16,%edx
  800ef5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800efc:	f6 c2 01             	test   $0x1,%dl
  800eff:	74 24                	je     800f25 <fd_lookup+0x49>
  800f01:	89 c2                	mov    %eax,%edx
  800f03:	c1 ea 0c             	shr    $0xc,%edx
  800f06:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f0d:	f6 c2 01             	test   $0x1,%dl
  800f10:	74 1a                	je     800f2c <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f15:	89 02                	mov    %eax,(%edx)
	return 0;
  800f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
		return -E_INVAL;
  800f1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f23:	eb f7                	jmp    800f1c <fd_lookup+0x40>
		return -E_INVAL;
  800f25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2a:	eb f0                	jmp    800f1c <fd_lookup+0x40>
  800f2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f31:	eb e9                	jmp    800f1c <fd_lookup+0x40>

00800f33 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f3c:	ba 48 29 80 00       	mov    $0x802948,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f41:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f46:	39 08                	cmp    %ecx,(%eax)
  800f48:	74 33                	je     800f7d <dev_lookup+0x4a>
  800f4a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f4d:	8b 02                	mov    (%edx),%eax
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	75 f3                	jne    800f46 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f53:	a1 04 40 80 00       	mov    0x804004,%eax
  800f58:	8b 40 48             	mov    0x48(%eax),%eax
  800f5b:	83 ec 04             	sub    $0x4,%esp
  800f5e:	51                   	push   %ecx
  800f5f:	50                   	push   %eax
  800f60:	68 cc 28 80 00       	push   $0x8028cc
  800f65:	e8 8a f2 ff ff       	call   8001f4 <cprintf>
	*dev = 0;
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f73:	83 c4 10             	add    $0x10,%esp
  800f76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f7b:	c9                   	leave  
  800f7c:	c3                   	ret    
			*dev = devtab[i];
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f82:	b8 00 00 00 00       	mov    $0x0,%eax
  800f87:	eb f2                	jmp    800f7b <dev_lookup+0x48>

00800f89 <fd_close>:
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	57                   	push   %edi
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 1c             	sub    $0x1c,%esp
  800f92:	8b 75 08             	mov    0x8(%ebp),%esi
  800f95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f98:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f9b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f9c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fa2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fa5:	50                   	push   %eax
  800fa6:	e8 31 ff ff ff       	call   800edc <fd_lookup>
  800fab:	89 c7                	mov    %eax,%edi
  800fad:	83 c4 08             	add    $0x8,%esp
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	78 05                	js     800fb9 <fd_close+0x30>
	    || fd != fd2)
  800fb4:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800fb7:	74 13                	je     800fcc <fd_close+0x43>
		return (must_exist ? r : 0);
  800fb9:	84 db                	test   %bl,%bl
  800fbb:	75 05                	jne    800fc2 <fd_close+0x39>
  800fbd:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800fc2:	89 f8                	mov    %edi,%eax
  800fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fcc:	83 ec 08             	sub    $0x8,%esp
  800fcf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	ff 36                	pushl  (%esi)
  800fd5:	e8 59 ff ff ff       	call   800f33 <dev_lookup>
  800fda:	89 c7                	mov    %eax,%edi
  800fdc:	83 c4 10             	add    $0x10,%esp
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	78 15                	js     800ff8 <fd_close+0x6f>
		if (dev->dev_close)
  800fe3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe6:	8b 40 10             	mov    0x10(%eax),%eax
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	74 1b                	je     801008 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	56                   	push   %esi
  800ff1:	ff d0                	call   *%eax
  800ff3:	89 c7                	mov    %eax,%edi
  800ff5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	56                   	push   %esi
  800ffc:	6a 00                	push   $0x0
  800ffe:	e8 33 fc ff ff       	call   800c36 <sys_page_unmap>
	return r;
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	eb ba                	jmp    800fc2 <fd_close+0x39>
			r = 0;
  801008:	bf 00 00 00 00       	mov    $0x0,%edi
  80100d:	eb e9                	jmp    800ff8 <fd_close+0x6f>

0080100f <close>:

int
close(int fdnum)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801015:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801018:	50                   	push   %eax
  801019:	ff 75 08             	pushl  0x8(%ebp)
  80101c:	e8 bb fe ff ff       	call   800edc <fd_lookup>
  801021:	83 c4 08             	add    $0x8,%esp
  801024:	85 c0                	test   %eax,%eax
  801026:	78 10                	js     801038 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	6a 01                	push   $0x1
  80102d:	ff 75 f4             	pushl  -0xc(%ebp)
  801030:	e8 54 ff ff ff       	call   800f89 <fd_close>
  801035:	83 c4 10             	add    $0x10,%esp
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <close_all>:

void
close_all(void)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	53                   	push   %ebx
  80103e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801041:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801046:	83 ec 0c             	sub    $0xc,%esp
  801049:	53                   	push   %ebx
  80104a:	e8 c0 ff ff ff       	call   80100f <close>
	for (i = 0; i < MAXFD; i++)
  80104f:	43                   	inc    %ebx
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	83 fb 20             	cmp    $0x20,%ebx
  801056:	75 ee                	jne    801046 <close_all+0xc>
}
  801058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
  801063:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801066:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801069:	50                   	push   %eax
  80106a:	ff 75 08             	pushl  0x8(%ebp)
  80106d:	e8 6a fe ff ff       	call   800edc <fd_lookup>
  801072:	89 c3                	mov    %eax,%ebx
  801074:	83 c4 08             	add    $0x8,%esp
  801077:	85 c0                	test   %eax,%eax
  801079:	0f 88 81 00 00 00    	js     801100 <dup+0xa3>
		return r;
	close(newfdnum);
  80107f:	83 ec 0c             	sub    $0xc,%esp
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	e8 85 ff ff ff       	call   80100f <close>

	newfd = INDEX2FD(newfdnum);
  80108a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80108d:	c1 e6 0c             	shl    $0xc,%esi
  801090:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109c:	e8 d5 fd ff ff       	call   800e76 <fd2data>
  8010a1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010a3:	89 34 24             	mov    %esi,(%esp)
  8010a6:	e8 cb fd ff ff       	call   800e76 <fd2data>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010b0:	89 d8                	mov    %ebx,%eax
  8010b2:	c1 e8 16             	shr    $0x16,%eax
  8010b5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010bc:	a8 01                	test   $0x1,%al
  8010be:	74 11                	je     8010d1 <dup+0x74>
  8010c0:	89 d8                	mov    %ebx,%eax
  8010c2:	c1 e8 0c             	shr    $0xc,%eax
  8010c5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010cc:	f6 c2 01             	test   $0x1,%dl
  8010cf:	75 39                	jne    80110a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010d4:	89 d0                	mov    %edx,%eax
  8010d6:	c1 e8 0c             	shr    $0xc,%eax
  8010d9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010e0:	83 ec 0c             	sub    $0xc,%esp
  8010e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8010e8:	50                   	push   %eax
  8010e9:	56                   	push   %esi
  8010ea:	6a 00                	push   $0x0
  8010ec:	52                   	push   %edx
  8010ed:	6a 00                	push   $0x0
  8010ef:	e8 00 fb ff ff       	call   800bf4 <sys_page_map>
  8010f4:	89 c3                	mov    %eax,%ebx
  8010f6:	83 c4 20             	add    $0x20,%esp
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	78 31                	js     80112e <dup+0xd1>
		goto err;

	return newfdnum;
  8010fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801100:	89 d8                	mov    %ebx,%eax
  801102:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5f                   	pop    %edi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80110a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	25 07 0e 00 00       	and    $0xe07,%eax
  801119:	50                   	push   %eax
  80111a:	57                   	push   %edi
  80111b:	6a 00                	push   $0x0
  80111d:	53                   	push   %ebx
  80111e:	6a 00                	push   $0x0
  801120:	e8 cf fa ff ff       	call   800bf4 <sys_page_map>
  801125:	89 c3                	mov    %eax,%ebx
  801127:	83 c4 20             	add    $0x20,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	79 a3                	jns    8010d1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	56                   	push   %esi
  801132:	6a 00                	push   $0x0
  801134:	e8 fd fa ff ff       	call   800c36 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801139:	83 c4 08             	add    $0x8,%esp
  80113c:	57                   	push   %edi
  80113d:	6a 00                	push   $0x0
  80113f:	e8 f2 fa ff ff       	call   800c36 <sys_page_unmap>
	return r;
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	eb b7                	jmp    801100 <dup+0xa3>

00801149 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	53                   	push   %ebx
  80114d:	83 ec 14             	sub    $0x14,%esp
  801150:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801153:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801156:	50                   	push   %eax
  801157:	53                   	push   %ebx
  801158:	e8 7f fd ff ff       	call   800edc <fd_lookup>
  80115d:	83 c4 08             	add    $0x8,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	78 3f                	js     8011a3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801164:	83 ec 08             	sub    $0x8,%esp
  801167:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80116a:	50                   	push   %eax
  80116b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116e:	ff 30                	pushl  (%eax)
  801170:	e8 be fd ff ff       	call   800f33 <dev_lookup>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	78 27                	js     8011a3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 42 08             	mov    0x8(%edx),%eax
  801182:	83 e0 03             	and    $0x3,%eax
  801185:	83 f8 01             	cmp    $0x1,%eax
  801188:	74 1e                	je     8011a8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118d:	8b 40 08             	mov    0x8(%eax),%eax
  801190:	85 c0                	test   %eax,%eax
  801192:	74 35                	je     8011c9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	ff 75 10             	pushl  0x10(%ebp)
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	52                   	push   %edx
  80119e:	ff d0                	call   *%eax
  8011a0:	83 c4 10             	add    $0x10,%esp
}
  8011a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011a8:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ad:	8b 40 48             	mov    0x48(%eax),%eax
  8011b0:	83 ec 04             	sub    $0x4,%esp
  8011b3:	53                   	push   %ebx
  8011b4:	50                   	push   %eax
  8011b5:	68 0d 29 80 00       	push   $0x80290d
  8011ba:	e8 35 f0 ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  8011bf:	83 c4 10             	add    $0x10,%esp
  8011c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c7:	eb da                	jmp    8011a3 <read+0x5a>
		return -E_NOT_SUPP;
  8011c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011ce:	eb d3                	jmp    8011a3 <read+0x5a>

008011d0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011dc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e4:	39 f3                	cmp    %esi,%ebx
  8011e6:	73 25                	jae    80120d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011e8:	83 ec 04             	sub    $0x4,%esp
  8011eb:	89 f0                	mov    %esi,%eax
  8011ed:	29 d8                	sub    %ebx,%eax
  8011ef:	50                   	push   %eax
  8011f0:	89 d8                	mov    %ebx,%eax
  8011f2:	03 45 0c             	add    0xc(%ebp),%eax
  8011f5:	50                   	push   %eax
  8011f6:	57                   	push   %edi
  8011f7:	e8 4d ff ff ff       	call   801149 <read>
		if (m < 0)
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 08                	js     80120b <readn+0x3b>
			return m;
		if (m == 0)
  801203:	85 c0                	test   %eax,%eax
  801205:	74 06                	je     80120d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801207:	01 c3                	add    %eax,%ebx
  801209:	eb d9                	jmp    8011e4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80120b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80120d:	89 d8                	mov    %ebx,%eax
  80120f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801212:	5b                   	pop    %ebx
  801213:	5e                   	pop    %esi
  801214:	5f                   	pop    %edi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	53                   	push   %ebx
  80121b:	83 ec 14             	sub    $0x14,%esp
  80121e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801221:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	53                   	push   %ebx
  801226:	e8 b1 fc ff ff       	call   800edc <fd_lookup>
  80122b:	83 c4 08             	add    $0x8,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 3a                	js     80126c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801238:	50                   	push   %eax
  801239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123c:	ff 30                	pushl  (%eax)
  80123e:	e8 f0 fc ff ff       	call   800f33 <dev_lookup>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	78 22                	js     80126c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80124a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801251:	74 1e                	je     801271 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801256:	8b 52 0c             	mov    0xc(%edx),%edx
  801259:	85 d2                	test   %edx,%edx
  80125b:	74 35                	je     801292 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80125d:	83 ec 04             	sub    $0x4,%esp
  801260:	ff 75 10             	pushl  0x10(%ebp)
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	50                   	push   %eax
  801267:	ff d2                	call   *%edx
  801269:	83 c4 10             	add    $0x10,%esp
}
  80126c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80126f:	c9                   	leave  
  801270:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801271:	a1 04 40 80 00       	mov    0x804004,%eax
  801276:	8b 40 48             	mov    0x48(%eax),%eax
  801279:	83 ec 04             	sub    $0x4,%esp
  80127c:	53                   	push   %ebx
  80127d:	50                   	push   %eax
  80127e:	68 29 29 80 00       	push   $0x802929
  801283:	e8 6c ef ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  801288:	83 c4 10             	add    $0x10,%esp
  80128b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801290:	eb da                	jmp    80126c <write+0x55>
		return -E_NOT_SUPP;
  801292:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801297:	eb d3                	jmp    80126c <write+0x55>

00801299 <seek>:

int
seek(int fdnum, off_t offset)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80129f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012a2:	50                   	push   %eax
  8012a3:	ff 75 08             	pushl  0x8(%ebp)
  8012a6:	e8 31 fc ff ff       	call   800edc <fd_lookup>
  8012ab:	83 c4 08             	add    $0x8,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 0e                	js     8012c0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    

008012c2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 14             	sub    $0x14,%esp
  8012c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012cf:	50                   	push   %eax
  8012d0:	53                   	push   %ebx
  8012d1:	e8 06 fc ff ff       	call   800edc <fd_lookup>
  8012d6:	83 c4 08             	add    $0x8,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	78 37                	js     801314 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e3:	50                   	push   %eax
  8012e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e7:	ff 30                	pushl  (%eax)
  8012e9:	e8 45 fc ff ff       	call   800f33 <dev_lookup>
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	78 1f                	js     801314 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012fc:	74 1b                	je     801319 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801301:	8b 52 18             	mov    0x18(%edx),%edx
  801304:	85 d2                	test   %edx,%edx
  801306:	74 32                	je     80133a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801308:	83 ec 08             	sub    $0x8,%esp
  80130b:	ff 75 0c             	pushl  0xc(%ebp)
  80130e:	50                   	push   %eax
  80130f:	ff d2                	call   *%edx
  801311:	83 c4 10             	add    $0x10,%esp
}
  801314:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801317:	c9                   	leave  
  801318:	c3                   	ret    
			thisenv->env_id, fdnum);
  801319:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80131e:	8b 40 48             	mov    0x48(%eax),%eax
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	53                   	push   %ebx
  801325:	50                   	push   %eax
  801326:	68 ec 28 80 00       	push   $0x8028ec
  80132b:	e8 c4 ee ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801338:	eb da                	jmp    801314 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80133a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133f:	eb d3                	jmp    801314 <ftruncate+0x52>

00801341 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	53                   	push   %ebx
  801345:	83 ec 14             	sub    $0x14,%esp
  801348:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80134b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80134e:	50                   	push   %eax
  80134f:	ff 75 08             	pushl  0x8(%ebp)
  801352:	e8 85 fb ff ff       	call   800edc <fd_lookup>
  801357:	83 c4 08             	add    $0x8,%esp
  80135a:	85 c0                	test   %eax,%eax
  80135c:	78 4b                	js     8013a9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801364:	50                   	push   %eax
  801365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801368:	ff 30                	pushl  (%eax)
  80136a:	e8 c4 fb ff ff       	call   800f33 <dev_lookup>
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	78 33                	js     8013a9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801379:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80137d:	74 2f                	je     8013ae <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80137f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801382:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801389:	00 00 00 
	stat->st_type = 0;
  80138c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801393:	00 00 00 
	stat->st_dev = dev;
  801396:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80139c:	83 ec 08             	sub    $0x8,%esp
  80139f:	53                   	push   %ebx
  8013a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8013a3:	ff 50 14             	call   *0x14(%eax)
  8013a6:	83 c4 10             	add    $0x10,%esp
}
  8013a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    
		return -E_NOT_SUPP;
  8013ae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b3:	eb f4                	jmp    8013a9 <fstat+0x68>

008013b5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	56                   	push   %esi
  8013b9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	6a 00                	push   $0x0
  8013bf:	ff 75 08             	pushl  0x8(%ebp)
  8013c2:	e8 34 02 00 00       	call   8015fb <open>
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 1b                	js     8013eb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013d0:	83 ec 08             	sub    $0x8,%esp
  8013d3:	ff 75 0c             	pushl  0xc(%ebp)
  8013d6:	50                   	push   %eax
  8013d7:	e8 65 ff ff ff       	call   801341 <fstat>
  8013dc:	89 c6                	mov    %eax,%esi
	close(fd);
  8013de:	89 1c 24             	mov    %ebx,(%esp)
  8013e1:	e8 29 fc ff ff       	call   80100f <close>
	return r;
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	89 f3                	mov    %esi,%ebx
}
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f0:	5b                   	pop    %ebx
  8013f1:	5e                   	pop    %esi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	56                   	push   %esi
  8013f8:	53                   	push   %ebx
  8013f9:	89 c6                	mov    %eax,%esi
  8013fb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013fd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801404:	74 27                	je     80142d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801406:	6a 07                	push   $0x7
  801408:	68 00 50 80 00       	push   $0x805000
  80140d:	56                   	push   %esi
  80140e:	ff 35 00 40 80 00    	pushl  0x804000
  801414:	e8 ca 0d 00 00       	call   8021e3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801419:	83 c4 0c             	add    $0xc,%esp
  80141c:	6a 00                	push   $0x0
  80141e:	53                   	push   %ebx
  80141f:	6a 00                	push   $0x0
  801421:	e8 34 0d 00 00       	call   80215a <ipc_recv>
}
  801426:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801429:	5b                   	pop    %ebx
  80142a:	5e                   	pop    %esi
  80142b:	5d                   	pop    %ebp
  80142c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80142d:	83 ec 0c             	sub    $0xc,%esp
  801430:	6a 01                	push   $0x1
  801432:	e8 08 0e 00 00       	call   80223f <ipc_find_env>
  801437:	a3 00 40 80 00       	mov    %eax,0x804000
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	eb c5                	jmp    801406 <fsipc+0x12>

00801441 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8b 40 0c             	mov    0xc(%eax),%eax
  80144d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801452:	8b 45 0c             	mov    0xc(%ebp),%eax
  801455:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80145a:	ba 00 00 00 00       	mov    $0x0,%edx
  80145f:	b8 02 00 00 00       	mov    $0x2,%eax
  801464:	e8 8b ff ff ff       	call   8013f4 <fsipc>
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <devfile_flush>:
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8b 40 0c             	mov    0xc(%eax),%eax
  801477:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80147c:	ba 00 00 00 00       	mov    $0x0,%edx
  801481:	b8 06 00 00 00       	mov    $0x6,%eax
  801486:	e8 69 ff ff ff       	call   8013f4 <fsipc>
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <devfile_stat>:
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	53                   	push   %ebx
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8b 40 0c             	mov    0xc(%eax),%eax
  80149d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8014ac:	e8 43 ff ff ff       	call   8013f4 <fsipc>
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 2c                	js     8014e1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	68 00 50 80 00       	push   $0x805000
  8014bd:	53                   	push   %ebx
  8014be:	e8 39 f3 ff ff       	call   8007fc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014c3:	a1 80 50 80 00       	mov    0x805080,%eax
  8014c8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8014ce:	a1 84 50 80 00       	mov    0x805084,%eax
  8014d3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <devfile_write>:
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	53                   	push   %ebx
  8014ea:	83 ec 04             	sub    $0x4,%esp
  8014ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8014f0:	89 d8                	mov    %ebx,%eax
  8014f2:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8014f8:	76 05                	jbe    8014ff <devfile_write+0x19>
  8014fa:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801502:	8b 52 0c             	mov    0xc(%edx),%edx
  801505:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80150b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	50                   	push   %eax
  801514:	ff 75 0c             	pushl  0xc(%ebp)
  801517:	68 08 50 80 00       	push   $0x805008
  80151c:	e8 4e f4 ff ff       	call   80096f <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801521:	ba 00 00 00 00       	mov    $0x0,%edx
  801526:	b8 04 00 00 00       	mov    $0x4,%eax
  80152b:	e8 c4 fe ff ff       	call   8013f4 <fsipc>
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	78 0b                	js     801542 <devfile_write+0x5c>
	assert(r <= n);
  801537:	39 c3                	cmp    %eax,%ebx
  801539:	72 0c                	jb     801547 <devfile_write+0x61>
	assert(r <= PGSIZE);
  80153b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801540:	7f 1e                	jg     801560 <devfile_write+0x7a>
}
  801542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801545:	c9                   	leave  
  801546:	c3                   	ret    
	assert(r <= n);
  801547:	68 58 29 80 00       	push   $0x802958
  80154c:	68 5f 29 80 00       	push   $0x80295f
  801551:	68 98 00 00 00       	push   $0x98
  801556:	68 74 29 80 00       	push   $0x802974
  80155b:	e8 81 eb ff ff       	call   8000e1 <_panic>
	assert(r <= PGSIZE);
  801560:	68 7f 29 80 00       	push   $0x80297f
  801565:	68 5f 29 80 00       	push   $0x80295f
  80156a:	68 99 00 00 00       	push   $0x99
  80156f:	68 74 29 80 00       	push   $0x802974
  801574:	e8 68 eb ff ff       	call   8000e1 <_panic>

00801579 <devfile_read>:
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	56                   	push   %esi
  80157d:	53                   	push   %ebx
  80157e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8b 40 0c             	mov    0xc(%eax),%eax
  801587:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80158c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801592:	ba 00 00 00 00       	mov    $0x0,%edx
  801597:	b8 03 00 00 00       	mov    $0x3,%eax
  80159c:	e8 53 fe ff ff       	call   8013f4 <fsipc>
  8015a1:	89 c3                	mov    %eax,%ebx
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 1f                	js     8015c6 <devfile_read+0x4d>
	assert(r <= n);
  8015a7:	39 c6                	cmp    %eax,%esi
  8015a9:	72 24                	jb     8015cf <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015ab:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015b0:	7f 33                	jg     8015e5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	50                   	push   %eax
  8015b6:	68 00 50 80 00       	push   $0x805000
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	e8 ac f3 ff ff       	call   80096f <memmove>
	return r;
  8015c3:	83 c4 10             	add    $0x10,%esp
}
  8015c6:	89 d8                	mov    %ebx,%eax
  8015c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015cb:	5b                   	pop    %ebx
  8015cc:	5e                   	pop    %esi
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    
	assert(r <= n);
  8015cf:	68 58 29 80 00       	push   $0x802958
  8015d4:	68 5f 29 80 00       	push   $0x80295f
  8015d9:	6a 7c                	push   $0x7c
  8015db:	68 74 29 80 00       	push   $0x802974
  8015e0:	e8 fc ea ff ff       	call   8000e1 <_panic>
	assert(r <= PGSIZE);
  8015e5:	68 7f 29 80 00       	push   $0x80297f
  8015ea:	68 5f 29 80 00       	push   $0x80295f
  8015ef:	6a 7d                	push   $0x7d
  8015f1:	68 74 29 80 00       	push   $0x802974
  8015f6:	e8 e6 ea ff ff       	call   8000e1 <_panic>

008015fb <open>:
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	56                   	push   %esi
  8015ff:	53                   	push   %ebx
  801600:	83 ec 1c             	sub    $0x1c,%esp
  801603:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801606:	56                   	push   %esi
  801607:	e8 bd f1 ff ff       	call   8007c9 <strlen>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801614:	7f 6c                	jg     801682 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801616:	83 ec 0c             	sub    $0xc,%esp
  801619:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161c:	50                   	push   %eax
  80161d:	e8 6b f8 ff ff       	call   800e8d <fd_alloc>
  801622:	89 c3                	mov    %eax,%ebx
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	85 c0                	test   %eax,%eax
  801629:	78 3c                	js     801667 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	56                   	push   %esi
  80162f:	68 00 50 80 00       	push   $0x805000
  801634:	e8 c3 f1 ff ff       	call   8007fc <strcpy>
	fsipcbuf.open.req_omode = mode;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801644:	b8 01 00 00 00       	mov    $0x1,%eax
  801649:	e8 a6 fd ff ff       	call   8013f4 <fsipc>
  80164e:	89 c3                	mov    %eax,%ebx
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	85 c0                	test   %eax,%eax
  801655:	78 19                	js     801670 <open+0x75>
	return fd2num(fd);
  801657:	83 ec 0c             	sub    $0xc,%esp
  80165a:	ff 75 f4             	pushl  -0xc(%ebp)
  80165d:	e8 04 f8 ff ff       	call   800e66 <fd2num>
  801662:	89 c3                	mov    %eax,%ebx
  801664:	83 c4 10             	add    $0x10,%esp
}
  801667:	89 d8                	mov    %ebx,%eax
  801669:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    
		fd_close(fd, 0);
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	6a 00                	push   $0x0
  801675:	ff 75 f4             	pushl  -0xc(%ebp)
  801678:	e8 0c f9 ff ff       	call   800f89 <fd_close>
		return r;
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	eb e5                	jmp    801667 <open+0x6c>
		return -E_BAD_PATH;
  801682:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801687:	eb de                	jmp    801667 <open+0x6c>

00801689 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80168f:	ba 00 00 00 00       	mov    $0x0,%edx
  801694:	b8 08 00 00 00       	mov    $0x8,%eax
  801699:	e8 56 fd ff ff       	call   8013f4 <fsipc>
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	57                   	push   %edi
  8016a4:	56                   	push   %esi
  8016a5:	53                   	push   %ebx
  8016a6:	81 ec 94 02 00 00    	sub    $0x294,%esp
  8016ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8016af:	6a 00                	push   $0x0
  8016b1:	ff 75 08             	pushl  0x8(%ebp)
  8016b4:	e8 42 ff ff ff       	call   8015fb <open>
  8016b9:	89 c1                	mov    %eax,%ecx
  8016bb:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	0f 88 ba 04 00 00    	js     801b86 <spawn+0x4e6>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 00 02 00 00       	push   $0x200
  8016d4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8016da:	50                   	push   %eax
  8016db:	51                   	push   %ecx
  8016dc:	e8 ef fa ff ff       	call   8011d0 <readn>
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8016e9:	0f 85 93 00 00 00    	jne    801782 <spawn+0xe2>
	    || elf->e_magic != ELF_MAGIC) {
  8016ef:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8016f6:	45 4c 46 
  8016f9:	0f 85 83 00 00 00    	jne    801782 <spawn+0xe2>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016ff:	b8 07 00 00 00       	mov    $0x7,%eax
  801704:	cd 30                	int    $0x30
  801706:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80170c:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801712:	85 c0                	test   %eax,%eax
  801714:	0f 88 77 04 00 00    	js     801b91 <spawn+0x4f1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80171a:	89 c2                	mov    %eax,%edx
  80171c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  801722:	89 d0                	mov    %edx,%eax
  801724:	c1 e0 05             	shl    $0x5,%eax
  801727:	29 d0                	sub    %edx,%eax
  801729:	8d 34 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%esi
  801730:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801736:	b9 11 00 00 00       	mov    $0x11,%ecx
  80173b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80173d:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801743:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801749:	ba 00 00 00 00       	mov    $0x0,%edx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
	string_size = 0;
  801753:	bf 00 00 00 00       	mov    $0x0,%edi
  801758:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80175b:	89 c3                	mov    %eax,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  80175d:	89 d9                	mov    %ebx,%ecx
  80175f:	8d 72 04             	lea    0x4(%edx),%esi
  801762:	8b 45 0c             	mov    0xc(%ebp),%eax
  801765:	8b 44 30 fc          	mov    -0x4(%eax,%esi,1),%eax
  801769:	85 c0                	test   %eax,%eax
  80176b:	74 48                	je     8017b5 <spawn+0x115>
		string_size += strlen(argv[argc]) + 1;
  80176d:	83 ec 0c             	sub    $0xc,%esp
  801770:	50                   	push   %eax
  801771:	e8 53 f0 ff ff       	call   8007c9 <strlen>
  801776:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  80177a:	43                   	inc    %ebx
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	89 f2                	mov    %esi,%edx
  801780:	eb db                	jmp    80175d <spawn+0xbd>
		close(fd);
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80178b:	e8 7f f8 ff ff       	call   80100f <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801790:	83 c4 0c             	add    $0xc,%esp
  801793:	68 7f 45 4c 46       	push   $0x464c457f
  801798:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80179e:	68 8b 29 80 00       	push   $0x80298b
  8017a3:	e8 4c ea ff ff       	call   8001f4 <cprintf>
		return -E_NOT_EXEC;
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
  8017b0:	e9 62 02 00 00       	jmp    801a17 <spawn+0x377>
  8017b5:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8017bb:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8017c1:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  8017c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8017ca:	be 00 10 40 00       	mov    $0x401000,%esi
  8017cf:	29 fe                	sub    %edi,%esi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8017d1:	89 f2                	mov    %esi,%edx
  8017d3:	83 e2 fc             	and    $0xfffffffc,%edx
  8017d6:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
  8017dd:	29 c2                	sub    %eax,%edx
  8017df:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8017e5:	8d 42 f8             	lea    -0x8(%edx),%eax
  8017e8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8017ed:	0f 86 a9 03 00 00    	jbe    801b9c <spawn+0x4fc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	6a 07                	push   $0x7
  8017f8:	68 00 00 40 00       	push   $0x400000
  8017fd:	6a 00                	push   $0x0
  8017ff:	e8 ad f3 ff ff       	call   800bb1 <sys_page_alloc>
  801804:	89 c7                	mov    %eax,%edi
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	85 c0                	test   %eax,%eax
  80180b:	0f 88 06 02 00 00    	js     801a17 <spawn+0x377>
  801811:	bf 00 00 00 00       	mov    $0x0,%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801816:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80181c:	7e 30                	jle    80184e <spawn+0x1ae>
		argv_store[i] = UTEMP2USTACK(string_store);
  80181e:	8d 86 00 d0 7f ee    	lea    -0x11803000(%esi),%eax
  801824:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  80182a:	89 04 b9             	mov    %eax,(%ecx,%edi,4)
		strcpy(string_store, argv[i]);
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	ff 34 bb             	pushl  (%ebx,%edi,4)
  801833:	56                   	push   %esi
  801834:	e8 c3 ef ff ff       	call   8007fc <strcpy>
		string_store += strlen(argv[i]) + 1;
  801839:	83 c4 04             	add    $0x4,%esp
  80183c:	ff 34 bb             	pushl  (%ebx,%edi,4)
  80183f:	e8 85 ef ff ff       	call   8007c9 <strlen>
  801844:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (i = 0; i < argc; i++) {
  801848:	47                   	inc    %edi
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	eb c8                	jmp    801816 <spawn+0x176>
	}
	argv_store[argc] = 0;
  80184e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801854:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80185a:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801861:	81 fe 00 10 40 00    	cmp    $0x401000,%esi
  801867:	0f 85 8c 00 00 00    	jne    8018f9 <spawn+0x259>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80186d:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801873:	89 c8                	mov    %ecx,%eax
  801875:	2d 00 30 80 11       	sub    $0x11803000,%eax
  80187a:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  80187d:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801883:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801886:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  80188c:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	6a 07                	push   $0x7
  801897:	68 00 d0 bf ee       	push   $0xeebfd000
  80189c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8018a2:	68 00 00 40 00       	push   $0x400000
  8018a7:	6a 00                	push   $0x0
  8018a9:	e8 46 f3 ff ff       	call   800bf4 <sys_page_map>
  8018ae:	89 c7                	mov    %eax,%edi
  8018b0:	83 c4 20             	add    $0x20,%esp
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	0f 88 3e 03 00 00    	js     801bf9 <spawn+0x559>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8018bb:	83 ec 08             	sub    $0x8,%esp
  8018be:	68 00 00 40 00       	push   $0x400000
  8018c3:	6a 00                	push   $0x0
  8018c5:	e8 6c f3 ff ff       	call   800c36 <sys_page_unmap>
  8018ca:	89 c7                	mov    %eax,%edi
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	0f 88 22 03 00 00    	js     801bf9 <spawn+0x559>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8018d7:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8018dd:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8018e4:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018ea:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  8018f1:	00 00 00 
  8018f4:	e9 4a 01 00 00       	jmp    801a43 <spawn+0x3a3>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018f9:	68 18 2a 80 00       	push   $0x802a18
  8018fe:	68 5f 29 80 00       	push   $0x80295f
  801903:	68 f1 00 00 00       	push   $0xf1
  801908:	68 a5 29 80 00       	push   $0x8029a5
  80190d:	e8 cf e7 ff ff       	call   8000e1 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	6a 07                	push   $0x7
  801917:	68 00 00 40 00       	push   $0x400000
  80191c:	6a 00                	push   $0x0
  80191e:	e8 8e f2 ff ff       	call   800bb1 <sys_page_alloc>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	0f 88 78 02 00 00    	js     801ba6 <spawn+0x506>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80192e:	83 ec 08             	sub    $0x8,%esp
  801931:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801937:	01 f8                	add    %edi,%eax
  801939:	50                   	push   %eax
  80193a:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801940:	e8 54 f9 ff ff       	call   801299 <seek>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	0f 88 5d 02 00 00    	js     801bad <spawn+0x50d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801959:	29 f8                	sub    %edi,%eax
  80195b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801960:	76 05                	jbe    801967 <spawn+0x2c7>
  801962:	b8 00 10 00 00       	mov    $0x1000,%eax
  801967:	50                   	push   %eax
  801968:	68 00 00 40 00       	push   $0x400000
  80196d:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801973:	e8 58 f8 ff ff       	call   8011d0 <readn>
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	85 c0                	test   %eax,%eax
  80197d:	0f 88 31 02 00 00    	js     801bb4 <spawn+0x514>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801983:	83 ec 0c             	sub    $0xc,%esp
  801986:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80198c:	56                   	push   %esi
  80198d:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801993:	68 00 00 40 00       	push   $0x400000
  801998:	6a 00                	push   $0x0
  80199a:	e8 55 f2 ff ff       	call   800bf4 <sys_page_map>
  80199f:	83 c4 20             	add    $0x20,%esp
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 7b                	js     801a21 <spawn+0x381>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	68 00 00 40 00       	push   $0x400000
  8019ae:	6a 00                	push   $0x0
  8019b0:	e8 81 f2 ff ff       	call   800c36 <sys_page_unmap>
  8019b5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8019b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019be:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8019c4:	89 df                	mov    %ebx,%edi
  8019c6:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  8019cc:	73 68                	jae    801a36 <spawn+0x396>
		if (i >= filesz) {
  8019ce:	3b 9d 94 fd ff ff    	cmp    -0x26c(%ebp),%ebx
  8019d4:	0f 82 38 ff ff ff    	jb     801912 <spawn+0x272>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8019e3:	56                   	push   %esi
  8019e4:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8019ea:	e8 c2 f1 ff ff       	call   800bb1 <sys_page_alloc>
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	79 c2                	jns    8019b8 <spawn+0x318>
  8019f6:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8019f8:	83 ec 0c             	sub    $0xc,%esp
  8019fb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a01:	e8 4b f1 ff ff       	call   800b51 <sys_env_destroy>
	close(fd);
  801a06:	83 c4 04             	add    $0x4,%esp
  801a09:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a0f:	e8 fb f5 ff ff       	call   80100f <close>
	return r;
  801a14:	83 c4 10             	add    $0x10,%esp
}
  801a17:	89 f8                	mov    %edi,%eax
  801a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a1c:	5b                   	pop    %ebx
  801a1d:	5e                   	pop    %esi
  801a1e:	5f                   	pop    %edi
  801a1f:	5d                   	pop    %ebp
  801a20:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801a21:	50                   	push   %eax
  801a22:	68 b1 29 80 00       	push   $0x8029b1
  801a27:	68 24 01 00 00       	push   $0x124
  801a2c:	68 a5 29 80 00       	push   $0x8029a5
  801a31:	e8 ab e6 ff ff       	call   8000e1 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a36:	ff 85 78 fd ff ff    	incl   -0x288(%ebp)
  801a3c:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801a43:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801a4a:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801a50:	7d 71                	jge    801ac3 <spawn+0x423>
		if (ph->p_type != ELF_PROG_LOAD)
  801a52:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801a58:	83 38 01             	cmpl   $0x1,(%eax)
  801a5b:	75 d9                	jne    801a36 <spawn+0x396>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801a5d:	89 c1                	mov    %eax,%ecx
  801a5f:	8b 40 18             	mov    0x18(%eax),%eax
  801a62:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801a65:	83 f8 01             	cmp    $0x1,%eax
  801a68:	19 c0                	sbb    %eax,%eax
  801a6a:	83 e0 fe             	and    $0xfffffffe,%eax
  801a6d:	83 c0 07             	add    $0x7,%eax
  801a70:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801a76:	89 c8                	mov    %ecx,%eax
  801a78:	8b 49 04             	mov    0x4(%ecx),%ecx
  801a7b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801a81:	8b 50 10             	mov    0x10(%eax),%edx
  801a84:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801a8a:	8b 78 14             	mov    0x14(%eax),%edi
  801a8d:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
  801a93:	8b 70 08             	mov    0x8(%eax),%esi
	if ((i = PGOFF(va))) {
  801a96:	89 f0                	mov    %esi,%eax
  801a98:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a9d:	74 1a                	je     801ab9 <spawn+0x419>
		va -= i;
  801a9f:	29 c6                	sub    %eax,%esi
		memsz += i;
  801aa1:	01 c7                	add    %eax,%edi
  801aa3:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
		filesz += i;
  801aa9:	01 c2                	add    %eax,%edx
  801aab:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
		fileoffset -= i;
  801ab1:	29 c1                	sub    %eax,%ecx
  801ab3:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801ab9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801abe:	e9 01 ff ff ff       	jmp    8019c4 <spawn+0x324>
	close(fd);
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801acc:	e8 3e f5 ff ff       	call   80100f <close>
  801ad1:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  801ad4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad9:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801adf:	eb 12                	jmp    801af3 <spawn+0x453>
  801ae1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ae7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801aed:	0f 84 c8 00 00 00    	je     801bbb <spawn+0x51b>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U) && (uvpt[PGNUM(pn)] & PTE_SHARE)) {
  801af3:	89 d8                	mov    %ebx,%eax
  801af5:	c1 e8 16             	shr    $0x16,%eax
  801af8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801aff:	a8 01                	test   $0x1,%al
  801b01:	74 de                	je     801ae1 <spawn+0x441>
  801b03:	89 d8                	mov    %ebx,%eax
  801b05:	c1 e8 0c             	shr    $0xc,%eax
  801b08:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b0f:	f6 c2 04             	test   $0x4,%dl
  801b12:	74 cd                	je     801ae1 <spawn+0x441>
  801b14:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b1b:	f6 c6 04             	test   $0x4,%dh
  801b1e:	74 c1                	je     801ae1 <spawn+0x441>
			if (sys_page_map(sys_getenvid(), (void*)(pn), child, (void*)(pn), uvpt[PGNUM(pn)] & PTE_SYSCALL) < 0) {
  801b20:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  801b27:	e8 66 f0 ff ff       	call   800b92 <sys_getenvid>
  801b2c:	83 ec 0c             	sub    $0xc,%esp
  801b2f:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801b35:	57                   	push   %edi
  801b36:	53                   	push   %ebx
  801b37:	56                   	push   %esi
  801b38:	53                   	push   %ebx
  801b39:	50                   	push   %eax
  801b3a:	e8 b5 f0 ff ff       	call   800bf4 <sys_page_map>
  801b3f:	83 c4 20             	add    $0x20,%esp
  801b42:	85 c0                	test   %eax,%eax
  801b44:	79 9b                	jns    801ae1 <spawn+0x441>
		panic("copy_shared_pages: %e", r);
  801b46:	6a ff                	push   $0xffffffff
  801b48:	68 ff 29 80 00       	push   $0x8029ff
  801b4d:	68 82 00 00 00       	push   $0x82
  801b52:	68 a5 29 80 00       	push   $0x8029a5
  801b57:	e8 85 e5 ff ff       	call   8000e1 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  801b5c:	50                   	push   %eax
  801b5d:	68 ce 29 80 00       	push   $0x8029ce
  801b62:	68 85 00 00 00       	push   $0x85
  801b67:	68 a5 29 80 00       	push   $0x8029a5
  801b6c:	e8 70 e5 ff ff       	call   8000e1 <_panic>
		panic("sys_env_set_status: %e", r);
  801b71:	50                   	push   %eax
  801b72:	68 e8 29 80 00       	push   $0x8029e8
  801b77:	68 88 00 00 00       	push   $0x88
  801b7c:	68 a5 29 80 00       	push   $0x8029a5
  801b81:	e8 5b e5 ff ff       	call   8000e1 <_panic>
		return r;
  801b86:	8b bd 8c fd ff ff    	mov    -0x274(%ebp),%edi
  801b8c:	e9 86 fe ff ff       	jmp    801a17 <spawn+0x377>
		return r;
  801b91:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  801b97:	e9 7b fe ff ff       	jmp    801a17 <spawn+0x377>
		return -E_NO_MEM;
  801b9c:	bf fc ff ff ff       	mov    $0xfffffffc,%edi
  801ba1:	e9 71 fe ff ff       	jmp    801a17 <spawn+0x377>
  801ba6:	89 c7                	mov    %eax,%edi
  801ba8:	e9 4b fe ff ff       	jmp    8019f8 <spawn+0x358>
  801bad:	89 c7                	mov    %eax,%edi
  801baf:	e9 44 fe ff ff       	jmp    8019f8 <spawn+0x358>
  801bb4:	89 c7                	mov    %eax,%edi
  801bb6:	e9 3d fe ff ff       	jmp    8019f8 <spawn+0x358>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801bbb:	83 ec 08             	sub    $0x8,%esp
  801bbe:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801bc4:	50                   	push   %eax
  801bc5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bcb:	e8 4a f1 ff ff       	call   800d1a <sys_env_set_trapframe>
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	78 85                	js     801b5c <spawn+0x4bc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801bd7:	83 ec 08             	sub    $0x8,%esp
  801bda:	6a 02                	push   $0x2
  801bdc:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801be2:	e8 b0 f0 ff ff       	call   800c97 <sys_env_set_status>
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 83                	js     801b71 <spawn+0x4d1>
	return child;
  801bee:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  801bf4:	e9 1e fe ff ff       	jmp    801a17 <spawn+0x377>
	sys_page_unmap(0, UTEMP);
  801bf9:	83 ec 08             	sub    $0x8,%esp
  801bfc:	68 00 00 40 00       	push   $0x400000
  801c01:	6a 00                	push   $0x0
  801c03:	e8 2e f0 ff ff       	call   800c36 <sys_page_unmap>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	e9 07 fe ff ff       	jmp    801a17 <spawn+0x377>

00801c10 <spawnl>:
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	57                   	push   %edi
  801c14:	56                   	push   %esi
  801c15:	53                   	push   %ebx
  801c16:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801c19:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801c1c:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801c21:	eb 03                	jmp    801c26 <spawnl+0x16>
		argc++;
  801c23:	40                   	inc    %eax
	while(va_arg(vl, void *) != NULL)
  801c24:	89 ca                	mov    %ecx,%edx
  801c26:	8d 4a 04             	lea    0x4(%edx),%ecx
  801c29:	83 3a 00             	cmpl   $0x0,(%edx)
  801c2c:	75 f5                	jne    801c23 <spawnl+0x13>
	const char *argv[argc+2];
  801c2e:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801c35:	83 e2 f0             	and    $0xfffffff0,%edx
  801c38:	29 d4                	sub    %edx,%esp
  801c3a:	8d 54 24 03          	lea    0x3(%esp),%edx
  801c3e:	c1 ea 02             	shr    $0x2,%edx
  801c41:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801c48:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801c4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c4d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801c54:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801c5b:	00 
	va_start(vl, arg0);
  801c5c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801c5f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801c61:	b8 00 00 00 00       	mov    $0x0,%eax
  801c66:	eb 09                	jmp    801c71 <spawnl+0x61>
		argv[i+1] = va_arg(vl, const char *);
  801c68:	40                   	inc    %eax
  801c69:	8b 39                	mov    (%ecx),%edi
  801c6b:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801c6e:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801c71:	39 d0                	cmp    %edx,%eax
  801c73:	75 f3                	jne    801c68 <spawnl+0x58>
	return spawn(prog, argv);
  801c75:	83 ec 08             	sub    $0x8,%esp
  801c78:	56                   	push   %esi
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 1f fa ff ff       	call   8016a0 <spawn>
}
  801c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    

00801c89 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	56                   	push   %esi
  801c8d:	53                   	push   %ebx
  801c8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c91:	83 ec 0c             	sub    $0xc,%esp
  801c94:	ff 75 08             	pushl  0x8(%ebp)
  801c97:	e8 da f1 ff ff       	call   800e76 <fd2data>
  801c9c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c9e:	83 c4 08             	add    $0x8,%esp
  801ca1:	68 3e 2a 80 00       	push   $0x802a3e
  801ca6:	53                   	push   %ebx
  801ca7:	e8 50 eb ff ff       	call   8007fc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cac:	8b 46 04             	mov    0x4(%esi),%eax
  801caf:	2b 06                	sub    (%esi),%eax
  801cb1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801cb7:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801cbe:	10 00 00 
	stat->st_dev = &devpipe;
  801cc1:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801cc8:	30 80 00 
	return 0;
}
  801ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5d                   	pop    %ebp
  801cd6:	c3                   	ret    

00801cd7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 0c             	sub    $0xc,%esp
  801cde:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ce1:	53                   	push   %ebx
  801ce2:	6a 00                	push   $0x0
  801ce4:	e8 4d ef ff ff       	call   800c36 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ce9:	89 1c 24             	mov    %ebx,(%esp)
  801cec:	e8 85 f1 ff ff       	call   800e76 <fd2data>
  801cf1:	83 c4 08             	add    $0x8,%esp
  801cf4:	50                   	push   %eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	e8 3a ef ff ff       	call   800c36 <sys_page_unmap>
}
  801cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <_pipeisclosed>:
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	57                   	push   %edi
  801d05:	56                   	push   %esi
  801d06:	53                   	push   %ebx
  801d07:	83 ec 1c             	sub    $0x1c,%esp
  801d0a:	89 c7                	mov    %eax,%edi
  801d0c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d0e:	a1 04 40 80 00       	mov    0x804004,%eax
  801d13:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	57                   	push   %edi
  801d1a:	e8 62 05 00 00       	call   802281 <pageref>
  801d1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d22:	89 34 24             	mov    %esi,(%esp)
  801d25:	e8 57 05 00 00       	call   802281 <pageref>
		nn = thisenv->env_runs;
  801d2a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d30:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d33:	83 c4 10             	add    $0x10,%esp
  801d36:	39 cb                	cmp    %ecx,%ebx
  801d38:	74 1b                	je     801d55 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d3a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d3d:	75 cf                	jne    801d0e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d3f:	8b 42 58             	mov    0x58(%edx),%eax
  801d42:	6a 01                	push   $0x1
  801d44:	50                   	push   %eax
  801d45:	53                   	push   %ebx
  801d46:	68 45 2a 80 00       	push   $0x802a45
  801d4b:	e8 a4 e4 ff ff       	call   8001f4 <cprintf>
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	eb b9                	jmp    801d0e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d55:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d58:	0f 94 c0             	sete   %al
  801d5b:	0f b6 c0             	movzbl %al,%eax
}
  801d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5f                   	pop    %edi
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    

00801d66 <devpipe_write>:
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	57                   	push   %edi
  801d6a:	56                   	push   %esi
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 18             	sub    $0x18,%esp
  801d6f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d72:	56                   	push   %esi
  801d73:	e8 fe f0 ff ff       	call   800e76 <fd2data>
  801d78:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d82:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d85:	74 41                	je     801dc8 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d87:	8b 53 04             	mov    0x4(%ebx),%edx
  801d8a:	8b 03                	mov    (%ebx),%eax
  801d8c:	83 c0 20             	add    $0x20,%eax
  801d8f:	39 c2                	cmp    %eax,%edx
  801d91:	72 14                	jb     801da7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d93:	89 da                	mov    %ebx,%edx
  801d95:	89 f0                	mov    %esi,%eax
  801d97:	e8 65 ff ff ff       	call   801d01 <_pipeisclosed>
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	75 2c                	jne    801dcc <devpipe_write+0x66>
			sys_yield();
  801da0:	e8 d3 ee ff ff       	call   800c78 <sys_yield>
  801da5:	eb e0                	jmp    801d87 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801daa:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801dad:	89 d0                	mov    %edx,%eax
  801daf:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801db4:	78 0b                	js     801dc1 <devpipe_write+0x5b>
  801db6:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801dba:	42                   	inc    %edx
  801dbb:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dbe:	47                   	inc    %edi
  801dbf:	eb c1                	jmp    801d82 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dc1:	48                   	dec    %eax
  801dc2:	83 c8 e0             	or     $0xffffffe0,%eax
  801dc5:	40                   	inc    %eax
  801dc6:	eb ee                	jmp    801db6 <devpipe_write+0x50>
	return i;
  801dc8:	89 f8                	mov    %edi,%eax
  801dca:	eb 05                	jmp    801dd1 <devpipe_write+0x6b>
				return 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd4:	5b                   	pop    %ebx
  801dd5:	5e                   	pop    %esi
  801dd6:	5f                   	pop    %edi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    

00801dd9 <devpipe_read>:
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	57                   	push   %edi
  801ddd:	56                   	push   %esi
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 18             	sub    $0x18,%esp
  801de2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801de5:	57                   	push   %edi
  801de6:	e8 8b f0 ff ff       	call   800e76 <fd2data>
  801deb:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801ded:	83 c4 10             	add    $0x10,%esp
  801df0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801df5:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801df8:	74 46                	je     801e40 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801dfa:	8b 06                	mov    (%esi),%eax
  801dfc:	3b 46 04             	cmp    0x4(%esi),%eax
  801dff:	75 22                	jne    801e23 <devpipe_read+0x4a>
			if (i > 0)
  801e01:	85 db                	test   %ebx,%ebx
  801e03:	74 0a                	je     801e0f <devpipe_read+0x36>
				return i;
  801e05:	89 d8                	mov    %ebx,%eax
}
  801e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0a:	5b                   	pop    %ebx
  801e0b:	5e                   	pop    %esi
  801e0c:	5f                   	pop    %edi
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801e0f:	89 f2                	mov    %esi,%edx
  801e11:	89 f8                	mov    %edi,%eax
  801e13:	e8 e9 fe ff ff       	call   801d01 <_pipeisclosed>
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	75 28                	jne    801e44 <devpipe_read+0x6b>
			sys_yield();
  801e1c:	e8 57 ee ff ff       	call   800c78 <sys_yield>
  801e21:	eb d7                	jmp    801dfa <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e23:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801e28:	78 0f                	js     801e39 <devpipe_read+0x60>
  801e2a:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e31:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801e34:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801e36:	43                   	inc    %ebx
  801e37:	eb bc                	jmp    801df5 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e39:	48                   	dec    %eax
  801e3a:	83 c8 e0             	or     $0xffffffe0,%eax
  801e3d:	40                   	inc    %eax
  801e3e:	eb ea                	jmp    801e2a <devpipe_read+0x51>
	return i;
  801e40:	89 d8                	mov    %ebx,%eax
  801e42:	eb c3                	jmp    801e07 <devpipe_read+0x2e>
				return 0;
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	eb bc                	jmp    801e07 <devpipe_read+0x2e>

00801e4b <pipe>:
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	56                   	push   %esi
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e56:	50                   	push   %eax
  801e57:	e8 31 f0 ff ff       	call   800e8d <fd_alloc>
  801e5c:	89 c3                	mov    %eax,%ebx
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	85 c0                	test   %eax,%eax
  801e63:	0f 88 2a 01 00 00    	js     801f93 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	68 07 04 00 00       	push   $0x407
  801e71:	ff 75 f4             	pushl  -0xc(%ebp)
  801e74:	6a 00                	push   $0x0
  801e76:	e8 36 ed ff ff       	call   800bb1 <sys_page_alloc>
  801e7b:	89 c3                	mov    %eax,%ebx
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	85 c0                	test   %eax,%eax
  801e82:	0f 88 0b 01 00 00    	js     801f93 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e8e:	50                   	push   %eax
  801e8f:	e8 f9 ef ff ff       	call   800e8d <fd_alloc>
  801e94:	89 c3                	mov    %eax,%ebx
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	0f 88 e2 00 00 00    	js     801f83 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea1:	83 ec 04             	sub    $0x4,%esp
  801ea4:	68 07 04 00 00       	push   $0x407
  801ea9:	ff 75 f0             	pushl  -0x10(%ebp)
  801eac:	6a 00                	push   $0x0
  801eae:	e8 fe ec ff ff       	call   800bb1 <sys_page_alloc>
  801eb3:	89 c3                	mov    %eax,%ebx
  801eb5:	83 c4 10             	add    $0x10,%esp
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	0f 88 c3 00 00 00    	js     801f83 <pipe+0x138>
	va = fd2data(fd0);
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec6:	e8 ab ef ff ff       	call   800e76 <fd2data>
  801ecb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ecd:	83 c4 0c             	add    $0xc,%esp
  801ed0:	68 07 04 00 00       	push   $0x407
  801ed5:	50                   	push   %eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	e8 d4 ec ff ff       	call   800bb1 <sys_page_alloc>
  801edd:	89 c3                	mov    %eax,%ebx
  801edf:	83 c4 10             	add    $0x10,%esp
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	0f 88 89 00 00 00    	js     801f73 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eea:	83 ec 0c             	sub    $0xc,%esp
  801eed:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef0:	e8 81 ef ff ff       	call   800e76 <fd2data>
  801ef5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801efc:	50                   	push   %eax
  801efd:	6a 00                	push   $0x0
  801eff:	56                   	push   %esi
  801f00:	6a 00                	push   $0x0
  801f02:	e8 ed ec ff ff       	call   800bf4 <sys_page_map>
  801f07:	89 c3                	mov    %eax,%ebx
  801f09:	83 c4 20             	add    $0x20,%esp
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	78 55                	js     801f65 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801f10:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801f25:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f33:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f40:	e8 21 ef ff ff       	call   800e66 <fd2num>
  801f45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f48:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f4a:	83 c4 04             	add    $0x4,%esp
  801f4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f50:	e8 11 ef ff ff       	call   800e66 <fd2num>
  801f55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f58:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f63:	eb 2e                	jmp    801f93 <pipe+0x148>
	sys_page_unmap(0, va);
  801f65:	83 ec 08             	sub    $0x8,%esp
  801f68:	56                   	push   %esi
  801f69:	6a 00                	push   $0x0
  801f6b:	e8 c6 ec ff ff       	call   800c36 <sys_page_unmap>
  801f70:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f73:	83 ec 08             	sub    $0x8,%esp
  801f76:	ff 75 f0             	pushl  -0x10(%ebp)
  801f79:	6a 00                	push   $0x0
  801f7b:	e8 b6 ec ff ff       	call   800c36 <sys_page_unmap>
  801f80:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f83:	83 ec 08             	sub    $0x8,%esp
  801f86:	ff 75 f4             	pushl  -0xc(%ebp)
  801f89:	6a 00                	push   $0x0
  801f8b:	e8 a6 ec ff ff       	call   800c36 <sys_page_unmap>
  801f90:	83 c4 10             	add    $0x10,%esp
}
  801f93:	89 d8                	mov    %ebx,%eax
  801f95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    

00801f9c <pipeisclosed>:
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa5:	50                   	push   %eax
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	e8 2e ef ff ff       	call   800edc <fd_lookup>
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	78 18                	js     801fcd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbb:	e8 b6 ee ff ff       	call   800e76 <fd2data>
	return _pipeisclosed(fd, p);
  801fc0:	89 c2                	mov    %eax,%edx
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	e8 37 fd ff ff       	call   801d01 <_pipeisclosed>
  801fca:	83 c4 10             	add    $0x10,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	5d                   	pop    %ebp
  801fd8:	c3                   	ret    

00801fd9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	53                   	push   %ebx
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801fe3:	68 5d 2a 80 00       	push   $0x802a5d
  801fe8:	53                   	push   %ebx
  801fe9:	e8 0e e8 ff ff       	call   8007fc <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801fee:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801ff5:	20 00 00 
	return 0;
}
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <devcons_write>:
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	57                   	push   %edi
  802006:	56                   	push   %esi
  802007:	53                   	push   %ebx
  802008:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80200e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802013:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802019:	eb 1d                	jmp    802038 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	53                   	push   %ebx
  80201f:	03 45 0c             	add    0xc(%ebp),%eax
  802022:	50                   	push   %eax
  802023:	57                   	push   %edi
  802024:	e8 46 e9 ff ff       	call   80096f <memmove>
		sys_cputs(buf, m);
  802029:	83 c4 08             	add    $0x8,%esp
  80202c:	53                   	push   %ebx
  80202d:	57                   	push   %edi
  80202e:	e8 e1 ea ff ff       	call   800b14 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802033:	01 de                	add    %ebx,%esi
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	89 f0                	mov    %esi,%eax
  80203a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80203d:	73 11                	jae    802050 <devcons_write+0x4e>
		m = n - tot;
  80203f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802042:	29 f3                	sub    %esi,%ebx
  802044:	83 fb 7f             	cmp    $0x7f,%ebx
  802047:	76 d2                	jbe    80201b <devcons_write+0x19>
  802049:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  80204e:	eb cb                	jmp    80201b <devcons_write+0x19>
}
  802050:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802053:	5b                   	pop    %ebx
  802054:	5e                   	pop    %esi
  802055:	5f                   	pop    %edi
  802056:	5d                   	pop    %ebp
  802057:	c3                   	ret    

00802058 <devcons_read>:
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  80205e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802062:	75 0c                	jne    802070 <devcons_read+0x18>
		return 0;
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	eb 21                	jmp    80208c <devcons_read+0x34>
		sys_yield();
  80206b:	e8 08 ec ff ff       	call   800c78 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802070:	e8 bd ea ff ff       	call   800b32 <sys_cgetc>
  802075:	85 c0                	test   %eax,%eax
  802077:	74 f2                	je     80206b <devcons_read+0x13>
	if (c < 0)
  802079:	85 c0                	test   %eax,%eax
  80207b:	78 0f                	js     80208c <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  80207d:	83 f8 04             	cmp    $0x4,%eax
  802080:	74 0c                	je     80208e <devcons_read+0x36>
	*(char*)vbuf = c;
  802082:	8b 55 0c             	mov    0xc(%ebp),%edx
  802085:	88 02                	mov    %al,(%edx)
	return 1;
  802087:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    
		return 0;
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	eb f7                	jmp    80208c <devcons_read+0x34>

00802095 <cputchar>:
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020a1:	6a 01                	push   $0x1
  8020a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020a6:	50                   	push   %eax
  8020a7:	e8 68 ea ff ff       	call   800b14 <sys_cputs>
}
  8020ac:	83 c4 10             	add    $0x10,%esp
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <getchar>:
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020b7:	6a 01                	push   $0x1
  8020b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020bc:	50                   	push   %eax
  8020bd:	6a 00                	push   $0x0
  8020bf:	e8 85 f0 ff ff       	call   801149 <read>
	if (r < 0)
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	78 08                	js     8020d3 <getchar+0x22>
	if (r < 1)
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	7e 06                	jle    8020d5 <getchar+0x24>
	return c;
  8020cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    
		return -E_EOF;
  8020d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020da:	eb f7                	jmp    8020d3 <getchar+0x22>

008020dc <iscons>:
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e5:	50                   	push   %eax
  8020e6:	ff 75 08             	pushl  0x8(%ebp)
  8020e9:	e8 ee ed ff ff       	call   800edc <fd_lookup>
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	78 11                	js     802106 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020fe:	39 10                	cmp    %edx,(%eax)
  802100:	0f 94 c0             	sete   %al
  802103:	0f b6 c0             	movzbl %al,%eax
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <opencons>:
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80210e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802111:	50                   	push   %eax
  802112:	e8 76 ed ff ff       	call   800e8d <fd_alloc>
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	85 c0                	test   %eax,%eax
  80211c:	78 3a                	js     802158 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80211e:	83 ec 04             	sub    $0x4,%esp
  802121:	68 07 04 00 00       	push   $0x407
  802126:	ff 75 f4             	pushl  -0xc(%ebp)
  802129:	6a 00                	push   $0x0
  80212b:	e8 81 ea ff ff       	call   800bb1 <sys_page_alloc>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	78 21                	js     802158 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802137:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80213d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802140:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	50                   	push   %eax
  802150:	e8 11 ed ff ff       	call   800e66 <fd2num>
  802155:	83 c4 10             	add    $0x10,%esp
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	57                   	push   %edi
  80215e:	56                   	push   %esi
  80215f:	53                   	push   %ebx
  802160:	83 ec 0c             	sub    $0xc,%esp
  802163:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802166:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802169:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  80216c:	85 ff                	test   %edi,%edi
  80216e:	74 53                	je     8021c3 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	57                   	push   %edi
  802174:	e8 48 ec ff ff       	call   800dc1 <sys_ipc_recv>
  802179:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  80217c:	85 db                	test   %ebx,%ebx
  80217e:	74 0b                	je     80218b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802180:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802186:	8b 52 74             	mov    0x74(%edx),%edx
  802189:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  80218b:	85 f6                	test   %esi,%esi
  80218d:	74 0f                	je     80219e <ipc_recv+0x44>
  80218f:	85 ff                	test   %edi,%edi
  802191:	74 0b                	je     80219e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802193:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802199:	8b 52 78             	mov    0x78(%edx),%edx
  80219c:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	74 30                	je     8021d2 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  8021a2:	85 db                	test   %ebx,%ebx
  8021a4:	74 06                	je     8021ac <ipc_recv+0x52>
      		*from_env_store = 0;
  8021a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  8021ac:	85 f6                	test   %esi,%esi
  8021ae:	74 2c                	je     8021dc <ipc_recv+0x82>
      		*perm_store = 0;
  8021b0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  8021b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  8021bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021be:	5b                   	pop    %ebx
  8021bf:	5e                   	pop    %esi
  8021c0:	5f                   	pop    %edi
  8021c1:	5d                   	pop    %ebp
  8021c2:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8021c3:	83 ec 0c             	sub    $0xc,%esp
  8021c6:	6a ff                	push   $0xffffffff
  8021c8:	e8 f4 eb ff ff       	call   800dc1 <sys_ipc_recv>
  8021cd:	83 c4 10             	add    $0x10,%esp
  8021d0:	eb aa                	jmp    80217c <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  8021d2:	a1 04 40 80 00       	mov    0x804004,%eax
  8021d7:	8b 40 70             	mov    0x70(%eax),%eax
  8021da:	eb df                	jmp    8021bb <ipc_recv+0x61>
		return -1;
  8021dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8021e1:	eb d8                	jmp    8021bb <ipc_recv+0x61>

008021e3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	57                   	push   %edi
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021f2:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8021f5:	85 db                	test   %ebx,%ebx
  8021f7:	75 22                	jne    80221b <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8021f9:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8021fe:	eb 1b                	jmp    80221b <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  802200:	68 6c 2a 80 00       	push   $0x802a6c
  802205:	68 5f 29 80 00       	push   $0x80295f
  80220a:	6a 48                	push   $0x48
  80220c:	68 90 2a 80 00       	push   $0x802a90
  802211:	e8 cb de ff ff       	call   8000e1 <_panic>
		sys_yield();
  802216:	e8 5d ea ff ff       	call   800c78 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  80221b:	57                   	push   %edi
  80221c:	53                   	push   %ebx
  80221d:	56                   	push   %esi
  80221e:	ff 75 08             	pushl  0x8(%ebp)
  802221:	e8 78 eb ff ff       	call   800d9e <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  802226:	83 c4 10             	add    $0x10,%esp
  802229:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80222c:	74 e8                	je     802216 <ipc_send+0x33>
  80222e:	85 c0                	test   %eax,%eax
  802230:	75 ce                	jne    802200 <ipc_send+0x1d>
		sys_yield();
  802232:	e8 41 ea ff ff       	call   800c78 <sys_yield>
		
	}
	
}
  802237:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80223a:	5b                   	pop    %ebx
  80223b:	5e                   	pop    %esi
  80223c:	5f                   	pop    %edi
  80223d:	5d                   	pop    %ebp
  80223e:	c3                   	ret    

0080223f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80224a:	89 c2                	mov    %eax,%edx
  80224c:	c1 e2 05             	shl    $0x5,%edx
  80224f:	29 c2                	sub    %eax,%edx
  802251:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  802258:	8b 52 50             	mov    0x50(%edx),%edx
  80225b:	39 ca                	cmp    %ecx,%edx
  80225d:	74 0f                	je     80226e <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80225f:	40                   	inc    %eax
  802260:	3d 00 04 00 00       	cmp    $0x400,%eax
  802265:	75 e3                	jne    80224a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
  80226c:	eb 11                	jmp    80227f <ipc_find_env+0x40>
			return envs[i].env_id;
  80226e:	89 c2                	mov    %eax,%edx
  802270:	c1 e2 05             	shl    $0x5,%edx
  802273:	29 c2                	sub    %eax,%edx
  802275:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80227c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80227f:	5d                   	pop    %ebp
  802280:	c3                   	ret    

00802281 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	c1 e8 16             	shr    $0x16,%eax
  80228a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802291:	a8 01                	test   $0x1,%al
  802293:	74 21                	je     8022b6 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	c1 e8 0c             	shr    $0xc,%eax
  80229b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022a2:	a8 01                	test   $0x1,%al
  8022a4:	74 17                	je     8022bd <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022a6:	c1 e8 0c             	shr    $0xc,%eax
  8022a9:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  8022b0:	ef 
  8022b1:	0f b7 c0             	movzwl %ax,%eax
  8022b4:	eb 05                	jmp    8022bb <pageref+0x3a>
		return 0;
  8022b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bb:	5d                   	pop    %ebp
  8022bc:	c3                   	ret    
		return 0;
  8022bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c2:	eb f7                	jmp    8022bb <pageref+0x3a>

008022c4 <__udivdi3>:
  8022c4:	55                   	push   %ebp
  8022c5:	57                   	push   %edi
  8022c6:	56                   	push   %esi
  8022c7:	53                   	push   %ebx
  8022c8:	83 ec 1c             	sub    $0x1c,%esp
  8022cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8022d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022d7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022db:	89 ca                	mov    %ecx,%edx
  8022dd:	89 f8                	mov    %edi,%eax
  8022df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8022e3:	85 f6                	test   %esi,%esi
  8022e5:	75 2d                	jne    802314 <__udivdi3+0x50>
  8022e7:	39 cf                	cmp    %ecx,%edi
  8022e9:	77 65                	ja     802350 <__udivdi3+0x8c>
  8022eb:	89 fd                	mov    %edi,%ebp
  8022ed:	85 ff                	test   %edi,%edi
  8022ef:	75 0b                	jne    8022fc <__udivdi3+0x38>
  8022f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f6:	31 d2                	xor    %edx,%edx
  8022f8:	f7 f7                	div    %edi
  8022fa:	89 c5                	mov    %eax,%ebp
  8022fc:	31 d2                	xor    %edx,%edx
  8022fe:	89 c8                	mov    %ecx,%eax
  802300:	f7 f5                	div    %ebp
  802302:	89 c1                	mov    %eax,%ecx
  802304:	89 d8                	mov    %ebx,%eax
  802306:	f7 f5                	div    %ebp
  802308:	89 cf                	mov    %ecx,%edi
  80230a:	89 fa                	mov    %edi,%edx
  80230c:	83 c4 1c             	add    $0x1c,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5f                   	pop    %edi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    
  802314:	39 ce                	cmp    %ecx,%esi
  802316:	77 28                	ja     802340 <__udivdi3+0x7c>
  802318:	0f bd fe             	bsr    %esi,%edi
  80231b:	83 f7 1f             	xor    $0x1f,%edi
  80231e:	75 40                	jne    802360 <__udivdi3+0x9c>
  802320:	39 ce                	cmp    %ecx,%esi
  802322:	72 0a                	jb     80232e <__udivdi3+0x6a>
  802324:	3b 44 24 04          	cmp    0x4(%esp),%eax
  802328:	0f 87 9e 00 00 00    	ja     8023cc <__udivdi3+0x108>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	89 fa                	mov    %edi,%edx
  802335:	83 c4 1c             	add    $0x1c,%esp
  802338:	5b                   	pop    %ebx
  802339:	5e                   	pop    %esi
  80233a:	5f                   	pop    %edi
  80233b:	5d                   	pop    %ebp
  80233c:	c3                   	ret    
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	31 ff                	xor    %edi,%edi
  802342:	31 c0                	xor    %eax,%eax
  802344:	89 fa                	mov    %edi,%edx
  802346:	83 c4 1c             	add    $0x1c,%esp
  802349:	5b                   	pop    %ebx
  80234a:	5e                   	pop    %esi
  80234b:	5f                   	pop    %edi
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    
  80234e:	66 90                	xchg   %ax,%ax
  802350:	89 d8                	mov    %ebx,%eax
  802352:	f7 f7                	div    %edi
  802354:	31 ff                	xor    %edi,%edi
  802356:	89 fa                	mov    %edi,%edx
  802358:	83 c4 1c             	add    $0x1c,%esp
  80235b:	5b                   	pop    %ebx
  80235c:	5e                   	pop    %esi
  80235d:	5f                   	pop    %edi
  80235e:	5d                   	pop    %ebp
  80235f:	c3                   	ret    
  802360:	bd 20 00 00 00       	mov    $0x20,%ebp
  802365:	29 fd                	sub    %edi,%ebp
  802367:	89 f9                	mov    %edi,%ecx
  802369:	d3 e6                	shl    %cl,%esi
  80236b:	89 c3                	mov    %eax,%ebx
  80236d:	89 e9                	mov    %ebp,%ecx
  80236f:	d3 eb                	shr    %cl,%ebx
  802371:	89 d9                	mov    %ebx,%ecx
  802373:	09 f1                	or     %esi,%ecx
  802375:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802379:	89 f9                	mov    %edi,%ecx
  80237b:	d3 e0                	shl    %cl,%eax
  80237d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802381:	89 d6                	mov    %edx,%esi
  802383:	89 e9                	mov    %ebp,%ecx
  802385:	d3 ee                	shr    %cl,%esi
  802387:	89 f9                	mov    %edi,%ecx
  802389:	d3 e2                	shl    %cl,%edx
  80238b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80238f:	89 e9                	mov    %ebp,%ecx
  802391:	d3 eb                	shr    %cl,%ebx
  802393:	09 da                	or     %ebx,%edx
  802395:	89 d0                	mov    %edx,%eax
  802397:	89 f2                	mov    %esi,%edx
  802399:	f7 74 24 08          	divl   0x8(%esp)
  80239d:	89 d6                	mov    %edx,%esi
  80239f:	89 c3                	mov    %eax,%ebx
  8023a1:	f7 64 24 0c          	mull   0xc(%esp)
  8023a5:	39 d6                	cmp    %edx,%esi
  8023a7:	72 17                	jb     8023c0 <__udivdi3+0xfc>
  8023a9:	74 09                	je     8023b4 <__udivdi3+0xf0>
  8023ab:	89 d8                	mov    %ebx,%eax
  8023ad:	31 ff                	xor    %edi,%edi
  8023af:	e9 56 ff ff ff       	jmp    80230a <__udivdi3+0x46>
  8023b4:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023b8:	89 f9                	mov    %edi,%ecx
  8023ba:	d3 e2                	shl    %cl,%edx
  8023bc:	39 c2                	cmp    %eax,%edx
  8023be:	73 eb                	jae    8023ab <__udivdi3+0xe7>
  8023c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c3:	31 ff                	xor    %edi,%edi
  8023c5:	e9 40 ff ff ff       	jmp    80230a <__udivdi3+0x46>
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	31 c0                	xor    %eax,%eax
  8023ce:	e9 37 ff ff ff       	jmp    80230a <__udivdi3+0x46>
  8023d3:	90                   	nop

008023d4 <__umoddi3>:
  8023d4:	55                   	push   %ebp
  8023d5:	57                   	push   %edi
  8023d6:	56                   	push   %esi
  8023d7:	53                   	push   %ebx
  8023d8:	83 ec 1c             	sub    $0x1c,%esp
  8023db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8023df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f3:	89 3c 24             	mov    %edi,(%esp)
  8023f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023fa:	89 f2                	mov    %esi,%edx
  8023fc:	85 c0                	test   %eax,%eax
  8023fe:	75 18                	jne    802418 <__umoddi3+0x44>
  802400:	39 f7                	cmp    %esi,%edi
  802402:	0f 86 a0 00 00 00    	jbe    8024a8 <__umoddi3+0xd4>
  802408:	89 c8                	mov    %ecx,%eax
  80240a:	f7 f7                	div    %edi
  80240c:	89 d0                	mov    %edx,%eax
  80240e:	31 d2                	xor    %edx,%edx
  802410:	83 c4 1c             	add    $0x1c,%esp
  802413:	5b                   	pop    %ebx
  802414:	5e                   	pop    %esi
  802415:	5f                   	pop    %edi
  802416:	5d                   	pop    %ebp
  802417:	c3                   	ret    
  802418:	89 f3                	mov    %esi,%ebx
  80241a:	39 f0                	cmp    %esi,%eax
  80241c:	0f 87 a6 00 00 00    	ja     8024c8 <__umoddi3+0xf4>
  802422:	0f bd e8             	bsr    %eax,%ebp
  802425:	83 f5 1f             	xor    $0x1f,%ebp
  802428:	0f 84 a6 00 00 00    	je     8024d4 <__umoddi3+0x100>
  80242e:	bf 20 00 00 00       	mov    $0x20,%edi
  802433:	29 ef                	sub    %ebp,%edi
  802435:	89 e9                	mov    %ebp,%ecx
  802437:	d3 e0                	shl    %cl,%eax
  802439:	8b 34 24             	mov    (%esp),%esi
  80243c:	89 f2                	mov    %esi,%edx
  80243e:	89 f9                	mov    %edi,%ecx
  802440:	d3 ea                	shr    %cl,%edx
  802442:	09 c2                	or     %eax,%edx
  802444:	89 14 24             	mov    %edx,(%esp)
  802447:	89 f2                	mov    %esi,%edx
  802449:	89 e9                	mov    %ebp,%ecx
  80244b:	d3 e2                	shl    %cl,%edx
  80244d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802451:	89 de                	mov    %ebx,%esi
  802453:	89 f9                	mov    %edi,%ecx
  802455:	d3 ee                	shr    %cl,%esi
  802457:	89 e9                	mov    %ebp,%ecx
  802459:	d3 e3                	shl    %cl,%ebx
  80245b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80245f:	89 d0                	mov    %edx,%eax
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e8                	shr    %cl,%eax
  802465:	09 d8                	or     %ebx,%eax
  802467:	89 d3                	mov    %edx,%ebx
  802469:	89 e9                	mov    %ebp,%ecx
  80246b:	d3 e3                	shl    %cl,%ebx
  80246d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802471:	89 f2                	mov    %esi,%edx
  802473:	f7 34 24             	divl   (%esp)
  802476:	89 d6                	mov    %edx,%esi
  802478:	f7 64 24 04          	mull   0x4(%esp)
  80247c:	89 c3                	mov    %eax,%ebx
  80247e:	89 d1                	mov    %edx,%ecx
  802480:	39 d6                	cmp    %edx,%esi
  802482:	72 7c                	jb     802500 <__umoddi3+0x12c>
  802484:	74 72                	je     8024f8 <__umoddi3+0x124>
  802486:	8b 54 24 08          	mov    0x8(%esp),%edx
  80248a:	29 da                	sub    %ebx,%edx
  80248c:	19 ce                	sbb    %ecx,%esi
  80248e:	89 f0                	mov    %esi,%eax
  802490:	89 f9                	mov    %edi,%ecx
  802492:	d3 e0                	shl    %cl,%eax
  802494:	89 e9                	mov    %ebp,%ecx
  802496:	d3 ea                	shr    %cl,%edx
  802498:	09 d0                	or     %edx,%eax
  80249a:	89 e9                	mov    %ebp,%ecx
  80249c:	d3 ee                	shr    %cl,%esi
  80249e:	89 f2                	mov    %esi,%edx
  8024a0:	83 c4 1c             	add    $0x1c,%esp
  8024a3:	5b                   	pop    %ebx
  8024a4:	5e                   	pop    %esi
  8024a5:	5f                   	pop    %edi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    
  8024a8:	89 fd                	mov    %edi,%ebp
  8024aa:	85 ff                	test   %edi,%edi
  8024ac:	75 0b                	jne    8024b9 <__umoddi3+0xe5>
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b3:	31 d2                	xor    %edx,%edx
  8024b5:	f7 f7                	div    %edi
  8024b7:	89 c5                	mov    %eax,%ebp
  8024b9:	89 f0                	mov    %esi,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	f7 f5                	div    %ebp
  8024bf:	89 c8                	mov    %ecx,%eax
  8024c1:	f7 f5                	div    %ebp
  8024c3:	e9 44 ff ff ff       	jmp    80240c <__umoddi3+0x38>
  8024c8:	89 c8                	mov    %ecx,%eax
  8024ca:	89 f2                	mov    %esi,%edx
  8024cc:	83 c4 1c             	add    $0x1c,%esp
  8024cf:	5b                   	pop    %ebx
  8024d0:	5e                   	pop    %esi
  8024d1:	5f                   	pop    %edi
  8024d2:	5d                   	pop    %ebp
  8024d3:	c3                   	ret    
  8024d4:	39 f0                	cmp    %esi,%eax
  8024d6:	72 05                	jb     8024dd <__umoddi3+0x109>
  8024d8:	39 0c 24             	cmp    %ecx,(%esp)
  8024db:	77 0c                	ja     8024e9 <__umoddi3+0x115>
  8024dd:	89 f2                	mov    %esi,%edx
  8024df:	29 f9                	sub    %edi,%ecx
  8024e1:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8024e5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024ed:	83 c4 1c             	add    $0x1c,%esp
  8024f0:	5b                   	pop    %ebx
  8024f1:	5e                   	pop    %esi
  8024f2:	5f                   	pop    %edi
  8024f3:	5d                   	pop    %ebp
  8024f4:	c3                   	ret    
  8024f5:	8d 76 00             	lea    0x0(%esi),%esi
  8024f8:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8024fc:	73 88                	jae    802486 <__umoddi3+0xb2>
  8024fe:	66 90                	xchg   %ax,%ax
  802500:	2b 44 24 04          	sub    0x4(%esp),%eax
  802504:	1b 14 24             	sbb    (%esp),%edx
  802507:	89 d1                	mov    %edx,%ecx
  802509:	89 c3                	mov    %eax,%ebx
  80250b:	e9 76 ff ff ff       	jmp    802486 <__umoddi3+0xb2>
