
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 67 00 00 00       	call   800098 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 04 40 80 00       	mov    0x804004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 60 1f 80 00       	push   $0x801f60
  800048:	e8 45 01 00 00       	call   800192 <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 bc 0b 00 00       	call   800c16 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 80 1f 80 00       	push   $0x801f80
  80006c:	e8 21 01 00 00       	call   800192 <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	43                   	inc    %ebx
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	83 fb 05             	cmp    $0x5,%ebx
  800078:	75 db                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007a:	a1 04 40 80 00       	mov    0x804004,%eax
  80007f:	8b 40 48             	mov    0x48(%eax),%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 ac 1f 80 00       	push   $0x801fac
  80008b:	e8 02 01 00 00       	call   800192 <cprintf>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800096:	c9                   	leave  
  800097:	c3                   	ret    

00800098 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	56                   	push   %esi
  80009c:	53                   	push   %ebx
  80009d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a3:	e8 88 0a 00 00       	call   800b30 <sys_getenvid>
  8000a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ad:	89 c2                	mov    %eax,%edx
  8000af:	c1 e2 05             	shl    $0x5,%edx
  8000b2:	29 c2                	sub    %eax,%edx
  8000b4:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000bb:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c0:	85 db                	test   %ebx,%ebx
  8000c2:	7e 07                	jle    8000cb <libmain+0x33>
		binaryname = argv[0];
  8000c4:	8b 06                	mov    (%esi),%eax
  8000c6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000cb:	83 ec 08             	sub    $0x8,%esp
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
  8000d0:	e8 5e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d5:	e8 0a 00 00 00       	call   8000e4 <exit>
}
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e0:	5b                   	pop    %ebx
  8000e1:	5e                   	pop    %esi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    

008000e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ea:	e8 e9 0e 00 00       	call   800fd8 <close_all>
	sys_env_destroy(0);
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	6a 00                	push   $0x0
  8000f4:	e8 f6 09 00 00       	call   800aef <sys_env_destroy>
}
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	c9                   	leave  
  8000fd:	c3                   	ret    

008000fe <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	53                   	push   %ebx
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800108:	8b 13                	mov    (%ebx),%edx
  80010a:	8d 42 01             	lea    0x1(%edx),%eax
  80010d:	89 03                	mov    %eax,(%ebx)
  80010f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800112:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800116:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011b:	74 08                	je     800125 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011d:	ff 43 04             	incl   0x4(%ebx)
}
  800120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800123:	c9                   	leave  
  800124:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	68 ff 00 00 00       	push   $0xff
  80012d:	8d 43 08             	lea    0x8(%ebx),%eax
  800130:	50                   	push   %eax
  800131:	e8 7c 09 00 00       	call   800ab2 <sys_cputs>
		b->idx = 0;
  800136:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	eb dc                	jmp    80011d <putch+0x1f>

00800141 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80014a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800151:	00 00 00 
	b.cnt = 0;
  800154:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015e:	ff 75 0c             	pushl  0xc(%ebp)
  800161:	ff 75 08             	pushl  0x8(%ebp)
  800164:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016a:	50                   	push   %eax
  80016b:	68 fe 00 80 00       	push   $0x8000fe
  800170:	e8 17 01 00 00       	call   80028c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800175:	83 c4 08             	add    $0x8,%esp
  800178:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 28 09 00 00       	call   800ab2 <sys_cputs>

	return b.cnt;
}
  80018a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800198:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019b:	50                   	push   %eax
  80019c:	ff 75 08             	pushl  0x8(%ebp)
  80019f:	e8 9d ff ff ff       	call   800141 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	57                   	push   %edi
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 1c             	sub    $0x1c,%esp
  8001af:	89 c7                	mov    %eax,%edi
  8001b1:	89 d6                	mov    %edx,%esi
  8001b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ca:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001cd:	39 d3                	cmp    %edx,%ebx
  8001cf:	72 05                	jb     8001d6 <printnum+0x30>
  8001d1:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d4:	77 78                	ja     80024e <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 18             	pushl  0x18(%ebp)
  8001dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8001df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001e2:	53                   	push   %ebx
  8001e3:	ff 75 10             	pushl  0x10(%ebp)
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f5:	e8 fe 1a 00 00       	call   801cf8 <__udivdi3>
  8001fa:	83 c4 18             	add    $0x18,%esp
  8001fd:	52                   	push   %edx
  8001fe:	50                   	push   %eax
  8001ff:	89 f2                	mov    %esi,%edx
  800201:	89 f8                	mov    %edi,%eax
  800203:	e8 9e ff ff ff       	call   8001a6 <printnum>
  800208:	83 c4 20             	add    $0x20,%esp
  80020b:	eb 11                	jmp    80021e <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	56                   	push   %esi
  800211:	ff 75 18             	pushl  0x18(%ebp)
  800214:	ff d7                	call   *%edi
  800216:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800219:	4b                   	dec    %ebx
  80021a:	85 db                	test   %ebx,%ebx
  80021c:	7f ef                	jg     80020d <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021e:	83 ec 08             	sub    $0x8,%esp
  800221:	56                   	push   %esi
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e4             	pushl  -0x1c(%ebp)
  800228:	ff 75 e0             	pushl  -0x20(%ebp)
  80022b:	ff 75 dc             	pushl  -0x24(%ebp)
  80022e:	ff 75 d8             	pushl  -0x28(%ebp)
  800231:	e8 d2 1b 00 00       	call   801e08 <__umoddi3>
  800236:	83 c4 14             	add    $0x14,%esp
  800239:	0f be 80 d5 1f 80 00 	movsbl 0x801fd5(%eax),%eax
  800240:	50                   	push   %eax
  800241:	ff d7                	call   *%edi
}
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800249:	5b                   	pop    %ebx
  80024a:	5e                   	pop    %esi
  80024b:	5f                   	pop    %edi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    
  80024e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800251:	eb c6                	jmp    800219 <printnum+0x73>

00800253 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800259:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1a>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800275:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 10             	pushl  0x10(%ebp)
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	ff 75 08             	pushl  0x8(%ebp)
  800282:	e8 05 00 00 00       	call   80028c <vprintfmt>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <vprintfmt>:
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 2c             	sub    $0x2c,%esp
  800295:	8b 75 08             	mov    0x8(%ebp),%esi
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029e:	e9 ae 03 00 00       	jmp    800651 <vprintfmt+0x3c5>
  8002a3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002a7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002ae:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c1:	8d 47 01             	lea    0x1(%edi),%eax
  8002c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c7:	8a 17                	mov    (%edi),%dl
  8002c9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002cc:	3c 55                	cmp    $0x55,%al
  8002ce:	0f 87 fe 03 00 00    	ja     8006d2 <vprintfmt+0x446>
  8002d4:	0f b6 c0             	movzbl %al,%eax
  8002d7:	ff 24 85 20 21 80 00 	jmp    *0x802120(,%eax,4)
  8002de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e1:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002e5:	eb da                	jmp    8002c1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002ea:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002ee:	eb d1                	jmp    8002c1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f0:	0f b6 d2             	movzbl %dl,%edx
  8002f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002fe:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800301:	01 c0                	add    %eax,%eax
  800303:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800307:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80030a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80030d:	83 f9 09             	cmp    $0x9,%ecx
  800310:	77 52                	ja     800364 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800312:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800313:	eb e9                	jmp    8002fe <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800315:	8b 45 14             	mov    0x14(%ebp),%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80031d:	8b 45 14             	mov    0x14(%ebp),%eax
  800320:	8d 40 04             	lea    0x4(%eax),%eax
  800323:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800326:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800329:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032d:	79 92                	jns    8002c1 <vprintfmt+0x35>
				width = precision, precision = -1;
  80032f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800332:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800335:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80033c:	eb 83                	jmp    8002c1 <vprintfmt+0x35>
  80033e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800342:	78 08                	js     80034c <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800347:	e9 75 ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
  80034c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800353:	eb ef                	jmp    800344 <vprintfmt+0xb8>
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800358:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80035f:	e9 5d ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
  800364:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800367:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80036a:	eb bd                	jmp    800329 <vprintfmt+0x9d>
			lflag++;
  80036c:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800370:	e9 4c ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800375:	8b 45 14             	mov    0x14(%ebp),%eax
  800378:	8d 78 04             	lea    0x4(%eax),%edi
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	53                   	push   %ebx
  80037f:	ff 30                	pushl  (%eax)
  800381:	ff d6                	call   *%esi
			break;
  800383:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800386:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800389:	e9 c0 02 00 00       	jmp    80064e <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80038e:	8b 45 14             	mov    0x14(%ebp),%eax
  800391:	8d 78 04             	lea    0x4(%eax),%edi
  800394:	8b 00                	mov    (%eax),%eax
  800396:	85 c0                	test   %eax,%eax
  800398:	78 2a                	js     8003c4 <vprintfmt+0x138>
  80039a:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80039c:	83 f8 0f             	cmp    $0xf,%eax
  80039f:	7f 27                	jg     8003c8 <vprintfmt+0x13c>
  8003a1:	8b 04 85 80 22 80 00 	mov    0x802280(,%eax,4),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	74 1c                	je     8003c8 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8003ac:	50                   	push   %eax
  8003ad:	68 b1 23 80 00       	push   $0x8023b1
  8003b2:	53                   	push   %ebx
  8003b3:	56                   	push   %esi
  8003b4:	e8 b6 fe ff ff       	call   80026f <printfmt>
  8003b9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003bf:	e9 8a 02 00 00       	jmp    80064e <vprintfmt+0x3c2>
  8003c4:	f7 d8                	neg    %eax
  8003c6:	eb d2                	jmp    80039a <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8003c8:	52                   	push   %edx
  8003c9:	68 ed 1f 80 00       	push   $0x801fed
  8003ce:	53                   	push   %ebx
  8003cf:	56                   	push   %esi
  8003d0:	e8 9a fe ff ff       	call   80026f <printfmt>
  8003d5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003db:	e9 6e 02 00 00       	jmp    80064e <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e3:	83 c0 04             	add    $0x4,%eax
  8003e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8b 38                	mov    (%eax),%edi
  8003ee:	85 ff                	test   %edi,%edi
  8003f0:	74 39                	je     80042b <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8003f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f6:	0f 8e a9 00 00 00    	jle    8004a5 <vprintfmt+0x219>
  8003fc:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800400:	0f 84 a7 00 00 00    	je     8004ad <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	ff 75 d0             	pushl  -0x30(%ebp)
  80040c:	57                   	push   %edi
  80040d:	e8 6b 03 00 00       	call   80077d <strnlen>
  800412:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800415:	29 c1                	sub    %eax,%ecx
  800417:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80041a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80041d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800421:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800424:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800427:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800429:	eb 14                	jmp    80043f <vprintfmt+0x1b3>
				p = "(null)";
  80042b:	bf e6 1f 80 00       	mov    $0x801fe6,%edi
  800430:	eb c0                	jmp    8003f2 <vprintfmt+0x166>
					putch(padc, putdat);
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	53                   	push   %ebx
  800436:	ff 75 e0             	pushl  -0x20(%ebp)
  800439:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80043b:	4f                   	dec    %edi
  80043c:	83 c4 10             	add    $0x10,%esp
  80043f:	85 ff                	test   %edi,%edi
  800441:	7f ef                	jg     800432 <vprintfmt+0x1a6>
  800443:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800446:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800449:	89 c8                	mov    %ecx,%eax
  80044b:	85 c9                	test   %ecx,%ecx
  80044d:	78 10                	js     80045f <vprintfmt+0x1d3>
  80044f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800457:	89 75 08             	mov    %esi,0x8(%ebp)
  80045a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80045d:	eb 15                	jmp    800474 <vprintfmt+0x1e8>
  80045f:	b8 00 00 00 00       	mov    $0x0,%eax
  800464:	eb e9                	jmp    80044f <vprintfmt+0x1c3>
					putch(ch, putdat);
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	53                   	push   %ebx
  80046a:	52                   	push   %edx
  80046b:	ff 55 08             	call   *0x8(%ebp)
  80046e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800471:	ff 4d e0             	decl   -0x20(%ebp)
  800474:	47                   	inc    %edi
  800475:	8a 47 ff             	mov    -0x1(%edi),%al
  800478:	0f be d0             	movsbl %al,%edx
  80047b:	85 d2                	test   %edx,%edx
  80047d:	74 59                	je     8004d8 <vprintfmt+0x24c>
  80047f:	85 f6                	test   %esi,%esi
  800481:	78 03                	js     800486 <vprintfmt+0x1fa>
  800483:	4e                   	dec    %esi
  800484:	78 2f                	js     8004b5 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800486:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048a:	74 da                	je     800466 <vprintfmt+0x1da>
  80048c:	0f be c0             	movsbl %al,%eax
  80048f:	83 e8 20             	sub    $0x20,%eax
  800492:	83 f8 5e             	cmp    $0x5e,%eax
  800495:	76 cf                	jbe    800466 <vprintfmt+0x1da>
					putch('?', putdat);
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	53                   	push   %ebx
  80049b:	6a 3f                	push   $0x3f
  80049d:	ff 55 08             	call   *0x8(%ebp)
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	eb cc                	jmp    800471 <vprintfmt+0x1e5>
  8004a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ab:	eb c7                	jmp    800474 <vprintfmt+0x1e8>
  8004ad:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004b3:	eb bf                	jmp    800474 <vprintfmt+0x1e8>
  8004b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004bb:	eb 0c                	jmp    8004c9 <vprintfmt+0x23d>
				putch(' ', putdat);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	53                   	push   %ebx
  8004c1:	6a 20                	push   $0x20
  8004c3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004c5:	4f                   	dec    %edi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	85 ff                	test   %edi,%edi
  8004cb:	7f f0                	jg     8004bd <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8004cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8004d3:	e9 76 01 00 00       	jmp    80064e <vprintfmt+0x3c2>
  8004d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004db:	8b 75 08             	mov    0x8(%ebp),%esi
  8004de:	eb e9                	jmp    8004c9 <vprintfmt+0x23d>
	if (lflag >= 2)
  8004e0:	83 f9 01             	cmp    $0x1,%ecx
  8004e3:	7f 1f                	jg     800504 <vprintfmt+0x278>
	else if (lflag)
  8004e5:	85 c9                	test   %ecx,%ecx
  8004e7:	75 48                	jne    800531 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8004e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f1:	89 c1                	mov    %eax,%ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 40 04             	lea    0x4(%eax),%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800502:	eb 17                	jmp    80051b <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8b 50 04             	mov    0x4(%eax),%edx
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 40 08             	lea    0x8(%eax),%eax
  800518:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80051b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80051e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800521:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800525:	78 25                	js     80054c <vprintfmt+0x2c0>
			base = 10;
  800527:	b8 0a 00 00 00       	mov    $0xa,%eax
  80052c:	e9 03 01 00 00       	jmp    800634 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800539:	89 c1                	mov    %eax,%ecx
  80053b:	c1 f9 1f             	sar    $0x1f,%ecx
  80053e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 40 04             	lea    0x4(%eax),%eax
  800547:	89 45 14             	mov    %eax,0x14(%ebp)
  80054a:	eb cf                	jmp    80051b <vprintfmt+0x28f>
				putch('-', putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	53                   	push   %ebx
  800550:	6a 2d                	push   $0x2d
  800552:	ff d6                	call   *%esi
				num = -(long long) num;
  800554:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800557:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80055a:	f7 da                	neg    %edx
  80055c:	83 d1 00             	adc    $0x0,%ecx
  80055f:	f7 d9                	neg    %ecx
  800561:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800564:	b8 0a 00 00 00       	mov    $0xa,%eax
  800569:	e9 c6 00 00 00       	jmp    800634 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80056e:	83 f9 01             	cmp    $0x1,%ecx
  800571:	7f 1e                	jg     800591 <vprintfmt+0x305>
	else if (lflag)
  800573:	85 c9                	test   %ecx,%ecx
  800575:	75 32                	jne    8005a9 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 10                	mov    (%eax),%edx
  80057c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800581:	8d 40 04             	lea    0x4(%eax),%eax
  800584:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058c:	e9 a3 00 00 00       	jmp    800634 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
  800596:	8b 48 04             	mov    0x4(%eax),%ecx
  800599:	8d 40 08             	lea    0x8(%eax),%eax
  80059c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a4:	e9 8b 00 00 00       	jmp    800634 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 10                	mov    (%eax),%edx
  8005ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b3:	8d 40 04             	lea    0x4(%eax),%eax
  8005b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005be:	eb 74                	jmp    800634 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005c0:	83 f9 01             	cmp    $0x1,%ecx
  8005c3:	7f 1b                	jg     8005e0 <vprintfmt+0x354>
	else if (lflag)
  8005c5:	85 c9                	test   %ecx,%ecx
  8005c7:	75 2c                	jne    8005f5 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 10                	mov    (%eax),%edx
  8005ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d3:	8d 40 04             	lea    0x4(%eax),%eax
  8005d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d9:	b8 08 00 00 00       	mov    $0x8,%eax
  8005de:	eb 54                	jmp    800634 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e8:	8d 40 08             	lea    0x8(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f3:	eb 3f                	jmp    800634 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 10                	mov    (%eax),%edx
  8005fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ff:	8d 40 04             	lea    0x4(%eax),%eax
  800602:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800605:	b8 08 00 00 00       	mov    $0x8,%eax
  80060a:	eb 28                	jmp    800634 <vprintfmt+0x3a8>
			putch('0', putdat);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	53                   	push   %ebx
  800610:	6a 30                	push   $0x30
  800612:	ff d6                	call   *%esi
			putch('x', putdat);
  800614:	83 c4 08             	add    $0x8,%esp
  800617:	53                   	push   %ebx
  800618:	6a 78                	push   $0x78
  80061a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 10                	mov    (%eax),%edx
  800621:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800626:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800634:	83 ec 0c             	sub    $0xc,%esp
  800637:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80063b:	57                   	push   %edi
  80063c:	ff 75 e0             	pushl  -0x20(%ebp)
  80063f:	50                   	push   %eax
  800640:	51                   	push   %ecx
  800641:	52                   	push   %edx
  800642:	89 da                	mov    %ebx,%edx
  800644:	89 f0                	mov    %esi,%eax
  800646:	e8 5b fb ff ff       	call   8001a6 <printnum>
			break;
  80064b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80064e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800651:	47                   	inc    %edi
  800652:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800656:	83 f8 25             	cmp    $0x25,%eax
  800659:	0f 84 44 fc ff ff    	je     8002a3 <vprintfmt+0x17>
			if (ch == '\0')
  80065f:	85 c0                	test   %eax,%eax
  800661:	0f 84 89 00 00 00    	je     8006f0 <vprintfmt+0x464>
			putch(ch, putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	50                   	push   %eax
  80066c:	ff d6                	call   *%esi
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	eb de                	jmp    800651 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7f 1b                	jg     800693 <vprintfmt+0x407>
	else if (lflag)
  800678:	85 c9                	test   %ecx,%ecx
  80067a:	75 2c                	jne    8006a8 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 10                	mov    (%eax),%edx
  800681:	b9 00 00 00 00       	mov    $0x0,%ecx
  800686:	8d 40 04             	lea    0x4(%eax),%eax
  800689:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068c:	b8 10 00 00 00       	mov    $0x10,%eax
  800691:	eb a1                	jmp    800634 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 10                	mov    (%eax),%edx
  800698:	8b 48 04             	mov    0x4(%eax),%ecx
  80069b:	8d 40 08             	lea    0x8(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a1:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a6:	eb 8c                	jmp    800634 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 10                	mov    (%eax),%edx
  8006ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006bd:	e9 72 ff ff ff       	jmp    800634 <vprintfmt+0x3a8>
			putch(ch, putdat);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	53                   	push   %ebx
  8006c6:	6a 25                	push   $0x25
  8006c8:	ff d6                	call   *%esi
			break;
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	e9 7c ff ff ff       	jmp    80064e <vprintfmt+0x3c2>
			putch('%', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 25                	push   $0x25
  8006d8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	89 f8                	mov    %edi,%eax
  8006df:	eb 01                	jmp    8006e2 <vprintfmt+0x456>
  8006e1:	48                   	dec    %eax
  8006e2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e6:	75 f9                	jne    8006e1 <vprintfmt+0x455>
  8006e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006eb:	e9 5e ff ff ff       	jmp    80064e <vprintfmt+0x3c2>
}
  8006f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f3:	5b                   	pop    %ebx
  8006f4:	5e                   	pop    %esi
  8006f5:	5f                   	pop    %edi
  8006f6:	5d                   	pop    %ebp
  8006f7:	c3                   	ret    

008006f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	83 ec 18             	sub    $0x18,%esp
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800704:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800707:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80070b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80070e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800715:	85 c0                	test   %eax,%eax
  800717:	74 26                	je     80073f <vsnprintf+0x47>
  800719:	85 d2                	test   %edx,%edx
  80071b:	7e 29                	jle    800746 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80071d:	ff 75 14             	pushl  0x14(%ebp)
  800720:	ff 75 10             	pushl  0x10(%ebp)
  800723:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800726:	50                   	push   %eax
  800727:	68 53 02 80 00       	push   $0x800253
  80072c:	e8 5b fb ff ff       	call   80028c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800734:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80073a:	83 c4 10             	add    $0x10,%esp
}
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    
		return -E_INVAL;
  80073f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800744:	eb f7                	jmp    80073d <vsnprintf+0x45>
  800746:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074b:	eb f0                	jmp    80073d <vsnprintf+0x45>

0080074d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800753:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800756:	50                   	push   %eax
  800757:	ff 75 10             	pushl  0x10(%ebp)
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	ff 75 08             	pushl  0x8(%ebp)
  800760:	e8 93 ff ff ff       	call   8006f8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80076d:	b8 00 00 00 00       	mov    $0x0,%eax
  800772:	eb 01                	jmp    800775 <strlen+0xe>
		n++;
  800774:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800775:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800779:	75 f9                	jne    800774 <strlen+0xd>
	return n;
}
  80077b:	5d                   	pop    %ebp
  80077c:	c3                   	ret    

0080077d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800783:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800786:	b8 00 00 00 00       	mov    $0x0,%eax
  80078b:	eb 01                	jmp    80078e <strnlen+0x11>
		n++;
  80078d:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078e:	39 d0                	cmp    %edx,%eax
  800790:	74 06                	je     800798 <strnlen+0x1b>
  800792:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800796:	75 f5                	jne    80078d <strnlen+0x10>
	return n;
}
  800798:	5d                   	pop    %ebp
  800799:	c3                   	ret    

0080079a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	42                   	inc    %edx
  8007a7:	41                   	inc    %ecx
  8007a8:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8007ab:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ae:	84 db                	test   %bl,%bl
  8007b0:	75 f4                	jne    8007a6 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007b2:	5b                   	pop    %ebx
  8007b3:	5d                   	pop    %ebp
  8007b4:	c3                   	ret    

008007b5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	53                   	push   %ebx
  8007b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007bc:	53                   	push   %ebx
  8007bd:	e8 a5 ff ff ff       	call   800767 <strlen>
  8007c2:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007c5:	ff 75 0c             	pushl  0xc(%ebp)
  8007c8:	01 d8                	add    %ebx,%eax
  8007ca:	50                   	push   %eax
  8007cb:	e8 ca ff ff ff       	call   80079a <strcpy>
	return dst;
}
  8007d0:	89 d8                	mov    %ebx,%eax
  8007d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d5:	c9                   	leave  
  8007d6:	c3                   	ret    

008007d7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	56                   	push   %esi
  8007db:	53                   	push   %ebx
  8007dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e2:	89 f3                	mov    %esi,%ebx
  8007e4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e7:	89 f2                	mov    %esi,%edx
  8007e9:	eb 0c                	jmp    8007f7 <strncpy+0x20>
		*dst++ = *src;
  8007eb:	42                   	inc    %edx
  8007ec:	8a 01                	mov    (%ecx),%al
  8007ee:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f1:	80 39 01             	cmpb   $0x1,(%ecx)
  8007f4:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007f7:	39 da                	cmp    %ebx,%edx
  8007f9:	75 f0                	jne    8007eb <strncpy+0x14>
	}
	return ret;
}
  8007fb:	89 f0                	mov    %esi,%eax
  8007fd:	5b                   	pop    %ebx
  8007fe:	5e                   	pop    %esi
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	56                   	push   %esi
  800805:	53                   	push   %ebx
  800806:	8b 75 08             	mov    0x8(%ebp),%esi
  800809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080c:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80080f:	85 c0                	test   %eax,%eax
  800811:	74 20                	je     800833 <strlcpy+0x32>
  800813:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800817:	89 f0                	mov    %esi,%eax
  800819:	eb 05                	jmp    800820 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80081b:	40                   	inc    %eax
  80081c:	42                   	inc    %edx
  80081d:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800820:	39 d8                	cmp    %ebx,%eax
  800822:	74 06                	je     80082a <strlcpy+0x29>
  800824:	8a 0a                	mov    (%edx),%cl
  800826:	84 c9                	test   %cl,%cl
  800828:	75 f1                	jne    80081b <strlcpy+0x1a>
		*dst = '\0';
  80082a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80082d:	29 f0                	sub    %esi,%eax
}
  80082f:	5b                   	pop    %ebx
  800830:	5e                   	pop    %esi
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    
  800833:	89 f0                	mov    %esi,%eax
  800835:	eb f6                	jmp    80082d <strlcpy+0x2c>

00800837 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800840:	eb 02                	jmp    800844 <strcmp+0xd>
		p++, q++;
  800842:	41                   	inc    %ecx
  800843:	42                   	inc    %edx
	while (*p && *p == *q)
  800844:	8a 01                	mov    (%ecx),%al
  800846:	84 c0                	test   %al,%al
  800848:	74 04                	je     80084e <strcmp+0x17>
  80084a:	3a 02                	cmp    (%edx),%al
  80084c:	74 f4                	je     800842 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80084e:	0f b6 c0             	movzbl %al,%eax
  800851:	0f b6 12             	movzbl (%edx),%edx
  800854:	29 d0                	sub    %edx,%eax
}
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	53                   	push   %ebx
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800862:	89 c3                	mov    %eax,%ebx
  800864:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800867:	eb 02                	jmp    80086b <strncmp+0x13>
		n--, p++, q++;
  800869:	40                   	inc    %eax
  80086a:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  80086b:	39 d8                	cmp    %ebx,%eax
  80086d:	74 15                	je     800884 <strncmp+0x2c>
  80086f:	8a 08                	mov    (%eax),%cl
  800871:	84 c9                	test   %cl,%cl
  800873:	74 04                	je     800879 <strncmp+0x21>
  800875:	3a 0a                	cmp    (%edx),%cl
  800877:	74 f0                	je     800869 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800879:	0f b6 00             	movzbl (%eax),%eax
  80087c:	0f b6 12             	movzbl (%edx),%edx
  80087f:	29 d0                	sub    %edx,%eax
}
  800881:	5b                   	pop    %ebx
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    
		return 0;
  800884:	b8 00 00 00 00       	mov    $0x0,%eax
  800889:	eb f6                	jmp    800881 <strncmp+0x29>

0080088b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800894:	8a 10                	mov    (%eax),%dl
  800896:	84 d2                	test   %dl,%dl
  800898:	74 07                	je     8008a1 <strchr+0x16>
		if (*s == c)
  80089a:	38 ca                	cmp    %cl,%dl
  80089c:	74 08                	je     8008a6 <strchr+0x1b>
	for (; *s; s++)
  80089e:	40                   	inc    %eax
  80089f:	eb f3                	jmp    800894 <strchr+0x9>
			return (char *) s;
	return 0;
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008b1:	8a 10                	mov    (%eax),%dl
  8008b3:	84 d2                	test   %dl,%dl
  8008b5:	74 07                	je     8008be <strfind+0x16>
		if (*s == c)
  8008b7:	38 ca                	cmp    %cl,%dl
  8008b9:	74 03                	je     8008be <strfind+0x16>
	for (; *s; s++)
  8008bb:	40                   	inc    %eax
  8008bc:	eb f3                	jmp    8008b1 <strfind+0x9>
			break;
	return (char *) s;
}
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	57                   	push   %edi
  8008c4:	56                   	push   %esi
  8008c5:	53                   	push   %ebx
  8008c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008cc:	85 c9                	test   %ecx,%ecx
  8008ce:	74 13                	je     8008e3 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008d0:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008d6:	75 05                	jne    8008dd <memset+0x1d>
  8008d8:	f6 c1 03             	test   $0x3,%cl
  8008db:	74 0d                	je     8008ea <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e0:	fc                   	cld    
  8008e1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008e3:	89 f8                	mov    %edi,%eax
  8008e5:	5b                   	pop    %ebx
  8008e6:	5e                   	pop    %esi
  8008e7:	5f                   	pop    %edi
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    
		c &= 0xFF;
  8008ea:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ee:	89 d3                	mov    %edx,%ebx
  8008f0:	c1 e3 08             	shl    $0x8,%ebx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	c1 e0 18             	shl    $0x18,%eax
  8008f8:	89 d6                	mov    %edx,%esi
  8008fa:	c1 e6 10             	shl    $0x10,%esi
  8008fd:	09 f0                	or     %esi,%eax
  8008ff:	09 c2                	or     %eax,%edx
  800901:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800903:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800906:	89 d0                	mov    %edx,%eax
  800908:	fc                   	cld    
  800909:	f3 ab                	rep stos %eax,%es:(%edi)
  80090b:	eb d6                	jmp    8008e3 <memset+0x23>

0080090d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	57                   	push   %edi
  800911:	56                   	push   %esi
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 75 0c             	mov    0xc(%ebp),%esi
  800918:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80091b:	39 c6                	cmp    %eax,%esi
  80091d:	73 33                	jae    800952 <memmove+0x45>
  80091f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800922:	39 d0                	cmp    %edx,%eax
  800924:	73 2c                	jae    800952 <memmove+0x45>
		s += n;
		d += n;
  800926:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800929:	89 d6                	mov    %edx,%esi
  80092b:	09 fe                	or     %edi,%esi
  80092d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800933:	75 13                	jne    800948 <memmove+0x3b>
  800935:	f6 c1 03             	test   $0x3,%cl
  800938:	75 0e                	jne    800948 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80093a:	83 ef 04             	sub    $0x4,%edi
  80093d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800940:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800943:	fd                   	std    
  800944:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800946:	eb 07                	jmp    80094f <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800948:	4f                   	dec    %edi
  800949:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80094c:	fd                   	std    
  80094d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80094f:	fc                   	cld    
  800950:	eb 13                	jmp    800965 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800952:	89 f2                	mov    %esi,%edx
  800954:	09 c2                	or     %eax,%edx
  800956:	f6 c2 03             	test   $0x3,%dl
  800959:	75 05                	jne    800960 <memmove+0x53>
  80095b:	f6 c1 03             	test   $0x3,%cl
  80095e:	74 09                	je     800969 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800960:	89 c7                	mov    %eax,%edi
  800962:	fc                   	cld    
  800963:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800965:	5e                   	pop    %esi
  800966:	5f                   	pop    %edi
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800969:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80096c:	89 c7                	mov    %eax,%edi
  80096e:	fc                   	cld    
  80096f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800971:	eb f2                	jmp    800965 <memmove+0x58>

00800973 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800976:	ff 75 10             	pushl  0x10(%ebp)
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	ff 75 08             	pushl  0x8(%ebp)
  80097f:	e8 89 ff ff ff       	call   80090d <memmove>
}
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	56                   	push   %esi
  80098a:	53                   	push   %ebx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 c6                	mov    %eax,%esi
  800990:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800996:	39 f0                	cmp    %esi,%eax
  800998:	74 16                	je     8009b0 <memcmp+0x2a>
		if (*s1 != *s2)
  80099a:	8a 08                	mov    (%eax),%cl
  80099c:	8a 1a                	mov    (%edx),%bl
  80099e:	38 d9                	cmp    %bl,%cl
  8009a0:	75 04                	jne    8009a6 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009a2:	40                   	inc    %eax
  8009a3:	42                   	inc    %edx
  8009a4:	eb f0                	jmp    800996 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009a6:	0f b6 c1             	movzbl %cl,%eax
  8009a9:	0f b6 db             	movzbl %bl,%ebx
  8009ac:	29 d8                	sub    %ebx,%eax
  8009ae:	eb 05                	jmp    8009b5 <memcmp+0x2f>
	}

	return 0;
  8009b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b5:	5b                   	pop    %ebx
  8009b6:	5e                   	pop    %esi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009c2:	89 c2                	mov    %eax,%edx
  8009c4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009c7:	39 d0                	cmp    %edx,%eax
  8009c9:	73 07                	jae    8009d2 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009cb:	38 08                	cmp    %cl,(%eax)
  8009cd:	74 03                	je     8009d2 <memfind+0x19>
	for (; s < ends; s++)
  8009cf:	40                   	inc    %eax
  8009d0:	eb f5                	jmp    8009c7 <memfind+0xe>
			break;
	return (void *) s;
}
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	57                   	push   %edi
  8009d8:	56                   	push   %esi
  8009d9:	53                   	push   %ebx
  8009da:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009dd:	eb 01                	jmp    8009e0 <strtol+0xc>
		s++;
  8009df:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8009e0:	8a 01                	mov    (%ecx),%al
  8009e2:	3c 20                	cmp    $0x20,%al
  8009e4:	74 f9                	je     8009df <strtol+0xb>
  8009e6:	3c 09                	cmp    $0x9,%al
  8009e8:	74 f5                	je     8009df <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8009ea:	3c 2b                	cmp    $0x2b,%al
  8009ec:	74 2b                	je     800a19 <strtol+0x45>
		s++;
	else if (*s == '-')
  8009ee:	3c 2d                	cmp    $0x2d,%al
  8009f0:	74 2f                	je     800a21 <strtol+0x4d>
	int neg = 0;
  8009f2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009f7:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8009fe:	75 12                	jne    800a12 <strtol+0x3e>
  800a00:	80 39 30             	cmpb   $0x30,(%ecx)
  800a03:	74 24                	je     800a29 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a09:	75 07                	jne    800a12 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a0b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
  800a17:	eb 4e                	jmp    800a67 <strtol+0x93>
		s++;
  800a19:	41                   	inc    %ecx
	int neg = 0;
  800a1a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1f:	eb d6                	jmp    8009f7 <strtol+0x23>
		s++, neg = 1;
  800a21:	41                   	inc    %ecx
  800a22:	bf 01 00 00 00       	mov    $0x1,%edi
  800a27:	eb ce                	jmp    8009f7 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a29:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a2d:	74 10                	je     800a3f <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a33:	75 dd                	jne    800a12 <strtol+0x3e>
		s++, base = 8;
  800a35:	41                   	inc    %ecx
  800a36:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a3d:	eb d3                	jmp    800a12 <strtol+0x3e>
		s += 2, base = 16;
  800a3f:	83 c1 02             	add    $0x2,%ecx
  800a42:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a49:	eb c7                	jmp    800a12 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a4b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a4e:	89 f3                	mov    %esi,%ebx
  800a50:	80 fb 19             	cmp    $0x19,%bl
  800a53:	77 24                	ja     800a79 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a55:	0f be d2             	movsbl %dl,%edx
  800a58:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a5b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a5e:	7d 2b                	jge    800a8b <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a60:	41                   	inc    %ecx
  800a61:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a65:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a67:	8a 11                	mov    (%ecx),%dl
  800a69:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a6c:	80 fb 09             	cmp    $0x9,%bl
  800a6f:	77 da                	ja     800a4b <strtol+0x77>
			dig = *s - '0';
  800a71:	0f be d2             	movsbl %dl,%edx
  800a74:	83 ea 30             	sub    $0x30,%edx
  800a77:	eb e2                	jmp    800a5b <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a79:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a7c:	89 f3                	mov    %esi,%ebx
  800a7e:	80 fb 19             	cmp    $0x19,%bl
  800a81:	77 08                	ja     800a8b <strtol+0xb7>
			dig = *s - 'A' + 10;
  800a83:	0f be d2             	movsbl %dl,%edx
  800a86:	83 ea 37             	sub    $0x37,%edx
  800a89:	eb d0                	jmp    800a5b <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8f:	74 05                	je     800a96 <strtol+0xc2>
		*endptr = (char *) s;
  800a91:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a94:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a96:	85 ff                	test   %edi,%edi
  800a98:	74 02                	je     800a9c <strtol+0xc8>
  800a9a:	f7 d8                	neg    %eax
}
  800a9c:	5b                   	pop    %ebx
  800a9d:	5e                   	pop    %esi
  800a9e:	5f                   	pop    %edi
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <atoi>:

int
atoi(const char *s)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800aa4:	6a 0a                	push   $0xa
  800aa6:	6a 00                	push   $0x0
  800aa8:	ff 75 08             	pushl  0x8(%ebp)
  800aab:	e8 24 ff ff ff       	call   8009d4 <strtol>
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	57                   	push   %edi
  800ab6:	56                   	push   %esi
  800ab7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac3:	89 c3                	mov    %eax,%ebx
  800ac5:	89 c7                	mov    %eax,%edi
  800ac7:	89 c6                	mov    %eax,%esi
  800ac9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800acb:	5b                   	pop    %ebx
  800acc:	5e                   	pop    %esi
  800acd:	5f                   	pop    %edi
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	57                   	push   %edi
  800ad4:	56                   	push   %esi
  800ad5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  800adb:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae0:	89 d1                	mov    %edx,%ecx
  800ae2:	89 d3                	mov    %edx,%ebx
  800ae4:	89 d7                	mov    %edx,%edi
  800ae6:	89 d6                	mov    %edx,%esi
  800ae8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5f                   	pop    %edi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800af8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afd:	b8 03 00 00 00       	mov    $0x3,%eax
  800b02:	8b 55 08             	mov    0x8(%ebp),%edx
  800b05:	89 cb                	mov    %ecx,%ebx
  800b07:	89 cf                	mov    %ecx,%edi
  800b09:	89 ce                	mov    %ecx,%esi
  800b0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b0d:	85 c0                	test   %eax,%eax
  800b0f:	7f 08                	jg     800b19 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b14:	5b                   	pop    %ebx
  800b15:	5e                   	pop    %esi
  800b16:	5f                   	pop    %edi
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b19:	83 ec 0c             	sub    $0xc,%esp
  800b1c:	50                   	push   %eax
  800b1d:	6a 03                	push   $0x3
  800b1f:	68 df 22 80 00       	push   $0x8022df
  800b24:	6a 23                	push   $0x23
  800b26:	68 fc 22 80 00       	push   $0x8022fc
  800b2b:	e8 df 0f 00 00       	call   801b0f <_panic>

00800b30 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	57                   	push   %edi
  800b34:	56                   	push   %esi
  800b35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b36:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3b:	b8 02 00 00 00       	mov    $0x2,%eax
  800b40:	89 d1                	mov    %edx,%ecx
  800b42:	89 d3                	mov    %edx,%ebx
  800b44:	89 d7                	mov    %edx,%edi
  800b46:	89 d6                	mov    %edx,%esi
  800b48:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b58:	be 00 00 00 00       	mov    $0x0,%esi
  800b5d:	b8 04 00 00 00       	mov    $0x4,%eax
  800b62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b65:	8b 55 08             	mov    0x8(%ebp),%edx
  800b68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b6b:	89 f7                	mov    %esi,%edi
  800b6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b6f:	85 c0                	test   %eax,%eax
  800b71:	7f 08                	jg     800b7b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800b7f:	6a 04                	push   $0x4
  800b81:	68 df 22 80 00       	push   $0x8022df
  800b86:	6a 23                	push   $0x23
  800b88:	68 fc 22 80 00       	push   $0x8022fc
  800b8d:	e8 7d 0f 00 00       	call   801b0f <_panic>

00800b92 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	57                   	push   %edi
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
  800b98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b9b:	b8 05 00 00 00       	mov    $0x5,%eax
  800ba0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ba9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bac:	8b 75 18             	mov    0x18(%ebp),%esi
  800baf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	7f 08                	jg     800bbd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb8:	5b                   	pop    %ebx
  800bb9:	5e                   	pop    %esi
  800bba:	5f                   	pop    %edi
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bbd:	83 ec 0c             	sub    $0xc,%esp
  800bc0:	50                   	push   %eax
  800bc1:	6a 05                	push   $0x5
  800bc3:	68 df 22 80 00       	push   $0x8022df
  800bc8:	6a 23                	push   $0x23
  800bca:	68 fc 22 80 00       	push   $0x8022fc
  800bcf:	e8 3b 0f 00 00       	call   801b0f <_panic>

00800bd4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800be2:	b8 06 00 00 00       	mov    $0x6,%eax
  800be7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bea:	8b 55 08             	mov    0x8(%ebp),%edx
  800bed:	89 df                	mov    %ebx,%edi
  800bef:	89 de                	mov    %ebx,%esi
  800bf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	7f 08                	jg     800bff <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bff:	83 ec 0c             	sub    $0xc,%esp
  800c02:	50                   	push   %eax
  800c03:	6a 06                	push   $0x6
  800c05:	68 df 22 80 00       	push   $0x8022df
  800c0a:	6a 23                	push   $0x23
  800c0c:	68 fc 22 80 00       	push   $0x8022fc
  800c11:	e8 f9 0e 00 00       	call   801b0f <_panic>

00800c16 <sys_yield>:

void
sys_yield(void)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	89 d7                	mov    %edx,%edi
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
  800c3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c43:	b8 08 00 00 00       	mov    $0x8,%eax
  800c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4e:	89 df                	mov    %ebx,%edi
  800c50:	89 de                	mov    %ebx,%esi
  800c52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c54:	85 c0                	test   %eax,%eax
  800c56:	7f 08                	jg     800c60 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c60:	83 ec 0c             	sub    $0xc,%esp
  800c63:	50                   	push   %eax
  800c64:	6a 08                	push   $0x8
  800c66:	68 df 22 80 00       	push   $0x8022df
  800c6b:	6a 23                	push   $0x23
  800c6d:	68 fc 22 80 00       	push   $0x8022fc
  800c72:	e8 98 0e 00 00       	call   801b0f <_panic>

00800c77 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c80:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c85:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8d:	89 cb                	mov    %ecx,%ebx
  800c8f:	89 cf                	mov    %ecx,%edi
  800c91:	89 ce                	mov    %ecx,%esi
  800c93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	7f 08                	jg     800ca1 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca1:	83 ec 0c             	sub    $0xc,%esp
  800ca4:	50                   	push   %eax
  800ca5:	6a 0c                	push   $0xc
  800ca7:	68 df 22 80 00       	push   $0x8022df
  800cac:	6a 23                	push   $0x23
  800cae:	68 fc 22 80 00       	push   $0x8022fc
  800cb3:	e8 57 0e 00 00       	call   801b0f <_panic>

00800cb8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc6:	b8 09 00 00 00       	mov    $0x9,%eax
  800ccb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	89 df                	mov    %ebx,%edi
  800cd3:	89 de                	mov    %ebx,%esi
  800cd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	7f 08                	jg     800ce3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	50                   	push   %eax
  800ce7:	6a 09                	push   $0x9
  800ce9:	68 df 22 80 00       	push   $0x8022df
  800cee:	6a 23                	push   $0x23
  800cf0:	68 fc 22 80 00       	push   $0x8022fc
  800cf5:	e8 15 0e 00 00       	call   801b0f <_panic>

00800cfa <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d08:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	89 df                	mov    %ebx,%edi
  800d15:	89 de                	mov    %ebx,%esi
  800d17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d19:	85 c0                	test   %eax,%eax
  800d1b:	7f 08                	jg     800d25 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d25:	83 ec 0c             	sub    $0xc,%esp
  800d28:	50                   	push   %eax
  800d29:	6a 0a                	push   $0xa
  800d2b:	68 df 22 80 00       	push   $0x8022df
  800d30:	6a 23                	push   $0x23
  800d32:	68 fc 22 80 00       	push   $0x8022fc
  800d37:	e8 d3 0d 00 00       	call   801b0f <_panic>

00800d3c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d42:	be 00 00 00 00       	mov    $0x0,%esi
  800d47:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d55:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d58:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
  800d65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d68:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d6d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	89 cb                	mov    %ecx,%ebx
  800d77:	89 cf                	mov    %ecx,%edi
  800d79:	89 ce                	mov    %ecx,%esi
  800d7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	7f 08                	jg     800d89 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d89:	83 ec 0c             	sub    $0xc,%esp
  800d8c:	50                   	push   %eax
  800d8d:	6a 0e                	push   $0xe
  800d8f:	68 df 22 80 00       	push   $0x8022df
  800d94:	6a 23                	push   $0x23
  800d96:	68 fc 22 80 00       	push   $0x8022fc
  800d9b:	e8 6f 0d 00 00       	call   801b0f <_panic>

00800da0 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da6:	be 00 00 00 00       	mov    $0x0,%esi
  800dab:	b8 0f 00 00 00       	mov    $0xf,%eax
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db9:	89 f7                	mov    %esi,%edi
  800dbb:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc8:	be 00 00 00 00       	mov    $0x0,%esi
  800dcd:	b8 10 00 00 00       	mov    $0x10,%eax
  800dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddb:	89 f7                	mov    %esi,%edi
  800ddd:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800def:	b8 11 00 00 00       	mov    $0x11,%eax
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	89 cb                	mov    %ecx,%ebx
  800df9:	89 cf                	mov    %ecx,%edi
  800dfb:	89 ce                	mov    %ecx,%esi
  800dfd:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	05 00 00 00 30       	add    $0x30000000,%eax
  800e0f:	c1 e8 0c             	shr    $0xc,%eax
}
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e24:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e31:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e36:	89 c2                	mov    %eax,%edx
  800e38:	c1 ea 16             	shr    $0x16,%edx
  800e3b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e42:	f6 c2 01             	test   $0x1,%dl
  800e45:	74 2a                	je     800e71 <fd_alloc+0x46>
  800e47:	89 c2                	mov    %eax,%edx
  800e49:	c1 ea 0c             	shr    $0xc,%edx
  800e4c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e53:	f6 c2 01             	test   $0x1,%dl
  800e56:	74 19                	je     800e71 <fd_alloc+0x46>
  800e58:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e5d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e62:	75 d2                	jne    800e36 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e64:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e6a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e6f:	eb 07                	jmp    800e78 <fd_alloc+0x4d>
			*fd_store = fd;
  800e71:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e7d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800e81:	77 39                	ja     800ebc <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	c1 e0 0c             	shl    $0xc,%eax
  800e89:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e8e:	89 c2                	mov    %eax,%edx
  800e90:	c1 ea 16             	shr    $0x16,%edx
  800e93:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e9a:	f6 c2 01             	test   $0x1,%dl
  800e9d:	74 24                	je     800ec3 <fd_lookup+0x49>
  800e9f:	89 c2                	mov    %eax,%edx
  800ea1:	c1 ea 0c             	shr    $0xc,%edx
  800ea4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eab:	f6 c2 01             	test   $0x1,%dl
  800eae:	74 1a                	je     800eca <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb3:	89 02                	mov    %eax,(%edx)
	return 0;
  800eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		return -E_INVAL;
  800ebc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec1:	eb f7                	jmp    800eba <fd_lookup+0x40>
		return -E_INVAL;
  800ec3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec8:	eb f0                	jmp    800eba <fd_lookup+0x40>
  800eca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ecf:	eb e9                	jmp    800eba <fd_lookup+0x40>

00800ed1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 08             	sub    $0x8,%esp
  800ed7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eda:	ba 88 23 80 00       	mov    $0x802388,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800edf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ee4:	39 08                	cmp    %ecx,(%eax)
  800ee6:	74 33                	je     800f1b <dev_lookup+0x4a>
  800ee8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800eeb:	8b 02                	mov    (%edx),%eax
  800eed:	85 c0                	test   %eax,%eax
  800eef:	75 f3                	jne    800ee4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ef1:	a1 04 40 80 00       	mov    0x804004,%eax
  800ef6:	8b 40 48             	mov    0x48(%eax),%eax
  800ef9:	83 ec 04             	sub    $0x4,%esp
  800efc:	51                   	push   %ecx
  800efd:	50                   	push   %eax
  800efe:	68 0c 23 80 00       	push   $0x80230c
  800f03:	e8 8a f2 ff ff       	call   800192 <cprintf>
	*dev = 0;
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    
			*dev = devtab[i];
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
  800f25:	eb f2                	jmp    800f19 <dev_lookup+0x48>

00800f27 <fd_close>:
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	57                   	push   %edi
  800f2b:	56                   	push   %esi
  800f2c:	53                   	push   %ebx
  800f2d:	83 ec 1c             	sub    $0x1c,%esp
  800f30:	8b 75 08             	mov    0x8(%ebp),%esi
  800f33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f39:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f40:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f43:	50                   	push   %eax
  800f44:	e8 31 ff ff ff       	call   800e7a <fd_lookup>
  800f49:	89 c7                	mov    %eax,%edi
  800f4b:	83 c4 08             	add    $0x8,%esp
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	78 05                	js     800f57 <fd_close+0x30>
	    || fd != fd2)
  800f52:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800f55:	74 13                	je     800f6a <fd_close+0x43>
		return (must_exist ? r : 0);
  800f57:	84 db                	test   %bl,%bl
  800f59:	75 05                	jne    800f60 <fd_close+0x39>
  800f5b:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800f60:	89 f8                	mov    %edi,%eax
  800f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f6a:	83 ec 08             	sub    $0x8,%esp
  800f6d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f70:	50                   	push   %eax
  800f71:	ff 36                	pushl  (%esi)
  800f73:	e8 59 ff ff ff       	call   800ed1 <dev_lookup>
  800f78:	89 c7                	mov    %eax,%edi
  800f7a:	83 c4 10             	add    $0x10,%esp
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	78 15                	js     800f96 <fd_close+0x6f>
		if (dev->dev_close)
  800f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f84:	8b 40 10             	mov    0x10(%eax),%eax
  800f87:	85 c0                	test   %eax,%eax
  800f89:	74 1b                	je     800fa6 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	56                   	push   %esi
  800f8f:	ff d0                	call   *%eax
  800f91:	89 c7                	mov    %eax,%edi
  800f93:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	56                   	push   %esi
  800f9a:	6a 00                	push   $0x0
  800f9c:	e8 33 fc ff ff       	call   800bd4 <sys_page_unmap>
	return r;
  800fa1:	83 c4 10             	add    $0x10,%esp
  800fa4:	eb ba                	jmp    800f60 <fd_close+0x39>
			r = 0;
  800fa6:	bf 00 00 00 00       	mov    $0x0,%edi
  800fab:	eb e9                	jmp    800f96 <fd_close+0x6f>

00800fad <close>:

int
close(int fdnum)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb6:	50                   	push   %eax
  800fb7:	ff 75 08             	pushl  0x8(%ebp)
  800fba:	e8 bb fe ff ff       	call   800e7a <fd_lookup>
  800fbf:	83 c4 08             	add    $0x8,%esp
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	78 10                	js     800fd6 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fc6:	83 ec 08             	sub    $0x8,%esp
  800fc9:	6a 01                	push   $0x1
  800fcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fce:	e8 54 ff ff ff       	call   800f27 <fd_close>
  800fd3:	83 c4 10             	add    $0x10,%esp
}
  800fd6:	c9                   	leave  
  800fd7:	c3                   	ret    

00800fd8 <close_all>:

void
close_all(void)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	53                   	push   %ebx
  800fdc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fdf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fe4:	83 ec 0c             	sub    $0xc,%esp
  800fe7:	53                   	push   %ebx
  800fe8:	e8 c0 ff ff ff       	call   800fad <close>
	for (i = 0; i < MAXFD; i++)
  800fed:	43                   	inc    %ebx
  800fee:	83 c4 10             	add    $0x10,%esp
  800ff1:	83 fb 20             	cmp    $0x20,%ebx
  800ff4:	75 ee                	jne    800fe4 <close_all+0xc>
}
  800ff6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
  801001:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801004:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801007:	50                   	push   %eax
  801008:	ff 75 08             	pushl  0x8(%ebp)
  80100b:	e8 6a fe ff ff       	call   800e7a <fd_lookup>
  801010:	89 c3                	mov    %eax,%ebx
  801012:	83 c4 08             	add    $0x8,%esp
  801015:	85 c0                	test   %eax,%eax
  801017:	0f 88 81 00 00 00    	js     80109e <dup+0xa3>
		return r;
	close(newfdnum);
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	ff 75 0c             	pushl  0xc(%ebp)
  801023:	e8 85 ff ff ff       	call   800fad <close>

	newfd = INDEX2FD(newfdnum);
  801028:	8b 75 0c             	mov    0xc(%ebp),%esi
  80102b:	c1 e6 0c             	shl    $0xc,%esi
  80102e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801034:	83 c4 04             	add    $0x4,%esp
  801037:	ff 75 e4             	pushl  -0x1c(%ebp)
  80103a:	e8 d5 fd ff ff       	call   800e14 <fd2data>
  80103f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801041:	89 34 24             	mov    %esi,(%esp)
  801044:	e8 cb fd ff ff       	call   800e14 <fd2data>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80104e:	89 d8                	mov    %ebx,%eax
  801050:	c1 e8 16             	shr    $0x16,%eax
  801053:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80105a:	a8 01                	test   $0x1,%al
  80105c:	74 11                	je     80106f <dup+0x74>
  80105e:	89 d8                	mov    %ebx,%eax
  801060:	c1 e8 0c             	shr    $0xc,%eax
  801063:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80106a:	f6 c2 01             	test   $0x1,%dl
  80106d:	75 39                	jne    8010a8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80106f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801072:	89 d0                	mov    %edx,%eax
  801074:	c1 e8 0c             	shr    $0xc,%eax
  801077:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80107e:	83 ec 0c             	sub    $0xc,%esp
  801081:	25 07 0e 00 00       	and    $0xe07,%eax
  801086:	50                   	push   %eax
  801087:	56                   	push   %esi
  801088:	6a 00                	push   $0x0
  80108a:	52                   	push   %edx
  80108b:	6a 00                	push   $0x0
  80108d:	e8 00 fb ff ff       	call   800b92 <sys_page_map>
  801092:	89 c3                	mov    %eax,%ebx
  801094:	83 c4 20             	add    $0x20,%esp
  801097:	85 c0                	test   %eax,%eax
  801099:	78 31                	js     8010cc <dup+0xd1>
		goto err;

	return newfdnum;
  80109b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80109e:	89 d8                	mov    %ebx,%eax
  8010a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8010b7:	50                   	push   %eax
  8010b8:	57                   	push   %edi
  8010b9:	6a 00                	push   $0x0
  8010bb:	53                   	push   %ebx
  8010bc:	6a 00                	push   $0x0
  8010be:	e8 cf fa ff ff       	call   800b92 <sys_page_map>
  8010c3:	89 c3                	mov    %eax,%ebx
  8010c5:	83 c4 20             	add    $0x20,%esp
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	79 a3                	jns    80106f <dup+0x74>
	sys_page_unmap(0, newfd);
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	56                   	push   %esi
  8010d0:	6a 00                	push   $0x0
  8010d2:	e8 fd fa ff ff       	call   800bd4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010d7:	83 c4 08             	add    $0x8,%esp
  8010da:	57                   	push   %edi
  8010db:	6a 00                	push   $0x0
  8010dd:	e8 f2 fa ff ff       	call   800bd4 <sys_page_unmap>
	return r;
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	eb b7                	jmp    80109e <dup+0xa3>

008010e7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	53                   	push   %ebx
  8010eb:	83 ec 14             	sub    $0x14,%esp
  8010ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010f4:	50                   	push   %eax
  8010f5:	53                   	push   %ebx
  8010f6:	e8 7f fd ff ff       	call   800e7a <fd_lookup>
  8010fb:	83 c4 08             	add    $0x8,%esp
  8010fe:	85 c0                	test   %eax,%eax
  801100:	78 3f                	js     801141 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801108:	50                   	push   %eax
  801109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110c:	ff 30                	pushl  (%eax)
  80110e:	e8 be fd ff ff       	call   800ed1 <dev_lookup>
  801113:	83 c4 10             	add    $0x10,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	78 27                	js     801141 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80111a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111d:	8b 42 08             	mov    0x8(%edx),%eax
  801120:	83 e0 03             	and    $0x3,%eax
  801123:	83 f8 01             	cmp    $0x1,%eax
  801126:	74 1e                	je     801146 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112b:	8b 40 08             	mov    0x8(%eax),%eax
  80112e:	85 c0                	test   %eax,%eax
  801130:	74 35                	je     801167 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801132:	83 ec 04             	sub    $0x4,%esp
  801135:	ff 75 10             	pushl  0x10(%ebp)
  801138:	ff 75 0c             	pushl  0xc(%ebp)
  80113b:	52                   	push   %edx
  80113c:	ff d0                	call   *%eax
  80113e:	83 c4 10             	add    $0x10,%esp
}
  801141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801144:	c9                   	leave  
  801145:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801146:	a1 04 40 80 00       	mov    0x804004,%eax
  80114b:	8b 40 48             	mov    0x48(%eax),%eax
  80114e:	83 ec 04             	sub    $0x4,%esp
  801151:	53                   	push   %ebx
  801152:	50                   	push   %eax
  801153:	68 4d 23 80 00       	push   $0x80234d
  801158:	e8 35 f0 ff ff       	call   800192 <cprintf>
		return -E_INVAL;
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801165:	eb da                	jmp    801141 <read+0x5a>
		return -E_NOT_SUPP;
  801167:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80116c:	eb d3                	jmp    801141 <read+0x5a>

0080116e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	57                   	push   %edi
  801172:	56                   	push   %esi
  801173:	53                   	push   %ebx
  801174:	83 ec 0c             	sub    $0xc,%esp
  801177:	8b 7d 08             	mov    0x8(%ebp),%edi
  80117a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80117d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801182:	39 f3                	cmp    %esi,%ebx
  801184:	73 25                	jae    8011ab <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	89 f0                	mov    %esi,%eax
  80118b:	29 d8                	sub    %ebx,%eax
  80118d:	50                   	push   %eax
  80118e:	89 d8                	mov    %ebx,%eax
  801190:	03 45 0c             	add    0xc(%ebp),%eax
  801193:	50                   	push   %eax
  801194:	57                   	push   %edi
  801195:	e8 4d ff ff ff       	call   8010e7 <read>
		if (m < 0)
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	78 08                	js     8011a9 <readn+0x3b>
			return m;
		if (m == 0)
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	74 06                	je     8011ab <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011a5:	01 c3                	add    %eax,%ebx
  8011a7:	eb d9                	jmp    801182 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011a9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011ab:	89 d8                	mov    %ebx,%eax
  8011ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	53                   	push   %ebx
  8011b9:	83 ec 14             	sub    $0x14,%esp
  8011bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011c2:	50                   	push   %eax
  8011c3:	53                   	push   %ebx
  8011c4:	e8 b1 fc ff ff       	call   800e7a <fd_lookup>
  8011c9:	83 c4 08             	add    $0x8,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 3a                	js     80120a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d0:	83 ec 08             	sub    $0x8,%esp
  8011d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d6:	50                   	push   %eax
  8011d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011da:	ff 30                	pushl  (%eax)
  8011dc:	e8 f0 fc ff ff       	call   800ed1 <dev_lookup>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 22                	js     80120a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011eb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011ef:	74 1e                	je     80120f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8011f7:	85 d2                	test   %edx,%edx
  8011f9:	74 35                	je     801230 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	ff 75 10             	pushl  0x10(%ebp)
  801201:	ff 75 0c             	pushl  0xc(%ebp)
  801204:	50                   	push   %eax
  801205:	ff d2                	call   *%edx
  801207:	83 c4 10             	add    $0x10,%esp
}
  80120a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80120f:	a1 04 40 80 00       	mov    0x804004,%eax
  801214:	8b 40 48             	mov    0x48(%eax),%eax
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	53                   	push   %ebx
  80121b:	50                   	push   %eax
  80121c:	68 69 23 80 00       	push   $0x802369
  801221:	e8 6c ef ff ff       	call   800192 <cprintf>
		return -E_INVAL;
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80122e:	eb da                	jmp    80120a <write+0x55>
		return -E_NOT_SUPP;
  801230:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801235:	eb d3                	jmp    80120a <write+0x55>

00801237 <seek>:

int
seek(int fdnum, off_t offset)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80123d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801240:	50                   	push   %eax
  801241:	ff 75 08             	pushl  0x8(%ebp)
  801244:	e8 31 fc ff ff       	call   800e7a <fd_lookup>
  801249:	83 c4 08             	add    $0x8,%esp
  80124c:	85 c0                	test   %eax,%eax
  80124e:	78 0e                	js     80125e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801250:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801253:	8b 55 0c             	mov    0xc(%ebp),%edx
  801256:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801259:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	53                   	push   %ebx
  801264:	83 ec 14             	sub    $0x14,%esp
  801267:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80126a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80126d:	50                   	push   %eax
  80126e:	53                   	push   %ebx
  80126f:	e8 06 fc ff ff       	call   800e7a <fd_lookup>
  801274:	83 c4 08             	add    $0x8,%esp
  801277:	85 c0                	test   %eax,%eax
  801279:	78 37                	js     8012b2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80127b:	83 ec 08             	sub    $0x8,%esp
  80127e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801281:	50                   	push   %eax
  801282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801285:	ff 30                	pushl  (%eax)
  801287:	e8 45 fc ff ff       	call   800ed1 <dev_lookup>
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	78 1f                	js     8012b2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801296:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80129a:	74 1b                	je     8012b7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80129c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129f:	8b 52 18             	mov    0x18(%edx),%edx
  8012a2:	85 d2                	test   %edx,%edx
  8012a4:	74 32                	je     8012d8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ac:	50                   	push   %eax
  8012ad:	ff d2                	call   *%edx
  8012af:	83 c4 10             	add    $0x10,%esp
}
  8012b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012b7:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012bc:	8b 40 48             	mov    0x48(%eax),%eax
  8012bf:	83 ec 04             	sub    $0x4,%esp
  8012c2:	53                   	push   %ebx
  8012c3:	50                   	push   %eax
  8012c4:	68 2c 23 80 00       	push   $0x80232c
  8012c9:	e8 c4 ee ff ff       	call   800192 <cprintf>
		return -E_INVAL;
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d6:	eb da                	jmp    8012b2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012dd:	eb d3                	jmp    8012b2 <ftruncate+0x52>

008012df <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	53                   	push   %ebx
  8012e3:	83 ec 14             	sub    $0x14,%esp
  8012e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ec:	50                   	push   %eax
  8012ed:	ff 75 08             	pushl  0x8(%ebp)
  8012f0:	e8 85 fb ff ff       	call   800e7a <fd_lookup>
  8012f5:	83 c4 08             	add    $0x8,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	78 4b                	js     801347 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801302:	50                   	push   %eax
  801303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801306:	ff 30                	pushl  (%eax)
  801308:	e8 c4 fb ff ff       	call   800ed1 <dev_lookup>
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	85 c0                	test   %eax,%eax
  801312:	78 33                	js     801347 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801317:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80131b:	74 2f                	je     80134c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80131d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801320:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801327:	00 00 00 
	stat->st_type = 0;
  80132a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801331:	00 00 00 
	stat->st_dev = dev;
  801334:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	53                   	push   %ebx
  80133e:	ff 75 f0             	pushl  -0x10(%ebp)
  801341:	ff 50 14             	call   *0x14(%eax)
  801344:	83 c4 10             	add    $0x10,%esp
}
  801347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    
		return -E_NOT_SUPP;
  80134c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801351:	eb f4                	jmp    801347 <fstat+0x68>

00801353 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	56                   	push   %esi
  801357:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	6a 00                	push   $0x0
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	e8 34 02 00 00       	call   801599 <open>
  801365:	89 c3                	mov    %eax,%ebx
  801367:	83 c4 10             	add    $0x10,%esp
  80136a:	85 c0                	test   %eax,%eax
  80136c:	78 1b                	js     801389 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	50                   	push   %eax
  801375:	e8 65 ff ff ff       	call   8012df <fstat>
  80137a:	89 c6                	mov    %eax,%esi
	close(fd);
  80137c:	89 1c 24             	mov    %ebx,(%esp)
  80137f:	e8 29 fc ff ff       	call   800fad <close>
	return r;
  801384:	83 c4 10             	add    $0x10,%esp
  801387:	89 f3                	mov    %esi,%ebx
}
  801389:	89 d8                	mov    %ebx,%eax
  80138b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138e:	5b                   	pop    %ebx
  80138f:	5e                   	pop    %esi
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    

00801392 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	56                   	push   %esi
  801396:	53                   	push   %ebx
  801397:	89 c6                	mov    %eax,%esi
  801399:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80139b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013a2:	74 27                	je     8013cb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013a4:	6a 07                	push   $0x7
  8013a6:	68 00 50 80 00       	push   $0x805000
  8013ab:	56                   	push   %esi
  8013ac:	ff 35 00 40 80 00    	pushl  0x804000
  8013b2:	e8 60 08 00 00       	call   801c17 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013b7:	83 c4 0c             	add    $0xc,%esp
  8013ba:	6a 00                	push   $0x0
  8013bc:	53                   	push   %ebx
  8013bd:	6a 00                	push   $0x0
  8013bf:	e8 ca 07 00 00       	call   801b8e <ipc_recv>
}
  8013c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c7:	5b                   	pop    %ebx
  8013c8:	5e                   	pop    %esi
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013cb:	83 ec 0c             	sub    $0xc,%esp
  8013ce:	6a 01                	push   $0x1
  8013d0:	e8 9e 08 00 00       	call   801c73 <ipc_find_env>
  8013d5:	a3 00 40 80 00       	mov    %eax,0x804000
  8013da:	83 c4 10             	add    $0x10,%esp
  8013dd:	eb c5                	jmp    8013a4 <fsipc+0x12>

008013df <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8013eb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fd:	b8 02 00 00 00       	mov    $0x2,%eax
  801402:	e8 8b ff ff ff       	call   801392 <fsipc>
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <devfile_flush>:
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8b 40 0c             	mov    0xc(%eax),%eax
  801415:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80141a:	ba 00 00 00 00       	mov    $0x0,%edx
  80141f:	b8 06 00 00 00       	mov    $0x6,%eax
  801424:	e8 69 ff ff ff       	call   801392 <fsipc>
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <devfile_stat>:
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	53                   	push   %ebx
  80142f:	83 ec 04             	sub    $0x4,%esp
  801432:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8b 40 0c             	mov    0xc(%eax),%eax
  80143b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801440:	ba 00 00 00 00       	mov    $0x0,%edx
  801445:	b8 05 00 00 00       	mov    $0x5,%eax
  80144a:	e8 43 ff ff ff       	call   801392 <fsipc>
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 2c                	js     80147f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	68 00 50 80 00       	push   $0x805000
  80145b:	53                   	push   %ebx
  80145c:	e8 39 f3 ff ff       	call   80079a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801461:	a1 80 50 80 00       	mov    0x805080,%eax
  801466:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80146c:	a1 84 50 80 00       	mov    0x805084,%eax
  801471:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <devfile_write>:
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	53                   	push   %ebx
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  80148e:	89 d8                	mov    %ebx,%eax
  801490:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801496:	76 05                	jbe    80149d <devfile_write+0x19>
  801498:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a3:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8014a9:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8014ae:	83 ec 04             	sub    $0x4,%esp
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	68 08 50 80 00       	push   $0x805008
  8014ba:	e8 4e f4 ff ff       	call   80090d <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8014bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c4:	b8 04 00 00 00       	mov    $0x4,%eax
  8014c9:	e8 c4 fe ff ff       	call   801392 <fsipc>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 0b                	js     8014e0 <devfile_write+0x5c>
	assert(r <= n);
  8014d5:	39 c3                	cmp    %eax,%ebx
  8014d7:	72 0c                	jb     8014e5 <devfile_write+0x61>
	assert(r <= PGSIZE);
  8014d9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014de:	7f 1e                	jg     8014fe <devfile_write+0x7a>
}
  8014e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    
	assert(r <= n);
  8014e5:	68 98 23 80 00       	push   $0x802398
  8014ea:	68 9f 23 80 00       	push   $0x80239f
  8014ef:	68 98 00 00 00       	push   $0x98
  8014f4:	68 b4 23 80 00       	push   $0x8023b4
  8014f9:	e8 11 06 00 00       	call   801b0f <_panic>
	assert(r <= PGSIZE);
  8014fe:	68 bf 23 80 00       	push   $0x8023bf
  801503:	68 9f 23 80 00       	push   $0x80239f
  801508:	68 99 00 00 00       	push   $0x99
  80150d:	68 b4 23 80 00       	push   $0x8023b4
  801512:	e8 f8 05 00 00       	call   801b0f <_panic>

00801517 <devfile_read>:
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
  80151c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8b 40 0c             	mov    0xc(%eax),%eax
  801525:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80152a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801530:	ba 00 00 00 00       	mov    $0x0,%edx
  801535:	b8 03 00 00 00       	mov    $0x3,%eax
  80153a:	e8 53 fe ff ff       	call   801392 <fsipc>
  80153f:	89 c3                	mov    %eax,%ebx
  801541:	85 c0                	test   %eax,%eax
  801543:	78 1f                	js     801564 <devfile_read+0x4d>
	assert(r <= n);
  801545:	39 c6                	cmp    %eax,%esi
  801547:	72 24                	jb     80156d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801549:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80154e:	7f 33                	jg     801583 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801550:	83 ec 04             	sub    $0x4,%esp
  801553:	50                   	push   %eax
  801554:	68 00 50 80 00       	push   $0x805000
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	e8 ac f3 ff ff       	call   80090d <memmove>
	return r;
  801561:	83 c4 10             	add    $0x10,%esp
}
  801564:	89 d8                	mov    %ebx,%eax
  801566:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801569:	5b                   	pop    %ebx
  80156a:	5e                   	pop    %esi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    
	assert(r <= n);
  80156d:	68 98 23 80 00       	push   $0x802398
  801572:	68 9f 23 80 00       	push   $0x80239f
  801577:	6a 7c                	push   $0x7c
  801579:	68 b4 23 80 00       	push   $0x8023b4
  80157e:	e8 8c 05 00 00       	call   801b0f <_panic>
	assert(r <= PGSIZE);
  801583:	68 bf 23 80 00       	push   $0x8023bf
  801588:	68 9f 23 80 00       	push   $0x80239f
  80158d:	6a 7d                	push   $0x7d
  80158f:	68 b4 23 80 00       	push   $0x8023b4
  801594:	e8 76 05 00 00       	call   801b0f <_panic>

00801599 <open>:
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	56                   	push   %esi
  80159d:	53                   	push   %ebx
  80159e:	83 ec 1c             	sub    $0x1c,%esp
  8015a1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015a4:	56                   	push   %esi
  8015a5:	e8 bd f1 ff ff       	call   800767 <strlen>
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015b2:	7f 6c                	jg     801620 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015b4:	83 ec 0c             	sub    $0xc,%esp
  8015b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	e8 6b f8 ff ff       	call   800e2b <fd_alloc>
  8015c0:	89 c3                	mov    %eax,%ebx
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 3c                	js     801605 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015c9:	83 ec 08             	sub    $0x8,%esp
  8015cc:	56                   	push   %esi
  8015cd:	68 00 50 80 00       	push   $0x805000
  8015d2:	e8 c3 f1 ff ff       	call   80079a <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015da:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e7:	e8 a6 fd ff ff       	call   801392 <fsipc>
  8015ec:	89 c3                	mov    %eax,%ebx
  8015ee:	83 c4 10             	add    $0x10,%esp
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 19                	js     80160e <open+0x75>
	return fd2num(fd);
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fb:	e8 04 f8 ff ff       	call   800e04 <fd2num>
  801600:	89 c3                	mov    %eax,%ebx
  801602:	83 c4 10             	add    $0x10,%esp
}
  801605:	89 d8                	mov    %ebx,%eax
  801607:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80160a:	5b                   	pop    %ebx
  80160b:	5e                   	pop    %esi
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    
		fd_close(fd, 0);
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	6a 00                	push   $0x0
  801613:	ff 75 f4             	pushl  -0xc(%ebp)
  801616:	e8 0c f9 ff ff       	call   800f27 <fd_close>
		return r;
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	eb e5                	jmp    801605 <open+0x6c>
		return -E_BAD_PATH;
  801620:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801625:	eb de                	jmp    801605 <open+0x6c>

00801627 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80162d:	ba 00 00 00 00       	mov    $0x0,%edx
  801632:	b8 08 00 00 00       	mov    $0x8,%eax
  801637:	e8 56 fd ff ff       	call   801392 <fsipc>
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	56                   	push   %esi
  801642:	53                   	push   %ebx
  801643:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	ff 75 08             	pushl  0x8(%ebp)
  80164c:	e8 c3 f7 ff ff       	call   800e14 <fd2data>
  801651:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801653:	83 c4 08             	add    $0x8,%esp
  801656:	68 cb 23 80 00       	push   $0x8023cb
  80165b:	53                   	push   %ebx
  80165c:	e8 39 f1 ff ff       	call   80079a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801661:	8b 46 04             	mov    0x4(%esi),%eax
  801664:	2b 06                	sub    (%esi),%eax
  801666:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80166c:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801673:	10 00 00 
	stat->st_dev = &devpipe;
  801676:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80167d:	30 80 00 
	return 0;
}
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
  801685:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801688:	5b                   	pop    %ebx
  801689:	5e                   	pop    %esi
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    

0080168c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	53                   	push   %ebx
  801690:	83 ec 0c             	sub    $0xc,%esp
  801693:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801696:	53                   	push   %ebx
  801697:	6a 00                	push   $0x0
  801699:	e8 36 f5 ff ff       	call   800bd4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80169e:	89 1c 24             	mov    %ebx,(%esp)
  8016a1:	e8 6e f7 ff ff       	call   800e14 <fd2data>
  8016a6:	83 c4 08             	add    $0x8,%esp
  8016a9:	50                   	push   %eax
  8016aa:	6a 00                	push   $0x0
  8016ac:	e8 23 f5 ff ff       	call   800bd4 <sys_page_unmap>
}
  8016b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <_pipeisclosed>:
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	57                   	push   %edi
  8016ba:	56                   	push   %esi
  8016bb:	53                   	push   %ebx
  8016bc:	83 ec 1c             	sub    $0x1c,%esp
  8016bf:	89 c7                	mov    %eax,%edi
  8016c1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8016c8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016cb:	83 ec 0c             	sub    $0xc,%esp
  8016ce:	57                   	push   %edi
  8016cf:	e8 e1 05 00 00       	call   801cb5 <pageref>
  8016d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016d7:	89 34 24             	mov    %esi,(%esp)
  8016da:	e8 d6 05 00 00       	call   801cb5 <pageref>
		nn = thisenv->env_runs;
  8016df:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016e5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	39 cb                	cmp    %ecx,%ebx
  8016ed:	74 1b                	je     80170a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016ef:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016f2:	75 cf                	jne    8016c3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016f4:	8b 42 58             	mov    0x58(%edx),%eax
  8016f7:	6a 01                	push   $0x1
  8016f9:	50                   	push   %eax
  8016fa:	53                   	push   %ebx
  8016fb:	68 d2 23 80 00       	push   $0x8023d2
  801700:	e8 8d ea ff ff       	call   800192 <cprintf>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	eb b9                	jmp    8016c3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80170a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80170d:	0f 94 c0             	sete   %al
  801710:	0f b6 c0             	movzbl %al,%eax
}
  801713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801716:	5b                   	pop    %ebx
  801717:	5e                   	pop    %esi
  801718:	5f                   	pop    %edi
  801719:	5d                   	pop    %ebp
  80171a:	c3                   	ret    

0080171b <devpipe_write>:
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	57                   	push   %edi
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
  801721:	83 ec 18             	sub    $0x18,%esp
  801724:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801727:	56                   	push   %esi
  801728:	e8 e7 f6 ff ff       	call   800e14 <fd2data>
  80172d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	bf 00 00 00 00       	mov    $0x0,%edi
  801737:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80173a:	74 41                	je     80177d <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80173c:	8b 53 04             	mov    0x4(%ebx),%edx
  80173f:	8b 03                	mov    (%ebx),%eax
  801741:	83 c0 20             	add    $0x20,%eax
  801744:	39 c2                	cmp    %eax,%edx
  801746:	72 14                	jb     80175c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801748:	89 da                	mov    %ebx,%edx
  80174a:	89 f0                	mov    %esi,%eax
  80174c:	e8 65 ff ff ff       	call   8016b6 <_pipeisclosed>
  801751:	85 c0                	test   %eax,%eax
  801753:	75 2c                	jne    801781 <devpipe_write+0x66>
			sys_yield();
  801755:	e8 bc f4 ff ff       	call   800c16 <sys_yield>
  80175a:	eb e0                	jmp    80173c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80175c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175f:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801762:	89 d0                	mov    %edx,%eax
  801764:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801769:	78 0b                	js     801776 <devpipe_write+0x5b>
  80176b:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  80176f:	42                   	inc    %edx
  801770:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801773:	47                   	inc    %edi
  801774:	eb c1                	jmp    801737 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801776:	48                   	dec    %eax
  801777:	83 c8 e0             	or     $0xffffffe0,%eax
  80177a:	40                   	inc    %eax
  80177b:	eb ee                	jmp    80176b <devpipe_write+0x50>
	return i;
  80177d:	89 f8                	mov    %edi,%eax
  80177f:	eb 05                	jmp    801786 <devpipe_write+0x6b>
				return 0;
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801786:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801789:	5b                   	pop    %ebx
  80178a:	5e                   	pop    %esi
  80178b:	5f                   	pop    %edi
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    

0080178e <devpipe_read>:
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	57                   	push   %edi
  801792:	56                   	push   %esi
  801793:	53                   	push   %ebx
  801794:	83 ec 18             	sub    $0x18,%esp
  801797:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80179a:	57                   	push   %edi
  80179b:	e8 74 f6 ff ff       	call   800e14 <fd2data>
  8017a0:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017aa:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8017ad:	74 46                	je     8017f5 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  8017af:	8b 06                	mov    (%esi),%eax
  8017b1:	3b 46 04             	cmp    0x4(%esi),%eax
  8017b4:	75 22                	jne    8017d8 <devpipe_read+0x4a>
			if (i > 0)
  8017b6:	85 db                	test   %ebx,%ebx
  8017b8:	74 0a                	je     8017c4 <devpipe_read+0x36>
				return i;
  8017ba:	89 d8                	mov    %ebx,%eax
}
  8017bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017bf:	5b                   	pop    %ebx
  8017c0:	5e                   	pop    %esi
  8017c1:	5f                   	pop    %edi
  8017c2:	5d                   	pop    %ebp
  8017c3:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  8017c4:	89 f2                	mov    %esi,%edx
  8017c6:	89 f8                	mov    %edi,%eax
  8017c8:	e8 e9 fe ff ff       	call   8016b6 <_pipeisclosed>
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	75 28                	jne    8017f9 <devpipe_read+0x6b>
			sys_yield();
  8017d1:	e8 40 f4 ff ff       	call   800c16 <sys_yield>
  8017d6:	eb d7                	jmp    8017af <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017d8:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8017dd:	78 0f                	js     8017ee <devpipe_read+0x60>
  8017df:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8017e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e6:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8017e9:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8017eb:	43                   	inc    %ebx
  8017ec:	eb bc                	jmp    8017aa <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017ee:	48                   	dec    %eax
  8017ef:	83 c8 e0             	or     $0xffffffe0,%eax
  8017f2:	40                   	inc    %eax
  8017f3:	eb ea                	jmp    8017df <devpipe_read+0x51>
	return i;
  8017f5:	89 d8                	mov    %ebx,%eax
  8017f7:	eb c3                	jmp    8017bc <devpipe_read+0x2e>
				return 0;
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	eb bc                	jmp    8017bc <devpipe_read+0x2e>

00801800 <pipe>:
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	56                   	push   %esi
  801804:	53                   	push   %ebx
  801805:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801808:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180b:	50                   	push   %eax
  80180c:	e8 1a f6 ff ff       	call   800e2b <fd_alloc>
  801811:	89 c3                	mov    %eax,%ebx
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	85 c0                	test   %eax,%eax
  801818:	0f 88 2a 01 00 00    	js     801948 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 07 04 00 00       	push   $0x407
  801826:	ff 75 f4             	pushl  -0xc(%ebp)
  801829:	6a 00                	push   $0x0
  80182b:	e8 1f f3 ff ff       	call   800b4f <sys_page_alloc>
  801830:	89 c3                	mov    %eax,%ebx
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	85 c0                	test   %eax,%eax
  801837:	0f 88 0b 01 00 00    	js     801948 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  80183d:	83 ec 0c             	sub    $0xc,%esp
  801840:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801843:	50                   	push   %eax
  801844:	e8 e2 f5 ff ff       	call   800e2b <fd_alloc>
  801849:	89 c3                	mov    %eax,%ebx
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	0f 88 e2 00 00 00    	js     801938 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801856:	83 ec 04             	sub    $0x4,%esp
  801859:	68 07 04 00 00       	push   $0x407
  80185e:	ff 75 f0             	pushl  -0x10(%ebp)
  801861:	6a 00                	push   $0x0
  801863:	e8 e7 f2 ff ff       	call   800b4f <sys_page_alloc>
  801868:	89 c3                	mov    %eax,%ebx
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	0f 88 c3 00 00 00    	js     801938 <pipe+0x138>
	va = fd2data(fd0);
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	ff 75 f4             	pushl  -0xc(%ebp)
  80187b:	e8 94 f5 ff ff       	call   800e14 <fd2data>
  801880:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801882:	83 c4 0c             	add    $0xc,%esp
  801885:	68 07 04 00 00       	push   $0x407
  80188a:	50                   	push   %eax
  80188b:	6a 00                	push   $0x0
  80188d:	e8 bd f2 ff ff       	call   800b4f <sys_page_alloc>
  801892:	89 c3                	mov    %eax,%ebx
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	85 c0                	test   %eax,%eax
  801899:	0f 88 89 00 00 00    	js     801928 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80189f:	83 ec 0c             	sub    $0xc,%esp
  8018a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a5:	e8 6a f5 ff ff       	call   800e14 <fd2data>
  8018aa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018b1:	50                   	push   %eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	56                   	push   %esi
  8018b5:	6a 00                	push   $0x0
  8018b7:	e8 d6 f2 ff ff       	call   800b92 <sys_page_map>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 20             	add    $0x20,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 55                	js     80191a <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  8018c5:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ce:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8018d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8018da:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8018e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018ef:	83 ec 0c             	sub    $0xc,%esp
  8018f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f5:	e8 0a f5 ff ff       	call   800e04 <fd2num>
  8018fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018ff:	83 c4 04             	add    $0x4,%esp
  801902:	ff 75 f0             	pushl  -0x10(%ebp)
  801905:	e8 fa f4 ff ff       	call   800e04 <fd2num>
  80190a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	bb 00 00 00 00       	mov    $0x0,%ebx
  801918:	eb 2e                	jmp    801948 <pipe+0x148>
	sys_page_unmap(0, va);
  80191a:	83 ec 08             	sub    $0x8,%esp
  80191d:	56                   	push   %esi
  80191e:	6a 00                	push   $0x0
  801920:	e8 af f2 ff ff       	call   800bd4 <sys_page_unmap>
  801925:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801928:	83 ec 08             	sub    $0x8,%esp
  80192b:	ff 75 f0             	pushl  -0x10(%ebp)
  80192e:	6a 00                	push   $0x0
  801930:	e8 9f f2 ff ff       	call   800bd4 <sys_page_unmap>
  801935:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801938:	83 ec 08             	sub    $0x8,%esp
  80193b:	ff 75 f4             	pushl  -0xc(%ebp)
  80193e:	6a 00                	push   $0x0
  801940:	e8 8f f2 ff ff       	call   800bd4 <sys_page_unmap>
  801945:	83 c4 10             	add    $0x10,%esp
}
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5e                   	pop    %esi
  80194f:	5d                   	pop    %ebp
  801950:	c3                   	ret    

00801951 <pipeisclosed>:
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801957:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195a:	50                   	push   %eax
  80195b:	ff 75 08             	pushl  0x8(%ebp)
  80195e:	e8 17 f5 ff ff       	call   800e7a <fd_lookup>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	78 18                	js     801982 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80196a:	83 ec 0c             	sub    $0xc,%esp
  80196d:	ff 75 f4             	pushl  -0xc(%ebp)
  801970:	e8 9f f4 ff ff       	call   800e14 <fd2data>
	return _pipeisclosed(fd, p);
  801975:	89 c2                	mov    %eax,%edx
  801977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197a:	e8 37 fd ff ff       	call   8016b6 <_pipeisclosed>
  80197f:	83 c4 10             	add    $0x10,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801987:	b8 00 00 00 00       	mov    $0x0,%eax
  80198c:	5d                   	pop    %ebp
  80198d:	c3                   	ret    

0080198e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	53                   	push   %ebx
  801992:	83 ec 0c             	sub    $0xc,%esp
  801995:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801998:	68 ea 23 80 00       	push   $0x8023ea
  80199d:	53                   	push   %ebx
  80199e:	e8 f7 ed ff ff       	call   80079a <strcpy>
	stat->st_type = FTYPE_IFCHR;
  8019a3:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8019aa:	20 00 00 
	return 0;
}
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <devcons_write>:
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	57                   	push   %edi
  8019bb:	56                   	push   %esi
  8019bc:	53                   	push   %ebx
  8019bd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8019c3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019c8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019ce:	eb 1d                	jmp    8019ed <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	53                   	push   %ebx
  8019d4:	03 45 0c             	add    0xc(%ebp),%eax
  8019d7:	50                   	push   %eax
  8019d8:	57                   	push   %edi
  8019d9:	e8 2f ef ff ff       	call   80090d <memmove>
		sys_cputs(buf, m);
  8019de:	83 c4 08             	add    $0x8,%esp
  8019e1:	53                   	push   %ebx
  8019e2:	57                   	push   %edi
  8019e3:	e8 ca f0 ff ff       	call   800ab2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019e8:	01 de                	add    %ebx,%esi
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	89 f0                	mov    %esi,%eax
  8019ef:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019f2:	73 11                	jae    801a05 <devcons_write+0x4e>
		m = n - tot;
  8019f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019f7:	29 f3                	sub    %esi,%ebx
  8019f9:	83 fb 7f             	cmp    $0x7f,%ebx
  8019fc:	76 d2                	jbe    8019d0 <devcons_write+0x19>
  8019fe:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801a03:	eb cb                	jmp    8019d0 <devcons_write+0x19>
}
  801a05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a08:	5b                   	pop    %ebx
  801a09:	5e                   	pop    %esi
  801a0a:	5f                   	pop    %edi
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    

00801a0d <devcons_read>:
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801a13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a17:	75 0c                	jne    801a25 <devcons_read+0x18>
		return 0;
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1e:	eb 21                	jmp    801a41 <devcons_read+0x34>
		sys_yield();
  801a20:	e8 f1 f1 ff ff       	call   800c16 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801a25:	e8 a6 f0 ff ff       	call   800ad0 <sys_cgetc>
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	74 f2                	je     801a20 <devcons_read+0x13>
	if (c < 0)
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 0f                	js     801a41 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801a32:	83 f8 04             	cmp    $0x4,%eax
  801a35:	74 0c                	je     801a43 <devcons_read+0x36>
	*(char*)vbuf = c;
  801a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3a:	88 02                	mov    %al,(%edx)
	return 1;
  801a3c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    
		return 0;
  801a43:	b8 00 00 00 00       	mov    $0x0,%eax
  801a48:	eb f7                	jmp    801a41 <devcons_read+0x34>

00801a4a <cputchar>:
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a56:	6a 01                	push   $0x1
  801a58:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a5b:	50                   	push   %eax
  801a5c:	e8 51 f0 ff ff       	call   800ab2 <sys_cputs>
}
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <getchar>:
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a6c:	6a 01                	push   $0x1
  801a6e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a71:	50                   	push   %eax
  801a72:	6a 00                	push   $0x0
  801a74:	e8 6e f6 ff ff       	call   8010e7 <read>
	if (r < 0)
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 08                	js     801a88 <getchar+0x22>
	if (r < 1)
  801a80:	85 c0                	test   %eax,%eax
  801a82:	7e 06                	jle    801a8a <getchar+0x24>
	return c;
  801a84:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    
		return -E_EOF;
  801a8a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a8f:	eb f7                	jmp    801a88 <getchar+0x22>

00801a91 <iscons>:
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9a:	50                   	push   %eax
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	e8 d7 f3 ff ff       	call   800e7a <fd_lookup>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 11                	js     801abb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aad:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ab3:	39 10                	cmp    %edx,(%eax)
  801ab5:	0f 94 c0             	sete   %al
  801ab8:	0f b6 c0             	movzbl %al,%eax
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <opencons>:
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ac3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac6:	50                   	push   %eax
  801ac7:	e8 5f f3 ff ff       	call   800e2b <fd_alloc>
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	85 c0                	test   %eax,%eax
  801ad1:	78 3a                	js     801b0d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ad3:	83 ec 04             	sub    $0x4,%esp
  801ad6:	68 07 04 00 00       	push   $0x407
  801adb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ade:	6a 00                	push   $0x0
  801ae0:	e8 6a f0 ff ff       	call   800b4f <sys_page_alloc>
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	78 21                	js     801b0d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801aec:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b01:	83 ec 0c             	sub    $0xc,%esp
  801b04:	50                   	push   %eax
  801b05:	e8 fa f2 ff ff       	call   800e04 <fd2num>
  801b0a:	83 c4 10             	add    $0x10,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	57                   	push   %edi
  801b13:	56                   	push   %esi
  801b14:	53                   	push   %ebx
  801b15:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801b1b:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801b1e:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801b24:	e8 07 f0 ff ff       	call   800b30 <sys_getenvid>
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	ff 75 08             	pushl  0x8(%ebp)
  801b32:	53                   	push   %ebx
  801b33:	50                   	push   %eax
  801b34:	68 f8 23 80 00       	push   $0x8023f8
  801b39:	68 00 01 00 00       	push   $0x100
  801b3e:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801b44:	56                   	push   %esi
  801b45:	e8 03 ec ff ff       	call   80074d <snprintf>
  801b4a:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801b4c:	83 c4 20             	add    $0x20,%esp
  801b4f:	57                   	push   %edi
  801b50:	ff 75 10             	pushl  0x10(%ebp)
  801b53:	bf 00 01 00 00       	mov    $0x100,%edi
  801b58:	89 f8                	mov    %edi,%eax
  801b5a:	29 d8                	sub    %ebx,%eax
  801b5c:	50                   	push   %eax
  801b5d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801b60:	50                   	push   %eax
  801b61:	e8 92 eb ff ff       	call   8006f8 <vsnprintf>
  801b66:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801b68:	83 c4 0c             	add    $0xc,%esp
  801b6b:	68 e3 23 80 00       	push   $0x8023e3
  801b70:	29 df                	sub    %ebx,%edi
  801b72:	57                   	push   %edi
  801b73:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801b76:	50                   	push   %eax
  801b77:	e8 d1 eb ff ff       	call   80074d <snprintf>
	sys_cputs(buf, r);
  801b7c:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801b7f:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801b81:	53                   	push   %ebx
  801b82:	56                   	push   %esi
  801b83:	e8 2a ef ff ff       	call   800ab2 <sys_cputs>
  801b88:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b8b:	cc                   	int3   
  801b8c:	eb fd                	jmp    801b8b <_panic+0x7c>

00801b8e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	57                   	push   %edi
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	83 ec 0c             	sub    $0xc,%esp
  801b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b9a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b9d:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801ba0:	85 ff                	test   %edi,%edi
  801ba2:	74 53                	je     801bf7 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801ba4:	83 ec 0c             	sub    $0xc,%esp
  801ba7:	57                   	push   %edi
  801ba8:	e8 b2 f1 ff ff       	call   800d5f <sys_ipc_recv>
  801bad:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801bb0:	85 db                	test   %ebx,%ebx
  801bb2:	74 0b                	je     801bbf <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801bb4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bba:	8b 52 74             	mov    0x74(%edx),%edx
  801bbd:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801bbf:	85 f6                	test   %esi,%esi
  801bc1:	74 0f                	je     801bd2 <ipc_recv+0x44>
  801bc3:	85 ff                	test   %edi,%edi
  801bc5:	74 0b                	je     801bd2 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801bc7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bcd:	8b 52 78             	mov    0x78(%edx),%edx
  801bd0:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	74 30                	je     801c06 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801bd6:	85 db                	test   %ebx,%ebx
  801bd8:	74 06                	je     801be0 <ipc_recv+0x52>
      		*from_env_store = 0;
  801bda:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801be0:	85 f6                	test   %esi,%esi
  801be2:	74 2c                	je     801c10 <ipc_recv+0x82>
      		*perm_store = 0;
  801be4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801bea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5f                   	pop    %edi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801bf7:	83 ec 0c             	sub    $0xc,%esp
  801bfa:	6a ff                	push   $0xffffffff
  801bfc:	e8 5e f1 ff ff       	call   800d5f <sys_ipc_recv>
  801c01:	83 c4 10             	add    $0x10,%esp
  801c04:	eb aa                	jmp    801bb0 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801c06:	a1 04 40 80 00       	mov    0x804004,%eax
  801c0b:	8b 40 70             	mov    0x70(%eax),%eax
  801c0e:	eb df                	jmp    801bef <ipc_recv+0x61>
		return -1;
  801c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c15:	eb d8                	jmp    801bef <ipc_recv+0x61>

00801c17 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	57                   	push   %edi
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
  801c1d:	83 ec 0c             	sub    $0xc,%esp
  801c20:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c23:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c26:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801c29:	85 db                	test   %ebx,%ebx
  801c2b:	75 22                	jne    801c4f <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801c2d:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801c32:	eb 1b                	jmp    801c4f <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c34:	68 1c 24 80 00       	push   $0x80241c
  801c39:	68 9f 23 80 00       	push   $0x80239f
  801c3e:	6a 48                	push   $0x48
  801c40:	68 40 24 80 00       	push   $0x802440
  801c45:	e8 c5 fe ff ff       	call   801b0f <_panic>
		sys_yield();
  801c4a:	e8 c7 ef ff ff       	call   800c16 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c4f:	57                   	push   %edi
  801c50:	53                   	push   %ebx
  801c51:	56                   	push   %esi
  801c52:	ff 75 08             	pushl  0x8(%ebp)
  801c55:	e8 e2 f0 ff ff       	call   800d3c <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c60:	74 e8                	je     801c4a <ipc_send+0x33>
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 ce                	jne    801c34 <ipc_send+0x1d>
		sys_yield();
  801c66:	e8 ab ef ff ff       	call   800c16 <sys_yield>
		
	}
	
}
  801c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c6e:	5b                   	pop    %ebx
  801c6f:	5e                   	pop    %esi
  801c70:	5f                   	pop    %edi
  801c71:	5d                   	pop    %ebp
  801c72:	c3                   	ret    

00801c73 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c7e:	89 c2                	mov    %eax,%edx
  801c80:	c1 e2 05             	shl    $0x5,%edx
  801c83:	29 c2                	sub    %eax,%edx
  801c85:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c8c:	8b 52 50             	mov    0x50(%edx),%edx
  801c8f:	39 ca                	cmp    %ecx,%edx
  801c91:	74 0f                	je     801ca2 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c93:	40                   	inc    %eax
  801c94:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c99:	75 e3                	jne    801c7e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca0:	eb 11                	jmp    801cb3 <ipc_find_env+0x40>
			return envs[i].env_id;
  801ca2:	89 c2                	mov    %eax,%edx
  801ca4:	c1 e2 05             	shl    $0x5,%edx
  801ca7:	29 c2                	sub    %eax,%edx
  801ca9:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801cb0:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    

00801cb5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	c1 e8 16             	shr    $0x16,%eax
  801cbe:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801cc5:	a8 01                	test   $0x1,%al
  801cc7:	74 21                	je     801cea <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	c1 e8 0c             	shr    $0xc,%eax
  801ccf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cd6:	a8 01                	test   $0x1,%al
  801cd8:	74 17                	je     801cf1 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cda:	c1 e8 0c             	shr    $0xc,%eax
  801cdd:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801ce4:	ef 
  801ce5:	0f b7 c0             	movzwl %ax,%eax
  801ce8:	eb 05                	jmp    801cef <pageref+0x3a>
		return 0;
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cef:	5d                   	pop    %ebp
  801cf0:	c3                   	ret    
		return 0;
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf6:	eb f7                	jmp    801cef <pageref+0x3a>

00801cf8 <__udivdi3>:
  801cf8:	55                   	push   %ebp
  801cf9:	57                   	push   %edi
  801cfa:	56                   	push   %esi
  801cfb:	53                   	push   %ebx
  801cfc:	83 ec 1c             	sub    $0x1c,%esp
  801cff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d0b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d0f:	89 ca                	mov    %ecx,%edx
  801d11:	89 f8                	mov    %edi,%eax
  801d13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d17:	85 f6                	test   %esi,%esi
  801d19:	75 2d                	jne    801d48 <__udivdi3+0x50>
  801d1b:	39 cf                	cmp    %ecx,%edi
  801d1d:	77 65                	ja     801d84 <__udivdi3+0x8c>
  801d1f:	89 fd                	mov    %edi,%ebp
  801d21:	85 ff                	test   %edi,%edi
  801d23:	75 0b                	jne    801d30 <__udivdi3+0x38>
  801d25:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2a:	31 d2                	xor    %edx,%edx
  801d2c:	f7 f7                	div    %edi
  801d2e:	89 c5                	mov    %eax,%ebp
  801d30:	31 d2                	xor    %edx,%edx
  801d32:	89 c8                	mov    %ecx,%eax
  801d34:	f7 f5                	div    %ebp
  801d36:	89 c1                	mov    %eax,%ecx
  801d38:	89 d8                	mov    %ebx,%eax
  801d3a:	f7 f5                	div    %ebp
  801d3c:	89 cf                	mov    %ecx,%edi
  801d3e:	89 fa                	mov    %edi,%edx
  801d40:	83 c4 1c             	add    $0x1c,%esp
  801d43:	5b                   	pop    %ebx
  801d44:	5e                   	pop    %esi
  801d45:	5f                   	pop    %edi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    
  801d48:	39 ce                	cmp    %ecx,%esi
  801d4a:	77 28                	ja     801d74 <__udivdi3+0x7c>
  801d4c:	0f bd fe             	bsr    %esi,%edi
  801d4f:	83 f7 1f             	xor    $0x1f,%edi
  801d52:	75 40                	jne    801d94 <__udivdi3+0x9c>
  801d54:	39 ce                	cmp    %ecx,%esi
  801d56:	72 0a                	jb     801d62 <__udivdi3+0x6a>
  801d58:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d5c:	0f 87 9e 00 00 00    	ja     801e00 <__udivdi3+0x108>
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	89 fa                	mov    %edi,%edx
  801d69:	83 c4 1c             	add    $0x1c,%esp
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5f                   	pop    %edi
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    
  801d71:	8d 76 00             	lea    0x0(%esi),%esi
  801d74:	31 ff                	xor    %edi,%edi
  801d76:	31 c0                	xor    %eax,%eax
  801d78:	89 fa                	mov    %edi,%edx
  801d7a:	83 c4 1c             	add    $0x1c,%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5e                   	pop    %esi
  801d7f:	5f                   	pop    %edi
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    
  801d82:	66 90                	xchg   %ax,%ax
  801d84:	89 d8                	mov    %ebx,%eax
  801d86:	f7 f7                	div    %edi
  801d88:	31 ff                	xor    %edi,%edi
  801d8a:	89 fa                	mov    %edi,%edx
  801d8c:	83 c4 1c             	add    $0x1c,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    
  801d94:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d99:	29 fd                	sub    %edi,%ebp
  801d9b:	89 f9                	mov    %edi,%ecx
  801d9d:	d3 e6                	shl    %cl,%esi
  801d9f:	89 c3                	mov    %eax,%ebx
  801da1:	89 e9                	mov    %ebp,%ecx
  801da3:	d3 eb                	shr    %cl,%ebx
  801da5:	89 d9                	mov    %ebx,%ecx
  801da7:	09 f1                	or     %esi,%ecx
  801da9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dad:	89 f9                	mov    %edi,%ecx
  801daf:	d3 e0                	shl    %cl,%eax
  801db1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801db5:	89 d6                	mov    %edx,%esi
  801db7:	89 e9                	mov    %ebp,%ecx
  801db9:	d3 ee                	shr    %cl,%esi
  801dbb:	89 f9                	mov    %edi,%ecx
  801dbd:	d3 e2                	shl    %cl,%edx
  801dbf:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801dc3:	89 e9                	mov    %ebp,%ecx
  801dc5:	d3 eb                	shr    %cl,%ebx
  801dc7:	09 da                	or     %ebx,%edx
  801dc9:	89 d0                	mov    %edx,%eax
  801dcb:	89 f2                	mov    %esi,%edx
  801dcd:	f7 74 24 08          	divl   0x8(%esp)
  801dd1:	89 d6                	mov    %edx,%esi
  801dd3:	89 c3                	mov    %eax,%ebx
  801dd5:	f7 64 24 0c          	mull   0xc(%esp)
  801dd9:	39 d6                	cmp    %edx,%esi
  801ddb:	72 17                	jb     801df4 <__udivdi3+0xfc>
  801ddd:	74 09                	je     801de8 <__udivdi3+0xf0>
  801ddf:	89 d8                	mov    %ebx,%eax
  801de1:	31 ff                	xor    %edi,%edi
  801de3:	e9 56 ff ff ff       	jmp    801d3e <__udivdi3+0x46>
  801de8:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dec:	89 f9                	mov    %edi,%ecx
  801dee:	d3 e2                	shl    %cl,%edx
  801df0:	39 c2                	cmp    %eax,%edx
  801df2:	73 eb                	jae    801ddf <__udivdi3+0xe7>
  801df4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801df7:	31 ff                	xor    %edi,%edi
  801df9:	e9 40 ff ff ff       	jmp    801d3e <__udivdi3+0x46>
  801dfe:	66 90                	xchg   %ax,%ax
  801e00:	31 c0                	xor    %eax,%eax
  801e02:	e9 37 ff ff ff       	jmp    801d3e <__udivdi3+0x46>
  801e07:	90                   	nop

00801e08 <__umoddi3>:
  801e08:	55                   	push   %ebp
  801e09:	57                   	push   %edi
  801e0a:	56                   	push   %esi
  801e0b:	53                   	push   %ebx
  801e0c:	83 ec 1c             	sub    $0x1c,%esp
  801e0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e27:	89 3c 24             	mov    %edi,(%esp)
  801e2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e2e:	89 f2                	mov    %esi,%edx
  801e30:	85 c0                	test   %eax,%eax
  801e32:	75 18                	jne    801e4c <__umoddi3+0x44>
  801e34:	39 f7                	cmp    %esi,%edi
  801e36:	0f 86 a0 00 00 00    	jbe    801edc <__umoddi3+0xd4>
  801e3c:	89 c8                	mov    %ecx,%eax
  801e3e:	f7 f7                	div    %edi
  801e40:	89 d0                	mov    %edx,%eax
  801e42:	31 d2                	xor    %edx,%edx
  801e44:	83 c4 1c             	add    $0x1c,%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5f                   	pop    %edi
  801e4a:	5d                   	pop    %ebp
  801e4b:	c3                   	ret    
  801e4c:	89 f3                	mov    %esi,%ebx
  801e4e:	39 f0                	cmp    %esi,%eax
  801e50:	0f 87 a6 00 00 00    	ja     801efc <__umoddi3+0xf4>
  801e56:	0f bd e8             	bsr    %eax,%ebp
  801e59:	83 f5 1f             	xor    $0x1f,%ebp
  801e5c:	0f 84 a6 00 00 00    	je     801f08 <__umoddi3+0x100>
  801e62:	bf 20 00 00 00       	mov    $0x20,%edi
  801e67:	29 ef                	sub    %ebp,%edi
  801e69:	89 e9                	mov    %ebp,%ecx
  801e6b:	d3 e0                	shl    %cl,%eax
  801e6d:	8b 34 24             	mov    (%esp),%esi
  801e70:	89 f2                	mov    %esi,%edx
  801e72:	89 f9                	mov    %edi,%ecx
  801e74:	d3 ea                	shr    %cl,%edx
  801e76:	09 c2                	or     %eax,%edx
  801e78:	89 14 24             	mov    %edx,(%esp)
  801e7b:	89 f2                	mov    %esi,%edx
  801e7d:	89 e9                	mov    %ebp,%ecx
  801e7f:	d3 e2                	shl    %cl,%edx
  801e81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e85:	89 de                	mov    %ebx,%esi
  801e87:	89 f9                	mov    %edi,%ecx
  801e89:	d3 ee                	shr    %cl,%esi
  801e8b:	89 e9                	mov    %ebp,%ecx
  801e8d:	d3 e3                	shl    %cl,%ebx
  801e8f:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e93:	89 d0                	mov    %edx,%eax
  801e95:	89 f9                	mov    %edi,%ecx
  801e97:	d3 e8                	shr    %cl,%eax
  801e99:	09 d8                	or     %ebx,%eax
  801e9b:	89 d3                	mov    %edx,%ebx
  801e9d:	89 e9                	mov    %ebp,%ecx
  801e9f:	d3 e3                	shl    %cl,%ebx
  801ea1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ea5:	89 f2                	mov    %esi,%edx
  801ea7:	f7 34 24             	divl   (%esp)
  801eaa:	89 d6                	mov    %edx,%esi
  801eac:	f7 64 24 04          	mull   0x4(%esp)
  801eb0:	89 c3                	mov    %eax,%ebx
  801eb2:	89 d1                	mov    %edx,%ecx
  801eb4:	39 d6                	cmp    %edx,%esi
  801eb6:	72 7c                	jb     801f34 <__umoddi3+0x12c>
  801eb8:	74 72                	je     801f2c <__umoddi3+0x124>
  801eba:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ebe:	29 da                	sub    %ebx,%edx
  801ec0:	19 ce                	sbb    %ecx,%esi
  801ec2:	89 f0                	mov    %esi,%eax
  801ec4:	89 f9                	mov    %edi,%ecx
  801ec6:	d3 e0                	shl    %cl,%eax
  801ec8:	89 e9                	mov    %ebp,%ecx
  801eca:	d3 ea                	shr    %cl,%edx
  801ecc:	09 d0                	or     %edx,%eax
  801ece:	89 e9                	mov    %ebp,%ecx
  801ed0:	d3 ee                	shr    %cl,%esi
  801ed2:	89 f2                	mov    %esi,%edx
  801ed4:	83 c4 1c             	add    $0x1c,%esp
  801ed7:	5b                   	pop    %ebx
  801ed8:	5e                   	pop    %esi
  801ed9:	5f                   	pop    %edi
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    
  801edc:	89 fd                	mov    %edi,%ebp
  801ede:	85 ff                	test   %edi,%edi
  801ee0:	75 0b                	jne    801eed <__umoddi3+0xe5>
  801ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee7:	31 d2                	xor    %edx,%edx
  801ee9:	f7 f7                	div    %edi
  801eeb:	89 c5                	mov    %eax,%ebp
  801eed:	89 f0                	mov    %esi,%eax
  801eef:	31 d2                	xor    %edx,%edx
  801ef1:	f7 f5                	div    %ebp
  801ef3:	89 c8                	mov    %ecx,%eax
  801ef5:	f7 f5                	div    %ebp
  801ef7:	e9 44 ff ff ff       	jmp    801e40 <__umoddi3+0x38>
  801efc:	89 c8                	mov    %ecx,%eax
  801efe:	89 f2                	mov    %esi,%edx
  801f00:	83 c4 1c             	add    $0x1c,%esp
  801f03:	5b                   	pop    %ebx
  801f04:	5e                   	pop    %esi
  801f05:	5f                   	pop    %edi
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    
  801f08:	39 f0                	cmp    %esi,%eax
  801f0a:	72 05                	jb     801f11 <__umoddi3+0x109>
  801f0c:	39 0c 24             	cmp    %ecx,(%esp)
  801f0f:	77 0c                	ja     801f1d <__umoddi3+0x115>
  801f11:	89 f2                	mov    %esi,%edx
  801f13:	29 f9                	sub    %edi,%ecx
  801f15:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f19:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f1d:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f21:	83 c4 1c             	add    $0x1c,%esp
  801f24:	5b                   	pop    %ebx
  801f25:	5e                   	pop    %esi
  801f26:	5f                   	pop    %edi
  801f27:	5d                   	pop    %ebp
  801f28:	c3                   	ret    
  801f29:	8d 76 00             	lea    0x0(%esi),%esi
  801f2c:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f30:	73 88                	jae    801eba <__umoddi3+0xb2>
  801f32:	66 90                	xchg   %ax,%ax
  801f34:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f38:	1b 14 24             	sbb    (%esp),%edx
  801f3b:	89 d1                	mov    %edx,%ecx
  801f3d:	89 c3                	mov    %eax,%ebx
  801f3f:	e9 76 ff ff ff       	jmp    801eba <__umoddi3+0xb2>
