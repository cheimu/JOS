
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 7b 01 00 00       	call   8001ac <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 e4 08 00 00       	call   80092d <strcpy>
	exit();
  800049:	e8 aa 01 00 00       	call   8001f8 <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d4 00 00 00    	jne    800138 <umain+0xe5>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 6a 0c 00 00       	call   800ce2 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bf 00 00 00    	js     800142 <umain+0xef>
	if ((r = fork()) < 0)
  800083:	e8 d3 0f 00 00       	call   80105b <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 c2 00 00 00    	js     800154 <umain+0x101>
	if (r == 0) {
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 84 cc 00 00 00    	je     800166 <umain+0x113>
	wait(r);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	53                   	push   %ebx
  80009e:	e8 e2 22 00 00       	call   802385 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a3:	83 c4 08             	add    $0x8,%esp
  8000a6:	ff 35 04 40 80 00    	pushl  0x804004
  8000ac:	68 00 00 00 a0       	push   $0xa0000000
  8000b1:	e8 14 09 00 00       	call   8009ca <strcmp>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	85 c0                	test   %eax,%eax
  8000bb:	0f 84 c5 00 00 00    	je     800186 <umain+0x133>
  8000c1:	b8 a6 29 80 00       	mov    $0x8029a6,%eax
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 dc 29 80 00       	push   $0x8029dc
  8000cf:	e8 51 02 00 00       	call   800325 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d4:	6a 00                	push   $0x0
  8000d6:	68 f7 29 80 00       	push   $0x8029f7
  8000db:	68 fc 29 80 00       	push   $0x8029fc
  8000e0:	68 fb 29 80 00       	push   $0x8029fb
  8000e5:	e8 dc 1e 00 00       	call   801fc6 <spawnl>
  8000ea:	83 c4 20             	add    $0x20,%esp
  8000ed:	85 c0                	test   %eax,%eax
  8000ef:	0f 88 9b 00 00 00    	js     800190 <umain+0x13d>
	wait(r);
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	50                   	push   %eax
  8000f9:	e8 87 22 00 00       	call   802385 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fe:	83 c4 08             	add    $0x8,%esp
  800101:	ff 35 00 40 80 00    	pushl  0x804000
  800107:	68 00 00 00 a0       	push   $0xa0000000
  80010c:	e8 b9 08 00 00       	call   8009ca <strcmp>
  800111:	83 c4 10             	add    $0x10,%esp
  800114:	85 c0                	test   %eax,%eax
  800116:	0f 84 86 00 00 00    	je     8001a2 <umain+0x14f>
  80011c:	b8 a6 29 80 00       	mov    $0x8029a6,%eax
  800121:	83 ec 08             	sub    $0x8,%esp
  800124:	50                   	push   %eax
  800125:	68 13 2a 80 00       	push   $0x802a13
  80012a:	e8 f6 01 00 00       	call   800325 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012f:	cc                   	int3   
}
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800136:	c9                   	leave  
  800137:	c3                   	ret    
		childofspawn();
  800138:	e8 f6 fe ff ff       	call   800033 <childofspawn>
  80013d:	e9 22 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  800142:	50                   	push   %eax
  800143:	68 ac 29 80 00       	push   $0x8029ac
  800148:	6a 13                	push   $0x13
  80014a:	68 bf 29 80 00       	push   $0x8029bf
  80014f:	e8 be 00 00 00       	call   800212 <_panic>
		panic("fork: %e", r);
  800154:	50                   	push   %eax
  800155:	68 d3 29 80 00       	push   $0x8029d3
  80015a:	6a 17                	push   $0x17
  80015c:	68 bf 29 80 00       	push   $0x8029bf
  800161:	e8 ac 00 00 00       	call   800212 <_panic>
		strcpy(VA, msg);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	ff 35 04 40 80 00    	pushl  0x804004
  80016f:	68 00 00 00 a0       	push   $0xa0000000
  800174:	e8 b4 07 00 00       	call   80092d <strcpy>
		exit();
  800179:	e8 7a 00 00 00       	call   8001f8 <exit>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	e9 14 ff ff ff       	jmp    80009a <umain+0x47>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800186:	b8 a0 29 80 00       	mov    $0x8029a0,%eax
  80018b:	e9 36 ff ff ff       	jmp    8000c6 <umain+0x73>
		panic("spawn: %e", r);
  800190:	50                   	push   %eax
  800191:	68 09 2a 80 00       	push   $0x802a09
  800196:	6a 21                	push   $0x21
  800198:	68 bf 29 80 00       	push   $0x8029bf
  80019d:	e8 70 00 00 00       	call   800212 <_panic>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8001a2:	b8 a0 29 80 00       	mov    $0x8029a0,%eax
  8001a7:	e9 75 ff ff ff       	jmp    800121 <umain+0xce>

008001ac <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	56                   	push   %esi
  8001b0:	53                   	push   %ebx
  8001b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001b7:	e8 07 0b 00 00       	call   800cc3 <sys_getenvid>
  8001bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001c1:	89 c2                	mov    %eax,%edx
  8001c3:	c1 e2 05             	shl    $0x5,%edx
  8001c6:	29 c2                	sub    %eax,%edx
  8001c8:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8001cf:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d4:	85 db                	test   %ebx,%ebx
  8001d6:	7e 07                	jle    8001df <libmain+0x33>
		binaryname = argv[0];
  8001d8:	8b 06                	mov    (%esi),%eax
  8001da:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	56                   	push   %esi
  8001e3:	53                   	push   %ebx
  8001e4:	e8 6a fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001e9:	e8 0a 00 00 00       	call   8001f8 <exit>
}
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001f4:	5b                   	pop    %ebx
  8001f5:	5e                   	pop    %esi
  8001f6:	5d                   	pop    %ebp
  8001f7:	c3                   	ret    

008001f8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001fe:	e8 ed 11 00 00       	call   8013f0 <close_all>
	sys_env_destroy(0);
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	6a 00                	push   $0x0
  800208:	e8 75 0a 00 00       	call   800c82 <sys_env_destroy>
}
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	57                   	push   %edi
  800216:	56                   	push   %esi
  800217:	53                   	push   %ebx
  800218:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80021e:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800221:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800227:	e8 97 0a 00 00       	call   800cc3 <sys_getenvid>
  80022c:	83 ec 04             	sub    $0x4,%esp
  80022f:	ff 75 0c             	pushl  0xc(%ebp)
  800232:	ff 75 08             	pushl  0x8(%ebp)
  800235:	53                   	push   %ebx
  800236:	50                   	push   %eax
  800237:	68 58 2a 80 00       	push   $0x802a58
  80023c:	68 00 01 00 00       	push   $0x100
  800241:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800247:	56                   	push   %esi
  800248:	e8 93 06 00 00       	call   8008e0 <snprintf>
  80024d:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80024f:	83 c4 20             	add    $0x20,%esp
  800252:	57                   	push   %edi
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	bf 00 01 00 00       	mov    $0x100,%edi
  80025b:	89 f8                	mov    %edi,%eax
  80025d:	29 d8                	sub    %ebx,%eax
  80025f:	50                   	push   %eax
  800260:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800263:	50                   	push   %eax
  800264:	e8 22 06 00 00       	call   80088b <vsnprintf>
  800269:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80026b:	83 c4 0c             	add    $0xc,%esp
  80026e:	68 de 2f 80 00       	push   $0x802fde
  800273:	29 df                	sub    %ebx,%edi
  800275:	57                   	push   %edi
  800276:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800279:	50                   	push   %eax
  80027a:	e8 61 06 00 00       	call   8008e0 <snprintf>
	sys_cputs(buf, r);
  80027f:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800282:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800284:	53                   	push   %ebx
  800285:	56                   	push   %esi
  800286:	e8 ba 09 00 00       	call   800c45 <sys_cputs>
  80028b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028e:	cc                   	int3   
  80028f:	eb fd                	jmp    80028e <_panic+0x7c>

00800291 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	53                   	push   %ebx
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80029b:	8b 13                	mov    (%ebx),%edx
  80029d:	8d 42 01             	lea    0x1(%edx),%eax
  8002a0:	89 03                	mov    %eax,(%ebx)
  8002a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ae:	74 08                	je     8002b8 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b0:	ff 43 04             	incl   0x4(%ebx)
}
  8002b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b6:	c9                   	leave  
  8002b7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	68 ff 00 00 00       	push   $0xff
  8002c0:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c3:	50                   	push   %eax
  8002c4:	e8 7c 09 00 00       	call   800c45 <sys_cputs>
		b->idx = 0;
  8002c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	eb dc                	jmp    8002b0 <putch+0x1f>

008002d4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e4:	00 00 00 
	b.cnt = 0;
  8002e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f1:	ff 75 0c             	pushl  0xc(%ebp)
  8002f4:	ff 75 08             	pushl  0x8(%ebp)
  8002f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002fd:	50                   	push   %eax
  8002fe:	68 91 02 80 00       	push   $0x800291
  800303:	e8 17 01 00 00       	call   80041f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800308:	83 c4 08             	add    $0x8,%esp
  80030b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800311:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800317:	50                   	push   %eax
  800318:	e8 28 09 00 00       	call   800c45 <sys_cputs>

	return b.cnt;
}
  80031d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80032b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80032e:	50                   	push   %eax
  80032f:	ff 75 08             	pushl  0x8(%ebp)
  800332:	e8 9d ff ff ff       	call   8002d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	57                   	push   %edi
  80033d:	56                   	push   %esi
  80033e:	53                   	push   %ebx
  80033f:	83 ec 1c             	sub    $0x1c,%esp
  800342:	89 c7                	mov    %eax,%edi
  800344:	89 d6                	mov    %edx,%esi
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800352:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800355:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80035d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800360:	39 d3                	cmp    %edx,%ebx
  800362:	72 05                	jb     800369 <printnum+0x30>
  800364:	39 45 10             	cmp    %eax,0x10(%ebp)
  800367:	77 78                	ja     8003e1 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800369:	83 ec 0c             	sub    $0xc,%esp
  80036c:	ff 75 18             	pushl  0x18(%ebp)
  80036f:	8b 45 14             	mov    0x14(%ebp),%eax
  800372:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800375:	53                   	push   %ebx
  800376:	ff 75 10             	pushl  0x10(%ebp)
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037f:	ff 75 e0             	pushl  -0x20(%ebp)
  800382:	ff 75 dc             	pushl  -0x24(%ebp)
  800385:	ff 75 d8             	pushl  -0x28(%ebp)
  800388:	e8 af 23 00 00       	call   80273c <__udivdi3>
  80038d:	83 c4 18             	add    $0x18,%esp
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	89 f2                	mov    %esi,%edx
  800394:	89 f8                	mov    %edi,%eax
  800396:	e8 9e ff ff ff       	call   800339 <printnum>
  80039b:	83 c4 20             	add    $0x20,%esp
  80039e:	eb 11                	jmp    8003b1 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	56                   	push   %esi
  8003a4:	ff 75 18             	pushl  0x18(%ebp)
  8003a7:	ff d7                	call   *%edi
  8003a9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003ac:	4b                   	dec    %ebx
  8003ad:	85 db                	test   %ebx,%ebx
  8003af:	7f ef                	jg     8003a0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	56                   	push   %esi
  8003b5:	83 ec 04             	sub    $0x4,%esp
  8003b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8003be:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c4:	e8 83 24 00 00       	call   80284c <__umoddi3>
  8003c9:	83 c4 14             	add    $0x14,%esp
  8003cc:	0f be 80 7b 2a 80 00 	movsbl 0x802a7b(%eax),%eax
  8003d3:	50                   	push   %eax
  8003d4:	ff d7                	call   *%edi
}
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003dc:	5b                   	pop    %ebx
  8003dd:	5e                   	pop    %esi
  8003de:	5f                   	pop    %edi
  8003df:	5d                   	pop    %ebp
  8003e0:	c3                   	ret    
  8003e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003e4:	eb c6                	jmp    8003ac <printnum+0x73>

008003e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ec:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8003ef:	8b 10                	mov    (%eax),%edx
  8003f1:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f4:	73 0a                	jae    800400 <sprintputch+0x1a>
		*b->buf++ = ch;
  8003f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f9:	89 08                	mov    %ecx,(%eax)
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	88 02                	mov    %al,(%edx)
}
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    

00800402 <printfmt>:
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800408:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040b:	50                   	push   %eax
  80040c:	ff 75 10             	pushl  0x10(%ebp)
  80040f:	ff 75 0c             	pushl  0xc(%ebp)
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 05 00 00 00       	call   80041f <vprintfmt>
}
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	c9                   	leave  
  80041e:	c3                   	ret    

0080041f <vprintfmt>:
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	57                   	push   %edi
  800423:	56                   	push   %esi
  800424:	53                   	push   %ebx
  800425:	83 ec 2c             	sub    $0x2c,%esp
  800428:	8b 75 08             	mov    0x8(%ebp),%esi
  80042b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80042e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800431:	e9 ae 03 00 00       	jmp    8007e4 <vprintfmt+0x3c5>
  800436:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80043a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800441:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800448:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80044f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800454:	8d 47 01             	lea    0x1(%edi),%eax
  800457:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045a:	8a 17                	mov    (%edi),%dl
  80045c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80045f:	3c 55                	cmp    $0x55,%al
  800461:	0f 87 fe 03 00 00    	ja     800865 <vprintfmt+0x446>
  800467:	0f b6 c0             	movzbl %al,%eax
  80046a:	ff 24 85 c0 2b 80 00 	jmp    *0x802bc0(,%eax,4)
  800471:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800474:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800478:	eb da                	jmp    800454 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80047d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800481:	eb d1                	jmp    800454 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800483:	0f b6 d2             	movzbl %dl,%edx
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800491:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800494:	01 c0                	add    %eax,%eax
  800496:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  80049a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80049d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a0:	83 f9 09             	cmp    $0x9,%ecx
  8004a3:	77 52                	ja     8004f7 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8004a5:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8004a6:	eb e9                	jmp    800491 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	8d 40 04             	lea    0x4(%eax),%eax
  8004b6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c0:	79 92                	jns    800454 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004cf:	eb 83                	jmp    800454 <vprintfmt+0x35>
  8004d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d5:	78 08                	js     8004df <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004da:	e9 75 ff ff ff       	jmp    800454 <vprintfmt+0x35>
  8004df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004e6:	eb ef                	jmp    8004d7 <vprintfmt+0xb8>
  8004e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004eb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004f2:	e9 5d ff ff ff       	jmp    800454 <vprintfmt+0x35>
  8004f7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004fd:	eb bd                	jmp    8004bc <vprintfmt+0x9d>
			lflag++;
  8004ff:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800503:	e9 4c ff ff ff       	jmp    800454 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8d 78 04             	lea    0x4(%eax),%edi
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	53                   	push   %ebx
  800512:	ff 30                	pushl  (%eax)
  800514:	ff d6                	call   *%esi
			break;
  800516:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800519:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80051c:	e9 c0 02 00 00       	jmp    8007e1 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8d 78 04             	lea    0x4(%eax),%edi
  800527:	8b 00                	mov    (%eax),%eax
  800529:	85 c0                	test   %eax,%eax
  80052b:	78 2a                	js     800557 <vprintfmt+0x138>
  80052d:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80052f:	83 f8 0f             	cmp    $0xf,%eax
  800532:	7f 27                	jg     80055b <vprintfmt+0x13c>
  800534:	8b 04 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%eax
  80053b:	85 c0                	test   %eax,%eax
  80053d:	74 1c                	je     80055b <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80053f:	50                   	push   %eax
  800540:	68 48 2e 80 00       	push   $0x802e48
  800545:	53                   	push   %ebx
  800546:	56                   	push   %esi
  800547:	e8 b6 fe ff ff       	call   800402 <printfmt>
  80054c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800552:	e9 8a 02 00 00       	jmp    8007e1 <vprintfmt+0x3c2>
  800557:	f7 d8                	neg    %eax
  800559:	eb d2                	jmp    80052d <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80055b:	52                   	push   %edx
  80055c:	68 93 2a 80 00       	push   $0x802a93
  800561:	53                   	push   %ebx
  800562:	56                   	push   %esi
  800563:	e8 9a fe ff ff       	call   800402 <printfmt>
  800568:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80056e:	e9 6e 02 00 00       	jmp    8007e1 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	83 c0 04             	add    $0x4,%eax
  800579:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 38                	mov    (%eax),%edi
  800581:	85 ff                	test   %edi,%edi
  800583:	74 39                	je     8005be <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800585:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800589:	0f 8e a9 00 00 00    	jle    800638 <vprintfmt+0x219>
  80058f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800593:	0f 84 a7 00 00 00    	je     800640 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	ff 75 d0             	pushl  -0x30(%ebp)
  80059f:	57                   	push   %edi
  8005a0:	e8 6b 03 00 00       	call   800910 <strnlen>
  8005a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a8:	29 c1                	sub    %eax,%ecx
  8005aa:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005ad:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005b0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005ba:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bc:	eb 14                	jmp    8005d2 <vprintfmt+0x1b3>
				p = "(null)";
  8005be:	bf 8c 2a 80 00       	mov    $0x802a8c,%edi
  8005c3:	eb c0                	jmp    800585 <vprintfmt+0x166>
					putch(padc, putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8005cc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ce:	4f                   	dec    %edi
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	85 ff                	test   %edi,%edi
  8005d4:	7f ef                	jg     8005c5 <vprintfmt+0x1a6>
  8005d6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005d9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005dc:	89 c8                	mov    %ecx,%eax
  8005de:	85 c9                	test   %ecx,%ecx
  8005e0:	78 10                	js     8005f2 <vprintfmt+0x1d3>
  8005e2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005e5:	29 c1                	sub    %eax,%ecx
  8005e7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005ea:	89 75 08             	mov    %esi,0x8(%ebp)
  8005ed:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005f0:	eb 15                	jmp    800607 <vprintfmt+0x1e8>
  8005f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f7:	eb e9                	jmp    8005e2 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	53                   	push   %ebx
  8005fd:	52                   	push   %edx
  8005fe:	ff 55 08             	call   *0x8(%ebp)
  800601:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800604:	ff 4d e0             	decl   -0x20(%ebp)
  800607:	47                   	inc    %edi
  800608:	8a 47 ff             	mov    -0x1(%edi),%al
  80060b:	0f be d0             	movsbl %al,%edx
  80060e:	85 d2                	test   %edx,%edx
  800610:	74 59                	je     80066b <vprintfmt+0x24c>
  800612:	85 f6                	test   %esi,%esi
  800614:	78 03                	js     800619 <vprintfmt+0x1fa>
  800616:	4e                   	dec    %esi
  800617:	78 2f                	js     800648 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800619:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061d:	74 da                	je     8005f9 <vprintfmt+0x1da>
  80061f:	0f be c0             	movsbl %al,%eax
  800622:	83 e8 20             	sub    $0x20,%eax
  800625:	83 f8 5e             	cmp    $0x5e,%eax
  800628:	76 cf                	jbe    8005f9 <vprintfmt+0x1da>
					putch('?', putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	53                   	push   %ebx
  80062e:	6a 3f                	push   $0x3f
  800630:	ff 55 08             	call   *0x8(%ebp)
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	eb cc                	jmp    800604 <vprintfmt+0x1e5>
  800638:	89 75 08             	mov    %esi,0x8(%ebp)
  80063b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80063e:	eb c7                	jmp    800607 <vprintfmt+0x1e8>
  800640:	89 75 08             	mov    %esi,0x8(%ebp)
  800643:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800646:	eb bf                	jmp    800607 <vprintfmt+0x1e8>
  800648:	8b 75 08             	mov    0x8(%ebp),%esi
  80064b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80064e:	eb 0c                	jmp    80065c <vprintfmt+0x23d>
				putch(' ', putdat);
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	53                   	push   %ebx
  800654:	6a 20                	push   $0x20
  800656:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800658:	4f                   	dec    %edi
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	85 ff                	test   %edi,%edi
  80065e:	7f f0                	jg     800650 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800660:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
  800666:	e9 76 01 00 00       	jmp    8007e1 <vprintfmt+0x3c2>
  80066b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80066e:	8b 75 08             	mov    0x8(%ebp),%esi
  800671:	eb e9                	jmp    80065c <vprintfmt+0x23d>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7f 1f                	jg     800697 <vprintfmt+0x278>
	else if (lflag)
  800678:	85 c9                	test   %ecx,%ecx
  80067a:	75 48                	jne    8006c4 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 c1                	mov    %eax,%ecx
  800686:	c1 f9 1f             	sar    $0x1f,%ecx
  800689:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
  800695:	eb 17                	jmp    8006ae <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 50 04             	mov    0x4(%eax),%edx
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8d 40 08             	lea    0x8(%eax),%eax
  8006ab:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8006b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b8:	78 25                	js     8006df <vprintfmt+0x2c0>
			base = 10;
  8006ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bf:	e9 03 01 00 00       	jmp    8007c7 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cc:	89 c1                	mov    %eax,%ecx
  8006ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
  8006dd:	eb cf                	jmp    8006ae <vprintfmt+0x28f>
				putch('-', putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	6a 2d                	push   $0x2d
  8006e5:	ff d6                	call   *%esi
				num = -(long long) num;
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006ed:	f7 da                	neg    %edx
  8006ef:	83 d1 00             	adc    $0x0,%ecx
  8006f2:	f7 d9                	neg    %ecx
  8006f4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fc:	e9 c6 00 00 00       	jmp    8007c7 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800701:	83 f9 01             	cmp    $0x1,%ecx
  800704:	7f 1e                	jg     800724 <vprintfmt+0x305>
	else if (lflag)
  800706:	85 c9                	test   %ecx,%ecx
  800708:	75 32                	jne    80073c <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 10                	mov    (%eax),%edx
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800714:	8d 40 04             	lea    0x4(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071f:	e9 a3 00 00 00       	jmp    8007c7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 10                	mov    (%eax),%edx
  800729:	8b 48 04             	mov    0x4(%eax),%ecx
  80072c:	8d 40 08             	lea    0x8(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800732:	b8 0a 00 00 00       	mov    $0xa,%eax
  800737:	e9 8b 00 00 00       	jmp    8007c7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8b 10                	mov    (%eax),%edx
  800741:	b9 00 00 00 00       	mov    $0x0,%ecx
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800751:	eb 74                	jmp    8007c7 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800753:	83 f9 01             	cmp    $0x1,%ecx
  800756:	7f 1b                	jg     800773 <vprintfmt+0x354>
	else if (lflag)
  800758:	85 c9                	test   %ecx,%ecx
  80075a:	75 2c                	jne    800788 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 10                	mov    (%eax),%edx
  800761:	b9 00 00 00 00       	mov    $0x0,%ecx
  800766:	8d 40 04             	lea    0x4(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076c:	b8 08 00 00 00       	mov    $0x8,%eax
  800771:	eb 54                	jmp    8007c7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 10                	mov    (%eax),%edx
  800778:	8b 48 04             	mov    0x4(%eax),%ecx
  80077b:	8d 40 08             	lea    0x8(%eax),%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800781:	b8 08 00 00 00       	mov    $0x8,%eax
  800786:	eb 3f                	jmp    8007c7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 10                	mov    (%eax),%edx
  80078d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800798:	b8 08 00 00 00       	mov    $0x8,%eax
  80079d:	eb 28                	jmp    8007c7 <vprintfmt+0x3a8>
			putch('0', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	6a 30                	push   $0x30
  8007a5:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a7:	83 c4 08             	add    $0x8,%esp
  8007aa:	53                   	push   %ebx
  8007ab:	6a 78                	push   $0x78
  8007ad:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 10                	mov    (%eax),%edx
  8007b4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007b9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007c7:	83 ec 0c             	sub    $0xc,%esp
  8007ca:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007ce:	57                   	push   %edi
  8007cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	89 da                	mov    %ebx,%edx
  8007d7:	89 f0                	mov    %esi,%eax
  8007d9:	e8 5b fb ff ff       	call   800339 <printnum>
			break;
  8007de:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	47                   	inc    %edi
  8007e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e9:	83 f8 25             	cmp    $0x25,%eax
  8007ec:	0f 84 44 fc ff ff    	je     800436 <vprintfmt+0x17>
			if (ch == '\0')
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	0f 84 89 00 00 00    	je     800883 <vprintfmt+0x464>
			putch(ch, putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	53                   	push   %ebx
  8007fe:	50                   	push   %eax
  8007ff:	ff d6                	call   *%esi
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	eb de                	jmp    8007e4 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800806:	83 f9 01             	cmp    $0x1,%ecx
  800809:	7f 1b                	jg     800826 <vprintfmt+0x407>
	else if (lflag)
  80080b:	85 c9                	test   %ecx,%ecx
  80080d:	75 2c                	jne    80083b <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 10                	mov    (%eax),%edx
  800814:	b9 00 00 00 00       	mov    $0x0,%ecx
  800819:	8d 40 04             	lea    0x4(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081f:	b8 10 00 00 00       	mov    $0x10,%eax
  800824:	eb a1                	jmp    8007c7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8b 10                	mov    (%eax),%edx
  80082b:	8b 48 04             	mov    0x4(%eax),%ecx
  80082e:	8d 40 08             	lea    0x8(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800834:	b8 10 00 00 00       	mov    $0x10,%eax
  800839:	eb 8c                	jmp    8007c7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8b 10                	mov    (%eax),%edx
  800840:	b9 00 00 00 00       	mov    $0x0,%ecx
  800845:	8d 40 04             	lea    0x4(%eax),%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084b:	b8 10 00 00 00       	mov    $0x10,%eax
  800850:	e9 72 ff ff ff       	jmp    8007c7 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	53                   	push   %ebx
  800859:	6a 25                	push   $0x25
  80085b:	ff d6                	call   *%esi
			break;
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	e9 7c ff ff ff       	jmp    8007e1 <vprintfmt+0x3c2>
			putch('%', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	53                   	push   %ebx
  800869:	6a 25                	push   $0x25
  80086b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 f8                	mov    %edi,%eax
  800872:	eb 01                	jmp    800875 <vprintfmt+0x456>
  800874:	48                   	dec    %eax
  800875:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800879:	75 f9                	jne    800874 <vprintfmt+0x455>
  80087b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087e:	e9 5e ff ff ff       	jmp    8007e1 <vprintfmt+0x3c2>
}
  800883:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800886:	5b                   	pop    %ebx
  800887:	5e                   	pop    %esi
  800888:	5f                   	pop    %edi
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	83 ec 18             	sub    $0x18,%esp
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800897:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80089a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a8:	85 c0                	test   %eax,%eax
  8008aa:	74 26                	je     8008d2 <vsnprintf+0x47>
  8008ac:	85 d2                	test   %edx,%edx
  8008ae:	7e 29                	jle    8008d9 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b0:	ff 75 14             	pushl  0x14(%ebp)
  8008b3:	ff 75 10             	pushl  0x10(%ebp)
  8008b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b9:	50                   	push   %eax
  8008ba:	68 e6 03 80 00       	push   $0x8003e6
  8008bf:	e8 5b fb ff ff       	call   80041f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    
		return -E_INVAL;
  8008d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d7:	eb f7                	jmp    8008d0 <vsnprintf+0x45>
  8008d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008de:	eb f0                	jmp    8008d0 <vsnprintf+0x45>

008008e0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e9:	50                   	push   %eax
  8008ea:	ff 75 10             	pushl  0x10(%ebp)
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	ff 75 08             	pushl  0x8(%ebp)
  8008f3:	e8 93 ff ff ff       	call   80088b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f8:	c9                   	leave  
  8008f9:	c3                   	ret    

008008fa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800900:	b8 00 00 00 00       	mov    $0x0,%eax
  800905:	eb 01                	jmp    800908 <strlen+0xe>
		n++;
  800907:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800908:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090c:	75 f9                	jne    800907 <strlen+0xd>
	return n;
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800919:	b8 00 00 00 00       	mov    $0x0,%eax
  80091e:	eb 01                	jmp    800921 <strnlen+0x11>
		n++;
  800920:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800921:	39 d0                	cmp    %edx,%eax
  800923:	74 06                	je     80092b <strnlen+0x1b>
  800925:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800929:	75 f5                	jne    800920 <strnlen+0x10>
	return n;
}
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800937:	89 c2                	mov    %eax,%edx
  800939:	42                   	inc    %edx
  80093a:	41                   	inc    %ecx
  80093b:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80093e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800941:	84 db                	test   %bl,%bl
  800943:	75 f4                	jne    800939 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800945:	5b                   	pop    %ebx
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	53                   	push   %ebx
  80094c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80094f:	53                   	push   %ebx
  800950:	e8 a5 ff ff ff       	call   8008fa <strlen>
  800955:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	01 d8                	add    %ebx,%eax
  80095d:	50                   	push   %eax
  80095e:	e8 ca ff ff ff       	call   80092d <strcpy>
	return dst;
}
  800963:	89 d8                	mov    %ebx,%eax
  800965:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	56                   	push   %esi
  80096e:	53                   	push   %ebx
  80096f:	8b 75 08             	mov    0x8(%ebp),%esi
  800972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800975:	89 f3                	mov    %esi,%ebx
  800977:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80097a:	89 f2                	mov    %esi,%edx
  80097c:	eb 0c                	jmp    80098a <strncpy+0x20>
		*dst++ = *src;
  80097e:	42                   	inc    %edx
  80097f:	8a 01                	mov    (%ecx),%al
  800981:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800984:	80 39 01             	cmpb   $0x1,(%ecx)
  800987:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80098a:	39 da                	cmp    %ebx,%edx
  80098c:	75 f0                	jne    80097e <strncpy+0x14>
	}
	return ret;
}
  80098e:	89 f0                	mov    %esi,%eax
  800990:	5b                   	pop    %ebx
  800991:	5e                   	pop    %esi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	8b 75 08             	mov    0x8(%ebp),%esi
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099f:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a2:	85 c0                	test   %eax,%eax
  8009a4:	74 20                	je     8009c6 <strlcpy+0x32>
  8009a6:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8009aa:	89 f0                	mov    %esi,%eax
  8009ac:	eb 05                	jmp    8009b3 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009ae:	40                   	inc    %eax
  8009af:	42                   	inc    %edx
  8009b0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009b3:	39 d8                	cmp    %ebx,%eax
  8009b5:	74 06                	je     8009bd <strlcpy+0x29>
  8009b7:	8a 0a                	mov    (%edx),%cl
  8009b9:	84 c9                	test   %cl,%cl
  8009bb:	75 f1                	jne    8009ae <strlcpy+0x1a>
		*dst = '\0';
  8009bd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009c0:	29 f0                	sub    %esi,%eax
}
  8009c2:	5b                   	pop    %ebx
  8009c3:	5e                   	pop    %esi
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    
  8009c6:	89 f0                	mov    %esi,%eax
  8009c8:	eb f6                	jmp    8009c0 <strlcpy+0x2c>

008009ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009d3:	eb 02                	jmp    8009d7 <strcmp+0xd>
		p++, q++;
  8009d5:	41                   	inc    %ecx
  8009d6:	42                   	inc    %edx
	while (*p && *p == *q)
  8009d7:	8a 01                	mov    (%ecx),%al
  8009d9:	84 c0                	test   %al,%al
  8009db:	74 04                	je     8009e1 <strcmp+0x17>
  8009dd:	3a 02                	cmp    (%edx),%al
  8009df:	74 f4                	je     8009d5 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e1:	0f b6 c0             	movzbl %al,%eax
  8009e4:	0f b6 12             	movzbl (%edx),%edx
  8009e7:	29 d0                	sub    %edx,%eax
}
  8009e9:	5d                   	pop    %ebp
  8009ea:	c3                   	ret    

008009eb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	53                   	push   %ebx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f5:	89 c3                	mov    %eax,%ebx
  8009f7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009fa:	eb 02                	jmp    8009fe <strncmp+0x13>
		n--, p++, q++;
  8009fc:	40                   	inc    %eax
  8009fd:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8009fe:	39 d8                	cmp    %ebx,%eax
  800a00:	74 15                	je     800a17 <strncmp+0x2c>
  800a02:	8a 08                	mov    (%eax),%cl
  800a04:	84 c9                	test   %cl,%cl
  800a06:	74 04                	je     800a0c <strncmp+0x21>
  800a08:	3a 0a                	cmp    (%edx),%cl
  800a0a:	74 f0                	je     8009fc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0c:	0f b6 00             	movzbl (%eax),%eax
  800a0f:	0f b6 12             	movzbl (%edx),%edx
  800a12:	29 d0                	sub    %edx,%eax
}
  800a14:	5b                   	pop    %ebx
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    
		return 0;
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1c:	eb f6                	jmp    800a14 <strncmp+0x29>

00800a1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a27:	8a 10                	mov    (%eax),%dl
  800a29:	84 d2                	test   %dl,%dl
  800a2b:	74 07                	je     800a34 <strchr+0x16>
		if (*s == c)
  800a2d:	38 ca                	cmp    %cl,%dl
  800a2f:	74 08                	je     800a39 <strchr+0x1b>
	for (; *s; s++)
  800a31:	40                   	inc    %eax
  800a32:	eb f3                	jmp    800a27 <strchr+0x9>
			return (char *) s;
	return 0;
  800a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a44:	8a 10                	mov    (%eax),%dl
  800a46:	84 d2                	test   %dl,%dl
  800a48:	74 07                	je     800a51 <strfind+0x16>
		if (*s == c)
  800a4a:	38 ca                	cmp    %cl,%dl
  800a4c:	74 03                	je     800a51 <strfind+0x16>
	for (; *s; s++)
  800a4e:	40                   	inc    %eax
  800a4f:	eb f3                	jmp    800a44 <strfind+0x9>
			break;
	return (char *) s;
}
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	57                   	push   %edi
  800a57:	56                   	push   %esi
  800a58:	53                   	push   %ebx
  800a59:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5f:	85 c9                	test   %ecx,%ecx
  800a61:	74 13                	je     800a76 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a63:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a69:	75 05                	jne    800a70 <memset+0x1d>
  800a6b:	f6 c1 03             	test   $0x3,%cl
  800a6e:	74 0d                	je     800a7d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	fc                   	cld    
  800a74:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a76:	89 f8                	mov    %edi,%eax
  800a78:	5b                   	pop    %ebx
  800a79:	5e                   	pop    %esi
  800a7a:	5f                   	pop    %edi
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    
		c &= 0xFF;
  800a7d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a81:	89 d3                	mov    %edx,%ebx
  800a83:	c1 e3 08             	shl    $0x8,%ebx
  800a86:	89 d0                	mov    %edx,%eax
  800a88:	c1 e0 18             	shl    $0x18,%eax
  800a8b:	89 d6                	mov    %edx,%esi
  800a8d:	c1 e6 10             	shl    $0x10,%esi
  800a90:	09 f0                	or     %esi,%eax
  800a92:	09 c2                	or     %eax,%edx
  800a94:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a96:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a99:	89 d0                	mov    %edx,%eax
  800a9b:	fc                   	cld    
  800a9c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a9e:	eb d6                	jmp    800a76 <memset+0x23>

00800aa0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	57                   	push   %edi
  800aa4:	56                   	push   %esi
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aae:	39 c6                	cmp    %eax,%esi
  800ab0:	73 33                	jae    800ae5 <memmove+0x45>
  800ab2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab5:	39 d0                	cmp    %edx,%eax
  800ab7:	73 2c                	jae    800ae5 <memmove+0x45>
		s += n;
		d += n;
  800ab9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abc:	89 d6                	mov    %edx,%esi
  800abe:	09 fe                	or     %edi,%esi
  800ac0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac6:	75 13                	jne    800adb <memmove+0x3b>
  800ac8:	f6 c1 03             	test   $0x3,%cl
  800acb:	75 0e                	jne    800adb <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800acd:	83 ef 04             	sub    $0x4,%edi
  800ad0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad6:	fd                   	std    
  800ad7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad9:	eb 07                	jmp    800ae2 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800adb:	4f                   	dec    %edi
  800adc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800adf:	fd                   	std    
  800ae0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae2:	fc                   	cld    
  800ae3:	eb 13                	jmp    800af8 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae5:	89 f2                	mov    %esi,%edx
  800ae7:	09 c2                	or     %eax,%edx
  800ae9:	f6 c2 03             	test   $0x3,%dl
  800aec:	75 05                	jne    800af3 <memmove+0x53>
  800aee:	f6 c1 03             	test   $0x3,%cl
  800af1:	74 09                	je     800afc <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800af3:	89 c7                	mov    %eax,%edi
  800af5:	fc                   	cld    
  800af6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af8:	5e                   	pop    %esi
  800af9:	5f                   	pop    %edi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800afc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aff:	89 c7                	mov    %eax,%edi
  800b01:	fc                   	cld    
  800b02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b04:	eb f2                	jmp    800af8 <memmove+0x58>

00800b06 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b09:	ff 75 10             	pushl  0x10(%ebp)
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	ff 75 08             	pushl  0x8(%ebp)
  800b12:	e8 89 ff ff ff       	call   800aa0 <memmove>
}
  800b17:	c9                   	leave  
  800b18:	c3                   	ret    

00800b19 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	89 c6                	mov    %eax,%esi
  800b23:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800b29:	39 f0                	cmp    %esi,%eax
  800b2b:	74 16                	je     800b43 <memcmp+0x2a>
		if (*s1 != *s2)
  800b2d:	8a 08                	mov    (%eax),%cl
  800b2f:	8a 1a                	mov    (%edx),%bl
  800b31:	38 d9                	cmp    %bl,%cl
  800b33:	75 04                	jne    800b39 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b35:	40                   	inc    %eax
  800b36:	42                   	inc    %edx
  800b37:	eb f0                	jmp    800b29 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b39:	0f b6 c1             	movzbl %cl,%eax
  800b3c:	0f b6 db             	movzbl %bl,%ebx
  800b3f:	29 d8                	sub    %ebx,%eax
  800b41:	eb 05                	jmp    800b48 <memcmp+0x2f>
	}

	return 0;
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b55:	89 c2                	mov    %eax,%edx
  800b57:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b5a:	39 d0                	cmp    %edx,%eax
  800b5c:	73 07                	jae    800b65 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5e:	38 08                	cmp    %cl,(%eax)
  800b60:	74 03                	je     800b65 <memfind+0x19>
	for (; s < ends; s++)
  800b62:	40                   	inc    %eax
  800b63:	eb f5                	jmp    800b5a <memfind+0xe>
			break;
	return (void *) s;
}
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b70:	eb 01                	jmp    800b73 <strtol+0xc>
		s++;
  800b72:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800b73:	8a 01                	mov    (%ecx),%al
  800b75:	3c 20                	cmp    $0x20,%al
  800b77:	74 f9                	je     800b72 <strtol+0xb>
  800b79:	3c 09                	cmp    $0x9,%al
  800b7b:	74 f5                	je     800b72 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800b7d:	3c 2b                	cmp    $0x2b,%al
  800b7f:	74 2b                	je     800bac <strtol+0x45>
		s++;
	else if (*s == '-')
  800b81:	3c 2d                	cmp    $0x2d,%al
  800b83:	74 2f                	je     800bb4 <strtol+0x4d>
	int neg = 0;
  800b85:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8a:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800b91:	75 12                	jne    800ba5 <strtol+0x3e>
  800b93:	80 39 30             	cmpb   $0x30,(%ecx)
  800b96:	74 24                	je     800bbc <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b9c:	75 07                	jne    800ba5 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  800baa:	eb 4e                	jmp    800bfa <strtol+0x93>
		s++;
  800bac:	41                   	inc    %ecx
	int neg = 0;
  800bad:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb2:	eb d6                	jmp    800b8a <strtol+0x23>
		s++, neg = 1;
  800bb4:	41                   	inc    %ecx
  800bb5:	bf 01 00 00 00       	mov    $0x1,%edi
  800bba:	eb ce                	jmp    800b8a <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bc0:	74 10                	je     800bd2 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800bc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc6:	75 dd                	jne    800ba5 <strtol+0x3e>
		s++, base = 8;
  800bc8:	41                   	inc    %ecx
  800bc9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800bd0:	eb d3                	jmp    800ba5 <strtol+0x3e>
		s += 2, base = 16;
  800bd2:	83 c1 02             	add    $0x2,%ecx
  800bd5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800bdc:	eb c7                	jmp    800ba5 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bde:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be1:	89 f3                	mov    %esi,%ebx
  800be3:	80 fb 19             	cmp    $0x19,%bl
  800be6:	77 24                	ja     800c0c <strtol+0xa5>
			dig = *s - 'a' + 10;
  800be8:	0f be d2             	movsbl %dl,%edx
  800beb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bee:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf1:	7d 2b                	jge    800c1e <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800bf3:	41                   	inc    %ecx
  800bf4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bf8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bfa:	8a 11                	mov    (%ecx),%dl
  800bfc:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800bff:	80 fb 09             	cmp    $0x9,%bl
  800c02:	77 da                	ja     800bde <strtol+0x77>
			dig = *s - '0';
  800c04:	0f be d2             	movsbl %dl,%edx
  800c07:	83 ea 30             	sub    $0x30,%edx
  800c0a:	eb e2                	jmp    800bee <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800c0c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c0f:	89 f3                	mov    %esi,%ebx
  800c11:	80 fb 19             	cmp    $0x19,%bl
  800c14:	77 08                	ja     800c1e <strtol+0xb7>
			dig = *s - 'A' + 10;
  800c16:	0f be d2             	movsbl %dl,%edx
  800c19:	83 ea 37             	sub    $0x37,%edx
  800c1c:	eb d0                	jmp    800bee <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c22:	74 05                	je     800c29 <strtol+0xc2>
		*endptr = (char *) s;
  800c24:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c27:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c29:	85 ff                	test   %edi,%edi
  800c2b:	74 02                	je     800c2f <strtol+0xc8>
  800c2d:	f7 d8                	neg    %eax
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <atoi>:

int
atoi(const char *s)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800c37:	6a 0a                	push   $0xa
  800c39:	6a 00                	push   $0x0
  800c3b:	ff 75 08             	pushl  0x8(%ebp)
  800c3e:	e8 24 ff ff ff       	call   800b67 <strtol>
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c53:	8b 55 08             	mov    0x8(%ebp),%edx
  800c56:	89 c3                	mov    %eax,%ebx
  800c58:	89 c7                	mov    %eax,%edi
  800c5a:	89 c6                	mov    %eax,%esi
  800c5c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c90:	b8 03 00 00 00       	mov    $0x3,%eax
  800c95:	8b 55 08             	mov    0x8(%ebp),%edx
  800c98:	89 cb                	mov    %ecx,%ebx
  800c9a:	89 cf                	mov    %ecx,%edi
  800c9c:	89 ce                	mov    %ecx,%esi
  800c9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	7f 08                	jg     800cac <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	50                   	push   %eax
  800cb0:	6a 03                	push   $0x3
  800cb2:	68 7f 2d 80 00       	push   $0x802d7f
  800cb7:	6a 23                	push   $0x23
  800cb9:	68 9c 2d 80 00       	push   $0x802d9c
  800cbe:	e8 4f f5 ff ff       	call   800212 <_panic>

00800cc3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd3:	89 d1                	mov    %edx,%ecx
  800cd5:	89 d3                	mov    %edx,%ebx
  800cd7:	89 d7                	mov    %edx,%edi
  800cd9:	89 d6                	mov    %edx,%esi
  800cdb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	be 00 00 00 00       	mov    $0x0,%esi
  800cf0:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfe:	89 f7                	mov    %esi,%edi
  800d00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d02:	85 c0                	test   %eax,%eax
  800d04:	7f 08                	jg     800d0e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0e:	83 ec 0c             	sub    $0xc,%esp
  800d11:	50                   	push   %eax
  800d12:	6a 04                	push   $0x4
  800d14:	68 7f 2d 80 00       	push   $0x802d7f
  800d19:	6a 23                	push   $0x23
  800d1b:	68 9c 2d 80 00       	push   $0x802d9c
  800d20:	e8 ed f4 ff ff       	call   800212 <_panic>

00800d25 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d3f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d44:	85 c0                	test   %eax,%eax
  800d46:	7f 08                	jg     800d50 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d50:	83 ec 0c             	sub    $0xc,%esp
  800d53:	50                   	push   %eax
  800d54:	6a 05                	push   $0x5
  800d56:	68 7f 2d 80 00       	push   $0x802d7f
  800d5b:	6a 23                	push   $0x23
  800d5d:	68 9c 2d 80 00       	push   $0x802d9c
  800d62:	e8 ab f4 ff ff       	call   800212 <_panic>

00800d67 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d75:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d80:	89 df                	mov    %ebx,%edi
  800d82:	89 de                	mov    %ebx,%esi
  800d84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d86:	85 c0                	test   %eax,%eax
  800d88:	7f 08                	jg     800d92 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d96:	6a 06                	push   $0x6
  800d98:	68 7f 2d 80 00       	push   $0x802d7f
  800d9d:	6a 23                	push   $0x23
  800d9f:	68 9c 2d 80 00       	push   $0x802d9c
  800da4:	e8 69 f4 ff ff       	call   800212 <_panic>

00800da9 <sys_yield>:

void
sys_yield(void)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800daf:	ba 00 00 00 00       	mov    $0x0,%edx
  800db4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db9:	89 d1                	mov    %edx,%ecx
  800dbb:	89 d3                	mov    %edx,%ebx
  800dbd:	89 d7                	mov    %edx,%edi
  800dbf:	89 d6                	mov    %edx,%esi
  800dc1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd6:	b8 08 00 00 00       	mov    $0x8,%eax
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 08                	push   $0x8
  800df9:	68 7f 2d 80 00       	push   $0x802d7f
  800dfe:	6a 23                	push   $0x23
  800e00:	68 9c 2d 80 00       	push   $0x802d9c
  800e05:	e8 08 f4 ff ff       	call   800212 <_panic>

00800e0a <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e18:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e20:	89 cb                	mov    %ecx,%ebx
  800e22:	89 cf                	mov    %ecx,%edi
  800e24:	89 ce                	mov    %ecx,%esi
  800e26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	7f 08                	jg     800e34 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	50                   	push   %eax
  800e38:	6a 0c                	push   $0xc
  800e3a:	68 7f 2d 80 00       	push   $0x802d7f
  800e3f:	6a 23                	push   $0x23
  800e41:	68 9c 2d 80 00       	push   $0x802d9c
  800e46:	e8 c7 f3 ff ff       	call   800212 <_panic>

00800e4b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	8b 55 08             	mov    0x8(%ebp),%edx
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7f 08                	jg     800e76 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	83 ec 0c             	sub    $0xc,%esp
  800e79:	50                   	push   %eax
  800e7a:	6a 09                	push   $0x9
  800e7c:	68 7f 2d 80 00       	push   $0x802d7f
  800e81:	6a 23                	push   $0x23
  800e83:	68 9c 2d 80 00       	push   $0x802d9c
  800e88:	e8 85 f3 ff ff       	call   800212 <_panic>

00800e8d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7f 08                	jg     800eb8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb8:	83 ec 0c             	sub    $0xc,%esp
  800ebb:	50                   	push   %eax
  800ebc:	6a 0a                	push   $0xa
  800ebe:	68 7f 2d 80 00       	push   $0x802d7f
  800ec3:	6a 23                	push   $0x23
  800ec5:	68 9c 2d 80 00       	push   $0x802d9c
  800eca:	e8 43 f3 ff ff       	call   800212 <_panic>

00800ecf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed5:	be 00 00 00 00       	mov    $0x0,%esi
  800eda:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eeb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f00:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	89 cb                	mov    %ecx,%ebx
  800f0a:	89 cf                	mov    %ecx,%edi
  800f0c:	89 ce                	mov    %ecx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	6a 0e                	push   $0xe
  800f22:	68 7f 2d 80 00       	push   $0x802d7f
  800f27:	6a 23                	push   $0x23
  800f29:	68 9c 2d 80 00       	push   $0x802d9c
  800f2e:	e8 df f2 ff ff       	call   800212 <_panic>

00800f33 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f39:	be 00 00 00 00       	mov    $0x0,%esi
  800f3e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4c:	89 f7                	mov    %esi,%edi
  800f4e:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5b:	be 00 00 00 00       	mov    $0x0,%esi
  800f60:	b8 10 00 00 00       	mov    $0x10,%eax
  800f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f68:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6e:	89 f7                	mov    %esi,%edi
  800f70:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f82:	b8 11 00 00 00       	mov    $0x11,%eax
  800f87:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8a:	89 cb                	mov    %ecx,%ebx
  800f8c:	89 cf                	mov    %ecx,%edi
  800f8e:	89 ce                	mov    %ecx,%esi
  800f90:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800f92:	5b                   	pop    %ebx
  800f93:	5e                   	pop    %esi
  800f94:	5f                   	pop    %edi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f9f:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800fa1:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fa5:	0f 84 84 00 00 00    	je     80102f <pgfault+0x98>
  800fab:	89 d8                	mov    %ebx,%eax
  800fad:	c1 e8 16             	shr    $0x16,%eax
  800fb0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fb7:	a8 01                	test   $0x1,%al
  800fb9:	74 74                	je     80102f <pgfault+0x98>
  800fbb:	89 d8                	mov    %ebx,%eax
  800fbd:	c1 e8 0c             	shr    $0xc,%eax
  800fc0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fc7:	f6 c4 08             	test   $0x8,%ah
  800fca:	74 63                	je     80102f <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800fcc:	e8 f2 fc ff ff       	call   800cc3 <sys_getenvid>
  800fd1:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800fd3:	83 ec 04             	sub    $0x4,%esp
  800fd6:	6a 07                	push   $0x7
  800fd8:	68 00 f0 7f 00       	push   $0x7ff000
  800fdd:	50                   	push   %eax
  800fde:	e8 ff fc ff ff       	call   800ce2 <sys_page_alloc>
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 5b                	js     801045 <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  800fea:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  800ff0:	83 ec 04             	sub    $0x4,%esp
  800ff3:	68 00 10 00 00       	push   $0x1000
  800ff8:	53                   	push   %ebx
  800ff9:	68 00 f0 7f 00       	push   $0x7ff000
  800ffe:	e8 03 fb ff ff       	call   800b06 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  801003:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80100a:	53                   	push   %ebx
  80100b:	56                   	push   %esi
  80100c:	68 00 f0 7f 00       	push   $0x7ff000
  801011:	56                   	push   %esi
  801012:	e8 0e fd ff ff       	call   800d25 <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  801017:	83 c4 18             	add    $0x18,%esp
  80101a:	68 00 f0 7f 00       	push   $0x7ff000
  80101f:	56                   	push   %esi
  801020:	e8 42 fd ff ff       	call   800d67 <sys_page_unmap>

}
  801025:	83 c4 10             	add    $0x10,%esp
  801028:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  80102f:	68 ac 2d 80 00       	push   $0x802dac
  801034:	68 36 2e 80 00       	push   $0x802e36
  801039:	6a 1c                	push   $0x1c
  80103b:	68 4b 2e 80 00       	push   $0x802e4b
  801040:	e8 cd f1 ff ff       	call   800212 <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  801045:	68 fc 2d 80 00       	push   $0x802dfc
  80104a:	68 36 2e 80 00       	push   $0x802e36
  80104f:	6a 26                	push   $0x26
  801051:	68 4b 2e 80 00       	push   $0x802e4b
  801056:	e8 b7 f1 ff ff       	call   800212 <_panic>

0080105b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
  801061:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801064:	68 97 0f 80 00       	push   $0x800f97
  801069:	e8 f6 14 00 00       	call   802564 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80106e:	b8 07 00 00 00       	mov    $0x7,%eax
  801073:	cd 30                	int    $0x30
  801075:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  80107b:	83 c4 10             	add    $0x10,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	0f 88 58 01 00 00    	js     8011de <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  801086:	85 c0                	test   %eax,%eax
  801088:	74 07                	je     801091 <fork+0x36>
  80108a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108f:	eb 72                	jmp    801103 <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  801091:	e8 2d fc ff ff       	call   800cc3 <sys_getenvid>
  801096:	25 ff 03 00 00       	and    $0x3ff,%eax
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	c1 e2 05             	shl    $0x5,%edx
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8010a9:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  8010ae:	e9 20 01 00 00       	jmp    8011d3 <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  8010b3:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  8010ba:	e8 04 fc ff ff       	call   800cc3 <sys_getenvid>
  8010bf:	83 ec 0c             	sub    $0xc,%esp
  8010c2:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  8010c8:	57                   	push   %edi
  8010c9:	56                   	push   %esi
  8010ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010cd:	56                   	push   %esi
  8010ce:	50                   	push   %eax
  8010cf:	e8 51 fc ff ff       	call   800d25 <sys_page_map>
  8010d4:	83 c4 20             	add    $0x20,%esp
  8010d7:	eb 18                	jmp    8010f1 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  8010d9:	e8 e5 fb ff ff       	call   800cc3 <sys_getenvid>
  8010de:	83 ec 0c             	sub    $0xc,%esp
  8010e1:	6a 05                	push   $0x5
  8010e3:	56                   	push   %esi
  8010e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e7:	56                   	push   %esi
  8010e8:	50                   	push   %eax
  8010e9:	e8 37 fc ff ff       	call   800d25 <sys_page_map>
  8010ee:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  8010f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010f7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010fd:	0f 84 8f 00 00 00    	je     801192 <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  801103:	89 d8                	mov    %ebx,%eax
  801105:	c1 e8 16             	shr    $0x16,%eax
  801108:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80110f:	a8 01                	test   $0x1,%al
  801111:	74 de                	je     8010f1 <fork+0x96>
  801113:	89 d8                	mov    %ebx,%eax
  801115:	c1 e8 0c             	shr    $0xc,%eax
  801118:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80111f:	a8 04                	test   $0x4,%al
  801121:	74 ce                	je     8010f1 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  801123:	89 de                	mov    %ebx,%esi
  801125:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  80112b:	89 f0                	mov    %esi,%eax
  80112d:	c1 e8 0c             	shr    $0xc,%eax
  801130:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801137:	f6 c6 04             	test   $0x4,%dh
  80113a:	0f 85 73 ff ff ff    	jne    8010b3 <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  801140:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801147:	a9 02 08 00 00       	test   $0x802,%eax
  80114c:	74 8b                	je     8010d9 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  80114e:	e8 70 fb ff ff       	call   800cc3 <sys_getenvid>
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	68 05 08 00 00       	push   $0x805
  80115b:	56                   	push   %esi
  80115c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80115f:	56                   	push   %esi
  801160:	50                   	push   %eax
  801161:	e8 bf fb ff ff       	call   800d25 <sys_page_map>
  801166:	83 c4 20             	add    $0x20,%esp
  801169:	85 c0                	test   %eax,%eax
  80116b:	78 84                	js     8010f1 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  80116d:	e8 51 fb ff ff       	call   800cc3 <sys_getenvid>
  801172:	89 c7                	mov    %eax,%edi
  801174:	e8 4a fb ff ff       	call   800cc3 <sys_getenvid>
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	68 05 08 00 00       	push   $0x805
  801181:	56                   	push   %esi
  801182:	57                   	push   %edi
  801183:	56                   	push   %esi
  801184:	50                   	push   %eax
  801185:	e8 9b fb ff ff       	call   800d25 <sys_page_map>
  80118a:	83 c4 20             	add    $0x20,%esp
  80118d:	e9 5f ff ff ff       	jmp    8010f1 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  801192:	83 ec 04             	sub    $0x4,%esp
  801195:	6a 07                	push   $0x7
  801197:	68 00 f0 bf ee       	push   $0xeebff000
  80119c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80119f:	57                   	push   %edi
  8011a0:	e8 3d fb ff ff       	call   800ce2 <sys_page_alloc>
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	78 3b                	js     8011e7 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	68 aa 25 80 00       	push   $0x8025aa
  8011b4:	57                   	push   %edi
  8011b5:	e8 d3 fc ff ff       	call   800e8d <sys_env_set_pgfault_upcall>
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	78 2f                	js     8011f0 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	6a 02                	push   $0x2
  8011c6:	57                   	push   %edi
  8011c7:	e8 fc fb ff ff       	call   800dc8 <sys_env_set_status>
	if (temp < 0) {
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	78 26                	js     8011f9 <fork+0x19e>
		return -1;
	}

	return childid;
}
  8011d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5e                   	pop    %esi
  8011db:	5f                   	pop    %edi
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    
		return -1;
  8011de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8011e5:	eb ec                	jmp    8011d3 <fork+0x178>
		return -1;
  8011e7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8011ee:	eb e3                	jmp    8011d3 <fork+0x178>
		return -1;
  8011f0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8011f7:	eb da                	jmp    8011d3 <fork+0x178>
		return -1;
  8011f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801200:	eb d1                	jmp    8011d3 <fork+0x178>

00801202 <sfork>:

// Challenge!
int
sfork(void)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801208:	68 56 2e 80 00       	push   $0x802e56
  80120d:	68 85 00 00 00       	push   $0x85
  801212:	68 4b 2e 80 00       	push   $0x802e4b
  801217:	e8 f6 ef ff ff       	call   800212 <_panic>

0080121c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	05 00 00 00 30       	add    $0x30000000,%eax
  801227:	c1 e8 0c             	shr    $0xc,%eax
}
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801237:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80123c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801249:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80124e:	89 c2                	mov    %eax,%edx
  801250:	c1 ea 16             	shr    $0x16,%edx
  801253:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80125a:	f6 c2 01             	test   $0x1,%dl
  80125d:	74 2a                	je     801289 <fd_alloc+0x46>
  80125f:	89 c2                	mov    %eax,%edx
  801261:	c1 ea 0c             	shr    $0xc,%edx
  801264:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80126b:	f6 c2 01             	test   $0x1,%dl
  80126e:	74 19                	je     801289 <fd_alloc+0x46>
  801270:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801275:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80127a:	75 d2                	jne    80124e <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80127c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801282:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801287:	eb 07                	jmp    801290 <fd_alloc+0x4d>
			*fd_store = fd;
  801289:	89 01                	mov    %eax,(%ecx)
			return 0;
  80128b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801295:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801299:	77 39                	ja     8012d4 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	c1 e0 0c             	shl    $0xc,%eax
  8012a1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012a6:	89 c2                	mov    %eax,%edx
  8012a8:	c1 ea 16             	shr    $0x16,%edx
  8012ab:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012b2:	f6 c2 01             	test   $0x1,%dl
  8012b5:	74 24                	je     8012db <fd_lookup+0x49>
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	c1 ea 0c             	shr    $0xc,%edx
  8012bc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012c3:	f6 c2 01             	test   $0x1,%dl
  8012c6:	74 1a                	je     8012e2 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cb:	89 02                	mov    %eax,(%edx)
	return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    
		return -E_INVAL;
  8012d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d9:	eb f7                	jmp    8012d2 <fd_lookup+0x40>
		return -E_INVAL;
  8012db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e0:	eb f0                	jmp    8012d2 <fd_lookup+0x40>
  8012e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e7:	eb e9                	jmp    8012d2 <fd_lookup+0x40>

008012e9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	ba e8 2e 80 00       	mov    $0x802ee8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012f7:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012fc:	39 08                	cmp    %ecx,(%eax)
  8012fe:	74 33                	je     801333 <dev_lookup+0x4a>
  801300:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801303:	8b 02                	mov    (%edx),%eax
  801305:	85 c0                	test   %eax,%eax
  801307:	75 f3                	jne    8012fc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801309:	a1 04 50 80 00       	mov    0x805004,%eax
  80130e:	8b 40 48             	mov    0x48(%eax),%eax
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	51                   	push   %ecx
  801315:	50                   	push   %eax
  801316:	68 6c 2e 80 00       	push   $0x802e6c
  80131b:	e8 05 f0 ff ff       	call   800325 <cprintf>
	*dev = 0;
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    
			*dev = devtab[i];
  801333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801336:	89 01                	mov    %eax,(%ecx)
			return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
  80133d:	eb f2                	jmp    801331 <dev_lookup+0x48>

0080133f <fd_close>:
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	57                   	push   %edi
  801343:	56                   	push   %esi
  801344:	53                   	push   %ebx
  801345:	83 ec 1c             	sub    $0x1c,%esp
  801348:	8b 75 08             	mov    0x8(%ebp),%esi
  80134b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80134e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801351:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801352:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801358:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80135b:	50                   	push   %eax
  80135c:	e8 31 ff ff ff       	call   801292 <fd_lookup>
  801361:	89 c7                	mov    %eax,%edi
  801363:	83 c4 08             	add    $0x8,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	78 05                	js     80136f <fd_close+0x30>
	    || fd != fd2)
  80136a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  80136d:	74 13                	je     801382 <fd_close+0x43>
		return (must_exist ? r : 0);
  80136f:	84 db                	test   %bl,%bl
  801371:	75 05                	jne    801378 <fd_close+0x39>
  801373:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801378:	89 f8                	mov    %edi,%eax
  80137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137d:	5b                   	pop    %ebx
  80137e:	5e                   	pop    %esi
  80137f:	5f                   	pop    %edi
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801382:	83 ec 08             	sub    $0x8,%esp
  801385:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801388:	50                   	push   %eax
  801389:	ff 36                	pushl  (%esi)
  80138b:	e8 59 ff ff ff       	call   8012e9 <dev_lookup>
  801390:	89 c7                	mov    %eax,%edi
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 15                	js     8013ae <fd_close+0x6f>
		if (dev->dev_close)
  801399:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80139c:	8b 40 10             	mov    0x10(%eax),%eax
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	74 1b                	je     8013be <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	56                   	push   %esi
  8013a7:	ff d0                	call   *%eax
  8013a9:	89 c7                	mov    %eax,%edi
  8013ab:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	56                   	push   %esi
  8013b2:	6a 00                	push   $0x0
  8013b4:	e8 ae f9 ff ff       	call   800d67 <sys_page_unmap>
	return r;
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	eb ba                	jmp    801378 <fd_close+0x39>
			r = 0;
  8013be:	bf 00 00 00 00       	mov    $0x0,%edi
  8013c3:	eb e9                	jmp    8013ae <fd_close+0x6f>

008013c5 <close>:

int
close(int fdnum)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	50                   	push   %eax
  8013cf:	ff 75 08             	pushl  0x8(%ebp)
  8013d2:	e8 bb fe ff ff       	call   801292 <fd_lookup>
  8013d7:	83 c4 08             	add    $0x8,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 10                	js     8013ee <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	6a 01                	push   $0x1
  8013e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e6:	e8 54 ff ff ff       	call   80133f <fd_close>
  8013eb:	83 c4 10             	add    $0x10,%esp
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <close_all>:

void
close_all(void)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	53                   	push   %ebx
  8013f4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013fc:	83 ec 0c             	sub    $0xc,%esp
  8013ff:	53                   	push   %ebx
  801400:	e8 c0 ff ff ff       	call   8013c5 <close>
	for (i = 0; i < MAXFD; i++)
  801405:	43                   	inc    %ebx
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	83 fb 20             	cmp    $0x20,%ebx
  80140c:	75 ee                	jne    8013fc <close_all+0xc>
}
  80140e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	57                   	push   %edi
  801417:	56                   	push   %esi
  801418:	53                   	push   %ebx
  801419:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80141c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 6a fe ff ff       	call   801292 <fd_lookup>
  801428:	89 c3                	mov    %eax,%ebx
  80142a:	83 c4 08             	add    $0x8,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	0f 88 81 00 00 00    	js     8014b6 <dup+0xa3>
		return r;
	close(newfdnum);
  801435:	83 ec 0c             	sub    $0xc,%esp
  801438:	ff 75 0c             	pushl  0xc(%ebp)
  80143b:	e8 85 ff ff ff       	call   8013c5 <close>

	newfd = INDEX2FD(newfdnum);
  801440:	8b 75 0c             	mov    0xc(%ebp),%esi
  801443:	c1 e6 0c             	shl    $0xc,%esi
  801446:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80144c:	83 c4 04             	add    $0x4,%esp
  80144f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801452:	e8 d5 fd ff ff       	call   80122c <fd2data>
  801457:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801459:	89 34 24             	mov    %esi,(%esp)
  80145c:	e8 cb fd ff ff       	call   80122c <fd2data>
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801466:	89 d8                	mov    %ebx,%eax
  801468:	c1 e8 16             	shr    $0x16,%eax
  80146b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801472:	a8 01                	test   $0x1,%al
  801474:	74 11                	je     801487 <dup+0x74>
  801476:	89 d8                	mov    %ebx,%eax
  801478:	c1 e8 0c             	shr    $0xc,%eax
  80147b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801482:	f6 c2 01             	test   $0x1,%dl
  801485:	75 39                	jne    8014c0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801487:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80148a:	89 d0                	mov    %edx,%eax
  80148c:	c1 e8 0c             	shr    $0xc,%eax
  80148f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801496:	83 ec 0c             	sub    $0xc,%esp
  801499:	25 07 0e 00 00       	and    $0xe07,%eax
  80149e:	50                   	push   %eax
  80149f:	56                   	push   %esi
  8014a0:	6a 00                	push   $0x0
  8014a2:	52                   	push   %edx
  8014a3:	6a 00                	push   $0x0
  8014a5:	e8 7b f8 ff ff       	call   800d25 <sys_page_map>
  8014aa:	89 c3                	mov    %eax,%ebx
  8014ac:	83 c4 20             	add    $0x20,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 31                	js     8014e4 <dup+0xd1>
		goto err;

	return newfdnum;
  8014b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014b6:	89 d8                	mov    %ebx,%eax
  8014b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014bb:	5b                   	pop    %ebx
  8014bc:	5e                   	pop    %esi
  8014bd:	5f                   	pop    %edi
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014c7:	83 ec 0c             	sub    $0xc,%esp
  8014ca:	25 07 0e 00 00       	and    $0xe07,%eax
  8014cf:	50                   	push   %eax
  8014d0:	57                   	push   %edi
  8014d1:	6a 00                	push   $0x0
  8014d3:	53                   	push   %ebx
  8014d4:	6a 00                	push   $0x0
  8014d6:	e8 4a f8 ff ff       	call   800d25 <sys_page_map>
  8014db:	89 c3                	mov    %eax,%ebx
  8014dd:	83 c4 20             	add    $0x20,%esp
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	79 a3                	jns    801487 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	56                   	push   %esi
  8014e8:	6a 00                	push   $0x0
  8014ea:	e8 78 f8 ff ff       	call   800d67 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014ef:	83 c4 08             	add    $0x8,%esp
  8014f2:	57                   	push   %edi
  8014f3:	6a 00                	push   $0x0
  8014f5:	e8 6d f8 ff ff       	call   800d67 <sys_page_unmap>
	return r;
  8014fa:	83 c4 10             	add    $0x10,%esp
  8014fd:	eb b7                	jmp    8014b6 <dup+0xa3>

008014ff <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	53                   	push   %ebx
  801503:	83 ec 14             	sub    $0x14,%esp
  801506:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801509:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150c:	50                   	push   %eax
  80150d:	53                   	push   %ebx
  80150e:	e8 7f fd ff ff       	call   801292 <fd_lookup>
  801513:	83 c4 08             	add    $0x8,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	78 3f                	js     801559 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801520:	50                   	push   %eax
  801521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801524:	ff 30                	pushl  (%eax)
  801526:	e8 be fd ff ff       	call   8012e9 <dev_lookup>
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 27                	js     801559 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801535:	8b 42 08             	mov    0x8(%edx),%eax
  801538:	83 e0 03             	and    $0x3,%eax
  80153b:	83 f8 01             	cmp    $0x1,%eax
  80153e:	74 1e                	je     80155e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	8b 40 08             	mov    0x8(%eax),%eax
  801546:	85 c0                	test   %eax,%eax
  801548:	74 35                	je     80157f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	ff 75 10             	pushl  0x10(%ebp)
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	52                   	push   %edx
  801554:	ff d0                	call   *%eax
  801556:	83 c4 10             	add    $0x10,%esp
}
  801559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80155e:	a1 04 50 80 00       	mov    0x805004,%eax
  801563:	8b 40 48             	mov    0x48(%eax),%eax
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	53                   	push   %ebx
  80156a:	50                   	push   %eax
  80156b:	68 ad 2e 80 00       	push   $0x802ead
  801570:	e8 b0 ed ff ff       	call   800325 <cprintf>
		return -E_INVAL;
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157d:	eb da                	jmp    801559 <read+0x5a>
		return -E_NOT_SUPP;
  80157f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801584:	eb d3                	jmp    801559 <read+0x5a>

00801586 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	57                   	push   %edi
  80158a:	56                   	push   %esi
  80158b:	53                   	push   %ebx
  80158c:	83 ec 0c             	sub    $0xc,%esp
  80158f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801592:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801595:	bb 00 00 00 00       	mov    $0x0,%ebx
  80159a:	39 f3                	cmp    %esi,%ebx
  80159c:	73 25                	jae    8015c3 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	89 f0                	mov    %esi,%eax
  8015a3:	29 d8                	sub    %ebx,%eax
  8015a5:	50                   	push   %eax
  8015a6:	89 d8                	mov    %ebx,%eax
  8015a8:	03 45 0c             	add    0xc(%ebp),%eax
  8015ab:	50                   	push   %eax
  8015ac:	57                   	push   %edi
  8015ad:	e8 4d ff ff ff       	call   8014ff <read>
		if (m < 0)
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	78 08                	js     8015c1 <readn+0x3b>
			return m;
		if (m == 0)
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	74 06                	je     8015c3 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015bd:	01 c3                	add    %eax,%ebx
  8015bf:	eb d9                	jmp    80159a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015c3:	89 d8                	mov    %ebx,%eax
  8015c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c8:	5b                   	pop    %ebx
  8015c9:	5e                   	pop    %esi
  8015ca:	5f                   	pop    %edi
  8015cb:	5d                   	pop    %ebp
  8015cc:	c3                   	ret    

008015cd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	53                   	push   %ebx
  8015d1:	83 ec 14             	sub    $0x14,%esp
  8015d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015da:	50                   	push   %eax
  8015db:	53                   	push   %ebx
  8015dc:	e8 b1 fc ff ff       	call   801292 <fd_lookup>
  8015e1:	83 c4 08             	add    $0x8,%esp
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	78 3a                	js     801622 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ee:	50                   	push   %eax
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	ff 30                	pushl  (%eax)
  8015f4:	e8 f0 fc ff ff       	call   8012e9 <dev_lookup>
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 22                	js     801622 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801603:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801607:	74 1e                	je     801627 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160c:	8b 52 0c             	mov    0xc(%edx),%edx
  80160f:	85 d2                	test   %edx,%edx
  801611:	74 35                	je     801648 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	ff 75 10             	pushl  0x10(%ebp)
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	50                   	push   %eax
  80161d:	ff d2                	call   *%edx
  80161f:	83 c4 10             	add    $0x10,%esp
}
  801622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801625:	c9                   	leave  
  801626:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801627:	a1 04 50 80 00       	mov    0x805004,%eax
  80162c:	8b 40 48             	mov    0x48(%eax),%eax
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	53                   	push   %ebx
  801633:	50                   	push   %eax
  801634:	68 c9 2e 80 00       	push   $0x802ec9
  801639:	e8 e7 ec ff ff       	call   800325 <cprintf>
		return -E_INVAL;
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801646:	eb da                	jmp    801622 <write+0x55>
		return -E_NOT_SUPP;
  801648:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164d:	eb d3                	jmp    801622 <write+0x55>

0080164f <seek>:

int
seek(int fdnum, off_t offset)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801655:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801658:	50                   	push   %eax
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 31 fc ff ff       	call   801292 <fd_lookup>
  801661:	83 c4 08             	add    $0x8,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	78 0e                	js     801676 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	53                   	push   %ebx
  80167c:	83 ec 14             	sub    $0x14,%esp
  80167f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801682:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801685:	50                   	push   %eax
  801686:	53                   	push   %ebx
  801687:	e8 06 fc ff ff       	call   801292 <fd_lookup>
  80168c:	83 c4 08             	add    $0x8,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 37                	js     8016ca <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801693:	83 ec 08             	sub    $0x8,%esp
  801696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801699:	50                   	push   %eax
  80169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169d:	ff 30                	pushl  (%eax)
  80169f:	e8 45 fc ff ff       	call   8012e9 <dev_lookup>
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	78 1f                	js     8016ca <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ae:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b2:	74 1b                	je     8016cf <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b7:	8b 52 18             	mov    0x18(%edx),%edx
  8016ba:	85 d2                	test   %edx,%edx
  8016bc:	74 32                	je     8016f0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	ff 75 0c             	pushl  0xc(%ebp)
  8016c4:	50                   	push   %eax
  8016c5:	ff d2                	call   *%edx
  8016c7:	83 c4 10             	add    $0x10,%esp
}
  8016ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016cf:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016d4:	8b 40 48             	mov    0x48(%eax),%eax
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	53                   	push   %ebx
  8016db:	50                   	push   %eax
  8016dc:	68 8c 2e 80 00       	push   $0x802e8c
  8016e1:	e8 3f ec ff ff       	call   800325 <cprintf>
		return -E_INVAL;
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ee:	eb da                	jmp    8016ca <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f5:	eb d3                	jmp    8016ca <ftruncate+0x52>

008016f7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	53                   	push   %ebx
  8016fb:	83 ec 14             	sub    $0x14,%esp
  8016fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801701:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801704:	50                   	push   %eax
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	e8 85 fb ff ff       	call   801292 <fd_lookup>
  80170d:	83 c4 08             	add    $0x8,%esp
  801710:	85 c0                	test   %eax,%eax
  801712:	78 4b                	js     80175f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801714:	83 ec 08             	sub    $0x8,%esp
  801717:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171a:	50                   	push   %eax
  80171b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171e:	ff 30                	pushl  (%eax)
  801720:	e8 c4 fb ff ff       	call   8012e9 <dev_lookup>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	85 c0                	test   %eax,%eax
  80172a:	78 33                	js     80175f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801733:	74 2f                	je     801764 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801735:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801738:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80173f:	00 00 00 
	stat->st_type = 0;
  801742:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801749:	00 00 00 
	stat->st_dev = dev;
  80174c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801752:	83 ec 08             	sub    $0x8,%esp
  801755:	53                   	push   %ebx
  801756:	ff 75 f0             	pushl  -0x10(%ebp)
  801759:	ff 50 14             	call   *0x14(%eax)
  80175c:	83 c4 10             	add    $0x10,%esp
}
  80175f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801762:	c9                   	leave  
  801763:	c3                   	ret    
		return -E_NOT_SUPP;
  801764:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801769:	eb f4                	jmp    80175f <fstat+0x68>

0080176b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	56                   	push   %esi
  80176f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	6a 00                	push   $0x0
  801775:	ff 75 08             	pushl  0x8(%ebp)
  801778:	e8 34 02 00 00       	call   8019b1 <open>
  80177d:	89 c3                	mov    %eax,%ebx
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	85 c0                	test   %eax,%eax
  801784:	78 1b                	js     8017a1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801786:	83 ec 08             	sub    $0x8,%esp
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	50                   	push   %eax
  80178d:	e8 65 ff ff ff       	call   8016f7 <fstat>
  801792:	89 c6                	mov    %eax,%esi
	close(fd);
  801794:	89 1c 24             	mov    %ebx,(%esp)
  801797:	e8 29 fc ff ff       	call   8013c5 <close>
	return r;
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	89 f3                	mov    %esi,%ebx
}
  8017a1:	89 d8                	mov    %ebx,%eax
  8017a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	56                   	push   %esi
  8017ae:	53                   	push   %ebx
  8017af:	89 c6                	mov    %eax,%esi
  8017b1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017b3:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8017ba:	74 27                	je     8017e3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017bc:	6a 07                	push   $0x7
  8017be:	68 00 60 80 00       	push   $0x806000
  8017c3:	56                   	push   %esi
  8017c4:	ff 35 00 50 80 00    	pushl  0x805000
  8017ca:	e8 8a 0e 00 00       	call   802659 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017cf:	83 c4 0c             	add    $0xc,%esp
  8017d2:	6a 00                	push   $0x0
  8017d4:	53                   	push   %ebx
  8017d5:	6a 00                	push   $0x0
  8017d7:	e8 f4 0d 00 00       	call   8025d0 <ipc_recv>
}
  8017dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017df:	5b                   	pop    %ebx
  8017e0:	5e                   	pop    %esi
  8017e1:	5d                   	pop    %ebp
  8017e2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017e3:	83 ec 0c             	sub    $0xc,%esp
  8017e6:	6a 01                	push   $0x1
  8017e8:	e8 c8 0e 00 00       	call   8026b5 <ipc_find_env>
  8017ed:	a3 00 50 80 00       	mov    %eax,0x805000
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	eb c5                	jmp    8017bc <fsipc+0x12>

008017f7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 40 0c             	mov    0xc(%eax),%eax
  801803:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801810:	ba 00 00 00 00       	mov    $0x0,%edx
  801815:	b8 02 00 00 00       	mov    $0x2,%eax
  80181a:	e8 8b ff ff ff       	call   8017aa <fsipc>
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <devfile_flush>:
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	8b 40 0c             	mov    0xc(%eax),%eax
  80182d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	b8 06 00 00 00       	mov    $0x6,%eax
  80183c:	e8 69 ff ff ff       	call   8017aa <fsipc>
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <devfile_stat>:
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	53                   	push   %ebx
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8b 40 0c             	mov    0xc(%eax),%eax
  801853:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	b8 05 00 00 00       	mov    $0x5,%eax
  801862:	e8 43 ff ff ff       	call   8017aa <fsipc>
  801867:	85 c0                	test   %eax,%eax
  801869:	78 2c                	js     801897 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	68 00 60 80 00       	push   $0x806000
  801873:	53                   	push   %ebx
  801874:	e8 b4 f0 ff ff       	call   80092d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801879:	a1 80 60 80 00       	mov    0x806080,%eax
  80187e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801884:	a1 84 60 80 00       	mov    0x806084,%eax
  801889:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <devfile_write>:
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8018a6:	89 d8                	mov    %ebx,%eax
  8018a8:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8018ae:	76 05                	jbe    8018b5 <devfile_write+0x19>
  8018b0:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b8:	8b 52 0c             	mov    0xc(%edx),%edx
  8018bb:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = size;
  8018c1:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	50                   	push   %eax
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	68 08 60 80 00       	push   $0x806008
  8018d2:	e8 c9 f1 ff ff       	call   800aa0 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dc:	b8 04 00 00 00       	mov    $0x4,%eax
  8018e1:	e8 c4 fe ff ff       	call   8017aa <fsipc>
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	78 0b                	js     8018f8 <devfile_write+0x5c>
	assert(r <= n);
  8018ed:	39 c3                	cmp    %eax,%ebx
  8018ef:	72 0c                	jb     8018fd <devfile_write+0x61>
	assert(r <= PGSIZE);
  8018f1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018f6:	7f 1e                	jg     801916 <devfile_write+0x7a>
}
  8018f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    
	assert(r <= n);
  8018fd:	68 f8 2e 80 00       	push   $0x802ef8
  801902:	68 36 2e 80 00       	push   $0x802e36
  801907:	68 98 00 00 00       	push   $0x98
  80190c:	68 ff 2e 80 00       	push   $0x802eff
  801911:	e8 fc e8 ff ff       	call   800212 <_panic>
	assert(r <= PGSIZE);
  801916:	68 0a 2f 80 00       	push   $0x802f0a
  80191b:	68 36 2e 80 00       	push   $0x802e36
  801920:	68 99 00 00 00       	push   $0x99
  801925:	68 ff 2e 80 00       	push   $0x802eff
  80192a:	e8 e3 e8 ff ff       	call   800212 <_panic>

0080192f <devfile_read>:
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	8b 40 0c             	mov    0xc(%eax),%eax
  80193d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801942:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801948:	ba 00 00 00 00       	mov    $0x0,%edx
  80194d:	b8 03 00 00 00       	mov    $0x3,%eax
  801952:	e8 53 fe ff ff       	call   8017aa <fsipc>
  801957:	89 c3                	mov    %eax,%ebx
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 1f                	js     80197c <devfile_read+0x4d>
	assert(r <= n);
  80195d:	39 c6                	cmp    %eax,%esi
  80195f:	72 24                	jb     801985 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801961:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801966:	7f 33                	jg     80199b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	50                   	push   %eax
  80196c:	68 00 60 80 00       	push   $0x806000
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	e8 27 f1 ff ff       	call   800aa0 <memmove>
	return r;
  801979:	83 c4 10             	add    $0x10,%esp
}
  80197c:	89 d8                	mov    %ebx,%eax
  80197e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801981:	5b                   	pop    %ebx
  801982:	5e                   	pop    %esi
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    
	assert(r <= n);
  801985:	68 f8 2e 80 00       	push   $0x802ef8
  80198a:	68 36 2e 80 00       	push   $0x802e36
  80198f:	6a 7c                	push   $0x7c
  801991:	68 ff 2e 80 00       	push   $0x802eff
  801996:	e8 77 e8 ff ff       	call   800212 <_panic>
	assert(r <= PGSIZE);
  80199b:	68 0a 2f 80 00       	push   $0x802f0a
  8019a0:	68 36 2e 80 00       	push   $0x802e36
  8019a5:	6a 7d                	push   $0x7d
  8019a7:	68 ff 2e 80 00       	push   $0x802eff
  8019ac:	e8 61 e8 ff ff       	call   800212 <_panic>

008019b1 <open>:
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	56                   	push   %esi
  8019b5:	53                   	push   %ebx
  8019b6:	83 ec 1c             	sub    $0x1c,%esp
  8019b9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019bc:	56                   	push   %esi
  8019bd:	e8 38 ef ff ff       	call   8008fa <strlen>
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019ca:	7f 6c                	jg     801a38 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019cc:	83 ec 0c             	sub    $0xc,%esp
  8019cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d2:	50                   	push   %eax
  8019d3:	e8 6b f8 ff ff       	call   801243 <fd_alloc>
  8019d8:	89 c3                	mov    %eax,%ebx
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 3c                	js     801a1d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	56                   	push   %esi
  8019e5:	68 00 60 80 00       	push   $0x806000
  8019ea:	e8 3e ef ff ff       	call   80092d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f2:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ff:	e8 a6 fd ff ff       	call   8017aa <fsipc>
  801a04:	89 c3                	mov    %eax,%ebx
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	78 19                	js     801a26 <open+0x75>
	return fd2num(fd);
  801a0d:	83 ec 0c             	sub    $0xc,%esp
  801a10:	ff 75 f4             	pushl  -0xc(%ebp)
  801a13:	e8 04 f8 ff ff       	call   80121c <fd2num>
  801a18:	89 c3                	mov    %eax,%ebx
  801a1a:	83 c4 10             	add    $0x10,%esp
}
  801a1d:	89 d8                	mov    %ebx,%eax
  801a1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a22:	5b                   	pop    %ebx
  801a23:	5e                   	pop    %esi
  801a24:	5d                   	pop    %ebp
  801a25:	c3                   	ret    
		fd_close(fd, 0);
  801a26:	83 ec 08             	sub    $0x8,%esp
  801a29:	6a 00                	push   $0x0
  801a2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2e:	e8 0c f9 ff ff       	call   80133f <fd_close>
		return r;
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	eb e5                	jmp    801a1d <open+0x6c>
		return -E_BAD_PATH;
  801a38:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a3d:	eb de                	jmp    801a1d <open+0x6c>

00801a3f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a45:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4a:	b8 08 00 00 00       	mov    $0x8,%eax
  801a4f:	e8 56 fd ff ff       	call   8017aa <fsipc>
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	57                   	push   %edi
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	81 ec 94 02 00 00    	sub    $0x294,%esp
  801a62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801a65:	6a 00                	push   $0x0
  801a67:	ff 75 08             	pushl  0x8(%ebp)
  801a6a:	e8 42 ff ff ff       	call   8019b1 <open>
  801a6f:	89 c1                	mov    %eax,%ecx
  801a71:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	0f 88 ba 04 00 00    	js     801f3c <spawn+0x4e6>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	68 00 02 00 00       	push   $0x200
  801a8a:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801a90:	50                   	push   %eax
  801a91:	51                   	push   %ecx
  801a92:	e8 ef fa ff ff       	call   801586 <readn>
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a9f:	0f 85 93 00 00 00    	jne    801b38 <spawn+0xe2>
	    || elf->e_magic != ELF_MAGIC) {
  801aa5:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801aac:	45 4c 46 
  801aaf:	0f 85 83 00 00 00    	jne    801b38 <spawn+0xe2>
  801ab5:	b8 07 00 00 00       	mov    $0x7,%eax
  801aba:	cd 30                	int    $0x30
  801abc:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801ac2:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	0f 88 77 04 00 00    	js     801f47 <spawn+0x4f1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801ad0:	89 c2                	mov    %eax,%edx
  801ad2:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  801ad8:	89 d0                	mov    %edx,%eax
  801ada:	c1 e0 05             	shl    $0x5,%eax
  801add:	29 d0                	sub    %edx,%eax
  801adf:	8d 34 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%esi
  801ae6:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801aec:	b9 11 00 00 00       	mov    $0x11,%ecx
  801af1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801af3:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801af9:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801aff:	ba 00 00 00 00       	mov    $0x0,%edx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b04:	b8 00 00 00 00       	mov    $0x0,%eax
	string_size = 0;
  801b09:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801b11:	89 c3                	mov    %eax,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  801b13:	89 d9                	mov    %ebx,%ecx
  801b15:	8d 72 04             	lea    0x4(%edx),%esi
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	8b 44 30 fc          	mov    -0x4(%eax,%esi,1),%eax
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	74 48                	je     801b6b <spawn+0x115>
		string_size += strlen(argv[argc]) + 1;
  801b23:	83 ec 0c             	sub    $0xc,%esp
  801b26:	50                   	push   %eax
  801b27:	e8 ce ed ff ff       	call   8008fa <strlen>
  801b2c:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801b30:	43                   	inc    %ebx
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	89 f2                	mov    %esi,%edx
  801b36:	eb db                	jmp    801b13 <spawn+0xbd>
		close(fd);
  801b38:	83 ec 0c             	sub    $0xc,%esp
  801b3b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801b41:	e8 7f f8 ff ff       	call   8013c5 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b46:	83 c4 0c             	add    $0xc,%esp
  801b49:	68 7f 45 4c 46       	push   $0x464c457f
  801b4e:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801b54:	68 16 2f 80 00       	push   $0x802f16
  801b59:	e8 c7 e7 ff ff       	call   800325 <cprintf>
		return -E_NOT_EXEC;
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
  801b66:	e9 62 02 00 00       	jmp    801dcd <spawn+0x377>
  801b6b:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801b71:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801b77:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801b7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801b80:	be 00 10 40 00       	mov    $0x401000,%esi
  801b85:	29 fe                	sub    %edi,%esi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801b87:	89 f2                	mov    %esi,%edx
  801b89:	83 e2 fc             	and    $0xfffffffc,%edx
  801b8c:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
  801b93:	29 c2                	sub    %eax,%edx
  801b95:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801b9b:	8d 42 f8             	lea    -0x8(%edx),%eax
  801b9e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ba3:	0f 86 a9 03 00 00    	jbe    801f52 <spawn+0x4fc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	6a 07                	push   $0x7
  801bae:	68 00 00 40 00       	push   $0x400000
  801bb3:	6a 00                	push   $0x0
  801bb5:	e8 28 f1 ff ff       	call   800ce2 <sys_page_alloc>
  801bba:	89 c7                	mov    %eax,%edi
  801bbc:	83 c4 10             	add    $0x10,%esp
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	0f 88 06 02 00 00    	js     801dcd <spawn+0x377>
  801bc7:	bf 00 00 00 00       	mov    $0x0,%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801bcc:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801bd2:	7e 30                	jle    801c04 <spawn+0x1ae>
		argv_store[i] = UTEMP2USTACK(string_store);
  801bd4:	8d 86 00 d0 7f ee    	lea    -0x11803000(%esi),%eax
  801bda:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801be0:	89 04 b9             	mov    %eax,(%ecx,%edi,4)
		strcpy(string_store, argv[i]);
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	ff 34 bb             	pushl  (%ebx,%edi,4)
  801be9:	56                   	push   %esi
  801bea:	e8 3e ed ff ff       	call   80092d <strcpy>
		string_store += strlen(argv[i]) + 1;
  801bef:	83 c4 04             	add    $0x4,%esp
  801bf2:	ff 34 bb             	pushl  (%ebx,%edi,4)
  801bf5:	e8 00 ed ff ff       	call   8008fa <strlen>
  801bfa:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (i = 0; i < argc; i++) {
  801bfe:	47                   	inc    %edi
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	eb c8                	jmp    801bcc <spawn+0x176>
	}
	argv_store[argc] = 0;
  801c04:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c0a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801c10:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c17:	81 fe 00 10 40 00    	cmp    $0x401000,%esi
  801c1d:	0f 85 8c 00 00 00    	jne    801caf <spawn+0x259>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c23:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801c29:	89 c8                	mov    %ecx,%eax
  801c2b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801c30:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801c33:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c39:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c3c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801c42:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c48:	83 ec 0c             	sub    $0xc,%esp
  801c4b:	6a 07                	push   $0x7
  801c4d:	68 00 d0 bf ee       	push   $0xeebfd000
  801c52:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c58:	68 00 00 40 00       	push   $0x400000
  801c5d:	6a 00                	push   $0x0
  801c5f:	e8 c1 f0 ff ff       	call   800d25 <sys_page_map>
  801c64:	89 c7                	mov    %eax,%edi
  801c66:	83 c4 20             	add    $0x20,%esp
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	0f 88 3e 03 00 00    	js     801faf <spawn+0x559>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c71:	83 ec 08             	sub    $0x8,%esp
  801c74:	68 00 00 40 00       	push   $0x400000
  801c79:	6a 00                	push   $0x0
  801c7b:	e8 e7 f0 ff ff       	call   800d67 <sys_page_unmap>
  801c80:	89 c7                	mov    %eax,%edi
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	85 c0                	test   %eax,%eax
  801c87:	0f 88 22 03 00 00    	js     801faf <spawn+0x559>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801c8d:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c93:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801c9a:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ca0:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801ca7:	00 00 00 
  801caa:	e9 4a 01 00 00       	jmp    801df9 <spawn+0x3a3>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801caf:	68 a0 2f 80 00       	push   $0x802fa0
  801cb4:	68 36 2e 80 00       	push   $0x802e36
  801cb9:	68 f1 00 00 00       	push   $0xf1
  801cbe:	68 30 2f 80 00       	push   $0x802f30
  801cc3:	e8 4a e5 ff ff       	call   800212 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	6a 07                	push   $0x7
  801ccd:	68 00 00 40 00       	push   $0x400000
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 09 f0 ff ff       	call   800ce2 <sys_page_alloc>
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	0f 88 78 02 00 00    	js     801f5c <spawn+0x506>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801ce4:	83 ec 08             	sub    $0x8,%esp
  801ce7:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801ced:	01 f8                	add    %edi,%eax
  801cef:	50                   	push   %eax
  801cf0:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cf6:	e8 54 f9 ff ff       	call   80164f <seek>
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	0f 88 5d 02 00 00    	js     801f63 <spawn+0x50d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d06:	83 ec 04             	sub    $0x4,%esp
  801d09:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d0f:	29 f8                	sub    %edi,%eax
  801d11:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d16:	76 05                	jbe    801d1d <spawn+0x2c7>
  801d18:	b8 00 10 00 00       	mov    $0x1000,%eax
  801d1d:	50                   	push   %eax
  801d1e:	68 00 00 40 00       	push   $0x400000
  801d23:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d29:	e8 58 f8 ff ff       	call   801586 <readn>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	85 c0                	test   %eax,%eax
  801d33:	0f 88 31 02 00 00    	js     801f6a <spawn+0x514>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d39:	83 ec 0c             	sub    $0xc,%esp
  801d3c:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d42:	56                   	push   %esi
  801d43:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801d49:	68 00 00 40 00       	push   $0x400000
  801d4e:	6a 00                	push   $0x0
  801d50:	e8 d0 ef ff ff       	call   800d25 <sys_page_map>
  801d55:	83 c4 20             	add    $0x20,%esp
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	78 7b                	js     801dd7 <spawn+0x381>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801d5c:	83 ec 08             	sub    $0x8,%esp
  801d5f:	68 00 00 40 00       	push   $0x400000
  801d64:	6a 00                	push   $0x0
  801d66:	e8 fc ef ff ff       	call   800d67 <sys_page_unmap>
  801d6b:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801d6e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d74:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801d7a:	89 df                	mov    %ebx,%edi
  801d7c:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  801d82:	73 68                	jae    801dec <spawn+0x396>
		if (i >= filesz) {
  801d84:	3b 9d 94 fd ff ff    	cmp    -0x26c(%ebp),%ebx
  801d8a:	0f 82 38 ff ff ff    	jb     801cc8 <spawn+0x272>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801d90:	83 ec 04             	sub    $0x4,%esp
  801d93:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d99:	56                   	push   %esi
  801d9a:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801da0:	e8 3d ef ff ff       	call   800ce2 <sys_page_alloc>
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	85 c0                	test   %eax,%eax
  801daa:	79 c2                	jns    801d6e <spawn+0x318>
  801dac:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801dae:	83 ec 0c             	sub    $0xc,%esp
  801db1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801db7:	e8 c6 ee ff ff       	call   800c82 <sys_env_destroy>
	close(fd);
  801dbc:	83 c4 04             	add    $0x4,%esp
  801dbf:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801dc5:	e8 fb f5 ff ff       	call   8013c5 <close>
	return r;
  801dca:	83 c4 10             	add    $0x10,%esp
}
  801dcd:	89 f8                	mov    %edi,%eax
  801dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd2:	5b                   	pop    %ebx
  801dd3:	5e                   	pop    %esi
  801dd4:	5f                   	pop    %edi
  801dd5:	5d                   	pop    %ebp
  801dd6:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801dd7:	50                   	push   %eax
  801dd8:	68 3c 2f 80 00       	push   $0x802f3c
  801ddd:	68 24 01 00 00       	push   $0x124
  801de2:	68 30 2f 80 00       	push   $0x802f30
  801de7:	e8 26 e4 ff ff       	call   800212 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801dec:	ff 85 78 fd ff ff    	incl   -0x288(%ebp)
  801df2:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801df9:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801e00:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801e06:	7d 71                	jge    801e79 <spawn+0x423>
		if (ph->p_type != ELF_PROG_LOAD)
  801e08:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801e0e:	83 38 01             	cmpl   $0x1,(%eax)
  801e11:	75 d9                	jne    801dec <spawn+0x396>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e13:	89 c1                	mov    %eax,%ecx
  801e15:	8b 40 18             	mov    0x18(%eax),%eax
  801e18:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801e1b:	83 f8 01             	cmp    $0x1,%eax
  801e1e:	19 c0                	sbb    %eax,%eax
  801e20:	83 e0 fe             	and    $0xfffffffe,%eax
  801e23:	83 c0 07             	add    $0x7,%eax
  801e26:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e2c:	89 c8                	mov    %ecx,%eax
  801e2e:	8b 49 04             	mov    0x4(%ecx),%ecx
  801e31:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801e37:	8b 50 10             	mov    0x10(%eax),%edx
  801e3a:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801e40:	8b 78 14             	mov    0x14(%eax),%edi
  801e43:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
  801e49:	8b 70 08             	mov    0x8(%eax),%esi
	if ((i = PGOFF(va))) {
  801e4c:	89 f0                	mov    %esi,%eax
  801e4e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e53:	74 1a                	je     801e6f <spawn+0x419>
		va -= i;
  801e55:	29 c6                	sub    %eax,%esi
		memsz += i;
  801e57:	01 c7                	add    %eax,%edi
  801e59:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
		filesz += i;
  801e5f:	01 c2                	add    %eax,%edx
  801e61:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
		fileoffset -= i;
  801e67:	29 c1                	sub    %eax,%ecx
  801e69:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801e6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e74:	e9 01 ff ff ff       	jmp    801d7a <spawn+0x324>
	close(fd);
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801e82:	e8 3e f5 ff ff       	call   8013c5 <close>
  801e87:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  801e8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e8f:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801e95:	eb 12                	jmp    801ea9 <spawn+0x453>
  801e97:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e9d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ea3:	0f 84 c8 00 00 00    	je     801f71 <spawn+0x51b>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U) && (uvpt[PGNUM(pn)] & PTE_SHARE)) {
  801ea9:	89 d8                	mov    %ebx,%eax
  801eab:	c1 e8 16             	shr    $0x16,%eax
  801eae:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801eb5:	a8 01                	test   $0x1,%al
  801eb7:	74 de                	je     801e97 <spawn+0x441>
  801eb9:	89 d8                	mov    %ebx,%eax
  801ebb:	c1 e8 0c             	shr    $0xc,%eax
  801ebe:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ec5:	f6 c2 04             	test   $0x4,%dl
  801ec8:	74 cd                	je     801e97 <spawn+0x441>
  801eca:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ed1:	f6 c6 04             	test   $0x4,%dh
  801ed4:	74 c1                	je     801e97 <spawn+0x441>
			if (sys_page_map(sys_getenvid(), (void*)(pn), child, (void*)(pn), uvpt[PGNUM(pn)] & PTE_SYSCALL) < 0) {
  801ed6:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  801edd:	e8 e1 ed ff ff       	call   800cc3 <sys_getenvid>
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801eeb:	57                   	push   %edi
  801eec:	53                   	push   %ebx
  801eed:	56                   	push   %esi
  801eee:	53                   	push   %ebx
  801eef:	50                   	push   %eax
  801ef0:	e8 30 ee ff ff       	call   800d25 <sys_page_map>
  801ef5:	83 c4 20             	add    $0x20,%esp
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	79 9b                	jns    801e97 <spawn+0x441>
		panic("copy_shared_pages: %e", r);
  801efc:	6a ff                	push   $0xffffffff
  801efe:	68 8a 2f 80 00       	push   $0x802f8a
  801f03:	68 82 00 00 00       	push   $0x82
  801f08:	68 30 2f 80 00       	push   $0x802f30
  801f0d:	e8 00 e3 ff ff       	call   800212 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  801f12:	50                   	push   %eax
  801f13:	68 59 2f 80 00       	push   $0x802f59
  801f18:	68 85 00 00 00       	push   $0x85
  801f1d:	68 30 2f 80 00       	push   $0x802f30
  801f22:	e8 eb e2 ff ff       	call   800212 <_panic>
		panic("sys_env_set_status: %e", r);
  801f27:	50                   	push   %eax
  801f28:	68 73 2f 80 00       	push   $0x802f73
  801f2d:	68 88 00 00 00       	push   $0x88
  801f32:	68 30 2f 80 00       	push   $0x802f30
  801f37:	e8 d6 e2 ff ff       	call   800212 <_panic>
		return r;
  801f3c:	8b bd 8c fd ff ff    	mov    -0x274(%ebp),%edi
  801f42:	e9 86 fe ff ff       	jmp    801dcd <spawn+0x377>
		return r;
  801f47:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  801f4d:	e9 7b fe ff ff       	jmp    801dcd <spawn+0x377>
		return -E_NO_MEM;
  801f52:	bf fc ff ff ff       	mov    $0xfffffffc,%edi
  801f57:	e9 71 fe ff ff       	jmp    801dcd <spawn+0x377>
  801f5c:	89 c7                	mov    %eax,%edi
  801f5e:	e9 4b fe ff ff       	jmp    801dae <spawn+0x358>
  801f63:	89 c7                	mov    %eax,%edi
  801f65:	e9 44 fe ff ff       	jmp    801dae <spawn+0x358>
  801f6a:	89 c7                	mov    %eax,%edi
  801f6c:	e9 3d fe ff ff       	jmp    801dae <spawn+0x358>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801f71:	83 ec 08             	sub    $0x8,%esp
  801f74:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801f7a:	50                   	push   %eax
  801f7b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f81:	e8 c5 ee ff ff       	call   800e4b <sys_env_set_trapframe>
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 85                	js     801f12 <spawn+0x4bc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	6a 02                	push   $0x2
  801f92:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f98:	e8 2b ee ff ff       	call   800dc8 <sys_env_set_status>
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	78 83                	js     801f27 <spawn+0x4d1>
	return child;
  801fa4:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  801faa:	e9 1e fe ff ff       	jmp    801dcd <spawn+0x377>
	sys_page_unmap(0, UTEMP);
  801faf:	83 ec 08             	sub    $0x8,%esp
  801fb2:	68 00 00 40 00       	push   $0x400000
  801fb7:	6a 00                	push   $0x0
  801fb9:	e8 a9 ed ff ff       	call   800d67 <sys_page_unmap>
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	e9 07 fe ff ff       	jmp    801dcd <spawn+0x377>

00801fc6 <spawnl>:
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	57                   	push   %edi
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801fcf:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801fd7:	eb 03                	jmp    801fdc <spawnl+0x16>
		argc++;
  801fd9:	40                   	inc    %eax
	while(va_arg(vl, void *) != NULL)
  801fda:	89 ca                	mov    %ecx,%edx
  801fdc:	8d 4a 04             	lea    0x4(%edx),%ecx
  801fdf:	83 3a 00             	cmpl   $0x0,(%edx)
  801fe2:	75 f5                	jne    801fd9 <spawnl+0x13>
	const char *argv[argc+2];
  801fe4:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801feb:	83 e2 f0             	and    $0xfffffff0,%edx
  801fee:	29 d4                	sub    %edx,%esp
  801ff0:	8d 54 24 03          	lea    0x3(%esp),%edx
  801ff4:	c1 ea 02             	shr    $0x2,%edx
  801ff7:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ffe:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802000:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802003:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80200a:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802011:	00 
	va_start(vl, arg0);
  802012:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802015:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	eb 09                	jmp    802027 <spawnl+0x61>
		argv[i+1] = va_arg(vl, const char *);
  80201e:	40                   	inc    %eax
  80201f:	8b 39                	mov    (%ecx),%edi
  802021:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802024:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802027:	39 d0                	cmp    %edx,%eax
  802029:	75 f3                	jne    80201e <spawnl+0x58>
	return spawn(prog, argv);
  80202b:	83 ec 08             	sub    $0x8,%esp
  80202e:	56                   	push   %esi
  80202f:	ff 75 08             	pushl  0x8(%ebp)
  802032:	e8 1f fa ff ff       	call   801a56 <spawn>
}
  802037:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203a:	5b                   	pop    %ebx
  80203b:	5e                   	pop    %esi
  80203c:	5f                   	pop    %edi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    

0080203f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	56                   	push   %esi
  802043:	53                   	push   %ebx
  802044:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802047:	83 ec 0c             	sub    $0xc,%esp
  80204a:	ff 75 08             	pushl  0x8(%ebp)
  80204d:	e8 da f1 ff ff       	call   80122c <fd2data>
  802052:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802054:	83 c4 08             	add    $0x8,%esp
  802057:	68 c6 2f 80 00       	push   $0x802fc6
  80205c:	53                   	push   %ebx
  80205d:	e8 cb e8 ff ff       	call   80092d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802062:	8b 46 04             	mov    0x4(%esi),%eax
  802065:	2b 06                	sub    (%esi),%eax
  802067:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80206d:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  802074:	10 00 00 
	stat->st_dev = &devpipe;
  802077:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  80207e:	40 80 00 
	return 0;
}
  802081:	b8 00 00 00 00       	mov    $0x0,%eax
  802086:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802089:	5b                   	pop    %ebx
  80208a:	5e                   	pop    %esi
  80208b:	5d                   	pop    %ebp
  80208c:	c3                   	ret    

0080208d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	53                   	push   %ebx
  802091:	83 ec 0c             	sub    $0xc,%esp
  802094:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802097:	53                   	push   %ebx
  802098:	6a 00                	push   $0x0
  80209a:	e8 c8 ec ff ff       	call   800d67 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80209f:	89 1c 24             	mov    %ebx,(%esp)
  8020a2:	e8 85 f1 ff ff       	call   80122c <fd2data>
  8020a7:	83 c4 08             	add    $0x8,%esp
  8020aa:	50                   	push   %eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	e8 b5 ec ff ff       	call   800d67 <sys_page_unmap>
}
  8020b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <_pipeisclosed>:
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	57                   	push   %edi
  8020bb:	56                   	push   %esi
  8020bc:	53                   	push   %ebx
  8020bd:	83 ec 1c             	sub    $0x1c,%esp
  8020c0:	89 c7                	mov    %eax,%edi
  8020c2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020c4:	a1 04 50 80 00       	mov    0x805004,%eax
  8020c9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020cc:	83 ec 0c             	sub    $0xc,%esp
  8020cf:	57                   	push   %edi
  8020d0:	e8 22 06 00 00       	call   8026f7 <pageref>
  8020d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020d8:	89 34 24             	mov    %esi,(%esp)
  8020db:	e8 17 06 00 00       	call   8026f7 <pageref>
		nn = thisenv->env_runs;
  8020e0:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8020e6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	39 cb                	cmp    %ecx,%ebx
  8020ee:	74 1b                	je     80210b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020f0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020f3:	75 cf                	jne    8020c4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020f5:	8b 42 58             	mov    0x58(%edx),%eax
  8020f8:	6a 01                	push   $0x1
  8020fa:	50                   	push   %eax
  8020fb:	53                   	push   %ebx
  8020fc:	68 cd 2f 80 00       	push   $0x802fcd
  802101:	e8 1f e2 ff ff       	call   800325 <cprintf>
  802106:	83 c4 10             	add    $0x10,%esp
  802109:	eb b9                	jmp    8020c4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80210b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80210e:	0f 94 c0             	sete   %al
  802111:	0f b6 c0             	movzbl %al,%eax
}
  802114:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5f                   	pop    %edi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    

0080211c <devpipe_write>:
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	57                   	push   %edi
  802120:	56                   	push   %esi
  802121:	53                   	push   %ebx
  802122:	83 ec 18             	sub    $0x18,%esp
  802125:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802128:	56                   	push   %esi
  802129:	e8 fe f0 ff ff       	call   80122c <fd2data>
  80212e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	bf 00 00 00 00       	mov    $0x0,%edi
  802138:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80213b:	74 41                	je     80217e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80213d:	8b 53 04             	mov    0x4(%ebx),%edx
  802140:	8b 03                	mov    (%ebx),%eax
  802142:	83 c0 20             	add    $0x20,%eax
  802145:	39 c2                	cmp    %eax,%edx
  802147:	72 14                	jb     80215d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802149:	89 da                	mov    %ebx,%edx
  80214b:	89 f0                	mov    %esi,%eax
  80214d:	e8 65 ff ff ff       	call   8020b7 <_pipeisclosed>
  802152:	85 c0                	test   %eax,%eax
  802154:	75 2c                	jne    802182 <devpipe_write+0x66>
			sys_yield();
  802156:	e8 4e ec ff ff       	call   800da9 <sys_yield>
  80215b:	eb e0                	jmp    80213d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80215d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802160:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  802163:	89 d0                	mov    %edx,%eax
  802165:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80216a:	78 0b                	js     802177 <devpipe_write+0x5b>
  80216c:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  802170:	42                   	inc    %edx
  802171:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802174:	47                   	inc    %edi
  802175:	eb c1                	jmp    802138 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802177:	48                   	dec    %eax
  802178:	83 c8 e0             	or     $0xffffffe0,%eax
  80217b:	40                   	inc    %eax
  80217c:	eb ee                	jmp    80216c <devpipe_write+0x50>
	return i;
  80217e:	89 f8                	mov    %edi,%eax
  802180:	eb 05                	jmp    802187 <devpipe_write+0x6b>
				return 0;
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80218a:	5b                   	pop    %ebx
  80218b:	5e                   	pop    %esi
  80218c:	5f                   	pop    %edi
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <devpipe_read>:
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	57                   	push   %edi
  802193:	56                   	push   %esi
  802194:	53                   	push   %ebx
  802195:	83 ec 18             	sub    $0x18,%esp
  802198:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80219b:	57                   	push   %edi
  80219c:	e8 8b f0 ff ff       	call   80122c <fd2data>
  8021a1:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021ab:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8021ae:	74 46                	je     8021f6 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  8021b0:	8b 06                	mov    (%esi),%eax
  8021b2:	3b 46 04             	cmp    0x4(%esi),%eax
  8021b5:	75 22                	jne    8021d9 <devpipe_read+0x4a>
			if (i > 0)
  8021b7:	85 db                	test   %ebx,%ebx
  8021b9:	74 0a                	je     8021c5 <devpipe_read+0x36>
				return i;
  8021bb:	89 d8                	mov    %ebx,%eax
}
  8021bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021c0:	5b                   	pop    %ebx
  8021c1:	5e                   	pop    %esi
  8021c2:	5f                   	pop    %edi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  8021c5:	89 f2                	mov    %esi,%edx
  8021c7:	89 f8                	mov    %edi,%eax
  8021c9:	e8 e9 fe ff ff       	call   8020b7 <_pipeisclosed>
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	75 28                	jne    8021fa <devpipe_read+0x6b>
			sys_yield();
  8021d2:	e8 d2 eb ff ff       	call   800da9 <sys_yield>
  8021d7:	eb d7                	jmp    8021b0 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021d9:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8021de:	78 0f                	js     8021ef <devpipe_read+0x60>
  8021e0:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8021e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021e7:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8021ea:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8021ec:	43                   	inc    %ebx
  8021ed:	eb bc                	jmp    8021ab <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021ef:	48                   	dec    %eax
  8021f0:	83 c8 e0             	or     $0xffffffe0,%eax
  8021f3:	40                   	inc    %eax
  8021f4:	eb ea                	jmp    8021e0 <devpipe_read+0x51>
	return i;
  8021f6:	89 d8                	mov    %ebx,%eax
  8021f8:	eb c3                	jmp    8021bd <devpipe_read+0x2e>
				return 0;
  8021fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ff:	eb bc                	jmp    8021bd <devpipe_read+0x2e>

00802201 <pipe>:
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
  802204:	56                   	push   %esi
  802205:	53                   	push   %ebx
  802206:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802209:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80220c:	50                   	push   %eax
  80220d:	e8 31 f0 ff ff       	call   801243 <fd_alloc>
  802212:	89 c3                	mov    %eax,%ebx
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	85 c0                	test   %eax,%eax
  802219:	0f 88 2a 01 00 00    	js     802349 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	68 07 04 00 00       	push   $0x407
  802227:	ff 75 f4             	pushl  -0xc(%ebp)
  80222a:	6a 00                	push   $0x0
  80222c:	e8 b1 ea ff ff       	call   800ce2 <sys_page_alloc>
  802231:	89 c3                	mov    %eax,%ebx
  802233:	83 c4 10             	add    $0x10,%esp
  802236:	85 c0                	test   %eax,%eax
  802238:	0f 88 0b 01 00 00    	js     802349 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  80223e:	83 ec 0c             	sub    $0xc,%esp
  802241:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802244:	50                   	push   %eax
  802245:	e8 f9 ef ff ff       	call   801243 <fd_alloc>
  80224a:	89 c3                	mov    %eax,%ebx
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	0f 88 e2 00 00 00    	js     802339 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802257:	83 ec 04             	sub    $0x4,%esp
  80225a:	68 07 04 00 00       	push   $0x407
  80225f:	ff 75 f0             	pushl  -0x10(%ebp)
  802262:	6a 00                	push   $0x0
  802264:	e8 79 ea ff ff       	call   800ce2 <sys_page_alloc>
  802269:	89 c3                	mov    %eax,%ebx
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	85 c0                	test   %eax,%eax
  802270:	0f 88 c3 00 00 00    	js     802339 <pipe+0x138>
	va = fd2data(fd0);
  802276:	83 ec 0c             	sub    $0xc,%esp
  802279:	ff 75 f4             	pushl  -0xc(%ebp)
  80227c:	e8 ab ef ff ff       	call   80122c <fd2data>
  802281:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802283:	83 c4 0c             	add    $0xc,%esp
  802286:	68 07 04 00 00       	push   $0x407
  80228b:	50                   	push   %eax
  80228c:	6a 00                	push   $0x0
  80228e:	e8 4f ea ff ff       	call   800ce2 <sys_page_alloc>
  802293:	89 c3                	mov    %eax,%ebx
  802295:	83 c4 10             	add    $0x10,%esp
  802298:	85 c0                	test   %eax,%eax
  80229a:	0f 88 89 00 00 00    	js     802329 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8022a6:	e8 81 ef ff ff       	call   80122c <fd2data>
  8022ab:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022b2:	50                   	push   %eax
  8022b3:	6a 00                	push   $0x0
  8022b5:	56                   	push   %esi
  8022b6:	6a 00                	push   $0x0
  8022b8:	e8 68 ea ff ff       	call   800d25 <sys_page_map>
  8022bd:	89 c3                	mov    %eax,%ebx
  8022bf:	83 c4 20             	add    $0x20,%esp
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	78 55                	js     80231b <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  8022c6:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8022db:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e4:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022f0:	83 ec 0c             	sub    $0xc,%esp
  8022f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f6:	e8 21 ef ff ff       	call   80121c <fd2num>
  8022fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022fe:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802300:	83 c4 04             	add    $0x4,%esp
  802303:	ff 75 f0             	pushl  -0x10(%ebp)
  802306:	e8 11 ef ff ff       	call   80121c <fd2num>
  80230b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80230e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802311:	83 c4 10             	add    $0x10,%esp
  802314:	bb 00 00 00 00       	mov    $0x0,%ebx
  802319:	eb 2e                	jmp    802349 <pipe+0x148>
	sys_page_unmap(0, va);
  80231b:	83 ec 08             	sub    $0x8,%esp
  80231e:	56                   	push   %esi
  80231f:	6a 00                	push   $0x0
  802321:	e8 41 ea ff ff       	call   800d67 <sys_page_unmap>
  802326:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802329:	83 ec 08             	sub    $0x8,%esp
  80232c:	ff 75 f0             	pushl  -0x10(%ebp)
  80232f:	6a 00                	push   $0x0
  802331:	e8 31 ea ff ff       	call   800d67 <sys_page_unmap>
  802336:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802339:	83 ec 08             	sub    $0x8,%esp
  80233c:	ff 75 f4             	pushl  -0xc(%ebp)
  80233f:	6a 00                	push   $0x0
  802341:	e8 21 ea ff ff       	call   800d67 <sys_page_unmap>
  802346:	83 c4 10             	add    $0x10,%esp
}
  802349:	89 d8                	mov    %ebx,%eax
  80234b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234e:	5b                   	pop    %ebx
  80234f:	5e                   	pop    %esi
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    

00802352 <pipeisclosed>:
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802358:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235b:	50                   	push   %eax
  80235c:	ff 75 08             	pushl  0x8(%ebp)
  80235f:	e8 2e ef ff ff       	call   801292 <fd_lookup>
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	85 c0                	test   %eax,%eax
  802369:	78 18                	js     802383 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80236b:	83 ec 0c             	sub    $0xc,%esp
  80236e:	ff 75 f4             	pushl  -0xc(%ebp)
  802371:	e8 b6 ee ff ff       	call   80122c <fd2data>
	return _pipeisclosed(fd, p);
  802376:	89 c2                	mov    %eax,%edx
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	e8 37 fd ff ff       	call   8020b7 <_pipeisclosed>
  802380:	83 c4 10             	add    $0x10,%esp
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	56                   	push   %esi
  802389:	53                   	push   %ebx
  80238a:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80238d:	85 f6                	test   %esi,%esi
  80238f:	74 18                	je     8023a9 <wait+0x24>
	e = &envs[ENVX(envid)];
  802391:	89 f2                	mov    %esi,%edx
  802393:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802399:	89 d0                	mov    %edx,%eax
  80239b:	c1 e0 05             	shl    $0x5,%eax
  80239e:	29 d0                	sub    %edx,%eax
  8023a0:	8d 1c 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%ebx
  8023a7:	eb 1b                	jmp    8023c4 <wait+0x3f>
	assert(envid != 0);
  8023a9:	68 e5 2f 80 00       	push   $0x802fe5
  8023ae:	68 36 2e 80 00       	push   $0x802e36
  8023b3:	6a 09                	push   $0x9
  8023b5:	68 f0 2f 80 00       	push   $0x802ff0
  8023ba:	e8 53 de ff ff       	call   800212 <_panic>
		sys_yield();
  8023bf:	e8 e5 e9 ff ff       	call   800da9 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8023c4:	8b 43 48             	mov    0x48(%ebx),%eax
  8023c7:	39 c6                	cmp    %eax,%esi
  8023c9:	75 07                	jne    8023d2 <wait+0x4d>
  8023cb:	8b 43 54             	mov    0x54(%ebx),%eax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	75 ed                	jne    8023bf <wait+0x3a>
}
  8023d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5d                   	pop    %ebp
  8023d8:	c3                   	ret    

008023d9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	5d                   	pop    %ebp
  8023e2:	c3                   	ret    

008023e3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	53                   	push   %ebx
  8023e7:	83 ec 0c             	sub    $0xc,%esp
  8023ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  8023ed:	68 fb 2f 80 00       	push   $0x802ffb
  8023f2:	53                   	push   %ebx
  8023f3:	e8 35 e5 ff ff       	call   80092d <strcpy>
	stat->st_type = FTYPE_IFCHR;
  8023f8:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8023ff:	20 00 00 
	return 0;
}
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <devcons_write>:
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	57                   	push   %edi
  802410:	56                   	push   %esi
  802411:	53                   	push   %ebx
  802412:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802418:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80241d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802423:	eb 1d                	jmp    802442 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	53                   	push   %ebx
  802429:	03 45 0c             	add    0xc(%ebp),%eax
  80242c:	50                   	push   %eax
  80242d:	57                   	push   %edi
  80242e:	e8 6d e6 ff ff       	call   800aa0 <memmove>
		sys_cputs(buf, m);
  802433:	83 c4 08             	add    $0x8,%esp
  802436:	53                   	push   %ebx
  802437:	57                   	push   %edi
  802438:	e8 08 e8 ff ff       	call   800c45 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80243d:	01 de                	add    %ebx,%esi
  80243f:	83 c4 10             	add    $0x10,%esp
  802442:	89 f0                	mov    %esi,%eax
  802444:	3b 75 10             	cmp    0x10(%ebp),%esi
  802447:	73 11                	jae    80245a <devcons_write+0x4e>
		m = n - tot;
  802449:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80244c:	29 f3                	sub    %esi,%ebx
  80244e:	83 fb 7f             	cmp    $0x7f,%ebx
  802451:	76 d2                	jbe    802425 <devcons_write+0x19>
  802453:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  802458:	eb cb                	jmp    802425 <devcons_write+0x19>
}
  80245a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	5f                   	pop    %edi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    

00802462 <devcons_read>:
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  802468:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80246c:	75 0c                	jne    80247a <devcons_read+0x18>
		return 0;
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	eb 21                	jmp    802496 <devcons_read+0x34>
		sys_yield();
  802475:	e8 2f e9 ff ff       	call   800da9 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80247a:	e8 e4 e7 ff ff       	call   800c63 <sys_cgetc>
  80247f:	85 c0                	test   %eax,%eax
  802481:	74 f2                	je     802475 <devcons_read+0x13>
	if (c < 0)
  802483:	85 c0                	test   %eax,%eax
  802485:	78 0f                	js     802496 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  802487:	83 f8 04             	cmp    $0x4,%eax
  80248a:	74 0c                	je     802498 <devcons_read+0x36>
	*(char*)vbuf = c;
  80248c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248f:	88 02                	mov    %al,(%edx)
	return 1;
  802491:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802496:	c9                   	leave  
  802497:	c3                   	ret    
		return 0;
  802498:	b8 00 00 00 00       	mov    $0x0,%eax
  80249d:	eb f7                	jmp    802496 <devcons_read+0x34>

0080249f <cputchar>:
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024ab:	6a 01                	push   $0x1
  8024ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024b0:	50                   	push   %eax
  8024b1:	e8 8f e7 ff ff       	call   800c45 <sys_cputs>
}
  8024b6:	83 c4 10             	add    $0x10,%esp
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <getchar>:
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024c1:	6a 01                	push   $0x1
  8024c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024c6:	50                   	push   %eax
  8024c7:	6a 00                	push   $0x0
  8024c9:	e8 31 f0 ff ff       	call   8014ff <read>
	if (r < 0)
  8024ce:	83 c4 10             	add    $0x10,%esp
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	78 08                	js     8024dd <getchar+0x22>
	if (r < 1)
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	7e 06                	jle    8024df <getchar+0x24>
	return c;
  8024d9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    
		return -E_EOF;
  8024df:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024e4:	eb f7                	jmp    8024dd <getchar+0x22>

008024e6 <iscons>:
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ef:	50                   	push   %eax
  8024f0:	ff 75 08             	pushl  0x8(%ebp)
  8024f3:	e8 9a ed ff ff       	call   801292 <fd_lookup>
  8024f8:	83 c4 10             	add    $0x10,%esp
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	78 11                	js     802510 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802508:	39 10                	cmp    %edx,(%eax)
  80250a:	0f 94 c0             	sete   %al
  80250d:	0f b6 c0             	movzbl %al,%eax
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <opencons>:
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
  802515:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802518:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251b:	50                   	push   %eax
  80251c:	e8 22 ed ff ff       	call   801243 <fd_alloc>
  802521:	83 c4 10             	add    $0x10,%esp
  802524:	85 c0                	test   %eax,%eax
  802526:	78 3a                	js     802562 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802528:	83 ec 04             	sub    $0x4,%esp
  80252b:	68 07 04 00 00       	push   $0x407
  802530:	ff 75 f4             	pushl  -0xc(%ebp)
  802533:	6a 00                	push   $0x0
  802535:	e8 a8 e7 ff ff       	call   800ce2 <sys_page_alloc>
  80253a:	83 c4 10             	add    $0x10,%esp
  80253d:	85 c0                	test   %eax,%eax
  80253f:	78 21                	js     802562 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802541:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802556:	83 ec 0c             	sub    $0xc,%esp
  802559:	50                   	push   %eax
  80255a:	e8 bd ec ff ff       	call   80121c <fd2num>
  80255f:	83 c4 10             	add    $0x10,%esp
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80256a:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802571:	74 0a                	je     80257d <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  80257d:	e8 41 e7 ff ff       	call   800cc3 <sys_getenvid>
  802582:	83 ec 04             	sub    $0x4,%esp
  802585:	6a 07                	push   $0x7
  802587:	68 00 f0 bf ee       	push   $0xeebff000
  80258c:	50                   	push   %eax
  80258d:	e8 50 e7 ff ff       	call   800ce2 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802592:	e8 2c e7 ff ff       	call   800cc3 <sys_getenvid>
  802597:	83 c4 08             	add    $0x8,%esp
  80259a:	68 aa 25 80 00       	push   $0x8025aa
  80259f:	50                   	push   %eax
  8025a0:	e8 e8 e8 ff ff       	call   800e8d <sys_env_set_pgfault_upcall>
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	eb c9                	jmp    802573 <set_pgfault_handler+0xf>

008025aa <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025aa:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025ab:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025b0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025b2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  8025b5:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8025b9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8025bd:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8025c0:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8025c2:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  8025c6:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8025c9:	61                   	popa   
	addl $4, %esp
  8025ca:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8025cd:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8025ce:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8025cf:	c3                   	ret    

008025d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	57                   	push   %edi
  8025d4:	56                   	push   %esi
  8025d5:	53                   	push   %ebx
  8025d6:	83 ec 0c             	sub    $0xc,%esp
  8025d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8025dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025df:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  8025e2:	85 ff                	test   %edi,%edi
  8025e4:	74 53                	je     802639 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  8025e6:	83 ec 0c             	sub    $0xc,%esp
  8025e9:	57                   	push   %edi
  8025ea:	e8 03 e9 ff ff       	call   800ef2 <sys_ipc_recv>
  8025ef:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  8025f2:	85 db                	test   %ebx,%ebx
  8025f4:	74 0b                	je     802601 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8025f6:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8025fc:	8b 52 74             	mov    0x74(%edx),%edx
  8025ff:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  802601:	85 f6                	test   %esi,%esi
  802603:	74 0f                	je     802614 <ipc_recv+0x44>
  802605:	85 ff                	test   %edi,%edi
  802607:	74 0b                	je     802614 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802609:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80260f:	8b 52 78             	mov    0x78(%edx),%edx
  802612:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  802614:	85 c0                	test   %eax,%eax
  802616:	74 30                	je     802648 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802618:	85 db                	test   %ebx,%ebx
  80261a:	74 06                	je     802622 <ipc_recv+0x52>
      		*from_env_store = 0;
  80261c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  802622:	85 f6                	test   %esi,%esi
  802624:	74 2c                	je     802652 <ipc_recv+0x82>
      		*perm_store = 0;
  802626:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80262c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  802631:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802634:	5b                   	pop    %ebx
  802635:	5e                   	pop    %esi
  802636:	5f                   	pop    %edi
  802637:	5d                   	pop    %ebp
  802638:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  802639:	83 ec 0c             	sub    $0xc,%esp
  80263c:	6a ff                	push   $0xffffffff
  80263e:	e8 af e8 ff ff       	call   800ef2 <sys_ipc_recv>
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	eb aa                	jmp    8025f2 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  802648:	a1 04 50 80 00       	mov    0x805004,%eax
  80264d:	8b 40 70             	mov    0x70(%eax),%eax
  802650:	eb df                	jmp    802631 <ipc_recv+0x61>
		return -1;
  802652:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802657:	eb d8                	jmp    802631 <ipc_recv+0x61>

00802659 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	57                   	push   %edi
  80265d:	56                   	push   %esi
  80265e:	53                   	push   %ebx
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	8b 75 0c             	mov    0xc(%ebp),%esi
  802665:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802668:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  80266b:	85 db                	test   %ebx,%ebx
  80266d:	75 22                	jne    802691 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  80266f:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  802674:	eb 1b                	jmp    802691 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  802676:	68 08 30 80 00       	push   $0x803008
  80267b:	68 36 2e 80 00       	push   $0x802e36
  802680:	6a 48                	push   $0x48
  802682:	68 2c 30 80 00       	push   $0x80302c
  802687:	e8 86 db ff ff       	call   800212 <_panic>
		sys_yield();
  80268c:	e8 18 e7 ff ff       	call   800da9 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  802691:	57                   	push   %edi
  802692:	53                   	push   %ebx
  802693:	56                   	push   %esi
  802694:	ff 75 08             	pushl  0x8(%ebp)
  802697:	e8 33 e8 ff ff       	call   800ecf <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  80269c:	83 c4 10             	add    $0x10,%esp
  80269f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026a2:	74 e8                	je     80268c <ipc_send+0x33>
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	75 ce                	jne    802676 <ipc_send+0x1d>
		sys_yield();
  8026a8:	e8 fc e6 ff ff       	call   800da9 <sys_yield>
		
	}
	
}
  8026ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b0:	5b                   	pop    %ebx
  8026b1:	5e                   	pop    %esi
  8026b2:	5f                   	pop    %edi
  8026b3:	5d                   	pop    %ebp
  8026b4:	c3                   	ret    

008026b5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026bb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026c0:	89 c2                	mov    %eax,%edx
  8026c2:	c1 e2 05             	shl    $0x5,%edx
  8026c5:	29 c2                	sub    %eax,%edx
  8026c7:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  8026ce:	8b 52 50             	mov    0x50(%edx),%edx
  8026d1:	39 ca                	cmp    %ecx,%edx
  8026d3:	74 0f                	je     8026e4 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8026d5:	40                   	inc    %eax
  8026d6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026db:	75 e3                	jne    8026c0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e2:	eb 11                	jmp    8026f5 <ipc_find_env+0x40>
			return envs[i].env_id;
  8026e4:	89 c2                	mov    %eax,%edx
  8026e6:	c1 e2 05             	shl    $0x5,%edx
  8026e9:	29 c2                	sub    %eax,%edx
  8026eb:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8026f2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026f5:	5d                   	pop    %ebp
  8026f6:	c3                   	ret    

008026f7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	c1 e8 16             	shr    $0x16,%eax
  802700:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802707:	a8 01                	test   $0x1,%al
  802709:	74 21                	je     80272c <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	c1 e8 0c             	shr    $0xc,%eax
  802711:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802718:	a8 01                	test   $0x1,%al
  80271a:	74 17                	je     802733 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80271c:	c1 e8 0c             	shr    $0xc,%eax
  80271f:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802726:	ef 
  802727:	0f b7 c0             	movzwl %ax,%eax
  80272a:	eb 05                	jmp    802731 <pageref+0x3a>
		return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    
		return 0;
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	eb f7                	jmp    802731 <pageref+0x3a>
  80273a:	66 90                	xchg   %ax,%ax

0080273c <__udivdi3>:
  80273c:	55                   	push   %ebp
  80273d:	57                   	push   %edi
  80273e:	56                   	push   %esi
  80273f:	53                   	push   %ebx
  802740:	83 ec 1c             	sub    $0x1c,%esp
  802743:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802747:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80274b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80274f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802753:	89 ca                	mov    %ecx,%edx
  802755:	89 f8                	mov    %edi,%eax
  802757:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80275b:	85 f6                	test   %esi,%esi
  80275d:	75 2d                	jne    80278c <__udivdi3+0x50>
  80275f:	39 cf                	cmp    %ecx,%edi
  802761:	77 65                	ja     8027c8 <__udivdi3+0x8c>
  802763:	89 fd                	mov    %edi,%ebp
  802765:	85 ff                	test   %edi,%edi
  802767:	75 0b                	jne    802774 <__udivdi3+0x38>
  802769:	b8 01 00 00 00       	mov    $0x1,%eax
  80276e:	31 d2                	xor    %edx,%edx
  802770:	f7 f7                	div    %edi
  802772:	89 c5                	mov    %eax,%ebp
  802774:	31 d2                	xor    %edx,%edx
  802776:	89 c8                	mov    %ecx,%eax
  802778:	f7 f5                	div    %ebp
  80277a:	89 c1                	mov    %eax,%ecx
  80277c:	89 d8                	mov    %ebx,%eax
  80277e:	f7 f5                	div    %ebp
  802780:	89 cf                	mov    %ecx,%edi
  802782:	89 fa                	mov    %edi,%edx
  802784:	83 c4 1c             	add    $0x1c,%esp
  802787:	5b                   	pop    %ebx
  802788:	5e                   	pop    %esi
  802789:	5f                   	pop    %edi
  80278a:	5d                   	pop    %ebp
  80278b:	c3                   	ret    
  80278c:	39 ce                	cmp    %ecx,%esi
  80278e:	77 28                	ja     8027b8 <__udivdi3+0x7c>
  802790:	0f bd fe             	bsr    %esi,%edi
  802793:	83 f7 1f             	xor    $0x1f,%edi
  802796:	75 40                	jne    8027d8 <__udivdi3+0x9c>
  802798:	39 ce                	cmp    %ecx,%esi
  80279a:	72 0a                	jb     8027a6 <__udivdi3+0x6a>
  80279c:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8027a0:	0f 87 9e 00 00 00    	ja     802844 <__udivdi3+0x108>
  8027a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ab:	89 fa                	mov    %edi,%edx
  8027ad:	83 c4 1c             	add    $0x1c,%esp
  8027b0:	5b                   	pop    %ebx
  8027b1:	5e                   	pop    %esi
  8027b2:	5f                   	pop    %edi
  8027b3:	5d                   	pop    %ebp
  8027b4:	c3                   	ret    
  8027b5:	8d 76 00             	lea    0x0(%esi),%esi
  8027b8:	31 ff                	xor    %edi,%edi
  8027ba:	31 c0                	xor    %eax,%eax
  8027bc:	89 fa                	mov    %edi,%edx
  8027be:	83 c4 1c             	add    $0x1c,%esp
  8027c1:	5b                   	pop    %ebx
  8027c2:	5e                   	pop    %esi
  8027c3:	5f                   	pop    %edi
  8027c4:	5d                   	pop    %ebp
  8027c5:	c3                   	ret    
  8027c6:	66 90                	xchg   %ax,%ax
  8027c8:	89 d8                	mov    %ebx,%eax
  8027ca:	f7 f7                	div    %edi
  8027cc:	31 ff                	xor    %edi,%edi
  8027ce:	89 fa                	mov    %edi,%edx
  8027d0:	83 c4 1c             	add    $0x1c,%esp
  8027d3:	5b                   	pop    %ebx
  8027d4:	5e                   	pop    %esi
  8027d5:	5f                   	pop    %edi
  8027d6:	5d                   	pop    %ebp
  8027d7:	c3                   	ret    
  8027d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027dd:	29 fd                	sub    %edi,%ebp
  8027df:	89 f9                	mov    %edi,%ecx
  8027e1:	d3 e6                	shl    %cl,%esi
  8027e3:	89 c3                	mov    %eax,%ebx
  8027e5:	89 e9                	mov    %ebp,%ecx
  8027e7:	d3 eb                	shr    %cl,%ebx
  8027e9:	89 d9                	mov    %ebx,%ecx
  8027eb:	09 f1                	or     %esi,%ecx
  8027ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027f1:	89 f9                	mov    %edi,%ecx
  8027f3:	d3 e0                	shl    %cl,%eax
  8027f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027f9:	89 d6                	mov    %edx,%esi
  8027fb:	89 e9                	mov    %ebp,%ecx
  8027fd:	d3 ee                	shr    %cl,%esi
  8027ff:	89 f9                	mov    %edi,%ecx
  802801:	d3 e2                	shl    %cl,%edx
  802803:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802807:	89 e9                	mov    %ebp,%ecx
  802809:	d3 eb                	shr    %cl,%ebx
  80280b:	09 da                	or     %ebx,%edx
  80280d:	89 d0                	mov    %edx,%eax
  80280f:	89 f2                	mov    %esi,%edx
  802811:	f7 74 24 08          	divl   0x8(%esp)
  802815:	89 d6                	mov    %edx,%esi
  802817:	89 c3                	mov    %eax,%ebx
  802819:	f7 64 24 0c          	mull   0xc(%esp)
  80281d:	39 d6                	cmp    %edx,%esi
  80281f:	72 17                	jb     802838 <__udivdi3+0xfc>
  802821:	74 09                	je     80282c <__udivdi3+0xf0>
  802823:	89 d8                	mov    %ebx,%eax
  802825:	31 ff                	xor    %edi,%edi
  802827:	e9 56 ff ff ff       	jmp    802782 <__udivdi3+0x46>
  80282c:	8b 54 24 04          	mov    0x4(%esp),%edx
  802830:	89 f9                	mov    %edi,%ecx
  802832:	d3 e2                	shl    %cl,%edx
  802834:	39 c2                	cmp    %eax,%edx
  802836:	73 eb                	jae    802823 <__udivdi3+0xe7>
  802838:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80283b:	31 ff                	xor    %edi,%edi
  80283d:	e9 40 ff ff ff       	jmp    802782 <__udivdi3+0x46>
  802842:	66 90                	xchg   %ax,%ax
  802844:	31 c0                	xor    %eax,%eax
  802846:	e9 37 ff ff ff       	jmp    802782 <__udivdi3+0x46>
  80284b:	90                   	nop

0080284c <__umoddi3>:
  80284c:	55                   	push   %ebp
  80284d:	57                   	push   %edi
  80284e:	56                   	push   %esi
  80284f:	53                   	push   %ebx
  802850:	83 ec 1c             	sub    $0x1c,%esp
  802853:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802857:	8b 74 24 34          	mov    0x34(%esp),%esi
  80285b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80285f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802863:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802867:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80286b:	89 3c 24             	mov    %edi,(%esp)
  80286e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802872:	89 f2                	mov    %esi,%edx
  802874:	85 c0                	test   %eax,%eax
  802876:	75 18                	jne    802890 <__umoddi3+0x44>
  802878:	39 f7                	cmp    %esi,%edi
  80287a:	0f 86 a0 00 00 00    	jbe    802920 <__umoddi3+0xd4>
  802880:	89 c8                	mov    %ecx,%eax
  802882:	f7 f7                	div    %edi
  802884:	89 d0                	mov    %edx,%eax
  802886:	31 d2                	xor    %edx,%edx
  802888:	83 c4 1c             	add    $0x1c,%esp
  80288b:	5b                   	pop    %ebx
  80288c:	5e                   	pop    %esi
  80288d:	5f                   	pop    %edi
  80288e:	5d                   	pop    %ebp
  80288f:	c3                   	ret    
  802890:	89 f3                	mov    %esi,%ebx
  802892:	39 f0                	cmp    %esi,%eax
  802894:	0f 87 a6 00 00 00    	ja     802940 <__umoddi3+0xf4>
  80289a:	0f bd e8             	bsr    %eax,%ebp
  80289d:	83 f5 1f             	xor    $0x1f,%ebp
  8028a0:	0f 84 a6 00 00 00    	je     80294c <__umoddi3+0x100>
  8028a6:	bf 20 00 00 00       	mov    $0x20,%edi
  8028ab:	29 ef                	sub    %ebp,%edi
  8028ad:	89 e9                	mov    %ebp,%ecx
  8028af:	d3 e0                	shl    %cl,%eax
  8028b1:	8b 34 24             	mov    (%esp),%esi
  8028b4:	89 f2                	mov    %esi,%edx
  8028b6:	89 f9                	mov    %edi,%ecx
  8028b8:	d3 ea                	shr    %cl,%edx
  8028ba:	09 c2                	or     %eax,%edx
  8028bc:	89 14 24             	mov    %edx,(%esp)
  8028bf:	89 f2                	mov    %esi,%edx
  8028c1:	89 e9                	mov    %ebp,%ecx
  8028c3:	d3 e2                	shl    %cl,%edx
  8028c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028c9:	89 de                	mov    %ebx,%esi
  8028cb:	89 f9                	mov    %edi,%ecx
  8028cd:	d3 ee                	shr    %cl,%esi
  8028cf:	89 e9                	mov    %ebp,%ecx
  8028d1:	d3 e3                	shl    %cl,%ebx
  8028d3:	8b 54 24 08          	mov    0x8(%esp),%edx
  8028d7:	89 d0                	mov    %edx,%eax
  8028d9:	89 f9                	mov    %edi,%ecx
  8028db:	d3 e8                	shr    %cl,%eax
  8028dd:	09 d8                	or     %ebx,%eax
  8028df:	89 d3                	mov    %edx,%ebx
  8028e1:	89 e9                	mov    %ebp,%ecx
  8028e3:	d3 e3                	shl    %cl,%ebx
  8028e5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028e9:	89 f2                	mov    %esi,%edx
  8028eb:	f7 34 24             	divl   (%esp)
  8028ee:	89 d6                	mov    %edx,%esi
  8028f0:	f7 64 24 04          	mull   0x4(%esp)
  8028f4:	89 c3                	mov    %eax,%ebx
  8028f6:	89 d1                	mov    %edx,%ecx
  8028f8:	39 d6                	cmp    %edx,%esi
  8028fa:	72 7c                	jb     802978 <__umoddi3+0x12c>
  8028fc:	74 72                	je     802970 <__umoddi3+0x124>
  8028fe:	8b 54 24 08          	mov    0x8(%esp),%edx
  802902:	29 da                	sub    %ebx,%edx
  802904:	19 ce                	sbb    %ecx,%esi
  802906:	89 f0                	mov    %esi,%eax
  802908:	89 f9                	mov    %edi,%ecx
  80290a:	d3 e0                	shl    %cl,%eax
  80290c:	89 e9                	mov    %ebp,%ecx
  80290e:	d3 ea                	shr    %cl,%edx
  802910:	09 d0                	or     %edx,%eax
  802912:	89 e9                	mov    %ebp,%ecx
  802914:	d3 ee                	shr    %cl,%esi
  802916:	89 f2                	mov    %esi,%edx
  802918:	83 c4 1c             	add    $0x1c,%esp
  80291b:	5b                   	pop    %ebx
  80291c:	5e                   	pop    %esi
  80291d:	5f                   	pop    %edi
  80291e:	5d                   	pop    %ebp
  80291f:	c3                   	ret    
  802920:	89 fd                	mov    %edi,%ebp
  802922:	85 ff                	test   %edi,%edi
  802924:	75 0b                	jne    802931 <__umoddi3+0xe5>
  802926:	b8 01 00 00 00       	mov    $0x1,%eax
  80292b:	31 d2                	xor    %edx,%edx
  80292d:	f7 f7                	div    %edi
  80292f:	89 c5                	mov    %eax,%ebp
  802931:	89 f0                	mov    %esi,%eax
  802933:	31 d2                	xor    %edx,%edx
  802935:	f7 f5                	div    %ebp
  802937:	89 c8                	mov    %ecx,%eax
  802939:	f7 f5                	div    %ebp
  80293b:	e9 44 ff ff ff       	jmp    802884 <__umoddi3+0x38>
  802940:	89 c8                	mov    %ecx,%eax
  802942:	89 f2                	mov    %esi,%edx
  802944:	83 c4 1c             	add    $0x1c,%esp
  802947:	5b                   	pop    %ebx
  802948:	5e                   	pop    %esi
  802949:	5f                   	pop    %edi
  80294a:	5d                   	pop    %ebp
  80294b:	c3                   	ret    
  80294c:	39 f0                	cmp    %esi,%eax
  80294e:	72 05                	jb     802955 <__umoddi3+0x109>
  802950:	39 0c 24             	cmp    %ecx,(%esp)
  802953:	77 0c                	ja     802961 <__umoddi3+0x115>
  802955:	89 f2                	mov    %esi,%edx
  802957:	29 f9                	sub    %edi,%ecx
  802959:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80295d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802961:	8b 44 24 04          	mov    0x4(%esp),%eax
  802965:	83 c4 1c             	add    $0x1c,%esp
  802968:	5b                   	pop    %ebx
  802969:	5e                   	pop    %esi
  80296a:	5f                   	pop    %edi
  80296b:	5d                   	pop    %ebp
  80296c:	c3                   	ret    
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802974:	73 88                	jae    8028fe <__umoddi3+0xb2>
  802976:	66 90                	xchg   %ax,%ax
  802978:	2b 44 24 04          	sub    0x4(%esp),%eax
  80297c:	1b 14 24             	sbb    (%esp),%edx
  80297f:	89 d1                	mov    %edx,%ecx
  802981:	89 c3                	mov    %eax,%ebx
  802983:	e9 76 ff ff ff       	jmp    8028fe <__umoddi3+0xb2>
