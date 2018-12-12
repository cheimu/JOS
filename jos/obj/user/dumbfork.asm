
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 a8 01 00 00       	call   8001d9 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 c5 0c 00 00       	call   800d0f <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 ee 0c 00 00       	call   800d52 <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 4f 0a 00 00       	call   800acd <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 07 0d 00 00       	call   800d94 <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 a0 20 80 00       	push   $0x8020a0
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 b3 20 80 00       	push   $0x8020b3
  8000a8:	e8 92 01 00 00       	call   80023f <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 c3 20 80 00       	push   $0x8020c3
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 b3 20 80 00       	push   $0x8020b3
  8000ba:	e8 80 01 00 00       	call   80023f <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 d4 20 80 00       	push   $0x8020d4
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 b3 20 80 00       	push   $0x8020b3
  8000cc:	e8 6e 01 00 00       	call   80023f <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c6                	mov    %eax,%esi
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 0f                	js     8000f5 <dumbfork+0x24>
  8000e6:	89 c3                	mov    %eax,%ebx
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	74 1b                	je     800107 <dumbfork+0x36>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ec:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f3:	eb 45                	jmp    80013a <dumbfork+0x69>
		panic("sys_exofork: %e", envid);
  8000f5:	50                   	push   %eax
  8000f6:	68 e7 20 80 00       	push   $0x8020e7
  8000fb:	6a 37                	push   $0x37
  8000fd:	68 b3 20 80 00       	push   $0x8020b3
  800102:	e8 38 01 00 00       	call   80023f <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800107:	e8 e4 0b 00 00       	call   800cf0 <sys_getenvid>
  80010c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	c1 e2 05             	shl    $0x5,%edx
  800116:	29 c2                	sub    %eax,%edx
  800118:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80011f:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800124:	eb 43                	jmp    800169 <dumbfork+0x98>
		duppage(envid, addr);
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	52                   	push   %edx
  80012a:	53                   	push   %ebx
  80012b:	e8 03 ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800130:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80013d:	81 fa 00 60 80 00    	cmp    $0x806000,%edx
  800143:	72 e1                	jb     800126 <dumbfork+0x55>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80014b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800150:	50                   	push   %eax
  800151:	56                   	push   %esi
  800152:	e8 dc fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800157:	83 c4 08             	add    $0x8,%esp
  80015a:	6a 02                	push   $0x2
  80015c:	56                   	push   %esi
  80015d:	e8 93 0c 00 00       	call   800df5 <sys_env_set_status>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	85 c0                	test   %eax,%eax
  800167:	78 09                	js     800172 <dumbfork+0xa1>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800169:	89 f0                	mov    %esi,%eax
  80016b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80016e:	5b                   	pop    %ebx
  80016f:	5e                   	pop    %esi
  800170:	5d                   	pop    %ebp
  800171:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  800172:	50                   	push   %eax
  800173:	68 f7 20 80 00       	push   $0x8020f7
  800178:	6a 4c                	push   $0x4c
  80017a:	68 b3 20 80 00       	push   $0x8020b3
  80017f:	e8 bb 00 00 00       	call   80023f <_panic>

00800184 <umain>:
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	57                   	push   %edi
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
  80018a:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  80018d:	e8 3f ff ff ff       	call   8000d1 <dumbfork>
  800192:	89 c7                	mov    %eax,%edi
  800194:	85 c0                	test   %eax,%eax
  800196:	74 0c                	je     8001a4 <umain+0x20>
  800198:	be 0e 21 80 00       	mov    $0x80210e,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a2:	eb 24                	jmp    8001c8 <umain+0x44>
  8001a4:	be 15 21 80 00       	mov    $0x802115,%esi
  8001a9:	eb f2                	jmp    80019d <umain+0x19>
  8001ab:	83 fb 13             	cmp    $0x13,%ebx
  8001ae:	7f 21                	jg     8001d1 <umain+0x4d>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	56                   	push   %esi
  8001b4:	53                   	push   %ebx
  8001b5:	68 1b 21 80 00       	push   $0x80211b
  8001ba:	e8 93 01 00 00       	call   800352 <cprintf>
		sys_yield();
  8001bf:	e8 12 0c 00 00       	call   800dd6 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001c4:	43                   	inc    %ebx
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	85 ff                	test   %edi,%edi
  8001ca:	74 df                	je     8001ab <umain+0x27>
  8001cc:	83 fb 09             	cmp    $0x9,%ebx
  8001cf:	7e df                	jle    8001b0 <umain+0x2c>
}
  8001d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d4:	5b                   	pop    %ebx
  8001d5:	5e                   	pop    %esi
  8001d6:	5f                   	pop    %edi
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    

008001d9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	56                   	push   %esi
  8001dd:	53                   	push   %ebx
  8001de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001e1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001e4:	e8 07 0b 00 00       	call   800cf0 <sys_getenvid>
  8001e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ee:	89 c2                	mov    %eax,%edx
  8001f0:	c1 e2 05             	shl    $0x5,%edx
  8001f3:	29 c2                	sub    %eax,%edx
  8001f5:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8001fc:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800201:	85 db                	test   %ebx,%ebx
  800203:	7e 07                	jle    80020c <libmain+0x33>
		binaryname = argv[0];
  800205:	8b 06                	mov    (%esi),%eax
  800207:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	e8 6e ff ff ff       	call   800184 <umain>

	// exit gracefully
	exit();
  800216:	e8 0a 00 00 00       	call   800225 <exit>
}
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800221:	5b                   	pop    %ebx
  800222:	5e                   	pop    %esi
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    

00800225 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80022b:	e8 68 0f 00 00       	call   801198 <close_all>
	sys_env_destroy(0);
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	6a 00                	push   $0x0
  800235:	e8 75 0a 00 00       	call   800caf <sys_env_destroy>
}
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	57                   	push   %edi
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
  800245:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80024b:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80024e:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800254:	e8 97 0a 00 00       	call   800cf0 <sys_getenvid>
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	53                   	push   %ebx
  800263:	50                   	push   %eax
  800264:	68 38 21 80 00       	push   $0x802138
  800269:	68 00 01 00 00       	push   $0x100
  80026e:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800274:	56                   	push   %esi
  800275:	e8 93 06 00 00       	call   80090d <snprintf>
  80027a:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80027c:	83 c4 20             	add    $0x20,%esp
  80027f:	57                   	push   %edi
  800280:	ff 75 10             	pushl  0x10(%ebp)
  800283:	bf 00 01 00 00       	mov    $0x100,%edi
  800288:	89 f8                	mov    %edi,%eax
  80028a:	29 d8                	sub    %ebx,%eax
  80028c:	50                   	push   %eax
  80028d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800290:	50                   	push   %eax
  800291:	e8 22 06 00 00       	call   8008b8 <vsnprintf>
  800296:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800298:	83 c4 0c             	add    $0xc,%esp
  80029b:	68 2b 21 80 00       	push   $0x80212b
  8002a0:	29 df                	sub    %ebx,%edi
  8002a2:	57                   	push   %edi
  8002a3:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8002a6:	50                   	push   %eax
  8002a7:	e8 61 06 00 00       	call   80090d <snprintf>
	sys_cputs(buf, r);
  8002ac:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8002af:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8002b1:	53                   	push   %ebx
  8002b2:	56                   	push   %esi
  8002b3:	e8 ba 09 00 00       	call   800c72 <sys_cputs>
  8002b8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002bb:	cc                   	int3   
  8002bc:	eb fd                	jmp    8002bb <_panic+0x7c>

008002be <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002c8:	8b 13                	mov    (%ebx),%edx
  8002ca:	8d 42 01             	lea    0x1(%edx),%eax
  8002cd:	89 03                	mov    %eax,(%ebx)
  8002cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002d2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002db:	74 08                	je     8002e5 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002dd:	ff 43 04             	incl   0x4(%ebx)
}
  8002e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	68 ff 00 00 00       	push   $0xff
  8002ed:	8d 43 08             	lea    0x8(%ebx),%eax
  8002f0:	50                   	push   %eax
  8002f1:	e8 7c 09 00 00       	call   800c72 <sys_cputs>
		b->idx = 0;
  8002f6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	eb dc                	jmp    8002dd <putch+0x1f>

00800301 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80030a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800311:	00 00 00 
	b.cnt = 0;
  800314:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80031b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032a:	50                   	push   %eax
  80032b:	68 be 02 80 00       	push   $0x8002be
  800330:	e8 17 01 00 00       	call   80044c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800335:	83 c4 08             	add    $0x8,%esp
  800338:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80033e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800344:	50                   	push   %eax
  800345:	e8 28 09 00 00       	call   800c72 <sys_cputs>

	return b.cnt;
}
  80034a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800350:	c9                   	leave  
  800351:	c3                   	ret    

00800352 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800358:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80035b:	50                   	push   %eax
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	e8 9d ff ff ff       	call   800301 <vcprintf>
	va_end(ap);

	return cnt;
}
  800364:	c9                   	leave  
  800365:	c3                   	ret    

00800366 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	57                   	push   %edi
  80036a:	56                   	push   %esi
  80036b:	53                   	push   %ebx
  80036c:	83 ec 1c             	sub    $0x1c,%esp
  80036f:	89 c7                	mov    %eax,%edi
  800371:	89 d6                	mov    %edx,%esi
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	8b 55 0c             	mov    0xc(%ebp),%edx
  800379:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80037f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800382:	bb 00 00 00 00       	mov    $0x0,%ebx
  800387:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80038a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80038d:	39 d3                	cmp    %edx,%ebx
  80038f:	72 05                	jb     800396 <printnum+0x30>
  800391:	39 45 10             	cmp    %eax,0x10(%ebp)
  800394:	77 78                	ja     80040e <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	ff 75 18             	pushl  0x18(%ebp)
  80039c:	8b 45 14             	mov    0x14(%ebp),%eax
  80039f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003a2:	53                   	push   %ebx
  8003a3:	ff 75 10             	pushl  0x10(%ebp)
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8003af:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b5:	e8 82 1a 00 00       	call   801e3c <__udivdi3>
  8003ba:	83 c4 18             	add    $0x18,%esp
  8003bd:	52                   	push   %edx
  8003be:	50                   	push   %eax
  8003bf:	89 f2                	mov    %esi,%edx
  8003c1:	89 f8                	mov    %edi,%eax
  8003c3:	e8 9e ff ff ff       	call   800366 <printnum>
  8003c8:	83 c4 20             	add    $0x20,%esp
  8003cb:	eb 11                	jmp    8003de <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	56                   	push   %esi
  8003d1:	ff 75 18             	pushl  0x18(%ebp)
  8003d4:	ff d7                	call   *%edi
  8003d6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003d9:	4b                   	dec    %ebx
  8003da:	85 db                	test   %ebx,%ebx
  8003dc:	7f ef                	jg     8003cd <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	56                   	push   %esi
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8003f1:	e8 56 1b 00 00       	call   801f4c <__umoddi3>
  8003f6:	83 c4 14             	add    $0x14,%esp
  8003f9:	0f be 80 5b 21 80 00 	movsbl 0x80215b(%eax),%eax
  800400:	50                   	push   %eax
  800401:	ff d7                	call   *%edi
}
  800403:	83 c4 10             	add    $0x10,%esp
  800406:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800409:	5b                   	pop    %ebx
  80040a:	5e                   	pop    %esi
  80040b:	5f                   	pop    %edi
  80040c:	5d                   	pop    %ebp
  80040d:	c3                   	ret    
  80040e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800411:	eb c6                	jmp    8003d9 <printnum+0x73>

00800413 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800419:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80041c:	8b 10                	mov    (%eax),%edx
  80041e:	3b 50 04             	cmp    0x4(%eax),%edx
  800421:	73 0a                	jae    80042d <sprintputch+0x1a>
		*b->buf++ = ch;
  800423:	8d 4a 01             	lea    0x1(%edx),%ecx
  800426:	89 08                	mov    %ecx,(%eax)
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	88 02                	mov    %al,(%edx)
}
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <printfmt>:
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800435:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800438:	50                   	push   %eax
  800439:	ff 75 10             	pushl  0x10(%ebp)
  80043c:	ff 75 0c             	pushl  0xc(%ebp)
  80043f:	ff 75 08             	pushl  0x8(%ebp)
  800442:	e8 05 00 00 00       	call   80044c <vprintfmt>
}
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	c9                   	leave  
  80044b:	c3                   	ret    

0080044c <vprintfmt>:
{
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	57                   	push   %edi
  800450:	56                   	push   %esi
  800451:	53                   	push   %ebx
  800452:	83 ec 2c             	sub    $0x2c,%esp
  800455:	8b 75 08             	mov    0x8(%ebp),%esi
  800458:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80045b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80045e:	e9 ae 03 00 00       	jmp    800811 <vprintfmt+0x3c5>
  800463:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800467:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80046e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800475:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80047c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8d 47 01             	lea    0x1(%edi),%eax
  800484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800487:	8a 17                	mov    (%edi),%dl
  800489:	8d 42 dd             	lea    -0x23(%edx),%eax
  80048c:	3c 55                	cmp    $0x55,%al
  80048e:	0f 87 fe 03 00 00    	ja     800892 <vprintfmt+0x446>
  800494:	0f b6 c0             	movzbl %al,%eax
  800497:	ff 24 85 a0 22 80 00 	jmp    *0x8022a0(,%eax,4)
  80049e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004a1:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004a5:	eb da                	jmp    800481 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004aa:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004ae:	eb d1                	jmp    800481 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004b0:	0f b6 d2             	movzbl %dl,%edx
  8004b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004be:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004c1:	01 c0                	add    %eax,%eax
  8004c3:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8004c7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ca:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004cd:	83 f9 09             	cmp    $0x9,%ecx
  8004d0:	77 52                	ja     800524 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8004d2:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8004d3:	eb e9                	jmp    8004be <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8004d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8d 40 04             	lea    0x4(%eax),%eax
  8004e3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ed:	79 92                	jns    800481 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004fc:	eb 83                	jmp    800481 <vprintfmt+0x35>
  8004fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800502:	78 08                	js     80050c <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800507:	e9 75 ff ff ff       	jmp    800481 <vprintfmt+0x35>
  80050c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800513:	eb ef                	jmp    800504 <vprintfmt+0xb8>
  800515:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800518:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80051f:	e9 5d ff ff ff       	jmp    800481 <vprintfmt+0x35>
  800524:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800527:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80052a:	eb bd                	jmp    8004e9 <vprintfmt+0x9d>
			lflag++;
  80052c:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80052d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800530:	e9 4c ff ff ff       	jmp    800481 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800535:	8b 45 14             	mov    0x14(%ebp),%eax
  800538:	8d 78 04             	lea    0x4(%eax),%edi
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	53                   	push   %ebx
  80053f:	ff 30                	pushl  (%eax)
  800541:	ff d6                	call   *%esi
			break;
  800543:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800546:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800549:	e9 c0 02 00 00       	jmp    80080e <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8d 78 04             	lea    0x4(%eax),%edi
  800554:	8b 00                	mov    (%eax),%eax
  800556:	85 c0                	test   %eax,%eax
  800558:	78 2a                	js     800584 <vprintfmt+0x138>
  80055a:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055c:	83 f8 0f             	cmp    $0xf,%eax
  80055f:	7f 27                	jg     800588 <vprintfmt+0x13c>
  800561:	8b 04 85 00 24 80 00 	mov    0x802400(,%eax,4),%eax
  800568:	85 c0                	test   %eax,%eax
  80056a:	74 1c                	je     800588 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80056c:	50                   	push   %eax
  80056d:	68 31 25 80 00       	push   $0x802531
  800572:	53                   	push   %ebx
  800573:	56                   	push   %esi
  800574:	e8 b6 fe ff ff       	call   80042f <printfmt>
  800579:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80057f:	e9 8a 02 00 00       	jmp    80080e <vprintfmt+0x3c2>
  800584:	f7 d8                	neg    %eax
  800586:	eb d2                	jmp    80055a <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800588:	52                   	push   %edx
  800589:	68 73 21 80 00       	push   $0x802173
  80058e:	53                   	push   %ebx
  80058f:	56                   	push   %esi
  800590:	e8 9a fe ff ff       	call   80042f <printfmt>
  800595:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800598:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80059b:	e9 6e 02 00 00       	jmp    80080e <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	83 c0 04             	add    $0x4,%eax
  8005a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 38                	mov    (%eax),%edi
  8005ae:	85 ff                	test   %edi,%edi
  8005b0:	74 39                	je     8005eb <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8005b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b6:	0f 8e a9 00 00 00    	jle    800665 <vprintfmt+0x219>
  8005bc:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005c0:	0f 84 a7 00 00 00    	je     80066d <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 d0             	pushl  -0x30(%ebp)
  8005cc:	57                   	push   %edi
  8005cd:	e8 6b 03 00 00       	call   80093d <strnlen>
  8005d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d5:	29 c1                	sub    %eax,%ecx
  8005d7:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005da:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005dd:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005e7:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e9:	eb 14                	jmp    8005ff <vprintfmt+0x1b3>
				p = "(null)";
  8005eb:	bf 6c 21 80 00       	mov    $0x80216c,%edi
  8005f0:	eb c0                	jmp    8005b2 <vprintfmt+0x166>
					putch(padc, putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	53                   	push   %ebx
  8005f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fb:	4f                   	dec    %edi
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	85 ff                	test   %edi,%edi
  800601:	7f ef                	jg     8005f2 <vprintfmt+0x1a6>
  800603:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800606:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800609:	89 c8                	mov    %ecx,%eax
  80060b:	85 c9                	test   %ecx,%ecx
  80060d:	78 10                	js     80061f <vprintfmt+0x1d3>
  80060f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800612:	29 c1                	sub    %eax,%ecx
  800614:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800617:	89 75 08             	mov    %esi,0x8(%ebp)
  80061a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80061d:	eb 15                	jmp    800634 <vprintfmt+0x1e8>
  80061f:	b8 00 00 00 00       	mov    $0x0,%eax
  800624:	eb e9                	jmp    80060f <vprintfmt+0x1c3>
					putch(ch, putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	53                   	push   %ebx
  80062a:	52                   	push   %edx
  80062b:	ff 55 08             	call   *0x8(%ebp)
  80062e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800631:	ff 4d e0             	decl   -0x20(%ebp)
  800634:	47                   	inc    %edi
  800635:	8a 47 ff             	mov    -0x1(%edi),%al
  800638:	0f be d0             	movsbl %al,%edx
  80063b:	85 d2                	test   %edx,%edx
  80063d:	74 59                	je     800698 <vprintfmt+0x24c>
  80063f:	85 f6                	test   %esi,%esi
  800641:	78 03                	js     800646 <vprintfmt+0x1fa>
  800643:	4e                   	dec    %esi
  800644:	78 2f                	js     800675 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800646:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80064a:	74 da                	je     800626 <vprintfmt+0x1da>
  80064c:	0f be c0             	movsbl %al,%eax
  80064f:	83 e8 20             	sub    $0x20,%eax
  800652:	83 f8 5e             	cmp    $0x5e,%eax
  800655:	76 cf                	jbe    800626 <vprintfmt+0x1da>
					putch('?', putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	6a 3f                	push   $0x3f
  80065d:	ff 55 08             	call   *0x8(%ebp)
  800660:	83 c4 10             	add    $0x10,%esp
  800663:	eb cc                	jmp    800631 <vprintfmt+0x1e5>
  800665:	89 75 08             	mov    %esi,0x8(%ebp)
  800668:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80066b:	eb c7                	jmp    800634 <vprintfmt+0x1e8>
  80066d:	89 75 08             	mov    %esi,0x8(%ebp)
  800670:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800673:	eb bf                	jmp    800634 <vprintfmt+0x1e8>
  800675:	8b 75 08             	mov    0x8(%ebp),%esi
  800678:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80067b:	eb 0c                	jmp    800689 <vprintfmt+0x23d>
				putch(' ', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 20                	push   $0x20
  800683:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800685:	4f                   	dec    %edi
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	85 ff                	test   %edi,%edi
  80068b:	7f f0                	jg     80067d <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80068d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
  800693:	e9 76 01 00 00       	jmp    80080e <vprintfmt+0x3c2>
  800698:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80069b:	8b 75 08             	mov    0x8(%ebp),%esi
  80069e:	eb e9                	jmp    800689 <vprintfmt+0x23d>
	if (lflag >= 2)
  8006a0:	83 f9 01             	cmp    $0x1,%ecx
  8006a3:	7f 1f                	jg     8006c4 <vprintfmt+0x278>
	else if (lflag)
  8006a5:	85 c9                	test   %ecx,%ecx
  8006a7:	75 48                	jne    8006f1 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b1:	89 c1                	mov    %eax,%ecx
  8006b3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8d 40 04             	lea    0x4(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c2:	eb 17                	jmp    8006db <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 08             	lea    0x8(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8006e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006e5:	78 25                	js     80070c <vprintfmt+0x2c0>
			base = 10;
  8006e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ec:	e9 03 01 00 00       	jmp    8007f4 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f9:	89 c1                	mov    %eax,%ecx
  8006fb:	c1 f9 1f             	sar    $0x1f,%ecx
  8006fe:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 40 04             	lea    0x4(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
  80070a:	eb cf                	jmp    8006db <vprintfmt+0x28f>
				putch('-', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	6a 2d                	push   $0x2d
  800712:	ff d6                	call   *%esi
				num = -(long long) num;
  800714:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800717:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80071a:	f7 da                	neg    %edx
  80071c:	83 d1 00             	adc    $0x0,%ecx
  80071f:	f7 d9                	neg    %ecx
  800721:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800724:	b8 0a 00 00 00       	mov    $0xa,%eax
  800729:	e9 c6 00 00 00       	jmp    8007f4 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80072e:	83 f9 01             	cmp    $0x1,%ecx
  800731:	7f 1e                	jg     800751 <vprintfmt+0x305>
	else if (lflag)
  800733:	85 c9                	test   %ecx,%ecx
  800735:	75 32                	jne    800769 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 10                	mov    (%eax),%edx
  80073c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800747:	b8 0a 00 00 00       	mov    $0xa,%eax
  80074c:	e9 a3 00 00 00       	jmp    8007f4 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 10                	mov    (%eax),%edx
  800756:	8b 48 04             	mov    0x4(%eax),%ecx
  800759:	8d 40 08             	lea    0x8(%eax),%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800764:	e9 8b 00 00 00       	jmp    8007f4 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 10                	mov    (%eax),%edx
  80076e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800779:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077e:	eb 74                	jmp    8007f4 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800780:	83 f9 01             	cmp    $0x1,%ecx
  800783:	7f 1b                	jg     8007a0 <vprintfmt+0x354>
	else if (lflag)
  800785:	85 c9                	test   %ecx,%ecx
  800787:	75 2c                	jne    8007b5 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 10                	mov    (%eax),%edx
  80078e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800793:	8d 40 04             	lea    0x4(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800799:	b8 08 00 00 00       	mov    $0x8,%eax
  80079e:	eb 54                	jmp    8007f4 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8b 10                	mov    (%eax),%edx
  8007a5:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a8:	8d 40 08             	lea    0x8(%eax),%eax
  8007ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b3:	eb 3f                	jmp    8007f4 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8b 10                	mov    (%eax),%edx
  8007ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bf:	8d 40 04             	lea    0x4(%eax),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ca:	eb 28                	jmp    8007f4 <vprintfmt+0x3a8>
			putch('0', putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	6a 30                	push   $0x30
  8007d2:	ff d6                	call   *%esi
			putch('x', putdat);
  8007d4:	83 c4 08             	add    $0x8,%esp
  8007d7:	53                   	push   %ebx
  8007d8:	6a 78                	push   $0x78
  8007da:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 10                	mov    (%eax),%edx
  8007e1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007e6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007e9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ef:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007f4:	83 ec 0c             	sub    $0xc,%esp
  8007f7:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007fb:	57                   	push   %edi
  8007fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ff:	50                   	push   %eax
  800800:	51                   	push   %ecx
  800801:	52                   	push   %edx
  800802:	89 da                	mov    %ebx,%edx
  800804:	89 f0                	mov    %esi,%eax
  800806:	e8 5b fb ff ff       	call   800366 <printnum>
			break;
  80080b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80080e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800811:	47                   	inc    %edi
  800812:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800816:	83 f8 25             	cmp    $0x25,%eax
  800819:	0f 84 44 fc ff ff    	je     800463 <vprintfmt+0x17>
			if (ch == '\0')
  80081f:	85 c0                	test   %eax,%eax
  800821:	0f 84 89 00 00 00    	je     8008b0 <vprintfmt+0x464>
			putch(ch, putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	53                   	push   %ebx
  80082b:	50                   	push   %eax
  80082c:	ff d6                	call   *%esi
  80082e:	83 c4 10             	add    $0x10,%esp
  800831:	eb de                	jmp    800811 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800833:	83 f9 01             	cmp    $0x1,%ecx
  800836:	7f 1b                	jg     800853 <vprintfmt+0x407>
	else if (lflag)
  800838:	85 c9                	test   %ecx,%ecx
  80083a:	75 2c                	jne    800868 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8b 10                	mov    (%eax),%edx
  800841:	b9 00 00 00 00       	mov    $0x0,%ecx
  800846:	8d 40 04             	lea    0x4(%eax),%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084c:	b8 10 00 00 00       	mov    $0x10,%eax
  800851:	eb a1                	jmp    8007f4 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8b 10                	mov    (%eax),%edx
  800858:	8b 48 04             	mov    0x4(%eax),%ecx
  80085b:	8d 40 08             	lea    0x8(%eax),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800861:	b8 10 00 00 00       	mov    $0x10,%eax
  800866:	eb 8c                	jmp    8007f4 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 10                	mov    (%eax),%edx
  80086d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800872:	8d 40 04             	lea    0x4(%eax),%eax
  800875:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800878:	b8 10 00 00 00       	mov    $0x10,%eax
  80087d:	e9 72 ff ff ff       	jmp    8007f4 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	6a 25                	push   $0x25
  800888:	ff d6                	call   *%esi
			break;
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	e9 7c ff ff ff       	jmp    80080e <vprintfmt+0x3c2>
			putch('%', putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	53                   	push   %ebx
  800896:	6a 25                	push   $0x25
  800898:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	89 f8                	mov    %edi,%eax
  80089f:	eb 01                	jmp    8008a2 <vprintfmt+0x456>
  8008a1:	48                   	dec    %eax
  8008a2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a6:	75 f9                	jne    8008a1 <vprintfmt+0x455>
  8008a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ab:	e9 5e ff ff ff       	jmp    80080e <vprintfmt+0x3c2>
}
  8008b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008b3:	5b                   	pop    %ebx
  8008b4:	5e                   	pop    %esi
  8008b5:	5f                   	pop    %edi
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 18             	sub    $0x18,%esp
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008cb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d5:	85 c0                	test   %eax,%eax
  8008d7:	74 26                	je     8008ff <vsnprintf+0x47>
  8008d9:	85 d2                	test   %edx,%edx
  8008db:	7e 29                	jle    800906 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008dd:	ff 75 14             	pushl  0x14(%ebp)
  8008e0:	ff 75 10             	pushl  0x10(%ebp)
  8008e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e6:	50                   	push   %eax
  8008e7:	68 13 04 80 00       	push   $0x800413
  8008ec:	e8 5b fb ff ff       	call   80044c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008fa:	83 c4 10             	add    $0x10,%esp
}
  8008fd:	c9                   	leave  
  8008fe:	c3                   	ret    
		return -E_INVAL;
  8008ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800904:	eb f7                	jmp    8008fd <vsnprintf+0x45>
  800906:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80090b:	eb f0                	jmp    8008fd <vsnprintf+0x45>

0080090d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800913:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800916:	50                   	push   %eax
  800917:	ff 75 10             	pushl  0x10(%ebp)
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	ff 75 08             	pushl  0x8(%ebp)
  800920:	e8 93 ff ff ff       	call   8008b8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80092d:	b8 00 00 00 00       	mov    $0x0,%eax
  800932:	eb 01                	jmp    800935 <strlen+0xe>
		n++;
  800934:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800935:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800939:	75 f9                	jne    800934 <strlen+0xd>
	return n;
}
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	eb 01                	jmp    80094e <strnlen+0x11>
		n++;
  80094d:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094e:	39 d0                	cmp    %edx,%eax
  800950:	74 06                	je     800958 <strnlen+0x1b>
  800952:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800956:	75 f5                	jne    80094d <strnlen+0x10>
	return n;
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800964:	89 c2                	mov    %eax,%edx
  800966:	42                   	inc    %edx
  800967:	41                   	inc    %ecx
  800968:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80096b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80096e:	84 db                	test   %bl,%bl
  800970:	75 f4                	jne    800966 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800972:	5b                   	pop    %ebx
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	53                   	push   %ebx
  800979:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097c:	53                   	push   %ebx
  80097d:	e8 a5 ff ff ff       	call   800927 <strlen>
  800982:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	01 d8                	add    %ebx,%eax
  80098a:	50                   	push   %eax
  80098b:	e8 ca ff ff ff       	call   80095a <strcpy>
	return dst;
}
  800990:	89 d8                	mov    %ebx,%eax
  800992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	8b 75 08             	mov    0x8(%ebp),%esi
  80099f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a2:	89 f3                	mov    %esi,%ebx
  8009a4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a7:	89 f2                	mov    %esi,%edx
  8009a9:	eb 0c                	jmp    8009b7 <strncpy+0x20>
		*dst++ = *src;
  8009ab:	42                   	inc    %edx
  8009ac:	8a 01                	mov    (%ecx),%al
  8009ae:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b1:	80 39 01             	cmpb   $0x1,(%ecx)
  8009b4:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009b7:	39 da                	cmp    %ebx,%edx
  8009b9:	75 f0                	jne    8009ab <strncpy+0x14>
	}
	return ret;
}
  8009bb:	89 f0                	mov    %esi,%eax
  8009bd:	5b                   	pop    %ebx
  8009be:	5e                   	pop    %esi
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	56                   	push   %esi
  8009c5:	53                   	push   %ebx
  8009c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cf:	85 c0                	test   %eax,%eax
  8009d1:	74 20                	je     8009f3 <strlcpy+0x32>
  8009d3:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8009d7:	89 f0                	mov    %esi,%eax
  8009d9:	eb 05                	jmp    8009e0 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009db:	40                   	inc    %eax
  8009dc:	42                   	inc    %edx
  8009dd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009e0:	39 d8                	cmp    %ebx,%eax
  8009e2:	74 06                	je     8009ea <strlcpy+0x29>
  8009e4:	8a 0a                	mov    (%edx),%cl
  8009e6:	84 c9                	test   %cl,%cl
  8009e8:	75 f1                	jne    8009db <strlcpy+0x1a>
		*dst = '\0';
  8009ea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ed:	29 f0                	sub    %esi,%eax
}
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    
  8009f3:	89 f0                	mov    %esi,%eax
  8009f5:	eb f6                	jmp    8009ed <strlcpy+0x2c>

008009f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a00:	eb 02                	jmp    800a04 <strcmp+0xd>
		p++, q++;
  800a02:	41                   	inc    %ecx
  800a03:	42                   	inc    %edx
	while (*p && *p == *q)
  800a04:	8a 01                	mov    (%ecx),%al
  800a06:	84 c0                	test   %al,%al
  800a08:	74 04                	je     800a0e <strcmp+0x17>
  800a0a:	3a 02                	cmp    (%edx),%al
  800a0c:	74 f4                	je     800a02 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0e:	0f b6 c0             	movzbl %al,%eax
  800a11:	0f b6 12             	movzbl (%edx),%edx
  800a14:	29 d0                	sub    %edx,%eax
}
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	53                   	push   %ebx
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a22:	89 c3                	mov    %eax,%ebx
  800a24:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a27:	eb 02                	jmp    800a2b <strncmp+0x13>
		n--, p++, q++;
  800a29:	40                   	inc    %eax
  800a2a:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800a2b:	39 d8                	cmp    %ebx,%eax
  800a2d:	74 15                	je     800a44 <strncmp+0x2c>
  800a2f:	8a 08                	mov    (%eax),%cl
  800a31:	84 c9                	test   %cl,%cl
  800a33:	74 04                	je     800a39 <strncmp+0x21>
  800a35:	3a 0a                	cmp    (%edx),%cl
  800a37:	74 f0                	je     800a29 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a39:	0f b6 00             	movzbl (%eax),%eax
  800a3c:	0f b6 12             	movzbl (%edx),%edx
  800a3f:	29 d0                	sub    %edx,%eax
}
  800a41:	5b                   	pop    %ebx
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    
		return 0;
  800a44:	b8 00 00 00 00       	mov    $0x0,%eax
  800a49:	eb f6                	jmp    800a41 <strncmp+0x29>

00800a4b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a54:	8a 10                	mov    (%eax),%dl
  800a56:	84 d2                	test   %dl,%dl
  800a58:	74 07                	je     800a61 <strchr+0x16>
		if (*s == c)
  800a5a:	38 ca                	cmp    %cl,%dl
  800a5c:	74 08                	je     800a66 <strchr+0x1b>
	for (; *s; s++)
  800a5e:	40                   	inc    %eax
  800a5f:	eb f3                	jmp    800a54 <strchr+0x9>
			return (char *) s;
	return 0;
  800a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a66:	5d                   	pop    %ebp
  800a67:	c3                   	ret    

00800a68 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a71:	8a 10                	mov    (%eax),%dl
  800a73:	84 d2                	test   %dl,%dl
  800a75:	74 07                	je     800a7e <strfind+0x16>
		if (*s == c)
  800a77:	38 ca                	cmp    %cl,%dl
  800a79:	74 03                	je     800a7e <strfind+0x16>
	for (; *s; s++)
  800a7b:	40                   	inc    %eax
  800a7c:	eb f3                	jmp    800a71 <strfind+0x9>
			break;
	return (char *) s;
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	57                   	push   %edi
  800a84:	56                   	push   %esi
  800a85:	53                   	push   %ebx
  800a86:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a89:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8c:	85 c9                	test   %ecx,%ecx
  800a8e:	74 13                	je     800aa3 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a90:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a96:	75 05                	jne    800a9d <memset+0x1d>
  800a98:	f6 c1 03             	test   $0x3,%cl
  800a9b:	74 0d                	je     800aaa <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa0:	fc                   	cld    
  800aa1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aa3:	89 f8                	mov    %edi,%eax
  800aa5:	5b                   	pop    %ebx
  800aa6:	5e                   	pop    %esi
  800aa7:	5f                   	pop    %edi
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    
		c &= 0xFF;
  800aaa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aae:	89 d3                	mov    %edx,%ebx
  800ab0:	c1 e3 08             	shl    $0x8,%ebx
  800ab3:	89 d0                	mov    %edx,%eax
  800ab5:	c1 e0 18             	shl    $0x18,%eax
  800ab8:	89 d6                	mov    %edx,%esi
  800aba:	c1 e6 10             	shl    $0x10,%esi
  800abd:	09 f0                	or     %esi,%eax
  800abf:	09 c2                	or     %eax,%edx
  800ac1:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ac3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac6:	89 d0                	mov    %edx,%eax
  800ac8:	fc                   	cld    
  800ac9:	f3 ab                	rep stos %eax,%es:(%edi)
  800acb:	eb d6                	jmp    800aa3 <memset+0x23>

00800acd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	57                   	push   %edi
  800ad1:	56                   	push   %esi
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800adb:	39 c6                	cmp    %eax,%esi
  800add:	73 33                	jae    800b12 <memmove+0x45>
  800adf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae2:	39 d0                	cmp    %edx,%eax
  800ae4:	73 2c                	jae    800b12 <memmove+0x45>
		s += n;
		d += n;
  800ae6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae9:	89 d6                	mov    %edx,%esi
  800aeb:	09 fe                	or     %edi,%esi
  800aed:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af3:	75 13                	jne    800b08 <memmove+0x3b>
  800af5:	f6 c1 03             	test   $0x3,%cl
  800af8:	75 0e                	jne    800b08 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800afa:	83 ef 04             	sub    $0x4,%edi
  800afd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b03:	fd                   	std    
  800b04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b06:	eb 07                	jmp    800b0f <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b08:	4f                   	dec    %edi
  800b09:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b0c:	fd                   	std    
  800b0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b0f:	fc                   	cld    
  800b10:	eb 13                	jmp    800b25 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b12:	89 f2                	mov    %esi,%edx
  800b14:	09 c2                	or     %eax,%edx
  800b16:	f6 c2 03             	test   $0x3,%dl
  800b19:	75 05                	jne    800b20 <memmove+0x53>
  800b1b:	f6 c1 03             	test   $0x3,%cl
  800b1e:	74 09                	je     800b29 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	fc                   	cld    
  800b23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b25:	5e                   	pop    %esi
  800b26:	5f                   	pop    %edi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b29:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b2c:	89 c7                	mov    %eax,%edi
  800b2e:	fc                   	cld    
  800b2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b31:	eb f2                	jmp    800b25 <memmove+0x58>

00800b33 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b36:	ff 75 10             	pushl  0x10(%ebp)
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 89 ff ff ff       	call   800acd <memmove>
}
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 c6                	mov    %eax,%esi
  800b50:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800b53:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800b56:	39 f0                	cmp    %esi,%eax
  800b58:	74 16                	je     800b70 <memcmp+0x2a>
		if (*s1 != *s2)
  800b5a:	8a 08                	mov    (%eax),%cl
  800b5c:	8a 1a                	mov    (%edx),%bl
  800b5e:	38 d9                	cmp    %bl,%cl
  800b60:	75 04                	jne    800b66 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b62:	40                   	inc    %eax
  800b63:	42                   	inc    %edx
  800b64:	eb f0                	jmp    800b56 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b66:	0f b6 c1             	movzbl %cl,%eax
  800b69:	0f b6 db             	movzbl %bl,%ebx
  800b6c:	29 d8                	sub    %ebx,%eax
  800b6e:	eb 05                	jmp    800b75 <memcmp+0x2f>
	}

	return 0;
  800b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b87:	39 d0                	cmp    %edx,%eax
  800b89:	73 07                	jae    800b92 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b8b:	38 08                	cmp    %cl,(%eax)
  800b8d:	74 03                	je     800b92 <memfind+0x19>
	for (; s < ends; s++)
  800b8f:	40                   	inc    %eax
  800b90:	eb f5                	jmp    800b87 <memfind+0xe>
			break;
	return (void *) s;
}
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
  800b9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9d:	eb 01                	jmp    800ba0 <strtol+0xc>
		s++;
  800b9f:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800ba0:	8a 01                	mov    (%ecx),%al
  800ba2:	3c 20                	cmp    $0x20,%al
  800ba4:	74 f9                	je     800b9f <strtol+0xb>
  800ba6:	3c 09                	cmp    $0x9,%al
  800ba8:	74 f5                	je     800b9f <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800baa:	3c 2b                	cmp    $0x2b,%al
  800bac:	74 2b                	je     800bd9 <strtol+0x45>
		s++;
	else if (*s == '-')
  800bae:	3c 2d                	cmp    $0x2d,%al
  800bb0:	74 2f                	je     800be1 <strtol+0x4d>
	int neg = 0;
  800bb2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb7:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800bbe:	75 12                	jne    800bd2 <strtol+0x3e>
  800bc0:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc3:	74 24                	je     800be9 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc9:	75 07                	jne    800bd2 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bcb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd7:	eb 4e                	jmp    800c27 <strtol+0x93>
		s++;
  800bd9:	41                   	inc    %ecx
	int neg = 0;
  800bda:	bf 00 00 00 00       	mov    $0x0,%edi
  800bdf:	eb d6                	jmp    800bb7 <strtol+0x23>
		s++, neg = 1;
  800be1:	41                   	inc    %ecx
  800be2:	bf 01 00 00 00       	mov    $0x1,%edi
  800be7:	eb ce                	jmp    800bb7 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bed:	74 10                	je     800bff <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800bef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf3:	75 dd                	jne    800bd2 <strtol+0x3e>
		s++, base = 8;
  800bf5:	41                   	inc    %ecx
  800bf6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800bfd:	eb d3                	jmp    800bd2 <strtol+0x3e>
		s += 2, base = 16;
  800bff:	83 c1 02             	add    $0x2,%ecx
  800c02:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c09:	eb c7                	jmp    800bd2 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c0b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c0e:	89 f3                	mov    %esi,%ebx
  800c10:	80 fb 19             	cmp    $0x19,%bl
  800c13:	77 24                	ja     800c39 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800c15:	0f be d2             	movsbl %dl,%edx
  800c18:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c1b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c1e:	7d 2b                	jge    800c4b <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800c20:	41                   	inc    %ecx
  800c21:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c25:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c27:	8a 11                	mov    (%ecx),%dl
  800c29:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800c2c:	80 fb 09             	cmp    $0x9,%bl
  800c2f:	77 da                	ja     800c0b <strtol+0x77>
			dig = *s - '0';
  800c31:	0f be d2             	movsbl %dl,%edx
  800c34:	83 ea 30             	sub    $0x30,%edx
  800c37:	eb e2                	jmp    800c1b <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800c39:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c3c:	89 f3                	mov    %esi,%ebx
  800c3e:	80 fb 19             	cmp    $0x19,%bl
  800c41:	77 08                	ja     800c4b <strtol+0xb7>
			dig = *s - 'A' + 10;
  800c43:	0f be d2             	movsbl %dl,%edx
  800c46:	83 ea 37             	sub    $0x37,%edx
  800c49:	eb d0                	jmp    800c1b <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4f:	74 05                	je     800c56 <strtol+0xc2>
		*endptr = (char *) s;
  800c51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c54:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c56:	85 ff                	test   %edi,%edi
  800c58:	74 02                	je     800c5c <strtol+0xc8>
  800c5a:	f7 d8                	neg    %eax
}
  800c5c:	5b                   	pop    %ebx
  800c5d:	5e                   	pop    %esi
  800c5e:	5f                   	pop    %edi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <atoi>:

int
atoi(const char *s)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800c64:	6a 0a                	push   $0xa
  800c66:	6a 00                	push   $0x0
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 24 ff ff ff       	call   800b94 <strtol>
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c78:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	89 c3                	mov    %eax,%ebx
  800c85:	89 c7                	mov    %eax,%edi
  800c87:	89 c6                	mov    %eax,%esi
  800c89:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5f                   	pop    %edi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	57                   	push   %edi
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c96:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9b:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca0:	89 d1                	mov    %edx,%ecx
  800ca2:	89 d3                	mov    %edx,%ebx
  800ca4:	89 d7                	mov    %edx,%edi
  800ca6:	89 d6                	mov    %edx,%esi
  800ca8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800caa:	5b                   	pop    %ebx
  800cab:	5e                   	pop    %esi
  800cac:	5f                   	pop    %edi
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbd:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc5:	89 cb                	mov    %ecx,%ebx
  800cc7:	89 cf                	mov    %ecx,%edi
  800cc9:	89 ce                	mov    %ecx,%esi
  800ccb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccd:	85 c0                	test   %eax,%eax
  800ccf:	7f 08                	jg     800cd9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd9:	83 ec 0c             	sub    $0xc,%esp
  800cdc:	50                   	push   %eax
  800cdd:	6a 03                	push   $0x3
  800cdf:	68 5f 24 80 00       	push   $0x80245f
  800ce4:	6a 23                	push   $0x23
  800ce6:	68 7c 24 80 00       	push   $0x80247c
  800ceb:	e8 4f f5 ff ff       	call   80023f <_panic>

00800cf0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfb:	b8 02 00 00 00       	mov    $0x2,%eax
  800d00:	89 d1                	mov    %edx,%ecx
  800d02:	89 d3                	mov    %edx,%ebx
  800d04:	89 d7                	mov    %edx,%edi
  800d06:	89 d6                	mov    %edx,%esi
  800d08:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d18:	be 00 00 00 00       	mov    $0x0,%esi
  800d1d:	b8 04 00 00 00       	mov    $0x4,%eax
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2b:	89 f7                	mov    %esi,%edi
  800d2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	7f 08                	jg     800d3b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3b:	83 ec 0c             	sub    $0xc,%esp
  800d3e:	50                   	push   %eax
  800d3f:	6a 04                	push   $0x4
  800d41:	68 5f 24 80 00       	push   $0x80245f
  800d46:	6a 23                	push   $0x23
  800d48:	68 7c 24 80 00       	push   $0x80247c
  800d4d:	e8 ed f4 ff ff       	call   80023f <_panic>

00800d52 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d69:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d71:	85 c0                	test   %eax,%eax
  800d73:	7f 08                	jg     800d7d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	83 ec 0c             	sub    $0xc,%esp
  800d80:	50                   	push   %eax
  800d81:	6a 05                	push   $0x5
  800d83:	68 5f 24 80 00       	push   $0x80245f
  800d88:	6a 23                	push   $0x23
  800d8a:	68 7c 24 80 00       	push   $0x80247c
  800d8f:	e8 ab f4 ff ff       	call   80023f <_panic>

00800d94 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da2:	b8 06 00 00 00       	mov    $0x6,%eax
  800da7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	89 df                	mov    %ebx,%edi
  800daf:	89 de                	mov    %ebx,%esi
  800db1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db3:	85 c0                	test   %eax,%eax
  800db5:	7f 08                	jg     800dbf <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	50                   	push   %eax
  800dc3:	6a 06                	push   $0x6
  800dc5:	68 5f 24 80 00       	push   $0x80245f
  800dca:	6a 23                	push   $0x23
  800dcc:	68 7c 24 80 00       	push   $0x80247c
  800dd1:	e8 69 f4 ff ff       	call   80023f <_panic>

00800dd6 <sys_yield>:

void
sys_yield(void)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800de6:	89 d1                	mov    %edx,%ecx
  800de8:	89 d3                	mov    %edx,%ebx
  800dea:	89 d7                	mov    %edx,%edi
  800dec:	89 d6                	mov    %edx,%esi
  800dee:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e03:	b8 08 00 00 00       	mov    $0x8,%eax
  800e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	89 df                	mov    %ebx,%edi
  800e10:	89 de                	mov    %ebx,%esi
  800e12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	7f 08                	jg     800e20 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	50                   	push   %eax
  800e24:	6a 08                	push   $0x8
  800e26:	68 5f 24 80 00       	push   $0x80245f
  800e2b:	6a 23                	push   $0x23
  800e2d:	68 7c 24 80 00       	push   $0x80247c
  800e32:	e8 08 f4 ff ff       	call   80023f <_panic>

00800e37 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e40:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e45:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	89 cb                	mov    %ecx,%ebx
  800e4f:	89 cf                	mov    %ecx,%edi
  800e51:	89 ce                	mov    %ecx,%esi
  800e53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7f 08                	jg     800e61 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	50                   	push   %eax
  800e65:	6a 0c                	push   $0xc
  800e67:	68 5f 24 80 00       	push   $0x80245f
  800e6c:	6a 23                	push   $0x23
  800e6e:	68 7c 24 80 00       	push   $0x80247c
  800e73:	e8 c7 f3 ff ff       	call   80023f <_panic>

00800e78 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e86:	b8 09 00 00 00       	mov    $0x9,%eax
  800e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e91:	89 df                	mov    %ebx,%edi
  800e93:	89 de                	mov    %ebx,%esi
  800e95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e97:	85 c0                	test   %eax,%eax
  800e99:	7f 08                	jg     800ea3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	50                   	push   %eax
  800ea7:	6a 09                	push   $0x9
  800ea9:	68 5f 24 80 00       	push   $0x80245f
  800eae:	6a 23                	push   $0x23
  800eb0:	68 7c 24 80 00       	push   $0x80247c
  800eb5:	e8 85 f3 ff ff       	call   80023f <_panic>

00800eba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
  800ec0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	89 df                	mov    %ebx,%edi
  800ed5:	89 de                	mov    %ebx,%esi
  800ed7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7f 08                	jg     800ee5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	50                   	push   %eax
  800ee9:	6a 0a                	push   $0xa
  800eeb:	68 5f 24 80 00       	push   $0x80245f
  800ef0:	6a 23                	push   $0x23
  800ef2:	68 7c 24 80 00       	push   $0x80247c
  800ef7:	e8 43 f3 ff ff       	call   80023f <_panic>

00800efc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f02:	be 00 00 00 00       	mov    $0x0,%esi
  800f07:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f15:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f18:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
  800f25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f28:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f2d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	89 cb                	mov    %ecx,%ebx
  800f37:	89 cf                	mov    %ecx,%edi
  800f39:	89 ce                	mov    %ecx,%esi
  800f3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7f 08                	jg     800f49 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800f4d:	6a 0e                	push   $0xe
  800f4f:	68 5f 24 80 00       	push   $0x80245f
  800f54:	6a 23                	push   $0x23
  800f56:	68 7c 24 80 00       	push   $0x80247c
  800f5b:	e8 df f2 ff ff       	call   80023f <_panic>

00800f60 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f66:	be 00 00 00 00       	mov    $0x0,%esi
  800f6b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f79:	89 f7                	mov    %esi,%edi
  800f7b:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f88:	be 00 00 00 00       	mov    $0x0,%esi
  800f8d:	b8 10 00 00 00       	mov    $0x10,%eax
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9b:	89 f7                	mov    %esi,%edi
  800f9d:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800f9f:	5b                   	pop    %ebx
  800fa0:	5e                   	pop    %esi
  800fa1:	5f                   	pop    %edi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800faa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800faf:	b8 11 00 00 00       	mov    $0x11,%eax
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	89 cb                	mov    %ecx,%ebx
  800fb9:	89 cf                	mov    %ecx,%edi
  800fbb:	89 ce                	mov    %ecx,%esi
  800fbd:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5f                   	pop    %edi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	05 00 00 00 30       	add    $0x30000000,%eax
  800fcf:	c1 e8 0c             	shr    $0xc,%eax
}
  800fd2:	5d                   	pop    %ebp
  800fd3:	c3                   	ret    

00800fd4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ff6:	89 c2                	mov    %eax,%edx
  800ff8:	c1 ea 16             	shr    $0x16,%edx
  800ffb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801002:	f6 c2 01             	test   $0x1,%dl
  801005:	74 2a                	je     801031 <fd_alloc+0x46>
  801007:	89 c2                	mov    %eax,%edx
  801009:	c1 ea 0c             	shr    $0xc,%edx
  80100c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801013:	f6 c2 01             	test   $0x1,%dl
  801016:	74 19                	je     801031 <fd_alloc+0x46>
  801018:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80101d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801022:	75 d2                	jne    800ff6 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801024:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80102a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80102f:	eb 07                	jmp    801038 <fd_alloc+0x4d>
			*fd_store = fd;
  801031:	89 01                	mov    %eax,(%ecx)
			return 0;
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80103d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801041:	77 39                	ja     80107c <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	c1 e0 0c             	shl    $0xc,%eax
  801049:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80104e:	89 c2                	mov    %eax,%edx
  801050:	c1 ea 16             	shr    $0x16,%edx
  801053:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80105a:	f6 c2 01             	test   $0x1,%dl
  80105d:	74 24                	je     801083 <fd_lookup+0x49>
  80105f:	89 c2                	mov    %eax,%edx
  801061:	c1 ea 0c             	shr    $0xc,%edx
  801064:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80106b:	f6 c2 01             	test   $0x1,%dl
  80106e:	74 1a                	je     80108a <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801070:	8b 55 0c             	mov    0xc(%ebp),%edx
  801073:	89 02                	mov    %eax,(%edx)
	return 0;
  801075:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    
		return -E_INVAL;
  80107c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801081:	eb f7                	jmp    80107a <fd_lookup+0x40>
		return -E_INVAL;
  801083:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801088:	eb f0                	jmp    80107a <fd_lookup+0x40>
  80108a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108f:	eb e9                	jmp    80107a <fd_lookup+0x40>

00801091 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 08             	sub    $0x8,%esp
  801097:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109a:	ba 08 25 80 00       	mov    $0x802508,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80109f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010a4:	39 08                	cmp    %ecx,(%eax)
  8010a6:	74 33                	je     8010db <dev_lookup+0x4a>
  8010a8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010ab:	8b 02                	mov    (%edx),%eax
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	75 f3                	jne    8010a4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8010b6:	8b 40 48             	mov    0x48(%eax),%eax
  8010b9:	83 ec 04             	sub    $0x4,%esp
  8010bc:	51                   	push   %ecx
  8010bd:	50                   	push   %eax
  8010be:	68 8c 24 80 00       	push   $0x80248c
  8010c3:	e8 8a f2 ff ff       	call   800352 <cprintf>
	*dev = 0;
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010d1:	83 c4 10             	add    $0x10,%esp
  8010d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    
			*dev = devtab[i];
  8010db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010de:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e5:	eb f2                	jmp    8010d9 <dev_lookup+0x48>

008010e7 <fd_close>:
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
  8010ed:	83 ec 1c             	sub    $0x1c,%esp
  8010f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010f9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010fa:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801100:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801103:	50                   	push   %eax
  801104:	e8 31 ff ff ff       	call   80103a <fd_lookup>
  801109:	89 c7                	mov    %eax,%edi
  80110b:	83 c4 08             	add    $0x8,%esp
  80110e:	85 c0                	test   %eax,%eax
  801110:	78 05                	js     801117 <fd_close+0x30>
	    || fd != fd2)
  801112:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801115:	74 13                	je     80112a <fd_close+0x43>
		return (must_exist ? r : 0);
  801117:	84 db                	test   %bl,%bl
  801119:	75 05                	jne    801120 <fd_close+0x39>
  80111b:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801120:	89 f8                	mov    %edi,%eax
  801122:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80112a:	83 ec 08             	sub    $0x8,%esp
  80112d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801130:	50                   	push   %eax
  801131:	ff 36                	pushl  (%esi)
  801133:	e8 59 ff ff ff       	call   801091 <dev_lookup>
  801138:	89 c7                	mov    %eax,%edi
  80113a:	83 c4 10             	add    $0x10,%esp
  80113d:	85 c0                	test   %eax,%eax
  80113f:	78 15                	js     801156 <fd_close+0x6f>
		if (dev->dev_close)
  801141:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801144:	8b 40 10             	mov    0x10(%eax),%eax
  801147:	85 c0                	test   %eax,%eax
  801149:	74 1b                	je     801166 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	56                   	push   %esi
  80114f:	ff d0                	call   *%eax
  801151:	89 c7                	mov    %eax,%edi
  801153:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801156:	83 ec 08             	sub    $0x8,%esp
  801159:	56                   	push   %esi
  80115a:	6a 00                	push   $0x0
  80115c:	e8 33 fc ff ff       	call   800d94 <sys_page_unmap>
	return r;
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	eb ba                	jmp    801120 <fd_close+0x39>
			r = 0;
  801166:	bf 00 00 00 00       	mov    $0x0,%edi
  80116b:	eb e9                	jmp    801156 <fd_close+0x6f>

0080116d <close>:

int
close(int fdnum)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801173:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801176:	50                   	push   %eax
  801177:	ff 75 08             	pushl  0x8(%ebp)
  80117a:	e8 bb fe ff ff       	call   80103a <fd_lookup>
  80117f:	83 c4 08             	add    $0x8,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	78 10                	js     801196 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801186:	83 ec 08             	sub    $0x8,%esp
  801189:	6a 01                	push   $0x1
  80118b:	ff 75 f4             	pushl  -0xc(%ebp)
  80118e:	e8 54 ff ff ff       	call   8010e7 <fd_close>
  801193:	83 c4 10             	add    $0x10,%esp
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <close_all>:

void
close_all(void)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	53                   	push   %ebx
  80119c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80119f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	53                   	push   %ebx
  8011a8:	e8 c0 ff ff ff       	call   80116d <close>
	for (i = 0; i < MAXFD; i++)
  8011ad:	43                   	inc    %ebx
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	83 fb 20             	cmp    $0x20,%ebx
  8011b4:	75 ee                	jne    8011a4 <close_all+0xc>
}
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	57                   	push   %edi
  8011bf:	56                   	push   %esi
  8011c0:	53                   	push   %ebx
  8011c1:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c7:	50                   	push   %eax
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	e8 6a fe ff ff       	call   80103a <fd_lookup>
  8011d0:	89 c3                	mov    %eax,%ebx
  8011d2:	83 c4 08             	add    $0x8,%esp
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 88 81 00 00 00    	js     80125e <dup+0xa3>
		return r;
	close(newfdnum);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 0c             	pushl  0xc(%ebp)
  8011e3:	e8 85 ff ff ff       	call   80116d <close>

	newfd = INDEX2FD(newfdnum);
  8011e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011eb:	c1 e6 0c             	shl    $0xc,%esi
  8011ee:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011f4:	83 c4 04             	add    $0x4,%esp
  8011f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011fa:	e8 d5 fd ff ff       	call   800fd4 <fd2data>
  8011ff:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801201:	89 34 24             	mov    %esi,(%esp)
  801204:	e8 cb fd ff ff       	call   800fd4 <fd2data>
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80120e:	89 d8                	mov    %ebx,%eax
  801210:	c1 e8 16             	shr    $0x16,%eax
  801213:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80121a:	a8 01                	test   $0x1,%al
  80121c:	74 11                	je     80122f <dup+0x74>
  80121e:	89 d8                	mov    %ebx,%eax
  801220:	c1 e8 0c             	shr    $0xc,%eax
  801223:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80122a:	f6 c2 01             	test   $0x1,%dl
  80122d:	75 39                	jne    801268 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80122f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801232:	89 d0                	mov    %edx,%eax
  801234:	c1 e8 0c             	shr    $0xc,%eax
  801237:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	25 07 0e 00 00       	and    $0xe07,%eax
  801246:	50                   	push   %eax
  801247:	56                   	push   %esi
  801248:	6a 00                	push   $0x0
  80124a:	52                   	push   %edx
  80124b:	6a 00                	push   $0x0
  80124d:	e8 00 fb ff ff       	call   800d52 <sys_page_map>
  801252:	89 c3                	mov    %eax,%ebx
  801254:	83 c4 20             	add    $0x20,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 31                	js     80128c <dup+0xd1>
		goto err;

	return newfdnum;
  80125b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80125e:	89 d8                	mov    %ebx,%eax
  801260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5f                   	pop    %edi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801268:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80126f:	83 ec 0c             	sub    $0xc,%esp
  801272:	25 07 0e 00 00       	and    $0xe07,%eax
  801277:	50                   	push   %eax
  801278:	57                   	push   %edi
  801279:	6a 00                	push   $0x0
  80127b:	53                   	push   %ebx
  80127c:	6a 00                	push   $0x0
  80127e:	e8 cf fa ff ff       	call   800d52 <sys_page_map>
  801283:	89 c3                	mov    %eax,%ebx
  801285:	83 c4 20             	add    $0x20,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	79 a3                	jns    80122f <dup+0x74>
	sys_page_unmap(0, newfd);
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	56                   	push   %esi
  801290:	6a 00                	push   $0x0
  801292:	e8 fd fa ff ff       	call   800d94 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801297:	83 c4 08             	add    $0x8,%esp
  80129a:	57                   	push   %edi
  80129b:	6a 00                	push   $0x0
  80129d:	e8 f2 fa ff ff       	call   800d94 <sys_page_unmap>
	return r;
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	eb b7                	jmp    80125e <dup+0xa3>

008012a7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 14             	sub    $0x14,%esp
  8012ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b4:	50                   	push   %eax
  8012b5:	53                   	push   %ebx
  8012b6:	e8 7f fd ff ff       	call   80103a <fd_lookup>
  8012bb:	83 c4 08             	add    $0x8,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 3f                	js     801301 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c2:	83 ec 08             	sub    $0x8,%esp
  8012c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c8:	50                   	push   %eax
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cc:	ff 30                	pushl  (%eax)
  8012ce:	e8 be fd ff ff       	call   801091 <dev_lookup>
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 27                	js     801301 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012dd:	8b 42 08             	mov    0x8(%edx),%eax
  8012e0:	83 e0 03             	and    $0x3,%eax
  8012e3:	83 f8 01             	cmp    $0x1,%eax
  8012e6:	74 1e                	je     801306 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012eb:	8b 40 08             	mov    0x8(%eax),%eax
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	74 35                	je     801327 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012f2:	83 ec 04             	sub    $0x4,%esp
  8012f5:	ff 75 10             	pushl  0x10(%ebp)
  8012f8:	ff 75 0c             	pushl  0xc(%ebp)
  8012fb:	52                   	push   %edx
  8012fc:	ff d0                	call   *%eax
  8012fe:	83 c4 10             	add    $0x10,%esp
}
  801301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801304:	c9                   	leave  
  801305:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801306:	a1 04 40 80 00       	mov    0x804004,%eax
  80130b:	8b 40 48             	mov    0x48(%eax),%eax
  80130e:	83 ec 04             	sub    $0x4,%esp
  801311:	53                   	push   %ebx
  801312:	50                   	push   %eax
  801313:	68 cd 24 80 00       	push   $0x8024cd
  801318:	e8 35 f0 ff ff       	call   800352 <cprintf>
		return -E_INVAL;
  80131d:	83 c4 10             	add    $0x10,%esp
  801320:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801325:	eb da                	jmp    801301 <read+0x5a>
		return -E_NOT_SUPP;
  801327:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80132c:	eb d3                	jmp    801301 <read+0x5a>

0080132e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	57                   	push   %edi
  801332:	56                   	push   %esi
  801333:	53                   	push   %ebx
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	8b 7d 08             	mov    0x8(%ebp),%edi
  80133a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80133d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801342:	39 f3                	cmp    %esi,%ebx
  801344:	73 25                	jae    80136b <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	89 f0                	mov    %esi,%eax
  80134b:	29 d8                	sub    %ebx,%eax
  80134d:	50                   	push   %eax
  80134e:	89 d8                	mov    %ebx,%eax
  801350:	03 45 0c             	add    0xc(%ebp),%eax
  801353:	50                   	push   %eax
  801354:	57                   	push   %edi
  801355:	e8 4d ff ff ff       	call   8012a7 <read>
		if (m < 0)
  80135a:	83 c4 10             	add    $0x10,%esp
  80135d:	85 c0                	test   %eax,%eax
  80135f:	78 08                	js     801369 <readn+0x3b>
			return m;
		if (m == 0)
  801361:	85 c0                	test   %eax,%eax
  801363:	74 06                	je     80136b <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801365:	01 c3                	add    %eax,%ebx
  801367:	eb d9                	jmp    801342 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801369:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80136b:	89 d8                	mov    %ebx,%eax
  80136d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801370:	5b                   	pop    %ebx
  801371:	5e                   	pop    %esi
  801372:	5f                   	pop    %edi
  801373:	5d                   	pop    %ebp
  801374:	c3                   	ret    

00801375 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	53                   	push   %ebx
  801379:	83 ec 14             	sub    $0x14,%esp
  80137c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	53                   	push   %ebx
  801384:	e8 b1 fc ff ff       	call   80103a <fd_lookup>
  801389:	83 c4 08             	add    $0x8,%esp
  80138c:	85 c0                	test   %eax,%eax
  80138e:	78 3a                	js     8013ca <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801390:	83 ec 08             	sub    $0x8,%esp
  801393:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801396:	50                   	push   %eax
  801397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139a:	ff 30                	pushl  (%eax)
  80139c:	e8 f0 fc ff ff       	call   801091 <dev_lookup>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 22                	js     8013ca <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ab:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013af:	74 1e                	je     8013cf <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b4:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b7:	85 d2                	test   %edx,%edx
  8013b9:	74 35                	je     8013f0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	ff 75 10             	pushl  0x10(%ebp)
  8013c1:	ff 75 0c             	pushl  0xc(%ebp)
  8013c4:	50                   	push   %eax
  8013c5:	ff d2                	call   *%edx
  8013c7:	83 c4 10             	add    $0x10,%esp
}
  8013ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013cf:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d4:	8b 40 48             	mov    0x48(%eax),%eax
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	53                   	push   %ebx
  8013db:	50                   	push   %eax
  8013dc:	68 e9 24 80 00       	push   $0x8024e9
  8013e1:	e8 6c ef ff ff       	call   800352 <cprintf>
		return -E_INVAL;
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ee:	eb da                	jmp    8013ca <write+0x55>
		return -E_NOT_SUPP;
  8013f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f5:	eb d3                	jmp    8013ca <write+0x55>

008013f7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fd:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801400:	50                   	push   %eax
  801401:	ff 75 08             	pushl  0x8(%ebp)
  801404:	e8 31 fc ff ff       	call   80103a <fd_lookup>
  801409:	83 c4 08             	add    $0x8,%esp
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 0e                	js     80141e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801410:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801413:	8b 55 0c             	mov    0xc(%ebp),%edx
  801416:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 14             	sub    $0x14,%esp
  801427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142d:	50                   	push   %eax
  80142e:	53                   	push   %ebx
  80142f:	e8 06 fc ff ff       	call   80103a <fd_lookup>
  801434:	83 c4 08             	add    $0x8,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 37                	js     801472 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801445:	ff 30                	pushl  (%eax)
  801447:	e8 45 fc ff ff       	call   801091 <dev_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 1f                	js     801472 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145a:	74 1b                	je     801477 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80145c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145f:	8b 52 18             	mov    0x18(%edx),%edx
  801462:	85 d2                	test   %edx,%edx
  801464:	74 32                	je     801498 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801466:	83 ec 08             	sub    $0x8,%esp
  801469:	ff 75 0c             	pushl  0xc(%ebp)
  80146c:	50                   	push   %eax
  80146d:	ff d2                	call   *%edx
  80146f:	83 c4 10             	add    $0x10,%esp
}
  801472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801475:	c9                   	leave  
  801476:	c3                   	ret    
			thisenv->env_id, fdnum);
  801477:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80147c:	8b 40 48             	mov    0x48(%eax),%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	53                   	push   %ebx
  801483:	50                   	push   %eax
  801484:	68 ac 24 80 00       	push   $0x8024ac
  801489:	e8 c4 ee ff ff       	call   800352 <cprintf>
		return -E_INVAL;
  80148e:	83 c4 10             	add    $0x10,%esp
  801491:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801496:	eb da                	jmp    801472 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801498:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80149d:	eb d3                	jmp    801472 <ftruncate+0x52>

0080149f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	53                   	push   %ebx
  8014a3:	83 ec 14             	sub    $0x14,%esp
  8014a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ac:	50                   	push   %eax
  8014ad:	ff 75 08             	pushl  0x8(%ebp)
  8014b0:	e8 85 fb ff ff       	call   80103a <fd_lookup>
  8014b5:	83 c4 08             	add    $0x8,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 4b                	js     801507 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c6:	ff 30                	pushl  (%eax)
  8014c8:	e8 c4 fb ff ff       	call   801091 <dev_lookup>
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	78 33                	js     801507 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014db:	74 2f                	je     80150c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014dd:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014e0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014e7:	00 00 00 
	stat->st_type = 0;
  8014ea:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014f1:	00 00 00 
	stat->st_dev = dev;
  8014f4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	53                   	push   %ebx
  8014fe:	ff 75 f0             	pushl  -0x10(%ebp)
  801501:	ff 50 14             	call   *0x14(%eax)
  801504:	83 c4 10             	add    $0x10,%esp
}
  801507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    
		return -E_NOT_SUPP;
  80150c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801511:	eb f4                	jmp    801507 <fstat+0x68>

00801513 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	56                   	push   %esi
  801517:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801518:	83 ec 08             	sub    $0x8,%esp
  80151b:	6a 00                	push   $0x0
  80151d:	ff 75 08             	pushl  0x8(%ebp)
  801520:	e8 34 02 00 00       	call   801759 <open>
  801525:	89 c3                	mov    %eax,%ebx
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 1b                	js     801549 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	ff 75 0c             	pushl  0xc(%ebp)
  801534:	50                   	push   %eax
  801535:	e8 65 ff ff ff       	call   80149f <fstat>
  80153a:	89 c6                	mov    %eax,%esi
	close(fd);
  80153c:	89 1c 24             	mov    %ebx,(%esp)
  80153f:	e8 29 fc ff ff       	call   80116d <close>
	return r;
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	89 f3                	mov    %esi,%ebx
}
  801549:	89 d8                	mov    %ebx,%eax
  80154b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154e:	5b                   	pop    %ebx
  80154f:	5e                   	pop    %esi
  801550:	5d                   	pop    %ebp
  801551:	c3                   	ret    

00801552 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	56                   	push   %esi
  801556:	53                   	push   %ebx
  801557:	89 c6                	mov    %eax,%esi
  801559:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80155b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801562:	74 27                	je     80158b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801564:	6a 07                	push   $0x7
  801566:	68 00 50 80 00       	push   $0x805000
  80156b:	56                   	push   %esi
  80156c:	ff 35 00 40 80 00    	pushl  0x804000
  801572:	e8 e1 07 00 00       	call   801d58 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801577:	83 c4 0c             	add    $0xc,%esp
  80157a:	6a 00                	push   $0x0
  80157c:	53                   	push   %ebx
  80157d:	6a 00                	push   $0x0
  80157f:	e8 4b 07 00 00       	call   801ccf <ipc_recv>
}
  801584:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801587:	5b                   	pop    %ebx
  801588:	5e                   	pop    %esi
  801589:	5d                   	pop    %ebp
  80158a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80158b:	83 ec 0c             	sub    $0xc,%esp
  80158e:	6a 01                	push   $0x1
  801590:	e8 1f 08 00 00       	call   801db4 <ipc_find_env>
  801595:	a3 00 40 80 00       	mov    %eax,0x804000
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	eb c5                	jmp    801564 <fsipc+0x12>

0080159f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ab:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bd:	b8 02 00 00 00       	mov    $0x2,%eax
  8015c2:	e8 8b ff ff ff       	call   801552 <fsipc>
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <devfile_flush>:
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015da:	ba 00 00 00 00       	mov    $0x0,%edx
  8015df:	b8 06 00 00 00       	mov    $0x6,%eax
  8015e4:	e8 69 ff ff ff       	call   801552 <fsipc>
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <devfile_stat>:
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	53                   	push   %ebx
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fb:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801600:	ba 00 00 00 00       	mov    $0x0,%edx
  801605:	b8 05 00 00 00       	mov    $0x5,%eax
  80160a:	e8 43 ff ff ff       	call   801552 <fsipc>
  80160f:	85 c0                	test   %eax,%eax
  801611:	78 2c                	js     80163f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	68 00 50 80 00       	push   $0x805000
  80161b:	53                   	push   %ebx
  80161c:	e8 39 f3 ff ff       	call   80095a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801621:	a1 80 50 80 00       	mov    0x805080,%eax
  801626:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80162c:	a1 84 50 80 00       	mov    0x805084,%eax
  801631:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <devfile_write>:
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	53                   	push   %ebx
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  80164e:	89 d8                	mov    %ebx,%eax
  801650:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801656:	76 05                	jbe    80165d <devfile_write+0x19>
  801658:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80165d:	8b 55 08             	mov    0x8(%ebp),%edx
  801660:	8b 52 0c             	mov    0xc(%edx),%edx
  801663:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801669:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	50                   	push   %eax
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	68 08 50 80 00       	push   $0x805008
  80167a:	e8 4e f4 ff ff       	call   800acd <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  80167f:	ba 00 00 00 00       	mov    $0x0,%edx
  801684:	b8 04 00 00 00       	mov    $0x4,%eax
  801689:	e8 c4 fe ff ff       	call   801552 <fsipc>
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 0b                	js     8016a0 <devfile_write+0x5c>
	assert(r <= n);
  801695:	39 c3                	cmp    %eax,%ebx
  801697:	72 0c                	jb     8016a5 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801699:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80169e:	7f 1e                	jg     8016be <devfile_write+0x7a>
}
  8016a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    
	assert(r <= n);
  8016a5:	68 18 25 80 00       	push   $0x802518
  8016aa:	68 1f 25 80 00       	push   $0x80251f
  8016af:	68 98 00 00 00       	push   $0x98
  8016b4:	68 34 25 80 00       	push   $0x802534
  8016b9:	e8 81 eb ff ff       	call   80023f <_panic>
	assert(r <= PGSIZE);
  8016be:	68 3f 25 80 00       	push   $0x80253f
  8016c3:	68 1f 25 80 00       	push   $0x80251f
  8016c8:	68 99 00 00 00       	push   $0x99
  8016cd:	68 34 25 80 00       	push   $0x802534
  8016d2:	e8 68 eb ff ff       	call   80023f <_panic>

008016d7 <devfile_read>:
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
  8016dc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016ea:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8016fa:	e8 53 fe ff ff       	call   801552 <fsipc>
  8016ff:	89 c3                	mov    %eax,%ebx
  801701:	85 c0                	test   %eax,%eax
  801703:	78 1f                	js     801724 <devfile_read+0x4d>
	assert(r <= n);
  801705:	39 c6                	cmp    %eax,%esi
  801707:	72 24                	jb     80172d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801709:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80170e:	7f 33                	jg     801743 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	50                   	push   %eax
  801714:	68 00 50 80 00       	push   $0x805000
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	e8 ac f3 ff ff       	call   800acd <memmove>
	return r;
  801721:	83 c4 10             	add    $0x10,%esp
}
  801724:	89 d8                	mov    %ebx,%eax
  801726:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801729:	5b                   	pop    %ebx
  80172a:	5e                   	pop    %esi
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    
	assert(r <= n);
  80172d:	68 18 25 80 00       	push   $0x802518
  801732:	68 1f 25 80 00       	push   $0x80251f
  801737:	6a 7c                	push   $0x7c
  801739:	68 34 25 80 00       	push   $0x802534
  80173e:	e8 fc ea ff ff       	call   80023f <_panic>
	assert(r <= PGSIZE);
  801743:	68 3f 25 80 00       	push   $0x80253f
  801748:	68 1f 25 80 00       	push   $0x80251f
  80174d:	6a 7d                	push   $0x7d
  80174f:	68 34 25 80 00       	push   $0x802534
  801754:	e8 e6 ea ff ff       	call   80023f <_panic>

00801759 <open>:
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	83 ec 1c             	sub    $0x1c,%esp
  801761:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801764:	56                   	push   %esi
  801765:	e8 bd f1 ff ff       	call   800927 <strlen>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801772:	7f 6c                	jg     8017e0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801774:	83 ec 0c             	sub    $0xc,%esp
  801777:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177a:	50                   	push   %eax
  80177b:	e8 6b f8 ff ff       	call   800feb <fd_alloc>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 3c                	js     8017c5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	56                   	push   %esi
  80178d:	68 00 50 80 00       	push   $0x805000
  801792:	e8 c3 f1 ff ff       	call   80095a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80179f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a7:	e8 a6 fd ff ff       	call   801552 <fsipc>
  8017ac:	89 c3                	mov    %eax,%ebx
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 19                	js     8017ce <open+0x75>
	return fd2num(fd);
  8017b5:	83 ec 0c             	sub    $0xc,%esp
  8017b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bb:	e8 04 f8 ff ff       	call   800fc4 <fd2num>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	83 c4 10             	add    $0x10,%esp
}
  8017c5:	89 d8                	mov    %ebx,%eax
  8017c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ca:	5b                   	pop    %ebx
  8017cb:	5e                   	pop    %esi
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    
		fd_close(fd, 0);
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	6a 00                	push   $0x0
  8017d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d6:	e8 0c f9 ff ff       	call   8010e7 <fd_close>
		return r;
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	eb e5                	jmp    8017c5 <open+0x6c>
		return -E_BAD_PATH;
  8017e0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017e5:	eb de                	jmp    8017c5 <open+0x6c>

008017e7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8017f7:	e8 56 fd ff ff       	call   801552 <fsipc>
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
  801803:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	e8 c3 f7 ff ff       	call   800fd4 <fd2data>
  801811:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801813:	83 c4 08             	add    $0x8,%esp
  801816:	68 4b 25 80 00       	push   $0x80254b
  80181b:	53                   	push   %ebx
  80181c:	e8 39 f1 ff ff       	call   80095a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801821:	8b 46 04             	mov    0x4(%esi),%eax
  801824:	2b 06                	sub    (%esi),%eax
  801826:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80182c:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801833:	10 00 00 
	stat->st_dev = &devpipe;
  801836:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80183d:	30 80 00 
	return 0;
}
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801848:	5b                   	pop    %ebx
  801849:	5e                   	pop    %esi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	53                   	push   %ebx
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801856:	53                   	push   %ebx
  801857:	6a 00                	push   $0x0
  801859:	e8 36 f5 ff ff       	call   800d94 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80185e:	89 1c 24             	mov    %ebx,(%esp)
  801861:	e8 6e f7 ff ff       	call   800fd4 <fd2data>
  801866:	83 c4 08             	add    $0x8,%esp
  801869:	50                   	push   %eax
  80186a:	6a 00                	push   $0x0
  80186c:	e8 23 f5 ff ff       	call   800d94 <sys_page_unmap>
}
  801871:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <_pipeisclosed>:
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	57                   	push   %edi
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
  80187c:	83 ec 1c             	sub    $0x1c,%esp
  80187f:	89 c7                	mov    %eax,%edi
  801881:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801883:	a1 04 40 80 00       	mov    0x804004,%eax
  801888:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	57                   	push   %edi
  80188f:	e8 62 05 00 00       	call   801df6 <pageref>
  801894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801897:	89 34 24             	mov    %esi,(%esp)
  80189a:	e8 57 05 00 00       	call   801df6 <pageref>
		nn = thisenv->env_runs;
  80189f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8018a5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	39 cb                	cmp    %ecx,%ebx
  8018ad:	74 1b                	je     8018ca <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8018af:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018b2:	75 cf                	jne    801883 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018b4:	8b 42 58             	mov    0x58(%edx),%eax
  8018b7:	6a 01                	push   $0x1
  8018b9:	50                   	push   %eax
  8018ba:	53                   	push   %ebx
  8018bb:	68 52 25 80 00       	push   $0x802552
  8018c0:	e8 8d ea ff ff       	call   800352 <cprintf>
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	eb b9                	jmp    801883 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018ca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018cd:	0f 94 c0             	sete   %al
  8018d0:	0f b6 c0             	movzbl %al,%eax
}
  8018d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d6:	5b                   	pop    %ebx
  8018d7:	5e                   	pop    %esi
  8018d8:	5f                   	pop    %edi
  8018d9:	5d                   	pop    %ebp
  8018da:	c3                   	ret    

008018db <devpipe_write>:
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	57                   	push   %edi
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 18             	sub    $0x18,%esp
  8018e4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018e7:	56                   	push   %esi
  8018e8:	e8 e7 f6 ff ff       	call   800fd4 <fd2data>
  8018ed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8018f7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018fa:	74 41                	je     80193d <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018fc:	8b 53 04             	mov    0x4(%ebx),%edx
  8018ff:	8b 03                	mov    (%ebx),%eax
  801901:	83 c0 20             	add    $0x20,%eax
  801904:	39 c2                	cmp    %eax,%edx
  801906:	72 14                	jb     80191c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801908:	89 da                	mov    %ebx,%edx
  80190a:	89 f0                	mov    %esi,%eax
  80190c:	e8 65 ff ff ff       	call   801876 <_pipeisclosed>
  801911:	85 c0                	test   %eax,%eax
  801913:	75 2c                	jne    801941 <devpipe_write+0x66>
			sys_yield();
  801915:	e8 bc f4 ff ff       	call   800dd6 <sys_yield>
  80191a:	eb e0                	jmp    8018fc <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80191c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191f:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801922:	89 d0                	mov    %edx,%eax
  801924:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801929:	78 0b                	js     801936 <devpipe_write+0x5b>
  80192b:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  80192f:	42                   	inc    %edx
  801930:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801933:	47                   	inc    %edi
  801934:	eb c1                	jmp    8018f7 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801936:	48                   	dec    %eax
  801937:	83 c8 e0             	or     $0xffffffe0,%eax
  80193a:	40                   	inc    %eax
  80193b:	eb ee                	jmp    80192b <devpipe_write+0x50>
	return i;
  80193d:	89 f8                	mov    %edi,%eax
  80193f:	eb 05                	jmp    801946 <devpipe_write+0x6b>
				return 0;
  801941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801946:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    

0080194e <devpipe_read>:
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	57                   	push   %edi
  801952:	56                   	push   %esi
  801953:	53                   	push   %ebx
  801954:	83 ec 18             	sub    $0x18,%esp
  801957:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80195a:	57                   	push   %edi
  80195b:	e8 74 f6 ff ff       	call   800fd4 <fd2data>
  801960:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196a:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80196d:	74 46                	je     8019b5 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  80196f:	8b 06                	mov    (%esi),%eax
  801971:	3b 46 04             	cmp    0x4(%esi),%eax
  801974:	75 22                	jne    801998 <devpipe_read+0x4a>
			if (i > 0)
  801976:	85 db                	test   %ebx,%ebx
  801978:	74 0a                	je     801984 <devpipe_read+0x36>
				return i;
  80197a:	89 d8                	mov    %ebx,%eax
}
  80197c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80197f:	5b                   	pop    %ebx
  801980:	5e                   	pop    %esi
  801981:	5f                   	pop    %edi
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801984:	89 f2                	mov    %esi,%edx
  801986:	89 f8                	mov    %edi,%eax
  801988:	e8 e9 fe ff ff       	call   801876 <_pipeisclosed>
  80198d:	85 c0                	test   %eax,%eax
  80198f:	75 28                	jne    8019b9 <devpipe_read+0x6b>
			sys_yield();
  801991:	e8 40 f4 ff ff       	call   800dd6 <sys_yield>
  801996:	eb d7                	jmp    80196f <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801998:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80199d:	78 0f                	js     8019ae <devpipe_read+0x60>
  80199f:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8019a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019a6:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8019a9:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8019ab:	43                   	inc    %ebx
  8019ac:	eb bc                	jmp    80196a <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019ae:	48                   	dec    %eax
  8019af:	83 c8 e0             	or     $0xffffffe0,%eax
  8019b2:	40                   	inc    %eax
  8019b3:	eb ea                	jmp    80199f <devpipe_read+0x51>
	return i;
  8019b5:	89 d8                	mov    %ebx,%eax
  8019b7:	eb c3                	jmp    80197c <devpipe_read+0x2e>
				return 0;
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019be:	eb bc                	jmp    80197c <devpipe_read+0x2e>

008019c0 <pipe>:
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	56                   	push   %esi
  8019c4:	53                   	push   %ebx
  8019c5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cb:	50                   	push   %eax
  8019cc:	e8 1a f6 ff ff       	call   800feb <fd_alloc>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	0f 88 2a 01 00 00    	js     801b08 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	68 07 04 00 00       	push   $0x407
  8019e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e9:	6a 00                	push   $0x0
  8019eb:	e8 1f f3 ff ff       	call   800d0f <sys_page_alloc>
  8019f0:	89 c3                	mov    %eax,%ebx
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	0f 88 0b 01 00 00    	js     801b08 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  8019fd:	83 ec 0c             	sub    $0xc,%esp
  801a00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a03:	50                   	push   %eax
  801a04:	e8 e2 f5 ff ff       	call   800feb <fd_alloc>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	0f 88 e2 00 00 00    	js     801af8 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	68 07 04 00 00       	push   $0x407
  801a1e:	ff 75 f0             	pushl  -0x10(%ebp)
  801a21:	6a 00                	push   $0x0
  801a23:	e8 e7 f2 ff ff       	call   800d0f <sys_page_alloc>
  801a28:	89 c3                	mov    %eax,%ebx
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	0f 88 c3 00 00 00    	js     801af8 <pipe+0x138>
	va = fd2data(fd0);
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3b:	e8 94 f5 ff ff       	call   800fd4 <fd2data>
  801a40:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a42:	83 c4 0c             	add    $0xc,%esp
  801a45:	68 07 04 00 00       	push   $0x407
  801a4a:	50                   	push   %eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	e8 bd f2 ff ff       	call   800d0f <sys_page_alloc>
  801a52:	89 c3                	mov    %eax,%ebx
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	85 c0                	test   %eax,%eax
  801a59:	0f 88 89 00 00 00    	js     801ae8 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a5f:	83 ec 0c             	sub    $0xc,%esp
  801a62:	ff 75 f0             	pushl  -0x10(%ebp)
  801a65:	e8 6a f5 ff ff       	call   800fd4 <fd2data>
  801a6a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a71:	50                   	push   %eax
  801a72:	6a 00                	push   $0x0
  801a74:	56                   	push   %esi
  801a75:	6a 00                	push   $0x0
  801a77:	e8 d6 f2 ff ff       	call   800d52 <sys_page_map>
  801a7c:	89 c3                	mov    %eax,%ebx
  801a7e:	83 c4 20             	add    $0x20,%esp
  801a81:	85 c0                	test   %eax,%eax
  801a83:	78 55                	js     801ada <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801a85:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a9a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801aaf:	83 ec 0c             	sub    $0xc,%esp
  801ab2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab5:	e8 0a f5 ff ff       	call   800fc4 <fd2num>
  801aba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801abf:	83 c4 04             	add    $0x4,%esp
  801ac2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac5:	e8 fa f4 ff ff       	call   800fc4 <fd2num>
  801aca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801acd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ad8:	eb 2e                	jmp    801b08 <pipe+0x148>
	sys_page_unmap(0, va);
  801ada:	83 ec 08             	sub    $0x8,%esp
  801add:	56                   	push   %esi
  801ade:	6a 00                	push   $0x0
  801ae0:	e8 af f2 ff ff       	call   800d94 <sys_page_unmap>
  801ae5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	ff 75 f0             	pushl  -0x10(%ebp)
  801aee:	6a 00                	push   $0x0
  801af0:	e8 9f f2 ff ff       	call   800d94 <sys_page_unmap>
  801af5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801af8:	83 ec 08             	sub    $0x8,%esp
  801afb:	ff 75 f4             	pushl  -0xc(%ebp)
  801afe:	6a 00                	push   $0x0
  801b00:	e8 8f f2 ff ff       	call   800d94 <sys_page_unmap>
  801b05:	83 c4 10             	add    $0x10,%esp
}
  801b08:	89 d8                	mov    %ebx,%eax
  801b0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0d:	5b                   	pop    %ebx
  801b0e:	5e                   	pop    %esi
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    

00801b11 <pipeisclosed>:
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1a:	50                   	push   %eax
  801b1b:	ff 75 08             	pushl  0x8(%ebp)
  801b1e:	e8 17 f5 ff ff       	call   80103a <fd_lookup>
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 18                	js     801b42 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b2a:	83 ec 0c             	sub    $0xc,%esp
  801b2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b30:	e8 9f f4 ff ff       	call   800fd4 <fd2data>
	return _pipeisclosed(fd, p);
  801b35:	89 c2                	mov    %eax,%edx
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	e8 37 fd ff ff       	call   801876 <_pipeisclosed>
  801b3f:	83 c4 10             	add    $0x10,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	53                   	push   %ebx
  801b52:	83 ec 0c             	sub    $0xc,%esp
  801b55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801b58:	68 6a 25 80 00       	push   $0x80256a
  801b5d:	53                   	push   %ebx
  801b5e:	e8 f7 ed ff ff       	call   80095a <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801b63:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801b6a:	20 00 00 
	return 0;
}
  801b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <devcons_write>:
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	57                   	push   %edi
  801b7b:	56                   	push   %esi
  801b7c:	53                   	push   %ebx
  801b7d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b83:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b88:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b8e:	eb 1d                	jmp    801bad <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	53                   	push   %ebx
  801b94:	03 45 0c             	add    0xc(%ebp),%eax
  801b97:	50                   	push   %eax
  801b98:	57                   	push   %edi
  801b99:	e8 2f ef ff ff       	call   800acd <memmove>
		sys_cputs(buf, m);
  801b9e:	83 c4 08             	add    $0x8,%esp
  801ba1:	53                   	push   %ebx
  801ba2:	57                   	push   %edi
  801ba3:	e8 ca f0 ff ff       	call   800c72 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ba8:	01 de                	add    %ebx,%esi
  801baa:	83 c4 10             	add    $0x10,%esp
  801bad:	89 f0                	mov    %esi,%eax
  801baf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bb2:	73 11                	jae    801bc5 <devcons_write+0x4e>
		m = n - tot;
  801bb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bb7:	29 f3                	sub    %esi,%ebx
  801bb9:	83 fb 7f             	cmp    $0x7f,%ebx
  801bbc:	76 d2                	jbe    801b90 <devcons_write+0x19>
  801bbe:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801bc3:	eb cb                	jmp    801b90 <devcons_write+0x19>
}
  801bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5f                   	pop    %edi
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    

00801bcd <devcons_read>:
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801bd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd7:	75 0c                	jne    801be5 <devcons_read+0x18>
		return 0;
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bde:	eb 21                	jmp    801c01 <devcons_read+0x34>
		sys_yield();
  801be0:	e8 f1 f1 ff ff       	call   800dd6 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801be5:	e8 a6 f0 ff ff       	call   800c90 <sys_cgetc>
  801bea:	85 c0                	test   %eax,%eax
  801bec:	74 f2                	je     801be0 <devcons_read+0x13>
	if (c < 0)
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	78 0f                	js     801c01 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801bf2:	83 f8 04             	cmp    $0x4,%eax
  801bf5:	74 0c                	je     801c03 <devcons_read+0x36>
	*(char*)vbuf = c;
  801bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfa:	88 02                	mov    %al,(%edx)
	return 1;
  801bfc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    
		return 0;
  801c03:	b8 00 00 00 00       	mov    $0x0,%eax
  801c08:	eb f7                	jmp    801c01 <devcons_read+0x34>

00801c0a <cputchar>:
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c16:	6a 01                	push   $0x1
  801c18:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c1b:	50                   	push   %eax
  801c1c:	e8 51 f0 ff ff       	call   800c72 <sys_cputs>
}
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <getchar>:
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c2c:	6a 01                	push   $0x1
  801c2e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c31:	50                   	push   %eax
  801c32:	6a 00                	push   $0x0
  801c34:	e8 6e f6 ff ff       	call   8012a7 <read>
	if (r < 0)
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 08                	js     801c48 <getchar+0x22>
	if (r < 1)
  801c40:	85 c0                	test   %eax,%eax
  801c42:	7e 06                	jle    801c4a <getchar+0x24>
	return c;
  801c44:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    
		return -E_EOF;
  801c4a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c4f:	eb f7                	jmp    801c48 <getchar+0x22>

00801c51 <iscons>:
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5a:	50                   	push   %eax
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	e8 d7 f3 ff ff       	call   80103a <fd_lookup>
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 11                	js     801c7b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c73:	39 10                	cmp    %edx,(%eax)
  801c75:	0f 94 c0             	sete   %al
  801c78:	0f b6 c0             	movzbl %al,%eax
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <opencons>:
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c86:	50                   	push   %eax
  801c87:	e8 5f f3 ff ff       	call   800feb <fd_alloc>
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	78 3a                	js     801ccd <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	68 07 04 00 00       	push   $0x407
  801c9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9e:	6a 00                	push   $0x0
  801ca0:	e8 6a f0 ff ff       	call   800d0f <sys_page_alloc>
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	78 21                	js     801ccd <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801cac:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cba:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	50                   	push   %eax
  801cc5:	e8 fa f2 ff ff       	call   800fc4 <fd2num>
  801cca:	83 c4 10             	add    $0x10,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	57                   	push   %edi
  801cd3:	56                   	push   %esi
  801cd4:	53                   	push   %ebx
  801cd5:	83 ec 0c             	sub    $0xc,%esp
  801cd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801cdb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cde:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801ce1:	85 ff                	test   %edi,%edi
  801ce3:	74 53                	je     801d38 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801ce5:	83 ec 0c             	sub    $0xc,%esp
  801ce8:	57                   	push   %edi
  801ce9:	e8 31 f2 ff ff       	call   800f1f <sys_ipc_recv>
  801cee:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801cf1:	85 db                	test   %ebx,%ebx
  801cf3:	74 0b                	je     801d00 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801cf5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cfb:	8b 52 74             	mov    0x74(%edx),%edx
  801cfe:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801d00:	85 f6                	test   %esi,%esi
  801d02:	74 0f                	je     801d13 <ipc_recv+0x44>
  801d04:	85 ff                	test   %edi,%edi
  801d06:	74 0b                	je     801d13 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801d08:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d0e:	8b 52 78             	mov    0x78(%edx),%edx
  801d11:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801d13:	85 c0                	test   %eax,%eax
  801d15:	74 30                	je     801d47 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801d17:	85 db                	test   %ebx,%ebx
  801d19:	74 06                	je     801d21 <ipc_recv+0x52>
      		*from_env_store = 0;
  801d1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801d21:	85 f6                	test   %esi,%esi
  801d23:	74 2c                	je     801d51 <ipc_recv+0x82>
      		*perm_store = 0;
  801d25:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801d2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	6a ff                	push   $0xffffffff
  801d3d:	e8 dd f1 ff ff       	call   800f1f <sys_ipc_recv>
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	eb aa                	jmp    801cf1 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801d47:	a1 04 40 80 00       	mov    0x804004,%eax
  801d4c:	8b 40 70             	mov    0x70(%eax),%eax
  801d4f:	eb df                	jmp    801d30 <ipc_recv+0x61>
		return -1;
  801d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d56:	eb d8                	jmp    801d30 <ipc_recv+0x61>

00801d58 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	57                   	push   %edi
  801d5c:	56                   	push   %esi
  801d5d:	53                   	push   %ebx
  801d5e:	83 ec 0c             	sub    $0xc,%esp
  801d61:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d67:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801d6a:	85 db                	test   %ebx,%ebx
  801d6c:	75 22                	jne    801d90 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801d6e:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801d73:	eb 1b                	jmp    801d90 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801d75:	68 78 25 80 00       	push   $0x802578
  801d7a:	68 1f 25 80 00       	push   $0x80251f
  801d7f:	6a 48                	push   $0x48
  801d81:	68 9c 25 80 00       	push   $0x80259c
  801d86:	e8 b4 e4 ff ff       	call   80023f <_panic>
		sys_yield();
  801d8b:	e8 46 f0 ff ff       	call   800dd6 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801d90:	57                   	push   %edi
  801d91:	53                   	push   %ebx
  801d92:	56                   	push   %esi
  801d93:	ff 75 08             	pushl  0x8(%ebp)
  801d96:	e8 61 f1 ff ff       	call   800efc <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801da1:	74 e8                	je     801d8b <ipc_send+0x33>
  801da3:	85 c0                	test   %eax,%eax
  801da5:	75 ce                	jne    801d75 <ipc_send+0x1d>
		sys_yield();
  801da7:	e8 2a f0 ff ff       	call   800dd6 <sys_yield>
		
	}
	
}
  801dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5e                   	pop    %esi
  801db1:	5f                   	pop    %edi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    

00801db4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801dbf:	89 c2                	mov    %eax,%edx
  801dc1:	c1 e2 05             	shl    $0x5,%edx
  801dc4:	29 c2                	sub    %eax,%edx
  801dc6:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801dcd:	8b 52 50             	mov    0x50(%edx),%edx
  801dd0:	39 ca                	cmp    %ecx,%edx
  801dd2:	74 0f                	je     801de3 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801dd4:	40                   	inc    %eax
  801dd5:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dda:	75 e3                	jne    801dbf <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  801de1:	eb 11                	jmp    801df4 <ipc_find_env+0x40>
			return envs[i].env_id;
  801de3:	89 c2                	mov    %eax,%edx
  801de5:	c1 e2 05             	shl    $0x5,%edx
  801de8:	29 c2                	sub    %eax,%edx
  801dea:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801df1:	8b 40 48             	mov    0x48(%eax),%eax
}
  801df4:	5d                   	pop    %ebp
  801df5:	c3                   	ret    

00801df6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	c1 e8 16             	shr    $0x16,%eax
  801dff:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e06:	a8 01                	test   $0x1,%al
  801e08:	74 21                	je     801e2b <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	c1 e8 0c             	shr    $0xc,%eax
  801e10:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801e17:	a8 01                	test   $0x1,%al
  801e19:	74 17                	je     801e32 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e1b:	c1 e8 0c             	shr    $0xc,%eax
  801e1e:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801e25:	ef 
  801e26:	0f b7 c0             	movzwl %ax,%eax
  801e29:	eb 05                	jmp    801e30 <pageref+0x3a>
		return 0;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    
		return 0;
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
  801e37:	eb f7                	jmp    801e30 <pageref+0x3a>
  801e39:	66 90                	xchg   %ax,%ax
  801e3b:	90                   	nop

00801e3c <__udivdi3>:
  801e3c:	55                   	push   %ebp
  801e3d:	57                   	push   %edi
  801e3e:	56                   	push   %esi
  801e3f:	53                   	push   %ebx
  801e40:	83 ec 1c             	sub    $0x1c,%esp
  801e43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e4f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e53:	89 ca                	mov    %ecx,%edx
  801e55:	89 f8                	mov    %edi,%eax
  801e57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e5b:	85 f6                	test   %esi,%esi
  801e5d:	75 2d                	jne    801e8c <__udivdi3+0x50>
  801e5f:	39 cf                	cmp    %ecx,%edi
  801e61:	77 65                	ja     801ec8 <__udivdi3+0x8c>
  801e63:	89 fd                	mov    %edi,%ebp
  801e65:	85 ff                	test   %edi,%edi
  801e67:	75 0b                	jne    801e74 <__udivdi3+0x38>
  801e69:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6e:	31 d2                	xor    %edx,%edx
  801e70:	f7 f7                	div    %edi
  801e72:	89 c5                	mov    %eax,%ebp
  801e74:	31 d2                	xor    %edx,%edx
  801e76:	89 c8                	mov    %ecx,%eax
  801e78:	f7 f5                	div    %ebp
  801e7a:	89 c1                	mov    %eax,%ecx
  801e7c:	89 d8                	mov    %ebx,%eax
  801e7e:	f7 f5                	div    %ebp
  801e80:	89 cf                	mov    %ecx,%edi
  801e82:	89 fa                	mov    %edi,%edx
  801e84:	83 c4 1c             	add    $0x1c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
  801e8c:	39 ce                	cmp    %ecx,%esi
  801e8e:	77 28                	ja     801eb8 <__udivdi3+0x7c>
  801e90:	0f bd fe             	bsr    %esi,%edi
  801e93:	83 f7 1f             	xor    $0x1f,%edi
  801e96:	75 40                	jne    801ed8 <__udivdi3+0x9c>
  801e98:	39 ce                	cmp    %ecx,%esi
  801e9a:	72 0a                	jb     801ea6 <__udivdi3+0x6a>
  801e9c:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801ea0:	0f 87 9e 00 00 00    	ja     801f44 <__udivdi3+0x108>
  801ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eab:	89 fa                	mov    %edi,%edx
  801ead:	83 c4 1c             	add    $0x1c,%esp
  801eb0:	5b                   	pop    %ebx
  801eb1:	5e                   	pop    %esi
  801eb2:	5f                   	pop    %edi
  801eb3:	5d                   	pop    %ebp
  801eb4:	c3                   	ret    
  801eb5:	8d 76 00             	lea    0x0(%esi),%esi
  801eb8:	31 ff                	xor    %edi,%edi
  801eba:	31 c0                	xor    %eax,%eax
  801ebc:	89 fa                	mov    %edi,%edx
  801ebe:	83 c4 1c             	add    $0x1c,%esp
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    
  801ec6:	66 90                	xchg   %ax,%ax
  801ec8:	89 d8                	mov    %ebx,%eax
  801eca:	f7 f7                	div    %edi
  801ecc:	31 ff                	xor    %edi,%edi
  801ece:	89 fa                	mov    %edi,%edx
  801ed0:	83 c4 1c             	add    $0x1c,%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5f                   	pop    %edi
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    
  801ed8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801edd:	29 fd                	sub    %edi,%ebp
  801edf:	89 f9                	mov    %edi,%ecx
  801ee1:	d3 e6                	shl    %cl,%esi
  801ee3:	89 c3                	mov    %eax,%ebx
  801ee5:	89 e9                	mov    %ebp,%ecx
  801ee7:	d3 eb                	shr    %cl,%ebx
  801ee9:	89 d9                	mov    %ebx,%ecx
  801eeb:	09 f1                	or     %esi,%ecx
  801eed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ef1:	89 f9                	mov    %edi,%ecx
  801ef3:	d3 e0                	shl    %cl,%eax
  801ef5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ef9:	89 d6                	mov    %edx,%esi
  801efb:	89 e9                	mov    %ebp,%ecx
  801efd:	d3 ee                	shr    %cl,%esi
  801eff:	89 f9                	mov    %edi,%ecx
  801f01:	d3 e2                	shl    %cl,%edx
  801f03:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801f07:	89 e9                	mov    %ebp,%ecx
  801f09:	d3 eb                	shr    %cl,%ebx
  801f0b:	09 da                	or     %ebx,%edx
  801f0d:	89 d0                	mov    %edx,%eax
  801f0f:	89 f2                	mov    %esi,%edx
  801f11:	f7 74 24 08          	divl   0x8(%esp)
  801f15:	89 d6                	mov    %edx,%esi
  801f17:	89 c3                	mov    %eax,%ebx
  801f19:	f7 64 24 0c          	mull   0xc(%esp)
  801f1d:	39 d6                	cmp    %edx,%esi
  801f1f:	72 17                	jb     801f38 <__udivdi3+0xfc>
  801f21:	74 09                	je     801f2c <__udivdi3+0xf0>
  801f23:	89 d8                	mov    %ebx,%eax
  801f25:	31 ff                	xor    %edi,%edi
  801f27:	e9 56 ff ff ff       	jmp    801e82 <__udivdi3+0x46>
  801f2c:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f30:	89 f9                	mov    %edi,%ecx
  801f32:	d3 e2                	shl    %cl,%edx
  801f34:	39 c2                	cmp    %eax,%edx
  801f36:	73 eb                	jae    801f23 <__udivdi3+0xe7>
  801f38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f3b:	31 ff                	xor    %edi,%edi
  801f3d:	e9 40 ff ff ff       	jmp    801e82 <__udivdi3+0x46>
  801f42:	66 90                	xchg   %ax,%ax
  801f44:	31 c0                	xor    %eax,%eax
  801f46:	e9 37 ff ff ff       	jmp    801e82 <__udivdi3+0x46>
  801f4b:	90                   	nop

00801f4c <__umoddi3>:
  801f4c:	55                   	push   %ebp
  801f4d:	57                   	push   %edi
  801f4e:	56                   	push   %esi
  801f4f:	53                   	push   %ebx
  801f50:	83 ec 1c             	sub    $0x1c,%esp
  801f53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f57:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f6b:	89 3c 24             	mov    %edi,(%esp)
  801f6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f72:	89 f2                	mov    %esi,%edx
  801f74:	85 c0                	test   %eax,%eax
  801f76:	75 18                	jne    801f90 <__umoddi3+0x44>
  801f78:	39 f7                	cmp    %esi,%edi
  801f7a:	0f 86 a0 00 00 00    	jbe    802020 <__umoddi3+0xd4>
  801f80:	89 c8                	mov    %ecx,%eax
  801f82:	f7 f7                	div    %edi
  801f84:	89 d0                	mov    %edx,%eax
  801f86:	31 d2                	xor    %edx,%edx
  801f88:	83 c4 1c             	add    $0x1c,%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5f                   	pop    %edi
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    
  801f90:	89 f3                	mov    %esi,%ebx
  801f92:	39 f0                	cmp    %esi,%eax
  801f94:	0f 87 a6 00 00 00    	ja     802040 <__umoddi3+0xf4>
  801f9a:	0f bd e8             	bsr    %eax,%ebp
  801f9d:	83 f5 1f             	xor    $0x1f,%ebp
  801fa0:	0f 84 a6 00 00 00    	je     80204c <__umoddi3+0x100>
  801fa6:	bf 20 00 00 00       	mov    $0x20,%edi
  801fab:	29 ef                	sub    %ebp,%edi
  801fad:	89 e9                	mov    %ebp,%ecx
  801faf:	d3 e0                	shl    %cl,%eax
  801fb1:	8b 34 24             	mov    (%esp),%esi
  801fb4:	89 f2                	mov    %esi,%edx
  801fb6:	89 f9                	mov    %edi,%ecx
  801fb8:	d3 ea                	shr    %cl,%edx
  801fba:	09 c2                	or     %eax,%edx
  801fbc:	89 14 24             	mov    %edx,(%esp)
  801fbf:	89 f2                	mov    %esi,%edx
  801fc1:	89 e9                	mov    %ebp,%ecx
  801fc3:	d3 e2                	shl    %cl,%edx
  801fc5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fc9:	89 de                	mov    %ebx,%esi
  801fcb:	89 f9                	mov    %edi,%ecx
  801fcd:	d3 ee                	shr    %cl,%esi
  801fcf:	89 e9                	mov    %ebp,%ecx
  801fd1:	d3 e3                	shl    %cl,%ebx
  801fd3:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fd7:	89 d0                	mov    %edx,%eax
  801fd9:	89 f9                	mov    %edi,%ecx
  801fdb:	d3 e8                	shr    %cl,%eax
  801fdd:	09 d8                	or     %ebx,%eax
  801fdf:	89 d3                	mov    %edx,%ebx
  801fe1:	89 e9                	mov    %ebp,%ecx
  801fe3:	d3 e3                	shl    %cl,%ebx
  801fe5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fe9:	89 f2                	mov    %esi,%edx
  801feb:	f7 34 24             	divl   (%esp)
  801fee:	89 d6                	mov    %edx,%esi
  801ff0:	f7 64 24 04          	mull   0x4(%esp)
  801ff4:	89 c3                	mov    %eax,%ebx
  801ff6:	89 d1                	mov    %edx,%ecx
  801ff8:	39 d6                	cmp    %edx,%esi
  801ffa:	72 7c                	jb     802078 <__umoddi3+0x12c>
  801ffc:	74 72                	je     802070 <__umoddi3+0x124>
  801ffe:	8b 54 24 08          	mov    0x8(%esp),%edx
  802002:	29 da                	sub    %ebx,%edx
  802004:	19 ce                	sbb    %ecx,%esi
  802006:	89 f0                	mov    %esi,%eax
  802008:	89 f9                	mov    %edi,%ecx
  80200a:	d3 e0                	shl    %cl,%eax
  80200c:	89 e9                	mov    %ebp,%ecx
  80200e:	d3 ea                	shr    %cl,%edx
  802010:	09 d0                	or     %edx,%eax
  802012:	89 e9                	mov    %ebp,%ecx
  802014:	d3 ee                	shr    %cl,%esi
  802016:	89 f2                	mov    %esi,%edx
  802018:	83 c4 1c             	add    $0x1c,%esp
  80201b:	5b                   	pop    %ebx
  80201c:	5e                   	pop    %esi
  80201d:	5f                   	pop    %edi
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    
  802020:	89 fd                	mov    %edi,%ebp
  802022:	85 ff                	test   %edi,%edi
  802024:	75 0b                	jne    802031 <__umoddi3+0xe5>
  802026:	b8 01 00 00 00       	mov    $0x1,%eax
  80202b:	31 d2                	xor    %edx,%edx
  80202d:	f7 f7                	div    %edi
  80202f:	89 c5                	mov    %eax,%ebp
  802031:	89 f0                	mov    %esi,%eax
  802033:	31 d2                	xor    %edx,%edx
  802035:	f7 f5                	div    %ebp
  802037:	89 c8                	mov    %ecx,%eax
  802039:	f7 f5                	div    %ebp
  80203b:	e9 44 ff ff ff       	jmp    801f84 <__umoddi3+0x38>
  802040:	89 c8                	mov    %ecx,%eax
  802042:	89 f2                	mov    %esi,%edx
  802044:	83 c4 1c             	add    $0x1c,%esp
  802047:	5b                   	pop    %ebx
  802048:	5e                   	pop    %esi
  802049:	5f                   	pop    %edi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    
  80204c:	39 f0                	cmp    %esi,%eax
  80204e:	72 05                	jb     802055 <__umoddi3+0x109>
  802050:	39 0c 24             	cmp    %ecx,(%esp)
  802053:	77 0c                	ja     802061 <__umoddi3+0x115>
  802055:	89 f2                	mov    %esi,%edx
  802057:	29 f9                	sub    %edi,%ecx
  802059:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80205d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802061:	8b 44 24 04          	mov    0x4(%esp),%eax
  802065:	83 c4 1c             	add    $0x1c,%esp
  802068:	5b                   	pop    %ebx
  802069:	5e                   	pop    %esi
  80206a:	5f                   	pop    %edi
  80206b:	5d                   	pop    %ebp
  80206c:	c3                   	ret    
  80206d:	8d 76 00             	lea    0x0(%esi),%esi
  802070:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802074:	73 88                	jae    801ffe <__umoddi3+0xb2>
  802076:	66 90                	xchg   %ax,%ax
  802078:	2b 44 24 04          	sub    0x4(%esp),%eax
  80207c:	1b 14 24             	sbb    (%esp),%edx
  80207f:	89 d1                	mov    %edx,%ecx
  802081:	89 c3                	mov    %eax,%ebx
  802083:	e9 76 ff ff ff       	jmp    801ffe <__umoddi3+0xb2>
