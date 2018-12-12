
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 e0 	movl   $0x8024e0,0x803004
  800042:	24 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 f4 1c 00 00       	call   801d42 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1f 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 25 11 00 00       	call   801185 <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 22 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	85 c0                	test   %eax,%eax
  80006c:	0f 85 58 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800072:	a1 04 40 80 00       	mov    0x804004,%eax
  800077:	8b 40 48             	mov    0x48(%eax),%eax
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	ff 75 90             	pushl  -0x70(%ebp)
  800080:	50                   	push   %eax
  800081:	68 0e 25 80 00       	push   $0x80250e
  800086:	e8 c4 03 00 00       	call   80044f <cprintf>
		close(p[1]);
  80008b:	83 c4 04             	add    $0x4,%esp
  80008e:	ff 75 90             	pushl  -0x70(%ebp)
  800091:	e8 59 14 00 00       	call   8014ef <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800096:	a1 04 40 80 00       	mov    0x804004,%eax
  80009b:	8b 40 48             	mov    0x48(%eax),%eax
  80009e:	83 c4 0c             	add    $0xc,%esp
  8000a1:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a4:	50                   	push   %eax
  8000a5:	68 2b 25 80 00       	push   $0x80252b
  8000aa:	e8 a0 03 00 00       	call   80044f <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000af:	83 c4 0c             	add    $0xc,%esp
  8000b2:	6a 63                	push   $0x63
  8000b4:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b7:	50                   	push   %eax
  8000b8:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bb:	e8 f0 15 00 00       	call   8016b0 <readn>
  8000c0:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	0f 88 d1 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cd:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	ff 35 00 30 80 00    	pushl  0x803000
  8000db:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000de:	50                   	push   %eax
  8000df:	e8 10 0a 00 00       	call   800af4 <strcmp>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	0f 85 c1 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 51 25 80 00       	push   $0x802551
  8000f7:	e8 53 03 00 00       	call   80044f <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000ff:	e8 1e 02 00 00       	call   800322 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	53                   	push   %ebx
  800108:	e8 b9 1d 00 00       	call   801ec6 <wait>

	binaryname = "pipewriteeof";
  80010d:	c7 05 04 30 80 00 a7 	movl   $0x8025a7,0x803004
  800114:	25 80 00 
	if ((i = pipe(p)) < 0)
  800117:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 20 1c 00 00       	call   801d42 <pipe>
  800122:	89 c6                	mov    %eax,%esi
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	85 c0                	test   %eax,%eax
  800129:	0f 88 34 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012f:	e8 51 10 00 00       	call   801185 <fork>
  800134:	89 c3                	mov    %eax,%ebx
  800136:	85 c0                	test   %eax,%eax
  800138:	0f 88 37 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  80013e:	85 c0                	test   %eax,%eax
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 9e 13 00 00       	call   8014ef <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 93 13 00 00       	call   8014ef <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 62 1d 00 00       	call   801ec6 <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 d5 25 80 00 	movl   $0x8025d5,(%esp)
  80016b:	e8 df 02 00 00       	call   80044f <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 ec 24 80 00       	push   $0x8024ec
  800180:	6a 0e                	push   $0xe
  800182:	68 f5 24 80 00       	push   $0x8024f5
  800187:	e8 b0 01 00 00       	call   80033c <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 05 25 80 00       	push   $0x802505
  800192:	6a 11                	push   $0x11
  800194:	68 f5 24 80 00       	push   $0x8024f5
  800199:	e8 9e 01 00 00       	call   80033c <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 48 25 80 00       	push   $0x802548
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 f5 24 80 00       	push   $0x8024f5
  8001ab:	e8 8c 01 00 00       	call   80033c <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 6d 25 80 00       	push   $0x80256d
  8001bd:	e8 8d 02 00 00       	call   80044f <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 35 ff ff ff       	jmp    8000ff <umain+0xcc>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 0e 25 80 00       	push   $0x80250e
  8001de:	e8 6c 02 00 00       	call   80044f <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 01 13 00 00       	call   8014ef <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 80 25 80 00       	push   $0x802580
  800202:	e8 48 02 00 00       	call   80044f <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 30 80 00    	pushl  0x803000
  800210:	e8 0f 08 00 00       	call   800a24 <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 30 80 00    	pushl  0x803000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 d0 14 00 00       	call   8016f7 <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 30 80 00    	pushl  0x803000
  800232:	e8 ed 07 00 00       	call   800a24 <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 c6                	cmp    %eax,%esi
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 a6 12 00 00       	call   8014ef <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b3 fe ff ff       	jmp    800104 <umain+0xd1>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 9d 25 80 00       	push   $0x80259d
  800257:	6a 25                	push   $0x25
  800259:	68 f5 24 80 00       	push   $0x8024f5
  80025e:	e8 d9 00 00 00       	call   80033c <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 ec 24 80 00       	push   $0x8024ec
  800269:	6a 2c                	push   $0x2c
  80026b:	68 f5 24 80 00       	push   $0x8024f5
  800270:	e8 c7 00 00 00       	call   80033c <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 05 25 80 00       	push   $0x802505
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 f5 24 80 00       	push   $0x8024f5
  800282:	e8 b5 00 00 00       	call   80033c <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 5d 12 00 00       	call   8014ef <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 b4 25 80 00       	push   $0x8025b4
  80029d:	e8 ad 01 00 00       	call   80044f <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 b6 25 80 00       	push   $0x8025b6
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 43 14 00 00       	call   8016f7 <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 b8 25 80 00       	push   $0x8025b8
  8002c4:	e8 86 01 00 00       	call   80044f <cprintf>
		exit();
  8002c9:	e8 54 00 00 00       	call   800322 <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e1:	e8 07 0b 00 00       	call   800ded <sys_getenvid>
  8002e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002eb:	89 c2                	mov    %eax,%edx
  8002ed:	c1 e2 05             	shl    $0x5,%edx
  8002f0:	29 c2                	sub    %eax,%edx
  8002f2:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8002f9:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fe:	85 db                	test   %ebx,%ebx
  800300:	7e 07                	jle    800309 <libmain+0x33>
		binaryname = argv[0];
  800302:	8b 06                	mov    (%esi),%eax
  800304:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	56                   	push   %esi
  80030d:	53                   	push   %ebx
  80030e:	e8 20 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800313:	e8 0a 00 00 00       	call   800322 <exit>
}
  800318:	83 c4 10             	add    $0x10,%esp
  80031b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80031e:	5b                   	pop    %ebx
  80031f:	5e                   	pop    %esi
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800328:	e8 ed 11 00 00       	call   80151a <close_all>
	sys_env_destroy(0);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	6a 00                	push   $0x0
  800332:	e8 75 0a 00 00       	call   800dac <sys_env_destroy>
}
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	c9                   	leave  
  80033b:	c3                   	ret    

0080033c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	57                   	push   %edi
  800340:	56                   	push   %esi
  800341:	53                   	push   %ebx
  800342:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800348:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80034b:	8b 1d 04 30 80 00    	mov    0x803004,%ebx
  800351:	e8 97 0a 00 00       	call   800ded <sys_getenvid>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	53                   	push   %ebx
  800360:	50                   	push   %eax
  800361:	68 38 26 80 00       	push   $0x802638
  800366:	68 00 01 00 00       	push   $0x100
  80036b:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800371:	56                   	push   %esi
  800372:	e8 93 06 00 00       	call   800a0a <snprintf>
  800377:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800379:	83 c4 20             	add    $0x20,%esp
  80037c:	57                   	push   %edi
  80037d:	ff 75 10             	pushl  0x10(%ebp)
  800380:	bf 00 01 00 00       	mov    $0x100,%edi
  800385:	89 f8                	mov    %edi,%eax
  800387:	29 d8                	sub    %ebx,%eax
  800389:	50                   	push   %eax
  80038a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80038d:	50                   	push   %eax
  80038e:	e8 22 06 00 00       	call   8009b5 <vsnprintf>
  800393:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800395:	83 c4 0c             	add    $0xc,%esp
  800398:	68 29 25 80 00       	push   $0x802529
  80039d:	29 df                	sub    %ebx,%edi
  80039f:	57                   	push   %edi
  8003a0:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8003a3:	50                   	push   %eax
  8003a4:	e8 61 06 00 00       	call   800a0a <snprintf>
	sys_cputs(buf, r);
  8003a9:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8003ac:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8003ae:	53                   	push   %ebx
  8003af:	56                   	push   %esi
  8003b0:	e8 ba 09 00 00       	call   800d6f <sys_cputs>
  8003b5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003b8:	cc                   	int3   
  8003b9:	eb fd                	jmp    8003b8 <_panic+0x7c>

008003bb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	53                   	push   %ebx
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003c5:	8b 13                	mov    (%ebx),%edx
  8003c7:	8d 42 01             	lea    0x1(%edx),%eax
  8003ca:	89 03                	mov    %eax,(%ebx)
  8003cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003cf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003d8:	74 08                	je     8003e2 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003da:	ff 43 04             	incl   0x4(%ebx)
}
  8003dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	68 ff 00 00 00       	push   $0xff
  8003ea:	8d 43 08             	lea    0x8(%ebx),%eax
  8003ed:	50                   	push   %eax
  8003ee:	e8 7c 09 00 00       	call   800d6f <sys_cputs>
		b->idx = 0;
  8003f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	eb dc                	jmp    8003da <putch+0x1f>

008003fe <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800407:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80040e:	00 00 00 
	b.cnt = 0;
  800411:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800418:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80041b:	ff 75 0c             	pushl  0xc(%ebp)
  80041e:	ff 75 08             	pushl  0x8(%ebp)
  800421:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800427:	50                   	push   %eax
  800428:	68 bb 03 80 00       	push   $0x8003bb
  80042d:	e8 17 01 00 00       	call   800549 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800432:	83 c4 08             	add    $0x8,%esp
  800435:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80043b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800441:	50                   	push   %eax
  800442:	e8 28 09 00 00       	call   800d6f <sys_cputs>

	return b.cnt;
}
  800447:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    

0080044f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800455:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800458:	50                   	push   %eax
  800459:	ff 75 08             	pushl  0x8(%ebp)
  80045c:	e8 9d ff ff ff       	call   8003fe <vcprintf>
	va_end(ap);

	return cnt;
}
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	57                   	push   %edi
  800467:	56                   	push   %esi
  800468:	53                   	push   %ebx
  800469:	83 ec 1c             	sub    $0x1c,%esp
  80046c:	89 c7                	mov    %eax,%edi
  80046e:	89 d6                	mov    %edx,%esi
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	8b 55 0c             	mov    0xc(%ebp),%edx
  800476:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800479:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80047c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80047f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800484:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800487:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80048a:	39 d3                	cmp    %edx,%ebx
  80048c:	72 05                	jb     800493 <printnum+0x30>
  80048e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800491:	77 78                	ja     80050b <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	ff 75 18             	pushl  0x18(%ebp)
  800499:	8b 45 14             	mov    0x14(%ebp),%eax
  80049c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80049f:	53                   	push   %ebx
  8004a0:	ff 75 10             	pushl  0x10(%ebp)
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8004af:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b2:	e8 c5 1d 00 00       	call   80227c <__udivdi3>
  8004b7:	83 c4 18             	add    $0x18,%esp
  8004ba:	52                   	push   %edx
  8004bb:	50                   	push   %eax
  8004bc:	89 f2                	mov    %esi,%edx
  8004be:	89 f8                	mov    %edi,%eax
  8004c0:	e8 9e ff ff ff       	call   800463 <printnum>
  8004c5:	83 c4 20             	add    $0x20,%esp
  8004c8:	eb 11                	jmp    8004db <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	56                   	push   %esi
  8004ce:	ff 75 18             	pushl  0x18(%ebp)
  8004d1:	ff d7                	call   *%edi
  8004d3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004d6:	4b                   	dec    %ebx
  8004d7:	85 db                	test   %ebx,%ebx
  8004d9:	7f ef                	jg     8004ca <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	56                   	push   %esi
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8004eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ee:	e8 99 1e 00 00       	call   80238c <__umoddi3>
  8004f3:	83 c4 14             	add    $0x14,%esp
  8004f6:	0f be 80 5b 26 80 00 	movsbl 0x80265b(%eax),%eax
  8004fd:	50                   	push   %eax
  8004fe:	ff d7                	call   *%edi
}
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800506:	5b                   	pop    %ebx
  800507:	5e                   	pop    %esi
  800508:	5f                   	pop    %edi
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    
  80050b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80050e:	eb c6                	jmp    8004d6 <printnum+0x73>

00800510 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800516:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800519:	8b 10                	mov    (%eax),%edx
  80051b:	3b 50 04             	cmp    0x4(%eax),%edx
  80051e:	73 0a                	jae    80052a <sprintputch+0x1a>
		*b->buf++ = ch;
  800520:	8d 4a 01             	lea    0x1(%edx),%ecx
  800523:	89 08                	mov    %ecx,(%eax)
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	88 02                	mov    %al,(%edx)
}
  80052a:	5d                   	pop    %ebp
  80052b:	c3                   	ret    

0080052c <printfmt>:
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800532:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800535:	50                   	push   %eax
  800536:	ff 75 10             	pushl  0x10(%ebp)
  800539:	ff 75 0c             	pushl  0xc(%ebp)
  80053c:	ff 75 08             	pushl  0x8(%ebp)
  80053f:	e8 05 00 00 00       	call   800549 <vprintfmt>
}
  800544:	83 c4 10             	add    $0x10,%esp
  800547:	c9                   	leave  
  800548:	c3                   	ret    

00800549 <vprintfmt>:
{
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	57                   	push   %edi
  80054d:	56                   	push   %esi
  80054e:	53                   	push   %ebx
  80054f:	83 ec 2c             	sub    $0x2c,%esp
  800552:	8b 75 08             	mov    0x8(%ebp),%esi
  800555:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800558:	8b 7d 10             	mov    0x10(%ebp),%edi
  80055b:	e9 ae 03 00 00       	jmp    80090e <vprintfmt+0x3c5>
  800560:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800564:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80056b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800572:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800579:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80057e:	8d 47 01             	lea    0x1(%edi),%eax
  800581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800584:	8a 17                	mov    (%edi),%dl
  800586:	8d 42 dd             	lea    -0x23(%edx),%eax
  800589:	3c 55                	cmp    $0x55,%al
  80058b:	0f 87 fe 03 00 00    	ja     80098f <vprintfmt+0x446>
  800591:	0f b6 c0             	movzbl %al,%eax
  800594:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80059e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8005a2:	eb da                	jmp    80057e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8005a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005a7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8005ab:	eb d1                	jmp    80057e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8005ad:	0f b6 d2             	movzbl %dl,%edx
  8005b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005be:	01 c0                	add    %eax,%eax
  8005c0:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8005c4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005c7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ca:	83 f9 09             	cmp    $0x9,%ecx
  8005cd:	77 52                	ja     800621 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8005cf:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8005d0:	eb e9                	jmp    8005bb <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8d 40 04             	lea    0x4(%eax),%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ea:	79 92                	jns    80057e <vprintfmt+0x35>
				width = precision, precision = -1;
  8005ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005f9:	eb 83                	jmp    80057e <vprintfmt+0x35>
  8005fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ff:	78 08                	js     800609 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800601:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800604:	e9 75 ff ff ff       	jmp    80057e <vprintfmt+0x35>
  800609:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800610:	eb ef                	jmp    800601 <vprintfmt+0xb8>
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800615:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80061c:	e9 5d ff ff ff       	jmp    80057e <vprintfmt+0x35>
  800621:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800624:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800627:	eb bd                	jmp    8005e6 <vprintfmt+0x9d>
			lflag++;
  800629:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80062a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80062d:	e9 4c ff ff ff       	jmp    80057e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 78 04             	lea    0x4(%eax),%edi
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	ff 30                	pushl  (%eax)
  80063e:	ff d6                	call   *%esi
			break;
  800640:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800643:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800646:	e9 c0 02 00 00       	jmp    80090b <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8d 78 04             	lea    0x4(%eax),%edi
  800651:	8b 00                	mov    (%eax),%eax
  800653:	85 c0                	test   %eax,%eax
  800655:	78 2a                	js     800681 <vprintfmt+0x138>
  800657:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800659:	83 f8 0f             	cmp    $0xf,%eax
  80065c:	7f 27                	jg     800685 <vprintfmt+0x13c>
  80065e:	8b 04 85 00 29 80 00 	mov    0x802900(,%eax,4),%eax
  800665:	85 c0                	test   %eax,%eax
  800667:	74 1c                	je     800685 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800669:	50                   	push   %eax
  80066a:	68 28 2a 80 00       	push   $0x802a28
  80066f:	53                   	push   %ebx
  800670:	56                   	push   %esi
  800671:	e8 b6 fe ff ff       	call   80052c <printfmt>
  800676:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800679:	89 7d 14             	mov    %edi,0x14(%ebp)
  80067c:	e9 8a 02 00 00       	jmp    80090b <vprintfmt+0x3c2>
  800681:	f7 d8                	neg    %eax
  800683:	eb d2                	jmp    800657 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800685:	52                   	push   %edx
  800686:	68 73 26 80 00       	push   $0x802673
  80068b:	53                   	push   %ebx
  80068c:	56                   	push   %esi
  80068d:	e8 9a fe ff ff       	call   80052c <printfmt>
  800692:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800695:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800698:	e9 6e 02 00 00       	jmp    80090b <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	83 c0 04             	add    $0x4,%eax
  8006a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 38                	mov    (%eax),%edi
  8006ab:	85 ff                	test   %edi,%edi
  8006ad:	74 39                	je     8006e8 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8006af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b3:	0f 8e a9 00 00 00    	jle    800762 <vprintfmt+0x219>
  8006b9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006bd:	0f 84 a7 00 00 00    	je     80076a <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 d0             	pushl  -0x30(%ebp)
  8006c9:	57                   	push   %edi
  8006ca:	e8 6b 03 00 00       	call   800a3a <strnlen>
  8006cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006d2:	29 c1                	sub    %eax,%ecx
  8006d4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006d7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006da:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006e4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e6:	eb 14                	jmp    8006fc <vprintfmt+0x1b3>
				p = "(null)";
  8006e8:	bf 6c 26 80 00       	mov    $0x80266c,%edi
  8006ed:	eb c0                	jmp    8006af <vprintfmt+0x166>
					putch(padc, putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	53                   	push   %ebx
  8006f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f8:	4f                   	dec    %edi
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	85 ff                	test   %edi,%edi
  8006fe:	7f ef                	jg     8006ef <vprintfmt+0x1a6>
  800700:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800703:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800706:	89 c8                	mov    %ecx,%eax
  800708:	85 c9                	test   %ecx,%ecx
  80070a:	78 10                	js     80071c <vprintfmt+0x1d3>
  80070c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80070f:	29 c1                	sub    %eax,%ecx
  800711:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800714:	89 75 08             	mov    %esi,0x8(%ebp)
  800717:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80071a:	eb 15                	jmp    800731 <vprintfmt+0x1e8>
  80071c:	b8 00 00 00 00       	mov    $0x0,%eax
  800721:	eb e9                	jmp    80070c <vprintfmt+0x1c3>
					putch(ch, putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	52                   	push   %edx
  800728:	ff 55 08             	call   *0x8(%ebp)
  80072b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072e:	ff 4d e0             	decl   -0x20(%ebp)
  800731:	47                   	inc    %edi
  800732:	8a 47 ff             	mov    -0x1(%edi),%al
  800735:	0f be d0             	movsbl %al,%edx
  800738:	85 d2                	test   %edx,%edx
  80073a:	74 59                	je     800795 <vprintfmt+0x24c>
  80073c:	85 f6                	test   %esi,%esi
  80073e:	78 03                	js     800743 <vprintfmt+0x1fa>
  800740:	4e                   	dec    %esi
  800741:	78 2f                	js     800772 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800743:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800747:	74 da                	je     800723 <vprintfmt+0x1da>
  800749:	0f be c0             	movsbl %al,%eax
  80074c:	83 e8 20             	sub    $0x20,%eax
  80074f:	83 f8 5e             	cmp    $0x5e,%eax
  800752:	76 cf                	jbe    800723 <vprintfmt+0x1da>
					putch('?', putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	53                   	push   %ebx
  800758:	6a 3f                	push   $0x3f
  80075a:	ff 55 08             	call   *0x8(%ebp)
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	eb cc                	jmp    80072e <vprintfmt+0x1e5>
  800762:	89 75 08             	mov    %esi,0x8(%ebp)
  800765:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800768:	eb c7                	jmp    800731 <vprintfmt+0x1e8>
  80076a:	89 75 08             	mov    %esi,0x8(%ebp)
  80076d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800770:	eb bf                	jmp    800731 <vprintfmt+0x1e8>
  800772:	8b 75 08             	mov    0x8(%ebp),%esi
  800775:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800778:	eb 0c                	jmp    800786 <vprintfmt+0x23d>
				putch(' ', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	6a 20                	push   $0x20
  800780:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800782:	4f                   	dec    %edi
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	85 ff                	test   %edi,%edi
  800788:	7f f0                	jg     80077a <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80078a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
  800790:	e9 76 01 00 00       	jmp    80090b <vprintfmt+0x3c2>
  800795:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800798:	8b 75 08             	mov    0x8(%ebp),%esi
  80079b:	eb e9                	jmp    800786 <vprintfmt+0x23d>
	if (lflag >= 2)
  80079d:	83 f9 01             	cmp    $0x1,%ecx
  8007a0:	7f 1f                	jg     8007c1 <vprintfmt+0x278>
	else if (lflag)
  8007a2:	85 c9                	test   %ecx,%ecx
  8007a4:	75 48                	jne    8007ee <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ae:	89 c1                	mov    %eax,%ecx
  8007b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8007b3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 40 04             	lea    0x4(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bf:	eb 17                	jmp    8007d8 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8b 50 04             	mov    0x4(%eax),%edx
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 40 08             	lea    0x8(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007db:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8007de:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007e2:	78 25                	js     800809 <vprintfmt+0x2c0>
			base = 10;
  8007e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e9:	e9 03 01 00 00       	jmp    8008f1 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 c1                	mov    %eax,%ecx
  8007f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8007fb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
  800807:	eb cf                	jmp    8007d8 <vprintfmt+0x28f>
				putch('-', putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	53                   	push   %ebx
  80080d:	6a 2d                	push   $0x2d
  80080f:	ff d6                	call   *%esi
				num = -(long long) num;
  800811:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800814:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800817:	f7 da                	neg    %edx
  800819:	83 d1 00             	adc    $0x0,%ecx
  80081c:	f7 d9                	neg    %ecx
  80081e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800821:	b8 0a 00 00 00       	mov    $0xa,%eax
  800826:	e9 c6 00 00 00       	jmp    8008f1 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80082b:	83 f9 01             	cmp    $0x1,%ecx
  80082e:	7f 1e                	jg     80084e <vprintfmt+0x305>
	else if (lflag)
  800830:	85 c9                	test   %ecx,%ecx
  800832:	75 32                	jne    800866 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 10                	mov    (%eax),%edx
  800839:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083e:	8d 40 04             	lea    0x4(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800844:	b8 0a 00 00 00       	mov    $0xa,%eax
  800849:	e9 a3 00 00 00       	jmp    8008f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 10                	mov    (%eax),%edx
  800853:	8b 48 04             	mov    0x4(%eax),%ecx
  800856:	8d 40 08             	lea    0x8(%eax),%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80085c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800861:	e9 8b 00 00 00       	jmp    8008f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 10                	mov    (%eax),%edx
  80086b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800870:	8d 40 04             	lea    0x4(%eax),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800876:	b8 0a 00 00 00       	mov    $0xa,%eax
  80087b:	eb 74                	jmp    8008f1 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80087d:	83 f9 01             	cmp    $0x1,%ecx
  800880:	7f 1b                	jg     80089d <vprintfmt+0x354>
	else if (lflag)
  800882:	85 c9                	test   %ecx,%ecx
  800884:	75 2c                	jne    8008b2 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	8b 10                	mov    (%eax),%edx
  80088b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800890:	8d 40 04             	lea    0x4(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800896:	b8 08 00 00 00       	mov    $0x8,%eax
  80089b:	eb 54                	jmp    8008f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8b 10                	mov    (%eax),%edx
  8008a2:	8b 48 04             	mov    0x4(%eax),%ecx
  8008a5:	8d 40 08             	lea    0x8(%eax),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b0:	eb 3f                	jmp    8008f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8b 10                	mov    (%eax),%edx
  8008b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008bc:	8d 40 04             	lea    0x4(%eax),%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8008c7:	eb 28                	jmp    8008f1 <vprintfmt+0x3a8>
			putch('0', putdat);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	53                   	push   %ebx
  8008cd:	6a 30                	push   $0x30
  8008cf:	ff d6                	call   *%esi
			putch('x', putdat);
  8008d1:	83 c4 08             	add    $0x8,%esp
  8008d4:	53                   	push   %ebx
  8008d5:	6a 78                	push   $0x78
  8008d7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8b 10                	mov    (%eax),%edx
  8008de:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008e3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008e6:	8d 40 04             	lea    0x4(%eax),%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ec:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008f1:	83 ec 0c             	sub    $0xc,%esp
  8008f4:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008f8:	57                   	push   %edi
  8008f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8008fc:	50                   	push   %eax
  8008fd:	51                   	push   %ecx
  8008fe:	52                   	push   %edx
  8008ff:	89 da                	mov    %ebx,%edx
  800901:	89 f0                	mov    %esi,%eax
  800903:	e8 5b fb ff ff       	call   800463 <printnum>
			break;
  800908:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80090b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090e:	47                   	inc    %edi
  80090f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800913:	83 f8 25             	cmp    $0x25,%eax
  800916:	0f 84 44 fc ff ff    	je     800560 <vprintfmt+0x17>
			if (ch == '\0')
  80091c:	85 c0                	test   %eax,%eax
  80091e:	0f 84 89 00 00 00    	je     8009ad <vprintfmt+0x464>
			putch(ch, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	53                   	push   %ebx
  800928:	50                   	push   %eax
  800929:	ff d6                	call   *%esi
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	eb de                	jmp    80090e <vprintfmt+0x3c5>
	if (lflag >= 2)
  800930:	83 f9 01             	cmp    $0x1,%ecx
  800933:	7f 1b                	jg     800950 <vprintfmt+0x407>
	else if (lflag)
  800935:	85 c9                	test   %ecx,%ecx
  800937:	75 2c                	jne    800965 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8b 10                	mov    (%eax),%edx
  80093e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800943:	8d 40 04             	lea    0x4(%eax),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800949:	b8 10 00 00 00       	mov    $0x10,%eax
  80094e:	eb a1                	jmp    8008f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8b 10                	mov    (%eax),%edx
  800955:	8b 48 04             	mov    0x4(%eax),%ecx
  800958:	8d 40 08             	lea    0x8(%eax),%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095e:	b8 10 00 00 00       	mov    $0x10,%eax
  800963:	eb 8c                	jmp    8008f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	8b 10                	mov    (%eax),%edx
  80096a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80096f:	8d 40 04             	lea    0x4(%eax),%eax
  800972:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800975:	b8 10 00 00 00       	mov    $0x10,%eax
  80097a:	e9 72 ff ff ff       	jmp    8008f1 <vprintfmt+0x3a8>
			putch(ch, putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	6a 25                	push   $0x25
  800985:	ff d6                	call   *%esi
			break;
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	e9 7c ff ff ff       	jmp    80090b <vprintfmt+0x3c2>
			putch('%', putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	53                   	push   %ebx
  800993:	6a 25                	push   $0x25
  800995:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800997:	83 c4 10             	add    $0x10,%esp
  80099a:	89 f8                	mov    %edi,%eax
  80099c:	eb 01                	jmp    80099f <vprintfmt+0x456>
  80099e:	48                   	dec    %eax
  80099f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009a3:	75 f9                	jne    80099e <vprintfmt+0x455>
  8009a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a8:	e9 5e ff ff ff       	jmp    80090b <vprintfmt+0x3c2>
}
  8009ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5f                   	pop    %edi
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	83 ec 18             	sub    $0x18,%esp
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d2:	85 c0                	test   %eax,%eax
  8009d4:	74 26                	je     8009fc <vsnprintf+0x47>
  8009d6:	85 d2                	test   %edx,%edx
  8009d8:	7e 29                	jle    800a03 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009da:	ff 75 14             	pushl  0x14(%ebp)
  8009dd:	ff 75 10             	pushl  0x10(%ebp)
  8009e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e3:	50                   	push   %eax
  8009e4:	68 10 05 80 00       	push   $0x800510
  8009e9:	e8 5b fb ff ff       	call   800549 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    
		return -E_INVAL;
  8009fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a01:	eb f7                	jmp    8009fa <vsnprintf+0x45>
  800a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a08:	eb f0                	jmp    8009fa <vsnprintf+0x45>

00800a0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a13:	50                   	push   %eax
  800a14:	ff 75 10             	pushl  0x10(%ebp)
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	ff 75 08             	pushl  0x8(%ebp)
  800a1d:	e8 93 ff ff ff       	call   8009b5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2f:	eb 01                	jmp    800a32 <strlen+0xe>
		n++;
  800a31:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800a32:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a36:	75 f9                	jne    800a31 <strlen+0xd>
	return n;
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a43:	b8 00 00 00 00       	mov    $0x0,%eax
  800a48:	eb 01                	jmp    800a4b <strnlen+0x11>
		n++;
  800a4a:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4b:	39 d0                	cmp    %edx,%eax
  800a4d:	74 06                	je     800a55 <strnlen+0x1b>
  800a4f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a53:	75 f5                	jne    800a4a <strnlen+0x10>
	return n;
}
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	53                   	push   %ebx
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	42                   	inc    %edx
  800a64:	41                   	inc    %ecx
  800a65:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800a68:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a6b:	84 db                	test   %bl,%bl
  800a6d:	75 f4                	jne    800a63 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a6f:	5b                   	pop    %ebx
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	53                   	push   %ebx
  800a76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a79:	53                   	push   %ebx
  800a7a:	e8 a5 ff ff ff       	call   800a24 <strlen>
  800a7f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	01 d8                	add    %ebx,%eax
  800a87:	50                   	push   %eax
  800a88:	e8 ca ff ff ff       	call   800a57 <strcpy>
	return dst;
}
  800a8d:	89 d8                	mov    %ebx,%eax
  800a8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a92:	c9                   	leave  
  800a93:	c3                   	ret    

00800a94 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9f:	89 f3                	mov    %esi,%ebx
  800aa1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa4:	89 f2                	mov    %esi,%edx
  800aa6:	eb 0c                	jmp    800ab4 <strncpy+0x20>
		*dst++ = *src;
  800aa8:	42                   	inc    %edx
  800aa9:	8a 01                	mov    (%ecx),%al
  800aab:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aae:	80 39 01             	cmpb   $0x1,(%ecx)
  800ab1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ab4:	39 da                	cmp    %ebx,%edx
  800ab6:	75 f0                	jne    800aa8 <strncpy+0x14>
	}
	return ret;
}
  800ab8:	89 f0                	mov    %esi,%eax
  800aba:	5b                   	pop    %ebx
  800abb:	5e                   	pop    %esi
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	56                   	push   %esi
  800ac2:	53                   	push   %ebx
  800ac3:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 20                	je     800af0 <strlcpy+0x32>
  800ad0:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800ad4:	89 f0                	mov    %esi,%eax
  800ad6:	eb 05                	jmp    800add <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad8:	40                   	inc    %eax
  800ad9:	42                   	inc    %edx
  800ada:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800add:	39 d8                	cmp    %ebx,%eax
  800adf:	74 06                	je     800ae7 <strlcpy+0x29>
  800ae1:	8a 0a                	mov    (%edx),%cl
  800ae3:	84 c9                	test   %cl,%cl
  800ae5:	75 f1                	jne    800ad8 <strlcpy+0x1a>
		*dst = '\0';
  800ae7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aea:	29 f0                	sub    %esi,%eax
}
  800aec:	5b                   	pop    %ebx
  800aed:	5e                   	pop    %esi
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    
  800af0:	89 f0                	mov    %esi,%eax
  800af2:	eb f6                	jmp    800aea <strlcpy+0x2c>

00800af4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afd:	eb 02                	jmp    800b01 <strcmp+0xd>
		p++, q++;
  800aff:	41                   	inc    %ecx
  800b00:	42                   	inc    %edx
	while (*p && *p == *q)
  800b01:	8a 01                	mov    (%ecx),%al
  800b03:	84 c0                	test   %al,%al
  800b05:	74 04                	je     800b0b <strcmp+0x17>
  800b07:	3a 02                	cmp    (%edx),%al
  800b09:	74 f4                	je     800aff <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0b:	0f b6 c0             	movzbl %al,%eax
  800b0e:	0f b6 12             	movzbl (%edx),%edx
  800b11:	29 d0                	sub    %edx,%eax
}
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	53                   	push   %ebx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1f:	89 c3                	mov    %eax,%ebx
  800b21:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b24:	eb 02                	jmp    800b28 <strncmp+0x13>
		n--, p++, q++;
  800b26:	40                   	inc    %eax
  800b27:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800b28:	39 d8                	cmp    %ebx,%eax
  800b2a:	74 15                	je     800b41 <strncmp+0x2c>
  800b2c:	8a 08                	mov    (%eax),%cl
  800b2e:	84 c9                	test   %cl,%cl
  800b30:	74 04                	je     800b36 <strncmp+0x21>
  800b32:	3a 0a                	cmp    (%edx),%cl
  800b34:	74 f0                	je     800b26 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b36:	0f b6 00             	movzbl (%eax),%eax
  800b39:	0f b6 12             	movzbl (%edx),%edx
  800b3c:	29 d0                	sub    %edx,%eax
}
  800b3e:	5b                   	pop    %ebx
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    
		return 0;
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
  800b46:	eb f6                	jmp    800b3e <strncmp+0x29>

00800b48 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800b51:	8a 10                	mov    (%eax),%dl
  800b53:	84 d2                	test   %dl,%dl
  800b55:	74 07                	je     800b5e <strchr+0x16>
		if (*s == c)
  800b57:	38 ca                	cmp    %cl,%dl
  800b59:	74 08                	je     800b63 <strchr+0x1b>
	for (; *s; s++)
  800b5b:	40                   	inc    %eax
  800b5c:	eb f3                	jmp    800b51 <strchr+0x9>
			return (char *) s;
	return 0;
  800b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800b6e:	8a 10                	mov    (%eax),%dl
  800b70:	84 d2                	test   %dl,%dl
  800b72:	74 07                	je     800b7b <strfind+0x16>
		if (*s == c)
  800b74:	38 ca                	cmp    %cl,%dl
  800b76:	74 03                	je     800b7b <strfind+0x16>
	for (; *s; s++)
  800b78:	40                   	inc    %eax
  800b79:	eb f3                	jmp    800b6e <strfind+0x9>
			break;
	return (char *) s;
}
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	57                   	push   %edi
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
  800b83:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b89:	85 c9                	test   %ecx,%ecx
  800b8b:	74 13                	je     800ba0 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b8d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b93:	75 05                	jne    800b9a <memset+0x1d>
  800b95:	f6 c1 03             	test   $0x3,%cl
  800b98:	74 0d                	je     800ba7 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	fc                   	cld    
  800b9e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ba0:	89 f8                	mov    %edi,%eax
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5f                   	pop    %edi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    
		c &= 0xFF;
  800ba7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bab:	89 d3                	mov    %edx,%ebx
  800bad:	c1 e3 08             	shl    $0x8,%ebx
  800bb0:	89 d0                	mov    %edx,%eax
  800bb2:	c1 e0 18             	shl    $0x18,%eax
  800bb5:	89 d6                	mov    %edx,%esi
  800bb7:	c1 e6 10             	shl    $0x10,%esi
  800bba:	09 f0                	or     %esi,%eax
  800bbc:	09 c2                	or     %eax,%edx
  800bbe:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bc0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc3:	89 d0                	mov    %edx,%eax
  800bc5:	fc                   	cld    
  800bc6:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc8:	eb d6                	jmp    800ba0 <memset+0x23>

00800bca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd8:	39 c6                	cmp    %eax,%esi
  800bda:	73 33                	jae    800c0f <memmove+0x45>
  800bdc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bdf:	39 d0                	cmp    %edx,%eax
  800be1:	73 2c                	jae    800c0f <memmove+0x45>
		s += n;
		d += n;
  800be3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	09 fe                	or     %edi,%esi
  800bea:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf0:	75 13                	jne    800c05 <memmove+0x3b>
  800bf2:	f6 c1 03             	test   $0x3,%cl
  800bf5:	75 0e                	jne    800c05 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf7:	83 ef 04             	sub    $0x4,%edi
  800bfa:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bfd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c00:	fd                   	std    
  800c01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c03:	eb 07                	jmp    800c0c <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c05:	4f                   	dec    %edi
  800c06:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c09:	fd                   	std    
  800c0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c0c:	fc                   	cld    
  800c0d:	eb 13                	jmp    800c22 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0f:	89 f2                	mov    %esi,%edx
  800c11:	09 c2                	or     %eax,%edx
  800c13:	f6 c2 03             	test   $0x3,%dl
  800c16:	75 05                	jne    800c1d <memmove+0x53>
  800c18:	f6 c1 03             	test   $0x3,%cl
  800c1b:	74 09                	je     800c26 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c1d:	89 c7                	mov    %eax,%edi
  800c1f:	fc                   	cld    
  800c20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	fc                   	cld    
  800c2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2e:	eb f2                	jmp    800c22 <memmove+0x58>

00800c30 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c33:	ff 75 10             	pushl  0x10(%ebp)
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	ff 75 08             	pushl  0x8(%ebp)
  800c3c:	e8 89 ff ff ff       	call   800bca <memmove>
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 c6                	mov    %eax,%esi
  800c4d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800c53:	39 f0                	cmp    %esi,%eax
  800c55:	74 16                	je     800c6d <memcmp+0x2a>
		if (*s1 != *s2)
  800c57:	8a 08                	mov    (%eax),%cl
  800c59:	8a 1a                	mov    (%edx),%bl
  800c5b:	38 d9                	cmp    %bl,%cl
  800c5d:	75 04                	jne    800c63 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c5f:	40                   	inc    %eax
  800c60:	42                   	inc    %edx
  800c61:	eb f0                	jmp    800c53 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c63:	0f b6 c1             	movzbl %cl,%eax
  800c66:	0f b6 db             	movzbl %bl,%ebx
  800c69:	29 d8                	sub    %ebx,%eax
  800c6b:	eb 05                	jmp    800c72 <memcmp+0x2f>
	}

	return 0;
  800c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c7f:	89 c2                	mov    %eax,%edx
  800c81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c84:	39 d0                	cmp    %edx,%eax
  800c86:	73 07                	jae    800c8f <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c88:	38 08                	cmp    %cl,(%eax)
  800c8a:	74 03                	je     800c8f <memfind+0x19>
	for (; s < ends; s++)
  800c8c:	40                   	inc    %eax
  800c8d:	eb f5                	jmp    800c84 <memfind+0xe>
			break;
	return (void *) s;
}
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c9a:	eb 01                	jmp    800c9d <strtol+0xc>
		s++;
  800c9c:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800c9d:	8a 01                	mov    (%ecx),%al
  800c9f:	3c 20                	cmp    $0x20,%al
  800ca1:	74 f9                	je     800c9c <strtol+0xb>
  800ca3:	3c 09                	cmp    $0x9,%al
  800ca5:	74 f5                	je     800c9c <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800ca7:	3c 2b                	cmp    $0x2b,%al
  800ca9:	74 2b                	je     800cd6 <strtol+0x45>
		s++;
	else if (*s == '-')
  800cab:	3c 2d                	cmp    $0x2d,%al
  800cad:	74 2f                	je     800cde <strtol+0x4d>
	int neg = 0;
  800caf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb4:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800cbb:	75 12                	jne    800ccf <strtol+0x3e>
  800cbd:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc0:	74 24                	je     800ce6 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc6:	75 07                	jne    800ccf <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd4:	eb 4e                	jmp    800d24 <strtol+0x93>
		s++;
  800cd6:	41                   	inc    %ecx
	int neg = 0;
  800cd7:	bf 00 00 00 00       	mov    $0x0,%edi
  800cdc:	eb d6                	jmp    800cb4 <strtol+0x23>
		s++, neg = 1;
  800cde:	41                   	inc    %ecx
  800cdf:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce4:	eb ce                	jmp    800cb4 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cea:	74 10                	je     800cfc <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800cec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf0:	75 dd                	jne    800ccf <strtol+0x3e>
		s++, base = 8;
  800cf2:	41                   	inc    %ecx
  800cf3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cfa:	eb d3                	jmp    800ccf <strtol+0x3e>
		s += 2, base = 16;
  800cfc:	83 c1 02             	add    $0x2,%ecx
  800cff:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d06:	eb c7                	jmp    800ccf <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d08:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d0b:	89 f3                	mov    %esi,%ebx
  800d0d:	80 fb 19             	cmp    $0x19,%bl
  800d10:	77 24                	ja     800d36 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800d12:	0f be d2             	movsbl %dl,%edx
  800d15:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d18:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d1b:	7d 2b                	jge    800d48 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800d1d:	41                   	inc    %ecx
  800d1e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d22:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d24:	8a 11                	mov    (%ecx),%dl
  800d26:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800d29:	80 fb 09             	cmp    $0x9,%bl
  800d2c:	77 da                	ja     800d08 <strtol+0x77>
			dig = *s - '0';
  800d2e:	0f be d2             	movsbl %dl,%edx
  800d31:	83 ea 30             	sub    $0x30,%edx
  800d34:	eb e2                	jmp    800d18 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800d36:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d39:	89 f3                	mov    %esi,%ebx
  800d3b:	80 fb 19             	cmp    $0x19,%bl
  800d3e:	77 08                	ja     800d48 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800d40:	0f be d2             	movsbl %dl,%edx
  800d43:	83 ea 37             	sub    $0x37,%edx
  800d46:	eb d0                	jmp    800d18 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4c:	74 05                	je     800d53 <strtol+0xc2>
		*endptr = (char *) s;
  800d4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d51:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d53:	85 ff                	test   %edi,%edi
  800d55:	74 02                	je     800d59 <strtol+0xc8>
  800d57:	f7 d8                	neg    %eax
}
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <atoi>:

int
atoi(const char *s)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800d61:	6a 0a                	push   $0xa
  800d63:	6a 00                	push   $0x0
  800d65:	ff 75 08             	pushl  0x8(%ebp)
  800d68:	e8 24 ff ff ff       	call   800c91 <strtol>
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d75:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d80:	89 c3                	mov    %eax,%ebx
  800d82:	89 c7                	mov    %eax,%edi
  800d84:	89 c6                	mov    %eax,%esi
  800d86:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_cgetc>:

int
sys_cgetc(void)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d93:	ba 00 00 00 00       	mov    $0x0,%edx
  800d98:	b8 01 00 00 00       	mov    $0x1,%eax
  800d9d:	89 d1                	mov    %edx,%ecx
  800d9f:	89 d3                	mov    %edx,%ebx
  800da1:	89 d7                	mov    %edx,%edi
  800da3:	89 d6                	mov    %edx,%esi
  800da5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dba:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc2:	89 cb                	mov    %ecx,%ebx
  800dc4:	89 cf                	mov    %ecx,%edi
  800dc6:	89 ce                	mov    %ecx,%esi
  800dc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	7f 08                	jg     800dd6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd6:	83 ec 0c             	sub    $0xc,%esp
  800dd9:	50                   	push   %eax
  800dda:	6a 03                	push   $0x3
  800ddc:	68 5f 29 80 00       	push   $0x80295f
  800de1:	6a 23                	push   $0x23
  800de3:	68 7c 29 80 00       	push   $0x80297c
  800de8:	e8 4f f5 ff ff       	call   80033c <_panic>

00800ded <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df3:	ba 00 00 00 00       	mov    $0x0,%edx
  800df8:	b8 02 00 00 00       	mov    $0x2,%eax
  800dfd:	89 d1                	mov    %edx,%ecx
  800dff:	89 d3                	mov    %edx,%ebx
  800e01:	89 d7                	mov    %edx,%edi
  800e03:	89 d6                	mov    %edx,%esi
  800e05:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	57                   	push   %edi
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
  800e12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e15:	be 00 00 00 00       	mov    $0x0,%esi
  800e1a:	b8 04 00 00 00       	mov    $0x4,%eax
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e28:	89 f7                	mov    %esi,%edi
  800e2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7f 08                	jg     800e38 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	50                   	push   %eax
  800e3c:	6a 04                	push   $0x4
  800e3e:	68 5f 29 80 00       	push   $0x80295f
  800e43:	6a 23                	push   $0x23
  800e45:	68 7c 29 80 00       	push   $0x80297c
  800e4a:	e8 ed f4 ff ff       	call   80033c <_panic>

00800e4f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e66:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e69:	8b 75 18             	mov    0x18(%ebp),%esi
  800e6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7f 08                	jg     800e7a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	50                   	push   %eax
  800e7e:	6a 05                	push   $0x5
  800e80:	68 5f 29 80 00       	push   $0x80295f
  800e85:	6a 23                	push   $0x23
  800e87:	68 7c 29 80 00       	push   $0x80297c
  800e8c:	e8 ab f4 ff ff       	call   80033c <_panic>

00800e91 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9f:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	89 df                	mov    %ebx,%edi
  800eac:	89 de                	mov    %ebx,%esi
  800eae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	7f 08                	jg     800ebc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	83 ec 0c             	sub    $0xc,%esp
  800ebf:	50                   	push   %eax
  800ec0:	6a 06                	push   $0x6
  800ec2:	68 5f 29 80 00       	push   $0x80295f
  800ec7:	6a 23                	push   $0x23
  800ec9:	68 7c 29 80 00       	push   $0x80297c
  800ece:	e8 69 f4 ff ff       	call   80033c <_panic>

00800ed3 <sys_yield>:

void
sys_yield(void)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ede:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ee3:	89 d1                	mov    %edx,%ecx
  800ee5:	89 d3                	mov    %edx,%ebx
  800ee7:	89 d7                	mov    %edx,%edi
  800ee9:	89 d6                	mov    %edx,%esi
  800eeb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f00:	b8 08 00 00 00       	mov    $0x8,%eax
  800f05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	89 df                	mov    %ebx,%edi
  800f0d:	89 de                	mov    %ebx,%esi
  800f0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	7f 08                	jg     800f1d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1d:	83 ec 0c             	sub    $0xc,%esp
  800f20:	50                   	push   %eax
  800f21:	6a 08                	push   $0x8
  800f23:	68 5f 29 80 00       	push   $0x80295f
  800f28:	6a 23                	push   $0x23
  800f2a:	68 7c 29 80 00       	push   $0x80297c
  800f2f:	e8 08 f4 ff ff       	call   80033c <_panic>

00800f34 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
  800f3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	89 cb                	mov    %ecx,%ebx
  800f4c:	89 cf                	mov    %ecx,%edi
  800f4e:	89 ce                	mov    %ecx,%esi
  800f50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f52:	85 c0                	test   %eax,%eax
  800f54:	7f 08                	jg     800f5e <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5e:	83 ec 0c             	sub    $0xc,%esp
  800f61:	50                   	push   %eax
  800f62:	6a 0c                	push   $0xc
  800f64:	68 5f 29 80 00       	push   $0x80295f
  800f69:	6a 23                	push   $0x23
  800f6b:	68 7c 29 80 00       	push   $0x80297c
  800f70:	e8 c7 f3 ff ff       	call   80033c <_panic>

00800f75 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	57                   	push   %edi
  800f79:	56                   	push   %esi
  800f7a:	53                   	push   %ebx
  800f7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f83:	b8 09 00 00 00       	mov    $0x9,%eax
  800f88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	89 df                	mov    %ebx,%edi
  800f90:	89 de                	mov    %ebx,%esi
  800f92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f94:	85 c0                	test   %eax,%eax
  800f96:	7f 08                	jg     800fa0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa0:	83 ec 0c             	sub    $0xc,%esp
  800fa3:	50                   	push   %eax
  800fa4:	6a 09                	push   $0x9
  800fa6:	68 5f 29 80 00       	push   $0x80295f
  800fab:	6a 23                	push   $0x23
  800fad:	68 7c 29 80 00       	push   $0x80297c
  800fb2:	e8 85 f3 ff ff       	call   80033c <_panic>

00800fb7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	57                   	push   %edi
  800fbb:	56                   	push   %esi
  800fbc:	53                   	push   %ebx
  800fbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	89 df                	mov    %ebx,%edi
  800fd2:	89 de                	mov    %ebx,%esi
  800fd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	7f 08                	jg     800fe2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdd:	5b                   	pop    %ebx
  800fde:	5e                   	pop    %esi
  800fdf:	5f                   	pop    %edi
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe2:	83 ec 0c             	sub    $0xc,%esp
  800fe5:	50                   	push   %eax
  800fe6:	6a 0a                	push   $0xa
  800fe8:	68 5f 29 80 00       	push   $0x80295f
  800fed:	6a 23                	push   $0x23
  800fef:	68 7c 29 80 00       	push   $0x80297c
  800ff4:	e8 43 f3 ff ff       	call   80033c <_panic>

00800ff9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	57                   	push   %edi
  800ffd:	56                   	push   %esi
  800ffe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fff:	be 00 00 00 00       	mov    $0x0,%esi
  801004:	b8 0d 00 00 00       	mov    $0xd,%eax
  801009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100c:	8b 55 08             	mov    0x8(%ebp),%edx
  80100f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801012:	8b 7d 14             	mov    0x14(%ebp),%edi
  801015:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
  801022:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801025:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80102f:	8b 55 08             	mov    0x8(%ebp),%edx
  801032:	89 cb                	mov    %ecx,%ebx
  801034:	89 cf                	mov    %ecx,%edi
  801036:	89 ce                	mov    %ecx,%esi
  801038:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	7f 08                	jg     801046 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80103e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5f                   	pop    %edi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801046:	83 ec 0c             	sub    $0xc,%esp
  801049:	50                   	push   %eax
  80104a:	6a 0e                	push   $0xe
  80104c:	68 5f 29 80 00       	push   $0x80295f
  801051:	6a 23                	push   $0x23
  801053:	68 7c 29 80 00       	push   $0x80297c
  801058:	e8 df f2 ff ff       	call   80033c <_panic>

0080105d <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
	asm volatile("int %1\n"
  801063:	be 00 00 00 00       	mov    $0x0,%esi
  801068:	b8 0f 00 00 00       	mov    $0xf,%eax
  80106d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801076:	89 f7                	mov    %esi,%edi
  801078:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
	asm volatile("int %1\n"
  801085:	be 00 00 00 00       	mov    $0x0,%esi
  80108a:	b8 10 00 00 00       	mov    $0x10,%eax
  80108f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801092:	8b 55 08             	mov    0x8(%ebp),%edx
  801095:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801098:	89 f7                	mov    %esi,%edi
  80109a:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	57                   	push   %edi
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ac:	b8 11 00 00 00       	mov    $0x11,%eax
  8010b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b4:	89 cb                	mov    %ecx,%ebx
  8010b6:	89 cf                	mov    %ecx,%edi
  8010b8:	89 ce                	mov    %ecx,%esi
  8010ba:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8010bc:	5b                   	pop    %ebx
  8010bd:	5e                   	pop    %esi
  8010be:	5f                   	pop    %edi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	56                   	push   %esi
  8010c5:	53                   	push   %ebx
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010c9:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  8010cb:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010cf:	0f 84 84 00 00 00    	je     801159 <pgfault+0x98>
  8010d5:	89 d8                	mov    %ebx,%eax
  8010d7:	c1 e8 16             	shr    $0x16,%eax
  8010da:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010e1:	a8 01                	test   $0x1,%al
  8010e3:	74 74                	je     801159 <pgfault+0x98>
  8010e5:	89 d8                	mov    %ebx,%eax
  8010e7:	c1 e8 0c             	shr    $0xc,%eax
  8010ea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010f1:	f6 c4 08             	test   $0x8,%ah
  8010f4:	74 63                	je     801159 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  8010f6:	e8 f2 fc ff ff       	call   800ded <sys_getenvid>
  8010fb:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  8010fd:	83 ec 04             	sub    $0x4,%esp
  801100:	6a 07                	push   $0x7
  801102:	68 00 f0 7f 00       	push   $0x7ff000
  801107:	50                   	push   %eax
  801108:	e8 ff fc ff ff       	call   800e0c <sys_page_alloc>
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	78 5b                	js     80116f <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  801114:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  80111a:	83 ec 04             	sub    $0x4,%esp
  80111d:	68 00 10 00 00       	push   $0x1000
  801122:	53                   	push   %ebx
  801123:	68 00 f0 7f 00       	push   $0x7ff000
  801128:	e8 03 fb ff ff       	call   800c30 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  80112d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801134:	53                   	push   %ebx
  801135:	56                   	push   %esi
  801136:	68 00 f0 7f 00       	push   $0x7ff000
  80113b:	56                   	push   %esi
  80113c:	e8 0e fd ff ff       	call   800e4f <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  801141:	83 c4 18             	add    $0x18,%esp
  801144:	68 00 f0 7f 00       	push   $0x7ff000
  801149:	56                   	push   %esi
  80114a:	e8 42 fd ff ff       	call   800e91 <sys_page_unmap>

}
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  801159:	68 8c 29 80 00       	push   $0x80298c
  80115e:	68 16 2a 80 00       	push   $0x802a16
  801163:	6a 1c                	push   $0x1c
  801165:	68 2b 2a 80 00       	push   $0x802a2b
  80116a:	e8 cd f1 ff ff       	call   80033c <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  80116f:	68 dc 29 80 00       	push   $0x8029dc
  801174:	68 16 2a 80 00       	push   $0x802a16
  801179:	6a 26                	push   $0x26
  80117b:	68 2b 2a 80 00       	push   $0x802a2b
  801180:	e8 b7 f1 ff ff       	call   80033c <_panic>

00801185 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	57                   	push   %edi
  801189:	56                   	push   %esi
  80118a:	53                   	push   %ebx
  80118b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80118e:	68 c1 10 80 00       	push   $0x8010c1
  801193:	e8 0d 0f 00 00       	call   8020a5 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801198:	b8 07 00 00 00       	mov    $0x7,%eax
  80119d:	cd 30                	int    $0x30
  80119f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	0f 88 58 01 00 00    	js     801308 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	74 07                	je     8011bb <fork+0x36>
  8011b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b9:	eb 72                	jmp    80122d <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011bb:	e8 2d fc ff ff       	call   800ded <sys_getenvid>
  8011c0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	c1 e2 05             	shl    $0x5,%edx
  8011ca:	29 c2                	sub    %eax,%edx
  8011cc:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8011d3:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011d8:	e9 20 01 00 00       	jmp    8012fd <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  8011dd:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  8011e4:	e8 04 fc ff ff       	call   800ded <sys_getenvid>
  8011e9:	83 ec 0c             	sub    $0xc,%esp
  8011ec:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  8011f2:	57                   	push   %edi
  8011f3:	56                   	push   %esi
  8011f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f7:	56                   	push   %esi
  8011f8:	50                   	push   %eax
  8011f9:	e8 51 fc ff ff       	call   800e4f <sys_page_map>
  8011fe:	83 c4 20             	add    $0x20,%esp
  801201:	eb 18                	jmp    80121b <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  801203:	e8 e5 fb ff ff       	call   800ded <sys_getenvid>
  801208:	83 ec 0c             	sub    $0xc,%esp
  80120b:	6a 05                	push   $0x5
  80120d:	56                   	push   %esi
  80120e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801211:	56                   	push   %esi
  801212:	50                   	push   %eax
  801213:	e8 37 fc ff ff       	call   800e4f <sys_page_map>
  801218:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  80121b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801221:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801227:	0f 84 8f 00 00 00    	je     8012bc <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  80122d:	89 d8                	mov    %ebx,%eax
  80122f:	c1 e8 16             	shr    $0x16,%eax
  801232:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801239:	a8 01                	test   $0x1,%al
  80123b:	74 de                	je     80121b <fork+0x96>
  80123d:	89 d8                	mov    %ebx,%eax
  80123f:	c1 e8 0c             	shr    $0xc,%eax
  801242:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801249:	a8 04                	test   $0x4,%al
  80124b:	74 ce                	je     80121b <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  80124d:	89 de                	mov    %ebx,%esi
  80124f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  801255:	89 f0                	mov    %esi,%eax
  801257:	c1 e8 0c             	shr    $0xc,%eax
  80125a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801261:	f6 c6 04             	test   $0x4,%dh
  801264:	0f 85 73 ff ff ff    	jne    8011dd <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  80126a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801271:	a9 02 08 00 00       	test   $0x802,%eax
  801276:	74 8b                	je     801203 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801278:	e8 70 fb ff ff       	call   800ded <sys_getenvid>
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	68 05 08 00 00       	push   $0x805
  801285:	56                   	push   %esi
  801286:	ff 75 e4             	pushl  -0x1c(%ebp)
  801289:	56                   	push   %esi
  80128a:	50                   	push   %eax
  80128b:	e8 bf fb ff ff       	call   800e4f <sys_page_map>
  801290:	83 c4 20             	add    $0x20,%esp
  801293:	85 c0                	test   %eax,%eax
  801295:	78 84                	js     80121b <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801297:	e8 51 fb ff ff       	call   800ded <sys_getenvid>
  80129c:	89 c7                	mov    %eax,%edi
  80129e:	e8 4a fb ff ff       	call   800ded <sys_getenvid>
  8012a3:	83 ec 0c             	sub    $0xc,%esp
  8012a6:	68 05 08 00 00       	push   $0x805
  8012ab:	56                   	push   %esi
  8012ac:	57                   	push   %edi
  8012ad:	56                   	push   %esi
  8012ae:	50                   	push   %eax
  8012af:	e8 9b fb ff ff       	call   800e4f <sys_page_map>
  8012b4:	83 c4 20             	add    $0x20,%esp
  8012b7:	e9 5f ff ff ff       	jmp    80121b <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	6a 07                	push   $0x7
  8012c1:	68 00 f0 bf ee       	push   $0xeebff000
  8012c6:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8012c9:	57                   	push   %edi
  8012ca:	e8 3d fb ff ff       	call   800e0c <sys_page_alloc>
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 3b                	js     801311 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  8012d6:	83 ec 08             	sub    $0x8,%esp
  8012d9:	68 eb 20 80 00       	push   $0x8020eb
  8012de:	57                   	push   %edi
  8012df:	e8 d3 fc ff ff       	call   800fb7 <sys_env_set_pgfault_upcall>
  8012e4:	83 c4 10             	add    $0x10,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	78 2f                	js     80131a <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	6a 02                	push   $0x2
  8012f0:	57                   	push   %edi
  8012f1:	e8 fc fb ff ff       	call   800ef2 <sys_env_set_status>
	if (temp < 0) {
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	78 26                	js     801323 <fork+0x19e>
		return -1;
	}

	return childid;
}
  8012fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801303:	5b                   	pop    %ebx
  801304:	5e                   	pop    %esi
  801305:	5f                   	pop    %edi
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    
		return -1;
  801308:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80130f:	eb ec                	jmp    8012fd <fork+0x178>
		return -1;
  801311:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801318:	eb e3                	jmp    8012fd <fork+0x178>
		return -1;
  80131a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801321:	eb da                	jmp    8012fd <fork+0x178>
		return -1;
  801323:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80132a:	eb d1                	jmp    8012fd <fork+0x178>

0080132c <sfork>:

// Challenge!
int
sfork(void)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801332:	68 36 2a 80 00       	push   $0x802a36
  801337:	68 85 00 00 00       	push   $0x85
  80133c:	68 2b 2a 80 00       	push   $0x802a2b
  801341:	e8 f6 ef ff ff       	call   80033c <_panic>

00801346 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	05 00 00 00 30       	add    $0x30000000,%eax
  801351:	c1 e8 0c             	shr    $0xc,%eax
}
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    

00801356 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801361:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801366:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801373:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801378:	89 c2                	mov    %eax,%edx
  80137a:	c1 ea 16             	shr    $0x16,%edx
  80137d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801384:	f6 c2 01             	test   $0x1,%dl
  801387:	74 2a                	je     8013b3 <fd_alloc+0x46>
  801389:	89 c2                	mov    %eax,%edx
  80138b:	c1 ea 0c             	shr    $0xc,%edx
  80138e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801395:	f6 c2 01             	test   $0x1,%dl
  801398:	74 19                	je     8013b3 <fd_alloc+0x46>
  80139a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80139f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013a4:	75 d2                	jne    801378 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013a6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013ac:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013b1:	eb 07                	jmp    8013ba <fd_alloc+0x4d>
			*fd_store = fd;
  8013b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013bf:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8013c3:	77 39                	ja     8013fe <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	c1 e0 0c             	shl    $0xc,%eax
  8013cb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	c1 ea 16             	shr    $0x16,%edx
  8013d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013dc:	f6 c2 01             	test   $0x1,%dl
  8013df:	74 24                	je     801405 <fd_lookup+0x49>
  8013e1:	89 c2                	mov    %eax,%edx
  8013e3:	c1 ea 0c             	shr    $0xc,%edx
  8013e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ed:	f6 c2 01             	test   $0x1,%dl
  8013f0:	74 1a                	je     80140c <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f5:	89 02                	mov    %eax,(%edx)
	return 0;
  8013f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    
		return -E_INVAL;
  8013fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801403:	eb f7                	jmp    8013fc <fd_lookup+0x40>
		return -E_INVAL;
  801405:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140a:	eb f0                	jmp    8013fc <fd_lookup+0x40>
  80140c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801411:	eb e9                	jmp    8013fc <fd_lookup+0x40>

00801413 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141c:	ba c8 2a 80 00       	mov    $0x802ac8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801421:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801426:	39 08                	cmp    %ecx,(%eax)
  801428:	74 33                	je     80145d <dev_lookup+0x4a>
  80142a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80142d:	8b 02                	mov    (%edx),%eax
  80142f:	85 c0                	test   %eax,%eax
  801431:	75 f3                	jne    801426 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801433:	a1 04 40 80 00       	mov    0x804004,%eax
  801438:	8b 40 48             	mov    0x48(%eax),%eax
  80143b:	83 ec 04             	sub    $0x4,%esp
  80143e:	51                   	push   %ecx
  80143f:	50                   	push   %eax
  801440:	68 4c 2a 80 00       	push   $0x802a4c
  801445:	e8 05 f0 ff ff       	call   80044f <cprintf>
	*dev = 0;
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    
			*dev = devtab[i];
  80145d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801460:	89 01                	mov    %eax,(%ecx)
			return 0;
  801462:	b8 00 00 00 00       	mov    $0x0,%eax
  801467:	eb f2                	jmp    80145b <dev_lookup+0x48>

00801469 <fd_close>:
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	57                   	push   %edi
  80146d:	56                   	push   %esi
  80146e:	53                   	push   %ebx
  80146f:	83 ec 1c             	sub    $0x1c,%esp
  801472:	8b 75 08             	mov    0x8(%ebp),%esi
  801475:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801478:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80147b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80147c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801482:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801485:	50                   	push   %eax
  801486:	e8 31 ff ff ff       	call   8013bc <fd_lookup>
  80148b:	89 c7                	mov    %eax,%edi
  80148d:	83 c4 08             	add    $0x8,%esp
  801490:	85 c0                	test   %eax,%eax
  801492:	78 05                	js     801499 <fd_close+0x30>
	    || fd != fd2)
  801494:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801497:	74 13                	je     8014ac <fd_close+0x43>
		return (must_exist ? r : 0);
  801499:	84 db                	test   %bl,%bl
  80149b:	75 05                	jne    8014a2 <fd_close+0x39>
  80149d:	bf 00 00 00 00       	mov    $0x0,%edi
}
  8014a2:	89 f8                	mov    %edi,%eax
  8014a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a7:	5b                   	pop    %ebx
  8014a8:	5e                   	pop    %esi
  8014a9:	5f                   	pop    %edi
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014b2:	50                   	push   %eax
  8014b3:	ff 36                	pushl  (%esi)
  8014b5:	e8 59 ff ff ff       	call   801413 <dev_lookup>
  8014ba:	89 c7                	mov    %eax,%edi
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 15                	js     8014d8 <fd_close+0x6f>
		if (dev->dev_close)
  8014c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c6:	8b 40 10             	mov    0x10(%eax),%eax
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	74 1b                	je     8014e8 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8014cd:	83 ec 0c             	sub    $0xc,%esp
  8014d0:	56                   	push   %esi
  8014d1:	ff d0                	call   *%eax
  8014d3:	89 c7                	mov    %eax,%edi
  8014d5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	56                   	push   %esi
  8014dc:	6a 00                	push   $0x0
  8014de:	e8 ae f9 ff ff       	call   800e91 <sys_page_unmap>
	return r;
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	eb ba                	jmp    8014a2 <fd_close+0x39>
			r = 0;
  8014e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8014ed:	eb e9                	jmp    8014d8 <fd_close+0x6f>

008014ef <close>:

int
close(int fdnum)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f8:	50                   	push   %eax
  8014f9:	ff 75 08             	pushl  0x8(%ebp)
  8014fc:	e8 bb fe ff ff       	call   8013bc <fd_lookup>
  801501:	83 c4 08             	add    $0x8,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 10                	js     801518 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	6a 01                	push   $0x1
  80150d:	ff 75 f4             	pushl  -0xc(%ebp)
  801510:	e8 54 ff ff ff       	call   801469 <fd_close>
  801515:	83 c4 10             	add    $0x10,%esp
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <close_all>:

void
close_all(void)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	53                   	push   %ebx
  80151e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801521:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	53                   	push   %ebx
  80152a:	e8 c0 ff ff ff       	call   8014ef <close>
	for (i = 0; i < MAXFD; i++)
  80152f:	43                   	inc    %ebx
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	83 fb 20             	cmp    $0x20,%ebx
  801536:	75 ee                	jne    801526 <close_all+0xc>
}
  801538:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	57                   	push   %edi
  801541:	56                   	push   %esi
  801542:	53                   	push   %ebx
  801543:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801546:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801549:	50                   	push   %eax
  80154a:	ff 75 08             	pushl  0x8(%ebp)
  80154d:	e8 6a fe ff ff       	call   8013bc <fd_lookup>
  801552:	89 c3                	mov    %eax,%ebx
  801554:	83 c4 08             	add    $0x8,%esp
  801557:	85 c0                	test   %eax,%eax
  801559:	0f 88 81 00 00 00    	js     8015e0 <dup+0xa3>
		return r;
	close(newfdnum);
  80155f:	83 ec 0c             	sub    $0xc,%esp
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	e8 85 ff ff ff       	call   8014ef <close>

	newfd = INDEX2FD(newfdnum);
  80156a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80156d:	c1 e6 0c             	shl    $0xc,%esi
  801570:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801576:	83 c4 04             	add    $0x4,%esp
  801579:	ff 75 e4             	pushl  -0x1c(%ebp)
  80157c:	e8 d5 fd ff ff       	call   801356 <fd2data>
  801581:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801583:	89 34 24             	mov    %esi,(%esp)
  801586:	e8 cb fd ff ff       	call   801356 <fd2data>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801590:	89 d8                	mov    %ebx,%eax
  801592:	c1 e8 16             	shr    $0x16,%eax
  801595:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80159c:	a8 01                	test   $0x1,%al
  80159e:	74 11                	je     8015b1 <dup+0x74>
  8015a0:	89 d8                	mov    %ebx,%eax
  8015a2:	c1 e8 0c             	shr    $0xc,%eax
  8015a5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015ac:	f6 c2 01             	test   $0x1,%dl
  8015af:	75 39                	jne    8015ea <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015b4:	89 d0                	mov    %edx,%eax
  8015b6:	c1 e8 0c             	shr    $0xc,%eax
  8015b9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015c8:	50                   	push   %eax
  8015c9:	56                   	push   %esi
  8015ca:	6a 00                	push   $0x0
  8015cc:	52                   	push   %edx
  8015cd:	6a 00                	push   $0x0
  8015cf:	e8 7b f8 ff ff       	call   800e4f <sys_page_map>
  8015d4:	89 c3                	mov    %eax,%ebx
  8015d6:	83 c4 20             	add    $0x20,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 31                	js     80160e <dup+0xd1>
		goto err;

	return newfdnum;
  8015dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015e0:	89 d8                	mov    %ebx,%eax
  8015e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5f                   	pop    %edi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015ea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f9:	50                   	push   %eax
  8015fa:	57                   	push   %edi
  8015fb:	6a 00                	push   $0x0
  8015fd:	53                   	push   %ebx
  8015fe:	6a 00                	push   $0x0
  801600:	e8 4a f8 ff ff       	call   800e4f <sys_page_map>
  801605:	89 c3                	mov    %eax,%ebx
  801607:	83 c4 20             	add    $0x20,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	79 a3                	jns    8015b1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	56                   	push   %esi
  801612:	6a 00                	push   $0x0
  801614:	e8 78 f8 ff ff       	call   800e91 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801619:	83 c4 08             	add    $0x8,%esp
  80161c:	57                   	push   %edi
  80161d:	6a 00                	push   $0x0
  80161f:	e8 6d f8 ff ff       	call   800e91 <sys_page_unmap>
	return r;
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	eb b7                	jmp    8015e0 <dup+0xa3>

00801629 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	53                   	push   %ebx
  80162d:	83 ec 14             	sub    $0x14,%esp
  801630:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801633:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801636:	50                   	push   %eax
  801637:	53                   	push   %ebx
  801638:	e8 7f fd ff ff       	call   8013bc <fd_lookup>
  80163d:	83 c4 08             	add    $0x8,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 3f                	js     801683 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164a:	50                   	push   %eax
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164e:	ff 30                	pushl  (%eax)
  801650:	e8 be fd ff ff       	call   801413 <dev_lookup>
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 27                	js     801683 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80165c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165f:	8b 42 08             	mov    0x8(%edx),%eax
  801662:	83 e0 03             	and    $0x3,%eax
  801665:	83 f8 01             	cmp    $0x1,%eax
  801668:	74 1e                	je     801688 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	8b 40 08             	mov    0x8(%eax),%eax
  801670:	85 c0                	test   %eax,%eax
  801672:	74 35                	je     8016a9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	ff 75 10             	pushl  0x10(%ebp)
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	52                   	push   %edx
  80167e:	ff d0                	call   *%eax
  801680:	83 c4 10             	add    $0x10,%esp
}
  801683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801686:	c9                   	leave  
  801687:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801688:	a1 04 40 80 00       	mov    0x804004,%eax
  80168d:	8b 40 48             	mov    0x48(%eax),%eax
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	53                   	push   %ebx
  801694:	50                   	push   %eax
  801695:	68 8d 2a 80 00       	push   $0x802a8d
  80169a:	e8 b0 ed ff ff       	call   80044f <cprintf>
		return -E_INVAL;
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a7:	eb da                	jmp    801683 <read+0x5a>
		return -E_NOT_SUPP;
  8016a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ae:	eb d3                	jmp    801683 <read+0x5a>

008016b0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	57                   	push   %edi
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016bc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c4:	39 f3                	cmp    %esi,%ebx
  8016c6:	73 25                	jae    8016ed <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	89 f0                	mov    %esi,%eax
  8016cd:	29 d8                	sub    %ebx,%eax
  8016cf:	50                   	push   %eax
  8016d0:	89 d8                	mov    %ebx,%eax
  8016d2:	03 45 0c             	add    0xc(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	57                   	push   %edi
  8016d7:	e8 4d ff ff ff       	call   801629 <read>
		if (m < 0)
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 08                	js     8016eb <readn+0x3b>
			return m;
		if (m == 0)
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	74 06                	je     8016ed <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8016e7:	01 c3                	add    %eax,%ebx
  8016e9:	eb d9                	jmp    8016c4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016eb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016ed:	89 d8                	mov    %ebx,%eax
  8016ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	53                   	push   %ebx
  8016fb:	83 ec 14             	sub    $0x14,%esp
  8016fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801701:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801704:	50                   	push   %eax
  801705:	53                   	push   %ebx
  801706:	e8 b1 fc ff ff       	call   8013bc <fd_lookup>
  80170b:	83 c4 08             	add    $0x8,%esp
  80170e:	85 c0                	test   %eax,%eax
  801710:	78 3a                	js     80174c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801712:	83 ec 08             	sub    $0x8,%esp
  801715:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801718:	50                   	push   %eax
  801719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171c:	ff 30                	pushl  (%eax)
  80171e:	e8 f0 fc ff ff       	call   801413 <dev_lookup>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	78 22                	js     80174c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801731:	74 1e                	je     801751 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801736:	8b 52 0c             	mov    0xc(%edx),%edx
  801739:	85 d2                	test   %edx,%edx
  80173b:	74 35                	je     801772 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	ff 75 10             	pushl  0x10(%ebp)
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	50                   	push   %eax
  801747:	ff d2                	call   *%edx
  801749:	83 c4 10             	add    $0x10,%esp
}
  80174c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174f:	c9                   	leave  
  801750:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801751:	a1 04 40 80 00       	mov    0x804004,%eax
  801756:	8b 40 48             	mov    0x48(%eax),%eax
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	53                   	push   %ebx
  80175d:	50                   	push   %eax
  80175e:	68 a9 2a 80 00       	push   $0x802aa9
  801763:	e8 e7 ec ff ff       	call   80044f <cprintf>
		return -E_INVAL;
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801770:	eb da                	jmp    80174c <write+0x55>
		return -E_NOT_SUPP;
  801772:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801777:	eb d3                	jmp    80174c <write+0x55>

00801779 <seek>:

int
seek(int fdnum, off_t offset)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80177f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801782:	50                   	push   %eax
  801783:	ff 75 08             	pushl  0x8(%ebp)
  801786:	e8 31 fc ff ff       	call   8013bc <fd_lookup>
  80178b:	83 c4 08             	add    $0x8,%esp
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 0e                	js     8017a0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801792:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801795:	8b 55 0c             	mov    0xc(%ebp),%edx
  801798:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	53                   	push   %ebx
  8017a6:	83 ec 14             	sub    $0x14,%esp
  8017a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017af:	50                   	push   %eax
  8017b0:	53                   	push   %ebx
  8017b1:	e8 06 fc ff ff       	call   8013bc <fd_lookup>
  8017b6:	83 c4 08             	add    $0x8,%esp
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 37                	js     8017f4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c3:	50                   	push   %eax
  8017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c7:	ff 30                	pushl  (%eax)
  8017c9:	e8 45 fc ff ff       	call   801413 <dev_lookup>
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 1f                	js     8017f4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017dc:	74 1b                	je     8017f9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e1:	8b 52 18             	mov    0x18(%edx),%edx
  8017e4:	85 d2                	test   %edx,%edx
  8017e6:	74 32                	je     80181a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017e8:	83 ec 08             	sub    $0x8,%esp
  8017eb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ee:	50                   	push   %eax
  8017ef:	ff d2                	call   *%edx
  8017f1:	83 c4 10             	add    $0x10,%esp
}
  8017f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017f9:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017fe:	8b 40 48             	mov    0x48(%eax),%eax
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	53                   	push   %ebx
  801805:	50                   	push   %eax
  801806:	68 6c 2a 80 00       	push   $0x802a6c
  80180b:	e8 3f ec ff ff       	call   80044f <cprintf>
		return -E_INVAL;
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801818:	eb da                	jmp    8017f4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80181a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80181f:	eb d3                	jmp    8017f4 <ftruncate+0x52>

00801821 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	53                   	push   %ebx
  801825:	83 ec 14             	sub    $0x14,%esp
  801828:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80182b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182e:	50                   	push   %eax
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	e8 85 fb ff ff       	call   8013bc <fd_lookup>
  801837:	83 c4 08             	add    $0x8,%esp
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 4b                	js     801889 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801844:	50                   	push   %eax
  801845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801848:	ff 30                	pushl  (%eax)
  80184a:	e8 c4 fb ff ff       	call   801413 <dev_lookup>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	85 c0                	test   %eax,%eax
  801854:	78 33                	js     801889 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801859:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80185d:	74 2f                	je     80188e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80185f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801862:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801869:	00 00 00 
	stat->st_type = 0;
  80186c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801873:	00 00 00 
	stat->st_dev = dev;
  801876:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80187c:	83 ec 08             	sub    $0x8,%esp
  80187f:	53                   	push   %ebx
  801880:	ff 75 f0             	pushl  -0x10(%ebp)
  801883:	ff 50 14             	call   *0x14(%eax)
  801886:	83 c4 10             	add    $0x10,%esp
}
  801889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    
		return -E_NOT_SUPP;
  80188e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801893:	eb f4                	jmp    801889 <fstat+0x68>

00801895 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80189a:	83 ec 08             	sub    $0x8,%esp
  80189d:	6a 00                	push   $0x0
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 34 02 00 00       	call   801adb <open>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 1b                	js     8018cb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	50                   	push   %eax
  8018b7:	e8 65 ff ff ff       	call   801821 <fstat>
  8018bc:	89 c6                	mov    %eax,%esi
	close(fd);
  8018be:	89 1c 24             	mov    %ebx,(%esp)
  8018c1:	e8 29 fc ff ff       	call   8014ef <close>
	return r;
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 f3                	mov    %esi,%ebx
}
  8018cb:	89 d8                	mov    %ebx,%eax
  8018cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d0:	5b                   	pop    %ebx
  8018d1:	5e                   	pop    %esi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    

008018d4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
  8018d9:	89 c6                	mov    %eax,%esi
  8018db:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018dd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018e4:	74 27                	je     80190d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018e6:	6a 07                	push   $0x7
  8018e8:	68 00 50 80 00       	push   $0x805000
  8018ed:	56                   	push   %esi
  8018ee:	ff 35 00 40 80 00    	pushl  0x804000
  8018f4:	e8 a1 08 00 00       	call   80219a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018f9:	83 c4 0c             	add    $0xc,%esp
  8018fc:	6a 00                	push   $0x0
  8018fe:	53                   	push   %ebx
  8018ff:	6a 00                	push   $0x0
  801901:	e8 0b 08 00 00       	call   802111 <ipc_recv>
}
  801906:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801909:	5b                   	pop    %ebx
  80190a:	5e                   	pop    %esi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	6a 01                	push   $0x1
  801912:	e8 df 08 00 00       	call   8021f6 <ipc_find_env>
  801917:	a3 00 40 80 00       	mov    %eax,0x804000
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	eb c5                	jmp    8018e6 <fsipc+0x12>

00801921 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	8b 40 0c             	mov    0xc(%eax),%eax
  80192d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801932:	8b 45 0c             	mov    0xc(%ebp),%eax
  801935:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80193a:	ba 00 00 00 00       	mov    $0x0,%edx
  80193f:	b8 02 00 00 00       	mov    $0x2,%eax
  801944:	e8 8b ff ff ff       	call   8018d4 <fsipc>
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <devfile_flush>:
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	8b 40 0c             	mov    0xc(%eax),%eax
  801957:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80195c:	ba 00 00 00 00       	mov    $0x0,%edx
  801961:	b8 06 00 00 00       	mov    $0x6,%eax
  801966:	e8 69 ff ff ff       	call   8018d4 <fsipc>
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <devfile_stat>:
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	53                   	push   %ebx
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8b 40 0c             	mov    0xc(%eax),%eax
  80197d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
  801987:	b8 05 00 00 00       	mov    $0x5,%eax
  80198c:	e8 43 ff ff ff       	call   8018d4 <fsipc>
  801991:	85 c0                	test   %eax,%eax
  801993:	78 2c                	js     8019c1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801995:	83 ec 08             	sub    $0x8,%esp
  801998:	68 00 50 80 00       	push   $0x805000
  80199d:	53                   	push   %ebx
  80199e:	e8 b4 f0 ff ff       	call   800a57 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019a3:	a1 80 50 80 00       	mov    0x805080,%eax
  8019a8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8019ae:	a1 84 50 80 00       	mov    0x805084,%eax
  8019b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <devfile_write>:
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	53                   	push   %ebx
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8019d0:	89 d8                	mov    %ebx,%eax
  8019d2:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8019d8:	76 05                	jbe    8019df <devfile_write+0x19>
  8019da:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019df:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8019e5:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8019eb:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	50                   	push   %eax
  8019f4:	ff 75 0c             	pushl  0xc(%ebp)
  8019f7:	68 08 50 80 00       	push   $0x805008
  8019fc:	e8 c9 f1 ff ff       	call   800bca <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
  801a06:	b8 04 00 00 00       	mov    $0x4,%eax
  801a0b:	e8 c4 fe ff ff       	call   8018d4 <fsipc>
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 0b                	js     801a22 <devfile_write+0x5c>
	assert(r <= n);
  801a17:	39 c3                	cmp    %eax,%ebx
  801a19:	72 0c                	jb     801a27 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801a1b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a20:	7f 1e                	jg     801a40 <devfile_write+0x7a>
}
  801a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    
	assert(r <= n);
  801a27:	68 d8 2a 80 00       	push   $0x802ad8
  801a2c:	68 16 2a 80 00       	push   $0x802a16
  801a31:	68 98 00 00 00       	push   $0x98
  801a36:	68 df 2a 80 00       	push   $0x802adf
  801a3b:	e8 fc e8 ff ff       	call   80033c <_panic>
	assert(r <= PGSIZE);
  801a40:	68 ea 2a 80 00       	push   $0x802aea
  801a45:	68 16 2a 80 00       	push   $0x802a16
  801a4a:	68 99 00 00 00       	push   $0x99
  801a4f:	68 df 2a 80 00       	push   $0x802adf
  801a54:	e8 e3 e8 ff ff       	call   80033c <_panic>

00801a59 <devfile_read>:
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	56                   	push   %esi
  801a5d:	53                   	push   %ebx
  801a5e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	8b 40 0c             	mov    0xc(%eax),%eax
  801a67:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a6c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a72:	ba 00 00 00 00       	mov    $0x0,%edx
  801a77:	b8 03 00 00 00       	mov    $0x3,%eax
  801a7c:	e8 53 fe ff ff       	call   8018d4 <fsipc>
  801a81:	89 c3                	mov    %eax,%ebx
  801a83:	85 c0                	test   %eax,%eax
  801a85:	78 1f                	js     801aa6 <devfile_read+0x4d>
	assert(r <= n);
  801a87:	39 c6                	cmp    %eax,%esi
  801a89:	72 24                	jb     801aaf <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a8b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a90:	7f 33                	jg     801ac5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	50                   	push   %eax
  801a96:	68 00 50 80 00       	push   $0x805000
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	e8 27 f1 ff ff       	call   800bca <memmove>
	return r;
  801aa3:	83 c4 10             	add    $0x10,%esp
}
  801aa6:	89 d8                	mov    %ebx,%eax
  801aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
	assert(r <= n);
  801aaf:	68 d8 2a 80 00       	push   $0x802ad8
  801ab4:	68 16 2a 80 00       	push   $0x802a16
  801ab9:	6a 7c                	push   $0x7c
  801abb:	68 df 2a 80 00       	push   $0x802adf
  801ac0:	e8 77 e8 ff ff       	call   80033c <_panic>
	assert(r <= PGSIZE);
  801ac5:	68 ea 2a 80 00       	push   $0x802aea
  801aca:	68 16 2a 80 00       	push   $0x802a16
  801acf:	6a 7d                	push   $0x7d
  801ad1:	68 df 2a 80 00       	push   $0x802adf
  801ad6:	e8 61 e8 ff ff       	call   80033c <_panic>

00801adb <open>:
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 1c             	sub    $0x1c,%esp
  801ae3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ae6:	56                   	push   %esi
  801ae7:	e8 38 ef ff ff       	call   800a24 <strlen>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801af4:	7f 6c                	jg     801b62 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801af6:	83 ec 0c             	sub    $0xc,%esp
  801af9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afc:	50                   	push   %eax
  801afd:	e8 6b f8 ff ff       	call   80136d <fd_alloc>
  801b02:	89 c3                	mov    %eax,%ebx
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 3c                	js     801b47 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b0b:	83 ec 08             	sub    $0x8,%esp
  801b0e:	56                   	push   %esi
  801b0f:	68 00 50 80 00       	push   $0x805000
  801b14:	e8 3e ef ff ff       	call   800a57 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b24:	b8 01 00 00 00       	mov    $0x1,%eax
  801b29:	e8 a6 fd ff ff       	call   8018d4 <fsipc>
  801b2e:	89 c3                	mov    %eax,%ebx
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 19                	js     801b50 <open+0x75>
	return fd2num(fd);
  801b37:	83 ec 0c             	sub    $0xc,%esp
  801b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b3d:	e8 04 f8 ff ff       	call   801346 <fd2num>
  801b42:	89 c3                	mov    %eax,%ebx
  801b44:	83 c4 10             	add    $0x10,%esp
}
  801b47:	89 d8                	mov    %ebx,%eax
  801b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4c:	5b                   	pop    %ebx
  801b4d:	5e                   	pop    %esi
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    
		fd_close(fd, 0);
  801b50:	83 ec 08             	sub    $0x8,%esp
  801b53:	6a 00                	push   $0x0
  801b55:	ff 75 f4             	pushl  -0xc(%ebp)
  801b58:	e8 0c f9 ff ff       	call   801469 <fd_close>
		return r;
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	eb e5                	jmp    801b47 <open+0x6c>
		return -E_BAD_PATH;
  801b62:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b67:	eb de                	jmp    801b47 <open+0x6c>

00801b69 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b74:	b8 08 00 00 00       	mov    $0x8,%eax
  801b79:	e8 56 fd ff ff       	call   8018d4 <fsipc>
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 c3 f7 ff ff       	call   801356 <fd2data>
  801b93:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b95:	83 c4 08             	add    $0x8,%esp
  801b98:	68 f6 2a 80 00       	push   $0x802af6
  801b9d:	53                   	push   %ebx
  801b9e:	e8 b4 ee ff ff       	call   800a57 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ba3:	8b 46 04             	mov    0x4(%esi),%eax
  801ba6:	2b 06                	sub    (%esi),%eax
  801ba8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801bae:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801bb5:	10 00 00 
	stat->st_dev = &devpipe;
  801bb8:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801bbf:	30 80 00 
	return 0;
}
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bca:	5b                   	pop    %ebx
  801bcb:	5e                   	pop    %esi
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bd8:	53                   	push   %ebx
  801bd9:	6a 00                	push   $0x0
  801bdb:	e8 b1 f2 ff ff       	call   800e91 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801be0:	89 1c 24             	mov    %ebx,(%esp)
  801be3:	e8 6e f7 ff ff       	call   801356 <fd2data>
  801be8:	83 c4 08             	add    $0x8,%esp
  801beb:	50                   	push   %eax
  801bec:	6a 00                	push   $0x0
  801bee:	e8 9e f2 ff ff       	call   800e91 <sys_page_unmap>
}
  801bf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <_pipeisclosed>:
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	57                   	push   %edi
  801bfc:	56                   	push   %esi
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 1c             	sub    $0x1c,%esp
  801c01:	89 c7                	mov    %eax,%edi
  801c03:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c05:	a1 04 40 80 00       	mov    0x804004,%eax
  801c0a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c0d:	83 ec 0c             	sub    $0xc,%esp
  801c10:	57                   	push   %edi
  801c11:	e8 22 06 00 00       	call   802238 <pageref>
  801c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c19:	89 34 24             	mov    %esi,(%esp)
  801c1c:	e8 17 06 00 00       	call   802238 <pageref>
		nn = thisenv->env_runs;
  801c21:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c27:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	39 cb                	cmp    %ecx,%ebx
  801c2f:	74 1b                	je     801c4c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c31:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c34:	75 cf                	jne    801c05 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c36:	8b 42 58             	mov    0x58(%edx),%eax
  801c39:	6a 01                	push   $0x1
  801c3b:	50                   	push   %eax
  801c3c:	53                   	push   %ebx
  801c3d:	68 fd 2a 80 00       	push   $0x802afd
  801c42:	e8 08 e8 ff ff       	call   80044f <cprintf>
  801c47:	83 c4 10             	add    $0x10,%esp
  801c4a:	eb b9                	jmp    801c05 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c4c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c4f:	0f 94 c0             	sete   %al
  801c52:	0f b6 c0             	movzbl %al,%eax
}
  801c55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c58:	5b                   	pop    %ebx
  801c59:	5e                   	pop    %esi
  801c5a:	5f                   	pop    %edi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    

00801c5d <devpipe_write>:
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	57                   	push   %edi
  801c61:	56                   	push   %esi
  801c62:	53                   	push   %ebx
  801c63:	83 ec 18             	sub    $0x18,%esp
  801c66:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c69:	56                   	push   %esi
  801c6a:	e8 e7 f6 ff ff       	call   801356 <fd2data>
  801c6f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	bf 00 00 00 00       	mov    $0x0,%edi
  801c79:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c7c:	74 41                	je     801cbf <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c7e:	8b 53 04             	mov    0x4(%ebx),%edx
  801c81:	8b 03                	mov    (%ebx),%eax
  801c83:	83 c0 20             	add    $0x20,%eax
  801c86:	39 c2                	cmp    %eax,%edx
  801c88:	72 14                	jb     801c9e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c8a:	89 da                	mov    %ebx,%edx
  801c8c:	89 f0                	mov    %esi,%eax
  801c8e:	e8 65 ff ff ff       	call   801bf8 <_pipeisclosed>
  801c93:	85 c0                	test   %eax,%eax
  801c95:	75 2c                	jne    801cc3 <devpipe_write+0x66>
			sys_yield();
  801c97:	e8 37 f2 ff ff       	call   800ed3 <sys_yield>
  801c9c:	eb e0                	jmp    801c7e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca1:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801ca4:	89 d0                	mov    %edx,%eax
  801ca6:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801cab:	78 0b                	js     801cb8 <devpipe_write+0x5b>
  801cad:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801cb1:	42                   	inc    %edx
  801cb2:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cb5:	47                   	inc    %edi
  801cb6:	eb c1                	jmp    801c79 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cb8:	48                   	dec    %eax
  801cb9:	83 c8 e0             	or     $0xffffffe0,%eax
  801cbc:	40                   	inc    %eax
  801cbd:	eb ee                	jmp    801cad <devpipe_write+0x50>
	return i;
  801cbf:	89 f8                	mov    %edi,%eax
  801cc1:	eb 05                	jmp    801cc8 <devpipe_write+0x6b>
				return 0;
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5e                   	pop    %esi
  801ccd:	5f                   	pop    %edi
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    

00801cd0 <devpipe_read>:
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	57                   	push   %edi
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 18             	sub    $0x18,%esp
  801cd9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cdc:	57                   	push   %edi
  801cdd:	e8 74 f6 ff ff       	call   801356 <fd2data>
  801ce2:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cec:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801cef:	74 46                	je     801d37 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801cf1:	8b 06                	mov    (%esi),%eax
  801cf3:	3b 46 04             	cmp    0x4(%esi),%eax
  801cf6:	75 22                	jne    801d1a <devpipe_read+0x4a>
			if (i > 0)
  801cf8:	85 db                	test   %ebx,%ebx
  801cfa:	74 0a                	je     801d06 <devpipe_read+0x36>
				return i;
  801cfc:	89 d8                	mov    %ebx,%eax
}
  801cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5e                   	pop    %esi
  801d03:	5f                   	pop    %edi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801d06:	89 f2                	mov    %esi,%edx
  801d08:	89 f8                	mov    %edi,%eax
  801d0a:	e8 e9 fe ff ff       	call   801bf8 <_pipeisclosed>
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	75 28                	jne    801d3b <devpipe_read+0x6b>
			sys_yield();
  801d13:	e8 bb f1 ff ff       	call   800ed3 <sys_yield>
  801d18:	eb d7                	jmp    801cf1 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d1a:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801d1f:	78 0f                	js     801d30 <devpipe_read+0x60>
  801d21:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d28:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801d2b:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801d2d:	43                   	inc    %ebx
  801d2e:	eb bc                	jmp    801cec <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d30:	48                   	dec    %eax
  801d31:	83 c8 e0             	or     $0xffffffe0,%eax
  801d34:	40                   	inc    %eax
  801d35:	eb ea                	jmp    801d21 <devpipe_read+0x51>
	return i;
  801d37:	89 d8                	mov    %ebx,%eax
  801d39:	eb c3                	jmp    801cfe <devpipe_read+0x2e>
				return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d40:	eb bc                	jmp    801cfe <devpipe_read+0x2e>

00801d42 <pipe>:
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4d:	50                   	push   %eax
  801d4e:	e8 1a f6 ff ff       	call   80136d <fd_alloc>
  801d53:	89 c3                	mov    %eax,%ebx
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	0f 88 2a 01 00 00    	js     801e8a <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	68 07 04 00 00       	push   $0x407
  801d68:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6b:	6a 00                	push   $0x0
  801d6d:	e8 9a f0 ff ff       	call   800e0c <sys_page_alloc>
  801d72:	89 c3                	mov    %eax,%ebx
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	85 c0                	test   %eax,%eax
  801d79:	0f 88 0b 01 00 00    	js     801e8a <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801d7f:	83 ec 0c             	sub    $0xc,%esp
  801d82:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d85:	50                   	push   %eax
  801d86:	e8 e2 f5 ff ff       	call   80136d <fd_alloc>
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	85 c0                	test   %eax,%eax
  801d92:	0f 88 e2 00 00 00    	js     801e7a <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d98:	83 ec 04             	sub    $0x4,%esp
  801d9b:	68 07 04 00 00       	push   $0x407
  801da0:	ff 75 f0             	pushl  -0x10(%ebp)
  801da3:	6a 00                	push   $0x0
  801da5:	e8 62 f0 ff ff       	call   800e0c <sys_page_alloc>
  801daa:	89 c3                	mov    %eax,%ebx
  801dac:	83 c4 10             	add    $0x10,%esp
  801daf:	85 c0                	test   %eax,%eax
  801db1:	0f 88 c3 00 00 00    	js     801e7a <pipe+0x138>
	va = fd2data(fd0);
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbd:	e8 94 f5 ff ff       	call   801356 <fd2data>
  801dc2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dc4:	83 c4 0c             	add    $0xc,%esp
  801dc7:	68 07 04 00 00       	push   $0x407
  801dcc:	50                   	push   %eax
  801dcd:	6a 00                	push   $0x0
  801dcf:	e8 38 f0 ff ff       	call   800e0c <sys_page_alloc>
  801dd4:	89 c3                	mov    %eax,%ebx
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	0f 88 89 00 00 00    	js     801e6a <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de1:	83 ec 0c             	sub    $0xc,%esp
  801de4:	ff 75 f0             	pushl  -0x10(%ebp)
  801de7:	e8 6a f5 ff ff       	call   801356 <fd2data>
  801dec:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801df3:	50                   	push   %eax
  801df4:	6a 00                	push   $0x0
  801df6:	56                   	push   %esi
  801df7:	6a 00                	push   $0x0
  801df9:	e8 51 f0 ff ff       	call   800e4f <sys_page_map>
  801dfe:	89 c3                	mov    %eax,%ebx
  801e00:	83 c4 20             	add    $0x20,%esp
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 55                	js     801e5c <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801e07:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e1c:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e25:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	ff 75 f4             	pushl  -0xc(%ebp)
  801e37:	e8 0a f5 ff ff       	call   801346 <fd2num>
  801e3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e41:	83 c4 04             	add    $0x4,%esp
  801e44:	ff 75 f0             	pushl  -0x10(%ebp)
  801e47:	e8 fa f4 ff ff       	call   801346 <fd2num>
  801e4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e4f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e5a:	eb 2e                	jmp    801e8a <pipe+0x148>
	sys_page_unmap(0, va);
  801e5c:	83 ec 08             	sub    $0x8,%esp
  801e5f:	56                   	push   %esi
  801e60:	6a 00                	push   $0x0
  801e62:	e8 2a f0 ff ff       	call   800e91 <sys_page_unmap>
  801e67:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e6a:	83 ec 08             	sub    $0x8,%esp
  801e6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e70:	6a 00                	push   $0x0
  801e72:	e8 1a f0 ff ff       	call   800e91 <sys_page_unmap>
  801e77:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e7a:	83 ec 08             	sub    $0x8,%esp
  801e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e80:	6a 00                	push   $0x0
  801e82:	e8 0a f0 ff ff       	call   800e91 <sys_page_unmap>
  801e87:	83 c4 10             	add    $0x10,%esp
}
  801e8a:	89 d8                	mov    %ebx,%eax
  801e8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8f:	5b                   	pop    %ebx
  801e90:	5e                   	pop    %esi
  801e91:	5d                   	pop    %ebp
  801e92:	c3                   	ret    

00801e93 <pipeisclosed>:
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e9c:	50                   	push   %eax
  801e9d:	ff 75 08             	pushl  0x8(%ebp)
  801ea0:	e8 17 f5 ff ff       	call   8013bc <fd_lookup>
  801ea5:	83 c4 10             	add    $0x10,%esp
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	78 18                	js     801ec4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801eac:	83 ec 0c             	sub    $0xc,%esp
  801eaf:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb2:	e8 9f f4 ff ff       	call   801356 <fd2data>
	return _pipeisclosed(fd, p);
  801eb7:	89 c2                	mov    %eax,%edx
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	e8 37 fd ff ff       	call   801bf8 <_pipeisclosed>
  801ec1:	83 c4 10             	add    $0x10,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	56                   	push   %esi
  801eca:	53                   	push   %ebx
  801ecb:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801ece:	85 f6                	test   %esi,%esi
  801ed0:	74 18                	je     801eea <wait+0x24>
	e = &envs[ENVX(envid)];
  801ed2:	89 f2                	mov    %esi,%edx
  801ed4:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801eda:	89 d0                	mov    %edx,%eax
  801edc:	c1 e0 05             	shl    $0x5,%eax
  801edf:	29 d0                	sub    %edx,%eax
  801ee1:	8d 1c 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%ebx
  801ee8:	eb 1b                	jmp    801f05 <wait+0x3f>
	assert(envid != 0);
  801eea:	68 15 2b 80 00       	push   $0x802b15
  801eef:	68 16 2a 80 00       	push   $0x802a16
  801ef4:	6a 09                	push   $0x9
  801ef6:	68 20 2b 80 00       	push   $0x802b20
  801efb:	e8 3c e4 ff ff       	call   80033c <_panic>
		sys_yield();
  801f00:	e8 ce ef ff ff       	call   800ed3 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f05:	8b 43 48             	mov    0x48(%ebx),%eax
  801f08:	39 c6                	cmp    %eax,%esi
  801f0a:	75 07                	jne    801f13 <wait+0x4d>
  801f0c:	8b 43 54             	mov    0x54(%ebx),%eax
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	75 ed                	jne    801f00 <wait+0x3a>
}
  801f13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f16:	5b                   	pop    %ebx
  801f17:	5e                   	pop    %esi
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    

00801f1a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    

00801f24 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	53                   	push   %ebx
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801f2e:	68 2b 2b 80 00       	push   $0x802b2b
  801f33:	53                   	push   %ebx
  801f34:	e8 1e eb ff ff       	call   800a57 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801f39:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801f40:	20 00 00 
	return 0;
}
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
  801f48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <devcons_write>:
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	57                   	push   %edi
  801f51:	56                   	push   %esi
  801f52:	53                   	push   %ebx
  801f53:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f59:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f5e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f64:	eb 1d                	jmp    801f83 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801f66:	83 ec 04             	sub    $0x4,%esp
  801f69:	53                   	push   %ebx
  801f6a:	03 45 0c             	add    0xc(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	57                   	push   %edi
  801f6f:	e8 56 ec ff ff       	call   800bca <memmove>
		sys_cputs(buf, m);
  801f74:	83 c4 08             	add    $0x8,%esp
  801f77:	53                   	push   %ebx
  801f78:	57                   	push   %edi
  801f79:	e8 f1 ed ff ff       	call   800d6f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f7e:	01 de                	add    %ebx,%esi
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	89 f0                	mov    %esi,%eax
  801f85:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f88:	73 11                	jae    801f9b <devcons_write+0x4e>
		m = n - tot;
  801f8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f8d:	29 f3                	sub    %esi,%ebx
  801f8f:	83 fb 7f             	cmp    $0x7f,%ebx
  801f92:	76 d2                	jbe    801f66 <devcons_write+0x19>
  801f94:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801f99:	eb cb                	jmp    801f66 <devcons_write+0x19>
}
  801f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9e:	5b                   	pop    %ebx
  801f9f:	5e                   	pop    %esi
  801fa0:	5f                   	pop    %edi
  801fa1:	5d                   	pop    %ebp
  801fa2:	c3                   	ret    

00801fa3 <devcons_read>:
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fad:	75 0c                	jne    801fbb <devcons_read+0x18>
		return 0;
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	eb 21                	jmp    801fd7 <devcons_read+0x34>
		sys_yield();
  801fb6:	e8 18 ef ff ff       	call   800ed3 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801fbb:	e8 cd ed ff ff       	call   800d8d <sys_cgetc>
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	74 f2                	je     801fb6 <devcons_read+0x13>
	if (c < 0)
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	78 0f                	js     801fd7 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801fc8:	83 f8 04             	cmp    $0x4,%eax
  801fcb:	74 0c                	je     801fd9 <devcons_read+0x36>
	*(char*)vbuf = c;
  801fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd0:	88 02                	mov    %al,(%edx)
	return 1;
  801fd2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    
		return 0;
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	eb f7                	jmp    801fd7 <devcons_read+0x34>

00801fe0 <cputchar>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fec:	6a 01                	push   $0x1
  801fee:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff1:	50                   	push   %eax
  801ff2:	e8 78 ed ff ff       	call   800d6f <sys_cputs>
}
  801ff7:	83 c4 10             	add    $0x10,%esp
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <getchar>:
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802002:	6a 01                	push   $0x1
  802004:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802007:	50                   	push   %eax
  802008:	6a 00                	push   $0x0
  80200a:	e8 1a f6 ff ff       	call   801629 <read>
	if (r < 0)
  80200f:	83 c4 10             	add    $0x10,%esp
  802012:	85 c0                	test   %eax,%eax
  802014:	78 08                	js     80201e <getchar+0x22>
	if (r < 1)
  802016:	85 c0                	test   %eax,%eax
  802018:	7e 06                	jle    802020 <getchar+0x24>
	return c;
  80201a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    
		return -E_EOF;
  802020:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802025:	eb f7                	jmp    80201e <getchar+0x22>

00802027 <iscons>:
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80202d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802030:	50                   	push   %eax
  802031:	ff 75 08             	pushl  0x8(%ebp)
  802034:	e8 83 f3 ff ff       	call   8013bc <fd_lookup>
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	85 c0                	test   %eax,%eax
  80203e:	78 11                	js     802051 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802049:	39 10                	cmp    %edx,(%eax)
  80204b:	0f 94 c0             	sete   %al
  80204e:	0f b6 c0             	movzbl %al,%eax
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <opencons>:
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802059:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205c:	50                   	push   %eax
  80205d:	e8 0b f3 ff ff       	call   80136d <fd_alloc>
  802062:	83 c4 10             	add    $0x10,%esp
  802065:	85 c0                	test   %eax,%eax
  802067:	78 3a                	js     8020a3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	68 07 04 00 00       	push   $0x407
  802071:	ff 75 f4             	pushl  -0xc(%ebp)
  802074:	6a 00                	push   $0x0
  802076:	e8 91 ed ff ff       	call   800e0c <sys_page_alloc>
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	85 c0                	test   %eax,%eax
  802080:	78 21                	js     8020a3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802082:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	50                   	push   %eax
  80209b:	e8 a6 f2 ff ff       	call   801346 <fd2num>
  8020a0:	83 c4 10             	add    $0x10,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020ab:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020b2:	74 0a                	je     8020be <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  8020be:	e8 2a ed ff ff       	call   800ded <sys_getenvid>
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	6a 07                	push   $0x7
  8020c8:	68 00 f0 bf ee       	push   $0xeebff000
  8020cd:	50                   	push   %eax
  8020ce:	e8 39 ed ff ff       	call   800e0c <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8020d3:	e8 15 ed ff ff       	call   800ded <sys_getenvid>
  8020d8:	83 c4 08             	add    $0x8,%esp
  8020db:	68 eb 20 80 00       	push   $0x8020eb
  8020e0:	50                   	push   %eax
  8020e1:	e8 d1 ee ff ff       	call   800fb7 <sys_env_set_pgfault_upcall>
  8020e6:	83 c4 10             	add    $0x10,%esp
  8020e9:	eb c9                	jmp    8020b4 <set_pgfault_handler+0xf>

008020eb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8020eb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8020ec:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8020f1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8020f3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  8020f6:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8020fa:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8020fe:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802101:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802103:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  802107:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80210a:	61                   	popa   
	addl $4, %esp
  80210b:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80210e:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80210f:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802110:	c3                   	ret    

00802111 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	57                   	push   %edi
  802115:	56                   	push   %esi
  802116:	53                   	push   %ebx
  802117:	83 ec 0c             	sub    $0xc,%esp
  80211a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80211d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802120:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  802123:	85 ff                	test   %edi,%edi
  802125:	74 53                	je     80217a <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  802127:	83 ec 0c             	sub    $0xc,%esp
  80212a:	57                   	push   %edi
  80212b:	e8 ec ee ff ff       	call   80101c <sys_ipc_recv>
  802130:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  802133:	85 db                	test   %ebx,%ebx
  802135:	74 0b                	je     802142 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802137:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80213d:	8b 52 74             	mov    0x74(%edx),%edx
  802140:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  802142:	85 f6                	test   %esi,%esi
  802144:	74 0f                	je     802155 <ipc_recv+0x44>
  802146:	85 ff                	test   %edi,%edi
  802148:	74 0b                	je     802155 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80214a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  802150:	8b 52 78             	mov    0x78(%edx),%edx
  802153:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  802155:	85 c0                	test   %eax,%eax
  802157:	74 30                	je     802189 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802159:	85 db                	test   %ebx,%ebx
  80215b:	74 06                	je     802163 <ipc_recv+0x52>
      		*from_env_store = 0;
  80215d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  802163:	85 f6                	test   %esi,%esi
  802165:	74 2c                	je     802193 <ipc_recv+0x82>
      		*perm_store = 0;
  802167:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80216d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  802172:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802175:	5b                   	pop    %ebx
  802176:	5e                   	pop    %esi
  802177:	5f                   	pop    %edi
  802178:	5d                   	pop    %ebp
  802179:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  80217a:	83 ec 0c             	sub    $0xc,%esp
  80217d:	6a ff                	push   $0xffffffff
  80217f:	e8 98 ee ff ff       	call   80101c <sys_ipc_recv>
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	eb aa                	jmp    802133 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  802189:	a1 04 40 80 00       	mov    0x804004,%eax
  80218e:	8b 40 70             	mov    0x70(%eax),%eax
  802191:	eb df                	jmp    802172 <ipc_recv+0x61>
		return -1;
  802193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802198:	eb d8                	jmp    802172 <ipc_recv+0x61>

0080219a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	57                   	push   %edi
  80219e:	56                   	push   %esi
  80219f:	53                   	push   %ebx
  8021a0:	83 ec 0c             	sub    $0xc,%esp
  8021a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021a9:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8021ac:	85 db                	test   %ebx,%ebx
  8021ae:	75 22                	jne    8021d2 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8021b0:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8021b5:	eb 1b                	jmp    8021d2 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8021b7:	68 38 2b 80 00       	push   $0x802b38
  8021bc:	68 16 2a 80 00       	push   $0x802a16
  8021c1:	6a 48                	push   $0x48
  8021c3:	68 5c 2b 80 00       	push   $0x802b5c
  8021c8:	e8 6f e1 ff ff       	call   80033c <_panic>
		sys_yield();
  8021cd:	e8 01 ed ff ff       	call   800ed3 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8021d2:	57                   	push   %edi
  8021d3:	53                   	push   %ebx
  8021d4:	56                   	push   %esi
  8021d5:	ff 75 08             	pushl  0x8(%ebp)
  8021d8:	e8 1c ee ff ff       	call   800ff9 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8021dd:	83 c4 10             	add    $0x10,%esp
  8021e0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021e3:	74 e8                	je     8021cd <ipc_send+0x33>
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	75 ce                	jne    8021b7 <ipc_send+0x1d>
		sys_yield();
  8021e9:	e8 e5 ec ff ff       	call   800ed3 <sys_yield>
		
	}
	
}
  8021ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021f1:	5b                   	pop    %ebx
  8021f2:	5e                   	pop    %esi
  8021f3:	5f                   	pop    %edi
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    

008021f6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802201:	89 c2                	mov    %eax,%edx
  802203:	c1 e2 05             	shl    $0x5,%edx
  802206:	29 c2                	sub    %eax,%edx
  802208:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  80220f:	8b 52 50             	mov    0x50(%edx),%edx
  802212:	39 ca                	cmp    %ecx,%edx
  802214:	74 0f                	je     802225 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802216:	40                   	inc    %eax
  802217:	3d 00 04 00 00       	cmp    $0x400,%eax
  80221c:	75 e3                	jne    802201 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
  802223:	eb 11                	jmp    802236 <ipc_find_env+0x40>
			return envs[i].env_id;
  802225:	89 c2                	mov    %eax,%edx
  802227:	c1 e2 05             	shl    $0x5,%edx
  80222a:	29 c2                	sub    %eax,%edx
  80222c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  802233:	8b 40 48             	mov    0x48(%eax),%eax
}
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    

00802238 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	c1 e8 16             	shr    $0x16,%eax
  802241:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802248:	a8 01                	test   $0x1,%al
  80224a:	74 21                	je     80226d <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	c1 e8 0c             	shr    $0xc,%eax
  802252:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802259:	a8 01                	test   $0x1,%al
  80225b:	74 17                	je     802274 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80225d:	c1 e8 0c             	shr    $0xc,%eax
  802260:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802267:	ef 
  802268:	0f b7 c0             	movzwl %ax,%eax
  80226b:	eb 05                	jmp    802272 <pageref+0x3a>
		return 0;
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    
		return 0;
  802274:	b8 00 00 00 00       	mov    $0x0,%eax
  802279:	eb f7                	jmp    802272 <pageref+0x3a>
  80227b:	90                   	nop

0080227c <__udivdi3>:
  80227c:	55                   	push   %ebp
  80227d:	57                   	push   %edi
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	83 ec 1c             	sub    $0x1c,%esp
  802283:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802287:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80228b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80228f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802293:	89 ca                	mov    %ecx,%edx
  802295:	89 f8                	mov    %edi,%eax
  802297:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80229b:	85 f6                	test   %esi,%esi
  80229d:	75 2d                	jne    8022cc <__udivdi3+0x50>
  80229f:	39 cf                	cmp    %ecx,%edi
  8022a1:	77 65                	ja     802308 <__udivdi3+0x8c>
  8022a3:	89 fd                	mov    %edi,%ebp
  8022a5:	85 ff                	test   %edi,%edi
  8022a7:	75 0b                	jne    8022b4 <__udivdi3+0x38>
  8022a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ae:	31 d2                	xor    %edx,%edx
  8022b0:	f7 f7                	div    %edi
  8022b2:	89 c5                	mov    %eax,%ebp
  8022b4:	31 d2                	xor    %edx,%edx
  8022b6:	89 c8                	mov    %ecx,%eax
  8022b8:	f7 f5                	div    %ebp
  8022ba:	89 c1                	mov    %eax,%ecx
  8022bc:	89 d8                	mov    %ebx,%eax
  8022be:	f7 f5                	div    %ebp
  8022c0:	89 cf                	mov    %ecx,%edi
  8022c2:	89 fa                	mov    %edi,%edx
  8022c4:	83 c4 1c             	add    $0x1c,%esp
  8022c7:	5b                   	pop    %ebx
  8022c8:	5e                   	pop    %esi
  8022c9:	5f                   	pop    %edi
  8022ca:	5d                   	pop    %ebp
  8022cb:	c3                   	ret    
  8022cc:	39 ce                	cmp    %ecx,%esi
  8022ce:	77 28                	ja     8022f8 <__udivdi3+0x7c>
  8022d0:	0f bd fe             	bsr    %esi,%edi
  8022d3:	83 f7 1f             	xor    $0x1f,%edi
  8022d6:	75 40                	jne    802318 <__udivdi3+0x9c>
  8022d8:	39 ce                	cmp    %ecx,%esi
  8022da:	72 0a                	jb     8022e6 <__udivdi3+0x6a>
  8022dc:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8022e0:	0f 87 9e 00 00 00    	ja     802384 <__udivdi3+0x108>
  8022e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022eb:	89 fa                	mov    %edi,%edx
  8022ed:	83 c4 1c             	add    $0x1c,%esp
  8022f0:	5b                   	pop    %ebx
  8022f1:	5e                   	pop    %esi
  8022f2:	5f                   	pop    %edi
  8022f3:	5d                   	pop    %ebp
  8022f4:	c3                   	ret    
  8022f5:	8d 76 00             	lea    0x0(%esi),%esi
  8022f8:	31 ff                	xor    %edi,%edi
  8022fa:	31 c0                	xor    %eax,%eax
  8022fc:	89 fa                	mov    %edi,%edx
  8022fe:	83 c4 1c             	add    $0x1c,%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    
  802306:	66 90                	xchg   %ax,%ax
  802308:	89 d8                	mov    %ebx,%eax
  80230a:	f7 f7                	div    %edi
  80230c:	31 ff                	xor    %edi,%edi
  80230e:	89 fa                	mov    %edi,%edx
  802310:	83 c4 1c             	add    $0x1c,%esp
  802313:	5b                   	pop    %ebx
  802314:	5e                   	pop    %esi
  802315:	5f                   	pop    %edi
  802316:	5d                   	pop    %ebp
  802317:	c3                   	ret    
  802318:	bd 20 00 00 00       	mov    $0x20,%ebp
  80231d:	29 fd                	sub    %edi,%ebp
  80231f:	89 f9                	mov    %edi,%ecx
  802321:	d3 e6                	shl    %cl,%esi
  802323:	89 c3                	mov    %eax,%ebx
  802325:	89 e9                	mov    %ebp,%ecx
  802327:	d3 eb                	shr    %cl,%ebx
  802329:	89 d9                	mov    %ebx,%ecx
  80232b:	09 f1                	or     %esi,%ecx
  80232d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802331:	89 f9                	mov    %edi,%ecx
  802333:	d3 e0                	shl    %cl,%eax
  802335:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802339:	89 d6                	mov    %edx,%esi
  80233b:	89 e9                	mov    %ebp,%ecx
  80233d:	d3 ee                	shr    %cl,%esi
  80233f:	89 f9                	mov    %edi,%ecx
  802341:	d3 e2                	shl    %cl,%edx
  802343:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802347:	89 e9                	mov    %ebp,%ecx
  802349:	d3 eb                	shr    %cl,%ebx
  80234b:	09 da                	or     %ebx,%edx
  80234d:	89 d0                	mov    %edx,%eax
  80234f:	89 f2                	mov    %esi,%edx
  802351:	f7 74 24 08          	divl   0x8(%esp)
  802355:	89 d6                	mov    %edx,%esi
  802357:	89 c3                	mov    %eax,%ebx
  802359:	f7 64 24 0c          	mull   0xc(%esp)
  80235d:	39 d6                	cmp    %edx,%esi
  80235f:	72 17                	jb     802378 <__udivdi3+0xfc>
  802361:	74 09                	je     80236c <__udivdi3+0xf0>
  802363:	89 d8                	mov    %ebx,%eax
  802365:	31 ff                	xor    %edi,%edi
  802367:	e9 56 ff ff ff       	jmp    8022c2 <__udivdi3+0x46>
  80236c:	8b 54 24 04          	mov    0x4(%esp),%edx
  802370:	89 f9                	mov    %edi,%ecx
  802372:	d3 e2                	shl    %cl,%edx
  802374:	39 c2                	cmp    %eax,%edx
  802376:	73 eb                	jae    802363 <__udivdi3+0xe7>
  802378:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80237b:	31 ff                	xor    %edi,%edi
  80237d:	e9 40 ff ff ff       	jmp    8022c2 <__udivdi3+0x46>
  802382:	66 90                	xchg   %ax,%ax
  802384:	31 c0                	xor    %eax,%eax
  802386:	e9 37 ff ff ff       	jmp    8022c2 <__udivdi3+0x46>
  80238b:	90                   	nop

0080238c <__umoddi3>:
  80238c:	55                   	push   %ebp
  80238d:	57                   	push   %edi
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	83 ec 1c             	sub    $0x1c,%esp
  802393:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802397:	8b 74 24 34          	mov    0x34(%esp),%esi
  80239b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80239f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023ab:	89 3c 24             	mov    %edi,(%esp)
  8023ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023b2:	89 f2                	mov    %esi,%edx
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	75 18                	jne    8023d0 <__umoddi3+0x44>
  8023b8:	39 f7                	cmp    %esi,%edi
  8023ba:	0f 86 a0 00 00 00    	jbe    802460 <__umoddi3+0xd4>
  8023c0:	89 c8                	mov    %ecx,%eax
  8023c2:	f7 f7                	div    %edi
  8023c4:	89 d0                	mov    %edx,%eax
  8023c6:	31 d2                	xor    %edx,%edx
  8023c8:	83 c4 1c             	add    $0x1c,%esp
  8023cb:	5b                   	pop    %ebx
  8023cc:	5e                   	pop    %esi
  8023cd:	5f                   	pop    %edi
  8023ce:	5d                   	pop    %ebp
  8023cf:	c3                   	ret    
  8023d0:	89 f3                	mov    %esi,%ebx
  8023d2:	39 f0                	cmp    %esi,%eax
  8023d4:	0f 87 a6 00 00 00    	ja     802480 <__umoddi3+0xf4>
  8023da:	0f bd e8             	bsr    %eax,%ebp
  8023dd:	83 f5 1f             	xor    $0x1f,%ebp
  8023e0:	0f 84 a6 00 00 00    	je     80248c <__umoddi3+0x100>
  8023e6:	bf 20 00 00 00       	mov    $0x20,%edi
  8023eb:	29 ef                	sub    %ebp,%edi
  8023ed:	89 e9                	mov    %ebp,%ecx
  8023ef:	d3 e0                	shl    %cl,%eax
  8023f1:	8b 34 24             	mov    (%esp),%esi
  8023f4:	89 f2                	mov    %esi,%edx
  8023f6:	89 f9                	mov    %edi,%ecx
  8023f8:	d3 ea                	shr    %cl,%edx
  8023fa:	09 c2                	or     %eax,%edx
  8023fc:	89 14 24             	mov    %edx,(%esp)
  8023ff:	89 f2                	mov    %esi,%edx
  802401:	89 e9                	mov    %ebp,%ecx
  802403:	d3 e2                	shl    %cl,%edx
  802405:	89 54 24 04          	mov    %edx,0x4(%esp)
  802409:	89 de                	mov    %ebx,%esi
  80240b:	89 f9                	mov    %edi,%ecx
  80240d:	d3 ee                	shr    %cl,%esi
  80240f:	89 e9                	mov    %ebp,%ecx
  802411:	d3 e3                	shl    %cl,%ebx
  802413:	8b 54 24 08          	mov    0x8(%esp),%edx
  802417:	89 d0                	mov    %edx,%eax
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	d3 e8                	shr    %cl,%eax
  80241d:	09 d8                	or     %ebx,%eax
  80241f:	89 d3                	mov    %edx,%ebx
  802421:	89 e9                	mov    %ebp,%ecx
  802423:	d3 e3                	shl    %cl,%ebx
  802425:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802429:	89 f2                	mov    %esi,%edx
  80242b:	f7 34 24             	divl   (%esp)
  80242e:	89 d6                	mov    %edx,%esi
  802430:	f7 64 24 04          	mull   0x4(%esp)
  802434:	89 c3                	mov    %eax,%ebx
  802436:	89 d1                	mov    %edx,%ecx
  802438:	39 d6                	cmp    %edx,%esi
  80243a:	72 7c                	jb     8024b8 <__umoddi3+0x12c>
  80243c:	74 72                	je     8024b0 <__umoddi3+0x124>
  80243e:	8b 54 24 08          	mov    0x8(%esp),%edx
  802442:	29 da                	sub    %ebx,%edx
  802444:	19 ce                	sbb    %ecx,%esi
  802446:	89 f0                	mov    %esi,%eax
  802448:	89 f9                	mov    %edi,%ecx
  80244a:	d3 e0                	shl    %cl,%eax
  80244c:	89 e9                	mov    %ebp,%ecx
  80244e:	d3 ea                	shr    %cl,%edx
  802450:	09 d0                	or     %edx,%eax
  802452:	89 e9                	mov    %ebp,%ecx
  802454:	d3 ee                	shr    %cl,%esi
  802456:	89 f2                	mov    %esi,%edx
  802458:	83 c4 1c             	add    $0x1c,%esp
  80245b:	5b                   	pop    %ebx
  80245c:	5e                   	pop    %esi
  80245d:	5f                   	pop    %edi
  80245e:	5d                   	pop    %ebp
  80245f:	c3                   	ret    
  802460:	89 fd                	mov    %edi,%ebp
  802462:	85 ff                	test   %edi,%edi
  802464:	75 0b                	jne    802471 <__umoddi3+0xe5>
  802466:	b8 01 00 00 00       	mov    $0x1,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f7                	div    %edi
  80246f:	89 c5                	mov    %eax,%ebp
  802471:	89 f0                	mov    %esi,%eax
  802473:	31 d2                	xor    %edx,%edx
  802475:	f7 f5                	div    %ebp
  802477:	89 c8                	mov    %ecx,%eax
  802479:	f7 f5                	div    %ebp
  80247b:	e9 44 ff ff ff       	jmp    8023c4 <__umoddi3+0x38>
  802480:	89 c8                	mov    %ecx,%eax
  802482:	89 f2                	mov    %esi,%edx
  802484:	83 c4 1c             	add    $0x1c,%esp
  802487:	5b                   	pop    %ebx
  802488:	5e                   	pop    %esi
  802489:	5f                   	pop    %edi
  80248a:	5d                   	pop    %ebp
  80248b:	c3                   	ret    
  80248c:	39 f0                	cmp    %esi,%eax
  80248e:	72 05                	jb     802495 <__umoddi3+0x109>
  802490:	39 0c 24             	cmp    %ecx,(%esp)
  802493:	77 0c                	ja     8024a1 <__umoddi3+0x115>
  802495:	89 f2                	mov    %esi,%edx
  802497:	29 f9                	sub    %edi,%ecx
  802499:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80249d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024a5:	83 c4 1c             	add    $0x1c,%esp
  8024a8:	5b                   	pop    %ebx
  8024a9:	5e                   	pop    %esi
  8024aa:	5f                   	pop    %edi
  8024ab:	5d                   	pop    %ebp
  8024ac:	c3                   	ret    
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8024b4:	73 88                	jae    80243e <__umoddi3+0xb2>
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	2b 44 24 04          	sub    0x4(%esp),%eax
  8024bc:	1b 14 24             	sbb    (%esp),%edx
  8024bf:	89 d1                	mov    %edx,%ecx
  8024c1:	89 c3                	mov    %eax,%ebx
  8024c3:	e9 76 ff ff ff       	jmp    80243e <__umoddi3+0xb2>
