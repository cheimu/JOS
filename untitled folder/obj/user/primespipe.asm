
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 07 02 00 00       	call   800238 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	83 ec 04             	sub    $0x4,%esp
  800048:	6a 04                	push   $0x4
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	e8 c1 15 00 00       	call   801612 <readn>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	83 f8 04             	cmp    $0x4,%eax
  800057:	75 4b                	jne    8000a4 <primeproc+0x71>
	cprintf("%d\n", p);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	ff 75 e0             	pushl  -0x20(%ebp)
  80005f:	68 21 24 80 00       	push   $0x802421
  800064:	e8 48 03 00 00       	call   8003b1 <cprintf>
	if ((i=pipe(pfd)) < 0)
  800069:	89 3c 24             	mov    %edi,(%esp)
  80006c:	e8 33 1c 00 00       	call   801ca4 <pipe>
  800071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	85 c0                	test   %eax,%eax
  800079:	78 4a                	js     8000c5 <primeproc+0x92>
		panic("pipe: %e", i);
	if ((id = fork()) < 0)
  80007b:	e8 67 10 00 00       	call   8010e7 <fork>
  800080:	85 c0                	test   %eax,%eax
  800082:	78 53                	js     8000d7 <primeproc+0xa4>
		panic("fork: %e", id);
	if (id == 0) {
  800084:	85 c0                	test   %eax,%eax
  800086:	75 61                	jne    8000e9 <primeproc+0xb6>
		close(fd);
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	53                   	push   %ebx
  80008c:	e8 c0 13 00 00       	call   801451 <close>
		close(pfd[1]);
  800091:	83 c4 04             	add    $0x4,%esp
  800094:	ff 75 dc             	pushl  -0x24(%ebp)
  800097:	e8 b5 13 00 00       	call   801451 <close>
		fd = pfd[0];
  80009c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb a1                	jmp    800045 <primeproc+0x12>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	89 c2                	mov    %eax,%edx
  8000a9:	85 c0                	test   %eax,%eax
  8000ab:	7e 05                	jle    8000b2 <primeproc+0x7f>
  8000ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b2:	52                   	push   %edx
  8000b3:	50                   	push   %eax
  8000b4:	68 e0 23 80 00       	push   $0x8023e0
  8000b9:	6a 15                	push   $0x15
  8000bb:	68 0f 24 80 00       	push   $0x80240f
  8000c0:	e8 d9 01 00 00       	call   80029e <_panic>
		panic("pipe: %e", i);
  8000c5:	50                   	push   %eax
  8000c6:	68 25 24 80 00       	push   $0x802425
  8000cb:	6a 1b                	push   $0x1b
  8000cd:	68 0f 24 80 00       	push   $0x80240f
  8000d2:	e8 c7 01 00 00       	call   80029e <_panic>
		panic("fork: %e", id);
  8000d7:	50                   	push   %eax
  8000d8:	68 2e 24 80 00       	push   $0x80242e
  8000dd:	6a 1d                	push   $0x1d
  8000df:	68 0f 24 80 00       	push   $0x80240f
  8000e4:	e8 b5 01 00 00       	call   80029e <_panic>
	}

	close(pfd[0]);
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ef:	e8 5d 13 00 00       	call   801451 <close>
	wfd = pfd[1];
  8000f4:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f7:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000fa:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fd:	83 ec 04             	sub    $0x4,%esp
  800100:	6a 04                	push   $0x4
  800102:	56                   	push   %esi
  800103:	53                   	push   %ebx
  800104:	e8 09 15 00 00       	call   801612 <readn>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	83 f8 04             	cmp    $0x4,%eax
  80010f:	75 43                	jne    800154 <primeproc+0x121>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	99                   	cltd   
  800115:	f7 7d e0             	idivl  -0x20(%ebp)
  800118:	85 d2                	test   %edx,%edx
  80011a:	74 e1                	je     8000fd <primeproc+0xca>
			if ((r=write(wfd, &i, 4)) != 4)
  80011c:	83 ec 04             	sub    $0x4,%esp
  80011f:	6a 04                	push   $0x4
  800121:	56                   	push   %esi
  800122:	57                   	push   %edi
  800123:	e8 31 15 00 00       	call   801659 <write>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	83 f8 04             	cmp    $0x4,%eax
  80012e:	74 cd                	je     8000fd <primeproc+0xca>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	89 c2                	mov    %eax,%edx
  800135:	85 c0                	test   %eax,%eax
  800137:	7e 05                	jle    80013e <primeproc+0x10b>
  800139:	ba 00 00 00 00       	mov    $0x0,%edx
  80013e:	52                   	push   %edx
  80013f:	50                   	push   %eax
  800140:	ff 75 e0             	pushl  -0x20(%ebp)
  800143:	68 53 24 80 00       	push   $0x802453
  800148:	6a 2e                	push   $0x2e
  80014a:	68 0f 24 80 00       	push   $0x80240f
  80014f:	e8 4a 01 00 00       	call   80029e <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	89 c2                	mov    %eax,%edx
  800159:	85 c0                	test   %eax,%eax
  80015b:	7e 05                	jle    800162 <primeproc+0x12f>
  80015d:	ba 00 00 00 00       	mov    $0x0,%edx
  800162:	52                   	push   %edx
  800163:	50                   	push   %eax
  800164:	53                   	push   %ebx
  800165:	ff 75 e0             	pushl  -0x20(%ebp)
  800168:	68 37 24 80 00       	push   $0x802437
  80016d:	6a 2b                	push   $0x2b
  80016f:	68 0f 24 80 00       	push   $0x80240f
  800174:	e8 25 01 00 00       	call   80029e <_panic>

00800179 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	53                   	push   %ebx
  80017d:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  800180:	c7 05 00 30 80 00 6d 	movl   $0x80246d,0x803000
  800187:	24 80 00 

	if ((i=pipe(p)) < 0)
  80018a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	e8 11 1b 00 00       	call   801ca4 <pipe>
  800193:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	85 c0                	test   %eax,%eax
  80019b:	78 23                	js     8001c0 <umain+0x47>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80019d:	e8 45 0f 00 00       	call   8010e7 <fork>
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	78 2c                	js     8001d2 <umain+0x59>
		panic("fork: %e", id);

	if (id == 0) {
  8001a6:	85 c0                	test   %eax,%eax
  8001a8:	75 3a                	jne    8001e4 <umain+0x6b>
		close(p[1]);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b0:	e8 9c 12 00 00       	call   801451 <close>
		primeproc(p[0]);
  8001b5:	83 c4 04             	add    $0x4,%esp
  8001b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bb:	e8 73 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001c0:	50                   	push   %eax
  8001c1:	68 25 24 80 00       	push   $0x802425
  8001c6:	6a 3a                	push   $0x3a
  8001c8:	68 0f 24 80 00       	push   $0x80240f
  8001cd:	e8 cc 00 00 00       	call   80029e <_panic>
		panic("fork: %e", id);
  8001d2:	50                   	push   %eax
  8001d3:	68 2e 24 80 00       	push   $0x80242e
  8001d8:	6a 3e                	push   $0x3e
  8001da:	68 0f 24 80 00       	push   $0x80240f
  8001df:	e8 ba 00 00 00       	call   80029e <_panic>
	}

	close(p[0]);
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ea:	e8 62 12 00 00       	call   801451 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001ef:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f6:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f9:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 04                	push   $0x4
  800201:	53                   	push   %ebx
  800202:	ff 75 f0             	pushl  -0x10(%ebp)
  800205:	e8 4f 14 00 00       	call   801659 <write>
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	83 f8 04             	cmp    $0x4,%eax
  800210:	75 05                	jne    800217 <umain+0x9e>
	for (i=2;; i++)
  800212:	ff 45 f4             	incl   -0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800215:	eb e5                	jmp    8001fc <umain+0x83>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	89 c2                	mov    %eax,%edx
  80021c:	85 c0                	test   %eax,%eax
  80021e:	7e 05                	jle    800225 <umain+0xac>
  800220:	ba 00 00 00 00       	mov    $0x0,%edx
  800225:	52                   	push   %edx
  800226:	50                   	push   %eax
  800227:	68 78 24 80 00       	push   $0x802478
  80022c:	6a 4a                	push   $0x4a
  80022e:	68 0f 24 80 00       	push   $0x80240f
  800233:	e8 66 00 00 00       	call   80029e <_panic>

00800238 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800240:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800243:	e8 07 0b 00 00       	call   800d4f <sys_getenvid>
  800248:	25 ff 03 00 00       	and    $0x3ff,%eax
  80024d:	89 c2                	mov    %eax,%edx
  80024f:	c1 e2 05             	shl    $0x5,%edx
  800252:	29 c2                	sub    %eax,%edx
  800254:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80025b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800260:	85 db                	test   %ebx,%ebx
  800262:	7e 07                	jle    80026b <libmain+0x33>
		binaryname = argv[0];
  800264:	8b 06                	mov    (%esi),%eax
  800266:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	56                   	push   %esi
  80026f:	53                   	push   %ebx
  800270:	e8 04 ff ff ff       	call   800179 <umain>

	// exit gracefully
	exit();
  800275:	e8 0a 00 00 00       	call   800284 <exit>
}
  80027a:	83 c4 10             	add    $0x10,%esp
  80027d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800280:	5b                   	pop    %ebx
  800281:	5e                   	pop    %esi
  800282:	5d                   	pop    %ebp
  800283:	c3                   	ret    

00800284 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80028a:	e8 ed 11 00 00       	call   80147c <close_all>
	sys_env_destroy(0);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	6a 00                	push   $0x0
  800294:	e8 75 0a 00 00       	call   800d0e <sys_env_destroy>
}
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	c9                   	leave  
  80029d:	c3                   	ret    

0080029e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	57                   	push   %edi
  8002a2:	56                   	push   %esi
  8002a3:	53                   	push   %ebx
  8002a4:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  8002aa:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  8002ad:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8002b3:	e8 97 0a 00 00       	call   800d4f <sys_getenvid>
  8002b8:	83 ec 04             	sub    $0x4,%esp
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	53                   	push   %ebx
  8002c2:	50                   	push   %eax
  8002c3:	68 9c 24 80 00       	push   $0x80249c
  8002c8:	68 00 01 00 00       	push   $0x100
  8002cd:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  8002d3:	56                   	push   %esi
  8002d4:	e8 93 06 00 00       	call   80096c <snprintf>
  8002d9:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  8002db:	83 c4 20             	add    $0x20,%esp
  8002de:	57                   	push   %edi
  8002df:	ff 75 10             	pushl  0x10(%ebp)
  8002e2:	bf 00 01 00 00       	mov    $0x100,%edi
  8002e7:	89 f8                	mov    %edi,%eax
  8002e9:	29 d8                	sub    %ebx,%eax
  8002eb:	50                   	push   %eax
  8002ec:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8002ef:	50                   	push   %eax
  8002f0:	e8 22 06 00 00       	call   800917 <vsnprintf>
  8002f5:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8002f7:	83 c4 0c             	add    $0xc,%esp
  8002fa:	68 23 24 80 00       	push   $0x802423
  8002ff:	29 df                	sub    %ebx,%edi
  800301:	57                   	push   %edi
  800302:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800305:	50                   	push   %eax
  800306:	e8 61 06 00 00       	call   80096c <snprintf>
	sys_cputs(buf, r);
  80030b:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80030e:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800310:	53                   	push   %ebx
  800311:	56                   	push   %esi
  800312:	e8 ba 09 00 00       	call   800cd1 <sys_cputs>
  800317:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80031a:	cc                   	int3   
  80031b:	eb fd                	jmp    80031a <_panic+0x7c>

0080031d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	53                   	push   %ebx
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800327:	8b 13                	mov    (%ebx),%edx
  800329:	8d 42 01             	lea    0x1(%edx),%eax
  80032c:	89 03                	mov    %eax,(%ebx)
  80032e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800331:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800335:	3d ff 00 00 00       	cmp    $0xff,%eax
  80033a:	74 08                	je     800344 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80033c:	ff 43 04             	incl   0x4(%ebx)
}
  80033f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800342:	c9                   	leave  
  800343:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	68 ff 00 00 00       	push   $0xff
  80034c:	8d 43 08             	lea    0x8(%ebx),%eax
  80034f:	50                   	push   %eax
  800350:	e8 7c 09 00 00       	call   800cd1 <sys_cputs>
		b->idx = 0;
  800355:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80035b:	83 c4 10             	add    $0x10,%esp
  80035e:	eb dc                	jmp    80033c <putch+0x1f>

00800360 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800369:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800370:	00 00 00 
	b.cnt = 0;
  800373:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80037a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80037d:	ff 75 0c             	pushl  0xc(%ebp)
  800380:	ff 75 08             	pushl  0x8(%ebp)
  800383:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800389:	50                   	push   %eax
  80038a:	68 1d 03 80 00       	push   $0x80031d
  80038f:	e8 17 01 00 00       	call   8004ab <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800394:	83 c4 08             	add    $0x8,%esp
  800397:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80039d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003a3:	50                   	push   %eax
  8003a4:	e8 28 09 00 00       	call   800cd1 <sys_cputs>

	return b.cnt;
}
  8003a9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003af:	c9                   	leave  
  8003b0:	c3                   	ret    

008003b1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 08             	pushl  0x8(%ebp)
  8003be:	e8 9d ff ff ff       	call   800360 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003c3:	c9                   	leave  
  8003c4:	c3                   	ret    

008003c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	57                   	push   %edi
  8003c9:	56                   	push   %esi
  8003ca:	53                   	push   %ebx
  8003cb:	83 ec 1c             	sub    $0x1c,%esp
  8003ce:	89 c7                	mov    %eax,%edi
  8003d0:	89 d6                	mov    %edx,%esi
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003db:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003ec:	39 d3                	cmp    %edx,%ebx
  8003ee:	72 05                	jb     8003f5 <printnum+0x30>
  8003f0:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003f3:	77 78                	ja     80046d <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	ff 75 18             	pushl  0x18(%ebp)
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800401:	53                   	push   %ebx
  800402:	ff 75 10             	pushl  0x10(%ebp)
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 e4             	pushl  -0x1c(%ebp)
  80040b:	ff 75 e0             	pushl  -0x20(%ebp)
  80040e:	ff 75 dc             	pushl  -0x24(%ebp)
  800411:	ff 75 d8             	pushl  -0x28(%ebp)
  800414:	e8 73 1d 00 00       	call   80218c <__udivdi3>
  800419:	83 c4 18             	add    $0x18,%esp
  80041c:	52                   	push   %edx
  80041d:	50                   	push   %eax
  80041e:	89 f2                	mov    %esi,%edx
  800420:	89 f8                	mov    %edi,%eax
  800422:	e8 9e ff ff ff       	call   8003c5 <printnum>
  800427:	83 c4 20             	add    $0x20,%esp
  80042a:	eb 11                	jmp    80043d <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	56                   	push   %esi
  800430:	ff 75 18             	pushl  0x18(%ebp)
  800433:	ff d7                	call   *%edi
  800435:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800438:	4b                   	dec    %ebx
  800439:	85 db                	test   %ebx,%ebx
  80043b:	7f ef                	jg     80042c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	56                   	push   %esi
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	ff 75 e4             	pushl  -0x1c(%ebp)
  800447:	ff 75 e0             	pushl  -0x20(%ebp)
  80044a:	ff 75 dc             	pushl  -0x24(%ebp)
  80044d:	ff 75 d8             	pushl  -0x28(%ebp)
  800450:	e8 47 1e 00 00       	call   80229c <__umoddi3>
  800455:	83 c4 14             	add    $0x14,%esp
  800458:	0f be 80 bf 24 80 00 	movsbl 0x8024bf(%eax),%eax
  80045f:	50                   	push   %eax
  800460:	ff d7                	call   *%edi
}
  800462:	83 c4 10             	add    $0x10,%esp
  800465:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800468:	5b                   	pop    %ebx
  800469:	5e                   	pop    %esi
  80046a:	5f                   	pop    %edi
  80046b:	5d                   	pop    %ebp
  80046c:	c3                   	ret    
  80046d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800470:	eb c6                	jmp    800438 <printnum+0x73>

00800472 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800478:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80047b:	8b 10                	mov    (%eax),%edx
  80047d:	3b 50 04             	cmp    0x4(%eax),%edx
  800480:	73 0a                	jae    80048c <sprintputch+0x1a>
		*b->buf++ = ch;
  800482:	8d 4a 01             	lea    0x1(%edx),%ecx
  800485:	89 08                	mov    %ecx,(%eax)
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	88 02                	mov    %al,(%edx)
}
  80048c:	5d                   	pop    %ebp
  80048d:	c3                   	ret    

0080048e <printfmt>:
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800494:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800497:	50                   	push   %eax
  800498:	ff 75 10             	pushl  0x10(%ebp)
  80049b:	ff 75 0c             	pushl  0xc(%ebp)
  80049e:	ff 75 08             	pushl  0x8(%ebp)
  8004a1:	e8 05 00 00 00       	call   8004ab <vprintfmt>
}
  8004a6:	83 c4 10             	add    $0x10,%esp
  8004a9:	c9                   	leave  
  8004aa:	c3                   	ret    

008004ab <vprintfmt>:
{
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	57                   	push   %edi
  8004af:	56                   	push   %esi
  8004b0:	53                   	push   %ebx
  8004b1:	83 ec 2c             	sub    $0x2c,%esp
  8004b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ba:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004bd:	e9 ae 03 00 00       	jmp    800870 <vprintfmt+0x3c5>
  8004c2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004c6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004cd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004db:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e0:	8d 47 01             	lea    0x1(%edi),%eax
  8004e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004e6:	8a 17                	mov    (%edi),%dl
  8004e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004eb:	3c 55                	cmp    $0x55,%al
  8004ed:	0f 87 fe 03 00 00    	ja     8008f1 <vprintfmt+0x446>
  8004f3:	0f b6 c0             	movzbl %al,%eax
  8004f6:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  8004fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800500:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800504:	eb da                	jmp    8004e0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800506:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800509:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80050d:	eb d1                	jmp    8004e0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80050f:	0f b6 d2             	movzbl %dl,%edx
  800512:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800515:	b8 00 00 00 00       	mov    $0x0,%eax
  80051a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80051d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800526:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800529:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80052c:	83 f9 09             	cmp    $0x9,%ecx
  80052f:	77 52                	ja     800583 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800531:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800532:	eb e9                	jmp    80051d <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8d 40 04             	lea    0x4(%eax),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800545:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800548:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80054c:	79 92                	jns    8004e0 <vprintfmt+0x35>
				width = precision, precision = -1;
  80054e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800551:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800554:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80055b:	eb 83                	jmp    8004e0 <vprintfmt+0x35>
  80055d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800561:	78 08                	js     80056b <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800563:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800566:	e9 75 ff ff ff       	jmp    8004e0 <vprintfmt+0x35>
  80056b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800572:	eb ef                	jmp    800563 <vprintfmt+0xb8>
  800574:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800577:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80057e:	e9 5d ff ff ff       	jmp    8004e0 <vprintfmt+0x35>
  800583:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800586:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800589:	eb bd                	jmp    800548 <vprintfmt+0x9d>
			lflag++;
  80058b:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80058f:	e9 4c ff ff ff       	jmp    8004e0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 78 04             	lea    0x4(%eax),%edi
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	ff 30                	pushl  (%eax)
  8005a0:	ff d6                	call   *%esi
			break;
  8005a2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005a5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005a8:	e9 c0 02 00 00       	jmp    80086d <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 78 04             	lea    0x4(%eax),%edi
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	85 c0                	test   %eax,%eax
  8005b7:	78 2a                	js     8005e3 <vprintfmt+0x138>
  8005b9:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005bb:	83 f8 0f             	cmp    $0xf,%eax
  8005be:	7f 27                	jg     8005e7 <vprintfmt+0x13c>
  8005c0:	8b 04 85 60 27 80 00 	mov    0x802760(,%eax,4),%eax
  8005c7:	85 c0                	test   %eax,%eax
  8005c9:	74 1c                	je     8005e7 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8005cb:	50                   	push   %eax
  8005cc:	68 88 28 80 00       	push   $0x802888
  8005d1:	53                   	push   %ebx
  8005d2:	56                   	push   %esi
  8005d3:	e8 b6 fe ff ff       	call   80048e <printfmt>
  8005d8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005db:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005de:	e9 8a 02 00 00       	jmp    80086d <vprintfmt+0x3c2>
  8005e3:	f7 d8                	neg    %eax
  8005e5:	eb d2                	jmp    8005b9 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8005e7:	52                   	push   %edx
  8005e8:	68 d7 24 80 00       	push   $0x8024d7
  8005ed:	53                   	push   %ebx
  8005ee:	56                   	push   %esi
  8005ef:	e8 9a fe ff ff       	call   80048e <printfmt>
  8005f4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005fa:	e9 6e 02 00 00       	jmp    80086d <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	83 c0 04             	add    $0x4,%eax
  800605:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 38                	mov    (%eax),%edi
  80060d:	85 ff                	test   %edi,%edi
  80060f:	74 39                	je     80064a <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800611:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800615:	0f 8e a9 00 00 00    	jle    8006c4 <vprintfmt+0x219>
  80061b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80061f:	0f 84 a7 00 00 00    	je     8006cc <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 d0             	pushl  -0x30(%ebp)
  80062b:	57                   	push   %edi
  80062c:	e8 6b 03 00 00       	call   80099c <strnlen>
  800631:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800634:	29 c1                	sub    %eax,%ecx
  800636:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800639:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80063c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800640:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800643:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800646:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	eb 14                	jmp    80065e <vprintfmt+0x1b3>
				p = "(null)";
  80064a:	bf d0 24 80 00       	mov    $0x8024d0,%edi
  80064f:	eb c0                	jmp    800611 <vprintfmt+0x166>
					putch(padc, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	ff 75 e0             	pushl  -0x20(%ebp)
  800658:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80065a:	4f                   	dec    %edi
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	85 ff                	test   %edi,%edi
  800660:	7f ef                	jg     800651 <vprintfmt+0x1a6>
  800662:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800665:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800668:	89 c8                	mov    %ecx,%eax
  80066a:	85 c9                	test   %ecx,%ecx
  80066c:	78 10                	js     80067e <vprintfmt+0x1d3>
  80066e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800671:	29 c1                	sub    %eax,%ecx
  800673:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800676:	89 75 08             	mov    %esi,0x8(%ebp)
  800679:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80067c:	eb 15                	jmp    800693 <vprintfmt+0x1e8>
  80067e:	b8 00 00 00 00       	mov    $0x0,%eax
  800683:	eb e9                	jmp    80066e <vprintfmt+0x1c3>
					putch(ch, putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	52                   	push   %edx
  80068a:	ff 55 08             	call   *0x8(%ebp)
  80068d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800690:	ff 4d e0             	decl   -0x20(%ebp)
  800693:	47                   	inc    %edi
  800694:	8a 47 ff             	mov    -0x1(%edi),%al
  800697:	0f be d0             	movsbl %al,%edx
  80069a:	85 d2                	test   %edx,%edx
  80069c:	74 59                	je     8006f7 <vprintfmt+0x24c>
  80069e:	85 f6                	test   %esi,%esi
  8006a0:	78 03                	js     8006a5 <vprintfmt+0x1fa>
  8006a2:	4e                   	dec    %esi
  8006a3:	78 2f                	js     8006d4 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006a9:	74 da                	je     800685 <vprintfmt+0x1da>
  8006ab:	0f be c0             	movsbl %al,%eax
  8006ae:	83 e8 20             	sub    $0x20,%eax
  8006b1:	83 f8 5e             	cmp    $0x5e,%eax
  8006b4:	76 cf                	jbe    800685 <vprintfmt+0x1da>
					putch('?', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	53                   	push   %ebx
  8006ba:	6a 3f                	push   $0x3f
  8006bc:	ff 55 08             	call   *0x8(%ebp)
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb cc                	jmp    800690 <vprintfmt+0x1e5>
  8006c4:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006ca:	eb c7                	jmp    800693 <vprintfmt+0x1e8>
  8006cc:	89 75 08             	mov    %esi,0x8(%ebp)
  8006cf:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d2:	eb bf                	jmp    800693 <vprintfmt+0x1e8>
  8006d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006da:	eb 0c                	jmp    8006e8 <vprintfmt+0x23d>
				putch(' ', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	53                   	push   %ebx
  8006e0:	6a 20                	push   $0x20
  8006e2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006e4:	4f                   	dec    %edi
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	85 ff                	test   %edi,%edi
  8006ea:	7f f0                	jg     8006dc <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	e9 76 01 00 00       	jmp    80086d <vprintfmt+0x3c2>
  8006f7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fd:	eb e9                	jmp    8006e8 <vprintfmt+0x23d>
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7f 1f                	jg     800723 <vprintfmt+0x278>
	else if (lflag)
  800704:	85 c9                	test   %ecx,%ecx
  800706:	75 48                	jne    800750 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	89 c1                	mov    %eax,%ecx
  800712:	c1 f9 1f             	sar    $0x1f,%ecx
  800715:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
  800721:	eb 17                	jmp    80073a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 50 04             	mov    0x4(%eax),%edx
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8d 40 08             	lea    0x8(%eax),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80073a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80073d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800740:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800744:	78 25                	js     80076b <vprintfmt+0x2c0>
			base = 10;
  800746:	b8 0a 00 00 00       	mov    $0xa,%eax
  80074b:	e9 03 01 00 00       	jmp    800853 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800758:	89 c1                	mov    %eax,%ecx
  80075a:	c1 f9 1f             	sar    $0x1f,%ecx
  80075d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8d 40 04             	lea    0x4(%eax),%eax
  800766:	89 45 14             	mov    %eax,0x14(%ebp)
  800769:	eb cf                	jmp    80073a <vprintfmt+0x28f>
				putch('-', putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	53                   	push   %ebx
  80076f:	6a 2d                	push   $0x2d
  800771:	ff d6                	call   *%esi
				num = -(long long) num;
  800773:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800776:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800779:	f7 da                	neg    %edx
  80077b:	83 d1 00             	adc    $0x0,%ecx
  80077e:	f7 d9                	neg    %ecx
  800780:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800783:	b8 0a 00 00 00       	mov    $0xa,%eax
  800788:	e9 c6 00 00 00       	jmp    800853 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80078d:	83 f9 01             	cmp    $0x1,%ecx
  800790:	7f 1e                	jg     8007b0 <vprintfmt+0x305>
	else if (lflag)
  800792:	85 c9                	test   %ecx,%ecx
  800794:	75 32                	jne    8007c8 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 10                	mov    (%eax),%edx
  80079b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a0:	8d 40 04             	lea    0x4(%eax),%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ab:	e9 a3 00 00 00       	jmp    800853 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 10                	mov    (%eax),%edx
  8007b5:	8b 48 04             	mov    0x4(%eax),%ecx
  8007b8:	8d 40 08             	lea    0x8(%eax),%eax
  8007bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c3:	e9 8b 00 00 00       	jmp    800853 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 10                	mov    (%eax),%edx
  8007cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d2:	8d 40 04             	lea    0x4(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007dd:	eb 74                	jmp    800853 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8007df:	83 f9 01             	cmp    $0x1,%ecx
  8007e2:	7f 1b                	jg     8007ff <vprintfmt+0x354>
	else if (lflag)
  8007e4:	85 c9                	test   %ecx,%ecx
  8007e6:	75 2c                	jne    800814 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8b 10                	mov    (%eax),%edx
  8007ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8007fd:	eb 54                	jmp    800853 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 10                	mov    (%eax),%edx
  800804:	8b 48 04             	mov    0x4(%eax),%ecx
  800807:	8d 40 08             	lea    0x8(%eax),%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80080d:	b8 08 00 00 00       	mov    $0x8,%eax
  800812:	eb 3f                	jmp    800853 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 10                	mov    (%eax),%edx
  800819:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081e:	8d 40 04             	lea    0x4(%eax),%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800824:	b8 08 00 00 00       	mov    $0x8,%eax
  800829:	eb 28                	jmp    800853 <vprintfmt+0x3a8>
			putch('0', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	53                   	push   %ebx
  80082f:	6a 30                	push   $0x30
  800831:	ff d6                	call   *%esi
			putch('x', putdat);
  800833:	83 c4 08             	add    $0x8,%esp
  800836:	53                   	push   %ebx
  800837:	6a 78                	push   $0x78
  800839:	ff d6                	call   *%esi
			num = (unsigned long long)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8b 10                	mov    (%eax),%edx
  800840:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800845:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800848:	8d 40 04             	lea    0x4(%eax),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800853:	83 ec 0c             	sub    $0xc,%esp
  800856:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80085a:	57                   	push   %edi
  80085b:	ff 75 e0             	pushl  -0x20(%ebp)
  80085e:	50                   	push   %eax
  80085f:	51                   	push   %ecx
  800860:	52                   	push   %edx
  800861:	89 da                	mov    %ebx,%edx
  800863:	89 f0                	mov    %esi,%eax
  800865:	e8 5b fb ff ff       	call   8003c5 <printnum>
			break;
  80086a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80086d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800870:	47                   	inc    %edi
  800871:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800875:	83 f8 25             	cmp    $0x25,%eax
  800878:	0f 84 44 fc ff ff    	je     8004c2 <vprintfmt+0x17>
			if (ch == '\0')
  80087e:	85 c0                	test   %eax,%eax
  800880:	0f 84 89 00 00 00    	je     80090f <vprintfmt+0x464>
			putch(ch, putdat);
  800886:	83 ec 08             	sub    $0x8,%esp
  800889:	53                   	push   %ebx
  80088a:	50                   	push   %eax
  80088b:	ff d6                	call   *%esi
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	eb de                	jmp    800870 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800892:	83 f9 01             	cmp    $0x1,%ecx
  800895:	7f 1b                	jg     8008b2 <vprintfmt+0x407>
	else if (lflag)
  800897:	85 c9                	test   %ecx,%ecx
  800899:	75 2c                	jne    8008c7 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 10                	mov    (%eax),%edx
  8008a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008a5:	8d 40 04             	lea    0x4(%eax),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b0:	eb a1                	jmp    800853 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8b 10                	mov    (%eax),%edx
  8008b7:	8b 48 04             	mov    0x4(%eax),%ecx
  8008ba:	8d 40 08             	lea    0x8(%eax),%eax
  8008bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c0:	b8 10 00 00 00       	mov    $0x10,%eax
  8008c5:	eb 8c                	jmp    800853 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8b 10                	mov    (%eax),%edx
  8008cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008d1:	8d 40 04             	lea    0x4(%eax),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d7:	b8 10 00 00 00       	mov    $0x10,%eax
  8008dc:	e9 72 ff ff ff       	jmp    800853 <vprintfmt+0x3a8>
			putch(ch, putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	6a 25                	push   $0x25
  8008e7:	ff d6                	call   *%esi
			break;
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	e9 7c ff ff ff       	jmp    80086d <vprintfmt+0x3c2>
			putch('%', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	53                   	push   %ebx
  8008f5:	6a 25                	push   $0x25
  8008f7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 f8                	mov    %edi,%eax
  8008fe:	eb 01                	jmp    800901 <vprintfmt+0x456>
  800900:	48                   	dec    %eax
  800901:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800905:	75 f9                	jne    800900 <vprintfmt+0x455>
  800907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090a:	e9 5e ff ff ff       	jmp    80086d <vprintfmt+0x3c2>
}
  80090f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5f                   	pop    %edi
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	83 ec 18             	sub    $0x18,%esp
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800923:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800926:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80092a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80092d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800934:	85 c0                	test   %eax,%eax
  800936:	74 26                	je     80095e <vsnprintf+0x47>
  800938:	85 d2                	test   %edx,%edx
  80093a:	7e 29                	jle    800965 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093c:	ff 75 14             	pushl  0x14(%ebp)
  80093f:	ff 75 10             	pushl  0x10(%ebp)
  800942:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800945:	50                   	push   %eax
  800946:	68 72 04 80 00       	push   $0x800472
  80094b:	e8 5b fb ff ff       	call   8004ab <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800953:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800959:	83 c4 10             	add    $0x10,%esp
}
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    
		return -E_INVAL;
  80095e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800963:	eb f7                	jmp    80095c <vsnprintf+0x45>
  800965:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096a:	eb f0                	jmp    80095c <vsnprintf+0x45>

0080096c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800972:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800975:	50                   	push   %eax
  800976:	ff 75 10             	pushl  0x10(%ebp)
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	ff 75 08             	pushl  0x8(%ebp)
  80097f:	e8 93 ff ff ff       	call   800917 <vsnprintf>
	va_end(ap);

	return rc;
}
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80098c:	b8 00 00 00 00       	mov    $0x0,%eax
  800991:	eb 01                	jmp    800994 <strlen+0xe>
		n++;
  800993:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800994:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800998:	75 f9                	jne    800993 <strlen+0xd>
	return n;
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009aa:	eb 01                	jmp    8009ad <strnlen+0x11>
		n++;
  8009ac:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ad:	39 d0                	cmp    %edx,%eax
  8009af:	74 06                	je     8009b7 <strnlen+0x1b>
  8009b1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009b5:	75 f5                	jne    8009ac <strnlen+0x10>
	return n;
}
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	53                   	push   %ebx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009c3:	89 c2                	mov    %eax,%edx
  8009c5:	42                   	inc    %edx
  8009c6:	41                   	inc    %ecx
  8009c7:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8009ca:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009cd:	84 db                	test   %bl,%bl
  8009cf:	75 f4                	jne    8009c5 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009d1:	5b                   	pop    %ebx
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	53                   	push   %ebx
  8009d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009db:	53                   	push   %ebx
  8009dc:	e8 a5 ff ff ff       	call   800986 <strlen>
  8009e1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	01 d8                	add    %ebx,%eax
  8009e9:	50                   	push   %eax
  8009ea:	e8 ca ff ff ff       	call   8009b9 <strcpy>
	return dst;
}
  8009ef:	89 d8                	mov    %ebx,%eax
  8009f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
  8009fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a01:	89 f3                	mov    %esi,%ebx
  800a03:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a06:	89 f2                	mov    %esi,%edx
  800a08:	eb 0c                	jmp    800a16 <strncpy+0x20>
		*dst++ = *src;
  800a0a:	42                   	inc    %edx
  800a0b:	8a 01                	mov    (%ecx),%al
  800a0d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a10:	80 39 01             	cmpb   $0x1,(%ecx)
  800a13:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a16:	39 da                	cmp    %ebx,%edx
  800a18:	75 f0                	jne    800a0a <strncpy+0x14>
	}
	return ret;
}
  800a1a:	89 f0                	mov    %esi,%eax
  800a1c:	5b                   	pop    %ebx
  800a1d:	5e                   	pop    %esi
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	56                   	push   %esi
  800a24:	53                   	push   %ebx
  800a25:	8b 75 08             	mov    0x8(%ebp),%esi
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a2e:	85 c0                	test   %eax,%eax
  800a30:	74 20                	je     800a52 <strlcpy+0x32>
  800a32:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800a36:	89 f0                	mov    %esi,%eax
  800a38:	eb 05                	jmp    800a3f <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a3a:	40                   	inc    %eax
  800a3b:	42                   	inc    %edx
  800a3c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a3f:	39 d8                	cmp    %ebx,%eax
  800a41:	74 06                	je     800a49 <strlcpy+0x29>
  800a43:	8a 0a                	mov    (%edx),%cl
  800a45:	84 c9                	test   %cl,%cl
  800a47:	75 f1                	jne    800a3a <strlcpy+0x1a>
		*dst = '\0';
  800a49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4c:	29 f0                	sub    %esi,%eax
}
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    
  800a52:	89 f0                	mov    %esi,%eax
  800a54:	eb f6                	jmp    800a4c <strlcpy+0x2c>

00800a56 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a5f:	eb 02                	jmp    800a63 <strcmp+0xd>
		p++, q++;
  800a61:	41                   	inc    %ecx
  800a62:	42                   	inc    %edx
	while (*p && *p == *q)
  800a63:	8a 01                	mov    (%ecx),%al
  800a65:	84 c0                	test   %al,%al
  800a67:	74 04                	je     800a6d <strcmp+0x17>
  800a69:	3a 02                	cmp    (%edx),%al
  800a6b:	74 f4                	je     800a61 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6d:	0f b6 c0             	movzbl %al,%eax
  800a70:	0f b6 12             	movzbl (%edx),%edx
  800a73:	29 d0                	sub    %edx,%eax
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	53                   	push   %ebx
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a81:	89 c3                	mov    %eax,%ebx
  800a83:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a86:	eb 02                	jmp    800a8a <strncmp+0x13>
		n--, p++, q++;
  800a88:	40                   	inc    %eax
  800a89:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800a8a:	39 d8                	cmp    %ebx,%eax
  800a8c:	74 15                	je     800aa3 <strncmp+0x2c>
  800a8e:	8a 08                	mov    (%eax),%cl
  800a90:	84 c9                	test   %cl,%cl
  800a92:	74 04                	je     800a98 <strncmp+0x21>
  800a94:	3a 0a                	cmp    (%edx),%cl
  800a96:	74 f0                	je     800a88 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a98:	0f b6 00             	movzbl (%eax),%eax
  800a9b:	0f b6 12             	movzbl (%edx),%edx
  800a9e:	29 d0                	sub    %edx,%eax
}
  800aa0:	5b                   	pop    %ebx
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    
		return 0;
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	eb f6                	jmp    800aa0 <strncmp+0x29>

00800aaa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800ab3:	8a 10                	mov    (%eax),%dl
  800ab5:	84 d2                	test   %dl,%dl
  800ab7:	74 07                	je     800ac0 <strchr+0x16>
		if (*s == c)
  800ab9:	38 ca                	cmp    %cl,%dl
  800abb:	74 08                	je     800ac5 <strchr+0x1b>
	for (; *s; s++)
  800abd:	40                   	inc    %eax
  800abe:	eb f3                	jmp    800ab3 <strchr+0x9>
			return (char *) s;
	return 0;
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800ad0:	8a 10                	mov    (%eax),%dl
  800ad2:	84 d2                	test   %dl,%dl
  800ad4:	74 07                	je     800add <strfind+0x16>
		if (*s == c)
  800ad6:	38 ca                	cmp    %cl,%dl
  800ad8:	74 03                	je     800add <strfind+0x16>
	for (; *s; s++)
  800ada:	40                   	inc    %eax
  800adb:	eb f3                	jmp    800ad0 <strfind+0x9>
			break;
	return (char *) s;
}
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	57                   	push   %edi
  800ae3:	56                   	push   %esi
  800ae4:	53                   	push   %ebx
  800ae5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aeb:	85 c9                	test   %ecx,%ecx
  800aed:	74 13                	je     800b02 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aef:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800af5:	75 05                	jne    800afc <memset+0x1d>
  800af7:	f6 c1 03             	test   $0x3,%cl
  800afa:	74 0d                	je     800b09 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	fc                   	cld    
  800b00:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b02:	89 f8                	mov    %edi,%eax
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5f                   	pop    %edi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    
		c &= 0xFF;
  800b09:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b0d:	89 d3                	mov    %edx,%ebx
  800b0f:	c1 e3 08             	shl    $0x8,%ebx
  800b12:	89 d0                	mov    %edx,%eax
  800b14:	c1 e0 18             	shl    $0x18,%eax
  800b17:	89 d6                	mov    %edx,%esi
  800b19:	c1 e6 10             	shl    $0x10,%esi
  800b1c:	09 f0                	or     %esi,%eax
  800b1e:	09 c2                	or     %eax,%edx
  800b20:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b22:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b25:	89 d0                	mov    %edx,%eax
  800b27:	fc                   	cld    
  800b28:	f3 ab                	rep stos %eax,%es:(%edi)
  800b2a:	eb d6                	jmp    800b02 <memset+0x23>

00800b2c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	57                   	push   %edi
  800b30:	56                   	push   %esi
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b37:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b3a:	39 c6                	cmp    %eax,%esi
  800b3c:	73 33                	jae    800b71 <memmove+0x45>
  800b3e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b41:	39 d0                	cmp    %edx,%eax
  800b43:	73 2c                	jae    800b71 <memmove+0x45>
		s += n;
		d += n;
  800b45:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b48:	89 d6                	mov    %edx,%esi
  800b4a:	09 fe                	or     %edi,%esi
  800b4c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b52:	75 13                	jne    800b67 <memmove+0x3b>
  800b54:	f6 c1 03             	test   $0x3,%cl
  800b57:	75 0e                	jne    800b67 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b59:	83 ef 04             	sub    $0x4,%edi
  800b5c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b5f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b62:	fd                   	std    
  800b63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b65:	eb 07                	jmp    800b6e <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b67:	4f                   	dec    %edi
  800b68:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b6b:	fd                   	std    
  800b6c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6e:	fc                   	cld    
  800b6f:	eb 13                	jmp    800b84 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b71:	89 f2                	mov    %esi,%edx
  800b73:	09 c2                	or     %eax,%edx
  800b75:	f6 c2 03             	test   $0x3,%dl
  800b78:	75 05                	jne    800b7f <memmove+0x53>
  800b7a:	f6 c1 03             	test   $0x3,%cl
  800b7d:	74 09                	je     800b88 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b7f:	89 c7                	mov    %eax,%edi
  800b81:	fc                   	cld    
  800b82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b8b:	89 c7                	mov    %eax,%edi
  800b8d:	fc                   	cld    
  800b8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b90:	eb f2                	jmp    800b84 <memmove+0x58>

00800b92 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b95:	ff 75 10             	pushl  0x10(%ebp)
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	ff 75 08             	pushl  0x8(%ebp)
  800b9e:	e8 89 ff ff ff       	call   800b2c <memmove>
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	56                   	push   %esi
  800ba9:	53                   	push   %ebx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 c6                	mov    %eax,%esi
  800baf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800bb5:	39 f0                	cmp    %esi,%eax
  800bb7:	74 16                	je     800bcf <memcmp+0x2a>
		if (*s1 != *s2)
  800bb9:	8a 08                	mov    (%eax),%cl
  800bbb:	8a 1a                	mov    (%edx),%bl
  800bbd:	38 d9                	cmp    %bl,%cl
  800bbf:	75 04                	jne    800bc5 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bc1:	40                   	inc    %eax
  800bc2:	42                   	inc    %edx
  800bc3:	eb f0                	jmp    800bb5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bc5:	0f b6 c1             	movzbl %cl,%eax
  800bc8:	0f b6 db             	movzbl %bl,%ebx
  800bcb:	29 d8                	sub    %ebx,%eax
  800bcd:	eb 05                	jmp    800bd4 <memcmp+0x2f>
	}

	return 0;
  800bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800be1:	89 c2                	mov    %eax,%edx
  800be3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be6:	39 d0                	cmp    %edx,%eax
  800be8:	73 07                	jae    800bf1 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bea:	38 08                	cmp    %cl,(%eax)
  800bec:	74 03                	je     800bf1 <memfind+0x19>
	for (; s < ends; s++)
  800bee:	40                   	inc    %eax
  800bef:	eb f5                	jmp    800be6 <memfind+0xe>
			break;
	return (void *) s;
}
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfc:	eb 01                	jmp    800bff <strtol+0xc>
		s++;
  800bfe:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800bff:	8a 01                	mov    (%ecx),%al
  800c01:	3c 20                	cmp    $0x20,%al
  800c03:	74 f9                	je     800bfe <strtol+0xb>
  800c05:	3c 09                	cmp    $0x9,%al
  800c07:	74 f5                	je     800bfe <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800c09:	3c 2b                	cmp    $0x2b,%al
  800c0b:	74 2b                	je     800c38 <strtol+0x45>
		s++;
	else if (*s == '-')
  800c0d:	3c 2d                	cmp    $0x2d,%al
  800c0f:	74 2f                	je     800c40 <strtol+0x4d>
	int neg = 0;
  800c11:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c16:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800c1d:	75 12                	jne    800c31 <strtol+0x3e>
  800c1f:	80 39 30             	cmpb   $0x30,(%ecx)
  800c22:	74 24                	je     800c48 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c28:	75 07                	jne    800c31 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c2a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
  800c36:	eb 4e                	jmp    800c86 <strtol+0x93>
		s++;
  800c38:	41                   	inc    %ecx
	int neg = 0;
  800c39:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3e:	eb d6                	jmp    800c16 <strtol+0x23>
		s++, neg = 1;
  800c40:	41                   	inc    %ecx
  800c41:	bf 01 00 00 00       	mov    $0x1,%edi
  800c46:	eb ce                	jmp    800c16 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c48:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c4c:	74 10                	je     800c5e <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800c4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c52:	75 dd                	jne    800c31 <strtol+0x3e>
		s++, base = 8;
  800c54:	41                   	inc    %ecx
  800c55:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c5c:	eb d3                	jmp    800c31 <strtol+0x3e>
		s += 2, base = 16;
  800c5e:	83 c1 02             	add    $0x2,%ecx
  800c61:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c68:	eb c7                	jmp    800c31 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c6a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6d:	89 f3                	mov    %esi,%ebx
  800c6f:	80 fb 19             	cmp    $0x19,%bl
  800c72:	77 24                	ja     800c98 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800c74:	0f be d2             	movsbl %dl,%edx
  800c77:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c7a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c7d:	7d 2b                	jge    800caa <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800c7f:	41                   	inc    %ecx
  800c80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c84:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c86:	8a 11                	mov    (%ecx),%dl
  800c88:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800c8b:	80 fb 09             	cmp    $0x9,%bl
  800c8e:	77 da                	ja     800c6a <strtol+0x77>
			dig = *s - '0';
  800c90:	0f be d2             	movsbl %dl,%edx
  800c93:	83 ea 30             	sub    $0x30,%edx
  800c96:	eb e2                	jmp    800c7a <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800c98:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c9b:	89 f3                	mov    %esi,%ebx
  800c9d:	80 fb 19             	cmp    $0x19,%bl
  800ca0:	77 08                	ja     800caa <strtol+0xb7>
			dig = *s - 'A' + 10;
  800ca2:	0f be d2             	movsbl %dl,%edx
  800ca5:	83 ea 37             	sub    $0x37,%edx
  800ca8:	eb d0                	jmp    800c7a <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cae:	74 05                	je     800cb5 <strtol+0xc2>
		*endptr = (char *) s;
  800cb0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cb5:	85 ff                	test   %edi,%edi
  800cb7:	74 02                	je     800cbb <strtol+0xc8>
  800cb9:	f7 d8                	neg    %eax
}
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <atoi>:

int
atoi(const char *s)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800cc3:	6a 0a                	push   $0xa
  800cc5:	6a 00                	push   $0x0
  800cc7:	ff 75 08             	pushl  0x8(%ebp)
  800cca:	e8 24 ff ff ff       	call   800bf3 <strtol>
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	89 c3                	mov    %eax,%ebx
  800ce4:	89 c7                	mov    %eax,%edi
  800ce6:	89 c6                	mov    %eax,%esi
  800ce8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <sys_cgetc>:

int
sys_cgetc(void)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  800cff:	89 d1                	mov    %edx,%ecx
  800d01:	89 d3                	mov    %edx,%ebx
  800d03:	89 d7                	mov    %edx,%edi
  800d05:	89 d6                	mov    %edx,%esi
  800d07:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	89 cb                	mov    %ecx,%ebx
  800d26:	89 cf                	mov    %ecx,%edi
  800d28:	89 ce                	mov    %ecx,%esi
  800d2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7f 08                	jg     800d38 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d38:	83 ec 0c             	sub    $0xc,%esp
  800d3b:	50                   	push   %eax
  800d3c:	6a 03                	push   $0x3
  800d3e:	68 bf 27 80 00       	push   $0x8027bf
  800d43:	6a 23                	push   $0x23
  800d45:	68 dc 27 80 00       	push   $0x8027dc
  800d4a:	e8 4f f5 ff ff       	call   80029e <_panic>

00800d4f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d55:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5f:	89 d1                	mov    %edx,%ecx
  800d61:	89 d3                	mov    %edx,%ebx
  800d63:	89 d7                	mov    %edx,%edi
  800d65:	89 d6                	mov    %edx,%esi
  800d67:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d69:	5b                   	pop    %ebx
  800d6a:	5e                   	pop    %esi
  800d6b:	5f                   	pop    %edi
  800d6c:	5d                   	pop    %ebp
  800d6d:	c3                   	ret    

00800d6e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d77:	be 00 00 00 00       	mov    $0x0,%esi
  800d7c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8a:	89 f7                	mov    %esi,%edi
  800d8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	7f 08                	jg     800d9a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 04                	push   $0x4
  800da0:	68 bf 27 80 00       	push   $0x8027bf
  800da5:	6a 23                	push   $0x23
  800da7:	68 dc 27 80 00       	push   $0x8027dc
  800dac:	e8 ed f4 ff ff       	call   80029e <_panic>

00800db1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dba:	b8 05 00 00 00       	mov    $0x5,%eax
  800dbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dcb:	8b 75 18             	mov    0x18(%ebp),%esi
  800dce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7f 08                	jg     800ddc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	50                   	push   %eax
  800de0:	6a 05                	push   $0x5
  800de2:	68 bf 27 80 00       	push   $0x8027bf
  800de7:	6a 23                	push   $0x23
  800de9:	68 dc 27 80 00       	push   $0x8027dc
  800dee:	e8 ab f4 ff ff       	call   80029e <_panic>

00800df3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e01:	b8 06 00 00 00       	mov    $0x6,%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	89 df                	mov    %ebx,%edi
  800e0e:	89 de                	mov    %ebx,%esi
  800e10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7f 08                	jg     800e1e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1e:	83 ec 0c             	sub    $0xc,%esp
  800e21:	50                   	push   %eax
  800e22:	6a 06                	push   $0x6
  800e24:	68 bf 27 80 00       	push   $0x8027bf
  800e29:	6a 23                	push   $0x23
  800e2b:	68 dc 27 80 00       	push   $0x8027dc
  800e30:	e8 69 f4 ff ff       	call   80029e <_panic>

00800e35 <sys_yield>:

void
sys_yield(void)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	57                   	push   %edi
  800e39:	56                   	push   %esi
  800e3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e40:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e45:	89 d1                	mov    %edx,%ecx
  800e47:	89 d3                	mov    %edx,%ebx
  800e49:	89 d7                	mov    %edx,%edi
  800e4b:	89 d6                	mov    %edx,%esi
  800e4d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	b8 08 00 00 00       	mov    $0x8,%eax
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	50                   	push   %eax
  800e83:	6a 08                	push   $0x8
  800e85:	68 bf 27 80 00       	push   $0x8027bf
  800e8a:	6a 23                	push   $0x23
  800e8c:	68 dc 27 80 00       	push   $0x8027dc
  800e91:	e8 08 f4 ff ff       	call   80029e <_panic>

00800e96 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	89 cb                	mov    %ecx,%ebx
  800eae:	89 cf                	mov    %ecx,%edi
  800eb0:	89 ce                	mov    %ecx,%esi
  800eb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	7f 08                	jg     800ec0 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebb:	5b                   	pop    %ebx
  800ebc:	5e                   	pop    %esi
  800ebd:	5f                   	pop    %edi
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec0:	83 ec 0c             	sub    $0xc,%esp
  800ec3:	50                   	push   %eax
  800ec4:	6a 0c                	push   $0xc
  800ec6:	68 bf 27 80 00       	push   $0x8027bf
  800ecb:	6a 23                	push   $0x23
  800ecd:	68 dc 27 80 00       	push   $0x8027dc
  800ed2:	e8 c7 f3 ff ff       	call   80029e <_panic>

00800ed7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee5:	b8 09 00 00 00       	mov    $0x9,%eax
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	89 df                	mov    %ebx,%edi
  800ef2:	89 de                	mov    %ebx,%esi
  800ef4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	7f 08                	jg     800f02 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f02:	83 ec 0c             	sub    $0xc,%esp
  800f05:	50                   	push   %eax
  800f06:	6a 09                	push   $0x9
  800f08:	68 bf 27 80 00       	push   $0x8027bf
  800f0d:	6a 23                	push   $0x23
  800f0f:	68 dc 27 80 00       	push   $0x8027dc
  800f14:	e8 85 f3 ff ff       	call   80029e <_panic>

00800f19 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	89 df                	mov    %ebx,%edi
  800f34:	89 de                	mov    %ebx,%esi
  800f36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	7f 08                	jg     800f44 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3f:	5b                   	pop    %ebx
  800f40:	5e                   	pop    %esi
  800f41:	5f                   	pop    %edi
  800f42:	5d                   	pop    %ebp
  800f43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f44:	83 ec 0c             	sub    $0xc,%esp
  800f47:	50                   	push   %eax
  800f48:	6a 0a                	push   $0xa
  800f4a:	68 bf 27 80 00       	push   $0x8027bf
  800f4f:	6a 23                	push   $0x23
  800f51:	68 dc 27 80 00       	push   $0x8027dc
  800f56:	e8 43 f3 ff ff       	call   80029e <_panic>

00800f5b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f61:	be 00 00 00 00       	mov    $0x0,%esi
  800f66:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f74:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f77:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
  800f84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f87:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	89 cb                	mov    %ecx,%ebx
  800f96:	89 cf                	mov    %ecx,%edi
  800f98:	89 ce                	mov    %ecx,%esi
  800f9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	7f 08                	jg     800fa8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa8:	83 ec 0c             	sub    $0xc,%esp
  800fab:	50                   	push   %eax
  800fac:	6a 0e                	push   $0xe
  800fae:	68 bf 27 80 00       	push   $0x8027bf
  800fb3:	6a 23                	push   $0x23
  800fb5:	68 dc 27 80 00       	push   $0x8027dc
  800fba:	e8 df f2 ff ff       	call   80029e <_panic>

00800fbf <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc5:	be 00 00 00 00       	mov    $0x0,%esi
  800fca:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd8:	89 f7                	mov    %esi,%edi
  800fda:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe7:	be 00 00 00 00       	mov    $0x0,%esi
  800fec:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ffa:	89 f7                	mov    %esi,%edi
  800ffc:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_set_console_color>:

void sys_set_console_color(int color) {
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
	asm volatile("int %1\n"
  801009:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100e:	b8 11 00 00 00       	mov    $0x11,%eax
  801013:	8b 55 08             	mov    0x8(%ebp),%edx
  801016:	89 cb                	mov    %ecx,%ebx
  801018:	89 cf                	mov    %ecx,%edi
  80101a:	89 ce                	mov    %ecx,%esi
  80101c:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80102b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  80102d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801031:	0f 84 84 00 00 00    	je     8010bb <pgfault+0x98>
  801037:	89 d8                	mov    %ebx,%eax
  801039:	c1 e8 16             	shr    $0x16,%eax
  80103c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801043:	a8 01                	test   $0x1,%al
  801045:	74 74                	je     8010bb <pgfault+0x98>
  801047:	89 d8                	mov    %ebx,%eax
  801049:	c1 e8 0c             	shr    $0xc,%eax
  80104c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801053:	f6 c4 08             	test   $0x8,%ah
  801056:	74 63                	je     8010bb <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  801058:	e8 f2 fc ff ff       	call   800d4f <sys_getenvid>
  80105d:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  80105f:	83 ec 04             	sub    $0x4,%esp
  801062:	6a 07                	push   $0x7
  801064:	68 00 f0 7f 00       	push   $0x7ff000
  801069:	50                   	push   %eax
  80106a:	e8 ff fc ff ff       	call   800d6e <sys_page_alloc>
  80106f:	83 c4 10             	add    $0x10,%esp
  801072:	85 c0                	test   %eax,%eax
  801074:	78 5b                	js     8010d1 <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  801076:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  80107c:	83 ec 04             	sub    $0x4,%esp
  80107f:	68 00 10 00 00       	push   $0x1000
  801084:	53                   	push   %ebx
  801085:	68 00 f0 7f 00       	push   $0x7ff000
  80108a:	e8 03 fb ff ff       	call   800b92 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  80108f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801096:	53                   	push   %ebx
  801097:	56                   	push   %esi
  801098:	68 00 f0 7f 00       	push   $0x7ff000
  80109d:	56                   	push   %esi
  80109e:	e8 0e fd ff ff       	call   800db1 <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  8010a3:	83 c4 18             	add    $0x18,%esp
  8010a6:	68 00 f0 7f 00       	push   $0x7ff000
  8010ab:	56                   	push   %esi
  8010ac:	e8 42 fd ff ff       	call   800df3 <sys_page_unmap>

}
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010b7:	5b                   	pop    %ebx
  8010b8:	5e                   	pop    %esi
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  8010bb:	68 ec 27 80 00       	push   $0x8027ec
  8010c0:	68 76 28 80 00       	push   $0x802876
  8010c5:	6a 1c                	push   $0x1c
  8010c7:	68 8b 28 80 00       	push   $0x80288b
  8010cc:	e8 cd f1 ff ff       	call   80029e <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  8010d1:	68 3c 28 80 00       	push   $0x80283c
  8010d6:	68 76 28 80 00       	push   $0x802876
  8010db:	6a 26                	push   $0x26
  8010dd:	68 8b 28 80 00       	push   $0x80288b
  8010e2:	e8 b7 f1 ff ff       	call   80029e <_panic>

008010e7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
  8010ed:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8010f0:	68 23 10 80 00       	push   $0x801023
  8010f5:	e8 b9 0e 00 00       	call   801fb3 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010fa:	b8 07 00 00 00       	mov    $0x7,%eax
  8010ff:	cd 30                	int    $0x30
  801101:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801104:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	85 c0                	test   %eax,%eax
  80110c:	0f 88 58 01 00 00    	js     80126a <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  801112:	85 c0                	test   %eax,%eax
  801114:	74 07                	je     80111d <fork+0x36>
  801116:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111b:	eb 72                	jmp    80118f <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  80111d:	e8 2d fc ff ff       	call   800d4f <sys_getenvid>
  801122:	25 ff 03 00 00       	and    $0x3ff,%eax
  801127:	89 c2                	mov    %eax,%edx
  801129:	c1 e2 05             	shl    $0x5,%edx
  80112c:	29 c2                	sub    %eax,%edx
  80112e:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801135:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80113a:	e9 20 01 00 00       	jmp    80125f <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  80113f:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  801146:	e8 04 fc ff ff       	call   800d4f <sys_getenvid>
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801154:	57                   	push   %edi
  801155:	56                   	push   %esi
  801156:	ff 75 e4             	pushl  -0x1c(%ebp)
  801159:	56                   	push   %esi
  80115a:	50                   	push   %eax
  80115b:	e8 51 fc ff ff       	call   800db1 <sys_page_map>
  801160:	83 c4 20             	add    $0x20,%esp
  801163:	eb 18                	jmp    80117d <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  801165:	e8 e5 fb ff ff       	call   800d4f <sys_getenvid>
  80116a:	83 ec 0c             	sub    $0xc,%esp
  80116d:	6a 05                	push   $0x5
  80116f:	56                   	push   %esi
  801170:	ff 75 e4             	pushl  -0x1c(%ebp)
  801173:	56                   	push   %esi
  801174:	50                   	push   %eax
  801175:	e8 37 fc ff ff       	call   800db1 <sys_page_map>
  80117a:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  80117d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801183:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801189:	0f 84 8f 00 00 00    	je     80121e <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  80118f:	89 d8                	mov    %ebx,%eax
  801191:	c1 e8 16             	shr    $0x16,%eax
  801194:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80119b:	a8 01                	test   $0x1,%al
  80119d:	74 de                	je     80117d <fork+0x96>
  80119f:	89 d8                	mov    %ebx,%eax
  8011a1:	c1 e8 0c             	shr    $0xc,%eax
  8011a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ab:	a8 04                	test   $0x4,%al
  8011ad:	74 ce                	je     80117d <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  8011af:	89 de                	mov    %ebx,%esi
  8011b1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  8011b7:	89 f0                	mov    %esi,%eax
  8011b9:	c1 e8 0c             	shr    $0xc,%eax
  8011bc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011c3:	f6 c6 04             	test   $0x4,%dh
  8011c6:	0f 85 73 ff ff ff    	jne    80113f <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  8011cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d3:	a9 02 08 00 00       	test   $0x802,%eax
  8011d8:	74 8b                	je     801165 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  8011da:	e8 70 fb ff ff       	call   800d4f <sys_getenvid>
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	68 05 08 00 00       	push   $0x805
  8011e7:	56                   	push   %esi
  8011e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011eb:	56                   	push   %esi
  8011ec:	50                   	push   %eax
  8011ed:	e8 bf fb ff ff       	call   800db1 <sys_page_map>
  8011f2:	83 c4 20             	add    $0x20,%esp
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	78 84                	js     80117d <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  8011f9:	e8 51 fb ff ff       	call   800d4f <sys_getenvid>
  8011fe:	89 c7                	mov    %eax,%edi
  801200:	e8 4a fb ff ff       	call   800d4f <sys_getenvid>
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	68 05 08 00 00       	push   $0x805
  80120d:	56                   	push   %esi
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	50                   	push   %eax
  801211:	e8 9b fb ff ff       	call   800db1 <sys_page_map>
  801216:	83 c4 20             	add    $0x20,%esp
  801219:	e9 5f ff ff ff       	jmp    80117d <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  80121e:	83 ec 04             	sub    $0x4,%esp
  801221:	6a 07                	push   $0x7
  801223:	68 00 f0 bf ee       	push   $0xeebff000
  801228:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80122b:	57                   	push   %edi
  80122c:	e8 3d fb ff ff       	call   800d6e <sys_page_alloc>
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	85 c0                	test   %eax,%eax
  801236:	78 3b                	js     801273 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  801238:	83 ec 08             	sub    $0x8,%esp
  80123b:	68 f9 1f 80 00       	push   $0x801ff9
  801240:	57                   	push   %edi
  801241:	e8 d3 fc ff ff       	call   800f19 <sys_env_set_pgfault_upcall>
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	78 2f                	js     80127c <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  80124d:	83 ec 08             	sub    $0x8,%esp
  801250:	6a 02                	push   $0x2
  801252:	57                   	push   %edi
  801253:	e8 fc fb ff ff       	call   800e54 <sys_env_set_status>
	if (temp < 0) {
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 26                	js     801285 <fork+0x19e>
		return -1;
	}

	return childid;
}
  80125f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801265:	5b                   	pop    %ebx
  801266:	5e                   	pop    %esi
  801267:	5f                   	pop    %edi
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    
		return -1;
  80126a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801271:	eb ec                	jmp    80125f <fork+0x178>
		return -1;
  801273:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80127a:	eb e3                	jmp    80125f <fork+0x178>
		return -1;
  80127c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801283:	eb da                	jmp    80125f <fork+0x178>
		return -1;
  801285:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80128c:	eb d1                	jmp    80125f <fork+0x178>

0080128e <sfork>:

// Challenge!
int
sfork(void)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801294:	68 96 28 80 00       	push   $0x802896
  801299:	68 85 00 00 00       	push   $0x85
  80129e:	68 8b 28 80 00       	push   $0x80288b
  8012a3:	e8 f6 ef ff ff       	call   80029e <_panic>

008012a8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	05 00 00 00 30       	add    $0x30000000,%eax
  8012b3:	c1 e8 0c             	shr    $0xc,%eax
}
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    

008012b8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012c8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012da:	89 c2                	mov    %eax,%edx
  8012dc:	c1 ea 16             	shr    $0x16,%edx
  8012df:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e6:	f6 c2 01             	test   $0x1,%dl
  8012e9:	74 2a                	je     801315 <fd_alloc+0x46>
  8012eb:	89 c2                	mov    %eax,%edx
  8012ed:	c1 ea 0c             	shr    $0xc,%edx
  8012f0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f7:	f6 c2 01             	test   $0x1,%dl
  8012fa:	74 19                	je     801315 <fd_alloc+0x46>
  8012fc:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801301:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801306:	75 d2                	jne    8012da <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801308:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80130e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801313:	eb 07                	jmp    80131c <fd_alloc+0x4d>
			*fd_store = fd;
  801315:	89 01                	mov    %eax,(%ecx)
			return 0;
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801321:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801325:	77 39                	ja     801360 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	c1 e0 0c             	shl    $0xc,%eax
  80132d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801332:	89 c2                	mov    %eax,%edx
  801334:	c1 ea 16             	shr    $0x16,%edx
  801337:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80133e:	f6 c2 01             	test   $0x1,%dl
  801341:	74 24                	je     801367 <fd_lookup+0x49>
  801343:	89 c2                	mov    %eax,%edx
  801345:	c1 ea 0c             	shr    $0xc,%edx
  801348:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134f:	f6 c2 01             	test   $0x1,%dl
  801352:	74 1a                	je     80136e <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	89 02                	mov    %eax,(%edx)
	return 0;
  801359:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135e:	5d                   	pop    %ebp
  80135f:	c3                   	ret    
		return -E_INVAL;
  801360:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801365:	eb f7                	jmp    80135e <fd_lookup+0x40>
		return -E_INVAL;
  801367:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136c:	eb f0                	jmp    80135e <fd_lookup+0x40>
  80136e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801373:	eb e9                	jmp    80135e <fd_lookup+0x40>

00801375 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 08             	sub    $0x8,%esp
  80137b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137e:	ba 28 29 80 00       	mov    $0x802928,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801383:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801388:	39 08                	cmp    %ecx,(%eax)
  80138a:	74 33                	je     8013bf <dev_lookup+0x4a>
  80138c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80138f:	8b 02                	mov    (%edx),%eax
  801391:	85 c0                	test   %eax,%eax
  801393:	75 f3                	jne    801388 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801395:	a1 04 40 80 00       	mov    0x804004,%eax
  80139a:	8b 40 48             	mov    0x48(%eax),%eax
  80139d:	83 ec 04             	sub    $0x4,%esp
  8013a0:	51                   	push   %ecx
  8013a1:	50                   	push   %eax
  8013a2:	68 ac 28 80 00       	push   $0x8028ac
  8013a7:	e8 05 f0 ff ff       	call   8003b1 <cprintf>
	*dev = 0;
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    
			*dev = devtab[i];
  8013bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c9:	eb f2                	jmp    8013bd <dev_lookup+0x48>

008013cb <fd_close>:
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	57                   	push   %edi
  8013cf:	56                   	push   %esi
  8013d0:	53                   	push   %ebx
  8013d1:	83 ec 1c             	sub    $0x1c,%esp
  8013d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8013d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013dd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013de:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013e4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e7:	50                   	push   %eax
  8013e8:	e8 31 ff ff ff       	call   80131e <fd_lookup>
  8013ed:	89 c7                	mov    %eax,%edi
  8013ef:	83 c4 08             	add    $0x8,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 05                	js     8013fb <fd_close+0x30>
	    || fd != fd2)
  8013f6:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8013f9:	74 13                	je     80140e <fd_close+0x43>
		return (must_exist ? r : 0);
  8013fb:	84 db                	test   %bl,%bl
  8013fd:	75 05                	jne    801404 <fd_close+0x39>
  8013ff:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801404:	89 f8                	mov    %edi,%eax
  801406:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801409:	5b                   	pop    %ebx
  80140a:	5e                   	pop    %esi
  80140b:	5f                   	pop    %edi
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801414:	50                   	push   %eax
  801415:	ff 36                	pushl  (%esi)
  801417:	e8 59 ff ff ff       	call   801375 <dev_lookup>
  80141c:	89 c7                	mov    %eax,%edi
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 15                	js     80143a <fd_close+0x6f>
		if (dev->dev_close)
  801425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801428:	8b 40 10             	mov    0x10(%eax),%eax
  80142b:	85 c0                	test   %eax,%eax
  80142d:	74 1b                	je     80144a <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80142f:	83 ec 0c             	sub    $0xc,%esp
  801432:	56                   	push   %esi
  801433:	ff d0                	call   *%eax
  801435:	89 c7                	mov    %eax,%edi
  801437:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80143a:	83 ec 08             	sub    $0x8,%esp
  80143d:	56                   	push   %esi
  80143e:	6a 00                	push   $0x0
  801440:	e8 ae f9 ff ff       	call   800df3 <sys_page_unmap>
	return r;
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	eb ba                	jmp    801404 <fd_close+0x39>
			r = 0;
  80144a:	bf 00 00 00 00       	mov    $0x0,%edi
  80144f:	eb e9                	jmp    80143a <fd_close+0x6f>

00801451 <close>:

int
close(int fdnum)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801457:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145a:	50                   	push   %eax
  80145b:	ff 75 08             	pushl  0x8(%ebp)
  80145e:	e8 bb fe ff ff       	call   80131e <fd_lookup>
  801463:	83 c4 08             	add    $0x8,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 10                	js     80147a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	6a 01                	push   $0x1
  80146f:	ff 75 f4             	pushl  -0xc(%ebp)
  801472:	e8 54 ff ff ff       	call   8013cb <fd_close>
  801477:	83 c4 10             	add    $0x10,%esp
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <close_all>:

void
close_all(void)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	53                   	push   %ebx
  801480:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801483:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	53                   	push   %ebx
  80148c:	e8 c0 ff ff ff       	call   801451 <close>
	for (i = 0; i < MAXFD; i++)
  801491:	43                   	inc    %ebx
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	83 fb 20             	cmp    $0x20,%ebx
  801498:	75 ee                	jne    801488 <close_all+0xc>
}
  80149a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	57                   	push   %edi
  8014a3:	56                   	push   %esi
  8014a4:	53                   	push   %ebx
  8014a5:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014ab:	50                   	push   %eax
  8014ac:	ff 75 08             	pushl  0x8(%ebp)
  8014af:	e8 6a fe ff ff       	call   80131e <fd_lookup>
  8014b4:	89 c3                	mov    %eax,%ebx
  8014b6:	83 c4 08             	add    $0x8,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	0f 88 81 00 00 00    	js     801542 <dup+0xa3>
		return r;
	close(newfdnum);
  8014c1:	83 ec 0c             	sub    $0xc,%esp
  8014c4:	ff 75 0c             	pushl  0xc(%ebp)
  8014c7:	e8 85 ff ff ff       	call   801451 <close>

	newfd = INDEX2FD(newfdnum);
  8014cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014cf:	c1 e6 0c             	shl    $0xc,%esi
  8014d2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014d8:	83 c4 04             	add    $0x4,%esp
  8014db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014de:	e8 d5 fd ff ff       	call   8012b8 <fd2data>
  8014e3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014e5:	89 34 24             	mov    %esi,(%esp)
  8014e8:	e8 cb fd ff ff       	call   8012b8 <fd2data>
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014f2:	89 d8                	mov    %ebx,%eax
  8014f4:	c1 e8 16             	shr    $0x16,%eax
  8014f7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014fe:	a8 01                	test   $0x1,%al
  801500:	74 11                	je     801513 <dup+0x74>
  801502:	89 d8                	mov    %ebx,%eax
  801504:	c1 e8 0c             	shr    $0xc,%eax
  801507:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80150e:	f6 c2 01             	test   $0x1,%dl
  801511:	75 39                	jne    80154c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801513:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801516:	89 d0                	mov    %edx,%eax
  801518:	c1 e8 0c             	shr    $0xc,%eax
  80151b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801522:	83 ec 0c             	sub    $0xc,%esp
  801525:	25 07 0e 00 00       	and    $0xe07,%eax
  80152a:	50                   	push   %eax
  80152b:	56                   	push   %esi
  80152c:	6a 00                	push   $0x0
  80152e:	52                   	push   %edx
  80152f:	6a 00                	push   $0x0
  801531:	e8 7b f8 ff ff       	call   800db1 <sys_page_map>
  801536:	89 c3                	mov    %eax,%ebx
  801538:	83 c4 20             	add    $0x20,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 31                	js     801570 <dup+0xd1>
		goto err;

	return newfdnum;
  80153f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801542:	89 d8                	mov    %ebx,%eax
  801544:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801547:	5b                   	pop    %ebx
  801548:	5e                   	pop    %esi
  801549:	5f                   	pop    %edi
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80154c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801553:	83 ec 0c             	sub    $0xc,%esp
  801556:	25 07 0e 00 00       	and    $0xe07,%eax
  80155b:	50                   	push   %eax
  80155c:	57                   	push   %edi
  80155d:	6a 00                	push   $0x0
  80155f:	53                   	push   %ebx
  801560:	6a 00                	push   $0x0
  801562:	e8 4a f8 ff ff       	call   800db1 <sys_page_map>
  801567:	89 c3                	mov    %eax,%ebx
  801569:	83 c4 20             	add    $0x20,%esp
  80156c:	85 c0                	test   %eax,%eax
  80156e:	79 a3                	jns    801513 <dup+0x74>
	sys_page_unmap(0, newfd);
  801570:	83 ec 08             	sub    $0x8,%esp
  801573:	56                   	push   %esi
  801574:	6a 00                	push   $0x0
  801576:	e8 78 f8 ff ff       	call   800df3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80157b:	83 c4 08             	add    $0x8,%esp
  80157e:	57                   	push   %edi
  80157f:	6a 00                	push   $0x0
  801581:	e8 6d f8 ff ff       	call   800df3 <sys_page_unmap>
	return r;
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	eb b7                	jmp    801542 <dup+0xa3>

0080158b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	53                   	push   %ebx
  80158f:	83 ec 14             	sub    $0x14,%esp
  801592:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801595:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801598:	50                   	push   %eax
  801599:	53                   	push   %ebx
  80159a:	e8 7f fd ff ff       	call   80131e <fd_lookup>
  80159f:	83 c4 08             	add    $0x8,%esp
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	78 3f                	js     8015e5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ac:	50                   	push   %eax
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	ff 30                	pushl  (%eax)
  8015b2:	e8 be fd ff ff       	call   801375 <dev_lookup>
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 27                	js     8015e5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015c1:	8b 42 08             	mov    0x8(%edx),%eax
  8015c4:	83 e0 03             	and    $0x3,%eax
  8015c7:	83 f8 01             	cmp    $0x1,%eax
  8015ca:	74 1e                	je     8015ea <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cf:	8b 40 08             	mov    0x8(%eax),%eax
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	74 35                	je     80160b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015d6:	83 ec 04             	sub    $0x4,%esp
  8015d9:	ff 75 10             	pushl  0x10(%ebp)
  8015dc:	ff 75 0c             	pushl  0xc(%ebp)
  8015df:	52                   	push   %edx
  8015e0:	ff d0                	call   *%eax
  8015e2:	83 c4 10             	add    $0x10,%esp
}
  8015e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8015ef:	8b 40 48             	mov    0x48(%eax),%eax
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	53                   	push   %ebx
  8015f6:	50                   	push   %eax
  8015f7:	68 ed 28 80 00       	push   $0x8028ed
  8015fc:	e8 b0 ed ff ff       	call   8003b1 <cprintf>
		return -E_INVAL;
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801609:	eb da                	jmp    8015e5 <read+0x5a>
		return -E_NOT_SUPP;
  80160b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801610:	eb d3                	jmp    8015e5 <read+0x5a>

00801612 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	57                   	push   %edi
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
  801618:	83 ec 0c             	sub    $0xc,%esp
  80161b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80161e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801621:	bb 00 00 00 00       	mov    $0x0,%ebx
  801626:	39 f3                	cmp    %esi,%ebx
  801628:	73 25                	jae    80164f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	89 f0                	mov    %esi,%eax
  80162f:	29 d8                	sub    %ebx,%eax
  801631:	50                   	push   %eax
  801632:	89 d8                	mov    %ebx,%eax
  801634:	03 45 0c             	add    0xc(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	57                   	push   %edi
  801639:	e8 4d ff ff ff       	call   80158b <read>
		if (m < 0)
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	85 c0                	test   %eax,%eax
  801643:	78 08                	js     80164d <readn+0x3b>
			return m;
		if (m == 0)
  801645:	85 c0                	test   %eax,%eax
  801647:	74 06                	je     80164f <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801649:	01 c3                	add    %eax,%ebx
  80164b:	eb d9                	jmp    801626 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80164f:	89 d8                	mov    %ebx,%eax
  801651:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5f                   	pop    %edi
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	53                   	push   %ebx
  80165d:	83 ec 14             	sub    $0x14,%esp
  801660:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801663:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801666:	50                   	push   %eax
  801667:	53                   	push   %ebx
  801668:	e8 b1 fc ff ff       	call   80131e <fd_lookup>
  80166d:	83 c4 08             	add    $0x8,%esp
  801670:	85 c0                	test   %eax,%eax
  801672:	78 3a                	js     8016ae <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801674:	83 ec 08             	sub    $0x8,%esp
  801677:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167a:	50                   	push   %eax
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	ff 30                	pushl  (%eax)
  801680:	e8 f0 fc ff ff       	call   801375 <dev_lookup>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	85 c0                	test   %eax,%eax
  80168a:	78 22                	js     8016ae <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80168c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801693:	74 1e                	je     8016b3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801695:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801698:	8b 52 0c             	mov    0xc(%edx),%edx
  80169b:	85 d2                	test   %edx,%edx
  80169d:	74 35                	je     8016d4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	ff 75 10             	pushl  0x10(%ebp)
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	50                   	push   %eax
  8016a9:	ff d2                	call   *%edx
  8016ab:	83 c4 10             	add    $0x10,%esp
}
  8016ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b3:	a1 04 40 80 00       	mov    0x804004,%eax
  8016b8:	8b 40 48             	mov    0x48(%eax),%eax
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	53                   	push   %ebx
  8016bf:	50                   	push   %eax
  8016c0:	68 09 29 80 00       	push   $0x802909
  8016c5:	e8 e7 ec ff ff       	call   8003b1 <cprintf>
		return -E_INVAL;
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d2:	eb da                	jmp    8016ae <write+0x55>
		return -E_NOT_SUPP;
  8016d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d9:	eb d3                	jmp    8016ae <write+0x55>

008016db <seek>:

int
seek(int fdnum, off_t offset)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e1:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 31 fc ff ff       	call   80131e <fd_lookup>
  8016ed:	83 c4 08             	add    $0x8,%esp
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	78 0e                	js     801702 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fa:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	53                   	push   %ebx
  801708:	83 ec 14             	sub    $0x14,%esp
  80170b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801711:	50                   	push   %eax
  801712:	53                   	push   %ebx
  801713:	e8 06 fc ff ff       	call   80131e <fd_lookup>
  801718:	83 c4 08             	add    $0x8,%esp
  80171b:	85 c0                	test   %eax,%eax
  80171d:	78 37                	js     801756 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801725:	50                   	push   %eax
  801726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801729:	ff 30                	pushl  (%eax)
  80172b:	e8 45 fc ff ff       	call   801375 <dev_lookup>
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	85 c0                	test   %eax,%eax
  801735:	78 1f                	js     801756 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80173e:	74 1b                	je     80175b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801743:	8b 52 18             	mov    0x18(%edx),%edx
  801746:	85 d2                	test   %edx,%edx
  801748:	74 32                	je     80177c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	50                   	push   %eax
  801751:	ff d2                	call   *%edx
  801753:	83 c4 10             	add    $0x10,%esp
}
  801756:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801759:	c9                   	leave  
  80175a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80175b:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801760:	8b 40 48             	mov    0x48(%eax),%eax
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	53                   	push   %ebx
  801767:	50                   	push   %eax
  801768:	68 cc 28 80 00       	push   $0x8028cc
  80176d:	e8 3f ec ff ff       	call   8003b1 <cprintf>
		return -E_INVAL;
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177a:	eb da                	jmp    801756 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80177c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801781:	eb d3                	jmp    801756 <ftruncate+0x52>

00801783 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	53                   	push   %ebx
  801787:	83 ec 14             	sub    $0x14,%esp
  80178a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801790:	50                   	push   %eax
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 85 fb ff ff       	call   80131e <fd_lookup>
  801799:	83 c4 08             	add    $0x8,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 4b                	js     8017eb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a6:	50                   	push   %eax
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	ff 30                	pushl  (%eax)
  8017ac:	e8 c4 fb ff ff       	call   801375 <dev_lookup>
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	78 33                	js     8017eb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017bf:	74 2f                	je     8017f0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017c1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017c4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017cb:	00 00 00 
	stat->st_type = 0;
  8017ce:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017d5:	00 00 00 
	stat->st_dev = dev;
  8017d8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017de:	83 ec 08             	sub    $0x8,%esp
  8017e1:	53                   	push   %ebx
  8017e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e5:	ff 50 14             	call   *0x14(%eax)
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    
		return -E_NOT_SUPP;
  8017f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f5:	eb f4                	jmp    8017eb <fstat+0x68>

008017f7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017fc:	83 ec 08             	sub    $0x8,%esp
  8017ff:	6a 00                	push   $0x0
  801801:	ff 75 08             	pushl  0x8(%ebp)
  801804:	e8 34 02 00 00       	call   801a3d <open>
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 1b                	js     80182d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	50                   	push   %eax
  801819:	e8 65 ff ff ff       	call   801783 <fstat>
  80181e:	89 c6                	mov    %eax,%esi
	close(fd);
  801820:	89 1c 24             	mov    %ebx,(%esp)
  801823:	e8 29 fc ff ff       	call   801451 <close>
	return r;
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	89 f3                	mov    %esi,%ebx
}
  80182d:	89 d8                	mov    %ebx,%eax
  80182f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	89 c6                	mov    %eax,%esi
  80183d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80183f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801846:	74 27                	je     80186f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801848:	6a 07                	push   $0x7
  80184a:	68 00 50 80 00       	push   $0x805000
  80184f:	56                   	push   %esi
  801850:	ff 35 00 40 80 00    	pushl  0x804000
  801856:	e8 4d 08 00 00       	call   8020a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80185b:	83 c4 0c             	add    $0xc,%esp
  80185e:	6a 00                	push   $0x0
  801860:	53                   	push   %ebx
  801861:	6a 00                	push   $0x0
  801863:	e8 b7 07 00 00       	call   80201f <ipc_recv>
}
  801868:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5d                   	pop    %ebp
  80186e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	6a 01                	push   $0x1
  801874:	e8 8b 08 00 00       	call   802104 <ipc_find_env>
  801879:	a3 00 40 80 00       	mov    %eax,0x804000
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	eb c5                	jmp    801848 <fsipc+0x12>

00801883 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	8b 40 0c             	mov    0xc(%eax),%eax
  80188f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801894:	8b 45 0c             	mov    0xc(%ebp),%eax
  801897:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80189c:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a1:	b8 02 00 00 00       	mov    $0x2,%eax
  8018a6:	e8 8b ff ff ff       	call   801836 <fsipc>
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <devfile_flush>:
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b9:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018be:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c3:	b8 06 00 00 00       	mov    $0x6,%eax
  8018c8:	e8 69 ff ff ff       	call   801836 <fsipc>
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <devfile_stat>:
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	53                   	push   %ebx
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018df:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8018ee:	e8 43 ff ff ff       	call   801836 <fsipc>
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 2c                	js     801923 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	68 00 50 80 00       	push   $0x805000
  8018ff:	53                   	push   %ebx
  801900:	e8 b4 f0 ff ff       	call   8009b9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801905:	a1 80 50 80 00       	mov    0x805080,%eax
  80190a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801910:	a1 84 50 80 00       	mov    0x805084,%eax
  801915:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <devfile_write>:
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	53                   	push   %ebx
  80192c:	83 ec 04             	sub    $0x4,%esp
  80192f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801932:	89 d8                	mov    %ebx,%eax
  801934:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80193a:	76 05                	jbe    801941 <devfile_write+0x19>
  80193c:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801941:	8b 55 08             	mov    0x8(%ebp),%edx
  801944:	8b 52 0c             	mov    0xc(%edx),%edx
  801947:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80194d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	50                   	push   %eax
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	68 08 50 80 00       	push   $0x805008
  80195e:	e8 c9 f1 ff ff       	call   800b2c <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801963:	ba 00 00 00 00       	mov    $0x0,%edx
  801968:	b8 04 00 00 00       	mov    $0x4,%eax
  80196d:	e8 c4 fe ff ff       	call   801836 <fsipc>
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	85 c0                	test   %eax,%eax
  801977:	78 0b                	js     801984 <devfile_write+0x5c>
	assert(r <= n);
  801979:	39 c3                	cmp    %eax,%ebx
  80197b:	72 0c                	jb     801989 <devfile_write+0x61>
	assert(r <= PGSIZE);
  80197d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801982:	7f 1e                	jg     8019a2 <devfile_write+0x7a>
}
  801984:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801987:	c9                   	leave  
  801988:	c3                   	ret    
	assert(r <= n);
  801989:	68 38 29 80 00       	push   $0x802938
  80198e:	68 76 28 80 00       	push   $0x802876
  801993:	68 98 00 00 00       	push   $0x98
  801998:	68 3f 29 80 00       	push   $0x80293f
  80199d:	e8 fc e8 ff ff       	call   80029e <_panic>
	assert(r <= PGSIZE);
  8019a2:	68 4a 29 80 00       	push   $0x80294a
  8019a7:	68 76 28 80 00       	push   $0x802876
  8019ac:	68 99 00 00 00       	push   $0x99
  8019b1:	68 3f 29 80 00       	push   $0x80293f
  8019b6:	e8 e3 e8 ff ff       	call   80029e <_panic>

008019bb <devfile_read>:
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
  8019c0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019ce:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8019de:	e8 53 fe ff ff       	call   801836 <fsipc>
  8019e3:	89 c3                	mov    %eax,%ebx
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	78 1f                	js     801a08 <devfile_read+0x4d>
	assert(r <= n);
  8019e9:	39 c6                	cmp    %eax,%esi
  8019eb:	72 24                	jb     801a11 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019f2:	7f 33                	jg     801a27 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	50                   	push   %eax
  8019f8:	68 00 50 80 00       	push   $0x805000
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	e8 27 f1 ff ff       	call   800b2c <memmove>
	return r;
  801a05:	83 c4 10             	add    $0x10,%esp
}
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0d:	5b                   	pop    %ebx
  801a0e:	5e                   	pop    %esi
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    
	assert(r <= n);
  801a11:	68 38 29 80 00       	push   $0x802938
  801a16:	68 76 28 80 00       	push   $0x802876
  801a1b:	6a 7c                	push   $0x7c
  801a1d:	68 3f 29 80 00       	push   $0x80293f
  801a22:	e8 77 e8 ff ff       	call   80029e <_panic>
	assert(r <= PGSIZE);
  801a27:	68 4a 29 80 00       	push   $0x80294a
  801a2c:	68 76 28 80 00       	push   $0x802876
  801a31:	6a 7d                	push   $0x7d
  801a33:	68 3f 29 80 00       	push   $0x80293f
  801a38:	e8 61 e8 ff ff       	call   80029e <_panic>

00801a3d <open>:
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	83 ec 1c             	sub    $0x1c,%esp
  801a45:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a48:	56                   	push   %esi
  801a49:	e8 38 ef ff ff       	call   800986 <strlen>
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a56:	7f 6c                	jg     801ac4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5e:	50                   	push   %eax
  801a5f:	e8 6b f8 ff ff       	call   8012cf <fd_alloc>
  801a64:	89 c3                	mov    %eax,%ebx
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 3c                	js     801aa9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	56                   	push   %esi
  801a71:	68 00 50 80 00       	push   $0x805000
  801a76:	e8 3e ef ff ff       	call   8009b9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a86:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8b:	e8 a6 fd ff ff       	call   801836 <fsipc>
  801a90:	89 c3                	mov    %eax,%ebx
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 19                	js     801ab2 <open+0x75>
	return fd2num(fd);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9f:	e8 04 f8 ff ff       	call   8012a8 <fd2num>
  801aa4:	89 c3                	mov    %eax,%ebx
  801aa6:	83 c4 10             	add    $0x10,%esp
}
  801aa9:	89 d8                	mov    %ebx,%eax
  801aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5e                   	pop    %esi
  801ab0:	5d                   	pop    %ebp
  801ab1:	c3                   	ret    
		fd_close(fd, 0);
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	6a 00                	push   $0x0
  801ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aba:	e8 0c f9 ff ff       	call   8013cb <fd_close>
		return r;
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	eb e5                	jmp    801aa9 <open+0x6c>
		return -E_BAD_PATH;
  801ac4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ac9:	eb de                	jmp    801aa9 <open+0x6c>

00801acb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad6:	b8 08 00 00 00       	mov    $0x8,%eax
  801adb:	e8 56 fd ff ff       	call   801836 <fsipc>
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	56                   	push   %esi
  801ae6:	53                   	push   %ebx
  801ae7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	ff 75 08             	pushl  0x8(%ebp)
  801af0:	e8 c3 f7 ff ff       	call   8012b8 <fd2data>
  801af5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801af7:	83 c4 08             	add    $0x8,%esp
  801afa:	68 56 29 80 00       	push   $0x802956
  801aff:	53                   	push   %ebx
  801b00:	e8 b4 ee ff ff       	call   8009b9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b05:	8b 46 04             	mov    0x4(%esi),%eax
  801b08:	2b 06                	sub    (%esi),%eax
  801b0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801b10:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801b17:	10 00 00 
	stat->st_dev = &devpipe;
  801b1a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b21:	30 80 00 
	return 0;
}
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
  801b29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2c:	5b                   	pop    %ebx
  801b2d:	5e                   	pop    %esi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	53                   	push   %ebx
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b3a:	53                   	push   %ebx
  801b3b:	6a 00                	push   $0x0
  801b3d:	e8 b1 f2 ff ff       	call   800df3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b42:	89 1c 24             	mov    %ebx,(%esp)
  801b45:	e8 6e f7 ff ff       	call   8012b8 <fd2data>
  801b4a:	83 c4 08             	add    $0x8,%esp
  801b4d:	50                   	push   %eax
  801b4e:	6a 00                	push   $0x0
  801b50:	e8 9e f2 ff ff       	call   800df3 <sys_page_unmap>
}
  801b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <_pipeisclosed>:
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	57                   	push   %edi
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	83 ec 1c             	sub    $0x1c,%esp
  801b63:	89 c7                	mov    %eax,%edi
  801b65:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b67:	a1 04 40 80 00       	mov    0x804004,%eax
  801b6c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b6f:	83 ec 0c             	sub    $0xc,%esp
  801b72:	57                   	push   %edi
  801b73:	e8 ce 05 00 00       	call   802146 <pageref>
  801b78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b7b:	89 34 24             	mov    %esi,(%esp)
  801b7e:	e8 c3 05 00 00       	call   802146 <pageref>
		nn = thisenv->env_runs;
  801b83:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b89:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	39 cb                	cmp    %ecx,%ebx
  801b91:	74 1b                	je     801bae <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b93:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b96:	75 cf                	jne    801b67 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b98:	8b 42 58             	mov    0x58(%edx),%eax
  801b9b:	6a 01                	push   $0x1
  801b9d:	50                   	push   %eax
  801b9e:	53                   	push   %ebx
  801b9f:	68 5d 29 80 00       	push   $0x80295d
  801ba4:	e8 08 e8 ff ff       	call   8003b1 <cprintf>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	eb b9                	jmp    801b67 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bb1:	0f 94 c0             	sete   %al
  801bb4:	0f b6 c0             	movzbl %al,%eax
}
  801bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bba:	5b                   	pop    %ebx
  801bbb:	5e                   	pop    %esi
  801bbc:	5f                   	pop    %edi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    

00801bbf <devpipe_write>:
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	57                   	push   %edi
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	83 ec 18             	sub    $0x18,%esp
  801bc8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bcb:	56                   	push   %esi
  801bcc:	e8 e7 f6 ff ff       	call   8012b8 <fd2data>
  801bd1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	bf 00 00 00 00       	mov    $0x0,%edi
  801bdb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bde:	74 41                	je     801c21 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801be0:	8b 53 04             	mov    0x4(%ebx),%edx
  801be3:	8b 03                	mov    (%ebx),%eax
  801be5:	83 c0 20             	add    $0x20,%eax
  801be8:	39 c2                	cmp    %eax,%edx
  801bea:	72 14                	jb     801c00 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bec:	89 da                	mov    %ebx,%edx
  801bee:	89 f0                	mov    %esi,%eax
  801bf0:	e8 65 ff ff ff       	call   801b5a <_pipeisclosed>
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	75 2c                	jne    801c25 <devpipe_write+0x66>
			sys_yield();
  801bf9:	e8 37 f2 ff ff       	call   800e35 <sys_yield>
  801bfe:	eb e0                	jmp    801be0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c03:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801c06:	89 d0                	mov    %edx,%eax
  801c08:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801c0d:	78 0b                	js     801c1a <devpipe_write+0x5b>
  801c0f:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801c13:	42                   	inc    %edx
  801c14:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c17:	47                   	inc    %edi
  801c18:	eb c1                	jmp    801bdb <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c1a:	48                   	dec    %eax
  801c1b:	83 c8 e0             	or     $0xffffffe0,%eax
  801c1e:	40                   	inc    %eax
  801c1f:	eb ee                	jmp    801c0f <devpipe_write+0x50>
	return i;
  801c21:	89 f8                	mov    %edi,%eax
  801c23:	eb 05                	jmp    801c2a <devpipe_write+0x6b>
				return 0;
  801c25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5f                   	pop    %edi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    

00801c32 <devpipe_read>:
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	57                   	push   %edi
  801c36:	56                   	push   %esi
  801c37:	53                   	push   %ebx
  801c38:	83 ec 18             	sub    $0x18,%esp
  801c3b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c3e:	57                   	push   %edi
  801c3f:	e8 74 f6 ff ff       	call   8012b8 <fd2data>
  801c44:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c4e:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c51:	74 46                	je     801c99 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801c53:	8b 06                	mov    (%esi),%eax
  801c55:	3b 46 04             	cmp    0x4(%esi),%eax
  801c58:	75 22                	jne    801c7c <devpipe_read+0x4a>
			if (i > 0)
  801c5a:	85 db                	test   %ebx,%ebx
  801c5c:	74 0a                	je     801c68 <devpipe_read+0x36>
				return i;
  801c5e:	89 d8                	mov    %ebx,%eax
}
  801c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c63:	5b                   	pop    %ebx
  801c64:	5e                   	pop    %esi
  801c65:	5f                   	pop    %edi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801c68:	89 f2                	mov    %esi,%edx
  801c6a:	89 f8                	mov    %edi,%eax
  801c6c:	e8 e9 fe ff ff       	call   801b5a <_pipeisclosed>
  801c71:	85 c0                	test   %eax,%eax
  801c73:	75 28                	jne    801c9d <devpipe_read+0x6b>
			sys_yield();
  801c75:	e8 bb f1 ff ff       	call   800e35 <sys_yield>
  801c7a:	eb d7                	jmp    801c53 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c7c:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801c81:	78 0f                	js     801c92 <devpipe_read+0x60>
  801c83:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801c87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8a:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c8d:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801c8f:	43                   	inc    %ebx
  801c90:	eb bc                	jmp    801c4e <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c92:	48                   	dec    %eax
  801c93:	83 c8 e0             	or     $0xffffffe0,%eax
  801c96:	40                   	inc    %eax
  801c97:	eb ea                	jmp    801c83 <devpipe_read+0x51>
	return i;
  801c99:	89 d8                	mov    %ebx,%eax
  801c9b:	eb c3                	jmp    801c60 <devpipe_read+0x2e>
				return 0;
  801c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca2:	eb bc                	jmp    801c60 <devpipe_read+0x2e>

00801ca4 <pipe>:
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	56                   	push   %esi
  801ca8:	53                   	push   %ebx
  801ca9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801caf:	50                   	push   %eax
  801cb0:	e8 1a f6 ff ff       	call   8012cf <fd_alloc>
  801cb5:	89 c3                	mov    %eax,%ebx
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	0f 88 2a 01 00 00    	js     801dec <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	68 07 04 00 00       	push   $0x407
  801cca:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccd:	6a 00                	push   $0x0
  801ccf:	e8 9a f0 ff ff       	call   800d6e <sys_page_alloc>
  801cd4:	89 c3                	mov    %eax,%ebx
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	0f 88 0b 01 00 00    	js     801dec <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801ce1:	83 ec 0c             	sub    $0xc,%esp
  801ce4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ce7:	50                   	push   %eax
  801ce8:	e8 e2 f5 ff ff       	call   8012cf <fd_alloc>
  801ced:	89 c3                	mov    %eax,%ebx
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	0f 88 e2 00 00 00    	js     801ddc <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	68 07 04 00 00       	push   $0x407
  801d02:	ff 75 f0             	pushl  -0x10(%ebp)
  801d05:	6a 00                	push   $0x0
  801d07:	e8 62 f0 ff ff       	call   800d6e <sys_page_alloc>
  801d0c:	89 c3                	mov    %eax,%ebx
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	0f 88 c3 00 00 00    	js     801ddc <pipe+0x138>
	va = fd2data(fd0);
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1f:	e8 94 f5 ff ff       	call   8012b8 <fd2data>
  801d24:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d26:	83 c4 0c             	add    $0xc,%esp
  801d29:	68 07 04 00 00       	push   $0x407
  801d2e:	50                   	push   %eax
  801d2f:	6a 00                	push   $0x0
  801d31:	e8 38 f0 ff ff       	call   800d6e <sys_page_alloc>
  801d36:	89 c3                	mov    %eax,%ebx
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	0f 88 89 00 00 00    	js     801dcc <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	ff 75 f0             	pushl  -0x10(%ebp)
  801d49:	e8 6a f5 ff ff       	call   8012b8 <fd2data>
  801d4e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d55:	50                   	push   %eax
  801d56:	6a 00                	push   $0x0
  801d58:	56                   	push   %esi
  801d59:	6a 00                	push   $0x0
  801d5b:	e8 51 f0 ff ff       	call   800db1 <sys_page_map>
  801d60:	89 c3                	mov    %eax,%ebx
  801d62:	83 c4 20             	add    $0x20,%esp
  801d65:	85 c0                	test   %eax,%eax
  801d67:	78 55                	js     801dbe <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801d69:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d7e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d87:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d93:	83 ec 0c             	sub    $0xc,%esp
  801d96:	ff 75 f4             	pushl  -0xc(%ebp)
  801d99:	e8 0a f5 ff ff       	call   8012a8 <fd2num>
  801d9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801da3:	83 c4 04             	add    $0x4,%esp
  801da6:	ff 75 f0             	pushl  -0x10(%ebp)
  801da9:	e8 fa f4 ff ff       	call   8012a8 <fd2num>
  801dae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dbc:	eb 2e                	jmp    801dec <pipe+0x148>
	sys_page_unmap(0, va);
  801dbe:	83 ec 08             	sub    $0x8,%esp
  801dc1:	56                   	push   %esi
  801dc2:	6a 00                	push   $0x0
  801dc4:	e8 2a f0 ff ff       	call   800df3 <sys_page_unmap>
  801dc9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dcc:	83 ec 08             	sub    $0x8,%esp
  801dcf:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd2:	6a 00                	push   $0x0
  801dd4:	e8 1a f0 ff ff       	call   800df3 <sys_page_unmap>
  801dd9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ddc:	83 ec 08             	sub    $0x8,%esp
  801ddf:	ff 75 f4             	pushl  -0xc(%ebp)
  801de2:	6a 00                	push   $0x0
  801de4:	e8 0a f0 ff ff       	call   800df3 <sys_page_unmap>
  801de9:	83 c4 10             	add    $0x10,%esp
}
  801dec:	89 d8                	mov    %ebx,%eax
  801dee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df1:	5b                   	pop    %ebx
  801df2:	5e                   	pop    %esi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    

00801df5 <pipeisclosed>:
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfe:	50                   	push   %eax
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 17 f5 ff ff       	call   80131e <fd_lookup>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	78 18                	js     801e26 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e0e:	83 ec 0c             	sub    $0xc,%esp
  801e11:	ff 75 f4             	pushl  -0xc(%ebp)
  801e14:	e8 9f f4 ff ff       	call   8012b8 <fd2data>
	return _pipeisclosed(fd, p);
  801e19:	89 c2                	mov    %eax,%edx
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	e8 37 fd ff ff       	call   801b5a <_pipeisclosed>
  801e23:	83 c4 10             	add    $0x10,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    

00801e32 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	53                   	push   %ebx
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801e3c:	68 70 29 80 00       	push   $0x802970
  801e41:	53                   	push   %ebx
  801e42:	e8 72 eb ff ff       	call   8009b9 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801e47:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801e4e:	20 00 00 
	return 0;
}
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
  801e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <devcons_write>:
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	57                   	push   %edi
  801e5f:	56                   	push   %esi
  801e60:	53                   	push   %ebx
  801e61:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e67:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e6c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e72:	eb 1d                	jmp    801e91 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	53                   	push   %ebx
  801e78:	03 45 0c             	add    0xc(%ebp),%eax
  801e7b:	50                   	push   %eax
  801e7c:	57                   	push   %edi
  801e7d:	e8 aa ec ff ff       	call   800b2c <memmove>
		sys_cputs(buf, m);
  801e82:	83 c4 08             	add    $0x8,%esp
  801e85:	53                   	push   %ebx
  801e86:	57                   	push   %edi
  801e87:	e8 45 ee ff ff       	call   800cd1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e8c:	01 de                	add    %ebx,%esi
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	89 f0                	mov    %esi,%eax
  801e93:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e96:	73 11                	jae    801ea9 <devcons_write+0x4e>
		m = n - tot;
  801e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e9b:	29 f3                	sub    %esi,%ebx
  801e9d:	83 fb 7f             	cmp    $0x7f,%ebx
  801ea0:	76 d2                	jbe    801e74 <devcons_write+0x19>
  801ea2:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801ea7:	eb cb                	jmp    801e74 <devcons_write+0x19>
}
  801ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eac:	5b                   	pop    %ebx
  801ead:	5e                   	pop    %esi
  801eae:	5f                   	pop    %edi
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    

00801eb1 <devcons_read>:
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ebb:	75 0c                	jne    801ec9 <devcons_read+0x18>
		return 0;
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	eb 21                	jmp    801ee5 <devcons_read+0x34>
		sys_yield();
  801ec4:	e8 6c ef ff ff       	call   800e35 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ec9:	e8 21 ee ff ff       	call   800cef <sys_cgetc>
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	74 f2                	je     801ec4 <devcons_read+0x13>
	if (c < 0)
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	78 0f                	js     801ee5 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801ed6:	83 f8 04             	cmp    $0x4,%eax
  801ed9:	74 0c                	je     801ee7 <devcons_read+0x36>
	*(char*)vbuf = c;
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	88 02                	mov    %al,(%edx)
	return 1;
  801ee0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    
		return 0;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eec:	eb f7                	jmp    801ee5 <devcons_read+0x34>

00801eee <cputchar>:
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801efa:	6a 01                	push   $0x1
  801efc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eff:	50                   	push   %eax
  801f00:	e8 cc ed ff ff       	call   800cd1 <sys_cputs>
}
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <getchar>:
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f10:	6a 01                	push   $0x1
  801f12:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f15:	50                   	push   %eax
  801f16:	6a 00                	push   $0x0
  801f18:	e8 6e f6 ff ff       	call   80158b <read>
	if (r < 0)
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	78 08                	js     801f2c <getchar+0x22>
	if (r < 1)
  801f24:	85 c0                	test   %eax,%eax
  801f26:	7e 06                	jle    801f2e <getchar+0x24>
	return c;
  801f28:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    
		return -E_EOF;
  801f2e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f33:	eb f7                	jmp    801f2c <getchar+0x22>

00801f35 <iscons>:
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3e:	50                   	push   %eax
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	e8 d7 f3 ff ff       	call   80131e <fd_lookup>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	78 11                	js     801f5f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f51:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f57:	39 10                	cmp    %edx,(%eax)
  801f59:	0f 94 c0             	sete   %al
  801f5c:	0f b6 c0             	movzbl %al,%eax
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <opencons>:
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6a:	50                   	push   %eax
  801f6b:	e8 5f f3 ff ff       	call   8012cf <fd_alloc>
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	85 c0                	test   %eax,%eax
  801f75:	78 3a                	js     801fb1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	68 07 04 00 00       	push   $0x407
  801f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f82:	6a 00                	push   $0x0
  801f84:	e8 e5 ed ff ff       	call   800d6e <sys_page_alloc>
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	78 21                	js     801fb1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f90:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	50                   	push   %eax
  801fa9:	e8 fa f2 ff ff       	call   8012a8 <fd2num>
  801fae:	83 c4 10             	add    $0x10,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fb9:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fc0:	74 0a                	je     801fcc <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801fcc:	e8 7e ed ff ff       	call   800d4f <sys_getenvid>
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	6a 07                	push   $0x7
  801fd6:	68 00 f0 bf ee       	push   $0xeebff000
  801fdb:	50                   	push   %eax
  801fdc:	e8 8d ed ff ff       	call   800d6e <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801fe1:	e8 69 ed ff ff       	call   800d4f <sys_getenvid>
  801fe6:	83 c4 08             	add    $0x8,%esp
  801fe9:	68 f9 1f 80 00       	push   $0x801ff9
  801fee:	50                   	push   %eax
  801fef:	e8 25 ef ff ff       	call   800f19 <sys_env_set_pgfault_upcall>
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	eb c9                	jmp    801fc2 <set_pgfault_handler+0xf>

00801ff9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801ff9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801ffa:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801fff:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802001:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  802004:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802008:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80200c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80200f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802011:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  802015:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802018:	61                   	popa   
	addl $4, %esp
  802019:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80201c:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80201d:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80201e:	c3                   	ret    

0080201f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	57                   	push   %edi
  802023:	56                   	push   %esi
  802024:	53                   	push   %ebx
  802025:	83 ec 0c             	sub    $0xc,%esp
  802028:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80202b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80202e:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  802031:	85 ff                	test   %edi,%edi
  802033:	74 53                	je     802088 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  802035:	83 ec 0c             	sub    $0xc,%esp
  802038:	57                   	push   %edi
  802039:	e8 40 ef ff ff       	call   800f7e <sys_ipc_recv>
  80203e:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  802041:	85 db                	test   %ebx,%ebx
  802043:	74 0b                	je     802050 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802045:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80204b:	8b 52 74             	mov    0x74(%edx),%edx
  80204e:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  802050:	85 f6                	test   %esi,%esi
  802052:	74 0f                	je     802063 <ipc_recv+0x44>
  802054:	85 ff                	test   %edi,%edi
  802056:	74 0b                	je     802063 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802058:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80205e:	8b 52 78             	mov    0x78(%edx),%edx
  802061:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  802063:	85 c0                	test   %eax,%eax
  802065:	74 30                	je     802097 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802067:	85 db                	test   %ebx,%ebx
  802069:	74 06                	je     802071 <ipc_recv+0x52>
      		*from_env_store = 0;
  80206b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  802071:	85 f6                	test   %esi,%esi
  802073:	74 2c                	je     8020a1 <ipc_recv+0x82>
      		*perm_store = 0;
  802075:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80207b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  802080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802083:	5b                   	pop    %ebx
  802084:	5e                   	pop    %esi
  802085:	5f                   	pop    %edi
  802086:	5d                   	pop    %ebp
  802087:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	6a ff                	push   $0xffffffff
  80208d:	e8 ec ee ff ff       	call   800f7e <sys_ipc_recv>
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	eb aa                	jmp    802041 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  802097:	a1 04 40 80 00       	mov    0x804004,%eax
  80209c:	8b 40 70             	mov    0x70(%eax),%eax
  80209f:	eb df                	jmp    802080 <ipc_recv+0x61>
		return -1;
  8020a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020a6:	eb d8                	jmp    802080 <ipc_recv+0x61>

008020a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	57                   	push   %edi
  8020ac:	56                   	push   %esi
  8020ad:	53                   	push   %ebx
  8020ae:	83 ec 0c             	sub    $0xc,%esp
  8020b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020b7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8020ba:	85 db                	test   %ebx,%ebx
  8020bc:	75 22                	jne    8020e0 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8020be:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8020c3:	eb 1b                	jmp    8020e0 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8020c5:	68 7c 29 80 00       	push   $0x80297c
  8020ca:	68 76 28 80 00       	push   $0x802876
  8020cf:	6a 48                	push   $0x48
  8020d1:	68 a0 29 80 00       	push   $0x8029a0
  8020d6:	e8 c3 e1 ff ff       	call   80029e <_panic>
		sys_yield();
  8020db:	e8 55 ed ff ff       	call   800e35 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8020e0:	57                   	push   %edi
  8020e1:	53                   	push   %ebx
  8020e2:	56                   	push   %esi
  8020e3:	ff 75 08             	pushl  0x8(%ebp)
  8020e6:	e8 70 ee ff ff       	call   800f5b <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020f1:	74 e8                	je     8020db <ipc_send+0x33>
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	75 ce                	jne    8020c5 <ipc_send+0x1d>
		sys_yield();
  8020f7:	e8 39 ed ff ff       	call   800e35 <sys_yield>
		
	}
	
}
  8020fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5f                   	pop    %edi
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80210f:	89 c2                	mov    %eax,%edx
  802111:	c1 e2 05             	shl    $0x5,%edx
  802114:	29 c2                	sub    %eax,%edx
  802116:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  80211d:	8b 52 50             	mov    0x50(%edx),%edx
  802120:	39 ca                	cmp    %ecx,%edx
  802122:	74 0f                	je     802133 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802124:	40                   	inc    %eax
  802125:	3d 00 04 00 00       	cmp    $0x400,%eax
  80212a:	75 e3                	jne    80210f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
  802131:	eb 11                	jmp    802144 <ipc_find_env+0x40>
			return envs[i].env_id;
  802133:	89 c2                	mov    %eax,%edx
  802135:	c1 e2 05             	shl    $0x5,%edx
  802138:	29 c2                	sub    %eax,%edx
  80213a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  802141:	8b 40 48             	mov    0x48(%eax),%eax
}
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    

00802146 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	c1 e8 16             	shr    $0x16,%eax
  80214f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802156:	a8 01                	test   $0x1,%al
  802158:	74 21                	je     80217b <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	c1 e8 0c             	shr    $0xc,%eax
  802160:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802167:	a8 01                	test   $0x1,%al
  802169:	74 17                	je     802182 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80216b:	c1 e8 0c             	shr    $0xc,%eax
  80216e:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802175:	ef 
  802176:	0f b7 c0             	movzwl %ax,%eax
  802179:	eb 05                	jmp    802180 <pageref+0x3a>
		return 0;
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    
		return 0;
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
  802187:	eb f7                	jmp    802180 <pageref+0x3a>
  802189:	66 90                	xchg   %ax,%ax
  80218b:	90                   	nop

0080218c <__udivdi3>:
  80218c:	55                   	push   %ebp
  80218d:	57                   	push   %edi
  80218e:	56                   	push   %esi
  80218f:	53                   	push   %ebx
  802190:	83 ec 1c             	sub    $0x1c,%esp
  802193:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802197:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80219b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80219f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021a3:	89 ca                	mov    %ecx,%edx
  8021a5:	89 f8                	mov    %edi,%eax
  8021a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021ab:	85 f6                	test   %esi,%esi
  8021ad:	75 2d                	jne    8021dc <__udivdi3+0x50>
  8021af:	39 cf                	cmp    %ecx,%edi
  8021b1:	77 65                	ja     802218 <__udivdi3+0x8c>
  8021b3:	89 fd                	mov    %edi,%ebp
  8021b5:	85 ff                	test   %edi,%edi
  8021b7:	75 0b                	jne    8021c4 <__udivdi3+0x38>
  8021b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021be:	31 d2                	xor    %edx,%edx
  8021c0:	f7 f7                	div    %edi
  8021c2:	89 c5                	mov    %eax,%ebp
  8021c4:	31 d2                	xor    %edx,%edx
  8021c6:	89 c8                	mov    %ecx,%eax
  8021c8:	f7 f5                	div    %ebp
  8021ca:	89 c1                	mov    %eax,%ecx
  8021cc:	89 d8                	mov    %ebx,%eax
  8021ce:	f7 f5                	div    %ebp
  8021d0:	89 cf                	mov    %ecx,%edi
  8021d2:	89 fa                	mov    %edi,%edx
  8021d4:	83 c4 1c             	add    $0x1c,%esp
  8021d7:	5b                   	pop    %ebx
  8021d8:	5e                   	pop    %esi
  8021d9:	5f                   	pop    %edi
  8021da:	5d                   	pop    %ebp
  8021db:	c3                   	ret    
  8021dc:	39 ce                	cmp    %ecx,%esi
  8021de:	77 28                	ja     802208 <__udivdi3+0x7c>
  8021e0:	0f bd fe             	bsr    %esi,%edi
  8021e3:	83 f7 1f             	xor    $0x1f,%edi
  8021e6:	75 40                	jne    802228 <__udivdi3+0x9c>
  8021e8:	39 ce                	cmp    %ecx,%esi
  8021ea:	72 0a                	jb     8021f6 <__udivdi3+0x6a>
  8021ec:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8021f0:	0f 87 9e 00 00 00    	ja     802294 <__udivdi3+0x108>
  8021f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fb:	89 fa                	mov    %edi,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	31 ff                	xor    %edi,%edi
  80220a:	31 c0                	xor    %eax,%eax
  80220c:	89 fa                	mov    %edi,%edx
  80220e:	83 c4 1c             	add    $0x1c,%esp
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5f                   	pop    %edi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    
  802216:	66 90                	xchg   %ax,%ax
  802218:	89 d8                	mov    %ebx,%eax
  80221a:	f7 f7                	div    %edi
  80221c:	31 ff                	xor    %edi,%edi
  80221e:	89 fa                	mov    %edi,%edx
  802220:	83 c4 1c             	add    $0x1c,%esp
  802223:	5b                   	pop    %ebx
  802224:	5e                   	pop    %esi
  802225:	5f                   	pop    %edi
  802226:	5d                   	pop    %ebp
  802227:	c3                   	ret    
  802228:	bd 20 00 00 00       	mov    $0x20,%ebp
  80222d:	29 fd                	sub    %edi,%ebp
  80222f:	89 f9                	mov    %edi,%ecx
  802231:	d3 e6                	shl    %cl,%esi
  802233:	89 c3                	mov    %eax,%ebx
  802235:	89 e9                	mov    %ebp,%ecx
  802237:	d3 eb                	shr    %cl,%ebx
  802239:	89 d9                	mov    %ebx,%ecx
  80223b:	09 f1                	or     %esi,%ecx
  80223d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802241:	89 f9                	mov    %edi,%ecx
  802243:	d3 e0                	shl    %cl,%eax
  802245:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802249:	89 d6                	mov    %edx,%esi
  80224b:	89 e9                	mov    %ebp,%ecx
  80224d:	d3 ee                	shr    %cl,%esi
  80224f:	89 f9                	mov    %edi,%ecx
  802251:	d3 e2                	shl    %cl,%edx
  802253:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802257:	89 e9                	mov    %ebp,%ecx
  802259:	d3 eb                	shr    %cl,%ebx
  80225b:	09 da                	or     %ebx,%edx
  80225d:	89 d0                	mov    %edx,%eax
  80225f:	89 f2                	mov    %esi,%edx
  802261:	f7 74 24 08          	divl   0x8(%esp)
  802265:	89 d6                	mov    %edx,%esi
  802267:	89 c3                	mov    %eax,%ebx
  802269:	f7 64 24 0c          	mull   0xc(%esp)
  80226d:	39 d6                	cmp    %edx,%esi
  80226f:	72 17                	jb     802288 <__udivdi3+0xfc>
  802271:	74 09                	je     80227c <__udivdi3+0xf0>
  802273:	89 d8                	mov    %ebx,%eax
  802275:	31 ff                	xor    %edi,%edi
  802277:	e9 56 ff ff ff       	jmp    8021d2 <__udivdi3+0x46>
  80227c:	8b 54 24 04          	mov    0x4(%esp),%edx
  802280:	89 f9                	mov    %edi,%ecx
  802282:	d3 e2                	shl    %cl,%edx
  802284:	39 c2                	cmp    %eax,%edx
  802286:	73 eb                	jae    802273 <__udivdi3+0xe7>
  802288:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80228b:	31 ff                	xor    %edi,%edi
  80228d:	e9 40 ff ff ff       	jmp    8021d2 <__udivdi3+0x46>
  802292:	66 90                	xchg   %ax,%ax
  802294:	31 c0                	xor    %eax,%eax
  802296:	e9 37 ff ff ff       	jmp    8021d2 <__udivdi3+0x46>
  80229b:	90                   	nop

0080229c <__umoddi3>:
  80229c:	55                   	push   %ebp
  80229d:	57                   	push   %edi
  80229e:	56                   	push   %esi
  80229f:	53                   	push   %ebx
  8022a0:	83 ec 1c             	sub    $0x1c,%esp
  8022a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022bb:	89 3c 24             	mov    %edi,(%esp)
  8022be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022c2:	89 f2                	mov    %esi,%edx
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	75 18                	jne    8022e0 <__umoddi3+0x44>
  8022c8:	39 f7                	cmp    %esi,%edi
  8022ca:	0f 86 a0 00 00 00    	jbe    802370 <__umoddi3+0xd4>
  8022d0:	89 c8                	mov    %ecx,%eax
  8022d2:	f7 f7                	div    %edi
  8022d4:	89 d0                	mov    %edx,%eax
  8022d6:	31 d2                	xor    %edx,%edx
  8022d8:	83 c4 1c             	add    $0x1c,%esp
  8022db:	5b                   	pop    %ebx
  8022dc:	5e                   	pop    %esi
  8022dd:	5f                   	pop    %edi
  8022de:	5d                   	pop    %ebp
  8022df:	c3                   	ret    
  8022e0:	89 f3                	mov    %esi,%ebx
  8022e2:	39 f0                	cmp    %esi,%eax
  8022e4:	0f 87 a6 00 00 00    	ja     802390 <__umoddi3+0xf4>
  8022ea:	0f bd e8             	bsr    %eax,%ebp
  8022ed:	83 f5 1f             	xor    $0x1f,%ebp
  8022f0:	0f 84 a6 00 00 00    	je     80239c <__umoddi3+0x100>
  8022f6:	bf 20 00 00 00       	mov    $0x20,%edi
  8022fb:	29 ef                	sub    %ebp,%edi
  8022fd:	89 e9                	mov    %ebp,%ecx
  8022ff:	d3 e0                	shl    %cl,%eax
  802301:	8b 34 24             	mov    (%esp),%esi
  802304:	89 f2                	mov    %esi,%edx
  802306:	89 f9                	mov    %edi,%ecx
  802308:	d3 ea                	shr    %cl,%edx
  80230a:	09 c2                	or     %eax,%edx
  80230c:	89 14 24             	mov    %edx,(%esp)
  80230f:	89 f2                	mov    %esi,%edx
  802311:	89 e9                	mov    %ebp,%ecx
  802313:	d3 e2                	shl    %cl,%edx
  802315:	89 54 24 04          	mov    %edx,0x4(%esp)
  802319:	89 de                	mov    %ebx,%esi
  80231b:	89 f9                	mov    %edi,%ecx
  80231d:	d3 ee                	shr    %cl,%esi
  80231f:	89 e9                	mov    %ebp,%ecx
  802321:	d3 e3                	shl    %cl,%ebx
  802323:	8b 54 24 08          	mov    0x8(%esp),%edx
  802327:	89 d0                	mov    %edx,%eax
  802329:	89 f9                	mov    %edi,%ecx
  80232b:	d3 e8                	shr    %cl,%eax
  80232d:	09 d8                	or     %ebx,%eax
  80232f:	89 d3                	mov    %edx,%ebx
  802331:	89 e9                	mov    %ebp,%ecx
  802333:	d3 e3                	shl    %cl,%ebx
  802335:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802339:	89 f2                	mov    %esi,%edx
  80233b:	f7 34 24             	divl   (%esp)
  80233e:	89 d6                	mov    %edx,%esi
  802340:	f7 64 24 04          	mull   0x4(%esp)
  802344:	89 c3                	mov    %eax,%ebx
  802346:	89 d1                	mov    %edx,%ecx
  802348:	39 d6                	cmp    %edx,%esi
  80234a:	72 7c                	jb     8023c8 <__umoddi3+0x12c>
  80234c:	74 72                	je     8023c0 <__umoddi3+0x124>
  80234e:	8b 54 24 08          	mov    0x8(%esp),%edx
  802352:	29 da                	sub    %ebx,%edx
  802354:	19 ce                	sbb    %ecx,%esi
  802356:	89 f0                	mov    %esi,%eax
  802358:	89 f9                	mov    %edi,%ecx
  80235a:	d3 e0                	shl    %cl,%eax
  80235c:	89 e9                	mov    %ebp,%ecx
  80235e:	d3 ea                	shr    %cl,%edx
  802360:	09 d0                	or     %edx,%eax
  802362:	89 e9                	mov    %ebp,%ecx
  802364:	d3 ee                	shr    %cl,%esi
  802366:	89 f2                	mov    %esi,%edx
  802368:	83 c4 1c             	add    $0x1c,%esp
  80236b:	5b                   	pop    %ebx
  80236c:	5e                   	pop    %esi
  80236d:	5f                   	pop    %edi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    
  802370:	89 fd                	mov    %edi,%ebp
  802372:	85 ff                	test   %edi,%edi
  802374:	75 0b                	jne    802381 <__umoddi3+0xe5>
  802376:	b8 01 00 00 00       	mov    $0x1,%eax
  80237b:	31 d2                	xor    %edx,%edx
  80237d:	f7 f7                	div    %edi
  80237f:	89 c5                	mov    %eax,%ebp
  802381:	89 f0                	mov    %esi,%eax
  802383:	31 d2                	xor    %edx,%edx
  802385:	f7 f5                	div    %ebp
  802387:	89 c8                	mov    %ecx,%eax
  802389:	f7 f5                	div    %ebp
  80238b:	e9 44 ff ff ff       	jmp    8022d4 <__umoddi3+0x38>
  802390:	89 c8                	mov    %ecx,%eax
  802392:	89 f2                	mov    %esi,%edx
  802394:	83 c4 1c             	add    $0x1c,%esp
  802397:	5b                   	pop    %ebx
  802398:	5e                   	pop    %esi
  802399:	5f                   	pop    %edi
  80239a:	5d                   	pop    %ebp
  80239b:	c3                   	ret    
  80239c:	39 f0                	cmp    %esi,%eax
  80239e:	72 05                	jb     8023a5 <__umoddi3+0x109>
  8023a0:	39 0c 24             	cmp    %ecx,(%esp)
  8023a3:	77 0c                	ja     8023b1 <__umoddi3+0x115>
  8023a5:	89 f2                	mov    %esi,%edx
  8023a7:	29 f9                	sub    %edi,%ecx
  8023a9:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023b5:	83 c4 1c             	add    $0x1c,%esp
  8023b8:	5b                   	pop    %ebx
  8023b9:	5e                   	pop    %esi
  8023ba:	5f                   	pop    %edi
  8023bb:	5d                   	pop    %ebp
  8023bc:	c3                   	ret    
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8023c4:	73 88                	jae    80234e <__umoddi3+0xb2>
  8023c6:	66 90                	xchg   %ax,%ax
  8023c8:	2b 44 24 04          	sub    0x4(%esp),%eax
  8023cc:	1b 14 24             	sbb    (%esp),%edx
  8023cf:	89 d1                	mov    %edx,%ecx
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	e9 76 ff ff ff       	jmp    80234e <__umoddi3+0xb2>
