
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
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
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 f9 0a 00 00       	call   800b39 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 40 80 00 7c 	cmpl   $0xeec0007c,0x804004
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 71 1f 80 00       	push   $0x801f71
  80005d:	e8 39 01 00 00       	call   80019b <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 20 0e 00 00       	call   800e96 <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 82 0d 00 00       	call   800e0d <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 60 1f 80 00       	push   $0x801f60
  800097:	e8 ff 00 00 00       	call   80019b <cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb dd                	jmp    80007e <umain+0x4b>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 88 0a 00 00       	call   800b39 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	89 c2                	mov    %eax,%edx
  8000b8:	c1 e2 05             	shl    $0x5,%edx
  8000bb:	29 c2                	sub    %eax,%edx
  8000bd:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000c4:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c9:	85 db                	test   %ebx,%ebx
  8000cb:	7e 07                	jle    8000d4 <libmain+0x33>
		binaryname = argv[0];
  8000cd:	8b 06                	mov    (%esi),%eax
  8000cf:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d4:	83 ec 08             	sub    $0x8,%esp
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	e8 55 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000de:	e8 0a 00 00 00       	call   8000ed <exit>
}
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f3:	e8 10 10 00 00       	call   801108 <close_all>
	sys_env_destroy(0);
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	6a 00                	push   $0x0
  8000fd:	e8 f6 09 00 00       	call   800af8 <sys_env_destroy>
}
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	c9                   	leave  
  800106:	c3                   	ret    

00800107 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	53                   	push   %ebx
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800111:	8b 13                	mov    (%ebx),%edx
  800113:	8d 42 01             	lea    0x1(%edx),%eax
  800116:	89 03                	mov    %eax,(%ebx)
  800118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800124:	74 08                	je     80012e <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800126:	ff 43 04             	incl   0x4(%ebx)
}
  800129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012c:	c9                   	leave  
  80012d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80012e:	83 ec 08             	sub    $0x8,%esp
  800131:	68 ff 00 00 00       	push   $0xff
  800136:	8d 43 08             	lea    0x8(%ebx),%eax
  800139:	50                   	push   %eax
  80013a:	e8 7c 09 00 00       	call   800abb <sys_cputs>
		b->idx = 0;
  80013f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	eb dc                	jmp    800126 <putch+0x1f>

0080014a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800153:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015a:	00 00 00 
	b.cnt = 0;
  80015d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800164:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800167:	ff 75 0c             	pushl  0xc(%ebp)
  80016a:	ff 75 08             	pushl  0x8(%ebp)
  80016d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800173:	50                   	push   %eax
  800174:	68 07 01 80 00       	push   $0x800107
  800179:	e8 17 01 00 00       	call   800295 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017e:	83 c4 08             	add    $0x8,%esp
  800181:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800187:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	e8 28 09 00 00       	call   800abb <sys_cputs>

	return b.cnt;
}
  800193:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800199:	c9                   	leave  
  80019a:	c3                   	ret    

0080019b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a4:	50                   	push   %eax
  8001a5:	ff 75 08             	pushl  0x8(%ebp)
  8001a8:	e8 9d ff ff ff       	call   80014a <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ad:	c9                   	leave  
  8001ae:	c3                   	ret    

008001af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	57                   	push   %edi
  8001b3:	56                   	push   %esi
  8001b4:	53                   	push   %ebx
  8001b5:	83 ec 1c             	sub    $0x1c,%esp
  8001b8:	89 c7                	mov    %eax,%edi
  8001ba:	89 d6                	mov    %edx,%esi
  8001bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001d3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d6:	39 d3                	cmp    %edx,%ebx
  8001d8:	72 05                	jb     8001df <printnum+0x30>
  8001da:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001dd:	77 78                	ja     800257 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	ff 75 18             	pushl  0x18(%ebp)
  8001e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8001e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001eb:	53                   	push   %ebx
  8001ec:	ff 75 10             	pushl  0x10(%ebp)
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8001fe:	e8 01 1b 00 00       	call   801d04 <__udivdi3>
  800203:	83 c4 18             	add    $0x18,%esp
  800206:	52                   	push   %edx
  800207:	50                   	push   %eax
  800208:	89 f2                	mov    %esi,%edx
  80020a:	89 f8                	mov    %edi,%eax
  80020c:	e8 9e ff ff ff       	call   8001af <printnum>
  800211:	83 c4 20             	add    $0x20,%esp
  800214:	eb 11                	jmp    800227 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800216:	83 ec 08             	sub    $0x8,%esp
  800219:	56                   	push   %esi
  80021a:	ff 75 18             	pushl  0x18(%ebp)
  80021d:	ff d7                	call   *%edi
  80021f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800222:	4b                   	dec    %ebx
  800223:	85 db                	test   %ebx,%ebx
  800225:	7f ef                	jg     800216 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	56                   	push   %esi
  80022b:	83 ec 04             	sub    $0x4,%esp
  80022e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800231:	ff 75 e0             	pushl  -0x20(%ebp)
  800234:	ff 75 dc             	pushl  -0x24(%ebp)
  800237:	ff 75 d8             	pushl  -0x28(%ebp)
  80023a:	e8 d5 1b 00 00       	call   801e14 <__umoddi3>
  80023f:	83 c4 14             	add    $0x14,%esp
  800242:	0f be 80 92 1f 80 00 	movsbl 0x801f92(%eax),%eax
  800249:	50                   	push   %eax
  80024a:	ff d7                	call   *%edi
}
  80024c:	83 c4 10             	add    $0x10,%esp
  80024f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800252:	5b                   	pop    %ebx
  800253:	5e                   	pop    %esi
  800254:	5f                   	pop    %edi
  800255:	5d                   	pop    %ebp
  800256:	c3                   	ret    
  800257:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80025a:	eb c6                	jmp    800222 <printnum+0x73>

0080025c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800262:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800265:	8b 10                	mov    (%eax),%edx
  800267:	3b 50 04             	cmp    0x4(%eax),%edx
  80026a:	73 0a                	jae    800276 <sprintputch+0x1a>
		*b->buf++ = ch;
  80026c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80026f:	89 08                	mov    %ecx,(%eax)
  800271:	8b 45 08             	mov    0x8(%ebp),%eax
  800274:	88 02                	mov    %al,(%edx)
}
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <printfmt>:
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80027e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800281:	50                   	push   %eax
  800282:	ff 75 10             	pushl  0x10(%ebp)
  800285:	ff 75 0c             	pushl  0xc(%ebp)
  800288:	ff 75 08             	pushl  0x8(%ebp)
  80028b:	e8 05 00 00 00       	call   800295 <vprintfmt>
}
  800290:	83 c4 10             	add    $0x10,%esp
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <vprintfmt>:
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	57                   	push   %edi
  800299:	56                   	push   %esi
  80029a:	53                   	push   %ebx
  80029b:	83 ec 2c             	sub    $0x2c,%esp
  80029e:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a7:	e9 ae 03 00 00       	jmp    80065a <vprintfmt+0x3c5>
  8002ac:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002b0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002b7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002c5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002ca:	8d 47 01             	lea    0x1(%edi),%eax
  8002cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002d0:	8a 17                	mov    (%edi),%dl
  8002d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d5:	3c 55                	cmp    $0x55,%al
  8002d7:	0f 87 fe 03 00 00    	ja     8006db <vprintfmt+0x446>
  8002dd:	0f b6 c0             	movzbl %al,%eax
  8002e0:	ff 24 85 e0 20 80 00 	jmp    *0x8020e0(,%eax,4)
  8002e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002ea:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ee:	eb da                	jmp    8002ca <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002f3:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002f7:	eb d1                	jmp    8002ca <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f9:	0f b6 d2             	movzbl %dl,%edx
  8002fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800304:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800307:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030a:	01 c0                	add    %eax,%eax
  80030c:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800310:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800313:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800316:	83 f9 09             	cmp    $0x9,%ecx
  800319:	77 52                	ja     80036d <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80031b:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80031c:	eb e9                	jmp    800307 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  80031e:	8b 45 14             	mov    0x14(%ebp),%eax
  800321:	8b 00                	mov    (%eax),%eax
  800323:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800326:	8b 45 14             	mov    0x14(%ebp),%eax
  800329:	8d 40 04             	lea    0x4(%eax),%eax
  80032c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800332:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800336:	79 92                	jns    8002ca <vprintfmt+0x35>
				width = precision, precision = -1;
  800338:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80033b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800345:	eb 83                	jmp    8002ca <vprintfmt+0x35>
  800347:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034b:	78 08                	js     800355 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800350:	e9 75 ff ff ff       	jmp    8002ca <vprintfmt+0x35>
  800355:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80035c:	eb ef                	jmp    80034d <vprintfmt+0xb8>
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800361:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800368:	e9 5d ff ff ff       	jmp    8002ca <vprintfmt+0x35>
  80036d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800370:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800373:	eb bd                	jmp    800332 <vprintfmt+0x9d>
			lflag++;
  800375:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800379:	e9 4c ff ff ff       	jmp    8002ca <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80037e:	8b 45 14             	mov    0x14(%ebp),%eax
  800381:	8d 78 04             	lea    0x4(%eax),%edi
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	53                   	push   %ebx
  800388:	ff 30                	pushl  (%eax)
  80038a:	ff d6                	call   *%esi
			break;
  80038c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80038f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800392:	e9 c0 02 00 00       	jmp    800657 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800397:	8b 45 14             	mov    0x14(%ebp),%eax
  80039a:	8d 78 04             	lea    0x4(%eax),%edi
  80039d:	8b 00                	mov    (%eax),%eax
  80039f:	85 c0                	test   %eax,%eax
  8003a1:	78 2a                	js     8003cd <vprintfmt+0x138>
  8003a3:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a5:	83 f8 0f             	cmp    $0xf,%eax
  8003a8:	7f 27                	jg     8003d1 <vprintfmt+0x13c>
  8003aa:	8b 04 85 40 22 80 00 	mov    0x802240(,%eax,4),%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	74 1c                	je     8003d1 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8003b5:	50                   	push   %eax
  8003b6:	68 01 23 80 00       	push   $0x802301
  8003bb:	53                   	push   %ebx
  8003bc:	56                   	push   %esi
  8003bd:	e8 b6 fe ff ff       	call   800278 <printfmt>
  8003c2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c8:	e9 8a 02 00 00       	jmp    800657 <vprintfmt+0x3c2>
  8003cd:	f7 d8                	neg    %eax
  8003cf:	eb d2                	jmp    8003a3 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8003d1:	52                   	push   %edx
  8003d2:	68 aa 1f 80 00       	push   $0x801faa
  8003d7:	53                   	push   %ebx
  8003d8:	56                   	push   %esi
  8003d9:	e8 9a fe ff ff       	call   800278 <printfmt>
  8003de:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e4:	e9 6e 02 00 00       	jmp    800657 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	83 c0 04             	add    $0x4,%eax
  8003ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f5:	8b 38                	mov    (%eax),%edi
  8003f7:	85 ff                	test   %edi,%edi
  8003f9:	74 39                	je     800434 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8003fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ff:	0f 8e a9 00 00 00    	jle    8004ae <vprintfmt+0x219>
  800405:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800409:	0f 84 a7 00 00 00    	je     8004b6 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	ff 75 d0             	pushl  -0x30(%ebp)
  800415:	57                   	push   %edi
  800416:	e8 6b 03 00 00       	call   800786 <strnlen>
  80041b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80041e:	29 c1                	sub    %eax,%ecx
  800420:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800423:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800426:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80042a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800430:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800432:	eb 14                	jmp    800448 <vprintfmt+0x1b3>
				p = "(null)";
  800434:	bf a3 1f 80 00       	mov    $0x801fa3,%edi
  800439:	eb c0                	jmp    8003fb <vprintfmt+0x166>
					putch(padc, putdat);
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	53                   	push   %ebx
  80043f:	ff 75 e0             	pushl  -0x20(%ebp)
  800442:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800444:	4f                   	dec    %edi
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	85 ff                	test   %edi,%edi
  80044a:	7f ef                	jg     80043b <vprintfmt+0x1a6>
  80044c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80044f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800452:	89 c8                	mov    %ecx,%eax
  800454:	85 c9                	test   %ecx,%ecx
  800456:	78 10                	js     800468 <vprintfmt+0x1d3>
  800458:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80045b:	29 c1                	sub    %eax,%ecx
  80045d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800460:	89 75 08             	mov    %esi,0x8(%ebp)
  800463:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800466:	eb 15                	jmp    80047d <vprintfmt+0x1e8>
  800468:	b8 00 00 00 00       	mov    $0x0,%eax
  80046d:	eb e9                	jmp    800458 <vprintfmt+0x1c3>
					putch(ch, putdat);
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	53                   	push   %ebx
  800473:	52                   	push   %edx
  800474:	ff 55 08             	call   *0x8(%ebp)
  800477:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80047a:	ff 4d e0             	decl   -0x20(%ebp)
  80047d:	47                   	inc    %edi
  80047e:	8a 47 ff             	mov    -0x1(%edi),%al
  800481:	0f be d0             	movsbl %al,%edx
  800484:	85 d2                	test   %edx,%edx
  800486:	74 59                	je     8004e1 <vprintfmt+0x24c>
  800488:	85 f6                	test   %esi,%esi
  80048a:	78 03                	js     80048f <vprintfmt+0x1fa>
  80048c:	4e                   	dec    %esi
  80048d:	78 2f                	js     8004be <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80048f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800493:	74 da                	je     80046f <vprintfmt+0x1da>
  800495:	0f be c0             	movsbl %al,%eax
  800498:	83 e8 20             	sub    $0x20,%eax
  80049b:	83 f8 5e             	cmp    $0x5e,%eax
  80049e:	76 cf                	jbe    80046f <vprintfmt+0x1da>
					putch('?', putdat);
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	6a 3f                	push   $0x3f
  8004a6:	ff 55 08             	call   *0x8(%ebp)
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	eb cc                	jmp    80047a <vprintfmt+0x1e5>
  8004ae:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004b4:	eb c7                	jmp    80047d <vprintfmt+0x1e8>
  8004b6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004bc:	eb bf                	jmp    80047d <vprintfmt+0x1e8>
  8004be:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004c4:	eb 0c                	jmp    8004d2 <vprintfmt+0x23d>
				putch(' ', putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	53                   	push   %ebx
  8004ca:	6a 20                	push   $0x20
  8004cc:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ce:	4f                   	dec    %edi
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	85 ff                	test   %edi,%edi
  8004d4:	7f f0                	jg     8004c6 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004dc:	e9 76 01 00 00       	jmp    800657 <vprintfmt+0x3c2>
  8004e1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e7:	eb e9                	jmp    8004d2 <vprintfmt+0x23d>
	if (lflag >= 2)
  8004e9:	83 f9 01             	cmp    $0x1,%ecx
  8004ec:	7f 1f                	jg     80050d <vprintfmt+0x278>
	else if (lflag)
  8004ee:	85 c9                	test   %ecx,%ecx
  8004f0:	75 48                	jne    80053a <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fa:	89 c1                	mov    %eax,%ecx
  8004fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8004ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	8d 40 04             	lea    0x4(%eax),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	eb 17                	jmp    800524 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 50 04             	mov    0x4(%eax),%edx
  800513:	8b 00                	mov    (%eax),%eax
  800515:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800518:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8d 40 08             	lea    0x8(%eax),%eax
  800521:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800524:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800527:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80052a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80052e:	78 25                	js     800555 <vprintfmt+0x2c0>
			base = 10;
  800530:	b8 0a 00 00 00       	mov    $0xa,%eax
  800535:	e9 03 01 00 00       	jmp    80063d <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800542:	89 c1                	mov    %eax,%ecx
  800544:	c1 f9 1f             	sar    $0x1f,%ecx
  800547:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8d 40 04             	lea    0x4(%eax),%eax
  800550:	89 45 14             	mov    %eax,0x14(%ebp)
  800553:	eb cf                	jmp    800524 <vprintfmt+0x28f>
				putch('-', putdat);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	53                   	push   %ebx
  800559:	6a 2d                	push   $0x2d
  80055b:	ff d6                	call   *%esi
				num = -(long long) num;
  80055d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800560:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800563:	f7 da                	neg    %edx
  800565:	83 d1 00             	adc    $0x0,%ecx
  800568:	f7 d9                	neg    %ecx
  80056a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80056d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800572:	e9 c6 00 00 00       	jmp    80063d <vprintfmt+0x3a8>
	if (lflag >= 2)
  800577:	83 f9 01             	cmp    $0x1,%ecx
  80057a:	7f 1e                	jg     80059a <vprintfmt+0x305>
	else if (lflag)
  80057c:	85 c9                	test   %ecx,%ecx
  80057e:	75 32                	jne    8005b2 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 10                	mov    (%eax),%edx
  800585:	b9 00 00 00 00       	mov    $0x0,%ecx
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800590:	b8 0a 00 00 00       	mov    $0xa,%eax
  800595:	e9 a3 00 00 00       	jmp    80063d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 10                	mov    (%eax),%edx
  80059f:	8b 48 04             	mov    0x4(%eax),%ecx
  8005a2:	8d 40 08             	lea    0x8(%eax),%eax
  8005a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ad:	e9 8b 00 00 00       	jmp    80063d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 10                	mov    (%eax),%edx
  8005b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bc:	8d 40 04             	lea    0x4(%eax),%eax
  8005bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c7:	eb 74                	jmp    80063d <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005c9:	83 f9 01             	cmp    $0x1,%ecx
  8005cc:	7f 1b                	jg     8005e9 <vprintfmt+0x354>
	else if (lflag)
  8005ce:	85 c9                	test   %ecx,%ecx
  8005d0:	75 2c                	jne    8005fe <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 10                	mov    (%eax),%edx
  8005d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005dc:	8d 40 04             	lea    0x4(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005e2:	b8 08 00 00 00       	mov    $0x8,%eax
  8005e7:	eb 54                	jmp    80063d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 10                	mov    (%eax),%edx
  8005ee:	8b 48 04             	mov    0x4(%eax),%ecx
  8005f1:	8d 40 08             	lea    0x8(%eax),%eax
  8005f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8005fc:	eb 3f                	jmp    80063d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8b 10                	mov    (%eax),%edx
  800603:	b9 00 00 00 00       	mov    $0x0,%ecx
  800608:	8d 40 04             	lea    0x4(%eax),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060e:	b8 08 00 00 00       	mov    $0x8,%eax
  800613:	eb 28                	jmp    80063d <vprintfmt+0x3a8>
			putch('0', putdat);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	53                   	push   %ebx
  800619:	6a 30                	push   $0x30
  80061b:	ff d6                	call   *%esi
			putch('x', putdat);
  80061d:	83 c4 08             	add    $0x8,%esp
  800620:	53                   	push   %ebx
  800621:	6a 78                	push   $0x78
  800623:	ff d6                	call   *%esi
			num = (unsigned long long)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 10                	mov    (%eax),%edx
  80062a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80062f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800638:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80063d:	83 ec 0c             	sub    $0xc,%esp
  800640:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800644:	57                   	push   %edi
  800645:	ff 75 e0             	pushl  -0x20(%ebp)
  800648:	50                   	push   %eax
  800649:	51                   	push   %ecx
  80064a:	52                   	push   %edx
  80064b:	89 da                	mov    %ebx,%edx
  80064d:	89 f0                	mov    %esi,%eax
  80064f:	e8 5b fb ff ff       	call   8001af <printnum>
			break;
  800654:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800657:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065a:	47                   	inc    %edi
  80065b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065f:	83 f8 25             	cmp    $0x25,%eax
  800662:	0f 84 44 fc ff ff    	je     8002ac <vprintfmt+0x17>
			if (ch == '\0')
  800668:	85 c0                	test   %eax,%eax
  80066a:	0f 84 89 00 00 00    	je     8006f9 <vprintfmt+0x464>
			putch(ch, putdat);
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	53                   	push   %ebx
  800674:	50                   	push   %eax
  800675:	ff d6                	call   *%esi
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	eb de                	jmp    80065a <vprintfmt+0x3c5>
	if (lflag >= 2)
  80067c:	83 f9 01             	cmp    $0x1,%ecx
  80067f:	7f 1b                	jg     80069c <vprintfmt+0x407>
	else if (lflag)
  800681:	85 c9                	test   %ecx,%ecx
  800683:	75 2c                	jne    8006b1 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 10                	mov    (%eax),%edx
  80068a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800695:	b8 10 00 00 00       	mov    $0x10,%eax
  80069a:	eb a1                	jmp    80063d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 10                	mov    (%eax),%edx
  8006a1:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a4:	8d 40 08             	lea    0x8(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006aa:	b8 10 00 00 00       	mov    $0x10,%eax
  8006af:	eb 8c                	jmp    80063d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 10                	mov    (%eax),%edx
  8006b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bb:	8d 40 04             	lea    0x4(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c1:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c6:	e9 72 ff ff ff       	jmp    80063d <vprintfmt+0x3a8>
			putch(ch, putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	6a 25                	push   $0x25
  8006d1:	ff d6                	call   *%esi
			break;
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	e9 7c ff ff ff       	jmp    800657 <vprintfmt+0x3c2>
			putch('%', putdat);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	6a 25                	push   $0x25
  8006e1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	89 f8                	mov    %edi,%eax
  8006e8:	eb 01                	jmp    8006eb <vprintfmt+0x456>
  8006ea:	48                   	dec    %eax
  8006eb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ef:	75 f9                	jne    8006ea <vprintfmt+0x455>
  8006f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f4:	e9 5e ff ff ff       	jmp    800657 <vprintfmt+0x3c2>
}
  8006f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fc:	5b                   	pop    %ebx
  8006fd:	5e                   	pop    %esi
  8006fe:	5f                   	pop    %edi
  8006ff:	5d                   	pop    %ebp
  800700:	c3                   	ret    

00800701 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
  800704:	83 ec 18             	sub    $0x18,%esp
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800710:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800714:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800717:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071e:	85 c0                	test   %eax,%eax
  800720:	74 26                	je     800748 <vsnprintf+0x47>
  800722:	85 d2                	test   %edx,%edx
  800724:	7e 29                	jle    80074f <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800726:	ff 75 14             	pushl  0x14(%ebp)
  800729:	ff 75 10             	pushl  0x10(%ebp)
  80072c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072f:	50                   	push   %eax
  800730:	68 5c 02 80 00       	push   $0x80025c
  800735:	e8 5b fb ff ff       	call   800295 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80073d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800743:	83 c4 10             	add    $0x10,%esp
}
  800746:	c9                   	leave  
  800747:	c3                   	ret    
		return -E_INVAL;
  800748:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074d:	eb f7                	jmp    800746 <vsnprintf+0x45>
  80074f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800754:	eb f0                	jmp    800746 <vsnprintf+0x45>

00800756 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80075c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80075f:	50                   	push   %eax
  800760:	ff 75 10             	pushl  0x10(%ebp)
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	ff 75 08             	pushl  0x8(%ebp)
  800769:	e8 93 ff ff ff       	call   800701 <vsnprintf>
	va_end(ap);

	return rc;
}
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    

00800770 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800776:	b8 00 00 00 00       	mov    $0x0,%eax
  80077b:	eb 01                	jmp    80077e <strlen+0xe>
		n++;
  80077d:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80077e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800782:	75 f9                	jne    80077d <strlen+0xd>
	return n;
}
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80078c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078f:	b8 00 00 00 00       	mov    $0x0,%eax
  800794:	eb 01                	jmp    800797 <strnlen+0x11>
		n++;
  800796:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800797:	39 d0                	cmp    %edx,%eax
  800799:	74 06                	je     8007a1 <strnlen+0x1b>
  80079b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80079f:	75 f5                	jne    800796 <strnlen+0x10>
	return n;
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	53                   	push   %ebx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ad:	89 c2                	mov    %eax,%edx
  8007af:	42                   	inc    %edx
  8007b0:	41                   	inc    %ecx
  8007b1:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8007b4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007b7:	84 db                	test   %bl,%bl
  8007b9:	75 f4                	jne    8007af <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007bb:	5b                   	pop    %ebx
  8007bc:	5d                   	pop    %ebp
  8007bd:	c3                   	ret    

008007be <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	53                   	push   %ebx
  8007c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c5:	53                   	push   %ebx
  8007c6:	e8 a5 ff ff ff       	call   800770 <strlen>
  8007cb:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	01 d8                	add    %ebx,%eax
  8007d3:	50                   	push   %eax
  8007d4:	e8 ca ff ff ff       	call   8007a3 <strcpy>
	return dst;
}
  8007d9:	89 d8                	mov    %ebx,%eax
  8007db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007de:	c9                   	leave  
  8007df:	c3                   	ret    

008007e0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	56                   	push   %esi
  8007e4:	53                   	push   %ebx
  8007e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007eb:	89 f3                	mov    %esi,%ebx
  8007ed:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f0:	89 f2                	mov    %esi,%edx
  8007f2:	eb 0c                	jmp    800800 <strncpy+0x20>
		*dst++ = *src;
  8007f4:	42                   	inc    %edx
  8007f5:	8a 01                	mov    (%ecx),%al
  8007f7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007fa:	80 39 01             	cmpb   $0x1,(%ecx)
  8007fd:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800800:	39 da                	cmp    %ebx,%edx
  800802:	75 f0                	jne    8007f4 <strncpy+0x14>
	}
	return ret;
}
  800804:	89 f0                	mov    %esi,%eax
  800806:	5b                   	pop    %ebx
  800807:	5e                   	pop    %esi
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	56                   	push   %esi
  80080e:	53                   	push   %ebx
  80080f:	8b 75 08             	mov    0x8(%ebp),%esi
  800812:	8b 55 0c             	mov    0xc(%ebp),%edx
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800818:	85 c0                	test   %eax,%eax
  80081a:	74 20                	je     80083c <strlcpy+0x32>
  80081c:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800820:	89 f0                	mov    %esi,%eax
  800822:	eb 05                	jmp    800829 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800824:	40                   	inc    %eax
  800825:	42                   	inc    %edx
  800826:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800829:	39 d8                	cmp    %ebx,%eax
  80082b:	74 06                	je     800833 <strlcpy+0x29>
  80082d:	8a 0a                	mov    (%edx),%cl
  80082f:	84 c9                	test   %cl,%cl
  800831:	75 f1                	jne    800824 <strlcpy+0x1a>
		*dst = '\0';
  800833:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800836:	29 f0                	sub    %esi,%eax
}
  800838:	5b                   	pop    %ebx
  800839:	5e                   	pop    %esi
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    
  80083c:	89 f0                	mov    %esi,%eax
  80083e:	eb f6                	jmp    800836 <strlcpy+0x2c>

00800840 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800846:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800849:	eb 02                	jmp    80084d <strcmp+0xd>
		p++, q++;
  80084b:	41                   	inc    %ecx
  80084c:	42                   	inc    %edx
	while (*p && *p == *q)
  80084d:	8a 01                	mov    (%ecx),%al
  80084f:	84 c0                	test   %al,%al
  800851:	74 04                	je     800857 <strcmp+0x17>
  800853:	3a 02                	cmp    (%edx),%al
  800855:	74 f4                	je     80084b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800857:	0f b6 c0             	movzbl %al,%eax
  80085a:	0f b6 12             	movzbl (%edx),%edx
  80085d:	29 d0                	sub    %edx,%eax
}
  80085f:	5d                   	pop    %ebp
  800860:	c3                   	ret    

00800861 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	53                   	push   %ebx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086b:	89 c3                	mov    %eax,%ebx
  80086d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800870:	eb 02                	jmp    800874 <strncmp+0x13>
		n--, p++, q++;
  800872:	40                   	inc    %eax
  800873:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800874:	39 d8                	cmp    %ebx,%eax
  800876:	74 15                	je     80088d <strncmp+0x2c>
  800878:	8a 08                	mov    (%eax),%cl
  80087a:	84 c9                	test   %cl,%cl
  80087c:	74 04                	je     800882 <strncmp+0x21>
  80087e:	3a 0a                	cmp    (%edx),%cl
  800880:	74 f0                	je     800872 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800882:	0f b6 00             	movzbl (%eax),%eax
  800885:	0f b6 12             	movzbl (%edx),%edx
  800888:	29 d0                	sub    %edx,%eax
}
  80088a:	5b                   	pop    %ebx
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    
		return 0;
  80088d:	b8 00 00 00 00       	mov    $0x0,%eax
  800892:	eb f6                	jmp    80088a <strncmp+0x29>

00800894 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80089d:	8a 10                	mov    (%eax),%dl
  80089f:	84 d2                	test   %dl,%dl
  8008a1:	74 07                	je     8008aa <strchr+0x16>
		if (*s == c)
  8008a3:	38 ca                	cmp    %cl,%dl
  8008a5:	74 08                	je     8008af <strchr+0x1b>
	for (; *s; s++)
  8008a7:	40                   	inc    %eax
  8008a8:	eb f3                	jmp    80089d <strchr+0x9>
			return (char *) s;
	return 0;
  8008aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008ba:	8a 10                	mov    (%eax),%dl
  8008bc:	84 d2                	test   %dl,%dl
  8008be:	74 07                	je     8008c7 <strfind+0x16>
		if (*s == c)
  8008c0:	38 ca                	cmp    %cl,%dl
  8008c2:	74 03                	je     8008c7 <strfind+0x16>
	for (; *s; s++)
  8008c4:	40                   	inc    %eax
  8008c5:	eb f3                	jmp    8008ba <strfind+0x9>
			break;
	return (char *) s;
}
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	57                   	push   %edi
  8008cd:	56                   	push   %esi
  8008ce:	53                   	push   %ebx
  8008cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008d5:	85 c9                	test   %ecx,%ecx
  8008d7:	74 13                	je     8008ec <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008d9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008df:	75 05                	jne    8008e6 <memset+0x1d>
  8008e1:	f6 c1 03             	test   $0x3,%cl
  8008e4:	74 0d                	je     8008f3 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e9:	fc                   	cld    
  8008ea:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008ec:	89 f8                	mov    %edi,%eax
  8008ee:	5b                   	pop    %ebx
  8008ef:	5e                   	pop    %esi
  8008f0:	5f                   	pop    %edi
  8008f1:	5d                   	pop    %ebp
  8008f2:	c3                   	ret    
		c &= 0xFF;
  8008f3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008f7:	89 d3                	mov    %edx,%ebx
  8008f9:	c1 e3 08             	shl    $0x8,%ebx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	c1 e0 18             	shl    $0x18,%eax
  800901:	89 d6                	mov    %edx,%esi
  800903:	c1 e6 10             	shl    $0x10,%esi
  800906:	09 f0                	or     %esi,%eax
  800908:	09 c2                	or     %eax,%edx
  80090a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80090c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80090f:	89 d0                	mov    %edx,%eax
  800911:	fc                   	cld    
  800912:	f3 ab                	rep stos %eax,%es:(%edi)
  800914:	eb d6                	jmp    8008ec <memset+0x23>

00800916 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	57                   	push   %edi
  80091a:	56                   	push   %esi
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800921:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800924:	39 c6                	cmp    %eax,%esi
  800926:	73 33                	jae    80095b <memmove+0x45>
  800928:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80092b:	39 d0                	cmp    %edx,%eax
  80092d:	73 2c                	jae    80095b <memmove+0x45>
		s += n;
		d += n;
  80092f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800932:	89 d6                	mov    %edx,%esi
  800934:	09 fe                	or     %edi,%esi
  800936:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80093c:	75 13                	jne    800951 <memmove+0x3b>
  80093e:	f6 c1 03             	test   $0x3,%cl
  800941:	75 0e                	jne    800951 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800943:	83 ef 04             	sub    $0x4,%edi
  800946:	8d 72 fc             	lea    -0x4(%edx),%esi
  800949:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80094c:	fd                   	std    
  80094d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80094f:	eb 07                	jmp    800958 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800951:	4f                   	dec    %edi
  800952:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800955:	fd                   	std    
  800956:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800958:	fc                   	cld    
  800959:	eb 13                	jmp    80096e <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095b:	89 f2                	mov    %esi,%edx
  80095d:	09 c2                	or     %eax,%edx
  80095f:	f6 c2 03             	test   $0x3,%dl
  800962:	75 05                	jne    800969 <memmove+0x53>
  800964:	f6 c1 03             	test   $0x3,%cl
  800967:	74 09                	je     800972 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800969:	89 c7                	mov    %eax,%edi
  80096b:	fc                   	cld    
  80096c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80096e:	5e                   	pop    %esi
  80096f:	5f                   	pop    %edi
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800972:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800975:	89 c7                	mov    %eax,%edi
  800977:	fc                   	cld    
  800978:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80097a:	eb f2                	jmp    80096e <memmove+0x58>

0080097c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	ff 75 08             	pushl  0x8(%ebp)
  800988:	e8 89 ff ff ff       	call   800916 <memmove>
}
  80098d:	c9                   	leave  
  80098e:	c3                   	ret    

0080098f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	56                   	push   %esi
  800993:	53                   	push   %ebx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	89 c6                	mov    %eax,%esi
  800999:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  80099f:	39 f0                	cmp    %esi,%eax
  8009a1:	74 16                	je     8009b9 <memcmp+0x2a>
		if (*s1 != *s2)
  8009a3:	8a 08                	mov    (%eax),%cl
  8009a5:	8a 1a                	mov    (%edx),%bl
  8009a7:	38 d9                	cmp    %bl,%cl
  8009a9:	75 04                	jne    8009af <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009ab:	40                   	inc    %eax
  8009ac:	42                   	inc    %edx
  8009ad:	eb f0                	jmp    80099f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009af:	0f b6 c1             	movzbl %cl,%eax
  8009b2:	0f b6 db             	movzbl %bl,%ebx
  8009b5:	29 d8                	sub    %ebx,%eax
  8009b7:	eb 05                	jmp    8009be <memcmp+0x2f>
	}

	return 0;
  8009b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009be:	5b                   	pop    %ebx
  8009bf:	5e                   	pop    %esi
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009cb:	89 c2                	mov    %eax,%edx
  8009cd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009d0:	39 d0                	cmp    %edx,%eax
  8009d2:	73 07                	jae    8009db <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009d4:	38 08                	cmp    %cl,(%eax)
  8009d6:	74 03                	je     8009db <memfind+0x19>
	for (; s < ends; s++)
  8009d8:	40                   	inc    %eax
  8009d9:	eb f5                	jmp    8009d0 <memfind+0xe>
			break;
	return (void *) s;
}
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	57                   	push   %edi
  8009e1:	56                   	push   %esi
  8009e2:	53                   	push   %ebx
  8009e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009e6:	eb 01                	jmp    8009e9 <strtol+0xc>
		s++;
  8009e8:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8009e9:	8a 01                	mov    (%ecx),%al
  8009eb:	3c 20                	cmp    $0x20,%al
  8009ed:	74 f9                	je     8009e8 <strtol+0xb>
  8009ef:	3c 09                	cmp    $0x9,%al
  8009f1:	74 f5                	je     8009e8 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8009f3:	3c 2b                	cmp    $0x2b,%al
  8009f5:	74 2b                	je     800a22 <strtol+0x45>
		s++;
	else if (*s == '-')
  8009f7:	3c 2d                	cmp    $0x2d,%al
  8009f9:	74 2f                	je     800a2a <strtol+0x4d>
	int neg = 0;
  8009fb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a00:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a07:	75 12                	jne    800a1b <strtol+0x3e>
  800a09:	80 39 30             	cmpb   $0x30,(%ecx)
  800a0c:	74 24                	je     800a32 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a12:	75 07                	jne    800a1b <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a14:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a20:	eb 4e                	jmp    800a70 <strtol+0x93>
		s++;
  800a22:	41                   	inc    %ecx
	int neg = 0;
  800a23:	bf 00 00 00 00       	mov    $0x0,%edi
  800a28:	eb d6                	jmp    800a00 <strtol+0x23>
		s++, neg = 1;
  800a2a:	41                   	inc    %ecx
  800a2b:	bf 01 00 00 00       	mov    $0x1,%edi
  800a30:	eb ce                	jmp    800a00 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a32:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a36:	74 10                	je     800a48 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a3c:	75 dd                	jne    800a1b <strtol+0x3e>
		s++, base = 8;
  800a3e:	41                   	inc    %ecx
  800a3f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a46:	eb d3                	jmp    800a1b <strtol+0x3e>
		s += 2, base = 16;
  800a48:	83 c1 02             	add    $0x2,%ecx
  800a4b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a52:	eb c7                	jmp    800a1b <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a54:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a57:	89 f3                	mov    %esi,%ebx
  800a59:	80 fb 19             	cmp    $0x19,%bl
  800a5c:	77 24                	ja     800a82 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a5e:	0f be d2             	movsbl %dl,%edx
  800a61:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a64:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a67:	7d 2b                	jge    800a94 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a69:	41                   	inc    %ecx
  800a6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a6e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a70:	8a 11                	mov    (%ecx),%dl
  800a72:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a75:	80 fb 09             	cmp    $0x9,%bl
  800a78:	77 da                	ja     800a54 <strtol+0x77>
			dig = *s - '0';
  800a7a:	0f be d2             	movsbl %dl,%edx
  800a7d:	83 ea 30             	sub    $0x30,%edx
  800a80:	eb e2                	jmp    800a64 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a82:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a85:	89 f3                	mov    %esi,%ebx
  800a87:	80 fb 19             	cmp    $0x19,%bl
  800a8a:	77 08                	ja     800a94 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800a8c:	0f be d2             	movsbl %dl,%edx
  800a8f:	83 ea 37             	sub    $0x37,%edx
  800a92:	eb d0                	jmp    800a64 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a98:	74 05                	je     800a9f <strtol+0xc2>
		*endptr = (char *) s;
  800a9a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a9d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a9f:	85 ff                	test   %edi,%edi
  800aa1:	74 02                	je     800aa5 <strtol+0xc8>
  800aa3:	f7 d8                	neg    %eax
}
  800aa5:	5b                   	pop    %ebx
  800aa6:	5e                   	pop    %esi
  800aa7:	5f                   	pop    %edi
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <atoi>:

int
atoi(const char *s)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800aad:	6a 0a                	push   $0xa
  800aaf:	6a 00                	push   $0x0
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 24 ff ff ff       	call   8009dd <strtol>
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	57                   	push   %edi
  800abf:	56                   	push   %esi
  800ac0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  800acc:	89 c3                	mov    %eax,%ebx
  800ace:	89 c7                	mov    %eax,%edi
  800ad0:	89 c6                	mov    %eax,%esi
  800ad2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	57                   	push   %edi
  800add:	56                   	push   %esi
  800ade:	53                   	push   %ebx
	asm volatile("int %1\n"
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae9:	89 d1                	mov    %edx,%ecx
  800aeb:	89 d3                	mov    %edx,%ebx
  800aed:	89 d7                	mov    %edx,%edi
  800aef:	89 d6                	mov    %edx,%esi
  800af1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800af3:	5b                   	pop    %ebx
  800af4:	5e                   	pop    %esi
  800af5:	5f                   	pop    %edi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	57                   	push   %edi
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
  800afe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b06:	b8 03 00 00 00       	mov    $0x3,%eax
  800b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0e:	89 cb                	mov    %ecx,%ebx
  800b10:	89 cf                	mov    %ecx,%edi
  800b12:	89 ce                	mov    %ecx,%esi
  800b14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b16:	85 c0                	test   %eax,%eax
  800b18:	7f 08                	jg     800b22 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1d:	5b                   	pop    %ebx
  800b1e:	5e                   	pop    %esi
  800b1f:	5f                   	pop    %edi
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	50                   	push   %eax
  800b26:	6a 03                	push   $0x3
  800b28:	68 9f 22 80 00       	push   $0x80229f
  800b2d:	6a 23                	push   $0x23
  800b2f:	68 bc 22 80 00       	push   $0x8022bc
  800b34:	e8 06 11 00 00       	call   801c3f <_panic>

00800b39 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	57                   	push   %edi
  800b3d:	56                   	push   %esi
  800b3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b44:	b8 02 00 00 00       	mov    $0x2,%eax
  800b49:	89 d1                	mov    %edx,%ecx
  800b4b:	89 d3                	mov    %edx,%ebx
  800b4d:	89 d7                	mov    %edx,%edi
  800b4f:	89 d6                	mov    %edx,%esi
  800b51:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5f                   	pop    %edi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b61:	be 00 00 00 00       	mov    $0x0,%esi
  800b66:	b8 04 00 00 00       	mov    $0x4,%eax
  800b6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b74:	89 f7                	mov    %esi,%edi
  800b76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b78:	85 c0                	test   %eax,%eax
  800b7a:	7f 08                	jg     800b84 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b84:	83 ec 0c             	sub    $0xc,%esp
  800b87:	50                   	push   %eax
  800b88:	6a 04                	push   $0x4
  800b8a:	68 9f 22 80 00       	push   $0x80229f
  800b8f:	6a 23                	push   $0x23
  800b91:	68 bc 22 80 00       	push   $0x8022bc
  800b96:	e8 a4 10 00 00       	call   801c3f <_panic>

00800b9b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	57                   	push   %edi
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba4:	b8 05 00 00 00       	mov    $0x5,%eax
  800ba9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bac:	8b 55 08             	mov    0x8(%ebp),%edx
  800baf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bb5:	8b 75 18             	mov    0x18(%ebp),%esi
  800bb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bba:	85 c0                	test   %eax,%eax
  800bbc:	7f 08                	jg     800bc6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc6:	83 ec 0c             	sub    $0xc,%esp
  800bc9:	50                   	push   %eax
  800bca:	6a 05                	push   $0x5
  800bcc:	68 9f 22 80 00       	push   $0x80229f
  800bd1:	6a 23                	push   $0x23
  800bd3:	68 bc 22 80 00       	push   $0x8022bc
  800bd8:	e8 62 10 00 00       	call   801c3f <_panic>

00800bdd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800beb:	b8 06 00 00 00       	mov    $0x6,%eax
  800bf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf6:	89 df                	mov    %ebx,%edi
  800bf8:	89 de                	mov    %ebx,%esi
  800bfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfc:	85 c0                	test   %eax,%eax
  800bfe:	7f 08                	jg     800c08 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c08:	83 ec 0c             	sub    $0xc,%esp
  800c0b:	50                   	push   %eax
  800c0c:	6a 06                	push   $0x6
  800c0e:	68 9f 22 80 00       	push   $0x80229f
  800c13:	6a 23                	push   $0x23
  800c15:	68 bc 22 80 00       	push   $0x8022bc
  800c1a:	e8 20 10 00 00       	call   801c3f <_panic>

00800c1f <sys_yield>:

void
sys_yield(void)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c25:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c2f:	89 d1                	mov    %edx,%ecx
  800c31:	89 d3                	mov    %edx,%ebx
  800c33:	89 d7                	mov    %edx,%edi
  800c35:	89 d6                	mov    %edx,%esi
  800c37:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c39:	5b                   	pop    %ebx
  800c3a:	5e                   	pop    %esi
  800c3b:	5f                   	pop    %edi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	57                   	push   %edi
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4c:	b8 08 00 00 00       	mov    $0x8,%eax
  800c51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	89 df                	mov    %ebx,%edi
  800c59:	89 de                	mov    %ebx,%esi
  800c5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	7f 08                	jg     800c69 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	50                   	push   %eax
  800c6d:	6a 08                	push   $0x8
  800c6f:	68 9f 22 80 00       	push   $0x80229f
  800c74:	6a 23                	push   $0x23
  800c76:	68 bc 22 80 00       	push   $0x8022bc
  800c7b:	e8 bf 0f 00 00       	call   801c3f <_panic>

00800c80 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
  800c86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c89:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
  800c96:	89 cb                	mov    %ecx,%ebx
  800c98:	89 cf                	mov    %ecx,%edi
  800c9a:	89 ce                	mov    %ecx,%esi
  800c9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9e:	85 c0                	test   %eax,%eax
  800ca0:	7f 08                	jg     800caa <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800caa:	83 ec 0c             	sub    $0xc,%esp
  800cad:	50                   	push   %eax
  800cae:	6a 0c                	push   $0xc
  800cb0:	68 9f 22 80 00       	push   $0x80229f
  800cb5:	6a 23                	push   $0x23
  800cb7:	68 bc 22 80 00       	push   $0x8022bc
  800cbc:	e8 7e 0f 00 00       	call   801c3f <_panic>

00800cc1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
  800cc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cca:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ccf:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	89 df                	mov    %ebx,%edi
  800cdc:	89 de                	mov    %ebx,%esi
  800cde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce0:	85 c0                	test   %eax,%eax
  800ce2:	7f 08                	jg     800cec <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cec:	83 ec 0c             	sub    $0xc,%esp
  800cef:	50                   	push   %eax
  800cf0:	6a 09                	push   $0x9
  800cf2:	68 9f 22 80 00       	push   $0x80229f
  800cf7:	6a 23                	push   $0x23
  800cf9:	68 bc 22 80 00       	push   $0x8022bc
  800cfe:	e8 3c 0f 00 00       	call   801c3f <_panic>

00800d03 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d11:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	89 df                	mov    %ebx,%edi
  800d1e:	89 de                	mov    %ebx,%esi
  800d20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d22:	85 c0                	test   %eax,%eax
  800d24:	7f 08                	jg     800d2e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2e:	83 ec 0c             	sub    $0xc,%esp
  800d31:	50                   	push   %eax
  800d32:	6a 0a                	push   $0xa
  800d34:	68 9f 22 80 00       	push   $0x80229f
  800d39:	6a 23                	push   $0x23
  800d3b:	68 bc 22 80 00       	push   $0x8022bc
  800d40:	e8 fa 0e 00 00       	call   801c3f <_panic>

00800d45 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4b:	be 00 00 00 00       	mov    $0x0,%esi
  800d50:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d61:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d63:	5b                   	pop    %ebx
  800d64:	5e                   	pop    %esi
  800d65:	5f                   	pop    %edi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d71:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d76:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	89 cb                	mov    %ecx,%ebx
  800d80:	89 cf                	mov    %ecx,%edi
  800d82:	89 ce                	mov    %ecx,%esi
  800d84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d86:	85 c0                	test   %eax,%eax
  800d88:	7f 08                	jg     800d92 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8d:	5b                   	pop    %ebx
  800d8e:	5e                   	pop    %esi
  800d8f:	5f                   	pop    %edi
  800d90:	5d                   	pop    %ebp
  800d91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d92:	83 ec 0c             	sub    $0xc,%esp
  800d95:	50                   	push   %eax
  800d96:	6a 0e                	push   $0xe
  800d98:	68 9f 22 80 00       	push   $0x80229f
  800d9d:	6a 23                	push   $0x23
  800d9f:	68 bc 22 80 00       	push   $0x8022bc
  800da4:	e8 96 0e 00 00       	call   801c3f <_panic>

00800da9 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800daf:	be 00 00 00 00       	mov    $0x0,%esi
  800db4:	b8 0f 00 00 00       	mov    $0xf,%eax
  800db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc2:	89 f7                	mov    %esi,%edi
  800dc4:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5f                   	pop    %edi
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd1:	be 00 00 00 00       	mov    $0x0,%esi
  800dd6:	b8 10 00 00 00       	mov    $0x10,%eax
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de4:	89 f7                	mov    %esi,%edi
  800de6:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    

00800ded <sys_set_console_color>:

void sys_set_console_color(int color) {
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df8:	b8 11 00 00 00       	mov    $0x11,%eax
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	89 cb                	mov    %ecx,%ebx
  800e02:	89 cf                	mov    %ecx,%edi
  800e04:	89 ce                	mov    %ecx,%esi
  800e06:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e19:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e1c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  800e1f:	85 ff                	test   %edi,%edi
  800e21:	74 53                	je     800e76 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	57                   	push   %edi
  800e27:	e8 3c ff ff ff       	call   800d68 <sys_ipc_recv>
  800e2c:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  800e2f:	85 db                	test   %ebx,%ebx
  800e31:	74 0b                	je     800e3e <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  800e33:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800e39:	8b 52 74             	mov    0x74(%edx),%edx
  800e3c:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  800e3e:	85 f6                	test   %esi,%esi
  800e40:	74 0f                	je     800e51 <ipc_recv+0x44>
  800e42:	85 ff                	test   %edi,%edi
  800e44:	74 0b                	je     800e51 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  800e46:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800e4c:	8b 52 78             	mov    0x78(%edx),%edx
  800e4f:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  800e51:	85 c0                	test   %eax,%eax
  800e53:	74 30                	je     800e85 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  800e55:	85 db                	test   %ebx,%ebx
  800e57:	74 06                	je     800e5f <ipc_recv+0x52>
      		*from_env_store = 0;
  800e59:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  800e5f:	85 f6                	test   %esi,%esi
  800e61:	74 2c                	je     800e8f <ipc_recv+0x82>
      		*perm_store = 0;
  800e63:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  800e69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  800e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  800e76:	83 ec 0c             	sub    $0xc,%esp
  800e79:	6a ff                	push   $0xffffffff
  800e7b:	e8 e8 fe ff ff       	call   800d68 <sys_ipc_recv>
  800e80:	83 c4 10             	add    $0x10,%esp
  800e83:	eb aa                	jmp    800e2f <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  800e85:	a1 04 40 80 00       	mov    0x804004,%eax
  800e8a:	8b 40 70             	mov    0x70(%eax),%eax
  800e8d:	eb df                	jmp    800e6e <ipc_recv+0x61>
		return -1;
  800e8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800e94:	eb d8                	jmp    800e6e <ipc_recv+0x61>

00800e96 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
  800e9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ea2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea5:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  800ea8:	85 db                	test   %ebx,%ebx
  800eaa:	75 22                	jne    800ece <ipc_send+0x38>
		pg = (void *) UTOP+1;
  800eac:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  800eb1:	eb 1b                	jmp    800ece <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  800eb3:	68 cc 22 80 00       	push   $0x8022cc
  800eb8:	68 ef 22 80 00       	push   $0x8022ef
  800ebd:	6a 48                	push   $0x48
  800ebf:	68 04 23 80 00       	push   $0x802304
  800ec4:	e8 76 0d 00 00       	call   801c3f <_panic>
		sys_yield();
  800ec9:	e8 51 fd ff ff       	call   800c1f <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  800ece:	57                   	push   %edi
  800ecf:	53                   	push   %ebx
  800ed0:	56                   	push   %esi
  800ed1:	ff 75 08             	pushl  0x8(%ebp)
  800ed4:	e8 6c fe ff ff       	call   800d45 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800edf:	74 e8                	je     800ec9 <ipc_send+0x33>
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	75 ce                	jne    800eb3 <ipc_send+0x1d>
		sys_yield();
  800ee5:	e8 35 fd ff ff       	call   800c1f <sys_yield>
		
	}
	
}
  800eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800efd:	89 c2                	mov    %eax,%edx
  800eff:	c1 e2 05             	shl    $0x5,%edx
  800f02:	29 c2                	sub    %eax,%edx
  800f04:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  800f0b:	8b 52 50             	mov    0x50(%edx),%edx
  800f0e:	39 ca                	cmp    %ecx,%edx
  800f10:	74 0f                	je     800f21 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  800f12:	40                   	inc    %eax
  800f13:	3d 00 04 00 00       	cmp    $0x400,%eax
  800f18:	75 e3                	jne    800efd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f1f:	eb 11                	jmp    800f32 <ipc_find_env+0x40>
			return envs[i].env_id;
  800f21:	89 c2                	mov    %eax,%edx
  800f23:	c1 e2 05             	shl    $0x5,%edx
  800f26:	29 c2                	sub    %eax,%edx
  800f28:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800f2f:	8b 40 48             	mov    0x48(%eax),%eax
}
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	05 00 00 00 30       	add    $0x30000000,%eax
  800f3f:	c1 e8 0c             	shr    $0xc,%eax
}
  800f42:	5d                   	pop    %ebp
  800f43:	c3                   	ret    

00800f44 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f54:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f61:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f66:	89 c2                	mov    %eax,%edx
  800f68:	c1 ea 16             	shr    $0x16,%edx
  800f6b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f72:	f6 c2 01             	test   $0x1,%dl
  800f75:	74 2a                	je     800fa1 <fd_alloc+0x46>
  800f77:	89 c2                	mov    %eax,%edx
  800f79:	c1 ea 0c             	shr    $0xc,%edx
  800f7c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f83:	f6 c2 01             	test   $0x1,%dl
  800f86:	74 19                	je     800fa1 <fd_alloc+0x46>
  800f88:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f8d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f92:	75 d2                	jne    800f66 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f94:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f9a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f9f:	eb 07                	jmp    800fa8 <fd_alloc+0x4d>
			*fd_store = fd;
  800fa1:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fad:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800fb1:	77 39                	ja     800fec <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	c1 e0 0c             	shl    $0xc,%eax
  800fb9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fbe:	89 c2                	mov    %eax,%edx
  800fc0:	c1 ea 16             	shr    $0x16,%edx
  800fc3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fca:	f6 c2 01             	test   $0x1,%dl
  800fcd:	74 24                	je     800ff3 <fd_lookup+0x49>
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	c1 ea 0c             	shr    $0xc,%edx
  800fd4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fdb:	f6 c2 01             	test   $0x1,%dl
  800fde:	74 1a                	je     800ffa <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe3:	89 02                	mov    %eax,(%edx)
	return 0;
  800fe5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		return -E_INVAL;
  800fec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff1:	eb f7                	jmp    800fea <fd_lookup+0x40>
		return -E_INVAL;
  800ff3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff8:	eb f0                	jmp    800fea <fd_lookup+0x40>
  800ffa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fff:	eb e9                	jmp    800fea <fd_lookup+0x40>

00801001 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 08             	sub    $0x8,%esp
  801007:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100a:	ba 8c 23 80 00       	mov    $0x80238c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80100f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801014:	39 08                	cmp    %ecx,(%eax)
  801016:	74 33                	je     80104b <dev_lookup+0x4a>
  801018:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80101b:	8b 02                	mov    (%edx),%eax
  80101d:	85 c0                	test   %eax,%eax
  80101f:	75 f3                	jne    801014 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801021:	a1 04 40 80 00       	mov    0x804004,%eax
  801026:	8b 40 48             	mov    0x48(%eax),%eax
  801029:	83 ec 04             	sub    $0x4,%esp
  80102c:	51                   	push   %ecx
  80102d:	50                   	push   %eax
  80102e:	68 10 23 80 00       	push   $0x802310
  801033:	e8 63 f1 ff ff       	call   80019b <cprintf>
	*dev = 0;
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801041:	83 c4 10             	add    $0x10,%esp
  801044:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    
			*dev = devtab[i];
  80104b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
  801055:	eb f2                	jmp    801049 <dev_lookup+0x48>

00801057 <fd_close>:
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
  80105d:	83 ec 1c             	sub    $0x1c,%esp
  801060:	8b 75 08             	mov    0x8(%ebp),%esi
  801063:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801066:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801069:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801070:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801073:	50                   	push   %eax
  801074:	e8 31 ff ff ff       	call   800faa <fd_lookup>
  801079:	89 c7                	mov    %eax,%edi
  80107b:	83 c4 08             	add    $0x8,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 05                	js     801087 <fd_close+0x30>
	    || fd != fd2)
  801082:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801085:	74 13                	je     80109a <fd_close+0x43>
		return (must_exist ? r : 0);
  801087:	84 db                	test   %bl,%bl
  801089:	75 05                	jne    801090 <fd_close+0x39>
  80108b:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801090:	89 f8                	mov    %edi,%eax
  801092:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010a0:	50                   	push   %eax
  8010a1:	ff 36                	pushl  (%esi)
  8010a3:	e8 59 ff ff ff       	call   801001 <dev_lookup>
  8010a8:	89 c7                	mov    %eax,%edi
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 15                	js     8010c6 <fd_close+0x6f>
		if (dev->dev_close)
  8010b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b4:	8b 40 10             	mov    0x10(%eax),%eax
  8010b7:	85 c0                	test   %eax,%eax
  8010b9:	74 1b                	je     8010d6 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8010bb:	83 ec 0c             	sub    $0xc,%esp
  8010be:	56                   	push   %esi
  8010bf:	ff d0                	call   *%eax
  8010c1:	89 c7                	mov    %eax,%edi
  8010c3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010c6:	83 ec 08             	sub    $0x8,%esp
  8010c9:	56                   	push   %esi
  8010ca:	6a 00                	push   $0x0
  8010cc:	e8 0c fb ff ff       	call   800bdd <sys_page_unmap>
	return r;
  8010d1:	83 c4 10             	add    $0x10,%esp
  8010d4:	eb ba                	jmp    801090 <fd_close+0x39>
			r = 0;
  8010d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8010db:	eb e9                	jmp    8010c6 <fd_close+0x6f>

008010dd <close>:

int
close(int fdnum)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e6:	50                   	push   %eax
  8010e7:	ff 75 08             	pushl  0x8(%ebp)
  8010ea:	e8 bb fe ff ff       	call   800faa <fd_lookup>
  8010ef:	83 c4 08             	add    $0x8,%esp
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	78 10                	js     801106 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	6a 01                	push   $0x1
  8010fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010fe:	e8 54 ff ff ff       	call   801057 <fd_close>
  801103:	83 c4 10             	add    $0x10,%esp
}
  801106:	c9                   	leave  
  801107:	c3                   	ret    

00801108 <close_all>:

void
close_all(void)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	53                   	push   %ebx
  80110c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80110f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801114:	83 ec 0c             	sub    $0xc,%esp
  801117:	53                   	push   %ebx
  801118:	e8 c0 ff ff ff       	call   8010dd <close>
	for (i = 0; i < MAXFD; i++)
  80111d:	43                   	inc    %ebx
  80111e:	83 c4 10             	add    $0x10,%esp
  801121:	83 fb 20             	cmp    $0x20,%ebx
  801124:	75 ee                	jne    801114 <close_all+0xc>
}
  801126:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801129:	c9                   	leave  
  80112a:	c3                   	ret    

0080112b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
  801131:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801134:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801137:	50                   	push   %eax
  801138:	ff 75 08             	pushl  0x8(%ebp)
  80113b:	e8 6a fe ff ff       	call   800faa <fd_lookup>
  801140:	89 c3                	mov    %eax,%ebx
  801142:	83 c4 08             	add    $0x8,%esp
  801145:	85 c0                	test   %eax,%eax
  801147:	0f 88 81 00 00 00    	js     8011ce <dup+0xa3>
		return r;
	close(newfdnum);
  80114d:	83 ec 0c             	sub    $0xc,%esp
  801150:	ff 75 0c             	pushl  0xc(%ebp)
  801153:	e8 85 ff ff ff       	call   8010dd <close>

	newfd = INDEX2FD(newfdnum);
  801158:	8b 75 0c             	mov    0xc(%ebp),%esi
  80115b:	c1 e6 0c             	shl    $0xc,%esi
  80115e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	ff 75 e4             	pushl  -0x1c(%ebp)
  80116a:	e8 d5 fd ff ff       	call   800f44 <fd2data>
  80116f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801171:	89 34 24             	mov    %esi,(%esp)
  801174:	e8 cb fd ff ff       	call   800f44 <fd2data>
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80117e:	89 d8                	mov    %ebx,%eax
  801180:	c1 e8 16             	shr    $0x16,%eax
  801183:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80118a:	a8 01                	test   $0x1,%al
  80118c:	74 11                	je     80119f <dup+0x74>
  80118e:	89 d8                	mov    %ebx,%eax
  801190:	c1 e8 0c             	shr    $0xc,%eax
  801193:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80119a:	f6 c2 01             	test   $0x1,%dl
  80119d:	75 39                	jne    8011d8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80119f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e8 0c             	shr    $0xc,%eax
  8011a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ae:	83 ec 0c             	sub    $0xc,%esp
  8011b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b6:	50                   	push   %eax
  8011b7:	56                   	push   %esi
  8011b8:	6a 00                	push   $0x0
  8011ba:	52                   	push   %edx
  8011bb:	6a 00                	push   $0x0
  8011bd:	e8 d9 f9 ff ff       	call   800b9b <sys_page_map>
  8011c2:	89 c3                	mov    %eax,%ebx
  8011c4:	83 c4 20             	add    $0x20,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 31                	js     8011fc <dup+0xd1>
		goto err;

	return newfdnum;
  8011cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011ce:	89 d8                	mov    %ebx,%eax
  8011d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d3:	5b                   	pop    %ebx
  8011d4:	5e                   	pop    %esi
  8011d5:	5f                   	pop    %edi
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8011e7:	50                   	push   %eax
  8011e8:	57                   	push   %edi
  8011e9:	6a 00                	push   $0x0
  8011eb:	53                   	push   %ebx
  8011ec:	6a 00                	push   $0x0
  8011ee:	e8 a8 f9 ff ff       	call   800b9b <sys_page_map>
  8011f3:	89 c3                	mov    %eax,%ebx
  8011f5:	83 c4 20             	add    $0x20,%esp
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	79 a3                	jns    80119f <dup+0x74>
	sys_page_unmap(0, newfd);
  8011fc:	83 ec 08             	sub    $0x8,%esp
  8011ff:	56                   	push   %esi
  801200:	6a 00                	push   $0x0
  801202:	e8 d6 f9 ff ff       	call   800bdd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801207:	83 c4 08             	add    $0x8,%esp
  80120a:	57                   	push   %edi
  80120b:	6a 00                	push   $0x0
  80120d:	e8 cb f9 ff ff       	call   800bdd <sys_page_unmap>
	return r;
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	eb b7                	jmp    8011ce <dup+0xa3>

00801217 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
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
  801226:	e8 7f fd ff ff       	call   800faa <fd_lookup>
  80122b:	83 c4 08             	add    $0x8,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 3f                	js     801271 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801238:	50                   	push   %eax
  801239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123c:	ff 30                	pushl  (%eax)
  80123e:	e8 be fd ff ff       	call   801001 <dev_lookup>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	78 27                	js     801271 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80124a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124d:	8b 42 08             	mov    0x8(%edx),%eax
  801250:	83 e0 03             	and    $0x3,%eax
  801253:	83 f8 01             	cmp    $0x1,%eax
  801256:	74 1e                	je     801276 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125b:	8b 40 08             	mov    0x8(%eax),%eax
  80125e:	85 c0                	test   %eax,%eax
  801260:	74 35                	je     801297 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	ff 75 10             	pushl  0x10(%ebp)
  801268:	ff 75 0c             	pushl  0xc(%ebp)
  80126b:	52                   	push   %edx
  80126c:	ff d0                	call   *%eax
  80126e:	83 c4 10             	add    $0x10,%esp
}
  801271:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801274:	c9                   	leave  
  801275:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801276:	a1 04 40 80 00       	mov    0x804004,%eax
  80127b:	8b 40 48             	mov    0x48(%eax),%eax
  80127e:	83 ec 04             	sub    $0x4,%esp
  801281:	53                   	push   %ebx
  801282:	50                   	push   %eax
  801283:	68 51 23 80 00       	push   $0x802351
  801288:	e8 0e ef ff ff       	call   80019b <cprintf>
		return -E_INVAL;
  80128d:	83 c4 10             	add    $0x10,%esp
  801290:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801295:	eb da                	jmp    801271 <read+0x5a>
		return -E_NOT_SUPP;
  801297:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80129c:	eb d3                	jmp    801271 <read+0x5a>

0080129e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	57                   	push   %edi
  8012a2:	56                   	push   %esi
  8012a3:	53                   	push   %ebx
  8012a4:	83 ec 0c             	sub    $0xc,%esp
  8012a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b2:	39 f3                	cmp    %esi,%ebx
  8012b4:	73 25                	jae    8012db <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b6:	83 ec 04             	sub    $0x4,%esp
  8012b9:	89 f0                	mov    %esi,%eax
  8012bb:	29 d8                	sub    %ebx,%eax
  8012bd:	50                   	push   %eax
  8012be:	89 d8                	mov    %ebx,%eax
  8012c0:	03 45 0c             	add    0xc(%ebp),%eax
  8012c3:	50                   	push   %eax
  8012c4:	57                   	push   %edi
  8012c5:	e8 4d ff ff ff       	call   801217 <read>
		if (m < 0)
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	78 08                	js     8012d9 <readn+0x3b>
			return m;
		if (m == 0)
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	74 06                	je     8012db <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012d5:	01 c3                	add    %eax,%ebx
  8012d7:	eb d9                	jmp    8012b2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012d9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012db:	89 d8                	mov    %ebx,%eax
  8012dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5f                   	pop    %edi
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    

008012e5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 14             	sub    $0x14,%esp
  8012ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f2:	50                   	push   %eax
  8012f3:	53                   	push   %ebx
  8012f4:	e8 b1 fc ff ff       	call   800faa <fd_lookup>
  8012f9:	83 c4 08             	add    $0x8,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 3a                	js     80133a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801300:	83 ec 08             	sub    $0x8,%esp
  801303:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801306:	50                   	push   %eax
  801307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130a:	ff 30                	pushl  (%eax)
  80130c:	e8 f0 fc ff ff       	call   801001 <dev_lookup>
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	78 22                	js     80133a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80131f:	74 1e                	je     80133f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801321:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801324:	8b 52 0c             	mov    0xc(%edx),%edx
  801327:	85 d2                	test   %edx,%edx
  801329:	74 35                	je     801360 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80132b:	83 ec 04             	sub    $0x4,%esp
  80132e:	ff 75 10             	pushl  0x10(%ebp)
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	50                   	push   %eax
  801335:	ff d2                	call   *%edx
  801337:	83 c4 10             	add    $0x10,%esp
}
  80133a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80133f:	a1 04 40 80 00       	mov    0x804004,%eax
  801344:	8b 40 48             	mov    0x48(%eax),%eax
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	53                   	push   %ebx
  80134b:	50                   	push   %eax
  80134c:	68 6d 23 80 00       	push   $0x80236d
  801351:	e8 45 ee ff ff       	call   80019b <cprintf>
		return -E_INVAL;
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135e:	eb da                	jmp    80133a <write+0x55>
		return -E_NOT_SUPP;
  801360:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801365:	eb d3                	jmp    80133a <write+0x55>

00801367 <seek>:

int
seek(int fdnum, off_t offset)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80136d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801370:	50                   	push   %eax
  801371:	ff 75 08             	pushl  0x8(%ebp)
  801374:	e8 31 fc ff ff       	call   800faa <fd_lookup>
  801379:	83 c4 08             	add    $0x8,%esp
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 0e                	js     80138e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801383:	8b 55 0c             	mov    0xc(%ebp),%edx
  801386:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	53                   	push   %ebx
  801394:	83 ec 14             	sub    $0x14,%esp
  801397:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139d:	50                   	push   %eax
  80139e:	53                   	push   %ebx
  80139f:	e8 06 fc ff ff       	call   800faa <fd_lookup>
  8013a4:	83 c4 08             	add    $0x8,%esp
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	78 37                	js     8013e2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b1:	50                   	push   %eax
  8013b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b5:	ff 30                	pushl  (%eax)
  8013b7:	e8 45 fc ff ff       	call   801001 <dev_lookup>
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 1f                	js     8013e2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ca:	74 1b                	je     8013e7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cf:	8b 52 18             	mov    0x18(%edx),%edx
  8013d2:	85 d2                	test   %edx,%edx
  8013d4:	74 32                	je     801408 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	50                   	push   %eax
  8013dd:	ff d2                	call   *%edx
  8013df:	83 c4 10             	add    $0x10,%esp
}
  8013e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013e7:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013ec:	8b 40 48             	mov    0x48(%eax),%eax
  8013ef:	83 ec 04             	sub    $0x4,%esp
  8013f2:	53                   	push   %ebx
  8013f3:	50                   	push   %eax
  8013f4:	68 30 23 80 00       	push   $0x802330
  8013f9:	e8 9d ed ff ff       	call   80019b <cprintf>
		return -E_INVAL;
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801406:	eb da                	jmp    8013e2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801408:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140d:	eb d3                	jmp    8013e2 <ftruncate+0x52>

0080140f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	53                   	push   %ebx
  801413:	83 ec 14             	sub    $0x14,%esp
  801416:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801419:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141c:	50                   	push   %eax
  80141d:	ff 75 08             	pushl  0x8(%ebp)
  801420:	e8 85 fb ff ff       	call   800faa <fd_lookup>
  801425:	83 c4 08             	add    $0x8,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 4b                	js     801477 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142c:	83 ec 08             	sub    $0x8,%esp
  80142f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801432:	50                   	push   %eax
  801433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801436:	ff 30                	pushl  (%eax)
  801438:	e8 c4 fb ff ff       	call   801001 <dev_lookup>
  80143d:	83 c4 10             	add    $0x10,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	78 33                	js     801477 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801447:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80144b:	74 2f                	je     80147c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80144d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801450:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801457:	00 00 00 
	stat->st_type = 0;
  80145a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801461:	00 00 00 
	stat->st_dev = dev;
  801464:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	53                   	push   %ebx
  80146e:	ff 75 f0             	pushl  -0x10(%ebp)
  801471:	ff 50 14             	call   *0x14(%eax)
  801474:	83 c4 10             	add    $0x10,%esp
}
  801477:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    
		return -E_NOT_SUPP;
  80147c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801481:	eb f4                	jmp    801477 <fstat+0x68>

00801483 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	6a 00                	push   $0x0
  80148d:	ff 75 08             	pushl  0x8(%ebp)
  801490:	e8 34 02 00 00       	call   8016c9 <open>
  801495:	89 c3                	mov    %eax,%ebx
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 1b                	js     8014b9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	ff 75 0c             	pushl  0xc(%ebp)
  8014a4:	50                   	push   %eax
  8014a5:	e8 65 ff ff ff       	call   80140f <fstat>
  8014aa:	89 c6                	mov    %eax,%esi
	close(fd);
  8014ac:	89 1c 24             	mov    %ebx,(%esp)
  8014af:	e8 29 fc ff ff       	call   8010dd <close>
	return r;
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	89 f3                	mov    %esi,%ebx
}
  8014b9:	89 d8                	mov    %ebx,%eax
  8014bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014be:	5b                   	pop    %ebx
  8014bf:	5e                   	pop    %esi
  8014c0:	5d                   	pop    %ebp
  8014c1:	c3                   	ret    

008014c2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	56                   	push   %esi
  8014c6:	53                   	push   %ebx
  8014c7:	89 c6                	mov    %eax,%esi
  8014c9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014cb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014d2:	74 27                	je     8014fb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014d4:	6a 07                	push   $0x7
  8014d6:	68 00 50 80 00       	push   $0x805000
  8014db:	56                   	push   %esi
  8014dc:	ff 35 00 40 80 00    	pushl  0x804000
  8014e2:	e8 af f9 ff ff       	call   800e96 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014e7:	83 c4 0c             	add    $0xc,%esp
  8014ea:	6a 00                	push   $0x0
  8014ec:	53                   	push   %ebx
  8014ed:	6a 00                	push   $0x0
  8014ef:	e8 19 f9 ff ff       	call   800e0d <ipc_recv>
}
  8014f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5d                   	pop    %ebp
  8014fa:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	6a 01                	push   $0x1
  801500:	e8 ed f9 ff ff       	call   800ef2 <ipc_find_env>
  801505:	a3 00 40 80 00       	mov    %eax,0x804000
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	eb c5                	jmp    8014d4 <fsipc+0x12>

0080150f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8b 40 0c             	mov    0xc(%eax),%eax
  80151b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801520:	8b 45 0c             	mov    0xc(%ebp),%eax
  801523:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801528:	ba 00 00 00 00       	mov    $0x0,%edx
  80152d:	b8 02 00 00 00       	mov    $0x2,%eax
  801532:	e8 8b ff ff ff       	call   8014c2 <fsipc>
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <devfile_flush>:
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8b 40 0c             	mov    0xc(%eax),%eax
  801545:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80154a:	ba 00 00 00 00       	mov    $0x0,%edx
  80154f:	b8 06 00 00 00       	mov    $0x6,%eax
  801554:	e8 69 ff ff ff       	call   8014c2 <fsipc>
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <devfile_stat>:
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	53                   	push   %ebx
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	8b 40 0c             	mov    0xc(%eax),%eax
  80156b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801570:	ba 00 00 00 00       	mov    $0x0,%edx
  801575:	b8 05 00 00 00       	mov    $0x5,%eax
  80157a:	e8 43 ff ff ff       	call   8014c2 <fsipc>
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 2c                	js     8015af <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	68 00 50 80 00       	push   $0x805000
  80158b:	53                   	push   %ebx
  80158c:	e8 12 f2 ff ff       	call   8007a3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801591:	a1 80 50 80 00       	mov    0x805080,%eax
  801596:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80159c:	a1 84 50 80 00       	mov    0x805084,%eax
  8015a1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <devfile_write>:
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	53                   	push   %ebx
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8015be:	89 d8                	mov    %ebx,%eax
  8015c0:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8015c6:	76 05                	jbe    8015cd <devfile_write+0x19>
  8015c8:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d0:	8b 52 0c             	mov    0xc(%edx),%edx
  8015d3:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8015d9:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	50                   	push   %eax
  8015e2:	ff 75 0c             	pushl  0xc(%ebp)
  8015e5:	68 08 50 80 00       	push   $0x805008
  8015ea:	e8 27 f3 ff ff       	call   800916 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8015ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8015f9:	e8 c4 fe ff ff       	call   8014c2 <fsipc>
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	85 c0                	test   %eax,%eax
  801603:	78 0b                	js     801610 <devfile_write+0x5c>
	assert(r <= n);
  801605:	39 c3                	cmp    %eax,%ebx
  801607:	72 0c                	jb     801615 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801609:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80160e:	7f 1e                	jg     80162e <devfile_write+0x7a>
}
  801610:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801613:	c9                   	leave  
  801614:	c3                   	ret    
	assert(r <= n);
  801615:	68 9c 23 80 00       	push   $0x80239c
  80161a:	68 ef 22 80 00       	push   $0x8022ef
  80161f:	68 98 00 00 00       	push   $0x98
  801624:	68 a3 23 80 00       	push   $0x8023a3
  801629:	e8 11 06 00 00       	call   801c3f <_panic>
	assert(r <= PGSIZE);
  80162e:	68 ae 23 80 00       	push   $0x8023ae
  801633:	68 ef 22 80 00       	push   $0x8022ef
  801638:	68 99 00 00 00       	push   $0x99
  80163d:	68 a3 23 80 00       	push   $0x8023a3
  801642:	e8 f8 05 00 00       	call   801c3f <_panic>

00801647 <devfile_read>:
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	56                   	push   %esi
  80164b:	53                   	push   %ebx
  80164c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8b 40 0c             	mov    0xc(%eax),%eax
  801655:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80165a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801660:	ba 00 00 00 00       	mov    $0x0,%edx
  801665:	b8 03 00 00 00       	mov    $0x3,%eax
  80166a:	e8 53 fe ff ff       	call   8014c2 <fsipc>
  80166f:	89 c3                	mov    %eax,%ebx
  801671:	85 c0                	test   %eax,%eax
  801673:	78 1f                	js     801694 <devfile_read+0x4d>
	assert(r <= n);
  801675:	39 c6                	cmp    %eax,%esi
  801677:	72 24                	jb     80169d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801679:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80167e:	7f 33                	jg     8016b3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	50                   	push   %eax
  801684:	68 00 50 80 00       	push   $0x805000
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	e8 85 f2 ff ff       	call   800916 <memmove>
	return r;
  801691:	83 c4 10             	add    $0x10,%esp
}
  801694:	89 d8                	mov    %ebx,%eax
  801696:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801699:	5b                   	pop    %ebx
  80169a:	5e                   	pop    %esi
  80169b:	5d                   	pop    %ebp
  80169c:	c3                   	ret    
	assert(r <= n);
  80169d:	68 9c 23 80 00       	push   $0x80239c
  8016a2:	68 ef 22 80 00       	push   $0x8022ef
  8016a7:	6a 7c                	push   $0x7c
  8016a9:	68 a3 23 80 00       	push   $0x8023a3
  8016ae:	e8 8c 05 00 00       	call   801c3f <_panic>
	assert(r <= PGSIZE);
  8016b3:	68 ae 23 80 00       	push   $0x8023ae
  8016b8:	68 ef 22 80 00       	push   $0x8022ef
  8016bd:	6a 7d                	push   $0x7d
  8016bf:	68 a3 23 80 00       	push   $0x8023a3
  8016c4:	e8 76 05 00 00       	call   801c3f <_panic>

008016c9 <open>:
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 1c             	sub    $0x1c,%esp
  8016d1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016d4:	56                   	push   %esi
  8016d5:	e8 96 f0 ff ff       	call   800770 <strlen>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016e2:	7f 6c                	jg     801750 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016e4:	83 ec 0c             	sub    $0xc,%esp
  8016e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ea:	50                   	push   %eax
  8016eb:	e8 6b f8 ff ff       	call   800f5b <fd_alloc>
  8016f0:	89 c3                	mov    %eax,%ebx
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	78 3c                	js     801735 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	56                   	push   %esi
  8016fd:	68 00 50 80 00       	push   $0x805000
  801702:	e8 9c f0 ff ff       	call   8007a3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80170f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801712:	b8 01 00 00 00       	mov    $0x1,%eax
  801717:	e8 a6 fd ff ff       	call   8014c2 <fsipc>
  80171c:	89 c3                	mov    %eax,%ebx
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	78 19                	js     80173e <open+0x75>
	return fd2num(fd);
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	ff 75 f4             	pushl  -0xc(%ebp)
  80172b:	e8 04 f8 ff ff       	call   800f34 <fd2num>
  801730:	89 c3                	mov    %eax,%ebx
  801732:	83 c4 10             	add    $0x10,%esp
}
  801735:	89 d8                	mov    %ebx,%eax
  801737:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173a:	5b                   	pop    %ebx
  80173b:	5e                   	pop    %esi
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    
		fd_close(fd, 0);
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	6a 00                	push   $0x0
  801743:	ff 75 f4             	pushl  -0xc(%ebp)
  801746:	e8 0c f9 ff ff       	call   801057 <fd_close>
		return r;
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	eb e5                	jmp    801735 <open+0x6c>
		return -E_BAD_PATH;
  801750:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801755:	eb de                	jmp    801735 <open+0x6c>

00801757 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80175d:	ba 00 00 00 00       	mov    $0x0,%edx
  801762:	b8 08 00 00 00       	mov    $0x8,%eax
  801767:	e8 56 fd ff ff       	call   8014c2 <fsipc>
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
  801773:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801776:	83 ec 0c             	sub    $0xc,%esp
  801779:	ff 75 08             	pushl  0x8(%ebp)
  80177c:	e8 c3 f7 ff ff       	call   800f44 <fd2data>
  801781:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801783:	83 c4 08             	add    $0x8,%esp
  801786:	68 ba 23 80 00       	push   $0x8023ba
  80178b:	53                   	push   %ebx
  80178c:	e8 12 f0 ff ff       	call   8007a3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801791:	8b 46 04             	mov    0x4(%esi),%eax
  801794:	2b 06                	sub    (%esi),%eax
  801796:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80179c:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  8017a3:	10 00 00 
	stat->st_dev = &devpipe;
  8017a6:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017ad:	30 80 00 
	return 0;
}
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	53                   	push   %ebx
  8017c0:	83 ec 0c             	sub    $0xc,%esp
  8017c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017c6:	53                   	push   %ebx
  8017c7:	6a 00                	push   $0x0
  8017c9:	e8 0f f4 ff ff       	call   800bdd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017ce:	89 1c 24             	mov    %ebx,(%esp)
  8017d1:	e8 6e f7 ff ff       	call   800f44 <fd2data>
  8017d6:	83 c4 08             	add    $0x8,%esp
  8017d9:	50                   	push   %eax
  8017da:	6a 00                	push   $0x0
  8017dc:	e8 fc f3 ff ff       	call   800bdd <sys_page_unmap>
}
  8017e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <_pipeisclosed>:
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	57                   	push   %edi
  8017ea:	56                   	push   %esi
  8017eb:	53                   	push   %ebx
  8017ec:	83 ec 1c             	sub    $0x1c,%esp
  8017ef:	89 c7                	mov    %eax,%edi
  8017f1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017f3:	a1 04 40 80 00       	mov    0x804004,%eax
  8017f8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017fb:	83 ec 0c             	sub    $0xc,%esp
  8017fe:	57                   	push   %edi
  8017ff:	e8 ba 04 00 00       	call   801cbe <pageref>
  801804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801807:	89 34 24             	mov    %esi,(%esp)
  80180a:	e8 af 04 00 00       	call   801cbe <pageref>
		nn = thisenv->env_runs;
  80180f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801815:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	39 cb                	cmp    %ecx,%ebx
  80181d:	74 1b                	je     80183a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80181f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801822:	75 cf                	jne    8017f3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801824:	8b 42 58             	mov    0x58(%edx),%eax
  801827:	6a 01                	push   $0x1
  801829:	50                   	push   %eax
  80182a:	53                   	push   %ebx
  80182b:	68 c1 23 80 00       	push   $0x8023c1
  801830:	e8 66 e9 ff ff       	call   80019b <cprintf>
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	eb b9                	jmp    8017f3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80183a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80183d:	0f 94 c0             	sete   %al
  801840:	0f b6 c0             	movzbl %al,%eax
}
  801843:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801846:	5b                   	pop    %ebx
  801847:	5e                   	pop    %esi
  801848:	5f                   	pop    %edi
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    

0080184b <devpipe_write>:
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	57                   	push   %edi
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	83 ec 18             	sub    $0x18,%esp
  801854:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801857:	56                   	push   %esi
  801858:	e8 e7 f6 ff ff       	call   800f44 <fd2data>
  80185d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	bf 00 00 00 00       	mov    $0x0,%edi
  801867:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80186a:	74 41                	je     8018ad <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80186c:	8b 53 04             	mov    0x4(%ebx),%edx
  80186f:	8b 03                	mov    (%ebx),%eax
  801871:	83 c0 20             	add    $0x20,%eax
  801874:	39 c2                	cmp    %eax,%edx
  801876:	72 14                	jb     80188c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801878:	89 da                	mov    %ebx,%edx
  80187a:	89 f0                	mov    %esi,%eax
  80187c:	e8 65 ff ff ff       	call   8017e6 <_pipeisclosed>
  801881:	85 c0                	test   %eax,%eax
  801883:	75 2c                	jne    8018b1 <devpipe_write+0x66>
			sys_yield();
  801885:	e8 95 f3 ff ff       	call   800c1f <sys_yield>
  80188a:	eb e0                	jmp    80186c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80188c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188f:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801892:	89 d0                	mov    %edx,%eax
  801894:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801899:	78 0b                	js     8018a6 <devpipe_write+0x5b>
  80189b:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  80189f:	42                   	inc    %edx
  8018a0:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018a3:	47                   	inc    %edi
  8018a4:	eb c1                	jmp    801867 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018a6:	48                   	dec    %eax
  8018a7:	83 c8 e0             	or     $0xffffffe0,%eax
  8018aa:	40                   	inc    %eax
  8018ab:	eb ee                	jmp    80189b <devpipe_write+0x50>
	return i;
  8018ad:	89 f8                	mov    %edi,%eax
  8018af:	eb 05                	jmp    8018b6 <devpipe_write+0x6b>
				return 0;
  8018b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018b9:	5b                   	pop    %ebx
  8018ba:	5e                   	pop    %esi
  8018bb:	5f                   	pop    %edi
  8018bc:	5d                   	pop    %ebp
  8018bd:	c3                   	ret    

008018be <devpipe_read>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	57                   	push   %edi
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 18             	sub    $0x18,%esp
  8018c7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018ca:	57                   	push   %edi
  8018cb:	e8 74 f6 ff ff       	call   800f44 <fd2data>
  8018d0:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018da:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8018dd:	74 46                	je     801925 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  8018df:	8b 06                	mov    (%esi),%eax
  8018e1:	3b 46 04             	cmp    0x4(%esi),%eax
  8018e4:	75 22                	jne    801908 <devpipe_read+0x4a>
			if (i > 0)
  8018e6:	85 db                	test   %ebx,%ebx
  8018e8:	74 0a                	je     8018f4 <devpipe_read+0x36>
				return i;
  8018ea:	89 d8                	mov    %ebx,%eax
}
  8018ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5e                   	pop    %esi
  8018f1:	5f                   	pop    %edi
  8018f2:	5d                   	pop    %ebp
  8018f3:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  8018f4:	89 f2                	mov    %esi,%edx
  8018f6:	89 f8                	mov    %edi,%eax
  8018f8:	e8 e9 fe ff ff       	call   8017e6 <_pipeisclosed>
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	75 28                	jne    801929 <devpipe_read+0x6b>
			sys_yield();
  801901:	e8 19 f3 ff ff       	call   800c1f <sys_yield>
  801906:	eb d7                	jmp    8018df <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801908:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80190d:	78 0f                	js     80191e <devpipe_read+0x60>
  80190f:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801913:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801916:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801919:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  80191b:	43                   	inc    %ebx
  80191c:	eb bc                	jmp    8018da <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80191e:	48                   	dec    %eax
  80191f:	83 c8 e0             	or     $0xffffffe0,%eax
  801922:	40                   	inc    %eax
  801923:	eb ea                	jmp    80190f <devpipe_read+0x51>
	return i;
  801925:	89 d8                	mov    %ebx,%eax
  801927:	eb c3                	jmp    8018ec <devpipe_read+0x2e>
				return 0;
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
  80192e:	eb bc                	jmp    8018ec <devpipe_read+0x2e>

00801930 <pipe>:
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
  801935:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801938:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193b:	50                   	push   %eax
  80193c:	e8 1a f6 ff ff       	call   800f5b <fd_alloc>
  801941:	89 c3                	mov    %eax,%ebx
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	0f 88 2a 01 00 00    	js     801a78 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	68 07 04 00 00       	push   $0x407
  801956:	ff 75 f4             	pushl  -0xc(%ebp)
  801959:	6a 00                	push   $0x0
  80195b:	e8 f8 f1 ff ff       	call   800b58 <sys_page_alloc>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	0f 88 0b 01 00 00    	js     801a78 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801973:	50                   	push   %eax
  801974:	e8 e2 f5 ff ff       	call   800f5b <fd_alloc>
  801979:	89 c3                	mov    %eax,%ebx
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	0f 88 e2 00 00 00    	js     801a68 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	68 07 04 00 00       	push   $0x407
  80198e:	ff 75 f0             	pushl  -0x10(%ebp)
  801991:	6a 00                	push   $0x0
  801993:	e8 c0 f1 ff ff       	call   800b58 <sys_page_alloc>
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	85 c0                	test   %eax,%eax
  80199f:	0f 88 c3 00 00 00    	js     801a68 <pipe+0x138>
	va = fd2data(fd0);
  8019a5:	83 ec 0c             	sub    $0xc,%esp
  8019a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ab:	e8 94 f5 ff ff       	call   800f44 <fd2data>
  8019b0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019b2:	83 c4 0c             	add    $0xc,%esp
  8019b5:	68 07 04 00 00       	push   $0x407
  8019ba:	50                   	push   %eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	e8 96 f1 ff ff       	call   800b58 <sys_page_alloc>
  8019c2:	89 c3                	mov    %eax,%ebx
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	0f 88 89 00 00 00    	js     801a58 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019cf:	83 ec 0c             	sub    $0xc,%esp
  8019d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019d5:	e8 6a f5 ff ff       	call   800f44 <fd2data>
  8019da:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019e1:	50                   	push   %eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	56                   	push   %esi
  8019e5:	6a 00                	push   $0x0
  8019e7:	e8 af f1 ff ff       	call   800b9b <sys_page_map>
  8019ec:	89 c3                	mov    %eax,%ebx
  8019ee:	83 c4 20             	add    $0x20,%esp
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	78 55                	js     801a4a <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  8019f5:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fe:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a0a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a13:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a18:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a1f:	83 ec 0c             	sub    $0xc,%esp
  801a22:	ff 75 f4             	pushl  -0xc(%ebp)
  801a25:	e8 0a f5 ff ff       	call   800f34 <fd2num>
  801a2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a2f:	83 c4 04             	add    $0x4,%esp
  801a32:	ff 75 f0             	pushl  -0x10(%ebp)
  801a35:	e8 fa f4 ff ff       	call   800f34 <fd2num>
  801a3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a48:	eb 2e                	jmp    801a78 <pipe+0x148>
	sys_page_unmap(0, va);
  801a4a:	83 ec 08             	sub    $0x8,%esp
  801a4d:	56                   	push   %esi
  801a4e:	6a 00                	push   $0x0
  801a50:	e8 88 f1 ff ff       	call   800bdd <sys_page_unmap>
  801a55:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a58:	83 ec 08             	sub    $0x8,%esp
  801a5b:	ff 75 f0             	pushl  -0x10(%ebp)
  801a5e:	6a 00                	push   $0x0
  801a60:	e8 78 f1 ff ff       	call   800bdd <sys_page_unmap>
  801a65:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a6e:	6a 00                	push   $0x0
  801a70:	e8 68 f1 ff ff       	call   800bdd <sys_page_unmap>
  801a75:	83 c4 10             	add    $0x10,%esp
}
  801a78:	89 d8                	mov    %ebx,%eax
  801a7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5e                   	pop    %esi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    

00801a81 <pipeisclosed>:
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8a:	50                   	push   %eax
  801a8b:	ff 75 08             	pushl  0x8(%ebp)
  801a8e:	e8 17 f5 ff ff       	call   800faa <fd_lookup>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 18                	js     801ab2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a9a:	83 ec 0c             	sub    $0xc,%esp
  801a9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa0:	e8 9f f4 ff ff       	call   800f44 <fd2data>
	return _pipeisclosed(fd, p);
  801aa5:	89 c2                	mov    %eax,%edx
  801aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaa:	e8 37 fd ff ff       	call   8017e6 <_pipeisclosed>
  801aaf:	83 c4 10             	add    $0x10,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  801abc:	5d                   	pop    %ebp
  801abd:	c3                   	ret    

00801abe <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	53                   	push   %ebx
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801ac8:	68 d9 23 80 00       	push   $0x8023d9
  801acd:	53                   	push   %ebx
  801ace:	e8 d0 ec ff ff       	call   8007a3 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801ad3:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801ada:	20 00 00 
	return 0;
}
  801add:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <devcons_write>:
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	57                   	push   %edi
  801aeb:	56                   	push   %esi
  801aec:	53                   	push   %ebx
  801aed:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801af3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801af8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801afe:	eb 1d                	jmp    801b1d <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	53                   	push   %ebx
  801b04:	03 45 0c             	add    0xc(%ebp),%eax
  801b07:	50                   	push   %eax
  801b08:	57                   	push   %edi
  801b09:	e8 08 ee ff ff       	call   800916 <memmove>
		sys_cputs(buf, m);
  801b0e:	83 c4 08             	add    $0x8,%esp
  801b11:	53                   	push   %ebx
  801b12:	57                   	push   %edi
  801b13:	e8 a3 ef ff ff       	call   800abb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b18:	01 de                	add    %ebx,%esi
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	89 f0                	mov    %esi,%eax
  801b1f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b22:	73 11                	jae    801b35 <devcons_write+0x4e>
		m = n - tot;
  801b24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b27:	29 f3                	sub    %esi,%ebx
  801b29:	83 fb 7f             	cmp    $0x7f,%ebx
  801b2c:	76 d2                	jbe    801b00 <devcons_write+0x19>
  801b2e:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801b33:	eb cb                	jmp    801b00 <devcons_write+0x19>
}
  801b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5f                   	pop    %edi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    

00801b3d <devcons_read>:
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801b43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b47:	75 0c                	jne    801b55 <devcons_read+0x18>
		return 0;
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4e:	eb 21                	jmp    801b71 <devcons_read+0x34>
		sys_yield();
  801b50:	e8 ca f0 ff ff       	call   800c1f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801b55:	e8 7f ef ff ff       	call   800ad9 <sys_cgetc>
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	74 f2                	je     801b50 <devcons_read+0x13>
	if (c < 0)
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	78 0f                	js     801b71 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801b62:	83 f8 04             	cmp    $0x4,%eax
  801b65:	74 0c                	je     801b73 <devcons_read+0x36>
	*(char*)vbuf = c;
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6a:	88 02                	mov    %al,(%edx)
	return 1;
  801b6c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    
		return 0;
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax
  801b78:	eb f7                	jmp    801b71 <devcons_read+0x34>

00801b7a <cputchar>:
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b86:	6a 01                	push   $0x1
  801b88:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b8b:	50                   	push   %eax
  801b8c:	e8 2a ef ff ff       	call   800abb <sys_cputs>
}
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <getchar>:
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b9c:	6a 01                	push   $0x1
  801b9e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ba1:	50                   	push   %eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	e8 6e f6 ff ff       	call   801217 <read>
	if (r < 0)
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 08                	js     801bb8 <getchar+0x22>
	if (r < 1)
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	7e 06                	jle    801bba <getchar+0x24>
	return c;
  801bb4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    
		return -E_EOF;
  801bba:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801bbf:	eb f7                	jmp    801bb8 <getchar+0x22>

00801bc1 <iscons>:
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bca:	50                   	push   %eax
  801bcb:	ff 75 08             	pushl  0x8(%ebp)
  801bce:	e8 d7 f3 ff ff       	call   800faa <fd_lookup>
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	78 11                	js     801beb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801be3:	39 10                	cmp    %edx,(%eax)
  801be5:	0f 94 c0             	sete   %al
  801be8:	0f b6 c0             	movzbl %al,%eax
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <opencons>:
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801bf3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf6:	50                   	push   %eax
  801bf7:	e8 5f f3 ff ff       	call   800f5b <fd_alloc>
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	85 c0                	test   %eax,%eax
  801c01:	78 3a                	js     801c3d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	68 07 04 00 00       	push   $0x407
  801c0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0e:	6a 00                	push   $0x0
  801c10:	e8 43 ef ff ff       	call   800b58 <sys_page_alloc>
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 21                	js     801c3d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801c1c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c25:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	50                   	push   %eax
  801c35:	e8 fa f2 ff ff       	call   800f34 <fd2num>
  801c3a:	83 c4 10             	add    $0x10,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	57                   	push   %edi
  801c43:	56                   	push   %esi
  801c44:	53                   	push   %ebx
  801c45:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801c4b:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801c4e:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801c54:	e8 e0 ee ff ff       	call   800b39 <sys_getenvid>
  801c59:	83 ec 04             	sub    $0x4,%esp
  801c5c:	ff 75 0c             	pushl  0xc(%ebp)
  801c5f:	ff 75 08             	pushl  0x8(%ebp)
  801c62:	53                   	push   %ebx
  801c63:	50                   	push   %eax
  801c64:	68 e8 23 80 00       	push   $0x8023e8
  801c69:	68 00 01 00 00       	push   $0x100
  801c6e:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801c74:	56                   	push   %esi
  801c75:	e8 dc ea ff ff       	call   800756 <snprintf>
  801c7a:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801c7c:	83 c4 20             	add    $0x20,%esp
  801c7f:	57                   	push   %edi
  801c80:	ff 75 10             	pushl  0x10(%ebp)
  801c83:	bf 00 01 00 00       	mov    $0x100,%edi
  801c88:	89 f8                	mov    %edi,%eax
  801c8a:	29 d8                	sub    %ebx,%eax
  801c8c:	50                   	push   %eax
  801c8d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801c90:	50                   	push   %eax
  801c91:	e8 6b ea ff ff       	call   800701 <vsnprintf>
  801c96:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801c98:	83 c4 0c             	add    $0xc,%esp
  801c9b:	68 d2 23 80 00       	push   $0x8023d2
  801ca0:	29 df                	sub    %ebx,%edi
  801ca2:	57                   	push   %edi
  801ca3:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801ca6:	50                   	push   %eax
  801ca7:	e8 aa ea ff ff       	call   800756 <snprintf>
	sys_cputs(buf, r);
  801cac:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801caf:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801cb1:	53                   	push   %ebx
  801cb2:	56                   	push   %esi
  801cb3:	e8 03 ee ff ff       	call   800abb <sys_cputs>
  801cb8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801cbb:	cc                   	int3   
  801cbc:	eb fd                	jmp    801cbb <_panic+0x7c>

00801cbe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	c1 e8 16             	shr    $0x16,%eax
  801cc7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801cce:	a8 01                	test   $0x1,%al
  801cd0:	74 21                	je     801cf3 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	c1 e8 0c             	shr    $0xc,%eax
  801cd8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cdf:	a8 01                	test   $0x1,%al
  801ce1:	74 17                	je     801cfa <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ce3:	c1 e8 0c             	shr    $0xc,%eax
  801ce6:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801ced:	ef 
  801cee:	0f b7 c0             	movzwl %ax,%eax
  801cf1:	eb 05                	jmp    801cf8 <pageref+0x3a>
		return 0;
  801cf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    
		return 0;
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801cff:	eb f7                	jmp    801cf8 <pageref+0x3a>
  801d01:	66 90                	xchg   %ax,%ax
  801d03:	90                   	nop

00801d04 <__udivdi3>:
  801d04:	55                   	push   %ebp
  801d05:	57                   	push   %edi
  801d06:	56                   	push   %esi
  801d07:	53                   	push   %ebx
  801d08:	83 ec 1c             	sub    $0x1c,%esp
  801d0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d17:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d1b:	89 ca                	mov    %ecx,%edx
  801d1d:	89 f8                	mov    %edi,%eax
  801d1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d23:	85 f6                	test   %esi,%esi
  801d25:	75 2d                	jne    801d54 <__udivdi3+0x50>
  801d27:	39 cf                	cmp    %ecx,%edi
  801d29:	77 65                	ja     801d90 <__udivdi3+0x8c>
  801d2b:	89 fd                	mov    %edi,%ebp
  801d2d:	85 ff                	test   %edi,%edi
  801d2f:	75 0b                	jne    801d3c <__udivdi3+0x38>
  801d31:	b8 01 00 00 00       	mov    $0x1,%eax
  801d36:	31 d2                	xor    %edx,%edx
  801d38:	f7 f7                	div    %edi
  801d3a:	89 c5                	mov    %eax,%ebp
  801d3c:	31 d2                	xor    %edx,%edx
  801d3e:	89 c8                	mov    %ecx,%eax
  801d40:	f7 f5                	div    %ebp
  801d42:	89 c1                	mov    %eax,%ecx
  801d44:	89 d8                	mov    %ebx,%eax
  801d46:	f7 f5                	div    %ebp
  801d48:	89 cf                	mov    %ecx,%edi
  801d4a:	89 fa                	mov    %edi,%edx
  801d4c:	83 c4 1c             	add    $0x1c,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5f                   	pop    %edi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    
  801d54:	39 ce                	cmp    %ecx,%esi
  801d56:	77 28                	ja     801d80 <__udivdi3+0x7c>
  801d58:	0f bd fe             	bsr    %esi,%edi
  801d5b:	83 f7 1f             	xor    $0x1f,%edi
  801d5e:	75 40                	jne    801da0 <__udivdi3+0x9c>
  801d60:	39 ce                	cmp    %ecx,%esi
  801d62:	72 0a                	jb     801d6e <__udivdi3+0x6a>
  801d64:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d68:	0f 87 9e 00 00 00    	ja     801e0c <__udivdi3+0x108>
  801d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d73:	89 fa                	mov    %edi,%edx
  801d75:	83 c4 1c             	add    $0x1c,%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5f                   	pop    %edi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    
  801d7d:	8d 76 00             	lea    0x0(%esi),%esi
  801d80:	31 ff                	xor    %edi,%edi
  801d82:	31 c0                	xor    %eax,%eax
  801d84:	89 fa                	mov    %edi,%edx
  801d86:	83 c4 1c             	add    $0x1c,%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5f                   	pop    %edi
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	89 d8                	mov    %ebx,%eax
  801d92:	f7 f7                	div    %edi
  801d94:	31 ff                	xor    %edi,%edi
  801d96:	89 fa                	mov    %edi,%edx
  801d98:	83 c4 1c             	add    $0x1c,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
  801da0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801da5:	29 fd                	sub    %edi,%ebp
  801da7:	89 f9                	mov    %edi,%ecx
  801da9:	d3 e6                	shl    %cl,%esi
  801dab:	89 c3                	mov    %eax,%ebx
  801dad:	89 e9                	mov    %ebp,%ecx
  801daf:	d3 eb                	shr    %cl,%ebx
  801db1:	89 d9                	mov    %ebx,%ecx
  801db3:	09 f1                	or     %esi,%ecx
  801db5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801db9:	89 f9                	mov    %edi,%ecx
  801dbb:	d3 e0                	shl    %cl,%eax
  801dbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dc1:	89 d6                	mov    %edx,%esi
  801dc3:	89 e9                	mov    %ebp,%ecx
  801dc5:	d3 ee                	shr    %cl,%esi
  801dc7:	89 f9                	mov    %edi,%ecx
  801dc9:	d3 e2                	shl    %cl,%edx
  801dcb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801dcf:	89 e9                	mov    %ebp,%ecx
  801dd1:	d3 eb                	shr    %cl,%ebx
  801dd3:	09 da                	or     %ebx,%edx
  801dd5:	89 d0                	mov    %edx,%eax
  801dd7:	89 f2                	mov    %esi,%edx
  801dd9:	f7 74 24 08          	divl   0x8(%esp)
  801ddd:	89 d6                	mov    %edx,%esi
  801ddf:	89 c3                	mov    %eax,%ebx
  801de1:	f7 64 24 0c          	mull   0xc(%esp)
  801de5:	39 d6                	cmp    %edx,%esi
  801de7:	72 17                	jb     801e00 <__udivdi3+0xfc>
  801de9:	74 09                	je     801df4 <__udivdi3+0xf0>
  801deb:	89 d8                	mov    %ebx,%eax
  801ded:	31 ff                	xor    %edi,%edi
  801def:	e9 56 ff ff ff       	jmp    801d4a <__udivdi3+0x46>
  801df4:	8b 54 24 04          	mov    0x4(%esp),%edx
  801df8:	89 f9                	mov    %edi,%ecx
  801dfa:	d3 e2                	shl    %cl,%edx
  801dfc:	39 c2                	cmp    %eax,%edx
  801dfe:	73 eb                	jae    801deb <__udivdi3+0xe7>
  801e00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e03:	31 ff                	xor    %edi,%edi
  801e05:	e9 40 ff ff ff       	jmp    801d4a <__udivdi3+0x46>
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	31 c0                	xor    %eax,%eax
  801e0e:	e9 37 ff ff ff       	jmp    801d4a <__udivdi3+0x46>
  801e13:	90                   	nop

00801e14 <__umoddi3>:
  801e14:	55                   	push   %ebp
  801e15:	57                   	push   %edi
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 1c             	sub    $0x1c,%esp
  801e1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e33:	89 3c 24             	mov    %edi,(%esp)
  801e36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e3a:	89 f2                	mov    %esi,%edx
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	75 18                	jne    801e58 <__umoddi3+0x44>
  801e40:	39 f7                	cmp    %esi,%edi
  801e42:	0f 86 a0 00 00 00    	jbe    801ee8 <__umoddi3+0xd4>
  801e48:	89 c8                	mov    %ecx,%eax
  801e4a:	f7 f7                	div    %edi
  801e4c:	89 d0                	mov    %edx,%eax
  801e4e:	31 d2                	xor    %edx,%edx
  801e50:	83 c4 1c             	add    $0x1c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
  801e58:	89 f3                	mov    %esi,%ebx
  801e5a:	39 f0                	cmp    %esi,%eax
  801e5c:	0f 87 a6 00 00 00    	ja     801f08 <__umoddi3+0xf4>
  801e62:	0f bd e8             	bsr    %eax,%ebp
  801e65:	83 f5 1f             	xor    $0x1f,%ebp
  801e68:	0f 84 a6 00 00 00    	je     801f14 <__umoddi3+0x100>
  801e6e:	bf 20 00 00 00       	mov    $0x20,%edi
  801e73:	29 ef                	sub    %ebp,%edi
  801e75:	89 e9                	mov    %ebp,%ecx
  801e77:	d3 e0                	shl    %cl,%eax
  801e79:	8b 34 24             	mov    (%esp),%esi
  801e7c:	89 f2                	mov    %esi,%edx
  801e7e:	89 f9                	mov    %edi,%ecx
  801e80:	d3 ea                	shr    %cl,%edx
  801e82:	09 c2                	or     %eax,%edx
  801e84:	89 14 24             	mov    %edx,(%esp)
  801e87:	89 f2                	mov    %esi,%edx
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	d3 e2                	shl    %cl,%edx
  801e8d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e91:	89 de                	mov    %ebx,%esi
  801e93:	89 f9                	mov    %edi,%ecx
  801e95:	d3 ee                	shr    %cl,%esi
  801e97:	89 e9                	mov    %ebp,%ecx
  801e99:	d3 e3                	shl    %cl,%ebx
  801e9b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e9f:	89 d0                	mov    %edx,%eax
  801ea1:	89 f9                	mov    %edi,%ecx
  801ea3:	d3 e8                	shr    %cl,%eax
  801ea5:	09 d8                	or     %ebx,%eax
  801ea7:	89 d3                	mov    %edx,%ebx
  801ea9:	89 e9                	mov    %ebp,%ecx
  801eab:	d3 e3                	shl    %cl,%ebx
  801ead:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801eb1:	89 f2                	mov    %esi,%edx
  801eb3:	f7 34 24             	divl   (%esp)
  801eb6:	89 d6                	mov    %edx,%esi
  801eb8:	f7 64 24 04          	mull   0x4(%esp)
  801ebc:	89 c3                	mov    %eax,%ebx
  801ebe:	89 d1                	mov    %edx,%ecx
  801ec0:	39 d6                	cmp    %edx,%esi
  801ec2:	72 7c                	jb     801f40 <__umoddi3+0x12c>
  801ec4:	74 72                	je     801f38 <__umoddi3+0x124>
  801ec6:	8b 54 24 08          	mov    0x8(%esp),%edx
  801eca:	29 da                	sub    %ebx,%edx
  801ecc:	19 ce                	sbb    %ecx,%esi
  801ece:	89 f0                	mov    %esi,%eax
  801ed0:	89 f9                	mov    %edi,%ecx
  801ed2:	d3 e0                	shl    %cl,%eax
  801ed4:	89 e9                	mov    %ebp,%ecx
  801ed6:	d3 ea                	shr    %cl,%edx
  801ed8:	09 d0                	or     %edx,%eax
  801eda:	89 e9                	mov    %ebp,%ecx
  801edc:	d3 ee                	shr    %cl,%esi
  801ede:	89 f2                	mov    %esi,%edx
  801ee0:	83 c4 1c             	add    $0x1c,%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5f                   	pop    %edi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    
  801ee8:	89 fd                	mov    %edi,%ebp
  801eea:	85 ff                	test   %edi,%edi
  801eec:	75 0b                	jne    801ef9 <__umoddi3+0xe5>
  801eee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef3:	31 d2                	xor    %edx,%edx
  801ef5:	f7 f7                	div    %edi
  801ef7:	89 c5                	mov    %eax,%ebp
  801ef9:	89 f0                	mov    %esi,%eax
  801efb:	31 d2                	xor    %edx,%edx
  801efd:	f7 f5                	div    %ebp
  801eff:	89 c8                	mov    %ecx,%eax
  801f01:	f7 f5                	div    %ebp
  801f03:	e9 44 ff ff ff       	jmp    801e4c <__umoddi3+0x38>
  801f08:	89 c8                	mov    %ecx,%eax
  801f0a:	89 f2                	mov    %esi,%edx
  801f0c:	83 c4 1c             	add    $0x1c,%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5e                   	pop    %esi
  801f11:	5f                   	pop    %edi
  801f12:	5d                   	pop    %ebp
  801f13:	c3                   	ret    
  801f14:	39 f0                	cmp    %esi,%eax
  801f16:	72 05                	jb     801f1d <__umoddi3+0x109>
  801f18:	39 0c 24             	cmp    %ecx,(%esp)
  801f1b:	77 0c                	ja     801f29 <__umoddi3+0x115>
  801f1d:	89 f2                	mov    %esi,%edx
  801f1f:	29 f9                	sub    %edi,%ecx
  801f21:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f25:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f29:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f2d:	83 c4 1c             	add    $0x1c,%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5f                   	pop    %edi
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    
  801f35:	8d 76 00             	lea    0x0(%esi),%esi
  801f38:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f3c:	73 88                	jae    801ec6 <__umoddi3+0xb2>
  801f3e:	66 90                	xchg   %ax,%ax
  801f40:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f44:	1b 14 24             	sbb    (%esp),%edx
  801f47:	89 d1                	mov    %edx,%ecx
  801f49:	89 c3                	mov    %eax,%ebx
  801f4b:	e9 76 ff ff ff       	jmp    801ec6 <__umoddi3+0xb2>
