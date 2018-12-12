
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 c5 00 00 00       	call   8000f6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 1a 11 00 00       	call   801166 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 40 80 00       	mov    0x804004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 a0 22 80 00       	push   $0x8022a0
  800060:	e8 0a 02 00 00       	call   80026f <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 3b 0f 00 00       	call   800fa5 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 30                	js     8000a3 <primeproc+0x70>
		panic("fork: %e", id);
	if (id == 0)
  800073:	85 c0                	test   %eax,%eax
  800075:	74 c8                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800077:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	6a 00                	push   $0x0
  80007f:	6a 00                	push   $0x0
  800081:	56                   	push   %esi
  800082:	e8 df 10 00 00       	call   801166 <ipc_recv>
  800087:	89 c1                	mov    %eax,%ecx
		if (i % p)
  800089:	99                   	cltd   
  80008a:	f7 fb                	idiv   %ebx
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	85 d2                	test   %edx,%edx
  800091:	74 e7                	je     80007a <primeproc+0x47>
			ipc_send(id, i, 0, 0);
  800093:	6a 00                	push   $0x0
  800095:	6a 00                	push   $0x0
  800097:	51                   	push   %ecx
  800098:	57                   	push   %edi
  800099:	e8 51 11 00 00       	call   8011ef <ipc_send>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	eb d7                	jmp    80007a <primeproc+0x47>
		panic("fork: %e", id);
  8000a3:	50                   	push   %eax
  8000a4:	68 ac 22 80 00       	push   $0x8022ac
  8000a9:	6a 1a                	push   $0x1a
  8000ab:	68 b5 22 80 00       	push   $0x8022b5
  8000b0:	e8 a7 00 00 00       	call   80015c <_panic>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 e6 0e 00 00       	call   800fa5 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1a                	js     8000df <umain+0x2a>
		panic("fork: %e", id);
	if (id == 0)
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	74 28                	je     8000f1 <umain+0x3c>
  8000c9:	bb 02 00 00 00       	mov    $0x2,%ebx
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  8000ce:	6a 00                	push   $0x0
  8000d0:	6a 00                	push   $0x0
  8000d2:	53                   	push   %ebx
  8000d3:	56                   	push   %esi
  8000d4:	e8 16 11 00 00       	call   8011ef <ipc_send>
	for (i = 2; ; i++)
  8000d9:	43                   	inc    %ebx
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	eb ef                	jmp    8000ce <umain+0x19>
		panic("fork: %e", id);
  8000df:	50                   	push   %eax
  8000e0:	68 ac 22 80 00       	push   $0x8022ac
  8000e5:	6a 2d                	push   $0x2d
  8000e7:	68 b5 22 80 00       	push   $0x8022b5
  8000ec:	e8 6b 00 00 00       	call   80015c <_panic>
		primeproc();
  8000f1:	e8 3d ff ff ff       	call   800033 <primeproc>

008000f6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	56                   	push   %esi
  8000fa:	53                   	push   %ebx
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800101:	e8 07 0b 00 00       	call   800c0d <sys_getenvid>
  800106:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	c1 e2 05             	shl    $0x5,%edx
  800110:	29 c2                	sub    %eax,%edx
  800112:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800119:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011e:	85 db                	test   %ebx,%ebx
  800120:	7e 07                	jle    800129 <libmain+0x33>
		binaryname = argv[0];
  800122:	8b 06                	mov    (%esi),%eax
  800124:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	56                   	push   %esi
  80012d:	53                   	push   %ebx
  80012e:	e8 82 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  800133:	e8 0a 00 00 00       	call   800142 <exit>
}
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013e:	5b                   	pop    %ebx
  80013f:	5e                   	pop    %esi
  800140:	5d                   	pop    %ebp
  800141:	c3                   	ret    

00800142 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800148:	e8 14 13 00 00       	call   801461 <close_all>
	sys_env_destroy(0);
  80014d:	83 ec 0c             	sub    $0xc,%esp
  800150:	6a 00                	push   $0x0
  800152:	e8 75 0a 00 00       	call   800bcc <sys_env_destroy>
}
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	57                   	push   %edi
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800168:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80016b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800171:	e8 97 0a 00 00       	call   800c0d <sys_getenvid>
  800176:	83 ec 04             	sub    $0x4,%esp
  800179:	ff 75 0c             	pushl  0xc(%ebp)
  80017c:	ff 75 08             	pushl  0x8(%ebp)
  80017f:	53                   	push   %ebx
  800180:	50                   	push   %eax
  800181:	68 d0 22 80 00       	push   $0x8022d0
  800186:	68 00 01 00 00       	push   $0x100
  80018b:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800191:	56                   	push   %esi
  800192:	e8 93 06 00 00       	call   80082a <snprintf>
  800197:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800199:	83 c4 20             	add    $0x20,%esp
  80019c:	57                   	push   %edi
  80019d:	ff 75 10             	pushl  0x10(%ebp)
  8001a0:	bf 00 01 00 00       	mov    $0x100,%edi
  8001a5:	89 f8                	mov    %edi,%eax
  8001a7:	29 d8                	sub    %ebx,%eax
  8001a9:	50                   	push   %eax
  8001aa:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8001ad:	50                   	push   %eax
  8001ae:	e8 22 06 00 00       	call   8007d5 <vsnprintf>
  8001b3:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8001b5:	83 c4 0c             	add    $0xc,%esp
  8001b8:	68 e2 27 80 00       	push   $0x8027e2
  8001bd:	29 df                	sub    %ebx,%edi
  8001bf:	57                   	push   %edi
  8001c0:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8001c3:	50                   	push   %eax
  8001c4:	e8 61 06 00 00       	call   80082a <snprintf>
	sys_cputs(buf, r);
  8001c9:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8001cc:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8001ce:	53                   	push   %ebx
  8001cf:	56                   	push   %esi
  8001d0:	e8 ba 09 00 00       	call   800b8f <sys_cputs>
  8001d5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d8:	cc                   	int3   
  8001d9:	eb fd                	jmp    8001d8 <_panic+0x7c>

008001db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	53                   	push   %ebx
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e5:	8b 13                	mov    (%ebx),%edx
  8001e7:	8d 42 01             	lea    0x1(%edx),%eax
  8001ea:	89 03                	mov    %eax,(%ebx)
  8001ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f8:	74 08                	je     800202 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001fa:	ff 43 04             	incl   0x4(%ebx)
}
  8001fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800200:	c9                   	leave  
  800201:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	68 ff 00 00 00       	push   $0xff
  80020a:	8d 43 08             	lea    0x8(%ebx),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 7c 09 00 00       	call   800b8f <sys_cputs>
		b->idx = 0;
  800213:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb dc                	jmp    8001fa <putch+0x1f>

0080021e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800227:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022e:	00 00 00 
	b.cnt = 0;
  800231:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800238:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800247:	50                   	push   %eax
  800248:	68 db 01 80 00       	push   $0x8001db
  80024d:	e8 17 01 00 00       	call   800369 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800252:	83 c4 08             	add    $0x8,%esp
  800255:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80025b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800261:	50                   	push   %eax
  800262:	e8 28 09 00 00       	call   800b8f <sys_cputs>

	return b.cnt;
}
  800267:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800275:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	e8 9d ff ff ff       	call   80021e <vcprintf>
	va_end(ap);

	return cnt;
}
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	57                   	push   %edi
  800287:	56                   	push   %esi
  800288:	53                   	push   %ebx
  800289:	83 ec 1c             	sub    $0x1c,%esp
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	89 d6                	mov    %edx,%esi
  800290:	8b 45 08             	mov    0x8(%ebp),%eax
  800293:	8b 55 0c             	mov    0xc(%ebp),%edx
  800296:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800299:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002aa:	39 d3                	cmp    %edx,%ebx
  8002ac:	72 05                	jb     8002b3 <printnum+0x30>
  8002ae:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b1:	77 78                	ja     80032b <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	ff 75 18             	pushl  0x18(%ebp)
  8002b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002bf:	53                   	push   %ebx
  8002c0:	ff 75 10             	pushl  0x10(%ebp)
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d2:	e8 71 1d 00 00       	call   802048 <__udivdi3>
  8002d7:	83 c4 18             	add    $0x18,%esp
  8002da:	52                   	push   %edx
  8002db:	50                   	push   %eax
  8002dc:	89 f2                	mov    %esi,%edx
  8002de:	89 f8                	mov    %edi,%eax
  8002e0:	e8 9e ff ff ff       	call   800283 <printnum>
  8002e5:	83 c4 20             	add    $0x20,%esp
  8002e8:	eb 11                	jmp    8002fb <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	56                   	push   %esi
  8002ee:	ff 75 18             	pushl  0x18(%ebp)
  8002f1:	ff d7                	call   *%edi
  8002f3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002f6:	4b                   	dec    %ebx
  8002f7:	85 db                	test   %ebx,%ebx
  8002f9:	7f ef                	jg     8002ea <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002fb:	83 ec 08             	sub    $0x8,%esp
  8002fe:	56                   	push   %esi
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	ff 75 e4             	pushl  -0x1c(%ebp)
  800305:	ff 75 e0             	pushl  -0x20(%ebp)
  800308:	ff 75 dc             	pushl  -0x24(%ebp)
  80030b:	ff 75 d8             	pushl  -0x28(%ebp)
  80030e:	e8 45 1e 00 00       	call   802158 <__umoddi3>
  800313:	83 c4 14             	add    $0x14,%esp
  800316:	0f be 80 f3 22 80 00 	movsbl 0x8022f3(%eax),%eax
  80031d:	50                   	push   %eax
  80031e:	ff d7                	call   *%edi
}
  800320:	83 c4 10             	add    $0x10,%esp
  800323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800326:	5b                   	pop    %ebx
  800327:	5e                   	pop    %esi
  800328:	5f                   	pop    %edi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    
  80032b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80032e:	eb c6                	jmp    8002f6 <printnum+0x73>

00800330 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800336:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800339:	8b 10                	mov    (%eax),%edx
  80033b:	3b 50 04             	cmp    0x4(%eax),%edx
  80033e:	73 0a                	jae    80034a <sprintputch+0x1a>
		*b->buf++ = ch;
  800340:	8d 4a 01             	lea    0x1(%edx),%ecx
  800343:	89 08                	mov    %ecx,(%eax)
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
  800348:	88 02                	mov    %al,(%edx)
}
  80034a:	5d                   	pop    %ebp
  80034b:	c3                   	ret    

0080034c <printfmt>:
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800352:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800355:	50                   	push   %eax
  800356:	ff 75 10             	pushl  0x10(%ebp)
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	e8 05 00 00 00       	call   800369 <vprintfmt>
}
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	c9                   	leave  
  800368:	c3                   	ret    

00800369 <vprintfmt>:
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	57                   	push   %edi
  80036d:	56                   	push   %esi
  80036e:	53                   	push   %ebx
  80036f:	83 ec 2c             	sub    $0x2c,%esp
  800372:	8b 75 08             	mov    0x8(%ebp),%esi
  800375:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800378:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037b:	e9 ae 03 00 00       	jmp    80072e <vprintfmt+0x3c5>
  800380:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800384:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80038b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800392:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800399:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	8d 47 01             	lea    0x1(%edi),%eax
  8003a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a4:	8a 17                	mov    (%edi),%dl
  8003a6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a9:	3c 55                	cmp    $0x55,%al
  8003ab:	0f 87 fe 03 00 00    	ja     8007af <vprintfmt+0x446>
  8003b1:	0f b6 c0             	movzbl %al,%eax
  8003b4:	ff 24 85 40 24 80 00 	jmp    *0x802440(,%eax,4)
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003be:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003c2:	eb da                	jmp    80039e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003cb:	eb d1                	jmp    80039e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003cd:	0f b6 d2             	movzbl %dl,%edx
  8003d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003db:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003de:	01 c0                	add    %eax,%eax
  8003e0:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8003e4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003ea:	83 f9 09             	cmp    $0x9,%ecx
  8003ed:	77 52                	ja     800441 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8003ef:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8003f0:	eb e9                	jmp    8003db <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8003f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	8d 40 04             	lea    0x4(%eax),%eax
  800400:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800406:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040a:	79 92                	jns    80039e <vprintfmt+0x35>
				width = precision, precision = -1;
  80040c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80040f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800412:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800419:	eb 83                	jmp    80039e <vprintfmt+0x35>
  80041b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041f:	78 08                	js     800429 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800424:	e9 75 ff ff ff       	jmp    80039e <vprintfmt+0x35>
  800429:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800430:	eb ef                	jmp    800421 <vprintfmt+0xb8>
  800432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800435:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80043c:	e9 5d ff ff ff       	jmp    80039e <vprintfmt+0x35>
  800441:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800444:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800447:	eb bd                	jmp    800406 <vprintfmt+0x9d>
			lflag++;
  800449:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044d:	e9 4c ff ff ff       	jmp    80039e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800452:	8b 45 14             	mov    0x14(%ebp),%eax
  800455:	8d 78 04             	lea    0x4(%eax),%edi
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	53                   	push   %ebx
  80045c:	ff 30                	pushl  (%eax)
  80045e:	ff d6                	call   *%esi
			break;
  800460:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800466:	e9 c0 02 00 00       	jmp    80072b <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	8d 78 04             	lea    0x4(%eax),%edi
  800471:	8b 00                	mov    (%eax),%eax
  800473:	85 c0                	test   %eax,%eax
  800475:	78 2a                	js     8004a1 <vprintfmt+0x138>
  800477:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800479:	83 f8 0f             	cmp    $0xf,%eax
  80047c:	7f 27                	jg     8004a5 <vprintfmt+0x13c>
  80047e:	8b 04 85 a0 25 80 00 	mov    0x8025a0(,%eax,4),%eax
  800485:	85 c0                	test   %eax,%eax
  800487:	74 1c                	je     8004a5 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800489:	50                   	push   %eax
  80048a:	68 c8 26 80 00       	push   $0x8026c8
  80048f:	53                   	push   %ebx
  800490:	56                   	push   %esi
  800491:	e8 b6 fe ff ff       	call   80034c <printfmt>
  800496:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800499:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049c:	e9 8a 02 00 00       	jmp    80072b <vprintfmt+0x3c2>
  8004a1:	f7 d8                	neg    %eax
  8004a3:	eb d2                	jmp    800477 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8004a5:	52                   	push   %edx
  8004a6:	68 0b 23 80 00       	push   $0x80230b
  8004ab:	53                   	push   %ebx
  8004ac:	56                   	push   %esi
  8004ad:	e8 9a fe ff ff       	call   80034c <printfmt>
  8004b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b8:	e9 6e 02 00 00       	jmp    80072b <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	83 c0 04             	add    $0x4,%eax
  8004c3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c9:	8b 38                	mov    (%eax),%edi
  8004cb:	85 ff                	test   %edi,%edi
  8004cd:	74 39                	je     800508 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8004cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d3:	0f 8e a9 00 00 00    	jle    800582 <vprintfmt+0x219>
  8004d9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004dd:	0f 84 a7 00 00 00    	je     80058a <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 d0             	pushl  -0x30(%ebp)
  8004e9:	57                   	push   %edi
  8004ea:	e8 6b 03 00 00       	call   80085a <strnlen>
  8004ef:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f2:	29 c1                	sub    %eax,%ecx
  8004f4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004f7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004fa:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800501:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800504:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800506:	eb 14                	jmp    80051c <vprintfmt+0x1b3>
				p = "(null)";
  800508:	bf 04 23 80 00       	mov    $0x802304,%edi
  80050d:	eb c0                	jmp    8004cf <vprintfmt+0x166>
					putch(padc, putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	53                   	push   %ebx
  800513:	ff 75 e0             	pushl  -0x20(%ebp)
  800516:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	4f                   	dec    %edi
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	85 ff                	test   %edi,%edi
  80051e:	7f ef                	jg     80050f <vprintfmt+0x1a6>
  800520:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800523:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800526:	89 c8                	mov    %ecx,%eax
  800528:	85 c9                	test   %ecx,%ecx
  80052a:	78 10                	js     80053c <vprintfmt+0x1d3>
  80052c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80052f:	29 c1                	sub    %eax,%ecx
  800531:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800534:	89 75 08             	mov    %esi,0x8(%ebp)
  800537:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053a:	eb 15                	jmp    800551 <vprintfmt+0x1e8>
  80053c:	b8 00 00 00 00       	mov    $0x0,%eax
  800541:	eb e9                	jmp    80052c <vprintfmt+0x1c3>
					putch(ch, putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	52                   	push   %edx
  800548:	ff 55 08             	call   *0x8(%ebp)
  80054b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80054e:	ff 4d e0             	decl   -0x20(%ebp)
  800551:	47                   	inc    %edi
  800552:	8a 47 ff             	mov    -0x1(%edi),%al
  800555:	0f be d0             	movsbl %al,%edx
  800558:	85 d2                	test   %edx,%edx
  80055a:	74 59                	je     8005b5 <vprintfmt+0x24c>
  80055c:	85 f6                	test   %esi,%esi
  80055e:	78 03                	js     800563 <vprintfmt+0x1fa>
  800560:	4e                   	dec    %esi
  800561:	78 2f                	js     800592 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800563:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800567:	74 da                	je     800543 <vprintfmt+0x1da>
  800569:	0f be c0             	movsbl %al,%eax
  80056c:	83 e8 20             	sub    $0x20,%eax
  80056f:	83 f8 5e             	cmp    $0x5e,%eax
  800572:	76 cf                	jbe    800543 <vprintfmt+0x1da>
					putch('?', putdat);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	53                   	push   %ebx
  800578:	6a 3f                	push   $0x3f
  80057a:	ff 55 08             	call   *0x8(%ebp)
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	eb cc                	jmp    80054e <vprintfmt+0x1e5>
  800582:	89 75 08             	mov    %esi,0x8(%ebp)
  800585:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800588:	eb c7                	jmp    800551 <vprintfmt+0x1e8>
  80058a:	89 75 08             	mov    %esi,0x8(%ebp)
  80058d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800590:	eb bf                	jmp    800551 <vprintfmt+0x1e8>
  800592:	8b 75 08             	mov    0x8(%ebp),%esi
  800595:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800598:	eb 0c                	jmp    8005a6 <vprintfmt+0x23d>
				putch(' ', putdat);
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	6a 20                	push   $0x20
  8005a0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005a2:	4f                   	dec    %edi
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	85 ff                	test   %edi,%edi
  8005a8:	7f f0                	jg     80059a <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8005aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b0:	e9 76 01 00 00       	jmp    80072b <vprintfmt+0x3c2>
  8005b5:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005bb:	eb e9                	jmp    8005a6 <vprintfmt+0x23d>
	if (lflag >= 2)
  8005bd:	83 f9 01             	cmp    $0x1,%ecx
  8005c0:	7f 1f                	jg     8005e1 <vprintfmt+0x278>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	75 48                	jne    80060e <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	89 c1                	mov    %eax,%ecx
  8005d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005df:	eb 17                	jmp    8005f8 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 50 04             	mov    0x4(%eax),%edx
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 40 08             	lea    0x8(%eax),%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8005fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800602:	78 25                	js     800629 <vprintfmt+0x2c0>
			base = 10;
  800604:	b8 0a 00 00 00       	mov    $0xa,%eax
  800609:	e9 03 01 00 00       	jmp    800711 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800616:	89 c1                	mov    %eax,%ecx
  800618:	c1 f9 1f             	sar    $0x1f,%ecx
  80061b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
  800627:	eb cf                	jmp    8005f8 <vprintfmt+0x28f>
				putch('-', putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	53                   	push   %ebx
  80062d:	6a 2d                	push   $0x2d
  80062f:	ff d6                	call   *%esi
				num = -(long long) num;
  800631:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800634:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800637:	f7 da                	neg    %edx
  800639:	83 d1 00             	adc    $0x0,%ecx
  80063c:	f7 d9                	neg    %ecx
  80063e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800641:	b8 0a 00 00 00       	mov    $0xa,%eax
  800646:	e9 c6 00 00 00       	jmp    800711 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80064b:	83 f9 01             	cmp    $0x1,%ecx
  80064e:	7f 1e                	jg     80066e <vprintfmt+0x305>
	else if (lflag)
  800650:	85 c9                	test   %ecx,%ecx
  800652:	75 32                	jne    800686 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 10                	mov    (%eax),%edx
  800659:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800664:	b8 0a 00 00 00       	mov    $0xa,%eax
  800669:	e9 a3 00 00 00       	jmp    800711 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 10                	mov    (%eax),%edx
  800673:	8b 48 04             	mov    0x4(%eax),%ecx
  800676:	8d 40 08             	lea    0x8(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800681:	e9 8b 00 00 00       	jmp    800711 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800696:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069b:	eb 74                	jmp    800711 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80069d:	83 f9 01             	cmp    $0x1,%ecx
  8006a0:	7f 1b                	jg     8006bd <vprintfmt+0x354>
	else if (lflag)
  8006a2:	85 c9                	test   %ecx,%ecx
  8006a4:	75 2c                	jne    8006d2 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bb:	eb 54                	jmp    800711 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c5:	8d 40 08             	lea    0x8(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d0:	eb 3f                	jmp    800711 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 10                	mov    (%eax),%edx
  8006d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e2:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e7:	eb 28                	jmp    800711 <vprintfmt+0x3a8>
			putch('0', putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	6a 30                	push   $0x30
  8006ef:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f1:	83 c4 08             	add    $0x8,%esp
  8006f4:	53                   	push   %ebx
  8006f5:	6a 78                	push   $0x78
  8006f7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 10                	mov    (%eax),%edx
  8006fe:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800703:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800711:	83 ec 0c             	sub    $0xc,%esp
  800714:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800718:	57                   	push   %edi
  800719:	ff 75 e0             	pushl  -0x20(%ebp)
  80071c:	50                   	push   %eax
  80071d:	51                   	push   %ecx
  80071e:	52                   	push   %edx
  80071f:	89 da                	mov    %ebx,%edx
  800721:	89 f0                	mov    %esi,%eax
  800723:	e8 5b fb ff ff       	call   800283 <printnum>
			break;
  800728:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80072b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	47                   	inc    %edi
  80072f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800733:	83 f8 25             	cmp    $0x25,%eax
  800736:	0f 84 44 fc ff ff    	je     800380 <vprintfmt+0x17>
			if (ch == '\0')
  80073c:	85 c0                	test   %eax,%eax
  80073e:	0f 84 89 00 00 00    	je     8007cd <vprintfmt+0x464>
			putch(ch, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	53                   	push   %ebx
  800748:	50                   	push   %eax
  800749:	ff d6                	call   *%esi
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	eb de                	jmp    80072e <vprintfmt+0x3c5>
	if (lflag >= 2)
  800750:	83 f9 01             	cmp    $0x1,%ecx
  800753:	7f 1b                	jg     800770 <vprintfmt+0x407>
	else if (lflag)
  800755:	85 c9                	test   %ecx,%ecx
  800757:	75 2c                	jne    800785 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 10                	mov    (%eax),%edx
  80075e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800763:	8d 40 04             	lea    0x4(%eax),%eax
  800766:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800769:	b8 10 00 00 00       	mov    $0x10,%eax
  80076e:	eb a1                	jmp    800711 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8b 10                	mov    (%eax),%edx
  800775:	8b 48 04             	mov    0x4(%eax),%ecx
  800778:	8d 40 08             	lea    0x8(%eax),%eax
  80077b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077e:	b8 10 00 00 00       	mov    $0x10,%eax
  800783:	eb 8c                	jmp    800711 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8b 10                	mov    (%eax),%edx
  80078a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800795:	b8 10 00 00 00       	mov    $0x10,%eax
  80079a:	e9 72 ff ff ff       	jmp    800711 <vprintfmt+0x3a8>
			putch(ch, putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	6a 25                	push   $0x25
  8007a5:	ff d6                	call   *%esi
			break;
  8007a7:	83 c4 10             	add    $0x10,%esp
  8007aa:	e9 7c ff ff ff       	jmp    80072b <vprintfmt+0x3c2>
			putch('%', putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	53                   	push   %ebx
  8007b3:	6a 25                	push   $0x25
  8007b5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	89 f8                	mov    %edi,%eax
  8007bc:	eb 01                	jmp    8007bf <vprintfmt+0x456>
  8007be:	48                   	dec    %eax
  8007bf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c3:	75 f9                	jne    8007be <vprintfmt+0x455>
  8007c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007c8:	e9 5e ff ff ff       	jmp    80072b <vprintfmt+0x3c2>
}
  8007cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d0:	5b                   	pop    %ebx
  8007d1:	5e                   	pop    %esi
  8007d2:	5f                   	pop    %edi
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	83 ec 18             	sub    $0x18,%esp
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	74 26                	je     80081c <vsnprintf+0x47>
  8007f6:	85 d2                	test   %edx,%edx
  8007f8:	7e 29                	jle    800823 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007fa:	ff 75 14             	pushl  0x14(%ebp)
  8007fd:	ff 75 10             	pushl  0x10(%ebp)
  800800:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800803:	50                   	push   %eax
  800804:	68 30 03 80 00       	push   $0x800330
  800809:	e8 5b fb ff ff       	call   800369 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80080e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800811:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800817:	83 c4 10             	add    $0x10,%esp
}
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    
		return -E_INVAL;
  80081c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800821:	eb f7                	jmp    80081a <vsnprintf+0x45>
  800823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800828:	eb f0                	jmp    80081a <vsnprintf+0x45>

0080082a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800830:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800833:	50                   	push   %eax
  800834:	ff 75 10             	pushl  0x10(%ebp)
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	ff 75 08             	pushl  0x8(%ebp)
  80083d:	e8 93 ff ff ff       	call   8007d5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800842:	c9                   	leave  
  800843:	c3                   	ret    

00800844 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80084a:	b8 00 00 00 00       	mov    $0x0,%eax
  80084f:	eb 01                	jmp    800852 <strlen+0xe>
		n++;
  800851:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800852:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800856:	75 f9                	jne    800851 <strlen+0xd>
	return n;
}
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	eb 01                	jmp    80086b <strnlen+0x11>
		n++;
  80086a:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086b:	39 d0                	cmp    %edx,%eax
  80086d:	74 06                	je     800875 <strnlen+0x1b>
  80086f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800873:	75 f5                	jne    80086a <strnlen+0x10>
	return n;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800881:	89 c2                	mov    %eax,%edx
  800883:	42                   	inc    %edx
  800884:	41                   	inc    %ecx
  800885:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800888:	88 5a ff             	mov    %bl,-0x1(%edx)
  80088b:	84 db                	test   %bl,%bl
  80088d:	75 f4                	jne    800883 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80088f:	5b                   	pop    %ebx
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	53                   	push   %ebx
  800896:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800899:	53                   	push   %ebx
  80089a:	e8 a5 ff ff ff       	call   800844 <strlen>
  80089f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	01 d8                	add    %ebx,%eax
  8008a7:	50                   	push   %eax
  8008a8:	e8 ca ff ff ff       	call   800877 <strcpy>
	return dst;
}
  8008ad:	89 d8                	mov    %ebx,%eax
  8008af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b2:	c9                   	leave  
  8008b3:	c3                   	ret    

008008b4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	56                   	push   %esi
  8008b8:	53                   	push   %ebx
  8008b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bf:	89 f3                	mov    %esi,%ebx
  8008c1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c4:	89 f2                	mov    %esi,%edx
  8008c6:	eb 0c                	jmp    8008d4 <strncpy+0x20>
		*dst++ = *src;
  8008c8:	42                   	inc    %edx
  8008c9:	8a 01                	mov    (%ecx),%al
  8008cb:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ce:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008d4:	39 da                	cmp    %ebx,%edx
  8008d6:	75 f0                	jne    8008c8 <strncpy+0x14>
	}
	return ret;
}
  8008d8:	89 f0                	mov    %esi,%eax
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	56                   	push   %esi
  8008e2:	53                   	push   %ebx
  8008e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e9:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ec:	85 c0                	test   %eax,%eax
  8008ee:	74 20                	je     800910 <strlcpy+0x32>
  8008f0:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8008f4:	89 f0                	mov    %esi,%eax
  8008f6:	eb 05                	jmp    8008fd <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f8:	40                   	inc    %eax
  8008f9:	42                   	inc    %edx
  8008fa:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008fd:	39 d8                	cmp    %ebx,%eax
  8008ff:	74 06                	je     800907 <strlcpy+0x29>
  800901:	8a 0a                	mov    (%edx),%cl
  800903:	84 c9                	test   %cl,%cl
  800905:	75 f1                	jne    8008f8 <strlcpy+0x1a>
		*dst = '\0';
  800907:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80090a:	29 f0                	sub    %esi,%eax
}
  80090c:	5b                   	pop    %ebx
  80090d:	5e                   	pop    %esi
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    
  800910:	89 f0                	mov    %esi,%eax
  800912:	eb f6                	jmp    80090a <strlcpy+0x2c>

00800914 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80091d:	eb 02                	jmp    800921 <strcmp+0xd>
		p++, q++;
  80091f:	41                   	inc    %ecx
  800920:	42                   	inc    %edx
	while (*p && *p == *q)
  800921:	8a 01                	mov    (%ecx),%al
  800923:	84 c0                	test   %al,%al
  800925:	74 04                	je     80092b <strcmp+0x17>
  800927:	3a 02                	cmp    (%edx),%al
  800929:	74 f4                	je     80091f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80092b:	0f b6 c0             	movzbl %al,%eax
  80092e:	0f b6 12             	movzbl (%edx),%edx
  800931:	29 d0                	sub    %edx,%eax
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	53                   	push   %ebx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093f:	89 c3                	mov    %eax,%ebx
  800941:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800944:	eb 02                	jmp    800948 <strncmp+0x13>
		n--, p++, q++;
  800946:	40                   	inc    %eax
  800947:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800948:	39 d8                	cmp    %ebx,%eax
  80094a:	74 15                	je     800961 <strncmp+0x2c>
  80094c:	8a 08                	mov    (%eax),%cl
  80094e:	84 c9                	test   %cl,%cl
  800950:	74 04                	je     800956 <strncmp+0x21>
  800952:	3a 0a                	cmp    (%edx),%cl
  800954:	74 f0                	je     800946 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800956:	0f b6 00             	movzbl (%eax),%eax
  800959:	0f b6 12             	movzbl (%edx),%edx
  80095c:	29 d0                	sub    %edx,%eax
}
  80095e:	5b                   	pop    %ebx
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    
		return 0;
  800961:	b8 00 00 00 00       	mov    $0x0,%eax
  800966:	eb f6                	jmp    80095e <strncmp+0x29>

00800968 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800971:	8a 10                	mov    (%eax),%dl
  800973:	84 d2                	test   %dl,%dl
  800975:	74 07                	je     80097e <strchr+0x16>
		if (*s == c)
  800977:	38 ca                	cmp    %cl,%dl
  800979:	74 08                	je     800983 <strchr+0x1b>
	for (; *s; s++)
  80097b:	40                   	inc    %eax
  80097c:	eb f3                	jmp    800971 <strchr+0x9>
			return (char *) s;
	return 0;
  80097e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80098e:	8a 10                	mov    (%eax),%dl
  800990:	84 d2                	test   %dl,%dl
  800992:	74 07                	je     80099b <strfind+0x16>
		if (*s == c)
  800994:	38 ca                	cmp    %cl,%dl
  800996:	74 03                	je     80099b <strfind+0x16>
	for (; *s; s++)
  800998:	40                   	inc    %eax
  800999:	eb f3                	jmp    80098e <strfind+0x9>
			break;
	return (char *) s;
}
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	57                   	push   %edi
  8009a1:	56                   	push   %esi
  8009a2:	53                   	push   %ebx
  8009a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a9:	85 c9                	test   %ecx,%ecx
  8009ab:	74 13                	je     8009c0 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ad:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009b3:	75 05                	jne    8009ba <memset+0x1d>
  8009b5:	f6 c1 03             	test   $0x3,%cl
  8009b8:	74 0d                	je     8009c7 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bd:	fc                   	cld    
  8009be:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009c0:	89 f8                	mov    %edi,%eax
  8009c2:	5b                   	pop    %ebx
  8009c3:	5e                   	pop    %esi
  8009c4:	5f                   	pop    %edi
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    
		c &= 0xFF;
  8009c7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009cb:	89 d3                	mov    %edx,%ebx
  8009cd:	c1 e3 08             	shl    $0x8,%ebx
  8009d0:	89 d0                	mov    %edx,%eax
  8009d2:	c1 e0 18             	shl    $0x18,%eax
  8009d5:	89 d6                	mov    %edx,%esi
  8009d7:	c1 e6 10             	shl    $0x10,%esi
  8009da:	09 f0                	or     %esi,%eax
  8009dc:	09 c2                	or     %eax,%edx
  8009de:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009e0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e3:	89 d0                	mov    %edx,%eax
  8009e5:	fc                   	cld    
  8009e6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e8:	eb d6                	jmp    8009c0 <memset+0x23>

008009ea <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	57                   	push   %edi
  8009ee:	56                   	push   %esi
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f8:	39 c6                	cmp    %eax,%esi
  8009fa:	73 33                	jae    800a2f <memmove+0x45>
  8009fc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ff:	39 d0                	cmp    %edx,%eax
  800a01:	73 2c                	jae    800a2f <memmove+0x45>
		s += n;
		d += n;
  800a03:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a06:	89 d6                	mov    %edx,%esi
  800a08:	09 fe                	or     %edi,%esi
  800a0a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a10:	75 13                	jne    800a25 <memmove+0x3b>
  800a12:	f6 c1 03             	test   $0x3,%cl
  800a15:	75 0e                	jne    800a25 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a17:	83 ef 04             	sub    $0x4,%edi
  800a1a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a1d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a20:	fd                   	std    
  800a21:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a23:	eb 07                	jmp    800a2c <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a25:	4f                   	dec    %edi
  800a26:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a29:	fd                   	std    
  800a2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a2c:	fc                   	cld    
  800a2d:	eb 13                	jmp    800a42 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2f:	89 f2                	mov    %esi,%edx
  800a31:	09 c2                	or     %eax,%edx
  800a33:	f6 c2 03             	test   $0x3,%dl
  800a36:	75 05                	jne    800a3d <memmove+0x53>
  800a38:	f6 c1 03             	test   $0x3,%cl
  800a3b:	74 09                	je     800a46 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a3d:	89 c7                	mov    %eax,%edi
  800a3f:	fc                   	cld    
  800a40:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a42:	5e                   	pop    %esi
  800a43:	5f                   	pop    %edi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a46:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a49:	89 c7                	mov    %eax,%edi
  800a4b:	fc                   	cld    
  800a4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4e:	eb f2                	jmp    800a42 <memmove+0x58>

00800a50 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a53:	ff 75 10             	pushl  0x10(%ebp)
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	ff 75 08             	pushl  0x8(%ebp)
  800a5c:	e8 89 ff ff ff       	call   8009ea <memmove>
}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	56                   	push   %esi
  800a67:	53                   	push   %ebx
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	89 c6                	mov    %eax,%esi
  800a6d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800a70:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a73:	39 f0                	cmp    %esi,%eax
  800a75:	74 16                	je     800a8d <memcmp+0x2a>
		if (*s1 != *s2)
  800a77:	8a 08                	mov    (%eax),%cl
  800a79:	8a 1a                	mov    (%edx),%bl
  800a7b:	38 d9                	cmp    %bl,%cl
  800a7d:	75 04                	jne    800a83 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a7f:	40                   	inc    %eax
  800a80:	42                   	inc    %edx
  800a81:	eb f0                	jmp    800a73 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a83:	0f b6 c1             	movzbl %cl,%eax
  800a86:	0f b6 db             	movzbl %bl,%ebx
  800a89:	29 d8                	sub    %ebx,%eax
  800a8b:	eb 05                	jmp    800a92 <memcmp+0x2f>
	}

	return 0;
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a9f:	89 c2                	mov    %eax,%edx
  800aa1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa4:	39 d0                	cmp    %edx,%eax
  800aa6:	73 07                	jae    800aaf <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa8:	38 08                	cmp    %cl,(%eax)
  800aaa:	74 03                	je     800aaf <memfind+0x19>
	for (; s < ends; s++)
  800aac:	40                   	inc    %eax
  800aad:	eb f5                	jmp    800aa4 <memfind+0xe>
			break;
	return (void *) s;
}
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	57                   	push   %edi
  800ab5:	56                   	push   %esi
  800ab6:	53                   	push   %ebx
  800ab7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aba:	eb 01                	jmp    800abd <strtol+0xc>
		s++;
  800abc:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800abd:	8a 01                	mov    (%ecx),%al
  800abf:	3c 20                	cmp    $0x20,%al
  800ac1:	74 f9                	je     800abc <strtol+0xb>
  800ac3:	3c 09                	cmp    $0x9,%al
  800ac5:	74 f5                	je     800abc <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800ac7:	3c 2b                	cmp    $0x2b,%al
  800ac9:	74 2b                	je     800af6 <strtol+0x45>
		s++;
	else if (*s == '-')
  800acb:	3c 2d                	cmp    $0x2d,%al
  800acd:	74 2f                	je     800afe <strtol+0x4d>
	int neg = 0;
  800acf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad4:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800adb:	75 12                	jne    800aef <strtol+0x3e>
  800add:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae0:	74 24                	je     800b06 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ae6:	75 07                	jne    800aef <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
  800af4:	eb 4e                	jmp    800b44 <strtol+0x93>
		s++;
  800af6:	41                   	inc    %ecx
	int neg = 0;
  800af7:	bf 00 00 00 00       	mov    $0x0,%edi
  800afc:	eb d6                	jmp    800ad4 <strtol+0x23>
		s++, neg = 1;
  800afe:	41                   	inc    %ecx
  800aff:	bf 01 00 00 00       	mov    $0x1,%edi
  800b04:	eb ce                	jmp    800ad4 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b06:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b0a:	74 10                	je     800b1c <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800b0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b10:	75 dd                	jne    800aef <strtol+0x3e>
		s++, base = 8;
  800b12:	41                   	inc    %ecx
  800b13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800b1a:	eb d3                	jmp    800aef <strtol+0x3e>
		s += 2, base = 16;
  800b1c:	83 c1 02             	add    $0x2,%ecx
  800b1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800b26:	eb c7                	jmp    800aef <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b28:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b2b:	89 f3                	mov    %esi,%ebx
  800b2d:	80 fb 19             	cmp    $0x19,%bl
  800b30:	77 24                	ja     800b56 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800b32:	0f be d2             	movsbl %dl,%edx
  800b35:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b38:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b3b:	7d 2b                	jge    800b68 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800b3d:	41                   	inc    %ecx
  800b3e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b42:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b44:	8a 11                	mov    (%ecx),%dl
  800b46:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b49:	80 fb 09             	cmp    $0x9,%bl
  800b4c:	77 da                	ja     800b28 <strtol+0x77>
			dig = *s - '0';
  800b4e:	0f be d2             	movsbl %dl,%edx
  800b51:	83 ea 30             	sub    $0x30,%edx
  800b54:	eb e2                	jmp    800b38 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b56:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b59:	89 f3                	mov    %esi,%ebx
  800b5b:	80 fb 19             	cmp    $0x19,%bl
  800b5e:	77 08                	ja     800b68 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b60:	0f be d2             	movsbl %dl,%edx
  800b63:	83 ea 37             	sub    $0x37,%edx
  800b66:	eb d0                	jmp    800b38 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6c:	74 05                	je     800b73 <strtol+0xc2>
		*endptr = (char *) s;
  800b6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b71:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b73:	85 ff                	test   %edi,%edi
  800b75:	74 02                	je     800b79 <strtol+0xc8>
  800b77:	f7 d8                	neg    %eax
}
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5f                   	pop    %edi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <atoi>:

int
atoi(const char *s)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b81:	6a 0a                	push   $0xa
  800b83:	6a 00                	push   $0x0
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 24 ff ff ff       	call   800ab1 <strtol>
}
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba0:	89 c3                	mov    %eax,%ebx
  800ba2:	89 c7                	mov    %eax,%edi
  800ba4:	89 c6                	mov    %eax,%esi
  800ba6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <sys_cgetc>:

int
sys_cgetc(void)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbd:	89 d1                	mov    %edx,%ecx
  800bbf:	89 d3                	mov    %edx,%ebx
  800bc1:	89 d7                	mov    %edx,%edi
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bda:	b8 03 00 00 00       	mov    $0x3,%eax
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	89 cb                	mov    %ecx,%ebx
  800be4:	89 cf                	mov    %ecx,%edi
  800be6:	89 ce                	mov    %ecx,%esi
  800be8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bea:	85 c0                	test   %eax,%eax
  800bec:	7f 08                	jg     800bf6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf6:	83 ec 0c             	sub    $0xc,%esp
  800bf9:	50                   	push   %eax
  800bfa:	6a 03                	push   $0x3
  800bfc:	68 ff 25 80 00       	push   $0x8025ff
  800c01:	6a 23                	push   $0x23
  800c03:	68 1c 26 80 00       	push   $0x80261c
  800c08:	e8 4f f5 ff ff       	call   80015c <_panic>

00800c0d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	57                   	push   %edi
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c13:	ba 00 00 00 00       	mov    $0x0,%edx
  800c18:	b8 02 00 00 00       	mov    $0x2,%eax
  800c1d:	89 d1                	mov    %edx,%ecx
  800c1f:	89 d3                	mov    %edx,%ebx
  800c21:	89 d7                	mov    %edx,%edi
  800c23:	89 d6                	mov    %edx,%esi
  800c25:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c35:	be 00 00 00 00       	mov    $0x0,%esi
  800c3a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c48:	89 f7                	mov    %esi,%edi
  800c4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4c:	85 c0                	test   %eax,%eax
  800c4e:	7f 08                	jg     800c58 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c58:	83 ec 0c             	sub    $0xc,%esp
  800c5b:	50                   	push   %eax
  800c5c:	6a 04                	push   $0x4
  800c5e:	68 ff 25 80 00       	push   $0x8025ff
  800c63:	6a 23                	push   $0x23
  800c65:	68 1c 26 80 00       	push   $0x80261c
  800c6a:	e8 ed f4 ff ff       	call   80015c <_panic>

00800c6f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
  800c75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c78:	b8 05 00 00 00       	mov    $0x5,%eax
  800c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c86:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c89:	8b 75 18             	mov    0x18(%ebp),%esi
  800c8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	7f 08                	jg     800c9a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9a:	83 ec 0c             	sub    $0xc,%esp
  800c9d:	50                   	push   %eax
  800c9e:	6a 05                	push   $0x5
  800ca0:	68 ff 25 80 00       	push   $0x8025ff
  800ca5:	6a 23                	push   $0x23
  800ca7:	68 1c 26 80 00       	push   $0x80261c
  800cac:	e8 ab f4 ff ff       	call   80015c <_panic>

00800cb1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cca:	89 df                	mov    %ebx,%edi
  800ccc:	89 de                	mov    %ebx,%esi
  800cce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	7f 08                	jg     800cdc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5f                   	pop    %edi
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdc:	83 ec 0c             	sub    $0xc,%esp
  800cdf:	50                   	push   %eax
  800ce0:	6a 06                	push   $0x6
  800ce2:	68 ff 25 80 00       	push   $0x8025ff
  800ce7:	6a 23                	push   $0x23
  800ce9:	68 1c 26 80 00       	push   $0x80261c
  800cee:	e8 69 f4 ff ff       	call   80015c <_panic>

00800cf3 <sys_yield>:

void
sys_yield(void)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfe:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d03:	89 d1                	mov    %edx,%ecx
  800d05:	89 d3                	mov    %edx,%ebx
  800d07:	89 d7                	mov    %edx,%edi
  800d09:	89 d6                	mov    %edx,%esi
  800d0b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d20:	b8 08 00 00 00       	mov    $0x8,%eax
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2b:	89 df                	mov    %ebx,%edi
  800d2d:	89 de                	mov    %ebx,%esi
  800d2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d31:	85 c0                	test   %eax,%eax
  800d33:	7f 08                	jg     800d3d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3d:	83 ec 0c             	sub    $0xc,%esp
  800d40:	50                   	push   %eax
  800d41:	6a 08                	push   $0x8
  800d43:	68 ff 25 80 00       	push   $0x8025ff
  800d48:	6a 23                	push   $0x23
  800d4a:	68 1c 26 80 00       	push   $0x80261c
  800d4f:	e8 08 f4 ff ff       	call   80015c <_panic>

00800d54 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d62:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	89 cb                	mov    %ecx,%ebx
  800d6c:	89 cf                	mov    %ecx,%edi
  800d6e:	89 ce                	mov    %ecx,%esi
  800d70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7f 08                	jg     800d7e <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	50                   	push   %eax
  800d82:	6a 0c                	push   $0xc
  800d84:	68 ff 25 80 00       	push   $0x8025ff
  800d89:	6a 23                	push   $0x23
  800d8b:	68 1c 26 80 00       	push   $0x80261c
  800d90:	e8 c7 f3 ff ff       	call   80015c <_panic>

00800d95 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da3:	b8 09 00 00 00       	mov    $0x9,%eax
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	89 df                	mov    %ebx,%edi
  800db0:	89 de                	mov    %ebx,%esi
  800db2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db4:	85 c0                	test   %eax,%eax
  800db6:	7f 08                	jg     800dc0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc0:	83 ec 0c             	sub    $0xc,%esp
  800dc3:	50                   	push   %eax
  800dc4:	6a 09                	push   $0x9
  800dc6:	68 ff 25 80 00       	push   $0x8025ff
  800dcb:	6a 23                	push   $0x23
  800dcd:	68 1c 26 80 00       	push   $0x80261c
  800dd2:	e8 85 f3 ff ff       	call   80015c <_panic>

00800dd7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	89 df                	mov    %ebx,%edi
  800df2:	89 de                	mov    %ebx,%esi
  800df4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	7f 08                	jg     800e02 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	50                   	push   %eax
  800e06:	6a 0a                	push   $0xa
  800e08:	68 ff 25 80 00       	push   $0x8025ff
  800e0d:	6a 23                	push   $0x23
  800e0f:	68 1c 26 80 00       	push   $0x80261c
  800e14:	e8 43 f3 ff ff       	call   80015c <_panic>

00800e19 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1f:	be 00 00 00 00       	mov    $0x0,%esi
  800e24:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e32:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e35:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
  800e42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e45:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	89 cb                	mov    %ecx,%ebx
  800e54:	89 cf                	mov    %ecx,%edi
  800e56:	89 ce                	mov    %ecx,%esi
  800e58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7f 08                	jg     800e66 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	83 ec 0c             	sub    $0xc,%esp
  800e69:	50                   	push   %eax
  800e6a:	6a 0e                	push   $0xe
  800e6c:	68 ff 25 80 00       	push   $0x8025ff
  800e71:	6a 23                	push   $0x23
  800e73:	68 1c 26 80 00       	push   $0x80261c
  800e78:	e8 df f2 ff ff       	call   80015c <_panic>

00800e7d <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e83:	be 00 00 00 00       	mov    $0x0,%esi
  800e88:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e96:	89 f7                	mov    %esi,%edi
  800e98:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea5:	be 00 00 00 00       	mov    $0x0,%esi
  800eaa:	b8 10 00 00 00       	mov    $0x10,%eax
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb8:	89 f7                	mov    %esi,%edi
  800eba:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    

00800ec1 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	57                   	push   %edi
  800ec5:	56                   	push   %esi
  800ec6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ecc:	b8 11 00 00 00       	mov    $0x11,%eax
  800ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed4:	89 cb                	mov    %ecx,%ebx
  800ed6:	89 cf                	mov    %ecx,%edi
  800ed8:	89 ce                	mov    %ecx,%esi
  800eda:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800edc:	5b                   	pop    %ebx
  800edd:	5e                   	pop    %esi
  800ede:	5f                   	pop    %edi
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    

00800ee1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ee9:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800eeb:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800eef:	0f 84 84 00 00 00    	je     800f79 <pgfault+0x98>
  800ef5:	89 d8                	mov    %ebx,%eax
  800ef7:	c1 e8 16             	shr    $0x16,%eax
  800efa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f01:	a8 01                	test   $0x1,%al
  800f03:	74 74                	je     800f79 <pgfault+0x98>
  800f05:	89 d8                	mov    %ebx,%eax
  800f07:	c1 e8 0c             	shr    $0xc,%eax
  800f0a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f11:	f6 c4 08             	test   $0x8,%ah
  800f14:	74 63                	je     800f79 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800f16:	e8 f2 fc ff ff       	call   800c0d <sys_getenvid>
  800f1b:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800f1d:	83 ec 04             	sub    $0x4,%esp
  800f20:	6a 07                	push   $0x7
  800f22:	68 00 f0 7f 00       	push   $0x7ff000
  800f27:	50                   	push   %eax
  800f28:	e8 ff fc ff ff       	call   800c2c <sys_page_alloc>
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	85 c0                	test   %eax,%eax
  800f32:	78 5b                	js     800f8f <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  800f34:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	68 00 10 00 00       	push   $0x1000
  800f42:	53                   	push   %ebx
  800f43:	68 00 f0 7f 00       	push   $0x7ff000
  800f48:	e8 03 fb ff ff       	call   800a50 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  800f4d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f54:	53                   	push   %ebx
  800f55:	56                   	push   %esi
  800f56:	68 00 f0 7f 00       	push   $0x7ff000
  800f5b:	56                   	push   %esi
  800f5c:	e8 0e fd ff ff       	call   800c6f <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  800f61:	83 c4 18             	add    $0x18,%esp
  800f64:	68 00 f0 7f 00       	push   $0x7ff000
  800f69:	56                   	push   %esi
  800f6a:	e8 42 fd ff ff       	call   800cb1 <sys_page_unmap>

}
  800f6f:	83 c4 10             	add    $0x10,%esp
  800f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800f79:	68 2c 26 80 00       	push   $0x80262c
  800f7e:	68 b6 26 80 00       	push   $0x8026b6
  800f83:	6a 1c                	push   $0x1c
  800f85:	68 cb 26 80 00       	push   $0x8026cb
  800f8a:	e8 cd f1 ff ff       	call   80015c <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800f8f:	68 7c 26 80 00       	push   $0x80267c
  800f94:	68 b6 26 80 00       	push   $0x8026b6
  800f99:	6a 26                	push   $0x26
  800f9b:	68 cb 26 80 00       	push   $0x8026cb
  800fa0:	e8 b7 f1 ff ff       	call   80015c <_panic>

00800fa5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
  800fab:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800fae:	68 e1 0e 80 00       	push   $0x800ee1
  800fb3:	e8 e0 0f 00 00       	call   801f98 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fb8:	b8 07 00 00 00       	mov    $0x7,%eax
  800fbd:	cd 30                	int    $0x30
  800fbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	0f 88 58 01 00 00    	js     801128 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	74 07                	je     800fdb <fork+0x36>
  800fd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd9:	eb 72                	jmp    80104d <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fdb:	e8 2d fc ff ff       	call   800c0d <sys_getenvid>
  800fe0:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fe5:	89 c2                	mov    %eax,%edx
  800fe7:	c1 e2 05             	shl    $0x5,%edx
  800fea:	29 c2                	sub    %eax,%edx
  800fec:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800ff3:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800ff8:	e9 20 01 00 00       	jmp    80111d <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  800ffd:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  801004:	e8 04 fc ff ff       	call   800c0d <sys_getenvid>
  801009:	83 ec 0c             	sub    $0xc,%esp
  80100c:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	ff 75 e4             	pushl  -0x1c(%ebp)
  801017:	56                   	push   %esi
  801018:	50                   	push   %eax
  801019:	e8 51 fc ff ff       	call   800c6f <sys_page_map>
  80101e:	83 c4 20             	add    $0x20,%esp
  801021:	eb 18                	jmp    80103b <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  801023:	e8 e5 fb ff ff       	call   800c0d <sys_getenvid>
  801028:	83 ec 0c             	sub    $0xc,%esp
  80102b:	6a 05                	push   $0x5
  80102d:	56                   	push   %esi
  80102e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801031:	56                   	push   %esi
  801032:	50                   	push   %eax
  801033:	e8 37 fc ff ff       	call   800c6f <sys_page_map>
  801038:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  80103b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801041:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801047:	0f 84 8f 00 00 00    	je     8010dc <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  80104d:	89 d8                	mov    %ebx,%eax
  80104f:	c1 e8 16             	shr    $0x16,%eax
  801052:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801059:	a8 01                	test   $0x1,%al
  80105b:	74 de                	je     80103b <fork+0x96>
  80105d:	89 d8                	mov    %ebx,%eax
  80105f:	c1 e8 0c             	shr    $0xc,%eax
  801062:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801069:	a8 04                	test   $0x4,%al
  80106b:	74 ce                	je     80103b <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  80106d:	89 de                	mov    %ebx,%esi
  80106f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  801075:	89 f0                	mov    %esi,%eax
  801077:	c1 e8 0c             	shr    $0xc,%eax
  80107a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801081:	f6 c6 04             	test   $0x4,%dh
  801084:	0f 85 73 ff ff ff    	jne    800ffd <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  80108a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801091:	a9 02 08 00 00       	test   $0x802,%eax
  801096:	74 8b                	je     801023 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801098:	e8 70 fb ff ff       	call   800c0d <sys_getenvid>
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	68 05 08 00 00       	push   $0x805
  8010a5:	56                   	push   %esi
  8010a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a9:	56                   	push   %esi
  8010aa:	50                   	push   %eax
  8010ab:	e8 bf fb ff ff       	call   800c6f <sys_page_map>
  8010b0:	83 c4 20             	add    $0x20,%esp
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	78 84                	js     80103b <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  8010b7:	e8 51 fb ff ff       	call   800c0d <sys_getenvid>
  8010bc:	89 c7                	mov    %eax,%edi
  8010be:	e8 4a fb ff ff       	call   800c0d <sys_getenvid>
  8010c3:	83 ec 0c             	sub    $0xc,%esp
  8010c6:	68 05 08 00 00       	push   $0x805
  8010cb:	56                   	push   %esi
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	50                   	push   %eax
  8010cf:	e8 9b fb ff ff       	call   800c6f <sys_page_map>
  8010d4:	83 c4 20             	add    $0x20,%esp
  8010d7:	e9 5f ff ff ff       	jmp    80103b <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  8010dc:	83 ec 04             	sub    $0x4,%esp
  8010df:	6a 07                	push   $0x7
  8010e1:	68 00 f0 bf ee       	push   $0xeebff000
  8010e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8010e9:	57                   	push   %edi
  8010ea:	e8 3d fb ff ff       	call   800c2c <sys_page_alloc>
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	78 3b                	js     801131 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	68 de 1f 80 00       	push   $0x801fde
  8010fe:	57                   	push   %edi
  8010ff:	e8 d3 fc ff ff       	call   800dd7 <sys_env_set_pgfault_upcall>
  801104:	83 c4 10             	add    $0x10,%esp
  801107:	85 c0                	test   %eax,%eax
  801109:	78 2f                	js     80113a <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	6a 02                	push   $0x2
  801110:	57                   	push   %edi
  801111:	e8 fc fb ff ff       	call   800d12 <sys_env_set_status>
	if (temp < 0) {
  801116:	83 c4 10             	add    $0x10,%esp
  801119:	85 c0                	test   %eax,%eax
  80111b:	78 26                	js     801143 <fork+0x19e>
		return -1;
	}

	return childid;
}
  80111d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    
		return -1;
  801128:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80112f:	eb ec                	jmp    80111d <fork+0x178>
		return -1;
  801131:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801138:	eb e3                	jmp    80111d <fork+0x178>
		return -1;
  80113a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801141:	eb da                	jmp    80111d <fork+0x178>
		return -1;
  801143:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80114a:	eb d1                	jmp    80111d <fork+0x178>

0080114c <sfork>:

// Challenge!
int
sfork(void)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801152:	68 d6 26 80 00       	push   $0x8026d6
  801157:	68 85 00 00 00       	push   $0x85
  80115c:	68 cb 26 80 00       	push   $0x8026cb
  801161:	e8 f6 ef ff ff       	call   80015c <_panic>

00801166 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801172:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801175:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801178:	85 ff                	test   %edi,%edi
  80117a:	74 53                	je     8011cf <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  80117c:	83 ec 0c             	sub    $0xc,%esp
  80117f:	57                   	push   %edi
  801180:	e8 b7 fc ff ff       	call   800e3c <sys_ipc_recv>
  801185:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801188:	85 db                	test   %ebx,%ebx
  80118a:	74 0b                	je     801197 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80118c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801192:	8b 52 74             	mov    0x74(%edx),%edx
  801195:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801197:	85 f6                	test   %esi,%esi
  801199:	74 0f                	je     8011aa <ipc_recv+0x44>
  80119b:	85 ff                	test   %edi,%edi
  80119d:	74 0b                	je     8011aa <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80119f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011a5:	8b 52 78             	mov    0x78(%edx),%edx
  8011a8:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	74 30                	je     8011de <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  8011ae:	85 db                	test   %ebx,%ebx
  8011b0:	74 06                	je     8011b8 <ipc_recv+0x52>
      		*from_env_store = 0;
  8011b2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  8011b8:	85 f6                	test   %esi,%esi
  8011ba:	74 2c                	je     8011e8 <ipc_recv+0x82>
      		*perm_store = 0;
  8011bc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  8011c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  8011c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ca:	5b                   	pop    %ebx
  8011cb:	5e                   	pop    %esi
  8011cc:	5f                   	pop    %edi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8011cf:	83 ec 0c             	sub    $0xc,%esp
  8011d2:	6a ff                	push   $0xffffffff
  8011d4:	e8 63 fc ff ff       	call   800e3c <sys_ipc_recv>
  8011d9:	83 c4 10             	add    $0x10,%esp
  8011dc:	eb aa                	jmp    801188 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  8011de:	a1 04 40 80 00       	mov    0x804004,%eax
  8011e3:	8b 40 70             	mov    0x70(%eax),%eax
  8011e6:	eb df                	jmp    8011c7 <ipc_recv+0x61>
		return -1;
  8011e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8011ed:	eb d8                	jmp    8011c7 <ipc_recv+0x61>

008011ef <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	57                   	push   %edi
  8011f3:	56                   	push   %esi
  8011f4:	53                   	push   %ebx
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011fe:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801201:	85 db                	test   %ebx,%ebx
  801203:	75 22                	jne    801227 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801205:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  80120a:	eb 1b                	jmp    801227 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  80120c:	68 ec 26 80 00       	push   $0x8026ec
  801211:	68 b6 26 80 00       	push   $0x8026b6
  801216:	6a 48                	push   $0x48
  801218:	68 0f 27 80 00       	push   $0x80270f
  80121d:	e8 3a ef ff ff       	call   80015c <_panic>
		sys_yield();
  801222:	e8 cc fa ff ff       	call   800cf3 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801227:	57                   	push   %edi
  801228:	53                   	push   %ebx
  801229:	56                   	push   %esi
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 e7 fb ff ff       	call   800e19 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801238:	74 e8                	je     801222 <ipc_send+0x33>
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 ce                	jne    80120c <ipc_send+0x1d>
		sys_yield();
  80123e:	e8 b0 fa ff ff       	call   800cf3 <sys_yield>
		
	}
	
}
  801243:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801246:	5b                   	pop    %ebx
  801247:	5e                   	pop    %esi
  801248:	5f                   	pop    %edi
  801249:	5d                   	pop    %ebp
  80124a:	c3                   	ret    

0080124b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801256:	89 c2                	mov    %eax,%edx
  801258:	c1 e2 05             	shl    $0x5,%edx
  80125b:	29 c2                	sub    %eax,%edx
  80125d:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801264:	8b 52 50             	mov    0x50(%edx),%edx
  801267:	39 ca                	cmp    %ecx,%edx
  801269:	74 0f                	je     80127a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80126b:	40                   	inc    %eax
  80126c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801271:	75 e3                	jne    801256 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801273:	b8 00 00 00 00       	mov    $0x0,%eax
  801278:	eb 11                	jmp    80128b <ipc_find_env+0x40>
			return envs[i].env_id;
  80127a:	89 c2                	mov    %eax,%edx
  80127c:	c1 e2 05             	shl    $0x5,%edx
  80127f:	29 c2                	sub    %eax,%edx
  801281:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801288:	8b 40 48             	mov    0x48(%eax),%eax
}
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	05 00 00 00 30       	add    $0x30000000,%eax
  801298:	c1 e8 0c             	shr    $0xc,%eax
}
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    

0080129d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ad:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012b2:	5d                   	pop    %ebp
  8012b3:	c3                   	ret    

008012b4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ba:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	c1 ea 16             	shr    $0x16,%edx
  8012c4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012cb:	f6 c2 01             	test   $0x1,%dl
  8012ce:	74 2a                	je     8012fa <fd_alloc+0x46>
  8012d0:	89 c2                	mov    %eax,%edx
  8012d2:	c1 ea 0c             	shr    $0xc,%edx
  8012d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012dc:	f6 c2 01             	test   $0x1,%dl
  8012df:	74 19                	je     8012fa <fd_alloc+0x46>
  8012e1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012e6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012eb:	75 d2                	jne    8012bf <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012ed:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012f3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012f8:	eb 07                	jmp    801301 <fd_alloc+0x4d>
			*fd_store = fd;
  8012fa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801301:	5d                   	pop    %ebp
  801302:	c3                   	ret    

00801303 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801306:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  80130a:	77 39                	ja     801345 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	c1 e0 0c             	shl    $0xc,%eax
  801312:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801317:	89 c2                	mov    %eax,%edx
  801319:	c1 ea 16             	shr    $0x16,%edx
  80131c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801323:	f6 c2 01             	test   $0x1,%dl
  801326:	74 24                	je     80134c <fd_lookup+0x49>
  801328:	89 c2                	mov    %eax,%edx
  80132a:	c1 ea 0c             	shr    $0xc,%edx
  80132d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801334:	f6 c2 01             	test   $0x1,%dl
  801337:	74 1a                	je     801353 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133c:	89 02                	mov    %eax,(%edx)
	return 0;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    
		return -E_INVAL;
  801345:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134a:	eb f7                	jmp    801343 <fd_lookup+0x40>
		return -E_INVAL;
  80134c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801351:	eb f0                	jmp    801343 <fd_lookup+0x40>
  801353:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801358:	eb e9                	jmp    801343 <fd_lookup+0x40>

0080135a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 08             	sub    $0x8,%esp
  801360:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801363:	ba 9c 27 80 00       	mov    $0x80279c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801368:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80136d:	39 08                	cmp    %ecx,(%eax)
  80136f:	74 33                	je     8013a4 <dev_lookup+0x4a>
  801371:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801374:	8b 02                	mov    (%edx),%eax
  801376:	85 c0                	test   %eax,%eax
  801378:	75 f3                	jne    80136d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80137a:	a1 04 40 80 00       	mov    0x804004,%eax
  80137f:	8b 40 48             	mov    0x48(%eax),%eax
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	51                   	push   %ecx
  801386:	50                   	push   %eax
  801387:	68 1c 27 80 00       	push   $0x80271c
  80138c:	e8 de ee ff ff       	call   80026f <cprintf>
	*dev = 0;
  801391:	8b 45 0c             	mov    0xc(%ebp),%eax
  801394:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    
			*dev = devtab[i];
  8013a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ae:	eb f2                	jmp    8013a2 <dev_lookup+0x48>

008013b0 <fd_close>:
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	57                   	push   %edi
  8013b4:	56                   	push   %esi
  8013b5:	53                   	push   %ebx
  8013b6:	83 ec 1c             	sub    $0x1c,%esp
  8013b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8013bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013c2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013c9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013cc:	50                   	push   %eax
  8013cd:	e8 31 ff ff ff       	call   801303 <fd_lookup>
  8013d2:	89 c7                	mov    %eax,%edi
  8013d4:	83 c4 08             	add    $0x8,%esp
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	78 05                	js     8013e0 <fd_close+0x30>
	    || fd != fd2)
  8013db:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8013de:	74 13                	je     8013f3 <fd_close+0x43>
		return (must_exist ? r : 0);
  8013e0:	84 db                	test   %bl,%bl
  8013e2:	75 05                	jne    8013e9 <fd_close+0x39>
  8013e4:	bf 00 00 00 00       	mov    $0x0,%edi
}
  8013e9:	89 f8                	mov    %edi,%eax
  8013eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ee:	5b                   	pop    %ebx
  8013ef:	5e                   	pop    %esi
  8013f0:	5f                   	pop    %edi
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013f9:	50                   	push   %eax
  8013fa:	ff 36                	pushl  (%esi)
  8013fc:	e8 59 ff ff ff       	call   80135a <dev_lookup>
  801401:	89 c7                	mov    %eax,%edi
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	85 c0                	test   %eax,%eax
  801408:	78 15                	js     80141f <fd_close+0x6f>
		if (dev->dev_close)
  80140a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140d:	8b 40 10             	mov    0x10(%eax),%eax
  801410:	85 c0                	test   %eax,%eax
  801412:	74 1b                	je     80142f <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801414:	83 ec 0c             	sub    $0xc,%esp
  801417:	56                   	push   %esi
  801418:	ff d0                	call   *%eax
  80141a:	89 c7                	mov    %eax,%edi
  80141c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80141f:	83 ec 08             	sub    $0x8,%esp
  801422:	56                   	push   %esi
  801423:	6a 00                	push   $0x0
  801425:	e8 87 f8 ff ff       	call   800cb1 <sys_page_unmap>
	return r;
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	eb ba                	jmp    8013e9 <fd_close+0x39>
			r = 0;
  80142f:	bf 00 00 00 00       	mov    $0x0,%edi
  801434:	eb e9                	jmp    80141f <fd_close+0x6f>

00801436 <close>:

int
close(int fdnum)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143f:	50                   	push   %eax
  801440:	ff 75 08             	pushl  0x8(%ebp)
  801443:	e8 bb fe ff ff       	call   801303 <fd_lookup>
  801448:	83 c4 08             	add    $0x8,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 10                	js     80145f <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80144f:	83 ec 08             	sub    $0x8,%esp
  801452:	6a 01                	push   $0x1
  801454:	ff 75 f4             	pushl  -0xc(%ebp)
  801457:	e8 54 ff ff ff       	call   8013b0 <fd_close>
  80145c:	83 c4 10             	add    $0x10,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <close_all>:

void
close_all(void)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	53                   	push   %ebx
  801465:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801468:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80146d:	83 ec 0c             	sub    $0xc,%esp
  801470:	53                   	push   %ebx
  801471:	e8 c0 ff ff ff       	call   801436 <close>
	for (i = 0; i < MAXFD; i++)
  801476:	43                   	inc    %ebx
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	83 fb 20             	cmp    $0x20,%ebx
  80147d:	75 ee                	jne    80146d <close_all+0xc>
}
  80147f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80148d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	ff 75 08             	pushl  0x8(%ebp)
  801494:	e8 6a fe ff ff       	call   801303 <fd_lookup>
  801499:	89 c3                	mov    %eax,%ebx
  80149b:	83 c4 08             	add    $0x8,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	0f 88 81 00 00 00    	js     801527 <dup+0xa3>
		return r;
	close(newfdnum);
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	e8 85 ff ff ff       	call   801436 <close>

	newfd = INDEX2FD(newfdnum);
  8014b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014b4:	c1 e6 0c             	shl    $0xc,%esi
  8014b7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014bd:	83 c4 04             	add    $0x4,%esp
  8014c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014c3:	e8 d5 fd ff ff       	call   80129d <fd2data>
  8014c8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014ca:	89 34 24             	mov    %esi,(%esp)
  8014cd:	e8 cb fd ff ff       	call   80129d <fd2data>
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014d7:	89 d8                	mov    %ebx,%eax
  8014d9:	c1 e8 16             	shr    $0x16,%eax
  8014dc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014e3:	a8 01                	test   $0x1,%al
  8014e5:	74 11                	je     8014f8 <dup+0x74>
  8014e7:	89 d8                	mov    %ebx,%eax
  8014e9:	c1 e8 0c             	shr    $0xc,%eax
  8014ec:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014f3:	f6 c2 01             	test   $0x1,%dl
  8014f6:	75 39                	jne    801531 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014fb:	89 d0                	mov    %edx,%eax
  8014fd:	c1 e8 0c             	shr    $0xc,%eax
  801500:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801507:	83 ec 0c             	sub    $0xc,%esp
  80150a:	25 07 0e 00 00       	and    $0xe07,%eax
  80150f:	50                   	push   %eax
  801510:	56                   	push   %esi
  801511:	6a 00                	push   $0x0
  801513:	52                   	push   %edx
  801514:	6a 00                	push   $0x0
  801516:	e8 54 f7 ff ff       	call   800c6f <sys_page_map>
  80151b:	89 c3                	mov    %eax,%ebx
  80151d:	83 c4 20             	add    $0x20,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 31                	js     801555 <dup+0xd1>
		goto err;

	return newfdnum;
  801524:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801527:	89 d8                	mov    %ebx,%eax
  801529:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152c:	5b                   	pop    %ebx
  80152d:	5e                   	pop    %esi
  80152e:	5f                   	pop    %edi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801531:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	25 07 0e 00 00       	and    $0xe07,%eax
  801540:	50                   	push   %eax
  801541:	57                   	push   %edi
  801542:	6a 00                	push   $0x0
  801544:	53                   	push   %ebx
  801545:	6a 00                	push   $0x0
  801547:	e8 23 f7 ff ff       	call   800c6f <sys_page_map>
  80154c:	89 c3                	mov    %eax,%ebx
  80154e:	83 c4 20             	add    $0x20,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	79 a3                	jns    8014f8 <dup+0x74>
	sys_page_unmap(0, newfd);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	56                   	push   %esi
  801559:	6a 00                	push   $0x0
  80155b:	e8 51 f7 ff ff       	call   800cb1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801560:	83 c4 08             	add    $0x8,%esp
  801563:	57                   	push   %edi
  801564:	6a 00                	push   $0x0
  801566:	e8 46 f7 ff ff       	call   800cb1 <sys_page_unmap>
	return r;
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	eb b7                	jmp    801527 <dup+0xa3>

00801570 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	53                   	push   %ebx
  801574:	83 ec 14             	sub    $0x14,%esp
  801577:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80157d:	50                   	push   %eax
  80157e:	53                   	push   %ebx
  80157f:	e8 7f fd ff ff       	call   801303 <fd_lookup>
  801584:	83 c4 08             	add    $0x8,%esp
  801587:	85 c0                	test   %eax,%eax
  801589:	78 3f                	js     8015ca <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158b:	83 ec 08             	sub    $0x8,%esp
  80158e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801591:	50                   	push   %eax
  801592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801595:	ff 30                	pushl  (%eax)
  801597:	e8 be fd ff ff       	call   80135a <dev_lookup>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	78 27                	js     8015ca <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a6:	8b 42 08             	mov    0x8(%edx),%eax
  8015a9:	83 e0 03             	and    $0x3,%eax
  8015ac:	83 f8 01             	cmp    $0x1,%eax
  8015af:	74 1e                	je     8015cf <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b4:	8b 40 08             	mov    0x8(%eax),%eax
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	74 35                	je     8015f0 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	ff 75 10             	pushl  0x10(%ebp)
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	52                   	push   %edx
  8015c5:	ff d0                	call   *%eax
  8015c7:	83 c4 10             	add    $0x10,%esp
}
  8015ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015cf:	a1 04 40 80 00       	mov    0x804004,%eax
  8015d4:	8b 40 48             	mov    0x48(%eax),%eax
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	53                   	push   %ebx
  8015db:	50                   	push   %eax
  8015dc:	68 60 27 80 00       	push   $0x802760
  8015e1:	e8 89 ec ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ee:	eb da                	jmp    8015ca <read+0x5a>
		return -E_NOT_SUPP;
  8015f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f5:	eb d3                	jmp    8015ca <read+0x5a>

008015f7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	57                   	push   %edi
  8015fb:	56                   	push   %esi
  8015fc:	53                   	push   %ebx
  8015fd:	83 ec 0c             	sub    $0xc,%esp
  801600:	8b 7d 08             	mov    0x8(%ebp),%edi
  801603:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801606:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160b:	39 f3                	cmp    %esi,%ebx
  80160d:	73 25                	jae    801634 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	89 f0                	mov    %esi,%eax
  801614:	29 d8                	sub    %ebx,%eax
  801616:	50                   	push   %eax
  801617:	89 d8                	mov    %ebx,%eax
  801619:	03 45 0c             	add    0xc(%ebp),%eax
  80161c:	50                   	push   %eax
  80161d:	57                   	push   %edi
  80161e:	e8 4d ff ff ff       	call   801570 <read>
		if (m < 0)
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	85 c0                	test   %eax,%eax
  801628:	78 08                	js     801632 <readn+0x3b>
			return m;
		if (m == 0)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 06                	je     801634 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80162e:	01 c3                	add    %eax,%ebx
  801630:	eb d9                	jmp    80160b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801632:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801634:	89 d8                	mov    %ebx,%eax
  801636:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801639:	5b                   	pop    %ebx
  80163a:	5e                   	pop    %esi
  80163b:	5f                   	pop    %edi
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    

0080163e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	53                   	push   %ebx
  801642:	83 ec 14             	sub    $0x14,%esp
  801645:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801648:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80164b:	50                   	push   %eax
  80164c:	53                   	push   %ebx
  80164d:	e8 b1 fc ff ff       	call   801303 <fd_lookup>
  801652:	83 c4 08             	add    $0x8,%esp
  801655:	85 c0                	test   %eax,%eax
  801657:	78 3a                	js     801693 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165f:	50                   	push   %eax
  801660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801663:	ff 30                	pushl  (%eax)
  801665:	e8 f0 fc ff ff       	call   80135a <dev_lookup>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	85 c0                	test   %eax,%eax
  80166f:	78 22                	js     801693 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801674:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801678:	74 1e                	je     801698 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80167a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167d:	8b 52 0c             	mov    0xc(%edx),%edx
  801680:	85 d2                	test   %edx,%edx
  801682:	74 35                	je     8016b9 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	ff 75 10             	pushl  0x10(%ebp)
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	50                   	push   %eax
  80168e:	ff d2                	call   *%edx
  801690:	83 c4 10             	add    $0x10,%esp
}
  801693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801696:	c9                   	leave  
  801697:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801698:	a1 04 40 80 00       	mov    0x804004,%eax
  80169d:	8b 40 48             	mov    0x48(%eax),%eax
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	53                   	push   %ebx
  8016a4:	50                   	push   %eax
  8016a5:	68 7c 27 80 00       	push   $0x80277c
  8016aa:	e8 c0 eb ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b7:	eb da                	jmp    801693 <write+0x55>
		return -E_NOT_SUPP;
  8016b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016be:	eb d3                	jmp    801693 <write+0x55>

008016c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016c9:	50                   	push   %eax
  8016ca:	ff 75 08             	pushl  0x8(%ebp)
  8016cd:	e8 31 fc ff ff       	call   801303 <fd_lookup>
  8016d2:	83 c4 08             	add    $0x8,%esp
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 0e                	js     8016e7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016df:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	53                   	push   %ebx
  8016ed:	83 ec 14             	sub    $0x14,%esp
  8016f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f6:	50                   	push   %eax
  8016f7:	53                   	push   %ebx
  8016f8:	e8 06 fc ff ff       	call   801303 <fd_lookup>
  8016fd:	83 c4 08             	add    $0x8,%esp
  801700:	85 c0                	test   %eax,%eax
  801702:	78 37                	js     80173b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170e:	ff 30                	pushl  (%eax)
  801710:	e8 45 fc ff ff       	call   80135a <dev_lookup>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 1f                	js     80173b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801723:	74 1b                	je     801740 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801725:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801728:	8b 52 18             	mov    0x18(%edx),%edx
  80172b:	85 d2                	test   %edx,%edx
  80172d:	74 32                	je     801761 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	50                   	push   %eax
  801736:	ff d2                	call   *%edx
  801738:	83 c4 10             	add    $0x10,%esp
}
  80173b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801740:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801745:	8b 40 48             	mov    0x48(%eax),%eax
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	53                   	push   %ebx
  80174c:	50                   	push   %eax
  80174d:	68 3c 27 80 00       	push   $0x80273c
  801752:	e8 18 eb ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175f:	eb da                	jmp    80173b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801761:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801766:	eb d3                	jmp    80173b <ftruncate+0x52>

00801768 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	53                   	push   %ebx
  80176c:	83 ec 14             	sub    $0x14,%esp
  80176f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801772:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801775:	50                   	push   %eax
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	e8 85 fb ff ff       	call   801303 <fd_lookup>
  80177e:	83 c4 08             	add    $0x8,%esp
  801781:	85 c0                	test   %eax,%eax
  801783:	78 4b                	js     8017d0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801785:	83 ec 08             	sub    $0x8,%esp
  801788:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178b:	50                   	push   %eax
  80178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178f:	ff 30                	pushl  (%eax)
  801791:	e8 c4 fb ff ff       	call   80135a <dev_lookup>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 33                	js     8017d0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017a4:	74 2f                	je     8017d5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017a6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017a9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017b0:	00 00 00 
	stat->st_type = 0;
  8017b3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017ba:	00 00 00 
	stat->st_dev = dev;
  8017bd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017c3:	83 ec 08             	sub    $0x8,%esp
  8017c6:	53                   	push   %ebx
  8017c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ca:	ff 50 14             	call   *0x14(%eax)
  8017cd:	83 c4 10             	add    $0x10,%esp
}
  8017d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    
		return -E_NOT_SUPP;
  8017d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017da:	eb f4                	jmp    8017d0 <fstat+0x68>

008017dc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	6a 00                	push   $0x0
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 34 02 00 00       	call   801a22 <open>
  8017ee:	89 c3                	mov    %eax,%ebx
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	78 1b                	js     801812 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017f7:	83 ec 08             	sub    $0x8,%esp
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	50                   	push   %eax
  8017fe:	e8 65 ff ff ff       	call   801768 <fstat>
  801803:	89 c6                	mov    %eax,%esi
	close(fd);
  801805:	89 1c 24             	mov    %ebx,(%esp)
  801808:	e8 29 fc ff ff       	call   801436 <close>
	return r;
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	89 f3                	mov    %esi,%ebx
}
  801812:	89 d8                	mov    %ebx,%eax
  801814:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    

0080181b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	56                   	push   %esi
  80181f:	53                   	push   %ebx
  801820:	89 c6                	mov    %eax,%esi
  801822:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801824:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80182b:	74 27                	je     801854 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80182d:	6a 07                	push   $0x7
  80182f:	68 00 50 80 00       	push   $0x805000
  801834:	56                   	push   %esi
  801835:	ff 35 00 40 80 00    	pushl  0x804000
  80183b:	e8 af f9 ff ff       	call   8011ef <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801840:	83 c4 0c             	add    $0xc,%esp
  801843:	6a 00                	push   $0x0
  801845:	53                   	push   %ebx
  801846:	6a 00                	push   $0x0
  801848:	e8 19 f9 ff ff       	call   801166 <ipc_recv>
}
  80184d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801850:	5b                   	pop    %ebx
  801851:	5e                   	pop    %esi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	6a 01                	push   $0x1
  801859:	e8 ed f9 ff ff       	call   80124b <ipc_find_env>
  80185e:	a3 00 40 80 00       	mov    %eax,0x804000
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	eb c5                	jmp    80182d <fsipc+0x12>

00801868 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 40 0c             	mov    0xc(%eax),%eax
  801874:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
  801886:	b8 02 00 00 00       	mov    $0x2,%eax
  80188b:	e8 8b ff ff ff       	call   80181b <fsipc>
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <devfile_flush>:
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	8b 40 0c             	mov    0xc(%eax),%eax
  80189e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a8:	b8 06 00 00 00       	mov    $0x6,%eax
  8018ad:	e8 69 ff ff ff       	call   80181b <fsipc>
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <devfile_stat>:
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	b8 05 00 00 00       	mov    $0x5,%eax
  8018d3:	e8 43 ff ff ff       	call   80181b <fsipc>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 2c                	js     801908 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	68 00 50 80 00       	push   $0x805000
  8018e4:	53                   	push   %ebx
  8018e5:	e8 8d ef ff ff       	call   800877 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018ea:	a1 80 50 80 00       	mov    0x805080,%eax
  8018ef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8018f5:	a1 84 50 80 00       	mov    0x805084,%eax
  8018fa:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801908:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <devfile_write>:
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	53                   	push   %ebx
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801917:	89 d8                	mov    %ebx,%eax
  801919:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80191f:	76 05                	jbe    801926 <devfile_write+0x19>
  801921:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801926:	8b 55 08             	mov    0x8(%ebp),%edx
  801929:	8b 52 0c             	mov    0xc(%edx),%edx
  80192c:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801932:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801937:	83 ec 04             	sub    $0x4,%esp
  80193a:	50                   	push   %eax
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	68 08 50 80 00       	push   $0x805008
  801943:	e8 a2 f0 ff ff       	call   8009ea <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801948:	ba 00 00 00 00       	mov    $0x0,%edx
  80194d:	b8 04 00 00 00       	mov    $0x4,%eax
  801952:	e8 c4 fe ff ff       	call   80181b <fsipc>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	78 0b                	js     801969 <devfile_write+0x5c>
	assert(r <= n);
  80195e:	39 c3                	cmp    %eax,%ebx
  801960:	72 0c                	jb     80196e <devfile_write+0x61>
	assert(r <= PGSIZE);
  801962:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801967:	7f 1e                	jg     801987 <devfile_write+0x7a>
}
  801969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    
	assert(r <= n);
  80196e:	68 ac 27 80 00       	push   $0x8027ac
  801973:	68 b6 26 80 00       	push   $0x8026b6
  801978:	68 98 00 00 00       	push   $0x98
  80197d:	68 b3 27 80 00       	push   $0x8027b3
  801982:	e8 d5 e7 ff ff       	call   80015c <_panic>
	assert(r <= PGSIZE);
  801987:	68 be 27 80 00       	push   $0x8027be
  80198c:	68 b6 26 80 00       	push   $0x8026b6
  801991:	68 99 00 00 00       	push   $0x99
  801996:	68 b3 27 80 00       	push   $0x8027b3
  80199b:	e8 bc e7 ff ff       	call   80015c <_panic>

008019a0 <devfile_read>:
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
  8019a5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ae:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019b3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	b8 03 00 00 00       	mov    $0x3,%eax
  8019c3:	e8 53 fe ff ff       	call   80181b <fsipc>
  8019c8:	89 c3                	mov    %eax,%ebx
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 1f                	js     8019ed <devfile_read+0x4d>
	assert(r <= n);
  8019ce:	39 c6                	cmp    %eax,%esi
  8019d0:	72 24                	jb     8019f6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019d2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019d7:	7f 33                	jg     801a0c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	50                   	push   %eax
  8019dd:	68 00 50 80 00       	push   $0x805000
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	e8 00 f0 ff ff       	call   8009ea <memmove>
	return r;
  8019ea:	83 c4 10             	add    $0x10,%esp
}
  8019ed:	89 d8                	mov    %ebx,%eax
  8019ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f2:	5b                   	pop    %ebx
  8019f3:	5e                   	pop    %esi
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    
	assert(r <= n);
  8019f6:	68 ac 27 80 00       	push   $0x8027ac
  8019fb:	68 b6 26 80 00       	push   $0x8026b6
  801a00:	6a 7c                	push   $0x7c
  801a02:	68 b3 27 80 00       	push   $0x8027b3
  801a07:	e8 50 e7 ff ff       	call   80015c <_panic>
	assert(r <= PGSIZE);
  801a0c:	68 be 27 80 00       	push   $0x8027be
  801a11:	68 b6 26 80 00       	push   $0x8026b6
  801a16:	6a 7d                	push   $0x7d
  801a18:	68 b3 27 80 00       	push   $0x8027b3
  801a1d:	e8 3a e7 ff ff       	call   80015c <_panic>

00801a22 <open>:
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	56                   	push   %esi
  801a26:	53                   	push   %ebx
  801a27:	83 ec 1c             	sub    $0x1c,%esp
  801a2a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a2d:	56                   	push   %esi
  801a2e:	e8 11 ee ff ff       	call   800844 <strlen>
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a3b:	7f 6c                	jg     801aa9 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a3d:	83 ec 0c             	sub    $0xc,%esp
  801a40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a43:	50                   	push   %eax
  801a44:	e8 6b f8 ff ff       	call   8012b4 <fd_alloc>
  801a49:	89 c3                	mov    %eax,%ebx
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	78 3c                	js     801a8e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a52:	83 ec 08             	sub    $0x8,%esp
  801a55:	56                   	push   %esi
  801a56:	68 00 50 80 00       	push   $0x805000
  801a5b:	e8 17 ee ff ff       	call   800877 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a63:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a70:	e8 a6 fd ff ff       	call   80181b <fsipc>
  801a75:	89 c3                	mov    %eax,%ebx
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 19                	js     801a97 <open+0x75>
	return fd2num(fd);
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	ff 75 f4             	pushl  -0xc(%ebp)
  801a84:	e8 04 f8 ff ff       	call   80128d <fd2num>
  801a89:	89 c3                	mov    %eax,%ebx
  801a8b:	83 c4 10             	add    $0x10,%esp
}
  801a8e:	89 d8                	mov    %ebx,%eax
  801a90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    
		fd_close(fd, 0);
  801a97:	83 ec 08             	sub    $0x8,%esp
  801a9a:	6a 00                	push   $0x0
  801a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9f:	e8 0c f9 ff ff       	call   8013b0 <fd_close>
		return r;
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	eb e5                	jmp    801a8e <open+0x6c>
		return -E_BAD_PATH;
  801aa9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aae:	eb de                	jmp    801a8e <open+0x6c>

00801ab0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  801abb:	b8 08 00 00 00       	mov    $0x8,%eax
  801ac0:	e8 56 fd ff ff       	call   80181b <fsipc>
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	ff 75 08             	pushl  0x8(%ebp)
  801ad5:	e8 c3 f7 ff ff       	call   80129d <fd2data>
  801ada:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801adc:	83 c4 08             	add    $0x8,%esp
  801adf:	68 ca 27 80 00       	push   $0x8027ca
  801ae4:	53                   	push   %ebx
  801ae5:	e8 8d ed ff ff       	call   800877 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aea:	8b 46 04             	mov    0x4(%esi),%eax
  801aed:	2b 06                	sub    (%esi),%eax
  801aef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801af5:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801afc:	10 00 00 
	stat->st_dev = &devpipe;
  801aff:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b06:	30 80 00 
	return 0;
}
  801b09:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    

00801b15 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	53                   	push   %ebx
  801b19:	83 ec 0c             	sub    $0xc,%esp
  801b1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b1f:	53                   	push   %ebx
  801b20:	6a 00                	push   $0x0
  801b22:	e8 8a f1 ff ff       	call   800cb1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b27:	89 1c 24             	mov    %ebx,(%esp)
  801b2a:	e8 6e f7 ff ff       	call   80129d <fd2data>
  801b2f:	83 c4 08             	add    $0x8,%esp
  801b32:	50                   	push   %eax
  801b33:	6a 00                	push   $0x0
  801b35:	e8 77 f1 ff ff       	call   800cb1 <sys_page_unmap>
}
  801b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <_pipeisclosed>:
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	57                   	push   %edi
  801b43:	56                   	push   %esi
  801b44:	53                   	push   %ebx
  801b45:	83 ec 1c             	sub    $0x1c,%esp
  801b48:	89 c7                	mov    %eax,%edi
  801b4a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b4c:	a1 04 40 80 00       	mov    0x804004,%eax
  801b51:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	57                   	push   %edi
  801b58:	e8 a7 04 00 00       	call   802004 <pageref>
  801b5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b60:	89 34 24             	mov    %esi,(%esp)
  801b63:	e8 9c 04 00 00       	call   802004 <pageref>
		nn = thisenv->env_runs;
  801b68:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	39 cb                	cmp    %ecx,%ebx
  801b76:	74 1b                	je     801b93 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b78:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b7b:	75 cf                	jne    801b4c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b7d:	8b 42 58             	mov    0x58(%edx),%eax
  801b80:	6a 01                	push   $0x1
  801b82:	50                   	push   %eax
  801b83:	53                   	push   %ebx
  801b84:	68 d1 27 80 00       	push   $0x8027d1
  801b89:	e8 e1 e6 ff ff       	call   80026f <cprintf>
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	eb b9                	jmp    801b4c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b93:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b96:	0f 94 c0             	sete   %al
  801b99:	0f b6 c0             	movzbl %al,%eax
}
  801b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <devpipe_write>:
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	57                   	push   %edi
  801ba8:	56                   	push   %esi
  801ba9:	53                   	push   %ebx
  801baa:	83 ec 18             	sub    $0x18,%esp
  801bad:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bb0:	56                   	push   %esi
  801bb1:	e8 e7 f6 ff ff       	call   80129d <fd2data>
  801bb6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bc3:	74 41                	je     801c06 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bc5:	8b 53 04             	mov    0x4(%ebx),%edx
  801bc8:	8b 03                	mov    (%ebx),%eax
  801bca:	83 c0 20             	add    $0x20,%eax
  801bcd:	39 c2                	cmp    %eax,%edx
  801bcf:	72 14                	jb     801be5 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bd1:	89 da                	mov    %ebx,%edx
  801bd3:	89 f0                	mov    %esi,%eax
  801bd5:	e8 65 ff ff ff       	call   801b3f <_pipeisclosed>
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	75 2c                	jne    801c0a <devpipe_write+0x66>
			sys_yield();
  801bde:	e8 10 f1 ff ff       	call   800cf3 <sys_yield>
  801be3:	eb e0                	jmp    801bc5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801beb:	89 d0                	mov    %edx,%eax
  801bed:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801bf2:	78 0b                	js     801bff <devpipe_write+0x5b>
  801bf4:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801bf8:	42                   	inc    %edx
  801bf9:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bfc:	47                   	inc    %edi
  801bfd:	eb c1                	jmp    801bc0 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bff:	48                   	dec    %eax
  801c00:	83 c8 e0             	or     $0xffffffe0,%eax
  801c03:	40                   	inc    %eax
  801c04:	eb ee                	jmp    801bf4 <devpipe_write+0x50>
	return i;
  801c06:	89 f8                	mov    %edi,%eax
  801c08:	eb 05                	jmp    801c0f <devpipe_write+0x6b>
				return 0;
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5f                   	pop    %edi
  801c15:	5d                   	pop    %ebp
  801c16:	c3                   	ret    

00801c17 <devpipe_read>:
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	57                   	push   %edi
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
  801c1d:	83 ec 18             	sub    $0x18,%esp
  801c20:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c23:	57                   	push   %edi
  801c24:	e8 74 f6 ff ff       	call   80129d <fd2data>
  801c29:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c33:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c36:	74 46                	je     801c7e <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801c38:	8b 06                	mov    (%esi),%eax
  801c3a:	3b 46 04             	cmp    0x4(%esi),%eax
  801c3d:	75 22                	jne    801c61 <devpipe_read+0x4a>
			if (i > 0)
  801c3f:	85 db                	test   %ebx,%ebx
  801c41:	74 0a                	je     801c4d <devpipe_read+0x36>
				return i;
  801c43:	89 d8                	mov    %ebx,%eax
}
  801c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c48:	5b                   	pop    %ebx
  801c49:	5e                   	pop    %esi
  801c4a:	5f                   	pop    %edi
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801c4d:	89 f2                	mov    %esi,%edx
  801c4f:	89 f8                	mov    %edi,%eax
  801c51:	e8 e9 fe ff ff       	call   801b3f <_pipeisclosed>
  801c56:	85 c0                	test   %eax,%eax
  801c58:	75 28                	jne    801c82 <devpipe_read+0x6b>
			sys_yield();
  801c5a:	e8 94 f0 ff ff       	call   800cf3 <sys_yield>
  801c5f:	eb d7                	jmp    801c38 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c61:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801c66:	78 0f                	js     801c77 <devpipe_read+0x60>
  801c68:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801c6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c6f:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c72:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801c74:	43                   	inc    %ebx
  801c75:	eb bc                	jmp    801c33 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c77:	48                   	dec    %eax
  801c78:	83 c8 e0             	or     $0xffffffe0,%eax
  801c7b:	40                   	inc    %eax
  801c7c:	eb ea                	jmp    801c68 <devpipe_read+0x51>
	return i;
  801c7e:	89 d8                	mov    %ebx,%eax
  801c80:	eb c3                	jmp    801c45 <devpipe_read+0x2e>
				return 0;
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	eb bc                	jmp    801c45 <devpipe_read+0x2e>

00801c89 <pipe>:
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	56                   	push   %esi
  801c8d:	53                   	push   %ebx
  801c8e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c94:	50                   	push   %eax
  801c95:	e8 1a f6 ff ff       	call   8012b4 <fd_alloc>
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	0f 88 2a 01 00 00    	js     801dd1 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	68 07 04 00 00       	push   $0x407
  801caf:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb2:	6a 00                	push   $0x0
  801cb4:	e8 73 ef ff ff       	call   800c2c <sys_page_alloc>
  801cb9:	89 c3                	mov    %eax,%ebx
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	0f 88 0b 01 00 00    	js     801dd1 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801cc6:	83 ec 0c             	sub    $0xc,%esp
  801cc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ccc:	50                   	push   %eax
  801ccd:	e8 e2 f5 ff ff       	call   8012b4 <fd_alloc>
  801cd2:	89 c3                	mov    %eax,%ebx
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	0f 88 e2 00 00 00    	js     801dc1 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cdf:	83 ec 04             	sub    $0x4,%esp
  801ce2:	68 07 04 00 00       	push   $0x407
  801ce7:	ff 75 f0             	pushl  -0x10(%ebp)
  801cea:	6a 00                	push   $0x0
  801cec:	e8 3b ef ff ff       	call   800c2c <sys_page_alloc>
  801cf1:	89 c3                	mov    %eax,%ebx
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	0f 88 c3 00 00 00    	js     801dc1 <pipe+0x138>
	va = fd2data(fd0);
  801cfe:	83 ec 0c             	sub    $0xc,%esp
  801d01:	ff 75 f4             	pushl  -0xc(%ebp)
  801d04:	e8 94 f5 ff ff       	call   80129d <fd2data>
  801d09:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d0b:	83 c4 0c             	add    $0xc,%esp
  801d0e:	68 07 04 00 00       	push   $0x407
  801d13:	50                   	push   %eax
  801d14:	6a 00                	push   $0x0
  801d16:	e8 11 ef ff ff       	call   800c2c <sys_page_alloc>
  801d1b:	89 c3                	mov    %eax,%ebx
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	85 c0                	test   %eax,%eax
  801d22:	0f 88 89 00 00 00    	js     801db1 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d28:	83 ec 0c             	sub    $0xc,%esp
  801d2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d2e:	e8 6a f5 ff ff       	call   80129d <fd2data>
  801d33:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d3a:	50                   	push   %eax
  801d3b:	6a 00                	push   $0x0
  801d3d:	56                   	push   %esi
  801d3e:	6a 00                	push   $0x0
  801d40:	e8 2a ef ff ff       	call   800c6f <sys_page_map>
  801d45:	89 c3                	mov    %eax,%ebx
  801d47:	83 c4 20             	add    $0x20,%esp
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	78 55                	js     801da3 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801d4e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d57:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d63:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d71:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7e:	e8 0a f5 ff ff       	call   80128d <fd2num>
  801d83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d86:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d88:	83 c4 04             	add    $0x4,%esp
  801d8b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d8e:	e8 fa f4 ff ff       	call   80128d <fd2num>
  801d93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d96:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801da1:	eb 2e                	jmp    801dd1 <pipe+0x148>
	sys_page_unmap(0, va);
  801da3:	83 ec 08             	sub    $0x8,%esp
  801da6:	56                   	push   %esi
  801da7:	6a 00                	push   $0x0
  801da9:	e8 03 ef ff ff       	call   800cb1 <sys_page_unmap>
  801dae:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801db1:	83 ec 08             	sub    $0x8,%esp
  801db4:	ff 75 f0             	pushl  -0x10(%ebp)
  801db7:	6a 00                	push   $0x0
  801db9:	e8 f3 ee ff ff       	call   800cb1 <sys_page_unmap>
  801dbe:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dc1:	83 ec 08             	sub    $0x8,%esp
  801dc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc7:	6a 00                	push   $0x0
  801dc9:	e8 e3 ee ff ff       	call   800cb1 <sys_page_unmap>
  801dce:	83 c4 10             	add    $0x10,%esp
}
  801dd1:	89 d8                	mov    %ebx,%eax
  801dd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd6:	5b                   	pop    %ebx
  801dd7:	5e                   	pop    %esi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    

00801dda <pipeisclosed>:
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801de0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de3:	50                   	push   %eax
  801de4:	ff 75 08             	pushl  0x8(%ebp)
  801de7:	e8 17 f5 ff ff       	call   801303 <fd_lookup>
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	85 c0                	test   %eax,%eax
  801df1:	78 18                	js     801e0b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801df3:	83 ec 0c             	sub    $0xc,%esp
  801df6:	ff 75 f4             	pushl  -0xc(%ebp)
  801df9:	e8 9f f4 ff ff       	call   80129d <fd2data>
	return _pipeisclosed(fd, p);
  801dfe:	89 c2                	mov    %eax,%edx
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	e8 37 fd ff ff       	call   801b3f <_pipeisclosed>
  801e08:	83 c4 10             	add    $0x10,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    

00801e17 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	53                   	push   %ebx
  801e1b:	83 ec 0c             	sub    $0xc,%esp
  801e1e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801e21:	68 e9 27 80 00       	push   $0x8027e9
  801e26:	53                   	push   %ebx
  801e27:	e8 4b ea ff ff       	call   800877 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801e2c:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801e33:	20 00 00 
	return 0;
}
  801e36:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <devcons_write>:
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	57                   	push   %edi
  801e44:	56                   	push   %esi
  801e45:	53                   	push   %ebx
  801e46:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e4c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e51:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e57:	eb 1d                	jmp    801e76 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801e59:	83 ec 04             	sub    $0x4,%esp
  801e5c:	53                   	push   %ebx
  801e5d:	03 45 0c             	add    0xc(%ebp),%eax
  801e60:	50                   	push   %eax
  801e61:	57                   	push   %edi
  801e62:	e8 83 eb ff ff       	call   8009ea <memmove>
		sys_cputs(buf, m);
  801e67:	83 c4 08             	add    $0x8,%esp
  801e6a:	53                   	push   %ebx
  801e6b:	57                   	push   %edi
  801e6c:	e8 1e ed ff ff       	call   800b8f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e71:	01 de                	add    %ebx,%esi
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	89 f0                	mov    %esi,%eax
  801e78:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e7b:	73 11                	jae    801e8e <devcons_write+0x4e>
		m = n - tot;
  801e7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e80:	29 f3                	sub    %esi,%ebx
  801e82:	83 fb 7f             	cmp    $0x7f,%ebx
  801e85:	76 d2                	jbe    801e59 <devcons_write+0x19>
  801e87:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801e8c:	eb cb                	jmp    801e59 <devcons_write+0x19>
}
  801e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e91:	5b                   	pop    %ebx
  801e92:	5e                   	pop    %esi
  801e93:	5f                   	pop    %edi
  801e94:	5d                   	pop    %ebp
  801e95:	c3                   	ret    

00801e96 <devcons_read>:
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801e9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ea0:	75 0c                	jne    801eae <devcons_read+0x18>
		return 0;
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea7:	eb 21                	jmp    801eca <devcons_read+0x34>
		sys_yield();
  801ea9:	e8 45 ee ff ff       	call   800cf3 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801eae:	e8 fa ec ff ff       	call   800bad <sys_cgetc>
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	74 f2                	je     801ea9 <devcons_read+0x13>
	if (c < 0)
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	78 0f                	js     801eca <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801ebb:	83 f8 04             	cmp    $0x4,%eax
  801ebe:	74 0c                	je     801ecc <devcons_read+0x36>
	*(char*)vbuf = c;
  801ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec3:	88 02                	mov    %al,(%edx)
	return 1;
  801ec5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    
		return 0;
  801ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed1:	eb f7                	jmp    801eca <devcons_read+0x34>

00801ed3 <cputchar>:
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801edf:	6a 01                	push   $0x1
  801ee1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ee4:	50                   	push   %eax
  801ee5:	e8 a5 ec ff ff       	call   800b8f <sys_cputs>
}
  801eea:	83 c4 10             	add    $0x10,%esp
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <getchar>:
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ef5:	6a 01                	push   $0x1
  801ef7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801efa:	50                   	push   %eax
  801efb:	6a 00                	push   $0x0
  801efd:	e8 6e f6 ff ff       	call   801570 <read>
	if (r < 0)
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	85 c0                	test   %eax,%eax
  801f07:	78 08                	js     801f11 <getchar+0x22>
	if (r < 1)
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	7e 06                	jle    801f13 <getchar+0x24>
	return c;
  801f0d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    
		return -E_EOF;
  801f13:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f18:	eb f7                	jmp    801f11 <getchar+0x22>

00801f1a <iscons>:
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f23:	50                   	push   %eax
  801f24:	ff 75 08             	pushl  0x8(%ebp)
  801f27:	e8 d7 f3 ff ff       	call   801303 <fd_lookup>
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	78 11                	js     801f44 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f3c:	39 10                	cmp    %edx,(%eax)
  801f3e:	0f 94 c0             	sete   %al
  801f41:	0f b6 c0             	movzbl %al,%eax
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <opencons>:
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4f:	50                   	push   %eax
  801f50:	e8 5f f3 ff ff       	call   8012b4 <fd_alloc>
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 3a                	js     801f96 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f5c:	83 ec 04             	sub    $0x4,%esp
  801f5f:	68 07 04 00 00       	push   $0x407
  801f64:	ff 75 f4             	pushl  -0xc(%ebp)
  801f67:	6a 00                	push   $0x0
  801f69:	e8 be ec ff ff       	call   800c2c <sys_page_alloc>
  801f6e:	83 c4 10             	add    $0x10,%esp
  801f71:	85 c0                	test   %eax,%eax
  801f73:	78 21                	js     801f96 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f75:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f8a:	83 ec 0c             	sub    $0xc,%esp
  801f8d:	50                   	push   %eax
  801f8e:	e8 fa f2 ff ff       	call   80128d <fd2num>
  801f93:	83 c4 10             	add    $0x10,%esp
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f9e:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fa5:	74 0a                	je     801fb1 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801fb1:	e8 57 ec ff ff       	call   800c0d <sys_getenvid>
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	6a 07                	push   $0x7
  801fbb:	68 00 f0 bf ee       	push   $0xeebff000
  801fc0:	50                   	push   %eax
  801fc1:	e8 66 ec ff ff       	call   800c2c <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801fc6:	e8 42 ec ff ff       	call   800c0d <sys_getenvid>
  801fcb:	83 c4 08             	add    $0x8,%esp
  801fce:	68 de 1f 80 00       	push   $0x801fde
  801fd3:	50                   	push   %eax
  801fd4:	e8 fe ed ff ff       	call   800dd7 <sys_env_set_pgfault_upcall>
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	eb c9                	jmp    801fa7 <set_pgfault_handler+0xf>

00801fde <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801fde:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801fdf:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801fe4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801fe6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  801fe9:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801fed:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801ff1:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801ff4:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801ff6:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  801ffa:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801ffd:	61                   	popa   
	addl $4, %esp
  801ffe:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802001:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802002:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802003:	c3                   	ret    

00802004 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	c1 e8 16             	shr    $0x16,%eax
  80200d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802014:	a8 01                	test   $0x1,%al
  802016:	74 21                	je     802039 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	c1 e8 0c             	shr    $0xc,%eax
  80201e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802025:	a8 01                	test   $0x1,%al
  802027:	74 17                	je     802040 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802029:	c1 e8 0c             	shr    $0xc,%eax
  80202c:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802033:	ef 
  802034:	0f b7 c0             	movzwl %ax,%eax
  802037:	eb 05                	jmp    80203e <pageref+0x3a>
		return 0;
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    
		return 0;
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	eb f7                	jmp    80203e <pageref+0x3a>
  802047:	90                   	nop

00802048 <__udivdi3>:
  802048:	55                   	push   %ebp
  802049:	57                   	push   %edi
  80204a:	56                   	push   %esi
  80204b:	53                   	push   %ebx
  80204c:	83 ec 1c             	sub    $0x1c,%esp
  80204f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802053:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802057:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80205b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80205f:	89 ca                	mov    %ecx,%edx
  802061:	89 f8                	mov    %edi,%eax
  802063:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802067:	85 f6                	test   %esi,%esi
  802069:	75 2d                	jne    802098 <__udivdi3+0x50>
  80206b:	39 cf                	cmp    %ecx,%edi
  80206d:	77 65                	ja     8020d4 <__udivdi3+0x8c>
  80206f:	89 fd                	mov    %edi,%ebp
  802071:	85 ff                	test   %edi,%edi
  802073:	75 0b                	jne    802080 <__udivdi3+0x38>
  802075:	b8 01 00 00 00       	mov    $0x1,%eax
  80207a:	31 d2                	xor    %edx,%edx
  80207c:	f7 f7                	div    %edi
  80207e:	89 c5                	mov    %eax,%ebp
  802080:	31 d2                	xor    %edx,%edx
  802082:	89 c8                	mov    %ecx,%eax
  802084:	f7 f5                	div    %ebp
  802086:	89 c1                	mov    %eax,%ecx
  802088:	89 d8                	mov    %ebx,%eax
  80208a:	f7 f5                	div    %ebp
  80208c:	89 cf                	mov    %ecx,%edi
  80208e:	89 fa                	mov    %edi,%edx
  802090:	83 c4 1c             	add    $0x1c,%esp
  802093:	5b                   	pop    %ebx
  802094:	5e                   	pop    %esi
  802095:	5f                   	pop    %edi
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    
  802098:	39 ce                	cmp    %ecx,%esi
  80209a:	77 28                	ja     8020c4 <__udivdi3+0x7c>
  80209c:	0f bd fe             	bsr    %esi,%edi
  80209f:	83 f7 1f             	xor    $0x1f,%edi
  8020a2:	75 40                	jne    8020e4 <__udivdi3+0x9c>
  8020a4:	39 ce                	cmp    %ecx,%esi
  8020a6:	72 0a                	jb     8020b2 <__udivdi3+0x6a>
  8020a8:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8020ac:	0f 87 9e 00 00 00    	ja     802150 <__udivdi3+0x108>
  8020b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b7:	89 fa                	mov    %edi,%edx
  8020b9:	83 c4 1c             	add    $0x1c,%esp
  8020bc:	5b                   	pop    %ebx
  8020bd:	5e                   	pop    %esi
  8020be:	5f                   	pop    %edi
  8020bf:	5d                   	pop    %ebp
  8020c0:	c3                   	ret    
  8020c1:	8d 76 00             	lea    0x0(%esi),%esi
  8020c4:	31 ff                	xor    %edi,%edi
  8020c6:	31 c0                	xor    %eax,%eax
  8020c8:	89 fa                	mov    %edi,%edx
  8020ca:	83 c4 1c             	add    $0x1c,%esp
  8020cd:	5b                   	pop    %ebx
  8020ce:	5e                   	pop    %esi
  8020cf:	5f                   	pop    %edi
  8020d0:	5d                   	pop    %ebp
  8020d1:	c3                   	ret    
  8020d2:	66 90                	xchg   %ax,%ax
  8020d4:	89 d8                	mov    %ebx,%eax
  8020d6:	f7 f7                	div    %edi
  8020d8:	31 ff                	xor    %edi,%edi
  8020da:	89 fa                	mov    %edi,%edx
  8020dc:	83 c4 1c             	add    $0x1c,%esp
  8020df:	5b                   	pop    %ebx
  8020e0:	5e                   	pop    %esi
  8020e1:	5f                   	pop    %edi
  8020e2:	5d                   	pop    %ebp
  8020e3:	c3                   	ret    
  8020e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020e9:	29 fd                	sub    %edi,%ebp
  8020eb:	89 f9                	mov    %edi,%ecx
  8020ed:	d3 e6                	shl    %cl,%esi
  8020ef:	89 c3                	mov    %eax,%ebx
  8020f1:	89 e9                	mov    %ebp,%ecx
  8020f3:	d3 eb                	shr    %cl,%ebx
  8020f5:	89 d9                	mov    %ebx,%ecx
  8020f7:	09 f1                	or     %esi,%ecx
  8020f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020fd:	89 f9                	mov    %edi,%ecx
  8020ff:	d3 e0                	shl    %cl,%eax
  802101:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802105:	89 d6                	mov    %edx,%esi
  802107:	89 e9                	mov    %ebp,%ecx
  802109:	d3 ee                	shr    %cl,%esi
  80210b:	89 f9                	mov    %edi,%ecx
  80210d:	d3 e2                	shl    %cl,%edx
  80210f:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802113:	89 e9                	mov    %ebp,%ecx
  802115:	d3 eb                	shr    %cl,%ebx
  802117:	09 da                	or     %ebx,%edx
  802119:	89 d0                	mov    %edx,%eax
  80211b:	89 f2                	mov    %esi,%edx
  80211d:	f7 74 24 08          	divl   0x8(%esp)
  802121:	89 d6                	mov    %edx,%esi
  802123:	89 c3                	mov    %eax,%ebx
  802125:	f7 64 24 0c          	mull   0xc(%esp)
  802129:	39 d6                	cmp    %edx,%esi
  80212b:	72 17                	jb     802144 <__udivdi3+0xfc>
  80212d:	74 09                	je     802138 <__udivdi3+0xf0>
  80212f:	89 d8                	mov    %ebx,%eax
  802131:	31 ff                	xor    %edi,%edi
  802133:	e9 56 ff ff ff       	jmp    80208e <__udivdi3+0x46>
  802138:	8b 54 24 04          	mov    0x4(%esp),%edx
  80213c:	89 f9                	mov    %edi,%ecx
  80213e:	d3 e2                	shl    %cl,%edx
  802140:	39 c2                	cmp    %eax,%edx
  802142:	73 eb                	jae    80212f <__udivdi3+0xe7>
  802144:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802147:	31 ff                	xor    %edi,%edi
  802149:	e9 40 ff ff ff       	jmp    80208e <__udivdi3+0x46>
  80214e:	66 90                	xchg   %ax,%ax
  802150:	31 c0                	xor    %eax,%eax
  802152:	e9 37 ff ff ff       	jmp    80208e <__udivdi3+0x46>
  802157:	90                   	nop

00802158 <__umoddi3>:
  802158:	55                   	push   %ebp
  802159:	57                   	push   %edi
  80215a:	56                   	push   %esi
  80215b:	53                   	push   %ebx
  80215c:	83 ec 1c             	sub    $0x1c,%esp
  80215f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802163:	8b 74 24 34          	mov    0x34(%esp),%esi
  802167:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80216b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80216f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802173:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802177:	89 3c 24             	mov    %edi,(%esp)
  80217a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80217e:	89 f2                	mov    %esi,%edx
  802180:	85 c0                	test   %eax,%eax
  802182:	75 18                	jne    80219c <__umoddi3+0x44>
  802184:	39 f7                	cmp    %esi,%edi
  802186:	0f 86 a0 00 00 00    	jbe    80222c <__umoddi3+0xd4>
  80218c:	89 c8                	mov    %ecx,%eax
  80218e:	f7 f7                	div    %edi
  802190:	89 d0                	mov    %edx,%eax
  802192:	31 d2                	xor    %edx,%edx
  802194:	83 c4 1c             	add    $0x1c,%esp
  802197:	5b                   	pop    %ebx
  802198:	5e                   	pop    %esi
  802199:	5f                   	pop    %edi
  80219a:	5d                   	pop    %ebp
  80219b:	c3                   	ret    
  80219c:	89 f3                	mov    %esi,%ebx
  80219e:	39 f0                	cmp    %esi,%eax
  8021a0:	0f 87 a6 00 00 00    	ja     80224c <__umoddi3+0xf4>
  8021a6:	0f bd e8             	bsr    %eax,%ebp
  8021a9:	83 f5 1f             	xor    $0x1f,%ebp
  8021ac:	0f 84 a6 00 00 00    	je     802258 <__umoddi3+0x100>
  8021b2:	bf 20 00 00 00       	mov    $0x20,%edi
  8021b7:	29 ef                	sub    %ebp,%edi
  8021b9:	89 e9                	mov    %ebp,%ecx
  8021bb:	d3 e0                	shl    %cl,%eax
  8021bd:	8b 34 24             	mov    (%esp),%esi
  8021c0:	89 f2                	mov    %esi,%edx
  8021c2:	89 f9                	mov    %edi,%ecx
  8021c4:	d3 ea                	shr    %cl,%edx
  8021c6:	09 c2                	or     %eax,%edx
  8021c8:	89 14 24             	mov    %edx,(%esp)
  8021cb:	89 f2                	mov    %esi,%edx
  8021cd:	89 e9                	mov    %ebp,%ecx
  8021cf:	d3 e2                	shl    %cl,%edx
  8021d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021d5:	89 de                	mov    %ebx,%esi
  8021d7:	89 f9                	mov    %edi,%ecx
  8021d9:	d3 ee                	shr    %cl,%esi
  8021db:	89 e9                	mov    %ebp,%ecx
  8021dd:	d3 e3                	shl    %cl,%ebx
  8021df:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021e3:	89 d0                	mov    %edx,%eax
  8021e5:	89 f9                	mov    %edi,%ecx
  8021e7:	d3 e8                	shr    %cl,%eax
  8021e9:	09 d8                	or     %ebx,%eax
  8021eb:	89 d3                	mov    %edx,%ebx
  8021ed:	89 e9                	mov    %ebp,%ecx
  8021ef:	d3 e3                	shl    %cl,%ebx
  8021f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021f5:	89 f2                	mov    %esi,%edx
  8021f7:	f7 34 24             	divl   (%esp)
  8021fa:	89 d6                	mov    %edx,%esi
  8021fc:	f7 64 24 04          	mull   0x4(%esp)
  802200:	89 c3                	mov    %eax,%ebx
  802202:	89 d1                	mov    %edx,%ecx
  802204:	39 d6                	cmp    %edx,%esi
  802206:	72 7c                	jb     802284 <__umoddi3+0x12c>
  802208:	74 72                	je     80227c <__umoddi3+0x124>
  80220a:	8b 54 24 08          	mov    0x8(%esp),%edx
  80220e:	29 da                	sub    %ebx,%edx
  802210:	19 ce                	sbb    %ecx,%esi
  802212:	89 f0                	mov    %esi,%eax
  802214:	89 f9                	mov    %edi,%ecx
  802216:	d3 e0                	shl    %cl,%eax
  802218:	89 e9                	mov    %ebp,%ecx
  80221a:	d3 ea                	shr    %cl,%edx
  80221c:	09 d0                	or     %edx,%eax
  80221e:	89 e9                	mov    %ebp,%ecx
  802220:	d3 ee                	shr    %cl,%esi
  802222:	89 f2                	mov    %esi,%edx
  802224:	83 c4 1c             	add    $0x1c,%esp
  802227:	5b                   	pop    %ebx
  802228:	5e                   	pop    %esi
  802229:	5f                   	pop    %edi
  80222a:	5d                   	pop    %ebp
  80222b:	c3                   	ret    
  80222c:	89 fd                	mov    %edi,%ebp
  80222e:	85 ff                	test   %edi,%edi
  802230:	75 0b                	jne    80223d <__umoddi3+0xe5>
  802232:	b8 01 00 00 00       	mov    $0x1,%eax
  802237:	31 d2                	xor    %edx,%edx
  802239:	f7 f7                	div    %edi
  80223b:	89 c5                	mov    %eax,%ebp
  80223d:	89 f0                	mov    %esi,%eax
  80223f:	31 d2                	xor    %edx,%edx
  802241:	f7 f5                	div    %ebp
  802243:	89 c8                	mov    %ecx,%eax
  802245:	f7 f5                	div    %ebp
  802247:	e9 44 ff ff ff       	jmp    802190 <__umoddi3+0x38>
  80224c:	89 c8                	mov    %ecx,%eax
  80224e:	89 f2                	mov    %esi,%edx
  802250:	83 c4 1c             	add    $0x1c,%esp
  802253:	5b                   	pop    %ebx
  802254:	5e                   	pop    %esi
  802255:	5f                   	pop    %edi
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    
  802258:	39 f0                	cmp    %esi,%eax
  80225a:	72 05                	jb     802261 <__umoddi3+0x109>
  80225c:	39 0c 24             	cmp    %ecx,(%esp)
  80225f:	77 0c                	ja     80226d <__umoddi3+0x115>
  802261:	89 f2                	mov    %esi,%edx
  802263:	29 f9                	sub    %edi,%ecx
  802265:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802269:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80226d:	8b 44 24 04          	mov    0x4(%esp),%eax
  802271:	83 c4 1c             	add    $0x1c,%esp
  802274:	5b                   	pop    %ebx
  802275:	5e                   	pop    %esi
  802276:	5f                   	pop    %edi
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    
  802279:	8d 76 00             	lea    0x0(%esi),%esi
  80227c:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802280:	73 88                	jae    80220a <__umoddi3+0xb2>
  802282:	66 90                	xchg   %ax,%ax
  802284:	2b 44 24 04          	sub    0x4(%esp),%eax
  802288:	1b 14 24             	sbb    (%esp),%edx
  80228b:	89 d1                	mov    %edx,%ecx
  80228d:	89 c3                	mov    %eax,%ebx
  80228f:	e9 76 ff ff ff       	jmp    80220a <__umoddi3+0xb2>
