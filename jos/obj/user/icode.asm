
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 e0 	movl   $0x8025e0,0x803000
  800045:	25 80 00 

	cprintf("icode startup\n");
  800048:	68 e6 25 80 00       	push   $0x8025e6
  80004d:	e8 5b 02 00 00       	call   8002ad <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  800059:	e8 4f 02 00 00       	call   8002ad <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 08 26 80 00       	push   $0x802608
  800068:	e8 47 16 00 00       	call   8016b4 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 18                	js     80008e <umain+0x5b>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 31 26 80 00       	push   $0x802631
  80007e:	e8 2a 02 00 00       	call   8002ad <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	eb 1f                	jmp    8000ad <umain+0x7a>
		panic("icode: open /motd: %e", fd);
  80008e:	50                   	push   %eax
  80008f:	68 0e 26 80 00       	push   $0x80260e
  800094:	6a 0f                	push   $0xf
  800096:	68 24 26 80 00       	push   $0x802624
  80009b:	e8 fa 00 00 00       	call   80019a <_panic>
		sys_cputs(buf, n);
  8000a0:	83 ec 08             	sub    $0x8,%esp
  8000a3:	50                   	push   %eax
  8000a4:	53                   	push   %ebx
  8000a5:	e8 23 0b 00 00       	call   800bcd <sys_cputs>
  8000aa:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	68 00 02 00 00       	push   $0x200
  8000b5:	53                   	push   %ebx
  8000b6:	56                   	push   %esi
  8000b7:	e8 46 11 00 00       	call   801202 <read>
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	7f dd                	jg     8000a0 <umain+0x6d>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 44 26 80 00       	push   $0x802644
  8000cb:	e8 dd 01 00 00       	call   8002ad <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 f0 0f 00 00       	call   8010c8 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 58 26 80 00 	movl   $0x802658,(%esp)
  8000df:	e8 c9 01 00 00       	call   8002ad <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 6c 26 80 00       	push   $0x80266c
  8000f0:	68 75 26 80 00       	push   $0x802675
  8000f5:	68 7f 26 80 00       	push   $0x80267f
  8000fa:	68 7e 26 80 00       	push   $0x80267e
  8000ff:	e8 c5 1b 00 00       	call   801cc9 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 9b 26 80 00       	push   $0x80269b
  800113:	e8 95 01 00 00       	call   8002ad <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 84 26 80 00       	push   $0x802684
  800128:	6a 1a                	push   $0x1a
  80012a:	68 24 26 80 00       	push   $0x802624
  80012f:	e8 66 00 00 00       	call   80019a <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013f:	e8 07 0b 00 00       	call   800c4b <sys_getenvid>
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	89 c2                	mov    %eax,%edx
  80014b:	c1 e2 05             	shl    $0x5,%edx
  80014e:	29 c2                	sub    %eax,%edx
  800150:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800157:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015c:	85 db                	test   %ebx,%ebx
  80015e:	7e 07                	jle    800167 <libmain+0x33>
		binaryname = argv[0];
  800160:	8b 06                	mov    (%esi),%eax
  800162:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	56                   	push   %esi
  80016b:	53                   	push   %ebx
  80016c:	e8 c2 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800171:	e8 0a 00 00 00       	call   800180 <exit>
}
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5d                   	pop    %ebp
  80017f:	c3                   	ret    

00800180 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800186:	e8 68 0f 00 00       	call   8010f3 <close_all>
	sys_env_destroy(0);
  80018b:	83 ec 0c             	sub    $0xc,%esp
  80018e:	6a 00                	push   $0x0
  800190:	e8 75 0a 00 00       	call   800c0a <sys_env_destroy>
}
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	c9                   	leave  
  800199:	c3                   	ret    

0080019a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	57                   	push   %edi
  80019e:	56                   	push   %esi
  80019f:	53                   	push   %ebx
  8001a0:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  8001a6:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  8001a9:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8001af:	e8 97 0a 00 00       	call   800c4b <sys_getenvid>
  8001b4:	83 ec 04             	sub    $0x4,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	53                   	push   %ebx
  8001be:	50                   	push   %eax
  8001bf:	68 b8 26 80 00       	push   $0x8026b8
  8001c4:	68 00 01 00 00       	push   $0x100
  8001c9:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  8001cf:	56                   	push   %esi
  8001d0:	e8 93 06 00 00       	call   800868 <snprintf>
  8001d5:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  8001d7:	83 c4 20             	add    $0x20,%esp
  8001da:	57                   	push   %edi
  8001db:	ff 75 10             	pushl  0x10(%ebp)
  8001de:	bf 00 01 00 00       	mov    $0x100,%edi
  8001e3:	89 f8                	mov    %edi,%eax
  8001e5:	29 d8                	sub    %ebx,%eax
  8001e7:	50                   	push   %eax
  8001e8:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8001eb:	50                   	push   %eax
  8001ec:	e8 22 06 00 00       	call   800813 <vsnprintf>
  8001f1:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8001f3:	83 c4 0c             	add    $0xc,%esp
  8001f6:	68 96 2b 80 00       	push   $0x802b96
  8001fb:	29 df                	sub    %ebx,%edi
  8001fd:	57                   	push   %edi
  8001fe:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800201:	50                   	push   %eax
  800202:	e8 61 06 00 00       	call   800868 <snprintf>
	sys_cputs(buf, r);
  800207:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80020a:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80020c:	53                   	push   %ebx
  80020d:	56                   	push   %esi
  80020e:	e8 ba 09 00 00       	call   800bcd <sys_cputs>
  800213:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800216:	cc                   	int3   
  800217:	eb fd                	jmp    800216 <_panic+0x7c>

00800219 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	53                   	push   %ebx
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800223:	8b 13                	mov    (%ebx),%edx
  800225:	8d 42 01             	lea    0x1(%edx),%eax
  800228:	89 03                	mov    %eax,(%ebx)
  80022a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800231:	3d ff 00 00 00       	cmp    $0xff,%eax
  800236:	74 08                	je     800240 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800238:	ff 43 04             	incl   0x4(%ebx)
}
  80023b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800240:	83 ec 08             	sub    $0x8,%esp
  800243:	68 ff 00 00 00       	push   $0xff
  800248:	8d 43 08             	lea    0x8(%ebx),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 7c 09 00 00       	call   800bcd <sys_cputs>
		b->idx = 0;
  800251:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	eb dc                	jmp    800238 <putch+0x1f>

0080025c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800265:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026c:	00 00 00 
	b.cnt = 0;
  80026f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800276:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	68 19 02 80 00       	push   $0x800219
  80028b:	e8 17 01 00 00       	call   8003a7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800290:	83 c4 08             	add    $0x8,%esp
  800293:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800299:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80029f:	50                   	push   %eax
  8002a0:	e8 28 09 00 00       	call   800bcd <sys_cputs>

	return b.cnt;
}
  8002a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b6:	50                   	push   %eax
  8002b7:	ff 75 08             	pushl  0x8(%ebp)
  8002ba:	e8 9d ff ff ff       	call   80025c <vcprintf>
	va_end(ap);

	return cnt;
}
  8002bf:	c9                   	leave  
  8002c0:	c3                   	ret    

008002c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	57                   	push   %edi
  8002c5:	56                   	push   %esi
  8002c6:	53                   	push   %ebx
  8002c7:	83 ec 1c             	sub    $0x1c,%esp
  8002ca:	89 c7                	mov    %eax,%edi
  8002cc:	89 d6                	mov    %edx,%esi
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002e5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002e8:	39 d3                	cmp    %edx,%ebx
  8002ea:	72 05                	jb     8002f1 <printnum+0x30>
  8002ec:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002ef:	77 78                	ja     800369 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	ff 75 18             	pushl  0x18(%ebp)
  8002f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002fd:	53                   	push   %ebx
  8002fe:	ff 75 10             	pushl  0x10(%ebp)
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	ff 75 e0             	pushl  -0x20(%ebp)
  80030a:	ff 75 dc             	pushl  -0x24(%ebp)
  80030d:	ff 75 d8             	pushl  -0x28(%ebp)
  800310:	e8 6b 20 00 00       	call   802380 <__udivdi3>
  800315:	83 c4 18             	add    $0x18,%esp
  800318:	52                   	push   %edx
  800319:	50                   	push   %eax
  80031a:	89 f2                	mov    %esi,%edx
  80031c:	89 f8                	mov    %edi,%eax
  80031e:	e8 9e ff ff ff       	call   8002c1 <printnum>
  800323:	83 c4 20             	add    $0x20,%esp
  800326:	eb 11                	jmp    800339 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	56                   	push   %esi
  80032c:	ff 75 18             	pushl  0x18(%ebp)
  80032f:	ff d7                	call   *%edi
  800331:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800334:	4b                   	dec    %ebx
  800335:	85 db                	test   %ebx,%ebx
  800337:	7f ef                	jg     800328 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	56                   	push   %esi
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	ff 75 e4             	pushl  -0x1c(%ebp)
  800343:	ff 75 e0             	pushl  -0x20(%ebp)
  800346:	ff 75 dc             	pushl  -0x24(%ebp)
  800349:	ff 75 d8             	pushl  -0x28(%ebp)
  80034c:	e8 3f 21 00 00       	call   802490 <__umoddi3>
  800351:	83 c4 14             	add    $0x14,%esp
  800354:	0f be 80 db 26 80 00 	movsbl 0x8026db(%eax),%eax
  80035b:	50                   	push   %eax
  80035c:	ff d7                	call   *%edi
}
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800364:	5b                   	pop    %ebx
  800365:	5e                   	pop    %esi
  800366:	5f                   	pop    %edi
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    
  800369:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80036c:	eb c6                	jmp    800334 <printnum+0x73>

0080036e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800374:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800377:	8b 10                	mov    (%eax),%edx
  800379:	3b 50 04             	cmp    0x4(%eax),%edx
  80037c:	73 0a                	jae    800388 <sprintputch+0x1a>
		*b->buf++ = ch;
  80037e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800381:	89 08                	mov    %ecx,(%eax)
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	88 02                	mov    %al,(%edx)
}
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    

0080038a <printfmt>:
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800390:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800393:	50                   	push   %eax
  800394:	ff 75 10             	pushl  0x10(%ebp)
  800397:	ff 75 0c             	pushl  0xc(%ebp)
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 05 00 00 00       	call   8003a7 <vprintfmt>
}
  8003a2:	83 c4 10             	add    $0x10,%esp
  8003a5:	c9                   	leave  
  8003a6:	c3                   	ret    

008003a7 <vprintfmt>:
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	57                   	push   %edi
  8003ab:	56                   	push   %esi
  8003ac:	53                   	push   %ebx
  8003ad:	83 ec 2c             	sub    $0x2c,%esp
  8003b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003b6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003b9:	e9 ae 03 00 00       	jmp    80076c <vprintfmt+0x3c5>
  8003be:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8003c2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003c9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003d7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003dc:	8d 47 01             	lea    0x1(%edi),%eax
  8003df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003e2:	8a 17                	mov    (%edi),%dl
  8003e4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003e7:	3c 55                	cmp    $0x55,%al
  8003e9:	0f 87 fe 03 00 00    	ja     8007ed <vprintfmt+0x446>
  8003ef:	0f b6 c0             	movzbl %al,%eax
  8003f2:	ff 24 85 20 28 80 00 	jmp    *0x802820(,%eax,4)
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003fc:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800400:	eb da                	jmp    8003dc <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800405:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800409:	eb d1                	jmp    8003dc <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	0f b6 d2             	movzbl %dl,%edx
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800411:	b8 00 00 00 00       	mov    $0x0,%eax
  800416:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800419:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80041c:	01 c0                	add    %eax,%eax
  80041e:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800422:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800425:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800428:	83 f9 09             	cmp    $0x9,%ecx
  80042b:	77 52                	ja     80047f <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80042d:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80042e:	eb e9                	jmp    800419 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800430:	8b 45 14             	mov    0x14(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 40 04             	lea    0x4(%eax),%eax
  80043e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800444:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800448:	79 92                	jns    8003dc <vprintfmt+0x35>
				width = precision, precision = -1;
  80044a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80044d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800450:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800457:	eb 83                	jmp    8003dc <vprintfmt+0x35>
  800459:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045d:	78 08                	js     800467 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80045f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800462:	e9 75 ff ff ff       	jmp    8003dc <vprintfmt+0x35>
  800467:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80046e:	eb ef                	jmp    80045f <vprintfmt+0xb8>
  800470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800473:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80047a:	e9 5d ff ff ff       	jmp    8003dc <vprintfmt+0x35>
  80047f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800482:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800485:	eb bd                	jmp    800444 <vprintfmt+0x9d>
			lflag++;
  800487:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80048b:	e9 4c ff ff ff       	jmp    8003dc <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	8d 78 04             	lea    0x4(%eax),%edi
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	53                   	push   %ebx
  80049a:	ff 30                	pushl  (%eax)
  80049c:	ff d6                	call   *%esi
			break;
  80049e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004a1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004a4:	e9 c0 02 00 00       	jmp    800769 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8004a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ac:	8d 78 04             	lea    0x4(%eax),%edi
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	85 c0                	test   %eax,%eax
  8004b3:	78 2a                	js     8004df <vprintfmt+0x138>
  8004b5:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b7:	83 f8 0f             	cmp    $0xf,%eax
  8004ba:	7f 27                	jg     8004e3 <vprintfmt+0x13c>
  8004bc:	8b 04 85 80 29 80 00 	mov    0x802980(,%eax,4),%eax
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	74 1c                	je     8004e3 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8004c7:	50                   	push   %eax
  8004c8:	68 b1 2a 80 00       	push   $0x802ab1
  8004cd:	53                   	push   %ebx
  8004ce:	56                   	push   %esi
  8004cf:	e8 b6 fe ff ff       	call   80038a <printfmt>
  8004d4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004da:	e9 8a 02 00 00       	jmp    800769 <vprintfmt+0x3c2>
  8004df:	f7 d8                	neg    %eax
  8004e1:	eb d2                	jmp    8004b5 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8004e3:	52                   	push   %edx
  8004e4:	68 f3 26 80 00       	push   $0x8026f3
  8004e9:	53                   	push   %ebx
  8004ea:	56                   	push   %esi
  8004eb:	e8 9a fe ff ff       	call   80038a <printfmt>
  8004f0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004f6:	e9 6e 02 00 00       	jmp    800769 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	83 c0 04             	add    $0x4,%eax
  800501:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8b 38                	mov    (%eax),%edi
  800509:	85 ff                	test   %edi,%edi
  80050b:	74 39                	je     800546 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80050d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800511:	0f 8e a9 00 00 00    	jle    8005c0 <vprintfmt+0x219>
  800517:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80051b:	0f 84 a7 00 00 00    	je     8005c8 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 75 d0             	pushl  -0x30(%ebp)
  800527:	57                   	push   %edi
  800528:	e8 6b 03 00 00       	call   800898 <strnlen>
  80052d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800530:	29 c1                	sub    %eax,%ecx
  800532:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800535:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800538:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80053c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800542:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800544:	eb 14                	jmp    80055a <vprintfmt+0x1b3>
				p = "(null)";
  800546:	bf ec 26 80 00       	mov    $0x8026ec,%edi
  80054b:	eb c0                	jmp    80050d <vprintfmt+0x166>
					putch(padc, putdat);
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	53                   	push   %ebx
  800551:	ff 75 e0             	pushl  -0x20(%ebp)
  800554:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800556:	4f                   	dec    %edi
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	85 ff                	test   %edi,%edi
  80055c:	7f ef                	jg     80054d <vprintfmt+0x1a6>
  80055e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800561:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800564:	89 c8                	mov    %ecx,%eax
  800566:	85 c9                	test   %ecx,%ecx
  800568:	78 10                	js     80057a <vprintfmt+0x1d3>
  80056a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80056d:	29 c1                	sub    %eax,%ecx
  80056f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800572:	89 75 08             	mov    %esi,0x8(%ebp)
  800575:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800578:	eb 15                	jmp    80058f <vprintfmt+0x1e8>
  80057a:	b8 00 00 00 00       	mov    $0x0,%eax
  80057f:	eb e9                	jmp    80056a <vprintfmt+0x1c3>
					putch(ch, putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	52                   	push   %edx
  800586:	ff 55 08             	call   *0x8(%ebp)
  800589:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058c:	ff 4d e0             	decl   -0x20(%ebp)
  80058f:	47                   	inc    %edi
  800590:	8a 47 ff             	mov    -0x1(%edi),%al
  800593:	0f be d0             	movsbl %al,%edx
  800596:	85 d2                	test   %edx,%edx
  800598:	74 59                	je     8005f3 <vprintfmt+0x24c>
  80059a:	85 f6                	test   %esi,%esi
  80059c:	78 03                	js     8005a1 <vprintfmt+0x1fa>
  80059e:	4e                   	dec    %esi
  80059f:	78 2f                	js     8005d0 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a5:	74 da                	je     800581 <vprintfmt+0x1da>
  8005a7:	0f be c0             	movsbl %al,%eax
  8005aa:	83 e8 20             	sub    $0x20,%eax
  8005ad:	83 f8 5e             	cmp    $0x5e,%eax
  8005b0:	76 cf                	jbe    800581 <vprintfmt+0x1da>
					putch('?', putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	6a 3f                	push   $0x3f
  8005b8:	ff 55 08             	call   *0x8(%ebp)
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	eb cc                	jmp    80058c <vprintfmt+0x1e5>
  8005c0:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c6:	eb c7                	jmp    80058f <vprintfmt+0x1e8>
  8005c8:	89 75 08             	mov    %esi,0x8(%ebp)
  8005cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005ce:	eb bf                	jmp    80058f <vprintfmt+0x1e8>
  8005d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005d6:	eb 0c                	jmp    8005e4 <vprintfmt+0x23d>
				putch(' ', putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 20                	push   $0x20
  8005de:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005e0:	4f                   	dec    %edi
  8005e1:	83 c4 10             	add    $0x10,%esp
  8005e4:	85 ff                	test   %edi,%edi
  8005e6:	7f f0                	jg     8005d8 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ee:	e9 76 01 00 00       	jmp    800769 <vprintfmt+0x3c2>
  8005f3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f9:	eb e9                	jmp    8005e4 <vprintfmt+0x23d>
	if (lflag >= 2)
  8005fb:	83 f9 01             	cmp    $0x1,%ecx
  8005fe:	7f 1f                	jg     80061f <vprintfmt+0x278>
	else if (lflag)
  800600:	85 c9                	test   %ecx,%ecx
  800602:	75 48                	jne    80064c <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	c1 f9 1f             	sar    $0x1f,%ecx
  800611:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 40 04             	lea    0x4(%eax),%eax
  80061a:	89 45 14             	mov    %eax,0x14(%ebp)
  80061d:	eb 17                	jmp    800636 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 50 04             	mov    0x4(%eax),%edx
  800625:	8b 00                	mov    (%eax),%eax
  800627:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8d 40 08             	lea    0x8(%eax),%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800636:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800639:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80063c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800640:	78 25                	js     800667 <vprintfmt+0x2c0>
			base = 10;
  800642:	b8 0a 00 00 00       	mov    $0xa,%eax
  800647:	e9 03 01 00 00       	jmp    80074f <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	89 c1                	mov    %eax,%ecx
  800656:	c1 f9 1f             	sar    $0x1f,%ecx
  800659:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
  800665:	eb cf                	jmp    800636 <vprintfmt+0x28f>
				putch('-', putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	6a 2d                	push   $0x2d
  80066d:	ff d6                	call   *%esi
				num = -(long long) num;
  80066f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800672:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800675:	f7 da                	neg    %edx
  800677:	83 d1 00             	adc    $0x0,%ecx
  80067a:	f7 d9                	neg    %ecx
  80067c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80067f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800684:	e9 c6 00 00 00       	jmp    80074f <vprintfmt+0x3a8>
	if (lflag >= 2)
  800689:	83 f9 01             	cmp    $0x1,%ecx
  80068c:	7f 1e                	jg     8006ac <vprintfmt+0x305>
	else if (lflag)
  80068e:	85 c9                	test   %ecx,%ecx
  800690:	75 32                	jne    8006c4 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 10                	mov    (%eax),%edx
  800697:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069c:	8d 40 04             	lea    0x4(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a7:	e9 a3 00 00 00       	jmp    80074f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 10                	mov    (%eax),%edx
  8006b1:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b4:	8d 40 08             	lea    0x8(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bf:	e9 8b 00 00 00       	jmp    80074f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ce:	8d 40 04             	lea    0x4(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d9:	eb 74                	jmp    80074f <vprintfmt+0x3a8>
	if (lflag >= 2)
  8006db:	83 f9 01             	cmp    $0x1,%ecx
  8006de:	7f 1b                	jg     8006fb <vprintfmt+0x354>
	else if (lflag)
  8006e0:	85 c9                	test   %ecx,%ecx
  8006e2:	75 2c                	jne    800710 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f9:	eb 54                	jmp    80074f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 10                	mov    (%eax),%edx
  800700:	8b 48 04             	mov    0x4(%eax),%ecx
  800703:	8d 40 08             	lea    0x8(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800709:	b8 08 00 00 00       	mov    $0x8,%eax
  80070e:	eb 3f                	jmp    80074f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 10                	mov    (%eax),%edx
  800715:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071a:	8d 40 04             	lea    0x4(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800720:	b8 08 00 00 00       	mov    $0x8,%eax
  800725:	eb 28                	jmp    80074f <vprintfmt+0x3a8>
			putch('0', putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	53                   	push   %ebx
  80072b:	6a 30                	push   $0x30
  80072d:	ff d6                	call   *%esi
			putch('x', putdat);
  80072f:	83 c4 08             	add    $0x8,%esp
  800732:	53                   	push   %ebx
  800733:	6a 78                	push   $0x78
  800735:	ff d6                	call   *%esi
			num = (unsigned long long)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 10                	mov    (%eax),%edx
  80073c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800741:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800744:	8d 40 04             	lea    0x4(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80074f:	83 ec 0c             	sub    $0xc,%esp
  800752:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800756:	57                   	push   %edi
  800757:	ff 75 e0             	pushl  -0x20(%ebp)
  80075a:	50                   	push   %eax
  80075b:	51                   	push   %ecx
  80075c:	52                   	push   %edx
  80075d:	89 da                	mov    %ebx,%edx
  80075f:	89 f0                	mov    %esi,%eax
  800761:	e8 5b fb ff ff       	call   8002c1 <printnum>
			break;
  800766:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800769:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	47                   	inc    %edi
  80076d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800771:	83 f8 25             	cmp    $0x25,%eax
  800774:	0f 84 44 fc ff ff    	je     8003be <vprintfmt+0x17>
			if (ch == '\0')
  80077a:	85 c0                	test   %eax,%eax
  80077c:	0f 84 89 00 00 00    	je     80080b <vprintfmt+0x464>
			putch(ch, putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	53                   	push   %ebx
  800786:	50                   	push   %eax
  800787:	ff d6                	call   *%esi
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	eb de                	jmp    80076c <vprintfmt+0x3c5>
	if (lflag >= 2)
  80078e:	83 f9 01             	cmp    $0x1,%ecx
  800791:	7f 1b                	jg     8007ae <vprintfmt+0x407>
	else if (lflag)
  800793:	85 c9                	test   %ecx,%ecx
  800795:	75 2c                	jne    8007c3 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 10                	mov    (%eax),%edx
  80079c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ac:	eb a1                	jmp    80074f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8b 10                	mov    (%eax),%edx
  8007b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8007b6:	8d 40 08             	lea    0x8(%eax),%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bc:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c1:	eb 8c                	jmp    80074f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 10                	mov    (%eax),%edx
  8007c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007cd:	8d 40 04             	lea    0x4(%eax),%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d8:	e9 72 ff ff ff       	jmp    80074f <vprintfmt+0x3a8>
			putch(ch, putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	53                   	push   %ebx
  8007e1:	6a 25                	push   $0x25
  8007e3:	ff d6                	call   *%esi
			break;
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	e9 7c ff ff ff       	jmp    800769 <vprintfmt+0x3c2>
			putch('%', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	6a 25                	push   $0x25
  8007f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	89 f8                	mov    %edi,%eax
  8007fa:	eb 01                	jmp    8007fd <vprintfmt+0x456>
  8007fc:	48                   	dec    %eax
  8007fd:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800801:	75 f9                	jne    8007fc <vprintfmt+0x455>
  800803:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800806:	e9 5e ff ff ff       	jmp    800769 <vprintfmt+0x3c2>
}
  80080b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80080e:	5b                   	pop    %ebx
  80080f:	5e                   	pop    %esi
  800810:	5f                   	pop    %edi
  800811:	5d                   	pop    %ebp
  800812:	c3                   	ret    

00800813 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	83 ec 18             	sub    $0x18,%esp
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80081f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800822:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800826:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800829:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800830:	85 c0                	test   %eax,%eax
  800832:	74 26                	je     80085a <vsnprintf+0x47>
  800834:	85 d2                	test   %edx,%edx
  800836:	7e 29                	jle    800861 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800838:	ff 75 14             	pushl  0x14(%ebp)
  80083b:	ff 75 10             	pushl  0x10(%ebp)
  80083e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800841:	50                   	push   %eax
  800842:	68 6e 03 80 00       	push   $0x80036e
  800847:	e8 5b fb ff ff       	call   8003a7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80084c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800855:	83 c4 10             	add    $0x10,%esp
}
  800858:	c9                   	leave  
  800859:	c3                   	ret    
		return -E_INVAL;
  80085a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085f:	eb f7                	jmp    800858 <vsnprintf+0x45>
  800861:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800866:	eb f0                	jmp    800858 <vsnprintf+0x45>

00800868 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800871:	50                   	push   %eax
  800872:	ff 75 10             	pushl  0x10(%ebp)
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	ff 75 08             	pushl  0x8(%ebp)
  80087b:	e8 93 ff ff ff       	call   800813 <vsnprintf>
	va_end(ap);

	return rc;
}
  800880:	c9                   	leave  
  800881:	c3                   	ret    

00800882 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800888:	b8 00 00 00 00       	mov    $0x0,%eax
  80088d:	eb 01                	jmp    800890 <strlen+0xe>
		n++;
  80088f:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800890:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800894:	75 f9                	jne    80088f <strlen+0xd>
	return n;
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a6:	eb 01                	jmp    8008a9 <strnlen+0x11>
		n++;
  8008a8:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a9:	39 d0                	cmp    %edx,%eax
  8008ab:	74 06                	je     8008b3 <strnlen+0x1b>
  8008ad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008b1:	75 f5                	jne    8008a8 <strnlen+0x10>
	return n;
}
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	53                   	push   %ebx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008bf:	89 c2                	mov    %eax,%edx
  8008c1:	42                   	inc    %edx
  8008c2:	41                   	inc    %ecx
  8008c3:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8008c6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c9:	84 db                	test   %bl,%bl
  8008cb:	75 f4                	jne    8008c1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008cd:	5b                   	pop    %ebx
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	53                   	push   %ebx
  8008d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d7:	53                   	push   %ebx
  8008d8:	e8 a5 ff ff ff       	call   800882 <strlen>
  8008dd:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	01 d8                	add    %ebx,%eax
  8008e5:	50                   	push   %eax
  8008e6:	e8 ca ff ff ff       	call   8008b5 <strcpy>
	return dst;
}
  8008eb:	89 d8                	mov    %ebx,%eax
  8008ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    

008008f2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	56                   	push   %esi
  8008f6:	53                   	push   %ebx
  8008f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008fd:	89 f3                	mov    %esi,%ebx
  8008ff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800902:	89 f2                	mov    %esi,%edx
  800904:	eb 0c                	jmp    800912 <strncpy+0x20>
		*dst++ = *src;
  800906:	42                   	inc    %edx
  800907:	8a 01                	mov    (%ecx),%al
  800909:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80090c:	80 39 01             	cmpb   $0x1,(%ecx)
  80090f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800912:	39 da                	cmp    %ebx,%edx
  800914:	75 f0                	jne    800906 <strncpy+0x14>
	}
	return ret;
}
  800916:	89 f0                	mov    %esi,%eax
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	56                   	push   %esi
  800920:	53                   	push   %ebx
  800921:	8b 75 08             	mov    0x8(%ebp),%esi
  800924:	8b 55 0c             	mov    0xc(%ebp),%edx
  800927:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80092a:	85 c0                	test   %eax,%eax
  80092c:	74 20                	je     80094e <strlcpy+0x32>
  80092e:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800932:	89 f0                	mov    %esi,%eax
  800934:	eb 05                	jmp    80093b <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800936:	40                   	inc    %eax
  800937:	42                   	inc    %edx
  800938:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80093b:	39 d8                	cmp    %ebx,%eax
  80093d:	74 06                	je     800945 <strlcpy+0x29>
  80093f:	8a 0a                	mov    (%edx),%cl
  800941:	84 c9                	test   %cl,%cl
  800943:	75 f1                	jne    800936 <strlcpy+0x1a>
		*dst = '\0';
  800945:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800948:	29 f0                	sub    %esi,%eax
}
  80094a:	5b                   	pop    %ebx
  80094b:	5e                   	pop    %esi
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    
  80094e:	89 f0                	mov    %esi,%eax
  800950:	eb f6                	jmp    800948 <strlcpy+0x2c>

00800952 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800958:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095b:	eb 02                	jmp    80095f <strcmp+0xd>
		p++, q++;
  80095d:	41                   	inc    %ecx
  80095e:	42                   	inc    %edx
	while (*p && *p == *q)
  80095f:	8a 01                	mov    (%ecx),%al
  800961:	84 c0                	test   %al,%al
  800963:	74 04                	je     800969 <strcmp+0x17>
  800965:	3a 02                	cmp    (%edx),%al
  800967:	74 f4                	je     80095d <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800969:	0f b6 c0             	movzbl %al,%eax
  80096c:	0f b6 12             	movzbl (%edx),%edx
  80096f:	29 d0                	sub    %edx,%eax
}
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	53                   	push   %ebx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097d:	89 c3                	mov    %eax,%ebx
  80097f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800982:	eb 02                	jmp    800986 <strncmp+0x13>
		n--, p++, q++;
  800984:	40                   	inc    %eax
  800985:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800986:	39 d8                	cmp    %ebx,%eax
  800988:	74 15                	je     80099f <strncmp+0x2c>
  80098a:	8a 08                	mov    (%eax),%cl
  80098c:	84 c9                	test   %cl,%cl
  80098e:	74 04                	je     800994 <strncmp+0x21>
  800990:	3a 0a                	cmp    (%edx),%cl
  800992:	74 f0                	je     800984 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800994:	0f b6 00             	movzbl (%eax),%eax
  800997:	0f b6 12             	movzbl (%edx),%edx
  80099a:	29 d0                	sub    %edx,%eax
}
  80099c:	5b                   	pop    %ebx
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    
		return 0;
  80099f:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a4:	eb f6                	jmp    80099c <strncmp+0x29>

008009a6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8009af:	8a 10                	mov    (%eax),%dl
  8009b1:	84 d2                	test   %dl,%dl
  8009b3:	74 07                	je     8009bc <strchr+0x16>
		if (*s == c)
  8009b5:	38 ca                	cmp    %cl,%dl
  8009b7:	74 08                	je     8009c1 <strchr+0x1b>
	for (; *s; s++)
  8009b9:	40                   	inc    %eax
  8009ba:	eb f3                	jmp    8009af <strchr+0x9>
			return (char *) s;
	return 0;
  8009bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8009cc:	8a 10                	mov    (%eax),%dl
  8009ce:	84 d2                	test   %dl,%dl
  8009d0:	74 07                	je     8009d9 <strfind+0x16>
		if (*s == c)
  8009d2:	38 ca                	cmp    %cl,%dl
  8009d4:	74 03                	je     8009d9 <strfind+0x16>
	for (; *s; s++)
  8009d6:	40                   	inc    %eax
  8009d7:	eb f3                	jmp    8009cc <strfind+0x9>
			break;
	return (char *) s;
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	57                   	push   %edi
  8009df:	56                   	push   %esi
  8009e0:	53                   	push   %ebx
  8009e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009e7:	85 c9                	test   %ecx,%ecx
  8009e9:	74 13                	je     8009fe <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009eb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009f1:	75 05                	jne    8009f8 <memset+0x1d>
  8009f3:	f6 c1 03             	test   $0x3,%cl
  8009f6:	74 0d                	je     800a05 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	fc                   	cld    
  8009fc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fe:	89 f8                	mov    %edi,%eax
  800a00:	5b                   	pop    %ebx
  800a01:	5e                   	pop    %esi
  800a02:	5f                   	pop    %edi
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    
		c &= 0xFF;
  800a05:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a09:	89 d3                	mov    %edx,%ebx
  800a0b:	c1 e3 08             	shl    $0x8,%ebx
  800a0e:	89 d0                	mov    %edx,%eax
  800a10:	c1 e0 18             	shl    $0x18,%eax
  800a13:	89 d6                	mov    %edx,%esi
  800a15:	c1 e6 10             	shl    $0x10,%esi
  800a18:	09 f0                	or     %esi,%eax
  800a1a:	09 c2                	or     %eax,%edx
  800a1c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a1e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a21:	89 d0                	mov    %edx,%eax
  800a23:	fc                   	cld    
  800a24:	f3 ab                	rep stos %eax,%es:(%edi)
  800a26:	eb d6                	jmp    8009fe <memset+0x23>

00800a28 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	57                   	push   %edi
  800a2c:	56                   	push   %esi
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a33:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a36:	39 c6                	cmp    %eax,%esi
  800a38:	73 33                	jae    800a6d <memmove+0x45>
  800a3a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a3d:	39 d0                	cmp    %edx,%eax
  800a3f:	73 2c                	jae    800a6d <memmove+0x45>
		s += n;
		d += n;
  800a41:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a44:	89 d6                	mov    %edx,%esi
  800a46:	09 fe                	or     %edi,%esi
  800a48:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4e:	75 13                	jne    800a63 <memmove+0x3b>
  800a50:	f6 c1 03             	test   $0x3,%cl
  800a53:	75 0e                	jne    800a63 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a55:	83 ef 04             	sub    $0x4,%edi
  800a58:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a5b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a5e:	fd                   	std    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb 07                	jmp    800a6a <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a63:	4f                   	dec    %edi
  800a64:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a67:	fd                   	std    
  800a68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a6a:	fc                   	cld    
  800a6b:	eb 13                	jmp    800a80 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6d:	89 f2                	mov    %esi,%edx
  800a6f:	09 c2                	or     %eax,%edx
  800a71:	f6 c2 03             	test   $0x3,%dl
  800a74:	75 05                	jne    800a7b <memmove+0x53>
  800a76:	f6 c1 03             	test   $0x3,%cl
  800a79:	74 09                	je     800a84 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a7b:	89 c7                	mov    %eax,%edi
  800a7d:	fc                   	cld    
  800a7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a80:	5e                   	pop    %esi
  800a81:	5f                   	pop    %edi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a87:	89 c7                	mov    %eax,%edi
  800a89:	fc                   	cld    
  800a8a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a8c:	eb f2                	jmp    800a80 <memmove+0x58>

00800a8e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	ff 75 08             	pushl  0x8(%ebp)
  800a9a:	e8 89 ff ff ff       	call   800a28 <memmove>
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	56                   	push   %esi
  800aa5:	53                   	push   %ebx
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	89 c6                	mov    %eax,%esi
  800aab:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800ab1:	39 f0                	cmp    %esi,%eax
  800ab3:	74 16                	je     800acb <memcmp+0x2a>
		if (*s1 != *s2)
  800ab5:	8a 08                	mov    (%eax),%cl
  800ab7:	8a 1a                	mov    (%edx),%bl
  800ab9:	38 d9                	cmp    %bl,%cl
  800abb:	75 04                	jne    800ac1 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800abd:	40                   	inc    %eax
  800abe:	42                   	inc    %edx
  800abf:	eb f0                	jmp    800ab1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ac1:	0f b6 c1             	movzbl %cl,%eax
  800ac4:	0f b6 db             	movzbl %bl,%ebx
  800ac7:	29 d8                	sub    %ebx,%eax
  800ac9:	eb 05                	jmp    800ad0 <memcmp+0x2f>
	}

	return 0;
  800acb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad0:	5b                   	pop    %ebx
  800ad1:	5e                   	pop    %esi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800add:	89 c2                	mov    %eax,%edx
  800adf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae2:	39 d0                	cmp    %edx,%eax
  800ae4:	73 07                	jae    800aed <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae6:	38 08                	cmp    %cl,(%eax)
  800ae8:	74 03                	je     800aed <memfind+0x19>
	for (; s < ends; s++)
  800aea:	40                   	inc    %eax
  800aeb:	eb f5                	jmp    800ae2 <memfind+0xe>
			break;
	return (void *) s;
}
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af8:	eb 01                	jmp    800afb <strtol+0xc>
		s++;
  800afa:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800afb:	8a 01                	mov    (%ecx),%al
  800afd:	3c 20                	cmp    $0x20,%al
  800aff:	74 f9                	je     800afa <strtol+0xb>
  800b01:	3c 09                	cmp    $0x9,%al
  800b03:	74 f5                	je     800afa <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800b05:	3c 2b                	cmp    $0x2b,%al
  800b07:	74 2b                	je     800b34 <strtol+0x45>
		s++;
	else if (*s == '-')
  800b09:	3c 2d                	cmp    $0x2d,%al
  800b0b:	74 2f                	je     800b3c <strtol+0x4d>
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b12:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800b19:	75 12                	jne    800b2d <strtol+0x3e>
  800b1b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b1e:	74 24                	je     800b44 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b24:	75 07                	jne    800b2d <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b26:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b32:	eb 4e                	jmp    800b82 <strtol+0x93>
		s++;
  800b34:	41                   	inc    %ecx
	int neg = 0;
  800b35:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3a:	eb d6                	jmp    800b12 <strtol+0x23>
		s++, neg = 1;
  800b3c:	41                   	inc    %ecx
  800b3d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b42:	eb ce                	jmp    800b12 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b44:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b48:	74 10                	je     800b5a <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800b4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b4e:	75 dd                	jne    800b2d <strtol+0x3e>
		s++, base = 8;
  800b50:	41                   	inc    %ecx
  800b51:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800b58:	eb d3                	jmp    800b2d <strtol+0x3e>
		s += 2, base = 16;
  800b5a:	83 c1 02             	add    $0x2,%ecx
  800b5d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800b64:	eb c7                	jmp    800b2d <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b66:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b69:	89 f3                	mov    %esi,%ebx
  800b6b:	80 fb 19             	cmp    $0x19,%bl
  800b6e:	77 24                	ja     800b94 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800b70:	0f be d2             	movsbl %dl,%edx
  800b73:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b76:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b79:	7d 2b                	jge    800ba6 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800b7b:	41                   	inc    %ecx
  800b7c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b80:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b82:	8a 11                	mov    (%ecx),%dl
  800b84:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b87:	80 fb 09             	cmp    $0x9,%bl
  800b8a:	77 da                	ja     800b66 <strtol+0x77>
			dig = *s - '0';
  800b8c:	0f be d2             	movsbl %dl,%edx
  800b8f:	83 ea 30             	sub    $0x30,%edx
  800b92:	eb e2                	jmp    800b76 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b94:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b97:	89 f3                	mov    %esi,%ebx
  800b99:	80 fb 19             	cmp    $0x19,%bl
  800b9c:	77 08                	ja     800ba6 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b9e:	0f be d2             	movsbl %dl,%edx
  800ba1:	83 ea 37             	sub    $0x37,%edx
  800ba4:	eb d0                	jmp    800b76 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ba6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800baa:	74 05                	je     800bb1 <strtol+0xc2>
		*endptr = (char *) s;
  800bac:	8b 75 0c             	mov    0xc(%ebp),%esi
  800baf:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb1:	85 ff                	test   %edi,%edi
  800bb3:	74 02                	je     800bb7 <strtol+0xc8>
  800bb5:	f7 d8                	neg    %eax
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <atoi>:

int
atoi(const char *s)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800bbf:	6a 0a                	push   $0xa
  800bc1:	6a 00                	push   $0x0
  800bc3:	ff 75 08             	pushl  0x8(%ebp)
  800bc6:	e8 24 ff ff ff       	call   800aef <strtol>
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bde:	89 c3                	mov    %eax,%ebx
  800be0:	89 c7                	mov    %eax,%edi
  800be2:	89 c6                	mov    %eax,%esi
  800be4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <sys_cgetc>:

int
sys_cgetc(void)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfb:	89 d1                	mov    %edx,%ecx
  800bfd:	89 d3                	mov    %edx,%ebx
  800bff:	89 d7                	mov    %edx,%edi
  800c01:	89 d6                	mov    %edx,%esi
  800c03:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5f                   	pop    %edi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	57                   	push   %edi
  800c0e:	56                   	push   %esi
  800c0f:	53                   	push   %ebx
  800c10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c13:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c18:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c20:	89 cb                	mov    %ecx,%ebx
  800c22:	89 cf                	mov    %ecx,%edi
  800c24:	89 ce                	mov    %ecx,%esi
  800c26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	7f 08                	jg     800c34 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	50                   	push   %eax
  800c38:	6a 03                	push   $0x3
  800c3a:	68 df 29 80 00       	push   $0x8029df
  800c3f:	6a 23                	push   $0x23
  800c41:	68 fc 29 80 00       	push   $0x8029fc
  800c46:	e8 4f f5 ff ff       	call   80019a <_panic>

00800c4b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c51:	ba 00 00 00 00       	mov    $0x0,%edx
  800c56:	b8 02 00 00 00       	mov    $0x2,%eax
  800c5b:	89 d1                	mov    %edx,%ecx
  800c5d:	89 d3                	mov    %edx,%ebx
  800c5f:	89 d7                	mov    %edx,%edi
  800c61:	89 d6                	mov    %edx,%esi
  800c63:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c73:	be 00 00 00 00       	mov    $0x0,%esi
  800c78:	b8 04 00 00 00       	mov    $0x4,%eax
  800c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c86:	89 f7                	mov    %esi,%edi
  800c88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	7f 08                	jg     800c96 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	50                   	push   %eax
  800c9a:	6a 04                	push   $0x4
  800c9c:	68 df 29 80 00       	push   $0x8029df
  800ca1:	6a 23                	push   $0x23
  800ca3:	68 fc 29 80 00       	push   $0x8029fc
  800ca8:	e8 ed f4 ff ff       	call   80019a <_panic>

00800cad <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
  800cb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb6:	b8 05 00 00 00       	mov    $0x5,%eax
  800cbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cc7:	8b 75 18             	mov    0x18(%ebp),%esi
  800cca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	7f 08                	jg     800cd8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd8:	83 ec 0c             	sub    $0xc,%esp
  800cdb:	50                   	push   %eax
  800cdc:	6a 05                	push   $0x5
  800cde:	68 df 29 80 00       	push   $0x8029df
  800ce3:	6a 23                	push   $0x23
  800ce5:	68 fc 29 80 00       	push   $0x8029fc
  800cea:	e8 ab f4 ff ff       	call   80019a <_panic>

00800cef <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
  800cf5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfd:	b8 06 00 00 00       	mov    $0x6,%eax
  800d02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	89 df                	mov    %ebx,%edi
  800d0a:	89 de                	mov    %ebx,%esi
  800d0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0e:	85 c0                	test   %eax,%eax
  800d10:	7f 08                	jg     800d1a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1a:	83 ec 0c             	sub    $0xc,%esp
  800d1d:	50                   	push   %eax
  800d1e:	6a 06                	push   $0x6
  800d20:	68 df 29 80 00       	push   $0x8029df
  800d25:	6a 23                	push   $0x23
  800d27:	68 fc 29 80 00       	push   $0x8029fc
  800d2c:	e8 69 f4 ff ff       	call   80019a <_panic>

00800d31 <sys_yield>:

void
sys_yield(void)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	57                   	push   %edi
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d37:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d41:	89 d1                	mov    %edx,%ecx
  800d43:	89 d3                	mov    %edx,%ebx
  800d45:	89 d7                	mov    %edx,%edi
  800d47:	89 d6                	mov    %edx,%esi
  800d49:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5e:	b8 08 00 00 00       	mov    $0x8,%eax
  800d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	89 df                	mov    %ebx,%edi
  800d6b:	89 de                	mov    %ebx,%esi
  800d6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6f:	85 c0                	test   %eax,%eax
  800d71:	7f 08                	jg     800d7b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7b:	83 ec 0c             	sub    $0xc,%esp
  800d7e:	50                   	push   %eax
  800d7f:	6a 08                	push   $0x8
  800d81:	68 df 29 80 00       	push   $0x8029df
  800d86:	6a 23                	push   $0x23
  800d88:	68 fc 29 80 00       	push   $0x8029fc
  800d8d:	e8 08 f4 ff ff       	call   80019a <_panic>

00800d92 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
  800d98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	89 cb                	mov    %ecx,%ebx
  800daa:	89 cf                	mov    %ecx,%edi
  800dac:	89 ce                	mov    %ecx,%esi
  800dae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db0:	85 c0                	test   %eax,%eax
  800db2:	7f 08                	jg     800dbc <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbc:	83 ec 0c             	sub    $0xc,%esp
  800dbf:	50                   	push   %eax
  800dc0:	6a 0c                	push   $0xc
  800dc2:	68 df 29 80 00       	push   $0x8029df
  800dc7:	6a 23                	push   $0x23
  800dc9:	68 fc 29 80 00       	push   $0x8029fc
  800dce:	e8 c7 f3 ff ff       	call   80019a <_panic>

00800dd3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de1:	b8 09 00 00 00       	mov    $0x9,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	89 df                	mov    %ebx,%edi
  800dee:	89 de                	mov    %ebx,%esi
  800df0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7f 08                	jg     800dfe <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df9:	5b                   	pop    %ebx
  800dfa:	5e                   	pop    %esi
  800dfb:	5f                   	pop    %edi
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfe:	83 ec 0c             	sub    $0xc,%esp
  800e01:	50                   	push   %eax
  800e02:	6a 09                	push   $0x9
  800e04:	68 df 29 80 00       	push   $0x8029df
  800e09:	6a 23                	push   $0x23
  800e0b:	68 fc 29 80 00       	push   $0x8029fc
  800e10:	e8 85 f3 ff ff       	call   80019a <_panic>

00800e15 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	57                   	push   %edi
  800e19:	56                   	push   %esi
  800e1a:	53                   	push   %ebx
  800e1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e23:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	89 df                	mov    %ebx,%edi
  800e30:	89 de                	mov    %ebx,%esi
  800e32:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e34:	85 c0                	test   %eax,%eax
  800e36:	7f 08                	jg     800e40 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e40:	83 ec 0c             	sub    $0xc,%esp
  800e43:	50                   	push   %eax
  800e44:	6a 0a                	push   $0xa
  800e46:	68 df 29 80 00       	push   $0x8029df
  800e4b:	6a 23                	push   $0x23
  800e4d:	68 fc 29 80 00       	push   $0x8029fc
  800e52:	e8 43 f3 ff ff       	call   80019a <_panic>

00800e57 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5d:	be 00 00 00 00       	mov    $0x0,%esi
  800e62:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e70:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e73:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e83:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e88:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 cb                	mov    %ecx,%ebx
  800e92:	89 cf                	mov    %ecx,%edi
  800e94:	89 ce                	mov    %ecx,%esi
  800e96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	7f 08                	jg     800ea4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	50                   	push   %eax
  800ea8:	6a 0e                	push   $0xe
  800eaa:	68 df 29 80 00       	push   $0x8029df
  800eaf:	6a 23                	push   $0x23
  800eb1:	68 fc 29 80 00       	push   $0x8029fc
  800eb6:	e8 df f2 ff ff       	call   80019a <_panic>

00800ebb <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec1:	be 00 00 00 00       	mov    $0x0,%esi
  800ec6:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ecb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed4:	89 f7                	mov    %esi,%edi
  800ed6:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800ed8:	5b                   	pop    %ebx
  800ed9:	5e                   	pop    %esi
  800eda:	5f                   	pop    %edi
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee3:	be 00 00 00 00       	mov    $0x0,%esi
  800ee8:	b8 10 00 00 00       	mov    $0x10,%eax
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef6:	89 f7                	mov    %esi,%edi
  800ef8:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    

00800eff <sys_set_console_color>:

void sys_set_console_color(int color) {
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	57                   	push   %edi
  800f03:	56                   	push   %esi
  800f04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f05:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0a:	b8 11 00 00 00       	mov    $0x11,%eax
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	89 cb                	mov    %ecx,%ebx
  800f14:	89 cf                	mov    %ecx,%edi
  800f16:	89 ce                	mov    %ecx,%esi
  800f18:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	05 00 00 00 30       	add    $0x30000000,%eax
  800f2a:	c1 e8 0c             	shr    $0xc,%eax
}
  800f2d:	5d                   	pop    %ebp
  800f2e:	c3                   	ret    

00800f2f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f3f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f4c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f51:	89 c2                	mov    %eax,%edx
  800f53:	c1 ea 16             	shr    $0x16,%edx
  800f56:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f5d:	f6 c2 01             	test   $0x1,%dl
  800f60:	74 2a                	je     800f8c <fd_alloc+0x46>
  800f62:	89 c2                	mov    %eax,%edx
  800f64:	c1 ea 0c             	shr    $0xc,%edx
  800f67:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f6e:	f6 c2 01             	test   $0x1,%dl
  800f71:	74 19                	je     800f8c <fd_alloc+0x46>
  800f73:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f78:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f7d:	75 d2                	jne    800f51 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f7f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f85:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f8a:	eb 07                	jmp    800f93 <fd_alloc+0x4d>
			*fd_store = fd;
  800f8c:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f98:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800f9c:	77 39                	ja     800fd7 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	c1 e0 0c             	shl    $0xc,%eax
  800fa4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fa9:	89 c2                	mov    %eax,%edx
  800fab:	c1 ea 16             	shr    $0x16,%edx
  800fae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fb5:	f6 c2 01             	test   $0x1,%dl
  800fb8:	74 24                	je     800fde <fd_lookup+0x49>
  800fba:	89 c2                	mov    %eax,%edx
  800fbc:	c1 ea 0c             	shr    $0xc,%edx
  800fbf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fc6:	f6 c2 01             	test   $0x1,%dl
  800fc9:	74 1a                	je     800fe5 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fce:	89 02                	mov    %eax,(%edx)
	return 0;
  800fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    
		return -E_INVAL;
  800fd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fdc:	eb f7                	jmp    800fd5 <fd_lookup+0x40>
		return -E_INVAL;
  800fde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe3:	eb f0                	jmp    800fd5 <fd_lookup+0x40>
  800fe5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fea:	eb e9                	jmp    800fd5 <fd_lookup+0x40>

00800fec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	83 ec 08             	sub    $0x8,%esp
  800ff2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff5:	ba 88 2a 80 00       	mov    $0x802a88,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ffa:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fff:	39 08                	cmp    %ecx,(%eax)
  801001:	74 33                	je     801036 <dev_lookup+0x4a>
  801003:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801006:	8b 02                	mov    (%edx),%eax
  801008:	85 c0                	test   %eax,%eax
  80100a:	75 f3                	jne    800fff <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80100c:	a1 04 40 80 00       	mov    0x804004,%eax
  801011:	8b 40 48             	mov    0x48(%eax),%eax
  801014:	83 ec 04             	sub    $0x4,%esp
  801017:	51                   	push   %ecx
  801018:	50                   	push   %eax
  801019:	68 0c 2a 80 00       	push   $0x802a0c
  80101e:	e8 8a f2 ff ff       	call   8002ad <cprintf>
	*dev = 0;
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80102c:	83 c4 10             	add    $0x10,%esp
  80102f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801034:	c9                   	leave  
  801035:	c3                   	ret    
			*dev = devtab[i];
  801036:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801039:	89 01                	mov    %eax,(%ecx)
			return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
  801040:	eb f2                	jmp    801034 <dev_lookup+0x48>

00801042 <fd_close>:
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	57                   	push   %edi
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
  801048:	83 ec 1c             	sub    $0x1c,%esp
  80104b:	8b 75 08             	mov    0x8(%ebp),%esi
  80104e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801051:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801054:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801055:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80105e:	50                   	push   %eax
  80105f:	e8 31 ff ff ff       	call   800f95 <fd_lookup>
  801064:	89 c7                	mov    %eax,%edi
  801066:	83 c4 08             	add    $0x8,%esp
  801069:	85 c0                	test   %eax,%eax
  80106b:	78 05                	js     801072 <fd_close+0x30>
	    || fd != fd2)
  80106d:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801070:	74 13                	je     801085 <fd_close+0x43>
		return (must_exist ? r : 0);
  801072:	84 db                	test   %bl,%bl
  801074:	75 05                	jne    80107b <fd_close+0x39>
  801076:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80107b:	89 f8                	mov    %edi,%eax
  80107d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80108b:	50                   	push   %eax
  80108c:	ff 36                	pushl  (%esi)
  80108e:	e8 59 ff ff ff       	call   800fec <dev_lookup>
  801093:	89 c7                	mov    %eax,%edi
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	85 c0                	test   %eax,%eax
  80109a:	78 15                	js     8010b1 <fd_close+0x6f>
		if (dev->dev_close)
  80109c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80109f:	8b 40 10             	mov    0x10(%eax),%eax
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	74 1b                	je     8010c1 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8010a6:	83 ec 0c             	sub    $0xc,%esp
  8010a9:	56                   	push   %esi
  8010aa:	ff d0                	call   *%eax
  8010ac:	89 c7                	mov    %eax,%edi
  8010ae:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010b1:	83 ec 08             	sub    $0x8,%esp
  8010b4:	56                   	push   %esi
  8010b5:	6a 00                	push   $0x0
  8010b7:	e8 33 fc ff ff       	call   800cef <sys_page_unmap>
	return r;
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	eb ba                	jmp    80107b <fd_close+0x39>
			r = 0;
  8010c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c6:	eb e9                	jmp    8010b1 <fd_close+0x6f>

008010c8 <close>:

int
close(int fdnum)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 08             	pushl  0x8(%ebp)
  8010d5:	e8 bb fe ff ff       	call   800f95 <fd_lookup>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	78 10                	js     8010f1 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010e1:	83 ec 08             	sub    $0x8,%esp
  8010e4:	6a 01                	push   $0x1
  8010e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8010e9:	e8 54 ff ff ff       	call   801042 <fd_close>
  8010ee:	83 c4 10             	add    $0x10,%esp
}
  8010f1:	c9                   	leave  
  8010f2:	c3                   	ret    

008010f3 <close_all>:

void
close_all(void)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	53                   	push   %ebx
  8010f7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010fa:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010ff:	83 ec 0c             	sub    $0xc,%esp
  801102:	53                   	push   %ebx
  801103:	e8 c0 ff ff ff       	call   8010c8 <close>
	for (i = 0; i < MAXFD; i++)
  801108:	43                   	inc    %ebx
  801109:	83 c4 10             	add    $0x10,%esp
  80110c:	83 fb 20             	cmp    $0x20,%ebx
  80110f:	75 ee                	jne    8010ff <close_all+0xc>
}
  801111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	57                   	push   %edi
  80111a:	56                   	push   %esi
  80111b:	53                   	push   %ebx
  80111c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80111f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801122:	50                   	push   %eax
  801123:	ff 75 08             	pushl  0x8(%ebp)
  801126:	e8 6a fe ff ff       	call   800f95 <fd_lookup>
  80112b:	89 c3                	mov    %eax,%ebx
  80112d:	83 c4 08             	add    $0x8,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	0f 88 81 00 00 00    	js     8011b9 <dup+0xa3>
		return r;
	close(newfdnum);
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	e8 85 ff ff ff       	call   8010c8 <close>

	newfd = INDEX2FD(newfdnum);
  801143:	8b 75 0c             	mov    0xc(%ebp),%esi
  801146:	c1 e6 0c             	shl    $0xc,%esi
  801149:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80114f:	83 c4 04             	add    $0x4,%esp
  801152:	ff 75 e4             	pushl  -0x1c(%ebp)
  801155:	e8 d5 fd ff ff       	call   800f2f <fd2data>
  80115a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80115c:	89 34 24             	mov    %esi,(%esp)
  80115f:	e8 cb fd ff ff       	call   800f2f <fd2data>
  801164:	83 c4 10             	add    $0x10,%esp
  801167:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801169:	89 d8                	mov    %ebx,%eax
  80116b:	c1 e8 16             	shr    $0x16,%eax
  80116e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801175:	a8 01                	test   $0x1,%al
  801177:	74 11                	je     80118a <dup+0x74>
  801179:	89 d8                	mov    %ebx,%eax
  80117b:	c1 e8 0c             	shr    $0xc,%eax
  80117e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801185:	f6 c2 01             	test   $0x1,%dl
  801188:	75 39                	jne    8011c3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80118a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80118d:	89 d0                	mov    %edx,%eax
  80118f:	c1 e8 0c             	shr    $0xc,%eax
  801192:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801199:	83 ec 0c             	sub    $0xc,%esp
  80119c:	25 07 0e 00 00       	and    $0xe07,%eax
  8011a1:	50                   	push   %eax
  8011a2:	56                   	push   %esi
  8011a3:	6a 00                	push   $0x0
  8011a5:	52                   	push   %edx
  8011a6:	6a 00                	push   $0x0
  8011a8:	e8 00 fb ff ff       	call   800cad <sys_page_map>
  8011ad:	89 c3                	mov    %eax,%ebx
  8011af:	83 c4 20             	add    $0x20,%esp
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	78 31                	js     8011e7 <dup+0xd1>
		goto err;

	return newfdnum;
  8011b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011b9:	89 d8                	mov    %ebx,%eax
  8011bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011be:	5b                   	pop    %ebx
  8011bf:	5e                   	pop    %esi
  8011c0:	5f                   	pop    %edi
  8011c1:	5d                   	pop    %ebp
  8011c2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ca:	83 ec 0c             	sub    $0xc,%esp
  8011cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8011d2:	50                   	push   %eax
  8011d3:	57                   	push   %edi
  8011d4:	6a 00                	push   $0x0
  8011d6:	53                   	push   %ebx
  8011d7:	6a 00                	push   $0x0
  8011d9:	e8 cf fa ff ff       	call   800cad <sys_page_map>
  8011de:	89 c3                	mov    %eax,%ebx
  8011e0:	83 c4 20             	add    $0x20,%esp
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	79 a3                	jns    80118a <dup+0x74>
	sys_page_unmap(0, newfd);
  8011e7:	83 ec 08             	sub    $0x8,%esp
  8011ea:	56                   	push   %esi
  8011eb:	6a 00                	push   $0x0
  8011ed:	e8 fd fa ff ff       	call   800cef <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011f2:	83 c4 08             	add    $0x8,%esp
  8011f5:	57                   	push   %edi
  8011f6:	6a 00                	push   $0x0
  8011f8:	e8 f2 fa ff ff       	call   800cef <sys_page_unmap>
	return r;
  8011fd:	83 c4 10             	add    $0x10,%esp
  801200:	eb b7                	jmp    8011b9 <dup+0xa3>

00801202 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	53                   	push   %ebx
  801206:	83 ec 14             	sub    $0x14,%esp
  801209:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80120c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80120f:	50                   	push   %eax
  801210:	53                   	push   %ebx
  801211:	e8 7f fd ff ff       	call   800f95 <fd_lookup>
  801216:	83 c4 08             	add    $0x8,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 3f                	js     80125c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801223:	50                   	push   %eax
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801227:	ff 30                	pushl  (%eax)
  801229:	e8 be fd ff ff       	call   800fec <dev_lookup>
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	78 27                	js     80125c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801235:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801238:	8b 42 08             	mov    0x8(%edx),%eax
  80123b:	83 e0 03             	and    $0x3,%eax
  80123e:	83 f8 01             	cmp    $0x1,%eax
  801241:	74 1e                	je     801261 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	8b 40 08             	mov    0x8(%eax),%eax
  801249:	85 c0                	test   %eax,%eax
  80124b:	74 35                	je     801282 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80124d:	83 ec 04             	sub    $0x4,%esp
  801250:	ff 75 10             	pushl  0x10(%ebp)
  801253:	ff 75 0c             	pushl  0xc(%ebp)
  801256:	52                   	push   %edx
  801257:	ff d0                	call   *%eax
  801259:	83 c4 10             	add    $0x10,%esp
}
  80125c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125f:	c9                   	leave  
  801260:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801261:	a1 04 40 80 00       	mov    0x804004,%eax
  801266:	8b 40 48             	mov    0x48(%eax),%eax
  801269:	83 ec 04             	sub    $0x4,%esp
  80126c:	53                   	push   %ebx
  80126d:	50                   	push   %eax
  80126e:	68 4d 2a 80 00       	push   $0x802a4d
  801273:	e8 35 f0 ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801280:	eb da                	jmp    80125c <read+0x5a>
		return -E_NOT_SUPP;
  801282:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801287:	eb d3                	jmp    80125c <read+0x5a>

00801289 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	57                   	push   %edi
  80128d:	56                   	push   %esi
  80128e:	53                   	push   %ebx
  80128f:	83 ec 0c             	sub    $0xc,%esp
  801292:	8b 7d 08             	mov    0x8(%ebp),%edi
  801295:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801298:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129d:	39 f3                	cmp    %esi,%ebx
  80129f:	73 25                	jae    8012c6 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012a1:	83 ec 04             	sub    $0x4,%esp
  8012a4:	89 f0                	mov    %esi,%eax
  8012a6:	29 d8                	sub    %ebx,%eax
  8012a8:	50                   	push   %eax
  8012a9:	89 d8                	mov    %ebx,%eax
  8012ab:	03 45 0c             	add    0xc(%ebp),%eax
  8012ae:	50                   	push   %eax
  8012af:	57                   	push   %edi
  8012b0:	e8 4d ff ff ff       	call   801202 <read>
		if (m < 0)
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 08                	js     8012c4 <readn+0x3b>
			return m;
		if (m == 0)
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	74 06                	je     8012c6 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012c0:	01 c3                	add    %eax,%ebx
  8012c2:	eb d9                	jmp    80129d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012c4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012c6:	89 d8                	mov    %ebx,%eax
  8012c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cb:	5b                   	pop    %ebx
  8012cc:	5e                   	pop    %esi
  8012cd:	5f                   	pop    %edi
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 14             	sub    $0x14,%esp
  8012d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012dd:	50                   	push   %eax
  8012de:	53                   	push   %ebx
  8012df:	e8 b1 fc ff ff       	call   800f95 <fd_lookup>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	78 3a                	js     801325 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f1:	50                   	push   %eax
  8012f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f5:	ff 30                	pushl  (%eax)
  8012f7:	e8 f0 fc ff ff       	call   800fec <dev_lookup>
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 22                	js     801325 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801306:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80130a:	74 1e                	je     80132a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80130c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130f:	8b 52 0c             	mov    0xc(%edx),%edx
  801312:	85 d2                	test   %edx,%edx
  801314:	74 35                	je     80134b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801316:	83 ec 04             	sub    $0x4,%esp
  801319:	ff 75 10             	pushl  0x10(%ebp)
  80131c:	ff 75 0c             	pushl  0xc(%ebp)
  80131f:	50                   	push   %eax
  801320:	ff d2                	call   *%edx
  801322:	83 c4 10             	add    $0x10,%esp
}
  801325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801328:	c9                   	leave  
  801329:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80132a:	a1 04 40 80 00       	mov    0x804004,%eax
  80132f:	8b 40 48             	mov    0x48(%eax),%eax
  801332:	83 ec 04             	sub    $0x4,%esp
  801335:	53                   	push   %ebx
  801336:	50                   	push   %eax
  801337:	68 69 2a 80 00       	push   $0x802a69
  80133c:	e8 6c ef ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801349:	eb da                	jmp    801325 <write+0x55>
		return -E_NOT_SUPP;
  80134b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801350:	eb d3                	jmp    801325 <write+0x55>

00801352 <seek>:

int
seek(int fdnum, off_t offset)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801358:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80135b:	50                   	push   %eax
  80135c:	ff 75 08             	pushl  0x8(%ebp)
  80135f:	e8 31 fc ff ff       	call   800f95 <fd_lookup>
  801364:	83 c4 08             	add    $0x8,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 0e                	js     801379 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80136b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80136e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801371:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801374:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	53                   	push   %ebx
  80137f:	83 ec 14             	sub    $0x14,%esp
  801382:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801385:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801388:	50                   	push   %eax
  801389:	53                   	push   %ebx
  80138a:	e8 06 fc ff ff       	call   800f95 <fd_lookup>
  80138f:	83 c4 08             	add    $0x8,%esp
  801392:	85 c0                	test   %eax,%eax
  801394:	78 37                	js     8013cd <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801396:	83 ec 08             	sub    $0x8,%esp
  801399:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139c:	50                   	push   %eax
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	ff 30                	pushl  (%eax)
  8013a2:	e8 45 fc ff ff       	call   800fec <dev_lookup>
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	78 1f                	js     8013cd <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b5:	74 1b                	je     8013d2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ba:	8b 52 18             	mov    0x18(%edx),%edx
  8013bd:	85 d2                	test   %edx,%edx
  8013bf:	74 32                	je     8013f3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	ff 75 0c             	pushl  0xc(%ebp)
  8013c7:	50                   	push   %eax
  8013c8:	ff d2                	call   *%edx
  8013ca:	83 c4 10             	add    $0x10,%esp
}
  8013cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013d2:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013d7:	8b 40 48             	mov    0x48(%eax),%eax
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	53                   	push   %ebx
  8013de:	50                   	push   %eax
  8013df:	68 2c 2a 80 00       	push   $0x802a2c
  8013e4:	e8 c4 ee ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f1:	eb da                	jmp    8013cd <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f8:	eb d3                	jmp    8013cd <ftruncate+0x52>

008013fa <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	53                   	push   %ebx
  8013fe:	83 ec 14             	sub    $0x14,%esp
  801401:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801404:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801407:	50                   	push   %eax
  801408:	ff 75 08             	pushl  0x8(%ebp)
  80140b:	e8 85 fb ff ff       	call   800f95 <fd_lookup>
  801410:	83 c4 08             	add    $0x8,%esp
  801413:	85 c0                	test   %eax,%eax
  801415:	78 4b                	js     801462 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141d:	50                   	push   %eax
  80141e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801421:	ff 30                	pushl  (%eax)
  801423:	e8 c4 fb ff ff       	call   800fec <dev_lookup>
  801428:	83 c4 10             	add    $0x10,%esp
  80142b:	85 c0                	test   %eax,%eax
  80142d:	78 33                	js     801462 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80142f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801432:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801436:	74 2f                	je     801467 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801438:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80143b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801442:	00 00 00 
	stat->st_type = 0;
  801445:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80144c:	00 00 00 
	stat->st_dev = dev;
  80144f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801455:	83 ec 08             	sub    $0x8,%esp
  801458:	53                   	push   %ebx
  801459:	ff 75 f0             	pushl  -0x10(%ebp)
  80145c:	ff 50 14             	call   *0x14(%eax)
  80145f:	83 c4 10             	add    $0x10,%esp
}
  801462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801465:	c9                   	leave  
  801466:	c3                   	ret    
		return -E_NOT_SUPP;
  801467:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146c:	eb f4                	jmp    801462 <fstat+0x68>

0080146e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	56                   	push   %esi
  801472:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	6a 00                	push   $0x0
  801478:	ff 75 08             	pushl  0x8(%ebp)
  80147b:	e8 34 02 00 00       	call   8016b4 <open>
  801480:	89 c3                	mov    %eax,%ebx
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 1b                	js     8014a4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801489:	83 ec 08             	sub    $0x8,%esp
  80148c:	ff 75 0c             	pushl  0xc(%ebp)
  80148f:	50                   	push   %eax
  801490:	e8 65 ff ff ff       	call   8013fa <fstat>
  801495:	89 c6                	mov    %eax,%esi
	close(fd);
  801497:	89 1c 24             	mov    %ebx,(%esp)
  80149a:	e8 29 fc ff ff       	call   8010c8 <close>
	return r;
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	89 f3                	mov    %esi,%ebx
}
  8014a4:	89 d8                	mov    %ebx,%eax
  8014a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5e                   	pop    %esi
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    

008014ad <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	56                   	push   %esi
  8014b1:	53                   	push   %ebx
  8014b2:	89 c6                	mov    %eax,%esi
  8014b4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014b6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014bd:	74 27                	je     8014e6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014bf:	6a 07                	push   $0x7
  8014c1:	68 00 50 80 00       	push   $0x805000
  8014c6:	56                   	push   %esi
  8014c7:	ff 35 00 40 80 00    	pushl  0x804000
  8014cd:	e8 ca 0d 00 00       	call   80229c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014d2:	83 c4 0c             	add    $0xc,%esp
  8014d5:	6a 00                	push   $0x0
  8014d7:	53                   	push   %ebx
  8014d8:	6a 00                	push   $0x0
  8014da:	e8 34 0d 00 00       	call   802213 <ipc_recv>
}
  8014df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e2:	5b                   	pop    %ebx
  8014e3:	5e                   	pop    %esi
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	6a 01                	push   $0x1
  8014eb:	e8 08 0e 00 00       	call   8022f8 <ipc_find_env>
  8014f0:	a3 00 40 80 00       	mov    %eax,0x804000
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	eb c5                	jmp    8014bf <fsipc+0x12>

008014fa <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	8b 40 0c             	mov    0xc(%eax),%eax
  801506:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801513:	ba 00 00 00 00       	mov    $0x0,%edx
  801518:	b8 02 00 00 00       	mov    $0x2,%eax
  80151d:	e8 8b ff ff ff       	call   8014ad <fsipc>
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <devfile_flush>:
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8b 40 0c             	mov    0xc(%eax),%eax
  801530:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801535:	ba 00 00 00 00       	mov    $0x0,%edx
  80153a:	b8 06 00 00 00       	mov    $0x6,%eax
  80153f:	e8 69 ff ff ff       	call   8014ad <fsipc>
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <devfile_stat>:
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	53                   	push   %ebx
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8b 40 0c             	mov    0xc(%eax),%eax
  801556:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80155b:	ba 00 00 00 00       	mov    $0x0,%edx
  801560:	b8 05 00 00 00       	mov    $0x5,%eax
  801565:	e8 43 ff ff ff       	call   8014ad <fsipc>
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 2c                	js     80159a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	68 00 50 80 00       	push   $0x805000
  801576:	53                   	push   %ebx
  801577:	e8 39 f3 ff ff       	call   8008b5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80157c:	a1 80 50 80 00       	mov    0x805080,%eax
  801581:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801587:	a1 84 50 80 00       	mov    0x805084,%eax
  80158c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <devfile_write>:
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	53                   	push   %ebx
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8015a9:	89 d8                	mov    %ebx,%eax
  8015ab:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8015b1:	76 05                	jbe    8015b8 <devfile_write+0x19>
  8015b3:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bb:	8b 52 0c             	mov    0xc(%edx),%edx
  8015be:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8015c4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	50                   	push   %eax
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	68 08 50 80 00       	push   $0x805008
  8015d5:	e8 4e f4 ff ff       	call   800a28 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8015da:	ba 00 00 00 00       	mov    $0x0,%edx
  8015df:	b8 04 00 00 00       	mov    $0x4,%eax
  8015e4:	e8 c4 fe ff ff       	call   8014ad <fsipc>
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 0b                	js     8015fb <devfile_write+0x5c>
	assert(r <= n);
  8015f0:	39 c3                	cmp    %eax,%ebx
  8015f2:	72 0c                	jb     801600 <devfile_write+0x61>
	assert(r <= PGSIZE);
  8015f4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015f9:	7f 1e                	jg     801619 <devfile_write+0x7a>
}
  8015fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    
	assert(r <= n);
  801600:	68 98 2a 80 00       	push   $0x802a98
  801605:	68 9f 2a 80 00       	push   $0x802a9f
  80160a:	68 98 00 00 00       	push   $0x98
  80160f:	68 b4 2a 80 00       	push   $0x802ab4
  801614:	e8 81 eb ff ff       	call   80019a <_panic>
	assert(r <= PGSIZE);
  801619:	68 bf 2a 80 00       	push   $0x802abf
  80161e:	68 9f 2a 80 00       	push   $0x802a9f
  801623:	68 99 00 00 00       	push   $0x99
  801628:	68 b4 2a 80 00       	push   $0x802ab4
  80162d:	e8 68 eb ff ff       	call   80019a <_panic>

00801632 <devfile_read>:
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	56                   	push   %esi
  801636:	53                   	push   %ebx
  801637:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	8b 40 0c             	mov    0xc(%eax),%eax
  801640:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801645:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80164b:	ba 00 00 00 00       	mov    $0x0,%edx
  801650:	b8 03 00 00 00       	mov    $0x3,%eax
  801655:	e8 53 fe ff ff       	call   8014ad <fsipc>
  80165a:	89 c3                	mov    %eax,%ebx
  80165c:	85 c0                	test   %eax,%eax
  80165e:	78 1f                	js     80167f <devfile_read+0x4d>
	assert(r <= n);
  801660:	39 c6                	cmp    %eax,%esi
  801662:	72 24                	jb     801688 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801664:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801669:	7f 33                	jg     80169e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	50                   	push   %eax
  80166f:	68 00 50 80 00       	push   $0x805000
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	e8 ac f3 ff ff       	call   800a28 <memmove>
	return r;
  80167c:	83 c4 10             	add    $0x10,%esp
}
  80167f:	89 d8                	mov    %ebx,%eax
  801681:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801684:	5b                   	pop    %ebx
  801685:	5e                   	pop    %esi
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    
	assert(r <= n);
  801688:	68 98 2a 80 00       	push   $0x802a98
  80168d:	68 9f 2a 80 00       	push   $0x802a9f
  801692:	6a 7c                	push   $0x7c
  801694:	68 b4 2a 80 00       	push   $0x802ab4
  801699:	e8 fc ea ff ff       	call   80019a <_panic>
	assert(r <= PGSIZE);
  80169e:	68 bf 2a 80 00       	push   $0x802abf
  8016a3:	68 9f 2a 80 00       	push   $0x802a9f
  8016a8:	6a 7d                	push   $0x7d
  8016aa:	68 b4 2a 80 00       	push   $0x802ab4
  8016af:	e8 e6 ea ff ff       	call   80019a <_panic>

008016b4 <open>:
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	56                   	push   %esi
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 1c             	sub    $0x1c,%esp
  8016bc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016bf:	56                   	push   %esi
  8016c0:	e8 bd f1 ff ff       	call   800882 <strlen>
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016cd:	7f 6c                	jg     80173b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016cf:	83 ec 0c             	sub    $0xc,%esp
  8016d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	e8 6b f8 ff ff       	call   800f46 <fd_alloc>
  8016db:	89 c3                	mov    %eax,%ebx
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	78 3c                	js     801720 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	56                   	push   %esi
  8016e8:	68 00 50 80 00       	push   $0x805000
  8016ed:	e8 c3 f1 ff ff       	call   8008b5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016fd:	b8 01 00 00 00       	mov    $0x1,%eax
  801702:	e8 a6 fd ff ff       	call   8014ad <fsipc>
  801707:	89 c3                	mov    %eax,%ebx
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	85 c0                	test   %eax,%eax
  80170e:	78 19                	js     801729 <open+0x75>
	return fd2num(fd);
  801710:	83 ec 0c             	sub    $0xc,%esp
  801713:	ff 75 f4             	pushl  -0xc(%ebp)
  801716:	e8 04 f8 ff ff       	call   800f1f <fd2num>
  80171b:	89 c3                	mov    %eax,%ebx
  80171d:	83 c4 10             	add    $0x10,%esp
}
  801720:	89 d8                	mov    %ebx,%eax
  801722:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801725:	5b                   	pop    %ebx
  801726:	5e                   	pop    %esi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    
		fd_close(fd, 0);
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	6a 00                	push   $0x0
  80172e:	ff 75 f4             	pushl  -0xc(%ebp)
  801731:	e8 0c f9 ff ff       	call   801042 <fd_close>
		return r;
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	eb e5                	jmp    801720 <open+0x6c>
		return -E_BAD_PATH;
  80173b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801740:	eb de                	jmp    801720 <open+0x6c>

00801742 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801748:	ba 00 00 00 00       	mov    $0x0,%edx
  80174d:	b8 08 00 00 00       	mov    $0x8,%eax
  801752:	e8 56 fd ff ff       	call   8014ad <fsipc>
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	57                   	push   %edi
  80175d:	56                   	push   %esi
  80175e:	53                   	push   %ebx
  80175f:	81 ec 94 02 00 00    	sub    $0x294,%esp
  801765:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801768:	6a 00                	push   $0x0
  80176a:	ff 75 08             	pushl  0x8(%ebp)
  80176d:	e8 42 ff ff ff       	call   8016b4 <open>
  801772:	89 c1                	mov    %eax,%ecx
  801774:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	0f 88 ba 04 00 00    	js     801c3f <spawn+0x4e6>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 00 02 00 00       	push   $0x200
  80178d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801793:	50                   	push   %eax
  801794:	51                   	push   %ecx
  801795:	e8 ef fa ff ff       	call   801289 <readn>
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	3d 00 02 00 00       	cmp    $0x200,%eax
  8017a2:	0f 85 93 00 00 00    	jne    80183b <spawn+0xe2>
	    || elf->e_magic != ELF_MAGIC) {
  8017a8:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8017af:	45 4c 46 
  8017b2:	0f 85 83 00 00 00    	jne    80183b <spawn+0xe2>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8017b8:	b8 07 00 00 00       	mov    $0x7,%eax
  8017bd:	cd 30                	int    $0x30
  8017bf:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8017c5:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	0f 88 77 04 00 00    	js     801c4a <spawn+0x4f1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8017db:	89 d0                	mov    %edx,%eax
  8017dd:	c1 e0 05             	shl    $0x5,%eax
  8017e0:	29 d0                	sub    %edx,%eax
  8017e2:	8d 34 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%esi
  8017e9:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8017ef:	b9 11 00 00 00       	mov    $0x11,%ecx
  8017f4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8017f6:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8017fc:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801802:	ba 00 00 00 00       	mov    $0x0,%edx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
	string_size = 0;
  80180c:	bf 00 00 00 00       	mov    $0x0,%edi
  801811:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801814:	89 c3                	mov    %eax,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  801816:	89 d9                	mov    %ebx,%ecx
  801818:	8d 72 04             	lea    0x4(%edx),%esi
  80181b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181e:	8b 44 30 fc          	mov    -0x4(%eax,%esi,1),%eax
  801822:	85 c0                	test   %eax,%eax
  801824:	74 48                	je     80186e <spawn+0x115>
		string_size += strlen(argv[argc]) + 1;
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	50                   	push   %eax
  80182a:	e8 53 f0 ff ff       	call   800882 <strlen>
  80182f:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801833:	43                   	inc    %ebx
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	89 f2                	mov    %esi,%edx
  801839:	eb db                	jmp    801816 <spawn+0xbd>
		close(fd);
  80183b:	83 ec 0c             	sub    $0xc,%esp
  80183e:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801844:	e8 7f f8 ff ff       	call   8010c8 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801849:	83 c4 0c             	add    $0xc,%esp
  80184c:	68 7f 45 4c 46       	push   $0x464c457f
  801851:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801857:	68 cb 2a 80 00       	push   $0x802acb
  80185c:	e8 4c ea ff ff       	call   8002ad <cprintf>
		return -E_NOT_EXEC;
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
  801869:	e9 62 02 00 00       	jmp    801ad0 <spawn+0x377>
  80186e:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801874:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  80187a:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801880:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801883:	be 00 10 40 00       	mov    $0x401000,%esi
  801888:	29 fe                	sub    %edi,%esi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80188a:	89 f2                	mov    %esi,%edx
  80188c:	83 e2 fc             	and    $0xfffffffc,%edx
  80188f:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
  801896:	29 c2                	sub    %eax,%edx
  801898:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80189e:	8d 42 f8             	lea    -0x8(%edx),%eax
  8018a1:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8018a6:	0f 86 a9 03 00 00    	jbe    801c55 <spawn+0x4fc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	6a 07                	push   $0x7
  8018b1:	68 00 00 40 00       	push   $0x400000
  8018b6:	6a 00                	push   $0x0
  8018b8:	e8 ad f3 ff ff       	call   800c6a <sys_page_alloc>
  8018bd:	89 c7                	mov    %eax,%edi
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	0f 88 06 02 00 00    	js     801ad0 <spawn+0x377>
  8018ca:	bf 00 00 00 00       	mov    $0x0,%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8018cf:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8018d5:	7e 30                	jle    801907 <spawn+0x1ae>
		argv_store[i] = UTEMP2USTACK(string_store);
  8018d7:	8d 86 00 d0 7f ee    	lea    -0x11803000(%esi),%eax
  8018dd:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8018e3:	89 04 b9             	mov    %eax,(%ecx,%edi,4)
		strcpy(string_store, argv[i]);
  8018e6:	83 ec 08             	sub    $0x8,%esp
  8018e9:	ff 34 bb             	pushl  (%ebx,%edi,4)
  8018ec:	56                   	push   %esi
  8018ed:	e8 c3 ef ff ff       	call   8008b5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8018f2:	83 c4 04             	add    $0x4,%esp
  8018f5:	ff 34 bb             	pushl  (%ebx,%edi,4)
  8018f8:	e8 85 ef ff ff       	call   800882 <strlen>
  8018fd:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (i = 0; i < argc; i++) {
  801901:	47                   	inc    %edi
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	eb c8                	jmp    8018cf <spawn+0x176>
	}
	argv_store[argc] = 0;
  801907:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80190d:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801913:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80191a:	81 fe 00 10 40 00    	cmp    $0x401000,%esi
  801920:	0f 85 8c 00 00 00    	jne    8019b2 <spawn+0x259>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801926:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  80192c:	89 c8                	mov    %ecx,%eax
  80192e:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801933:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801936:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80193c:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80193f:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801945:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	6a 07                	push   $0x7
  801950:	68 00 d0 bf ee       	push   $0xeebfd000
  801955:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80195b:	68 00 00 40 00       	push   $0x400000
  801960:	6a 00                	push   $0x0
  801962:	e8 46 f3 ff ff       	call   800cad <sys_page_map>
  801967:	89 c7                	mov    %eax,%edi
  801969:	83 c4 20             	add    $0x20,%esp
  80196c:	85 c0                	test   %eax,%eax
  80196e:	0f 88 3e 03 00 00    	js     801cb2 <spawn+0x559>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	68 00 00 40 00       	push   $0x400000
  80197c:	6a 00                	push   $0x0
  80197e:	e8 6c f3 ff ff       	call   800cef <sys_page_unmap>
  801983:	89 c7                	mov    %eax,%edi
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	85 c0                	test   %eax,%eax
  80198a:	0f 88 22 03 00 00    	js     801cb2 <spawn+0x559>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801990:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801996:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80199d:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019a3:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  8019aa:	00 00 00 
  8019ad:	e9 4a 01 00 00       	jmp    801afc <spawn+0x3a3>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8019b2:	68 58 2b 80 00       	push   $0x802b58
  8019b7:	68 9f 2a 80 00       	push   $0x802a9f
  8019bc:	68 f1 00 00 00       	push   $0xf1
  8019c1:	68 e5 2a 80 00       	push   $0x802ae5
  8019c6:	e8 cf e7 ff ff       	call   80019a <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	6a 07                	push   $0x7
  8019d0:	68 00 00 40 00       	push   $0x400000
  8019d5:	6a 00                	push   $0x0
  8019d7:	e8 8e f2 ff ff       	call   800c6a <sys_page_alloc>
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	0f 88 78 02 00 00    	js     801c5f <spawn+0x506>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8019e7:	83 ec 08             	sub    $0x8,%esp
  8019ea:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8019f0:	01 f8                	add    %edi,%eax
  8019f2:	50                   	push   %eax
  8019f3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019f9:	e8 54 f9 ff ff       	call   801352 <seek>
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	85 c0                	test   %eax,%eax
  801a03:	0f 88 5d 02 00 00    	js     801c66 <spawn+0x50d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a12:	29 f8                	sub    %edi,%eax
  801a14:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a19:	76 05                	jbe    801a20 <spawn+0x2c7>
  801a1b:	b8 00 10 00 00       	mov    $0x1000,%eax
  801a20:	50                   	push   %eax
  801a21:	68 00 00 40 00       	push   $0x400000
  801a26:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a2c:	e8 58 f8 ff ff       	call   801289 <readn>
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	85 c0                	test   %eax,%eax
  801a36:	0f 88 31 02 00 00    	js     801c6d <spawn+0x514>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801a3c:	83 ec 0c             	sub    $0xc,%esp
  801a3f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801a45:	56                   	push   %esi
  801a46:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801a4c:	68 00 00 40 00       	push   $0x400000
  801a51:	6a 00                	push   $0x0
  801a53:	e8 55 f2 ff ff       	call   800cad <sys_page_map>
  801a58:	83 c4 20             	add    $0x20,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 7b                	js     801ada <spawn+0x381>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	68 00 00 40 00       	push   $0x400000
  801a67:	6a 00                	push   $0x0
  801a69:	e8 81 f2 ff ff       	call   800cef <sys_page_unmap>
  801a6e:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801a71:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a77:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801a7d:	89 df                	mov    %ebx,%edi
  801a7f:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  801a85:	73 68                	jae    801aef <spawn+0x396>
		if (i >= filesz) {
  801a87:	3b 9d 94 fd ff ff    	cmp    -0x26c(%ebp),%ebx
  801a8d:	0f 82 38 ff ff ff    	jb     8019cb <spawn+0x272>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801a93:	83 ec 04             	sub    $0x4,%esp
  801a96:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801a9c:	56                   	push   %esi
  801a9d:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801aa3:	e8 c2 f1 ff ff       	call   800c6a <sys_page_alloc>
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	85 c0                	test   %eax,%eax
  801aad:	79 c2                	jns    801a71 <spawn+0x318>
  801aaf:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801ab1:	83 ec 0c             	sub    $0xc,%esp
  801ab4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801aba:	e8 4b f1 ff ff       	call   800c0a <sys_env_destroy>
	close(fd);
  801abf:	83 c4 04             	add    $0x4,%esp
  801ac2:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ac8:	e8 fb f5 ff ff       	call   8010c8 <close>
	return r;
  801acd:	83 c4 10             	add    $0x10,%esp
}
  801ad0:	89 f8                	mov    %edi,%eax
  801ad2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ad5:	5b                   	pop    %ebx
  801ad6:	5e                   	pop    %esi
  801ad7:	5f                   	pop    %edi
  801ad8:	5d                   	pop    %ebp
  801ad9:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801ada:	50                   	push   %eax
  801adb:	68 f1 2a 80 00       	push   $0x802af1
  801ae0:	68 24 01 00 00       	push   $0x124
  801ae5:	68 e5 2a 80 00       	push   $0x802ae5
  801aea:	e8 ab e6 ff ff       	call   80019a <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801aef:	ff 85 78 fd ff ff    	incl   -0x288(%ebp)
  801af5:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801afc:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801b03:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801b09:	7d 71                	jge    801b7c <spawn+0x423>
		if (ph->p_type != ELF_PROG_LOAD)
  801b0b:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801b11:	83 38 01             	cmpl   $0x1,(%eax)
  801b14:	75 d9                	jne    801aef <spawn+0x396>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b16:	89 c1                	mov    %eax,%ecx
  801b18:	8b 40 18             	mov    0x18(%eax),%eax
  801b1b:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801b1e:	83 f8 01             	cmp    $0x1,%eax
  801b21:	19 c0                	sbb    %eax,%eax
  801b23:	83 e0 fe             	and    $0xfffffffe,%eax
  801b26:	83 c0 07             	add    $0x7,%eax
  801b29:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b2f:	89 c8                	mov    %ecx,%eax
  801b31:	8b 49 04             	mov    0x4(%ecx),%ecx
  801b34:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801b3a:	8b 50 10             	mov    0x10(%eax),%edx
  801b3d:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801b43:	8b 78 14             	mov    0x14(%eax),%edi
  801b46:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
  801b4c:	8b 70 08             	mov    0x8(%eax),%esi
	if ((i = PGOFF(va))) {
  801b4f:	89 f0                	mov    %esi,%eax
  801b51:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b56:	74 1a                	je     801b72 <spawn+0x419>
		va -= i;
  801b58:	29 c6                	sub    %eax,%esi
		memsz += i;
  801b5a:	01 c7                	add    %eax,%edi
  801b5c:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
		filesz += i;
  801b62:	01 c2                	add    %eax,%edx
  801b64:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
		fileoffset -= i;
  801b6a:	29 c1                	sub    %eax,%ecx
  801b6c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801b72:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b77:	e9 01 ff ff ff       	jmp    801a7d <spawn+0x324>
	close(fd);
  801b7c:	83 ec 0c             	sub    $0xc,%esp
  801b7f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801b85:	e8 3e f5 ff ff       	call   8010c8 <close>
  801b8a:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  801b8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b92:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801b98:	eb 12                	jmp    801bac <spawn+0x453>
  801b9a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ba0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ba6:	0f 84 c8 00 00 00    	je     801c74 <spawn+0x51b>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U) && (uvpt[PGNUM(pn)] & PTE_SHARE)) {
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	c1 e8 16             	shr    $0x16,%eax
  801bb1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801bb8:	a8 01                	test   $0x1,%al
  801bba:	74 de                	je     801b9a <spawn+0x441>
  801bbc:	89 d8                	mov    %ebx,%eax
  801bbe:	c1 e8 0c             	shr    $0xc,%eax
  801bc1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bc8:	f6 c2 04             	test   $0x4,%dl
  801bcb:	74 cd                	je     801b9a <spawn+0x441>
  801bcd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bd4:	f6 c6 04             	test   $0x4,%dh
  801bd7:	74 c1                	je     801b9a <spawn+0x441>
			if (sys_page_map(sys_getenvid(), (void*)(pn), child, (void*)(pn), uvpt[PGNUM(pn)] & PTE_SYSCALL) < 0) {
  801bd9:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  801be0:	e8 66 f0 ff ff       	call   800c4b <sys_getenvid>
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801bee:	57                   	push   %edi
  801bef:	53                   	push   %ebx
  801bf0:	56                   	push   %esi
  801bf1:	53                   	push   %ebx
  801bf2:	50                   	push   %eax
  801bf3:	e8 b5 f0 ff ff       	call   800cad <sys_page_map>
  801bf8:	83 c4 20             	add    $0x20,%esp
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	79 9b                	jns    801b9a <spawn+0x441>
		panic("copy_shared_pages: %e", r);
  801bff:	6a ff                	push   $0xffffffff
  801c01:	68 3f 2b 80 00       	push   $0x802b3f
  801c06:	68 82 00 00 00       	push   $0x82
  801c0b:	68 e5 2a 80 00       	push   $0x802ae5
  801c10:	e8 85 e5 ff ff       	call   80019a <_panic>
		panic("sys_env_set_trapframe: %e", r);
  801c15:	50                   	push   %eax
  801c16:	68 0e 2b 80 00       	push   $0x802b0e
  801c1b:	68 85 00 00 00       	push   $0x85
  801c20:	68 e5 2a 80 00       	push   $0x802ae5
  801c25:	e8 70 e5 ff ff       	call   80019a <_panic>
		panic("sys_env_set_status: %e", r);
  801c2a:	50                   	push   %eax
  801c2b:	68 28 2b 80 00       	push   $0x802b28
  801c30:	68 88 00 00 00       	push   $0x88
  801c35:	68 e5 2a 80 00       	push   $0x802ae5
  801c3a:	e8 5b e5 ff ff       	call   80019a <_panic>
		return r;
  801c3f:	8b bd 8c fd ff ff    	mov    -0x274(%ebp),%edi
  801c45:	e9 86 fe ff ff       	jmp    801ad0 <spawn+0x377>
		return r;
  801c4a:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  801c50:	e9 7b fe ff ff       	jmp    801ad0 <spawn+0x377>
		return -E_NO_MEM;
  801c55:	bf fc ff ff ff       	mov    $0xfffffffc,%edi
  801c5a:	e9 71 fe ff ff       	jmp    801ad0 <spawn+0x377>
  801c5f:	89 c7                	mov    %eax,%edi
  801c61:	e9 4b fe ff ff       	jmp    801ab1 <spawn+0x358>
  801c66:	89 c7                	mov    %eax,%edi
  801c68:	e9 44 fe ff ff       	jmp    801ab1 <spawn+0x358>
  801c6d:	89 c7                	mov    %eax,%edi
  801c6f:	e9 3d fe ff ff       	jmp    801ab1 <spawn+0x358>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801c74:	83 ec 08             	sub    $0x8,%esp
  801c77:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801c7d:	50                   	push   %eax
  801c7e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c84:	e8 4a f1 ff ff       	call   800dd3 <sys_env_set_trapframe>
  801c89:	83 c4 10             	add    $0x10,%esp
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 85                	js     801c15 <spawn+0x4bc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801c90:	83 ec 08             	sub    $0x8,%esp
  801c93:	6a 02                	push   $0x2
  801c95:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c9b:	e8 b0 f0 ff ff       	call   800d50 <sys_env_set_status>
  801ca0:	83 c4 10             	add    $0x10,%esp
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	78 83                	js     801c2a <spawn+0x4d1>
	return child;
  801ca7:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  801cad:	e9 1e fe ff ff       	jmp    801ad0 <spawn+0x377>
	sys_page_unmap(0, UTEMP);
  801cb2:	83 ec 08             	sub    $0x8,%esp
  801cb5:	68 00 00 40 00       	push   $0x400000
  801cba:	6a 00                	push   $0x0
  801cbc:	e8 2e f0 ff ff       	call   800cef <sys_page_unmap>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	e9 07 fe ff ff       	jmp    801ad0 <spawn+0x377>

00801cc9 <spawnl>:
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	57                   	push   %edi
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801cd2:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801cda:	eb 03                	jmp    801cdf <spawnl+0x16>
		argc++;
  801cdc:	40                   	inc    %eax
	while(va_arg(vl, void *) != NULL)
  801cdd:	89 ca                	mov    %ecx,%edx
  801cdf:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ce2:	83 3a 00             	cmpl   $0x0,(%edx)
  801ce5:	75 f5                	jne    801cdc <spawnl+0x13>
	const char *argv[argc+2];
  801ce7:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801cee:	83 e2 f0             	and    $0xfffffff0,%edx
  801cf1:	29 d4                	sub    %edx,%esp
  801cf3:	8d 54 24 03          	lea    0x3(%esp),%edx
  801cf7:	c1 ea 02             	shr    $0x2,%edx
  801cfa:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801d01:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d06:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801d0d:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801d14:	00 
	va_start(vl, arg0);
  801d15:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801d18:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	eb 09                	jmp    801d2a <spawnl+0x61>
		argv[i+1] = va_arg(vl, const char *);
  801d21:	40                   	inc    %eax
  801d22:	8b 39                	mov    (%ecx),%edi
  801d24:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801d27:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801d2a:	39 d0                	cmp    %edx,%eax
  801d2c:	75 f3                	jne    801d21 <spawnl+0x58>
	return spawn(prog, argv);
  801d2e:	83 ec 08             	sub    $0x8,%esp
  801d31:	56                   	push   %esi
  801d32:	ff 75 08             	pushl  0x8(%ebp)
  801d35:	e8 1f fa ff ff       	call   801759 <spawn>
}
  801d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d3d:	5b                   	pop    %ebx
  801d3e:	5e                   	pop    %esi
  801d3f:	5f                   	pop    %edi
  801d40:	5d                   	pop    %ebp
  801d41:	c3                   	ret    

00801d42 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	ff 75 08             	pushl  0x8(%ebp)
  801d50:	e8 da f1 ff ff       	call   800f2f <fd2data>
  801d55:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d57:	83 c4 08             	add    $0x8,%esp
  801d5a:	68 7e 2b 80 00       	push   $0x802b7e
  801d5f:	53                   	push   %ebx
  801d60:	e8 50 eb ff ff       	call   8008b5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d65:	8b 46 04             	mov    0x4(%esi),%eax
  801d68:	2b 06                	sub    (%esi),%eax
  801d6a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801d70:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801d77:	10 00 00 
	stat->st_dev = &devpipe;
  801d7a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d81:	30 80 00 
	return 0;
}
  801d84:	b8 00 00 00 00       	mov    $0x0,%eax
  801d89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8c:	5b                   	pop    %ebx
  801d8d:	5e                   	pop    %esi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    

00801d90 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	53                   	push   %ebx
  801d94:	83 ec 0c             	sub    $0xc,%esp
  801d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d9a:	53                   	push   %ebx
  801d9b:	6a 00                	push   $0x0
  801d9d:	e8 4d ef ff ff       	call   800cef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801da2:	89 1c 24             	mov    %ebx,(%esp)
  801da5:	e8 85 f1 ff ff       	call   800f2f <fd2data>
  801daa:	83 c4 08             	add    $0x8,%esp
  801dad:	50                   	push   %eax
  801dae:	6a 00                	push   $0x0
  801db0:	e8 3a ef ff ff       	call   800cef <sys_page_unmap>
}
  801db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <_pipeisclosed>:
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	57                   	push   %edi
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
  801dc0:	83 ec 1c             	sub    $0x1c,%esp
  801dc3:	89 c7                	mov    %eax,%edi
  801dc5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dc7:	a1 04 40 80 00       	mov    0x804004,%eax
  801dcc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	57                   	push   %edi
  801dd3:	e8 62 05 00 00       	call   80233a <pageref>
  801dd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ddb:	89 34 24             	mov    %esi,(%esp)
  801dde:	e8 57 05 00 00       	call   80233a <pageref>
		nn = thisenv->env_runs;
  801de3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801de9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	39 cb                	cmp    %ecx,%ebx
  801df1:	74 1b                	je     801e0e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801df3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801df6:	75 cf                	jne    801dc7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801df8:	8b 42 58             	mov    0x58(%edx),%eax
  801dfb:	6a 01                	push   $0x1
  801dfd:	50                   	push   %eax
  801dfe:	53                   	push   %ebx
  801dff:	68 85 2b 80 00       	push   $0x802b85
  801e04:	e8 a4 e4 ff ff       	call   8002ad <cprintf>
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	eb b9                	jmp    801dc7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e0e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e11:	0f 94 c0             	sete   %al
  801e14:	0f b6 c0             	movzbl %al,%eax
}
  801e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5f                   	pop    %edi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <devpipe_write>:
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	57                   	push   %edi
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
  801e25:	83 ec 18             	sub    $0x18,%esp
  801e28:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e2b:	56                   	push   %esi
  801e2c:	e8 fe f0 ff ff       	call   800f2f <fd2data>
  801e31:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e3e:	74 41                	je     801e81 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e40:	8b 53 04             	mov    0x4(%ebx),%edx
  801e43:	8b 03                	mov    (%ebx),%eax
  801e45:	83 c0 20             	add    $0x20,%eax
  801e48:	39 c2                	cmp    %eax,%edx
  801e4a:	72 14                	jb     801e60 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e4c:	89 da                	mov    %ebx,%edx
  801e4e:	89 f0                	mov    %esi,%eax
  801e50:	e8 65 ff ff ff       	call   801dba <_pipeisclosed>
  801e55:	85 c0                	test   %eax,%eax
  801e57:	75 2c                	jne    801e85 <devpipe_write+0x66>
			sys_yield();
  801e59:	e8 d3 ee ff ff       	call   800d31 <sys_yield>
  801e5e:	eb e0                	jmp    801e40 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801e66:	89 d0                	mov    %edx,%eax
  801e68:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801e6d:	78 0b                	js     801e7a <devpipe_write+0x5b>
  801e6f:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801e73:	42                   	inc    %edx
  801e74:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e77:	47                   	inc    %edi
  801e78:	eb c1                	jmp    801e3b <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e7a:	48                   	dec    %eax
  801e7b:	83 c8 e0             	or     $0xffffffe0,%eax
  801e7e:	40                   	inc    %eax
  801e7f:	eb ee                	jmp    801e6f <devpipe_write+0x50>
	return i;
  801e81:	89 f8                	mov    %edi,%eax
  801e83:	eb 05                	jmp    801e8a <devpipe_write+0x6b>
				return 0;
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e8d:	5b                   	pop    %ebx
  801e8e:	5e                   	pop    %esi
  801e8f:	5f                   	pop    %edi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    

00801e92 <devpipe_read>:
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	57                   	push   %edi
  801e96:	56                   	push   %esi
  801e97:	53                   	push   %ebx
  801e98:	83 ec 18             	sub    $0x18,%esp
  801e9b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e9e:	57                   	push   %edi
  801e9f:	e8 8b f0 ff ff       	call   800f2f <fd2data>
  801ea4:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eae:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801eb1:	74 46                	je     801ef9 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801eb3:	8b 06                	mov    (%esi),%eax
  801eb5:	3b 46 04             	cmp    0x4(%esi),%eax
  801eb8:	75 22                	jne    801edc <devpipe_read+0x4a>
			if (i > 0)
  801eba:	85 db                	test   %ebx,%ebx
  801ebc:	74 0a                	je     801ec8 <devpipe_read+0x36>
				return i;
  801ebe:	89 d8                	mov    %ebx,%eax
}
  801ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec3:	5b                   	pop    %ebx
  801ec4:	5e                   	pop    %esi
  801ec5:	5f                   	pop    %edi
  801ec6:	5d                   	pop    %ebp
  801ec7:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801ec8:	89 f2                	mov    %esi,%edx
  801eca:	89 f8                	mov    %edi,%eax
  801ecc:	e8 e9 fe ff ff       	call   801dba <_pipeisclosed>
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	75 28                	jne    801efd <devpipe_read+0x6b>
			sys_yield();
  801ed5:	e8 57 ee ff ff       	call   800d31 <sys_yield>
  801eda:	eb d7                	jmp    801eb3 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801edc:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801ee1:	78 0f                	js     801ef2 <devpipe_read+0x60>
  801ee3:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eea:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801eed:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801eef:	43                   	inc    %ebx
  801ef0:	eb bc                	jmp    801eae <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ef2:	48                   	dec    %eax
  801ef3:	83 c8 e0             	or     $0xffffffe0,%eax
  801ef6:	40                   	inc    %eax
  801ef7:	eb ea                	jmp    801ee3 <devpipe_read+0x51>
	return i;
  801ef9:	89 d8                	mov    %ebx,%eax
  801efb:	eb c3                	jmp    801ec0 <devpipe_read+0x2e>
				return 0;
  801efd:	b8 00 00 00 00       	mov    $0x0,%eax
  801f02:	eb bc                	jmp    801ec0 <devpipe_read+0x2e>

00801f04 <pipe>:
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	56                   	push   %esi
  801f08:	53                   	push   %ebx
  801f09:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0f:	50                   	push   %eax
  801f10:	e8 31 f0 ff ff       	call   800f46 <fd_alloc>
  801f15:	89 c3                	mov    %eax,%ebx
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	0f 88 2a 01 00 00    	js     80204c <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f22:	83 ec 04             	sub    $0x4,%esp
  801f25:	68 07 04 00 00       	push   $0x407
  801f2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2d:	6a 00                	push   $0x0
  801f2f:	e8 36 ed ff ff       	call   800c6a <sys_page_alloc>
  801f34:	89 c3                	mov    %eax,%ebx
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	0f 88 0b 01 00 00    	js     80204c <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801f41:	83 ec 0c             	sub    $0xc,%esp
  801f44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f47:	50                   	push   %eax
  801f48:	e8 f9 ef ff ff       	call   800f46 <fd_alloc>
  801f4d:	89 c3                	mov    %eax,%ebx
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	85 c0                	test   %eax,%eax
  801f54:	0f 88 e2 00 00 00    	js     80203c <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	68 07 04 00 00       	push   $0x407
  801f62:	ff 75 f0             	pushl  -0x10(%ebp)
  801f65:	6a 00                	push   $0x0
  801f67:	e8 fe ec ff ff       	call   800c6a <sys_page_alloc>
  801f6c:	89 c3                	mov    %eax,%ebx
  801f6e:	83 c4 10             	add    $0x10,%esp
  801f71:	85 c0                	test   %eax,%eax
  801f73:	0f 88 c3 00 00 00    	js     80203c <pipe+0x138>
	va = fd2data(fd0);
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7f:	e8 ab ef ff ff       	call   800f2f <fd2data>
  801f84:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f86:	83 c4 0c             	add    $0xc,%esp
  801f89:	68 07 04 00 00       	push   $0x407
  801f8e:	50                   	push   %eax
  801f8f:	6a 00                	push   $0x0
  801f91:	e8 d4 ec ff ff       	call   800c6a <sys_page_alloc>
  801f96:	89 c3                	mov    %eax,%ebx
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	0f 88 89 00 00 00    	js     80202c <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa9:	e8 81 ef ff ff       	call   800f2f <fd2data>
  801fae:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fb5:	50                   	push   %eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	56                   	push   %esi
  801fb9:	6a 00                	push   $0x0
  801fbb:	e8 ed ec ff ff       	call   800cad <sys_page_map>
  801fc0:	89 c3                	mov    %eax,%ebx
  801fc2:	83 c4 20             	add    $0x20,%esp
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 55                	js     80201e <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801fc9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801fde:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff9:	e8 21 ef ff ff       	call   800f1f <fd2num>
  801ffe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802001:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802003:	83 c4 04             	add    $0x4,%esp
  802006:	ff 75 f0             	pushl  -0x10(%ebp)
  802009:	e8 11 ef ff ff       	call   800f1f <fd2num>
  80200e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802011:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	bb 00 00 00 00       	mov    $0x0,%ebx
  80201c:	eb 2e                	jmp    80204c <pipe+0x148>
	sys_page_unmap(0, va);
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	56                   	push   %esi
  802022:	6a 00                	push   $0x0
  802024:	e8 c6 ec ff ff       	call   800cef <sys_page_unmap>
  802029:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80202c:	83 ec 08             	sub    $0x8,%esp
  80202f:	ff 75 f0             	pushl  -0x10(%ebp)
  802032:	6a 00                	push   $0x0
  802034:	e8 b6 ec ff ff       	call   800cef <sys_page_unmap>
  802039:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80203c:	83 ec 08             	sub    $0x8,%esp
  80203f:	ff 75 f4             	pushl  -0xc(%ebp)
  802042:	6a 00                	push   $0x0
  802044:	e8 a6 ec ff ff       	call   800cef <sys_page_unmap>
  802049:	83 c4 10             	add    $0x10,%esp
}
  80204c:	89 d8                	mov    %ebx,%eax
  80204e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802051:	5b                   	pop    %ebx
  802052:	5e                   	pop    %esi
  802053:	5d                   	pop    %ebp
  802054:	c3                   	ret    

00802055 <pipeisclosed>:
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80205b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205e:	50                   	push   %eax
  80205f:	ff 75 08             	pushl  0x8(%ebp)
  802062:	e8 2e ef ff ff       	call   800f95 <fd_lookup>
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 18                	js     802086 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80206e:	83 ec 0c             	sub    $0xc,%esp
  802071:	ff 75 f4             	pushl  -0xc(%ebp)
  802074:	e8 b6 ee ff ff       	call   800f2f <fd2data>
	return _pipeisclosed(fd, p);
  802079:	89 c2                	mov    %eax,%edx
  80207b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207e:	e8 37 fd ff ff       	call   801dba <_pipeisclosed>
  802083:	83 c4 10             	add    $0x10,%esp
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    

00802092 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	53                   	push   %ebx
  802096:	83 ec 0c             	sub    $0xc,%esp
  802099:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  80209c:	68 9d 2b 80 00       	push   $0x802b9d
  8020a1:	53                   	push   %ebx
  8020a2:	e8 0e e8 ff ff       	call   8008b5 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  8020a7:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8020ae:	20 00 00 
	return 0;
}
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <devcons_write>:
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	57                   	push   %edi
  8020bf:	56                   	push   %esi
  8020c0:	53                   	push   %ebx
  8020c1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020c7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020cc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020d2:	eb 1d                	jmp    8020f1 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	53                   	push   %ebx
  8020d8:	03 45 0c             	add    0xc(%ebp),%eax
  8020db:	50                   	push   %eax
  8020dc:	57                   	push   %edi
  8020dd:	e8 46 e9 ff ff       	call   800a28 <memmove>
		sys_cputs(buf, m);
  8020e2:	83 c4 08             	add    $0x8,%esp
  8020e5:	53                   	push   %ebx
  8020e6:	57                   	push   %edi
  8020e7:	e8 e1 ea ff ff       	call   800bcd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020ec:	01 de                	add    %ebx,%esi
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	89 f0                	mov    %esi,%eax
  8020f3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f6:	73 11                	jae    802109 <devcons_write+0x4e>
		m = n - tot;
  8020f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020fb:	29 f3                	sub    %esi,%ebx
  8020fd:	83 fb 7f             	cmp    $0x7f,%ebx
  802100:	76 d2                	jbe    8020d4 <devcons_write+0x19>
  802102:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  802107:	eb cb                	jmp    8020d4 <devcons_write+0x19>
}
  802109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80210c:	5b                   	pop    %ebx
  80210d:	5e                   	pop    %esi
  80210e:	5f                   	pop    %edi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    

00802111 <devcons_read>:
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  802117:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80211b:	75 0c                	jne    802129 <devcons_read+0x18>
		return 0;
  80211d:	b8 00 00 00 00       	mov    $0x0,%eax
  802122:	eb 21                	jmp    802145 <devcons_read+0x34>
		sys_yield();
  802124:	e8 08 ec ff ff       	call   800d31 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802129:	e8 bd ea ff ff       	call   800beb <sys_cgetc>
  80212e:	85 c0                	test   %eax,%eax
  802130:	74 f2                	je     802124 <devcons_read+0x13>
	if (c < 0)
  802132:	85 c0                	test   %eax,%eax
  802134:	78 0f                	js     802145 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  802136:	83 f8 04             	cmp    $0x4,%eax
  802139:	74 0c                	je     802147 <devcons_read+0x36>
	*(char*)vbuf = c;
  80213b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213e:	88 02                	mov    %al,(%edx)
	return 1;
  802140:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    
		return 0;
  802147:	b8 00 00 00 00       	mov    $0x0,%eax
  80214c:	eb f7                	jmp    802145 <devcons_read+0x34>

0080214e <cputchar>:
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80215a:	6a 01                	push   $0x1
  80215c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80215f:	50                   	push   %eax
  802160:	e8 68 ea ff ff       	call   800bcd <sys_cputs>
}
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <getchar>:
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802170:	6a 01                	push   $0x1
  802172:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802175:	50                   	push   %eax
  802176:	6a 00                	push   $0x0
  802178:	e8 85 f0 ff ff       	call   801202 <read>
	if (r < 0)
  80217d:	83 c4 10             	add    $0x10,%esp
  802180:	85 c0                	test   %eax,%eax
  802182:	78 08                	js     80218c <getchar+0x22>
	if (r < 1)
  802184:	85 c0                	test   %eax,%eax
  802186:	7e 06                	jle    80218e <getchar+0x24>
	return c;
  802188:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    
		return -E_EOF;
  80218e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802193:	eb f7                	jmp    80218c <getchar+0x22>

00802195 <iscons>:
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80219b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80219e:	50                   	push   %eax
  80219f:	ff 75 08             	pushl  0x8(%ebp)
  8021a2:	e8 ee ed ff ff       	call   800f95 <fd_lookup>
  8021a7:	83 c4 10             	add    $0x10,%esp
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	78 11                	js     8021bf <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021b7:	39 10                	cmp    %edx,(%eax)
  8021b9:	0f 94 c0             	sete   %al
  8021bc:	0f b6 c0             	movzbl %al,%eax
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <opencons>:
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ca:	50                   	push   %eax
  8021cb:	e8 76 ed ff ff       	call   800f46 <fd_alloc>
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	78 3a                	js     802211 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	68 07 04 00 00       	push   $0x407
  8021df:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e2:	6a 00                	push   $0x0
  8021e4:	e8 81 ea ff ff       	call   800c6a <sys_page_alloc>
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	78 21                	js     802211 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021f0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	50                   	push   %eax
  802209:	e8 11 ed ff ff       	call   800f1f <fd2num>
  80220e:	83 c4 10             	add    $0x10,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
  802216:	57                   	push   %edi
  802217:	56                   	push   %esi
  802218:	53                   	push   %ebx
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80221f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802222:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  802225:	85 ff                	test   %edi,%edi
  802227:	74 53                	je     80227c <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  802229:	83 ec 0c             	sub    $0xc,%esp
  80222c:	57                   	push   %edi
  80222d:	e8 48 ec ff ff       	call   800e7a <sys_ipc_recv>
  802232:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  802235:	85 db                	test   %ebx,%ebx
  802237:	74 0b                	je     802244 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802239:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80223f:	8b 52 74             	mov    0x74(%edx),%edx
  802242:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  802244:	85 f6                	test   %esi,%esi
  802246:	74 0f                	je     802257 <ipc_recv+0x44>
  802248:	85 ff                	test   %edi,%edi
  80224a:	74 0b                	je     802257 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80224c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802252:	8b 52 78             	mov    0x78(%edx),%edx
  802255:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  802257:	85 c0                	test   %eax,%eax
  802259:	74 30                	je     80228b <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  80225b:	85 db                	test   %ebx,%ebx
  80225d:	74 06                	je     802265 <ipc_recv+0x52>
      		*from_env_store = 0;
  80225f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  802265:	85 f6                	test   %esi,%esi
  802267:	74 2c                	je     802295 <ipc_recv+0x82>
      		*perm_store = 0;
  802269:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80226f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  802274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5f                   	pop    %edi
  80227a:	5d                   	pop    %ebp
  80227b:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  80227c:	83 ec 0c             	sub    $0xc,%esp
  80227f:	6a ff                	push   $0xffffffff
  802281:	e8 f4 eb ff ff       	call   800e7a <sys_ipc_recv>
  802286:	83 c4 10             	add    $0x10,%esp
  802289:	eb aa                	jmp    802235 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  80228b:	a1 04 40 80 00       	mov    0x804004,%eax
  802290:	8b 40 70             	mov    0x70(%eax),%eax
  802293:	eb df                	jmp    802274 <ipc_recv+0x61>
		return -1;
  802295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80229a:	eb d8                	jmp    802274 <ipc_recv+0x61>

0080229c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	57                   	push   %edi
  8022a0:	56                   	push   %esi
  8022a1:	53                   	push   %ebx
  8022a2:	83 ec 0c             	sub    $0xc,%esp
  8022a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022ab:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8022ae:	85 db                	test   %ebx,%ebx
  8022b0:	75 22                	jne    8022d4 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8022b2:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8022b7:	eb 1b                	jmp    8022d4 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8022b9:	68 ac 2b 80 00       	push   $0x802bac
  8022be:	68 9f 2a 80 00       	push   $0x802a9f
  8022c3:	6a 48                	push   $0x48
  8022c5:	68 d0 2b 80 00       	push   $0x802bd0
  8022ca:	e8 cb de ff ff       	call   80019a <_panic>
		sys_yield();
  8022cf:	e8 5d ea ff ff       	call   800d31 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8022d4:	57                   	push   %edi
  8022d5:	53                   	push   %ebx
  8022d6:	56                   	push   %esi
  8022d7:	ff 75 08             	pushl  0x8(%ebp)
  8022da:	e8 78 eb ff ff       	call   800e57 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8022df:	83 c4 10             	add    $0x10,%esp
  8022e2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022e5:	74 e8                	je     8022cf <ipc_send+0x33>
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	75 ce                	jne    8022b9 <ipc_send+0x1d>
		sys_yield();
  8022eb:	e8 41 ea ff ff       	call   800d31 <sys_yield>
		
	}
	
}
  8022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f3:	5b                   	pop    %ebx
  8022f4:	5e                   	pop    %esi
  8022f5:	5f                   	pop    %edi
  8022f6:	5d                   	pop    %ebp
  8022f7:	c3                   	ret    

008022f8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802303:	89 c2                	mov    %eax,%edx
  802305:	c1 e2 05             	shl    $0x5,%edx
  802308:	29 c2                	sub    %eax,%edx
  80230a:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  802311:	8b 52 50             	mov    0x50(%edx),%edx
  802314:	39 ca                	cmp    %ecx,%edx
  802316:	74 0f                	je     802327 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802318:	40                   	inc    %eax
  802319:	3d 00 04 00 00       	cmp    $0x400,%eax
  80231e:	75 e3                	jne    802303 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
  802325:	eb 11                	jmp    802338 <ipc_find_env+0x40>
			return envs[i].env_id;
  802327:	89 c2                	mov    %eax,%edx
  802329:	c1 e2 05             	shl    $0x5,%edx
  80232c:	29 c2                	sub    %eax,%edx
  80232e:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  802335:	8b 40 48             	mov    0x48(%eax),%eax
}
  802338:	5d                   	pop    %ebp
  802339:	c3                   	ret    

0080233a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	c1 e8 16             	shr    $0x16,%eax
  802343:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80234a:	a8 01                	test   $0x1,%al
  80234c:	74 21                	je     80236f <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	c1 e8 0c             	shr    $0xc,%eax
  802354:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80235b:	a8 01                	test   $0x1,%al
  80235d:	74 17                	je     802376 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80235f:	c1 e8 0c             	shr    $0xc,%eax
  802362:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802369:	ef 
  80236a:	0f b7 c0             	movzwl %ax,%eax
  80236d:	eb 05                	jmp    802374 <pageref+0x3a>
		return 0;
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    
		return 0;
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
  80237b:	eb f7                	jmp    802374 <pageref+0x3a>
  80237d:	66 90                	xchg   %ax,%ax
  80237f:	90                   	nop

00802380 <__udivdi3>:
  802380:	55                   	push   %ebp
  802381:	57                   	push   %edi
  802382:	56                   	push   %esi
  802383:	53                   	push   %ebx
  802384:	83 ec 1c             	sub    $0x1c,%esp
  802387:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80238b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80238f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802393:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802397:	89 ca                	mov    %ecx,%edx
  802399:	89 f8                	mov    %edi,%eax
  80239b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80239f:	85 f6                	test   %esi,%esi
  8023a1:	75 2d                	jne    8023d0 <__udivdi3+0x50>
  8023a3:	39 cf                	cmp    %ecx,%edi
  8023a5:	77 65                	ja     80240c <__udivdi3+0x8c>
  8023a7:	89 fd                	mov    %edi,%ebp
  8023a9:	85 ff                	test   %edi,%edi
  8023ab:	75 0b                	jne    8023b8 <__udivdi3+0x38>
  8023ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b2:	31 d2                	xor    %edx,%edx
  8023b4:	f7 f7                	div    %edi
  8023b6:	89 c5                	mov    %eax,%ebp
  8023b8:	31 d2                	xor    %edx,%edx
  8023ba:	89 c8                	mov    %ecx,%eax
  8023bc:	f7 f5                	div    %ebp
  8023be:	89 c1                	mov    %eax,%ecx
  8023c0:	89 d8                	mov    %ebx,%eax
  8023c2:	f7 f5                	div    %ebp
  8023c4:	89 cf                	mov    %ecx,%edi
  8023c6:	89 fa                	mov    %edi,%edx
  8023c8:	83 c4 1c             	add    $0x1c,%esp
  8023cb:	5b                   	pop    %ebx
  8023cc:	5e                   	pop    %esi
  8023cd:	5f                   	pop    %edi
  8023ce:	5d                   	pop    %ebp
  8023cf:	c3                   	ret    
  8023d0:	39 ce                	cmp    %ecx,%esi
  8023d2:	77 28                	ja     8023fc <__udivdi3+0x7c>
  8023d4:	0f bd fe             	bsr    %esi,%edi
  8023d7:	83 f7 1f             	xor    $0x1f,%edi
  8023da:	75 40                	jne    80241c <__udivdi3+0x9c>
  8023dc:	39 ce                	cmp    %ecx,%esi
  8023de:	72 0a                	jb     8023ea <__udivdi3+0x6a>
  8023e0:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8023e4:	0f 87 9e 00 00 00    	ja     802488 <__udivdi3+0x108>
  8023ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ef:	89 fa                	mov    %edi,%edx
  8023f1:	83 c4 1c             	add    $0x1c,%esp
  8023f4:	5b                   	pop    %ebx
  8023f5:	5e                   	pop    %esi
  8023f6:	5f                   	pop    %edi
  8023f7:	5d                   	pop    %ebp
  8023f8:	c3                   	ret    
  8023f9:	8d 76 00             	lea    0x0(%esi),%esi
  8023fc:	31 ff                	xor    %edi,%edi
  8023fe:	31 c0                	xor    %eax,%eax
  802400:	89 fa                	mov    %edi,%edx
  802402:	83 c4 1c             	add    $0x1c,%esp
  802405:	5b                   	pop    %ebx
  802406:	5e                   	pop    %esi
  802407:	5f                   	pop    %edi
  802408:	5d                   	pop    %ebp
  802409:	c3                   	ret    
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	89 d8                	mov    %ebx,%eax
  80240e:	f7 f7                	div    %edi
  802410:	31 ff                	xor    %edi,%edi
  802412:	89 fa                	mov    %edi,%edx
  802414:	83 c4 1c             	add    $0x1c,%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5f                   	pop    %edi
  80241a:	5d                   	pop    %ebp
  80241b:	c3                   	ret    
  80241c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802421:	29 fd                	sub    %edi,%ebp
  802423:	89 f9                	mov    %edi,%ecx
  802425:	d3 e6                	shl    %cl,%esi
  802427:	89 c3                	mov    %eax,%ebx
  802429:	89 e9                	mov    %ebp,%ecx
  80242b:	d3 eb                	shr    %cl,%ebx
  80242d:	89 d9                	mov    %ebx,%ecx
  80242f:	09 f1                	or     %esi,%ecx
  802431:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802435:	89 f9                	mov    %edi,%ecx
  802437:	d3 e0                	shl    %cl,%eax
  802439:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80243d:	89 d6                	mov    %edx,%esi
  80243f:	89 e9                	mov    %ebp,%ecx
  802441:	d3 ee                	shr    %cl,%esi
  802443:	89 f9                	mov    %edi,%ecx
  802445:	d3 e2                	shl    %cl,%edx
  802447:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80244b:	89 e9                	mov    %ebp,%ecx
  80244d:	d3 eb                	shr    %cl,%ebx
  80244f:	09 da                	or     %ebx,%edx
  802451:	89 d0                	mov    %edx,%eax
  802453:	89 f2                	mov    %esi,%edx
  802455:	f7 74 24 08          	divl   0x8(%esp)
  802459:	89 d6                	mov    %edx,%esi
  80245b:	89 c3                	mov    %eax,%ebx
  80245d:	f7 64 24 0c          	mull   0xc(%esp)
  802461:	39 d6                	cmp    %edx,%esi
  802463:	72 17                	jb     80247c <__udivdi3+0xfc>
  802465:	74 09                	je     802470 <__udivdi3+0xf0>
  802467:	89 d8                	mov    %ebx,%eax
  802469:	31 ff                	xor    %edi,%edi
  80246b:	e9 56 ff ff ff       	jmp    8023c6 <__udivdi3+0x46>
  802470:	8b 54 24 04          	mov    0x4(%esp),%edx
  802474:	89 f9                	mov    %edi,%ecx
  802476:	d3 e2                	shl    %cl,%edx
  802478:	39 c2                	cmp    %eax,%edx
  80247a:	73 eb                	jae    802467 <__udivdi3+0xe7>
  80247c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80247f:	31 ff                	xor    %edi,%edi
  802481:	e9 40 ff ff ff       	jmp    8023c6 <__udivdi3+0x46>
  802486:	66 90                	xchg   %ax,%ax
  802488:	31 c0                	xor    %eax,%eax
  80248a:	e9 37 ff ff ff       	jmp    8023c6 <__udivdi3+0x46>
  80248f:	90                   	nop

00802490 <__umoddi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	53                   	push   %ebx
  802494:	83 ec 1c             	sub    $0x1c,%esp
  802497:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80249b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80249f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024af:	89 3c 24             	mov    %edi,(%esp)
  8024b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024b6:	89 f2                	mov    %esi,%edx
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	75 18                	jne    8024d4 <__umoddi3+0x44>
  8024bc:	39 f7                	cmp    %esi,%edi
  8024be:	0f 86 a0 00 00 00    	jbe    802564 <__umoddi3+0xd4>
  8024c4:	89 c8                	mov    %ecx,%eax
  8024c6:	f7 f7                	div    %edi
  8024c8:	89 d0                	mov    %edx,%eax
  8024ca:	31 d2                	xor    %edx,%edx
  8024cc:	83 c4 1c             	add    $0x1c,%esp
  8024cf:	5b                   	pop    %ebx
  8024d0:	5e                   	pop    %esi
  8024d1:	5f                   	pop    %edi
  8024d2:	5d                   	pop    %ebp
  8024d3:	c3                   	ret    
  8024d4:	89 f3                	mov    %esi,%ebx
  8024d6:	39 f0                	cmp    %esi,%eax
  8024d8:	0f 87 a6 00 00 00    	ja     802584 <__umoddi3+0xf4>
  8024de:	0f bd e8             	bsr    %eax,%ebp
  8024e1:	83 f5 1f             	xor    $0x1f,%ebp
  8024e4:	0f 84 a6 00 00 00    	je     802590 <__umoddi3+0x100>
  8024ea:	bf 20 00 00 00       	mov    $0x20,%edi
  8024ef:	29 ef                	sub    %ebp,%edi
  8024f1:	89 e9                	mov    %ebp,%ecx
  8024f3:	d3 e0                	shl    %cl,%eax
  8024f5:	8b 34 24             	mov    (%esp),%esi
  8024f8:	89 f2                	mov    %esi,%edx
  8024fa:	89 f9                	mov    %edi,%ecx
  8024fc:	d3 ea                	shr    %cl,%edx
  8024fe:	09 c2                	or     %eax,%edx
  802500:	89 14 24             	mov    %edx,(%esp)
  802503:	89 f2                	mov    %esi,%edx
  802505:	89 e9                	mov    %ebp,%ecx
  802507:	d3 e2                	shl    %cl,%edx
  802509:	89 54 24 04          	mov    %edx,0x4(%esp)
  80250d:	89 de                	mov    %ebx,%esi
  80250f:	89 f9                	mov    %edi,%ecx
  802511:	d3 ee                	shr    %cl,%esi
  802513:	89 e9                	mov    %ebp,%ecx
  802515:	d3 e3                	shl    %cl,%ebx
  802517:	8b 54 24 08          	mov    0x8(%esp),%edx
  80251b:	89 d0                	mov    %edx,%eax
  80251d:	89 f9                	mov    %edi,%ecx
  80251f:	d3 e8                	shr    %cl,%eax
  802521:	09 d8                	or     %ebx,%eax
  802523:	89 d3                	mov    %edx,%ebx
  802525:	89 e9                	mov    %ebp,%ecx
  802527:	d3 e3                	shl    %cl,%ebx
  802529:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80252d:	89 f2                	mov    %esi,%edx
  80252f:	f7 34 24             	divl   (%esp)
  802532:	89 d6                	mov    %edx,%esi
  802534:	f7 64 24 04          	mull   0x4(%esp)
  802538:	89 c3                	mov    %eax,%ebx
  80253a:	89 d1                	mov    %edx,%ecx
  80253c:	39 d6                	cmp    %edx,%esi
  80253e:	72 7c                	jb     8025bc <__umoddi3+0x12c>
  802540:	74 72                	je     8025b4 <__umoddi3+0x124>
  802542:	8b 54 24 08          	mov    0x8(%esp),%edx
  802546:	29 da                	sub    %ebx,%edx
  802548:	19 ce                	sbb    %ecx,%esi
  80254a:	89 f0                	mov    %esi,%eax
  80254c:	89 f9                	mov    %edi,%ecx
  80254e:	d3 e0                	shl    %cl,%eax
  802550:	89 e9                	mov    %ebp,%ecx
  802552:	d3 ea                	shr    %cl,%edx
  802554:	09 d0                	or     %edx,%eax
  802556:	89 e9                	mov    %ebp,%ecx
  802558:	d3 ee                	shr    %cl,%esi
  80255a:	89 f2                	mov    %esi,%edx
  80255c:	83 c4 1c             	add    $0x1c,%esp
  80255f:	5b                   	pop    %ebx
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
  802564:	89 fd                	mov    %edi,%ebp
  802566:	85 ff                	test   %edi,%edi
  802568:	75 0b                	jne    802575 <__umoddi3+0xe5>
  80256a:	b8 01 00 00 00       	mov    $0x1,%eax
  80256f:	31 d2                	xor    %edx,%edx
  802571:	f7 f7                	div    %edi
  802573:	89 c5                	mov    %eax,%ebp
  802575:	89 f0                	mov    %esi,%eax
  802577:	31 d2                	xor    %edx,%edx
  802579:	f7 f5                	div    %ebp
  80257b:	89 c8                	mov    %ecx,%eax
  80257d:	f7 f5                	div    %ebp
  80257f:	e9 44 ff ff ff       	jmp    8024c8 <__umoddi3+0x38>
  802584:	89 c8                	mov    %ecx,%eax
  802586:	89 f2                	mov    %esi,%edx
  802588:	83 c4 1c             	add    $0x1c,%esp
  80258b:	5b                   	pop    %ebx
  80258c:	5e                   	pop    %esi
  80258d:	5f                   	pop    %edi
  80258e:	5d                   	pop    %ebp
  80258f:	c3                   	ret    
  802590:	39 f0                	cmp    %esi,%eax
  802592:	72 05                	jb     802599 <__umoddi3+0x109>
  802594:	39 0c 24             	cmp    %ecx,(%esp)
  802597:	77 0c                	ja     8025a5 <__umoddi3+0x115>
  802599:	89 f2                	mov    %esi,%edx
  80259b:	29 f9                	sub    %edi,%ecx
  80259d:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025a1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025a5:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025a9:	83 c4 1c             	add    $0x1c,%esp
  8025ac:	5b                   	pop    %ebx
  8025ad:	5e                   	pop    %esi
  8025ae:	5f                   	pop    %edi
  8025af:	5d                   	pop    %ebp
  8025b0:	c3                   	ret    
  8025b1:	8d 76 00             	lea    0x0(%esi),%esi
  8025b4:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8025b8:	73 88                	jae    802542 <__umoddi3+0xb2>
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8025c0:	1b 14 24             	sbb    (%esp),%edx
  8025c3:	89 d1                	mov    %edx,%ecx
  8025c5:	89 c3                	mov    %eax,%ebx
  8025c7:	e9 76 ff ff ff       	jmp    802542 <__umoddi3+0xb2>
