
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b5 00 00 00       	call   8000e6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 c0 0b 00 00       	call   800bfd <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 4c 0f 00 00       	call   800f95 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0d                	je     80005a <umain+0x27>
	for (i = 0; i < 20; i++)
  80004d:	43                   	inc    %ebx
  80004e:	83 fb 14             	cmp    $0x14,%ebx
  800051:	75 f1                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800053:	e8 8b 0c 00 00       	call   800ce3 <sys_yield>
		return;
  800058:	eb 6e                	jmp    8000c8 <umain+0x95>
	if (i == 20) {
  80005a:	83 fb 14             	cmp    $0x14,%ebx
  80005d:	74 f4                	je     800053 <umain+0x20>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005f:	89 f0                	mov    %esi,%eax
  800061:	25 ff 03 00 00       	and    $0x3ff,%eax
  800066:	89 c2                	mov    %eax,%edx
  800068:	c1 e2 05             	shl    $0x5,%edx
  80006b:	29 c2                	sub    %eax,%edx
  80006d:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  800074:	eb 02                	jmp    800078 <umain+0x45>
		asm volatile("pause");
  800076:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800078:	8b 42 54             	mov    0x54(%edx),%eax
  80007b:	85 c0                	test   %eax,%eax
  80007d:	75 f7                	jne    800076 <umain+0x43>
  80007f:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800084:	e8 5a 0c 00 00       	call   800ce3 <sys_yield>
  800089:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  80008e:	a1 04 40 80 00       	mov    0x804004,%eax
  800093:	40                   	inc    %eax
  800094:	a3 04 40 80 00       	mov    %eax,0x804004
		for (j = 0; j < 10000; j++)
  800099:	4a                   	dec    %edx
  80009a:	75 f2                	jne    80008e <umain+0x5b>
	for (i = 0; i < 10; i++) {
  80009c:	4b                   	dec    %ebx
  80009d:	75 e5                	jne    800084 <umain+0x51>
	}

	if (counter != 10*10000)
  80009f:	a1 04 40 80 00       	mov    0x804004,%eax
  8000a4:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000a9:	75 24                	jne    8000cf <umain+0x9c>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b0:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b3:	8b 40 48             	mov    0x48(%eax),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	52                   	push   %edx
  8000ba:	50                   	push   %eax
  8000bb:	68 db 22 80 00       	push   $0x8022db
  8000c0:	e8 9a 01 00 00       	call   80025f <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

}
  8000c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cb:	5b                   	pop    %ebx
  8000cc:	5e                   	pop    %esi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000cf:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d4:	50                   	push   %eax
  8000d5:	68 a0 22 80 00       	push   $0x8022a0
  8000da:	6a 21                	push   $0x21
  8000dc:	68 c8 22 80 00       	push   $0x8022c8
  8000e1:	e8 66 00 00 00       	call   80014c <_panic>

008000e6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ee:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f1:	e8 07 0b 00 00       	call   800bfd <sys_getenvid>
  8000f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fb:	89 c2                	mov    %eax,%edx
  8000fd:	c1 e2 05             	shl    $0x5,%edx
  800100:	29 c2                	sub    %eax,%edx
  800102:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800109:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010e:	85 db                	test   %ebx,%ebx
  800110:	7e 07                	jle    800119 <libmain+0x33>
		binaryname = argv[0];
  800112:	8b 06                	mov    (%esi),%eax
  800114:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800119:	83 ec 08             	sub    $0x8,%esp
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	e8 10 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800123:	e8 0a 00 00 00       	call   800132 <exit>
}
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800138:	e8 ed 11 00 00       	call   80132a <close_all>
	sys_env_destroy(0);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	6a 00                	push   $0x0
  800142:	e8 75 0a 00 00       	call   800bbc <sys_env_destroy>
}
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	c9                   	leave  
  80014b:	c3                   	ret    

0080014c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	57                   	push   %edi
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
  800152:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800158:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80015b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800161:	e8 97 0a 00 00       	call   800bfd <sys_getenvid>
  800166:	83 ec 04             	sub    $0x4,%esp
  800169:	ff 75 0c             	pushl  0xc(%ebp)
  80016c:	ff 75 08             	pushl  0x8(%ebp)
  80016f:	53                   	push   %ebx
  800170:	50                   	push   %eax
  800171:	68 04 23 80 00       	push   $0x802304
  800176:	68 00 01 00 00       	push   $0x100
  80017b:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800181:	56                   	push   %esi
  800182:	e8 93 06 00 00       	call   80081a <snprintf>
  800187:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800189:	83 c4 20             	add    $0x20,%esp
  80018c:	57                   	push   %edi
  80018d:	ff 75 10             	pushl  0x10(%ebp)
  800190:	bf 00 01 00 00       	mov    $0x100,%edi
  800195:	89 f8                	mov    %edi,%eax
  800197:	29 d8                	sub    %ebx,%eax
  800199:	50                   	push   %eax
  80019a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80019d:	50                   	push   %eax
  80019e:	e8 22 06 00 00       	call   8007c5 <vsnprintf>
  8001a3:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8001a5:	83 c4 0c             	add    $0xc,%esp
  8001a8:	68 f7 22 80 00       	push   $0x8022f7
  8001ad:	29 df                	sub    %ebx,%edi
  8001af:	57                   	push   %edi
  8001b0:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8001b3:	50                   	push   %eax
  8001b4:	e8 61 06 00 00       	call   80081a <snprintf>
	sys_cputs(buf, r);
  8001b9:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8001bc:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8001be:	53                   	push   %ebx
  8001bf:	56                   	push   %esi
  8001c0:	e8 ba 09 00 00       	call   800b7f <sys_cputs>
  8001c5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c8:	cc                   	int3   
  8001c9:	eb fd                	jmp    8001c8 <_panic+0x7c>

008001cb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d5:	8b 13                	mov    (%ebx),%edx
  8001d7:	8d 42 01             	lea    0x1(%edx),%eax
  8001da:	89 03                	mov    %eax,(%ebx)
  8001dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001df:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e8:	74 08                	je     8001f2 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ea:	ff 43 04             	incl   0x4(%ebx)
}
  8001ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	68 ff 00 00 00       	push   $0xff
  8001fa:	8d 43 08             	lea    0x8(%ebx),%eax
  8001fd:	50                   	push   %eax
  8001fe:	e8 7c 09 00 00       	call   800b7f <sys_cputs>
		b->idx = 0;
  800203:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	eb dc                	jmp    8001ea <putch+0x1f>

0080020e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020e:	55                   	push   %ebp
  80020f:	89 e5                	mov    %esp,%ebp
  800211:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800217:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021e:	00 00 00 
	b.cnt = 0;
  800221:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800228:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022b:	ff 75 0c             	pushl  0xc(%ebp)
  80022e:	ff 75 08             	pushl  0x8(%ebp)
  800231:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800237:	50                   	push   %eax
  800238:	68 cb 01 80 00       	push   $0x8001cb
  80023d:	e8 17 01 00 00       	call   800359 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800242:	83 c4 08             	add    $0x8,%esp
  800245:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80024b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800251:	50                   	push   %eax
  800252:	e8 28 09 00 00       	call   800b7f <sys_cputs>

	return b.cnt;
}
  800257:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

0080025f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800265:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800268:	50                   	push   %eax
  800269:	ff 75 08             	pushl  0x8(%ebp)
  80026c:	e8 9d ff ff ff       	call   80020e <vcprintf>
	va_end(ap);

	return cnt;
}
  800271:	c9                   	leave  
  800272:	c3                   	ret    

00800273 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	57                   	push   %edi
  800277:	56                   	push   %esi
  800278:	53                   	push   %ebx
  800279:	83 ec 1c             	sub    $0x1c,%esp
  80027c:	89 c7                	mov    %eax,%edi
  80027e:	89 d6                	mov    %edx,%esi
  800280:	8b 45 08             	mov    0x8(%ebp),%eax
  800283:	8b 55 0c             	mov    0xc(%ebp),%edx
  800286:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800289:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80028c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80028f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800294:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800297:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80029a:	39 d3                	cmp    %edx,%ebx
  80029c:	72 05                	jb     8002a3 <printnum+0x30>
  80029e:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002a1:	77 78                	ja     80031b <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	ff 75 18             	pushl  0x18(%ebp)
  8002a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002af:	53                   	push   %ebx
  8002b0:	ff 75 10             	pushl  0x10(%ebp)
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c2:	e8 71 1d 00 00       	call   802038 <__udivdi3>
  8002c7:	83 c4 18             	add    $0x18,%esp
  8002ca:	52                   	push   %edx
  8002cb:	50                   	push   %eax
  8002cc:	89 f2                	mov    %esi,%edx
  8002ce:	89 f8                	mov    %edi,%eax
  8002d0:	e8 9e ff ff ff       	call   800273 <printnum>
  8002d5:	83 c4 20             	add    $0x20,%esp
  8002d8:	eb 11                	jmp    8002eb <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	56                   	push   %esi
  8002de:	ff 75 18             	pushl  0x18(%ebp)
  8002e1:	ff d7                	call   *%edi
  8002e3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002e6:	4b                   	dec    %ebx
  8002e7:	85 db                	test   %ebx,%ebx
  8002e9:	7f ef                	jg     8002da <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	56                   	push   %esi
  8002ef:	83 ec 04             	sub    $0x4,%esp
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8002fe:	e8 45 1e 00 00       	call   802148 <__umoddi3>
  800303:	83 c4 14             	add    $0x14,%esp
  800306:	0f be 80 27 23 80 00 	movsbl 0x802327(%eax),%eax
  80030d:	50                   	push   %eax
  80030e:	ff d7                	call   *%edi
}
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800316:	5b                   	pop    %ebx
  800317:	5e                   	pop    %esi
  800318:	5f                   	pop    %edi
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    
  80031b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80031e:	eb c6                	jmp    8002e6 <printnum+0x73>

00800320 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800326:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	3b 50 04             	cmp    0x4(%eax),%edx
  80032e:	73 0a                	jae    80033a <sprintputch+0x1a>
		*b->buf++ = ch;
  800330:	8d 4a 01             	lea    0x1(%edx),%ecx
  800333:	89 08                	mov    %ecx,(%eax)
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	88 02                	mov    %al,(%edx)
}
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    

0080033c <printfmt>:
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800342:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 05 00 00 00       	call   800359 <vprintfmt>
}
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <vprintfmt>:
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	57                   	push   %edi
  80035d:	56                   	push   %esi
  80035e:	53                   	push   %ebx
  80035f:	83 ec 2c             	sub    $0x2c,%esp
  800362:	8b 75 08             	mov    0x8(%ebp),%esi
  800365:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800368:	8b 7d 10             	mov    0x10(%ebp),%edi
  80036b:	e9 ae 03 00 00       	jmp    80071e <vprintfmt+0x3c5>
  800370:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800374:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80037b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800382:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800389:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	8d 47 01             	lea    0x1(%edi),%eax
  800391:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800394:	8a 17                	mov    (%edi),%dl
  800396:	8d 42 dd             	lea    -0x23(%edx),%eax
  800399:	3c 55                	cmp    $0x55,%al
  80039b:	0f 87 fe 03 00 00    	ja     80079f <vprintfmt+0x446>
  8003a1:	0f b6 c0             	movzbl %al,%eax
  8003a4:	ff 24 85 60 24 80 00 	jmp    *0x802460(,%eax,4)
  8003ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ae:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003b2:	eb da                	jmp    80038e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003b7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003bb:	eb d1                	jmp    80038e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003bd:	0f b6 d2             	movzbl %dl,%edx
  8003c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003cb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8003d4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003d7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003da:	83 f9 09             	cmp    $0x9,%ecx
  8003dd:	77 52                	ja     800431 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8003df:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8003e0:	eb e9                	jmp    8003cb <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ed:	8d 40 04             	lea    0x4(%eax),%eax
  8003f0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fa:	79 92                	jns    80038e <vprintfmt+0x35>
				width = precision, precision = -1;
  8003fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800402:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800409:	eb 83                	jmp    80038e <vprintfmt+0x35>
  80040b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040f:	78 08                	js     800419 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800414:	e9 75 ff ff ff       	jmp    80038e <vprintfmt+0x35>
  800419:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800420:	eb ef                	jmp    800411 <vprintfmt+0xb8>
  800422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800425:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80042c:	e9 5d ff ff ff       	jmp    80038e <vprintfmt+0x35>
  800431:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800434:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800437:	eb bd                	jmp    8003f6 <vprintfmt+0x9d>
			lflag++;
  800439:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043d:	e9 4c ff ff ff       	jmp    80038e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	8d 78 04             	lea    0x4(%eax),%edi
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	53                   	push   %ebx
  80044c:	ff 30                	pushl  (%eax)
  80044e:	ff d6                	call   *%esi
			break;
  800450:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800456:	e9 c0 02 00 00       	jmp    80071b <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 78 04             	lea    0x4(%eax),%edi
  800461:	8b 00                	mov    (%eax),%eax
  800463:	85 c0                	test   %eax,%eax
  800465:	78 2a                	js     800491 <vprintfmt+0x138>
  800467:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800469:	83 f8 0f             	cmp    $0xf,%eax
  80046c:	7f 27                	jg     800495 <vprintfmt+0x13c>
  80046e:	8b 04 85 c0 25 80 00 	mov    0x8025c0(,%eax,4),%eax
  800475:	85 c0                	test   %eax,%eax
  800477:	74 1c                	je     800495 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800479:	50                   	push   %eax
  80047a:	68 e8 26 80 00       	push   $0x8026e8
  80047f:	53                   	push   %ebx
  800480:	56                   	push   %esi
  800481:	e8 b6 fe ff ff       	call   80033c <printfmt>
  800486:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800489:	89 7d 14             	mov    %edi,0x14(%ebp)
  80048c:	e9 8a 02 00 00       	jmp    80071b <vprintfmt+0x3c2>
  800491:	f7 d8                	neg    %eax
  800493:	eb d2                	jmp    800467 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800495:	52                   	push   %edx
  800496:	68 3f 23 80 00       	push   $0x80233f
  80049b:	53                   	push   %ebx
  80049c:	56                   	push   %esi
  80049d:	e8 9a fe ff ff       	call   80033c <printfmt>
  8004a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a8:	e9 6e 02 00 00       	jmp    80071b <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	8b 38                	mov    (%eax),%edi
  8004bb:	85 ff                	test   %edi,%edi
  8004bd:	74 39                	je     8004f8 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8004bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c3:	0f 8e a9 00 00 00    	jle    800572 <vprintfmt+0x219>
  8004c9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004cd:	0f 84 a7 00 00 00    	je     80057a <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 d0             	pushl  -0x30(%ebp)
  8004d9:	57                   	push   %edi
  8004da:	e8 6b 03 00 00       	call   80084a <strnlen>
  8004df:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e2:	29 c1                	sub    %eax,%ecx
  8004e4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004e7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004ea:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004f4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f6:	eb 14                	jmp    80050c <vprintfmt+0x1b3>
				p = "(null)";
  8004f8:	bf 38 23 80 00       	mov    $0x802338,%edi
  8004fd:	eb c0                	jmp    8004bf <vprintfmt+0x166>
					putch(padc, putdat);
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	53                   	push   %ebx
  800503:	ff 75 e0             	pushl  -0x20(%ebp)
  800506:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800508:	4f                   	dec    %edi
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	85 ff                	test   %edi,%edi
  80050e:	7f ef                	jg     8004ff <vprintfmt+0x1a6>
  800510:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800513:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800516:	89 c8                	mov    %ecx,%eax
  800518:	85 c9                	test   %ecx,%ecx
  80051a:	78 10                	js     80052c <vprintfmt+0x1d3>
  80051c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80051f:	29 c1                	sub    %eax,%ecx
  800521:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800524:	89 75 08             	mov    %esi,0x8(%ebp)
  800527:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80052a:	eb 15                	jmp    800541 <vprintfmt+0x1e8>
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
  800531:	eb e9                	jmp    80051c <vprintfmt+0x1c3>
					putch(ch, putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	52                   	push   %edx
  800538:	ff 55 08             	call   *0x8(%ebp)
  80053b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053e:	ff 4d e0             	decl   -0x20(%ebp)
  800541:	47                   	inc    %edi
  800542:	8a 47 ff             	mov    -0x1(%edi),%al
  800545:	0f be d0             	movsbl %al,%edx
  800548:	85 d2                	test   %edx,%edx
  80054a:	74 59                	je     8005a5 <vprintfmt+0x24c>
  80054c:	85 f6                	test   %esi,%esi
  80054e:	78 03                	js     800553 <vprintfmt+0x1fa>
  800550:	4e                   	dec    %esi
  800551:	78 2f                	js     800582 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800553:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800557:	74 da                	je     800533 <vprintfmt+0x1da>
  800559:	0f be c0             	movsbl %al,%eax
  80055c:	83 e8 20             	sub    $0x20,%eax
  80055f:	83 f8 5e             	cmp    $0x5e,%eax
  800562:	76 cf                	jbe    800533 <vprintfmt+0x1da>
					putch('?', putdat);
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	53                   	push   %ebx
  800568:	6a 3f                	push   $0x3f
  80056a:	ff 55 08             	call   *0x8(%ebp)
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	eb cc                	jmp    80053e <vprintfmt+0x1e5>
  800572:	89 75 08             	mov    %esi,0x8(%ebp)
  800575:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800578:	eb c7                	jmp    800541 <vprintfmt+0x1e8>
  80057a:	89 75 08             	mov    %esi,0x8(%ebp)
  80057d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800580:	eb bf                	jmp    800541 <vprintfmt+0x1e8>
  800582:	8b 75 08             	mov    0x8(%ebp),%esi
  800585:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800588:	eb 0c                	jmp    800596 <vprintfmt+0x23d>
				putch(' ', putdat);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	53                   	push   %ebx
  80058e:	6a 20                	push   $0x20
  800590:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800592:	4f                   	dec    %edi
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	85 ff                	test   %edi,%edi
  800598:	7f f0                	jg     80058a <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80059a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a0:	e9 76 01 00 00       	jmp    80071b <vprintfmt+0x3c2>
  8005a5:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ab:	eb e9                	jmp    800596 <vprintfmt+0x23d>
	if (lflag >= 2)
  8005ad:	83 f9 01             	cmp    $0x1,%ecx
  8005b0:	7f 1f                	jg     8005d1 <vprintfmt+0x278>
	else if (lflag)
  8005b2:	85 c9                	test   %ecx,%ecx
  8005b4:	75 48                	jne    8005fe <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	89 c1                	mov    %eax,%ecx
  8005c0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8d 40 04             	lea    0x4(%eax),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cf:	eb 17                	jmp    8005e8 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8b 50 04             	mov    0x4(%eax),%edx
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 08             	lea    0x8(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005eb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8005ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f2:	78 25                	js     800619 <vprintfmt+0x2c0>
			base = 10;
  8005f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f9:	e9 03 01 00 00       	jmp    800701 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800606:	89 c1                	mov    %eax,%ecx
  800608:	c1 f9 1f             	sar    $0x1f,%ecx
  80060b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
  800617:	eb cf                	jmp    8005e8 <vprintfmt+0x28f>
				putch('-', putdat);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 2d                	push   $0x2d
  80061f:	ff d6                	call   *%esi
				num = -(long long) num;
  800621:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800624:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800627:	f7 da                	neg    %edx
  800629:	83 d1 00             	adc    $0x0,%ecx
  80062c:	f7 d9                	neg    %ecx
  80062e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800631:	b8 0a 00 00 00       	mov    $0xa,%eax
  800636:	e9 c6 00 00 00       	jmp    800701 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80063b:	83 f9 01             	cmp    $0x1,%ecx
  80063e:	7f 1e                	jg     80065e <vprintfmt+0x305>
	else if (lflag)
  800640:	85 c9                	test   %ecx,%ecx
  800642:	75 32                	jne    800676 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 10                	mov    (%eax),%edx
  800649:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800654:	b8 0a 00 00 00       	mov    $0xa,%eax
  800659:	e9 a3 00 00 00       	jmp    800701 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 10                	mov    (%eax),%edx
  800663:	8b 48 04             	mov    0x4(%eax),%ecx
  800666:	8d 40 08             	lea    0x8(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800671:	e9 8b 00 00 00       	jmp    800701 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 10                	mov    (%eax),%edx
  80067b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800680:	8d 40 04             	lea    0x4(%eax),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800686:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068b:	eb 74                	jmp    800701 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80068d:	83 f9 01             	cmp    $0x1,%ecx
  800690:	7f 1b                	jg     8006ad <vprintfmt+0x354>
	else if (lflag)
  800692:	85 c9                	test   %ecx,%ecx
  800694:	75 2c                	jne    8006c2 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 10                	mov    (%eax),%edx
  80069b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a0:	8d 40 04             	lea    0x4(%eax),%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ab:	eb 54                	jmp    800701 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b5:	8d 40 08             	lea    0x8(%eax),%eax
  8006b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c0:	eb 3f                	jmp    800701 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 10                	mov    (%eax),%edx
  8006c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cc:	8d 40 04             	lea    0x4(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d7:	eb 28                	jmp    800701 <vprintfmt+0x3a8>
			putch('0', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 30                	push   $0x30
  8006df:	ff d6                	call   *%esi
			putch('x', putdat);
  8006e1:	83 c4 08             	add    $0x8,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	6a 78                	push   $0x78
  8006e7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8b 10                	mov    (%eax),%edx
  8006ee:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006f3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f6:	8d 40 04             	lea    0x4(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800701:	83 ec 0c             	sub    $0xc,%esp
  800704:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800708:	57                   	push   %edi
  800709:	ff 75 e0             	pushl  -0x20(%ebp)
  80070c:	50                   	push   %eax
  80070d:	51                   	push   %ecx
  80070e:	52                   	push   %edx
  80070f:	89 da                	mov    %ebx,%edx
  800711:	89 f0                	mov    %esi,%eax
  800713:	e8 5b fb ff ff       	call   800273 <printnum>
			break;
  800718:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80071b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071e:	47                   	inc    %edi
  80071f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800723:	83 f8 25             	cmp    $0x25,%eax
  800726:	0f 84 44 fc ff ff    	je     800370 <vprintfmt+0x17>
			if (ch == '\0')
  80072c:	85 c0                	test   %eax,%eax
  80072e:	0f 84 89 00 00 00    	je     8007bd <vprintfmt+0x464>
			putch(ch, putdat);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	53                   	push   %ebx
  800738:	50                   	push   %eax
  800739:	ff d6                	call   *%esi
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	eb de                	jmp    80071e <vprintfmt+0x3c5>
	if (lflag >= 2)
  800740:	83 f9 01             	cmp    $0x1,%ecx
  800743:	7f 1b                	jg     800760 <vprintfmt+0x407>
	else if (lflag)
  800745:	85 c9                	test   %ecx,%ecx
  800747:	75 2c                	jne    800775 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8b 10                	mov    (%eax),%edx
  80074e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800753:	8d 40 04             	lea    0x4(%eax),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800759:	b8 10 00 00 00       	mov    $0x10,%eax
  80075e:	eb a1                	jmp    800701 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 10                	mov    (%eax),%edx
  800765:	8b 48 04             	mov    0x4(%eax),%ecx
  800768:	8d 40 08             	lea    0x8(%eax),%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076e:	b8 10 00 00 00       	mov    $0x10,%eax
  800773:	eb 8c                	jmp    800701 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8b 10                	mov    (%eax),%edx
  80077a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077f:	8d 40 04             	lea    0x4(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800785:	b8 10 00 00 00       	mov    $0x10,%eax
  80078a:	e9 72 ff ff ff       	jmp    800701 <vprintfmt+0x3a8>
			putch(ch, putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	53                   	push   %ebx
  800793:	6a 25                	push   $0x25
  800795:	ff d6                	call   *%esi
			break;
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	e9 7c ff ff ff       	jmp    80071b <vprintfmt+0x3c2>
			putch('%', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	6a 25                	push   $0x25
  8007a5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007a7:	83 c4 10             	add    $0x10,%esp
  8007aa:	89 f8                	mov    %edi,%eax
  8007ac:	eb 01                	jmp    8007af <vprintfmt+0x456>
  8007ae:	48                   	dec    %eax
  8007af:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007b3:	75 f9                	jne    8007ae <vprintfmt+0x455>
  8007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007b8:	e9 5e ff ff ff       	jmp    80071b <vprintfmt+0x3c2>
}
  8007bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007c0:	5b                   	pop    %ebx
  8007c1:	5e                   	pop    %esi
  8007c2:	5f                   	pop    %edi
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007d4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007e2:	85 c0                	test   %eax,%eax
  8007e4:	74 26                	je     80080c <vsnprintf+0x47>
  8007e6:	85 d2                	test   %edx,%edx
  8007e8:	7e 29                	jle    800813 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ea:	ff 75 14             	pushl  0x14(%ebp)
  8007ed:	ff 75 10             	pushl  0x10(%ebp)
  8007f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007f3:	50                   	push   %eax
  8007f4:	68 20 03 80 00       	push   $0x800320
  8007f9:	e8 5b fb ff ff       	call   800359 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800801:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800807:	83 c4 10             	add    $0x10,%esp
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    
		return -E_INVAL;
  80080c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800811:	eb f7                	jmp    80080a <vsnprintf+0x45>
  800813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800818:	eb f0                	jmp    80080a <vsnprintf+0x45>

0080081a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800820:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800823:	50                   	push   %eax
  800824:	ff 75 10             	pushl  0x10(%ebp)
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	ff 75 08             	pushl  0x8(%ebp)
  80082d:	e8 93 ff ff ff       	call   8007c5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	eb 01                	jmp    800842 <strlen+0xe>
		n++;
  800841:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800842:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800846:	75 f9                	jne    800841 <strlen+0xd>
	return n;
}
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800850:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800853:	b8 00 00 00 00       	mov    $0x0,%eax
  800858:	eb 01                	jmp    80085b <strnlen+0x11>
		n++;
  80085a:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085b:	39 d0                	cmp    %edx,%eax
  80085d:	74 06                	je     800865 <strnlen+0x1b>
  80085f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800863:	75 f5                	jne    80085a <strnlen+0x10>
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800871:	89 c2                	mov    %eax,%edx
  800873:	42                   	inc    %edx
  800874:	41                   	inc    %ecx
  800875:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800878:	88 5a ff             	mov    %bl,-0x1(%edx)
  80087b:	84 db                	test   %bl,%bl
  80087d:	75 f4                	jne    800873 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80087f:	5b                   	pop    %ebx
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	53                   	push   %ebx
  800886:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800889:	53                   	push   %ebx
  80088a:	e8 a5 ff ff ff       	call   800834 <strlen>
  80088f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	01 d8                	add    %ebx,%eax
  800897:	50                   	push   %eax
  800898:	e8 ca ff ff ff       	call   800867 <strcpy>
	return dst;
}
  80089d:	89 d8                	mov    %ebx,%eax
  80089f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	56                   	push   %esi
  8008a8:	53                   	push   %ebx
  8008a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008af:	89 f3                	mov    %esi,%ebx
  8008b1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b4:	89 f2                	mov    %esi,%edx
  8008b6:	eb 0c                	jmp    8008c4 <strncpy+0x20>
		*dst++ = *src;
  8008b8:	42                   	inc    %edx
  8008b9:	8a 01                	mov    (%ecx),%al
  8008bb:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008be:	80 39 01             	cmpb   $0x1,(%ecx)
  8008c1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008c4:	39 da                	cmp    %ebx,%edx
  8008c6:	75 f0                	jne    8008b8 <strncpy+0x14>
	}
	return ret;
}
  8008c8:	89 f0                	mov    %esi,%eax
  8008ca:	5b                   	pop    %ebx
  8008cb:	5e                   	pop    %esi
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	56                   	push   %esi
  8008d2:	53                   	push   %ebx
  8008d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008dc:	85 c0                	test   %eax,%eax
  8008de:	74 20                	je     800900 <strlcpy+0x32>
  8008e0:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8008e4:	89 f0                	mov    %esi,%eax
  8008e6:	eb 05                	jmp    8008ed <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008e8:	40                   	inc    %eax
  8008e9:	42                   	inc    %edx
  8008ea:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008ed:	39 d8                	cmp    %ebx,%eax
  8008ef:	74 06                	je     8008f7 <strlcpy+0x29>
  8008f1:	8a 0a                	mov    (%edx),%cl
  8008f3:	84 c9                	test   %cl,%cl
  8008f5:	75 f1                	jne    8008e8 <strlcpy+0x1a>
		*dst = '\0';
  8008f7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008fa:	29 f0                	sub    %esi,%eax
}
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    
  800900:	89 f0                	mov    %esi,%eax
  800902:	eb f6                	jmp    8008fa <strlcpy+0x2c>

00800904 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80090d:	eb 02                	jmp    800911 <strcmp+0xd>
		p++, q++;
  80090f:	41                   	inc    %ecx
  800910:	42                   	inc    %edx
	while (*p && *p == *q)
  800911:	8a 01                	mov    (%ecx),%al
  800913:	84 c0                	test   %al,%al
  800915:	74 04                	je     80091b <strcmp+0x17>
  800917:	3a 02                	cmp    (%edx),%al
  800919:	74 f4                	je     80090f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091b:	0f b6 c0             	movzbl %al,%eax
  80091e:	0f b6 12             	movzbl (%edx),%edx
  800921:	29 d0                	sub    %edx,%eax
}
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	53                   	push   %ebx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092f:	89 c3                	mov    %eax,%ebx
  800931:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800934:	eb 02                	jmp    800938 <strncmp+0x13>
		n--, p++, q++;
  800936:	40                   	inc    %eax
  800937:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800938:	39 d8                	cmp    %ebx,%eax
  80093a:	74 15                	je     800951 <strncmp+0x2c>
  80093c:	8a 08                	mov    (%eax),%cl
  80093e:	84 c9                	test   %cl,%cl
  800940:	74 04                	je     800946 <strncmp+0x21>
  800942:	3a 0a                	cmp    (%edx),%cl
  800944:	74 f0                	je     800936 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800946:	0f b6 00             	movzbl (%eax),%eax
  800949:	0f b6 12             	movzbl (%edx),%edx
  80094c:	29 d0                	sub    %edx,%eax
}
  80094e:	5b                   	pop    %ebx
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    
		return 0;
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
  800956:	eb f6                	jmp    80094e <strncmp+0x29>

00800958 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800961:	8a 10                	mov    (%eax),%dl
  800963:	84 d2                	test   %dl,%dl
  800965:	74 07                	je     80096e <strchr+0x16>
		if (*s == c)
  800967:	38 ca                	cmp    %cl,%dl
  800969:	74 08                	je     800973 <strchr+0x1b>
	for (; *s; s++)
  80096b:	40                   	inc    %eax
  80096c:	eb f3                	jmp    800961 <strchr+0x9>
			return (char *) s;
	return 0;
  80096e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80097e:	8a 10                	mov    (%eax),%dl
  800980:	84 d2                	test   %dl,%dl
  800982:	74 07                	je     80098b <strfind+0x16>
		if (*s == c)
  800984:	38 ca                	cmp    %cl,%dl
  800986:	74 03                	je     80098b <strfind+0x16>
	for (; *s; s++)
  800988:	40                   	inc    %eax
  800989:	eb f3                	jmp    80097e <strfind+0x9>
			break;
	return (char *) s;
}
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	57                   	push   %edi
  800991:	56                   	push   %esi
  800992:	53                   	push   %ebx
  800993:	8b 7d 08             	mov    0x8(%ebp),%edi
  800996:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800999:	85 c9                	test   %ecx,%ecx
  80099b:	74 13                	je     8009b0 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80099d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a3:	75 05                	jne    8009aa <memset+0x1d>
  8009a5:	f6 c1 03             	test   $0x3,%cl
  8009a8:	74 0d                	je     8009b7 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ad:	fc                   	cld    
  8009ae:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009b0:	89 f8                	mov    %edi,%eax
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5f                   	pop    %edi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    
		c &= 0xFF;
  8009b7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009bb:	89 d3                	mov    %edx,%ebx
  8009bd:	c1 e3 08             	shl    $0x8,%ebx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	c1 e0 18             	shl    $0x18,%eax
  8009c5:	89 d6                	mov    %edx,%esi
  8009c7:	c1 e6 10             	shl    $0x10,%esi
  8009ca:	09 f0                	or     %esi,%eax
  8009cc:	09 c2                	or     %eax,%edx
  8009ce:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009d0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d3:	89 d0                	mov    %edx,%eax
  8009d5:	fc                   	cld    
  8009d6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d8:	eb d6                	jmp    8009b0 <memset+0x23>

008009da <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	57                   	push   %edi
  8009de:	56                   	push   %esi
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e8:	39 c6                	cmp    %eax,%esi
  8009ea:	73 33                	jae    800a1f <memmove+0x45>
  8009ec:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ef:	39 d0                	cmp    %edx,%eax
  8009f1:	73 2c                	jae    800a1f <memmove+0x45>
		s += n;
		d += n;
  8009f3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f6:	89 d6                	mov    %edx,%esi
  8009f8:	09 fe                	or     %edi,%esi
  8009fa:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a00:	75 13                	jne    800a15 <memmove+0x3b>
  800a02:	f6 c1 03             	test   $0x3,%cl
  800a05:	75 0e                	jne    800a15 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a07:	83 ef 04             	sub    $0x4,%edi
  800a0a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a0d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a10:	fd                   	std    
  800a11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a13:	eb 07                	jmp    800a1c <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a15:	4f                   	dec    %edi
  800a16:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a19:	fd                   	std    
  800a1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a1c:	fc                   	cld    
  800a1d:	eb 13                	jmp    800a32 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1f:	89 f2                	mov    %esi,%edx
  800a21:	09 c2                	or     %eax,%edx
  800a23:	f6 c2 03             	test   $0x3,%dl
  800a26:	75 05                	jne    800a2d <memmove+0x53>
  800a28:	f6 c1 03             	test   $0x3,%cl
  800a2b:	74 09                	je     800a36 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a2d:	89 c7                	mov    %eax,%edi
  800a2f:	fc                   	cld    
  800a30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a32:	5e                   	pop    %esi
  800a33:	5f                   	pop    %edi
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a39:	89 c7                	mov    %eax,%edi
  800a3b:	fc                   	cld    
  800a3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3e:	eb f2                	jmp    800a32 <memmove+0x58>

00800a40 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a43:	ff 75 10             	pushl  0x10(%ebp)
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 89 ff ff ff       	call   8009da <memmove>
}
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    

00800a53 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	56                   	push   %esi
  800a57:	53                   	push   %ebx
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	89 c6                	mov    %eax,%esi
  800a5d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a63:	39 f0                	cmp    %esi,%eax
  800a65:	74 16                	je     800a7d <memcmp+0x2a>
		if (*s1 != *s2)
  800a67:	8a 08                	mov    (%eax),%cl
  800a69:	8a 1a                	mov    (%edx),%bl
  800a6b:	38 d9                	cmp    %bl,%cl
  800a6d:	75 04                	jne    800a73 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6f:	40                   	inc    %eax
  800a70:	42                   	inc    %edx
  800a71:	eb f0                	jmp    800a63 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a73:	0f b6 c1             	movzbl %cl,%eax
  800a76:	0f b6 db             	movzbl %bl,%ebx
  800a79:	29 d8                	sub    %ebx,%eax
  800a7b:	eb 05                	jmp    800a82 <memcmp+0x2f>
	}

	return 0;
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a94:	39 d0                	cmp    %edx,%eax
  800a96:	73 07                	jae    800a9f <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a98:	38 08                	cmp    %cl,(%eax)
  800a9a:	74 03                	je     800a9f <memfind+0x19>
	for (; s < ends; s++)
  800a9c:	40                   	inc    %eax
  800a9d:	eb f5                	jmp    800a94 <memfind+0xe>
			break;
	return (void *) s;
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	57                   	push   %edi
  800aa5:	56                   	push   %esi
  800aa6:	53                   	push   %ebx
  800aa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aaa:	eb 01                	jmp    800aad <strtol+0xc>
		s++;
  800aac:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800aad:	8a 01                	mov    (%ecx),%al
  800aaf:	3c 20                	cmp    $0x20,%al
  800ab1:	74 f9                	je     800aac <strtol+0xb>
  800ab3:	3c 09                	cmp    $0x9,%al
  800ab5:	74 f5                	je     800aac <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800ab7:	3c 2b                	cmp    $0x2b,%al
  800ab9:	74 2b                	je     800ae6 <strtol+0x45>
		s++;
	else if (*s == '-')
  800abb:	3c 2d                	cmp    $0x2d,%al
  800abd:	74 2f                	je     800aee <strtol+0x4d>
	int neg = 0;
  800abf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac4:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800acb:	75 12                	jne    800adf <strtol+0x3e>
  800acd:	80 39 30             	cmpb   $0x30,(%ecx)
  800ad0:	74 24                	je     800af6 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ad2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad6:	75 07                	jne    800adf <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ad8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	eb 4e                	jmp    800b34 <strtol+0x93>
		s++;
  800ae6:	41                   	inc    %ecx
	int neg = 0;
  800ae7:	bf 00 00 00 00       	mov    $0x0,%edi
  800aec:	eb d6                	jmp    800ac4 <strtol+0x23>
		s++, neg = 1;
  800aee:	41                   	inc    %ecx
  800aef:	bf 01 00 00 00       	mov    $0x1,%edi
  800af4:	eb ce                	jmp    800ac4 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800afa:	74 10                	je     800b0c <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800afc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b00:	75 dd                	jne    800adf <strtol+0x3e>
		s++, base = 8;
  800b02:	41                   	inc    %ecx
  800b03:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800b0a:	eb d3                	jmp    800adf <strtol+0x3e>
		s += 2, base = 16;
  800b0c:	83 c1 02             	add    $0x2,%ecx
  800b0f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800b16:	eb c7                	jmp    800adf <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b18:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b1b:	89 f3                	mov    %esi,%ebx
  800b1d:	80 fb 19             	cmp    $0x19,%bl
  800b20:	77 24                	ja     800b46 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800b22:	0f be d2             	movsbl %dl,%edx
  800b25:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b28:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b2b:	7d 2b                	jge    800b58 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800b2d:	41                   	inc    %ecx
  800b2e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b32:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b34:	8a 11                	mov    (%ecx),%dl
  800b36:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b39:	80 fb 09             	cmp    $0x9,%bl
  800b3c:	77 da                	ja     800b18 <strtol+0x77>
			dig = *s - '0';
  800b3e:	0f be d2             	movsbl %dl,%edx
  800b41:	83 ea 30             	sub    $0x30,%edx
  800b44:	eb e2                	jmp    800b28 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b46:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b49:	89 f3                	mov    %esi,%ebx
  800b4b:	80 fb 19             	cmp    $0x19,%bl
  800b4e:	77 08                	ja     800b58 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b50:	0f be d2             	movsbl %dl,%edx
  800b53:	83 ea 37             	sub    $0x37,%edx
  800b56:	eb d0                	jmp    800b28 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5c:	74 05                	je     800b63 <strtol+0xc2>
		*endptr = (char *) s;
  800b5e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b61:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b63:	85 ff                	test   %edi,%edi
  800b65:	74 02                	je     800b69 <strtol+0xc8>
  800b67:	f7 d8                	neg    %eax
}
  800b69:	5b                   	pop    %ebx
  800b6a:	5e                   	pop    %esi
  800b6b:	5f                   	pop    %edi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <atoi>:

int
atoi(const char *s)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b71:	6a 0a                	push   $0xa
  800b73:	6a 00                	push   $0x0
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	e8 24 ff ff ff       	call   800aa1 <strtol>
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	57                   	push   %edi
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b90:	89 c3                	mov    %eax,%ebx
  800b92:	89 c7                	mov    %eax,%edi
  800b94:	89 c6                	mov    %eax,%esi
  800b96:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5f                   	pop    %edi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <sys_cgetc>:

int
sys_cgetc(void)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	57                   	push   %edi
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bad:	89 d1                	mov    %edx,%ecx
  800baf:	89 d3                	mov    %edx,%ebx
  800bb1:	89 d7                	mov    %edx,%edi
  800bb3:	89 d6                	mov    %edx,%esi
  800bb5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
  800bc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd2:	89 cb                	mov    %ecx,%ebx
  800bd4:	89 cf                	mov    %ecx,%edi
  800bd6:	89 ce                	mov    %ecx,%esi
  800bd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bda:	85 c0                	test   %eax,%eax
  800bdc:	7f 08                	jg     800be6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be6:	83 ec 0c             	sub    $0xc,%esp
  800be9:	50                   	push   %eax
  800bea:	6a 03                	push   $0x3
  800bec:	68 1f 26 80 00       	push   $0x80261f
  800bf1:	6a 23                	push   $0x23
  800bf3:	68 3c 26 80 00       	push   $0x80263c
  800bf8:	e8 4f f5 ff ff       	call   80014c <_panic>

00800bfd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	57                   	push   %edi
  800c01:	56                   	push   %esi
  800c02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c03:	ba 00 00 00 00       	mov    $0x0,%edx
  800c08:	b8 02 00 00 00       	mov    $0x2,%eax
  800c0d:	89 d1                	mov    %edx,%ecx
  800c0f:	89 d3                	mov    %edx,%ebx
  800c11:	89 d7                	mov    %edx,%edi
  800c13:	89 d6                	mov    %edx,%esi
  800c15:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c17:	5b                   	pop    %ebx
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	57                   	push   %edi
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c25:	be 00 00 00 00       	mov    $0x0,%esi
  800c2a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c32:	8b 55 08             	mov    0x8(%ebp),%edx
  800c35:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c38:	89 f7                	mov    %esi,%edi
  800c3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	7f 08                	jg     800c48 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	50                   	push   %eax
  800c4c:	6a 04                	push   $0x4
  800c4e:	68 1f 26 80 00       	push   $0x80261f
  800c53:	6a 23                	push   $0x23
  800c55:	68 3c 26 80 00       	push   $0x80263c
  800c5a:	e8 ed f4 ff ff       	call   80014c <_panic>

00800c5f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	57                   	push   %edi
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
  800c65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c68:	b8 05 00 00 00       	mov    $0x5,%eax
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	8b 55 08             	mov    0x8(%ebp),%edx
  800c73:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c76:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c79:	8b 75 18             	mov    0x18(%ebp),%esi
  800c7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7e:	85 c0                	test   %eax,%eax
  800c80:	7f 08                	jg     800c8a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8a:	83 ec 0c             	sub    $0xc,%esp
  800c8d:	50                   	push   %eax
  800c8e:	6a 05                	push   $0x5
  800c90:	68 1f 26 80 00       	push   $0x80261f
  800c95:	6a 23                	push   $0x23
  800c97:	68 3c 26 80 00       	push   $0x80263c
  800c9c:	e8 ab f4 ff ff       	call   80014c <_panic>

00800ca1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800caf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	89 df                	mov    %ebx,%edi
  800cbc:	89 de                	mov    %ebx,%esi
  800cbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc0:	85 c0                	test   %eax,%eax
  800cc2:	7f 08                	jg     800ccc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccc:	83 ec 0c             	sub    $0xc,%esp
  800ccf:	50                   	push   %eax
  800cd0:	6a 06                	push   $0x6
  800cd2:	68 1f 26 80 00       	push   $0x80261f
  800cd7:	6a 23                	push   $0x23
  800cd9:	68 3c 26 80 00       	push   $0x80263c
  800cde:	e8 69 f4 ff ff       	call   80014c <_panic>

00800ce3 <sys_yield>:

void
sys_yield(void)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	89 d6                	mov    %edx,%esi
  800cfb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d10:	b8 08 00 00 00       	mov    $0x8,%eax
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	89 df                	mov    %ebx,%edi
  800d1d:	89 de                	mov    %ebx,%esi
  800d1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d21:	85 c0                	test   %eax,%eax
  800d23:	7f 08                	jg     800d2d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	50                   	push   %eax
  800d31:	6a 08                	push   $0x8
  800d33:	68 1f 26 80 00       	push   $0x80261f
  800d38:	6a 23                	push   $0x23
  800d3a:	68 3c 26 80 00       	push   $0x80263c
  800d3f:	e8 08 f4 ff ff       	call   80014c <_panic>

00800d44 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d52:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	89 cb                	mov    %ecx,%ebx
  800d5c:	89 cf                	mov    %ecx,%edi
  800d5e:	89 ce                	mov    %ecx,%esi
  800d60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d62:	85 c0                	test   %eax,%eax
  800d64:	7f 08                	jg     800d6e <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	50                   	push   %eax
  800d72:	6a 0c                	push   $0xc
  800d74:	68 1f 26 80 00       	push   $0x80261f
  800d79:	6a 23                	push   $0x23
  800d7b:	68 3c 26 80 00       	push   $0x80263c
  800d80:	e8 c7 f3 ff ff       	call   80014c <_panic>

00800d85 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d93:	b8 09 00 00 00       	mov    $0x9,%eax
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	89 df                	mov    %ebx,%edi
  800da0:	89 de                	mov    %ebx,%esi
  800da2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	7f 08                	jg     800db0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	50                   	push   %eax
  800db4:	6a 09                	push   $0x9
  800db6:	68 1f 26 80 00       	push   $0x80261f
  800dbb:	6a 23                	push   $0x23
  800dbd:	68 3c 26 80 00       	push   $0x80263c
  800dc2:	e8 85 f3 ff ff       	call   80014c <_panic>

00800dc7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	89 df                	mov    %ebx,%edi
  800de2:	89 de                	mov    %ebx,%esi
  800de4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7f 08                	jg     800df2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800df6:	6a 0a                	push   $0xa
  800df8:	68 1f 26 80 00       	push   $0x80261f
  800dfd:	6a 23                	push   $0x23
  800dff:	68 3c 26 80 00       	push   $0x80263c
  800e04:	e8 43 f3 ff ff       	call   80014c <_panic>

00800e09 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0f:	be 00 00 00 00       	mov    $0x0,%esi
  800e14:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e22:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e25:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	57                   	push   %edi
  800e30:	56                   	push   %esi
  800e31:	53                   	push   %ebx
  800e32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	89 cb                	mov    %ecx,%ebx
  800e44:	89 cf                	mov    %ecx,%edi
  800e46:	89 ce                	mov    %ecx,%esi
  800e48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	7f 08                	jg     800e56 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	50                   	push   %eax
  800e5a:	6a 0e                	push   $0xe
  800e5c:	68 1f 26 80 00       	push   $0x80261f
  800e61:	6a 23                	push   $0x23
  800e63:	68 3c 26 80 00       	push   $0x80263c
  800e68:	e8 df f2 ff ff       	call   80014c <_panic>

00800e6d <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e73:	be 00 00 00 00       	mov    $0x0,%esi
  800e78:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e86:	89 f7                	mov    %esi,%edi
  800e88:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    

00800e8f <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e95:	be 00 00 00 00       	mov    $0x0,%esi
  800e9a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea8:	89 f7                	mov    %esi,%edi
  800eaa:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    

00800eb1 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebc:	b8 11 00 00 00       	mov    $0x11,%eax
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	89 cb                	mov    %ecx,%ebx
  800ec6:	89 cf                	mov    %ecx,%edi
  800ec8:	89 ce                	mov    %ecx,%esi
  800eca:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ed9:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800edb:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800edf:	0f 84 84 00 00 00    	je     800f69 <pgfault+0x98>
  800ee5:	89 d8                	mov    %ebx,%eax
  800ee7:	c1 e8 16             	shr    $0x16,%eax
  800eea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ef1:	a8 01                	test   $0x1,%al
  800ef3:	74 74                	je     800f69 <pgfault+0x98>
  800ef5:	89 d8                	mov    %ebx,%eax
  800ef7:	c1 e8 0c             	shr    $0xc,%eax
  800efa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f01:	f6 c4 08             	test   $0x8,%ah
  800f04:	74 63                	je     800f69 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800f06:	e8 f2 fc ff ff       	call   800bfd <sys_getenvid>
  800f0b:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800f0d:	83 ec 04             	sub    $0x4,%esp
  800f10:	6a 07                	push   $0x7
  800f12:	68 00 f0 7f 00       	push   $0x7ff000
  800f17:	50                   	push   %eax
  800f18:	e8 ff fc ff ff       	call   800c1c <sys_page_alloc>
  800f1d:	83 c4 10             	add    $0x10,%esp
  800f20:	85 c0                	test   %eax,%eax
  800f22:	78 5b                	js     800f7f <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  800f24:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  800f2a:	83 ec 04             	sub    $0x4,%esp
  800f2d:	68 00 10 00 00       	push   $0x1000
  800f32:	53                   	push   %ebx
  800f33:	68 00 f0 7f 00       	push   $0x7ff000
  800f38:	e8 03 fb ff ff       	call   800a40 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  800f3d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f44:	53                   	push   %ebx
  800f45:	56                   	push   %esi
  800f46:	68 00 f0 7f 00       	push   $0x7ff000
  800f4b:	56                   	push   %esi
  800f4c:	e8 0e fd ff ff       	call   800c5f <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  800f51:	83 c4 18             	add    $0x18,%esp
  800f54:	68 00 f0 7f 00       	push   $0x7ff000
  800f59:	56                   	push   %esi
  800f5a:	e8 42 fd ff ff       	call   800ca1 <sys_page_unmap>

}
  800f5f:	83 c4 10             	add    $0x10,%esp
  800f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800f69:	68 4c 26 80 00       	push   $0x80264c
  800f6e:	68 d6 26 80 00       	push   $0x8026d6
  800f73:	6a 1c                	push   $0x1c
  800f75:	68 eb 26 80 00       	push   $0x8026eb
  800f7a:	e8 cd f1 ff ff       	call   80014c <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800f7f:	68 9c 26 80 00       	push   $0x80269c
  800f84:	68 d6 26 80 00       	push   $0x8026d6
  800f89:	6a 26                	push   $0x26
  800f8b:	68 eb 26 80 00       	push   $0x8026eb
  800f90:	e8 b7 f1 ff ff       	call   80014c <_panic>

00800f95 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f9e:	68 d1 0e 80 00       	push   $0x800ed1
  800fa3:	e8 b9 0e 00 00       	call   801e61 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fa8:	b8 07 00 00 00       	mov    $0x7,%eax
  800fad:	cd 30                	int    $0x30
  800faf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800fb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  800fb5:	83 c4 10             	add    $0x10,%esp
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	0f 88 58 01 00 00    	js     801118 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	74 07                	je     800fcb <fork+0x36>
  800fc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc9:	eb 72                	jmp    80103d <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fcb:	e8 2d fc ff ff       	call   800bfd <sys_getenvid>
  800fd0:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fd5:	89 c2                	mov    %eax,%edx
  800fd7:	c1 e2 05             	shl    $0x5,%edx
  800fda:	29 c2                	sub    %eax,%edx
  800fdc:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800fe3:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800fe8:	e9 20 01 00 00       	jmp    80110d <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  800fed:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  800ff4:	e8 04 fc ff ff       	call   800bfd <sys_getenvid>
  800ff9:	83 ec 0c             	sub    $0xc,%esp
  800ffc:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	ff 75 e4             	pushl  -0x1c(%ebp)
  801007:	56                   	push   %esi
  801008:	50                   	push   %eax
  801009:	e8 51 fc ff ff       	call   800c5f <sys_page_map>
  80100e:	83 c4 20             	add    $0x20,%esp
  801011:	eb 18                	jmp    80102b <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  801013:	e8 e5 fb ff ff       	call   800bfd <sys_getenvid>
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	6a 05                	push   $0x5
  80101d:	56                   	push   %esi
  80101e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801021:	56                   	push   %esi
  801022:	50                   	push   %eax
  801023:	e8 37 fc ff ff       	call   800c5f <sys_page_map>
  801028:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  80102b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801031:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801037:	0f 84 8f 00 00 00    	je     8010cc <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  80103d:	89 d8                	mov    %ebx,%eax
  80103f:	c1 e8 16             	shr    $0x16,%eax
  801042:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801049:	a8 01                	test   $0x1,%al
  80104b:	74 de                	je     80102b <fork+0x96>
  80104d:	89 d8                	mov    %ebx,%eax
  80104f:	c1 e8 0c             	shr    $0xc,%eax
  801052:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801059:	a8 04                	test   $0x4,%al
  80105b:	74 ce                	je     80102b <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  80105d:	89 de                	mov    %ebx,%esi
  80105f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  801065:	89 f0                	mov    %esi,%eax
  801067:	c1 e8 0c             	shr    $0xc,%eax
  80106a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801071:	f6 c6 04             	test   $0x4,%dh
  801074:	0f 85 73 ff ff ff    	jne    800fed <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  80107a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801081:	a9 02 08 00 00       	test   $0x802,%eax
  801086:	74 8b                	je     801013 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801088:	e8 70 fb ff ff       	call   800bfd <sys_getenvid>
  80108d:	83 ec 0c             	sub    $0xc,%esp
  801090:	68 05 08 00 00       	push   $0x805
  801095:	56                   	push   %esi
  801096:	ff 75 e4             	pushl  -0x1c(%ebp)
  801099:	56                   	push   %esi
  80109a:	50                   	push   %eax
  80109b:	e8 bf fb ff ff       	call   800c5f <sys_page_map>
  8010a0:	83 c4 20             	add    $0x20,%esp
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	78 84                	js     80102b <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  8010a7:	e8 51 fb ff ff       	call   800bfd <sys_getenvid>
  8010ac:	89 c7                	mov    %eax,%edi
  8010ae:	e8 4a fb ff ff       	call   800bfd <sys_getenvid>
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	68 05 08 00 00       	push   $0x805
  8010bb:	56                   	push   %esi
  8010bc:	57                   	push   %edi
  8010bd:	56                   	push   %esi
  8010be:	50                   	push   %eax
  8010bf:	e8 9b fb ff ff       	call   800c5f <sys_page_map>
  8010c4:	83 c4 20             	add    $0x20,%esp
  8010c7:	e9 5f ff ff ff       	jmp    80102b <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  8010cc:	83 ec 04             	sub    $0x4,%esp
  8010cf:	6a 07                	push   $0x7
  8010d1:	68 00 f0 bf ee       	push   $0xeebff000
  8010d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8010d9:	57                   	push   %edi
  8010da:	e8 3d fb ff ff       	call   800c1c <sys_page_alloc>
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	78 3b                	js     801121 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	68 a7 1e 80 00       	push   $0x801ea7
  8010ee:	57                   	push   %edi
  8010ef:	e8 d3 fc ff ff       	call   800dc7 <sys_env_set_pgfault_upcall>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	78 2f                	js     80112a <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	6a 02                	push   $0x2
  801100:	57                   	push   %edi
  801101:	e8 fc fb ff ff       	call   800d02 <sys_env_set_status>
	if (temp < 0) {
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	85 c0                	test   %eax,%eax
  80110b:	78 26                	js     801133 <fork+0x19e>
		return -1;
	}

	return childid;
}
  80110d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		return -1;
  801118:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80111f:	eb ec                	jmp    80110d <fork+0x178>
		return -1;
  801121:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801128:	eb e3                	jmp    80110d <fork+0x178>
		return -1;
  80112a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801131:	eb da                	jmp    80110d <fork+0x178>
		return -1;
  801133:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80113a:	eb d1                	jmp    80110d <fork+0x178>

0080113c <sfork>:

// Challenge!
int
sfork(void)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801142:	68 f6 26 80 00       	push   $0x8026f6
  801147:	68 85 00 00 00       	push   $0x85
  80114c:	68 eb 26 80 00       	push   $0x8026eb
  801151:	e8 f6 ef ff ff       	call   80014c <_panic>

00801156 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	05 00 00 00 30       	add    $0x30000000,%eax
  801161:	c1 e8 0c             	shr    $0xc,%eax
}
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801171:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801176:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801183:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801188:	89 c2                	mov    %eax,%edx
  80118a:	c1 ea 16             	shr    $0x16,%edx
  80118d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801194:	f6 c2 01             	test   $0x1,%dl
  801197:	74 2a                	je     8011c3 <fd_alloc+0x46>
  801199:	89 c2                	mov    %eax,%edx
  80119b:	c1 ea 0c             	shr    $0xc,%edx
  80119e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a5:	f6 c2 01             	test   $0x1,%dl
  8011a8:	74 19                	je     8011c3 <fd_alloc+0x46>
  8011aa:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011af:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b4:	75 d2                	jne    801188 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011b6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011bc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011c1:	eb 07                	jmp    8011ca <fd_alloc+0x4d>
			*fd_store = fd;
  8011c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011cf:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8011d3:	77 39                	ja     80120e <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	c1 e0 0c             	shl    $0xc,%eax
  8011db:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e0:	89 c2                	mov    %eax,%edx
  8011e2:	c1 ea 16             	shr    $0x16,%edx
  8011e5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ec:	f6 c2 01             	test   $0x1,%dl
  8011ef:	74 24                	je     801215 <fd_lookup+0x49>
  8011f1:	89 c2                	mov    %eax,%edx
  8011f3:	c1 ea 0c             	shr    $0xc,%edx
  8011f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011fd:	f6 c2 01             	test   $0x1,%dl
  801200:	74 1a                	je     80121c <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801202:	8b 55 0c             	mov    0xc(%ebp),%edx
  801205:	89 02                	mov    %eax,(%edx)
	return 0;
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120c:	5d                   	pop    %ebp
  80120d:	c3                   	ret    
		return -E_INVAL;
  80120e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801213:	eb f7                	jmp    80120c <fd_lookup+0x40>
		return -E_INVAL;
  801215:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121a:	eb f0                	jmp    80120c <fd_lookup+0x40>
  80121c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801221:	eb e9                	jmp    80120c <fd_lookup+0x40>

00801223 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 08             	sub    $0x8,%esp
  801229:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122c:	ba 88 27 80 00       	mov    $0x802788,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801231:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801236:	39 08                	cmp    %ecx,(%eax)
  801238:	74 33                	je     80126d <dev_lookup+0x4a>
  80123a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80123d:	8b 02                	mov    (%edx),%eax
  80123f:	85 c0                	test   %eax,%eax
  801241:	75 f3                	jne    801236 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801243:	a1 08 40 80 00       	mov    0x804008,%eax
  801248:	8b 40 48             	mov    0x48(%eax),%eax
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	51                   	push   %ecx
  80124f:	50                   	push   %eax
  801250:	68 0c 27 80 00       	push   $0x80270c
  801255:	e8 05 f0 ff ff       	call   80025f <cprintf>
	*dev = 0;
  80125a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    
			*dev = devtab[i];
  80126d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801270:	89 01                	mov    %eax,(%ecx)
			return 0;
  801272:	b8 00 00 00 00       	mov    $0x0,%eax
  801277:	eb f2                	jmp    80126b <dev_lookup+0x48>

00801279 <fd_close>:
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	57                   	push   %edi
  80127d:	56                   	push   %esi
  80127e:	53                   	push   %ebx
  80127f:	83 ec 1c             	sub    $0x1c,%esp
  801282:	8b 75 08             	mov    0x8(%ebp),%esi
  801285:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801288:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80128b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80128c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801292:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801295:	50                   	push   %eax
  801296:	e8 31 ff ff ff       	call   8011cc <fd_lookup>
  80129b:	89 c7                	mov    %eax,%edi
  80129d:	83 c4 08             	add    $0x8,%esp
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	78 05                	js     8012a9 <fd_close+0x30>
	    || fd != fd2)
  8012a4:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8012a7:	74 13                	je     8012bc <fd_close+0x43>
		return (must_exist ? r : 0);
  8012a9:	84 db                	test   %bl,%bl
  8012ab:	75 05                	jne    8012b2 <fd_close+0x39>
  8012ad:	bf 00 00 00 00       	mov    $0x0,%edi
}
  8012b2:	89 f8                	mov    %edi,%eax
  8012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5f                   	pop    %edi
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012bc:	83 ec 08             	sub    $0x8,%esp
  8012bf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012c2:	50                   	push   %eax
  8012c3:	ff 36                	pushl  (%esi)
  8012c5:	e8 59 ff ff ff       	call   801223 <dev_lookup>
  8012ca:	89 c7                	mov    %eax,%edi
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	78 15                	js     8012e8 <fd_close+0x6f>
		if (dev->dev_close)
  8012d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d6:	8b 40 10             	mov    0x10(%eax),%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1b                	je     8012f8 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	56                   	push   %esi
  8012e1:	ff d0                	call   *%eax
  8012e3:	89 c7                	mov    %eax,%edi
  8012e5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012e8:	83 ec 08             	sub    $0x8,%esp
  8012eb:	56                   	push   %esi
  8012ec:	6a 00                	push   $0x0
  8012ee:	e8 ae f9 ff ff       	call   800ca1 <sys_page_unmap>
	return r;
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	eb ba                	jmp    8012b2 <fd_close+0x39>
			r = 0;
  8012f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fd:	eb e9                	jmp    8012e8 <fd_close+0x6f>

008012ff <close>:

int
close(int fdnum)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801305:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801308:	50                   	push   %eax
  801309:	ff 75 08             	pushl  0x8(%ebp)
  80130c:	e8 bb fe ff ff       	call   8011cc <fd_lookup>
  801311:	83 c4 08             	add    $0x8,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	78 10                	js     801328 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	6a 01                	push   $0x1
  80131d:	ff 75 f4             	pushl  -0xc(%ebp)
  801320:	e8 54 ff ff ff       	call   801279 <fd_close>
  801325:	83 c4 10             	add    $0x10,%esp
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <close_all>:

void
close_all(void)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	53                   	push   %ebx
  80132e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801331:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	53                   	push   %ebx
  80133a:	e8 c0 ff ff ff       	call   8012ff <close>
	for (i = 0; i < MAXFD; i++)
  80133f:	43                   	inc    %ebx
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	83 fb 20             	cmp    $0x20,%ebx
  801346:	75 ee                	jne    801336 <close_all+0xc>
}
  801348:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	57                   	push   %edi
  801351:	56                   	push   %esi
  801352:	53                   	push   %ebx
  801353:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801356:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801359:	50                   	push   %eax
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 6a fe ff ff       	call   8011cc <fd_lookup>
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 08             	add    $0x8,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	0f 88 81 00 00 00    	js     8013f0 <dup+0xa3>
		return r;
	close(newfdnum);
  80136f:	83 ec 0c             	sub    $0xc,%esp
  801372:	ff 75 0c             	pushl  0xc(%ebp)
  801375:	e8 85 ff ff ff       	call   8012ff <close>

	newfd = INDEX2FD(newfdnum);
  80137a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80137d:	c1 e6 0c             	shl    $0xc,%esi
  801380:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801386:	83 c4 04             	add    $0x4,%esp
  801389:	ff 75 e4             	pushl  -0x1c(%ebp)
  80138c:	e8 d5 fd ff ff       	call   801166 <fd2data>
  801391:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801393:	89 34 24             	mov    %esi,(%esp)
  801396:	e8 cb fd ff ff       	call   801166 <fd2data>
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013a0:	89 d8                	mov    %ebx,%eax
  8013a2:	c1 e8 16             	shr    $0x16,%eax
  8013a5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013ac:	a8 01                	test   $0x1,%al
  8013ae:	74 11                	je     8013c1 <dup+0x74>
  8013b0:	89 d8                	mov    %ebx,%eax
  8013b2:	c1 e8 0c             	shr    $0xc,%eax
  8013b5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013bc:	f6 c2 01             	test   $0x1,%dl
  8013bf:	75 39                	jne    8013fa <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013c4:	89 d0                	mov    %edx,%eax
  8013c6:	c1 e8 0c             	shr    $0xc,%eax
  8013c9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d8:	50                   	push   %eax
  8013d9:	56                   	push   %esi
  8013da:	6a 00                	push   $0x0
  8013dc:	52                   	push   %edx
  8013dd:	6a 00                	push   $0x0
  8013df:	e8 7b f8 ff ff       	call   800c5f <sys_page_map>
  8013e4:	89 c3                	mov    %eax,%ebx
  8013e6:	83 c4 20             	add    $0x20,%esp
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	78 31                	js     80141e <dup+0xd1>
		goto err;

	return newfdnum;
  8013ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013f0:	89 d8                	mov    %ebx,%eax
  8013f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f5:	5b                   	pop    %ebx
  8013f6:	5e                   	pop    %esi
  8013f7:	5f                   	pop    %edi
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	25 07 0e 00 00       	and    $0xe07,%eax
  801409:	50                   	push   %eax
  80140a:	57                   	push   %edi
  80140b:	6a 00                	push   $0x0
  80140d:	53                   	push   %ebx
  80140e:	6a 00                	push   $0x0
  801410:	e8 4a f8 ff ff       	call   800c5f <sys_page_map>
  801415:	89 c3                	mov    %eax,%ebx
  801417:	83 c4 20             	add    $0x20,%esp
  80141a:	85 c0                	test   %eax,%eax
  80141c:	79 a3                	jns    8013c1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	56                   	push   %esi
  801422:	6a 00                	push   $0x0
  801424:	e8 78 f8 ff ff       	call   800ca1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801429:	83 c4 08             	add    $0x8,%esp
  80142c:	57                   	push   %edi
  80142d:	6a 00                	push   $0x0
  80142f:	e8 6d f8 ff ff       	call   800ca1 <sys_page_unmap>
	return r;
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	eb b7                	jmp    8013f0 <dup+0xa3>

00801439 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	53                   	push   %ebx
  80143d:	83 ec 14             	sub    $0x14,%esp
  801440:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801443:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	53                   	push   %ebx
  801448:	e8 7f fd ff ff       	call   8011cc <fd_lookup>
  80144d:	83 c4 08             	add    $0x8,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	78 3f                	js     801493 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801454:	83 ec 08             	sub    $0x8,%esp
  801457:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145a:	50                   	push   %eax
  80145b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145e:	ff 30                	pushl  (%eax)
  801460:	e8 be fd ff ff       	call   801223 <dev_lookup>
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 27                	js     801493 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80146c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80146f:	8b 42 08             	mov    0x8(%edx),%eax
  801472:	83 e0 03             	and    $0x3,%eax
  801475:	83 f8 01             	cmp    $0x1,%eax
  801478:	74 1e                	je     801498 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80147a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147d:	8b 40 08             	mov    0x8(%eax),%eax
  801480:	85 c0                	test   %eax,%eax
  801482:	74 35                	je     8014b9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	ff 75 10             	pushl  0x10(%ebp)
  80148a:	ff 75 0c             	pushl  0xc(%ebp)
  80148d:	52                   	push   %edx
  80148e:	ff d0                	call   *%eax
  801490:	83 c4 10             	add    $0x10,%esp
}
  801493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801496:	c9                   	leave  
  801497:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801498:	a1 08 40 80 00       	mov    0x804008,%eax
  80149d:	8b 40 48             	mov    0x48(%eax),%eax
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	53                   	push   %ebx
  8014a4:	50                   	push   %eax
  8014a5:	68 4d 27 80 00       	push   $0x80274d
  8014aa:	e8 b0 ed ff ff       	call   80025f <cprintf>
		return -E_INVAL;
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b7:	eb da                	jmp    801493 <read+0x5a>
		return -E_NOT_SUPP;
  8014b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014be:	eb d3                	jmp    801493 <read+0x5a>

008014c0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	57                   	push   %edi
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 0c             	sub    $0xc,%esp
  8014c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014cc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d4:	39 f3                	cmp    %esi,%ebx
  8014d6:	73 25                	jae    8014fd <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014d8:	83 ec 04             	sub    $0x4,%esp
  8014db:	89 f0                	mov    %esi,%eax
  8014dd:	29 d8                	sub    %ebx,%eax
  8014df:	50                   	push   %eax
  8014e0:	89 d8                	mov    %ebx,%eax
  8014e2:	03 45 0c             	add    0xc(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	57                   	push   %edi
  8014e7:	e8 4d ff ff ff       	call   801439 <read>
		if (m < 0)
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 08                	js     8014fb <readn+0x3b>
			return m;
		if (m == 0)
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	74 06                	je     8014fd <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8014f7:	01 c3                	add    %eax,%ebx
  8014f9:	eb d9                	jmp    8014d4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014fb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014fd:	89 d8                	mov    %ebx,%eax
  8014ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801502:	5b                   	pop    %ebx
  801503:	5e                   	pop    %esi
  801504:	5f                   	pop    %edi
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	53                   	push   %ebx
  80150b:	83 ec 14             	sub    $0x14,%esp
  80150e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801511:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	53                   	push   %ebx
  801516:	e8 b1 fc ff ff       	call   8011cc <fd_lookup>
  80151b:	83 c4 08             	add    $0x8,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 3a                	js     80155c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801528:	50                   	push   %eax
  801529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152c:	ff 30                	pushl  (%eax)
  80152e:	e8 f0 fc ff ff       	call   801223 <dev_lookup>
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	85 c0                	test   %eax,%eax
  801538:	78 22                	js     80155c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80153a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801541:	74 1e                	je     801561 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	8b 52 0c             	mov    0xc(%edx),%edx
  801549:	85 d2                	test   %edx,%edx
  80154b:	74 35                	je     801582 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	ff 75 10             	pushl  0x10(%ebp)
  801553:	ff 75 0c             	pushl  0xc(%ebp)
  801556:	50                   	push   %eax
  801557:	ff d2                	call   *%edx
  801559:	83 c4 10             	add    $0x10,%esp
}
  80155c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155f:	c9                   	leave  
  801560:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801561:	a1 08 40 80 00       	mov    0x804008,%eax
  801566:	8b 40 48             	mov    0x48(%eax),%eax
  801569:	83 ec 04             	sub    $0x4,%esp
  80156c:	53                   	push   %ebx
  80156d:	50                   	push   %eax
  80156e:	68 69 27 80 00       	push   $0x802769
  801573:	e8 e7 ec ff ff       	call   80025f <cprintf>
		return -E_INVAL;
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801580:	eb da                	jmp    80155c <write+0x55>
		return -E_NOT_SUPP;
  801582:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801587:	eb d3                	jmp    80155c <write+0x55>

00801589 <seek>:

int
seek(int fdnum, off_t offset)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	e8 31 fc ff ff       	call   8011cc <fd_lookup>
  80159b:	83 c4 08             	add    $0x8,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 0e                	js     8015b0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	53                   	push   %ebx
  8015b6:	83 ec 14             	sub    $0x14,%esp
  8015b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bf:	50                   	push   %eax
  8015c0:	53                   	push   %ebx
  8015c1:	e8 06 fc ff ff       	call   8011cc <fd_lookup>
  8015c6:	83 c4 08             	add    $0x8,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	78 37                	js     801604 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cd:	83 ec 08             	sub    $0x8,%esp
  8015d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d3:	50                   	push   %eax
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	ff 30                	pushl  (%eax)
  8015d9:	e8 45 fc ff ff       	call   801223 <dev_lookup>
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 1f                	js     801604 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ec:	74 1b                	je     801609 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f1:	8b 52 18             	mov    0x18(%edx),%edx
  8015f4:	85 d2                	test   %edx,%edx
  8015f6:	74 32                	je     80162a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	ff 75 0c             	pushl  0xc(%ebp)
  8015fe:	50                   	push   %eax
  8015ff:	ff d2                	call   *%edx
  801601:	83 c4 10             	add    $0x10,%esp
}
  801604:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801607:	c9                   	leave  
  801608:	c3                   	ret    
			thisenv->env_id, fdnum);
  801609:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80160e:	8b 40 48             	mov    0x48(%eax),%eax
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	53                   	push   %ebx
  801615:	50                   	push   %eax
  801616:	68 2c 27 80 00       	push   $0x80272c
  80161b:	e8 3f ec ff ff       	call   80025f <cprintf>
		return -E_INVAL;
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801628:	eb da                	jmp    801604 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80162a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162f:	eb d3                	jmp    801604 <ftruncate+0x52>

00801631 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	53                   	push   %ebx
  801635:	83 ec 14             	sub    $0x14,%esp
  801638:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80163e:	50                   	push   %eax
  80163f:	ff 75 08             	pushl  0x8(%ebp)
  801642:	e8 85 fb ff ff       	call   8011cc <fd_lookup>
  801647:	83 c4 08             	add    $0x8,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 4b                	js     801699 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801654:	50                   	push   %eax
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	ff 30                	pushl  (%eax)
  80165a:	e8 c4 fb ff ff       	call   801223 <dev_lookup>
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	85 c0                	test   %eax,%eax
  801664:	78 33                	js     801699 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801669:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80166d:	74 2f                	je     80169e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80166f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801672:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801679:	00 00 00 
	stat->st_type = 0;
  80167c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801683:	00 00 00 
	stat->st_dev = dev;
  801686:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	53                   	push   %ebx
  801690:	ff 75 f0             	pushl  -0x10(%ebp)
  801693:	ff 50 14             	call   *0x14(%eax)
  801696:	83 c4 10             	add    $0x10,%esp
}
  801699:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    
		return -E_NOT_SUPP;
  80169e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a3:	eb f4                	jmp    801699 <fstat+0x68>

008016a5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016aa:	83 ec 08             	sub    $0x8,%esp
  8016ad:	6a 00                	push   $0x0
  8016af:	ff 75 08             	pushl  0x8(%ebp)
  8016b2:	e8 34 02 00 00       	call   8018eb <open>
  8016b7:	89 c3                	mov    %eax,%ebx
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 1b                	js     8016db <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	50                   	push   %eax
  8016c7:	e8 65 ff ff ff       	call   801631 <fstat>
  8016cc:	89 c6                	mov    %eax,%esi
	close(fd);
  8016ce:	89 1c 24             	mov    %ebx,(%esp)
  8016d1:	e8 29 fc ff ff       	call   8012ff <close>
	return r;
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	89 f3                	mov    %esi,%ebx
}
  8016db:	89 d8                	mov    %ebx,%eax
  8016dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e0:	5b                   	pop    %ebx
  8016e1:	5e                   	pop    %esi
  8016e2:	5d                   	pop    %ebp
  8016e3:	c3                   	ret    

008016e4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	56                   	push   %esi
  8016e8:	53                   	push   %ebx
  8016e9:	89 c6                	mov    %eax,%esi
  8016eb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ed:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016f4:	74 27                	je     80171d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016f6:	6a 07                	push   $0x7
  8016f8:	68 00 50 80 00       	push   $0x805000
  8016fd:	56                   	push   %esi
  8016fe:	ff 35 00 40 80 00    	pushl  0x804000
  801704:	e8 4d 08 00 00       	call   801f56 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801709:	83 c4 0c             	add    $0xc,%esp
  80170c:	6a 00                	push   $0x0
  80170e:	53                   	push   %ebx
  80170f:	6a 00                	push   $0x0
  801711:	e8 b7 07 00 00       	call   801ecd <ipc_recv>
}
  801716:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801719:	5b                   	pop    %ebx
  80171a:	5e                   	pop    %esi
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80171d:	83 ec 0c             	sub    $0xc,%esp
  801720:	6a 01                	push   $0x1
  801722:	e8 8b 08 00 00       	call   801fb2 <ipc_find_env>
  801727:	a3 00 40 80 00       	mov    %eax,0x804000
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	eb c5                	jmp    8016f6 <fsipc+0x12>

00801731 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8b 40 0c             	mov    0xc(%eax),%eax
  80173d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	b8 02 00 00 00       	mov    $0x2,%eax
  801754:	e8 8b ff ff ff       	call   8016e4 <fsipc>
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <devfile_flush>:
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8b 40 0c             	mov    0xc(%eax),%eax
  801767:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80176c:	ba 00 00 00 00       	mov    $0x0,%edx
  801771:	b8 06 00 00 00       	mov    $0x6,%eax
  801776:	e8 69 ff ff ff       	call   8016e4 <fsipc>
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <devfile_stat>:
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	53                   	push   %ebx
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8b 40 0c             	mov    0xc(%eax),%eax
  80178d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801792:	ba 00 00 00 00       	mov    $0x0,%edx
  801797:	b8 05 00 00 00       	mov    $0x5,%eax
  80179c:	e8 43 ff ff ff       	call   8016e4 <fsipc>
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	78 2c                	js     8017d1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	68 00 50 80 00       	push   $0x805000
  8017ad:	53                   	push   %ebx
  8017ae:	e8 b4 f0 ff ff       	call   800867 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017b3:	a1 80 50 80 00       	mov    0x805080,%eax
  8017b8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8017be:	a1 84 50 80 00       	mov    0x805084,%eax
  8017c3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <devfile_write>:
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	53                   	push   %ebx
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8017e0:	89 d8                	mov    %ebx,%eax
  8017e2:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8017e8:	76 05                	jbe    8017ef <devfile_write+0x19>
  8017ea:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8017f5:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8017fb:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	50                   	push   %eax
  801804:	ff 75 0c             	pushl  0xc(%ebp)
  801807:	68 08 50 80 00       	push   $0x805008
  80180c:	e8 c9 f1 ff ff       	call   8009da <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801811:	ba 00 00 00 00       	mov    $0x0,%edx
  801816:	b8 04 00 00 00       	mov    $0x4,%eax
  80181b:	e8 c4 fe ff ff       	call   8016e4 <fsipc>
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	85 c0                	test   %eax,%eax
  801825:	78 0b                	js     801832 <devfile_write+0x5c>
	assert(r <= n);
  801827:	39 c3                	cmp    %eax,%ebx
  801829:	72 0c                	jb     801837 <devfile_write+0x61>
	assert(r <= PGSIZE);
  80182b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801830:	7f 1e                	jg     801850 <devfile_write+0x7a>
}
  801832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801835:	c9                   	leave  
  801836:	c3                   	ret    
	assert(r <= n);
  801837:	68 98 27 80 00       	push   $0x802798
  80183c:	68 d6 26 80 00       	push   $0x8026d6
  801841:	68 98 00 00 00       	push   $0x98
  801846:	68 9f 27 80 00       	push   $0x80279f
  80184b:	e8 fc e8 ff ff       	call   80014c <_panic>
	assert(r <= PGSIZE);
  801850:	68 aa 27 80 00       	push   $0x8027aa
  801855:	68 d6 26 80 00       	push   $0x8026d6
  80185a:	68 99 00 00 00       	push   $0x99
  80185f:	68 9f 27 80 00       	push   $0x80279f
  801864:	e8 e3 e8 ff ff       	call   80014c <_panic>

00801869 <devfile_read>:
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	56                   	push   %esi
  80186d:	53                   	push   %ebx
  80186e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8b 40 0c             	mov    0xc(%eax),%eax
  801877:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80187c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801882:	ba 00 00 00 00       	mov    $0x0,%edx
  801887:	b8 03 00 00 00       	mov    $0x3,%eax
  80188c:	e8 53 fe ff ff       	call   8016e4 <fsipc>
  801891:	89 c3                	mov    %eax,%ebx
  801893:	85 c0                	test   %eax,%eax
  801895:	78 1f                	js     8018b6 <devfile_read+0x4d>
	assert(r <= n);
  801897:	39 c6                	cmp    %eax,%esi
  801899:	72 24                	jb     8018bf <devfile_read+0x56>
	assert(r <= PGSIZE);
  80189b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a0:	7f 33                	jg     8018d5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	50                   	push   %eax
  8018a6:	68 00 50 80 00       	push   $0x805000
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	e8 27 f1 ff ff       	call   8009da <memmove>
	return r;
  8018b3:	83 c4 10             	add    $0x10,%esp
}
  8018b6:	89 d8                	mov    %ebx,%eax
  8018b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    
	assert(r <= n);
  8018bf:	68 98 27 80 00       	push   $0x802798
  8018c4:	68 d6 26 80 00       	push   $0x8026d6
  8018c9:	6a 7c                	push   $0x7c
  8018cb:	68 9f 27 80 00       	push   $0x80279f
  8018d0:	e8 77 e8 ff ff       	call   80014c <_panic>
	assert(r <= PGSIZE);
  8018d5:	68 aa 27 80 00       	push   $0x8027aa
  8018da:	68 d6 26 80 00       	push   $0x8026d6
  8018df:	6a 7d                	push   $0x7d
  8018e1:	68 9f 27 80 00       	push   $0x80279f
  8018e6:	e8 61 e8 ff ff       	call   80014c <_panic>

008018eb <open>:
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 1c             	sub    $0x1c,%esp
  8018f3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018f6:	56                   	push   %esi
  8018f7:	e8 38 ef ff ff       	call   800834 <strlen>
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801904:	7f 6c                	jg     801972 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190c:	50                   	push   %eax
  80190d:	e8 6b f8 ff ff       	call   80117d <fd_alloc>
  801912:	89 c3                	mov    %eax,%ebx
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 3c                	js     801957 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	56                   	push   %esi
  80191f:	68 00 50 80 00       	push   $0x805000
  801924:	e8 3e ef ff ff       	call   800867 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801934:	b8 01 00 00 00       	mov    $0x1,%eax
  801939:	e8 a6 fd ff ff       	call   8016e4 <fsipc>
  80193e:	89 c3                	mov    %eax,%ebx
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	85 c0                	test   %eax,%eax
  801945:	78 19                	js     801960 <open+0x75>
	return fd2num(fd);
  801947:	83 ec 0c             	sub    $0xc,%esp
  80194a:	ff 75 f4             	pushl  -0xc(%ebp)
  80194d:	e8 04 f8 ff ff       	call   801156 <fd2num>
  801952:	89 c3                	mov    %eax,%ebx
  801954:	83 c4 10             	add    $0x10,%esp
}
  801957:	89 d8                	mov    %ebx,%eax
  801959:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195c:	5b                   	pop    %ebx
  80195d:	5e                   	pop    %esi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
		fd_close(fd, 0);
  801960:	83 ec 08             	sub    $0x8,%esp
  801963:	6a 00                	push   $0x0
  801965:	ff 75 f4             	pushl  -0xc(%ebp)
  801968:	e8 0c f9 ff ff       	call   801279 <fd_close>
		return r;
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	eb e5                	jmp    801957 <open+0x6c>
		return -E_BAD_PATH;
  801972:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801977:	eb de                	jmp    801957 <open+0x6c>

00801979 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80197f:	ba 00 00 00 00       	mov    $0x0,%edx
  801984:	b8 08 00 00 00       	mov    $0x8,%eax
  801989:	e8 56 fd ff ff       	call   8016e4 <fsipc>
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	56                   	push   %esi
  801994:	53                   	push   %ebx
  801995:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801998:	83 ec 0c             	sub    $0xc,%esp
  80199b:	ff 75 08             	pushl  0x8(%ebp)
  80199e:	e8 c3 f7 ff ff       	call   801166 <fd2data>
  8019a3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019a5:	83 c4 08             	add    $0x8,%esp
  8019a8:	68 b6 27 80 00       	push   $0x8027b6
  8019ad:	53                   	push   %ebx
  8019ae:	e8 b4 ee ff ff       	call   800867 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019b3:	8b 46 04             	mov    0x4(%esi),%eax
  8019b6:	2b 06                	sub    (%esi),%eax
  8019b8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  8019be:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  8019c5:	10 00 00 
	stat->st_dev = &devpipe;
  8019c8:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019cf:	30 80 00 
	return 0;
}
  8019d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019da:	5b                   	pop    %ebx
  8019db:	5e                   	pop    %esi
  8019dc:	5d                   	pop    %ebp
  8019dd:	c3                   	ret    

008019de <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	53                   	push   %ebx
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019e8:	53                   	push   %ebx
  8019e9:	6a 00                	push   $0x0
  8019eb:	e8 b1 f2 ff ff       	call   800ca1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019f0:	89 1c 24             	mov    %ebx,(%esp)
  8019f3:	e8 6e f7 ff ff       	call   801166 <fd2data>
  8019f8:	83 c4 08             	add    $0x8,%esp
  8019fb:	50                   	push   %eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	e8 9e f2 ff ff       	call   800ca1 <sys_page_unmap>
}
  801a03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <_pipeisclosed>:
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	57                   	push   %edi
  801a0c:	56                   	push   %esi
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 1c             	sub    $0x1c,%esp
  801a11:	89 c7                	mov    %eax,%edi
  801a13:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a15:	a1 08 40 80 00       	mov    0x804008,%eax
  801a1a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	57                   	push   %edi
  801a21:	e8 ce 05 00 00       	call   801ff4 <pageref>
  801a26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a29:	89 34 24             	mov    %esi,(%esp)
  801a2c:	e8 c3 05 00 00       	call   801ff4 <pageref>
		nn = thisenv->env_runs;
  801a31:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a37:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	39 cb                	cmp    %ecx,%ebx
  801a3f:	74 1b                	je     801a5c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a41:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a44:	75 cf                	jne    801a15 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a46:	8b 42 58             	mov    0x58(%edx),%eax
  801a49:	6a 01                	push   $0x1
  801a4b:	50                   	push   %eax
  801a4c:	53                   	push   %ebx
  801a4d:	68 bd 27 80 00       	push   $0x8027bd
  801a52:	e8 08 e8 ff ff       	call   80025f <cprintf>
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	eb b9                	jmp    801a15 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a5c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a5f:	0f 94 c0             	sete   %al
  801a62:	0f b6 c0             	movzbl %al,%eax
}
  801a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a68:	5b                   	pop    %ebx
  801a69:	5e                   	pop    %esi
  801a6a:	5f                   	pop    %edi
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    

00801a6d <devpipe_write>:
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	57                   	push   %edi
  801a71:	56                   	push   %esi
  801a72:	53                   	push   %ebx
  801a73:	83 ec 18             	sub    $0x18,%esp
  801a76:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a79:	56                   	push   %esi
  801a7a:	e8 e7 f6 ff ff       	call   801166 <fd2data>
  801a7f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	bf 00 00 00 00       	mov    $0x0,%edi
  801a89:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a8c:	74 41                	je     801acf <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a8e:	8b 53 04             	mov    0x4(%ebx),%edx
  801a91:	8b 03                	mov    (%ebx),%eax
  801a93:	83 c0 20             	add    $0x20,%eax
  801a96:	39 c2                	cmp    %eax,%edx
  801a98:	72 14                	jb     801aae <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a9a:	89 da                	mov    %ebx,%edx
  801a9c:	89 f0                	mov    %esi,%eax
  801a9e:	e8 65 ff ff ff       	call   801a08 <_pipeisclosed>
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	75 2c                	jne    801ad3 <devpipe_write+0x66>
			sys_yield();
  801aa7:	e8 37 f2 ff ff       	call   800ce3 <sys_yield>
  801aac:	eb e0                	jmp    801a8e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab1:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801ab4:	89 d0                	mov    %edx,%eax
  801ab6:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801abb:	78 0b                	js     801ac8 <devpipe_write+0x5b>
  801abd:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801ac1:	42                   	inc    %edx
  801ac2:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ac5:	47                   	inc    %edi
  801ac6:	eb c1                	jmp    801a89 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ac8:	48                   	dec    %eax
  801ac9:	83 c8 e0             	or     $0xffffffe0,%eax
  801acc:	40                   	inc    %eax
  801acd:	eb ee                	jmp    801abd <devpipe_write+0x50>
	return i;
  801acf:	89 f8                	mov    %edi,%eax
  801ad1:	eb 05                	jmp    801ad8 <devpipe_write+0x6b>
				return 0;
  801ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5e                   	pop    %esi
  801add:	5f                   	pop    %edi
  801ade:	5d                   	pop    %ebp
  801adf:	c3                   	ret    

00801ae0 <devpipe_read>:
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	57                   	push   %edi
  801ae4:	56                   	push   %esi
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 18             	sub    $0x18,%esp
  801ae9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801aec:	57                   	push   %edi
  801aed:	e8 74 f6 ff ff       	call   801166 <fd2data>
  801af2:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801af4:	83 c4 10             	add    $0x10,%esp
  801af7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801afc:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801aff:	74 46                	je     801b47 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801b01:	8b 06                	mov    (%esi),%eax
  801b03:	3b 46 04             	cmp    0x4(%esi),%eax
  801b06:	75 22                	jne    801b2a <devpipe_read+0x4a>
			if (i > 0)
  801b08:	85 db                	test   %ebx,%ebx
  801b0a:	74 0a                	je     801b16 <devpipe_read+0x36>
				return i;
  801b0c:	89 d8                	mov    %ebx,%eax
}
  801b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5f                   	pop    %edi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801b16:	89 f2                	mov    %esi,%edx
  801b18:	89 f8                	mov    %edi,%eax
  801b1a:	e8 e9 fe ff ff       	call   801a08 <_pipeisclosed>
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	75 28                	jne    801b4b <devpipe_read+0x6b>
			sys_yield();
  801b23:	e8 bb f1 ff ff       	call   800ce3 <sys_yield>
  801b28:	eb d7                	jmp    801b01 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b2a:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801b2f:	78 0f                	js     801b40 <devpipe_read+0x60>
  801b31:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801b35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b38:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801b3b:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801b3d:	43                   	inc    %ebx
  801b3e:	eb bc                	jmp    801afc <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b40:	48                   	dec    %eax
  801b41:	83 c8 e0             	or     $0xffffffe0,%eax
  801b44:	40                   	inc    %eax
  801b45:	eb ea                	jmp    801b31 <devpipe_read+0x51>
	return i;
  801b47:	89 d8                	mov    %ebx,%eax
  801b49:	eb c3                	jmp    801b0e <devpipe_read+0x2e>
				return 0;
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b50:	eb bc                	jmp    801b0e <devpipe_read+0x2e>

00801b52 <pipe>:
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	56                   	push   %esi
  801b56:	53                   	push   %ebx
  801b57:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	e8 1a f6 ff ff       	call   80117d <fd_alloc>
  801b63:	89 c3                	mov    %eax,%ebx
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	0f 88 2a 01 00 00    	js     801c9a <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	68 07 04 00 00       	push   $0x407
  801b78:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7b:	6a 00                	push   $0x0
  801b7d:	e8 9a f0 ff ff       	call   800c1c <sys_page_alloc>
  801b82:	89 c3                	mov    %eax,%ebx
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	85 c0                	test   %eax,%eax
  801b89:	0f 88 0b 01 00 00    	js     801c9a <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b95:	50                   	push   %eax
  801b96:	e8 e2 f5 ff ff       	call   80117d <fd_alloc>
  801b9b:	89 c3                	mov    %eax,%ebx
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	0f 88 e2 00 00 00    	js     801c8a <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	68 07 04 00 00       	push   $0x407
  801bb0:	ff 75 f0             	pushl  -0x10(%ebp)
  801bb3:	6a 00                	push   $0x0
  801bb5:	e8 62 f0 ff ff       	call   800c1c <sys_page_alloc>
  801bba:	89 c3                	mov    %eax,%ebx
  801bbc:	83 c4 10             	add    $0x10,%esp
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	0f 88 c3 00 00 00    	js     801c8a <pipe+0x138>
	va = fd2data(fd0);
  801bc7:	83 ec 0c             	sub    $0xc,%esp
  801bca:	ff 75 f4             	pushl  -0xc(%ebp)
  801bcd:	e8 94 f5 ff ff       	call   801166 <fd2data>
  801bd2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bd4:	83 c4 0c             	add    $0xc,%esp
  801bd7:	68 07 04 00 00       	push   $0x407
  801bdc:	50                   	push   %eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	e8 38 f0 ff ff       	call   800c1c <sys_page_alloc>
  801be4:	89 c3                	mov    %eax,%ebx
  801be6:	83 c4 10             	add    $0x10,%esp
  801be9:	85 c0                	test   %eax,%eax
  801beb:	0f 88 89 00 00 00    	js     801c7a <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bf1:	83 ec 0c             	sub    $0xc,%esp
  801bf4:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf7:	e8 6a f5 ff ff       	call   801166 <fd2data>
  801bfc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c03:	50                   	push   %eax
  801c04:	6a 00                	push   $0x0
  801c06:	56                   	push   %esi
  801c07:	6a 00                	push   $0x0
  801c09:	e8 51 f0 ff ff       	call   800c5f <sys_page_map>
  801c0e:	89 c3                	mov    %eax,%ebx
  801c10:	83 c4 20             	add    $0x20,%esp
  801c13:	85 c0                	test   %eax,%eax
  801c15:	78 55                	js     801c6c <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801c17:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c2c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c35:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c41:	83 ec 0c             	sub    $0xc,%esp
  801c44:	ff 75 f4             	pushl  -0xc(%ebp)
  801c47:	e8 0a f5 ff ff       	call   801156 <fd2num>
  801c4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c51:	83 c4 04             	add    $0x4,%esp
  801c54:	ff 75 f0             	pushl  -0x10(%ebp)
  801c57:	e8 fa f4 ff ff       	call   801156 <fd2num>
  801c5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c62:	83 c4 10             	add    $0x10,%esp
  801c65:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c6a:	eb 2e                	jmp    801c9a <pipe+0x148>
	sys_page_unmap(0, va);
  801c6c:	83 ec 08             	sub    $0x8,%esp
  801c6f:	56                   	push   %esi
  801c70:	6a 00                	push   $0x0
  801c72:	e8 2a f0 ff ff       	call   800ca1 <sys_page_unmap>
  801c77:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c7a:	83 ec 08             	sub    $0x8,%esp
  801c7d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c80:	6a 00                	push   $0x0
  801c82:	e8 1a f0 ff ff       	call   800ca1 <sys_page_unmap>
  801c87:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c8a:	83 ec 08             	sub    $0x8,%esp
  801c8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c90:	6a 00                	push   $0x0
  801c92:	e8 0a f0 ff ff       	call   800ca1 <sys_page_unmap>
  801c97:	83 c4 10             	add    $0x10,%esp
}
  801c9a:	89 d8                	mov    %ebx,%eax
  801c9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    

00801ca3 <pipeisclosed>:
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ca9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cac:	50                   	push   %eax
  801cad:	ff 75 08             	pushl  0x8(%ebp)
  801cb0:	e8 17 f5 ff ff       	call   8011cc <fd_lookup>
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	78 18                	js     801cd4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801cbc:	83 ec 0c             	sub    $0xc,%esp
  801cbf:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc2:	e8 9f f4 ff ff       	call   801166 <fd2data>
	return _pipeisclosed(fd, p);
  801cc7:	89 c2                	mov    %eax,%edx
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	e8 37 fd ff ff       	call   801a08 <_pipeisclosed>
  801cd1:	83 c4 10             	add    $0x10,%esp
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    

00801ce0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801cea:	68 d5 27 80 00       	push   $0x8027d5
  801cef:	53                   	push   %ebx
  801cf0:	e8 72 eb ff ff       	call   800867 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801cf5:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801cfc:	20 00 00 
	return 0;
}
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
  801d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <devcons_write>:
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	57                   	push   %edi
  801d0d:	56                   	push   %esi
  801d0e:	53                   	push   %ebx
  801d0f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d15:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d1a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d20:	eb 1d                	jmp    801d3f <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801d22:	83 ec 04             	sub    $0x4,%esp
  801d25:	53                   	push   %ebx
  801d26:	03 45 0c             	add    0xc(%ebp),%eax
  801d29:	50                   	push   %eax
  801d2a:	57                   	push   %edi
  801d2b:	e8 aa ec ff ff       	call   8009da <memmove>
		sys_cputs(buf, m);
  801d30:	83 c4 08             	add    $0x8,%esp
  801d33:	53                   	push   %ebx
  801d34:	57                   	push   %edi
  801d35:	e8 45 ee ff ff       	call   800b7f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d3a:	01 de                	add    %ebx,%esi
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	89 f0                	mov    %esi,%eax
  801d41:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d44:	73 11                	jae    801d57 <devcons_write+0x4e>
		m = n - tot;
  801d46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d49:	29 f3                	sub    %esi,%ebx
  801d4b:	83 fb 7f             	cmp    $0x7f,%ebx
  801d4e:	76 d2                	jbe    801d22 <devcons_write+0x19>
  801d50:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801d55:	eb cb                	jmp    801d22 <devcons_write+0x19>
}
  801d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d5a:	5b                   	pop    %ebx
  801d5b:	5e                   	pop    %esi
  801d5c:	5f                   	pop    %edi
  801d5d:	5d                   	pop    %ebp
  801d5e:	c3                   	ret    

00801d5f <devcons_read>:
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801d65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d69:	75 0c                	jne    801d77 <devcons_read+0x18>
		return 0;
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	eb 21                	jmp    801d93 <devcons_read+0x34>
		sys_yield();
  801d72:	e8 6c ef ff ff       	call   800ce3 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801d77:	e8 21 ee ff ff       	call   800b9d <sys_cgetc>
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	74 f2                	je     801d72 <devcons_read+0x13>
	if (c < 0)
  801d80:	85 c0                	test   %eax,%eax
  801d82:	78 0f                	js     801d93 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801d84:	83 f8 04             	cmp    $0x4,%eax
  801d87:	74 0c                	je     801d95 <devcons_read+0x36>
	*(char*)vbuf = c;
  801d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8c:	88 02                	mov    %al,(%edx)
	return 1;
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    
		return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9a:	eb f7                	jmp    801d93 <devcons_read+0x34>

00801d9c <cputchar>:
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801da8:	6a 01                	push   $0x1
  801daa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dad:	50                   	push   %eax
  801dae:	e8 cc ed ff ff       	call   800b7f <sys_cputs>
}
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <getchar>:
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801dbe:	6a 01                	push   $0x1
  801dc0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dc3:	50                   	push   %eax
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 6e f6 ff ff       	call   801439 <read>
	if (r < 0)
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 08                	js     801dda <getchar+0x22>
	if (r < 1)
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	7e 06                	jle    801ddc <getchar+0x24>
	return c;
  801dd6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    
		return -E_EOF;
  801ddc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801de1:	eb f7                	jmp    801dda <getchar+0x22>

00801de3 <iscons>:
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801de9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dec:	50                   	push   %eax
  801ded:	ff 75 08             	pushl  0x8(%ebp)
  801df0:	e8 d7 f3 ff ff       	call   8011cc <fd_lookup>
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 11                	js     801e0d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e05:	39 10                	cmp    %edx,(%eax)
  801e07:	0f 94 c0             	sete   %al
  801e0a:	0f b6 c0             	movzbl %al,%eax
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <opencons>:
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e18:	50                   	push   %eax
  801e19:	e8 5f f3 ff ff       	call   80117d <fd_alloc>
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	85 c0                	test   %eax,%eax
  801e23:	78 3a                	js     801e5f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	68 07 04 00 00       	push   $0x407
  801e2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e30:	6a 00                	push   $0x0
  801e32:	e8 e5 ed ff ff       	call   800c1c <sys_page_alloc>
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	78 21                	js     801e5f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e3e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e47:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	50                   	push   %eax
  801e57:	e8 fa f2 ff ff       	call   801156 <fd2num>
  801e5c:	83 c4 10             	add    $0x10,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801e67:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e6e:	74 0a                	je     801e7a <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801e7a:	e8 7e ed ff ff       	call   800bfd <sys_getenvid>
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	6a 07                	push   $0x7
  801e84:	68 00 f0 bf ee       	push   $0xeebff000
  801e89:	50                   	push   %eax
  801e8a:	e8 8d ed ff ff       	call   800c1c <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801e8f:	e8 69 ed ff ff       	call   800bfd <sys_getenvid>
  801e94:	83 c4 08             	add    $0x8,%esp
  801e97:	68 a7 1e 80 00       	push   $0x801ea7
  801e9c:	50                   	push   %eax
  801e9d:	e8 25 ef ff ff       	call   800dc7 <sys_env_set_pgfault_upcall>
  801ea2:	83 c4 10             	add    $0x10,%esp
  801ea5:	eb c9                	jmp    801e70 <set_pgfault_handler+0xf>

00801ea7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801ea7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801ea8:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801ead:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801eaf:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  801eb2:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801eb6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801eba:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801ebd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801ebf:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  801ec3:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801ec6:	61                   	popa   
	addl $4, %esp
  801ec7:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801eca:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801ecb:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801ecc:	c3                   	ret    

00801ecd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	57                   	push   %edi
  801ed1:	56                   	push   %esi
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ed9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801edc:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801edf:	85 ff                	test   %edi,%edi
  801ee1:	74 53                	je     801f36 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	57                   	push   %edi
  801ee7:	e8 40 ef ff ff       	call   800e2c <sys_ipc_recv>
  801eec:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801eef:	85 db                	test   %ebx,%ebx
  801ef1:	74 0b                	je     801efe <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801ef3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ef9:	8b 52 74             	mov    0x74(%edx),%edx
  801efc:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801efe:	85 f6                	test   %esi,%esi
  801f00:	74 0f                	je     801f11 <ipc_recv+0x44>
  801f02:	85 ff                	test   %edi,%edi
  801f04:	74 0b                	je     801f11 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801f06:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f0c:	8b 52 78             	mov    0x78(%edx),%edx
  801f0f:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801f11:	85 c0                	test   %eax,%eax
  801f13:	74 30                	je     801f45 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801f15:	85 db                	test   %ebx,%ebx
  801f17:	74 06                	je     801f1f <ipc_recv+0x52>
      		*from_env_store = 0;
  801f19:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801f1f:	85 f6                	test   %esi,%esi
  801f21:	74 2c                	je     801f4f <ipc_recv+0x82>
      		*perm_store = 0;
  801f23:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5f                   	pop    %edi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	6a ff                	push   $0xffffffff
  801f3b:	e8 ec ee ff ff       	call   800e2c <sys_ipc_recv>
  801f40:	83 c4 10             	add    $0x10,%esp
  801f43:	eb aa                	jmp    801eef <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801f45:	a1 08 40 80 00       	mov    0x804008,%eax
  801f4a:	8b 40 70             	mov    0x70(%eax),%eax
  801f4d:	eb df                	jmp    801f2e <ipc_recv+0x61>
		return -1;
  801f4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f54:	eb d8                	jmp    801f2e <ipc_recv+0x61>

00801f56 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	57                   	push   %edi
  801f5a:	56                   	push   %esi
  801f5b:	53                   	push   %ebx
  801f5c:	83 ec 0c             	sub    $0xc,%esp
  801f5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f65:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801f68:	85 db                	test   %ebx,%ebx
  801f6a:	75 22                	jne    801f8e <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801f6c:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801f71:	eb 1b                	jmp    801f8e <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801f73:	68 e4 27 80 00       	push   $0x8027e4
  801f78:	68 d6 26 80 00       	push   $0x8026d6
  801f7d:	6a 48                	push   $0x48
  801f7f:	68 08 28 80 00       	push   $0x802808
  801f84:	e8 c3 e1 ff ff       	call   80014c <_panic>
		sys_yield();
  801f89:	e8 55 ed ff ff       	call   800ce3 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801f8e:	57                   	push   %edi
  801f8f:	53                   	push   %ebx
  801f90:	56                   	push   %esi
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	e8 70 ee ff ff       	call   800e09 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f9f:	74 e8                	je     801f89 <ipc_send+0x33>
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	75 ce                	jne    801f73 <ipc_send+0x1d>
		sys_yield();
  801fa5:	e8 39 ed ff ff       	call   800ce3 <sys_yield>
		
	}
	
}
  801faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fad:	5b                   	pop    %ebx
  801fae:	5e                   	pop    %esi
  801faf:	5f                   	pop    %edi
  801fb0:	5d                   	pop    %ebp
  801fb1:	c3                   	ret    

00801fb2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fbd:	89 c2                	mov    %eax,%edx
  801fbf:	c1 e2 05             	shl    $0x5,%edx
  801fc2:	29 c2                	sub    %eax,%edx
  801fc4:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801fcb:	8b 52 50             	mov    0x50(%edx),%edx
  801fce:	39 ca                	cmp    %ecx,%edx
  801fd0:	74 0f                	je     801fe1 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801fd2:	40                   	inc    %eax
  801fd3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fd8:	75 e3                	jne    801fbd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdf:	eb 11                	jmp    801ff2 <ipc_find_env+0x40>
			return envs[i].env_id;
  801fe1:	89 c2                	mov    %eax,%edx
  801fe3:	c1 e2 05             	shl    $0x5,%edx
  801fe6:	29 c2                	sub    %eax,%edx
  801fe8:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801fef:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    

00801ff4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	c1 e8 16             	shr    $0x16,%eax
  801ffd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802004:	a8 01                	test   $0x1,%al
  802006:	74 21                	je     802029 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	c1 e8 0c             	shr    $0xc,%eax
  80200e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802015:	a8 01                	test   $0x1,%al
  802017:	74 17                	je     802030 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802019:	c1 e8 0c             	shr    $0xc,%eax
  80201c:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802023:	ef 
  802024:	0f b7 c0             	movzwl %ax,%eax
  802027:	eb 05                	jmp    80202e <pageref+0x3a>
		return 0;
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    
		return 0;
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
  802035:	eb f7                	jmp    80202e <pageref+0x3a>
  802037:	90                   	nop

00802038 <__udivdi3>:
  802038:	55                   	push   %ebp
  802039:	57                   	push   %edi
  80203a:	56                   	push   %esi
  80203b:	53                   	push   %ebx
  80203c:	83 ec 1c             	sub    $0x1c,%esp
  80203f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802043:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802047:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80204b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80204f:	89 ca                	mov    %ecx,%edx
  802051:	89 f8                	mov    %edi,%eax
  802053:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802057:	85 f6                	test   %esi,%esi
  802059:	75 2d                	jne    802088 <__udivdi3+0x50>
  80205b:	39 cf                	cmp    %ecx,%edi
  80205d:	77 65                	ja     8020c4 <__udivdi3+0x8c>
  80205f:	89 fd                	mov    %edi,%ebp
  802061:	85 ff                	test   %edi,%edi
  802063:	75 0b                	jne    802070 <__udivdi3+0x38>
  802065:	b8 01 00 00 00       	mov    $0x1,%eax
  80206a:	31 d2                	xor    %edx,%edx
  80206c:	f7 f7                	div    %edi
  80206e:	89 c5                	mov    %eax,%ebp
  802070:	31 d2                	xor    %edx,%edx
  802072:	89 c8                	mov    %ecx,%eax
  802074:	f7 f5                	div    %ebp
  802076:	89 c1                	mov    %eax,%ecx
  802078:	89 d8                	mov    %ebx,%eax
  80207a:	f7 f5                	div    %ebp
  80207c:	89 cf                	mov    %ecx,%edi
  80207e:	89 fa                	mov    %edi,%edx
  802080:	83 c4 1c             	add    $0x1c,%esp
  802083:	5b                   	pop    %ebx
  802084:	5e                   	pop    %esi
  802085:	5f                   	pop    %edi
  802086:	5d                   	pop    %ebp
  802087:	c3                   	ret    
  802088:	39 ce                	cmp    %ecx,%esi
  80208a:	77 28                	ja     8020b4 <__udivdi3+0x7c>
  80208c:	0f bd fe             	bsr    %esi,%edi
  80208f:	83 f7 1f             	xor    $0x1f,%edi
  802092:	75 40                	jne    8020d4 <__udivdi3+0x9c>
  802094:	39 ce                	cmp    %ecx,%esi
  802096:	72 0a                	jb     8020a2 <__udivdi3+0x6a>
  802098:	3b 44 24 04          	cmp    0x4(%esp),%eax
  80209c:	0f 87 9e 00 00 00    	ja     802140 <__udivdi3+0x108>
  8020a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a7:	89 fa                	mov    %edi,%edx
  8020a9:	83 c4 1c             	add    $0x1c,%esp
  8020ac:	5b                   	pop    %ebx
  8020ad:	5e                   	pop    %esi
  8020ae:	5f                   	pop    %edi
  8020af:	5d                   	pop    %ebp
  8020b0:	c3                   	ret    
  8020b1:	8d 76 00             	lea    0x0(%esi),%esi
  8020b4:	31 ff                	xor    %edi,%edi
  8020b6:	31 c0                	xor    %eax,%eax
  8020b8:	89 fa                	mov    %edi,%edx
  8020ba:	83 c4 1c             	add    $0x1c,%esp
  8020bd:	5b                   	pop    %ebx
  8020be:	5e                   	pop    %esi
  8020bf:	5f                   	pop    %edi
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    
  8020c2:	66 90                	xchg   %ax,%ax
  8020c4:	89 d8                	mov    %ebx,%eax
  8020c6:	f7 f7                	div    %edi
  8020c8:	31 ff                	xor    %edi,%edi
  8020ca:	89 fa                	mov    %edi,%edx
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    
  8020d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020d9:	29 fd                	sub    %edi,%ebp
  8020db:	89 f9                	mov    %edi,%ecx
  8020dd:	d3 e6                	shl    %cl,%esi
  8020df:	89 c3                	mov    %eax,%ebx
  8020e1:	89 e9                	mov    %ebp,%ecx
  8020e3:	d3 eb                	shr    %cl,%ebx
  8020e5:	89 d9                	mov    %ebx,%ecx
  8020e7:	09 f1                	or     %esi,%ecx
  8020e9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020ed:	89 f9                	mov    %edi,%ecx
  8020ef:	d3 e0                	shl    %cl,%eax
  8020f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020f5:	89 d6                	mov    %edx,%esi
  8020f7:	89 e9                	mov    %ebp,%ecx
  8020f9:	d3 ee                	shr    %cl,%esi
  8020fb:	89 f9                	mov    %edi,%ecx
  8020fd:	d3 e2                	shl    %cl,%edx
  8020ff:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802103:	89 e9                	mov    %ebp,%ecx
  802105:	d3 eb                	shr    %cl,%ebx
  802107:	09 da                	or     %ebx,%edx
  802109:	89 d0                	mov    %edx,%eax
  80210b:	89 f2                	mov    %esi,%edx
  80210d:	f7 74 24 08          	divl   0x8(%esp)
  802111:	89 d6                	mov    %edx,%esi
  802113:	89 c3                	mov    %eax,%ebx
  802115:	f7 64 24 0c          	mull   0xc(%esp)
  802119:	39 d6                	cmp    %edx,%esi
  80211b:	72 17                	jb     802134 <__udivdi3+0xfc>
  80211d:	74 09                	je     802128 <__udivdi3+0xf0>
  80211f:	89 d8                	mov    %ebx,%eax
  802121:	31 ff                	xor    %edi,%edi
  802123:	e9 56 ff ff ff       	jmp    80207e <__udivdi3+0x46>
  802128:	8b 54 24 04          	mov    0x4(%esp),%edx
  80212c:	89 f9                	mov    %edi,%ecx
  80212e:	d3 e2                	shl    %cl,%edx
  802130:	39 c2                	cmp    %eax,%edx
  802132:	73 eb                	jae    80211f <__udivdi3+0xe7>
  802134:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802137:	31 ff                	xor    %edi,%edi
  802139:	e9 40 ff ff ff       	jmp    80207e <__udivdi3+0x46>
  80213e:	66 90                	xchg   %ax,%ax
  802140:	31 c0                	xor    %eax,%eax
  802142:	e9 37 ff ff ff       	jmp    80207e <__udivdi3+0x46>
  802147:	90                   	nop

00802148 <__umoddi3>:
  802148:	55                   	push   %ebp
  802149:	57                   	push   %edi
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
  80214c:	83 ec 1c             	sub    $0x1c,%esp
  80214f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802153:	8b 74 24 34          	mov    0x34(%esp),%esi
  802157:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80215b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80215f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802163:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802167:	89 3c 24             	mov    %edi,(%esp)
  80216a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80216e:	89 f2                	mov    %esi,%edx
  802170:	85 c0                	test   %eax,%eax
  802172:	75 18                	jne    80218c <__umoddi3+0x44>
  802174:	39 f7                	cmp    %esi,%edi
  802176:	0f 86 a0 00 00 00    	jbe    80221c <__umoddi3+0xd4>
  80217c:	89 c8                	mov    %ecx,%eax
  80217e:	f7 f7                	div    %edi
  802180:	89 d0                	mov    %edx,%eax
  802182:	31 d2                	xor    %edx,%edx
  802184:	83 c4 1c             	add    $0x1c,%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5f                   	pop    %edi
  80218a:	5d                   	pop    %ebp
  80218b:	c3                   	ret    
  80218c:	89 f3                	mov    %esi,%ebx
  80218e:	39 f0                	cmp    %esi,%eax
  802190:	0f 87 a6 00 00 00    	ja     80223c <__umoddi3+0xf4>
  802196:	0f bd e8             	bsr    %eax,%ebp
  802199:	83 f5 1f             	xor    $0x1f,%ebp
  80219c:	0f 84 a6 00 00 00    	je     802248 <__umoddi3+0x100>
  8021a2:	bf 20 00 00 00       	mov    $0x20,%edi
  8021a7:	29 ef                	sub    %ebp,%edi
  8021a9:	89 e9                	mov    %ebp,%ecx
  8021ab:	d3 e0                	shl    %cl,%eax
  8021ad:	8b 34 24             	mov    (%esp),%esi
  8021b0:	89 f2                	mov    %esi,%edx
  8021b2:	89 f9                	mov    %edi,%ecx
  8021b4:	d3 ea                	shr    %cl,%edx
  8021b6:	09 c2                	or     %eax,%edx
  8021b8:	89 14 24             	mov    %edx,(%esp)
  8021bb:	89 f2                	mov    %esi,%edx
  8021bd:	89 e9                	mov    %ebp,%ecx
  8021bf:	d3 e2                	shl    %cl,%edx
  8021c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021c5:	89 de                	mov    %ebx,%esi
  8021c7:	89 f9                	mov    %edi,%ecx
  8021c9:	d3 ee                	shr    %cl,%esi
  8021cb:	89 e9                	mov    %ebp,%ecx
  8021cd:	d3 e3                	shl    %cl,%ebx
  8021cf:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021d3:	89 d0                	mov    %edx,%eax
  8021d5:	89 f9                	mov    %edi,%ecx
  8021d7:	d3 e8                	shr    %cl,%eax
  8021d9:	09 d8                	or     %ebx,%eax
  8021db:	89 d3                	mov    %edx,%ebx
  8021dd:	89 e9                	mov    %ebp,%ecx
  8021df:	d3 e3                	shl    %cl,%ebx
  8021e1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e5:	89 f2                	mov    %esi,%edx
  8021e7:	f7 34 24             	divl   (%esp)
  8021ea:	89 d6                	mov    %edx,%esi
  8021ec:	f7 64 24 04          	mull   0x4(%esp)
  8021f0:	89 c3                	mov    %eax,%ebx
  8021f2:	89 d1                	mov    %edx,%ecx
  8021f4:	39 d6                	cmp    %edx,%esi
  8021f6:	72 7c                	jb     802274 <__umoddi3+0x12c>
  8021f8:	74 72                	je     80226c <__umoddi3+0x124>
  8021fa:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021fe:	29 da                	sub    %ebx,%edx
  802200:	19 ce                	sbb    %ecx,%esi
  802202:	89 f0                	mov    %esi,%eax
  802204:	89 f9                	mov    %edi,%ecx
  802206:	d3 e0                	shl    %cl,%eax
  802208:	89 e9                	mov    %ebp,%ecx
  80220a:	d3 ea                	shr    %cl,%edx
  80220c:	09 d0                	or     %edx,%eax
  80220e:	89 e9                	mov    %ebp,%ecx
  802210:	d3 ee                	shr    %cl,%esi
  802212:	89 f2                	mov    %esi,%edx
  802214:	83 c4 1c             	add    $0x1c,%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5f                   	pop    %edi
  80221a:	5d                   	pop    %ebp
  80221b:	c3                   	ret    
  80221c:	89 fd                	mov    %edi,%ebp
  80221e:	85 ff                	test   %edi,%edi
  802220:	75 0b                	jne    80222d <__umoddi3+0xe5>
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	31 d2                	xor    %edx,%edx
  802229:	f7 f7                	div    %edi
  80222b:	89 c5                	mov    %eax,%ebp
  80222d:	89 f0                	mov    %esi,%eax
  80222f:	31 d2                	xor    %edx,%edx
  802231:	f7 f5                	div    %ebp
  802233:	89 c8                	mov    %ecx,%eax
  802235:	f7 f5                	div    %ebp
  802237:	e9 44 ff ff ff       	jmp    802180 <__umoddi3+0x38>
  80223c:	89 c8                	mov    %ecx,%eax
  80223e:	89 f2                	mov    %esi,%edx
  802240:	83 c4 1c             	add    $0x1c,%esp
  802243:	5b                   	pop    %ebx
  802244:	5e                   	pop    %esi
  802245:	5f                   	pop    %edi
  802246:	5d                   	pop    %ebp
  802247:	c3                   	ret    
  802248:	39 f0                	cmp    %esi,%eax
  80224a:	72 05                	jb     802251 <__umoddi3+0x109>
  80224c:	39 0c 24             	cmp    %ecx,(%esp)
  80224f:	77 0c                	ja     80225d <__umoddi3+0x115>
  802251:	89 f2                	mov    %esi,%edx
  802253:	29 f9                	sub    %edi,%ecx
  802255:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802259:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80225d:	8b 44 24 04          	mov    0x4(%esp),%eax
  802261:	83 c4 1c             	add    $0x1c,%esp
  802264:	5b                   	pop    %ebx
  802265:	5e                   	pop    %esi
  802266:	5f                   	pop    %edi
  802267:	5d                   	pop    %ebp
  802268:	c3                   	ret    
  802269:	8d 76 00             	lea    0x0(%esi),%esi
  80226c:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802270:	73 88                	jae    8021fa <__umoddi3+0xb2>
  802272:	66 90                	xchg   %ax,%ax
  802274:	2b 44 24 04          	sub    0x4(%esp),%eax
  802278:	1b 14 24             	sbb    (%esp),%edx
  80227b:	89 d1                	mov    %edx,%ecx
  80227d:	89 c3                	mov    %eax,%ebx
  80227f:	e9 76 ff ff ff       	jmp    8021fa <__umoddi3+0xb2>
