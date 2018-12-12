
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 4f 01 00 00       	call   800180 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 1b                	jmp    80005e <num+0x2b>
		if (bol) {
			printf("%5d ", ++line);
			bol = 0;
		}
		if ((r = write(1, &c, 1)) != 1)
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 01                	push   $0x1
  800048:	53                   	push   %ebx
  800049:	6a 01                	push   $0x1
  80004b:	e8 24 12 00 00       	call   801274 <write>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	83 f8 01             	cmp    $0x1,%eax
  800056:	75 4a                	jne    8000a2 <num+0x6f>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800058:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  80005c:	74 5c                	je     8000ba <num+0x87>
	while ((n = read(f, &c, 1)) > 0) {
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	53                   	push   %ebx
  800064:	56                   	push   %esi
  800065:	e8 3c 11 00 00       	call   8011a6 <read>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	85 c0                	test   %eax,%eax
  80006f:	7e 55                	jle    8000c6 <num+0x93>
		if (bol) {
  800071:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  800078:	74 c9                	je     800043 <num+0x10>
			printf("%5d ", ++line);
  80007a:	a1 00 40 80 00       	mov    0x804000,%eax
  80007f:	40                   	inc    %eax
  800080:	a3 00 40 80 00       	mov    %eax,0x804000
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	50                   	push   %eax
  800089:	68 40 21 80 00       	push   $0x802140
  80008e:	e8 67 17 00 00       	call   8017fa <printf>
			bol = 0;
  800093:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80009a:	00 00 00 
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	eb a1                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	ff 75 0c             	pushl  0xc(%ebp)
  8000a9:	68 45 21 80 00       	push   $0x802145
  8000ae:	6a 13                	push   $0x13
  8000b0:	68 60 21 80 00       	push   $0x802160
  8000b5:	e8 2c 01 00 00       	call   8001e6 <_panic>
			bol = 1;
  8000ba:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c1:	00 00 00 
  8000c4:	eb 98                	jmp    80005e <num+0x2b>
	}
	if (n < 0)
  8000c6:	85 c0                	test   %eax,%eax
  8000c8:	78 07                	js     8000d1 <num+0x9e>
		panic("error reading %s: %e", s, n);
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	68 6b 21 80 00       	push   $0x80216b
  8000dd:	6a 18                	push   $0x18
  8000df:	68 60 21 80 00       	push   $0x802160
  8000e4:	e8 fd 00 00 00       	call   8001e6 <_panic>

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f2:	c7 05 04 30 80 00 80 	movl   $0x802180,0x803004
  8000f9:	21 80 00 
	if (argc == 1)
  8000fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800100:	74 45                	je     800147 <umain+0x5e>
  800102:	8b 45 0c             	mov    0xc(%ebp),%eax
  800105:	8d 58 04             	lea    0x4(%eax),%ebx
  800108:	bf 01 00 00 00       	mov    $0x1,%edi
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80010d:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800110:	7d 47                	jge    800159 <umain+0x70>
			f = open(argv[i], O_RDONLY);
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	6a 00                	push   $0x0
  80011a:	ff 33                	pushl  (%ebx)
  80011c:	e8 37 15 00 00       	call   801658 <open>
  800121:	89 c6                	mov    %eax,%esi
  800123:	83 c3 04             	add    $0x4,%ebx
			if (f < 0)
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	85 c0                	test   %eax,%eax
  80012b:	78 39                	js     800166 <umain+0x7d>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	ff 73 fc             	pushl  -0x4(%ebx)
  800133:	50                   	push   %eax
  800134:	e8 fa fe ff ff       	call   800033 <num>
				close(f);
  800139:	89 34 24             	mov    %esi,(%esp)
  80013c:	e8 2b 0f 00 00       	call   80106c <close>
		for (i = 1; i < argc; i++) {
  800141:	47                   	inc    %edi
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	eb c6                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800147:	83 ec 08             	sub    $0x8,%esp
  80014a:	68 84 21 80 00       	push   $0x802184
  80014f:	6a 00                	push   $0x0
  800151:	e8 dd fe ff ff       	call   800033 <num>
  800156:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  800159:	e8 6e 00 00 00       	call   8001cc <exit>
}
  80015e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800161:	5b                   	pop    %ebx
  800162:	5e                   	pop    %esi
  800163:	5f                   	pop    %edi
  800164:	5d                   	pop    %ebp
  800165:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	50                   	push   %eax
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	ff 30                	pushl  (%eax)
  80016f:	68 8c 21 80 00       	push   $0x80218c
  800174:	6a 27                	push   $0x27
  800176:	68 60 21 80 00       	push   $0x802160
  80017b:	e8 66 00 00 00       	call   8001e6 <_panic>

00800180 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
  800185:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800188:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80018b:	e8 5f 0a 00 00       	call   800bef <sys_getenvid>
  800190:	25 ff 03 00 00       	and    $0x3ff,%eax
  800195:	89 c2                	mov    %eax,%edx
  800197:	c1 e2 05             	shl    $0x5,%edx
  80019a:	29 c2                	sub    %eax,%edx
  80019c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8001a3:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a8:	85 db                	test   %ebx,%ebx
  8001aa:	7e 07                	jle    8001b3 <libmain+0x33>
		binaryname = argv[0];
  8001ac:	8b 06                	mov    (%esi),%eax
  8001ae:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	e8 2c ff ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  8001bd:	e8 0a 00 00 00       	call   8001cc <exit>
}
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c8:	5b                   	pop    %ebx
  8001c9:	5e                   	pop    %esi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    

008001cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001d2:	e8 c0 0e 00 00       	call   801097 <close_all>
	sys_env_destroy(0);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	6a 00                	push   $0x0
  8001dc:	e8 cd 09 00 00       	call   800bae <sys_env_destroy>
}
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	57                   	push   %edi
  8001ea:	56                   	push   %esi
  8001eb:	53                   	push   %ebx
  8001ec:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  8001f2:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  8001f5:	8b 1d 04 30 80 00    	mov    0x803004,%ebx
  8001fb:	e8 ef 09 00 00       	call   800bef <sys_getenvid>
  800200:	83 ec 04             	sub    $0x4,%esp
  800203:	ff 75 0c             	pushl  0xc(%ebp)
  800206:	ff 75 08             	pushl  0x8(%ebp)
  800209:	53                   	push   %ebx
  80020a:	50                   	push   %eax
  80020b:	68 a8 21 80 00       	push   $0x8021a8
  800210:	68 00 01 00 00       	push   $0x100
  800215:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  80021b:	56                   	push   %esi
  80021c:	e8 eb 05 00 00       	call   80080c <snprintf>
  800221:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800223:	83 c4 20             	add    $0x20,%esp
  800226:	57                   	push   %edi
  800227:	ff 75 10             	pushl  0x10(%ebp)
  80022a:	bf 00 01 00 00       	mov    $0x100,%edi
  80022f:	89 f8                	mov    %edi,%eax
  800231:	29 d8                	sub    %ebx,%eax
  800233:	50                   	push   %eax
  800234:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800237:	50                   	push   %eax
  800238:	e8 7a 05 00 00       	call   8007b7 <vsnprintf>
  80023d:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80023f:	83 c4 0c             	add    $0xc,%esp
  800242:	68 c3 25 80 00       	push   $0x8025c3
  800247:	29 df                	sub    %ebx,%edi
  800249:	57                   	push   %edi
  80024a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80024d:	50                   	push   %eax
  80024e:	e8 b9 05 00 00       	call   80080c <snprintf>
	sys_cputs(buf, r);
  800253:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800256:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800258:	53                   	push   %ebx
  800259:	56                   	push   %esi
  80025a:	e8 12 09 00 00       	call   800b71 <sys_cputs>
  80025f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800262:	cc                   	int3   
  800263:	eb fd                	jmp    800262 <_panic+0x7c>

00800265 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	57                   	push   %edi
  800269:	56                   	push   %esi
  80026a:	53                   	push   %ebx
  80026b:	83 ec 1c             	sub    $0x1c,%esp
  80026e:	89 c7                	mov    %eax,%edi
  800270:	89 d6                	mov    %edx,%esi
  800272:	8b 45 08             	mov    0x8(%ebp),%eax
  800275:	8b 55 0c             	mov    0xc(%ebp),%edx
  800278:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80027e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800281:	bb 00 00 00 00       	mov    $0x0,%ebx
  800286:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800289:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80028c:	39 d3                	cmp    %edx,%ebx
  80028e:	72 05                	jb     800295 <printnum+0x30>
  800290:	39 45 10             	cmp    %eax,0x10(%ebp)
  800293:	77 78                	ja     80030d <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	ff 75 18             	pushl  0x18(%ebp)
  80029b:	8b 45 14             	mov    0x14(%ebp),%eax
  80029e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002a1:	53                   	push   %ebx
  8002a2:	ff 75 10             	pushl  0x10(%ebp)
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b4:	e8 3b 1c 00 00       	call   801ef4 <__udivdi3>
  8002b9:	83 c4 18             	add    $0x18,%esp
  8002bc:	52                   	push   %edx
  8002bd:	50                   	push   %eax
  8002be:	89 f2                	mov    %esi,%edx
  8002c0:	89 f8                	mov    %edi,%eax
  8002c2:	e8 9e ff ff ff       	call   800265 <printnum>
  8002c7:	83 c4 20             	add    $0x20,%esp
  8002ca:	eb 11                	jmp    8002dd <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	56                   	push   %esi
  8002d0:	ff 75 18             	pushl  0x18(%ebp)
  8002d3:	ff d7                	call   *%edi
  8002d5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002d8:	4b                   	dec    %ebx
  8002d9:	85 db                	test   %ebx,%ebx
  8002db:	7f ef                	jg     8002cc <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	56                   	push   %esi
  8002e1:	83 ec 04             	sub    $0x4,%esp
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ea:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f0:	e8 0f 1d 00 00       	call   802004 <__umoddi3>
  8002f5:	83 c4 14             	add    $0x14,%esp
  8002f8:	0f be 80 cb 21 80 00 	movsbl 0x8021cb(%eax),%eax
  8002ff:	50                   	push   %eax
  800300:	ff d7                	call   *%edi
}
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800308:	5b                   	pop    %ebx
  800309:	5e                   	pop    %esi
  80030a:	5f                   	pop    %edi
  80030b:	5d                   	pop    %ebp
  80030c:	c3                   	ret    
  80030d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800310:	eb c6                	jmp    8002d8 <printnum+0x73>

00800312 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800318:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80031b:	8b 10                	mov    (%eax),%edx
  80031d:	3b 50 04             	cmp    0x4(%eax),%edx
  800320:	73 0a                	jae    80032c <sprintputch+0x1a>
		*b->buf++ = ch;
  800322:	8d 4a 01             	lea    0x1(%edx),%ecx
  800325:	89 08                	mov    %ecx,(%eax)
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	88 02                	mov    %al,(%edx)
}
  80032c:	5d                   	pop    %ebp
  80032d:	c3                   	ret    

0080032e <printfmt>:
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800334:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800337:	50                   	push   %eax
  800338:	ff 75 10             	pushl  0x10(%ebp)
  80033b:	ff 75 0c             	pushl  0xc(%ebp)
  80033e:	ff 75 08             	pushl  0x8(%ebp)
  800341:	e8 05 00 00 00       	call   80034b <vprintfmt>
}
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	c9                   	leave  
  80034a:	c3                   	ret    

0080034b <vprintfmt>:
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	57                   	push   %edi
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
  800351:	83 ec 2c             	sub    $0x2c,%esp
  800354:	8b 75 08             	mov    0x8(%ebp),%esi
  800357:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80035a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80035d:	e9 ae 03 00 00       	jmp    800710 <vprintfmt+0x3c5>
  800362:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800366:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80036d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800374:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80037b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800380:	8d 47 01             	lea    0x1(%edi),%eax
  800383:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800386:	8a 17                	mov    (%edi),%dl
  800388:	8d 42 dd             	lea    -0x23(%edx),%eax
  80038b:	3c 55                	cmp    $0x55,%al
  80038d:	0f 87 fe 03 00 00    	ja     800791 <vprintfmt+0x446>
  800393:	0f b6 c0             	movzbl %al,%eax
  800396:	ff 24 85 00 23 80 00 	jmp    *0x802300(,%eax,4)
  80039d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a0:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003a4:	eb da                	jmp    800380 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a9:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003ad:	eb d1                	jmp    800380 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	0f b6 d2             	movzbl %dl,%edx
  8003b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003bd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8003c6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003cc:	83 f9 09             	cmp    $0x9,%ecx
  8003cf:	77 52                	ja     800423 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8003d1:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8003d2:	eb e9                	jmp    8003bd <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8003d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003df:	8d 40 04             	lea    0x4(%eax),%eax
  8003e2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ec:	79 92                	jns    800380 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003fb:	eb 83                	jmp    800380 <vprintfmt+0x35>
  8003fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800401:	78 08                	js     80040b <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800406:	e9 75 ff ff ff       	jmp    800380 <vprintfmt+0x35>
  80040b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800412:	eb ef                	jmp    800403 <vprintfmt+0xb8>
  800414:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800417:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80041e:	e9 5d ff ff ff       	jmp    800380 <vprintfmt+0x35>
  800423:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800426:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800429:	eb bd                	jmp    8003e8 <vprintfmt+0x9d>
			lflag++;
  80042b:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80042f:	e9 4c ff ff ff       	jmp    800380 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8d 78 04             	lea    0x4(%eax),%edi
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	53                   	push   %ebx
  80043e:	ff 30                	pushl  (%eax)
  800440:	ff d6                	call   *%esi
			break;
  800442:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800445:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800448:	e9 c0 02 00 00       	jmp    80070d <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 78 04             	lea    0x4(%eax),%edi
  800453:	8b 00                	mov    (%eax),%eax
  800455:	85 c0                	test   %eax,%eax
  800457:	78 2a                	js     800483 <vprintfmt+0x138>
  800459:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045b:	83 f8 0f             	cmp    $0xf,%eax
  80045e:	7f 27                	jg     800487 <vprintfmt+0x13c>
  800460:	8b 04 85 60 24 80 00 	mov    0x802460(,%eax,4),%eax
  800467:	85 c0                	test   %eax,%eax
  800469:	74 1c                	je     800487 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80046b:	50                   	push   %eax
  80046c:	68 91 25 80 00       	push   $0x802591
  800471:	53                   	push   %ebx
  800472:	56                   	push   %esi
  800473:	e8 b6 fe ff ff       	call   80032e <printfmt>
  800478:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80047e:	e9 8a 02 00 00       	jmp    80070d <vprintfmt+0x3c2>
  800483:	f7 d8                	neg    %eax
  800485:	eb d2                	jmp    800459 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800487:	52                   	push   %edx
  800488:	68 e3 21 80 00       	push   $0x8021e3
  80048d:	53                   	push   %ebx
  80048e:	56                   	push   %esi
  80048f:	e8 9a fe ff ff       	call   80032e <printfmt>
  800494:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800497:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80049a:	e9 6e 02 00 00       	jmp    80070d <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8b 38                	mov    (%eax),%edi
  8004ad:	85 ff                	test   %edi,%edi
  8004af:	74 39                	je     8004ea <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8004b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b5:	0f 8e a9 00 00 00    	jle    800564 <vprintfmt+0x219>
  8004bb:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004bf:	0f 84 a7 00 00 00    	je     80056c <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	ff 75 d0             	pushl  -0x30(%ebp)
  8004cb:	57                   	push   %edi
  8004cc:	e8 6b 03 00 00       	call   80083c <strnlen>
  8004d1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d4:	29 c1                	sub    %eax,%ecx
  8004d6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004d9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004dc:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004e6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e8:	eb 14                	jmp    8004fe <vprintfmt+0x1b3>
				p = "(null)";
  8004ea:	bf dc 21 80 00       	mov    $0x8021dc,%edi
  8004ef:	eb c0                	jmp    8004b1 <vprintfmt+0x166>
					putch(padc, putdat);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	53                   	push   %ebx
  8004f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fa:	4f                   	dec    %edi
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	85 ff                	test   %edi,%edi
  800500:	7f ef                	jg     8004f1 <vprintfmt+0x1a6>
  800502:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800505:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800508:	89 c8                	mov    %ecx,%eax
  80050a:	85 c9                	test   %ecx,%ecx
  80050c:	78 10                	js     80051e <vprintfmt+0x1d3>
  80050e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800511:	29 c1                	sub    %eax,%ecx
  800513:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800516:	89 75 08             	mov    %esi,0x8(%ebp)
  800519:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80051c:	eb 15                	jmp    800533 <vprintfmt+0x1e8>
  80051e:	b8 00 00 00 00       	mov    $0x0,%eax
  800523:	eb e9                	jmp    80050e <vprintfmt+0x1c3>
					putch(ch, putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	53                   	push   %ebx
  800529:	52                   	push   %edx
  80052a:	ff 55 08             	call   *0x8(%ebp)
  80052d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800530:	ff 4d e0             	decl   -0x20(%ebp)
  800533:	47                   	inc    %edi
  800534:	8a 47 ff             	mov    -0x1(%edi),%al
  800537:	0f be d0             	movsbl %al,%edx
  80053a:	85 d2                	test   %edx,%edx
  80053c:	74 59                	je     800597 <vprintfmt+0x24c>
  80053e:	85 f6                	test   %esi,%esi
  800540:	78 03                	js     800545 <vprintfmt+0x1fa>
  800542:	4e                   	dec    %esi
  800543:	78 2f                	js     800574 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800545:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800549:	74 da                	je     800525 <vprintfmt+0x1da>
  80054b:	0f be c0             	movsbl %al,%eax
  80054e:	83 e8 20             	sub    $0x20,%eax
  800551:	83 f8 5e             	cmp    $0x5e,%eax
  800554:	76 cf                	jbe    800525 <vprintfmt+0x1da>
					putch('?', putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	53                   	push   %ebx
  80055a:	6a 3f                	push   $0x3f
  80055c:	ff 55 08             	call   *0x8(%ebp)
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	eb cc                	jmp    800530 <vprintfmt+0x1e5>
  800564:	89 75 08             	mov    %esi,0x8(%ebp)
  800567:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80056a:	eb c7                	jmp    800533 <vprintfmt+0x1e8>
  80056c:	89 75 08             	mov    %esi,0x8(%ebp)
  80056f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800572:	eb bf                	jmp    800533 <vprintfmt+0x1e8>
  800574:	8b 75 08             	mov    0x8(%ebp),%esi
  800577:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80057a:	eb 0c                	jmp    800588 <vprintfmt+0x23d>
				putch(' ', putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	6a 20                	push   $0x20
  800582:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800584:	4f                   	dec    %edi
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	85 ff                	test   %edi,%edi
  80058a:	7f f0                	jg     80057c <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80058c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80058f:	89 45 14             	mov    %eax,0x14(%ebp)
  800592:	e9 76 01 00 00       	jmp    80070d <vprintfmt+0x3c2>
  800597:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80059a:	8b 75 08             	mov    0x8(%ebp),%esi
  80059d:	eb e9                	jmp    800588 <vprintfmt+0x23d>
	if (lflag >= 2)
  80059f:	83 f9 01             	cmp    $0x1,%ecx
  8005a2:	7f 1f                	jg     8005c3 <vprintfmt+0x278>
	else if (lflag)
  8005a4:	85 c9                	test   %ecx,%ecx
  8005a6:	75 48                	jne    8005f0 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b0:	89 c1                	mov    %eax,%ecx
  8005b2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c1:	eb 17                	jmp    8005da <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8b 50 04             	mov    0x4(%eax),%edx
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8d 40 08             	lea    0x8(%eax),%eax
  8005d7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005dd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8005e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e4:	78 25                	js     80060b <vprintfmt+0x2c0>
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005eb:	e9 03 01 00 00       	jmp    8006f3 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	89 c1                	mov    %eax,%ecx
  8005fa:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 40 04             	lea    0x4(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
  800609:	eb cf                	jmp    8005da <vprintfmt+0x28f>
				putch('-', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	6a 2d                	push   $0x2d
  800611:	ff d6                	call   *%esi
				num = -(long long) num;
  800613:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800616:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800619:	f7 da                	neg    %edx
  80061b:	83 d1 00             	adc    $0x0,%ecx
  80061e:	f7 d9                	neg    %ecx
  800620:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800623:	b8 0a 00 00 00       	mov    $0xa,%eax
  800628:	e9 c6 00 00 00       	jmp    8006f3 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80062d:	83 f9 01             	cmp    $0x1,%ecx
  800630:	7f 1e                	jg     800650 <vprintfmt+0x305>
	else if (lflag)
  800632:	85 c9                	test   %ecx,%ecx
  800634:	75 32                	jne    800668 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 10                	mov    (%eax),%edx
  80063b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800640:	8d 40 04             	lea    0x4(%eax),%eax
  800643:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800646:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064b:	e9 a3 00 00 00       	jmp    8006f3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8b 10                	mov    (%eax),%edx
  800655:	8b 48 04             	mov    0x4(%eax),%ecx
  800658:	8d 40 08             	lea    0x8(%eax),%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800663:	e9 8b 00 00 00       	jmp    8006f3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 10                	mov    (%eax),%edx
  80066d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800672:	8d 40 04             	lea    0x4(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800678:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067d:	eb 74                	jmp    8006f3 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80067f:	83 f9 01             	cmp    $0x1,%ecx
  800682:	7f 1b                	jg     80069f <vprintfmt+0x354>
	else if (lflag)
  800684:	85 c9                	test   %ecx,%ecx
  800686:	75 2c                	jne    8006b4 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800692:	8d 40 04             	lea    0x4(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800698:	b8 08 00 00 00       	mov    $0x8,%eax
  80069d:	eb 54                	jmp    8006f3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8b 10                	mov    (%eax),%edx
  8006a4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a7:	8d 40 08             	lea    0x8(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ad:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b2:	eb 3f                	jmp    8006f3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 10                	mov    (%eax),%edx
  8006b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006be:	8d 40 04             	lea    0x4(%eax),%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c9:	eb 28                	jmp    8006f3 <vprintfmt+0x3a8>
			putch('0', putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	6a 30                	push   $0x30
  8006d1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d3:	83 c4 08             	add    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	6a 78                	push   $0x78
  8006d9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 10                	mov    (%eax),%edx
  8006e0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006e5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e8:	8d 40 04             	lea    0x4(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ee:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f3:	83 ec 0c             	sub    $0xc,%esp
  8006f6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006fa:	57                   	push   %edi
  8006fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fe:	50                   	push   %eax
  8006ff:	51                   	push   %ecx
  800700:	52                   	push   %edx
  800701:	89 da                	mov    %ebx,%edx
  800703:	89 f0                	mov    %esi,%eax
  800705:	e8 5b fb ff ff       	call   800265 <printnum>
			break;
  80070a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80070d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800710:	47                   	inc    %edi
  800711:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800715:	83 f8 25             	cmp    $0x25,%eax
  800718:	0f 84 44 fc ff ff    	je     800362 <vprintfmt+0x17>
			if (ch == '\0')
  80071e:	85 c0                	test   %eax,%eax
  800720:	0f 84 89 00 00 00    	je     8007af <vprintfmt+0x464>
			putch(ch, putdat);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	53                   	push   %ebx
  80072a:	50                   	push   %eax
  80072b:	ff d6                	call   *%esi
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb de                	jmp    800710 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800732:	83 f9 01             	cmp    $0x1,%ecx
  800735:	7f 1b                	jg     800752 <vprintfmt+0x407>
	else if (lflag)
  800737:	85 c9                	test   %ecx,%ecx
  800739:	75 2c                	jne    800767 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074b:	b8 10 00 00 00       	mov    $0x10,%eax
  800750:	eb a1                	jmp    8006f3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 10                	mov    (%eax),%edx
  800757:	8b 48 04             	mov    0x4(%eax),%ecx
  80075a:	8d 40 08             	lea    0x8(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800760:	b8 10 00 00 00       	mov    $0x10,%eax
  800765:	eb 8c                	jmp    8006f3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 10                	mov    (%eax),%edx
  80076c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800777:	b8 10 00 00 00       	mov    $0x10,%eax
  80077c:	e9 72 ff ff ff       	jmp    8006f3 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	53                   	push   %ebx
  800785:	6a 25                	push   $0x25
  800787:	ff d6                	call   *%esi
			break;
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	e9 7c ff ff ff       	jmp    80070d <vprintfmt+0x3c2>
			putch('%', putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	53                   	push   %ebx
  800795:	6a 25                	push   $0x25
  800797:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	89 f8                	mov    %edi,%eax
  80079e:	eb 01                	jmp    8007a1 <vprintfmt+0x456>
  8007a0:	48                   	dec    %eax
  8007a1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a5:	75 f9                	jne    8007a0 <vprintfmt+0x455>
  8007a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007aa:	e9 5e ff ff ff       	jmp    80070d <vprintfmt+0x3c2>
}
  8007af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b2:	5b                   	pop    %ebx
  8007b3:	5e                   	pop    %esi
  8007b4:	5f                   	pop    %edi
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007ca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d4:	85 c0                	test   %eax,%eax
  8007d6:	74 26                	je     8007fe <vsnprintf+0x47>
  8007d8:	85 d2                	test   %edx,%edx
  8007da:	7e 29                	jle    800805 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007dc:	ff 75 14             	pushl  0x14(%ebp)
  8007df:	ff 75 10             	pushl  0x10(%ebp)
  8007e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e5:	50                   	push   %eax
  8007e6:	68 12 03 80 00       	push   $0x800312
  8007eb:	e8 5b fb ff ff       	call   80034b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f9:	83 c4 10             	add    $0x10,%esp
}
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    
		return -E_INVAL;
  8007fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800803:	eb f7                	jmp    8007fc <vsnprintf+0x45>
  800805:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080a:	eb f0                	jmp    8007fc <vsnprintf+0x45>

0080080c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800812:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800815:	50                   	push   %eax
  800816:	ff 75 10             	pushl  0x10(%ebp)
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	ff 75 08             	pushl  0x8(%ebp)
  80081f:	e8 93 ff ff ff       	call   8007b7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800824:	c9                   	leave  
  800825:	c3                   	ret    

00800826 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
  800831:	eb 01                	jmp    800834 <strlen+0xe>
		n++;
  800833:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800834:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800838:	75 f9                	jne    800833 <strlen+0xd>
	return n;
}
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800845:	b8 00 00 00 00       	mov    $0x0,%eax
  80084a:	eb 01                	jmp    80084d <strnlen+0x11>
		n++;
  80084c:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80084d:	39 d0                	cmp    %edx,%eax
  80084f:	74 06                	je     800857 <strnlen+0x1b>
  800851:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800855:	75 f5                	jne    80084c <strnlen+0x10>
	return n;
}
  800857:	5d                   	pop    %ebp
  800858:	c3                   	ret    

00800859 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800863:	89 c2                	mov    %eax,%edx
  800865:	42                   	inc    %edx
  800866:	41                   	inc    %ecx
  800867:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80086a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80086d:	84 db                	test   %bl,%bl
  80086f:	75 f4                	jne    800865 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800871:	5b                   	pop    %ebx
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	53                   	push   %ebx
  800878:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80087b:	53                   	push   %ebx
  80087c:	e8 a5 ff ff ff       	call   800826 <strlen>
  800881:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	01 d8                	add    %ebx,%eax
  800889:	50                   	push   %eax
  80088a:	e8 ca ff ff ff       	call   800859 <strcpy>
	return dst;
}
  80088f:	89 d8                	mov    %ebx,%eax
  800891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	8b 75 08             	mov    0x8(%ebp),%esi
  80089e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a1:	89 f3                	mov    %esi,%ebx
  8008a3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a6:	89 f2                	mov    %esi,%edx
  8008a8:	eb 0c                	jmp    8008b6 <strncpy+0x20>
		*dst++ = *src;
  8008aa:	42                   	inc    %edx
  8008ab:	8a 01                	mov    (%ecx),%al
  8008ad:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b0:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b6:	39 da                	cmp    %ebx,%edx
  8008b8:	75 f0                	jne    8008aa <strncpy+0x14>
	}
	return ret;
}
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	5b                   	pop    %ebx
  8008bd:	5e                   	pop    %esi
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	56                   	push   %esi
  8008c4:	53                   	push   %ebx
  8008c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cb:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ce:	85 c0                	test   %eax,%eax
  8008d0:	74 20                	je     8008f2 <strlcpy+0x32>
  8008d2:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8008d6:	89 f0                	mov    %esi,%eax
  8008d8:	eb 05                	jmp    8008df <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008da:	40                   	inc    %eax
  8008db:	42                   	inc    %edx
  8008dc:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008df:	39 d8                	cmp    %ebx,%eax
  8008e1:	74 06                	je     8008e9 <strlcpy+0x29>
  8008e3:	8a 0a                	mov    (%edx),%cl
  8008e5:	84 c9                	test   %cl,%cl
  8008e7:	75 f1                	jne    8008da <strlcpy+0x1a>
		*dst = '\0';
  8008e9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ec:	29 f0                	sub    %esi,%eax
}
  8008ee:	5b                   	pop    %ebx
  8008ef:	5e                   	pop    %esi
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    
  8008f2:	89 f0                	mov    %esi,%eax
  8008f4:	eb f6                	jmp    8008ec <strlcpy+0x2c>

008008f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ff:	eb 02                	jmp    800903 <strcmp+0xd>
		p++, q++;
  800901:	41                   	inc    %ecx
  800902:	42                   	inc    %edx
	while (*p && *p == *q)
  800903:	8a 01                	mov    (%ecx),%al
  800905:	84 c0                	test   %al,%al
  800907:	74 04                	je     80090d <strcmp+0x17>
  800909:	3a 02                	cmp    (%edx),%al
  80090b:	74 f4                	je     800901 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80090d:	0f b6 c0             	movzbl %al,%eax
  800910:	0f b6 12             	movzbl (%edx),%edx
  800913:	29 d0                	sub    %edx,%eax
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	89 c3                	mov    %eax,%ebx
  800923:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800926:	eb 02                	jmp    80092a <strncmp+0x13>
		n--, p++, q++;
  800928:	40                   	inc    %eax
  800929:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  80092a:	39 d8                	cmp    %ebx,%eax
  80092c:	74 15                	je     800943 <strncmp+0x2c>
  80092e:	8a 08                	mov    (%eax),%cl
  800930:	84 c9                	test   %cl,%cl
  800932:	74 04                	je     800938 <strncmp+0x21>
  800934:	3a 0a                	cmp    (%edx),%cl
  800936:	74 f0                	je     800928 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 00             	movzbl (%eax),%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
}
  800940:	5b                   	pop    %ebx
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    
		return 0;
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
  800948:	eb f6                	jmp    800940 <strncmp+0x29>

0080094a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800953:	8a 10                	mov    (%eax),%dl
  800955:	84 d2                	test   %dl,%dl
  800957:	74 07                	je     800960 <strchr+0x16>
		if (*s == c)
  800959:	38 ca                	cmp    %cl,%dl
  80095b:	74 08                	je     800965 <strchr+0x1b>
	for (; *s; s++)
  80095d:	40                   	inc    %eax
  80095e:	eb f3                	jmp    800953 <strchr+0x9>
			return (char *) s;
	return 0;
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800970:	8a 10                	mov    (%eax),%dl
  800972:	84 d2                	test   %dl,%dl
  800974:	74 07                	je     80097d <strfind+0x16>
		if (*s == c)
  800976:	38 ca                	cmp    %cl,%dl
  800978:	74 03                	je     80097d <strfind+0x16>
	for (; *s; s++)
  80097a:	40                   	inc    %eax
  80097b:	eb f3                	jmp    800970 <strfind+0x9>
			break;
	return (char *) s;
}
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	57                   	push   %edi
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	8b 7d 08             	mov    0x8(%ebp),%edi
  800988:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80098b:	85 c9                	test   %ecx,%ecx
  80098d:	74 13                	je     8009a2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80098f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800995:	75 05                	jne    80099c <memset+0x1d>
  800997:	f6 c1 03             	test   $0x3,%cl
  80099a:	74 0d                	je     8009a9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80099c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099f:	fc                   	cld    
  8009a0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009a2:	89 f8                	mov    %edi,%eax
  8009a4:	5b                   	pop    %ebx
  8009a5:	5e                   	pop    %esi
  8009a6:	5f                   	pop    %edi
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    
		c &= 0xFF;
  8009a9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ad:	89 d3                	mov    %edx,%ebx
  8009af:	c1 e3 08             	shl    $0x8,%ebx
  8009b2:	89 d0                	mov    %edx,%eax
  8009b4:	c1 e0 18             	shl    $0x18,%eax
  8009b7:	89 d6                	mov    %edx,%esi
  8009b9:	c1 e6 10             	shl    $0x10,%esi
  8009bc:	09 f0                	or     %esi,%eax
  8009be:	09 c2                	or     %eax,%edx
  8009c0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009c2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	fc                   	cld    
  8009c8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ca:	eb d6                	jmp    8009a2 <memset+0x23>

008009cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	57                   	push   %edi
  8009d0:	56                   	push   %esi
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009da:	39 c6                	cmp    %eax,%esi
  8009dc:	73 33                	jae    800a11 <memmove+0x45>
  8009de:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e1:	39 d0                	cmp    %edx,%eax
  8009e3:	73 2c                	jae    800a11 <memmove+0x45>
		s += n;
		d += n;
  8009e5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e8:	89 d6                	mov    %edx,%esi
  8009ea:	09 fe                	or     %edi,%esi
  8009ec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f2:	75 13                	jne    800a07 <memmove+0x3b>
  8009f4:	f6 c1 03             	test   $0x3,%cl
  8009f7:	75 0e                	jne    800a07 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f9:	83 ef 04             	sub    $0x4,%edi
  8009fc:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009ff:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a02:	fd                   	std    
  800a03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a05:	eb 07                	jmp    800a0e <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a07:	4f                   	dec    %edi
  800a08:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0b:	fd                   	std    
  800a0c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a0e:	fc                   	cld    
  800a0f:	eb 13                	jmp    800a24 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a11:	89 f2                	mov    %esi,%edx
  800a13:	09 c2                	or     %eax,%edx
  800a15:	f6 c2 03             	test   $0x3,%dl
  800a18:	75 05                	jne    800a1f <memmove+0x53>
  800a1a:	f6 c1 03             	test   $0x3,%cl
  800a1d:	74 09                	je     800a28 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a1f:	89 c7                	mov    %eax,%edi
  800a21:	fc                   	cld    
  800a22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a24:	5e                   	pop    %esi
  800a25:	5f                   	pop    %edi
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a2b:	89 c7                	mov    %eax,%edi
  800a2d:	fc                   	cld    
  800a2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a30:	eb f2                	jmp    800a24 <memmove+0x58>

00800a32 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a35:	ff 75 10             	pushl  0x10(%ebp)
  800a38:	ff 75 0c             	pushl  0xc(%ebp)
  800a3b:	ff 75 08             	pushl  0x8(%ebp)
  800a3e:	e8 89 ff ff ff       	call   8009cc <memmove>
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	56                   	push   %esi
  800a49:	53                   	push   %ebx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	89 c6                	mov    %eax,%esi
  800a4f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a55:	39 f0                	cmp    %esi,%eax
  800a57:	74 16                	je     800a6f <memcmp+0x2a>
		if (*s1 != *s2)
  800a59:	8a 08                	mov    (%eax),%cl
  800a5b:	8a 1a                	mov    (%edx),%bl
  800a5d:	38 d9                	cmp    %bl,%cl
  800a5f:	75 04                	jne    800a65 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a61:	40                   	inc    %eax
  800a62:	42                   	inc    %edx
  800a63:	eb f0                	jmp    800a55 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a65:	0f b6 c1             	movzbl %cl,%eax
  800a68:	0f b6 db             	movzbl %bl,%ebx
  800a6b:	29 d8                	sub    %ebx,%eax
  800a6d:	eb 05                	jmp    800a74 <memcmp+0x2f>
	}

	return 0;
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a74:	5b                   	pop    %ebx
  800a75:	5e                   	pop    %esi
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a81:	89 c2                	mov    %eax,%edx
  800a83:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a86:	39 d0                	cmp    %edx,%eax
  800a88:	73 07                	jae    800a91 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a8a:	38 08                	cmp    %cl,(%eax)
  800a8c:	74 03                	je     800a91 <memfind+0x19>
	for (; s < ends; s++)
  800a8e:	40                   	inc    %eax
  800a8f:	eb f5                	jmp    800a86 <memfind+0xe>
			break;
	return (void *) s;
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	57                   	push   %edi
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9c:	eb 01                	jmp    800a9f <strtol+0xc>
		s++;
  800a9e:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a9f:	8a 01                	mov    (%ecx),%al
  800aa1:	3c 20                	cmp    $0x20,%al
  800aa3:	74 f9                	je     800a9e <strtol+0xb>
  800aa5:	3c 09                	cmp    $0x9,%al
  800aa7:	74 f5                	je     800a9e <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800aa9:	3c 2b                	cmp    $0x2b,%al
  800aab:	74 2b                	je     800ad8 <strtol+0x45>
		s++;
	else if (*s == '-')
  800aad:	3c 2d                	cmp    $0x2d,%al
  800aaf:	74 2f                	je     800ae0 <strtol+0x4d>
	int neg = 0;
  800ab1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab6:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800abd:	75 12                	jne    800ad1 <strtol+0x3e>
  800abf:	80 39 30             	cmpb   $0x30,(%ecx)
  800ac2:	74 24                	je     800ae8 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ac4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac8:	75 07                	jne    800ad1 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	eb 4e                	jmp    800b26 <strtol+0x93>
		s++;
  800ad8:	41                   	inc    %ecx
	int neg = 0;
  800ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ade:	eb d6                	jmp    800ab6 <strtol+0x23>
		s++, neg = 1;
  800ae0:	41                   	inc    %ecx
  800ae1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae6:	eb ce                	jmp    800ab6 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aec:	74 10                	je     800afe <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800aee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af2:	75 dd                	jne    800ad1 <strtol+0x3e>
		s++, base = 8;
  800af4:	41                   	inc    %ecx
  800af5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800afc:	eb d3                	jmp    800ad1 <strtol+0x3e>
		s += 2, base = 16;
  800afe:	83 c1 02             	add    $0x2,%ecx
  800b01:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800b08:	eb c7                	jmp    800ad1 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b0a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b0d:	89 f3                	mov    %esi,%ebx
  800b0f:	80 fb 19             	cmp    $0x19,%bl
  800b12:	77 24                	ja     800b38 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800b14:	0f be d2             	movsbl %dl,%edx
  800b17:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b1a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1d:	7d 2b                	jge    800b4a <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800b1f:	41                   	inc    %ecx
  800b20:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b26:	8a 11                	mov    (%ecx),%dl
  800b28:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b2b:	80 fb 09             	cmp    $0x9,%bl
  800b2e:	77 da                	ja     800b0a <strtol+0x77>
			dig = *s - '0';
  800b30:	0f be d2             	movsbl %dl,%edx
  800b33:	83 ea 30             	sub    $0x30,%edx
  800b36:	eb e2                	jmp    800b1a <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b38:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b3b:	89 f3                	mov    %esi,%ebx
  800b3d:	80 fb 19             	cmp    $0x19,%bl
  800b40:	77 08                	ja     800b4a <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b42:	0f be d2             	movsbl %dl,%edx
  800b45:	83 ea 37             	sub    $0x37,%edx
  800b48:	eb d0                	jmp    800b1a <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4e:	74 05                	je     800b55 <strtol+0xc2>
		*endptr = (char *) s;
  800b50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b53:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b55:	85 ff                	test   %edi,%edi
  800b57:	74 02                	je     800b5b <strtol+0xc8>
  800b59:	f7 d8                	neg    %eax
}
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5f                   	pop    %edi
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <atoi>:

int
atoi(const char *s)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b63:	6a 0a                	push   $0xa
  800b65:	6a 00                	push   $0x0
  800b67:	ff 75 08             	pushl  0x8(%ebp)
  800b6a:	e8 24 ff ff ff       	call   800a93 <strtol>
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	57                   	push   %edi
  800b75:	56                   	push   %esi
  800b76:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b77:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b82:	89 c3                	mov    %eax,%ebx
  800b84:	89 c7                	mov    %eax,%edi
  800b86:	89 c6                	mov    %eax,%esi
  800b88:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b95:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b9f:	89 d1                	mov    %edx,%ecx
  800ba1:	89 d3                	mov    %edx,%ebx
  800ba3:	89 d7                	mov    %edx,%edi
  800ba5:	89 d6                	mov    %edx,%esi
  800ba7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
  800bb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bbc:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	89 cb                	mov    %ecx,%ebx
  800bc6:	89 cf                	mov    %ecx,%edi
  800bc8:	89 ce                	mov    %ecx,%esi
  800bca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bcc:	85 c0                	test   %eax,%eax
  800bce:	7f 08                	jg     800bd8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd3:	5b                   	pop    %ebx
  800bd4:	5e                   	pop    %esi
  800bd5:	5f                   	pop    %edi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd8:	83 ec 0c             	sub    $0xc,%esp
  800bdb:	50                   	push   %eax
  800bdc:	6a 03                	push   $0x3
  800bde:	68 bf 24 80 00       	push   $0x8024bf
  800be3:	6a 23                	push   $0x23
  800be5:	68 dc 24 80 00       	push   $0x8024dc
  800bea:	e8 f7 f5 ff ff       	call   8001e6 <_panic>

00800bef <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfa:	b8 02 00 00 00       	mov    $0x2,%eax
  800bff:	89 d1                	mov    %edx,%ecx
  800c01:	89 d3                	mov    %edx,%ebx
  800c03:	89 d7                	mov    %edx,%edi
  800c05:	89 d6                	mov    %edx,%esi
  800c07:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5e                   	pop    %esi
  800c0b:	5f                   	pop    %edi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c17:	be 00 00 00 00       	mov    $0x0,%esi
  800c1c:	b8 04 00 00 00       	mov    $0x4,%eax
  800c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2a:	89 f7                	mov    %esi,%edi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	50                   	push   %eax
  800c3e:	6a 04                	push   $0x4
  800c40:	68 bf 24 80 00       	push   $0x8024bf
  800c45:	6a 23                	push   $0x23
  800c47:	68 dc 24 80 00       	push   $0x8024dc
  800c4c:	e8 95 f5 ff ff       	call   8001e6 <_panic>

00800c51 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	57                   	push   %edi
  800c55:	56                   	push   %esi
  800c56:	53                   	push   %ebx
  800c57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c68:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c6b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c70:	85 c0                	test   %eax,%eax
  800c72:	7f 08                	jg     800c7c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c77:	5b                   	pop    %ebx
  800c78:	5e                   	pop    %esi
  800c79:	5f                   	pop    %edi
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7c:	83 ec 0c             	sub    $0xc,%esp
  800c7f:	50                   	push   %eax
  800c80:	6a 05                	push   $0x5
  800c82:	68 bf 24 80 00       	push   $0x8024bf
  800c87:	6a 23                	push   $0x23
  800c89:	68 dc 24 80 00       	push   $0x8024dc
  800c8e:	e8 53 f5 ff ff       	call   8001e6 <_panic>

00800c93 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca1:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	89 df                	mov    %ebx,%edi
  800cae:	89 de                	mov    %ebx,%esi
  800cb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	7f 08                	jg     800cbe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbe:	83 ec 0c             	sub    $0xc,%esp
  800cc1:	50                   	push   %eax
  800cc2:	6a 06                	push   $0x6
  800cc4:	68 bf 24 80 00       	push   $0x8024bf
  800cc9:	6a 23                	push   $0x23
  800ccb:	68 dc 24 80 00       	push   $0x8024dc
  800cd0:	e8 11 f5 ff ff       	call   8001e6 <_panic>

00800cd5 <sys_yield>:

void
sys_yield(void)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce5:	89 d1                	mov    %edx,%ecx
  800ce7:	89 d3                	mov    %edx,%ebx
  800ce9:	89 d7                	mov    %edx,%edi
  800ceb:	89 d6                	mov    %edx,%esi
  800ced:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d02:	b8 08 00 00 00       	mov    $0x8,%eax
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	89 df                	mov    %ebx,%edi
  800d0f:	89 de                	mov    %ebx,%esi
  800d11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7f 08                	jg     800d1f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	50                   	push   %eax
  800d23:	6a 08                	push   $0x8
  800d25:	68 bf 24 80 00       	push   $0x8024bf
  800d2a:	6a 23                	push   $0x23
  800d2c:	68 dc 24 80 00       	push   $0x8024dc
  800d31:	e8 b0 f4 ff ff       	call   8001e6 <_panic>

00800d36 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d44:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	89 cb                	mov    %ecx,%ebx
  800d4e:	89 cf                	mov    %ecx,%edi
  800d50:	89 ce                	mov    %ecx,%esi
  800d52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7f 08                	jg     800d60 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	83 ec 0c             	sub    $0xc,%esp
  800d63:	50                   	push   %eax
  800d64:	6a 0c                	push   $0xc
  800d66:	68 bf 24 80 00       	push   $0x8024bf
  800d6b:	6a 23                	push   $0x23
  800d6d:	68 dc 24 80 00       	push   $0x8024dc
  800d72:	e8 6f f4 ff ff       	call   8001e6 <_panic>

00800d77 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d85:	b8 09 00 00 00       	mov    $0x9,%eax
  800d8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d90:	89 df                	mov    %ebx,%edi
  800d92:	89 de                	mov    %ebx,%esi
  800d94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	83 ec 0c             	sub    $0xc,%esp
  800da5:	50                   	push   %eax
  800da6:	6a 09                	push   $0x9
  800da8:	68 bf 24 80 00       	push   $0x8024bf
  800dad:	6a 23                	push   $0x23
  800daf:	68 dc 24 80 00       	push   $0x8024dc
  800db4:	e8 2d f4 ff ff       	call   8001e6 <_panic>

00800db9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd2:	89 df                	mov    %ebx,%edi
  800dd4:	89 de                	mov    %ebx,%esi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 0a                	push   $0xa
  800dea:	68 bf 24 80 00       	push   $0x8024bf
  800def:	6a 23                	push   $0x23
  800df1:	68 dc 24 80 00       	push   $0x8024dc
  800df6:	e8 eb f3 ff ff       	call   8001e6 <_panic>

00800dfb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e01:	be 00 00 00 00       	mov    $0x0,%esi
  800e06:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e14:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e17:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	89 cb                	mov    %ecx,%ebx
  800e36:	89 cf                	mov    %ecx,%edi
  800e38:	89 ce                	mov    %ecx,%esi
  800e3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7f 08                	jg     800e48 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	50                   	push   %eax
  800e4c:	6a 0e                	push   $0xe
  800e4e:	68 bf 24 80 00       	push   $0x8024bf
  800e53:	6a 23                	push   $0x23
  800e55:	68 dc 24 80 00       	push   $0x8024dc
  800e5a:	e8 87 f3 ff ff       	call   8001e6 <_panic>

00800e5f <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	57                   	push   %edi
  800e63:	56                   	push   %esi
  800e64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e65:	be 00 00 00 00       	mov    $0x0,%esi
  800e6a:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e78:	89 f7                	mov    %esi,%edi
  800e7a:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	57                   	push   %edi
  800e85:	56                   	push   %esi
  800e86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e87:	be 00 00 00 00       	mov    $0x0,%esi
  800e8c:	b8 10 00 00 00       	mov    $0x10,%eax
  800e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9a:	89 f7                	mov    %esi,%edi
  800e9c:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eae:	b8 11 00 00 00       	mov    $0x11,%eax
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	89 cb                	mov    %ecx,%ebx
  800eb8:	89 cf                	mov    %ecx,%edi
  800eba:	89 ce                	mov    %ecx,%esi
  800ebc:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	05 00 00 00 30       	add    $0x30000000,%eax
  800ece:	c1 e8 0c             	shr    $0xc,%eax
}
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ede:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ee3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ef5:	89 c2                	mov    %eax,%edx
  800ef7:	c1 ea 16             	shr    $0x16,%edx
  800efa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f01:	f6 c2 01             	test   $0x1,%dl
  800f04:	74 2a                	je     800f30 <fd_alloc+0x46>
  800f06:	89 c2                	mov    %eax,%edx
  800f08:	c1 ea 0c             	shr    $0xc,%edx
  800f0b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f12:	f6 c2 01             	test   $0x1,%dl
  800f15:	74 19                	je     800f30 <fd_alloc+0x46>
  800f17:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f1c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f21:	75 d2                	jne    800ef5 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f23:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f29:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f2e:	eb 07                	jmp    800f37 <fd_alloc+0x4d>
			*fd_store = fd;
  800f30:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f3c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800f40:	77 39                	ja     800f7b <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	c1 e0 0c             	shl    $0xc,%eax
  800f48:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f4d:	89 c2                	mov    %eax,%edx
  800f4f:	c1 ea 16             	shr    $0x16,%edx
  800f52:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f59:	f6 c2 01             	test   $0x1,%dl
  800f5c:	74 24                	je     800f82 <fd_lookup+0x49>
  800f5e:	89 c2                	mov    %eax,%edx
  800f60:	c1 ea 0c             	shr    $0xc,%edx
  800f63:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f6a:	f6 c2 01             	test   $0x1,%dl
  800f6d:	74 1a                	je     800f89 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f72:	89 02                	mov    %eax,(%edx)
	return 0;
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    
		return -E_INVAL;
  800f7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f80:	eb f7                	jmp    800f79 <fd_lookup+0x40>
		return -E_INVAL;
  800f82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f87:	eb f0                	jmp    800f79 <fd_lookup+0x40>
  800f89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f8e:	eb e9                	jmp    800f79 <fd_lookup+0x40>

00800f90 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	83 ec 08             	sub    $0x8,%esp
  800f96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f99:	ba 68 25 80 00       	mov    $0x802568,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f9e:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fa3:	39 08                	cmp    %ecx,(%eax)
  800fa5:	74 33                	je     800fda <dev_lookup+0x4a>
  800fa7:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800faa:	8b 02                	mov    (%edx),%eax
  800fac:	85 c0                	test   %eax,%eax
  800fae:	75 f3                	jne    800fa3 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fb0:	a1 08 40 80 00       	mov    0x804008,%eax
  800fb5:	8b 40 48             	mov    0x48(%eax),%eax
  800fb8:	83 ec 04             	sub    $0x4,%esp
  800fbb:	51                   	push   %ecx
  800fbc:	50                   	push   %eax
  800fbd:	68 ec 24 80 00       	push   $0x8024ec
  800fc2:	e8 ae 0d 00 00       	call   801d75 <cprintf>
	*dev = 0;
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fd0:	83 c4 10             	add    $0x10,%esp
  800fd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fd8:	c9                   	leave  
  800fd9:	c3                   	ret    
			*dev = devtab[i];
  800fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe4:	eb f2                	jmp    800fd8 <dev_lookup+0x48>

00800fe6 <fd_close>:
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
  800fec:	83 ec 1c             	sub    $0x1c,%esp
  800fef:	8b 75 08             	mov    0x8(%ebp),%esi
  800ff2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ff5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fff:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801002:	50                   	push   %eax
  801003:	e8 31 ff ff ff       	call   800f39 <fd_lookup>
  801008:	89 c7                	mov    %eax,%edi
  80100a:	83 c4 08             	add    $0x8,%esp
  80100d:	85 c0                	test   %eax,%eax
  80100f:	78 05                	js     801016 <fd_close+0x30>
	    || fd != fd2)
  801011:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801014:	74 13                	je     801029 <fd_close+0x43>
		return (must_exist ? r : 0);
  801016:	84 db                	test   %bl,%bl
  801018:	75 05                	jne    80101f <fd_close+0x39>
  80101a:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80101f:	89 f8                	mov    %edi,%eax
  801021:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80102f:	50                   	push   %eax
  801030:	ff 36                	pushl  (%esi)
  801032:	e8 59 ff ff ff       	call   800f90 <dev_lookup>
  801037:	89 c7                	mov    %eax,%edi
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	85 c0                	test   %eax,%eax
  80103e:	78 15                	js     801055 <fd_close+0x6f>
		if (dev->dev_close)
  801040:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801043:	8b 40 10             	mov    0x10(%eax),%eax
  801046:	85 c0                	test   %eax,%eax
  801048:	74 1b                	je     801065 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80104a:	83 ec 0c             	sub    $0xc,%esp
  80104d:	56                   	push   %esi
  80104e:	ff d0                	call   *%eax
  801050:	89 c7                	mov    %eax,%edi
  801052:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	56                   	push   %esi
  801059:	6a 00                	push   $0x0
  80105b:	e8 33 fc ff ff       	call   800c93 <sys_page_unmap>
	return r;
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	eb ba                	jmp    80101f <fd_close+0x39>
			r = 0;
  801065:	bf 00 00 00 00       	mov    $0x0,%edi
  80106a:	eb e9                	jmp    801055 <fd_close+0x6f>

0080106c <close>:

int
close(int fdnum)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801072:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801075:	50                   	push   %eax
  801076:	ff 75 08             	pushl  0x8(%ebp)
  801079:	e8 bb fe ff ff       	call   800f39 <fd_lookup>
  80107e:	83 c4 08             	add    $0x8,%esp
  801081:	85 c0                	test   %eax,%eax
  801083:	78 10                	js     801095 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	6a 01                	push   $0x1
  80108a:	ff 75 f4             	pushl  -0xc(%ebp)
  80108d:	e8 54 ff ff ff       	call   800fe6 <fd_close>
  801092:	83 c4 10             	add    $0x10,%esp
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <close_all>:

void
close_all(void)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	53                   	push   %ebx
  80109b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80109e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	53                   	push   %ebx
  8010a7:	e8 c0 ff ff ff       	call   80106c <close>
	for (i = 0; i < MAXFD; i++)
  8010ac:	43                   	inc    %ebx
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	83 fb 20             	cmp    $0x20,%ebx
  8010b3:	75 ee                	jne    8010a3 <close_all+0xc>
}
  8010b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	53                   	push   %ebx
  8010c0:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010c6:	50                   	push   %eax
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	e8 6a fe ff ff       	call   800f39 <fd_lookup>
  8010cf:	89 c3                	mov    %eax,%ebx
  8010d1:	83 c4 08             	add    $0x8,%esp
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	0f 88 81 00 00 00    	js     80115d <dup+0xa3>
		return r;
	close(newfdnum);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	ff 75 0c             	pushl  0xc(%ebp)
  8010e2:	e8 85 ff ff ff       	call   80106c <close>

	newfd = INDEX2FD(newfdnum);
  8010e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010ea:	c1 e6 0c             	shl    $0xc,%esi
  8010ed:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010f3:	83 c4 04             	add    $0x4,%esp
  8010f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f9:	e8 d5 fd ff ff       	call   800ed3 <fd2data>
  8010fe:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801100:	89 34 24             	mov    %esi,(%esp)
  801103:	e8 cb fd ff ff       	call   800ed3 <fd2data>
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80110d:	89 d8                	mov    %ebx,%eax
  80110f:	c1 e8 16             	shr    $0x16,%eax
  801112:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801119:	a8 01                	test   $0x1,%al
  80111b:	74 11                	je     80112e <dup+0x74>
  80111d:	89 d8                	mov    %ebx,%eax
  80111f:	c1 e8 0c             	shr    $0xc,%eax
  801122:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801129:	f6 c2 01             	test   $0x1,%dl
  80112c:	75 39                	jne    801167 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80112e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801131:	89 d0                	mov    %edx,%eax
  801133:	c1 e8 0c             	shr    $0xc,%eax
  801136:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	25 07 0e 00 00       	and    $0xe07,%eax
  801145:	50                   	push   %eax
  801146:	56                   	push   %esi
  801147:	6a 00                	push   $0x0
  801149:	52                   	push   %edx
  80114a:	6a 00                	push   $0x0
  80114c:	e8 00 fb ff ff       	call   800c51 <sys_page_map>
  801151:	89 c3                	mov    %eax,%ebx
  801153:	83 c4 20             	add    $0x20,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	78 31                	js     80118b <dup+0xd1>
		goto err;

	return newfdnum;
  80115a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80115d:	89 d8                	mov    %ebx,%eax
  80115f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5f                   	pop    %edi
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801167:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	25 07 0e 00 00       	and    $0xe07,%eax
  801176:	50                   	push   %eax
  801177:	57                   	push   %edi
  801178:	6a 00                	push   $0x0
  80117a:	53                   	push   %ebx
  80117b:	6a 00                	push   $0x0
  80117d:	e8 cf fa ff ff       	call   800c51 <sys_page_map>
  801182:	89 c3                	mov    %eax,%ebx
  801184:	83 c4 20             	add    $0x20,%esp
  801187:	85 c0                	test   %eax,%eax
  801189:	79 a3                	jns    80112e <dup+0x74>
	sys_page_unmap(0, newfd);
  80118b:	83 ec 08             	sub    $0x8,%esp
  80118e:	56                   	push   %esi
  80118f:	6a 00                	push   $0x0
  801191:	e8 fd fa ff ff       	call   800c93 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801196:	83 c4 08             	add    $0x8,%esp
  801199:	57                   	push   %edi
  80119a:	6a 00                	push   $0x0
  80119c:	e8 f2 fa ff ff       	call   800c93 <sys_page_unmap>
	return r;
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	eb b7                	jmp    80115d <dup+0xa3>

008011a6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	53                   	push   %ebx
  8011aa:	83 ec 14             	sub    $0x14,%esp
  8011ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b3:	50                   	push   %eax
  8011b4:	53                   	push   %ebx
  8011b5:	e8 7f fd ff ff       	call   800f39 <fd_lookup>
  8011ba:	83 c4 08             	add    $0x8,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	78 3f                	js     801200 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c7:	50                   	push   %eax
  8011c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cb:	ff 30                	pushl  (%eax)
  8011cd:	e8 be fd ff ff       	call   800f90 <dev_lookup>
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	78 27                	js     801200 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011dc:	8b 42 08             	mov    0x8(%edx),%eax
  8011df:	83 e0 03             	and    $0x3,%eax
  8011e2:	83 f8 01             	cmp    $0x1,%eax
  8011e5:	74 1e                	je     801205 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ea:	8b 40 08             	mov    0x8(%eax),%eax
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	74 35                	je     801226 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	ff 75 10             	pushl  0x10(%ebp)
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	52                   	push   %edx
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
}
  801200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801203:	c9                   	leave  
  801204:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801205:	a1 08 40 80 00       	mov    0x804008,%eax
  80120a:	8b 40 48             	mov    0x48(%eax),%eax
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	53                   	push   %ebx
  801211:	50                   	push   %eax
  801212:	68 2d 25 80 00       	push   $0x80252d
  801217:	e8 59 0b 00 00       	call   801d75 <cprintf>
		return -E_INVAL;
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801224:	eb da                	jmp    801200 <read+0x5a>
		return -E_NOT_SUPP;
  801226:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80122b:	eb d3                	jmp    801200 <read+0x5a>

0080122d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	8b 7d 08             	mov    0x8(%ebp),%edi
  801239:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80123c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801241:	39 f3                	cmp    %esi,%ebx
  801243:	73 25                	jae    80126a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801245:	83 ec 04             	sub    $0x4,%esp
  801248:	89 f0                	mov    %esi,%eax
  80124a:	29 d8                	sub    %ebx,%eax
  80124c:	50                   	push   %eax
  80124d:	89 d8                	mov    %ebx,%eax
  80124f:	03 45 0c             	add    0xc(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	57                   	push   %edi
  801254:	e8 4d ff ff ff       	call   8011a6 <read>
		if (m < 0)
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 08                	js     801268 <readn+0x3b>
			return m;
		if (m == 0)
  801260:	85 c0                	test   %eax,%eax
  801262:	74 06                	je     80126a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801264:	01 c3                	add    %eax,%ebx
  801266:	eb d9                	jmp    801241 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801268:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80126a:	89 d8                	mov    %ebx,%eax
  80126c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126f:	5b                   	pop    %ebx
  801270:	5e                   	pop    %esi
  801271:	5f                   	pop    %edi
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	53                   	push   %ebx
  801278:	83 ec 14             	sub    $0x14,%esp
  80127b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80127e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801281:	50                   	push   %eax
  801282:	53                   	push   %ebx
  801283:	e8 b1 fc ff ff       	call   800f39 <fd_lookup>
  801288:	83 c4 08             	add    $0x8,%esp
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 3a                	js     8012c9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801295:	50                   	push   %eax
  801296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801299:	ff 30                	pushl  (%eax)
  80129b:	e8 f0 fc ff ff       	call   800f90 <dev_lookup>
  8012a0:	83 c4 10             	add    $0x10,%esp
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	78 22                	js     8012c9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ae:	74 1e                	je     8012ce <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b3:	8b 52 0c             	mov    0xc(%edx),%edx
  8012b6:	85 d2                	test   %edx,%edx
  8012b8:	74 35                	je     8012ef <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	ff 75 10             	pushl  0x10(%ebp)
  8012c0:	ff 75 0c             	pushl  0xc(%ebp)
  8012c3:	50                   	push   %eax
  8012c4:	ff d2                	call   *%edx
  8012c6:	83 c4 10             	add    $0x10,%esp
}
  8012c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012ce:	a1 08 40 80 00       	mov    0x804008,%eax
  8012d3:	8b 40 48             	mov    0x48(%eax),%eax
  8012d6:	83 ec 04             	sub    $0x4,%esp
  8012d9:	53                   	push   %ebx
  8012da:	50                   	push   %eax
  8012db:	68 49 25 80 00       	push   $0x802549
  8012e0:	e8 90 0a 00 00       	call   801d75 <cprintf>
		return -E_INVAL;
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ed:	eb da                	jmp    8012c9 <write+0x55>
		return -E_NOT_SUPP;
  8012ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012f4:	eb d3                	jmp    8012c9 <write+0x55>

008012f6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012fc:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012ff:	50                   	push   %eax
  801300:	ff 75 08             	pushl  0x8(%ebp)
  801303:	e8 31 fc ff ff       	call   800f39 <fd_lookup>
  801308:	83 c4 08             	add    $0x8,%esp
  80130b:	85 c0                	test   %eax,%eax
  80130d:	78 0e                	js     80131d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8b 55 0c             	mov    0xc(%ebp),%edx
  801315:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801318:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	53                   	push   %ebx
  801323:	83 ec 14             	sub    $0x14,%esp
  801326:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801329:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132c:	50                   	push   %eax
  80132d:	53                   	push   %ebx
  80132e:	e8 06 fc ff ff       	call   800f39 <fd_lookup>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 37                	js     801371 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	ff 30                	pushl  (%eax)
  801346:	e8 45 fc ff ff       	call   800f90 <dev_lookup>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 1f                	js     801371 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801355:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801359:	74 1b                	je     801376 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80135b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135e:	8b 52 18             	mov    0x18(%edx),%edx
  801361:	85 d2                	test   %edx,%edx
  801363:	74 32                	je     801397 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	50                   	push   %eax
  80136c:	ff d2                	call   *%edx
  80136e:	83 c4 10             	add    $0x10,%esp
}
  801371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801374:	c9                   	leave  
  801375:	c3                   	ret    
			thisenv->env_id, fdnum);
  801376:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80137b:	8b 40 48             	mov    0x48(%eax),%eax
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	53                   	push   %ebx
  801382:	50                   	push   %eax
  801383:	68 0c 25 80 00       	push   $0x80250c
  801388:	e8 e8 09 00 00       	call   801d75 <cprintf>
		return -E_INVAL;
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801395:	eb da                	jmp    801371 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801397:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139c:	eb d3                	jmp    801371 <ftruncate+0x52>

0080139e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 14             	sub    $0x14,%esp
  8013a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ab:	50                   	push   %eax
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	e8 85 fb ff ff       	call   800f39 <fd_lookup>
  8013b4:	83 c4 08             	add    $0x8,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 4b                	js     801406 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c1:	50                   	push   %eax
  8013c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c5:	ff 30                	pushl  (%eax)
  8013c7:	e8 c4 fb ff ff       	call   800f90 <dev_lookup>
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 33                	js     801406 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013da:	74 2f                	je     80140b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013dc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013df:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013e6:	00 00 00 
	stat->st_type = 0;
  8013e9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013f0:	00 00 00 
	stat->st_dev = dev;
  8013f3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	53                   	push   %ebx
  8013fd:	ff 75 f0             	pushl  -0x10(%ebp)
  801400:	ff 50 14             	call   *0x14(%eax)
  801403:	83 c4 10             	add    $0x10,%esp
}
  801406:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801409:	c9                   	leave  
  80140a:	c3                   	ret    
		return -E_NOT_SUPP;
  80140b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801410:	eb f4                	jmp    801406 <fstat+0x68>

00801412 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	56                   	push   %esi
  801416:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	6a 00                	push   $0x0
  80141c:	ff 75 08             	pushl  0x8(%ebp)
  80141f:	e8 34 02 00 00       	call   801658 <open>
  801424:	89 c3                	mov    %eax,%ebx
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 1b                	js     801448 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	ff 75 0c             	pushl  0xc(%ebp)
  801433:	50                   	push   %eax
  801434:	e8 65 ff ff ff       	call   80139e <fstat>
  801439:	89 c6                	mov    %eax,%esi
	close(fd);
  80143b:	89 1c 24             	mov    %ebx,(%esp)
  80143e:	e8 29 fc ff ff       	call   80106c <close>
	return r;
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	89 f3                	mov    %esi,%ebx
}
  801448:	89 d8                	mov    %ebx,%eax
  80144a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80144d:	5b                   	pop    %ebx
  80144e:	5e                   	pop    %esi
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    

00801451 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	56                   	push   %esi
  801455:	53                   	push   %ebx
  801456:	89 c6                	mov    %eax,%esi
  801458:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80145a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801461:	74 27                	je     80148a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801463:	6a 07                	push   $0x7
  801465:	68 00 50 80 00       	push   $0x805000
  80146a:	56                   	push   %esi
  80146b:	ff 35 04 40 80 00    	pushl  0x804004
  801471:	e8 9c 09 00 00       	call   801e12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801476:	83 c4 0c             	add    $0xc,%esp
  801479:	6a 00                	push   $0x0
  80147b:	53                   	push   %ebx
  80147c:	6a 00                	push   $0x0
  80147e:	e8 06 09 00 00       	call   801d89 <ipc_recv>
}
  801483:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801486:	5b                   	pop    %ebx
  801487:	5e                   	pop    %esi
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80148a:	83 ec 0c             	sub    $0xc,%esp
  80148d:	6a 01                	push   $0x1
  80148f:	e8 da 09 00 00       	call   801e6e <ipc_find_env>
  801494:	a3 04 40 80 00       	mov    %eax,0x804004
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	eb c5                	jmp    801463 <fsipc+0x12>

0080149e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8014aa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014bc:	b8 02 00 00 00       	mov    $0x2,%eax
  8014c1:	e8 8b ff ff ff       	call   801451 <fsipc>
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <devfile_flush>:
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014de:	b8 06 00 00 00       	mov    $0x6,%eax
  8014e3:	e8 69 ff ff ff       	call   801451 <fsipc>
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <devfile_stat>:
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 04             	sub    $0x4,%esp
  8014f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8014fa:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801504:	b8 05 00 00 00       	mov    $0x5,%eax
  801509:	e8 43 ff ff ff       	call   801451 <fsipc>
  80150e:	85 c0                	test   %eax,%eax
  801510:	78 2c                	js     80153e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801512:	83 ec 08             	sub    $0x8,%esp
  801515:	68 00 50 80 00       	push   $0x805000
  80151a:	53                   	push   %ebx
  80151b:	e8 39 f3 ff ff       	call   800859 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801520:	a1 80 50 80 00       	mov    0x805080,%eax
  801525:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80152b:	a1 84 50 80 00       	mov    0x805084,%eax
  801530:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <devfile_write>:
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	53                   	push   %ebx
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  80154d:	89 d8                	mov    %ebx,%eax
  80154f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801555:	76 05                	jbe    80155c <devfile_write+0x19>
  801557:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80155c:	8b 55 08             	mov    0x8(%ebp),%edx
  80155f:	8b 52 0c             	mov    0xc(%edx),%edx
  801562:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801568:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	50                   	push   %eax
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	68 08 50 80 00       	push   $0x805008
  801579:	e8 4e f4 ff ff       	call   8009cc <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  80157e:	ba 00 00 00 00       	mov    $0x0,%edx
  801583:	b8 04 00 00 00       	mov    $0x4,%eax
  801588:	e8 c4 fe ff ff       	call   801451 <fsipc>
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 0b                	js     80159f <devfile_write+0x5c>
	assert(r <= n);
  801594:	39 c3                	cmp    %eax,%ebx
  801596:	72 0c                	jb     8015a4 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801598:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80159d:	7f 1e                	jg     8015bd <devfile_write+0x7a>
}
  80159f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    
	assert(r <= n);
  8015a4:	68 78 25 80 00       	push   $0x802578
  8015a9:	68 7f 25 80 00       	push   $0x80257f
  8015ae:	68 98 00 00 00       	push   $0x98
  8015b3:	68 94 25 80 00       	push   $0x802594
  8015b8:	e8 29 ec ff ff       	call   8001e6 <_panic>
	assert(r <= PGSIZE);
  8015bd:	68 9f 25 80 00       	push   $0x80259f
  8015c2:	68 7f 25 80 00       	push   $0x80257f
  8015c7:	68 99 00 00 00       	push   $0x99
  8015cc:	68 94 25 80 00       	push   $0x802594
  8015d1:	e8 10 ec ff ff       	call   8001e6 <_panic>

008015d6 <devfile_read>:
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	56                   	push   %esi
  8015da:	53                   	push   %ebx
  8015db:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015e9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8015f9:	e8 53 fe ff ff       	call   801451 <fsipc>
  8015fe:	89 c3                	mov    %eax,%ebx
  801600:	85 c0                	test   %eax,%eax
  801602:	78 1f                	js     801623 <devfile_read+0x4d>
	assert(r <= n);
  801604:	39 c6                	cmp    %eax,%esi
  801606:	72 24                	jb     80162c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801608:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80160d:	7f 33                	jg     801642 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	50                   	push   %eax
  801613:	68 00 50 80 00       	push   $0x805000
  801618:	ff 75 0c             	pushl  0xc(%ebp)
  80161b:	e8 ac f3 ff ff       	call   8009cc <memmove>
	return r;
  801620:	83 c4 10             	add    $0x10,%esp
}
  801623:	89 d8                	mov    %ebx,%eax
  801625:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801628:	5b                   	pop    %ebx
  801629:	5e                   	pop    %esi
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    
	assert(r <= n);
  80162c:	68 78 25 80 00       	push   $0x802578
  801631:	68 7f 25 80 00       	push   $0x80257f
  801636:	6a 7c                	push   $0x7c
  801638:	68 94 25 80 00       	push   $0x802594
  80163d:	e8 a4 eb ff ff       	call   8001e6 <_panic>
	assert(r <= PGSIZE);
  801642:	68 9f 25 80 00       	push   $0x80259f
  801647:	68 7f 25 80 00       	push   $0x80257f
  80164c:	6a 7d                	push   $0x7d
  80164e:	68 94 25 80 00       	push   $0x802594
  801653:	e8 8e eb ff ff       	call   8001e6 <_panic>

00801658 <open>:
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	56                   	push   %esi
  80165c:	53                   	push   %ebx
  80165d:	83 ec 1c             	sub    $0x1c,%esp
  801660:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801663:	56                   	push   %esi
  801664:	e8 bd f1 ff ff       	call   800826 <strlen>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801671:	7f 6c                	jg     8016df <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801673:	83 ec 0c             	sub    $0xc,%esp
  801676:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801679:	50                   	push   %eax
  80167a:	e8 6b f8 ff ff       	call   800eea <fd_alloc>
  80167f:	89 c3                	mov    %eax,%ebx
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 3c                	js     8016c4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801688:	83 ec 08             	sub    $0x8,%esp
  80168b:	56                   	push   %esi
  80168c:	68 00 50 80 00       	push   $0x805000
  801691:	e8 c3 f1 ff ff       	call   800859 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80169e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a6:	e8 a6 fd ff ff       	call   801451 <fsipc>
  8016ab:	89 c3                	mov    %eax,%ebx
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	78 19                	js     8016cd <open+0x75>
	return fd2num(fd);
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ba:	e8 04 f8 ff ff       	call   800ec3 <fd2num>
  8016bf:	89 c3                	mov    %eax,%ebx
  8016c1:	83 c4 10             	add    $0x10,%esp
}
  8016c4:	89 d8                	mov    %ebx,%eax
  8016c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c9:	5b                   	pop    %ebx
  8016ca:	5e                   	pop    %esi
  8016cb:	5d                   	pop    %ebp
  8016cc:	c3                   	ret    
		fd_close(fd, 0);
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	6a 00                	push   $0x0
  8016d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d5:	e8 0c f9 ff ff       	call   800fe6 <fd_close>
		return r;
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	eb e5                	jmp    8016c4 <open+0x6c>
		return -E_BAD_PATH;
  8016df:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016e4:	eb de                	jmp    8016c4 <open+0x6c>

008016e6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8016f6:	e8 56 fd ff ff       	call   801451 <fsipc>
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8016fd:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801701:	7e 38                	jle    80173b <writebuf+0x3e>
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	53                   	push   %ebx
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80170c:	ff 70 04             	pushl  0x4(%eax)
  80170f:	8d 40 10             	lea    0x10(%eax),%eax
  801712:	50                   	push   %eax
  801713:	ff 33                	pushl  (%ebx)
  801715:	e8 5a fb ff ff       	call   801274 <write>
		if (result > 0)
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	85 c0                	test   %eax,%eax
  80171f:	7e 03                	jle    801724 <writebuf+0x27>
			b->result += result;
  801721:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801724:	3b 43 04             	cmp    0x4(%ebx),%eax
  801727:	74 0e                	je     801737 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801729:	89 c2                	mov    %eax,%edx
  80172b:	85 c0                	test   %eax,%eax
  80172d:	7e 05                	jle    801734 <writebuf+0x37>
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	89 53 0c             	mov    %edx,0xc(%ebx)
	}
}
  801737:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <putch>:

static void
putch(int ch, void *thunk)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	53                   	push   %ebx
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801746:	8b 53 04             	mov    0x4(%ebx),%edx
  801749:	8d 42 01             	lea    0x1(%edx),%eax
  80174c:	89 43 04             	mov    %eax,0x4(%ebx)
  80174f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801752:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801756:	3d 00 01 00 00       	cmp    $0x100,%eax
  80175b:	74 06                	je     801763 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80175d:	83 c4 04             	add    $0x4,%esp
  801760:	5b                   	pop    %ebx
  801761:	5d                   	pop    %ebp
  801762:	c3                   	ret    
		writebuf(b);
  801763:	89 d8                	mov    %ebx,%eax
  801765:	e8 93 ff ff ff       	call   8016fd <writebuf>
		b->idx = 0;
  80176a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801771:	eb ea                	jmp    80175d <putch+0x21>

00801773 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801785:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80178c:	00 00 00 
	b.result = 0;
  80178f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801796:	00 00 00 
	b.error = 1;
  801799:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8017a0:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8017a3:	ff 75 10             	pushl  0x10(%ebp)
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017af:	50                   	push   %eax
  8017b0:	68 3c 17 80 00       	push   $0x80173c
  8017b5:	e8 91 eb ff ff       	call   80034b <vprintfmt>
	if (b.idx > 0)
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8017c4:	7e 0b                	jle    8017d1 <vfprintf+0x5e>
		writebuf(&b);
  8017c6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017cc:	e8 2c ff ff ff       	call   8016fd <writebuf>

	return (b.result ? b.result : b.error);
  8017d1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	75 06                	jne    8017e1 <vfprintf+0x6e>
  8017db:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017e9:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8017ec:	50                   	push   %eax
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	e8 7b ff ff ff       	call   801773 <vfprintf>
	va_end(ap);

	return cnt;
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <printf>:

int
printf(const char *fmt, ...)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801800:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801803:	50                   	push   %eax
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 01                	push   $0x1
  801809:	e8 65 ff ff ff       	call   801773 <vfprintf>
	va_end(ap);

	return cnt;
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	56                   	push   %esi
  801814:	53                   	push   %ebx
  801815:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801818:	83 ec 0c             	sub    $0xc,%esp
  80181b:	ff 75 08             	pushl  0x8(%ebp)
  80181e:	e8 b0 f6 ff ff       	call   800ed3 <fd2data>
  801823:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801825:	83 c4 08             	add    $0x8,%esp
  801828:	68 ab 25 80 00       	push   $0x8025ab
  80182d:	53                   	push   %ebx
  80182e:	e8 26 f0 ff ff       	call   800859 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801833:	8b 46 04             	mov    0x4(%esi),%eax
  801836:	2b 06                	sub    (%esi),%eax
  801838:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80183e:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801845:	10 00 00 
	stat->st_dev = &devpipe;
  801848:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  80184f:	30 80 00 
	return 0;
}
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
  801857:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	53                   	push   %ebx
  801862:	83 ec 0c             	sub    $0xc,%esp
  801865:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801868:	53                   	push   %ebx
  801869:	6a 00                	push   $0x0
  80186b:	e8 23 f4 ff ff       	call   800c93 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801870:	89 1c 24             	mov    %ebx,(%esp)
  801873:	e8 5b f6 ff ff       	call   800ed3 <fd2data>
  801878:	83 c4 08             	add    $0x8,%esp
  80187b:	50                   	push   %eax
  80187c:	6a 00                	push   $0x0
  80187e:	e8 10 f4 ff ff       	call   800c93 <sys_page_unmap>
}
  801883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <_pipeisclosed>:
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	57                   	push   %edi
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
  80188e:	83 ec 1c             	sub    $0x1c,%esp
  801891:	89 c7                	mov    %eax,%edi
  801893:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801895:	a1 08 40 80 00       	mov    0x804008,%eax
  80189a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80189d:	83 ec 0c             	sub    $0xc,%esp
  8018a0:	57                   	push   %edi
  8018a1:	e8 0a 06 00 00       	call   801eb0 <pageref>
  8018a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018a9:	89 34 24             	mov    %esi,(%esp)
  8018ac:	e8 ff 05 00 00       	call   801eb0 <pageref>
		nn = thisenv->env_runs;
  8018b1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8018b7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	39 cb                	cmp    %ecx,%ebx
  8018bf:	74 1b                	je     8018dc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8018c1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018c4:	75 cf                	jne    801895 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018c6:	8b 42 58             	mov    0x58(%edx),%eax
  8018c9:	6a 01                	push   $0x1
  8018cb:	50                   	push   %eax
  8018cc:	53                   	push   %ebx
  8018cd:	68 b2 25 80 00       	push   $0x8025b2
  8018d2:	e8 9e 04 00 00       	call   801d75 <cprintf>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	eb b9                	jmp    801895 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018dc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018df:	0f 94 c0             	sete   %al
  8018e2:	0f b6 c0             	movzbl %al,%eax
}
  8018e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e8:	5b                   	pop    %ebx
  8018e9:	5e                   	pop    %esi
  8018ea:	5f                   	pop    %edi
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    

008018ed <devpipe_write>:
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	57                   	push   %edi
  8018f1:	56                   	push   %esi
  8018f2:	53                   	push   %ebx
  8018f3:	83 ec 18             	sub    $0x18,%esp
  8018f6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018f9:	56                   	push   %esi
  8018fa:	e8 d4 f5 ff ff       	call   800ed3 <fd2data>
  8018ff:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	bf 00 00 00 00       	mov    $0x0,%edi
  801909:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80190c:	74 41                	je     80194f <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80190e:	8b 53 04             	mov    0x4(%ebx),%edx
  801911:	8b 03                	mov    (%ebx),%eax
  801913:	83 c0 20             	add    $0x20,%eax
  801916:	39 c2                	cmp    %eax,%edx
  801918:	72 14                	jb     80192e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80191a:	89 da                	mov    %ebx,%edx
  80191c:	89 f0                	mov    %esi,%eax
  80191e:	e8 65 ff ff ff       	call   801888 <_pipeisclosed>
  801923:	85 c0                	test   %eax,%eax
  801925:	75 2c                	jne    801953 <devpipe_write+0x66>
			sys_yield();
  801927:	e8 a9 f3 ff ff       	call   800cd5 <sys_yield>
  80192c:	eb e0                	jmp    80190e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801934:	89 d0                	mov    %edx,%eax
  801936:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80193b:	78 0b                	js     801948 <devpipe_write+0x5b>
  80193d:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801941:	42                   	inc    %edx
  801942:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801945:	47                   	inc    %edi
  801946:	eb c1                	jmp    801909 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801948:	48                   	dec    %eax
  801949:	83 c8 e0             	or     $0xffffffe0,%eax
  80194c:	40                   	inc    %eax
  80194d:	eb ee                	jmp    80193d <devpipe_write+0x50>
	return i;
  80194f:	89 f8                	mov    %edi,%eax
  801951:	eb 05                	jmp    801958 <devpipe_write+0x6b>
				return 0;
  801953:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801958:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    

00801960 <devpipe_read>:
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	57                   	push   %edi
  801964:	56                   	push   %esi
  801965:	53                   	push   %ebx
  801966:	83 ec 18             	sub    $0x18,%esp
  801969:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80196c:	57                   	push   %edi
  80196d:	e8 61 f5 ff ff       	call   800ed3 <fd2data>
  801972:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	bb 00 00 00 00       	mov    $0x0,%ebx
  80197c:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80197f:	74 46                	je     8019c7 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801981:	8b 06                	mov    (%esi),%eax
  801983:	3b 46 04             	cmp    0x4(%esi),%eax
  801986:	75 22                	jne    8019aa <devpipe_read+0x4a>
			if (i > 0)
  801988:	85 db                	test   %ebx,%ebx
  80198a:	74 0a                	je     801996 <devpipe_read+0x36>
				return i;
  80198c:	89 d8                	mov    %ebx,%eax
}
  80198e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801991:	5b                   	pop    %ebx
  801992:	5e                   	pop    %esi
  801993:	5f                   	pop    %edi
  801994:	5d                   	pop    %ebp
  801995:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801996:	89 f2                	mov    %esi,%edx
  801998:	89 f8                	mov    %edi,%eax
  80199a:	e8 e9 fe ff ff       	call   801888 <_pipeisclosed>
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	75 28                	jne    8019cb <devpipe_read+0x6b>
			sys_yield();
  8019a3:	e8 2d f3 ff ff       	call   800cd5 <sys_yield>
  8019a8:	eb d7                	jmp    801981 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019aa:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8019af:	78 0f                	js     8019c0 <devpipe_read+0x60>
  8019b1:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8019b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b8:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8019bb:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8019bd:	43                   	inc    %ebx
  8019be:	eb bc                	jmp    80197c <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019c0:	48                   	dec    %eax
  8019c1:	83 c8 e0             	or     $0xffffffe0,%eax
  8019c4:	40                   	inc    %eax
  8019c5:	eb ea                	jmp    8019b1 <devpipe_read+0x51>
	return i;
  8019c7:	89 d8                	mov    %ebx,%eax
  8019c9:	eb c3                	jmp    80198e <devpipe_read+0x2e>
				return 0;
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d0:	eb bc                	jmp    80198e <devpipe_read+0x2e>

008019d2 <pipe>:
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	56                   	push   %esi
  8019d6:	53                   	push   %ebx
  8019d7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019dd:	50                   	push   %eax
  8019de:	e8 07 f5 ff ff       	call   800eea <fd_alloc>
  8019e3:	89 c3                	mov    %eax,%ebx
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	0f 88 2a 01 00 00    	js     801b1a <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	68 07 04 00 00       	push   $0x407
  8019f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fb:	6a 00                	push   $0x0
  8019fd:	e8 0c f2 ff ff       	call   800c0e <sys_page_alloc>
  801a02:	89 c3                	mov    %eax,%ebx
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	85 c0                	test   %eax,%eax
  801a09:	0f 88 0b 01 00 00    	js     801b1a <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801a0f:	83 ec 0c             	sub    $0xc,%esp
  801a12:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a15:	50                   	push   %eax
  801a16:	e8 cf f4 ff ff       	call   800eea <fd_alloc>
  801a1b:	89 c3                	mov    %eax,%ebx
  801a1d:	83 c4 10             	add    $0x10,%esp
  801a20:	85 c0                	test   %eax,%eax
  801a22:	0f 88 e2 00 00 00    	js     801b0a <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	68 07 04 00 00       	push   $0x407
  801a30:	ff 75 f0             	pushl  -0x10(%ebp)
  801a33:	6a 00                	push   $0x0
  801a35:	e8 d4 f1 ff ff       	call   800c0e <sys_page_alloc>
  801a3a:	89 c3                	mov    %eax,%ebx
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	0f 88 c3 00 00 00    	js     801b0a <pipe+0x138>
	va = fd2data(fd0);
  801a47:	83 ec 0c             	sub    $0xc,%esp
  801a4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4d:	e8 81 f4 ff ff       	call   800ed3 <fd2data>
  801a52:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a54:	83 c4 0c             	add    $0xc,%esp
  801a57:	68 07 04 00 00       	push   $0x407
  801a5c:	50                   	push   %eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	e8 aa f1 ff ff       	call   800c0e <sys_page_alloc>
  801a64:	89 c3                	mov    %eax,%ebx
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	0f 88 89 00 00 00    	js     801afa <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a71:	83 ec 0c             	sub    $0xc,%esp
  801a74:	ff 75 f0             	pushl  -0x10(%ebp)
  801a77:	e8 57 f4 ff ff       	call   800ed3 <fd2data>
  801a7c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a83:	50                   	push   %eax
  801a84:	6a 00                	push   $0x0
  801a86:	56                   	push   %esi
  801a87:	6a 00                	push   $0x0
  801a89:	e8 c3 f1 ff ff       	call   800c51 <sys_page_map>
  801a8e:	89 c3                	mov    %eax,%ebx
  801a90:	83 c4 20             	add    $0x20,%esp
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 55                	js     801aec <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801a97:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801aac:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ac1:	83 ec 0c             	sub    $0xc,%esp
  801ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac7:	e8 f7 f3 ff ff       	call   800ec3 <fd2num>
  801acc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801acf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ad1:	83 c4 04             	add    $0x4,%esp
  801ad4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ad7:	e8 e7 f3 ff ff       	call   800ec3 <fd2num>
  801adc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aea:	eb 2e                	jmp    801b1a <pipe+0x148>
	sys_page_unmap(0, va);
  801aec:	83 ec 08             	sub    $0x8,%esp
  801aef:	56                   	push   %esi
  801af0:	6a 00                	push   $0x0
  801af2:	e8 9c f1 ff ff       	call   800c93 <sys_page_unmap>
  801af7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	ff 75 f0             	pushl  -0x10(%ebp)
  801b00:	6a 00                	push   $0x0
  801b02:	e8 8c f1 ff ff       	call   800c93 <sys_page_unmap>
  801b07:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b10:	6a 00                	push   $0x0
  801b12:	e8 7c f1 ff ff       	call   800c93 <sys_page_unmap>
  801b17:	83 c4 10             	add    $0x10,%esp
}
  801b1a:	89 d8                	mov    %ebx,%eax
  801b1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5d                   	pop    %ebp
  801b22:	c3                   	ret    

00801b23 <pipeisclosed>:
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b2c:	50                   	push   %eax
  801b2d:	ff 75 08             	pushl  0x8(%ebp)
  801b30:	e8 04 f4 ff ff       	call   800f39 <fd_lookup>
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	78 18                	js     801b54 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b42:	e8 8c f3 ff ff       	call   800ed3 <fd2data>
	return _pipeisclosed(fd, p);
  801b47:	89 c2                	mov    %eax,%edx
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	e8 37 fd ff ff       	call   801888 <_pipeisclosed>
  801b51:	83 c4 10             	add    $0x10,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    

00801b60 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	53                   	push   %ebx
  801b64:	83 ec 0c             	sub    $0xc,%esp
  801b67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801b6a:	68 ca 25 80 00       	push   $0x8025ca
  801b6f:	53                   	push   %ebx
  801b70:	e8 e4 ec ff ff       	call   800859 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801b75:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801b7c:	20 00 00 
	return 0;
}
  801b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <devcons_write>:
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	57                   	push   %edi
  801b8d:	56                   	push   %esi
  801b8e:	53                   	push   %ebx
  801b8f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b95:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b9a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ba0:	eb 1d                	jmp    801bbf <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	53                   	push   %ebx
  801ba6:	03 45 0c             	add    0xc(%ebp),%eax
  801ba9:	50                   	push   %eax
  801baa:	57                   	push   %edi
  801bab:	e8 1c ee ff ff       	call   8009cc <memmove>
		sys_cputs(buf, m);
  801bb0:	83 c4 08             	add    $0x8,%esp
  801bb3:	53                   	push   %ebx
  801bb4:	57                   	push   %edi
  801bb5:	e8 b7 ef ff ff       	call   800b71 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801bba:	01 de                	add    %ebx,%esi
  801bbc:	83 c4 10             	add    $0x10,%esp
  801bbf:	89 f0                	mov    %esi,%eax
  801bc1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bc4:	73 11                	jae    801bd7 <devcons_write+0x4e>
		m = n - tot;
  801bc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bc9:	29 f3                	sub    %esi,%ebx
  801bcb:	83 fb 7f             	cmp    $0x7f,%ebx
  801bce:	76 d2                	jbe    801ba2 <devcons_write+0x19>
  801bd0:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801bd5:	eb cb                	jmp    801ba2 <devcons_write+0x19>
}
  801bd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bda:	5b                   	pop    %ebx
  801bdb:	5e                   	pop    %esi
  801bdc:	5f                   	pop    %edi
  801bdd:	5d                   	pop    %ebp
  801bde:	c3                   	ret    

00801bdf <devcons_read>:
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801be5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801be9:	75 0c                	jne    801bf7 <devcons_read+0x18>
		return 0;
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf0:	eb 21                	jmp    801c13 <devcons_read+0x34>
		sys_yield();
  801bf2:	e8 de f0 ff ff       	call   800cd5 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801bf7:	e8 93 ef ff ff       	call   800b8f <sys_cgetc>
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	74 f2                	je     801bf2 <devcons_read+0x13>
	if (c < 0)
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 0f                	js     801c13 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801c04:	83 f8 04             	cmp    $0x4,%eax
  801c07:	74 0c                	je     801c15 <devcons_read+0x36>
	*(char*)vbuf = c;
  801c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0c:	88 02                	mov    %al,(%edx)
	return 1;
  801c0e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    
		return 0;
  801c15:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1a:	eb f7                	jmp    801c13 <devcons_read+0x34>

00801c1c <cputchar>:
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c28:	6a 01                	push   $0x1
  801c2a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c2d:	50                   	push   %eax
  801c2e:	e8 3e ef ff ff       	call   800b71 <sys_cputs>
}
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <getchar>:
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c3e:	6a 01                	push   $0x1
  801c40:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c43:	50                   	push   %eax
  801c44:	6a 00                	push   $0x0
  801c46:	e8 5b f5 ff ff       	call   8011a6 <read>
	if (r < 0)
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 08                	js     801c5a <getchar+0x22>
	if (r < 1)
  801c52:	85 c0                	test   %eax,%eax
  801c54:	7e 06                	jle    801c5c <getchar+0x24>
	return c;
  801c56:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    
		return -E_EOF;
  801c5c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c61:	eb f7                	jmp    801c5a <getchar+0x22>

00801c63 <iscons>:
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c6c:	50                   	push   %eax
  801c6d:	ff 75 08             	pushl  0x8(%ebp)
  801c70:	e8 c4 f2 ff ff       	call   800f39 <fd_lookup>
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 11                	js     801c8d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7f:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801c85:	39 10                	cmp    %edx,(%eax)
  801c87:	0f 94 c0             	sete   %al
  801c8a:	0f b6 c0             	movzbl %al,%eax
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <opencons>:
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c98:	50                   	push   %eax
  801c99:	e8 4c f2 ff ff       	call   800eea <fd_alloc>
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	78 3a                	js     801cdf <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	68 07 04 00 00       	push   $0x407
  801cad:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb0:	6a 00                	push   $0x0
  801cb2:	e8 57 ef ff ff       	call   800c0e <sys_page_alloc>
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	78 21                	js     801cdf <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801cbe:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	50                   	push   %eax
  801cd7:	e8 e7 f1 ff ff       	call   800ec3 <fd2num>
  801cdc:	83 c4 10             	add    $0x10,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 04             	sub    $0x4,%esp
  801ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801ceb:	8b 13                	mov    (%ebx),%edx
  801ced:	8d 42 01             	lea    0x1(%edx),%eax
  801cf0:	89 03                	mov    %eax,(%ebx)
  801cf2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801cf9:	3d ff 00 00 00       	cmp    $0xff,%eax
  801cfe:	74 08                	je     801d08 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801d00:	ff 43 04             	incl   0x4(%ebx)
}
  801d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	68 ff 00 00 00       	push   $0xff
  801d10:	8d 43 08             	lea    0x8(%ebx),%eax
  801d13:	50                   	push   %eax
  801d14:	e8 58 ee ff ff       	call   800b71 <sys_cputs>
		b->idx = 0;
  801d19:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	eb dc                	jmp    801d00 <putch+0x1f>

00801d24 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801d2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d34:	00 00 00 
	b.cnt = 0;
  801d37:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d3e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	ff 75 08             	pushl  0x8(%ebp)
  801d47:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d4d:	50                   	push   %eax
  801d4e:	68 e1 1c 80 00       	push   $0x801ce1
  801d53:	e8 f3 e5 ff ff       	call   80034b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801d58:	83 c4 08             	add    $0x8,%esp
  801d5b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801d61:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801d67:	50                   	push   %eax
  801d68:	e8 04 ee ff ff       	call   800b71 <sys_cputs>

	return b.cnt;
}
  801d6d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d7b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801d7e:	50                   	push   %eax
  801d7f:	ff 75 08             	pushl  0x8(%ebp)
  801d82:	e8 9d ff ff ff       	call   801d24 <vcprintf>
	va_end(ap);

	return cnt;
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	57                   	push   %edi
  801d8d:	56                   	push   %esi
  801d8e:	53                   	push   %ebx
  801d8f:	83 ec 0c             	sub    $0xc,%esp
  801d92:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d95:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d98:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801d9b:	85 ff                	test   %edi,%edi
  801d9d:	74 53                	je     801df2 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801d9f:	83 ec 0c             	sub    $0xc,%esp
  801da2:	57                   	push   %edi
  801da3:	e8 76 f0 ff ff       	call   800e1e <sys_ipc_recv>
  801da8:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801dab:	85 db                	test   %ebx,%ebx
  801dad:	74 0b                	je     801dba <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801daf:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801db5:	8b 52 74             	mov    0x74(%edx),%edx
  801db8:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801dba:	85 f6                	test   %esi,%esi
  801dbc:	74 0f                	je     801dcd <ipc_recv+0x44>
  801dbe:	85 ff                	test   %edi,%edi
  801dc0:	74 0b                	je     801dcd <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801dc2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801dc8:	8b 52 78             	mov    0x78(%edx),%edx
  801dcb:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	74 30                	je     801e01 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801dd1:	85 db                	test   %ebx,%ebx
  801dd3:	74 06                	je     801ddb <ipc_recv+0x52>
      		*from_env_store = 0;
  801dd5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801ddb:	85 f6                	test   %esi,%esi
  801ddd:	74 2c                	je     801e0b <ipc_recv+0x82>
      		*perm_store = 0;
  801ddf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5f                   	pop    %edi
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801df2:	83 ec 0c             	sub    $0xc,%esp
  801df5:	6a ff                	push   $0xffffffff
  801df7:	e8 22 f0 ff ff       	call   800e1e <sys_ipc_recv>
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	eb aa                	jmp    801dab <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801e01:	a1 08 40 80 00       	mov    0x804008,%eax
  801e06:	8b 40 70             	mov    0x70(%eax),%eax
  801e09:	eb df                	jmp    801dea <ipc_recv+0x61>
		return -1;
  801e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e10:	eb d8                	jmp    801dea <ipc_recv+0x61>

00801e12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	57                   	push   %edi
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e21:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801e24:	85 db                	test   %ebx,%ebx
  801e26:	75 22                	jne    801e4a <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801e28:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801e2d:	eb 1b                	jmp    801e4a <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801e2f:	68 d8 25 80 00       	push   $0x8025d8
  801e34:	68 7f 25 80 00       	push   $0x80257f
  801e39:	6a 48                	push   $0x48
  801e3b:	68 fc 25 80 00       	push   $0x8025fc
  801e40:	e8 a1 e3 ff ff       	call   8001e6 <_panic>
		sys_yield();
  801e45:	e8 8b ee ff ff       	call   800cd5 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801e4a:	57                   	push   %edi
  801e4b:	53                   	push   %ebx
  801e4c:	56                   	push   %esi
  801e4d:	ff 75 08             	pushl  0x8(%ebp)
  801e50:	e8 a6 ef ff ff       	call   800dfb <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e5b:	74 e8                	je     801e45 <ipc_send+0x33>
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	75 ce                	jne    801e2f <ipc_send+0x1d>
		sys_yield();
  801e61:	e8 6f ee ff ff       	call   800cd5 <sys_yield>
		
	}
	
}
  801e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e69:	5b                   	pop    %ebx
  801e6a:	5e                   	pop    %esi
  801e6b:	5f                   	pop    %edi
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    

00801e6e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e74:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e79:	89 c2                	mov    %eax,%edx
  801e7b:	c1 e2 05             	shl    $0x5,%edx
  801e7e:	29 c2                	sub    %eax,%edx
  801e80:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801e87:	8b 52 50             	mov    0x50(%edx),%edx
  801e8a:	39 ca                	cmp    %ecx,%edx
  801e8c:	74 0f                	je     801e9d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801e8e:	40                   	inc    %eax
  801e8f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e94:	75 e3                	jne    801e79 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	eb 11                	jmp    801eae <ipc_find_env+0x40>
			return envs[i].env_id;
  801e9d:	89 c2                	mov    %eax,%edx
  801e9f:	c1 e2 05             	shl    $0x5,%edx
  801ea2:	29 c2                	sub    %eax,%edx
  801ea4:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801eab:	8b 40 48             	mov    0x48(%eax),%eax
}
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	c1 e8 16             	shr    $0x16,%eax
  801eb9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ec0:	a8 01                	test   $0x1,%al
  801ec2:	74 21                	je     801ee5 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	c1 e8 0c             	shr    $0xc,%eax
  801eca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801ed1:	a8 01                	test   $0x1,%al
  801ed3:	74 17                	je     801eec <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ed5:	c1 e8 0c             	shr    $0xc,%eax
  801ed8:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801edf:	ef 
  801ee0:	0f b7 c0             	movzwl %ax,%eax
  801ee3:	eb 05                	jmp    801eea <pageref+0x3a>
		return 0;
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    
		return 0;
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef1:	eb f7                	jmp    801eea <pageref+0x3a>
  801ef3:	90                   	nop

00801ef4 <__udivdi3>:
  801ef4:	55                   	push   %ebp
  801ef5:	57                   	push   %edi
  801ef6:	56                   	push   %esi
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 1c             	sub    $0x1c,%esp
  801efb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801eff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f07:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f0b:	89 ca                	mov    %ecx,%edx
  801f0d:	89 f8                	mov    %edi,%eax
  801f0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f13:	85 f6                	test   %esi,%esi
  801f15:	75 2d                	jne    801f44 <__udivdi3+0x50>
  801f17:	39 cf                	cmp    %ecx,%edi
  801f19:	77 65                	ja     801f80 <__udivdi3+0x8c>
  801f1b:	89 fd                	mov    %edi,%ebp
  801f1d:	85 ff                	test   %edi,%edi
  801f1f:	75 0b                	jne    801f2c <__udivdi3+0x38>
  801f21:	b8 01 00 00 00       	mov    $0x1,%eax
  801f26:	31 d2                	xor    %edx,%edx
  801f28:	f7 f7                	div    %edi
  801f2a:	89 c5                	mov    %eax,%ebp
  801f2c:	31 d2                	xor    %edx,%edx
  801f2e:	89 c8                	mov    %ecx,%eax
  801f30:	f7 f5                	div    %ebp
  801f32:	89 c1                	mov    %eax,%ecx
  801f34:	89 d8                	mov    %ebx,%eax
  801f36:	f7 f5                	div    %ebp
  801f38:	89 cf                	mov    %ecx,%edi
  801f3a:	89 fa                	mov    %edi,%edx
  801f3c:	83 c4 1c             	add    $0x1c,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5f                   	pop    %edi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    
  801f44:	39 ce                	cmp    %ecx,%esi
  801f46:	77 28                	ja     801f70 <__udivdi3+0x7c>
  801f48:	0f bd fe             	bsr    %esi,%edi
  801f4b:	83 f7 1f             	xor    $0x1f,%edi
  801f4e:	75 40                	jne    801f90 <__udivdi3+0x9c>
  801f50:	39 ce                	cmp    %ecx,%esi
  801f52:	72 0a                	jb     801f5e <__udivdi3+0x6a>
  801f54:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801f58:	0f 87 9e 00 00 00    	ja     801ffc <__udivdi3+0x108>
  801f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f63:	89 fa                	mov    %edi,%edx
  801f65:	83 c4 1c             	add    $0x1c,%esp
  801f68:	5b                   	pop    %ebx
  801f69:	5e                   	pop    %esi
  801f6a:	5f                   	pop    %edi
  801f6b:	5d                   	pop    %ebp
  801f6c:	c3                   	ret    
  801f6d:	8d 76 00             	lea    0x0(%esi),%esi
  801f70:	31 ff                	xor    %edi,%edi
  801f72:	31 c0                	xor    %eax,%eax
  801f74:	89 fa                	mov    %edi,%edx
  801f76:	83 c4 1c             	add    $0x1c,%esp
  801f79:	5b                   	pop    %ebx
  801f7a:	5e                   	pop    %esi
  801f7b:	5f                   	pop    %edi
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    
  801f7e:	66 90                	xchg   %ax,%ax
  801f80:	89 d8                	mov    %ebx,%eax
  801f82:	f7 f7                	div    %edi
  801f84:	31 ff                	xor    %edi,%edi
  801f86:	89 fa                	mov    %edi,%edx
  801f88:	83 c4 1c             	add    $0x1c,%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5f                   	pop    %edi
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    
  801f90:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f95:	29 fd                	sub    %edi,%ebp
  801f97:	89 f9                	mov    %edi,%ecx
  801f99:	d3 e6                	shl    %cl,%esi
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	89 e9                	mov    %ebp,%ecx
  801f9f:	d3 eb                	shr    %cl,%ebx
  801fa1:	89 d9                	mov    %ebx,%ecx
  801fa3:	09 f1                	or     %esi,%ecx
  801fa5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fa9:	89 f9                	mov    %edi,%ecx
  801fab:	d3 e0                	shl    %cl,%eax
  801fad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb1:	89 d6                	mov    %edx,%esi
  801fb3:	89 e9                	mov    %ebp,%ecx
  801fb5:	d3 ee                	shr    %cl,%esi
  801fb7:	89 f9                	mov    %edi,%ecx
  801fb9:	d3 e2                	shl    %cl,%edx
  801fbb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801fbf:	89 e9                	mov    %ebp,%ecx
  801fc1:	d3 eb                	shr    %cl,%ebx
  801fc3:	09 da                	or     %ebx,%edx
  801fc5:	89 d0                	mov    %edx,%eax
  801fc7:	89 f2                	mov    %esi,%edx
  801fc9:	f7 74 24 08          	divl   0x8(%esp)
  801fcd:	89 d6                	mov    %edx,%esi
  801fcf:	89 c3                	mov    %eax,%ebx
  801fd1:	f7 64 24 0c          	mull   0xc(%esp)
  801fd5:	39 d6                	cmp    %edx,%esi
  801fd7:	72 17                	jb     801ff0 <__udivdi3+0xfc>
  801fd9:	74 09                	je     801fe4 <__udivdi3+0xf0>
  801fdb:	89 d8                	mov    %ebx,%eax
  801fdd:	31 ff                	xor    %edi,%edi
  801fdf:	e9 56 ff ff ff       	jmp    801f3a <__udivdi3+0x46>
  801fe4:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fe8:	89 f9                	mov    %edi,%ecx
  801fea:	d3 e2                	shl    %cl,%edx
  801fec:	39 c2                	cmp    %eax,%edx
  801fee:	73 eb                	jae    801fdb <__udivdi3+0xe7>
  801ff0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ff3:	31 ff                	xor    %edi,%edi
  801ff5:	e9 40 ff ff ff       	jmp    801f3a <__udivdi3+0x46>
  801ffa:	66 90                	xchg   %ax,%ax
  801ffc:	31 c0                	xor    %eax,%eax
  801ffe:	e9 37 ff ff ff       	jmp    801f3a <__udivdi3+0x46>
  802003:	90                   	nop

00802004 <__umoddi3>:
  802004:	55                   	push   %ebp
  802005:	57                   	push   %edi
  802006:	56                   	push   %esi
  802007:	53                   	push   %ebx
  802008:	83 ec 1c             	sub    $0x1c,%esp
  80200b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80200f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802017:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80201b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80201f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802023:	89 3c 24             	mov    %edi,(%esp)
  802026:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80202a:	89 f2                	mov    %esi,%edx
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 18                	jne    802048 <__umoddi3+0x44>
  802030:	39 f7                	cmp    %esi,%edi
  802032:	0f 86 a0 00 00 00    	jbe    8020d8 <__umoddi3+0xd4>
  802038:	89 c8                	mov    %ecx,%eax
  80203a:	f7 f7                	div    %edi
  80203c:	89 d0                	mov    %edx,%eax
  80203e:	31 d2                	xor    %edx,%edx
  802040:	83 c4 1c             	add    $0x1c,%esp
  802043:	5b                   	pop    %ebx
  802044:	5e                   	pop    %esi
  802045:	5f                   	pop    %edi
  802046:	5d                   	pop    %ebp
  802047:	c3                   	ret    
  802048:	89 f3                	mov    %esi,%ebx
  80204a:	39 f0                	cmp    %esi,%eax
  80204c:	0f 87 a6 00 00 00    	ja     8020f8 <__umoddi3+0xf4>
  802052:	0f bd e8             	bsr    %eax,%ebp
  802055:	83 f5 1f             	xor    $0x1f,%ebp
  802058:	0f 84 a6 00 00 00    	je     802104 <__umoddi3+0x100>
  80205e:	bf 20 00 00 00       	mov    $0x20,%edi
  802063:	29 ef                	sub    %ebp,%edi
  802065:	89 e9                	mov    %ebp,%ecx
  802067:	d3 e0                	shl    %cl,%eax
  802069:	8b 34 24             	mov    (%esp),%esi
  80206c:	89 f2                	mov    %esi,%edx
  80206e:	89 f9                	mov    %edi,%ecx
  802070:	d3 ea                	shr    %cl,%edx
  802072:	09 c2                	or     %eax,%edx
  802074:	89 14 24             	mov    %edx,(%esp)
  802077:	89 f2                	mov    %esi,%edx
  802079:	89 e9                	mov    %ebp,%ecx
  80207b:	d3 e2                	shl    %cl,%edx
  80207d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802081:	89 de                	mov    %ebx,%esi
  802083:	89 f9                	mov    %edi,%ecx
  802085:	d3 ee                	shr    %cl,%esi
  802087:	89 e9                	mov    %ebp,%ecx
  802089:	d3 e3                	shl    %cl,%ebx
  80208b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80208f:	89 d0                	mov    %edx,%eax
  802091:	89 f9                	mov    %edi,%ecx
  802093:	d3 e8                	shr    %cl,%eax
  802095:	09 d8                	or     %ebx,%eax
  802097:	89 d3                	mov    %edx,%ebx
  802099:	89 e9                	mov    %ebp,%ecx
  80209b:	d3 e3                	shl    %cl,%ebx
  80209d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020a1:	89 f2                	mov    %esi,%edx
  8020a3:	f7 34 24             	divl   (%esp)
  8020a6:	89 d6                	mov    %edx,%esi
  8020a8:	f7 64 24 04          	mull   0x4(%esp)
  8020ac:	89 c3                	mov    %eax,%ebx
  8020ae:	89 d1                	mov    %edx,%ecx
  8020b0:	39 d6                	cmp    %edx,%esi
  8020b2:	72 7c                	jb     802130 <__umoddi3+0x12c>
  8020b4:	74 72                	je     802128 <__umoddi3+0x124>
  8020b6:	8b 54 24 08          	mov    0x8(%esp),%edx
  8020ba:	29 da                	sub    %ebx,%edx
  8020bc:	19 ce                	sbb    %ecx,%esi
  8020be:	89 f0                	mov    %esi,%eax
  8020c0:	89 f9                	mov    %edi,%ecx
  8020c2:	d3 e0                	shl    %cl,%eax
  8020c4:	89 e9                	mov    %ebp,%ecx
  8020c6:	d3 ea                	shr    %cl,%edx
  8020c8:	09 d0                	or     %edx,%eax
  8020ca:	89 e9                	mov    %ebp,%ecx
  8020cc:	d3 ee                	shr    %cl,%esi
  8020ce:	89 f2                	mov    %esi,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	89 fd                	mov    %edi,%ebp
  8020da:	85 ff                	test   %edi,%edi
  8020dc:	75 0b                	jne    8020e9 <__umoddi3+0xe5>
  8020de:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e3:	31 d2                	xor    %edx,%edx
  8020e5:	f7 f7                	div    %edi
  8020e7:	89 c5                	mov    %eax,%ebp
  8020e9:	89 f0                	mov    %esi,%eax
  8020eb:	31 d2                	xor    %edx,%edx
  8020ed:	f7 f5                	div    %ebp
  8020ef:	89 c8                	mov    %ecx,%eax
  8020f1:	f7 f5                	div    %ebp
  8020f3:	e9 44 ff ff ff       	jmp    80203c <__umoddi3+0x38>
  8020f8:	89 c8                	mov    %ecx,%eax
  8020fa:	89 f2                	mov    %esi,%edx
  8020fc:	83 c4 1c             	add    $0x1c,%esp
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5f                   	pop    %edi
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    
  802104:	39 f0                	cmp    %esi,%eax
  802106:	72 05                	jb     80210d <__umoddi3+0x109>
  802108:	39 0c 24             	cmp    %ecx,(%esp)
  80210b:	77 0c                	ja     802119 <__umoddi3+0x115>
  80210d:	89 f2                	mov    %esi,%edx
  80210f:	29 f9                	sub    %edi,%ecx
  802111:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802115:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802119:	8b 44 24 04          	mov    0x4(%esp),%eax
  80211d:	83 c4 1c             	add    $0x1c,%esp
  802120:	5b                   	pop    %ebx
  802121:	5e                   	pop    %esi
  802122:	5f                   	pop    %edi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    
  802125:	8d 76 00             	lea    0x0(%esi),%esi
  802128:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80212c:	73 88                	jae    8020b6 <__umoddi3+0xb2>
  80212e:	66 90                	xchg   %ax,%ax
  802130:	2b 44 24 04          	sub    0x4(%esp),%eax
  802134:	1b 14 24             	sbb    (%esp),%edx
  802137:	89 d1                	mov    %edx,%ecx
  802139:	89 c3                	mov    %eax,%ebx
  80213b:	e9 76 ff ff ff       	jmp    8020b6 <__umoddi3+0xb2>
