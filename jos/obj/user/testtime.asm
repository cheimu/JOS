
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 64 00 00 00       	call   800095 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  80003f:	e8 cf 0b 00 00       	call   800c13 <sys_yield>
	for (i = 0; i < 50; i++)
  800044:	4b                   	dec    %ebx
  800045:	75 f8                	jne    80003f <umain+0xc>

	cprintf("starting count down: ");
  800047:	83 ec 0c             	sub    $0xc,%esp
  80004a:	68 20 21 80 00       	push   $0x802120
  80004f:	e8 3b 01 00 00       	call   80018f <cprintf>
  800054:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  800057:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	53                   	push   %ebx
  800060:	68 36 21 80 00       	push   $0x802136
  800065:	e8 25 01 00 00       	call   80018f <cprintf>
		sleep(1);
  80006a:	83 c4 08             	add    $0x8,%esp
  80006d:	6a 00                	push   $0x0
  80006f:	6a 01                	push   $0x1
  800071:	e8 ef 0d 00 00       	call   800e65 <sleep>
	for (i = 5; i >= 0; i--) {
  800076:	4b                   	dec    %ebx
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	83 fb ff             	cmp    $0xffffffff,%ebx
  80007d:	75 dd                	jne    80005c <umain+0x29>
	}
	cprintf("\n");
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 a7 25 80 00       	push   $0x8025a7
  800087:	e8 03 01 00 00       	call   80018f <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80008c:	cc                   	int3   
	breakpoint();
}
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800093:	c9                   	leave  
  800094:	c3                   	ret    

00800095 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800095:	55                   	push   %ebp
  800096:	89 e5                	mov    %esp,%ebp
  800098:	56                   	push   %esi
  800099:	53                   	push   %ebx
  80009a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a0:	e8 88 0a 00 00       	call   800b2d <sys_getenvid>
  8000a5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000aa:	89 c2                	mov    %eax,%edx
  8000ac:	c1 e2 05             	shl    $0x5,%edx
  8000af:	29 c2                	sub    %eax,%edx
  8000b1:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000b8:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bd:	85 db                	test   %ebx,%ebx
  8000bf:	7e 07                	jle    8000c8 <libmain+0x33>
		binaryname = argv[0];
  8000c1:	8b 06                	mov    (%esi),%eax
  8000c3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
  8000cd:	e8 61 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d2:	e8 0a 00 00 00       	call   8000e1 <exit>
}
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5d                   	pop    %ebp
  8000e0:	c3                   	ret    

008000e1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000e7:	e8 ad 10 00 00       	call   801199 <close_all>
	sys_env_destroy(0);
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	6a 00                	push   $0x0
  8000f1:	e8 f6 09 00 00       	call   800aec <sys_env_destroy>
}
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	c9                   	leave  
  8000fa:	c3                   	ret    

008000fb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	53                   	push   %ebx
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800105:	8b 13                	mov    (%ebx),%edx
  800107:	8d 42 01             	lea    0x1(%edx),%eax
  80010a:	89 03                	mov    %eax,(%ebx)
  80010c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800113:	3d ff 00 00 00       	cmp    $0xff,%eax
  800118:	74 08                	je     800122 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011a:	ff 43 04             	incl   0x4(%ebx)
}
  80011d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800120:	c9                   	leave  
  800121:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	68 ff 00 00 00       	push   $0xff
  80012a:	8d 43 08             	lea    0x8(%ebx),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 7c 09 00 00       	call   800aaf <sys_cputs>
		b->idx = 0;
  800133:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	eb dc                	jmp    80011a <putch+0x1f>

0080013e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800147:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014e:	00 00 00 
	b.cnt = 0;
  800151:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800158:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015b:	ff 75 0c             	pushl  0xc(%ebp)
  80015e:	ff 75 08             	pushl  0x8(%ebp)
  800161:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	68 fb 00 80 00       	push   $0x8000fb
  80016d:	e8 17 01 00 00       	call   800289 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800172:	83 c4 08             	add    $0x8,%esp
  800175:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 28 09 00 00       	call   800aaf <sys_cputs>

	return b.cnt;
}
  800187:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800195:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800198:	50                   	push   %eax
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 9d ff ff ff       	call   80013e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	57                   	push   %edi
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	83 ec 1c             	sub    $0x1c,%esp
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 d6                	mov    %edx,%esi
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001c7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001ca:	39 d3                	cmp    %edx,%ebx
  8001cc:	72 05                	jb     8001d3 <printnum+0x30>
  8001ce:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d1:	77 78                	ja     80024b <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	ff 75 18             	pushl  0x18(%ebp)
  8001d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8001dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001df:	53                   	push   %ebx
  8001e0:	ff 75 10             	pushl  0x10(%ebp)
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ec:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f2:	e8 c5 1c 00 00       	call   801ebc <__udivdi3>
  8001f7:	83 c4 18             	add    $0x18,%esp
  8001fa:	52                   	push   %edx
  8001fb:	50                   	push   %eax
  8001fc:	89 f2                	mov    %esi,%edx
  8001fe:	89 f8                	mov    %edi,%eax
  800200:	e8 9e ff ff ff       	call   8001a3 <printnum>
  800205:	83 c4 20             	add    $0x20,%esp
  800208:	eb 11                	jmp    80021b <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	56                   	push   %esi
  80020e:	ff 75 18             	pushl  0x18(%ebp)
  800211:	ff d7                	call   *%edi
  800213:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800216:	4b                   	dec    %ebx
  800217:	85 db                	test   %ebx,%ebx
  800219:	7f ef                	jg     80020a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	56                   	push   %esi
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	ff 75 dc             	pushl  -0x24(%ebp)
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 99 1d 00 00       	call   801fcc <__umoddi3>
  800233:	83 c4 14             	add    $0x14,%esp
  800236:	0f be 80 44 21 80 00 	movsbl 0x802144(%eax),%eax
  80023d:	50                   	push   %eax
  80023e:	ff d7                	call   *%edi
}
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800246:	5b                   	pop    %ebx
  800247:	5e                   	pop    %esi
  800248:	5f                   	pop    %edi
  800249:	5d                   	pop    %ebp
  80024a:	c3                   	ret    
  80024b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80024e:	eb c6                	jmp    800216 <printnum+0x73>

00800250 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800256:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800259:	8b 10                	mov    (%eax),%edx
  80025b:	3b 50 04             	cmp    0x4(%eax),%edx
  80025e:	73 0a                	jae    80026a <sprintputch+0x1a>
		*b->buf++ = ch;
  800260:	8d 4a 01             	lea    0x1(%edx),%ecx
  800263:	89 08                	mov    %ecx,(%eax)
  800265:	8b 45 08             	mov    0x8(%ebp),%eax
  800268:	88 02                	mov    %al,(%edx)
}
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <printfmt>:
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800272:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800275:	50                   	push   %eax
  800276:	ff 75 10             	pushl  0x10(%ebp)
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	e8 05 00 00 00       	call   800289 <vprintfmt>
}
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <vprintfmt>:
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	57                   	push   %edi
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
  80028f:	83 ec 2c             	sub    $0x2c,%esp
  800292:	8b 75 08             	mov    0x8(%ebp),%esi
  800295:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800298:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029b:	e9 ae 03 00 00       	jmp    80064e <vprintfmt+0x3c5>
  8002a0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002a4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002ab:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002b2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002b9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002be:	8d 47 01             	lea    0x1(%edi),%eax
  8002c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c4:	8a 17                	mov    (%edi),%dl
  8002c6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c9:	3c 55                	cmp    $0x55,%al
  8002cb:	0f 87 fe 03 00 00    	ja     8006cf <vprintfmt+0x446>
  8002d1:	0f b6 c0             	movzbl %al,%eax
  8002d4:	ff 24 85 80 22 80 00 	jmp    *0x802280(,%eax,4)
  8002db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002de:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002e2:	eb da                	jmp    8002be <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002e7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002eb:	eb d1                	jmp    8002be <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ed:	0f b6 d2             	movzbl %dl,%edx
  8002f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002fe:	01 c0                	add    %eax,%eax
  800300:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800304:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800307:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80030a:	83 f9 09             	cmp    $0x9,%ecx
  80030d:	77 52                	ja     800361 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80030f:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800310:	eb e9                	jmp    8002fb <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800312:	8b 45 14             	mov    0x14(%ebp),%eax
  800315:	8b 00                	mov    (%eax),%eax
  800317:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80031a:	8b 45 14             	mov    0x14(%ebp),%eax
  80031d:	8d 40 04             	lea    0x4(%eax),%eax
  800320:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800323:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800326:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032a:	79 92                	jns    8002be <vprintfmt+0x35>
				width = precision, precision = -1;
  80032c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80032f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800332:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800339:	eb 83                	jmp    8002be <vprintfmt+0x35>
  80033b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80033f:	78 08                	js     800349 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800341:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800344:	e9 75 ff ff ff       	jmp    8002be <vprintfmt+0x35>
  800349:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800350:	eb ef                	jmp    800341 <vprintfmt+0xb8>
  800352:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800355:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80035c:	e9 5d ff ff ff       	jmp    8002be <vprintfmt+0x35>
  800361:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800364:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800367:	eb bd                	jmp    800326 <vprintfmt+0x9d>
			lflag++;
  800369:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80036d:	e9 4c ff ff ff       	jmp    8002be <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800372:	8b 45 14             	mov    0x14(%ebp),%eax
  800375:	8d 78 04             	lea    0x4(%eax),%edi
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	53                   	push   %ebx
  80037c:	ff 30                	pushl  (%eax)
  80037e:	ff d6                	call   *%esi
			break;
  800380:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800383:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800386:	e9 c0 02 00 00       	jmp    80064b <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80038b:	8b 45 14             	mov    0x14(%ebp),%eax
  80038e:	8d 78 04             	lea    0x4(%eax),%edi
  800391:	8b 00                	mov    (%eax),%eax
  800393:	85 c0                	test   %eax,%eax
  800395:	78 2a                	js     8003c1 <vprintfmt+0x138>
  800397:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800399:	83 f8 0f             	cmp    $0xf,%eax
  80039c:	7f 27                	jg     8003c5 <vprintfmt+0x13c>
  80039e:	8b 04 85 e0 23 80 00 	mov    0x8023e0(,%eax,4),%eax
  8003a5:	85 c0                	test   %eax,%eax
  8003a7:	74 1c                	je     8003c5 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8003a9:	50                   	push   %eax
  8003aa:	68 75 25 80 00       	push   $0x802575
  8003af:	53                   	push   %ebx
  8003b0:	56                   	push   %esi
  8003b1:	e8 b6 fe ff ff       	call   80026c <printfmt>
  8003b6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003bc:	e9 8a 02 00 00       	jmp    80064b <vprintfmt+0x3c2>
  8003c1:	f7 d8                	neg    %eax
  8003c3:	eb d2                	jmp    800397 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8003c5:	52                   	push   %edx
  8003c6:	68 5c 21 80 00       	push   $0x80215c
  8003cb:	53                   	push   %ebx
  8003cc:	56                   	push   %esi
  8003cd:	e8 9a fe ff ff       	call   80026c <printfmt>
  8003d2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003d8:	e9 6e 02 00 00       	jmp    80064b <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8003dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e0:	83 c0 04             	add    $0x4,%eax
  8003e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	8b 38                	mov    (%eax),%edi
  8003eb:	85 ff                	test   %edi,%edi
  8003ed:	74 39                	je     800428 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8003ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f3:	0f 8e a9 00 00 00    	jle    8004a2 <vprintfmt+0x219>
  8003f9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003fd:	0f 84 a7 00 00 00    	je     8004aa <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	ff 75 d0             	pushl  -0x30(%ebp)
  800409:	57                   	push   %edi
  80040a:	e8 6b 03 00 00       	call   80077a <strnlen>
  80040f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800412:	29 c1                	sub    %eax,%ecx
  800414:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800417:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80041a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80041e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800421:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800424:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800426:	eb 14                	jmp    80043c <vprintfmt+0x1b3>
				p = "(null)";
  800428:	bf 55 21 80 00       	mov    $0x802155,%edi
  80042d:	eb c0                	jmp    8003ef <vprintfmt+0x166>
					putch(padc, putdat);
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	53                   	push   %ebx
  800433:	ff 75 e0             	pushl  -0x20(%ebp)
  800436:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800438:	4f                   	dec    %edi
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	85 ff                	test   %edi,%edi
  80043e:	7f ef                	jg     80042f <vprintfmt+0x1a6>
  800440:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800443:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800446:	89 c8                	mov    %ecx,%eax
  800448:	85 c9                	test   %ecx,%ecx
  80044a:	78 10                	js     80045c <vprintfmt+0x1d3>
  80044c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80044f:	29 c1                	sub    %eax,%ecx
  800451:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800454:	89 75 08             	mov    %esi,0x8(%ebp)
  800457:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80045a:	eb 15                	jmp    800471 <vprintfmt+0x1e8>
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	eb e9                	jmp    80044c <vprintfmt+0x1c3>
					putch(ch, putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	53                   	push   %ebx
  800467:	52                   	push   %edx
  800468:	ff 55 08             	call   *0x8(%ebp)
  80046b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80046e:	ff 4d e0             	decl   -0x20(%ebp)
  800471:	47                   	inc    %edi
  800472:	8a 47 ff             	mov    -0x1(%edi),%al
  800475:	0f be d0             	movsbl %al,%edx
  800478:	85 d2                	test   %edx,%edx
  80047a:	74 59                	je     8004d5 <vprintfmt+0x24c>
  80047c:	85 f6                	test   %esi,%esi
  80047e:	78 03                	js     800483 <vprintfmt+0x1fa>
  800480:	4e                   	dec    %esi
  800481:	78 2f                	js     8004b2 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800483:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800487:	74 da                	je     800463 <vprintfmt+0x1da>
  800489:	0f be c0             	movsbl %al,%eax
  80048c:	83 e8 20             	sub    $0x20,%eax
  80048f:	83 f8 5e             	cmp    $0x5e,%eax
  800492:	76 cf                	jbe    800463 <vprintfmt+0x1da>
					putch('?', putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	53                   	push   %ebx
  800498:	6a 3f                	push   $0x3f
  80049a:	ff 55 08             	call   *0x8(%ebp)
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	eb cc                	jmp    80046e <vprintfmt+0x1e5>
  8004a2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a8:	eb c7                	jmp    800471 <vprintfmt+0x1e8>
  8004aa:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ad:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004b0:	eb bf                	jmp    800471 <vprintfmt+0x1e8>
  8004b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b5:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004b8:	eb 0c                	jmp    8004c6 <vprintfmt+0x23d>
				putch(' ', putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	53                   	push   %ebx
  8004be:	6a 20                	push   $0x20
  8004c0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004c2:	4f                   	dec    %edi
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	85 ff                	test   %edi,%edi
  8004c8:	7f f0                	jg     8004ba <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8004d0:	e9 76 01 00 00       	jmp    80064b <vprintfmt+0x3c2>
  8004d5:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8004db:	eb e9                	jmp    8004c6 <vprintfmt+0x23d>
	if (lflag >= 2)
  8004dd:	83 f9 01             	cmp    $0x1,%ecx
  8004e0:	7f 1f                	jg     800501 <vprintfmt+0x278>
	else if (lflag)
  8004e2:	85 c9                	test   %ecx,%ecx
  8004e4:	75 48                	jne    80052e <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8004e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ee:	89 c1                	mov    %eax,%ecx
  8004f0:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	8d 40 04             	lea    0x4(%eax),%eax
  8004fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ff:	eb 17                	jmp    800518 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8b 50 04             	mov    0x4(%eax),%edx
  800507:	8b 00                	mov    (%eax),%eax
  800509:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8d 40 08             	lea    0x8(%eax),%eax
  800515:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800518:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80051b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80051e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800522:	78 25                	js     800549 <vprintfmt+0x2c0>
			base = 10;
  800524:	b8 0a 00 00 00       	mov    $0xa,%eax
  800529:	e9 03 01 00 00       	jmp    800631 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800536:	89 c1                	mov    %eax,%ecx
  800538:	c1 f9 1f             	sar    $0x1f,%ecx
  80053b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8d 40 04             	lea    0x4(%eax),%eax
  800544:	89 45 14             	mov    %eax,0x14(%ebp)
  800547:	eb cf                	jmp    800518 <vprintfmt+0x28f>
				putch('-', putdat);
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	53                   	push   %ebx
  80054d:	6a 2d                	push   $0x2d
  80054f:	ff d6                	call   *%esi
				num = -(long long) num;
  800551:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800554:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800557:	f7 da                	neg    %edx
  800559:	83 d1 00             	adc    $0x0,%ecx
  80055c:	f7 d9                	neg    %ecx
  80055e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800561:	b8 0a 00 00 00       	mov    $0xa,%eax
  800566:	e9 c6 00 00 00       	jmp    800631 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80056b:	83 f9 01             	cmp    $0x1,%ecx
  80056e:	7f 1e                	jg     80058e <vprintfmt+0x305>
	else if (lflag)
  800570:	85 c9                	test   %ecx,%ecx
  800572:	75 32                	jne    8005a6 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 10                	mov    (%eax),%edx
  800579:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057e:	8d 40 04             	lea    0x4(%eax),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800584:	b8 0a 00 00 00       	mov    $0xa,%eax
  800589:	e9 a3 00 00 00       	jmp    800631 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8b 10                	mov    (%eax),%edx
  800593:	8b 48 04             	mov    0x4(%eax),%ecx
  800596:	8d 40 08             	lea    0x8(%eax),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a1:	e9 8b 00 00 00       	jmp    800631 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b0:	8d 40 04             	lea    0x4(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bb:	eb 74                	jmp    800631 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005bd:	83 f9 01             	cmp    $0x1,%ecx
  8005c0:	7f 1b                	jg     8005dd <vprintfmt+0x354>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	75 2c                	jne    8005f2 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8005db:	eb 54                	jmp    800631 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e5:	8d 40 08             	lea    0x8(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f0:	eb 3f                	jmp    800631 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 10                	mov    (%eax),%edx
  8005f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800602:	b8 08 00 00 00       	mov    $0x8,%eax
  800607:	eb 28                	jmp    800631 <vprintfmt+0x3a8>
			putch('0', putdat);
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	53                   	push   %ebx
  80060d:	6a 30                	push   $0x30
  80060f:	ff d6                	call   *%esi
			putch('x', putdat);
  800611:	83 c4 08             	add    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 78                	push   $0x78
  800617:	ff d6                	call   *%esi
			num = (unsigned long long)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 10                	mov    (%eax),%edx
  80061e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800623:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800626:	8d 40 04             	lea    0x4(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800638:	57                   	push   %edi
  800639:	ff 75 e0             	pushl  -0x20(%ebp)
  80063c:	50                   	push   %eax
  80063d:	51                   	push   %ecx
  80063e:	52                   	push   %edx
  80063f:	89 da                	mov    %ebx,%edx
  800641:	89 f0                	mov    %esi,%eax
  800643:	e8 5b fb ff ff       	call   8001a3 <printnum>
			break;
  800648:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80064b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064e:	47                   	inc    %edi
  80064f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800653:	83 f8 25             	cmp    $0x25,%eax
  800656:	0f 84 44 fc ff ff    	je     8002a0 <vprintfmt+0x17>
			if (ch == '\0')
  80065c:	85 c0                	test   %eax,%eax
  80065e:	0f 84 89 00 00 00    	je     8006ed <vprintfmt+0x464>
			putch(ch, putdat);
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	53                   	push   %ebx
  800668:	50                   	push   %eax
  800669:	ff d6                	call   *%esi
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	eb de                	jmp    80064e <vprintfmt+0x3c5>
	if (lflag >= 2)
  800670:	83 f9 01             	cmp    $0x1,%ecx
  800673:	7f 1b                	jg     800690 <vprintfmt+0x407>
	else if (lflag)
  800675:	85 c9                	test   %ecx,%ecx
  800677:	75 2c                	jne    8006a5 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 10                	mov    (%eax),%edx
  80067e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800683:	8d 40 04             	lea    0x4(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800689:	b8 10 00 00 00       	mov    $0x10,%eax
  80068e:	eb a1                	jmp    800631 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 10                	mov    (%eax),%edx
  800695:	8b 48 04             	mov    0x4(%eax),%ecx
  800698:	8d 40 08             	lea    0x8(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069e:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a3:	eb 8c                	jmp    800631 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8b 10                	mov    (%eax),%edx
  8006aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006af:	8d 40 04             	lea    0x4(%eax),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b5:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ba:	e9 72 ff ff ff       	jmp    800631 <vprintfmt+0x3a8>
			putch(ch, putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	53                   	push   %ebx
  8006c3:	6a 25                	push   $0x25
  8006c5:	ff d6                	call   *%esi
			break;
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	e9 7c ff ff ff       	jmp    80064b <vprintfmt+0x3c2>
			putch('%', putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	53                   	push   %ebx
  8006d3:	6a 25                	push   $0x25
  8006d5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	89 f8                	mov    %edi,%eax
  8006dc:	eb 01                	jmp    8006df <vprintfmt+0x456>
  8006de:	48                   	dec    %eax
  8006df:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e3:	75 f9                	jne    8006de <vprintfmt+0x455>
  8006e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e8:	e9 5e ff ff ff       	jmp    80064b <vprintfmt+0x3c2>
}
  8006ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f0:	5b                   	pop    %ebx
  8006f1:	5e                   	pop    %esi
  8006f2:	5f                   	pop    %edi
  8006f3:	5d                   	pop    %ebp
  8006f4:	c3                   	ret    

008006f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 18             	sub    $0x18,%esp
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800701:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800704:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800708:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80070b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800712:	85 c0                	test   %eax,%eax
  800714:	74 26                	je     80073c <vsnprintf+0x47>
  800716:	85 d2                	test   %edx,%edx
  800718:	7e 29                	jle    800743 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80071a:	ff 75 14             	pushl  0x14(%ebp)
  80071d:	ff 75 10             	pushl  0x10(%ebp)
  800720:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800723:	50                   	push   %eax
  800724:	68 50 02 80 00       	push   $0x800250
  800729:	e8 5b fb ff ff       	call   800289 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80072e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800731:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800737:	83 c4 10             	add    $0x10,%esp
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    
		return -E_INVAL;
  80073c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800741:	eb f7                	jmp    80073a <vsnprintf+0x45>
  800743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800748:	eb f0                	jmp    80073a <vsnprintf+0x45>

0080074a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800750:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800753:	50                   	push   %eax
  800754:	ff 75 10             	pushl  0x10(%ebp)
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	ff 75 08             	pushl  0x8(%ebp)
  80075d:	e8 93 ff ff ff       	call   8006f5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80076a:	b8 00 00 00 00       	mov    $0x0,%eax
  80076f:	eb 01                	jmp    800772 <strlen+0xe>
		n++;
  800771:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800772:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800776:	75 f9                	jne    800771 <strlen+0xd>
	return n;
}
  800778:	5d                   	pop    %ebp
  800779:	c3                   	ret    

0080077a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800780:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800783:	b8 00 00 00 00       	mov    $0x0,%eax
  800788:	eb 01                	jmp    80078b <strnlen+0x11>
		n++;
  80078a:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078b:	39 d0                	cmp    %edx,%eax
  80078d:	74 06                	je     800795 <strnlen+0x1b>
  80078f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800793:	75 f5                	jne    80078a <strnlen+0x10>
	return n;
}
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	53                   	push   %ebx
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	42                   	inc    %edx
  8007a4:	41                   	inc    %ecx
  8007a5:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8007a8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ab:	84 db                	test   %bl,%bl
  8007ad:	75 f4                	jne    8007a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007af:	5b                   	pop    %ebx
  8007b0:	5d                   	pop    %ebp
  8007b1:	c3                   	ret    

008007b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	53                   	push   %ebx
  8007b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b9:	53                   	push   %ebx
  8007ba:	e8 a5 ff ff ff       	call   800764 <strlen>
  8007bf:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007c2:	ff 75 0c             	pushl  0xc(%ebp)
  8007c5:	01 d8                	add    %ebx,%eax
  8007c7:	50                   	push   %eax
  8007c8:	e8 ca ff ff ff       	call   800797 <strcpy>
	return dst;
}
  8007cd:	89 d8                	mov    %ebx,%eax
  8007cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	56                   	push   %esi
  8007d8:	53                   	push   %ebx
  8007d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007df:	89 f3                	mov    %esi,%ebx
  8007e1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e4:	89 f2                	mov    %esi,%edx
  8007e6:	eb 0c                	jmp    8007f4 <strncpy+0x20>
		*dst++ = *src;
  8007e8:	42                   	inc    %edx
  8007e9:	8a 01                	mov    (%ecx),%al
  8007eb:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ee:	80 39 01             	cmpb   $0x1,(%ecx)
  8007f1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007f4:	39 da                	cmp    %ebx,%edx
  8007f6:	75 f0                	jne    8007e8 <strncpy+0x14>
	}
	return ret;
}
  8007f8:	89 f0                	mov    %esi,%eax
  8007fa:	5b                   	pop    %ebx
  8007fb:	5e                   	pop    %esi
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	56                   	push   %esi
  800802:	53                   	push   %ebx
  800803:	8b 75 08             	mov    0x8(%ebp),%esi
  800806:	8b 55 0c             	mov    0xc(%ebp),%edx
  800809:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80080c:	85 c0                	test   %eax,%eax
  80080e:	74 20                	je     800830 <strlcpy+0x32>
  800810:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800814:	89 f0                	mov    %esi,%eax
  800816:	eb 05                	jmp    80081d <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800818:	40                   	inc    %eax
  800819:	42                   	inc    %edx
  80081a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80081d:	39 d8                	cmp    %ebx,%eax
  80081f:	74 06                	je     800827 <strlcpy+0x29>
  800821:	8a 0a                	mov    (%edx),%cl
  800823:	84 c9                	test   %cl,%cl
  800825:	75 f1                	jne    800818 <strlcpy+0x1a>
		*dst = '\0';
  800827:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80082a:	29 f0                	sub    %esi,%eax
}
  80082c:	5b                   	pop    %ebx
  80082d:	5e                   	pop    %esi
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    
  800830:	89 f0                	mov    %esi,%eax
  800832:	eb f6                	jmp    80082a <strlcpy+0x2c>

00800834 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80083d:	eb 02                	jmp    800841 <strcmp+0xd>
		p++, q++;
  80083f:	41                   	inc    %ecx
  800840:	42                   	inc    %edx
	while (*p && *p == *q)
  800841:	8a 01                	mov    (%ecx),%al
  800843:	84 c0                	test   %al,%al
  800845:	74 04                	je     80084b <strcmp+0x17>
  800847:	3a 02                	cmp    (%edx),%al
  800849:	74 f4                	je     80083f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80084b:	0f b6 c0             	movzbl %al,%eax
  80084e:	0f b6 12             	movzbl (%edx),%edx
  800851:	29 d0                	sub    %edx,%eax
}
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    

00800855 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085f:	89 c3                	mov    %eax,%ebx
  800861:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800864:	eb 02                	jmp    800868 <strncmp+0x13>
		n--, p++, q++;
  800866:	40                   	inc    %eax
  800867:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800868:	39 d8                	cmp    %ebx,%eax
  80086a:	74 15                	je     800881 <strncmp+0x2c>
  80086c:	8a 08                	mov    (%eax),%cl
  80086e:	84 c9                	test   %cl,%cl
  800870:	74 04                	je     800876 <strncmp+0x21>
  800872:	3a 0a                	cmp    (%edx),%cl
  800874:	74 f0                	je     800866 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800876:	0f b6 00             	movzbl (%eax),%eax
  800879:	0f b6 12             	movzbl (%edx),%edx
  80087c:	29 d0                	sub    %edx,%eax
}
  80087e:	5b                   	pop    %ebx
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    
		return 0;
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
  800886:	eb f6                	jmp    80087e <strncmp+0x29>

00800888 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800891:	8a 10                	mov    (%eax),%dl
  800893:	84 d2                	test   %dl,%dl
  800895:	74 07                	je     80089e <strchr+0x16>
		if (*s == c)
  800897:	38 ca                	cmp    %cl,%dl
  800899:	74 08                	je     8008a3 <strchr+0x1b>
	for (; *s; s++)
  80089b:	40                   	inc    %eax
  80089c:	eb f3                	jmp    800891 <strchr+0x9>
			return (char *) s;
	return 0;
  80089e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008ae:	8a 10                	mov    (%eax),%dl
  8008b0:	84 d2                	test   %dl,%dl
  8008b2:	74 07                	je     8008bb <strfind+0x16>
		if (*s == c)
  8008b4:	38 ca                	cmp    %cl,%dl
  8008b6:	74 03                	je     8008bb <strfind+0x16>
	for (; *s; s++)
  8008b8:	40                   	inc    %eax
  8008b9:	eb f3                	jmp    8008ae <strfind+0x9>
			break;
	return (char *) s;
}
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	57                   	push   %edi
  8008c1:	56                   	push   %esi
  8008c2:	53                   	push   %ebx
  8008c3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008c9:	85 c9                	test   %ecx,%ecx
  8008cb:	74 13                	je     8008e0 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008cd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008d3:	75 05                	jne    8008da <memset+0x1d>
  8008d5:	f6 c1 03             	test   $0x3,%cl
  8008d8:	74 0d                	je     8008e7 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dd:	fc                   	cld    
  8008de:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008e0:	89 f8                	mov    %edi,%eax
  8008e2:	5b                   	pop    %ebx
  8008e3:	5e                   	pop    %esi
  8008e4:	5f                   	pop    %edi
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    
		c &= 0xFF;
  8008e7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008eb:	89 d3                	mov    %edx,%ebx
  8008ed:	c1 e3 08             	shl    $0x8,%ebx
  8008f0:	89 d0                	mov    %edx,%eax
  8008f2:	c1 e0 18             	shl    $0x18,%eax
  8008f5:	89 d6                	mov    %edx,%esi
  8008f7:	c1 e6 10             	shl    $0x10,%esi
  8008fa:	09 f0                	or     %esi,%eax
  8008fc:	09 c2                	or     %eax,%edx
  8008fe:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800900:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800903:	89 d0                	mov    %edx,%eax
  800905:	fc                   	cld    
  800906:	f3 ab                	rep stos %eax,%es:(%edi)
  800908:	eb d6                	jmp    8008e0 <memset+0x23>

0080090a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	57                   	push   %edi
  80090e:	56                   	push   %esi
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 75 0c             	mov    0xc(%ebp),%esi
  800915:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800918:	39 c6                	cmp    %eax,%esi
  80091a:	73 33                	jae    80094f <memmove+0x45>
  80091c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80091f:	39 d0                	cmp    %edx,%eax
  800921:	73 2c                	jae    80094f <memmove+0x45>
		s += n;
		d += n;
  800923:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800926:	89 d6                	mov    %edx,%esi
  800928:	09 fe                	or     %edi,%esi
  80092a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800930:	75 13                	jne    800945 <memmove+0x3b>
  800932:	f6 c1 03             	test   $0x3,%cl
  800935:	75 0e                	jne    800945 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800937:	83 ef 04             	sub    $0x4,%edi
  80093a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80093d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800940:	fd                   	std    
  800941:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800943:	eb 07                	jmp    80094c <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800945:	4f                   	dec    %edi
  800946:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800949:	fd                   	std    
  80094a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80094c:	fc                   	cld    
  80094d:	eb 13                	jmp    800962 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80094f:	89 f2                	mov    %esi,%edx
  800951:	09 c2                	or     %eax,%edx
  800953:	f6 c2 03             	test   $0x3,%dl
  800956:	75 05                	jne    80095d <memmove+0x53>
  800958:	f6 c1 03             	test   $0x3,%cl
  80095b:	74 09                	je     800966 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80095d:	89 c7                	mov    %eax,%edi
  80095f:	fc                   	cld    
  800960:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800962:	5e                   	pop    %esi
  800963:	5f                   	pop    %edi
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800966:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800969:	89 c7                	mov    %eax,%edi
  80096b:	fc                   	cld    
  80096c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096e:	eb f2                	jmp    800962 <memmove+0x58>

00800970 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800973:	ff 75 10             	pushl  0x10(%ebp)
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	ff 75 08             	pushl  0x8(%ebp)
  80097c:	e8 89 ff ff ff       	call   80090a <memmove>
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	56                   	push   %esi
  800987:	53                   	push   %ebx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 c6                	mov    %eax,%esi
  80098d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800990:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800993:	39 f0                	cmp    %esi,%eax
  800995:	74 16                	je     8009ad <memcmp+0x2a>
		if (*s1 != *s2)
  800997:	8a 08                	mov    (%eax),%cl
  800999:	8a 1a                	mov    (%edx),%bl
  80099b:	38 d9                	cmp    %bl,%cl
  80099d:	75 04                	jne    8009a3 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80099f:	40                   	inc    %eax
  8009a0:	42                   	inc    %edx
  8009a1:	eb f0                	jmp    800993 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009a3:	0f b6 c1             	movzbl %cl,%eax
  8009a6:	0f b6 db             	movzbl %bl,%ebx
  8009a9:	29 d8                	sub    %ebx,%eax
  8009ab:	eb 05                	jmp    8009b2 <memcmp+0x2f>
	}

	return 0;
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009bf:	89 c2                	mov    %eax,%edx
  8009c1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009c4:	39 d0                	cmp    %edx,%eax
  8009c6:	73 07                	jae    8009cf <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009c8:	38 08                	cmp    %cl,(%eax)
  8009ca:	74 03                	je     8009cf <memfind+0x19>
	for (; s < ends; s++)
  8009cc:	40                   	inc    %eax
  8009cd:	eb f5                	jmp    8009c4 <memfind+0xe>
			break;
	return (void *) s;
}
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	57                   	push   %edi
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009da:	eb 01                	jmp    8009dd <strtol+0xc>
		s++;
  8009dc:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8009dd:	8a 01                	mov    (%ecx),%al
  8009df:	3c 20                	cmp    $0x20,%al
  8009e1:	74 f9                	je     8009dc <strtol+0xb>
  8009e3:	3c 09                	cmp    $0x9,%al
  8009e5:	74 f5                	je     8009dc <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8009e7:	3c 2b                	cmp    $0x2b,%al
  8009e9:	74 2b                	je     800a16 <strtol+0x45>
		s++;
	else if (*s == '-')
  8009eb:	3c 2d                	cmp    $0x2d,%al
  8009ed:	74 2f                	je     800a1e <strtol+0x4d>
	int neg = 0;
  8009ef:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009f4:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8009fb:	75 12                	jne    800a0f <strtol+0x3e>
  8009fd:	80 39 30             	cmpb   $0x30,(%ecx)
  800a00:	74 24                	je     800a26 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a06:	75 07                	jne    800a0f <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a08:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a14:	eb 4e                	jmp    800a64 <strtol+0x93>
		s++;
  800a16:	41                   	inc    %ecx
	int neg = 0;
  800a17:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1c:	eb d6                	jmp    8009f4 <strtol+0x23>
		s++, neg = 1;
  800a1e:	41                   	inc    %ecx
  800a1f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a24:	eb ce                	jmp    8009f4 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a26:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a2a:	74 10                	je     800a3c <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a30:	75 dd                	jne    800a0f <strtol+0x3e>
		s++, base = 8;
  800a32:	41                   	inc    %ecx
  800a33:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a3a:	eb d3                	jmp    800a0f <strtol+0x3e>
		s += 2, base = 16;
  800a3c:	83 c1 02             	add    $0x2,%ecx
  800a3f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a46:	eb c7                	jmp    800a0f <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a48:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a4b:	89 f3                	mov    %esi,%ebx
  800a4d:	80 fb 19             	cmp    $0x19,%bl
  800a50:	77 24                	ja     800a76 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a52:	0f be d2             	movsbl %dl,%edx
  800a55:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a58:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a5b:	7d 2b                	jge    800a88 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a5d:	41                   	inc    %ecx
  800a5e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a62:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a64:	8a 11                	mov    (%ecx),%dl
  800a66:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a69:	80 fb 09             	cmp    $0x9,%bl
  800a6c:	77 da                	ja     800a48 <strtol+0x77>
			dig = *s - '0';
  800a6e:	0f be d2             	movsbl %dl,%edx
  800a71:	83 ea 30             	sub    $0x30,%edx
  800a74:	eb e2                	jmp    800a58 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a76:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a79:	89 f3                	mov    %esi,%ebx
  800a7b:	80 fb 19             	cmp    $0x19,%bl
  800a7e:	77 08                	ja     800a88 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800a80:	0f be d2             	movsbl %dl,%edx
  800a83:	83 ea 37             	sub    $0x37,%edx
  800a86:	eb d0                	jmp    800a58 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8c:	74 05                	je     800a93 <strtol+0xc2>
		*endptr = (char *) s;
  800a8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a91:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a93:	85 ff                	test   %edi,%edi
  800a95:	74 02                	je     800a99 <strtol+0xc8>
  800a97:	f7 d8                	neg    %eax
}
  800a99:	5b                   	pop    %ebx
  800a9a:	5e                   	pop    %esi
  800a9b:	5f                   	pop    %edi
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <atoi>:

int
atoi(const char *s)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800aa1:	6a 0a                	push   $0xa
  800aa3:	6a 00                	push   $0x0
  800aa5:	ff 75 08             	pushl  0x8(%ebp)
  800aa8:	e8 24 ff ff ff       	call   8009d1 <strtol>
}
  800aad:	c9                   	leave  
  800aae:	c3                   	ret    

00800aaf <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800abd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac0:	89 c3                	mov    %eax,%ebx
  800ac2:	89 c7                	mov    %eax,%edi
  800ac4:	89 c6                	mov    %eax,%esi
  800ac6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ac8:	5b                   	pop    %ebx
  800ac9:	5e                   	pop    %esi
  800aca:	5f                   	pop    %edi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <sys_cgetc>:

int
sys_cgetc(void)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	57                   	push   %edi
  800ad1:	56                   	push   %esi
  800ad2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad8:	b8 01 00 00 00       	mov    $0x1,%eax
  800add:	89 d1                	mov    %edx,%ecx
  800adf:	89 d3                	mov    %edx,%ebx
  800ae1:	89 d7                	mov    %edx,%edi
  800ae3:	89 d6                	mov    %edx,%esi
  800ae5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ae7:	5b                   	pop    %ebx
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800af5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afa:	b8 03 00 00 00       	mov    $0x3,%eax
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	89 cb                	mov    %ecx,%ebx
  800b04:	89 cf                	mov    %ecx,%edi
  800b06:	89 ce                	mov    %ecx,%esi
  800b08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b0a:	85 c0                	test   %eax,%eax
  800b0c:	7f 08                	jg     800b16 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b16:	83 ec 0c             	sub    $0xc,%esp
  800b19:	50                   	push   %eax
  800b1a:	6a 03                	push   $0x3
  800b1c:	68 3f 24 80 00       	push   $0x80243f
  800b21:	6a 23                	push   $0x23
  800b23:	68 5c 24 80 00       	push   $0x80245c
  800b28:	e8 a3 11 00 00       	call   801cd0 <_panic>

00800b2d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	57                   	push   %edi
  800b31:	56                   	push   %esi
  800b32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b33:	ba 00 00 00 00       	mov    $0x0,%edx
  800b38:	b8 02 00 00 00       	mov    $0x2,%eax
  800b3d:	89 d1                	mov    %edx,%ecx
  800b3f:	89 d3                	mov    %edx,%ebx
  800b41:	89 d7                	mov    %edx,%edi
  800b43:	89 d6                	mov    %edx,%esi
  800b45:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
  800b52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b55:	be 00 00 00 00       	mov    $0x0,%esi
  800b5a:	b8 04 00 00 00       	mov    $0x4,%eax
  800b5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b68:	89 f7                	mov    %esi,%edi
  800b6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b6c:	85 c0                	test   %eax,%eax
  800b6e:	7f 08                	jg     800b78 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5f                   	pop    %edi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b78:	83 ec 0c             	sub    $0xc,%esp
  800b7b:	50                   	push   %eax
  800b7c:	6a 04                	push   $0x4
  800b7e:	68 3f 24 80 00       	push   $0x80243f
  800b83:	6a 23                	push   $0x23
  800b85:	68 5c 24 80 00       	push   $0x80245c
  800b8a:	e8 41 11 00 00       	call   801cd0 <_panic>

00800b8f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b98:	b8 05 00 00 00       	mov    $0x5,%eax
  800b9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ba6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ba9:	8b 75 18             	mov    0x18(%ebp),%esi
  800bac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bae:	85 c0                	test   %eax,%eax
  800bb0:	7f 08                	jg     800bba <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5f                   	pop    %edi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bba:	83 ec 0c             	sub    $0xc,%esp
  800bbd:	50                   	push   %eax
  800bbe:	6a 05                	push   $0x5
  800bc0:	68 3f 24 80 00       	push   $0x80243f
  800bc5:	6a 23                	push   $0x23
  800bc7:	68 5c 24 80 00       	push   $0x80245c
  800bcc:	e8 ff 10 00 00       	call   801cd0 <_panic>

00800bd1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bdf:	b8 06 00 00 00       	mov    $0x6,%eax
  800be4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bea:	89 df                	mov    %ebx,%edi
  800bec:	89 de                	mov    %ebx,%esi
  800bee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf0:	85 c0                	test   %eax,%eax
  800bf2:	7f 08                	jg     800bfc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf7:	5b                   	pop    %ebx
  800bf8:	5e                   	pop    %esi
  800bf9:	5f                   	pop    %edi
  800bfa:	5d                   	pop    %ebp
  800bfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfc:	83 ec 0c             	sub    $0xc,%esp
  800bff:	50                   	push   %eax
  800c00:	6a 06                	push   $0x6
  800c02:	68 3f 24 80 00       	push   $0x80243f
  800c07:	6a 23                	push   $0x23
  800c09:	68 5c 24 80 00       	push   $0x80245c
  800c0e:	e8 bd 10 00 00       	call   801cd0 <_panic>

00800c13 <sys_yield>:

void
sys_yield(void)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c19:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c23:	89 d1                	mov    %edx,%ecx
  800c25:	89 d3                	mov    %edx,%ebx
  800c27:	89 d7                	mov    %edx,%edi
  800c29:	89 d6                	mov    %edx,%esi
  800c2b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c40:	b8 08 00 00 00       	mov    $0x8,%eax
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4b:	89 df                	mov    %ebx,%edi
  800c4d:	89 de                	mov    %ebx,%esi
  800c4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c51:	85 c0                	test   %eax,%eax
  800c53:	7f 08                	jg     800c5d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5f                   	pop    %edi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5d:	83 ec 0c             	sub    $0xc,%esp
  800c60:	50                   	push   %eax
  800c61:	6a 08                	push   $0x8
  800c63:	68 3f 24 80 00       	push   $0x80243f
  800c68:	6a 23                	push   $0x23
  800c6a:	68 5c 24 80 00       	push   $0x80245c
  800c6f:	e8 5c 10 00 00       	call   801cd0 <_panic>

00800c74 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
  800c7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c82:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c87:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8a:	89 cb                	mov    %ecx,%ebx
  800c8c:	89 cf                	mov    %ecx,%edi
  800c8e:	89 ce                	mov    %ecx,%esi
  800c90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c92:	85 c0                	test   %eax,%eax
  800c94:	7f 08                	jg     800c9e <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9e:	83 ec 0c             	sub    $0xc,%esp
  800ca1:	50                   	push   %eax
  800ca2:	6a 0c                	push   $0xc
  800ca4:	68 3f 24 80 00       	push   $0x80243f
  800ca9:	6a 23                	push   $0x23
  800cab:	68 5c 24 80 00       	push   $0x80245c
  800cb0:	e8 1b 10 00 00       	call   801cd0 <_panic>

00800cb5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc3:	b8 09 00 00 00       	mov    $0x9,%eax
  800cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	89 df                	mov    %ebx,%edi
  800cd0:	89 de                	mov    %ebx,%esi
  800cd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	7f 08                	jg     800ce0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce0:	83 ec 0c             	sub    $0xc,%esp
  800ce3:	50                   	push   %eax
  800ce4:	6a 09                	push   $0x9
  800ce6:	68 3f 24 80 00       	push   $0x80243f
  800ceb:	6a 23                	push   $0x23
  800ced:	68 5c 24 80 00       	push   $0x80245c
  800cf2:	e8 d9 0f 00 00       	call   801cd0 <_panic>

00800cf7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d05:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d10:	89 df                	mov    %ebx,%edi
  800d12:	89 de                	mov    %ebx,%esi
  800d14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d16:	85 c0                	test   %eax,%eax
  800d18:	7f 08                	jg     800d22 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d22:	83 ec 0c             	sub    $0xc,%esp
  800d25:	50                   	push   %eax
  800d26:	6a 0a                	push   $0xa
  800d28:	68 3f 24 80 00       	push   $0x80243f
  800d2d:	6a 23                	push   $0x23
  800d2f:	68 5c 24 80 00       	push   $0x80245c
  800d34:	e8 97 0f 00 00       	call   801cd0 <_panic>

00800d39 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3f:	be 00 00 00 00       	mov    $0x0,%esi
  800d44:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d52:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d55:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d6a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	89 cb                	mov    %ecx,%ebx
  800d74:	89 cf                	mov    %ecx,%edi
  800d76:	89 ce                	mov    %ecx,%esi
  800d78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7f 08                	jg     800d86 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	6a 0e                	push   $0xe
  800d8c:	68 3f 24 80 00       	push   $0x80243f
  800d91:	6a 23                	push   $0x23
  800d93:	68 5c 24 80 00       	push   $0x80245c
  800d98:	e8 33 0f 00 00       	call   801cd0 <_panic>

00800d9d <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da3:	be 00 00 00 00       	mov    $0x0,%esi
  800da8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800dad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db6:	89 f7                	mov    %esi,%edi
  800db8:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc5:	be 00 00 00 00       	mov    $0x0,%esi
  800dca:	b8 10 00 00 00       	mov    $0x10,%eax
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd8:	89 f7                	mov    %esi,%edi
  800dda:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	57                   	push   %edi
  800de5:	56                   	push   %esi
  800de6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dec:	b8 11 00 00 00       	mov    $0x11,%eax
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	89 cb                	mov    %ecx,%ebx
  800df6:	89 cf                	mov    %ecx,%edi
  800df8:	89 ce                	mov    %ecx,%esi
  800dfa:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800dfc:	5b                   	pop    %ebx
  800dfd:	5e                   	pop    %esi
  800dfe:	5f                   	pop    %edi
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <uptime>:
#include <inc/lib.h>

nanoseconds_t
uptime(void)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 44             	sub    $0x44,%esp
	struct sysinfo info;

	sys_sysinfo(&info);
  800e07:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800e0a:	50                   	push   %eax
  800e0b:	e8 64 fe ff ff       	call   800c74 <sys_sysinfo>
	return info.uptime;
}
  800e10:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800e13:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    

00800e18 <nanosleep>:

void
nanosleep(nanoseconds_t nanoseconds)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	57                   	push   %edi
  800e1c:	56                   	push   %esi
  800e1d:	8b 75 08             	mov    0x8(%ebp),%esi
  800e20:	8b 7d 0c             	mov    0xc(%ebp),%edi
	nanoseconds_t now, end;

	now = uptime();
  800e23:	e8 d9 ff ff ff       	call   800e01 <uptime>
	end = now + nanoseconds;
  800e28:	01 c6                	add    %eax,%esi
  800e2a:	11 d7                	adc    %edx,%edi
	if (end < now)
  800e2c:	39 fa                	cmp    %edi,%edx
  800e2e:	72 1f                	jb     800e4f <nanosleep+0x37>
  800e30:	77 04                	ja     800e36 <nanosleep+0x1e>
  800e32:	39 f0                	cmp    %esi,%eax
  800e34:	76 19                	jbe    800e4f <nanosleep+0x37>
		panic("nanosleep: wrap");
  800e36:	83 ec 04             	sub    $0x4,%esp
  800e39:	68 6a 24 80 00       	push   $0x80246a
  800e3e:	6a 14                	push   $0x14
  800e40:	68 7a 24 80 00       	push   $0x80247a
  800e45:	e8 86 0e 00 00       	call   801cd0 <_panic>

	while (uptime() < end)
		sys_yield();
  800e4a:	e8 c4 fd ff ff       	call   800c13 <sys_yield>
	while (uptime() < end)
  800e4f:	e8 ad ff ff ff       	call   800e01 <uptime>
  800e54:	39 d7                	cmp    %edx,%edi
  800e56:	77 f2                	ja     800e4a <nanosleep+0x32>
  800e58:	72 04                	jb     800e5e <nanosleep+0x46>
  800e5a:	39 c6                	cmp    %eax,%esi
  800e5c:	77 ec                	ja     800e4a <nanosleep+0x32>
}
  800e5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <sleep>:

void
sleep(seconds_t seconds)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	nanosleep(seconds * NANOSECONDS_PER_SECOND);
  800e6a:	83 ec 08             	sub    $0x8,%esp
  800e6d:	69 75 0c 00 ca 9a 3b 	imul   $0x3b9aca00,0xc(%ebp),%esi
  800e74:	b9 00 ca 9a 3b       	mov    $0x3b9aca00,%ecx
  800e79:	89 c8                	mov    %ecx,%eax
  800e7b:	f7 65 08             	mull   0x8(%ebp)
  800e7e:	89 d3                	mov    %edx,%ebx
  800e80:	01 f3                	add    %esi,%ebx
  800e82:	53                   	push   %ebx
  800e83:	50                   	push   %eax
  800e84:	e8 8f ff ff ff       	call   800e18 <nanosleep>
}
  800e89:	83 c4 10             	add    $0x10,%esp
  800e8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e8f:	5b                   	pop    %ebx
  800e90:	5e                   	pop    %esi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <epoch_to_tm>:
	return days[month];
}

// ignore leap seconds
void epoch_to_tm(seconds_t epoch, struct tm *tm)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 4c             	sub    $0x4c,%esp
  800e9c:	8b 75 08             	mov    0x8(%ebp),%esi
  800e9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int year, month, days, dsec;

	days = epoch / 86400;
  800ea2:	6a 00                	push   $0x0
  800ea4:	68 80 51 01 00       	push   $0x15180
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	e8 0c 10 00 00       	call   801ebc <__udivdi3>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 c3                	mov    %eax,%ebx
	dsec = epoch % 86400;
  800eb5:	6a 00                	push   $0x0
  800eb7:	68 80 51 01 00       	push   $0x15180
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	e8 09 11 00 00       	call   801fcc <__umoddi3>
  800ec3:	83 c4 10             	add    $0x10,%esp
  800ec6:	89 c1                	mov    %eax,%ecx

	tm->tm_sec = dsec % 60;
  800ec8:	be 3c 00 00 00       	mov    $0x3c,%esi
  800ecd:	99                   	cltd   
  800ece:	f7 fe                	idiv   %esi
  800ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed3:	89 10                	mov    %edx,(%eax)
	tm->tm_min = (dsec % 3600) / 60;
  800ed5:	bf 10 0e 00 00       	mov    $0xe10,%edi
  800eda:	89 c8                	mov    %ecx,%eax
  800edc:	99                   	cltd   
  800edd:	f7 ff                	idiv   %edi
  800edf:	89 c1                	mov    %eax,%ecx
  800ee1:	89 d0                	mov    %edx,%eax
  800ee3:	99                   	cltd   
  800ee4:	f7 fe                	idiv   %esi
  800ee6:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ee9:	89 47 04             	mov    %eax,0x4(%edi)
	tm->tm_hour = dsec / 3600;
  800eec:	89 4f 08             	mov    %ecx,0x8(%edi)
	tm->tm_wday = (days + 4) % 7;
  800eef:	8d 43 04             	lea    0x4(%ebx),%eax
  800ef2:	b9 07 00 00 00       	mov    $0x7,%ecx
  800ef7:	99                   	cltd   
  800ef8:	f7 f9                	idiv   %ecx
  800efa:	89 57 18             	mov    %edx,0x18(%edi)

	for (year = 1970; days >= days_per_year(year); ++year)
  800efd:	b9 b2 07 00 00       	mov    $0x7b2,%ecx
	return (year % 4 == 0) && !((year % 100 == 0) && (year % 400 != 0));
  800f02:	be 64 00 00 00       	mov    $0x64,%esi
  800f07:	bf 90 01 00 00       	mov    $0x190,%edi
	for (year = 1970; days >= days_per_year(year); ++year)
  800f0c:	eb 0c                	jmp    800f1a <epoch_to_tm+0x87>
	return isleap(year) ? 366 : 365;
  800f0e:	b8 6d 01 00 00       	mov    $0x16d,%eax
	for (year = 1970; days >= days_per_year(year); ++year)
  800f13:	39 c3                	cmp    %eax,%ebx
  800f15:	7c 31                	jl     800f48 <epoch_to_tm+0xb5>
		days -= days_per_year(year);
  800f17:	29 c3                	sub    %eax,%ebx
	for (year = 1970; days >= days_per_year(year); ++year)
  800f19:	41                   	inc    %ecx
	return (year % 4 == 0) && !((year % 100 == 0) && (year % 400 != 0));
  800f1a:	89 c8                	mov    %ecx,%eax
  800f1c:	83 e0 03             	and    $0x3,%eax
  800f1f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800f22:	75 ea                	jne    800f0e <epoch_to_tm+0x7b>
  800f24:	89 c8                	mov    %ecx,%eax
  800f26:	99                   	cltd   
  800f27:	f7 fe                	idiv   %esi
  800f29:	85 d2                	test   %edx,%edx
  800f2b:	75 14                	jne    800f41 <epoch_to_tm+0xae>
  800f2d:	89 c8                	mov    %ecx,%eax
  800f2f:	99                   	cltd   
  800f30:	f7 ff                	idiv   %edi
	return isleap(year) ? 366 : 365;
  800f32:	85 d2                	test   %edx,%edx
  800f34:	0f 94 c0             	sete   %al
  800f37:	0f b6 c0             	movzbl %al,%eax
  800f3a:	05 6d 01 00 00       	add    $0x16d,%eax
  800f3f:	eb d2                	jmp    800f13 <epoch_to_tm+0x80>
  800f41:	b8 6e 01 00 00       	mov    $0x16e,%eax
  800f46:	eb cb                	jmp    800f13 <epoch_to_tm+0x80>
	tm->tm_year = year - 1900;
  800f48:	8d 81 94 f8 ff ff    	lea    -0x76c(%ecx),%eax
  800f4e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f51:	89 42 14             	mov    %eax,0x14(%edx)
	tm->tm_yday = days;
  800f54:	89 5a 1c             	mov    %ebx,0x1c(%edx)
	return (year % 4 == 0) && !((year % 100 == 0) && (year % 400 != 0));
  800f57:	be 64 00 00 00       	mov    $0x64,%esi
  800f5c:	89 c8                	mov    %ecx,%eax
  800f5e:	99                   	cltd   
  800f5f:	f7 fe                	idiv   %esi
  800f61:	89 55 b0             	mov    %edx,-0x50(%ebp)
  800f64:	be 90 01 00 00       	mov    $0x190,%esi
  800f69:	89 c8                	mov    %ecx,%eax
  800f6b:	99                   	cltd   
  800f6c:	f7 fe                	idiv   %esi

	for (month = 0; days >= days_per_month(year, month); ++month)
  800f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f73:	89 55 ac             	mov    %edx,-0x54(%ebp)
  800f76:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  800f79:	eb 29                	jmp    800fa4 <epoch_to_tm+0x111>
		return 29;
  800f7b:	b9 1d 00 00 00       	mov    $0x1d,%ecx
  800f80:	eb 1b                	jmp    800f9d <epoch_to_tm+0x10a>
		days -= days_per_month(year, month);
	tm->tm_mon = month;
  800f82:	8b 7d 10             	mov    0x10(%ebp),%edi
  800f85:	89 47 10             	mov    %eax,0x10(%edi)
	tm->tm_mday = days + 1;
  800f88:	43                   	inc    %ebx
  800f89:	89 5f 0c             	mov    %ebx,0xc(%edi)
}
  800f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    
	if (isleap(year) && month == 1)
  800f94:	83 f8 01             	cmp    $0x1,%eax
  800f97:	74 e2                	je     800f7b <epoch_to_tm+0xe8>
	return days[month];
  800f99:	8b 4c 85 b8          	mov    -0x48(%ebp,%eax,4),%ecx
	for (month = 0; days >= days_per_month(year, month); ++month)
  800f9d:	39 cb                	cmp    %ecx,%ebx
  800f9f:	7c e1                	jl     800f82 <epoch_to_tm+0xef>
		days -= days_per_month(year, month);
  800fa1:	29 cb                	sub    %ecx,%ebx
	for (month = 0; days >= days_per_month(year, month); ++month)
  800fa3:	40                   	inc    %eax
	int days[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
  800fa4:	8d 7d b8             	lea    -0x48(%ebp),%edi
  800fa7:	be a0 24 80 00       	mov    $0x8024a0,%esi
  800fac:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800fb1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	return (year % 4 == 0) && !((year % 100 == 0) && (year % 400 != 0));
  800fb3:	85 d2                	test   %edx,%edx
  800fb5:	75 e2                	jne    800f99 <epoch_to_tm+0x106>
  800fb7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  800fbb:	75 d7                	jne    800f94 <epoch_to_tm+0x101>
  800fbd:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  800fc1:	75 d6                	jne    800f99 <epoch_to_tm+0x106>
  800fc3:	eb cf                	jmp    800f94 <epoch_to_tm+0x101>

00800fc5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	05 00 00 00 30       	add    $0x30000000,%eax
  800fd0:	c1 e8 0c             	shr    $0xc,%eax
}
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fe0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ff7:	89 c2                	mov    %eax,%edx
  800ff9:	c1 ea 16             	shr    $0x16,%edx
  800ffc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801003:	f6 c2 01             	test   $0x1,%dl
  801006:	74 2a                	je     801032 <fd_alloc+0x46>
  801008:	89 c2                	mov    %eax,%edx
  80100a:	c1 ea 0c             	shr    $0xc,%edx
  80100d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801014:	f6 c2 01             	test   $0x1,%dl
  801017:	74 19                	je     801032 <fd_alloc+0x46>
  801019:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80101e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801023:	75 d2                	jne    800ff7 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801025:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80102b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801030:	eb 07                	jmp    801039 <fd_alloc+0x4d>
			*fd_store = fd;
  801032:	89 01                	mov    %eax,(%ecx)
			return 0;
  801034:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80103e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801042:	77 39                	ja     80107d <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	c1 e0 0c             	shl    $0xc,%eax
  80104a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80104f:	89 c2                	mov    %eax,%edx
  801051:	c1 ea 16             	shr    $0x16,%edx
  801054:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80105b:	f6 c2 01             	test   $0x1,%dl
  80105e:	74 24                	je     801084 <fd_lookup+0x49>
  801060:	89 c2                	mov    %eax,%edx
  801062:	c1 ea 0c             	shr    $0xc,%edx
  801065:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80106c:	f6 c2 01             	test   $0x1,%dl
  80106f:	74 1a                	je     80108b <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801071:	8b 55 0c             	mov    0xc(%ebp),%edx
  801074:	89 02                	mov    %eax,(%edx)
	return 0;
  801076:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    
		return -E_INVAL;
  80107d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801082:	eb f7                	jmp    80107b <fd_lookup+0x40>
		return -E_INVAL;
  801084:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801089:	eb f0                	jmp    80107b <fd_lookup+0x40>
  80108b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801090:	eb e9                	jmp    80107b <fd_lookup+0x40>

00801092 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 08             	sub    $0x8,%esp
  801098:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109b:	ba 4c 25 80 00       	mov    $0x80254c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8010a0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010a5:	39 08                	cmp    %ecx,(%eax)
  8010a7:	74 33                	je     8010dc <dev_lookup+0x4a>
  8010a9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010ac:	8b 02                	mov    (%edx),%eax
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	75 f3                	jne    8010a5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8010b7:	8b 40 48             	mov    0x48(%eax),%eax
  8010ba:	83 ec 04             	sub    $0x4,%esp
  8010bd:	51                   	push   %ecx
  8010be:	50                   	push   %eax
  8010bf:	68 d0 24 80 00       	push   $0x8024d0
  8010c4:	e8 c6 f0 ff ff       	call   80018f <cprintf>
	*dev = 0;
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010d2:	83 c4 10             	add    $0x10,%esp
  8010d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    
			*dev = devtab[i];
  8010dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010df:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e6:	eb f2                	jmp    8010da <dev_lookup+0x48>

008010e8 <fd_close>:
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	57                   	push   %edi
  8010ec:	56                   	push   %esi
  8010ed:	53                   	push   %ebx
  8010ee:	83 ec 1c             	sub    $0x1c,%esp
  8010f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010fa:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801101:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801104:	50                   	push   %eax
  801105:	e8 31 ff ff ff       	call   80103b <fd_lookup>
  80110a:	89 c7                	mov    %eax,%edi
  80110c:	83 c4 08             	add    $0x8,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 05                	js     801118 <fd_close+0x30>
	    || fd != fd2)
  801113:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801116:	74 13                	je     80112b <fd_close+0x43>
		return (must_exist ? r : 0);
  801118:	84 db                	test   %bl,%bl
  80111a:	75 05                	jne    801121 <fd_close+0x39>
  80111c:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801121:	89 f8                	mov    %edi,%eax
  801123:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801126:	5b                   	pop    %ebx
  801127:	5e                   	pop    %esi
  801128:	5f                   	pop    %edi
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801131:	50                   	push   %eax
  801132:	ff 36                	pushl  (%esi)
  801134:	e8 59 ff ff ff       	call   801092 <dev_lookup>
  801139:	89 c7                	mov    %eax,%edi
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	85 c0                	test   %eax,%eax
  801140:	78 15                	js     801157 <fd_close+0x6f>
		if (dev->dev_close)
  801142:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801145:	8b 40 10             	mov    0x10(%eax),%eax
  801148:	85 c0                	test   %eax,%eax
  80114a:	74 1b                	je     801167 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80114c:	83 ec 0c             	sub    $0xc,%esp
  80114f:	56                   	push   %esi
  801150:	ff d0                	call   *%eax
  801152:	89 c7                	mov    %eax,%edi
  801154:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801157:	83 ec 08             	sub    $0x8,%esp
  80115a:	56                   	push   %esi
  80115b:	6a 00                	push   $0x0
  80115d:	e8 6f fa ff ff       	call   800bd1 <sys_page_unmap>
	return r;
  801162:	83 c4 10             	add    $0x10,%esp
  801165:	eb ba                	jmp    801121 <fd_close+0x39>
			r = 0;
  801167:	bf 00 00 00 00       	mov    $0x0,%edi
  80116c:	eb e9                	jmp    801157 <fd_close+0x6f>

0080116e <close>:

int
close(int fdnum)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801174:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801177:	50                   	push   %eax
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 bb fe ff ff       	call   80103b <fd_lookup>
  801180:	83 c4 08             	add    $0x8,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	78 10                	js     801197 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801187:	83 ec 08             	sub    $0x8,%esp
  80118a:	6a 01                	push   $0x1
  80118c:	ff 75 f4             	pushl  -0xc(%ebp)
  80118f:	e8 54 ff ff ff       	call   8010e8 <fd_close>
  801194:	83 c4 10             	add    $0x10,%esp
}
  801197:	c9                   	leave  
  801198:	c3                   	ret    

00801199 <close_all>:

void
close_all(void)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	53                   	push   %ebx
  80119d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011a5:	83 ec 0c             	sub    $0xc,%esp
  8011a8:	53                   	push   %ebx
  8011a9:	e8 c0 ff ff ff       	call   80116e <close>
	for (i = 0; i < MAXFD; i++)
  8011ae:	43                   	inc    %ebx
  8011af:	83 c4 10             	add    $0x10,%esp
  8011b2:	83 fb 20             	cmp    $0x20,%ebx
  8011b5:	75 ee                	jne    8011a5 <close_all+0xc>
}
  8011b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	57                   	push   %edi
  8011c0:	56                   	push   %esi
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	ff 75 08             	pushl  0x8(%ebp)
  8011cc:	e8 6a fe ff ff       	call   80103b <fd_lookup>
  8011d1:	89 c3                	mov    %eax,%ebx
  8011d3:	83 c4 08             	add    $0x8,%esp
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 88 81 00 00 00    	js     80125f <dup+0xa3>
		return r;
	close(newfdnum);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 0c             	pushl  0xc(%ebp)
  8011e4:	e8 85 ff ff ff       	call   80116e <close>

	newfd = INDEX2FD(newfdnum);
  8011e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ec:	c1 e6 0c             	shl    $0xc,%esi
  8011ef:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011f5:	83 c4 04             	add    $0x4,%esp
  8011f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011fb:	e8 d5 fd ff ff       	call   800fd5 <fd2data>
  801200:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801202:	89 34 24             	mov    %esi,(%esp)
  801205:	e8 cb fd ff ff       	call   800fd5 <fd2data>
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80120f:	89 d8                	mov    %ebx,%eax
  801211:	c1 e8 16             	shr    $0x16,%eax
  801214:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80121b:	a8 01                	test   $0x1,%al
  80121d:	74 11                	je     801230 <dup+0x74>
  80121f:	89 d8                	mov    %ebx,%eax
  801221:	c1 e8 0c             	shr    $0xc,%eax
  801224:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80122b:	f6 c2 01             	test   $0x1,%dl
  80122e:	75 39                	jne    801269 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801230:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801233:	89 d0                	mov    %edx,%eax
  801235:	c1 e8 0c             	shr    $0xc,%eax
  801238:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	25 07 0e 00 00       	and    $0xe07,%eax
  801247:	50                   	push   %eax
  801248:	56                   	push   %esi
  801249:	6a 00                	push   $0x0
  80124b:	52                   	push   %edx
  80124c:	6a 00                	push   $0x0
  80124e:	e8 3c f9 ff ff       	call   800b8f <sys_page_map>
  801253:	89 c3                	mov    %eax,%ebx
  801255:	83 c4 20             	add    $0x20,%esp
  801258:	85 c0                	test   %eax,%eax
  80125a:	78 31                	js     80128d <dup+0xd1>
		goto err;

	return newfdnum;
  80125c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80125f:	89 d8                	mov    %ebx,%eax
  801261:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801264:	5b                   	pop    %ebx
  801265:	5e                   	pop    %esi
  801266:	5f                   	pop    %edi
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801269:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	25 07 0e 00 00       	and    $0xe07,%eax
  801278:	50                   	push   %eax
  801279:	57                   	push   %edi
  80127a:	6a 00                	push   $0x0
  80127c:	53                   	push   %ebx
  80127d:	6a 00                	push   $0x0
  80127f:	e8 0b f9 ff ff       	call   800b8f <sys_page_map>
  801284:	89 c3                	mov    %eax,%ebx
  801286:	83 c4 20             	add    $0x20,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	79 a3                	jns    801230 <dup+0x74>
	sys_page_unmap(0, newfd);
  80128d:	83 ec 08             	sub    $0x8,%esp
  801290:	56                   	push   %esi
  801291:	6a 00                	push   $0x0
  801293:	e8 39 f9 ff ff       	call   800bd1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801298:	83 c4 08             	add    $0x8,%esp
  80129b:	57                   	push   %edi
  80129c:	6a 00                	push   $0x0
  80129e:	e8 2e f9 ff ff       	call   800bd1 <sys_page_unmap>
	return r;
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	eb b7                	jmp    80125f <dup+0xa3>

008012a8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 14             	sub    $0x14,%esp
  8012af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b5:	50                   	push   %eax
  8012b6:	53                   	push   %ebx
  8012b7:	e8 7f fd ff ff       	call   80103b <fd_lookup>
  8012bc:	83 c4 08             	add    $0x8,%esp
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	78 3f                	js     801302 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c9:	50                   	push   %eax
  8012ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cd:	ff 30                	pushl  (%eax)
  8012cf:	e8 be fd ff ff       	call   801092 <dev_lookup>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 27                	js     801302 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012de:	8b 42 08             	mov    0x8(%edx),%eax
  8012e1:	83 e0 03             	and    $0x3,%eax
  8012e4:	83 f8 01             	cmp    $0x1,%eax
  8012e7:	74 1e                	je     801307 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ec:	8b 40 08             	mov    0x8(%eax),%eax
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	74 35                	je     801328 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012f3:	83 ec 04             	sub    $0x4,%esp
  8012f6:	ff 75 10             	pushl  0x10(%ebp)
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	52                   	push   %edx
  8012fd:	ff d0                	call   *%eax
  8012ff:	83 c4 10             	add    $0x10,%esp
}
  801302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801305:	c9                   	leave  
  801306:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801307:	a1 04 40 80 00       	mov    0x804004,%eax
  80130c:	8b 40 48             	mov    0x48(%eax),%eax
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	53                   	push   %ebx
  801313:	50                   	push   %eax
  801314:	68 11 25 80 00       	push   $0x802511
  801319:	e8 71 ee ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801326:	eb da                	jmp    801302 <read+0x5a>
		return -E_NOT_SUPP;
  801328:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80132d:	eb d3                	jmp    801302 <read+0x5a>

0080132f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	57                   	push   %edi
  801333:	56                   	push   %esi
  801334:	53                   	push   %ebx
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	8b 7d 08             	mov    0x8(%ebp),%edi
  80133b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80133e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801343:	39 f3                	cmp    %esi,%ebx
  801345:	73 25                	jae    80136c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	89 f0                	mov    %esi,%eax
  80134c:	29 d8                	sub    %ebx,%eax
  80134e:	50                   	push   %eax
  80134f:	89 d8                	mov    %ebx,%eax
  801351:	03 45 0c             	add    0xc(%ebp),%eax
  801354:	50                   	push   %eax
  801355:	57                   	push   %edi
  801356:	e8 4d ff ff ff       	call   8012a8 <read>
		if (m < 0)
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	85 c0                	test   %eax,%eax
  801360:	78 08                	js     80136a <readn+0x3b>
			return m;
		if (m == 0)
  801362:	85 c0                	test   %eax,%eax
  801364:	74 06                	je     80136c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801366:	01 c3                	add    %eax,%ebx
  801368:	eb d9                	jmp    801343 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80136a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80136c:	89 d8                	mov    %ebx,%eax
  80136e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801371:	5b                   	pop    %ebx
  801372:	5e                   	pop    %esi
  801373:	5f                   	pop    %edi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	53                   	push   %ebx
  80137a:	83 ec 14             	sub    $0x14,%esp
  80137d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801380:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801383:	50                   	push   %eax
  801384:	53                   	push   %ebx
  801385:	e8 b1 fc ff ff       	call   80103b <fd_lookup>
  80138a:	83 c4 08             	add    $0x8,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 3a                	js     8013cb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139b:	ff 30                	pushl  (%eax)
  80139d:	e8 f0 fc ff ff       	call   801092 <dev_lookup>
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 22                	js     8013cb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ac:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b0:	74 1e                	je     8013d0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b8:	85 d2                	test   %edx,%edx
  8013ba:	74 35                	je     8013f1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	ff 75 10             	pushl  0x10(%ebp)
  8013c2:	ff 75 0c             	pushl  0xc(%ebp)
  8013c5:	50                   	push   %eax
  8013c6:	ff d2                	call   *%edx
  8013c8:	83 c4 10             	add    $0x10,%esp
}
  8013cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013d0:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d5:	8b 40 48             	mov    0x48(%eax),%eax
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	53                   	push   %ebx
  8013dc:	50                   	push   %eax
  8013dd:	68 2d 25 80 00       	push   $0x80252d
  8013e2:	e8 a8 ed ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ef:	eb da                	jmp    8013cb <write+0x55>
		return -E_NOT_SUPP;
  8013f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f6:	eb d3                	jmp    8013cb <write+0x55>

008013f8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fe:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801401:	50                   	push   %eax
  801402:	ff 75 08             	pushl  0x8(%ebp)
  801405:	e8 31 fc ff ff       	call   80103b <fd_lookup>
  80140a:	83 c4 08             	add    $0x8,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 0e                	js     80141f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801411:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801414:	8b 55 0c             	mov    0xc(%ebp),%edx
  801417:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80141a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	53                   	push   %ebx
  801425:	83 ec 14             	sub    $0x14,%esp
  801428:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142e:	50                   	push   %eax
  80142f:	53                   	push   %ebx
  801430:	e8 06 fc ff ff       	call   80103b <fd_lookup>
  801435:	83 c4 08             	add    $0x8,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	78 37                	js     801473 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801446:	ff 30                	pushl  (%eax)
  801448:	e8 45 fc ff ff       	call   801092 <dev_lookup>
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	78 1f                	js     801473 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801457:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145b:	74 1b                	je     801478 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80145d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801460:	8b 52 18             	mov    0x18(%edx),%edx
  801463:	85 d2                	test   %edx,%edx
  801465:	74 32                	je     801499 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801467:	83 ec 08             	sub    $0x8,%esp
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	50                   	push   %eax
  80146e:	ff d2                	call   *%edx
  801470:	83 c4 10             	add    $0x10,%esp
}
  801473:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801476:	c9                   	leave  
  801477:	c3                   	ret    
			thisenv->env_id, fdnum);
  801478:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80147d:	8b 40 48             	mov    0x48(%eax),%eax
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	53                   	push   %ebx
  801484:	50                   	push   %eax
  801485:	68 f0 24 80 00       	push   $0x8024f0
  80148a:	e8 00 ed ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801497:	eb da                	jmp    801473 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801499:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80149e:	eb d3                	jmp    801473 <ftruncate+0x52>

008014a0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 14             	sub    $0x14,%esp
  8014a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	ff 75 08             	pushl  0x8(%ebp)
  8014b1:	e8 85 fb ff ff       	call   80103b <fd_lookup>
  8014b6:	83 c4 08             	add    $0x8,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 4b                	js     801508 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c3:	50                   	push   %eax
  8014c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c7:	ff 30                	pushl  (%eax)
  8014c9:	e8 c4 fb ff ff       	call   801092 <dev_lookup>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 33                	js     801508 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014dc:	74 2f                	je     80150d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014de:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014e1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014e8:	00 00 00 
	stat->st_type = 0;
  8014eb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014f2:	00 00 00 
	stat->st_dev = dev;
  8014f5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014fb:	83 ec 08             	sub    $0x8,%esp
  8014fe:	53                   	push   %ebx
  8014ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801502:	ff 50 14             	call   *0x14(%eax)
  801505:	83 c4 10             	add    $0x10,%esp
}
  801508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    
		return -E_NOT_SUPP;
  80150d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801512:	eb f4                	jmp    801508 <fstat+0x68>

00801514 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	6a 00                	push   $0x0
  80151e:	ff 75 08             	pushl  0x8(%ebp)
  801521:	e8 34 02 00 00       	call   80175a <open>
  801526:	89 c3                	mov    %eax,%ebx
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 1b                	js     80154a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	50                   	push   %eax
  801536:	e8 65 ff ff ff       	call   8014a0 <fstat>
  80153b:	89 c6                	mov    %eax,%esi
	close(fd);
  80153d:	89 1c 24             	mov    %ebx,(%esp)
  801540:	e8 29 fc ff ff       	call   80116e <close>
	return r;
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 f3                	mov    %esi,%ebx
}
  80154a:	89 d8                	mov    %ebx,%eax
  80154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5d                   	pop    %ebp
  801552:	c3                   	ret    

00801553 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	56                   	push   %esi
  801557:	53                   	push   %ebx
  801558:	89 c6                	mov    %eax,%esi
  80155a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80155c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801563:	74 27                	je     80158c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801565:	6a 07                	push   $0x7
  801567:	68 00 50 80 00       	push   $0x805000
  80156c:	56                   	push   %esi
  80156d:	ff 35 00 40 80 00    	pushl  0x804000
  801573:	e8 60 08 00 00       	call   801dd8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801578:	83 c4 0c             	add    $0xc,%esp
  80157b:	6a 00                	push   $0x0
  80157d:	53                   	push   %ebx
  80157e:	6a 00                	push   $0x0
  801580:	e8 ca 07 00 00       	call   801d4f <ipc_recv>
}
  801585:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801588:	5b                   	pop    %ebx
  801589:	5e                   	pop    %esi
  80158a:	5d                   	pop    %ebp
  80158b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80158c:	83 ec 0c             	sub    $0xc,%esp
  80158f:	6a 01                	push   $0x1
  801591:	e8 9e 08 00 00       	call   801e34 <ipc_find_env>
  801596:	a3 00 40 80 00       	mov    %eax,0x804000
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	eb c5                	jmp    801565 <fsipc+0x12>

008015a0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015be:	b8 02 00 00 00       	mov    $0x2,%eax
  8015c3:	e8 8b ff ff ff       	call   801553 <fsipc>
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <devfile_flush>:
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015db:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e0:	b8 06 00 00 00       	mov    $0x6,%eax
  8015e5:	e8 69 ff ff ff       	call   801553 <fsipc>
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <devfile_stat>:
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	53                   	push   %ebx
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801601:	ba 00 00 00 00       	mov    $0x0,%edx
  801606:	b8 05 00 00 00       	mov    $0x5,%eax
  80160b:	e8 43 ff ff ff       	call   801553 <fsipc>
  801610:	85 c0                	test   %eax,%eax
  801612:	78 2c                	js     801640 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	68 00 50 80 00       	push   $0x805000
  80161c:	53                   	push   %ebx
  80161d:	e8 75 f1 ff ff       	call   800797 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801622:	a1 80 50 80 00       	mov    0x805080,%eax
  801627:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80162d:	a1 84 50 80 00       	mov    0x805084,%eax
  801632:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <devfile_write>:
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	53                   	push   %ebx
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  80164f:	89 d8                	mov    %ebx,%eax
  801651:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801657:	76 05                	jbe    80165e <devfile_write+0x19>
  801659:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80165e:	8b 55 08             	mov    0x8(%ebp),%edx
  801661:	8b 52 0c             	mov    0xc(%edx),%edx
  801664:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80166a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	50                   	push   %eax
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	68 08 50 80 00       	push   $0x805008
  80167b:	e8 8a f2 ff ff       	call   80090a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801680:	ba 00 00 00 00       	mov    $0x0,%edx
  801685:	b8 04 00 00 00       	mov    $0x4,%eax
  80168a:	e8 c4 fe ff ff       	call   801553 <fsipc>
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	85 c0                	test   %eax,%eax
  801694:	78 0b                	js     8016a1 <devfile_write+0x5c>
	assert(r <= n);
  801696:	39 c3                	cmp    %eax,%ebx
  801698:	72 0c                	jb     8016a6 <devfile_write+0x61>
	assert(r <= PGSIZE);
  80169a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80169f:	7f 1e                	jg     8016bf <devfile_write+0x7a>
}
  8016a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    
	assert(r <= n);
  8016a6:	68 5c 25 80 00       	push   $0x80255c
  8016ab:	68 63 25 80 00       	push   $0x802563
  8016b0:	68 98 00 00 00       	push   $0x98
  8016b5:	68 78 25 80 00       	push   $0x802578
  8016ba:	e8 11 06 00 00       	call   801cd0 <_panic>
	assert(r <= PGSIZE);
  8016bf:	68 83 25 80 00       	push   $0x802583
  8016c4:	68 63 25 80 00       	push   $0x802563
  8016c9:	68 99 00 00 00       	push   $0x99
  8016ce:	68 78 25 80 00       	push   $0x802578
  8016d3:	e8 f8 05 00 00       	call   801cd0 <_panic>

008016d8 <devfile_read>:
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016eb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f6:	b8 03 00 00 00       	mov    $0x3,%eax
  8016fb:	e8 53 fe ff ff       	call   801553 <fsipc>
  801700:	89 c3                	mov    %eax,%ebx
  801702:	85 c0                	test   %eax,%eax
  801704:	78 1f                	js     801725 <devfile_read+0x4d>
	assert(r <= n);
  801706:	39 c6                	cmp    %eax,%esi
  801708:	72 24                	jb     80172e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80170a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80170f:	7f 33                	jg     801744 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	50                   	push   %eax
  801715:	68 00 50 80 00       	push   $0x805000
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	e8 e8 f1 ff ff       	call   80090a <memmove>
	return r;
  801722:	83 c4 10             	add    $0x10,%esp
}
  801725:	89 d8                	mov    %ebx,%eax
  801727:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172a:	5b                   	pop    %ebx
  80172b:	5e                   	pop    %esi
  80172c:	5d                   	pop    %ebp
  80172d:	c3                   	ret    
	assert(r <= n);
  80172e:	68 5c 25 80 00       	push   $0x80255c
  801733:	68 63 25 80 00       	push   $0x802563
  801738:	6a 7c                	push   $0x7c
  80173a:	68 78 25 80 00       	push   $0x802578
  80173f:	e8 8c 05 00 00       	call   801cd0 <_panic>
	assert(r <= PGSIZE);
  801744:	68 83 25 80 00       	push   $0x802583
  801749:	68 63 25 80 00       	push   $0x802563
  80174e:	6a 7d                	push   $0x7d
  801750:	68 78 25 80 00       	push   $0x802578
  801755:	e8 76 05 00 00       	call   801cd0 <_panic>

0080175a <open>:
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	56                   	push   %esi
  80175e:	53                   	push   %ebx
  80175f:	83 ec 1c             	sub    $0x1c,%esp
  801762:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801765:	56                   	push   %esi
  801766:	e8 f9 ef ff ff       	call   800764 <strlen>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801773:	7f 6c                	jg     8017e1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177b:	50                   	push   %eax
  80177c:	e8 6b f8 ff ff       	call   800fec <fd_alloc>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	85 c0                	test   %eax,%eax
  801788:	78 3c                	js     8017c6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	56                   	push   %esi
  80178e:	68 00 50 80 00       	push   $0x805000
  801793:	e8 ff ef ff ff       	call   800797 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a8:	e8 a6 fd ff ff       	call   801553 <fsipc>
  8017ad:	89 c3                	mov    %eax,%ebx
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	78 19                	js     8017cf <open+0x75>
	return fd2num(fd);
  8017b6:	83 ec 0c             	sub    $0xc,%esp
  8017b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bc:	e8 04 f8 ff ff       	call   800fc5 <fd2num>
  8017c1:	89 c3                	mov    %eax,%ebx
  8017c3:	83 c4 10             	add    $0x10,%esp
}
  8017c6:	89 d8                	mov    %ebx,%eax
  8017c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5e                   	pop    %esi
  8017cd:	5d                   	pop    %ebp
  8017ce:	c3                   	ret    
		fd_close(fd, 0);
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	6a 00                	push   $0x0
  8017d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d7:	e8 0c f9 ff ff       	call   8010e8 <fd_close>
		return r;
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	eb e5                	jmp    8017c6 <open+0x6c>
		return -E_BAD_PATH;
  8017e1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017e6:	eb de                	jmp    8017c6 <open+0x6c>

008017e8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8017f8:	e8 56 fd ff ff       	call   801553 <fsipc>
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	56                   	push   %esi
  801803:	53                   	push   %ebx
  801804:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801807:	83 ec 0c             	sub    $0xc,%esp
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	e8 c3 f7 ff ff       	call   800fd5 <fd2data>
  801812:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801814:	83 c4 08             	add    $0x8,%esp
  801817:	68 8f 25 80 00       	push   $0x80258f
  80181c:	53                   	push   %ebx
  80181d:	e8 75 ef ff ff       	call   800797 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801822:	8b 46 04             	mov    0x4(%esi),%eax
  801825:	2b 06                	sub    (%esi),%eax
  801827:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80182d:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801834:	10 00 00 
	stat->st_dev = &devpipe;
  801837:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80183e:	30 80 00 
	return 0;
}
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801849:	5b                   	pop    %ebx
  80184a:	5e                   	pop    %esi
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    

0080184d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	53                   	push   %ebx
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801857:	53                   	push   %ebx
  801858:	6a 00                	push   $0x0
  80185a:	e8 72 f3 ff ff       	call   800bd1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80185f:	89 1c 24             	mov    %ebx,(%esp)
  801862:	e8 6e f7 ff ff       	call   800fd5 <fd2data>
  801867:	83 c4 08             	add    $0x8,%esp
  80186a:	50                   	push   %eax
  80186b:	6a 00                	push   $0x0
  80186d:	e8 5f f3 ff ff       	call   800bd1 <sys_page_unmap>
}
  801872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <_pipeisclosed>:
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	57                   	push   %edi
  80187b:	56                   	push   %esi
  80187c:	53                   	push   %ebx
  80187d:	83 ec 1c             	sub    $0x1c,%esp
  801880:	89 c7                	mov    %eax,%edi
  801882:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801884:	a1 04 40 80 00       	mov    0x804004,%eax
  801889:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80188c:	83 ec 0c             	sub    $0xc,%esp
  80188f:	57                   	push   %edi
  801890:	e8 e1 05 00 00       	call   801e76 <pageref>
  801895:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801898:	89 34 24             	mov    %esi,(%esp)
  80189b:	e8 d6 05 00 00       	call   801e76 <pageref>
		nn = thisenv->env_runs;
  8018a0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8018a6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	39 cb                	cmp    %ecx,%ebx
  8018ae:	74 1b                	je     8018cb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8018b0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018b3:	75 cf                	jne    801884 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018b5:	8b 42 58             	mov    0x58(%edx),%eax
  8018b8:	6a 01                	push   $0x1
  8018ba:	50                   	push   %eax
  8018bb:	53                   	push   %ebx
  8018bc:	68 96 25 80 00       	push   $0x802596
  8018c1:	e8 c9 e8 ff ff       	call   80018f <cprintf>
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	eb b9                	jmp    801884 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018cb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018ce:	0f 94 c0             	sete   %al
  8018d1:	0f b6 c0             	movzbl %al,%eax
}
  8018d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5f                   	pop    %edi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <devpipe_write>:
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	57                   	push   %edi
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 18             	sub    $0x18,%esp
  8018e5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018e8:	56                   	push   %esi
  8018e9:	e8 e7 f6 ff ff       	call   800fd5 <fd2data>
  8018ee:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8018f8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018fb:	74 41                	je     80193e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018fd:	8b 53 04             	mov    0x4(%ebx),%edx
  801900:	8b 03                	mov    (%ebx),%eax
  801902:	83 c0 20             	add    $0x20,%eax
  801905:	39 c2                	cmp    %eax,%edx
  801907:	72 14                	jb     80191d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801909:	89 da                	mov    %ebx,%edx
  80190b:	89 f0                	mov    %esi,%eax
  80190d:	e8 65 ff ff ff       	call   801877 <_pipeisclosed>
  801912:	85 c0                	test   %eax,%eax
  801914:	75 2c                	jne    801942 <devpipe_write+0x66>
			sys_yield();
  801916:	e8 f8 f2 ff ff       	call   800c13 <sys_yield>
  80191b:	eb e0                	jmp    8018fd <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80191d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801920:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801923:	89 d0                	mov    %edx,%eax
  801925:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80192a:	78 0b                	js     801937 <devpipe_write+0x5b>
  80192c:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801930:	42                   	inc    %edx
  801931:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801934:	47                   	inc    %edi
  801935:	eb c1                	jmp    8018f8 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801937:	48                   	dec    %eax
  801938:	83 c8 e0             	or     $0xffffffe0,%eax
  80193b:	40                   	inc    %eax
  80193c:	eb ee                	jmp    80192c <devpipe_write+0x50>
	return i;
  80193e:	89 f8                	mov    %edi,%eax
  801940:	eb 05                	jmp    801947 <devpipe_write+0x6b>
				return 0;
  801942:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801947:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80194a:	5b                   	pop    %ebx
  80194b:	5e                   	pop    %esi
  80194c:	5f                   	pop    %edi
  80194d:	5d                   	pop    %ebp
  80194e:	c3                   	ret    

0080194f <devpipe_read>:
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	57                   	push   %edi
  801953:	56                   	push   %esi
  801954:	53                   	push   %ebx
  801955:	83 ec 18             	sub    $0x18,%esp
  801958:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80195b:	57                   	push   %edi
  80195c:	e8 74 f6 ff ff       	call   800fd5 <fd2data>
  801961:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196b:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80196e:	74 46                	je     8019b6 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801970:	8b 06                	mov    (%esi),%eax
  801972:	3b 46 04             	cmp    0x4(%esi),%eax
  801975:	75 22                	jne    801999 <devpipe_read+0x4a>
			if (i > 0)
  801977:	85 db                	test   %ebx,%ebx
  801979:	74 0a                	je     801985 <devpipe_read+0x36>
				return i;
  80197b:	89 d8                	mov    %ebx,%eax
}
  80197d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801980:	5b                   	pop    %ebx
  801981:	5e                   	pop    %esi
  801982:	5f                   	pop    %edi
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801985:	89 f2                	mov    %esi,%edx
  801987:	89 f8                	mov    %edi,%eax
  801989:	e8 e9 fe ff ff       	call   801877 <_pipeisclosed>
  80198e:	85 c0                	test   %eax,%eax
  801990:	75 28                	jne    8019ba <devpipe_read+0x6b>
			sys_yield();
  801992:	e8 7c f2 ff ff       	call   800c13 <sys_yield>
  801997:	eb d7                	jmp    801970 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801999:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80199e:	78 0f                	js     8019af <devpipe_read+0x60>
  8019a0:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8019a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019a7:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8019aa:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8019ac:	43                   	inc    %ebx
  8019ad:	eb bc                	jmp    80196b <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019af:	48                   	dec    %eax
  8019b0:	83 c8 e0             	or     $0xffffffe0,%eax
  8019b3:	40                   	inc    %eax
  8019b4:	eb ea                	jmp    8019a0 <devpipe_read+0x51>
	return i;
  8019b6:	89 d8                	mov    %ebx,%eax
  8019b8:	eb c3                	jmp    80197d <devpipe_read+0x2e>
				return 0;
  8019ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bf:	eb bc                	jmp    80197d <devpipe_read+0x2e>

008019c1 <pipe>:
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	56                   	push   %esi
  8019c5:	53                   	push   %ebx
  8019c6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cc:	50                   	push   %eax
  8019cd:	e8 1a f6 ff ff       	call   800fec <fd_alloc>
  8019d2:	89 c3                	mov    %eax,%ebx
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	0f 88 2a 01 00 00    	js     801b09 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	68 07 04 00 00       	push   $0x407
  8019e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ea:	6a 00                	push   $0x0
  8019ec:	e8 5b f1 ff ff       	call   800b4c <sys_page_alloc>
  8019f1:	89 c3                	mov    %eax,%ebx
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	0f 88 0b 01 00 00    	js     801b09 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  8019fe:	83 ec 0c             	sub    $0xc,%esp
  801a01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a04:	50                   	push   %eax
  801a05:	e8 e2 f5 ff ff       	call   800fec <fd_alloc>
  801a0a:	89 c3                	mov    %eax,%ebx
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	0f 88 e2 00 00 00    	js     801af9 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	68 07 04 00 00       	push   $0x407
  801a1f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a22:	6a 00                	push   $0x0
  801a24:	e8 23 f1 ff ff       	call   800b4c <sys_page_alloc>
  801a29:	89 c3                	mov    %eax,%ebx
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	0f 88 c3 00 00 00    	js     801af9 <pipe+0x138>
	va = fd2data(fd0);
  801a36:	83 ec 0c             	sub    $0xc,%esp
  801a39:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3c:	e8 94 f5 ff ff       	call   800fd5 <fd2data>
  801a41:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a43:	83 c4 0c             	add    $0xc,%esp
  801a46:	68 07 04 00 00       	push   $0x407
  801a4b:	50                   	push   %eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	e8 f9 f0 ff ff       	call   800b4c <sys_page_alloc>
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	0f 88 89 00 00 00    	js     801ae9 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a60:	83 ec 0c             	sub    $0xc,%esp
  801a63:	ff 75 f0             	pushl  -0x10(%ebp)
  801a66:	e8 6a f5 ff ff       	call   800fd5 <fd2data>
  801a6b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a72:	50                   	push   %eax
  801a73:	6a 00                	push   $0x0
  801a75:	56                   	push   %esi
  801a76:	6a 00                	push   $0x0
  801a78:	e8 12 f1 ff ff       	call   800b8f <sys_page_map>
  801a7d:	89 c3                	mov    %eax,%ebx
  801a7f:	83 c4 20             	add    $0x20,%esp
  801a82:	85 c0                	test   %eax,%eax
  801a84:	78 55                	js     801adb <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801a86:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a9b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa4:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ab0:	83 ec 0c             	sub    $0xc,%esp
  801ab3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab6:	e8 0a f5 ff ff       	call   800fc5 <fd2num>
  801abb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abe:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ac0:	83 c4 04             	add    $0x4,%esp
  801ac3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac6:	e8 fa f4 ff ff       	call   800fc5 <fd2num>
  801acb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ace:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad9:	eb 2e                	jmp    801b09 <pipe+0x148>
	sys_page_unmap(0, va);
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	56                   	push   %esi
  801adf:	6a 00                	push   $0x0
  801ae1:	e8 eb f0 ff ff       	call   800bd1 <sys_page_unmap>
  801ae6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ae9:	83 ec 08             	sub    $0x8,%esp
  801aec:	ff 75 f0             	pushl  -0x10(%ebp)
  801aef:	6a 00                	push   $0x0
  801af1:	e8 db f0 ff ff       	call   800bd1 <sys_page_unmap>
  801af6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801af9:	83 ec 08             	sub    $0x8,%esp
  801afc:	ff 75 f4             	pushl  -0xc(%ebp)
  801aff:	6a 00                	push   $0x0
  801b01:	e8 cb f0 ff ff       	call   800bd1 <sys_page_unmap>
  801b06:	83 c4 10             	add    $0x10,%esp
}
  801b09:	89 d8                	mov    %ebx,%eax
  801b0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5e                   	pop    %esi
  801b10:	5d                   	pop    %ebp
  801b11:	c3                   	ret    

00801b12 <pipeisclosed>:
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1b:	50                   	push   %eax
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	e8 17 f5 ff ff       	call   80103b <fd_lookup>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 18                	js     801b43 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b2b:	83 ec 0c             	sub    $0xc,%esp
  801b2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b31:	e8 9f f4 ff ff       	call   800fd5 <fd2data>
	return _pipeisclosed(fd, p);
  801b36:	89 c2                	mov    %eax,%edx
  801b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3b:	e8 37 fd ff ff       	call   801877 <_pipeisclosed>
  801b40:	83 c4 10             	add    $0x10,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    

00801b4f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	53                   	push   %ebx
  801b53:	83 ec 0c             	sub    $0xc,%esp
  801b56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801b59:	68 ae 25 80 00       	push   $0x8025ae
  801b5e:	53                   	push   %ebx
  801b5f:	e8 33 ec ff ff       	call   800797 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801b64:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801b6b:	20 00 00 
	return 0;
}
  801b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <devcons_write>:
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	57                   	push   %edi
  801b7c:	56                   	push   %esi
  801b7d:	53                   	push   %ebx
  801b7e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b84:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b89:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b8f:	eb 1d                	jmp    801bae <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801b91:	83 ec 04             	sub    $0x4,%esp
  801b94:	53                   	push   %ebx
  801b95:	03 45 0c             	add    0xc(%ebp),%eax
  801b98:	50                   	push   %eax
  801b99:	57                   	push   %edi
  801b9a:	e8 6b ed ff ff       	call   80090a <memmove>
		sys_cputs(buf, m);
  801b9f:	83 c4 08             	add    $0x8,%esp
  801ba2:	53                   	push   %ebx
  801ba3:	57                   	push   %edi
  801ba4:	e8 06 ef ff ff       	call   800aaf <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ba9:	01 de                	add    %ebx,%esi
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	89 f0                	mov    %esi,%eax
  801bb0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bb3:	73 11                	jae    801bc6 <devcons_write+0x4e>
		m = n - tot;
  801bb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bb8:	29 f3                	sub    %esi,%ebx
  801bba:	83 fb 7f             	cmp    $0x7f,%ebx
  801bbd:	76 d2                	jbe    801b91 <devcons_write+0x19>
  801bbf:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801bc4:	eb cb                	jmp    801b91 <devcons_write+0x19>
}
  801bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5e                   	pop    %esi
  801bcb:	5f                   	pop    %edi
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <devcons_read>:
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801bd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd8:	75 0c                	jne    801be6 <devcons_read+0x18>
		return 0;
  801bda:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdf:	eb 21                	jmp    801c02 <devcons_read+0x34>
		sys_yield();
  801be1:	e8 2d f0 ff ff       	call   800c13 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801be6:	e8 e2 ee ff ff       	call   800acd <sys_cgetc>
  801beb:	85 c0                	test   %eax,%eax
  801bed:	74 f2                	je     801be1 <devcons_read+0x13>
	if (c < 0)
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 0f                	js     801c02 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801bf3:	83 f8 04             	cmp    $0x4,%eax
  801bf6:	74 0c                	je     801c04 <devcons_read+0x36>
	*(char*)vbuf = c;
  801bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfb:	88 02                	mov    %al,(%edx)
	return 1;
  801bfd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    
		return 0;
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
  801c09:	eb f7                	jmp    801c02 <devcons_read+0x34>

00801c0b <cputchar>:
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c17:	6a 01                	push   $0x1
  801c19:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c1c:	50                   	push   %eax
  801c1d:	e8 8d ee ff ff       	call   800aaf <sys_cputs>
}
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <getchar>:
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c2d:	6a 01                	push   $0x1
  801c2f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c32:	50                   	push   %eax
  801c33:	6a 00                	push   $0x0
  801c35:	e8 6e f6 ff ff       	call   8012a8 <read>
	if (r < 0)
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 08                	js     801c49 <getchar+0x22>
	if (r < 1)
  801c41:	85 c0                	test   %eax,%eax
  801c43:	7e 06                	jle    801c4b <getchar+0x24>
	return c;
  801c45:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    
		return -E_EOF;
  801c4b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c50:	eb f7                	jmp    801c49 <getchar+0x22>

00801c52 <iscons>:
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5b:	50                   	push   %eax
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	e8 d7 f3 ff ff       	call   80103b <fd_lookup>
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	85 c0                	test   %eax,%eax
  801c69:	78 11                	js     801c7c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c74:	39 10                	cmp    %edx,(%eax)
  801c76:	0f 94 c0             	sete   %al
  801c79:	0f b6 c0             	movzbl %al,%eax
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <opencons>:
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c87:	50                   	push   %eax
  801c88:	e8 5f f3 ff ff       	call   800fec <fd_alloc>
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 3a                	js     801cce <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c94:	83 ec 04             	sub    $0x4,%esp
  801c97:	68 07 04 00 00       	push   $0x407
  801c9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9f:	6a 00                	push   $0x0
  801ca1:	e8 a6 ee ff ff       	call   800b4c <sys_page_alloc>
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	78 21                	js     801cce <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801cad:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cc2:	83 ec 0c             	sub    $0xc,%esp
  801cc5:	50                   	push   %eax
  801cc6:	e8 fa f2 ff ff       	call   800fc5 <fd2num>
  801ccb:	83 c4 10             	add    $0x10,%esp
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	57                   	push   %edi
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801cdc:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801cdf:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801ce5:	e8 43 ee ff ff       	call   800b2d <sys_getenvid>
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	53                   	push   %ebx
  801cf4:	50                   	push   %eax
  801cf5:	68 bc 25 80 00       	push   $0x8025bc
  801cfa:	68 00 01 00 00       	push   $0x100
  801cff:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801d05:	56                   	push   %esi
  801d06:	e8 3f ea ff ff       	call   80074a <snprintf>
  801d0b:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801d0d:	83 c4 20             	add    $0x20,%esp
  801d10:	57                   	push   %edi
  801d11:	ff 75 10             	pushl  0x10(%ebp)
  801d14:	bf 00 01 00 00       	mov    $0x100,%edi
  801d19:	89 f8                	mov    %edi,%eax
  801d1b:	29 d8                	sub    %ebx,%eax
  801d1d:	50                   	push   %eax
  801d1e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801d21:	50                   	push   %eax
  801d22:	e8 ce e9 ff ff       	call   8006f5 <vsnprintf>
  801d27:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801d29:	83 c4 0c             	add    $0xc,%esp
  801d2c:	68 a7 25 80 00       	push   $0x8025a7
  801d31:	29 df                	sub    %ebx,%edi
  801d33:	57                   	push   %edi
  801d34:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801d37:	50                   	push   %eax
  801d38:	e8 0d ea ff ff       	call   80074a <snprintf>
	sys_cputs(buf, r);
  801d3d:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801d40:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801d42:	53                   	push   %ebx
  801d43:	56                   	push   %esi
  801d44:	e8 66 ed ff ff       	call   800aaf <sys_cputs>
  801d49:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d4c:	cc                   	int3   
  801d4d:	eb fd                	jmp    801d4c <_panic+0x7c>

00801d4f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	57                   	push   %edi
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
  801d55:	83 ec 0c             	sub    $0xc,%esp
  801d58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d5b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d5e:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801d61:	85 ff                	test   %edi,%edi
  801d63:	74 53                	je     801db8 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	57                   	push   %edi
  801d69:	e8 ee ef ff ff       	call   800d5c <sys_ipc_recv>
  801d6e:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801d71:	85 db                	test   %ebx,%ebx
  801d73:	74 0b                	je     801d80 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801d75:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d7b:	8b 52 74             	mov    0x74(%edx),%edx
  801d7e:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801d80:	85 f6                	test   %esi,%esi
  801d82:	74 0f                	je     801d93 <ipc_recv+0x44>
  801d84:	85 ff                	test   %edi,%edi
  801d86:	74 0b                	je     801d93 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801d88:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d8e:	8b 52 78             	mov    0x78(%edx),%edx
  801d91:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801d93:	85 c0                	test   %eax,%eax
  801d95:	74 30                	je     801dc7 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801d97:	85 db                	test   %ebx,%ebx
  801d99:	74 06                	je     801da1 <ipc_recv+0x52>
      		*from_env_store = 0;
  801d9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801da1:	85 f6                	test   %esi,%esi
  801da3:	74 2c                	je     801dd1 <ipc_recv+0x82>
      		*perm_store = 0;
  801da5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801dab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db3:	5b                   	pop    %ebx
  801db4:	5e                   	pop    %esi
  801db5:	5f                   	pop    %edi
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801db8:	83 ec 0c             	sub    $0xc,%esp
  801dbb:	6a ff                	push   $0xffffffff
  801dbd:	e8 9a ef ff ff       	call   800d5c <sys_ipc_recv>
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	eb aa                	jmp    801d71 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801dc7:	a1 04 40 80 00       	mov    0x804004,%eax
  801dcc:	8b 40 70             	mov    0x70(%eax),%eax
  801dcf:	eb df                	jmp    801db0 <ipc_recv+0x61>
		return -1;
  801dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801dd6:	eb d8                	jmp    801db0 <ipc_recv+0x61>

00801dd8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	57                   	push   %edi
  801ddc:	56                   	push   %esi
  801ddd:	53                   	push   %ebx
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801de4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801de7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801dea:	85 db                	test   %ebx,%ebx
  801dec:	75 22                	jne    801e10 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801dee:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801df3:	eb 1b                	jmp    801e10 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801df5:	68 e0 25 80 00       	push   $0x8025e0
  801dfa:	68 63 25 80 00       	push   $0x802563
  801dff:	6a 48                	push   $0x48
  801e01:	68 04 26 80 00       	push   $0x802604
  801e06:	e8 c5 fe ff ff       	call   801cd0 <_panic>
		sys_yield();
  801e0b:	e8 03 ee ff ff       	call   800c13 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801e10:	57                   	push   %edi
  801e11:	53                   	push   %ebx
  801e12:	56                   	push   %esi
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	e8 1e ef ff ff       	call   800d39 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801e1b:	83 c4 10             	add    $0x10,%esp
  801e1e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e21:	74 e8                	je     801e0b <ipc_send+0x33>
  801e23:	85 c0                	test   %eax,%eax
  801e25:	75 ce                	jne    801df5 <ipc_send+0x1d>
		sys_yield();
  801e27:	e8 e7 ed ff ff       	call   800c13 <sys_yield>
		
	}
	
}
  801e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    

00801e34 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e3f:	89 c2                	mov    %eax,%edx
  801e41:	c1 e2 05             	shl    $0x5,%edx
  801e44:	29 c2                	sub    %eax,%edx
  801e46:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801e4d:	8b 52 50             	mov    0x50(%edx),%edx
  801e50:	39 ca                	cmp    %ecx,%edx
  801e52:	74 0f                	je     801e63 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801e54:	40                   	inc    %eax
  801e55:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e5a:	75 e3                	jne    801e3f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	eb 11                	jmp    801e74 <ipc_find_env+0x40>
			return envs[i].env_id;
  801e63:	89 c2                	mov    %eax,%edx
  801e65:	c1 e2 05             	shl    $0x5,%edx
  801e68:	29 c2                	sub    %eax,%edx
  801e6a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801e71:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    

00801e76 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	c1 e8 16             	shr    $0x16,%eax
  801e7f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e86:	a8 01                	test   $0x1,%al
  801e88:	74 21                	je     801eab <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	c1 e8 0c             	shr    $0xc,%eax
  801e90:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801e97:	a8 01                	test   $0x1,%al
  801e99:	74 17                	je     801eb2 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e9b:	c1 e8 0c             	shr    $0xc,%eax
  801e9e:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801ea5:	ef 
  801ea6:	0f b7 c0             	movzwl %ax,%eax
  801ea9:	eb 05                	jmp    801eb0 <pageref+0x3a>
		return 0;
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    
		return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb7:	eb f7                	jmp    801eb0 <pageref+0x3a>
  801eb9:	66 90                	xchg   %ax,%ax
  801ebb:	90                   	nop

00801ebc <__udivdi3>:
  801ebc:	55                   	push   %ebp
  801ebd:	57                   	push   %edi
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	83 ec 1c             	sub    $0x1c,%esp
  801ec3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ec7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ecb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ecf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ed3:	89 ca                	mov    %ecx,%edx
  801ed5:	89 f8                	mov    %edi,%eax
  801ed7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801edb:	85 f6                	test   %esi,%esi
  801edd:	75 2d                	jne    801f0c <__udivdi3+0x50>
  801edf:	39 cf                	cmp    %ecx,%edi
  801ee1:	77 65                	ja     801f48 <__udivdi3+0x8c>
  801ee3:	89 fd                	mov    %edi,%ebp
  801ee5:	85 ff                	test   %edi,%edi
  801ee7:	75 0b                	jne    801ef4 <__udivdi3+0x38>
  801ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  801eee:	31 d2                	xor    %edx,%edx
  801ef0:	f7 f7                	div    %edi
  801ef2:	89 c5                	mov    %eax,%ebp
  801ef4:	31 d2                	xor    %edx,%edx
  801ef6:	89 c8                	mov    %ecx,%eax
  801ef8:	f7 f5                	div    %ebp
  801efa:	89 c1                	mov    %eax,%ecx
  801efc:	89 d8                	mov    %ebx,%eax
  801efe:	f7 f5                	div    %ebp
  801f00:	89 cf                	mov    %ecx,%edi
  801f02:	89 fa                	mov    %edi,%edx
  801f04:	83 c4 1c             	add    $0x1c,%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5f                   	pop    %edi
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    
  801f0c:	39 ce                	cmp    %ecx,%esi
  801f0e:	77 28                	ja     801f38 <__udivdi3+0x7c>
  801f10:	0f bd fe             	bsr    %esi,%edi
  801f13:	83 f7 1f             	xor    $0x1f,%edi
  801f16:	75 40                	jne    801f58 <__udivdi3+0x9c>
  801f18:	39 ce                	cmp    %ecx,%esi
  801f1a:	72 0a                	jb     801f26 <__udivdi3+0x6a>
  801f1c:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801f20:	0f 87 9e 00 00 00    	ja     801fc4 <__udivdi3+0x108>
  801f26:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2b:	89 fa                	mov    %edi,%edx
  801f2d:	83 c4 1c             	add    $0x1c,%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5f                   	pop    %edi
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    
  801f35:	8d 76 00             	lea    0x0(%esi),%esi
  801f38:	31 ff                	xor    %edi,%edi
  801f3a:	31 c0                	xor    %eax,%eax
  801f3c:	89 fa                	mov    %edi,%edx
  801f3e:	83 c4 1c             	add    $0x1c,%esp
  801f41:	5b                   	pop    %ebx
  801f42:	5e                   	pop    %esi
  801f43:	5f                   	pop    %edi
  801f44:	5d                   	pop    %ebp
  801f45:	c3                   	ret    
  801f46:	66 90                	xchg   %ax,%ax
  801f48:	89 d8                	mov    %ebx,%eax
  801f4a:	f7 f7                	div    %edi
  801f4c:	31 ff                	xor    %edi,%edi
  801f4e:	89 fa                	mov    %edi,%edx
  801f50:	83 c4 1c             	add    $0x1c,%esp
  801f53:	5b                   	pop    %ebx
  801f54:	5e                   	pop    %esi
  801f55:	5f                   	pop    %edi
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    
  801f58:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f5d:	29 fd                	sub    %edi,%ebp
  801f5f:	89 f9                	mov    %edi,%ecx
  801f61:	d3 e6                	shl    %cl,%esi
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	89 e9                	mov    %ebp,%ecx
  801f67:	d3 eb                	shr    %cl,%ebx
  801f69:	89 d9                	mov    %ebx,%ecx
  801f6b:	09 f1                	or     %esi,%ecx
  801f6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f71:	89 f9                	mov    %edi,%ecx
  801f73:	d3 e0                	shl    %cl,%eax
  801f75:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f79:	89 d6                	mov    %edx,%esi
  801f7b:	89 e9                	mov    %ebp,%ecx
  801f7d:	d3 ee                	shr    %cl,%esi
  801f7f:	89 f9                	mov    %edi,%ecx
  801f81:	d3 e2                	shl    %cl,%edx
  801f83:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801f87:	89 e9                	mov    %ebp,%ecx
  801f89:	d3 eb                	shr    %cl,%ebx
  801f8b:	09 da                	or     %ebx,%edx
  801f8d:	89 d0                	mov    %edx,%eax
  801f8f:	89 f2                	mov    %esi,%edx
  801f91:	f7 74 24 08          	divl   0x8(%esp)
  801f95:	89 d6                	mov    %edx,%esi
  801f97:	89 c3                	mov    %eax,%ebx
  801f99:	f7 64 24 0c          	mull   0xc(%esp)
  801f9d:	39 d6                	cmp    %edx,%esi
  801f9f:	72 17                	jb     801fb8 <__udivdi3+0xfc>
  801fa1:	74 09                	je     801fac <__udivdi3+0xf0>
  801fa3:	89 d8                	mov    %ebx,%eax
  801fa5:	31 ff                	xor    %edi,%edi
  801fa7:	e9 56 ff ff ff       	jmp    801f02 <__udivdi3+0x46>
  801fac:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fb0:	89 f9                	mov    %edi,%ecx
  801fb2:	d3 e2                	shl    %cl,%edx
  801fb4:	39 c2                	cmp    %eax,%edx
  801fb6:	73 eb                	jae    801fa3 <__udivdi3+0xe7>
  801fb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fbb:	31 ff                	xor    %edi,%edi
  801fbd:	e9 40 ff ff ff       	jmp    801f02 <__udivdi3+0x46>
  801fc2:	66 90                	xchg   %ax,%ax
  801fc4:	31 c0                	xor    %eax,%eax
  801fc6:	e9 37 ff ff ff       	jmp    801f02 <__udivdi3+0x46>
  801fcb:	90                   	nop

00801fcc <__umoddi3>:
  801fcc:	55                   	push   %ebp
  801fcd:	57                   	push   %edi
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 1c             	sub    $0x1c,%esp
  801fd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fe3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fe7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801feb:	89 3c 24             	mov    %edi,(%esp)
  801fee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ff2:	89 f2                	mov    %esi,%edx
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	75 18                	jne    802010 <__umoddi3+0x44>
  801ff8:	39 f7                	cmp    %esi,%edi
  801ffa:	0f 86 a0 00 00 00    	jbe    8020a0 <__umoddi3+0xd4>
  802000:	89 c8                	mov    %ecx,%eax
  802002:	f7 f7                	div    %edi
  802004:	89 d0                	mov    %edx,%eax
  802006:	31 d2                	xor    %edx,%edx
  802008:	83 c4 1c             	add    $0x1c,%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5e                   	pop    %esi
  80200d:	5f                   	pop    %edi
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    
  802010:	89 f3                	mov    %esi,%ebx
  802012:	39 f0                	cmp    %esi,%eax
  802014:	0f 87 a6 00 00 00    	ja     8020c0 <__umoddi3+0xf4>
  80201a:	0f bd e8             	bsr    %eax,%ebp
  80201d:	83 f5 1f             	xor    $0x1f,%ebp
  802020:	0f 84 a6 00 00 00    	je     8020cc <__umoddi3+0x100>
  802026:	bf 20 00 00 00       	mov    $0x20,%edi
  80202b:	29 ef                	sub    %ebp,%edi
  80202d:	89 e9                	mov    %ebp,%ecx
  80202f:	d3 e0                	shl    %cl,%eax
  802031:	8b 34 24             	mov    (%esp),%esi
  802034:	89 f2                	mov    %esi,%edx
  802036:	89 f9                	mov    %edi,%ecx
  802038:	d3 ea                	shr    %cl,%edx
  80203a:	09 c2                	or     %eax,%edx
  80203c:	89 14 24             	mov    %edx,(%esp)
  80203f:	89 f2                	mov    %esi,%edx
  802041:	89 e9                	mov    %ebp,%ecx
  802043:	d3 e2                	shl    %cl,%edx
  802045:	89 54 24 04          	mov    %edx,0x4(%esp)
  802049:	89 de                	mov    %ebx,%esi
  80204b:	89 f9                	mov    %edi,%ecx
  80204d:	d3 ee                	shr    %cl,%esi
  80204f:	89 e9                	mov    %ebp,%ecx
  802051:	d3 e3                	shl    %cl,%ebx
  802053:	8b 54 24 08          	mov    0x8(%esp),%edx
  802057:	89 d0                	mov    %edx,%eax
  802059:	89 f9                	mov    %edi,%ecx
  80205b:	d3 e8                	shr    %cl,%eax
  80205d:	09 d8                	or     %ebx,%eax
  80205f:	89 d3                	mov    %edx,%ebx
  802061:	89 e9                	mov    %ebp,%ecx
  802063:	d3 e3                	shl    %cl,%ebx
  802065:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802069:	89 f2                	mov    %esi,%edx
  80206b:	f7 34 24             	divl   (%esp)
  80206e:	89 d6                	mov    %edx,%esi
  802070:	f7 64 24 04          	mull   0x4(%esp)
  802074:	89 c3                	mov    %eax,%ebx
  802076:	89 d1                	mov    %edx,%ecx
  802078:	39 d6                	cmp    %edx,%esi
  80207a:	72 7c                	jb     8020f8 <__umoddi3+0x12c>
  80207c:	74 72                	je     8020f0 <__umoddi3+0x124>
  80207e:	8b 54 24 08          	mov    0x8(%esp),%edx
  802082:	29 da                	sub    %ebx,%edx
  802084:	19 ce                	sbb    %ecx,%esi
  802086:	89 f0                	mov    %esi,%eax
  802088:	89 f9                	mov    %edi,%ecx
  80208a:	d3 e0                	shl    %cl,%eax
  80208c:	89 e9                	mov    %ebp,%ecx
  80208e:	d3 ea                	shr    %cl,%edx
  802090:	09 d0                	or     %edx,%eax
  802092:	89 e9                	mov    %ebp,%ecx
  802094:	d3 ee                	shr    %cl,%esi
  802096:	89 f2                	mov    %esi,%edx
  802098:	83 c4 1c             	add    $0x1c,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5f                   	pop    %edi
  80209e:	5d                   	pop    %ebp
  80209f:	c3                   	ret    
  8020a0:	89 fd                	mov    %edi,%ebp
  8020a2:	85 ff                	test   %edi,%edi
  8020a4:	75 0b                	jne    8020b1 <__umoddi3+0xe5>
  8020a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ab:	31 d2                	xor    %edx,%edx
  8020ad:	f7 f7                	div    %edi
  8020af:	89 c5                	mov    %eax,%ebp
  8020b1:	89 f0                	mov    %esi,%eax
  8020b3:	31 d2                	xor    %edx,%edx
  8020b5:	f7 f5                	div    %ebp
  8020b7:	89 c8                	mov    %ecx,%eax
  8020b9:	f7 f5                	div    %ebp
  8020bb:	e9 44 ff ff ff       	jmp    802004 <__umoddi3+0x38>
  8020c0:	89 c8                	mov    %ecx,%eax
  8020c2:	89 f2                	mov    %esi,%edx
  8020c4:	83 c4 1c             	add    $0x1c,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    
  8020cc:	39 f0                	cmp    %esi,%eax
  8020ce:	72 05                	jb     8020d5 <__umoddi3+0x109>
  8020d0:	39 0c 24             	cmp    %ecx,(%esp)
  8020d3:	77 0c                	ja     8020e1 <__umoddi3+0x115>
  8020d5:	89 f2                	mov    %esi,%edx
  8020d7:	29 f9                	sub    %edi,%ecx
  8020d9:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020e1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020e5:	83 c4 1c             	add    $0x1c,%esp
  8020e8:	5b                   	pop    %ebx
  8020e9:	5e                   	pop    %esi
  8020ea:	5f                   	pop    %edi
  8020eb:	5d                   	pop    %ebp
  8020ec:	c3                   	ret    
  8020ed:	8d 76 00             	lea    0x0(%esi),%esi
  8020f0:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8020f4:	73 88                	jae    80207e <__umoddi3+0xb2>
  8020f6:	66 90                	xchg   %ax,%ax
  8020f8:	2b 44 24 04          	sub    0x4(%esp),%eax
  8020fc:	1b 14 24             	sbb    (%esp),%edx
  8020ff:	89 d1                	mov    %edx,%ecx
  802101:	89 c3                	mov    %eax,%ebx
  802103:	e9 76 ff ff ff       	jmp    80207e <__umoddi3+0xb2>
