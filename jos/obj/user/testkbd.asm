
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 3f 02 00 00       	call   800270 <libmain>
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
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 7a 0e 00 00       	call   800ebe <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	4b                   	dec    %ebx
  800045:	75 f8                	jne    80003f <umain+0xc>

	close(0);
  800047:	83 ec 0c             	sub    $0xc,%esp
  80004a:	6a 00                	push   $0x0
  80004c:	e8 04 12 00 00       	call   801255 <close>
	if ((r = opencons()) < 0)
  800051:	e8 c8 01 00 00       	call   80021e <opencons>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	85 c0                	test   %eax,%eax
  80005b:	78 16                	js     800073 <umain+0x40>
		panic("opencons: %e", r);
	if (r != 0)
  80005d:	85 c0                	test   %eax,%eax
  80005f:	74 24                	je     800085 <umain+0x52>
		panic("first opencons used fd %d", r);
  800061:	50                   	push   %eax
  800062:	68 bc 21 80 00       	push   $0x8021bc
  800067:	6a 11                	push   $0x11
  800069:	68 ad 21 80 00       	push   $0x8021ad
  80006e:	e8 63 02 00 00       	call   8002d6 <_panic>
		panic("opencons: %e", r);
  800073:	50                   	push   %eax
  800074:	68 a0 21 80 00       	push   $0x8021a0
  800079:	6a 0f                	push   $0xf
  80007b:	68 ad 21 80 00       	push   $0x8021ad
  800080:	e8 51 02 00 00       	call   8002d6 <_panic>
	if ((r = dup(0, 1)) < 0)
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	6a 01                	push   $0x1
  80008a:	6a 00                	push   $0x0
  80008c:	e8 12 12 00 00       	call   8012a3 <dup>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	79 24                	jns    8000bc <umain+0x89>
		panic("dup: %e", r);
  800098:	50                   	push   %eax
  800099:	68 d6 21 80 00       	push   $0x8021d6
  80009e:	6a 13                	push   $0x13
  8000a0:	68 ad 21 80 00       	push   $0x8021ad
  8000a5:	e8 2c 02 00 00       	call   8002d6 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 f0 21 80 00       	push   $0x8021f0
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 13 19 00 00       	call   8019cc <fprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 de 21 80 00       	push   $0x8021de
  8000c4:	e8 4d 08 00 00       	call   800916 <readline>
		if (buf != NULL)
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 da                	je     8000aa <umain+0x77>
			fprintf(1, "%s\n", buf);
  8000d0:	83 ec 04             	sub    $0x4,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 ec 21 80 00       	push   $0x8021ec
  8000d9:	6a 01                	push   $0x1
  8000db:	e8 ec 18 00 00       	call   8019cc <fprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	eb d7                	jmp    8000bc <umain+0x89>

008000e5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8000e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000ef:	55                   	push   %ebp
  8000f0:	89 e5                	mov    %esp,%ebp
  8000f2:	53                   	push   %ebx
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  8000f9:	68 08 22 80 00       	push   $0x802208
  8000fe:	53                   	push   %ebx
  8000ff:	e8 3e 09 00 00       	call   800a42 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800104:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  80010b:	20 00 00 
	return 0;
}
  80010e:	b8 00 00 00 00       	mov    $0x0,%eax
  800113:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800116:	c9                   	leave  
  800117:	c3                   	ret    

00800118 <devcons_write>:
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800124:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800129:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80012f:	eb 1d                	jmp    80014e <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	53                   	push   %ebx
  800135:	03 45 0c             	add    0xc(%ebp),%eax
  800138:	50                   	push   %eax
  800139:	57                   	push   %edi
  80013a:	e8 76 0a 00 00       	call   800bb5 <memmove>
		sys_cputs(buf, m);
  80013f:	83 c4 08             	add    $0x8,%esp
  800142:	53                   	push   %ebx
  800143:	57                   	push   %edi
  800144:	e8 11 0c 00 00       	call   800d5a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800149:	01 de                	add    %ebx,%esi
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	89 f0                	mov    %esi,%eax
  800150:	3b 75 10             	cmp    0x10(%ebp),%esi
  800153:	73 11                	jae    800166 <devcons_write+0x4e>
		m = n - tot;
  800155:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800158:	29 f3                	sub    %esi,%ebx
  80015a:	83 fb 7f             	cmp    $0x7f,%ebx
  80015d:	76 d2                	jbe    800131 <devcons_write+0x19>
  80015f:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800164:	eb cb                	jmp    800131 <devcons_write+0x19>
}
  800166:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800169:	5b                   	pop    %ebx
  80016a:	5e                   	pop    %esi
  80016b:	5f                   	pop    %edi
  80016c:	5d                   	pop    %ebp
  80016d:	c3                   	ret    

0080016e <devcons_read>:
{
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  800174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800178:	75 0c                	jne    800186 <devcons_read+0x18>
		return 0;
  80017a:	b8 00 00 00 00       	mov    $0x0,%eax
  80017f:	eb 21                	jmp    8001a2 <devcons_read+0x34>
		sys_yield();
  800181:	e8 38 0d 00 00       	call   800ebe <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800186:	e8 ed 0b 00 00       	call   800d78 <sys_cgetc>
  80018b:	85 c0                	test   %eax,%eax
  80018d:	74 f2                	je     800181 <devcons_read+0x13>
	if (c < 0)
  80018f:	85 c0                	test   %eax,%eax
  800191:	78 0f                	js     8001a2 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 0c                	je     8001a4 <devcons_read+0x36>
	*(char*)vbuf = c;
  800198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019b:	88 02                	mov    %al,(%edx)
	return 1;
  80019d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8001a2:	c9                   	leave  
  8001a3:	c3                   	ret    
		return 0;
  8001a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a9:	eb f7                	jmp    8001a2 <devcons_read+0x34>

008001ab <cputchar>:
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8001b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001b7:	6a 01                	push   $0x1
  8001b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001bc:	50                   	push   %eax
  8001bd:	e8 98 0b 00 00       	call   800d5a <sys_cputs>
}
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	c9                   	leave  
  8001c6:	c3                   	ret    

008001c7 <getchar>:
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001cd:	6a 01                	push   $0x1
  8001cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001d2:	50                   	push   %eax
  8001d3:	6a 00                	push   $0x0
  8001d5:	e8 b5 11 00 00       	call   80138f <read>
	if (r < 0)
  8001da:	83 c4 10             	add    $0x10,%esp
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	78 08                	js     8001e9 <getchar+0x22>
	if (r < 1)
  8001e1:	85 c0                	test   %eax,%eax
  8001e3:	7e 06                	jle    8001eb <getchar+0x24>
	return c;
  8001e5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    
		return -E_EOF;
  8001eb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001f0:	eb f7                	jmp    8001e9 <getchar+0x22>

008001f2 <iscons>:
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001fb:	50                   	push   %eax
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	e8 1e 0f 00 00       	call   801122 <fd_lookup>
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	85 c0                	test   %eax,%eax
  800209:	78 11                	js     80021c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80020b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80020e:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800214:	39 10                	cmp    %edx,(%eax)
  800216:	0f 94 c0             	sete   %al
  800219:	0f b6 c0             	movzbl %al,%eax
}
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <opencons>:
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800224:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800227:	50                   	push   %eax
  800228:	e8 a6 0e 00 00       	call   8010d3 <fd_alloc>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	85 c0                	test   %eax,%eax
  800232:	78 3a                	js     80026e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 07 04 00 00       	push   $0x407
  80023c:	ff 75 f4             	pushl  -0xc(%ebp)
  80023f:	6a 00                	push   $0x0
  800241:	e8 b1 0b 00 00       	call   800df7 <sys_page_alloc>
  800246:	83 c4 10             	add    $0x10,%esp
  800249:	85 c0                	test   %eax,%eax
  80024b:	78 21                	js     80026e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80024d:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800256:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	50                   	push   %eax
  800266:	e8 41 0e 00 00       	call   8010ac <fd2num>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	56                   	push   %esi
  800274:	53                   	push   %ebx
  800275:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800278:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80027b:	e8 58 0b 00 00       	call   800dd8 <sys_getenvid>
  800280:	25 ff 03 00 00       	and    $0x3ff,%eax
  800285:	89 c2                	mov    %eax,%edx
  800287:	c1 e2 05             	shl    $0x5,%edx
  80028a:	29 c2                	sub    %eax,%edx
  80028c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800293:	a3 04 44 80 00       	mov    %eax,0x804404

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800298:	85 db                	test   %ebx,%ebx
  80029a:	7e 07                	jle    8002a3 <libmain+0x33>
		binaryname = argv[0];
  80029c:	8b 06                	mov    (%esi),%eax
  80029e:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	56                   	push   %esi
  8002a7:	53                   	push   %ebx
  8002a8:	e8 86 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8002ad:	e8 0a 00 00 00       	call   8002bc <exit>
}
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002b8:	5b                   	pop    %ebx
  8002b9:	5e                   	pop    %esi
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002c2:	e8 b9 0f 00 00       	call   801280 <close_all>
	sys_env_destroy(0);
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	6a 00                	push   $0x0
  8002cc:	e8 c6 0a 00 00       	call   800d97 <sys_env_destroy>
}
  8002d1:	83 c4 10             	add    $0x10,%esp
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	57                   	push   %edi
  8002da:	56                   	push   %esi
  8002db:	53                   	push   %ebx
  8002dc:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  8002e2:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  8002e5:	8b 1d 1c 30 80 00    	mov    0x80301c,%ebx
  8002eb:	e8 e8 0a 00 00       	call   800dd8 <sys_getenvid>
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	ff 75 0c             	pushl  0xc(%ebp)
  8002f6:	ff 75 08             	pushl  0x8(%ebp)
  8002f9:	53                   	push   %ebx
  8002fa:	50                   	push   %eax
  8002fb:	68 20 22 80 00       	push   $0x802220
  800300:	68 00 01 00 00       	push   $0x100
  800305:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  80030b:	56                   	push   %esi
  80030c:	e8 eb 05 00 00       	call   8008fc <snprintf>
  800311:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800313:	83 c4 20             	add    $0x20,%esp
  800316:	57                   	push   %edi
  800317:	ff 75 10             	pushl  0x10(%ebp)
  80031a:	bf 00 01 00 00       	mov    $0x100,%edi
  80031f:	89 f8                	mov    %edi,%eax
  800321:	29 d8                	sub    %ebx,%eax
  800323:	50                   	push   %eax
  800324:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800327:	50                   	push   %eax
  800328:	e8 7a 05 00 00       	call   8008a7 <vsnprintf>
  80032d:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80032f:	83 c4 0c             	add    $0xc,%esp
  800332:	68 06 22 80 00       	push   $0x802206
  800337:	29 df                	sub    %ebx,%edi
  800339:	57                   	push   %edi
  80033a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80033d:	50                   	push   %eax
  80033e:	e8 b9 05 00 00       	call   8008fc <snprintf>
	sys_cputs(buf, r);
  800343:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800346:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800348:	53                   	push   %ebx
  800349:	56                   	push   %esi
  80034a:	e8 0b 0a 00 00       	call   800d5a <sys_cputs>
  80034f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800352:	cc                   	int3   
  800353:	eb fd                	jmp    800352 <_panic+0x7c>

00800355 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	57                   	push   %edi
  800359:	56                   	push   %esi
  80035a:	53                   	push   %ebx
  80035b:	83 ec 1c             	sub    $0x1c,%esp
  80035e:	89 c7                	mov    %eax,%edi
  800360:	89 d6                	mov    %edx,%esi
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	8b 55 0c             	mov    0xc(%ebp),%edx
  800368:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800371:	bb 00 00 00 00       	mov    $0x0,%ebx
  800376:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800379:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80037c:	39 d3                	cmp    %edx,%ebx
  80037e:	72 05                	jb     800385 <printnum+0x30>
  800380:	39 45 10             	cmp    %eax,0x10(%ebp)
  800383:	77 78                	ja     8003fd <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	ff 75 18             	pushl  0x18(%ebp)
  80038b:	8b 45 14             	mov    0x14(%ebp),%eax
  80038e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800391:	53                   	push   %ebx
  800392:	ff 75 10             	pushl  0x10(%ebp)
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039b:	ff 75 e0             	pushl  -0x20(%ebp)
  80039e:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a4:	e8 ab 1b 00 00       	call   801f54 <__udivdi3>
  8003a9:	83 c4 18             	add    $0x18,%esp
  8003ac:	52                   	push   %edx
  8003ad:	50                   	push   %eax
  8003ae:	89 f2                	mov    %esi,%edx
  8003b0:	89 f8                	mov    %edi,%eax
  8003b2:	e8 9e ff ff ff       	call   800355 <printnum>
  8003b7:	83 c4 20             	add    $0x20,%esp
  8003ba:	eb 11                	jmp    8003cd <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	56                   	push   %esi
  8003c0:	ff 75 18             	pushl  0x18(%ebp)
  8003c3:	ff d7                	call   *%edi
  8003c5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003c8:	4b                   	dec    %ebx
  8003c9:	85 db                	test   %ebx,%ebx
  8003cb:	7f ef                	jg     8003bc <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	56                   	push   %esi
  8003d1:	83 ec 04             	sub    $0x4,%esp
  8003d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003da:	ff 75 dc             	pushl  -0x24(%ebp)
  8003dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e0:	e8 7f 1c 00 00       	call   802064 <__umoddi3>
  8003e5:	83 c4 14             	add    $0x14,%esp
  8003e8:	0f be 80 43 22 80 00 	movsbl 0x802243(%eax),%eax
  8003ef:	50                   	push   %eax
  8003f0:	ff d7                	call   *%edi
}
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f8:	5b                   	pop    %ebx
  8003f9:	5e                   	pop    %esi
  8003fa:	5f                   	pop    %edi
  8003fb:	5d                   	pop    %ebp
  8003fc:	c3                   	ret    
  8003fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800400:	eb c6                	jmp    8003c8 <printnum+0x73>

00800402 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800408:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80040b:	8b 10                	mov    (%eax),%edx
  80040d:	3b 50 04             	cmp    0x4(%eax),%edx
  800410:	73 0a                	jae    80041c <sprintputch+0x1a>
		*b->buf++ = ch;
  800412:	8d 4a 01             	lea    0x1(%edx),%ecx
  800415:	89 08                	mov    %ecx,(%eax)
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	88 02                	mov    %al,(%edx)
}
  80041c:	5d                   	pop    %ebp
  80041d:	c3                   	ret    

0080041e <printfmt>:
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800424:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800427:	50                   	push   %eax
  800428:	ff 75 10             	pushl  0x10(%ebp)
  80042b:	ff 75 0c             	pushl  0xc(%ebp)
  80042e:	ff 75 08             	pushl  0x8(%ebp)
  800431:	e8 05 00 00 00       	call   80043b <vprintfmt>
}
  800436:	83 c4 10             	add    $0x10,%esp
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <vprintfmt>:
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	57                   	push   %edi
  80043f:	56                   	push   %esi
  800440:	53                   	push   %ebx
  800441:	83 ec 2c             	sub    $0x2c,%esp
  800444:	8b 75 08             	mov    0x8(%ebp),%esi
  800447:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80044a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80044d:	e9 ae 03 00 00       	jmp    800800 <vprintfmt+0x3c5>
  800452:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800456:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80045d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800464:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80046b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800470:	8d 47 01             	lea    0x1(%edi),%eax
  800473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800476:	8a 17                	mov    (%edi),%dl
  800478:	8d 42 dd             	lea    -0x23(%edx),%eax
  80047b:	3c 55                	cmp    $0x55,%al
  80047d:	0f 87 fe 03 00 00    	ja     800881 <vprintfmt+0x446>
  800483:	0f b6 c0             	movzbl %al,%eax
  800486:	ff 24 85 80 23 80 00 	jmp    *0x802380(,%eax,4)
  80048d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800490:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800494:	eb da                	jmp    800470 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800496:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800499:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80049d:	eb d1                	jmp    800470 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80049f:	0f b6 d2             	movzbl %dl,%edx
  8004a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004aa:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004ad:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004b0:	01 c0                	add    %eax,%eax
  8004b2:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8004b6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004bc:	83 f9 09             	cmp    $0x9,%ecx
  8004bf:	77 52                	ja     800513 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8004c1:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8004c2:	eb e9                	jmp    8004ad <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	8d 40 04             	lea    0x4(%eax),%eax
  8004d2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004dc:	79 92                	jns    800470 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004eb:	eb 83                	jmp    800470 <vprintfmt+0x35>
  8004ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f1:	78 08                	js     8004fb <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004f6:	e9 75 ff ff ff       	jmp    800470 <vprintfmt+0x35>
  8004fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800502:	eb ef                	jmp    8004f3 <vprintfmt+0xb8>
  800504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800507:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80050e:	e9 5d ff ff ff       	jmp    800470 <vprintfmt+0x35>
  800513:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800516:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800519:	eb bd                	jmp    8004d8 <vprintfmt+0x9d>
			lflag++;
  80051b:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80051c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80051f:	e9 4c ff ff ff       	jmp    800470 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 78 04             	lea    0x4(%eax),%edi
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	53                   	push   %ebx
  80052e:	ff 30                	pushl  (%eax)
  800530:	ff d6                	call   *%esi
			break;
  800532:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800535:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800538:	e9 c0 02 00 00       	jmp    8007fd <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8d 78 04             	lea    0x4(%eax),%edi
  800543:	8b 00                	mov    (%eax),%eax
  800545:	85 c0                	test   %eax,%eax
  800547:	78 2a                	js     800573 <vprintfmt+0x138>
  800549:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054b:	83 f8 0f             	cmp    $0xf,%eax
  80054e:	7f 27                	jg     800577 <vprintfmt+0x13c>
  800550:	8b 04 85 e0 24 80 00 	mov    0x8024e0(,%eax,4),%eax
  800557:	85 c0                	test   %eax,%eax
  800559:	74 1c                	je     800577 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80055b:	50                   	push   %eax
  80055c:	68 21 26 80 00       	push   $0x802621
  800561:	53                   	push   %ebx
  800562:	56                   	push   %esi
  800563:	e8 b6 fe ff ff       	call   80041e <printfmt>
  800568:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80056e:	e9 8a 02 00 00       	jmp    8007fd <vprintfmt+0x3c2>
  800573:	f7 d8                	neg    %eax
  800575:	eb d2                	jmp    800549 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800577:	52                   	push   %edx
  800578:	68 5b 22 80 00       	push   $0x80225b
  80057d:	53                   	push   %ebx
  80057e:	56                   	push   %esi
  80057f:	e8 9a fe ff ff       	call   80041e <printfmt>
  800584:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800587:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80058a:	e9 6e 02 00 00       	jmp    8007fd <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	83 c0 04             	add    $0x4,%eax
  800595:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 38                	mov    (%eax),%edi
  80059d:	85 ff                	test   %edi,%edi
  80059f:	74 39                	je     8005da <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8005a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a5:	0f 8e a9 00 00 00    	jle    800654 <vprintfmt+0x219>
  8005ab:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005af:	0f 84 a7 00 00 00    	je     80065c <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	ff 75 d0             	pushl  -0x30(%ebp)
  8005bb:	57                   	push   %edi
  8005bc:	e8 64 04 00 00       	call   800a25 <strnlen>
  8005c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c4:	29 c1                	sub    %eax,%ecx
  8005c6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005c9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005cc:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005d6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d8:	eb 14                	jmp    8005ee <vprintfmt+0x1b3>
				p = "(null)";
  8005da:	bf 54 22 80 00       	mov    $0x802254,%edi
  8005df:	eb c0                	jmp    8005a1 <vprintfmt+0x166>
					putch(padc, putdat);
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	53                   	push   %ebx
  8005e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ea:	4f                   	dec    %edi
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	85 ff                	test   %edi,%edi
  8005f0:	7f ef                	jg     8005e1 <vprintfmt+0x1a6>
  8005f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005f5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005f8:	89 c8                	mov    %ecx,%eax
  8005fa:	85 c9                	test   %ecx,%ecx
  8005fc:	78 10                	js     80060e <vprintfmt+0x1d3>
  8005fe:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800601:	29 c1                	sub    %eax,%ecx
  800603:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800606:	89 75 08             	mov    %esi,0x8(%ebp)
  800609:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80060c:	eb 15                	jmp    800623 <vprintfmt+0x1e8>
  80060e:	b8 00 00 00 00       	mov    $0x0,%eax
  800613:	eb e9                	jmp    8005fe <vprintfmt+0x1c3>
					putch(ch, putdat);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	53                   	push   %ebx
  800619:	52                   	push   %edx
  80061a:	ff 55 08             	call   *0x8(%ebp)
  80061d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800620:	ff 4d e0             	decl   -0x20(%ebp)
  800623:	47                   	inc    %edi
  800624:	8a 47 ff             	mov    -0x1(%edi),%al
  800627:	0f be d0             	movsbl %al,%edx
  80062a:	85 d2                	test   %edx,%edx
  80062c:	74 59                	je     800687 <vprintfmt+0x24c>
  80062e:	85 f6                	test   %esi,%esi
  800630:	78 03                	js     800635 <vprintfmt+0x1fa>
  800632:	4e                   	dec    %esi
  800633:	78 2f                	js     800664 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800635:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800639:	74 da                	je     800615 <vprintfmt+0x1da>
  80063b:	0f be c0             	movsbl %al,%eax
  80063e:	83 e8 20             	sub    $0x20,%eax
  800641:	83 f8 5e             	cmp    $0x5e,%eax
  800644:	76 cf                	jbe    800615 <vprintfmt+0x1da>
					putch('?', putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 3f                	push   $0x3f
  80064c:	ff 55 08             	call   *0x8(%ebp)
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	eb cc                	jmp    800620 <vprintfmt+0x1e5>
  800654:	89 75 08             	mov    %esi,0x8(%ebp)
  800657:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80065a:	eb c7                	jmp    800623 <vprintfmt+0x1e8>
  80065c:	89 75 08             	mov    %esi,0x8(%ebp)
  80065f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800662:	eb bf                	jmp    800623 <vprintfmt+0x1e8>
  800664:	8b 75 08             	mov    0x8(%ebp),%esi
  800667:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80066a:	eb 0c                	jmp    800678 <vprintfmt+0x23d>
				putch(' ', putdat);
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	53                   	push   %ebx
  800670:	6a 20                	push   $0x20
  800672:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800674:	4f                   	dec    %edi
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	85 ff                	test   %edi,%edi
  80067a:	7f f0                	jg     80066c <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80067c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
  800682:	e9 76 01 00 00       	jmp    8007fd <vprintfmt+0x3c2>
  800687:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80068a:	8b 75 08             	mov    0x8(%ebp),%esi
  80068d:	eb e9                	jmp    800678 <vprintfmt+0x23d>
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7f 1f                	jg     8006b3 <vprintfmt+0x278>
	else if (lflag)
  800694:	85 c9                	test   %ecx,%ecx
  800696:	75 48                	jne    8006e0 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	89 c1                	mov    %eax,%ecx
  8006a2:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b1:	eb 17                	jmp    8006ca <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 50 04             	mov    0x4(%eax),%edx
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 08             	lea    0x8(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006cd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8006d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006d4:	78 25                	js     8006fb <vprintfmt+0x2c0>
			base = 10;
  8006d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006db:	e9 03 01 00 00       	jmp    8007e3 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 c1                	mov    %eax,%ecx
  8006ea:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ed:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 40 04             	lea    0x4(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f9:	eb cf                	jmp    8006ca <vprintfmt+0x28f>
				putch('-', putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	53                   	push   %ebx
  8006ff:	6a 2d                	push   $0x2d
  800701:	ff d6                	call   *%esi
				num = -(long long) num;
  800703:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800706:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800709:	f7 da                	neg    %edx
  80070b:	83 d1 00             	adc    $0x0,%ecx
  80070e:	f7 d9                	neg    %ecx
  800710:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800713:	b8 0a 00 00 00       	mov    $0xa,%eax
  800718:	e9 c6 00 00 00       	jmp    8007e3 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80071d:	83 f9 01             	cmp    $0x1,%ecx
  800720:	7f 1e                	jg     800740 <vprintfmt+0x305>
	else if (lflag)
  800722:	85 c9                	test   %ecx,%ecx
  800724:	75 32                	jne    800758 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800736:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073b:	e9 a3 00 00 00       	jmp    8007e3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8b 10                	mov    (%eax),%edx
  800745:	8b 48 04             	mov    0x4(%eax),%ecx
  800748:	8d 40 08             	lea    0x8(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800753:	e9 8b 00 00 00       	jmp    8007e3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
  80075d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800768:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076d:	eb 74                	jmp    8007e3 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80076f:	83 f9 01             	cmp    $0x1,%ecx
  800772:	7f 1b                	jg     80078f <vprintfmt+0x354>
	else if (lflag)
  800774:	85 c9                	test   %ecx,%ecx
  800776:	75 2c                	jne    8007a4 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 10                	mov    (%eax),%edx
  80077d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800782:	8d 40 04             	lea    0x4(%eax),%eax
  800785:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800788:	b8 08 00 00 00       	mov    $0x8,%eax
  80078d:	eb 54                	jmp    8007e3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 10                	mov    (%eax),%edx
  800794:	8b 48 04             	mov    0x4(%eax),%ecx
  800797:	8d 40 08             	lea    0x8(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80079d:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a2:	eb 3f                	jmp    8007e3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 10                	mov    (%eax),%edx
  8007a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ae:	8d 40 04             	lea    0x4(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b9:	eb 28                	jmp    8007e3 <vprintfmt+0x3a8>
			putch('0', putdat);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	6a 30                	push   $0x30
  8007c1:	ff d6                	call   *%esi
			putch('x', putdat);
  8007c3:	83 c4 08             	add    $0x8,%esp
  8007c6:	53                   	push   %ebx
  8007c7:	6a 78                	push   $0x78
  8007c9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8b 10                	mov    (%eax),%edx
  8007d0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007d5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007de:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007ea:	57                   	push   %edi
  8007eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ee:	50                   	push   %eax
  8007ef:	51                   	push   %ecx
  8007f0:	52                   	push   %edx
  8007f1:	89 da                	mov    %ebx,%edx
  8007f3:	89 f0                	mov    %esi,%eax
  8007f5:	e8 5b fb ff ff       	call   800355 <printnum>
			break;
  8007fa:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	47                   	inc    %edi
  800801:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800805:	83 f8 25             	cmp    $0x25,%eax
  800808:	0f 84 44 fc ff ff    	je     800452 <vprintfmt+0x17>
			if (ch == '\0')
  80080e:	85 c0                	test   %eax,%eax
  800810:	0f 84 89 00 00 00    	je     80089f <vprintfmt+0x464>
			putch(ch, putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	50                   	push   %eax
  80081b:	ff d6                	call   *%esi
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	eb de                	jmp    800800 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800822:	83 f9 01             	cmp    $0x1,%ecx
  800825:	7f 1b                	jg     800842 <vprintfmt+0x407>
	else if (lflag)
  800827:	85 c9                	test   %ecx,%ecx
  800829:	75 2c                	jne    800857 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8b 10                	mov    (%eax),%edx
  800830:	b9 00 00 00 00       	mov    $0x0,%ecx
  800835:	8d 40 04             	lea    0x4(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083b:	b8 10 00 00 00       	mov    $0x10,%eax
  800840:	eb a1                	jmp    8007e3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 10                	mov    (%eax),%edx
  800847:	8b 48 04             	mov    0x4(%eax),%ecx
  80084a:	8d 40 08             	lea    0x8(%eax),%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800850:	b8 10 00 00 00       	mov    $0x10,%eax
  800855:	eb 8c                	jmp    8007e3 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	8b 10                	mov    (%eax),%edx
  80085c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800861:	8d 40 04             	lea    0x4(%eax),%eax
  800864:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800867:	b8 10 00 00 00       	mov    $0x10,%eax
  80086c:	e9 72 ff ff ff       	jmp    8007e3 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	53                   	push   %ebx
  800875:	6a 25                	push   $0x25
  800877:	ff d6                	call   *%esi
			break;
  800879:	83 c4 10             	add    $0x10,%esp
  80087c:	e9 7c ff ff ff       	jmp    8007fd <vprintfmt+0x3c2>
			putch('%', putdat);
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	53                   	push   %ebx
  800885:	6a 25                	push   $0x25
  800887:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	89 f8                	mov    %edi,%eax
  80088e:	eb 01                	jmp    800891 <vprintfmt+0x456>
  800890:	48                   	dec    %eax
  800891:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800895:	75 f9                	jne    800890 <vprintfmt+0x455>
  800897:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089a:	e9 5e ff ff ff       	jmp    8007fd <vprintfmt+0x3c2>
}
  80089f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a2:	5b                   	pop    %ebx
  8008a3:	5e                   	pop    %esi
  8008a4:	5f                   	pop    %edi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 18             	sub    $0x18,%esp
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c4:	85 c0                	test   %eax,%eax
  8008c6:	74 26                	je     8008ee <vsnprintf+0x47>
  8008c8:	85 d2                	test   %edx,%edx
  8008ca:	7e 29                	jle    8008f5 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cc:	ff 75 14             	pushl  0x14(%ebp)
  8008cf:	ff 75 10             	pushl  0x10(%ebp)
  8008d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d5:	50                   	push   %eax
  8008d6:	68 02 04 80 00       	push   $0x800402
  8008db:	e8 5b fb ff ff       	call   80043b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
}
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    
		return -E_INVAL;
  8008ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f3:	eb f7                	jmp    8008ec <vsnprintf+0x45>
  8008f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fa:	eb f0                	jmp    8008ec <vsnprintf+0x45>

008008fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800902:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800905:	50                   	push   %eax
  800906:	ff 75 10             	pushl  0x10(%ebp)
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	ff 75 08             	pushl  0x8(%ebp)
  80090f:	e8 93 ff ff ff       	call   8008a7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	57                   	push   %edi
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 0c             	sub    $0xc,%esp
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800922:	85 c0                	test   %eax,%eax
  800924:	74 13                	je     800939 <readline+0x23>
		fprintf(1, "%s", prompt);
  800926:	83 ec 04             	sub    $0x4,%esp
  800929:	50                   	push   %eax
  80092a:	68 21 26 80 00       	push   $0x802621
  80092f:	6a 01                	push   $0x1
  800931:	e8 96 10 00 00       	call   8019cc <fprintf>
  800936:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	6a 00                	push   $0x0
  80093e:	e8 af f8 ff ff       	call   8001f2 <iscons>
  800943:	89 c7                	mov    %eax,%edi
  800945:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800948:	be 00 00 00 00       	mov    $0x0,%esi
  80094d:	eb 7b                	jmp    8009ca <readline+0xb4>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  80094f:	83 f8 f8             	cmp    $0xfffffff8,%eax
  800952:	74 66                	je     8009ba <readline+0xa4>
				cprintf("read error: %e\n", c);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	50                   	push   %eax
  800958:	68 3f 25 80 00       	push   $0x80253f
  80095d:	e8 71 14 00 00       	call   801dd3 <cprintf>
  800962:	83 c4 10             	add    $0x10,%esp
			return NULL;
  800965:	b8 00 00 00 00       	mov    $0x0,%eax
  80096a:	eb 37                	jmp    8009a3 <readline+0x8d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
			if (echoing)
				cputchar('\b');
  80096c:	83 ec 0c             	sub    $0xc,%esp
  80096f:	6a 08                	push   $0x8
  800971:	e8 35 f8 ff ff       	call   8001ab <cputchar>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	eb 4e                	jmp    8009c9 <readline+0xb3>
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
  80097b:	83 ec 0c             	sub    $0xc,%esp
  80097e:	53                   	push   %ebx
  80097f:	e8 27 f8 ff ff       	call   8001ab <cputchar>
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	eb 6b                	jmp    8009f4 <readline+0xde>
			buf[i++] = c;
		} else if (c == '\n' || c == '\r') {
  800989:	83 fb 0a             	cmp    $0xa,%ebx
  80098c:	74 05                	je     800993 <readline+0x7d>
  80098e:	83 fb 0d             	cmp    $0xd,%ebx
  800991:	75 37                	jne    8009ca <readline+0xb4>
			if (echoing)
  800993:	85 ff                	test   %edi,%edi
  800995:	75 14                	jne    8009ab <readline+0x95>
				cputchar('\n');
			buf[i] = 0;
  800997:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  80099e:	b8 00 40 80 00       	mov    $0x804000,%eax
		}
	}
}
  8009a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a6:	5b                   	pop    %ebx
  8009a7:	5e                   	pop    %esi
  8009a8:	5f                   	pop    %edi
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    
				cputchar('\n');
  8009ab:	83 ec 0c             	sub    $0xc,%esp
  8009ae:	6a 0a                	push   $0xa
  8009b0:	e8 f6 f7 ff ff       	call   8001ab <cputchar>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	eb dd                	jmp    800997 <readline+0x81>
			return NULL;
  8009ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bf:	eb e2                	jmp    8009a3 <readline+0x8d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8009c1:	85 f6                	test   %esi,%esi
  8009c3:	7e 40                	jle    800a05 <readline+0xef>
			if (echoing)
  8009c5:	85 ff                	test   %edi,%edi
  8009c7:	75 a3                	jne    80096c <readline+0x56>
			i--;
  8009c9:	4e                   	dec    %esi
		c = getchar();
  8009ca:	e8 f8 f7 ff ff       	call   8001c7 <getchar>
  8009cf:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8009d1:	85 c0                	test   %eax,%eax
  8009d3:	0f 88 76 ff ff ff    	js     80094f <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8009d9:	83 f8 08             	cmp    $0x8,%eax
  8009dc:	74 21                	je     8009ff <readline+0xe9>
  8009de:	83 f8 7f             	cmp    $0x7f,%eax
  8009e1:	74 de                	je     8009c1 <readline+0xab>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009e3:	83 f8 1f             	cmp    $0x1f,%eax
  8009e6:	7e a1                	jle    800989 <readline+0x73>
  8009e8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8009ee:	7f 99                	jg     800989 <readline+0x73>
			if (echoing)
  8009f0:	85 ff                	test   %edi,%edi
  8009f2:	75 87                	jne    80097b <readline+0x65>
			buf[i++] = c;
  8009f4:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  8009fa:	8d 76 01             	lea    0x1(%esi),%esi
  8009fd:	eb cb                	jmp    8009ca <readline+0xb4>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8009ff:	85 f6                	test   %esi,%esi
  800a01:	7f c2                	jg     8009c5 <readline+0xaf>
  800a03:	eb c5                	jmp    8009ca <readline+0xb4>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a05:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800a0b:	7e e3                	jle    8009f0 <readline+0xda>
  800a0d:	eb bb                	jmp    8009ca <readline+0xb4>

00800a0f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1a:	eb 01                	jmp    800a1d <strlen+0xe>
		n++;
  800a1c:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800a1d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a21:	75 f9                	jne    800a1c <strlen+0xd>
	return n;
}
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	eb 01                	jmp    800a36 <strnlen+0x11>
		n++;
  800a35:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a36:	39 d0                	cmp    %edx,%eax
  800a38:	74 06                	je     800a40 <strnlen+0x1b>
  800a3a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a3e:	75 f5                	jne    800a35 <strnlen+0x10>
	return n;
}
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	53                   	push   %ebx
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a4c:	89 c2                	mov    %eax,%edx
  800a4e:	42                   	inc    %edx
  800a4f:	41                   	inc    %ecx
  800a50:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800a53:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a56:	84 db                	test   %bl,%bl
  800a58:	75 f4                	jne    800a4e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a5a:	5b                   	pop    %ebx
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a64:	53                   	push   %ebx
  800a65:	e8 a5 ff ff ff       	call   800a0f <strlen>
  800a6a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	01 d8                	add    %ebx,%eax
  800a72:	50                   	push   %eax
  800a73:	e8 ca ff ff ff       	call   800a42 <strcpy>
	return dst;
}
  800a78:	89 d8                	mov    %ebx,%eax
  800a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7d:	c9                   	leave  
  800a7e:	c3                   	ret    

00800a7f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	56                   	push   %esi
  800a83:	53                   	push   %ebx
  800a84:	8b 75 08             	mov    0x8(%ebp),%esi
  800a87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8a:	89 f3                	mov    %esi,%ebx
  800a8c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8f:	89 f2                	mov    %esi,%edx
  800a91:	eb 0c                	jmp    800a9f <strncpy+0x20>
		*dst++ = *src;
  800a93:	42                   	inc    %edx
  800a94:	8a 01                	mov    (%ecx),%al
  800a96:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a99:	80 39 01             	cmpb   $0x1,(%ecx)
  800a9c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a9f:	39 da                	cmp    %ebx,%edx
  800aa1:	75 f0                	jne    800a93 <strncpy+0x14>
	}
	return ret;
}
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	5b                   	pop    %ebx
  800aa6:	5e                   	pop    %esi
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
  800aae:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab4:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab7:	85 c0                	test   %eax,%eax
  800ab9:	74 20                	je     800adb <strlcpy+0x32>
  800abb:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800abf:	89 f0                	mov    %esi,%eax
  800ac1:	eb 05                	jmp    800ac8 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ac3:	40                   	inc    %eax
  800ac4:	42                   	inc    %edx
  800ac5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ac8:	39 d8                	cmp    %ebx,%eax
  800aca:	74 06                	je     800ad2 <strlcpy+0x29>
  800acc:	8a 0a                	mov    (%edx),%cl
  800ace:	84 c9                	test   %cl,%cl
  800ad0:	75 f1                	jne    800ac3 <strlcpy+0x1a>
		*dst = '\0';
  800ad2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad5:	29 f0                	sub    %esi,%eax
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5e                   	pop    %esi
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    
  800adb:	89 f0                	mov    %esi,%eax
  800add:	eb f6                	jmp    800ad5 <strlcpy+0x2c>

00800adf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae8:	eb 02                	jmp    800aec <strcmp+0xd>
		p++, q++;
  800aea:	41                   	inc    %ecx
  800aeb:	42                   	inc    %edx
	while (*p && *p == *q)
  800aec:	8a 01                	mov    (%ecx),%al
  800aee:	84 c0                	test   %al,%al
  800af0:	74 04                	je     800af6 <strcmp+0x17>
  800af2:	3a 02                	cmp    (%edx),%al
  800af4:	74 f4                	je     800aea <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af6:	0f b6 c0             	movzbl %al,%eax
  800af9:	0f b6 12             	movzbl (%edx),%edx
  800afc:	29 d0                	sub    %edx,%eax
}
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	53                   	push   %ebx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0a:	89 c3                	mov    %eax,%ebx
  800b0c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b0f:	eb 02                	jmp    800b13 <strncmp+0x13>
		n--, p++, q++;
  800b11:	40                   	inc    %eax
  800b12:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800b13:	39 d8                	cmp    %ebx,%eax
  800b15:	74 15                	je     800b2c <strncmp+0x2c>
  800b17:	8a 08                	mov    (%eax),%cl
  800b19:	84 c9                	test   %cl,%cl
  800b1b:	74 04                	je     800b21 <strncmp+0x21>
  800b1d:	3a 0a                	cmp    (%edx),%cl
  800b1f:	74 f0                	je     800b11 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b21:	0f b6 00             	movzbl (%eax),%eax
  800b24:	0f b6 12             	movzbl (%edx),%edx
  800b27:	29 d0                	sub    %edx,%eax
}
  800b29:	5b                   	pop    %ebx
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    
		return 0;
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	eb f6                	jmp    800b29 <strncmp+0x29>

00800b33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800b3c:	8a 10                	mov    (%eax),%dl
  800b3e:	84 d2                	test   %dl,%dl
  800b40:	74 07                	je     800b49 <strchr+0x16>
		if (*s == c)
  800b42:	38 ca                	cmp    %cl,%dl
  800b44:	74 08                	je     800b4e <strchr+0x1b>
	for (; *s; s++)
  800b46:	40                   	inc    %eax
  800b47:	eb f3                	jmp    800b3c <strchr+0x9>
			return (char *) s;
	return 0;
  800b49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800b59:	8a 10                	mov    (%eax),%dl
  800b5b:	84 d2                	test   %dl,%dl
  800b5d:	74 07                	je     800b66 <strfind+0x16>
		if (*s == c)
  800b5f:	38 ca                	cmp    %cl,%dl
  800b61:	74 03                	je     800b66 <strfind+0x16>
	for (; *s; s++)
  800b63:	40                   	inc    %eax
  800b64:	eb f3                	jmp    800b59 <strfind+0x9>
			break;
	return (char *) s;
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	57                   	push   %edi
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
  800b6e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b71:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b74:	85 c9                	test   %ecx,%ecx
  800b76:	74 13                	je     800b8b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b78:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b7e:	75 05                	jne    800b85 <memset+0x1d>
  800b80:	f6 c1 03             	test   $0x3,%cl
  800b83:	74 0d                	je     800b92 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b88:	fc                   	cld    
  800b89:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8b:	89 f8                	mov    %edi,%eax
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    
		c &= 0xFF;
  800b92:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	c1 e3 08             	shl    $0x8,%ebx
  800b9b:	89 d0                	mov    %edx,%eax
  800b9d:	c1 e0 18             	shl    $0x18,%eax
  800ba0:	89 d6                	mov    %edx,%esi
  800ba2:	c1 e6 10             	shl    $0x10,%esi
  800ba5:	09 f0                	or     %esi,%eax
  800ba7:	09 c2                	or     %eax,%edx
  800ba9:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bab:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bae:	89 d0                	mov    %edx,%eax
  800bb0:	fc                   	cld    
  800bb1:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb3:	eb d6                	jmp    800b8b <memset+0x23>

00800bb5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	57                   	push   %edi
  800bb9:	56                   	push   %esi
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc3:	39 c6                	cmp    %eax,%esi
  800bc5:	73 33                	jae    800bfa <memmove+0x45>
  800bc7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bca:	39 d0                	cmp    %edx,%eax
  800bcc:	73 2c                	jae    800bfa <memmove+0x45>
		s += n;
		d += n;
  800bce:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd1:	89 d6                	mov    %edx,%esi
  800bd3:	09 fe                	or     %edi,%esi
  800bd5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bdb:	75 13                	jne    800bf0 <memmove+0x3b>
  800bdd:	f6 c1 03             	test   $0x3,%cl
  800be0:	75 0e                	jne    800bf0 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800be2:	83 ef 04             	sub    $0x4,%edi
  800be5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800be8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800beb:	fd                   	std    
  800bec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bee:	eb 07                	jmp    800bf7 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf0:	4f                   	dec    %edi
  800bf1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bf4:	fd                   	std    
  800bf5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bf7:	fc                   	cld    
  800bf8:	eb 13                	jmp    800c0d <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfa:	89 f2                	mov    %esi,%edx
  800bfc:	09 c2                	or     %eax,%edx
  800bfe:	f6 c2 03             	test   $0x3,%dl
  800c01:	75 05                	jne    800c08 <memmove+0x53>
  800c03:	f6 c1 03             	test   $0x3,%cl
  800c06:	74 09                	je     800c11 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c08:	89 c7                	mov    %eax,%edi
  800c0a:	fc                   	cld    
  800c0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c0d:	5e                   	pop    %esi
  800c0e:	5f                   	pop    %edi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c14:	89 c7                	mov    %eax,%edi
  800c16:	fc                   	cld    
  800c17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c19:	eb f2                	jmp    800c0d <memmove+0x58>

00800c1b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c1e:	ff 75 10             	pushl  0x10(%ebp)
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	ff 75 08             	pushl  0x8(%ebp)
  800c27:	e8 89 ff ff ff       	call   800bb5 <memmove>
}
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 c6                	mov    %eax,%esi
  800c38:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800c3b:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800c3e:	39 f0                	cmp    %esi,%eax
  800c40:	74 16                	je     800c58 <memcmp+0x2a>
		if (*s1 != *s2)
  800c42:	8a 08                	mov    (%eax),%cl
  800c44:	8a 1a                	mov    (%edx),%bl
  800c46:	38 d9                	cmp    %bl,%cl
  800c48:	75 04                	jne    800c4e <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c4a:	40                   	inc    %eax
  800c4b:	42                   	inc    %edx
  800c4c:	eb f0                	jmp    800c3e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c4e:	0f b6 c1             	movzbl %cl,%eax
  800c51:	0f b6 db             	movzbl %bl,%ebx
  800c54:	29 d8                	sub    %ebx,%eax
  800c56:	eb 05                	jmp    800c5d <memcmp+0x2f>
	}

	return 0;
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c6a:	89 c2                	mov    %eax,%edx
  800c6c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c6f:	39 d0                	cmp    %edx,%eax
  800c71:	73 07                	jae    800c7a <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c73:	38 08                	cmp    %cl,(%eax)
  800c75:	74 03                	je     800c7a <memfind+0x19>
	for (; s < ends; s++)
  800c77:	40                   	inc    %eax
  800c78:	eb f5                	jmp    800c6f <memfind+0xe>
			break;
	return (void *) s;
}
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	57                   	push   %edi
  800c80:	56                   	push   %esi
  800c81:	53                   	push   %ebx
  800c82:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c85:	eb 01                	jmp    800c88 <strtol+0xc>
		s++;
  800c87:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800c88:	8a 01                	mov    (%ecx),%al
  800c8a:	3c 20                	cmp    $0x20,%al
  800c8c:	74 f9                	je     800c87 <strtol+0xb>
  800c8e:	3c 09                	cmp    $0x9,%al
  800c90:	74 f5                	je     800c87 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800c92:	3c 2b                	cmp    $0x2b,%al
  800c94:	74 2b                	je     800cc1 <strtol+0x45>
		s++;
	else if (*s == '-')
  800c96:	3c 2d                	cmp    $0x2d,%al
  800c98:	74 2f                	je     800cc9 <strtol+0x4d>
	int neg = 0;
  800c9a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9f:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800ca6:	75 12                	jne    800cba <strtol+0x3e>
  800ca8:	80 39 30             	cmpb   $0x30,(%ecx)
  800cab:	74 24                	je     800cd1 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb1:	75 07                	jne    800cba <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cb3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800cba:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbf:	eb 4e                	jmp    800d0f <strtol+0x93>
		s++;
  800cc1:	41                   	inc    %ecx
	int neg = 0;
  800cc2:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc7:	eb d6                	jmp    800c9f <strtol+0x23>
		s++, neg = 1;
  800cc9:	41                   	inc    %ecx
  800cca:	bf 01 00 00 00       	mov    $0x1,%edi
  800ccf:	eb ce                	jmp    800c9f <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cd5:	74 10                	je     800ce7 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	75 dd                	jne    800cba <strtol+0x3e>
		s++, base = 8;
  800cdd:	41                   	inc    %ecx
  800cde:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ce5:	eb d3                	jmp    800cba <strtol+0x3e>
		s += 2, base = 16;
  800ce7:	83 c1 02             	add    $0x2,%ecx
  800cea:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cf1:	eb c7                	jmp    800cba <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cf3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cf6:	89 f3                	mov    %esi,%ebx
  800cf8:	80 fb 19             	cmp    $0x19,%bl
  800cfb:	77 24                	ja     800d21 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800cfd:	0f be d2             	movsbl %dl,%edx
  800d00:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d03:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d06:	7d 2b                	jge    800d33 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800d08:	41                   	inc    %ecx
  800d09:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d0d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d0f:	8a 11                	mov    (%ecx),%dl
  800d11:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800d14:	80 fb 09             	cmp    $0x9,%bl
  800d17:	77 da                	ja     800cf3 <strtol+0x77>
			dig = *s - '0';
  800d19:	0f be d2             	movsbl %dl,%edx
  800d1c:	83 ea 30             	sub    $0x30,%edx
  800d1f:	eb e2                	jmp    800d03 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800d21:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d24:	89 f3                	mov    %esi,%ebx
  800d26:	80 fb 19             	cmp    $0x19,%bl
  800d29:	77 08                	ja     800d33 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800d2b:	0f be d2             	movsbl %dl,%edx
  800d2e:	83 ea 37             	sub    $0x37,%edx
  800d31:	eb d0                	jmp    800d03 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d37:	74 05                	je     800d3e <strtol+0xc2>
		*endptr = (char *) s;
  800d39:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d3e:	85 ff                	test   %edi,%edi
  800d40:	74 02                	je     800d44 <strtol+0xc8>
  800d42:	f7 d8                	neg    %eax
}
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <atoi>:

int
atoi(const char *s)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800d4c:	6a 0a                	push   $0xa
  800d4e:	6a 00                	push   $0x0
  800d50:	ff 75 08             	pushl  0x8(%ebp)
  800d53:	e8 24 ff ff ff       	call   800c7c <strtol>
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d60:	b8 00 00 00 00       	mov    $0x0,%eax
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6b:	89 c3                	mov    %eax,%ebx
  800d6d:	89 c7                	mov    %eax,%edi
  800d6f:	89 c6                	mov    %eax,%esi
  800d71:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d83:	b8 01 00 00 00       	mov    $0x1,%eax
  800d88:	89 d1                	mov    %edx,%ecx
  800d8a:	89 d3                	mov    %edx,%ebx
  800d8c:	89 d7                	mov    %edx,%edi
  800d8e:	89 d6                	mov    %edx,%esi
  800d90:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5f                   	pop    %edi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da5:	b8 03 00 00 00       	mov    $0x3,%eax
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	89 cb                	mov    %ecx,%ebx
  800daf:	89 cf                	mov    %ecx,%edi
  800db1:	89 ce                	mov    %ecx,%esi
  800db3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	7f 08                	jg     800dc1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc1:	83 ec 0c             	sub    $0xc,%esp
  800dc4:	50                   	push   %eax
  800dc5:	6a 03                	push   $0x3
  800dc7:	68 4f 25 80 00       	push   $0x80254f
  800dcc:	6a 23                	push   $0x23
  800dce:	68 6c 25 80 00       	push   $0x80256c
  800dd3:	e8 fe f4 ff ff       	call   8002d6 <_panic>

00800dd8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dde:	ba 00 00 00 00       	mov    $0x0,%edx
  800de3:	b8 02 00 00 00       	mov    $0x2,%eax
  800de8:	89 d1                	mov    %edx,%ecx
  800dea:	89 d3                	mov    %edx,%ebx
  800dec:	89 d7                	mov    %edx,%edi
  800dee:	89 d6                	mov    %edx,%esi
  800df0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    

00800df7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	57                   	push   %edi
  800dfb:	56                   	push   %esi
  800dfc:	53                   	push   %ebx
  800dfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e00:	be 00 00 00 00       	mov    $0x0,%esi
  800e05:	b8 04 00 00 00       	mov    $0x4,%eax
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e13:	89 f7                	mov    %esi,%edi
  800e15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	7f 08                	jg     800e23 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	50                   	push   %eax
  800e27:	6a 04                	push   $0x4
  800e29:	68 4f 25 80 00       	push   $0x80254f
  800e2e:	6a 23                	push   $0x23
  800e30:	68 6c 25 80 00       	push   $0x80256c
  800e35:	e8 9c f4 ff ff       	call   8002d6 <_panic>

00800e3a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e43:	b8 05 00 00 00       	mov    $0x5,%eax
  800e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e51:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e54:	8b 75 18             	mov    0x18(%ebp),%esi
  800e57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	7f 08                	jg     800e65 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e65:	83 ec 0c             	sub    $0xc,%esp
  800e68:	50                   	push   %eax
  800e69:	6a 05                	push   $0x5
  800e6b:	68 4f 25 80 00       	push   $0x80254f
  800e70:	6a 23                	push   $0x23
  800e72:	68 6c 25 80 00       	push   $0x80256c
  800e77:	e8 5a f4 ff ff       	call   8002d6 <_panic>

00800e7c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8a:	b8 06 00 00 00       	mov    $0x6,%eax
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	89 df                	mov    %ebx,%edi
  800e97:	89 de                	mov    %ebx,%esi
  800e99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	7f 08                	jg     800ea7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5f                   	pop    %edi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea7:	83 ec 0c             	sub    $0xc,%esp
  800eaa:	50                   	push   %eax
  800eab:	6a 06                	push   $0x6
  800ead:	68 4f 25 80 00       	push   $0x80254f
  800eb2:	6a 23                	push   $0x23
  800eb4:	68 6c 25 80 00       	push   $0x80256c
  800eb9:	e8 18 f4 ff ff       	call   8002d6 <_panic>

00800ebe <sys_yield>:

void
sys_yield(void)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ece:	89 d1                	mov    %edx,%ecx
  800ed0:	89 d3                	mov    %edx,%ebx
  800ed2:	89 d7                	mov    %edx,%edi
  800ed4:	89 d6                	mov    %edx,%esi
  800ed6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ed8:	5b                   	pop    %ebx
  800ed9:	5e                   	pop    %esi
  800eda:	5f                   	pop    %edi
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
  800ee3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eeb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	89 df                	mov    %ebx,%edi
  800ef8:	89 de                	mov    %ebx,%esi
  800efa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efc:	85 c0                	test   %eax,%eax
  800efe:	7f 08                	jg     800f08 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f08:	83 ec 0c             	sub    $0xc,%esp
  800f0b:	50                   	push   %eax
  800f0c:	6a 08                	push   $0x8
  800f0e:	68 4f 25 80 00       	push   $0x80254f
  800f13:	6a 23                	push   $0x23
  800f15:	68 6c 25 80 00       	push   $0x80256c
  800f1a:	e8 b7 f3 ff ff       	call   8002d6 <_panic>

00800f1f <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
  800f25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f28:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f2d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	89 cb                	mov    %ecx,%ebx
  800f37:	89 cf                	mov    %ecx,%edi
  800f39:	89 ce                	mov    %ecx,%esi
  800f3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7f 08                	jg     800f49 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	50                   	push   %eax
  800f4d:	6a 0c                	push   $0xc
  800f4f:	68 4f 25 80 00       	push   $0x80254f
  800f54:	6a 23                	push   $0x23
  800f56:	68 6c 25 80 00       	push   $0x80256c
  800f5b:	e8 76 f3 ff ff       	call   8002d6 <_panic>

00800f60 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f76:	8b 55 08             	mov    0x8(%ebp),%edx
  800f79:	89 df                	mov    %ebx,%edi
  800f7b:	89 de                	mov    %ebx,%esi
  800f7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7f 08                	jg     800f8b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	50                   	push   %eax
  800f8f:	6a 09                	push   $0x9
  800f91:	68 4f 25 80 00       	push   $0x80254f
  800f96:	6a 23                	push   $0x23
  800f98:	68 6c 25 80 00       	push   $0x80256c
  800f9d:	e8 34 f3 ff ff       	call   8002d6 <_panic>

00800fa2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	7f 08                	jg     800fcd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcd:	83 ec 0c             	sub    $0xc,%esp
  800fd0:	50                   	push   %eax
  800fd1:	6a 0a                	push   $0xa
  800fd3:	68 4f 25 80 00       	push   $0x80254f
  800fd8:	6a 23                	push   $0x23
  800fda:	68 6c 25 80 00       	push   $0x80256c
  800fdf:	e8 f2 f2 ff ff       	call   8002d6 <_panic>

00800fe4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fea:	be 00 00 00 00       	mov    $0x0,%esi
  800fef:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ff4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ffd:	8b 7d 14             	mov    0x14(%ebp),%edi
  801000:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
  80100d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801010:	b9 00 00 00 00       	mov    $0x0,%ecx
  801015:	b8 0e 00 00 00       	mov    $0xe,%eax
  80101a:	8b 55 08             	mov    0x8(%ebp),%edx
  80101d:	89 cb                	mov    %ecx,%ebx
  80101f:	89 cf                	mov    %ecx,%edi
  801021:	89 ce                	mov    %ecx,%esi
  801023:	cd 30                	int    $0x30
	if(check && ret > 0)
  801025:	85 c0                	test   %eax,%eax
  801027:	7f 08                	jg     801031 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801029:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	50                   	push   %eax
  801035:	6a 0e                	push   $0xe
  801037:	68 4f 25 80 00       	push   $0x80254f
  80103c:	6a 23                	push   $0x23
  80103e:	68 6c 25 80 00       	push   $0x80256c
  801043:	e8 8e f2 ff ff       	call   8002d6 <_panic>

00801048 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	57                   	push   %edi
  80104c:	56                   	push   %esi
  80104d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104e:	be 00 00 00 00       	mov    $0x0,%esi
  801053:	b8 0f 00 00 00       	mov    $0xf,%eax
  801058:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801061:	89 f7                	mov    %esi,%edi
  801063:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801070:	be 00 00 00 00       	mov    $0x0,%esi
  801075:	b8 10 00 00 00       	mov    $0x10,%eax
  80107a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107d:	8b 55 08             	mov    0x8(%ebp),%edx
  801080:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801083:	89 f7                	mov    %esi,%edi
  801085:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801087:	5b                   	pop    %ebx
  801088:	5e                   	pop    %esi
  801089:	5f                   	pop    %edi
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    

0080108c <sys_set_console_color>:

void sys_set_console_color(int color) {
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	57                   	push   %edi
  801090:	56                   	push   %esi
  801091:	53                   	push   %ebx
	asm volatile("int %1\n"
  801092:	b9 00 00 00 00       	mov    $0x0,%ecx
  801097:	b8 11 00 00 00       	mov    $0x11,%eax
  80109c:	8b 55 08             	mov    0x8(%ebp),%edx
  80109f:	89 cb                	mov    %ecx,%ebx
  8010a1:	89 cf                	mov    %ecx,%edi
  8010a3:	89 ce                	mov    %ecx,%esi
  8010a5:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8010a7:	5b                   	pop    %ebx
  8010a8:	5e                   	pop    %esi
  8010a9:	5f                   	pop    %edi
  8010aa:	5d                   	pop    %ebp
  8010ab:	c3                   	ret    

008010ac <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	05 00 00 00 30       	add    $0x30000000,%eax
  8010b7:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010cc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010de:	89 c2                	mov    %eax,%edx
  8010e0:	c1 ea 16             	shr    $0x16,%edx
  8010e3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ea:	f6 c2 01             	test   $0x1,%dl
  8010ed:	74 2a                	je     801119 <fd_alloc+0x46>
  8010ef:	89 c2                	mov    %eax,%edx
  8010f1:	c1 ea 0c             	shr    $0xc,%edx
  8010f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010fb:	f6 c2 01             	test   $0x1,%dl
  8010fe:	74 19                	je     801119 <fd_alloc+0x46>
  801100:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801105:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80110a:	75 d2                	jne    8010de <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80110c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801112:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801117:	eb 07                	jmp    801120 <fd_alloc+0x4d>
			*fd_store = fd;
  801119:	89 01                	mov    %eax,(%ecx)
			return 0;
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801120:	5d                   	pop    %ebp
  801121:	c3                   	ret    

00801122 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801125:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801129:	77 39                	ja     801164 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	c1 e0 0c             	shl    $0xc,%eax
  801131:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801136:	89 c2                	mov    %eax,%edx
  801138:	c1 ea 16             	shr    $0x16,%edx
  80113b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801142:	f6 c2 01             	test   $0x1,%dl
  801145:	74 24                	je     80116b <fd_lookup+0x49>
  801147:	89 c2                	mov    %eax,%edx
  801149:	c1 ea 0c             	shr    $0xc,%edx
  80114c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801153:	f6 c2 01             	test   $0x1,%dl
  801156:	74 1a                	je     801172 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115b:	89 02                	mov    %eax,(%edx)
	return 0;
  80115d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    
		return -E_INVAL;
  801164:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801169:	eb f7                	jmp    801162 <fd_lookup+0x40>
		return -E_INVAL;
  80116b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801170:	eb f0                	jmp    801162 <fd_lookup+0x40>
  801172:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801177:	eb e9                	jmp    801162 <fd_lookup+0x40>

00801179 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801182:	ba f8 25 80 00       	mov    $0x8025f8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801187:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80118c:	39 08                	cmp    %ecx,(%eax)
  80118e:	74 33                	je     8011c3 <dev_lookup+0x4a>
  801190:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801193:	8b 02                	mov    (%edx),%eax
  801195:	85 c0                	test   %eax,%eax
  801197:	75 f3                	jne    80118c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801199:	a1 04 44 80 00       	mov    0x804404,%eax
  80119e:	8b 40 48             	mov    0x48(%eax),%eax
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	51                   	push   %ecx
  8011a5:	50                   	push   %eax
  8011a6:	68 7c 25 80 00       	push   $0x80257c
  8011ab:	e8 23 0c 00 00       	call   801dd3 <cprintf>
	*dev = 0;
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011b9:	83 c4 10             	add    $0x10,%esp
  8011bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    
			*dev = devtab[i];
  8011c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cd:	eb f2                	jmp    8011c1 <dev_lookup+0x48>

008011cf <fd_close>:
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 1c             	sub    $0x1c,%esp
  8011d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8011db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011eb:	50                   	push   %eax
  8011ec:	e8 31 ff ff ff       	call   801122 <fd_lookup>
  8011f1:	89 c7                	mov    %eax,%edi
  8011f3:	83 c4 08             	add    $0x8,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	78 05                	js     8011ff <fd_close+0x30>
	    || fd != fd2)
  8011fa:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8011fd:	74 13                	je     801212 <fd_close+0x43>
		return (must_exist ? r : 0);
  8011ff:	84 db                	test   %bl,%bl
  801201:	75 05                	jne    801208 <fd_close+0x39>
  801203:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801208:	89 f8                	mov    %edi,%eax
  80120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120d:	5b                   	pop    %ebx
  80120e:	5e                   	pop    %esi
  80120f:	5f                   	pop    %edi
  801210:	5d                   	pop    %ebp
  801211:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801212:	83 ec 08             	sub    $0x8,%esp
  801215:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801218:	50                   	push   %eax
  801219:	ff 36                	pushl  (%esi)
  80121b:	e8 59 ff ff ff       	call   801179 <dev_lookup>
  801220:	89 c7                	mov    %eax,%edi
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	85 c0                	test   %eax,%eax
  801227:	78 15                	js     80123e <fd_close+0x6f>
		if (dev->dev_close)
  801229:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122c:	8b 40 10             	mov    0x10(%eax),%eax
  80122f:	85 c0                	test   %eax,%eax
  801231:	74 1b                	je     80124e <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	56                   	push   %esi
  801237:	ff d0                	call   *%eax
  801239:	89 c7                	mov    %eax,%edi
  80123b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80123e:	83 ec 08             	sub    $0x8,%esp
  801241:	56                   	push   %esi
  801242:	6a 00                	push   $0x0
  801244:	e8 33 fc ff ff       	call   800e7c <sys_page_unmap>
	return r;
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	eb ba                	jmp    801208 <fd_close+0x39>
			r = 0;
  80124e:	bf 00 00 00 00       	mov    $0x0,%edi
  801253:	eb e9                	jmp    80123e <fd_close+0x6f>

00801255 <close>:

int
close(int fdnum)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80125b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 08             	pushl  0x8(%ebp)
  801262:	e8 bb fe ff ff       	call   801122 <fd_lookup>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	78 10                	js     80127e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	6a 01                	push   $0x1
  801273:	ff 75 f4             	pushl  -0xc(%ebp)
  801276:	e8 54 ff ff ff       	call   8011cf <fd_close>
  80127b:	83 c4 10             	add    $0x10,%esp
}
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <close_all>:

void
close_all(void)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	53                   	push   %ebx
  801284:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801287:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	53                   	push   %ebx
  801290:	e8 c0 ff ff ff       	call   801255 <close>
	for (i = 0; i < MAXFD; i++)
  801295:	43                   	inc    %ebx
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	83 fb 20             	cmp    $0x20,%ebx
  80129c:	75 ee                	jne    80128c <close_all+0xc>
}
  80129e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012af:	50                   	push   %eax
  8012b0:	ff 75 08             	pushl  0x8(%ebp)
  8012b3:	e8 6a fe ff ff       	call   801122 <fd_lookup>
  8012b8:	89 c3                	mov    %eax,%ebx
  8012ba:	83 c4 08             	add    $0x8,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	0f 88 81 00 00 00    	js     801346 <dup+0xa3>
		return r;
	close(newfdnum);
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 85 ff ff ff       	call   801255 <close>

	newfd = INDEX2FD(newfdnum);
  8012d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012d3:	c1 e6 0c             	shl    $0xc,%esi
  8012d6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012dc:	83 c4 04             	add    $0x4,%esp
  8012df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e2:	e8 d5 fd ff ff       	call   8010bc <fd2data>
  8012e7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012e9:	89 34 24             	mov    %esi,(%esp)
  8012ec:	e8 cb fd ff ff       	call   8010bc <fd2data>
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012f6:	89 d8                	mov    %ebx,%eax
  8012f8:	c1 e8 16             	shr    $0x16,%eax
  8012fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801302:	a8 01                	test   $0x1,%al
  801304:	74 11                	je     801317 <dup+0x74>
  801306:	89 d8                	mov    %ebx,%eax
  801308:	c1 e8 0c             	shr    $0xc,%eax
  80130b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801312:	f6 c2 01             	test   $0x1,%dl
  801315:	75 39                	jne    801350 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801317:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80131a:	89 d0                	mov    %edx,%eax
  80131c:	c1 e8 0c             	shr    $0xc,%eax
  80131f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801326:	83 ec 0c             	sub    $0xc,%esp
  801329:	25 07 0e 00 00       	and    $0xe07,%eax
  80132e:	50                   	push   %eax
  80132f:	56                   	push   %esi
  801330:	6a 00                	push   $0x0
  801332:	52                   	push   %edx
  801333:	6a 00                	push   $0x0
  801335:	e8 00 fb ff ff       	call   800e3a <sys_page_map>
  80133a:	89 c3                	mov    %eax,%ebx
  80133c:	83 c4 20             	add    $0x20,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 31                	js     801374 <dup+0xd1>
		goto err;

	return newfdnum;
  801343:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801346:	89 d8                	mov    %ebx,%eax
  801348:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134b:	5b                   	pop    %ebx
  80134c:	5e                   	pop    %esi
  80134d:	5f                   	pop    %edi
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801350:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	25 07 0e 00 00       	and    $0xe07,%eax
  80135f:	50                   	push   %eax
  801360:	57                   	push   %edi
  801361:	6a 00                	push   $0x0
  801363:	53                   	push   %ebx
  801364:	6a 00                	push   $0x0
  801366:	e8 cf fa ff ff       	call   800e3a <sys_page_map>
  80136b:	89 c3                	mov    %eax,%ebx
  80136d:	83 c4 20             	add    $0x20,%esp
  801370:	85 c0                	test   %eax,%eax
  801372:	79 a3                	jns    801317 <dup+0x74>
	sys_page_unmap(0, newfd);
  801374:	83 ec 08             	sub    $0x8,%esp
  801377:	56                   	push   %esi
  801378:	6a 00                	push   $0x0
  80137a:	e8 fd fa ff ff       	call   800e7c <sys_page_unmap>
	sys_page_unmap(0, nva);
  80137f:	83 c4 08             	add    $0x8,%esp
  801382:	57                   	push   %edi
  801383:	6a 00                	push   $0x0
  801385:	e8 f2 fa ff ff       	call   800e7c <sys_page_unmap>
	return r;
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	eb b7                	jmp    801346 <dup+0xa3>

0080138f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	53                   	push   %ebx
  801393:	83 ec 14             	sub    $0x14,%esp
  801396:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801399:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139c:	50                   	push   %eax
  80139d:	53                   	push   %ebx
  80139e:	e8 7f fd ff ff       	call   801122 <fd_lookup>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 3f                	js     8013e9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b0:	50                   	push   %eax
  8013b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b4:	ff 30                	pushl  (%eax)
  8013b6:	e8 be fd ff ff       	call   801179 <dev_lookup>
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 27                	js     8013e9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c5:	8b 42 08             	mov    0x8(%edx),%eax
  8013c8:	83 e0 03             	and    $0x3,%eax
  8013cb:	83 f8 01             	cmp    $0x1,%eax
  8013ce:	74 1e                	je     8013ee <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d3:	8b 40 08             	mov    0x8(%eax),%eax
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	74 35                	je     80140f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	ff 75 10             	pushl  0x10(%ebp)
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	52                   	push   %edx
  8013e4:	ff d0                	call   *%eax
  8013e6:	83 c4 10             	add    $0x10,%esp
}
  8013e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ee:	a1 04 44 80 00       	mov    0x804404,%eax
  8013f3:	8b 40 48             	mov    0x48(%eax),%eax
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	53                   	push   %ebx
  8013fa:	50                   	push   %eax
  8013fb:	68 bd 25 80 00       	push   $0x8025bd
  801400:	e8 ce 09 00 00       	call   801dd3 <cprintf>
		return -E_INVAL;
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140d:	eb da                	jmp    8013e9 <read+0x5a>
		return -E_NOT_SUPP;
  80140f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801414:	eb d3                	jmp    8013e9 <read+0x5a>

00801416 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	57                   	push   %edi
  80141a:	56                   	push   %esi
  80141b:	53                   	push   %ebx
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801422:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801425:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142a:	39 f3                	cmp    %esi,%ebx
  80142c:	73 25                	jae    801453 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	89 f0                	mov    %esi,%eax
  801433:	29 d8                	sub    %ebx,%eax
  801435:	50                   	push   %eax
  801436:	89 d8                	mov    %ebx,%eax
  801438:	03 45 0c             	add    0xc(%ebp),%eax
  80143b:	50                   	push   %eax
  80143c:	57                   	push   %edi
  80143d:	e8 4d ff ff ff       	call   80138f <read>
		if (m < 0)
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	78 08                	js     801451 <readn+0x3b>
			return m;
		if (m == 0)
  801449:	85 c0                	test   %eax,%eax
  80144b:	74 06                	je     801453 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80144d:	01 c3                	add    %eax,%ebx
  80144f:	eb d9                	jmp    80142a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801451:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801453:	89 d8                	mov    %ebx,%eax
  801455:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801458:	5b                   	pop    %ebx
  801459:	5e                   	pop    %esi
  80145a:	5f                   	pop    %edi
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    

0080145d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	53                   	push   %ebx
  801461:	83 ec 14             	sub    $0x14,%esp
  801464:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801467:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146a:	50                   	push   %eax
  80146b:	53                   	push   %ebx
  80146c:	e8 b1 fc ff ff       	call   801122 <fd_lookup>
  801471:	83 c4 08             	add    $0x8,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 3a                	js     8014b2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147e:	50                   	push   %eax
  80147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801482:	ff 30                	pushl  (%eax)
  801484:	e8 f0 fc ff ff       	call   801179 <dev_lookup>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 22                	js     8014b2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801497:	74 1e                	je     8014b7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149c:	8b 52 0c             	mov    0xc(%edx),%edx
  80149f:	85 d2                	test   %edx,%edx
  8014a1:	74 35                	je     8014d8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	ff 75 10             	pushl  0x10(%ebp)
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	50                   	push   %eax
  8014ad:	ff d2                	call   *%edx
  8014af:	83 c4 10             	add    $0x10,%esp
}
  8014b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b7:	a1 04 44 80 00       	mov    0x804404,%eax
  8014bc:	8b 40 48             	mov    0x48(%eax),%eax
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	53                   	push   %ebx
  8014c3:	50                   	push   %eax
  8014c4:	68 d9 25 80 00       	push   $0x8025d9
  8014c9:	e8 05 09 00 00       	call   801dd3 <cprintf>
		return -E_INVAL;
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d6:	eb da                	jmp    8014b2 <write+0x55>
		return -E_NOT_SUPP;
  8014d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014dd:	eb d3                	jmp    8014b2 <write+0x55>

008014df <seek>:

int
seek(int fdnum, off_t offset)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014e8:	50                   	push   %eax
  8014e9:	ff 75 08             	pushl  0x8(%ebp)
  8014ec:	e8 31 fc ff ff       	call   801122 <fd_lookup>
  8014f1:	83 c4 08             	add    $0x8,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	78 0e                	js     801506 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fe:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801501:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	53                   	push   %ebx
  80150c:	83 ec 14             	sub    $0x14,%esp
  80150f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801512:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	53                   	push   %ebx
  801517:	e8 06 fc ff ff       	call   801122 <fd_lookup>
  80151c:	83 c4 08             	add    $0x8,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 37                	js     80155a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801529:	50                   	push   %eax
  80152a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152d:	ff 30                	pushl  (%eax)
  80152f:	e8 45 fc ff ff       	call   801179 <dev_lookup>
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	85 c0                	test   %eax,%eax
  801539:	78 1f                	js     80155a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801542:	74 1b                	je     80155f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801547:	8b 52 18             	mov    0x18(%edx),%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	74 32                	je     801580 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80154e:	83 ec 08             	sub    $0x8,%esp
  801551:	ff 75 0c             	pushl  0xc(%ebp)
  801554:	50                   	push   %eax
  801555:	ff d2                	call   *%edx
  801557:	83 c4 10             	add    $0x10,%esp
}
  80155a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80155f:	a1 04 44 80 00       	mov    0x804404,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801564:	8b 40 48             	mov    0x48(%eax),%eax
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	53                   	push   %ebx
  80156b:	50                   	push   %eax
  80156c:	68 9c 25 80 00       	push   $0x80259c
  801571:	e8 5d 08 00 00       	call   801dd3 <cprintf>
		return -E_INVAL;
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157e:	eb da                	jmp    80155a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801580:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801585:	eb d3                	jmp    80155a <ftruncate+0x52>

00801587 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	53                   	push   %ebx
  80158b:	83 ec 14             	sub    $0x14,%esp
  80158e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801591:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801594:	50                   	push   %eax
  801595:	ff 75 08             	pushl  0x8(%ebp)
  801598:	e8 85 fb ff ff       	call   801122 <fd_lookup>
  80159d:	83 c4 08             	add    $0x8,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	78 4b                	js     8015ef <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015aa:	50                   	push   %eax
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	ff 30                	pushl  (%eax)
  8015b0:	e8 c4 fb ff ff       	call   801179 <dev_lookup>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	78 33                	js     8015ef <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015c3:	74 2f                	je     8015f4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015c5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015c8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015cf:	00 00 00 
	stat->st_type = 0;
  8015d2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015d9:	00 00 00 
	stat->st_dev = dev;
  8015dc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	53                   	push   %ebx
  8015e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015e9:	ff 50 14             	call   *0x14(%eax)
  8015ec:	83 c4 10             	add    $0x10,%esp
}
  8015ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    
		return -E_NOT_SUPP;
  8015f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f9:	eb f4                	jmp    8015ef <fstat+0x68>

008015fb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	56                   	push   %esi
  8015ff:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	6a 00                	push   $0x0
  801605:	ff 75 08             	pushl  0x8(%ebp)
  801608:	e8 34 02 00 00       	call   801841 <open>
  80160d:	89 c3                	mov    %eax,%ebx
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	85 c0                	test   %eax,%eax
  801614:	78 1b                	js     801631 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	50                   	push   %eax
  80161d:	e8 65 ff ff ff       	call   801587 <fstat>
  801622:	89 c6                	mov    %eax,%esi
	close(fd);
  801624:	89 1c 24             	mov    %ebx,(%esp)
  801627:	e8 29 fc ff ff       	call   801255 <close>
	return r;
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	89 f3                	mov    %esi,%ebx
}
  801631:	89 d8                	mov    %ebx,%eax
  801633:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801636:	5b                   	pop    %ebx
  801637:	5e                   	pop    %esi
  801638:	5d                   	pop    %ebp
  801639:	c3                   	ret    

0080163a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	56                   	push   %esi
  80163e:	53                   	push   %ebx
  80163f:	89 c6                	mov    %eax,%esi
  801641:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801643:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  80164a:	74 27                	je     801673 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80164c:	6a 07                	push   $0x7
  80164e:	68 00 50 80 00       	push   $0x805000
  801653:	56                   	push   %esi
  801654:	ff 35 00 44 80 00    	pushl  0x804400
  80165a:	e8 11 08 00 00       	call   801e70 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80165f:	83 c4 0c             	add    $0xc,%esp
  801662:	6a 00                	push   $0x0
  801664:	53                   	push   %ebx
  801665:	6a 00                	push   $0x0
  801667:	e8 7b 07 00 00       	call   801de7 <ipc_recv>
}
  80166c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801673:	83 ec 0c             	sub    $0xc,%esp
  801676:	6a 01                	push   $0x1
  801678:	e8 4f 08 00 00       	call   801ecc <ipc_find_env>
  80167d:	a3 00 44 80 00       	mov    %eax,0x804400
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	eb c5                	jmp    80164c <fsipc+0x12>

00801687 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8b 40 0c             	mov    0xc(%eax),%eax
  801693:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a5:	b8 02 00 00 00       	mov    $0x2,%eax
  8016aa:	e8 8b ff ff ff       	call   80163a <fsipc>
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <devfile_flush>:
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c7:	b8 06 00 00 00       	mov    $0x6,%eax
  8016cc:	e8 69 ff ff ff       	call   80163a <fsipc>
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <devfile_stat>:
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	53                   	push   %ebx
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ed:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f2:	e8 43 ff ff ff       	call   80163a <fsipc>
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	78 2c                	js     801727 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016fb:	83 ec 08             	sub    $0x8,%esp
  8016fe:	68 00 50 80 00       	push   $0x805000
  801703:	53                   	push   %ebx
  801704:	e8 39 f3 ff ff       	call   800a42 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801709:	a1 80 50 80 00       	mov    0x805080,%eax
  80170e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801714:	a1 84 50 80 00       	mov    0x805084,%eax
  801719:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801727:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <devfile_write>:
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	53                   	push   %ebx
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801736:	89 d8                	mov    %ebx,%eax
  801738:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80173e:	76 05                	jbe    801745 <devfile_write+0x19>
  801740:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801745:	8b 55 08             	mov    0x8(%ebp),%edx
  801748:	8b 52 0c             	mov    0xc(%edx),%edx
  80174b:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801751:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	50                   	push   %eax
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	68 08 50 80 00       	push   $0x805008
  801762:	e8 4e f4 ff ff       	call   800bb5 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801767:	ba 00 00 00 00       	mov    $0x0,%edx
  80176c:	b8 04 00 00 00       	mov    $0x4,%eax
  801771:	e8 c4 fe ff ff       	call   80163a <fsipc>
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	85 c0                	test   %eax,%eax
  80177b:	78 0b                	js     801788 <devfile_write+0x5c>
	assert(r <= n);
  80177d:	39 c3                	cmp    %eax,%ebx
  80177f:	72 0c                	jb     80178d <devfile_write+0x61>
	assert(r <= PGSIZE);
  801781:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801786:	7f 1e                	jg     8017a6 <devfile_write+0x7a>
}
  801788:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    
	assert(r <= n);
  80178d:	68 08 26 80 00       	push   $0x802608
  801792:	68 0f 26 80 00       	push   $0x80260f
  801797:	68 98 00 00 00       	push   $0x98
  80179c:	68 24 26 80 00       	push   $0x802624
  8017a1:	e8 30 eb ff ff       	call   8002d6 <_panic>
	assert(r <= PGSIZE);
  8017a6:	68 2f 26 80 00       	push   $0x80262f
  8017ab:	68 0f 26 80 00       	push   $0x80260f
  8017b0:	68 99 00 00 00       	push   $0x99
  8017b5:	68 24 26 80 00       	push   $0x802624
  8017ba:	e8 17 eb ff ff       	call   8002d6 <_panic>

008017bf <devfile_read>:
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
  8017c4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017d2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017dd:	b8 03 00 00 00       	mov    $0x3,%eax
  8017e2:	e8 53 fe ff ff       	call   80163a <fsipc>
  8017e7:	89 c3                	mov    %eax,%ebx
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	78 1f                	js     80180c <devfile_read+0x4d>
	assert(r <= n);
  8017ed:	39 c6                	cmp    %eax,%esi
  8017ef:	72 24                	jb     801815 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017f1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f6:	7f 33                	jg     80182b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	50                   	push   %eax
  8017fc:	68 00 50 80 00       	push   $0x805000
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	e8 ac f3 ff ff       	call   800bb5 <memmove>
	return r;
  801809:	83 c4 10             	add    $0x10,%esp
}
  80180c:	89 d8                	mov    %ebx,%eax
  80180e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801811:	5b                   	pop    %ebx
  801812:	5e                   	pop    %esi
  801813:	5d                   	pop    %ebp
  801814:	c3                   	ret    
	assert(r <= n);
  801815:	68 08 26 80 00       	push   $0x802608
  80181a:	68 0f 26 80 00       	push   $0x80260f
  80181f:	6a 7c                	push   $0x7c
  801821:	68 24 26 80 00       	push   $0x802624
  801826:	e8 ab ea ff ff       	call   8002d6 <_panic>
	assert(r <= PGSIZE);
  80182b:	68 2f 26 80 00       	push   $0x80262f
  801830:	68 0f 26 80 00       	push   $0x80260f
  801835:	6a 7d                	push   $0x7d
  801837:	68 24 26 80 00       	push   $0x802624
  80183c:	e8 95 ea ff ff       	call   8002d6 <_panic>

00801841 <open>:
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	56                   	push   %esi
  801845:	53                   	push   %ebx
  801846:	83 ec 1c             	sub    $0x1c,%esp
  801849:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80184c:	56                   	push   %esi
  80184d:	e8 bd f1 ff ff       	call   800a0f <strlen>
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80185a:	7f 6c                	jg     8018c8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80185c:	83 ec 0c             	sub    $0xc,%esp
  80185f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801862:	50                   	push   %eax
  801863:	e8 6b f8 ff ff       	call   8010d3 <fd_alloc>
  801868:	89 c3                	mov    %eax,%ebx
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 3c                	js     8018ad <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	56                   	push   %esi
  801875:	68 00 50 80 00       	push   $0x805000
  80187a:	e8 c3 f1 ff ff       	call   800a42 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80187f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801882:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801887:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188a:	b8 01 00 00 00       	mov    $0x1,%eax
  80188f:	e8 a6 fd ff ff       	call   80163a <fsipc>
  801894:	89 c3                	mov    %eax,%ebx
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	85 c0                	test   %eax,%eax
  80189b:	78 19                	js     8018b6 <open+0x75>
	return fd2num(fd);
  80189d:	83 ec 0c             	sub    $0xc,%esp
  8018a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a3:	e8 04 f8 ff ff       	call   8010ac <fd2num>
  8018a8:	89 c3                	mov    %eax,%ebx
  8018aa:	83 c4 10             	add    $0x10,%esp
}
  8018ad:	89 d8                	mov    %ebx,%eax
  8018af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    
		fd_close(fd, 0);
  8018b6:	83 ec 08             	sub    $0x8,%esp
  8018b9:	6a 00                	push   $0x0
  8018bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018be:	e8 0c f9 ff ff       	call   8011cf <fd_close>
		return r;
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	eb e5                	jmp    8018ad <open+0x6c>
		return -E_BAD_PATH;
  8018c8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018cd:	eb de                	jmp    8018ad <open+0x6c>

008018cf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018da:	b8 08 00 00 00       	mov    $0x8,%eax
  8018df:	e8 56 fd ff ff       	call   80163a <fsipc>
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8018e6:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8018ea:	7e 38                	jle    801924 <writebuf+0x3e>
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8018f5:	ff 70 04             	pushl  0x4(%eax)
  8018f8:	8d 40 10             	lea    0x10(%eax),%eax
  8018fb:	50                   	push   %eax
  8018fc:	ff 33                	pushl  (%ebx)
  8018fe:	e8 5a fb ff ff       	call   80145d <write>
		if (result > 0)
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	85 c0                	test   %eax,%eax
  801908:	7e 03                	jle    80190d <writebuf+0x27>
			b->result += result;
  80190a:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80190d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801910:	74 0e                	je     801920 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801912:	89 c2                	mov    %eax,%edx
  801914:	85 c0                	test   %eax,%eax
  801916:	7e 05                	jle    80191d <writebuf+0x37>
  801918:	ba 00 00 00 00       	mov    $0x0,%edx
  80191d:	89 53 0c             	mov    %edx,0xc(%ebx)
	}
}
  801920:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <putch>:

static void
putch(int ch, void *thunk)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	53                   	push   %ebx
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80192f:	8b 53 04             	mov    0x4(%ebx),%edx
  801932:	8d 42 01             	lea    0x1(%edx),%eax
  801935:	89 43 04             	mov    %eax,0x4(%ebx)
  801938:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193b:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80193f:	3d 00 01 00 00       	cmp    $0x100,%eax
  801944:	74 06                	je     80194c <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801946:	83 c4 04             	add    $0x4,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    
		writebuf(b);
  80194c:	89 d8                	mov    %ebx,%eax
  80194e:	e8 93 ff ff ff       	call   8018e6 <writebuf>
		b->idx = 0;
  801953:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80195a:	eb ea                	jmp    801946 <putch+0x21>

0080195c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80196e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801975:	00 00 00 
	b.result = 0;
  801978:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80197f:	00 00 00 
	b.error = 1;
  801982:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801989:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80198c:	ff 75 10             	pushl  0x10(%ebp)
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801998:	50                   	push   %eax
  801999:	68 25 19 80 00       	push   $0x801925
  80199e:	e8 98 ea ff ff       	call   80043b <vprintfmt>
	if (b.idx > 0)
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019ad:	7e 0b                	jle    8019ba <vfprintf+0x5e>
		writebuf(&b);
  8019af:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019b5:	e8 2c ff ff ff       	call   8018e6 <writebuf>

	return (b.result ? b.result : b.error);
  8019ba:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	75 06                	jne    8019ca <vfprintf+0x6e>
  8019c4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019d2:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8019d5:	50                   	push   %eax
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	ff 75 08             	pushl  0x8(%ebp)
  8019dc:	e8 7b ff ff ff       	call   80195c <vfprintf>
	va_end(ap);

	return cnt;
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <printf>:

int
printf(const char *fmt, ...)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019e9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8019ec:	50                   	push   %eax
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	6a 01                	push   $0x1
  8019f2:	e8 65 ff ff ff       	call   80195c <vfprintf>
	va_end(ap);

	return cnt;
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	56                   	push   %esi
  8019fd:	53                   	push   %ebx
  8019fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a01:	83 ec 0c             	sub    $0xc,%esp
  801a04:	ff 75 08             	pushl  0x8(%ebp)
  801a07:	e8 b0 f6 ff ff       	call   8010bc <fd2data>
  801a0c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a0e:	83 c4 08             	add    $0x8,%esp
  801a11:	68 3b 26 80 00       	push   $0x80263b
  801a16:	53                   	push   %ebx
  801a17:	e8 26 f0 ff ff       	call   800a42 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a1c:	8b 46 04             	mov    0x4(%esi),%eax
  801a1f:	2b 06                	sub    (%esi),%eax
  801a21:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801a27:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801a2e:	10 00 00 
	stat->st_dev = &devpipe;
  801a31:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801a38:	30 80 00 
	return 0;
}
  801a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	53                   	push   %ebx
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a51:	53                   	push   %ebx
  801a52:	6a 00                	push   $0x0
  801a54:	e8 23 f4 ff ff       	call   800e7c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a59:	89 1c 24             	mov    %ebx,(%esp)
  801a5c:	e8 5b f6 ff ff       	call   8010bc <fd2data>
  801a61:	83 c4 08             	add    $0x8,%esp
  801a64:	50                   	push   %eax
  801a65:	6a 00                	push   $0x0
  801a67:	e8 10 f4 ff ff       	call   800e7c <sys_page_unmap>
}
  801a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <_pipeisclosed>:
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	57                   	push   %edi
  801a75:	56                   	push   %esi
  801a76:	53                   	push   %ebx
  801a77:	83 ec 1c             	sub    $0x1c,%esp
  801a7a:	89 c7                	mov    %eax,%edi
  801a7c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a7e:	a1 04 44 80 00       	mov    0x804404,%eax
  801a83:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a86:	83 ec 0c             	sub    $0xc,%esp
  801a89:	57                   	push   %edi
  801a8a:	e8 7f 04 00 00       	call   801f0e <pageref>
  801a8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a92:	89 34 24             	mov    %esi,(%esp)
  801a95:	e8 74 04 00 00       	call   801f0e <pageref>
		nn = thisenv->env_runs;
  801a9a:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801aa0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	39 cb                	cmp    %ecx,%ebx
  801aa8:	74 1b                	je     801ac5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801aaa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aad:	75 cf                	jne    801a7e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801aaf:	8b 42 58             	mov    0x58(%edx),%eax
  801ab2:	6a 01                	push   $0x1
  801ab4:	50                   	push   %eax
  801ab5:	53                   	push   %ebx
  801ab6:	68 42 26 80 00       	push   $0x802642
  801abb:	e8 13 03 00 00       	call   801dd3 <cprintf>
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	eb b9                	jmp    801a7e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ac5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ac8:	0f 94 c0             	sete   %al
  801acb:	0f b6 c0             	movzbl %al,%eax
}
  801ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5f                   	pop    %edi
  801ad4:	5d                   	pop    %ebp
  801ad5:	c3                   	ret    

00801ad6 <devpipe_write>:
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	57                   	push   %edi
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
  801adc:	83 ec 18             	sub    $0x18,%esp
  801adf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ae2:	56                   	push   %esi
  801ae3:	e8 d4 f5 ff ff       	call   8010bc <fd2data>
  801ae8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	bf 00 00 00 00       	mov    $0x0,%edi
  801af2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801af5:	74 41                	je     801b38 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801af7:	8b 53 04             	mov    0x4(%ebx),%edx
  801afa:	8b 03                	mov    (%ebx),%eax
  801afc:	83 c0 20             	add    $0x20,%eax
  801aff:	39 c2                	cmp    %eax,%edx
  801b01:	72 14                	jb     801b17 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b03:	89 da                	mov    %ebx,%edx
  801b05:	89 f0                	mov    %esi,%eax
  801b07:	e8 65 ff ff ff       	call   801a71 <_pipeisclosed>
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	75 2c                	jne    801b3c <devpipe_write+0x66>
			sys_yield();
  801b10:	e8 a9 f3 ff ff       	call   800ebe <sys_yield>
  801b15:	eb e0                	jmp    801af7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1a:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801b24:	78 0b                	js     801b31 <devpipe_write+0x5b>
  801b26:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801b2a:	42                   	inc    %edx
  801b2b:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b2e:	47                   	inc    %edi
  801b2f:	eb c1                	jmp    801af2 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b31:	48                   	dec    %eax
  801b32:	83 c8 e0             	or     $0xffffffe0,%eax
  801b35:	40                   	inc    %eax
  801b36:	eb ee                	jmp    801b26 <devpipe_write+0x50>
	return i;
  801b38:	89 f8                	mov    %edi,%eax
  801b3a:	eb 05                	jmp    801b41 <devpipe_write+0x6b>
				return 0;
  801b3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b44:	5b                   	pop    %ebx
  801b45:	5e                   	pop    %esi
  801b46:	5f                   	pop    %edi
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    

00801b49 <devpipe_read>:
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	57                   	push   %edi
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
  801b4f:	83 ec 18             	sub    $0x18,%esp
  801b52:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b55:	57                   	push   %edi
  801b56:	e8 61 f5 ff ff       	call   8010bc <fd2data>
  801b5b:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b65:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b68:	74 46                	je     801bb0 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801b6a:	8b 06                	mov    (%esi),%eax
  801b6c:	3b 46 04             	cmp    0x4(%esi),%eax
  801b6f:	75 22                	jne    801b93 <devpipe_read+0x4a>
			if (i > 0)
  801b71:	85 db                	test   %ebx,%ebx
  801b73:	74 0a                	je     801b7f <devpipe_read+0x36>
				return i;
  801b75:	89 d8                	mov    %ebx,%eax
}
  801b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5f                   	pop    %edi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801b7f:	89 f2                	mov    %esi,%edx
  801b81:	89 f8                	mov    %edi,%eax
  801b83:	e8 e9 fe ff ff       	call   801a71 <_pipeisclosed>
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	75 28                	jne    801bb4 <devpipe_read+0x6b>
			sys_yield();
  801b8c:	e8 2d f3 ff ff       	call   800ebe <sys_yield>
  801b91:	eb d7                	jmp    801b6a <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b93:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801b98:	78 0f                	js     801ba9 <devpipe_read+0x60>
  801b9a:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801b9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ba1:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801ba4:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801ba6:	43                   	inc    %ebx
  801ba7:	eb bc                	jmp    801b65 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ba9:	48                   	dec    %eax
  801baa:	83 c8 e0             	or     $0xffffffe0,%eax
  801bad:	40                   	inc    %eax
  801bae:	eb ea                	jmp    801b9a <devpipe_read+0x51>
	return i;
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	eb c3                	jmp    801b77 <devpipe_read+0x2e>
				return 0;
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb9:	eb bc                	jmp    801b77 <devpipe_read+0x2e>

00801bbb <pipe>:
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc6:	50                   	push   %eax
  801bc7:	e8 07 f5 ff ff       	call   8010d3 <fd_alloc>
  801bcc:	89 c3                	mov    %eax,%ebx
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	0f 88 2a 01 00 00    	js     801d03 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 07 04 00 00       	push   $0x407
  801be1:	ff 75 f4             	pushl  -0xc(%ebp)
  801be4:	6a 00                	push   $0x0
  801be6:	e8 0c f2 ff ff       	call   800df7 <sys_page_alloc>
  801beb:	89 c3                	mov    %eax,%ebx
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	0f 88 0b 01 00 00    	js     801d03 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfe:	50                   	push   %eax
  801bff:	e8 cf f4 ff ff       	call   8010d3 <fd_alloc>
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	0f 88 e2 00 00 00    	js     801cf3 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	68 07 04 00 00       	push   $0x407
  801c19:	ff 75 f0             	pushl  -0x10(%ebp)
  801c1c:	6a 00                	push   $0x0
  801c1e:	e8 d4 f1 ff ff       	call   800df7 <sys_page_alloc>
  801c23:	89 c3                	mov    %eax,%ebx
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	0f 88 c3 00 00 00    	js     801cf3 <pipe+0x138>
	va = fd2data(fd0);
  801c30:	83 ec 0c             	sub    $0xc,%esp
  801c33:	ff 75 f4             	pushl  -0xc(%ebp)
  801c36:	e8 81 f4 ff ff       	call   8010bc <fd2data>
  801c3b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c3d:	83 c4 0c             	add    $0xc,%esp
  801c40:	68 07 04 00 00       	push   $0x407
  801c45:	50                   	push   %eax
  801c46:	6a 00                	push   $0x0
  801c48:	e8 aa f1 ff ff       	call   800df7 <sys_page_alloc>
  801c4d:	89 c3                	mov    %eax,%ebx
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	85 c0                	test   %eax,%eax
  801c54:	0f 88 89 00 00 00    	js     801ce3 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5a:	83 ec 0c             	sub    $0xc,%esp
  801c5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c60:	e8 57 f4 ff ff       	call   8010bc <fd2data>
  801c65:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c6c:	50                   	push   %eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	56                   	push   %esi
  801c70:	6a 00                	push   $0x0
  801c72:	e8 c3 f1 ff ff       	call   800e3a <sys_page_map>
  801c77:	89 c3                	mov    %eax,%ebx
  801c79:	83 c4 20             	add    $0x20,%esp
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 55                	js     801cd5 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801c80:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c89:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c95:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb0:	e8 f7 f3 ff ff       	call   8010ac <fd2num>
  801cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cba:	83 c4 04             	add    $0x4,%esp
  801cbd:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc0:	e8 e7 f3 ff ff       	call   8010ac <fd2num>
  801cc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cd3:	eb 2e                	jmp    801d03 <pipe+0x148>
	sys_page_unmap(0, va);
  801cd5:	83 ec 08             	sub    $0x8,%esp
  801cd8:	56                   	push   %esi
  801cd9:	6a 00                	push   $0x0
  801cdb:	e8 9c f1 ff ff       	call   800e7c <sys_page_unmap>
  801ce0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ce3:	83 ec 08             	sub    $0x8,%esp
  801ce6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce9:	6a 00                	push   $0x0
  801ceb:	e8 8c f1 ff ff       	call   800e7c <sys_page_unmap>
  801cf0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801cf3:	83 ec 08             	sub    $0x8,%esp
  801cf6:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf9:	6a 00                	push   $0x0
  801cfb:	e8 7c f1 ff ff       	call   800e7c <sys_page_unmap>
  801d00:	83 c4 10             	add    $0x10,%esp
}
  801d03:	89 d8                	mov    %ebx,%eax
  801d05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d08:	5b                   	pop    %ebx
  801d09:	5e                   	pop    %esi
  801d0a:	5d                   	pop    %ebp
  801d0b:	c3                   	ret    

00801d0c <pipeisclosed>:
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d15:	50                   	push   %eax
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	e8 04 f4 ff ff       	call   801122 <fd_lookup>
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	85 c0                	test   %eax,%eax
  801d23:	78 18                	js     801d3d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d25:	83 ec 0c             	sub    $0xc,%esp
  801d28:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2b:	e8 8c f3 ff ff       	call   8010bc <fd2data>
	return _pipeisclosed(fd, p);
  801d30:	89 c2                	mov    %eax,%edx
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	e8 37 fd ff ff       	call   801a71 <_pipeisclosed>
  801d3a:	83 c4 10             	add    $0x10,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	53                   	push   %ebx
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801d49:	8b 13                	mov    (%ebx),%edx
  801d4b:	8d 42 01             	lea    0x1(%edx),%eax
  801d4e:	89 03                	mov    %eax,(%ebx)
  801d50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d53:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801d57:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d5c:	74 08                	je     801d66 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801d5e:	ff 43 04             	incl   0x4(%ebx)
}
  801d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801d66:	83 ec 08             	sub    $0x8,%esp
  801d69:	68 ff 00 00 00       	push   $0xff
  801d6e:	8d 43 08             	lea    0x8(%ebx),%eax
  801d71:	50                   	push   %eax
  801d72:	e8 e3 ef ff ff       	call   800d5a <sys_cputs>
		b->idx = 0;
  801d77:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	eb dc                	jmp    801d5e <putch+0x1f>

00801d82 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801d8b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d92:	00 00 00 
	b.cnt = 0;
  801d95:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d9c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d9f:	ff 75 0c             	pushl  0xc(%ebp)
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801dab:	50                   	push   %eax
  801dac:	68 3f 1d 80 00       	push   $0x801d3f
  801db1:	e8 85 e6 ff ff       	call   80043b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801db6:	83 c4 08             	add    $0x8,%esp
  801db9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801dbf:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801dc5:	50                   	push   %eax
  801dc6:	e8 8f ef ff ff       	call   800d5a <sys_cputs>

	return b.cnt;
}
  801dcb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801dd9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801ddc:	50                   	push   %eax
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	e8 9d ff ff ff       	call   801d82 <vcprintf>
	va_end(ap);

	return cnt;
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	57                   	push   %edi
  801deb:	56                   	push   %esi
  801dec:	53                   	push   %ebx
  801ded:	83 ec 0c             	sub    $0xc,%esp
  801df0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801df3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801df6:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801df9:	85 ff                	test   %edi,%edi
  801dfb:	74 53                	je     801e50 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	57                   	push   %edi
  801e01:	e8 01 f2 ff ff       	call   801007 <sys_ipc_recv>
  801e06:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801e09:	85 db                	test   %ebx,%ebx
  801e0b:	74 0b                	je     801e18 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801e0d:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801e13:	8b 52 74             	mov    0x74(%edx),%edx
  801e16:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801e18:	85 f6                	test   %esi,%esi
  801e1a:	74 0f                	je     801e2b <ipc_recv+0x44>
  801e1c:	85 ff                	test   %edi,%edi
  801e1e:	74 0b                	je     801e2b <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801e20:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801e26:	8b 52 78             	mov    0x78(%edx),%edx
  801e29:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	74 30                	je     801e5f <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801e2f:	85 db                	test   %ebx,%ebx
  801e31:	74 06                	je     801e39 <ipc_recv+0x52>
      		*from_env_store = 0;
  801e33:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801e39:	85 f6                	test   %esi,%esi
  801e3b:	74 2c                	je     801e69 <ipc_recv+0x82>
      		*perm_store = 0;
  801e3d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801e43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4b:	5b                   	pop    %ebx
  801e4c:	5e                   	pop    %esi
  801e4d:	5f                   	pop    %edi
  801e4e:	5d                   	pop    %ebp
  801e4f:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	6a ff                	push   $0xffffffff
  801e55:	e8 ad f1 ff ff       	call   801007 <sys_ipc_recv>
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	eb aa                	jmp    801e09 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801e5f:	a1 04 44 80 00       	mov    0x804404,%eax
  801e64:	8b 40 70             	mov    0x70(%eax),%eax
  801e67:	eb df                	jmp    801e48 <ipc_recv+0x61>
		return -1;
  801e69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e6e:	eb d8                	jmp    801e48 <ipc_recv+0x61>

00801e70 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	57                   	push   %edi
  801e74:	56                   	push   %esi
  801e75:	53                   	push   %ebx
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e7f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801e82:	85 db                	test   %ebx,%ebx
  801e84:	75 22                	jne    801ea8 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801e86:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801e8b:	eb 1b                	jmp    801ea8 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801e8d:	68 5c 26 80 00       	push   $0x80265c
  801e92:	68 0f 26 80 00       	push   $0x80260f
  801e97:	6a 48                	push   $0x48
  801e99:	68 80 26 80 00       	push   $0x802680
  801e9e:	e8 33 e4 ff ff       	call   8002d6 <_panic>
		sys_yield();
  801ea3:	e8 16 f0 ff ff       	call   800ebe <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801ea8:	57                   	push   %edi
  801ea9:	53                   	push   %ebx
  801eaa:	56                   	push   %esi
  801eab:	ff 75 08             	pushl  0x8(%ebp)
  801eae:	e8 31 f1 ff ff       	call   800fe4 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801eb9:	74 e8                	je     801ea3 <ipc_send+0x33>
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	75 ce                	jne    801e8d <ipc_send+0x1d>
		sys_yield();
  801ebf:	e8 fa ef ff ff       	call   800ebe <sys_yield>
		
	}
	
}
  801ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec7:	5b                   	pop    %ebx
  801ec8:	5e                   	pop    %esi
  801ec9:	5f                   	pop    %edi
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    

00801ecc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ed7:	89 c2                	mov    %eax,%edx
  801ed9:	c1 e2 05             	shl    $0x5,%edx
  801edc:	29 c2                	sub    %eax,%edx
  801ede:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801ee5:	8b 52 50             	mov    0x50(%edx),%edx
  801ee8:	39 ca                	cmp    %ecx,%edx
  801eea:	74 0f                	je     801efb <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801eec:	40                   	inc    %eax
  801eed:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ef2:	75 e3                	jne    801ed7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef9:	eb 11                	jmp    801f0c <ipc_find_env+0x40>
			return envs[i].env_id;
  801efb:	89 c2                	mov    %eax,%edx
  801efd:	c1 e2 05             	shl    $0x5,%edx
  801f00:	29 c2                	sub    %eax,%edx
  801f02:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801f09:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    

00801f0e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	c1 e8 16             	shr    $0x16,%eax
  801f17:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f1e:	a8 01                	test   $0x1,%al
  801f20:	74 21                	je     801f43 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	c1 e8 0c             	shr    $0xc,%eax
  801f28:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801f2f:	a8 01                	test   $0x1,%al
  801f31:	74 17                	je     801f4a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f33:	c1 e8 0c             	shr    $0xc,%eax
  801f36:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801f3d:	ef 
  801f3e:	0f b7 c0             	movzwl %ax,%eax
  801f41:	eb 05                	jmp    801f48 <pageref+0x3a>
		return 0;
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    
		return 0;
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4f:	eb f7                	jmp    801f48 <pageref+0x3a>
  801f51:	66 90                	xchg   %ax,%ax
  801f53:	90                   	nop

00801f54 <__udivdi3>:
  801f54:	55                   	push   %ebp
  801f55:	57                   	push   %edi
  801f56:	56                   	push   %esi
  801f57:	53                   	push   %ebx
  801f58:	83 ec 1c             	sub    $0x1c,%esp
  801f5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f67:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f6b:	89 ca                	mov    %ecx,%edx
  801f6d:	89 f8                	mov    %edi,%eax
  801f6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f73:	85 f6                	test   %esi,%esi
  801f75:	75 2d                	jne    801fa4 <__udivdi3+0x50>
  801f77:	39 cf                	cmp    %ecx,%edi
  801f79:	77 65                	ja     801fe0 <__udivdi3+0x8c>
  801f7b:	89 fd                	mov    %edi,%ebp
  801f7d:	85 ff                	test   %edi,%edi
  801f7f:	75 0b                	jne    801f8c <__udivdi3+0x38>
  801f81:	b8 01 00 00 00       	mov    $0x1,%eax
  801f86:	31 d2                	xor    %edx,%edx
  801f88:	f7 f7                	div    %edi
  801f8a:	89 c5                	mov    %eax,%ebp
  801f8c:	31 d2                	xor    %edx,%edx
  801f8e:	89 c8                	mov    %ecx,%eax
  801f90:	f7 f5                	div    %ebp
  801f92:	89 c1                	mov    %eax,%ecx
  801f94:	89 d8                	mov    %ebx,%eax
  801f96:	f7 f5                	div    %ebp
  801f98:	89 cf                	mov    %ecx,%edi
  801f9a:	89 fa                	mov    %edi,%edx
  801f9c:	83 c4 1c             	add    $0x1c,%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    
  801fa4:	39 ce                	cmp    %ecx,%esi
  801fa6:	77 28                	ja     801fd0 <__udivdi3+0x7c>
  801fa8:	0f bd fe             	bsr    %esi,%edi
  801fab:	83 f7 1f             	xor    $0x1f,%edi
  801fae:	75 40                	jne    801ff0 <__udivdi3+0x9c>
  801fb0:	39 ce                	cmp    %ecx,%esi
  801fb2:	72 0a                	jb     801fbe <__udivdi3+0x6a>
  801fb4:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801fb8:	0f 87 9e 00 00 00    	ja     80205c <__udivdi3+0x108>
  801fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc3:	89 fa                	mov    %edi,%edx
  801fc5:	83 c4 1c             	add    $0x1c,%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5f                   	pop    %edi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    
  801fcd:	8d 76 00             	lea    0x0(%esi),%esi
  801fd0:	31 ff                	xor    %edi,%edi
  801fd2:	31 c0                	xor    %eax,%eax
  801fd4:	89 fa                	mov    %edi,%edx
  801fd6:	83 c4 1c             	add    $0x1c,%esp
  801fd9:	5b                   	pop    %ebx
  801fda:	5e                   	pop    %esi
  801fdb:	5f                   	pop    %edi
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    
  801fde:	66 90                	xchg   %ax,%ax
  801fe0:	89 d8                	mov    %ebx,%eax
  801fe2:	f7 f7                	div    %edi
  801fe4:	31 ff                	xor    %edi,%edi
  801fe6:	89 fa                	mov    %edi,%edx
  801fe8:	83 c4 1c             	add    $0x1c,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5f                   	pop    %edi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    
  801ff0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ff5:	29 fd                	sub    %edi,%ebp
  801ff7:	89 f9                	mov    %edi,%ecx
  801ff9:	d3 e6                	shl    %cl,%esi
  801ffb:	89 c3                	mov    %eax,%ebx
  801ffd:	89 e9                	mov    %ebp,%ecx
  801fff:	d3 eb                	shr    %cl,%ebx
  802001:	89 d9                	mov    %ebx,%ecx
  802003:	09 f1                	or     %esi,%ecx
  802005:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802009:	89 f9                	mov    %edi,%ecx
  80200b:	d3 e0                	shl    %cl,%eax
  80200d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802011:	89 d6                	mov    %edx,%esi
  802013:	89 e9                	mov    %ebp,%ecx
  802015:	d3 ee                	shr    %cl,%esi
  802017:	89 f9                	mov    %edi,%ecx
  802019:	d3 e2                	shl    %cl,%edx
  80201b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80201f:	89 e9                	mov    %ebp,%ecx
  802021:	d3 eb                	shr    %cl,%ebx
  802023:	09 da                	or     %ebx,%edx
  802025:	89 d0                	mov    %edx,%eax
  802027:	89 f2                	mov    %esi,%edx
  802029:	f7 74 24 08          	divl   0x8(%esp)
  80202d:	89 d6                	mov    %edx,%esi
  80202f:	89 c3                	mov    %eax,%ebx
  802031:	f7 64 24 0c          	mull   0xc(%esp)
  802035:	39 d6                	cmp    %edx,%esi
  802037:	72 17                	jb     802050 <__udivdi3+0xfc>
  802039:	74 09                	je     802044 <__udivdi3+0xf0>
  80203b:	89 d8                	mov    %ebx,%eax
  80203d:	31 ff                	xor    %edi,%edi
  80203f:	e9 56 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  802044:	8b 54 24 04          	mov    0x4(%esp),%edx
  802048:	89 f9                	mov    %edi,%ecx
  80204a:	d3 e2                	shl    %cl,%edx
  80204c:	39 c2                	cmp    %eax,%edx
  80204e:	73 eb                	jae    80203b <__udivdi3+0xe7>
  802050:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802053:	31 ff                	xor    %edi,%edi
  802055:	e9 40 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	31 c0                	xor    %eax,%eax
  80205e:	e9 37 ff ff ff       	jmp    801f9a <__udivdi3+0x46>
  802063:	90                   	nop

00802064 <__umoddi3>:
  802064:	55                   	push   %ebp
  802065:	57                   	push   %edi
  802066:	56                   	push   %esi
  802067:	53                   	push   %ebx
  802068:	83 ec 1c             	sub    $0x1c,%esp
  80206b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80206f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802077:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80207b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80207f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802083:	89 3c 24             	mov    %edi,(%esp)
  802086:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80208a:	89 f2                	mov    %esi,%edx
  80208c:	85 c0                	test   %eax,%eax
  80208e:	75 18                	jne    8020a8 <__umoddi3+0x44>
  802090:	39 f7                	cmp    %esi,%edi
  802092:	0f 86 a0 00 00 00    	jbe    802138 <__umoddi3+0xd4>
  802098:	89 c8                	mov    %ecx,%eax
  80209a:	f7 f7                	div    %edi
  80209c:	89 d0                	mov    %edx,%eax
  80209e:	31 d2                	xor    %edx,%edx
  8020a0:	83 c4 1c             	add    $0x1c,%esp
  8020a3:	5b                   	pop    %ebx
  8020a4:	5e                   	pop    %esi
  8020a5:	5f                   	pop    %edi
  8020a6:	5d                   	pop    %ebp
  8020a7:	c3                   	ret    
  8020a8:	89 f3                	mov    %esi,%ebx
  8020aa:	39 f0                	cmp    %esi,%eax
  8020ac:	0f 87 a6 00 00 00    	ja     802158 <__umoddi3+0xf4>
  8020b2:	0f bd e8             	bsr    %eax,%ebp
  8020b5:	83 f5 1f             	xor    $0x1f,%ebp
  8020b8:	0f 84 a6 00 00 00    	je     802164 <__umoddi3+0x100>
  8020be:	bf 20 00 00 00       	mov    $0x20,%edi
  8020c3:	29 ef                	sub    %ebp,%edi
  8020c5:	89 e9                	mov    %ebp,%ecx
  8020c7:	d3 e0                	shl    %cl,%eax
  8020c9:	8b 34 24             	mov    (%esp),%esi
  8020cc:	89 f2                	mov    %esi,%edx
  8020ce:	89 f9                	mov    %edi,%ecx
  8020d0:	d3 ea                	shr    %cl,%edx
  8020d2:	09 c2                	or     %eax,%edx
  8020d4:	89 14 24             	mov    %edx,(%esp)
  8020d7:	89 f2                	mov    %esi,%edx
  8020d9:	89 e9                	mov    %ebp,%ecx
  8020db:	d3 e2                	shl    %cl,%edx
  8020dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e1:	89 de                	mov    %ebx,%esi
  8020e3:	89 f9                	mov    %edi,%ecx
  8020e5:	d3 ee                	shr    %cl,%esi
  8020e7:	89 e9                	mov    %ebp,%ecx
  8020e9:	d3 e3                	shl    %cl,%ebx
  8020eb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8020ef:	89 d0                	mov    %edx,%eax
  8020f1:	89 f9                	mov    %edi,%ecx
  8020f3:	d3 e8                	shr    %cl,%eax
  8020f5:	09 d8                	or     %ebx,%eax
  8020f7:	89 d3                	mov    %edx,%ebx
  8020f9:	89 e9                	mov    %ebp,%ecx
  8020fb:	d3 e3                	shl    %cl,%ebx
  8020fd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802101:	89 f2                	mov    %esi,%edx
  802103:	f7 34 24             	divl   (%esp)
  802106:	89 d6                	mov    %edx,%esi
  802108:	f7 64 24 04          	mull   0x4(%esp)
  80210c:	89 c3                	mov    %eax,%ebx
  80210e:	89 d1                	mov    %edx,%ecx
  802110:	39 d6                	cmp    %edx,%esi
  802112:	72 7c                	jb     802190 <__umoddi3+0x12c>
  802114:	74 72                	je     802188 <__umoddi3+0x124>
  802116:	8b 54 24 08          	mov    0x8(%esp),%edx
  80211a:	29 da                	sub    %ebx,%edx
  80211c:	19 ce                	sbb    %ecx,%esi
  80211e:	89 f0                	mov    %esi,%eax
  802120:	89 f9                	mov    %edi,%ecx
  802122:	d3 e0                	shl    %cl,%eax
  802124:	89 e9                	mov    %ebp,%ecx
  802126:	d3 ea                	shr    %cl,%edx
  802128:	09 d0                	or     %edx,%eax
  80212a:	89 e9                	mov    %ebp,%ecx
  80212c:	d3 ee                	shr    %cl,%esi
  80212e:	89 f2                	mov    %esi,%edx
  802130:	83 c4 1c             	add    $0x1c,%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5f                   	pop    %edi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    
  802138:	89 fd                	mov    %edi,%ebp
  80213a:	85 ff                	test   %edi,%edi
  80213c:	75 0b                	jne    802149 <__umoddi3+0xe5>
  80213e:	b8 01 00 00 00       	mov    $0x1,%eax
  802143:	31 d2                	xor    %edx,%edx
  802145:	f7 f7                	div    %edi
  802147:	89 c5                	mov    %eax,%ebp
  802149:	89 f0                	mov    %esi,%eax
  80214b:	31 d2                	xor    %edx,%edx
  80214d:	f7 f5                	div    %ebp
  80214f:	89 c8                	mov    %ecx,%eax
  802151:	f7 f5                	div    %ebp
  802153:	e9 44 ff ff ff       	jmp    80209c <__umoddi3+0x38>
  802158:	89 c8                	mov    %ecx,%eax
  80215a:	89 f2                	mov    %esi,%edx
  80215c:	83 c4 1c             	add    $0x1c,%esp
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	5f                   	pop    %edi
  802162:	5d                   	pop    %ebp
  802163:	c3                   	ret    
  802164:	39 f0                	cmp    %esi,%eax
  802166:	72 05                	jb     80216d <__umoddi3+0x109>
  802168:	39 0c 24             	cmp    %ecx,(%esp)
  80216b:	77 0c                	ja     802179 <__umoddi3+0x115>
  80216d:	89 f2                	mov    %esi,%edx
  80216f:	29 f9                	sub    %edi,%ecx
  802171:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802175:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802179:	8b 44 24 04          	mov    0x4(%esp),%eax
  80217d:	83 c4 1c             	add    $0x1c,%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5f                   	pop    %edi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    
  802185:	8d 76 00             	lea    0x0(%esi),%esi
  802188:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80218c:	73 88                	jae    802116 <__umoddi3+0xb2>
  80218e:	66 90                	xchg   %ax,%ax
  802190:	2b 44 24 04          	sub    0x4(%esp),%eax
  802194:	1b 14 24             	sbb    (%esp),%edx
  802197:	89 d1                	mov    %edx,%ecx
  802199:	89 c3                	mov    %eax,%ebx
  80219b:	e9 76 ff ff ff       	jmp    802116 <__umoddi3+0xb2>
