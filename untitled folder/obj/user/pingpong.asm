
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 8d 00 00 00       	call   8000be <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 ad 0e 00 00       	call   800eee <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4d                	jne    800095 <umain+0x62>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 57 10 00 00       	call   8010af <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 f4 0a 00 00       	call   800b56 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 76 22 80 00       	push   $0x802276
  80006a:	e8 49 01 00 00       	call   8001b8 <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 16                	je     80008d <umain+0x5a>
			return;
		i++;
  800077:	43                   	inc    %ebx
		ipc_send(who, i, 0, 0);
  800078:	6a 00                	push   $0x0
  80007a:	6a 00                	push   $0x0
  80007c:	53                   	push   %ebx
  80007d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800080:	e8 b3 10 00 00       	call   801138 <ipc_send>
		if (i == 10)
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	83 fb 0a             	cmp    $0xa,%ebx
  80008b:	75 be                	jne    80004b <umain+0x18>
			return;
	}

}
  80008d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5f                   	pop    %edi
  800093:	5d                   	pop    %ebp
  800094:	c3                   	ret    
  800095:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800097:	e8 ba 0a 00 00       	call   800b56 <sys_getenvid>
  80009c:	83 ec 04             	sub    $0x4,%esp
  80009f:	53                   	push   %ebx
  8000a0:	50                   	push   %eax
  8000a1:	68 60 22 80 00       	push   $0x802260
  8000a6:	e8 0d 01 00 00       	call   8001b8 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ab:	6a 00                	push   $0x0
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b4:	e8 7f 10 00 00       	call   801138 <ipc_send>
  8000b9:	83 c4 20             	add    $0x20,%esp
  8000bc:	eb 8a                	jmp    800048 <umain+0x15>

008000be <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
  8000c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c9:	e8 88 0a 00 00       	call   800b56 <sys_getenvid>
  8000ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	c1 e2 05             	shl    $0x5,%edx
  8000d8:	29 c2                	sub    %eax,%edx
  8000da:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000e1:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e6:	85 db                	test   %ebx,%ebx
  8000e8:	7e 07                	jle    8000f1 <libmain+0x33>
		binaryname = argv[0];
  8000ea:	8b 06                	mov    (%esi),%eax
  8000ec:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f1:	83 ec 08             	sub    $0x8,%esp
  8000f4:	56                   	push   %esi
  8000f5:	53                   	push   %ebx
  8000f6:	e8 38 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000fb:	e8 0a 00 00 00       	call   80010a <exit>
}
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800106:	5b                   	pop    %ebx
  800107:	5e                   	pop    %esi
  800108:	5d                   	pop    %ebp
  800109:	c3                   	ret    

0080010a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010a:	55                   	push   %ebp
  80010b:	89 e5                	mov    %esp,%ebp
  80010d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800110:	e8 95 12 00 00       	call   8013aa <close_all>
	sys_env_destroy(0);
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	6a 00                	push   $0x0
  80011a:	e8 f6 09 00 00       	call   800b15 <sys_env_destroy>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	c9                   	leave  
  800123:	c3                   	ret    

00800124 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	53                   	push   %ebx
  800128:	83 ec 04             	sub    $0x4,%esp
  80012b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012e:	8b 13                	mov    (%ebx),%edx
  800130:	8d 42 01             	lea    0x1(%edx),%eax
  800133:	89 03                	mov    %eax,(%ebx)
  800135:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800138:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800141:	74 08                	je     80014b <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800143:	ff 43 04             	incl   0x4(%ebx)
}
  800146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800149:	c9                   	leave  
  80014a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80014b:	83 ec 08             	sub    $0x8,%esp
  80014e:	68 ff 00 00 00       	push   $0xff
  800153:	8d 43 08             	lea    0x8(%ebx),%eax
  800156:	50                   	push   %eax
  800157:	e8 7c 09 00 00       	call   800ad8 <sys_cputs>
		b->idx = 0;
  80015c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	eb dc                	jmp    800143 <putch+0x1f>

00800167 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800170:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800177:	00 00 00 
	b.cnt = 0;
  80017a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800181:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800184:	ff 75 0c             	pushl  0xc(%ebp)
  800187:	ff 75 08             	pushl  0x8(%ebp)
  80018a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	68 24 01 80 00       	push   $0x800124
  800196:	e8 17 01 00 00       	call   8002b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80019b:	83 c4 08             	add    $0x8,%esp
  80019e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001aa:	50                   	push   %eax
  8001ab:	e8 28 09 00 00       	call   800ad8 <sys_cputs>

	return b.cnt;
}
  8001b0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    

008001b8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001be:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001c1:	50                   	push   %eax
  8001c2:	ff 75 08             	pushl  0x8(%ebp)
  8001c5:	e8 9d ff ff ff       	call   800167 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ca:	c9                   	leave  
  8001cb:	c3                   	ret    

008001cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	57                   	push   %edi
  8001d0:	56                   	push   %esi
  8001d1:	53                   	push   %ebx
  8001d2:	83 ec 1c             	sub    $0x1c,%esp
  8001d5:	89 c7                	mov    %eax,%edi
  8001d7:	89 d6                	mov    %edx,%esi
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f3:	39 d3                	cmp    %edx,%ebx
  8001f5:	72 05                	jb     8001fc <printnum+0x30>
  8001f7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001fa:	77 78                	ja     800274 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	ff 75 18             	pushl  0x18(%ebp)
  800202:	8b 45 14             	mov    0x14(%ebp),%eax
  800205:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800208:	53                   	push   %ebx
  800209:	ff 75 10             	pushl  0x10(%ebp)
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800212:	ff 75 e0             	pushl  -0x20(%ebp)
  800215:	ff 75 dc             	pushl  -0x24(%ebp)
  800218:	ff 75 d8             	pushl  -0x28(%ebp)
  80021b:	e8 f0 1d 00 00       	call   802010 <__udivdi3>
  800220:	83 c4 18             	add    $0x18,%esp
  800223:	52                   	push   %edx
  800224:	50                   	push   %eax
  800225:	89 f2                	mov    %esi,%edx
  800227:	89 f8                	mov    %edi,%eax
  800229:	e8 9e ff ff ff       	call   8001cc <printnum>
  80022e:	83 c4 20             	add    $0x20,%esp
  800231:	eb 11                	jmp    800244 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	56                   	push   %esi
  800237:	ff 75 18             	pushl  0x18(%ebp)
  80023a:	ff d7                	call   *%edi
  80023c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023f:	4b                   	dec    %ebx
  800240:	85 db                	test   %ebx,%ebx
  800242:	7f ef                	jg     800233 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	56                   	push   %esi
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024e:	ff 75 e0             	pushl  -0x20(%ebp)
  800251:	ff 75 dc             	pushl  -0x24(%ebp)
  800254:	ff 75 d8             	pushl  -0x28(%ebp)
  800257:	e8 c4 1e 00 00       	call   802120 <__umoddi3>
  80025c:	83 c4 14             	add    $0x14,%esp
  80025f:	0f be 80 93 22 80 00 	movsbl 0x802293(%eax),%eax
  800266:	50                   	push   %eax
  800267:	ff d7                	call   *%edi
}
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026f:	5b                   	pop    %ebx
  800270:	5e                   	pop    %esi
  800271:	5f                   	pop    %edi
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    
  800274:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800277:	eb c6                	jmp    80023f <printnum+0x73>

00800279 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027f:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800282:	8b 10                	mov    (%eax),%edx
  800284:	3b 50 04             	cmp    0x4(%eax),%edx
  800287:	73 0a                	jae    800293 <sprintputch+0x1a>
		*b->buf++ = ch;
  800289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028c:	89 08                	mov    %ecx,(%eax)
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	88 02                	mov    %al,(%edx)
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <printfmt>:
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029e:	50                   	push   %eax
  80029f:	ff 75 10             	pushl  0x10(%ebp)
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	e8 05 00 00 00       	call   8002b2 <vprintfmt>
}
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <vprintfmt>:
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 2c             	sub    $0x2c,%esp
  8002bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8002be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c4:	e9 ae 03 00 00       	jmp    800677 <vprintfmt+0x3c5>
  8002c9:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002cd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002d4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8d 47 01             	lea    0x1(%edi),%eax
  8002ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ed:	8a 17                	mov    (%edi),%dl
  8002ef:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f2:	3c 55                	cmp    $0x55,%al
  8002f4:	0f 87 fe 03 00 00    	ja     8006f8 <vprintfmt+0x446>
  8002fa:	0f b6 c0             	movzbl %al,%eax
  8002fd:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  800304:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800307:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80030b:	eb da                	jmp    8002e7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800310:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800314:	eb d1                	jmp    8002e7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800316:	0f b6 d2             	movzbl %dl,%edx
  800319:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80031c:	b8 00 00 00 00       	mov    $0x0,%eax
  800321:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800324:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800327:	01 c0                	add    %eax,%eax
  800329:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  80032d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800330:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800333:	83 f9 09             	cmp    $0x9,%ecx
  800336:	77 52                	ja     80038a <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800338:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800339:	eb e9                	jmp    800324 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  80033b:	8b 45 14             	mov    0x14(%ebp),%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800343:	8b 45 14             	mov    0x14(%ebp),%eax
  800346:	8d 40 04             	lea    0x4(%eax),%eax
  800349:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80034f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800353:	79 92                	jns    8002e7 <vprintfmt+0x35>
				width = precision, precision = -1;
  800355:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800358:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800362:	eb 83                	jmp    8002e7 <vprintfmt+0x35>
  800364:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800368:	78 08                	js     800372 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80036d:	e9 75 ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
  800372:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800379:	eb ef                	jmp    80036a <vprintfmt+0xb8>
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80037e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800385:	e9 5d ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
  80038a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800390:	eb bd                	jmp    80034f <vprintfmt+0x9d>
			lflag++;
  800392:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800396:	e9 4c ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80039b:	8b 45 14             	mov    0x14(%ebp),%eax
  80039e:	8d 78 04             	lea    0x4(%eax),%edi
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	53                   	push   %ebx
  8003a5:	ff 30                	pushl  (%eax)
  8003a7:	ff d6                	call   *%esi
			break;
  8003a9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003ac:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003af:	e9 c0 02 00 00       	jmp    800674 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	8d 78 04             	lea    0x4(%eax),%edi
  8003ba:	8b 00                	mov    (%eax),%eax
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	78 2a                	js     8003ea <vprintfmt+0x138>
  8003c0:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c2:	83 f8 0f             	cmp    $0xf,%eax
  8003c5:	7f 27                	jg     8003ee <vprintfmt+0x13c>
  8003c7:	8b 04 85 40 25 80 00 	mov    0x802540(,%eax,4),%eax
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	74 1c                	je     8003ee <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8003d2:	50                   	push   %eax
  8003d3:	68 68 26 80 00       	push   $0x802668
  8003d8:	53                   	push   %ebx
  8003d9:	56                   	push   %esi
  8003da:	e8 b6 fe ff ff       	call   800295 <printfmt>
  8003df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e5:	e9 8a 02 00 00       	jmp    800674 <vprintfmt+0x3c2>
  8003ea:	f7 d8                	neg    %eax
  8003ec:	eb d2                	jmp    8003c0 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8003ee:	52                   	push   %edx
  8003ef:	68 ab 22 80 00       	push   $0x8022ab
  8003f4:	53                   	push   %ebx
  8003f5:	56                   	push   %esi
  8003f6:	e8 9a fe ff ff       	call   800295 <printfmt>
  8003fb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fe:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800401:	e9 6e 02 00 00       	jmp    800674 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	83 c0 04             	add    $0x4,%eax
  80040c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80040f:	8b 45 14             	mov    0x14(%ebp),%eax
  800412:	8b 38                	mov    (%eax),%edi
  800414:	85 ff                	test   %edi,%edi
  800416:	74 39                	je     800451 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800418:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041c:	0f 8e a9 00 00 00    	jle    8004cb <vprintfmt+0x219>
  800422:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800426:	0f 84 a7 00 00 00    	je     8004d3 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	ff 75 d0             	pushl  -0x30(%ebp)
  800432:	57                   	push   %edi
  800433:	e8 6b 03 00 00       	call   8007a3 <strnlen>
  800438:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80043b:	29 c1                	sub    %eax,%ecx
  80043d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800440:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800443:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800447:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80044d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044f:	eb 14                	jmp    800465 <vprintfmt+0x1b3>
				p = "(null)";
  800451:	bf a4 22 80 00       	mov    $0x8022a4,%edi
  800456:	eb c0                	jmp    800418 <vprintfmt+0x166>
					putch(padc, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	53                   	push   %ebx
  80045c:	ff 75 e0             	pushl  -0x20(%ebp)
  80045f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800461:	4f                   	dec    %edi
  800462:	83 c4 10             	add    $0x10,%esp
  800465:	85 ff                	test   %edi,%edi
  800467:	7f ef                	jg     800458 <vprintfmt+0x1a6>
  800469:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80046c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80046f:	89 c8                	mov    %ecx,%eax
  800471:	85 c9                	test   %ecx,%ecx
  800473:	78 10                	js     800485 <vprintfmt+0x1d3>
  800475:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800478:	29 c1                	sub    %eax,%ecx
  80047a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80047d:	89 75 08             	mov    %esi,0x8(%ebp)
  800480:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800483:	eb 15                	jmp    80049a <vprintfmt+0x1e8>
  800485:	b8 00 00 00 00       	mov    $0x0,%eax
  80048a:	eb e9                	jmp    800475 <vprintfmt+0x1c3>
					putch(ch, putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	52                   	push   %edx
  800491:	ff 55 08             	call   *0x8(%ebp)
  800494:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800497:	ff 4d e0             	decl   -0x20(%ebp)
  80049a:	47                   	inc    %edi
  80049b:	8a 47 ff             	mov    -0x1(%edi),%al
  80049e:	0f be d0             	movsbl %al,%edx
  8004a1:	85 d2                	test   %edx,%edx
  8004a3:	74 59                	je     8004fe <vprintfmt+0x24c>
  8004a5:	85 f6                	test   %esi,%esi
  8004a7:	78 03                	js     8004ac <vprintfmt+0x1fa>
  8004a9:	4e                   	dec    %esi
  8004aa:	78 2f                	js     8004db <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b0:	74 da                	je     80048c <vprintfmt+0x1da>
  8004b2:	0f be c0             	movsbl %al,%eax
  8004b5:	83 e8 20             	sub    $0x20,%eax
  8004b8:	83 f8 5e             	cmp    $0x5e,%eax
  8004bb:	76 cf                	jbe    80048c <vprintfmt+0x1da>
					putch('?', putdat);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	53                   	push   %ebx
  8004c1:	6a 3f                	push   $0x3f
  8004c3:	ff 55 08             	call   *0x8(%ebp)
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	eb cc                	jmp    800497 <vprintfmt+0x1e5>
  8004cb:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ce:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d1:	eb c7                	jmp    80049a <vprintfmt+0x1e8>
  8004d3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d9:	eb bf                	jmp    80049a <vprintfmt+0x1e8>
  8004db:	8b 75 08             	mov    0x8(%ebp),%esi
  8004de:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004e1:	eb 0c                	jmp    8004ef <vprintfmt+0x23d>
				putch(' ', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	6a 20                	push   $0x20
  8004e9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004eb:	4f                   	dec    %edi
  8004ec:	83 c4 10             	add    $0x10,%esp
  8004ef:	85 ff                	test   %edi,%edi
  8004f1:	7f f0                	jg     8004e3 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f9:	e9 76 01 00 00       	jmp    800674 <vprintfmt+0x3c2>
  8004fe:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800501:	8b 75 08             	mov    0x8(%ebp),%esi
  800504:	eb e9                	jmp    8004ef <vprintfmt+0x23d>
	if (lflag >= 2)
  800506:	83 f9 01             	cmp    $0x1,%ecx
  800509:	7f 1f                	jg     80052a <vprintfmt+0x278>
	else if (lflag)
  80050b:	85 c9                	test   %ecx,%ecx
  80050d:	75 48                	jne    800557 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800517:	89 c1                	mov    %eax,%ecx
  800519:	c1 f9 1f             	sar    $0x1f,%ecx
  80051c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8d 40 04             	lea    0x4(%eax),%eax
  800525:	89 45 14             	mov    %eax,0x14(%ebp)
  800528:	eb 17                	jmp    800541 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8b 50 04             	mov    0x4(%eax),%edx
  800530:	8b 00                	mov    (%eax),%eax
  800532:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800535:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	8d 40 08             	lea    0x8(%eax),%eax
  80053e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800541:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800544:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800547:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80054b:	78 25                	js     800572 <vprintfmt+0x2c0>
			base = 10;
  80054d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800552:	e9 03 01 00 00       	jmp    80065a <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055f:	89 c1                	mov    %eax,%ecx
  800561:	c1 f9 1f             	sar    $0x1f,%ecx
  800564:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	eb cf                	jmp    800541 <vprintfmt+0x28f>
				putch('-', putdat);
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	53                   	push   %ebx
  800576:	6a 2d                	push   $0x2d
  800578:	ff d6                	call   *%esi
				num = -(long long) num;
  80057a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80057d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800580:	f7 da                	neg    %edx
  800582:	83 d1 00             	adc    $0x0,%ecx
  800585:	f7 d9                	neg    %ecx
  800587:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058f:	e9 c6 00 00 00       	jmp    80065a <vprintfmt+0x3a8>
	if (lflag >= 2)
  800594:	83 f9 01             	cmp    $0x1,%ecx
  800597:	7f 1e                	jg     8005b7 <vprintfmt+0x305>
	else if (lflag)
  800599:	85 c9                	test   %ecx,%ecx
  80059b:	75 32                	jne    8005cf <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8b 10                	mov    (%eax),%edx
  8005a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a7:	8d 40 04             	lea    0x4(%eax),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b2:	e9 a3 00 00 00       	jmp    80065a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 10                	mov    (%eax),%edx
  8005bc:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bf:	8d 40 08             	lea    0x8(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ca:	e9 8b 00 00 00       	jmp    80065a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 10                	mov    (%eax),%edx
  8005d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e4:	eb 74                	jmp    80065a <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005e6:	83 f9 01             	cmp    $0x1,%ecx
  8005e9:	7f 1b                	jg     800606 <vprintfmt+0x354>
	else if (lflag)
  8005eb:	85 c9                	test   %ecx,%ecx
  8005ed:	75 2c                	jne    80061b <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f9:	8d 40 04             	lea    0x4(%eax),%eax
  8005fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ff:	b8 08 00 00 00       	mov    $0x8,%eax
  800604:	eb 54                	jmp    80065a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 48 04             	mov    0x4(%eax),%ecx
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800614:	b8 08 00 00 00       	mov    $0x8,%eax
  800619:	eb 3f                	jmp    80065a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 10                	mov    (%eax),%edx
  800620:	b9 00 00 00 00       	mov    $0x0,%ecx
  800625:	8d 40 04             	lea    0x4(%eax),%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80062b:	b8 08 00 00 00       	mov    $0x8,%eax
  800630:	eb 28                	jmp    80065a <vprintfmt+0x3a8>
			putch('0', putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	53                   	push   %ebx
  800636:	6a 30                	push   $0x30
  800638:	ff d6                	call   *%esi
			putch('x', putdat);
  80063a:	83 c4 08             	add    $0x8,%esp
  80063d:	53                   	push   %ebx
  80063e:	6a 78                	push   $0x78
  800640:	ff d6                	call   *%esi
			num = (unsigned long long)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800655:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80065a:	83 ec 0c             	sub    $0xc,%esp
  80065d:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800661:	57                   	push   %edi
  800662:	ff 75 e0             	pushl  -0x20(%ebp)
  800665:	50                   	push   %eax
  800666:	51                   	push   %ecx
  800667:	52                   	push   %edx
  800668:	89 da                	mov    %ebx,%edx
  80066a:	89 f0                	mov    %esi,%eax
  80066c:	e8 5b fb ff ff       	call   8001cc <printnum>
			break;
  800671:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800674:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800677:	47                   	inc    %edi
  800678:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80067c:	83 f8 25             	cmp    $0x25,%eax
  80067f:	0f 84 44 fc ff ff    	je     8002c9 <vprintfmt+0x17>
			if (ch == '\0')
  800685:	85 c0                	test   %eax,%eax
  800687:	0f 84 89 00 00 00    	je     800716 <vprintfmt+0x464>
			putch(ch, putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	50                   	push   %eax
  800692:	ff d6                	call   *%esi
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	eb de                	jmp    800677 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800699:	83 f9 01             	cmp    $0x1,%ecx
  80069c:	7f 1b                	jg     8006b9 <vprintfmt+0x407>
	else if (lflag)
  80069e:	85 c9                	test   %ecx,%ecx
  8006a0:	75 2c                	jne    8006ce <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 10                	mov    (%eax),%edx
  8006a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006b7:	eb a1                	jmp    80065a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 10                	mov    (%eax),%edx
  8006be:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c1:	8d 40 08             	lea    0x8(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8006cc:	eb 8c                	jmp    80065a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 10                	mov    (%eax),%edx
  8006d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d8:	8d 40 04             	lea    0x4(%eax),%eax
  8006db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006de:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e3:	e9 72 ff ff ff       	jmp    80065a <vprintfmt+0x3a8>
			putch(ch, putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	53                   	push   %ebx
  8006ec:	6a 25                	push   $0x25
  8006ee:	ff d6                	call   *%esi
			break;
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	e9 7c ff ff ff       	jmp    800674 <vprintfmt+0x3c2>
			putch('%', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	6a 25                	push   $0x25
  8006fe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	89 f8                	mov    %edi,%eax
  800705:	eb 01                	jmp    800708 <vprintfmt+0x456>
  800707:	48                   	dec    %eax
  800708:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80070c:	75 f9                	jne    800707 <vprintfmt+0x455>
  80070e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800711:	e9 5e ff ff ff       	jmp    800674 <vprintfmt+0x3c2>
}
  800716:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800719:	5b                   	pop    %ebx
  80071a:	5e                   	pop    %esi
  80071b:	5f                   	pop    %edi
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80072a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80072d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800731:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800734:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80073b:	85 c0                	test   %eax,%eax
  80073d:	74 26                	je     800765 <vsnprintf+0x47>
  80073f:	85 d2                	test   %edx,%edx
  800741:	7e 29                	jle    80076c <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800743:	ff 75 14             	pushl  0x14(%ebp)
  800746:	ff 75 10             	pushl  0x10(%ebp)
  800749:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	68 79 02 80 00       	push   $0x800279
  800752:	e8 5b fb ff ff       	call   8002b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80075a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80075d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800760:	83 c4 10             	add    $0x10,%esp
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    
		return -E_INVAL;
  800765:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80076a:	eb f7                	jmp    800763 <vsnprintf+0x45>
  80076c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800771:	eb f0                	jmp    800763 <vsnprintf+0x45>

00800773 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800779:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80077c:	50                   	push   %eax
  80077d:	ff 75 10             	pushl  0x10(%ebp)
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	ff 75 08             	pushl  0x8(%ebp)
  800786:	e8 93 ff ff ff       	call   80071e <vsnprintf>
	va_end(ap);

	return rc;
}
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800793:	b8 00 00 00 00       	mov    $0x0,%eax
  800798:	eb 01                	jmp    80079b <strlen+0xe>
		n++;
  80079a:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80079b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80079f:	75 f9                	jne    80079a <strlen+0xd>
	return n;
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b1:	eb 01                	jmp    8007b4 <strnlen+0x11>
		n++;
  8007b3:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b4:	39 d0                	cmp    %edx,%eax
  8007b6:	74 06                	je     8007be <strnlen+0x1b>
  8007b8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007bc:	75 f5                	jne    8007b3 <strnlen+0x10>
	return n;
}
  8007be:	5d                   	pop    %ebp
  8007bf:	c3                   	ret    

008007c0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	53                   	push   %ebx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ca:	89 c2                	mov    %eax,%edx
  8007cc:	42                   	inc    %edx
  8007cd:	41                   	inc    %ecx
  8007ce:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8007d1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007d4:	84 db                	test   %bl,%bl
  8007d6:	75 f4                	jne    8007cc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007d8:	5b                   	pop    %ebx
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	53                   	push   %ebx
  8007df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e2:	53                   	push   %ebx
  8007e3:	e8 a5 ff ff ff       	call   80078d <strlen>
  8007e8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	01 d8                	add    %ebx,%eax
  8007f0:	50                   	push   %eax
  8007f1:	e8 ca ff ff ff       	call   8007c0 <strcpy>
	return dst;
}
  8007f6:	89 d8                	mov    %ebx,%eax
  8007f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    

008007fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	56                   	push   %esi
  800801:	53                   	push   %ebx
  800802:	8b 75 08             	mov    0x8(%ebp),%esi
  800805:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800808:	89 f3                	mov    %esi,%ebx
  80080a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80080d:	89 f2                	mov    %esi,%edx
  80080f:	eb 0c                	jmp    80081d <strncpy+0x20>
		*dst++ = *src;
  800811:	42                   	inc    %edx
  800812:	8a 01                	mov    (%ecx),%al
  800814:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800817:	80 39 01             	cmpb   $0x1,(%ecx)
  80081a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80081d:	39 da                	cmp    %ebx,%edx
  80081f:	75 f0                	jne    800811 <strncpy+0x14>
	}
	return ret;
}
  800821:	89 f0                	mov    %esi,%eax
  800823:	5b                   	pop    %ebx
  800824:	5e                   	pop    %esi
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	56                   	push   %esi
  80082b:	53                   	push   %ebx
  80082c:	8b 75 08             	mov    0x8(%ebp),%esi
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800832:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800835:	85 c0                	test   %eax,%eax
  800837:	74 20                	je     800859 <strlcpy+0x32>
  800839:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  80083d:	89 f0                	mov    %esi,%eax
  80083f:	eb 05                	jmp    800846 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800841:	40                   	inc    %eax
  800842:	42                   	inc    %edx
  800843:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800846:	39 d8                	cmp    %ebx,%eax
  800848:	74 06                	je     800850 <strlcpy+0x29>
  80084a:	8a 0a                	mov    (%edx),%cl
  80084c:	84 c9                	test   %cl,%cl
  80084e:	75 f1                	jne    800841 <strlcpy+0x1a>
		*dst = '\0';
  800850:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800853:	29 f0                	sub    %esi,%eax
}
  800855:	5b                   	pop    %ebx
  800856:	5e                   	pop    %esi
  800857:	5d                   	pop    %ebp
  800858:	c3                   	ret    
  800859:	89 f0                	mov    %esi,%eax
  80085b:	eb f6                	jmp    800853 <strlcpy+0x2c>

0080085d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800863:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800866:	eb 02                	jmp    80086a <strcmp+0xd>
		p++, q++;
  800868:	41                   	inc    %ecx
  800869:	42                   	inc    %edx
	while (*p && *p == *q)
  80086a:	8a 01                	mov    (%ecx),%al
  80086c:	84 c0                	test   %al,%al
  80086e:	74 04                	je     800874 <strcmp+0x17>
  800870:	3a 02                	cmp    (%edx),%al
  800872:	74 f4                	je     800868 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800874:	0f b6 c0             	movzbl %al,%eax
  800877:	0f b6 12             	movzbl (%edx),%edx
  80087a:	29 d0                	sub    %edx,%eax
}
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	53                   	push   %ebx
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	8b 55 0c             	mov    0xc(%ebp),%edx
  800888:	89 c3                	mov    %eax,%ebx
  80088a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80088d:	eb 02                	jmp    800891 <strncmp+0x13>
		n--, p++, q++;
  80088f:	40                   	inc    %eax
  800890:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800891:	39 d8                	cmp    %ebx,%eax
  800893:	74 15                	je     8008aa <strncmp+0x2c>
  800895:	8a 08                	mov    (%eax),%cl
  800897:	84 c9                	test   %cl,%cl
  800899:	74 04                	je     80089f <strncmp+0x21>
  80089b:	3a 0a                	cmp    (%edx),%cl
  80089d:	74 f0                	je     80088f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80089f:	0f b6 00             	movzbl (%eax),%eax
  8008a2:	0f b6 12             	movzbl (%edx),%edx
  8008a5:	29 d0                	sub    %edx,%eax
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    
		return 0;
  8008aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8008af:	eb f6                	jmp    8008a7 <strncmp+0x29>

008008b1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008ba:	8a 10                	mov    (%eax),%dl
  8008bc:	84 d2                	test   %dl,%dl
  8008be:	74 07                	je     8008c7 <strchr+0x16>
		if (*s == c)
  8008c0:	38 ca                	cmp    %cl,%dl
  8008c2:	74 08                	je     8008cc <strchr+0x1b>
	for (; *s; s++)
  8008c4:	40                   	inc    %eax
  8008c5:	eb f3                	jmp    8008ba <strchr+0x9>
			return (char *) s;
	return 0;
  8008c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008d7:	8a 10                	mov    (%eax),%dl
  8008d9:	84 d2                	test   %dl,%dl
  8008db:	74 07                	je     8008e4 <strfind+0x16>
		if (*s == c)
  8008dd:	38 ca                	cmp    %cl,%dl
  8008df:	74 03                	je     8008e4 <strfind+0x16>
	for (; *s; s++)
  8008e1:	40                   	inc    %eax
  8008e2:	eb f3                	jmp    8008d7 <strfind+0x9>
			break;
	return (char *) s;
}
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	57                   	push   %edi
  8008ea:	56                   	push   %esi
  8008eb:	53                   	push   %ebx
  8008ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008f2:	85 c9                	test   %ecx,%ecx
  8008f4:	74 13                	je     800909 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f6:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008fc:	75 05                	jne    800903 <memset+0x1d>
  8008fe:	f6 c1 03             	test   $0x3,%cl
  800901:	74 0d                	je     800910 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800903:	8b 45 0c             	mov    0xc(%ebp),%eax
  800906:	fc                   	cld    
  800907:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800909:	89 f8                	mov    %edi,%eax
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5f                   	pop    %edi
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    
		c &= 0xFF;
  800910:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800914:	89 d3                	mov    %edx,%ebx
  800916:	c1 e3 08             	shl    $0x8,%ebx
  800919:	89 d0                	mov    %edx,%eax
  80091b:	c1 e0 18             	shl    $0x18,%eax
  80091e:	89 d6                	mov    %edx,%esi
  800920:	c1 e6 10             	shl    $0x10,%esi
  800923:	09 f0                	or     %esi,%eax
  800925:	09 c2                	or     %eax,%edx
  800927:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800929:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80092c:	89 d0                	mov    %edx,%eax
  80092e:	fc                   	cld    
  80092f:	f3 ab                	rep stos %eax,%es:(%edi)
  800931:	eb d6                	jmp    800909 <memset+0x23>

00800933 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	57                   	push   %edi
  800937:	56                   	push   %esi
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80093e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800941:	39 c6                	cmp    %eax,%esi
  800943:	73 33                	jae    800978 <memmove+0x45>
  800945:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800948:	39 d0                	cmp    %edx,%eax
  80094a:	73 2c                	jae    800978 <memmove+0x45>
		s += n;
		d += n;
  80094c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80094f:	89 d6                	mov    %edx,%esi
  800951:	09 fe                	or     %edi,%esi
  800953:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800959:	75 13                	jne    80096e <memmove+0x3b>
  80095b:	f6 c1 03             	test   $0x3,%cl
  80095e:	75 0e                	jne    80096e <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800960:	83 ef 04             	sub    $0x4,%edi
  800963:	8d 72 fc             	lea    -0x4(%edx),%esi
  800966:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800969:	fd                   	std    
  80096a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096c:	eb 07                	jmp    800975 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80096e:	4f                   	dec    %edi
  80096f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800972:	fd                   	std    
  800973:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800975:	fc                   	cld    
  800976:	eb 13                	jmp    80098b <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800978:	89 f2                	mov    %esi,%edx
  80097a:	09 c2                	or     %eax,%edx
  80097c:	f6 c2 03             	test   $0x3,%dl
  80097f:	75 05                	jne    800986 <memmove+0x53>
  800981:	f6 c1 03             	test   $0x3,%cl
  800984:	74 09                	je     80098f <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800986:	89 c7                	mov    %eax,%edi
  800988:	fc                   	cld    
  800989:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80098b:	5e                   	pop    %esi
  80098c:	5f                   	pop    %edi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80098f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800992:	89 c7                	mov    %eax,%edi
  800994:	fc                   	cld    
  800995:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800997:	eb f2                	jmp    80098b <memmove+0x58>

00800999 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80099c:	ff 75 10             	pushl  0x10(%ebp)
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	ff 75 08             	pushl  0x8(%ebp)
  8009a5:	e8 89 ff ff ff       	call   800933 <memmove>
}
  8009aa:	c9                   	leave  
  8009ab:	c3                   	ret    

008009ac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	56                   	push   %esi
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	89 c6                	mov    %eax,%esi
  8009b6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  8009bc:	39 f0                	cmp    %esi,%eax
  8009be:	74 16                	je     8009d6 <memcmp+0x2a>
		if (*s1 != *s2)
  8009c0:	8a 08                	mov    (%eax),%cl
  8009c2:	8a 1a                	mov    (%edx),%bl
  8009c4:	38 d9                	cmp    %bl,%cl
  8009c6:	75 04                	jne    8009cc <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009c8:	40                   	inc    %eax
  8009c9:	42                   	inc    %edx
  8009ca:	eb f0                	jmp    8009bc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009cc:	0f b6 c1             	movzbl %cl,%eax
  8009cf:	0f b6 db             	movzbl %bl,%ebx
  8009d2:	29 d8                	sub    %ebx,%eax
  8009d4:	eb 05                	jmp    8009db <memcmp+0x2f>
	}

	return 0;
  8009d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009db:	5b                   	pop    %ebx
  8009dc:	5e                   	pop    %esi
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009e8:	89 c2                	mov    %eax,%edx
  8009ea:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009ed:	39 d0                	cmp    %edx,%eax
  8009ef:	73 07                	jae    8009f8 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009f1:	38 08                	cmp    %cl,(%eax)
  8009f3:	74 03                	je     8009f8 <memfind+0x19>
	for (; s < ends; s++)
  8009f5:	40                   	inc    %eax
  8009f6:	eb f5                	jmp    8009ed <memfind+0xe>
			break;
	return (void *) s;
}
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	57                   	push   %edi
  8009fe:	56                   	push   %esi
  8009ff:	53                   	push   %ebx
  800a00:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a03:	eb 01                	jmp    800a06 <strtol+0xc>
		s++;
  800a05:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a06:	8a 01                	mov    (%ecx),%al
  800a08:	3c 20                	cmp    $0x20,%al
  800a0a:	74 f9                	je     800a05 <strtol+0xb>
  800a0c:	3c 09                	cmp    $0x9,%al
  800a0e:	74 f5                	je     800a05 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a10:	3c 2b                	cmp    $0x2b,%al
  800a12:	74 2b                	je     800a3f <strtol+0x45>
		s++;
	else if (*s == '-')
  800a14:	3c 2d                	cmp    $0x2d,%al
  800a16:	74 2f                	je     800a47 <strtol+0x4d>
	int neg = 0;
  800a18:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a1d:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a24:	75 12                	jne    800a38 <strtol+0x3e>
  800a26:	80 39 30             	cmpb   $0x30,(%ecx)
  800a29:	74 24                	je     800a4f <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a2f:	75 07                	jne    800a38 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a31:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3d:	eb 4e                	jmp    800a8d <strtol+0x93>
		s++;
  800a3f:	41                   	inc    %ecx
	int neg = 0;
  800a40:	bf 00 00 00 00       	mov    $0x0,%edi
  800a45:	eb d6                	jmp    800a1d <strtol+0x23>
		s++, neg = 1;
  800a47:	41                   	inc    %ecx
  800a48:	bf 01 00 00 00       	mov    $0x1,%edi
  800a4d:	eb ce                	jmp    800a1d <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a4f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a53:	74 10                	je     800a65 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a59:	75 dd                	jne    800a38 <strtol+0x3e>
		s++, base = 8;
  800a5b:	41                   	inc    %ecx
  800a5c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a63:	eb d3                	jmp    800a38 <strtol+0x3e>
		s += 2, base = 16;
  800a65:	83 c1 02             	add    $0x2,%ecx
  800a68:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a6f:	eb c7                	jmp    800a38 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a71:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a74:	89 f3                	mov    %esi,%ebx
  800a76:	80 fb 19             	cmp    $0x19,%bl
  800a79:	77 24                	ja     800a9f <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a7b:	0f be d2             	movsbl %dl,%edx
  800a7e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a81:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a84:	7d 2b                	jge    800ab1 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a86:	41                   	inc    %ecx
  800a87:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a8b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a8d:	8a 11                	mov    (%ecx),%dl
  800a8f:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a92:	80 fb 09             	cmp    $0x9,%bl
  800a95:	77 da                	ja     800a71 <strtol+0x77>
			dig = *s - '0';
  800a97:	0f be d2             	movsbl %dl,%edx
  800a9a:	83 ea 30             	sub    $0x30,%edx
  800a9d:	eb e2                	jmp    800a81 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a9f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aa2:	89 f3                	mov    %esi,%ebx
  800aa4:	80 fb 19             	cmp    $0x19,%bl
  800aa7:	77 08                	ja     800ab1 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800aa9:	0f be d2             	movsbl %dl,%edx
  800aac:	83 ea 37             	sub    $0x37,%edx
  800aaf:	eb d0                	jmp    800a81 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ab1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab5:	74 05                	je     800abc <strtol+0xc2>
		*endptr = (char *) s;
  800ab7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aba:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800abc:	85 ff                	test   %edi,%edi
  800abe:	74 02                	je     800ac2 <strtol+0xc8>
  800ac0:	f7 d8                	neg    %eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5f                   	pop    %edi
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <atoi>:

int
atoi(const char *s)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800aca:	6a 0a                	push   $0xa
  800acc:	6a 00                	push   $0x0
  800ace:	ff 75 08             	pushl  0x8(%ebp)
  800ad1:	e8 24 ff ff ff       	call   8009fa <strtol>
}
  800ad6:	c9                   	leave  
  800ad7:	c3                   	ret    

00800ad8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ade:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	89 c3                	mov    %eax,%ebx
  800aeb:	89 c7                	mov    %eax,%edi
  800aed:	89 c6                	mov    %eax,%esi
  800aef:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800af1:	5b                   	pop    %ebx
  800af2:	5e                   	pop    %esi
  800af3:	5f                   	pop    %edi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	57                   	push   %edi
  800afa:	56                   	push   %esi
  800afb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800afc:	ba 00 00 00 00       	mov    $0x0,%edx
  800b01:	b8 01 00 00 00       	mov    $0x1,%eax
  800b06:	89 d1                	mov    %edx,%ecx
  800b08:	89 d3                	mov    %edx,%ebx
  800b0a:	89 d7                	mov    %edx,%edi
  800b0c:	89 d6                	mov    %edx,%esi
  800b0e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5f                   	pop    %edi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	57                   	push   %edi
  800b19:	56                   	push   %esi
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b23:	b8 03 00 00 00       	mov    $0x3,%eax
  800b28:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2b:	89 cb                	mov    %ecx,%ebx
  800b2d:	89 cf                	mov    %ecx,%edi
  800b2f:	89 ce                	mov    %ecx,%esi
  800b31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b33:	85 c0                	test   %eax,%eax
  800b35:	7f 08                	jg     800b3f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	5f                   	pop    %edi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b3f:	83 ec 0c             	sub    $0xc,%esp
  800b42:	50                   	push   %eax
  800b43:	6a 03                	push   $0x3
  800b45:	68 9f 25 80 00       	push   $0x80259f
  800b4a:	6a 23                	push   $0x23
  800b4c:	68 bc 25 80 00       	push   $0x8025bc
  800b51:	e8 8b 13 00 00       	call   801ee1 <_panic>

00800b56 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b61:	b8 02 00 00 00       	mov    $0x2,%eax
  800b66:	89 d1                	mov    %edx,%ecx
  800b68:	89 d3                	mov    %edx,%ebx
  800b6a:	89 d7                	mov    %edx,%edi
  800b6c:	89 d6                	mov    %edx,%esi
  800b6e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5f                   	pop    %edi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
  800b7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b7e:	be 00 00 00 00       	mov    $0x0,%esi
  800b83:	b8 04 00 00 00       	mov    $0x4,%eax
  800b88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b91:	89 f7                	mov    %esi,%edi
  800b93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b95:	85 c0                	test   %eax,%eax
  800b97:	7f 08                	jg     800ba1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5f                   	pop    %edi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba1:	83 ec 0c             	sub    $0xc,%esp
  800ba4:	50                   	push   %eax
  800ba5:	6a 04                	push   $0x4
  800ba7:	68 9f 25 80 00       	push   $0x80259f
  800bac:	6a 23                	push   $0x23
  800bae:	68 bc 25 80 00       	push   $0x8025bc
  800bb3:	e8 29 13 00 00       	call   801ee1 <_panic>

00800bb8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
  800bbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc1:	b8 05 00 00 00       	mov    $0x5,%eax
  800bc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bcf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bd2:	8b 75 18             	mov    0x18(%ebp),%esi
  800bd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	7f 08                	jg     800be3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	50                   	push   %eax
  800be7:	6a 05                	push   $0x5
  800be9:	68 9f 25 80 00       	push   $0x80259f
  800bee:	6a 23                	push   $0x23
  800bf0:	68 bc 25 80 00       	push   $0x8025bc
  800bf5:	e8 e7 12 00 00       	call   801ee1 <_panic>

00800bfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	53                   	push   %ebx
  800c00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c08:	b8 06 00 00 00       	mov    $0x6,%eax
  800c0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c10:	8b 55 08             	mov    0x8(%ebp),%edx
  800c13:	89 df                	mov    %ebx,%edi
  800c15:	89 de                	mov    %ebx,%esi
  800c17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c19:	85 c0                	test   %eax,%eax
  800c1b:	7f 08                	jg     800c25 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	83 ec 0c             	sub    $0xc,%esp
  800c28:	50                   	push   %eax
  800c29:	6a 06                	push   $0x6
  800c2b:	68 9f 25 80 00       	push   $0x80259f
  800c30:	6a 23                	push   $0x23
  800c32:	68 bc 25 80 00       	push   $0x8025bc
  800c37:	e8 a5 12 00 00       	call   801ee1 <_panic>

00800c3c <sys_yield>:

void
sys_yield(void)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	57                   	push   %edi
  800c40:	56                   	push   %esi
  800c41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c42:	ba 00 00 00 00       	mov    $0x0,%edx
  800c47:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c4c:	89 d1                	mov    %edx,%ecx
  800c4e:	89 d3                	mov    %edx,%ebx
  800c50:	89 d7                	mov    %edx,%edi
  800c52:	89 d6                	mov    %edx,%esi
  800c54:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c69:	b8 08 00 00 00       	mov    $0x8,%eax
  800c6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c71:	8b 55 08             	mov    0x8(%ebp),%edx
  800c74:	89 df                	mov    %ebx,%edi
  800c76:	89 de                	mov    %ebx,%esi
  800c78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7a:	85 c0                	test   %eax,%eax
  800c7c:	7f 08                	jg     800c86 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c86:	83 ec 0c             	sub    $0xc,%esp
  800c89:	50                   	push   %eax
  800c8a:	6a 08                	push   $0x8
  800c8c:	68 9f 25 80 00       	push   $0x80259f
  800c91:	6a 23                	push   $0x23
  800c93:	68 bc 25 80 00       	push   $0x8025bc
  800c98:	e8 44 12 00 00       	call   801ee1 <_panic>

00800c9d <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cab:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	89 cb                	mov    %ecx,%ebx
  800cb5:	89 cf                	mov    %ecx,%edi
  800cb7:	89 ce                	mov    %ecx,%esi
  800cb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	83 ec 0c             	sub    $0xc,%esp
  800cca:	50                   	push   %eax
  800ccb:	6a 0c                	push   $0xc
  800ccd:	68 9f 25 80 00       	push   $0x80259f
  800cd2:	6a 23                	push   $0x23
  800cd4:	68 bc 25 80 00       	push   $0x8025bc
  800cd9:	e8 03 12 00 00       	call   801ee1 <_panic>

00800cde <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
  800ce4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cec:	b8 09 00 00 00       	mov    $0x9,%eax
  800cf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	89 df                	mov    %ebx,%edi
  800cf9:	89 de                	mov    %ebx,%esi
  800cfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	7f 08                	jg     800d09 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d09:	83 ec 0c             	sub    $0xc,%esp
  800d0c:	50                   	push   %eax
  800d0d:	6a 09                	push   $0x9
  800d0f:	68 9f 25 80 00       	push   $0x80259f
  800d14:	6a 23                	push   $0x23
  800d16:	68 bc 25 80 00       	push   $0x8025bc
  800d1b:	e8 c1 11 00 00       	call   801ee1 <_panic>

00800d20 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
  800d26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	89 df                	mov    %ebx,%edi
  800d3b:	89 de                	mov    %ebx,%esi
  800d3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	7f 08                	jg     800d4b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4b:	83 ec 0c             	sub    $0xc,%esp
  800d4e:	50                   	push   %eax
  800d4f:	6a 0a                	push   $0xa
  800d51:	68 9f 25 80 00       	push   $0x80259f
  800d56:	6a 23                	push   $0x23
  800d58:	68 bc 25 80 00       	push   $0x8025bc
  800d5d:	e8 7f 11 00 00       	call   801ee1 <_panic>

00800d62 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d68:	be 00 00 00 00       	mov    $0x0,%esi
  800d6d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d93:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	89 cb                	mov    %ecx,%ebx
  800d9d:	89 cf                	mov    %ecx,%edi
  800d9f:	89 ce                	mov    %ecx,%esi
  800da1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7f 08                	jg     800daf <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5f                   	pop    %edi
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	50                   	push   %eax
  800db3:	6a 0e                	push   $0xe
  800db5:	68 9f 25 80 00       	push   $0x80259f
  800dba:	6a 23                	push   $0x23
  800dbc:	68 bc 25 80 00       	push   $0x8025bc
  800dc1:	e8 1b 11 00 00       	call   801ee1 <_panic>

00800dc6 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcc:	be 00 00 00 00       	mov    $0x0,%esi
  800dd1:	b8 0f 00 00 00       	mov    $0xf,%eax
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddf:	89 f7                	mov    %esi,%edi
  800de1:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5f                   	pop    %edi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dee:	be 00 00 00 00       	mov    $0x0,%esi
  800df3:	b8 10 00 00 00       	mov    $0x10,%eax
  800df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e01:	89 f7                	mov    %esi,%edi
  800e03:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e15:	b8 11 00 00 00       	mov    $0x11,%eax
  800e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1d:	89 cb                	mov    %ecx,%ebx
  800e1f:	89 cf                	mov    %ecx,%edi
  800e21:	89 ce                	mov    %ecx,%esi
  800e23:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e32:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800e34:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e38:	0f 84 84 00 00 00    	je     800ec2 <pgfault+0x98>
  800e3e:	89 d8                	mov    %ebx,%eax
  800e40:	c1 e8 16             	shr    $0x16,%eax
  800e43:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e4a:	a8 01                	test   $0x1,%al
  800e4c:	74 74                	je     800ec2 <pgfault+0x98>
  800e4e:	89 d8                	mov    %ebx,%eax
  800e50:	c1 e8 0c             	shr    $0xc,%eax
  800e53:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e5a:	f6 c4 08             	test   $0x8,%ah
  800e5d:	74 63                	je     800ec2 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800e5f:	e8 f2 fc ff ff       	call   800b56 <sys_getenvid>
  800e64:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800e66:	83 ec 04             	sub    $0x4,%esp
  800e69:	6a 07                	push   $0x7
  800e6b:	68 00 f0 7f 00       	push   $0x7ff000
  800e70:	50                   	push   %eax
  800e71:	e8 ff fc ff ff       	call   800b75 <sys_page_alloc>
  800e76:	83 c4 10             	add    $0x10,%esp
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	78 5b                	js     800ed8 <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  800e7d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  800e83:	83 ec 04             	sub    $0x4,%esp
  800e86:	68 00 10 00 00       	push   $0x1000
  800e8b:	53                   	push   %ebx
  800e8c:	68 00 f0 7f 00       	push   $0x7ff000
  800e91:	e8 03 fb ff ff       	call   800999 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  800e96:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e9d:	53                   	push   %ebx
  800e9e:	56                   	push   %esi
  800e9f:	68 00 f0 7f 00       	push   $0x7ff000
  800ea4:	56                   	push   %esi
  800ea5:	e8 0e fd ff ff       	call   800bb8 <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  800eaa:	83 c4 18             	add    $0x18,%esp
  800ead:	68 00 f0 7f 00       	push   $0x7ff000
  800eb2:	56                   	push   %esi
  800eb3:	e8 42 fd ff ff       	call   800bfa <sys_page_unmap>

}
  800eb8:	83 c4 10             	add    $0x10,%esp
  800ebb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800ec2:	68 cc 25 80 00       	push   $0x8025cc
  800ec7:	68 56 26 80 00       	push   $0x802656
  800ecc:	6a 1c                	push   $0x1c
  800ece:	68 6b 26 80 00       	push   $0x80266b
  800ed3:	e8 09 10 00 00       	call   801ee1 <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800ed8:	68 1c 26 80 00       	push   $0x80261c
  800edd:	68 56 26 80 00       	push   $0x802656
  800ee2:	6a 26                	push   $0x26
  800ee4:	68 6b 26 80 00       	push   $0x80266b
  800ee9:	e8 f3 0f 00 00       	call   801ee1 <_panic>

00800eee <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
  800ef4:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800ef7:	68 2a 0e 80 00       	push   $0x800e2a
  800efc:	e8 5f 10 00 00       	call   801f60 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f01:	b8 07 00 00 00       	mov    $0x7,%eax
  800f06:	cd 30                	int    $0x30
  800f08:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  800f0e:	83 c4 10             	add    $0x10,%esp
  800f11:	85 c0                	test   %eax,%eax
  800f13:	0f 88 58 01 00 00    	js     801071 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  800f19:	85 c0                	test   %eax,%eax
  800f1b:	74 07                	je     800f24 <fork+0x36>
  800f1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f22:	eb 72                	jmp    800f96 <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f24:	e8 2d fc ff ff       	call   800b56 <sys_getenvid>
  800f29:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f2e:	89 c2                	mov    %eax,%edx
  800f30:	c1 e2 05             	shl    $0x5,%edx
  800f33:	29 c2                	sub    %eax,%edx
  800f35:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800f3c:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f41:	e9 20 01 00 00       	jmp    801066 <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  800f46:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  800f4d:	e8 04 fc ff ff       	call   800b56 <sys_getenvid>
  800f52:	83 ec 0c             	sub    $0xc,%esp
  800f55:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f60:	56                   	push   %esi
  800f61:	50                   	push   %eax
  800f62:	e8 51 fc ff ff       	call   800bb8 <sys_page_map>
  800f67:	83 c4 20             	add    $0x20,%esp
  800f6a:	eb 18                	jmp    800f84 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  800f6c:	e8 e5 fb ff ff       	call   800b56 <sys_getenvid>
  800f71:	83 ec 0c             	sub    $0xc,%esp
  800f74:	6a 05                	push   $0x5
  800f76:	56                   	push   %esi
  800f77:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7a:	56                   	push   %esi
  800f7b:	50                   	push   %eax
  800f7c:	e8 37 fc ff ff       	call   800bb8 <sys_page_map>
  800f81:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  800f84:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f8a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f90:	0f 84 8f 00 00 00    	je     801025 <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  800f96:	89 d8                	mov    %ebx,%eax
  800f98:	c1 e8 16             	shr    $0x16,%eax
  800f9b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fa2:	a8 01                	test   $0x1,%al
  800fa4:	74 de                	je     800f84 <fork+0x96>
  800fa6:	89 d8                	mov    %ebx,%eax
  800fa8:	c1 e8 0c             	shr    $0xc,%eax
  800fab:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fb2:	a8 04                	test   $0x4,%al
  800fb4:	74 ce                	je     800f84 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  800fb6:	89 de                	mov    %ebx,%esi
  800fb8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  800fbe:	89 f0                	mov    %esi,%eax
  800fc0:	c1 e8 0c             	shr    $0xc,%eax
  800fc3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fca:	f6 c6 04             	test   $0x4,%dh
  800fcd:	0f 85 73 ff ff ff    	jne    800f46 <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  800fd3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fda:	a9 02 08 00 00       	test   $0x802,%eax
  800fdf:	74 8b                	je     800f6c <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  800fe1:	e8 70 fb ff ff       	call   800b56 <sys_getenvid>
  800fe6:	83 ec 0c             	sub    $0xc,%esp
  800fe9:	68 05 08 00 00       	push   $0x805
  800fee:	56                   	push   %esi
  800fef:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ff2:	56                   	push   %esi
  800ff3:	50                   	push   %eax
  800ff4:	e8 bf fb ff ff       	call   800bb8 <sys_page_map>
  800ff9:	83 c4 20             	add    $0x20,%esp
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	78 84                	js     800f84 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801000:	e8 51 fb ff ff       	call   800b56 <sys_getenvid>
  801005:	89 c7                	mov    %eax,%edi
  801007:	e8 4a fb ff ff       	call   800b56 <sys_getenvid>
  80100c:	83 ec 0c             	sub    $0xc,%esp
  80100f:	68 05 08 00 00       	push   $0x805
  801014:	56                   	push   %esi
  801015:	57                   	push   %edi
  801016:	56                   	push   %esi
  801017:	50                   	push   %eax
  801018:	e8 9b fb ff ff       	call   800bb8 <sys_page_map>
  80101d:	83 c4 20             	add    $0x20,%esp
  801020:	e9 5f ff ff ff       	jmp    800f84 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  801025:	83 ec 04             	sub    $0x4,%esp
  801028:	6a 07                	push   $0x7
  80102a:	68 00 f0 bf ee       	push   $0xeebff000
  80102f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801032:	57                   	push   %edi
  801033:	e8 3d fb ff ff       	call   800b75 <sys_page_alloc>
  801038:	83 c4 10             	add    $0x10,%esp
  80103b:	85 c0                	test   %eax,%eax
  80103d:	78 3b                	js     80107a <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  80103f:	83 ec 08             	sub    $0x8,%esp
  801042:	68 a6 1f 80 00       	push   $0x801fa6
  801047:	57                   	push   %edi
  801048:	e8 d3 fc ff ff       	call   800d20 <sys_env_set_pgfault_upcall>
  80104d:	83 c4 10             	add    $0x10,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	78 2f                	js     801083 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  801054:	83 ec 08             	sub    $0x8,%esp
  801057:	6a 02                	push   $0x2
  801059:	57                   	push   %edi
  80105a:	e8 fc fb ff ff       	call   800c5b <sys_env_set_status>
	if (temp < 0) {
  80105f:	83 c4 10             	add    $0x10,%esp
  801062:	85 c0                	test   %eax,%eax
  801064:	78 26                	js     80108c <fork+0x19e>
		return -1;
	}

	return childid;
}
  801066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		return -1;
  801071:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801078:	eb ec                	jmp    801066 <fork+0x178>
		return -1;
  80107a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801081:	eb e3                	jmp    801066 <fork+0x178>
		return -1;
  801083:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80108a:	eb da                	jmp    801066 <fork+0x178>
		return -1;
  80108c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801093:	eb d1                	jmp    801066 <fork+0x178>

00801095 <sfork>:

// Challenge!
int
sfork(void)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80109b:	68 76 26 80 00       	push   $0x802676
  8010a0:	68 85 00 00 00       	push   $0x85
  8010a5:	68 6b 26 80 00       	push   $0x80266b
  8010aa:	e8 32 0e 00 00       	call   801ee1 <_panic>

008010af <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	57                   	push   %edi
  8010b3:	56                   	push   %esi
  8010b4:	53                   	push   %ebx
  8010b5:	83 ec 0c             	sub    $0xc,%esp
  8010b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8010bb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8010be:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  8010c1:	85 ff                	test   %edi,%edi
  8010c3:	74 53                	je     801118 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	57                   	push   %edi
  8010c9:	e8 b7 fc ff ff       	call   800d85 <sys_ipc_recv>
  8010ce:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  8010d1:	85 db                	test   %ebx,%ebx
  8010d3:	74 0b                	je     8010e0 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8010d5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8010db:	8b 52 74             	mov    0x74(%edx),%edx
  8010de:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	74 0f                	je     8010f3 <ipc_recv+0x44>
  8010e4:	85 ff                	test   %edi,%edi
  8010e6:	74 0b                	je     8010f3 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8010e8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8010ee:	8b 52 78             	mov    0x78(%edx),%edx
  8010f1:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	74 30                	je     801127 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  8010f7:	85 db                	test   %ebx,%ebx
  8010f9:	74 06                	je     801101 <ipc_recv+0x52>
      		*from_env_store = 0;
  8010fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801101:	85 f6                	test   %esi,%esi
  801103:	74 2c                	je     801131 <ipc_recv+0x82>
      		*perm_store = 0;
  801105:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80110b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	6a ff                	push   $0xffffffff
  80111d:	e8 63 fc ff ff       	call   800d85 <sys_ipc_recv>
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	eb aa                	jmp    8010d1 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801127:	a1 04 40 80 00       	mov    0x804004,%eax
  80112c:	8b 40 70             	mov    0x70(%eax),%eax
  80112f:	eb df                	jmp    801110 <ipc_recv+0x61>
		return -1;
  801131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801136:	eb d8                	jmp    801110 <ipc_recv+0x61>

00801138 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	57                   	push   %edi
  80113c:	56                   	push   %esi
  80113d:	53                   	push   %ebx
  80113e:	83 ec 0c             	sub    $0xc,%esp
  801141:	8b 75 0c             	mov    0xc(%ebp),%esi
  801144:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801147:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  80114a:	85 db                	test   %ebx,%ebx
  80114c:	75 22                	jne    801170 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  80114e:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801153:	eb 1b                	jmp    801170 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801155:	68 8c 26 80 00       	push   $0x80268c
  80115a:	68 56 26 80 00       	push   $0x802656
  80115f:	6a 48                	push   $0x48
  801161:	68 af 26 80 00       	push   $0x8026af
  801166:	e8 76 0d 00 00       	call   801ee1 <_panic>
		sys_yield();
  80116b:	e8 cc fa ff ff       	call   800c3c <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801170:	57                   	push   %edi
  801171:	53                   	push   %ebx
  801172:	56                   	push   %esi
  801173:	ff 75 08             	pushl  0x8(%ebp)
  801176:	e8 e7 fb ff ff       	call   800d62 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801181:	74 e8                	je     80116b <ipc_send+0x33>
  801183:	85 c0                	test   %eax,%eax
  801185:	75 ce                	jne    801155 <ipc_send+0x1d>
		sys_yield();
  801187:	e8 b0 fa ff ff       	call   800c3c <sys_yield>
		
	}
	
}
  80118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118f:	5b                   	pop    %ebx
  801190:	5e                   	pop    %esi
  801191:	5f                   	pop    %edi
  801192:	5d                   	pop    %ebp
  801193:	c3                   	ret    

00801194 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80119f:	89 c2                	mov    %eax,%edx
  8011a1:	c1 e2 05             	shl    $0x5,%edx
  8011a4:	29 c2                	sub    %eax,%edx
  8011a6:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  8011ad:	8b 52 50             	mov    0x50(%edx),%edx
  8011b0:	39 ca                	cmp    %ecx,%edx
  8011b2:	74 0f                	je     8011c3 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8011b4:	40                   	inc    %eax
  8011b5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011ba:	75 e3                	jne    80119f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8011bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c1:	eb 11                	jmp    8011d4 <ipc_find_env+0x40>
			return envs[i].env_id;
  8011c3:	89 c2                	mov    %eax,%edx
  8011c5:	c1 e2 05             	shl    $0x5,%edx
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8011d1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	05 00 00 00 30       	add    $0x30000000,%eax
  8011e1:	c1 e8 0c             	shr    $0xc,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801203:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801208:	89 c2                	mov    %eax,%edx
  80120a:	c1 ea 16             	shr    $0x16,%edx
  80120d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801214:	f6 c2 01             	test   $0x1,%dl
  801217:	74 2a                	je     801243 <fd_alloc+0x46>
  801219:	89 c2                	mov    %eax,%edx
  80121b:	c1 ea 0c             	shr    $0xc,%edx
  80121e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801225:	f6 c2 01             	test   $0x1,%dl
  801228:	74 19                	je     801243 <fd_alloc+0x46>
  80122a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80122f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801234:	75 d2                	jne    801208 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801236:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80123c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801241:	eb 07                	jmp    80124a <fd_alloc+0x4d>
			*fd_store = fd;
  801243:	89 01                	mov    %eax,(%ecx)
			return 0;
  801245:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80124f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801253:	77 39                	ja     80128e <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	c1 e0 0c             	shl    $0xc,%eax
  80125b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801260:	89 c2                	mov    %eax,%edx
  801262:	c1 ea 16             	shr    $0x16,%edx
  801265:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80126c:	f6 c2 01             	test   $0x1,%dl
  80126f:	74 24                	je     801295 <fd_lookup+0x49>
  801271:	89 c2                	mov    %eax,%edx
  801273:	c1 ea 0c             	shr    $0xc,%edx
  801276:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80127d:	f6 c2 01             	test   $0x1,%dl
  801280:	74 1a                	je     80129c <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801282:	8b 55 0c             	mov    0xc(%ebp),%edx
  801285:	89 02                	mov    %eax,(%edx)
	return 0;
  801287:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    
		return -E_INVAL;
  80128e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801293:	eb f7                	jmp    80128c <fd_lookup+0x40>
		return -E_INVAL;
  801295:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129a:	eb f0                	jmp    80128c <fd_lookup+0x40>
  80129c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a1:	eb e9                	jmp    80128c <fd_lookup+0x40>

008012a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ac:	ba 38 27 80 00       	mov    $0x802738,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012b1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012b6:	39 08                	cmp    %ecx,(%eax)
  8012b8:	74 33                	je     8012ed <dev_lookup+0x4a>
  8012ba:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012bd:	8b 02                	mov    (%edx),%eax
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 f3                	jne    8012b6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c8:	8b 40 48             	mov    0x48(%eax),%eax
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	51                   	push   %ecx
  8012cf:	50                   	push   %eax
  8012d0:	68 bc 26 80 00       	push   $0x8026bc
  8012d5:	e8 de ee ff ff       	call   8001b8 <cprintf>
	*dev = 0;
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    
			*dev = devtab[i];
  8012ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f7:	eb f2                	jmp    8012eb <dev_lookup+0x48>

008012f9 <fd_close>:
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	57                   	push   %edi
  8012fd:	56                   	push   %esi
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 1c             	sub    $0x1c,%esp
  801302:	8b 75 08             	mov    0x8(%ebp),%esi
  801305:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801308:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80130b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80130c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801312:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801315:	50                   	push   %eax
  801316:	e8 31 ff ff ff       	call   80124c <fd_lookup>
  80131b:	89 c7                	mov    %eax,%edi
  80131d:	83 c4 08             	add    $0x8,%esp
  801320:	85 c0                	test   %eax,%eax
  801322:	78 05                	js     801329 <fd_close+0x30>
	    || fd != fd2)
  801324:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801327:	74 13                	je     80133c <fd_close+0x43>
		return (must_exist ? r : 0);
  801329:	84 db                	test   %bl,%bl
  80132b:	75 05                	jne    801332 <fd_close+0x39>
  80132d:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801332:	89 f8                	mov    %edi,%eax
  801334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801337:	5b                   	pop    %ebx
  801338:	5e                   	pop    %esi
  801339:	5f                   	pop    %edi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801342:	50                   	push   %eax
  801343:	ff 36                	pushl  (%esi)
  801345:	e8 59 ff ff ff       	call   8012a3 <dev_lookup>
  80134a:	89 c7                	mov    %eax,%edi
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 15                	js     801368 <fd_close+0x6f>
		if (dev->dev_close)
  801353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801356:	8b 40 10             	mov    0x10(%eax),%eax
  801359:	85 c0                	test   %eax,%eax
  80135b:	74 1b                	je     801378 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80135d:	83 ec 0c             	sub    $0xc,%esp
  801360:	56                   	push   %esi
  801361:	ff d0                	call   *%eax
  801363:	89 c7                	mov    %eax,%edi
  801365:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801368:	83 ec 08             	sub    $0x8,%esp
  80136b:	56                   	push   %esi
  80136c:	6a 00                	push   $0x0
  80136e:	e8 87 f8 ff ff       	call   800bfa <sys_page_unmap>
	return r;
  801373:	83 c4 10             	add    $0x10,%esp
  801376:	eb ba                	jmp    801332 <fd_close+0x39>
			r = 0;
  801378:	bf 00 00 00 00       	mov    $0x0,%edi
  80137d:	eb e9                	jmp    801368 <fd_close+0x6f>

0080137f <close>:

int
close(int fdnum)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801385:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801388:	50                   	push   %eax
  801389:	ff 75 08             	pushl  0x8(%ebp)
  80138c:	e8 bb fe ff ff       	call   80124c <fd_lookup>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	78 10                	js     8013a8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801398:	83 ec 08             	sub    $0x8,%esp
  80139b:	6a 01                	push   $0x1
  80139d:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a0:	e8 54 ff ff ff       	call   8012f9 <fd_close>
  8013a5:	83 c4 10             	add    $0x10,%esp
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <close_all>:

void
close_all(void)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	53                   	push   %ebx
  8013ba:	e8 c0 ff ff ff       	call   80137f <close>
	for (i = 0; i < MAXFD; i++)
  8013bf:	43                   	inc    %ebx
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	83 fb 20             	cmp    $0x20,%ebx
  8013c6:	75 ee                	jne    8013b6 <close_all+0xc>
}
  8013c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	57                   	push   %edi
  8013d1:	56                   	push   %esi
  8013d2:	53                   	push   %ebx
  8013d3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	e8 6a fe ff ff       	call   80124c <fd_lookup>
  8013e2:	89 c3                	mov    %eax,%ebx
  8013e4:	83 c4 08             	add    $0x8,%esp
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	0f 88 81 00 00 00    	js     801470 <dup+0xa3>
		return r;
	close(newfdnum);
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	ff 75 0c             	pushl  0xc(%ebp)
  8013f5:	e8 85 ff ff ff       	call   80137f <close>

	newfd = INDEX2FD(newfdnum);
  8013fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013fd:	c1 e6 0c             	shl    $0xc,%esi
  801400:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801406:	83 c4 04             	add    $0x4,%esp
  801409:	ff 75 e4             	pushl  -0x1c(%ebp)
  80140c:	e8 d5 fd ff ff       	call   8011e6 <fd2data>
  801411:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801413:	89 34 24             	mov    %esi,(%esp)
  801416:	e8 cb fd ff ff       	call   8011e6 <fd2data>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801420:	89 d8                	mov    %ebx,%eax
  801422:	c1 e8 16             	shr    $0x16,%eax
  801425:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80142c:	a8 01                	test   $0x1,%al
  80142e:	74 11                	je     801441 <dup+0x74>
  801430:	89 d8                	mov    %ebx,%eax
  801432:	c1 e8 0c             	shr    $0xc,%eax
  801435:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80143c:	f6 c2 01             	test   $0x1,%dl
  80143f:	75 39                	jne    80147a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801441:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	c1 e8 0c             	shr    $0xc,%eax
  801449:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801450:	83 ec 0c             	sub    $0xc,%esp
  801453:	25 07 0e 00 00       	and    $0xe07,%eax
  801458:	50                   	push   %eax
  801459:	56                   	push   %esi
  80145a:	6a 00                	push   $0x0
  80145c:	52                   	push   %edx
  80145d:	6a 00                	push   $0x0
  80145f:	e8 54 f7 ff ff       	call   800bb8 <sys_page_map>
  801464:	89 c3                	mov    %eax,%ebx
  801466:	83 c4 20             	add    $0x20,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 31                	js     80149e <dup+0xd1>
		goto err;

	return newfdnum;
  80146d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801470:	89 d8                	mov    %ebx,%eax
  801472:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801475:	5b                   	pop    %ebx
  801476:	5e                   	pop    %esi
  801477:	5f                   	pop    %edi
  801478:	5d                   	pop    %ebp
  801479:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80147a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801481:	83 ec 0c             	sub    $0xc,%esp
  801484:	25 07 0e 00 00       	and    $0xe07,%eax
  801489:	50                   	push   %eax
  80148a:	57                   	push   %edi
  80148b:	6a 00                	push   $0x0
  80148d:	53                   	push   %ebx
  80148e:	6a 00                	push   $0x0
  801490:	e8 23 f7 ff ff       	call   800bb8 <sys_page_map>
  801495:	89 c3                	mov    %eax,%ebx
  801497:	83 c4 20             	add    $0x20,%esp
  80149a:	85 c0                	test   %eax,%eax
  80149c:	79 a3                	jns    801441 <dup+0x74>
	sys_page_unmap(0, newfd);
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	56                   	push   %esi
  8014a2:	6a 00                	push   $0x0
  8014a4:	e8 51 f7 ff ff       	call   800bfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014a9:	83 c4 08             	add    $0x8,%esp
  8014ac:	57                   	push   %edi
  8014ad:	6a 00                	push   $0x0
  8014af:	e8 46 f7 ff ff       	call   800bfa <sys_page_unmap>
	return r;
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	eb b7                	jmp    801470 <dup+0xa3>

008014b9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	53                   	push   %ebx
  8014bd:	83 ec 14             	sub    $0x14,%esp
  8014c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c6:	50                   	push   %eax
  8014c7:	53                   	push   %ebx
  8014c8:	e8 7f fd ff ff       	call   80124c <fd_lookup>
  8014cd:	83 c4 08             	add    $0x8,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	78 3f                	js     801513 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014da:	50                   	push   %eax
  8014db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014de:	ff 30                	pushl  (%eax)
  8014e0:	e8 be fd ff ff       	call   8012a3 <dev_lookup>
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	78 27                	js     801513 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ef:	8b 42 08             	mov    0x8(%edx),%eax
  8014f2:	83 e0 03             	and    $0x3,%eax
  8014f5:	83 f8 01             	cmp    $0x1,%eax
  8014f8:	74 1e                	je     801518 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fd:	8b 40 08             	mov    0x8(%eax),%eax
  801500:	85 c0                	test   %eax,%eax
  801502:	74 35                	je     801539 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	ff 75 10             	pushl  0x10(%ebp)
  80150a:	ff 75 0c             	pushl  0xc(%ebp)
  80150d:	52                   	push   %edx
  80150e:	ff d0                	call   *%eax
  801510:	83 c4 10             	add    $0x10,%esp
}
  801513:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801516:	c9                   	leave  
  801517:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801518:	a1 04 40 80 00       	mov    0x804004,%eax
  80151d:	8b 40 48             	mov    0x48(%eax),%eax
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	53                   	push   %ebx
  801524:	50                   	push   %eax
  801525:	68 fd 26 80 00       	push   $0x8026fd
  80152a:	e8 89 ec ff ff       	call   8001b8 <cprintf>
		return -E_INVAL;
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801537:	eb da                	jmp    801513 <read+0x5a>
		return -E_NOT_SUPP;
  801539:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153e:	eb d3                	jmp    801513 <read+0x5a>

00801540 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	57                   	push   %edi
  801544:	56                   	push   %esi
  801545:	53                   	push   %ebx
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	8b 7d 08             	mov    0x8(%ebp),%edi
  80154c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80154f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801554:	39 f3                	cmp    %esi,%ebx
  801556:	73 25                	jae    80157d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	89 f0                	mov    %esi,%eax
  80155d:	29 d8                	sub    %ebx,%eax
  80155f:	50                   	push   %eax
  801560:	89 d8                	mov    %ebx,%eax
  801562:	03 45 0c             	add    0xc(%ebp),%eax
  801565:	50                   	push   %eax
  801566:	57                   	push   %edi
  801567:	e8 4d ff ff ff       	call   8014b9 <read>
		if (m < 0)
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	85 c0                	test   %eax,%eax
  801571:	78 08                	js     80157b <readn+0x3b>
			return m;
		if (m == 0)
  801573:	85 c0                	test   %eax,%eax
  801575:	74 06                	je     80157d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801577:	01 c3                	add    %eax,%ebx
  801579:	eb d9                	jmp    801554 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80157b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80157d:	89 d8                	mov    %ebx,%eax
  80157f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5f                   	pop    %edi
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	53                   	push   %ebx
  80158b:	83 ec 14             	sub    $0x14,%esp
  80158e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801591:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801594:	50                   	push   %eax
  801595:	53                   	push   %ebx
  801596:	e8 b1 fc ff ff       	call   80124c <fd_lookup>
  80159b:	83 c4 08             	add    $0x8,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 3a                	js     8015dc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a2:	83 ec 08             	sub    $0x8,%esp
  8015a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a8:	50                   	push   %eax
  8015a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ac:	ff 30                	pushl  (%eax)
  8015ae:	e8 f0 fc ff ff       	call   8012a3 <dev_lookup>
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 22                	js     8015dc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015c1:	74 1e                	je     8015e1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c9:	85 d2                	test   %edx,%edx
  8015cb:	74 35                	je     801602 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015cd:	83 ec 04             	sub    $0x4,%esp
  8015d0:	ff 75 10             	pushl  0x10(%ebp)
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	50                   	push   %eax
  8015d7:	ff d2                	call   *%edx
  8015d9:	83 c4 10             	add    $0x10,%esp
}
  8015dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8015e6:	8b 40 48             	mov    0x48(%eax),%eax
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	53                   	push   %ebx
  8015ed:	50                   	push   %eax
  8015ee:	68 19 27 80 00       	push   $0x802719
  8015f3:	e8 c0 eb ff ff       	call   8001b8 <cprintf>
		return -E_INVAL;
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801600:	eb da                	jmp    8015dc <write+0x55>
		return -E_NOT_SUPP;
  801602:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801607:	eb d3                	jmp    8015dc <write+0x55>

00801609 <seek>:

int
seek(int fdnum, off_t offset)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80160f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801612:	50                   	push   %eax
  801613:	ff 75 08             	pushl  0x8(%ebp)
  801616:	e8 31 fc ff ff       	call   80124c <fd_lookup>
  80161b:	83 c4 08             	add    $0x8,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 0e                	js     801630 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801622:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	53                   	push   %ebx
  801636:	83 ec 14             	sub    $0x14,%esp
  801639:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80163f:	50                   	push   %eax
  801640:	53                   	push   %ebx
  801641:	e8 06 fc ff ff       	call   80124c <fd_lookup>
  801646:	83 c4 08             	add    $0x8,%esp
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 37                	js     801684 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164d:	83 ec 08             	sub    $0x8,%esp
  801650:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801653:	50                   	push   %eax
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	ff 30                	pushl  (%eax)
  801659:	e8 45 fc ff ff       	call   8012a3 <dev_lookup>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	78 1f                	js     801684 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80166c:	74 1b                	je     801689 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80166e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801671:	8b 52 18             	mov    0x18(%edx),%edx
  801674:	85 d2                	test   %edx,%edx
  801676:	74 32                	je     8016aa <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	50                   	push   %eax
  80167f:	ff d2                	call   *%edx
  801681:	83 c4 10             	add    $0x10,%esp
}
  801684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801687:	c9                   	leave  
  801688:	c3                   	ret    
			thisenv->env_id, fdnum);
  801689:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80168e:	8b 40 48             	mov    0x48(%eax),%eax
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	53                   	push   %ebx
  801695:	50                   	push   %eax
  801696:	68 dc 26 80 00       	push   $0x8026dc
  80169b:	e8 18 eb ff ff       	call   8001b8 <cprintf>
		return -E_INVAL;
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a8:	eb da                	jmp    801684 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016af:	eb d3                	jmp    801684 <ftruncate+0x52>

008016b1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 14             	sub    $0x14,%esp
  8016b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016be:	50                   	push   %eax
  8016bf:	ff 75 08             	pushl  0x8(%ebp)
  8016c2:	e8 85 fb ff ff       	call   80124c <fd_lookup>
  8016c7:	83 c4 08             	add    $0x8,%esp
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	78 4b                	js     801719 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ce:	83 ec 08             	sub    $0x8,%esp
  8016d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d4:	50                   	push   %eax
  8016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d8:	ff 30                	pushl  (%eax)
  8016da:	e8 c4 fb ff ff       	call   8012a3 <dev_lookup>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	78 33                	js     801719 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016ed:	74 2f                	je     80171e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016ef:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016f2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f9:	00 00 00 
	stat->st_type = 0;
  8016fc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801703:	00 00 00 
	stat->st_dev = dev;
  801706:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80170c:	83 ec 08             	sub    $0x8,%esp
  80170f:	53                   	push   %ebx
  801710:	ff 75 f0             	pushl  -0x10(%ebp)
  801713:	ff 50 14             	call   *0x14(%eax)
  801716:	83 c4 10             	add    $0x10,%esp
}
  801719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    
		return -E_NOT_SUPP;
  80171e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801723:	eb f4                	jmp    801719 <fstat+0x68>

00801725 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	56                   	push   %esi
  801729:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	6a 00                	push   $0x0
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 34 02 00 00       	call   80196b <open>
  801737:	89 c3                	mov    %eax,%ebx
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 1b                	js     80175b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	50                   	push   %eax
  801747:	e8 65 ff ff ff       	call   8016b1 <fstat>
  80174c:	89 c6                	mov    %eax,%esi
	close(fd);
  80174e:	89 1c 24             	mov    %ebx,(%esp)
  801751:	e8 29 fc ff ff       	call   80137f <close>
	return r;
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	89 f3                	mov    %esi,%ebx
}
  80175b:	89 d8                	mov    %ebx,%eax
  80175d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    

00801764 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	56                   	push   %esi
  801768:	53                   	push   %ebx
  801769:	89 c6                	mov    %eax,%esi
  80176b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80176d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801774:	74 27                	je     80179d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801776:	6a 07                	push   $0x7
  801778:	68 00 50 80 00       	push   $0x805000
  80177d:	56                   	push   %esi
  80177e:	ff 35 00 40 80 00    	pushl  0x804000
  801784:	e8 af f9 ff ff       	call   801138 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801789:	83 c4 0c             	add    $0xc,%esp
  80178c:	6a 00                	push   $0x0
  80178e:	53                   	push   %ebx
  80178f:	6a 00                	push   $0x0
  801791:	e8 19 f9 ff ff       	call   8010af <ipc_recv>
}
  801796:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5d                   	pop    %ebp
  80179c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80179d:	83 ec 0c             	sub    $0xc,%esp
  8017a0:	6a 01                	push   $0x1
  8017a2:	e8 ed f9 ff ff       	call   801194 <ipc_find_env>
  8017a7:	a3 00 40 80 00       	mov    %eax,0x804000
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	eb c5                	jmp    801776 <fsipc+0x12>

008017b1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cf:	b8 02 00 00 00       	mov    $0x2,%eax
  8017d4:	e8 8b ff ff ff       	call   801764 <fsipc>
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <devfile_flush>:
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f6:	e8 69 ff ff ff       	call   801764 <fsipc>
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <devfile_stat>:
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	53                   	push   %ebx
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 40 0c             	mov    0xc(%eax),%eax
  80180d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801812:	ba 00 00 00 00       	mov    $0x0,%edx
  801817:	b8 05 00 00 00       	mov    $0x5,%eax
  80181c:	e8 43 ff ff ff       	call   801764 <fsipc>
  801821:	85 c0                	test   %eax,%eax
  801823:	78 2c                	js     801851 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801825:	83 ec 08             	sub    $0x8,%esp
  801828:	68 00 50 80 00       	push   $0x805000
  80182d:	53                   	push   %ebx
  80182e:	e8 8d ef ff ff       	call   8007c0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801833:	a1 80 50 80 00       	mov    0x805080,%eax
  801838:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80183e:	a1 84 50 80 00       	mov    0x805084,%eax
  801843:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801851:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <devfile_write>:
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	53                   	push   %ebx
  80185a:	83 ec 04             	sub    $0x4,%esp
  80185d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801860:	89 d8                	mov    %ebx,%eax
  801862:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801868:	76 05                	jbe    80186f <devfile_write+0x19>
  80186a:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80186f:	8b 55 08             	mov    0x8(%ebp),%edx
  801872:	8b 52 0c             	mov    0xc(%edx),%edx
  801875:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80187b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	50                   	push   %eax
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	68 08 50 80 00       	push   $0x805008
  80188c:	e8 a2 f0 ff ff       	call   800933 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801891:	ba 00 00 00 00       	mov    $0x0,%edx
  801896:	b8 04 00 00 00       	mov    $0x4,%eax
  80189b:	e8 c4 fe ff ff       	call   801764 <fsipc>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 0b                	js     8018b2 <devfile_write+0x5c>
	assert(r <= n);
  8018a7:	39 c3                	cmp    %eax,%ebx
  8018a9:	72 0c                	jb     8018b7 <devfile_write+0x61>
	assert(r <= PGSIZE);
  8018ab:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018b0:	7f 1e                	jg     8018d0 <devfile_write+0x7a>
}
  8018b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    
	assert(r <= n);
  8018b7:	68 48 27 80 00       	push   $0x802748
  8018bc:	68 56 26 80 00       	push   $0x802656
  8018c1:	68 98 00 00 00       	push   $0x98
  8018c6:	68 4f 27 80 00       	push   $0x80274f
  8018cb:	e8 11 06 00 00       	call   801ee1 <_panic>
	assert(r <= PGSIZE);
  8018d0:	68 5a 27 80 00       	push   $0x80275a
  8018d5:	68 56 26 80 00       	push   $0x802656
  8018da:	68 99 00 00 00       	push   $0x99
  8018df:	68 4f 27 80 00       	push   $0x80274f
  8018e4:	e8 f8 05 00 00       	call   801ee1 <_panic>

008018e9 <devfile_read>:
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	56                   	push   %esi
  8018ed:	53                   	push   %ebx
  8018ee:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018fc:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
  801907:	b8 03 00 00 00       	mov    $0x3,%eax
  80190c:	e8 53 fe ff ff       	call   801764 <fsipc>
  801911:	89 c3                	mov    %eax,%ebx
  801913:	85 c0                	test   %eax,%eax
  801915:	78 1f                	js     801936 <devfile_read+0x4d>
	assert(r <= n);
  801917:	39 c6                	cmp    %eax,%esi
  801919:	72 24                	jb     80193f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80191b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801920:	7f 33                	jg     801955 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	50                   	push   %eax
  801926:	68 00 50 80 00       	push   $0x805000
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	e8 00 f0 ff ff       	call   800933 <memmove>
	return r;
  801933:	83 c4 10             	add    $0x10,%esp
}
  801936:	89 d8                	mov    %ebx,%eax
  801938:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193b:	5b                   	pop    %ebx
  80193c:	5e                   	pop    %esi
  80193d:	5d                   	pop    %ebp
  80193e:	c3                   	ret    
	assert(r <= n);
  80193f:	68 48 27 80 00       	push   $0x802748
  801944:	68 56 26 80 00       	push   $0x802656
  801949:	6a 7c                	push   $0x7c
  80194b:	68 4f 27 80 00       	push   $0x80274f
  801950:	e8 8c 05 00 00       	call   801ee1 <_panic>
	assert(r <= PGSIZE);
  801955:	68 5a 27 80 00       	push   $0x80275a
  80195a:	68 56 26 80 00       	push   $0x802656
  80195f:	6a 7d                	push   $0x7d
  801961:	68 4f 27 80 00       	push   $0x80274f
  801966:	e8 76 05 00 00       	call   801ee1 <_panic>

0080196b <open>:
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	83 ec 1c             	sub    $0x1c,%esp
  801973:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801976:	56                   	push   %esi
  801977:	e8 11 ee ff ff       	call   80078d <strlen>
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801984:	7f 6c                	jg     8019f2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801986:	83 ec 0c             	sub    $0xc,%esp
  801989:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198c:	50                   	push   %eax
  80198d:	e8 6b f8 ff ff       	call   8011fd <fd_alloc>
  801992:	89 c3                	mov    %eax,%ebx
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	78 3c                	js     8019d7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80199b:	83 ec 08             	sub    $0x8,%esp
  80199e:	56                   	push   %esi
  80199f:	68 00 50 80 00       	push   $0x805000
  8019a4:	e8 17 ee ff ff       	call   8007c0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b9:	e8 a6 fd ff ff       	call   801764 <fsipc>
  8019be:	89 c3                	mov    %eax,%ebx
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	78 19                	js     8019e0 <open+0x75>
	return fd2num(fd);
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cd:	e8 04 f8 ff ff       	call   8011d6 <fd2num>
  8019d2:	89 c3                	mov    %eax,%ebx
  8019d4:	83 c4 10             	add    $0x10,%esp
}
  8019d7:	89 d8                	mov    %ebx,%eax
  8019d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019dc:	5b                   	pop    %ebx
  8019dd:	5e                   	pop    %esi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    
		fd_close(fd, 0);
  8019e0:	83 ec 08             	sub    $0x8,%esp
  8019e3:	6a 00                	push   $0x0
  8019e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e8:	e8 0c f9 ff ff       	call   8012f9 <fd_close>
		return r;
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	eb e5                	jmp    8019d7 <open+0x6c>
		return -E_BAD_PATH;
  8019f2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019f7:	eb de                	jmp    8019d7 <open+0x6c>

008019f9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801a04:	b8 08 00 00 00       	mov    $0x8,%eax
  801a09:	e8 56 fd ff ff       	call   801764 <fsipc>
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	56                   	push   %esi
  801a14:	53                   	push   %ebx
  801a15:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a18:	83 ec 0c             	sub    $0xc,%esp
  801a1b:	ff 75 08             	pushl  0x8(%ebp)
  801a1e:	e8 c3 f7 ff ff       	call   8011e6 <fd2data>
  801a23:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a25:	83 c4 08             	add    $0x8,%esp
  801a28:	68 66 27 80 00       	push   $0x802766
  801a2d:	53                   	push   %ebx
  801a2e:	e8 8d ed ff ff       	call   8007c0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a33:	8b 46 04             	mov    0x4(%esi),%eax
  801a36:	2b 06                	sub    (%esi),%eax
  801a38:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801a3e:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801a45:	10 00 00 
	stat->st_dev = &devpipe;
  801a48:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a4f:	30 80 00 
	return 0;
}
  801a52:	b8 00 00 00 00       	mov    $0x0,%eax
  801a57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5e                   	pop    %esi
  801a5c:	5d                   	pop    %ebp
  801a5d:	c3                   	ret    

00801a5e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	53                   	push   %ebx
  801a62:	83 ec 0c             	sub    $0xc,%esp
  801a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a68:	53                   	push   %ebx
  801a69:	6a 00                	push   $0x0
  801a6b:	e8 8a f1 ff ff       	call   800bfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a70:	89 1c 24             	mov    %ebx,(%esp)
  801a73:	e8 6e f7 ff ff       	call   8011e6 <fd2data>
  801a78:	83 c4 08             	add    $0x8,%esp
  801a7b:	50                   	push   %eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	e8 77 f1 ff ff       	call   800bfa <sys_page_unmap>
}
  801a83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <_pipeisclosed>:
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	57                   	push   %edi
  801a8c:	56                   	push   %esi
  801a8d:	53                   	push   %ebx
  801a8e:	83 ec 1c             	sub    $0x1c,%esp
  801a91:	89 c7                	mov    %eax,%edi
  801a93:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a95:	a1 04 40 80 00       	mov    0x804004,%eax
  801a9a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a9d:	83 ec 0c             	sub    $0xc,%esp
  801aa0:	57                   	push   %edi
  801aa1:	e8 26 05 00 00       	call   801fcc <pageref>
  801aa6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aa9:	89 34 24             	mov    %esi,(%esp)
  801aac:	e8 1b 05 00 00       	call   801fcc <pageref>
		nn = thisenv->env_runs;
  801ab1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ab7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	39 cb                	cmp    %ecx,%ebx
  801abf:	74 1b                	je     801adc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ac1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ac4:	75 cf                	jne    801a95 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ac6:	8b 42 58             	mov    0x58(%edx),%eax
  801ac9:	6a 01                	push   $0x1
  801acb:	50                   	push   %eax
  801acc:	53                   	push   %ebx
  801acd:	68 6d 27 80 00       	push   $0x80276d
  801ad2:	e8 e1 e6 ff ff       	call   8001b8 <cprintf>
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	eb b9                	jmp    801a95 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801adc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801adf:	0f 94 c0             	sete   %al
  801ae2:	0f b6 c0             	movzbl %al,%eax
}
  801ae5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae8:	5b                   	pop    %ebx
  801ae9:	5e                   	pop    %esi
  801aea:	5f                   	pop    %edi
  801aeb:	5d                   	pop    %ebp
  801aec:	c3                   	ret    

00801aed <devpipe_write>:
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	57                   	push   %edi
  801af1:	56                   	push   %esi
  801af2:	53                   	push   %ebx
  801af3:	83 ec 18             	sub    $0x18,%esp
  801af6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801af9:	56                   	push   %esi
  801afa:	e8 e7 f6 ff ff       	call   8011e6 <fd2data>
  801aff:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	bf 00 00 00 00       	mov    $0x0,%edi
  801b09:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b0c:	74 41                	je     801b4f <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b0e:	8b 53 04             	mov    0x4(%ebx),%edx
  801b11:	8b 03                	mov    (%ebx),%eax
  801b13:	83 c0 20             	add    $0x20,%eax
  801b16:	39 c2                	cmp    %eax,%edx
  801b18:	72 14                	jb     801b2e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b1a:	89 da                	mov    %ebx,%edx
  801b1c:	89 f0                	mov    %esi,%eax
  801b1e:	e8 65 ff ff ff       	call   801a88 <_pipeisclosed>
  801b23:	85 c0                	test   %eax,%eax
  801b25:	75 2c                	jne    801b53 <devpipe_write+0x66>
			sys_yield();
  801b27:	e8 10 f1 ff ff       	call   800c3c <sys_yield>
  801b2c:	eb e0                	jmp    801b0e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b31:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801b34:	89 d0                	mov    %edx,%eax
  801b36:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801b3b:	78 0b                	js     801b48 <devpipe_write+0x5b>
  801b3d:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801b41:	42                   	inc    %edx
  801b42:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b45:	47                   	inc    %edi
  801b46:	eb c1                	jmp    801b09 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b48:	48                   	dec    %eax
  801b49:	83 c8 e0             	or     $0xffffffe0,%eax
  801b4c:	40                   	inc    %eax
  801b4d:	eb ee                	jmp    801b3d <devpipe_write+0x50>
	return i;
  801b4f:	89 f8                	mov    %edi,%eax
  801b51:	eb 05                	jmp    801b58 <devpipe_write+0x6b>
				return 0;
  801b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5f                   	pop    %edi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    

00801b60 <devpipe_read>:
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	57                   	push   %edi
  801b64:	56                   	push   %esi
  801b65:	53                   	push   %ebx
  801b66:	83 ec 18             	sub    $0x18,%esp
  801b69:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b6c:	57                   	push   %edi
  801b6d:	e8 74 f6 ff ff       	call   8011e6 <fd2data>
  801b72:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b7c:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b7f:	74 46                	je     801bc7 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801b81:	8b 06                	mov    (%esi),%eax
  801b83:	3b 46 04             	cmp    0x4(%esi),%eax
  801b86:	75 22                	jne    801baa <devpipe_read+0x4a>
			if (i > 0)
  801b88:	85 db                	test   %ebx,%ebx
  801b8a:	74 0a                	je     801b96 <devpipe_read+0x36>
				return i;
  801b8c:	89 d8                	mov    %ebx,%eax
}
  801b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b91:	5b                   	pop    %ebx
  801b92:	5e                   	pop    %esi
  801b93:	5f                   	pop    %edi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801b96:	89 f2                	mov    %esi,%edx
  801b98:	89 f8                	mov    %edi,%eax
  801b9a:	e8 e9 fe ff ff       	call   801a88 <_pipeisclosed>
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	75 28                	jne    801bcb <devpipe_read+0x6b>
			sys_yield();
  801ba3:	e8 94 f0 ff ff       	call   800c3c <sys_yield>
  801ba8:	eb d7                	jmp    801b81 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801baa:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801baf:	78 0f                	js     801bc0 <devpipe_read+0x60>
  801bb1:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801bb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb8:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801bbb:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801bbd:	43                   	inc    %ebx
  801bbe:	eb bc                	jmp    801b7c <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bc0:	48                   	dec    %eax
  801bc1:	83 c8 e0             	or     $0xffffffe0,%eax
  801bc4:	40                   	inc    %eax
  801bc5:	eb ea                	jmp    801bb1 <devpipe_read+0x51>
	return i;
  801bc7:	89 d8                	mov    %ebx,%eax
  801bc9:	eb c3                	jmp    801b8e <devpipe_read+0x2e>
				return 0;
  801bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd0:	eb bc                	jmp    801b8e <devpipe_read+0x2e>

00801bd2 <pipe>:
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	56                   	push   %esi
  801bd6:	53                   	push   %ebx
  801bd7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bdd:	50                   	push   %eax
  801bde:	e8 1a f6 ff ff       	call   8011fd <fd_alloc>
  801be3:	89 c3                	mov    %eax,%ebx
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	85 c0                	test   %eax,%eax
  801bea:	0f 88 2a 01 00 00    	js     801d1a <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	68 07 04 00 00       	push   $0x407
  801bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfb:	6a 00                	push   $0x0
  801bfd:	e8 73 ef ff ff       	call   800b75 <sys_page_alloc>
  801c02:	89 c3                	mov    %eax,%ebx
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	85 c0                	test   %eax,%eax
  801c09:	0f 88 0b 01 00 00    	js     801d1a <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c15:	50                   	push   %eax
  801c16:	e8 e2 f5 ff ff       	call   8011fd <fd_alloc>
  801c1b:	89 c3                	mov    %eax,%ebx
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	85 c0                	test   %eax,%eax
  801c22:	0f 88 e2 00 00 00    	js     801d0a <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	68 07 04 00 00       	push   $0x407
  801c30:	ff 75 f0             	pushl  -0x10(%ebp)
  801c33:	6a 00                	push   $0x0
  801c35:	e8 3b ef ff ff       	call   800b75 <sys_page_alloc>
  801c3a:	89 c3                	mov    %eax,%ebx
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	0f 88 c3 00 00 00    	js     801d0a <pipe+0x138>
	va = fd2data(fd0);
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4d:	e8 94 f5 ff ff       	call   8011e6 <fd2data>
  801c52:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c54:	83 c4 0c             	add    $0xc,%esp
  801c57:	68 07 04 00 00       	push   $0x407
  801c5c:	50                   	push   %eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	e8 11 ef ff ff       	call   800b75 <sys_page_alloc>
  801c64:	89 c3                	mov    %eax,%ebx
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	0f 88 89 00 00 00    	js     801cfa <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	ff 75 f0             	pushl  -0x10(%ebp)
  801c77:	e8 6a f5 ff ff       	call   8011e6 <fd2data>
  801c7c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c83:	50                   	push   %eax
  801c84:	6a 00                	push   $0x0
  801c86:	56                   	push   %esi
  801c87:	6a 00                	push   $0x0
  801c89:	e8 2a ef ff ff       	call   800bb8 <sys_page_map>
  801c8e:	89 c3                	mov    %eax,%ebx
  801c90:	83 c4 20             	add    $0x20,%esp
  801c93:	85 c0                	test   %eax,%eax
  801c95:	78 55                	js     801cec <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801c97:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801cac:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc7:	e8 0a f5 ff ff       	call   8011d6 <fd2num>
  801ccc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ccf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cd1:	83 c4 04             	add    $0x4,%esp
  801cd4:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd7:	e8 fa f4 ff ff       	call   8011d6 <fd2num>
  801cdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cdf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ce2:	83 c4 10             	add    $0x10,%esp
  801ce5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cea:	eb 2e                	jmp    801d1a <pipe+0x148>
	sys_page_unmap(0, va);
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	56                   	push   %esi
  801cf0:	6a 00                	push   $0x0
  801cf2:	e8 03 ef ff ff       	call   800bfa <sys_page_unmap>
  801cf7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cfa:	83 ec 08             	sub    $0x8,%esp
  801cfd:	ff 75 f0             	pushl  -0x10(%ebp)
  801d00:	6a 00                	push   $0x0
  801d02:	e8 f3 ee ff ff       	call   800bfa <sys_page_unmap>
  801d07:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d0a:	83 ec 08             	sub    $0x8,%esp
  801d0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d10:	6a 00                	push   $0x0
  801d12:	e8 e3 ee ff ff       	call   800bfa <sys_page_unmap>
  801d17:	83 c4 10             	add    $0x10,%esp
}
  801d1a:	89 d8                	mov    %ebx,%eax
  801d1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5d                   	pop    %ebp
  801d22:	c3                   	ret    

00801d23 <pipeisclosed>:
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2c:	50                   	push   %eax
  801d2d:	ff 75 08             	pushl  0x8(%ebp)
  801d30:	e8 17 f5 ff ff       	call   80124c <fd_lookup>
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	78 18                	js     801d54 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d42:	e8 9f f4 ff ff       	call   8011e6 <fd2data>
	return _pipeisclosed(fd, p);
  801d47:	89 c2                	mov    %eax,%edx
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	e8 37 fd ff ff       	call   801a88 <_pipeisclosed>
  801d51:	83 c4 10             	add    $0x10,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    

00801d60 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	53                   	push   %ebx
  801d64:	83 ec 0c             	sub    $0xc,%esp
  801d67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801d6a:	68 85 27 80 00       	push   $0x802785
  801d6f:	53                   	push   %ebx
  801d70:	e8 4b ea ff ff       	call   8007c0 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801d75:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801d7c:	20 00 00 
	return 0;
}
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <devcons_write>:
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	57                   	push   %edi
  801d8d:	56                   	push   %esi
  801d8e:	53                   	push   %ebx
  801d8f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d95:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d9a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801da0:	eb 1d                	jmp    801dbf <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	53                   	push   %ebx
  801da6:	03 45 0c             	add    0xc(%ebp),%eax
  801da9:	50                   	push   %eax
  801daa:	57                   	push   %edi
  801dab:	e8 83 eb ff ff       	call   800933 <memmove>
		sys_cputs(buf, m);
  801db0:	83 c4 08             	add    $0x8,%esp
  801db3:	53                   	push   %ebx
  801db4:	57                   	push   %edi
  801db5:	e8 1e ed ff ff       	call   800ad8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801dba:	01 de                	add    %ebx,%esi
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	89 f0                	mov    %esi,%eax
  801dc1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc4:	73 11                	jae    801dd7 <devcons_write+0x4e>
		m = n - tot;
  801dc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801dc9:	29 f3                	sub    %esi,%ebx
  801dcb:	83 fb 7f             	cmp    $0x7f,%ebx
  801dce:	76 d2                	jbe    801da2 <devcons_write+0x19>
  801dd0:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801dd5:	eb cb                	jmp    801da2 <devcons_write+0x19>
}
  801dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dda:	5b                   	pop    %ebx
  801ddb:	5e                   	pop    %esi
  801ddc:	5f                   	pop    %edi
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    

00801ddf <devcons_read>:
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801de5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801de9:	75 0c                	jne    801df7 <devcons_read+0x18>
		return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
  801df0:	eb 21                	jmp    801e13 <devcons_read+0x34>
		sys_yield();
  801df2:	e8 45 ee ff ff       	call   800c3c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801df7:	e8 fa ec ff ff       	call   800af6 <sys_cgetc>
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	74 f2                	je     801df2 <devcons_read+0x13>
	if (c < 0)
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 0f                	js     801e13 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801e04:	83 f8 04             	cmp    $0x4,%eax
  801e07:	74 0c                	je     801e15 <devcons_read+0x36>
	*(char*)vbuf = c;
  801e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0c:	88 02                	mov    %al,(%edx)
	return 1;
  801e0e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    
		return 0;
  801e15:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1a:	eb f7                	jmp    801e13 <devcons_read+0x34>

00801e1c <cputchar>:
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e28:	6a 01                	push   $0x1
  801e2a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e2d:	50                   	push   %eax
  801e2e:	e8 a5 ec ff ff       	call   800ad8 <sys_cputs>
}
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <getchar>:
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e3e:	6a 01                	push   $0x1
  801e40:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e43:	50                   	push   %eax
  801e44:	6a 00                	push   $0x0
  801e46:	e8 6e f6 ff ff       	call   8014b9 <read>
	if (r < 0)
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	78 08                	js     801e5a <getchar+0x22>
	if (r < 1)
  801e52:	85 c0                	test   %eax,%eax
  801e54:	7e 06                	jle    801e5c <getchar+0x24>
	return c;
  801e56:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    
		return -E_EOF;
  801e5c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e61:	eb f7                	jmp    801e5a <getchar+0x22>

00801e63 <iscons>:
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6c:	50                   	push   %eax
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	e8 d7 f3 ff ff       	call   80124c <fd_lookup>
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	78 11                	js     801e8d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e85:	39 10                	cmp    %edx,(%eax)
  801e87:	0f 94 c0             	sete   %al
  801e8a:	0f b6 c0             	movzbl %al,%eax
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <opencons>:
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e98:	50                   	push   %eax
  801e99:	e8 5f f3 ff ff       	call   8011fd <fd_alloc>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 3a                	js     801edf <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	68 07 04 00 00       	push   $0x407
  801ead:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb0:	6a 00                	push   $0x0
  801eb2:	e8 be ec ff ff       	call   800b75 <sys_page_alloc>
  801eb7:	83 c4 10             	add    $0x10,%esp
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 21                	js     801edf <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ebe:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	50                   	push   %eax
  801ed7:	e8 fa f2 ff ff       	call   8011d6 <fd2num>
  801edc:	83 c4 10             	add    $0x10,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	57                   	push   %edi
  801ee5:	56                   	push   %esi
  801ee6:	53                   	push   %ebx
  801ee7:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801eed:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801ef0:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801ef6:	e8 5b ec ff ff       	call   800b56 <sys_getenvid>
  801efb:	83 ec 04             	sub    $0x4,%esp
  801efe:	ff 75 0c             	pushl  0xc(%ebp)
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	53                   	push   %ebx
  801f05:	50                   	push   %eax
  801f06:	68 94 27 80 00       	push   $0x802794
  801f0b:	68 00 01 00 00       	push   $0x100
  801f10:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801f16:	56                   	push   %esi
  801f17:	e8 57 e8 ff ff       	call   800773 <snprintf>
  801f1c:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801f1e:	83 c4 20             	add    $0x20,%esp
  801f21:	57                   	push   %edi
  801f22:	ff 75 10             	pushl  0x10(%ebp)
  801f25:	bf 00 01 00 00       	mov    $0x100,%edi
  801f2a:	89 f8                	mov    %edi,%eax
  801f2c:	29 d8                	sub    %ebx,%eax
  801f2e:	50                   	push   %eax
  801f2f:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801f32:	50                   	push   %eax
  801f33:	e8 e6 e7 ff ff       	call   80071e <vsnprintf>
  801f38:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801f3a:	83 c4 0c             	add    $0xc,%esp
  801f3d:	68 7e 27 80 00       	push   $0x80277e
  801f42:	29 df                	sub    %ebx,%edi
  801f44:	57                   	push   %edi
  801f45:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801f48:	50                   	push   %eax
  801f49:	e8 25 e8 ff ff       	call   800773 <snprintf>
	sys_cputs(buf, r);
  801f4e:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801f51:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801f53:	53                   	push   %ebx
  801f54:	56                   	push   %esi
  801f55:	e8 7e eb ff ff       	call   800ad8 <sys_cputs>
  801f5a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f5d:	cc                   	int3   
  801f5e:	eb fd                	jmp    801f5d <_panic+0x7c>

00801f60 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f66:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801f6d:	74 0a                	je     801f79 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801f79:	e8 d8 eb ff ff       	call   800b56 <sys_getenvid>
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	6a 07                	push   $0x7
  801f83:	68 00 f0 bf ee       	push   $0xeebff000
  801f88:	50                   	push   %eax
  801f89:	e8 e7 eb ff ff       	call   800b75 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801f8e:	e8 c3 eb ff ff       	call   800b56 <sys_getenvid>
  801f93:	83 c4 08             	add    $0x8,%esp
  801f96:	68 a6 1f 80 00       	push   $0x801fa6
  801f9b:	50                   	push   %eax
  801f9c:	e8 7f ed ff ff       	call   800d20 <sys_env_set_pgfault_upcall>
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	eb c9                	jmp    801f6f <set_pgfault_handler+0xf>

00801fa6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801fa6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801fa7:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801fac:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801fae:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  801fb1:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801fb5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801fb9:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801fbc:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801fbe:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  801fc2:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801fc5:	61                   	popa   
	addl $4, %esp
  801fc6:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801fc9:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801fca:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801fcb:	c3                   	ret    

00801fcc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	c1 e8 16             	shr    $0x16,%eax
  801fd5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801fdc:	a8 01                	test   $0x1,%al
  801fde:	74 21                	je     802001 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	c1 e8 0c             	shr    $0xc,%eax
  801fe6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801fed:	a8 01                	test   $0x1,%al
  801fef:	74 17                	je     802008 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ff1:	c1 e8 0c             	shr    $0xc,%eax
  801ff4:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801ffb:	ef 
  801ffc:	0f b7 c0             	movzwl %ax,%eax
  801fff:	eb 05                	jmp    802006 <pageref+0x3a>
		return 0;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802006:	5d                   	pop    %ebp
  802007:	c3                   	ret    
		return 0;
  802008:	b8 00 00 00 00       	mov    $0x0,%eax
  80200d:	eb f7                	jmp    802006 <pageref+0x3a>
  80200f:	90                   	nop

00802010 <__udivdi3>:
  802010:	55                   	push   %ebp
  802011:	57                   	push   %edi
  802012:	56                   	push   %esi
  802013:	53                   	push   %ebx
  802014:	83 ec 1c             	sub    $0x1c,%esp
  802017:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80201b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80201f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802023:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802027:	89 ca                	mov    %ecx,%edx
  802029:	89 f8                	mov    %edi,%eax
  80202b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80202f:	85 f6                	test   %esi,%esi
  802031:	75 2d                	jne    802060 <__udivdi3+0x50>
  802033:	39 cf                	cmp    %ecx,%edi
  802035:	77 65                	ja     80209c <__udivdi3+0x8c>
  802037:	89 fd                	mov    %edi,%ebp
  802039:	85 ff                	test   %edi,%edi
  80203b:	75 0b                	jne    802048 <__udivdi3+0x38>
  80203d:	b8 01 00 00 00       	mov    $0x1,%eax
  802042:	31 d2                	xor    %edx,%edx
  802044:	f7 f7                	div    %edi
  802046:	89 c5                	mov    %eax,%ebp
  802048:	31 d2                	xor    %edx,%edx
  80204a:	89 c8                	mov    %ecx,%eax
  80204c:	f7 f5                	div    %ebp
  80204e:	89 c1                	mov    %eax,%ecx
  802050:	89 d8                	mov    %ebx,%eax
  802052:	f7 f5                	div    %ebp
  802054:	89 cf                	mov    %ecx,%edi
  802056:	89 fa                	mov    %edi,%edx
  802058:	83 c4 1c             	add    $0x1c,%esp
  80205b:	5b                   	pop    %ebx
  80205c:	5e                   	pop    %esi
  80205d:	5f                   	pop    %edi
  80205e:	5d                   	pop    %ebp
  80205f:	c3                   	ret    
  802060:	39 ce                	cmp    %ecx,%esi
  802062:	77 28                	ja     80208c <__udivdi3+0x7c>
  802064:	0f bd fe             	bsr    %esi,%edi
  802067:	83 f7 1f             	xor    $0x1f,%edi
  80206a:	75 40                	jne    8020ac <__udivdi3+0x9c>
  80206c:	39 ce                	cmp    %ecx,%esi
  80206e:	72 0a                	jb     80207a <__udivdi3+0x6a>
  802070:	3b 44 24 04          	cmp    0x4(%esp),%eax
  802074:	0f 87 9e 00 00 00    	ja     802118 <__udivdi3+0x108>
  80207a:	b8 01 00 00 00       	mov    $0x1,%eax
  80207f:	89 fa                	mov    %edi,%edx
  802081:	83 c4 1c             	add    $0x1c,%esp
  802084:	5b                   	pop    %ebx
  802085:	5e                   	pop    %esi
  802086:	5f                   	pop    %edi
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    
  802089:	8d 76 00             	lea    0x0(%esi),%esi
  80208c:	31 ff                	xor    %edi,%edi
  80208e:	31 c0                	xor    %eax,%eax
  802090:	89 fa                	mov    %edi,%edx
  802092:	83 c4 1c             	add    $0x1c,%esp
  802095:	5b                   	pop    %ebx
  802096:	5e                   	pop    %esi
  802097:	5f                   	pop    %edi
  802098:	5d                   	pop    %ebp
  802099:	c3                   	ret    
  80209a:	66 90                	xchg   %ax,%ax
  80209c:	89 d8                	mov    %ebx,%eax
  80209e:	f7 f7                	div    %edi
  8020a0:	31 ff                	xor    %edi,%edi
  8020a2:	89 fa                	mov    %edi,%edx
  8020a4:	83 c4 1c             	add    $0x1c,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
  8020ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020b1:	29 fd                	sub    %edi,%ebp
  8020b3:	89 f9                	mov    %edi,%ecx
  8020b5:	d3 e6                	shl    %cl,%esi
  8020b7:	89 c3                	mov    %eax,%ebx
  8020b9:	89 e9                	mov    %ebp,%ecx
  8020bb:	d3 eb                	shr    %cl,%ebx
  8020bd:	89 d9                	mov    %ebx,%ecx
  8020bf:	09 f1                	or     %esi,%ecx
  8020c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020c5:	89 f9                	mov    %edi,%ecx
  8020c7:	d3 e0                	shl    %cl,%eax
  8020c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020cd:	89 d6                	mov    %edx,%esi
  8020cf:	89 e9                	mov    %ebp,%ecx
  8020d1:	d3 ee                	shr    %cl,%esi
  8020d3:	89 f9                	mov    %edi,%ecx
  8020d5:	d3 e2                	shl    %cl,%edx
  8020d7:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8020db:	89 e9                	mov    %ebp,%ecx
  8020dd:	d3 eb                	shr    %cl,%ebx
  8020df:	09 da                	or     %ebx,%edx
  8020e1:	89 d0                	mov    %edx,%eax
  8020e3:	89 f2                	mov    %esi,%edx
  8020e5:	f7 74 24 08          	divl   0x8(%esp)
  8020e9:	89 d6                	mov    %edx,%esi
  8020eb:	89 c3                	mov    %eax,%ebx
  8020ed:	f7 64 24 0c          	mull   0xc(%esp)
  8020f1:	39 d6                	cmp    %edx,%esi
  8020f3:	72 17                	jb     80210c <__udivdi3+0xfc>
  8020f5:	74 09                	je     802100 <__udivdi3+0xf0>
  8020f7:	89 d8                	mov    %ebx,%eax
  8020f9:	31 ff                	xor    %edi,%edi
  8020fb:	e9 56 ff ff ff       	jmp    802056 <__udivdi3+0x46>
  802100:	8b 54 24 04          	mov    0x4(%esp),%edx
  802104:	89 f9                	mov    %edi,%ecx
  802106:	d3 e2                	shl    %cl,%edx
  802108:	39 c2                	cmp    %eax,%edx
  80210a:	73 eb                	jae    8020f7 <__udivdi3+0xe7>
  80210c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80210f:	31 ff                	xor    %edi,%edi
  802111:	e9 40 ff ff ff       	jmp    802056 <__udivdi3+0x46>
  802116:	66 90                	xchg   %ax,%ax
  802118:	31 c0                	xor    %eax,%eax
  80211a:	e9 37 ff ff ff       	jmp    802056 <__udivdi3+0x46>
  80211f:	90                   	nop

00802120 <__umoddi3>:
  802120:	55                   	push   %ebp
  802121:	57                   	push   %edi
  802122:	56                   	push   %esi
  802123:	53                   	push   %ebx
  802124:	83 ec 1c             	sub    $0x1c,%esp
  802127:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80212b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80212f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802133:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80213b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80213f:	89 3c 24             	mov    %edi,(%esp)
  802142:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802146:	89 f2                	mov    %esi,%edx
  802148:	85 c0                	test   %eax,%eax
  80214a:	75 18                	jne    802164 <__umoddi3+0x44>
  80214c:	39 f7                	cmp    %esi,%edi
  80214e:	0f 86 a0 00 00 00    	jbe    8021f4 <__umoddi3+0xd4>
  802154:	89 c8                	mov    %ecx,%eax
  802156:	f7 f7                	div    %edi
  802158:	89 d0                	mov    %edx,%eax
  80215a:	31 d2                	xor    %edx,%edx
  80215c:	83 c4 1c             	add    $0x1c,%esp
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	5f                   	pop    %edi
  802162:	5d                   	pop    %ebp
  802163:	c3                   	ret    
  802164:	89 f3                	mov    %esi,%ebx
  802166:	39 f0                	cmp    %esi,%eax
  802168:	0f 87 a6 00 00 00    	ja     802214 <__umoddi3+0xf4>
  80216e:	0f bd e8             	bsr    %eax,%ebp
  802171:	83 f5 1f             	xor    $0x1f,%ebp
  802174:	0f 84 a6 00 00 00    	je     802220 <__umoddi3+0x100>
  80217a:	bf 20 00 00 00       	mov    $0x20,%edi
  80217f:	29 ef                	sub    %ebp,%edi
  802181:	89 e9                	mov    %ebp,%ecx
  802183:	d3 e0                	shl    %cl,%eax
  802185:	8b 34 24             	mov    (%esp),%esi
  802188:	89 f2                	mov    %esi,%edx
  80218a:	89 f9                	mov    %edi,%ecx
  80218c:	d3 ea                	shr    %cl,%edx
  80218e:	09 c2                	or     %eax,%edx
  802190:	89 14 24             	mov    %edx,(%esp)
  802193:	89 f2                	mov    %esi,%edx
  802195:	89 e9                	mov    %ebp,%ecx
  802197:	d3 e2                	shl    %cl,%edx
  802199:	89 54 24 04          	mov    %edx,0x4(%esp)
  80219d:	89 de                	mov    %ebx,%esi
  80219f:	89 f9                	mov    %edi,%ecx
  8021a1:	d3 ee                	shr    %cl,%esi
  8021a3:	89 e9                	mov    %ebp,%ecx
  8021a5:	d3 e3                	shl    %cl,%ebx
  8021a7:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021ab:	89 d0                	mov    %edx,%eax
  8021ad:	89 f9                	mov    %edi,%ecx
  8021af:	d3 e8                	shr    %cl,%eax
  8021b1:	09 d8                	or     %ebx,%eax
  8021b3:	89 d3                	mov    %edx,%ebx
  8021b5:	89 e9                	mov    %ebp,%ecx
  8021b7:	d3 e3                	shl    %cl,%ebx
  8021b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021bd:	89 f2                	mov    %esi,%edx
  8021bf:	f7 34 24             	divl   (%esp)
  8021c2:	89 d6                	mov    %edx,%esi
  8021c4:	f7 64 24 04          	mull   0x4(%esp)
  8021c8:	89 c3                	mov    %eax,%ebx
  8021ca:	89 d1                	mov    %edx,%ecx
  8021cc:	39 d6                	cmp    %edx,%esi
  8021ce:	72 7c                	jb     80224c <__umoddi3+0x12c>
  8021d0:	74 72                	je     802244 <__umoddi3+0x124>
  8021d2:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021d6:	29 da                	sub    %ebx,%edx
  8021d8:	19 ce                	sbb    %ecx,%esi
  8021da:	89 f0                	mov    %esi,%eax
  8021dc:	89 f9                	mov    %edi,%ecx
  8021de:	d3 e0                	shl    %cl,%eax
  8021e0:	89 e9                	mov    %ebp,%ecx
  8021e2:	d3 ea                	shr    %cl,%edx
  8021e4:	09 d0                	or     %edx,%eax
  8021e6:	89 e9                	mov    %ebp,%ecx
  8021e8:	d3 ee                	shr    %cl,%esi
  8021ea:	89 f2                	mov    %esi,%edx
  8021ec:	83 c4 1c             	add    $0x1c,%esp
  8021ef:	5b                   	pop    %ebx
  8021f0:	5e                   	pop    %esi
  8021f1:	5f                   	pop    %edi
  8021f2:	5d                   	pop    %ebp
  8021f3:	c3                   	ret    
  8021f4:	89 fd                	mov    %edi,%ebp
  8021f6:	85 ff                	test   %edi,%edi
  8021f8:	75 0b                	jne    802205 <__umoddi3+0xe5>
  8021fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ff:	31 d2                	xor    %edx,%edx
  802201:	f7 f7                	div    %edi
  802203:	89 c5                	mov    %eax,%ebp
  802205:	89 f0                	mov    %esi,%eax
  802207:	31 d2                	xor    %edx,%edx
  802209:	f7 f5                	div    %ebp
  80220b:	89 c8                	mov    %ecx,%eax
  80220d:	f7 f5                	div    %ebp
  80220f:	e9 44 ff ff ff       	jmp    802158 <__umoddi3+0x38>
  802214:	89 c8                	mov    %ecx,%eax
  802216:	89 f2                	mov    %esi,%edx
  802218:	83 c4 1c             	add    $0x1c,%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5e                   	pop    %esi
  80221d:	5f                   	pop    %edi
  80221e:	5d                   	pop    %ebp
  80221f:	c3                   	ret    
  802220:	39 f0                	cmp    %esi,%eax
  802222:	72 05                	jb     802229 <__umoddi3+0x109>
  802224:	39 0c 24             	cmp    %ecx,(%esp)
  802227:	77 0c                	ja     802235 <__umoddi3+0x115>
  802229:	89 f2                	mov    %esi,%edx
  80222b:	29 f9                	sub    %edi,%ecx
  80222d:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802231:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802235:	8b 44 24 04          	mov    0x4(%esp),%eax
  802239:	83 c4 1c             	add    $0x1c,%esp
  80223c:	5b                   	pop    %ebx
  80223d:	5e                   	pop    %esi
  80223e:	5f                   	pop    %edi
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    
  802241:	8d 76 00             	lea    0x0(%esi),%esi
  802244:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802248:	73 88                	jae    8021d2 <__umoddi3+0xb2>
  80224a:	66 90                	xchg   %ax,%ax
  80224c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802250:	1b 14 24             	sbb    (%esp),%edx
  802253:	89 d1                	mov    %edx,%ecx
  802255:	89 c3                	mov    %eax,%ebx
  802257:	e9 76 ff ff ff       	jmp    8021d2 <__umoddi3+0xb2>
