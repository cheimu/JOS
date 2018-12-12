
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 d0 00 00 00       	call   800101 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 97 10 00 00       	call   8010d8 <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 72                	jne    8000ba <umain+0x87>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 9a 10 00 00       	call   8010f2 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 04 40 80 00       	mov    0x804004,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 28 0b 00 00       	call   800b99 <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 d0 22 80 00       	push   $0x8022d0
  800080:	e8 76 01 00 00       	call   8001fb <cprintf>
		if (val == 10)
  800085:	a1 04 40 80 00       	mov    0x804004,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 20                	je     8000b2 <umain+0x7f>
			return;
		++val;
  800092:	40                   	inc    %eax
  800093:	a3 04 40 80 00       	mov    %eax,0x804004
		ipc_send(who, 0, 0, 0);
  800098:	6a 00                	push   $0x0
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a1:	e8 d5 10 00 00       	call   80117b <ipc_send>
		if (val == 10)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	83 3d 04 40 80 00 0a 	cmpl   $0xa,0x804004
  8000b0:	75 96                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5e                   	pop    %esi
  8000b7:	5f                   	pop    %edi
  8000b8:	5d                   	pop    %ebp
  8000b9:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000ba:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000c0:	e8 d4 0a 00 00       	call   800b99 <sys_getenvid>
  8000c5:	83 ec 04             	sub    $0x4,%esp
  8000c8:	53                   	push   %ebx
  8000c9:	50                   	push   %eax
  8000ca:	68 a0 22 80 00       	push   $0x8022a0
  8000cf:	e8 27 01 00 00       	call   8001fb <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d7:	e8 bd 0a 00 00       	call   800b99 <sys_getenvid>
  8000dc:	83 c4 0c             	add    $0xc,%esp
  8000df:	53                   	push   %ebx
  8000e0:	50                   	push   %eax
  8000e1:	68 ba 22 80 00       	push   $0x8022ba
  8000e6:	e8 10 01 00 00       	call   8001fb <cprintf>
		ipc_send(who, 0, 0, 0);
  8000eb:	6a 00                	push   $0x0
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f4:	e8 82 10 00 00       	call   80117b <ipc_send>
  8000f9:	83 c4 20             	add    $0x20,%esp
  8000fc:	e9 47 ff ff ff       	jmp    800048 <umain+0x15>

00800101 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	56                   	push   %esi
  800105:	53                   	push   %ebx
  800106:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800109:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010c:	e8 88 0a 00 00       	call   800b99 <sys_getenvid>
  800111:	25 ff 03 00 00       	and    $0x3ff,%eax
  800116:	89 c2                	mov    %eax,%edx
  800118:	c1 e2 05             	shl    $0x5,%edx
  80011b:	29 c2                	sub    %eax,%edx
  80011d:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800124:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800129:	85 db                	test   %ebx,%ebx
  80012b:	7e 07                	jle    800134 <libmain+0x33>
		binaryname = argv[0];
  80012d:	8b 06                	mov    (%esi),%eax
  80012f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	e8 f5 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013e:	e8 0a 00 00 00       	call   80014d <exit>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800149:	5b                   	pop    %ebx
  80014a:	5e                   	pop    %esi
  80014b:	5d                   	pop    %ebp
  80014c:	c3                   	ret    

0080014d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800153:	e8 95 12 00 00       	call   8013ed <close_all>
	sys_env_destroy(0);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	6a 00                	push   $0x0
  80015d:	e8 f6 09 00 00       	call   800b58 <sys_env_destroy>
}
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	53                   	push   %ebx
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800171:	8b 13                	mov    (%ebx),%edx
  800173:	8d 42 01             	lea    0x1(%edx),%eax
  800176:	89 03                	mov    %eax,(%ebx)
  800178:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800184:	74 08                	je     80018e <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800186:	ff 43 04             	incl   0x4(%ebx)
}
  800189:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80018e:	83 ec 08             	sub    $0x8,%esp
  800191:	68 ff 00 00 00       	push   $0xff
  800196:	8d 43 08             	lea    0x8(%ebx),%eax
  800199:	50                   	push   %eax
  80019a:	e8 7c 09 00 00       	call   800b1b <sys_cputs>
		b->idx = 0;
  80019f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	eb dc                	jmp    800186 <putch+0x1f>

008001aa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ba:	00 00 00 
	b.cnt = 0;
  8001bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ca:	ff 75 08             	pushl  0x8(%ebp)
  8001cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d3:	50                   	push   %eax
  8001d4:	68 67 01 80 00       	push   $0x800167
  8001d9:	e8 17 01 00 00       	call   8002f5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001de:	83 c4 08             	add    $0x8,%esp
  8001e1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ed:	50                   	push   %eax
  8001ee:	e8 28 09 00 00       	call   800b1b <sys_cputs>

	return b.cnt;
}
  8001f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f9:	c9                   	leave  
  8001fa:	c3                   	ret    

008001fb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800201:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800204:	50                   	push   %eax
  800205:	ff 75 08             	pushl  0x8(%ebp)
  800208:	e8 9d ff ff ff       	call   8001aa <vcprintf>
	va_end(ap);

	return cnt;
}
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	57                   	push   %edi
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
  800215:	83 ec 1c             	sub    $0x1c,%esp
  800218:	89 c7                	mov    %eax,%edi
  80021a:	89 d6                	mov    %edx,%esi
  80021c:	8b 45 08             	mov    0x8(%ebp),%eax
  80021f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800222:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800225:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800228:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80022b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800230:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800233:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800236:	39 d3                	cmp    %edx,%ebx
  800238:	72 05                	jb     80023f <printnum+0x30>
  80023a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80023d:	77 78                	ja     8002b7 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	ff 75 18             	pushl  0x18(%ebp)
  800245:	8b 45 14             	mov    0x14(%ebp),%eax
  800248:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80024b:	53                   	push   %ebx
  80024c:	ff 75 10             	pushl  0x10(%ebp)
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 e0             	pushl  -0x20(%ebp)
  800258:	ff 75 dc             	pushl  -0x24(%ebp)
  80025b:	ff 75 d8             	pushl  -0x28(%ebp)
  80025e:	e8 f1 1d 00 00       	call   802054 <__udivdi3>
  800263:	83 c4 18             	add    $0x18,%esp
  800266:	52                   	push   %edx
  800267:	50                   	push   %eax
  800268:	89 f2                	mov    %esi,%edx
  80026a:	89 f8                	mov    %edi,%eax
  80026c:	e8 9e ff ff ff       	call   80020f <printnum>
  800271:	83 c4 20             	add    $0x20,%esp
  800274:	eb 11                	jmp    800287 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	56                   	push   %esi
  80027a:	ff 75 18             	pushl  0x18(%ebp)
  80027d:	ff d7                	call   *%edi
  80027f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800282:	4b                   	dec    %ebx
  800283:	85 db                	test   %ebx,%ebx
  800285:	7f ef                	jg     800276 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	56                   	push   %esi
  80028b:	83 ec 04             	sub    $0x4,%esp
  80028e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800291:	ff 75 e0             	pushl  -0x20(%ebp)
  800294:	ff 75 dc             	pushl  -0x24(%ebp)
  800297:	ff 75 d8             	pushl  -0x28(%ebp)
  80029a:	e8 c5 1e 00 00       	call   802164 <__umoddi3>
  80029f:	83 c4 14             	add    $0x14,%esp
  8002a2:	0f be 80 00 23 80 00 	movsbl 0x802300(%eax),%eax
  8002a9:	50                   	push   %eax
  8002aa:	ff d7                	call   *%edi
}
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b2:	5b                   	pop    %ebx
  8002b3:	5e                   	pop    %esi
  8002b4:	5f                   	pop    %edi
  8002b5:	5d                   	pop    %ebp
  8002b6:	c3                   	ret    
  8002b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ba:	eb c6                	jmp    800282 <printnum+0x73>

008002bc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c2:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ca:	73 0a                	jae    8002d6 <sprintputch+0x1a>
		*b->buf++ = ch;
  8002cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cf:	89 08                	mov    %ecx,(%eax)
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	88 02                	mov    %al,(%edx)
}
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    

008002d8 <printfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002de:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e1:	50                   	push   %eax
  8002e2:	ff 75 10             	pushl  0x10(%ebp)
  8002e5:	ff 75 0c             	pushl  0xc(%ebp)
  8002e8:	ff 75 08             	pushl  0x8(%ebp)
  8002eb:	e8 05 00 00 00       	call   8002f5 <vprintfmt>
}
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <vprintfmt>:
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 2c             	sub    $0x2c,%esp
  8002fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800301:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800304:	8b 7d 10             	mov    0x10(%ebp),%edi
  800307:	e9 ae 03 00 00       	jmp    8006ba <vprintfmt+0x3c5>
  80030c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800310:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800317:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80031e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800325:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8d 47 01             	lea    0x1(%edi),%eax
  80032d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800330:	8a 17                	mov    (%edi),%dl
  800332:	8d 42 dd             	lea    -0x23(%edx),%eax
  800335:	3c 55                	cmp    $0x55,%al
  800337:	0f 87 fe 03 00 00    	ja     80073b <vprintfmt+0x446>
  80033d:	0f b6 c0             	movzbl %al,%eax
  800340:	ff 24 85 40 24 80 00 	jmp    *0x802440(,%eax,4)
  800347:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80034a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80034e:	eb da                	jmp    80032a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800353:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800357:	eb d1                	jmp    80032a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800359:	0f b6 d2             	movzbl %dl,%edx
  80035c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800367:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800370:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800373:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800376:	83 f9 09             	cmp    $0x9,%ecx
  800379:	77 52                	ja     8003cd <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80037b:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80037c:	eb e9                	jmp    800367 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  80037e:	8b 45 14             	mov    0x14(%ebp),%eax
  800381:	8b 00                	mov    (%eax),%eax
  800383:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8d 40 04             	lea    0x4(%eax),%eax
  80038c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800392:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800396:	79 92                	jns    80032a <vprintfmt+0x35>
				width = precision, precision = -1;
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003a5:	eb 83                	jmp    80032a <vprintfmt+0x35>
  8003a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ab:	78 08                	js     8003b5 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b0:	e9 75 ff ff ff       	jmp    80032a <vprintfmt+0x35>
  8003b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003bc:	eb ef                	jmp    8003ad <vprintfmt+0xb8>
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003c8:	e9 5d ff ff ff       	jmp    80032a <vprintfmt+0x35>
  8003cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003d3:	eb bd                	jmp    800392 <vprintfmt+0x9d>
			lflag++;
  8003d5:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d9:	e9 4c ff ff ff       	jmp    80032a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003de:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e1:	8d 78 04             	lea    0x4(%eax),%edi
  8003e4:	83 ec 08             	sub    $0x8,%esp
  8003e7:	53                   	push   %ebx
  8003e8:	ff 30                	pushl  (%eax)
  8003ea:	ff d6                	call   *%esi
			break;
  8003ec:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003ef:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f2:	e9 c0 02 00 00       	jmp    8006b7 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8003f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fa:	8d 78 04             	lea    0x4(%eax),%edi
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	85 c0                	test   %eax,%eax
  800401:	78 2a                	js     80042d <vprintfmt+0x138>
  800403:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800405:	83 f8 0f             	cmp    $0xf,%eax
  800408:	7f 27                	jg     800431 <vprintfmt+0x13c>
  80040a:	8b 04 85 a0 25 80 00 	mov    0x8025a0(,%eax,4),%eax
  800411:	85 c0                	test   %eax,%eax
  800413:	74 1c                	je     800431 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800415:	50                   	push   %eax
  800416:	68 c8 26 80 00       	push   $0x8026c8
  80041b:	53                   	push   %ebx
  80041c:	56                   	push   %esi
  80041d:	e8 b6 fe ff ff       	call   8002d8 <printfmt>
  800422:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800425:	89 7d 14             	mov    %edi,0x14(%ebp)
  800428:	e9 8a 02 00 00       	jmp    8006b7 <vprintfmt+0x3c2>
  80042d:	f7 d8                	neg    %eax
  80042f:	eb d2                	jmp    800403 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800431:	52                   	push   %edx
  800432:	68 18 23 80 00       	push   $0x802318
  800437:	53                   	push   %ebx
  800438:	56                   	push   %esi
  800439:	e8 9a fe ff ff       	call   8002d8 <printfmt>
  80043e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800441:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800444:	e9 6e 02 00 00       	jmp    8006b7 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	83 c0 04             	add    $0x4,%eax
  80044f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800452:	8b 45 14             	mov    0x14(%ebp),%eax
  800455:	8b 38                	mov    (%eax),%edi
  800457:	85 ff                	test   %edi,%edi
  800459:	74 39                	je     800494 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80045b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045f:	0f 8e a9 00 00 00    	jle    80050e <vprintfmt+0x219>
  800465:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800469:	0f 84 a7 00 00 00    	je     800516 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	ff 75 d0             	pushl  -0x30(%ebp)
  800475:	57                   	push   %edi
  800476:	e8 6b 03 00 00       	call   8007e6 <strnlen>
  80047b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047e:	29 c1                	sub    %eax,%ecx
  800480:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800483:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800486:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80048a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800490:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800492:	eb 14                	jmp    8004a8 <vprintfmt+0x1b3>
				p = "(null)";
  800494:	bf 11 23 80 00       	mov    $0x802311,%edi
  800499:	eb c0                	jmp    80045b <vprintfmt+0x166>
					putch(padc, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	53                   	push   %ebx
  80049f:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a4:	4f                   	dec    %edi
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	85 ff                	test   %edi,%edi
  8004aa:	7f ef                	jg     80049b <vprintfmt+0x1a6>
  8004ac:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004af:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b2:	89 c8                	mov    %ecx,%eax
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	78 10                	js     8004c8 <vprintfmt+0x1d3>
  8004b8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004bb:	29 c1                	sub    %eax,%ecx
  8004bd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004c0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c6:	eb 15                	jmp    8004dd <vprintfmt+0x1e8>
  8004c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cd:	eb e9                	jmp    8004b8 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	52                   	push   %edx
  8004d4:	ff 55 08             	call   *0x8(%ebp)
  8004d7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004da:	ff 4d e0             	decl   -0x20(%ebp)
  8004dd:	47                   	inc    %edi
  8004de:	8a 47 ff             	mov    -0x1(%edi),%al
  8004e1:	0f be d0             	movsbl %al,%edx
  8004e4:	85 d2                	test   %edx,%edx
  8004e6:	74 59                	je     800541 <vprintfmt+0x24c>
  8004e8:	85 f6                	test   %esi,%esi
  8004ea:	78 03                	js     8004ef <vprintfmt+0x1fa>
  8004ec:	4e                   	dec    %esi
  8004ed:	78 2f                	js     80051e <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ef:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f3:	74 da                	je     8004cf <vprintfmt+0x1da>
  8004f5:	0f be c0             	movsbl %al,%eax
  8004f8:	83 e8 20             	sub    $0x20,%eax
  8004fb:	83 f8 5e             	cmp    $0x5e,%eax
  8004fe:	76 cf                	jbe    8004cf <vprintfmt+0x1da>
					putch('?', putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	6a 3f                	push   $0x3f
  800506:	ff 55 08             	call   *0x8(%ebp)
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	eb cc                	jmp    8004da <vprintfmt+0x1e5>
  80050e:	89 75 08             	mov    %esi,0x8(%ebp)
  800511:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800514:	eb c7                	jmp    8004dd <vprintfmt+0x1e8>
  800516:	89 75 08             	mov    %esi,0x8(%ebp)
  800519:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80051c:	eb bf                	jmp    8004dd <vprintfmt+0x1e8>
  80051e:	8b 75 08             	mov    0x8(%ebp),%esi
  800521:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800524:	eb 0c                	jmp    800532 <vprintfmt+0x23d>
				putch(' ', putdat);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	53                   	push   %ebx
  80052a:	6a 20                	push   $0x20
  80052c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80052e:	4f                   	dec    %edi
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	85 ff                	test   %edi,%edi
  800534:	7f f0                	jg     800526 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	89 45 14             	mov    %eax,0x14(%ebp)
  80053c:	e9 76 01 00 00       	jmp    8006b7 <vprintfmt+0x3c2>
  800541:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800544:	8b 75 08             	mov    0x8(%ebp),%esi
  800547:	eb e9                	jmp    800532 <vprintfmt+0x23d>
	if (lflag >= 2)
  800549:	83 f9 01             	cmp    $0x1,%ecx
  80054c:	7f 1f                	jg     80056d <vprintfmt+0x278>
	else if (lflag)
  80054e:	85 c9                	test   %ecx,%ecx
  800550:	75 48                	jne    80059a <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055a:	89 c1                	mov    %eax,%ecx
  80055c:	c1 f9 1f             	sar    $0x1f,%ecx
  80055f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8d 40 04             	lea    0x4(%eax),%eax
  800568:	89 45 14             	mov    %eax,0x14(%ebp)
  80056b:	eb 17                	jmp    800584 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 50 04             	mov    0x4(%eax),%edx
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8d 40 08             	lea    0x8(%eax),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800584:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800587:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80058a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80058e:	78 25                	js     8005b5 <vprintfmt+0x2c0>
			base = 10;
  800590:	b8 0a 00 00 00       	mov    $0xa,%eax
  800595:	e9 03 01 00 00       	jmp    80069d <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	89 c1                	mov    %eax,%ecx
  8005a4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 04             	lea    0x4(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b3:	eb cf                	jmp    800584 <vprintfmt+0x28f>
				putch('-', putdat);
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	53                   	push   %ebx
  8005b9:	6a 2d                	push   $0x2d
  8005bb:	ff d6                	call   *%esi
				num = -(long long) num;
  8005bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c3:	f7 da                	neg    %edx
  8005c5:	83 d1 00             	adc    $0x0,%ecx
  8005c8:	f7 d9                	neg    %ecx
  8005ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d2:	e9 c6 00 00 00       	jmp    80069d <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005d7:	83 f9 01             	cmp    $0x1,%ecx
  8005da:	7f 1e                	jg     8005fa <vprintfmt+0x305>
	else if (lflag)
  8005dc:	85 c9                	test   %ecx,%ecx
  8005de:	75 32                	jne    800612 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ea:	8d 40 04             	lea    0x4(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f5:	e9 a3 00 00 00       	jmp    80069d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 10                	mov    (%eax),%edx
  8005ff:	8b 48 04             	mov    0x4(%eax),%ecx
  800602:	8d 40 08             	lea    0x8(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800608:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060d:	e9 8b 00 00 00       	jmp    80069d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061c:	8d 40 04             	lea    0x4(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800622:	b8 0a 00 00 00       	mov    $0xa,%eax
  800627:	eb 74                	jmp    80069d <vprintfmt+0x3a8>
	if (lflag >= 2)
  800629:	83 f9 01             	cmp    $0x1,%ecx
  80062c:	7f 1b                	jg     800649 <vprintfmt+0x354>
	else if (lflag)
  80062e:	85 c9                	test   %ecx,%ecx
  800630:	75 2c                	jne    80065e <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 10                	mov    (%eax),%edx
  800637:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800642:	b8 08 00 00 00       	mov    $0x8,%eax
  800647:	eb 54                	jmp    80069d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 10                	mov    (%eax),%edx
  80064e:	8b 48 04             	mov    0x4(%eax),%ecx
  800651:	8d 40 08             	lea    0x8(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800657:	b8 08 00 00 00       	mov    $0x8,%eax
  80065c:	eb 3f                	jmp    80069d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 10                	mov    (%eax),%edx
  800663:	b9 00 00 00 00       	mov    $0x0,%ecx
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066e:	b8 08 00 00 00       	mov    $0x8,%eax
  800673:	eb 28                	jmp    80069d <vprintfmt+0x3a8>
			putch('0', putdat);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	53                   	push   %ebx
  800679:	6a 30                	push   $0x30
  80067b:	ff d6                	call   *%esi
			putch('x', putdat);
  80067d:	83 c4 08             	add    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 78                	push   $0x78
  800683:	ff d6                	call   *%esi
			num = (unsigned long long)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 10                	mov    (%eax),%edx
  80068a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80068f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800692:	8d 40 04             	lea    0x4(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800698:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069d:	83 ec 0c             	sub    $0xc,%esp
  8006a0:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006a4:	57                   	push   %edi
  8006a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a8:	50                   	push   %eax
  8006a9:	51                   	push   %ecx
  8006aa:	52                   	push   %edx
  8006ab:	89 da                	mov    %ebx,%edx
  8006ad:	89 f0                	mov    %esi,%eax
  8006af:	e8 5b fb ff ff       	call   80020f <printnum>
			break;
  8006b4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ba:	47                   	inc    %edi
  8006bb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bf:	83 f8 25             	cmp    $0x25,%eax
  8006c2:	0f 84 44 fc ff ff    	je     80030c <vprintfmt+0x17>
			if (ch == '\0')
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	0f 84 89 00 00 00    	je     800759 <vprintfmt+0x464>
			putch(ch, putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	53                   	push   %ebx
  8006d4:	50                   	push   %eax
  8006d5:	ff d6                	call   *%esi
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	eb de                	jmp    8006ba <vprintfmt+0x3c5>
	if (lflag >= 2)
  8006dc:	83 f9 01             	cmp    $0x1,%ecx
  8006df:	7f 1b                	jg     8006fc <vprintfmt+0x407>
	else if (lflag)
  8006e1:	85 c9                	test   %ecx,%ecx
  8006e3:	75 2c                	jne    800711 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 10                	mov    (%eax),%edx
  8006ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fa:	eb a1                	jmp    80069d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
  80070f:	eb 8c                	jmp    80069d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800721:	b8 10 00 00 00       	mov    $0x10,%eax
  800726:	e9 72 ff ff ff       	jmp    80069d <vprintfmt+0x3a8>
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 25                	push   $0x25
  800731:	ff d6                	call   *%esi
			break;
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	e9 7c ff ff ff       	jmp    8006b7 <vprintfmt+0x3c2>
			putch('%', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 25                	push   $0x25
  800741:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 f8                	mov    %edi,%eax
  800748:	eb 01                	jmp    80074b <vprintfmt+0x456>
  80074a:	48                   	dec    %eax
  80074b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074f:	75 f9                	jne    80074a <vprintfmt+0x455>
  800751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800754:	e9 5e ff ff ff       	jmp    8006b7 <vprintfmt+0x3c2>
}
  800759:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075c:	5b                   	pop    %ebx
  80075d:	5e                   	pop    %esi
  80075e:	5f                   	pop    %edi
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800770:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800774:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077e:	85 c0                	test   %eax,%eax
  800780:	74 26                	je     8007a8 <vsnprintf+0x47>
  800782:	85 d2                	test   %edx,%edx
  800784:	7e 29                	jle    8007af <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800786:	ff 75 14             	pushl  0x14(%ebp)
  800789:	ff 75 10             	pushl  0x10(%ebp)
  80078c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80078f:	50                   	push   %eax
  800790:	68 bc 02 80 00       	push   $0x8002bc
  800795:	e8 5b fb ff ff       	call   8002f5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a3:	83 c4 10             	add    $0x10,%esp
}
  8007a6:	c9                   	leave  
  8007a7:	c3                   	ret    
		return -E_INVAL;
  8007a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ad:	eb f7                	jmp    8007a6 <vsnprintf+0x45>
  8007af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b4:	eb f0                	jmp    8007a6 <vsnprintf+0x45>

008007b6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007bf:	50                   	push   %eax
  8007c0:	ff 75 10             	pushl  0x10(%ebp)
  8007c3:	ff 75 0c             	pushl  0xc(%ebp)
  8007c6:	ff 75 08             	pushl  0x8(%ebp)
  8007c9:	e8 93 ff ff ff       	call   800761 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007db:	eb 01                	jmp    8007de <strlen+0xe>
		n++;
  8007dd:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8007de:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e2:	75 f9                	jne    8007dd <strlen+0xd>
	return n;
}
  8007e4:	5d                   	pop    %ebp
  8007e5:	c3                   	ret    

008007e6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f4:	eb 01                	jmp    8007f7 <strnlen+0x11>
		n++;
  8007f6:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f7:	39 d0                	cmp    %edx,%eax
  8007f9:	74 06                	je     800801 <strnlen+0x1b>
  8007fb:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007ff:	75 f5                	jne    8007f6 <strnlen+0x10>
	return n;
}
  800801:	5d                   	pop    %ebp
  800802:	c3                   	ret    

00800803 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080d:	89 c2                	mov    %eax,%edx
  80080f:	42                   	inc    %edx
  800810:	41                   	inc    %ecx
  800811:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800814:	88 5a ff             	mov    %bl,-0x1(%edx)
  800817:	84 db                	test   %bl,%bl
  800819:	75 f4                	jne    80080f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80081b:	5b                   	pop    %ebx
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	53                   	push   %ebx
  800822:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800825:	53                   	push   %ebx
  800826:	e8 a5 ff ff ff       	call   8007d0 <strlen>
  80082b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	01 d8                	add    %ebx,%eax
  800833:	50                   	push   %eax
  800834:	e8 ca ff ff ff       	call   800803 <strcpy>
	return dst;
}
  800839:	89 d8                	mov    %ebx,%eax
  80083b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80083e:	c9                   	leave  
  80083f:	c3                   	ret    

00800840 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	56                   	push   %esi
  800844:	53                   	push   %ebx
  800845:	8b 75 08             	mov    0x8(%ebp),%esi
  800848:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084b:	89 f3                	mov    %esi,%ebx
  80084d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800850:	89 f2                	mov    %esi,%edx
  800852:	eb 0c                	jmp    800860 <strncpy+0x20>
		*dst++ = *src;
  800854:	42                   	inc    %edx
  800855:	8a 01                	mov    (%ecx),%al
  800857:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80085a:	80 39 01             	cmpb   $0x1,(%ecx)
  80085d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800860:	39 da                	cmp    %ebx,%edx
  800862:	75 f0                	jne    800854 <strncpy+0x14>
	}
	return ret;
}
  800864:	89 f0                	mov    %esi,%eax
  800866:	5b                   	pop    %ebx
  800867:	5e                   	pop    %esi
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	56                   	push   %esi
  80086e:	53                   	push   %ebx
  80086f:	8b 75 08             	mov    0x8(%ebp),%esi
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
  800875:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800878:	85 c0                	test   %eax,%eax
  80087a:	74 20                	je     80089c <strlcpy+0x32>
  80087c:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800880:	89 f0                	mov    %esi,%eax
  800882:	eb 05                	jmp    800889 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800884:	40                   	inc    %eax
  800885:	42                   	inc    %edx
  800886:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800889:	39 d8                	cmp    %ebx,%eax
  80088b:	74 06                	je     800893 <strlcpy+0x29>
  80088d:	8a 0a                	mov    (%edx),%cl
  80088f:	84 c9                	test   %cl,%cl
  800891:	75 f1                	jne    800884 <strlcpy+0x1a>
		*dst = '\0';
  800893:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800896:	29 f0                	sub    %esi,%eax
}
  800898:	5b                   	pop    %ebx
  800899:	5e                   	pop    %esi
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	eb f6                	jmp    800896 <strlcpy+0x2c>

008008a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008a9:	eb 02                	jmp    8008ad <strcmp+0xd>
		p++, q++;
  8008ab:	41                   	inc    %ecx
  8008ac:	42                   	inc    %edx
	while (*p && *p == *q)
  8008ad:	8a 01                	mov    (%ecx),%al
  8008af:	84 c0                	test   %al,%al
  8008b1:	74 04                	je     8008b7 <strcmp+0x17>
  8008b3:	3a 02                	cmp    (%edx),%al
  8008b5:	74 f4                	je     8008ab <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b7:	0f b6 c0             	movzbl %al,%eax
  8008ba:	0f b6 12             	movzbl (%edx),%edx
  8008bd:	29 d0                	sub    %edx,%eax
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	53                   	push   %ebx
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cb:	89 c3                	mov    %eax,%ebx
  8008cd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008d0:	eb 02                	jmp    8008d4 <strncmp+0x13>
		n--, p++, q++;
  8008d2:	40                   	inc    %eax
  8008d3:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8008d4:	39 d8                	cmp    %ebx,%eax
  8008d6:	74 15                	je     8008ed <strncmp+0x2c>
  8008d8:	8a 08                	mov    (%eax),%cl
  8008da:	84 c9                	test   %cl,%cl
  8008dc:	74 04                	je     8008e2 <strncmp+0x21>
  8008de:	3a 0a                	cmp    (%edx),%cl
  8008e0:	74 f0                	je     8008d2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e2:	0f b6 00             	movzbl (%eax),%eax
  8008e5:	0f b6 12             	movzbl (%edx),%edx
  8008e8:	29 d0                	sub    %edx,%eax
}
  8008ea:	5b                   	pop    %ebx
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    
		return 0;
  8008ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f2:	eb f6                	jmp    8008ea <strncmp+0x29>

008008f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008fd:	8a 10                	mov    (%eax),%dl
  8008ff:	84 d2                	test   %dl,%dl
  800901:	74 07                	je     80090a <strchr+0x16>
		if (*s == c)
  800903:	38 ca                	cmp    %cl,%dl
  800905:	74 08                	je     80090f <strchr+0x1b>
	for (; *s; s++)
  800907:	40                   	inc    %eax
  800908:	eb f3                	jmp    8008fd <strchr+0x9>
			return (char *) s;
	return 0;
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80091a:	8a 10                	mov    (%eax),%dl
  80091c:	84 d2                	test   %dl,%dl
  80091e:	74 07                	je     800927 <strfind+0x16>
		if (*s == c)
  800920:	38 ca                	cmp    %cl,%dl
  800922:	74 03                	je     800927 <strfind+0x16>
	for (; *s; s++)
  800924:	40                   	inc    %eax
  800925:	eb f3                	jmp    80091a <strfind+0x9>
			break;
	return (char *) s;
}
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	57                   	push   %edi
  80092d:	56                   	push   %esi
  80092e:	53                   	push   %ebx
  80092f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800932:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800935:	85 c9                	test   %ecx,%ecx
  800937:	74 13                	je     80094c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800939:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80093f:	75 05                	jne    800946 <memset+0x1d>
  800941:	f6 c1 03             	test   $0x3,%cl
  800944:	74 0d                	je     800953 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
  800949:	fc                   	cld    
  80094a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80094c:	89 f8                	mov    %edi,%eax
  80094e:	5b                   	pop    %ebx
  80094f:	5e                   	pop    %esi
  800950:	5f                   	pop    %edi
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    
		c &= 0xFF;
  800953:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800957:	89 d3                	mov    %edx,%ebx
  800959:	c1 e3 08             	shl    $0x8,%ebx
  80095c:	89 d0                	mov    %edx,%eax
  80095e:	c1 e0 18             	shl    $0x18,%eax
  800961:	89 d6                	mov    %edx,%esi
  800963:	c1 e6 10             	shl    $0x10,%esi
  800966:	09 f0                	or     %esi,%eax
  800968:	09 c2                	or     %eax,%edx
  80096a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80096c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80096f:	89 d0                	mov    %edx,%eax
  800971:	fc                   	cld    
  800972:	f3 ab                	rep stos %eax,%es:(%edi)
  800974:	eb d6                	jmp    80094c <memset+0x23>

00800976 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	57                   	push   %edi
  80097a:	56                   	push   %esi
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800981:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800984:	39 c6                	cmp    %eax,%esi
  800986:	73 33                	jae    8009bb <memmove+0x45>
  800988:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80098b:	39 d0                	cmp    %edx,%eax
  80098d:	73 2c                	jae    8009bb <memmove+0x45>
		s += n;
		d += n;
  80098f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800992:	89 d6                	mov    %edx,%esi
  800994:	09 fe                	or     %edi,%esi
  800996:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80099c:	75 13                	jne    8009b1 <memmove+0x3b>
  80099e:	f6 c1 03             	test   $0x3,%cl
  8009a1:	75 0e                	jne    8009b1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a3:	83 ef 04             	sub    $0x4,%edi
  8009a6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ac:	fd                   	std    
  8009ad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009af:	eb 07                	jmp    8009b8 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009b1:	4f                   	dec    %edi
  8009b2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b8:	fc                   	cld    
  8009b9:	eb 13                	jmp    8009ce <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bb:	89 f2                	mov    %esi,%edx
  8009bd:	09 c2                	or     %eax,%edx
  8009bf:	f6 c2 03             	test   $0x3,%dl
  8009c2:	75 05                	jne    8009c9 <memmove+0x53>
  8009c4:	f6 c1 03             	test   $0x3,%cl
  8009c7:	74 09                	je     8009d2 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009c9:	89 c7                	mov    %eax,%edi
  8009cb:	fc                   	cld    
  8009cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009ce:	5e                   	pop    %esi
  8009cf:	5f                   	pop    %edi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d5:	89 c7                	mov    %eax,%edi
  8009d7:	fc                   	cld    
  8009d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009da:	eb f2                	jmp    8009ce <memmove+0x58>

008009dc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009df:	ff 75 10             	pushl  0x10(%ebp)
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 89 ff ff ff       	call   800976 <memmove>
}
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	56                   	push   %esi
  8009f3:	53                   	push   %ebx
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	89 c6                	mov    %eax,%esi
  8009f9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  8009fc:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  8009ff:	39 f0                	cmp    %esi,%eax
  800a01:	74 16                	je     800a19 <memcmp+0x2a>
		if (*s1 != *s2)
  800a03:	8a 08                	mov    (%eax),%cl
  800a05:	8a 1a                	mov    (%edx),%bl
  800a07:	38 d9                	cmp    %bl,%cl
  800a09:	75 04                	jne    800a0f <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a0b:	40                   	inc    %eax
  800a0c:	42                   	inc    %edx
  800a0d:	eb f0                	jmp    8009ff <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a0f:	0f b6 c1             	movzbl %cl,%eax
  800a12:	0f b6 db             	movzbl %bl,%ebx
  800a15:	29 d8                	sub    %ebx,%eax
  800a17:	eb 05                	jmp    800a1e <memcmp+0x2f>
	}

	return 0;
  800a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1e:	5b                   	pop    %ebx
  800a1f:	5e                   	pop    %esi
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2b:	89 c2                	mov    %eax,%edx
  800a2d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a30:	39 d0                	cmp    %edx,%eax
  800a32:	73 07                	jae    800a3b <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a34:	38 08                	cmp    %cl,(%eax)
  800a36:	74 03                	je     800a3b <memfind+0x19>
	for (; s < ends; s++)
  800a38:	40                   	inc    %eax
  800a39:	eb f5                	jmp    800a30 <memfind+0xe>
			break;
	return (void *) s;
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	57                   	push   %edi
  800a41:	56                   	push   %esi
  800a42:	53                   	push   %ebx
  800a43:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a46:	eb 01                	jmp    800a49 <strtol+0xc>
		s++;
  800a48:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a49:	8a 01                	mov    (%ecx),%al
  800a4b:	3c 20                	cmp    $0x20,%al
  800a4d:	74 f9                	je     800a48 <strtol+0xb>
  800a4f:	3c 09                	cmp    $0x9,%al
  800a51:	74 f5                	je     800a48 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a53:	3c 2b                	cmp    $0x2b,%al
  800a55:	74 2b                	je     800a82 <strtol+0x45>
		s++;
	else if (*s == '-')
  800a57:	3c 2d                	cmp    $0x2d,%al
  800a59:	74 2f                	je     800a8a <strtol+0x4d>
	int neg = 0;
  800a5b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a60:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a67:	75 12                	jne    800a7b <strtol+0x3e>
  800a69:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6c:	74 24                	je     800a92 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a72:	75 07                	jne    800a7b <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a74:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a80:	eb 4e                	jmp    800ad0 <strtol+0x93>
		s++;
  800a82:	41                   	inc    %ecx
	int neg = 0;
  800a83:	bf 00 00 00 00       	mov    $0x0,%edi
  800a88:	eb d6                	jmp    800a60 <strtol+0x23>
		s++, neg = 1;
  800a8a:	41                   	inc    %ecx
  800a8b:	bf 01 00 00 00       	mov    $0x1,%edi
  800a90:	eb ce                	jmp    800a60 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a92:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a96:	74 10                	je     800aa8 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9c:	75 dd                	jne    800a7b <strtol+0x3e>
		s++, base = 8;
  800a9e:	41                   	inc    %ecx
  800a9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800aa6:	eb d3                	jmp    800a7b <strtol+0x3e>
		s += 2, base = 16;
  800aa8:	83 c1 02             	add    $0x2,%ecx
  800aab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ab2:	eb c7                	jmp    800a7b <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ab4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ab7:	89 f3                	mov    %esi,%ebx
  800ab9:	80 fb 19             	cmp    $0x19,%bl
  800abc:	77 24                	ja     800ae2 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800abe:	0f be d2             	movsbl %dl,%edx
  800ac1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac7:	7d 2b                	jge    800af4 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800ac9:	41                   	inc    %ecx
  800aca:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ace:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad0:	8a 11                	mov    (%ecx),%dl
  800ad2:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800ad5:	80 fb 09             	cmp    $0x9,%bl
  800ad8:	77 da                	ja     800ab4 <strtol+0x77>
			dig = *s - '0';
  800ada:	0f be d2             	movsbl %dl,%edx
  800add:	83 ea 30             	sub    $0x30,%edx
  800ae0:	eb e2                	jmp    800ac4 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800ae2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae5:	89 f3                	mov    %esi,%ebx
  800ae7:	80 fb 19             	cmp    $0x19,%bl
  800aea:	77 08                	ja     800af4 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800aec:	0f be d2             	movsbl %dl,%edx
  800aef:	83 ea 37             	sub    $0x37,%edx
  800af2:	eb d0                	jmp    800ac4 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af8:	74 05                	je     800aff <strtol+0xc2>
		*endptr = (char *) s;
  800afa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aff:	85 ff                	test   %edi,%edi
  800b01:	74 02                	je     800b05 <strtol+0xc8>
  800b03:	f7 d8                	neg    %eax
}
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5f                   	pop    %edi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <atoi>:

int
atoi(const char *s)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b0d:	6a 0a                	push   $0xa
  800b0f:	6a 00                	push   $0x0
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 24 ff ff ff       	call   800a3d <strtol>
}
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	57                   	push   %edi
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
  800b26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b29:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2c:	89 c3                	mov    %eax,%ebx
  800b2e:	89 c7                	mov    %eax,%edi
  800b30:	89 c6                	mov    %eax,%esi
  800b32:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	57                   	push   %edi
  800b3d:	56                   	push   %esi
  800b3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b44:	b8 01 00 00 00       	mov    $0x1,%eax
  800b49:	89 d1                	mov    %edx,%ecx
  800b4b:	89 d3                	mov    %edx,%ebx
  800b4d:	89 d7                	mov    %edx,%edi
  800b4f:	89 d6                	mov    %edx,%esi
  800b51:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5f                   	pop    %edi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b66:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6e:	89 cb                	mov    %ecx,%ebx
  800b70:	89 cf                	mov    %ecx,%edi
  800b72:	89 ce                	mov    %ecx,%esi
  800b74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b76:	85 c0                	test   %eax,%eax
  800b78:	7f 08                	jg     800b82 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7d:	5b                   	pop    %ebx
  800b7e:	5e                   	pop    %esi
  800b7f:	5f                   	pop    %edi
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b82:	83 ec 0c             	sub    $0xc,%esp
  800b85:	50                   	push   %eax
  800b86:	6a 03                	push   $0x3
  800b88:	68 ff 25 80 00       	push   $0x8025ff
  800b8d:	6a 23                	push   $0x23
  800b8f:	68 1c 26 80 00       	push   $0x80261c
  800b94:	e8 8b 13 00 00       	call   801f24 <_panic>

00800b99 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	57                   	push   %edi
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba4:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba9:	89 d1                	mov    %edx,%ecx
  800bab:	89 d3                	mov    %edx,%ebx
  800bad:	89 d7                	mov    %edx,%edi
  800baf:	89 d6                	mov    %edx,%esi
  800bb1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
  800bbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc1:	be 00 00 00 00       	mov    $0x0,%esi
  800bc6:	b8 04 00 00 00       	mov    $0x4,%eax
  800bcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bce:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd4:	89 f7                	mov    %esi,%edi
  800bd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd8:	85 c0                	test   %eax,%eax
  800bda:	7f 08                	jg     800be4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	50                   	push   %eax
  800be8:	6a 04                	push   $0x4
  800bea:	68 ff 25 80 00       	push   $0x8025ff
  800bef:	6a 23                	push   $0x23
  800bf1:	68 1c 26 80 00       	push   $0x80261c
  800bf6:	e8 29 13 00 00       	call   801f24 <_panic>

00800bfb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c04:	b8 05 00 00 00       	mov    $0x5,%eax
  800c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c12:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c15:	8b 75 18             	mov    0x18(%ebp),%esi
  800c18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	7f 08                	jg     800c26 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	50                   	push   %eax
  800c2a:	6a 05                	push   $0x5
  800c2c:	68 ff 25 80 00       	push   $0x8025ff
  800c31:	6a 23                	push   $0x23
  800c33:	68 1c 26 80 00       	push   $0x80261c
  800c38:	e8 e7 12 00 00       	call   801f24 <_panic>

00800c3d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	57                   	push   %edi
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
  800c43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4b:	b8 06 00 00 00       	mov    $0x6,%eax
  800c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c53:	8b 55 08             	mov    0x8(%ebp),%edx
  800c56:	89 df                	mov    %ebx,%edi
  800c58:	89 de                	mov    %ebx,%esi
  800c5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	7f 08                	jg     800c68 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c68:	83 ec 0c             	sub    $0xc,%esp
  800c6b:	50                   	push   %eax
  800c6c:	6a 06                	push   $0x6
  800c6e:	68 ff 25 80 00       	push   $0x8025ff
  800c73:	6a 23                	push   $0x23
  800c75:	68 1c 26 80 00       	push   $0x80261c
  800c7a:	e8 a5 12 00 00       	call   801f24 <_panic>

00800c7f <sys_yield>:

void
sys_yield(void)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c85:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8f:	89 d1                	mov    %edx,%ecx
  800c91:	89 d3                	mov    %edx,%ebx
  800c93:	89 d7                	mov    %edx,%edi
  800c95:	89 d6                	mov    %edx,%esi
  800c97:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
  800ca4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cac:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	89 df                	mov    %ebx,%edi
  800cb9:	89 de                	mov    %ebx,%esi
  800cbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	7f 08                	jg     800cc9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	50                   	push   %eax
  800ccd:	6a 08                	push   $0x8
  800ccf:	68 ff 25 80 00       	push   $0x8025ff
  800cd4:	6a 23                	push   $0x23
  800cd6:	68 1c 26 80 00       	push   $0x80261c
  800cdb:	e8 44 12 00 00       	call   801f24 <_panic>

00800ce0 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
  800ce6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cee:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	89 cb                	mov    %ecx,%ebx
  800cf8:	89 cf                	mov    %ecx,%edi
  800cfa:	89 ce                	mov    %ecx,%esi
  800cfc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfe:	85 c0                	test   %eax,%eax
  800d00:	7f 08                	jg     800d0a <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5f                   	pop    %edi
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	50                   	push   %eax
  800d0e:	6a 0c                	push   $0xc
  800d10:	68 ff 25 80 00       	push   $0x8025ff
  800d15:	6a 23                	push   $0x23
  800d17:	68 1c 26 80 00       	push   $0x80261c
  800d1c:	e8 03 12 00 00       	call   801f24 <_panic>

00800d21 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	57                   	push   %edi
  800d25:	56                   	push   %esi
  800d26:	53                   	push   %ebx
  800d27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2f:	b8 09 00 00 00       	mov    $0x9,%eax
  800d34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	89 df                	mov    %ebx,%edi
  800d3c:	89 de                	mov    %ebx,%esi
  800d3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	7f 08                	jg     800d4c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4c:	83 ec 0c             	sub    $0xc,%esp
  800d4f:	50                   	push   %eax
  800d50:	6a 09                	push   $0x9
  800d52:	68 ff 25 80 00       	push   $0x8025ff
  800d57:	6a 23                	push   $0x23
  800d59:	68 1c 26 80 00       	push   $0x80261c
  800d5e:	e8 c1 11 00 00       	call   801f24 <_panic>

00800d63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	89 df                	mov    %ebx,%edi
  800d7e:	89 de                	mov    %ebx,%esi
  800d80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d82:	85 c0                	test   %eax,%eax
  800d84:	7f 08                	jg     800d8e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d89:	5b                   	pop    %ebx
  800d8a:	5e                   	pop    %esi
  800d8b:	5f                   	pop    %edi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8e:	83 ec 0c             	sub    $0xc,%esp
  800d91:	50                   	push   %eax
  800d92:	6a 0a                	push   $0xa
  800d94:	68 ff 25 80 00       	push   $0x8025ff
  800d99:	6a 23                	push   $0x23
  800d9b:	68 1c 26 80 00       	push   $0x80261c
  800da0:	e8 7f 11 00 00       	call   801f24 <_panic>

00800da5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dab:	be 00 00 00 00       	mov    $0x0,%esi
  800db0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	89 cb                	mov    %ecx,%ebx
  800de0:	89 cf                	mov    %ecx,%edi
  800de2:	89 ce                	mov    %ecx,%esi
  800de4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7f 08                	jg     800df2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	50                   	push   %eax
  800df6:	6a 0e                	push   $0xe
  800df8:	68 ff 25 80 00       	push   $0x8025ff
  800dfd:	6a 23                	push   $0x23
  800dff:	68 1c 26 80 00       	push   $0x80261c
  800e04:	e8 1b 11 00 00       	call   801f24 <_panic>

00800e09 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0f:	be 00 00 00 00       	mov    $0x0,%esi
  800e14:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e22:	89 f7                	mov    %esi,%edi
  800e24:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5f                   	pop    %edi
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e31:	be 00 00 00 00       	mov    $0x0,%esi
  800e36:	b8 10 00 00 00       	mov    $0x10,%eax
  800e3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e44:	89 f7                	mov    %esi,%edi
  800e46:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e53:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e58:	b8 11 00 00 00       	mov    $0x11,%eax
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	89 cb                	mov    %ecx,%ebx
  800e62:	89 cf                	mov    %ecx,%edi
  800e64:	89 ce                	mov    %ecx,%esi
  800e66:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e68:	5b                   	pop    %ebx
  800e69:	5e                   	pop    %esi
  800e6a:	5f                   	pop    %edi
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    

00800e6d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e75:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800e77:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e7b:	0f 84 84 00 00 00    	je     800f05 <pgfault+0x98>
  800e81:	89 d8                	mov    %ebx,%eax
  800e83:	c1 e8 16             	shr    $0x16,%eax
  800e86:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e8d:	a8 01                	test   $0x1,%al
  800e8f:	74 74                	je     800f05 <pgfault+0x98>
  800e91:	89 d8                	mov    %ebx,%eax
  800e93:	c1 e8 0c             	shr    $0xc,%eax
  800e96:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e9d:	f6 c4 08             	test   $0x8,%ah
  800ea0:	74 63                	je     800f05 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800ea2:	e8 f2 fc ff ff       	call   800b99 <sys_getenvid>
  800ea7:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800ea9:	83 ec 04             	sub    $0x4,%esp
  800eac:	6a 07                	push   $0x7
  800eae:	68 00 f0 7f 00       	push   $0x7ff000
  800eb3:	50                   	push   %eax
  800eb4:	e8 ff fc ff ff       	call   800bb8 <sys_page_alloc>
  800eb9:	83 c4 10             	add    $0x10,%esp
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	78 5b                	js     800f1b <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  800ec0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  800ec6:	83 ec 04             	sub    $0x4,%esp
  800ec9:	68 00 10 00 00       	push   $0x1000
  800ece:	53                   	push   %ebx
  800ecf:	68 00 f0 7f 00       	push   $0x7ff000
  800ed4:	e8 03 fb ff ff       	call   8009dc <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  800ed9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ee0:	53                   	push   %ebx
  800ee1:	56                   	push   %esi
  800ee2:	68 00 f0 7f 00       	push   $0x7ff000
  800ee7:	56                   	push   %esi
  800ee8:	e8 0e fd ff ff       	call   800bfb <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  800eed:	83 c4 18             	add    $0x18,%esp
  800ef0:	68 00 f0 7f 00       	push   $0x7ff000
  800ef5:	56                   	push   %esi
  800ef6:	e8 42 fd ff ff       	call   800c3d <sys_page_unmap>

}
  800efb:	83 c4 10             	add    $0x10,%esp
  800efe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800f05:	68 2c 26 80 00       	push   $0x80262c
  800f0a:	68 b6 26 80 00       	push   $0x8026b6
  800f0f:	6a 1c                	push   $0x1c
  800f11:	68 cb 26 80 00       	push   $0x8026cb
  800f16:	e8 09 10 00 00       	call   801f24 <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800f1b:	68 7c 26 80 00       	push   $0x80267c
  800f20:	68 b6 26 80 00       	push   $0x8026b6
  800f25:	6a 26                	push   $0x26
  800f27:	68 cb 26 80 00       	push   $0x8026cb
  800f2c:	e8 f3 0f 00 00       	call   801f24 <_panic>

00800f31 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	57                   	push   %edi
  800f35:	56                   	push   %esi
  800f36:	53                   	push   %ebx
  800f37:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f3a:	68 6d 0e 80 00       	push   $0x800e6d
  800f3f:	e8 5f 10 00 00       	call   801fa3 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f44:	b8 07 00 00 00       	mov    $0x7,%eax
  800f49:	cd 30                	int    $0x30
  800f4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	85 c0                	test   %eax,%eax
  800f56:	0f 88 58 01 00 00    	js     8010b4 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	74 07                	je     800f67 <fork+0x36>
  800f60:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f65:	eb 72                	jmp    800fd9 <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f67:	e8 2d fc ff ff       	call   800b99 <sys_getenvid>
  800f6c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f71:	89 c2                	mov    %eax,%edx
  800f73:	c1 e2 05             	shl    $0x5,%edx
  800f76:	29 c2                	sub    %eax,%edx
  800f78:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800f7f:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800f84:	e9 20 01 00 00       	jmp    8010a9 <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  800f89:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  800f90:	e8 04 fc ff ff       	call   800b99 <sys_getenvid>
  800f95:	83 ec 0c             	sub    $0xc,%esp
  800f98:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  800f9e:	57                   	push   %edi
  800f9f:	56                   	push   %esi
  800fa0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fa3:	56                   	push   %esi
  800fa4:	50                   	push   %eax
  800fa5:	e8 51 fc ff ff       	call   800bfb <sys_page_map>
  800faa:	83 c4 20             	add    $0x20,%esp
  800fad:	eb 18                	jmp    800fc7 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  800faf:	e8 e5 fb ff ff       	call   800b99 <sys_getenvid>
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	6a 05                	push   $0x5
  800fb9:	56                   	push   %esi
  800fba:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbd:	56                   	push   %esi
  800fbe:	50                   	push   %eax
  800fbf:	e8 37 fc ff ff       	call   800bfb <sys_page_map>
  800fc4:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  800fc7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fcd:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fd3:	0f 84 8f 00 00 00    	je     801068 <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  800fd9:	89 d8                	mov    %ebx,%eax
  800fdb:	c1 e8 16             	shr    $0x16,%eax
  800fde:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe5:	a8 01                	test   $0x1,%al
  800fe7:	74 de                	je     800fc7 <fork+0x96>
  800fe9:	89 d8                	mov    %ebx,%eax
  800feb:	c1 e8 0c             	shr    $0xc,%eax
  800fee:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ff5:	a8 04                	test   $0x4,%al
  800ff7:	74 ce                	je     800fc7 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  800ff9:	89 de                	mov    %ebx,%esi
  800ffb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  801001:	89 f0                	mov    %esi,%eax
  801003:	c1 e8 0c             	shr    $0xc,%eax
  801006:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80100d:	f6 c6 04             	test   $0x4,%dh
  801010:	0f 85 73 ff ff ff    	jne    800f89 <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  801016:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80101d:	a9 02 08 00 00       	test   $0x802,%eax
  801022:	74 8b                	je     800faf <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801024:	e8 70 fb ff ff       	call   800b99 <sys_getenvid>
  801029:	83 ec 0c             	sub    $0xc,%esp
  80102c:	68 05 08 00 00       	push   $0x805
  801031:	56                   	push   %esi
  801032:	ff 75 e4             	pushl  -0x1c(%ebp)
  801035:	56                   	push   %esi
  801036:	50                   	push   %eax
  801037:	e8 bf fb ff ff       	call   800bfb <sys_page_map>
  80103c:	83 c4 20             	add    $0x20,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	78 84                	js     800fc7 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801043:	e8 51 fb ff ff       	call   800b99 <sys_getenvid>
  801048:	89 c7                	mov    %eax,%edi
  80104a:	e8 4a fb ff ff       	call   800b99 <sys_getenvid>
  80104f:	83 ec 0c             	sub    $0xc,%esp
  801052:	68 05 08 00 00       	push   $0x805
  801057:	56                   	push   %esi
  801058:	57                   	push   %edi
  801059:	56                   	push   %esi
  80105a:	50                   	push   %eax
  80105b:	e8 9b fb ff ff       	call   800bfb <sys_page_map>
  801060:	83 c4 20             	add    $0x20,%esp
  801063:	e9 5f ff ff ff       	jmp    800fc7 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  801068:	83 ec 04             	sub    $0x4,%esp
  80106b:	6a 07                	push   $0x7
  80106d:	68 00 f0 bf ee       	push   $0xeebff000
  801072:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801075:	57                   	push   %edi
  801076:	e8 3d fb ff ff       	call   800bb8 <sys_page_alloc>
  80107b:	83 c4 10             	add    $0x10,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 3b                	js     8010bd <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  801082:	83 ec 08             	sub    $0x8,%esp
  801085:	68 e9 1f 80 00       	push   $0x801fe9
  80108a:	57                   	push   %edi
  80108b:	e8 d3 fc ff ff       	call   800d63 <sys_env_set_pgfault_upcall>
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	78 2f                	js     8010c6 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  801097:	83 ec 08             	sub    $0x8,%esp
  80109a:	6a 02                	push   $0x2
  80109c:	57                   	push   %edi
  80109d:	e8 fc fb ff ff       	call   800c9e <sys_env_set_status>
	if (temp < 0) {
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 26                	js     8010cf <fork+0x19e>
		return -1;
	}

	return childid;
}
  8010a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010af:	5b                   	pop    %ebx
  8010b0:	5e                   	pop    %esi
  8010b1:	5f                   	pop    %edi
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    
		return -1;
  8010b4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8010bb:	eb ec                	jmp    8010a9 <fork+0x178>
		return -1;
  8010bd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8010c4:	eb e3                	jmp    8010a9 <fork+0x178>
		return -1;
  8010c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8010cd:	eb da                	jmp    8010a9 <fork+0x178>
		return -1;
  8010cf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8010d6:	eb d1                	jmp    8010a9 <fork+0x178>

008010d8 <sfork>:

// Challenge!
int
sfork(void)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010de:	68 d6 26 80 00       	push   $0x8026d6
  8010e3:	68 85 00 00 00       	push   $0x85
  8010e8:	68 cb 26 80 00       	push   $0x8026cb
  8010ed:	e8 32 0e 00 00       	call   801f24 <_panic>

008010f2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	57                   	push   %edi
  8010f6:	56                   	push   %esi
  8010f7:	53                   	push   %ebx
  8010f8:	83 ec 0c             	sub    $0xc,%esp
  8010fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8010fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801101:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801104:	85 ff                	test   %edi,%edi
  801106:	74 53                	je     80115b <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801108:	83 ec 0c             	sub    $0xc,%esp
  80110b:	57                   	push   %edi
  80110c:	e8 b7 fc ff ff       	call   800dc8 <sys_ipc_recv>
  801111:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801114:	85 db                	test   %ebx,%ebx
  801116:	74 0b                	je     801123 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801118:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80111e:	8b 52 74             	mov    0x74(%edx),%edx
  801121:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801123:	85 f6                	test   %esi,%esi
  801125:	74 0f                	je     801136 <ipc_recv+0x44>
  801127:	85 ff                	test   %edi,%edi
  801129:	74 0b                	je     801136 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80112b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801131:	8b 52 78             	mov    0x78(%edx),%edx
  801134:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801136:	85 c0                	test   %eax,%eax
  801138:	74 30                	je     80116a <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  80113a:	85 db                	test   %ebx,%ebx
  80113c:	74 06                	je     801144 <ipc_recv+0x52>
      		*from_env_store = 0;
  80113e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801144:	85 f6                	test   %esi,%esi
  801146:	74 2c                	je     801174 <ipc_recv+0x82>
      		*perm_store = 0;
  801148:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80114e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801153:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  80115b:	83 ec 0c             	sub    $0xc,%esp
  80115e:	6a ff                	push   $0xffffffff
  801160:	e8 63 fc ff ff       	call   800dc8 <sys_ipc_recv>
  801165:	83 c4 10             	add    $0x10,%esp
  801168:	eb aa                	jmp    801114 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  80116a:	a1 08 40 80 00       	mov    0x804008,%eax
  80116f:	8b 40 70             	mov    0x70(%eax),%eax
  801172:	eb df                	jmp    801153 <ipc_recv+0x61>
		return -1;
  801174:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801179:	eb d8                	jmp    801153 <ipc_recv+0x61>

0080117b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	57                   	push   %edi
  80117f:	56                   	push   %esi
  801180:	53                   	push   %ebx
  801181:	83 ec 0c             	sub    $0xc,%esp
  801184:	8b 75 0c             	mov    0xc(%ebp),%esi
  801187:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80118a:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  80118d:	85 db                	test   %ebx,%ebx
  80118f:	75 22                	jne    8011b3 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801191:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801196:	eb 1b                	jmp    8011b3 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801198:	68 ec 26 80 00       	push   $0x8026ec
  80119d:	68 b6 26 80 00       	push   $0x8026b6
  8011a2:	6a 48                	push   $0x48
  8011a4:	68 0f 27 80 00       	push   $0x80270f
  8011a9:	e8 76 0d 00 00       	call   801f24 <_panic>
		sys_yield();
  8011ae:	e8 cc fa ff ff       	call   800c7f <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8011b3:	57                   	push   %edi
  8011b4:	53                   	push   %ebx
  8011b5:	56                   	push   %esi
  8011b6:	ff 75 08             	pushl  0x8(%ebp)
  8011b9:	e8 e7 fb ff ff       	call   800da5 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011c4:	74 e8                	je     8011ae <ipc_send+0x33>
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	75 ce                	jne    801198 <ipc_send+0x1d>
		sys_yield();
  8011ca:	e8 b0 fa ff ff       	call   800c7f <sys_yield>
		
	}
	
}
  8011cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    

008011d7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8011dd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8011e2:	89 c2                	mov    %eax,%edx
  8011e4:	c1 e2 05             	shl    $0x5,%edx
  8011e7:	29 c2                	sub    %eax,%edx
  8011e9:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  8011f0:	8b 52 50             	mov    0x50(%edx),%edx
  8011f3:	39 ca                	cmp    %ecx,%edx
  8011f5:	74 0f                	je     801206 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8011f7:	40                   	inc    %eax
  8011f8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011fd:	75 e3                	jne    8011e2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8011ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801204:	eb 11                	jmp    801217 <ipc_find_env+0x40>
			return envs[i].env_id;
  801206:	89 c2                	mov    %eax,%edx
  801208:	c1 e2 05             	shl    $0x5,%edx
  80120b:	29 c2                	sub    %eax,%edx
  80120d:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801214:	8b 40 48             	mov    0x48(%eax),%eax
}
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    

00801219 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	05 00 00 00 30       	add    $0x30000000,%eax
  801224:	c1 e8 0c             	shr    $0xc,%eax
}
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801234:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801239:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    

00801240 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801246:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80124b:	89 c2                	mov    %eax,%edx
  80124d:	c1 ea 16             	shr    $0x16,%edx
  801250:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801257:	f6 c2 01             	test   $0x1,%dl
  80125a:	74 2a                	je     801286 <fd_alloc+0x46>
  80125c:	89 c2                	mov    %eax,%edx
  80125e:	c1 ea 0c             	shr    $0xc,%edx
  801261:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801268:	f6 c2 01             	test   $0x1,%dl
  80126b:	74 19                	je     801286 <fd_alloc+0x46>
  80126d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801272:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801277:	75 d2                	jne    80124b <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801279:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80127f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801284:	eb 07                	jmp    80128d <fd_alloc+0x4d>
			*fd_store = fd;
  801286:	89 01                	mov    %eax,(%ecx)
			return 0;
  801288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128d:	5d                   	pop    %ebp
  80128e:	c3                   	ret    

0080128f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801292:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801296:	77 39                	ja     8012d1 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	c1 e0 0c             	shl    $0xc,%eax
  80129e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012a3:	89 c2                	mov    %eax,%edx
  8012a5:	c1 ea 16             	shr    $0x16,%edx
  8012a8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012af:	f6 c2 01             	test   $0x1,%dl
  8012b2:	74 24                	je     8012d8 <fd_lookup+0x49>
  8012b4:	89 c2                	mov    %eax,%edx
  8012b6:	c1 ea 0c             	shr    $0xc,%edx
  8012b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012c0:	f6 c2 01             	test   $0x1,%dl
  8012c3:	74 1a                	je     8012df <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c8:	89 02                	mov    %eax,(%edx)
	return 0;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012cf:	5d                   	pop    %ebp
  8012d0:	c3                   	ret    
		return -E_INVAL;
  8012d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d6:	eb f7                	jmp    8012cf <fd_lookup+0x40>
		return -E_INVAL;
  8012d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012dd:	eb f0                	jmp    8012cf <fd_lookup+0x40>
  8012df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e4:	eb e9                	jmp    8012cf <fd_lookup+0x40>

008012e6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ef:	ba 98 27 80 00       	mov    $0x802798,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012f4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012f9:	39 08                	cmp    %ecx,(%eax)
  8012fb:	74 33                	je     801330 <dev_lookup+0x4a>
  8012fd:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801300:	8b 02                	mov    (%edx),%eax
  801302:	85 c0                	test   %eax,%eax
  801304:	75 f3                	jne    8012f9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801306:	a1 08 40 80 00       	mov    0x804008,%eax
  80130b:	8b 40 48             	mov    0x48(%eax),%eax
  80130e:	83 ec 04             	sub    $0x4,%esp
  801311:	51                   	push   %ecx
  801312:	50                   	push   %eax
  801313:	68 1c 27 80 00       	push   $0x80271c
  801318:	e8 de ee ff ff       	call   8001fb <cprintf>
	*dev = 0;
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801326:	83 c4 10             	add    $0x10,%esp
  801329:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    
			*dev = devtab[i];
  801330:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801333:	89 01                	mov    %eax,(%ecx)
			return 0;
  801335:	b8 00 00 00 00       	mov    $0x0,%eax
  80133a:	eb f2                	jmp    80132e <dev_lookup+0x48>

0080133c <fd_close>:
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	57                   	push   %edi
  801340:	56                   	push   %esi
  801341:	53                   	push   %ebx
  801342:	83 ec 1c             	sub    $0x1c,%esp
  801345:	8b 75 08             	mov    0x8(%ebp),%esi
  801348:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80134b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80134e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80134f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801355:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801358:	50                   	push   %eax
  801359:	e8 31 ff ff ff       	call   80128f <fd_lookup>
  80135e:	89 c7                	mov    %eax,%edi
  801360:	83 c4 08             	add    $0x8,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	78 05                	js     80136c <fd_close+0x30>
	    || fd != fd2)
  801367:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  80136a:	74 13                	je     80137f <fd_close+0x43>
		return (must_exist ? r : 0);
  80136c:	84 db                	test   %bl,%bl
  80136e:	75 05                	jne    801375 <fd_close+0x39>
  801370:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801375:	89 f8                	mov    %edi,%eax
  801377:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137a:	5b                   	pop    %ebx
  80137b:	5e                   	pop    %esi
  80137c:	5f                   	pop    %edi
  80137d:	5d                   	pop    %ebp
  80137e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80137f:	83 ec 08             	sub    $0x8,%esp
  801382:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801385:	50                   	push   %eax
  801386:	ff 36                	pushl  (%esi)
  801388:	e8 59 ff ff ff       	call   8012e6 <dev_lookup>
  80138d:	89 c7                	mov    %eax,%edi
  80138f:	83 c4 10             	add    $0x10,%esp
  801392:	85 c0                	test   %eax,%eax
  801394:	78 15                	js     8013ab <fd_close+0x6f>
		if (dev->dev_close)
  801396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801399:	8b 40 10             	mov    0x10(%eax),%eax
  80139c:	85 c0                	test   %eax,%eax
  80139e:	74 1b                	je     8013bb <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8013a0:	83 ec 0c             	sub    $0xc,%esp
  8013a3:	56                   	push   %esi
  8013a4:	ff d0                	call   *%eax
  8013a6:	89 c7                	mov    %eax,%edi
  8013a8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	56                   	push   %esi
  8013af:	6a 00                	push   $0x0
  8013b1:	e8 87 f8 ff ff       	call   800c3d <sys_page_unmap>
	return r;
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	eb ba                	jmp    801375 <fd_close+0x39>
			r = 0;
  8013bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8013c0:	eb e9                	jmp    8013ab <fd_close+0x6f>

008013c2 <close>:

int
close(int fdnum)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cb:	50                   	push   %eax
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 bb fe ff ff       	call   80128f <fd_lookup>
  8013d4:	83 c4 08             	add    $0x8,%esp
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	78 10                	js     8013eb <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013db:	83 ec 08             	sub    $0x8,%esp
  8013de:	6a 01                	push   $0x1
  8013e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e3:	e8 54 ff ff ff       	call   80133c <fd_close>
  8013e8:	83 c4 10             	add    $0x10,%esp
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <close_all>:

void
close_all(void)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	53                   	push   %ebx
  8013f1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013f4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013f9:	83 ec 0c             	sub    $0xc,%esp
  8013fc:	53                   	push   %ebx
  8013fd:	e8 c0 ff ff ff       	call   8013c2 <close>
	for (i = 0; i < MAXFD; i++)
  801402:	43                   	inc    %ebx
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	83 fb 20             	cmp    $0x20,%ebx
  801409:	75 ee                	jne    8013f9 <close_all+0xc>
}
  80140b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	57                   	push   %edi
  801414:	56                   	push   %esi
  801415:	53                   	push   %ebx
  801416:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801419:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80141c:	50                   	push   %eax
  80141d:	ff 75 08             	pushl  0x8(%ebp)
  801420:	e8 6a fe ff ff       	call   80128f <fd_lookup>
  801425:	89 c3                	mov    %eax,%ebx
  801427:	83 c4 08             	add    $0x8,%esp
  80142a:	85 c0                	test   %eax,%eax
  80142c:	0f 88 81 00 00 00    	js     8014b3 <dup+0xa3>
		return r;
	close(newfdnum);
  801432:	83 ec 0c             	sub    $0xc,%esp
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	e8 85 ff ff ff       	call   8013c2 <close>

	newfd = INDEX2FD(newfdnum);
  80143d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801440:	c1 e6 0c             	shl    $0xc,%esi
  801443:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801449:	83 c4 04             	add    $0x4,%esp
  80144c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80144f:	e8 d5 fd ff ff       	call   801229 <fd2data>
  801454:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801456:	89 34 24             	mov    %esi,(%esp)
  801459:	e8 cb fd ff ff       	call   801229 <fd2data>
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801463:	89 d8                	mov    %ebx,%eax
  801465:	c1 e8 16             	shr    $0x16,%eax
  801468:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80146f:	a8 01                	test   $0x1,%al
  801471:	74 11                	je     801484 <dup+0x74>
  801473:	89 d8                	mov    %ebx,%eax
  801475:	c1 e8 0c             	shr    $0xc,%eax
  801478:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80147f:	f6 c2 01             	test   $0x1,%dl
  801482:	75 39                	jne    8014bd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801484:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801487:	89 d0                	mov    %edx,%eax
  801489:	c1 e8 0c             	shr    $0xc,%eax
  80148c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801493:	83 ec 0c             	sub    $0xc,%esp
  801496:	25 07 0e 00 00       	and    $0xe07,%eax
  80149b:	50                   	push   %eax
  80149c:	56                   	push   %esi
  80149d:	6a 00                	push   $0x0
  80149f:	52                   	push   %edx
  8014a0:	6a 00                	push   $0x0
  8014a2:	e8 54 f7 ff ff       	call   800bfb <sys_page_map>
  8014a7:	89 c3                	mov    %eax,%ebx
  8014a9:	83 c4 20             	add    $0x20,%esp
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 31                	js     8014e1 <dup+0xd1>
		goto err;

	return newfdnum;
  8014b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014b3:	89 d8                	mov    %ebx,%eax
  8014b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5f                   	pop    %edi
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8014cc:	50                   	push   %eax
  8014cd:	57                   	push   %edi
  8014ce:	6a 00                	push   $0x0
  8014d0:	53                   	push   %ebx
  8014d1:	6a 00                	push   $0x0
  8014d3:	e8 23 f7 ff ff       	call   800bfb <sys_page_map>
  8014d8:	89 c3                	mov    %eax,%ebx
  8014da:	83 c4 20             	add    $0x20,%esp
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	79 a3                	jns    801484 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014e1:	83 ec 08             	sub    $0x8,%esp
  8014e4:	56                   	push   %esi
  8014e5:	6a 00                	push   $0x0
  8014e7:	e8 51 f7 ff ff       	call   800c3d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014ec:	83 c4 08             	add    $0x8,%esp
  8014ef:	57                   	push   %edi
  8014f0:	6a 00                	push   $0x0
  8014f2:	e8 46 f7 ff ff       	call   800c3d <sys_page_unmap>
	return r;
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	eb b7                	jmp    8014b3 <dup+0xa3>

008014fc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	53                   	push   %ebx
  801500:	83 ec 14             	sub    $0x14,%esp
  801503:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801506:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801509:	50                   	push   %eax
  80150a:	53                   	push   %ebx
  80150b:	e8 7f fd ff ff       	call   80128f <fd_lookup>
  801510:	83 c4 08             	add    $0x8,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 3f                	js     801556 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801517:	83 ec 08             	sub    $0x8,%esp
  80151a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151d:	50                   	push   %eax
  80151e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801521:	ff 30                	pushl  (%eax)
  801523:	e8 be fd ff ff       	call   8012e6 <dev_lookup>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 27                	js     801556 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80152f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801532:	8b 42 08             	mov    0x8(%edx),%eax
  801535:	83 e0 03             	and    $0x3,%eax
  801538:	83 f8 01             	cmp    $0x1,%eax
  80153b:	74 1e                	je     80155b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80153d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801540:	8b 40 08             	mov    0x8(%eax),%eax
  801543:	85 c0                	test   %eax,%eax
  801545:	74 35                	je     80157c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	ff 75 10             	pushl  0x10(%ebp)
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	52                   	push   %edx
  801551:	ff d0                	call   *%eax
  801553:	83 c4 10             	add    $0x10,%esp
}
  801556:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801559:	c9                   	leave  
  80155a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80155b:	a1 08 40 80 00       	mov    0x804008,%eax
  801560:	8b 40 48             	mov    0x48(%eax),%eax
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	53                   	push   %ebx
  801567:	50                   	push   %eax
  801568:	68 5d 27 80 00       	push   $0x80275d
  80156d:	e8 89 ec ff ff       	call   8001fb <cprintf>
		return -E_INVAL;
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157a:	eb da                	jmp    801556 <read+0x5a>
		return -E_NOT_SUPP;
  80157c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801581:	eb d3                	jmp    801556 <read+0x5a>

00801583 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	57                   	push   %edi
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	83 ec 0c             	sub    $0xc,%esp
  80158c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80158f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801592:	bb 00 00 00 00       	mov    $0x0,%ebx
  801597:	39 f3                	cmp    %esi,%ebx
  801599:	73 25                	jae    8015c0 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	89 f0                	mov    %esi,%eax
  8015a0:	29 d8                	sub    %ebx,%eax
  8015a2:	50                   	push   %eax
  8015a3:	89 d8                	mov    %ebx,%eax
  8015a5:	03 45 0c             	add    0xc(%ebp),%eax
  8015a8:	50                   	push   %eax
  8015a9:	57                   	push   %edi
  8015aa:	e8 4d ff ff ff       	call   8014fc <read>
		if (m < 0)
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	78 08                	js     8015be <readn+0x3b>
			return m;
		if (m == 0)
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	74 06                	je     8015c0 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015ba:	01 c3                	add    %eax,%ebx
  8015bc:	eb d9                	jmp    801597 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015be:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015c0:	89 d8                	mov    %ebx,%eax
  8015c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c5:	5b                   	pop    %ebx
  8015c6:	5e                   	pop    %esi
  8015c7:	5f                   	pop    %edi
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 14             	sub    $0x14,%esp
  8015d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d7:	50                   	push   %eax
  8015d8:	53                   	push   %ebx
  8015d9:	e8 b1 fc ff ff       	call   80128f <fd_lookup>
  8015de:	83 c4 08             	add    $0x8,%esp
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 3a                	js     80161f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015eb:	50                   	push   %eax
  8015ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ef:	ff 30                	pushl  (%eax)
  8015f1:	e8 f0 fc ff ff       	call   8012e6 <dev_lookup>
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 22                	js     80161f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801600:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801604:	74 1e                	je     801624 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801609:	8b 52 0c             	mov    0xc(%edx),%edx
  80160c:	85 d2                	test   %edx,%edx
  80160e:	74 35                	je     801645 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	ff 75 0c             	pushl  0xc(%ebp)
  801619:	50                   	push   %eax
  80161a:	ff d2                	call   *%edx
  80161c:	83 c4 10             	add    $0x10,%esp
}
  80161f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801622:	c9                   	leave  
  801623:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801624:	a1 08 40 80 00       	mov    0x804008,%eax
  801629:	8b 40 48             	mov    0x48(%eax),%eax
  80162c:	83 ec 04             	sub    $0x4,%esp
  80162f:	53                   	push   %ebx
  801630:	50                   	push   %eax
  801631:	68 79 27 80 00       	push   $0x802779
  801636:	e8 c0 eb ff ff       	call   8001fb <cprintf>
		return -E_INVAL;
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801643:	eb da                	jmp    80161f <write+0x55>
		return -E_NOT_SUPP;
  801645:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164a:	eb d3                	jmp    80161f <write+0x55>

0080164c <seek>:

int
seek(int fdnum, off_t offset)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801652:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	ff 75 08             	pushl  0x8(%ebp)
  801659:	e8 31 fc ff ff       	call   80128f <fd_lookup>
  80165e:	83 c4 08             	add    $0x8,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	78 0e                	js     801673 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801665:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80166e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	53                   	push   %ebx
  801679:	83 ec 14             	sub    $0x14,%esp
  80167c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80167f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801682:	50                   	push   %eax
  801683:	53                   	push   %ebx
  801684:	e8 06 fc ff ff       	call   80128f <fd_lookup>
  801689:	83 c4 08             	add    $0x8,%esp
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 37                	js     8016c7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801696:	50                   	push   %eax
  801697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169a:	ff 30                	pushl  (%eax)
  80169c:	e8 45 fc ff ff       	call   8012e6 <dev_lookup>
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	78 1f                	js     8016c7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ab:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016af:	74 1b                	je     8016cc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b4:	8b 52 18             	mov    0x18(%edx),%edx
  8016b7:	85 d2                	test   %edx,%edx
  8016b9:	74 32                	je     8016ed <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016bb:	83 ec 08             	sub    $0x8,%esp
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	50                   	push   %eax
  8016c2:	ff d2                	call   *%edx
  8016c4:	83 c4 10             	add    $0x10,%esp
}
  8016c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016cc:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016d1:	8b 40 48             	mov    0x48(%eax),%eax
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	53                   	push   %ebx
  8016d8:	50                   	push   %eax
  8016d9:	68 3c 27 80 00       	push   $0x80273c
  8016de:	e8 18 eb ff ff       	call   8001fb <cprintf>
		return -E_INVAL;
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016eb:	eb da                	jmp    8016c7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f2:	eb d3                	jmp    8016c7 <ftruncate+0x52>

008016f4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	53                   	push   %ebx
  8016f8:	83 ec 14             	sub    $0x14,%esp
  8016fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801701:	50                   	push   %eax
  801702:	ff 75 08             	pushl  0x8(%ebp)
  801705:	e8 85 fb ff ff       	call   80128f <fd_lookup>
  80170a:	83 c4 08             	add    $0x8,%esp
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 4b                	js     80175c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801717:	50                   	push   %eax
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171b:	ff 30                	pushl  (%eax)
  80171d:	e8 c4 fb ff ff       	call   8012e6 <dev_lookup>
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	85 c0                	test   %eax,%eax
  801727:	78 33                	js     80175c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801730:	74 2f                	je     801761 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801732:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801735:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80173c:	00 00 00 
	stat->st_type = 0;
  80173f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801746:	00 00 00 
	stat->st_dev = dev;
  801749:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	53                   	push   %ebx
  801753:	ff 75 f0             	pushl  -0x10(%ebp)
  801756:	ff 50 14             	call   *0x14(%eax)
  801759:	83 c4 10             	add    $0x10,%esp
}
  80175c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175f:	c9                   	leave  
  801760:	c3                   	ret    
		return -E_NOT_SUPP;
  801761:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801766:	eb f4                	jmp    80175c <fstat+0x68>

00801768 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	6a 00                	push   $0x0
  801772:	ff 75 08             	pushl  0x8(%ebp)
  801775:	e8 34 02 00 00       	call   8019ae <open>
  80177a:	89 c3                	mov    %eax,%ebx
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 1b                	js     80179e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	ff 75 0c             	pushl  0xc(%ebp)
  801789:	50                   	push   %eax
  80178a:	e8 65 ff ff ff       	call   8016f4 <fstat>
  80178f:	89 c6                	mov    %eax,%esi
	close(fd);
  801791:	89 1c 24             	mov    %ebx,(%esp)
  801794:	e8 29 fc ff ff       	call   8013c2 <close>
	return r;
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	89 f3                	mov    %esi,%ebx
}
  80179e:	89 d8                	mov    %ebx,%eax
  8017a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	56                   	push   %esi
  8017ab:	53                   	push   %ebx
  8017ac:	89 c6                	mov    %eax,%esi
  8017ae:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017b0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017b7:	74 27                	je     8017e0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017b9:	6a 07                	push   $0x7
  8017bb:	68 00 50 80 00       	push   $0x805000
  8017c0:	56                   	push   %esi
  8017c1:	ff 35 00 40 80 00    	pushl  0x804000
  8017c7:	e8 af f9 ff ff       	call   80117b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017cc:	83 c4 0c             	add    $0xc,%esp
  8017cf:	6a 00                	push   $0x0
  8017d1:	53                   	push   %ebx
  8017d2:	6a 00                	push   $0x0
  8017d4:	e8 19 f9 ff ff       	call   8010f2 <ipc_recv>
}
  8017d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017dc:	5b                   	pop    %ebx
  8017dd:	5e                   	pop    %esi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	6a 01                	push   $0x1
  8017e5:	e8 ed f9 ff ff       	call   8011d7 <ipc_find_env>
  8017ea:	a3 00 40 80 00       	mov    %eax,0x804000
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	eb c5                	jmp    8017b9 <fsipc+0x12>

008017f4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801800:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801805:	8b 45 0c             	mov    0xc(%ebp),%eax
  801808:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80180d:	ba 00 00 00 00       	mov    $0x0,%edx
  801812:	b8 02 00 00 00       	mov    $0x2,%eax
  801817:	e8 8b ff ff ff       	call   8017a7 <fsipc>
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <devfile_flush>:
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	8b 40 0c             	mov    0xc(%eax),%eax
  80182a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80182f:	ba 00 00 00 00       	mov    $0x0,%edx
  801834:	b8 06 00 00 00       	mov    $0x6,%eax
  801839:	e8 69 ff ff ff       	call   8017a7 <fsipc>
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <devfile_stat>:
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	53                   	push   %ebx
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8b 40 0c             	mov    0xc(%eax),%eax
  801850:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801855:	ba 00 00 00 00       	mov    $0x0,%edx
  80185a:	b8 05 00 00 00       	mov    $0x5,%eax
  80185f:	e8 43 ff ff ff       	call   8017a7 <fsipc>
  801864:	85 c0                	test   %eax,%eax
  801866:	78 2c                	js     801894 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	68 00 50 80 00       	push   $0x805000
  801870:	53                   	push   %ebx
  801871:	e8 8d ef ff ff       	call   800803 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801876:	a1 80 50 80 00       	mov    0x805080,%eax
  80187b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801881:	a1 84 50 80 00       	mov    0x805084,%eax
  801886:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <devfile_write>:
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	53                   	push   %ebx
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8018a3:	89 d8                	mov    %ebx,%eax
  8018a5:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8018ab:	76 05                	jbe    8018b2 <devfile_write+0x19>
  8018ad:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8018b8:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8018be:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	50                   	push   %eax
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	68 08 50 80 00       	push   $0x805008
  8018cf:	e8 a2 f0 ff ff       	call   800976 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8018d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d9:	b8 04 00 00 00       	mov    $0x4,%eax
  8018de:	e8 c4 fe ff ff       	call   8017a7 <fsipc>
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 0b                	js     8018f5 <devfile_write+0x5c>
	assert(r <= n);
  8018ea:	39 c3                	cmp    %eax,%ebx
  8018ec:	72 0c                	jb     8018fa <devfile_write+0x61>
	assert(r <= PGSIZE);
  8018ee:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018f3:	7f 1e                	jg     801913 <devfile_write+0x7a>
}
  8018f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    
	assert(r <= n);
  8018fa:	68 a8 27 80 00       	push   $0x8027a8
  8018ff:	68 b6 26 80 00       	push   $0x8026b6
  801904:	68 98 00 00 00       	push   $0x98
  801909:	68 af 27 80 00       	push   $0x8027af
  80190e:	e8 11 06 00 00       	call   801f24 <_panic>
	assert(r <= PGSIZE);
  801913:	68 ba 27 80 00       	push   $0x8027ba
  801918:	68 b6 26 80 00       	push   $0x8026b6
  80191d:	68 99 00 00 00       	push   $0x99
  801922:	68 af 27 80 00       	push   $0x8027af
  801927:	e8 f8 05 00 00       	call   801f24 <_panic>

0080192c <devfile_read>:
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
  801931:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8b 40 0c             	mov    0xc(%eax),%eax
  80193a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80193f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801945:	ba 00 00 00 00       	mov    $0x0,%edx
  80194a:	b8 03 00 00 00       	mov    $0x3,%eax
  80194f:	e8 53 fe ff ff       	call   8017a7 <fsipc>
  801954:	89 c3                	mov    %eax,%ebx
  801956:	85 c0                	test   %eax,%eax
  801958:	78 1f                	js     801979 <devfile_read+0x4d>
	assert(r <= n);
  80195a:	39 c6                	cmp    %eax,%esi
  80195c:	72 24                	jb     801982 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80195e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801963:	7f 33                	jg     801998 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	50                   	push   %eax
  801969:	68 00 50 80 00       	push   $0x805000
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	e8 00 f0 ff ff       	call   800976 <memmove>
	return r;
  801976:	83 c4 10             	add    $0x10,%esp
}
  801979:	89 d8                	mov    %ebx,%eax
  80197b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197e:	5b                   	pop    %ebx
  80197f:	5e                   	pop    %esi
  801980:	5d                   	pop    %ebp
  801981:	c3                   	ret    
	assert(r <= n);
  801982:	68 a8 27 80 00       	push   $0x8027a8
  801987:	68 b6 26 80 00       	push   $0x8026b6
  80198c:	6a 7c                	push   $0x7c
  80198e:	68 af 27 80 00       	push   $0x8027af
  801993:	e8 8c 05 00 00       	call   801f24 <_panic>
	assert(r <= PGSIZE);
  801998:	68 ba 27 80 00       	push   $0x8027ba
  80199d:	68 b6 26 80 00       	push   $0x8026b6
  8019a2:	6a 7d                	push   $0x7d
  8019a4:	68 af 27 80 00       	push   $0x8027af
  8019a9:	e8 76 05 00 00       	call   801f24 <_panic>

008019ae <open>:
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	56                   	push   %esi
  8019b2:	53                   	push   %ebx
  8019b3:	83 ec 1c             	sub    $0x1c,%esp
  8019b6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019b9:	56                   	push   %esi
  8019ba:	e8 11 ee ff ff       	call   8007d0 <strlen>
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019c7:	7f 6c                	jg     801a35 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cf:	50                   	push   %eax
  8019d0:	e8 6b f8 ff ff       	call   801240 <fd_alloc>
  8019d5:	89 c3                	mov    %eax,%ebx
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 3c                	js     801a1a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	56                   	push   %esi
  8019e2:	68 00 50 80 00       	push   $0x805000
  8019e7:	e8 17 ee ff ff       	call   800803 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ef:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fc:	e8 a6 fd ff ff       	call   8017a7 <fsipc>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 19                	js     801a23 <open+0x75>
	return fd2num(fd);
  801a0a:	83 ec 0c             	sub    $0xc,%esp
  801a0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a10:	e8 04 f8 ff ff       	call   801219 <fd2num>
  801a15:	89 c3                	mov    %eax,%ebx
  801a17:	83 c4 10             	add    $0x10,%esp
}
  801a1a:	89 d8                	mov    %ebx,%eax
  801a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5e                   	pop    %esi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    
		fd_close(fd, 0);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	6a 00                	push   $0x0
  801a28:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2b:	e8 0c f9 ff ff       	call   80133c <fd_close>
		return r;
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	eb e5                	jmp    801a1a <open+0x6c>
		return -E_BAD_PATH;
  801a35:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a3a:	eb de                	jmp    801a1a <open+0x6c>

00801a3c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a42:	ba 00 00 00 00       	mov    $0x0,%edx
  801a47:	b8 08 00 00 00       	mov    $0x8,%eax
  801a4c:	e8 56 fd ff ff       	call   8017a7 <fsipc>
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a5b:	83 ec 0c             	sub    $0xc,%esp
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	e8 c3 f7 ff ff       	call   801229 <fd2data>
  801a66:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a68:	83 c4 08             	add    $0x8,%esp
  801a6b:	68 c6 27 80 00       	push   $0x8027c6
  801a70:	53                   	push   %ebx
  801a71:	e8 8d ed ff ff       	call   800803 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a76:	8b 46 04             	mov    0x4(%esi),%eax
  801a79:	2b 06                	sub    (%esi),%eax
  801a7b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801a81:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801a88:	10 00 00 
	stat->st_dev = &devpipe;
  801a8b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a92:	30 80 00 
	return 0;
}
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    

00801aa1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	53                   	push   %ebx
  801aa5:	83 ec 0c             	sub    $0xc,%esp
  801aa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801aab:	53                   	push   %ebx
  801aac:	6a 00                	push   $0x0
  801aae:	e8 8a f1 ff ff       	call   800c3d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ab3:	89 1c 24             	mov    %ebx,(%esp)
  801ab6:	e8 6e f7 ff ff       	call   801229 <fd2data>
  801abb:	83 c4 08             	add    $0x8,%esp
  801abe:	50                   	push   %eax
  801abf:	6a 00                	push   $0x0
  801ac1:	e8 77 f1 ff ff       	call   800c3d <sys_page_unmap>
}
  801ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <_pipeisclosed>:
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	57                   	push   %edi
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
  801ad1:	83 ec 1c             	sub    $0x1c,%esp
  801ad4:	89 c7                	mov    %eax,%edi
  801ad6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ad8:	a1 08 40 80 00       	mov    0x804008,%eax
  801add:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ae0:	83 ec 0c             	sub    $0xc,%esp
  801ae3:	57                   	push   %edi
  801ae4:	e8 26 05 00 00       	call   80200f <pageref>
  801ae9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aec:	89 34 24             	mov    %esi,(%esp)
  801aef:	e8 1b 05 00 00       	call   80200f <pageref>
		nn = thisenv->env_runs;
  801af4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801afa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	39 cb                	cmp    %ecx,%ebx
  801b02:	74 1b                	je     801b1f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b04:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b07:	75 cf                	jne    801ad8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b09:	8b 42 58             	mov    0x58(%edx),%eax
  801b0c:	6a 01                	push   $0x1
  801b0e:	50                   	push   %eax
  801b0f:	53                   	push   %ebx
  801b10:	68 cd 27 80 00       	push   $0x8027cd
  801b15:	e8 e1 e6 ff ff       	call   8001fb <cprintf>
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	eb b9                	jmp    801ad8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b1f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b22:	0f 94 c0             	sete   %al
  801b25:	0f b6 c0             	movzbl %al,%eax
}
  801b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <devpipe_write>:
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	57                   	push   %edi
  801b34:	56                   	push   %esi
  801b35:	53                   	push   %ebx
  801b36:	83 ec 18             	sub    $0x18,%esp
  801b39:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b3c:	56                   	push   %esi
  801b3d:	e8 e7 f6 ff ff       	call   801229 <fd2data>
  801b42:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	bf 00 00 00 00       	mov    $0x0,%edi
  801b4c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b4f:	74 41                	je     801b92 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b51:	8b 53 04             	mov    0x4(%ebx),%edx
  801b54:	8b 03                	mov    (%ebx),%eax
  801b56:	83 c0 20             	add    $0x20,%eax
  801b59:	39 c2                	cmp    %eax,%edx
  801b5b:	72 14                	jb     801b71 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b5d:	89 da                	mov    %ebx,%edx
  801b5f:	89 f0                	mov    %esi,%eax
  801b61:	e8 65 ff ff ff       	call   801acb <_pipeisclosed>
  801b66:	85 c0                	test   %eax,%eax
  801b68:	75 2c                	jne    801b96 <devpipe_write+0x66>
			sys_yield();
  801b6a:	e8 10 f1 ff ff       	call   800c7f <sys_yield>
  801b6f:	eb e0                	jmp    801b51 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b74:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801b77:	89 d0                	mov    %edx,%eax
  801b79:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801b7e:	78 0b                	js     801b8b <devpipe_write+0x5b>
  801b80:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801b84:	42                   	inc    %edx
  801b85:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b88:	47                   	inc    %edi
  801b89:	eb c1                	jmp    801b4c <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b8b:	48                   	dec    %eax
  801b8c:	83 c8 e0             	or     $0xffffffe0,%eax
  801b8f:	40                   	inc    %eax
  801b90:	eb ee                	jmp    801b80 <devpipe_write+0x50>
	return i;
  801b92:	89 f8                	mov    %edi,%eax
  801b94:	eb 05                	jmp    801b9b <devpipe_write+0x6b>
				return 0;
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9e:	5b                   	pop    %ebx
  801b9f:	5e                   	pop    %esi
  801ba0:	5f                   	pop    %edi
  801ba1:	5d                   	pop    %ebp
  801ba2:	c3                   	ret    

00801ba3 <devpipe_read>:
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	57                   	push   %edi
  801ba7:	56                   	push   %esi
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 18             	sub    $0x18,%esp
  801bac:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801baf:	57                   	push   %edi
  801bb0:	e8 74 f6 ff ff       	call   801229 <fd2data>
  801bb5:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bbf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801bc2:	74 46                	je     801c0a <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801bc4:	8b 06                	mov    (%esi),%eax
  801bc6:	3b 46 04             	cmp    0x4(%esi),%eax
  801bc9:	75 22                	jne    801bed <devpipe_read+0x4a>
			if (i > 0)
  801bcb:	85 db                	test   %ebx,%ebx
  801bcd:	74 0a                	je     801bd9 <devpipe_read+0x36>
				return i;
  801bcf:	89 d8                	mov    %ebx,%eax
}
  801bd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5f                   	pop    %edi
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801bd9:	89 f2                	mov    %esi,%edx
  801bdb:	89 f8                	mov    %edi,%eax
  801bdd:	e8 e9 fe ff ff       	call   801acb <_pipeisclosed>
  801be2:	85 c0                	test   %eax,%eax
  801be4:	75 28                	jne    801c0e <devpipe_read+0x6b>
			sys_yield();
  801be6:	e8 94 f0 ff ff       	call   800c7f <sys_yield>
  801beb:	eb d7                	jmp    801bc4 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bed:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801bf2:	78 0f                	js     801c03 <devpipe_read+0x60>
  801bf4:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801bf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bfb:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801bfe:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801c00:	43                   	inc    %ebx
  801c01:	eb bc                	jmp    801bbf <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c03:	48                   	dec    %eax
  801c04:	83 c8 e0             	or     $0xffffffe0,%eax
  801c07:	40                   	inc    %eax
  801c08:	eb ea                	jmp    801bf4 <devpipe_read+0x51>
	return i;
  801c0a:	89 d8                	mov    %ebx,%eax
  801c0c:	eb c3                	jmp    801bd1 <devpipe_read+0x2e>
				return 0;
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c13:	eb bc                	jmp    801bd1 <devpipe_read+0x2e>

00801c15 <pipe>:
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	56                   	push   %esi
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c20:	50                   	push   %eax
  801c21:	e8 1a f6 ff ff       	call   801240 <fd_alloc>
  801c26:	89 c3                	mov    %eax,%ebx
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	0f 88 2a 01 00 00    	js     801d5d <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	68 07 04 00 00       	push   $0x407
  801c3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3e:	6a 00                	push   $0x0
  801c40:	e8 73 ef ff ff       	call   800bb8 <sys_page_alloc>
  801c45:	89 c3                	mov    %eax,%ebx
  801c47:	83 c4 10             	add    $0x10,%esp
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	0f 88 0b 01 00 00    	js     801d5d <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801c52:	83 ec 0c             	sub    $0xc,%esp
  801c55:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c58:	50                   	push   %eax
  801c59:	e8 e2 f5 ff ff       	call   801240 <fd_alloc>
  801c5e:	89 c3                	mov    %eax,%ebx
  801c60:	83 c4 10             	add    $0x10,%esp
  801c63:	85 c0                	test   %eax,%eax
  801c65:	0f 88 e2 00 00 00    	js     801d4d <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	68 07 04 00 00       	push   $0x407
  801c73:	ff 75 f0             	pushl  -0x10(%ebp)
  801c76:	6a 00                	push   $0x0
  801c78:	e8 3b ef ff ff       	call   800bb8 <sys_page_alloc>
  801c7d:	89 c3                	mov    %eax,%ebx
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	85 c0                	test   %eax,%eax
  801c84:	0f 88 c3 00 00 00    	js     801d4d <pipe+0x138>
	va = fd2data(fd0);
  801c8a:	83 ec 0c             	sub    $0xc,%esp
  801c8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c90:	e8 94 f5 ff ff       	call   801229 <fd2data>
  801c95:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c97:	83 c4 0c             	add    $0xc,%esp
  801c9a:	68 07 04 00 00       	push   $0x407
  801c9f:	50                   	push   %eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	e8 11 ef ff ff       	call   800bb8 <sys_page_alloc>
  801ca7:	89 c3                	mov    %eax,%ebx
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	85 c0                	test   %eax,%eax
  801cae:	0f 88 89 00 00 00    	js     801d3d <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb4:	83 ec 0c             	sub    $0xc,%esp
  801cb7:	ff 75 f0             	pushl  -0x10(%ebp)
  801cba:	e8 6a f5 ff ff       	call   801229 <fd2data>
  801cbf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801cc6:	50                   	push   %eax
  801cc7:	6a 00                	push   $0x0
  801cc9:	56                   	push   %esi
  801cca:	6a 00                	push   $0x0
  801ccc:	e8 2a ef ff ff       	call   800bfb <sys_page_map>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	83 c4 20             	add    $0x20,%esp
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	78 55                	js     801d2f <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801cda:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801cef:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d04:	83 ec 0c             	sub    $0xc,%esp
  801d07:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0a:	e8 0a f5 ff ff       	call   801219 <fd2num>
  801d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d12:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d14:	83 c4 04             	add    $0x4,%esp
  801d17:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1a:	e8 fa f4 ff ff       	call   801219 <fd2num>
  801d1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d22:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d25:	83 c4 10             	add    $0x10,%esp
  801d28:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d2d:	eb 2e                	jmp    801d5d <pipe+0x148>
	sys_page_unmap(0, va);
  801d2f:	83 ec 08             	sub    $0x8,%esp
  801d32:	56                   	push   %esi
  801d33:	6a 00                	push   $0x0
  801d35:	e8 03 ef ff ff       	call   800c3d <sys_page_unmap>
  801d3a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d3d:	83 ec 08             	sub    $0x8,%esp
  801d40:	ff 75 f0             	pushl  -0x10(%ebp)
  801d43:	6a 00                	push   $0x0
  801d45:	e8 f3 ee ff ff       	call   800c3d <sys_page_unmap>
  801d4a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d4d:	83 ec 08             	sub    $0x8,%esp
  801d50:	ff 75 f4             	pushl  -0xc(%ebp)
  801d53:	6a 00                	push   $0x0
  801d55:	e8 e3 ee ff ff       	call   800c3d <sys_page_unmap>
  801d5a:	83 c4 10             	add    $0x10,%esp
}
  801d5d:	89 d8                	mov    %ebx,%eax
  801d5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d62:	5b                   	pop    %ebx
  801d63:	5e                   	pop    %esi
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    

00801d66 <pipeisclosed>:
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6f:	50                   	push   %eax
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	e8 17 f5 ff ff       	call   80128f <fd_lookup>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	78 18                	js     801d97 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d7f:	83 ec 0c             	sub    $0xc,%esp
  801d82:	ff 75 f4             	pushl  -0xc(%ebp)
  801d85:	e8 9f f4 ff ff       	call   801229 <fd2data>
	return _pipeisclosed(fd, p);
  801d8a:	89 c2                	mov    %eax,%edx
  801d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8f:	e8 37 fd ff ff       	call   801acb <_pipeisclosed>
  801d94:	83 c4 10             	add    $0x10,%esp
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    

00801da3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	53                   	push   %ebx
  801da7:	83 ec 0c             	sub    $0xc,%esp
  801daa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801dad:	68 e5 27 80 00       	push   $0x8027e5
  801db2:	53                   	push   %ebx
  801db3:	e8 4b ea ff ff       	call   800803 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801db8:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801dbf:	20 00 00 
	return 0;
}
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <devcons_write>:
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	57                   	push   %edi
  801dd0:	56                   	push   %esi
  801dd1:	53                   	push   %ebx
  801dd2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801dd8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ddd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801de3:	eb 1d                	jmp    801e02 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	53                   	push   %ebx
  801de9:	03 45 0c             	add    0xc(%ebp),%eax
  801dec:	50                   	push   %eax
  801ded:	57                   	push   %edi
  801dee:	e8 83 eb ff ff       	call   800976 <memmove>
		sys_cputs(buf, m);
  801df3:	83 c4 08             	add    $0x8,%esp
  801df6:	53                   	push   %ebx
  801df7:	57                   	push   %edi
  801df8:	e8 1e ed ff ff       	call   800b1b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801dfd:	01 de                	add    %ebx,%esi
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	89 f0                	mov    %esi,%eax
  801e04:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e07:	73 11                	jae    801e1a <devcons_write+0x4e>
		m = n - tot;
  801e09:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e0c:	29 f3                	sub    %esi,%ebx
  801e0e:	83 fb 7f             	cmp    $0x7f,%ebx
  801e11:	76 d2                	jbe    801de5 <devcons_write+0x19>
  801e13:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801e18:	eb cb                	jmp    801de5 <devcons_write+0x19>
}
  801e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1d:	5b                   	pop    %ebx
  801e1e:	5e                   	pop    %esi
  801e1f:	5f                   	pop    %edi
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    

00801e22 <devcons_read>:
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801e28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2c:	75 0c                	jne    801e3a <devcons_read+0x18>
		return 0;
  801e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e33:	eb 21                	jmp    801e56 <devcons_read+0x34>
		sys_yield();
  801e35:	e8 45 ee ff ff       	call   800c7f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e3a:	e8 fa ec ff ff       	call   800b39 <sys_cgetc>
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	74 f2                	je     801e35 <devcons_read+0x13>
	if (c < 0)
  801e43:	85 c0                	test   %eax,%eax
  801e45:	78 0f                	js     801e56 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801e47:	83 f8 04             	cmp    $0x4,%eax
  801e4a:	74 0c                	je     801e58 <devcons_read+0x36>
	*(char*)vbuf = c;
  801e4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4f:	88 02                	mov    %al,(%edx)
	return 1;
  801e51:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    
		return 0;
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5d:	eb f7                	jmp    801e56 <devcons_read+0x34>

00801e5f <cputchar>:
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e6b:	6a 01                	push   $0x1
  801e6d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e70:	50                   	push   %eax
  801e71:	e8 a5 ec ff ff       	call   800b1b <sys_cputs>
}
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <getchar>:
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e81:	6a 01                	push   $0x1
  801e83:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e86:	50                   	push   %eax
  801e87:	6a 00                	push   $0x0
  801e89:	e8 6e f6 ff ff       	call   8014fc <read>
	if (r < 0)
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	85 c0                	test   %eax,%eax
  801e93:	78 08                	js     801e9d <getchar+0x22>
	if (r < 1)
  801e95:	85 c0                	test   %eax,%eax
  801e97:	7e 06                	jle    801e9f <getchar+0x24>
	return c;
  801e99:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    
		return -E_EOF;
  801e9f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ea4:	eb f7                	jmp    801e9d <getchar+0x22>

00801ea6 <iscons>:
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eaf:	50                   	push   %eax
  801eb0:	ff 75 08             	pushl  0x8(%ebp)
  801eb3:	e8 d7 f3 ff ff       	call   80128f <fd_lookup>
  801eb8:	83 c4 10             	add    $0x10,%esp
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	78 11                	js     801ed0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ec8:	39 10                	cmp    %edx,(%eax)
  801eca:	0f 94 c0             	sete   %al
  801ecd:	0f b6 c0             	movzbl %al,%eax
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <opencons>:
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ed8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801edb:	50                   	push   %eax
  801edc:	e8 5f f3 ff ff       	call   801240 <fd_alloc>
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	78 3a                	js     801f22 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ee8:	83 ec 04             	sub    $0x4,%esp
  801eeb:	68 07 04 00 00       	push   $0x407
  801ef0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef3:	6a 00                	push   $0x0
  801ef5:	e8 be ec ff ff       	call   800bb8 <sys_page_alloc>
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	85 c0                	test   %eax,%eax
  801eff:	78 21                	js     801f22 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f01:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	50                   	push   %eax
  801f1a:	e8 fa f2 ff ff       	call   801219 <fd2num>
  801f1f:	83 c4 10             	add    $0x10,%esp
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	57                   	push   %edi
  801f28:	56                   	push   %esi
  801f29:	53                   	push   %ebx
  801f2a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801f30:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801f33:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801f39:	e8 5b ec ff ff       	call   800b99 <sys_getenvid>
  801f3e:	83 ec 04             	sub    $0x4,%esp
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	ff 75 08             	pushl  0x8(%ebp)
  801f47:	53                   	push   %ebx
  801f48:	50                   	push   %eax
  801f49:	68 f4 27 80 00       	push   $0x8027f4
  801f4e:	68 00 01 00 00       	push   $0x100
  801f53:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801f59:	56                   	push   %esi
  801f5a:	e8 57 e8 ff ff       	call   8007b6 <snprintf>
  801f5f:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801f61:	83 c4 20             	add    $0x20,%esp
  801f64:	57                   	push   %edi
  801f65:	ff 75 10             	pushl  0x10(%ebp)
  801f68:	bf 00 01 00 00       	mov    $0x100,%edi
  801f6d:	89 f8                	mov    %edi,%eax
  801f6f:	29 d8                	sub    %ebx,%eax
  801f71:	50                   	push   %eax
  801f72:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801f75:	50                   	push   %eax
  801f76:	e8 e6 e7 ff ff       	call   800761 <vsnprintf>
  801f7b:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801f7d:	83 c4 0c             	add    $0xc,%esp
  801f80:	68 de 27 80 00       	push   $0x8027de
  801f85:	29 df                	sub    %ebx,%edi
  801f87:	57                   	push   %edi
  801f88:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801f8b:	50                   	push   %eax
  801f8c:	e8 25 e8 ff ff       	call   8007b6 <snprintf>
	sys_cputs(buf, r);
  801f91:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801f94:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801f96:	53                   	push   %ebx
  801f97:	56                   	push   %esi
  801f98:	e8 7e eb ff ff       	call   800b1b <sys_cputs>
  801f9d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fa0:	cc                   	int3   
  801fa1:	eb fd                	jmp    801fa0 <_panic+0x7c>

00801fa3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fa9:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fb0:	74 0a                	je     801fbc <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801fbc:	e8 d8 eb ff ff       	call   800b99 <sys_getenvid>
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	6a 07                	push   $0x7
  801fc6:	68 00 f0 bf ee       	push   $0xeebff000
  801fcb:	50                   	push   %eax
  801fcc:	e8 e7 eb ff ff       	call   800bb8 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801fd1:	e8 c3 eb ff ff       	call   800b99 <sys_getenvid>
  801fd6:	83 c4 08             	add    $0x8,%esp
  801fd9:	68 e9 1f 80 00       	push   $0x801fe9
  801fde:	50                   	push   %eax
  801fdf:	e8 7f ed ff ff       	call   800d63 <sys_env_set_pgfault_upcall>
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	eb c9                	jmp    801fb2 <set_pgfault_handler+0xf>

00801fe9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801fe9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801fea:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801fef:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801ff1:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  801ff4:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801ff8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801ffc:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801fff:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802001:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  802005:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802008:	61                   	popa   
	addl $4, %esp
  802009:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80200c:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80200d:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80200e:	c3                   	ret    

0080200f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	c1 e8 16             	shr    $0x16,%eax
  802018:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80201f:	a8 01                	test   $0x1,%al
  802021:	74 21                	je     802044 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	c1 e8 0c             	shr    $0xc,%eax
  802029:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802030:	a8 01                	test   $0x1,%al
  802032:	74 17                	je     80204b <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802034:	c1 e8 0c             	shr    $0xc,%eax
  802037:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  80203e:	ef 
  80203f:	0f b7 c0             	movzwl %ax,%eax
  802042:	eb 05                	jmp    802049 <pageref+0x3a>
		return 0;
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802049:	5d                   	pop    %ebp
  80204a:	c3                   	ret    
		return 0;
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	eb f7                	jmp    802049 <pageref+0x3a>
  802052:	66 90                	xchg   %ax,%ax

00802054 <__udivdi3>:
  802054:	55                   	push   %ebp
  802055:	57                   	push   %edi
  802056:	56                   	push   %esi
  802057:	53                   	push   %ebx
  802058:	83 ec 1c             	sub    $0x1c,%esp
  80205b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80205f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802067:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80206b:	89 ca                	mov    %ecx,%edx
  80206d:	89 f8                	mov    %edi,%eax
  80206f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802073:	85 f6                	test   %esi,%esi
  802075:	75 2d                	jne    8020a4 <__udivdi3+0x50>
  802077:	39 cf                	cmp    %ecx,%edi
  802079:	77 65                	ja     8020e0 <__udivdi3+0x8c>
  80207b:	89 fd                	mov    %edi,%ebp
  80207d:	85 ff                	test   %edi,%edi
  80207f:	75 0b                	jne    80208c <__udivdi3+0x38>
  802081:	b8 01 00 00 00       	mov    $0x1,%eax
  802086:	31 d2                	xor    %edx,%edx
  802088:	f7 f7                	div    %edi
  80208a:	89 c5                	mov    %eax,%ebp
  80208c:	31 d2                	xor    %edx,%edx
  80208e:	89 c8                	mov    %ecx,%eax
  802090:	f7 f5                	div    %ebp
  802092:	89 c1                	mov    %eax,%ecx
  802094:	89 d8                	mov    %ebx,%eax
  802096:	f7 f5                	div    %ebp
  802098:	89 cf                	mov    %ecx,%edi
  80209a:	89 fa                	mov    %edi,%edx
  80209c:	83 c4 1c             	add    $0x1c,%esp
  80209f:	5b                   	pop    %ebx
  8020a0:	5e                   	pop    %esi
  8020a1:	5f                   	pop    %edi
  8020a2:	5d                   	pop    %ebp
  8020a3:	c3                   	ret    
  8020a4:	39 ce                	cmp    %ecx,%esi
  8020a6:	77 28                	ja     8020d0 <__udivdi3+0x7c>
  8020a8:	0f bd fe             	bsr    %esi,%edi
  8020ab:	83 f7 1f             	xor    $0x1f,%edi
  8020ae:	75 40                	jne    8020f0 <__udivdi3+0x9c>
  8020b0:	39 ce                	cmp    %ecx,%esi
  8020b2:	72 0a                	jb     8020be <__udivdi3+0x6a>
  8020b4:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8020b8:	0f 87 9e 00 00 00    	ja     80215c <__udivdi3+0x108>
  8020be:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c3:	89 fa                	mov    %edi,%edx
  8020c5:	83 c4 1c             	add    $0x1c,%esp
  8020c8:	5b                   	pop    %ebx
  8020c9:	5e                   	pop    %esi
  8020ca:	5f                   	pop    %edi
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    
  8020cd:	8d 76 00             	lea    0x0(%esi),%esi
  8020d0:	31 ff                	xor    %edi,%edi
  8020d2:	31 c0                	xor    %eax,%eax
  8020d4:	89 fa                	mov    %edi,%edx
  8020d6:	83 c4 1c             	add    $0x1c,%esp
  8020d9:	5b                   	pop    %ebx
  8020da:	5e                   	pop    %esi
  8020db:	5f                   	pop    %edi
  8020dc:	5d                   	pop    %ebp
  8020dd:	c3                   	ret    
  8020de:	66 90                	xchg   %ax,%ax
  8020e0:	89 d8                	mov    %ebx,%eax
  8020e2:	f7 f7                	div    %edi
  8020e4:	31 ff                	xor    %edi,%edi
  8020e6:	89 fa                	mov    %edi,%edx
  8020e8:	83 c4 1c             	add    $0x1c,%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5f                   	pop    %edi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    
  8020f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020f5:	29 fd                	sub    %edi,%ebp
  8020f7:	89 f9                	mov    %edi,%ecx
  8020f9:	d3 e6                	shl    %cl,%esi
  8020fb:	89 c3                	mov    %eax,%ebx
  8020fd:	89 e9                	mov    %ebp,%ecx
  8020ff:	d3 eb                	shr    %cl,%ebx
  802101:	89 d9                	mov    %ebx,%ecx
  802103:	09 f1                	or     %esi,%ecx
  802105:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802109:	89 f9                	mov    %edi,%ecx
  80210b:	d3 e0                	shl    %cl,%eax
  80210d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802111:	89 d6                	mov    %edx,%esi
  802113:	89 e9                	mov    %ebp,%ecx
  802115:	d3 ee                	shr    %cl,%esi
  802117:	89 f9                	mov    %edi,%ecx
  802119:	d3 e2                	shl    %cl,%edx
  80211b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80211f:	89 e9                	mov    %ebp,%ecx
  802121:	d3 eb                	shr    %cl,%ebx
  802123:	09 da                	or     %ebx,%edx
  802125:	89 d0                	mov    %edx,%eax
  802127:	89 f2                	mov    %esi,%edx
  802129:	f7 74 24 08          	divl   0x8(%esp)
  80212d:	89 d6                	mov    %edx,%esi
  80212f:	89 c3                	mov    %eax,%ebx
  802131:	f7 64 24 0c          	mull   0xc(%esp)
  802135:	39 d6                	cmp    %edx,%esi
  802137:	72 17                	jb     802150 <__udivdi3+0xfc>
  802139:	74 09                	je     802144 <__udivdi3+0xf0>
  80213b:	89 d8                	mov    %ebx,%eax
  80213d:	31 ff                	xor    %edi,%edi
  80213f:	e9 56 ff ff ff       	jmp    80209a <__udivdi3+0x46>
  802144:	8b 54 24 04          	mov    0x4(%esp),%edx
  802148:	89 f9                	mov    %edi,%ecx
  80214a:	d3 e2                	shl    %cl,%edx
  80214c:	39 c2                	cmp    %eax,%edx
  80214e:	73 eb                	jae    80213b <__udivdi3+0xe7>
  802150:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802153:	31 ff                	xor    %edi,%edi
  802155:	e9 40 ff ff ff       	jmp    80209a <__udivdi3+0x46>
  80215a:	66 90                	xchg   %ax,%ax
  80215c:	31 c0                	xor    %eax,%eax
  80215e:	e9 37 ff ff ff       	jmp    80209a <__udivdi3+0x46>
  802163:	90                   	nop

00802164 <__umoddi3>:
  802164:	55                   	push   %ebp
  802165:	57                   	push   %edi
  802166:	56                   	push   %esi
  802167:	53                   	push   %ebx
  802168:	83 ec 1c             	sub    $0x1c,%esp
  80216b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80216f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802173:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802177:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80217b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80217f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802183:	89 3c 24             	mov    %edi,(%esp)
  802186:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80218a:	89 f2                	mov    %esi,%edx
  80218c:	85 c0                	test   %eax,%eax
  80218e:	75 18                	jne    8021a8 <__umoddi3+0x44>
  802190:	39 f7                	cmp    %esi,%edi
  802192:	0f 86 a0 00 00 00    	jbe    802238 <__umoddi3+0xd4>
  802198:	89 c8                	mov    %ecx,%eax
  80219a:	f7 f7                	div    %edi
  80219c:	89 d0                	mov    %edx,%eax
  80219e:	31 d2                	xor    %edx,%edx
  8021a0:	83 c4 1c             	add    $0x1c,%esp
  8021a3:	5b                   	pop    %ebx
  8021a4:	5e                   	pop    %esi
  8021a5:	5f                   	pop    %edi
  8021a6:	5d                   	pop    %ebp
  8021a7:	c3                   	ret    
  8021a8:	89 f3                	mov    %esi,%ebx
  8021aa:	39 f0                	cmp    %esi,%eax
  8021ac:	0f 87 a6 00 00 00    	ja     802258 <__umoddi3+0xf4>
  8021b2:	0f bd e8             	bsr    %eax,%ebp
  8021b5:	83 f5 1f             	xor    $0x1f,%ebp
  8021b8:	0f 84 a6 00 00 00    	je     802264 <__umoddi3+0x100>
  8021be:	bf 20 00 00 00       	mov    $0x20,%edi
  8021c3:	29 ef                	sub    %ebp,%edi
  8021c5:	89 e9                	mov    %ebp,%ecx
  8021c7:	d3 e0                	shl    %cl,%eax
  8021c9:	8b 34 24             	mov    (%esp),%esi
  8021cc:	89 f2                	mov    %esi,%edx
  8021ce:	89 f9                	mov    %edi,%ecx
  8021d0:	d3 ea                	shr    %cl,%edx
  8021d2:	09 c2                	or     %eax,%edx
  8021d4:	89 14 24             	mov    %edx,(%esp)
  8021d7:	89 f2                	mov    %esi,%edx
  8021d9:	89 e9                	mov    %ebp,%ecx
  8021db:	d3 e2                	shl    %cl,%edx
  8021dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021e1:	89 de                	mov    %ebx,%esi
  8021e3:	89 f9                	mov    %edi,%ecx
  8021e5:	d3 ee                	shr    %cl,%esi
  8021e7:	89 e9                	mov    %ebp,%ecx
  8021e9:	d3 e3                	shl    %cl,%ebx
  8021eb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021ef:	89 d0                	mov    %edx,%eax
  8021f1:	89 f9                	mov    %edi,%ecx
  8021f3:	d3 e8                	shr    %cl,%eax
  8021f5:	09 d8                	or     %ebx,%eax
  8021f7:	89 d3                	mov    %edx,%ebx
  8021f9:	89 e9                	mov    %ebp,%ecx
  8021fb:	d3 e3                	shl    %cl,%ebx
  8021fd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802201:	89 f2                	mov    %esi,%edx
  802203:	f7 34 24             	divl   (%esp)
  802206:	89 d6                	mov    %edx,%esi
  802208:	f7 64 24 04          	mull   0x4(%esp)
  80220c:	89 c3                	mov    %eax,%ebx
  80220e:	89 d1                	mov    %edx,%ecx
  802210:	39 d6                	cmp    %edx,%esi
  802212:	72 7c                	jb     802290 <__umoddi3+0x12c>
  802214:	74 72                	je     802288 <__umoddi3+0x124>
  802216:	8b 54 24 08          	mov    0x8(%esp),%edx
  80221a:	29 da                	sub    %ebx,%edx
  80221c:	19 ce                	sbb    %ecx,%esi
  80221e:	89 f0                	mov    %esi,%eax
  802220:	89 f9                	mov    %edi,%ecx
  802222:	d3 e0                	shl    %cl,%eax
  802224:	89 e9                	mov    %ebp,%ecx
  802226:	d3 ea                	shr    %cl,%edx
  802228:	09 d0                	or     %edx,%eax
  80222a:	89 e9                	mov    %ebp,%ecx
  80222c:	d3 ee                	shr    %cl,%esi
  80222e:	89 f2                	mov    %esi,%edx
  802230:	83 c4 1c             	add    $0x1c,%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    
  802238:	89 fd                	mov    %edi,%ebp
  80223a:	85 ff                	test   %edi,%edi
  80223c:	75 0b                	jne    802249 <__umoddi3+0xe5>
  80223e:	b8 01 00 00 00       	mov    $0x1,%eax
  802243:	31 d2                	xor    %edx,%edx
  802245:	f7 f7                	div    %edi
  802247:	89 c5                	mov    %eax,%ebp
  802249:	89 f0                	mov    %esi,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f5                	div    %ebp
  80224f:	89 c8                	mov    %ecx,%eax
  802251:	f7 f5                	div    %ebp
  802253:	e9 44 ff ff ff       	jmp    80219c <__umoddi3+0x38>
  802258:	89 c8                	mov    %ecx,%eax
  80225a:	89 f2                	mov    %esi,%edx
  80225c:	83 c4 1c             	add    $0x1c,%esp
  80225f:	5b                   	pop    %ebx
  802260:	5e                   	pop    %esi
  802261:	5f                   	pop    %edi
  802262:	5d                   	pop    %ebp
  802263:	c3                   	ret    
  802264:	39 f0                	cmp    %esi,%eax
  802266:	72 05                	jb     80226d <__umoddi3+0x109>
  802268:	39 0c 24             	cmp    %ecx,(%esp)
  80226b:	77 0c                	ja     802279 <__umoddi3+0x115>
  80226d:	89 f2                	mov    %esi,%edx
  80226f:	29 f9                	sub    %edi,%ecx
  802271:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802275:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802279:	8b 44 24 04          	mov    0x4(%esp),%eax
  80227d:	83 c4 1c             	add    $0x1c,%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5f                   	pop    %edi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    
  802285:	8d 76 00             	lea    0x0(%esi),%esi
  802288:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80228c:	73 88                	jae    802216 <__umoddi3+0xb2>
  80228e:	66 90                	xchg   %ax,%ax
  802290:	2b 44 24 04          	sub    0x4(%esp),%eax
  802294:	1b 14 24             	sbb    (%esp),%edx
  802297:	89 d1                	mov    %edx,%ecx
  802299:	89 c3                	mov    %eax,%ebx
  80229b:	e9 76 ff ff ff       	jmp    802216 <__umoddi3+0xb2>
