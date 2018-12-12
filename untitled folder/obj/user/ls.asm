
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 ba 02 00 00       	call   8002eb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, uint32_t type, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	89 c3                	mov    %eax,%ebx
  80003a:	89 d6                	mov    %edx,%esi
	const char *sep;

	if (flag['l'])
  80003c:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800043:	74 29                	je     80006e <ls1+0x3b>
		printf("%11d %c ", size, FTYPE_ISDIR(type) ? 'd' : '-');
  800045:	89 d0                	mov    %edx,%eax
  800047:	25 00 f0 00 00       	and    $0xf000,%eax
  80004c:	3d 00 40 00 00       	cmp    $0x4000,%eax
  800051:	0f 84 80 00 00 00    	je     8000d7 <ls1+0xa4>
  800057:	b8 2d 00 00 00       	mov    $0x2d,%eax
  80005c:	83 ec 04             	sub    $0x4,%esp
  80005f:	50                   	push   %eax
  800060:	51                   	push   %ecx
  800061:	68 22 24 80 00       	push   $0x802422
  800066:	e8 53 1a 00 00       	call   801abe <printf>
  80006b:	83 c4 10             	add    $0x10,%esp
	if (prefix) {
  80006e:	85 db                	test   %ebx,%ebx
  800070:	74 1c                	je     80008e <ls1+0x5b>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800072:	80 3b 00             	cmpb   $0x0,(%ebx)
  800075:	75 6a                	jne    8000e1 <ls1+0xae>
			sep = "/";
		else
			sep = "";
  800077:	b8 8a 24 80 00       	mov    $0x80248a,%eax
		printf("%s%s", prefix, sep);
  80007c:	83 ec 04             	sub    $0x4,%esp
  80007f:	50                   	push   %eax
  800080:	53                   	push   %ebx
  800081:	68 2b 24 80 00       	push   $0x80242b
  800086:	e8 33 1a 00 00       	call   801abe <printf>
  80008b:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	ff 75 08             	pushl  0x8(%ebp)
  800094:	68 b1 28 80 00       	push   $0x8028b1
  800099:	e8 20 1a 00 00       	call   801abe <printf>
	if (flag['F'] && FTYPE_ISDIR(type))
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a8:	74 16                	je     8000c0 <ls1+0x8d>
  8000aa:	89 f0                	mov    %esi,%eax
  8000ac:	25 00 f0 00 00       	and    $0xf000,%eax
  8000b1:	3d 00 40 00 00       	cmp    $0x4000,%eax
  8000b6:	74 4d                	je     800105 <ls1+0xd2>
		printf("/");
	if (flag['F'] && (type & FTYPE_IEXEC))
  8000b8:	f7 c6 40 00 00 00    	test   $0x40,%esi
  8000be:	75 60                	jne    800120 <ls1+0xed>
		printf("*");
	printf("\n");
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 89 24 80 00       	push   $0x802489
  8000c8:	e8 f1 19 00 00       	call   801abe <printf>
}
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000d3:	5b                   	pop    %ebx
  8000d4:	5e                   	pop    %esi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    
		printf("%11d %c ", size, FTYPE_ISDIR(type) ? 'd' : '-');
  8000d7:	b8 64 00 00 00       	mov    $0x64,%eax
  8000dc:	e9 7b ff ff ff       	jmp    80005c <ls1+0x29>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	53                   	push   %ebx
  8000e5:	e8 a7 08 00 00       	call   800991 <strlen>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000f2:	74 07                	je     8000fb <ls1+0xc8>
			sep = "/";
  8000f4:	b8 20 24 80 00       	mov    $0x802420,%eax
  8000f9:	eb 81                	jmp    80007c <ls1+0x49>
			sep = "";
  8000fb:	b8 8a 24 80 00       	mov    $0x80248a,%eax
  800100:	e9 77 ff ff ff       	jmp    80007c <ls1+0x49>
		printf("/");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 20 24 80 00       	push   $0x802420
  80010d:	e8 ac 19 00 00       	call   801abe <printf>
	if (flag['F'] && (type & FTYPE_IEXEC))
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  80011c:	75 9a                	jne    8000b8 <ls1+0x85>
  80011e:	eb a0                	jmp    8000c0 <ls1+0x8d>
		printf("*");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 30 24 80 00       	push   $0x802430
  800128:	e8 91 19 00 00       	call   801abe <printf>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	eb 8e                	jmp    8000c0 <ls1+0x8d>

00800132 <ls>:
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	81 ec a4 01 00 00    	sub    $0x1a4,%esp
  80013e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  800141:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  800147:	50                   	push   %eax
  800148:	53                   	push   %ebx
  800149:	e8 88 15 00 00       	call   8016d6 <stat>
  80014e:	83 c4 10             	add    $0x10,%esp
  800151:	85 c0                	test   %eax,%eax
  800153:	78 2d                	js     800182 <ls+0x50>
	if (FTYPE_ISDIR(st.st_type) && !flag['d'])
  800155:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800158:	89 d0                	mov    %edx,%eax
  80015a:	25 00 f0 00 00       	and    $0xf000,%eax
  80015f:	3d 00 40 00 00       	cmp    $0x4000,%eax
  800164:	74 32                	je     800198 <ls+0x66>
		ls1(0, st.st_type, st.st_size, path);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	53                   	push   %ebx
  80016a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80016d:	b8 00 00 00 00       	mov    $0x0,%eax
  800172:	e8 bc fe ff ff       	call   800033 <ls1>
  800177:	83 c4 10             	add    $0x10,%esp
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("stat %s: %e", path, r);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	53                   	push   %ebx
  800187:	68 32 24 80 00       	push   $0x802432
  80018c:	6a 0f                	push   $0xf
  80018e:	68 3e 24 80 00       	push   $0x80243e
  800193:	e8 b9 01 00 00       	call   800351 <_panic>
	if (FTYPE_ISDIR(st.st_type) && !flag['d'])
  800198:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  80019f:	75 c5                	jne    800166 <ls+0x34>
	if ((fd = open(path, O_RDONLY)) < 0)
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	6a 00                	push   $0x0
  8001a6:	53                   	push   %ebx
  8001a7:	e8 70 17 00 00       	call   80191c <open>
  8001ac:	89 c6                	mov    %eax,%esi
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	85 c0                	test   %eax,%eax
  8001b3:	78 45                	js     8001fa <ls+0xc8>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001b5:	8d bd 5c fe ff ff    	lea    -0x1a4(%ebp),%edi
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 00 01 00 00       	push   $0x100
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	e8 27 13 00 00       	call   8014f1 <readn>
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001d2:	75 3c                	jne    800210 <ls+0xde>
		if (f.f_name[0])
  8001d4:	80 bd 5c fe ff ff 00 	cmpb   $0x0,-0x1a4(%ebp)
  8001db:	74 de                	je     8001bb <ls+0x89>
			ls1(prefix, f.f_type, f.f_size, f.f_name);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	57                   	push   %edi
  8001e1:	8b 8d dc fe ff ff    	mov    -0x124(%ebp),%ecx
  8001e7:	8b 95 e0 fe ff ff    	mov    -0x120(%ebp),%edx
  8001ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f0:	e8 3e fe ff ff       	call   800033 <ls1>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	eb c1                	jmp    8001bb <ls+0x89>
		panic("open %s: %e", path, fd);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	53                   	push   %ebx
  8001ff:	68 48 24 80 00       	push   $0x802448
  800204:	6a 1d                	push   $0x1d
  800206:	68 3e 24 80 00       	push   $0x80243e
  80020b:	e8 41 01 00 00       	call   800351 <_panic>
	if (n > 0)
  800210:	85 c0                	test   %eax,%eax
  800212:	7f 1e                	jg     800232 <ls+0x100>
	if (n < 0)
  800214:	85 c0                	test   %eax,%eax
  800216:	0f 89 5e ff ff ff    	jns    80017a <ls+0x48>
		panic("error reading directory %s: %e", path, n);
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	53                   	push   %ebx
  800221:	68 8c 24 80 00       	push   $0x80248c
  800226:	6a 24                	push   $0x24
  800228:	68 3e 24 80 00       	push   $0x80243e
  80022d:	e8 1f 01 00 00       	call   800351 <_panic>
		panic("short read in directory %s", path);
  800232:	53                   	push   %ebx
  800233:	68 54 24 80 00       	push   $0x802454
  800238:	6a 22                	push   $0x22
  80023a:	68 3e 24 80 00       	push   $0x80243e
  80023f:	e8 0d 01 00 00       	call   800351 <_panic>

00800244 <usage>:

void
usage(void)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  80024a:	68 6f 24 80 00       	push   $0x80246f
  80024f:	e8 6a 18 00 00       	call   801abe <printf>
	exit();
  800254:	e8 de 00 00 00       	call   800337 <exit>
}
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <umain>:

void
umain(int argc, char **argv)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
  800263:	83 ec 14             	sub    $0x14,%esp
  800266:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800269:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	56                   	push   %esi
  80026e:	8d 45 08             	lea    0x8(%ebp),%eax
  800271:	50                   	push   %eax
  800272:	e8 b7 0d 00 00       	call   80102e <argstart>
	while ((i = argnext(&args)) >= 0)
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  80027d:	eb 07                	jmp    800286 <umain+0x28>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  80027f:	ff 04 85 20 40 80 00 	incl   0x804020(,%eax,4)
	while ((i = argnext(&args)) >= 0)
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	53                   	push   %ebx
  80028a:	e8 d8 0d 00 00       	call   801067 <argnext>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	85 c0                	test   %eax,%eax
  800294:	78 16                	js     8002ac <umain+0x4e>
		switch (i) {
  800296:	83 f8 64             	cmp    $0x64,%eax
  800299:	74 e4                	je     80027f <umain+0x21>
  80029b:	83 f8 6c             	cmp    $0x6c,%eax
  80029e:	74 df                	je     80027f <umain+0x21>
  8002a0:	83 f8 46             	cmp    $0x46,%eax
  8002a3:	74 da                	je     80027f <umain+0x21>
			break;
		default:
			usage();
  8002a5:	e8 9a ff ff ff       	call   800244 <usage>
  8002aa:	eb da                	jmp    800286 <umain+0x28>
  8002ac:	bb 01 00 00 00       	mov    $0x1,%ebx
		}

	if (argc == 1)
  8002b1:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002b5:	75 28                	jne    8002df <umain+0x81>
		ls("/", "");
  8002b7:	83 ec 08             	sub    $0x8,%esp
  8002ba:	68 8a 24 80 00       	push   $0x80248a
  8002bf:	68 20 24 80 00       	push   $0x802420
  8002c4:	e8 69 fe ff ff       	call   800132 <ls>
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	eb 16                	jmp    8002e4 <umain+0x86>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  8002ce:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002d1:	83 ec 08             	sub    $0x8,%esp
  8002d4:	50                   	push   %eax
  8002d5:	50                   	push   %eax
  8002d6:	e8 57 fe ff ff       	call   800132 <ls>
		for (i = 1; i < argc; i++)
  8002db:	43                   	inc    %ebx
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8002e2:	7c ea                	jl     8002ce <umain+0x70>
	}
}
  8002e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002e7:	5b                   	pop    %ebx
  8002e8:	5e                   	pop    %esi
  8002e9:	5d                   	pop    %ebp
  8002ea:	c3                   	ret    

008002eb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	56                   	push   %esi
  8002ef:	53                   	push   %ebx
  8002f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002f3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002f6:	e8 5f 0a 00 00       	call   800d5a <sys_getenvid>
  8002fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800300:	89 c2                	mov    %eax,%edx
  800302:	c1 e2 05             	shl    $0x5,%edx
  800305:	29 c2                	sub    %eax,%edx
  800307:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80030e:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800313:	85 db                	test   %ebx,%ebx
  800315:	7e 07                	jle    80031e <libmain+0x33>
		binaryname = argv[0];
  800317:	8b 06                	mov    (%esi),%eax
  800319:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	56                   	push   %esi
  800322:	53                   	push   %ebx
  800323:	e8 36 ff ff ff       	call   80025e <umain>

	// exit gracefully
	exit();
  800328:	e8 0a 00 00 00       	call   800337 <exit>
}
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5d                   	pop    %ebp
  800336:	c3                   	ret    

00800337 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80033d:	e8 19 10 00 00       	call   80135b <close_all>
	sys_env_destroy(0);
  800342:	83 ec 0c             	sub    $0xc,%esp
  800345:	6a 00                	push   $0x0
  800347:	e8 cd 09 00 00       	call   800d19 <sys_env_destroy>
}
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	57                   	push   %edi
  800355:	56                   	push   %esi
  800356:	53                   	push   %ebx
  800357:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80035d:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800360:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800366:	e8 ef 09 00 00       	call   800d5a <sys_getenvid>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	ff 75 0c             	pushl  0xc(%ebp)
  800371:	ff 75 08             	pushl  0x8(%ebp)
  800374:	53                   	push   %ebx
  800375:	50                   	push   %eax
  800376:	68 b8 24 80 00       	push   $0x8024b8
  80037b:	68 00 01 00 00       	push   $0x100
  800380:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800386:	56                   	push   %esi
  800387:	e8 eb 05 00 00       	call   800977 <snprintf>
  80038c:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80038e:	83 c4 20             	add    $0x20,%esp
  800391:	57                   	push   %edi
  800392:	ff 75 10             	pushl  0x10(%ebp)
  800395:	bf 00 01 00 00       	mov    $0x100,%edi
  80039a:	89 f8                	mov    %edi,%eax
  80039c:	29 d8                	sub    %ebx,%eax
  80039e:	50                   	push   %eax
  80039f:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8003a2:	50                   	push   %eax
  8003a3:	e8 7a 05 00 00       	call   800922 <vsnprintf>
  8003a8:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8003aa:	83 c4 0c             	add    $0xc,%esp
  8003ad:	68 89 24 80 00       	push   $0x802489
  8003b2:	29 df                	sub    %ebx,%edi
  8003b4:	57                   	push   %edi
  8003b5:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8003b8:	50                   	push   %eax
  8003b9:	e8 b9 05 00 00       	call   800977 <snprintf>
	sys_cputs(buf, r);
  8003be:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8003c1:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8003c3:	53                   	push   %ebx
  8003c4:	56                   	push   %esi
  8003c5:	e8 12 09 00 00       	call   800cdc <sys_cputs>
  8003ca:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003cd:	cc                   	int3   
  8003ce:	eb fd                	jmp    8003cd <_panic+0x7c>

008003d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	57                   	push   %edi
  8003d4:	56                   	push   %esi
  8003d5:	53                   	push   %ebx
  8003d6:	83 ec 1c             	sub    $0x1c,%esp
  8003d9:	89 c7                	mov    %eax,%edi
  8003db:	89 d6                	mov    %edx,%esi
  8003dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003f1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003f4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003f7:	39 d3                	cmp    %edx,%ebx
  8003f9:	72 05                	jb     800400 <printnum+0x30>
  8003fb:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003fe:	77 78                	ja     800478 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800400:	83 ec 0c             	sub    $0xc,%esp
  800403:	ff 75 18             	pushl  0x18(%ebp)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80040c:	53                   	push   %ebx
  80040d:	ff 75 10             	pushl  0x10(%ebp)
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	ff 75 e4             	pushl  -0x1c(%ebp)
  800416:	ff 75 e0             	pushl  -0x20(%ebp)
  800419:	ff 75 dc             	pushl  -0x24(%ebp)
  80041c:	ff 75 d8             	pushl  -0x28(%ebp)
  80041f:	e8 94 1d 00 00       	call   8021b8 <__udivdi3>
  800424:	83 c4 18             	add    $0x18,%esp
  800427:	52                   	push   %edx
  800428:	50                   	push   %eax
  800429:	89 f2                	mov    %esi,%edx
  80042b:	89 f8                	mov    %edi,%eax
  80042d:	e8 9e ff ff ff       	call   8003d0 <printnum>
  800432:	83 c4 20             	add    $0x20,%esp
  800435:	eb 11                	jmp    800448 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800437:	83 ec 08             	sub    $0x8,%esp
  80043a:	56                   	push   %esi
  80043b:	ff 75 18             	pushl  0x18(%ebp)
  80043e:	ff d7                	call   *%edi
  800440:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800443:	4b                   	dec    %ebx
  800444:	85 db                	test   %ebx,%ebx
  800446:	7f ef                	jg     800437 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	56                   	push   %esi
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800452:	ff 75 e0             	pushl  -0x20(%ebp)
  800455:	ff 75 dc             	pushl  -0x24(%ebp)
  800458:	ff 75 d8             	pushl  -0x28(%ebp)
  80045b:	e8 68 1e 00 00       	call   8022c8 <__umoddi3>
  800460:	83 c4 14             	add    $0x14,%esp
  800463:	0f be 80 db 24 80 00 	movsbl 0x8024db(%eax),%eax
  80046a:	50                   	push   %eax
  80046b:	ff d7                	call   *%edi
}
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800473:	5b                   	pop    %ebx
  800474:	5e                   	pop    %esi
  800475:	5f                   	pop    %edi
  800476:	5d                   	pop    %ebp
  800477:	c3                   	ret    
  800478:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80047b:	eb c6                	jmp    800443 <printnum+0x73>

0080047d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800483:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800486:	8b 10                	mov    (%eax),%edx
  800488:	3b 50 04             	cmp    0x4(%eax),%edx
  80048b:	73 0a                	jae    800497 <sprintputch+0x1a>
		*b->buf++ = ch;
  80048d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800490:	89 08                	mov    %ecx,(%eax)
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	88 02                	mov    %al,(%edx)
}
  800497:	5d                   	pop    %ebp
  800498:	c3                   	ret    

00800499 <printfmt>:
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80049f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004a2:	50                   	push   %eax
  8004a3:	ff 75 10             	pushl  0x10(%ebp)
  8004a6:	ff 75 0c             	pushl  0xc(%ebp)
  8004a9:	ff 75 08             	pushl  0x8(%ebp)
  8004ac:	e8 05 00 00 00       	call   8004b6 <vprintfmt>
}
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	c9                   	leave  
  8004b5:	c3                   	ret    

008004b6 <vprintfmt>:
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	57                   	push   %edi
  8004ba:	56                   	push   %esi
  8004bb:	53                   	push   %ebx
  8004bc:	83 ec 2c             	sub    $0x2c,%esp
  8004bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004c8:	e9 ae 03 00 00       	jmp    80087b <vprintfmt+0x3c5>
  8004cd:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004d1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004d8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004e6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8d 47 01             	lea    0x1(%edi),%eax
  8004ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004f1:	8a 17                	mov    (%edi),%dl
  8004f3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004f6:	3c 55                	cmp    $0x55,%al
  8004f8:	0f 87 fe 03 00 00    	ja     8008fc <vprintfmt+0x446>
  8004fe:	0f b6 c0             	movzbl %al,%eax
  800501:	ff 24 85 20 26 80 00 	jmp    *0x802620(,%eax,4)
  800508:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80050b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80050f:	eb da                	jmp    8004eb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800511:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800514:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800518:	eb d1                	jmp    8004eb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	0f b6 d2             	movzbl %dl,%edx
  80051d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800520:	b8 00 00 00 00       	mov    $0x0,%eax
  800525:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800528:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80052b:	01 c0                	add    %eax,%eax
  80052d:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800531:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800534:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800537:	83 f9 09             	cmp    $0x9,%ecx
  80053a:	77 52                	ja     80058e <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80053c:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80053d:	eb e9                	jmp    800528 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 40 04             	lea    0x4(%eax),%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800550:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800553:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800557:	79 92                	jns    8004eb <vprintfmt+0x35>
				width = precision, precision = -1;
  800559:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80055c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800566:	eb 83                	jmp    8004eb <vprintfmt+0x35>
  800568:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80056c:	78 08                	js     800576 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80056e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800571:	e9 75 ff ff ff       	jmp    8004eb <vprintfmt+0x35>
  800576:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057d:	eb ef                	jmp    80056e <vprintfmt+0xb8>
  80057f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800582:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800589:	e9 5d ff ff ff       	jmp    8004eb <vprintfmt+0x35>
  80058e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800591:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800594:	eb bd                	jmp    800553 <vprintfmt+0x9d>
			lflag++;
  800596:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800597:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80059a:	e9 4c ff ff ff       	jmp    8004eb <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8d 78 04             	lea    0x4(%eax),%edi
  8005a5:	83 ec 08             	sub    $0x8,%esp
  8005a8:	53                   	push   %ebx
  8005a9:	ff 30                	pushl  (%eax)
  8005ab:	ff d6                	call   *%esi
			break;
  8005ad:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005b0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005b3:	e9 c0 02 00 00       	jmp    800878 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 78 04             	lea    0x4(%eax),%edi
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	85 c0                	test   %eax,%eax
  8005c2:	78 2a                	js     8005ee <vprintfmt+0x138>
  8005c4:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005c6:	83 f8 0f             	cmp    $0xf,%eax
  8005c9:	7f 27                	jg     8005f2 <vprintfmt+0x13c>
  8005cb:	8b 04 85 80 27 80 00 	mov    0x802780(,%eax,4),%eax
  8005d2:	85 c0                	test   %eax,%eax
  8005d4:	74 1c                	je     8005f2 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8005d6:	50                   	push   %eax
  8005d7:	68 b1 28 80 00       	push   $0x8028b1
  8005dc:	53                   	push   %ebx
  8005dd:	56                   	push   %esi
  8005de:	e8 b6 fe ff ff       	call   800499 <printfmt>
  8005e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005e9:	e9 8a 02 00 00       	jmp    800878 <vprintfmt+0x3c2>
  8005ee:	f7 d8                	neg    %eax
  8005f0:	eb d2                	jmp    8005c4 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8005f2:	52                   	push   %edx
  8005f3:	68 f3 24 80 00       	push   $0x8024f3
  8005f8:	53                   	push   %ebx
  8005f9:	56                   	push   %esi
  8005fa:	e8 9a fe ff ff       	call   800499 <printfmt>
  8005ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800602:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800605:	e9 6e 02 00 00       	jmp    800878 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 38                	mov    (%eax),%edi
  800618:	85 ff                	test   %edi,%edi
  80061a:	74 39                	je     800655 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80061c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800620:	0f 8e a9 00 00 00    	jle    8006cf <vprintfmt+0x219>
  800626:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80062a:	0f 84 a7 00 00 00    	je     8006d7 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	ff 75 d0             	pushl  -0x30(%ebp)
  800636:	57                   	push   %edi
  800637:	e8 6b 03 00 00       	call   8009a7 <strnlen>
  80063c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80063f:	29 c1                	sub    %eax,%ecx
  800641:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800644:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800647:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80064e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800651:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800653:	eb 14                	jmp    800669 <vprintfmt+0x1b3>
				p = "(null)";
  800655:	bf ec 24 80 00       	mov    $0x8024ec,%edi
  80065a:	eb c0                	jmp    80061c <vprintfmt+0x166>
					putch(padc, putdat);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	53                   	push   %ebx
  800660:	ff 75 e0             	pushl  -0x20(%ebp)
  800663:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800665:	4f                   	dec    %edi
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	85 ff                	test   %edi,%edi
  80066b:	7f ef                	jg     80065c <vprintfmt+0x1a6>
  80066d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800670:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800673:	89 c8                	mov    %ecx,%eax
  800675:	85 c9                	test   %ecx,%ecx
  800677:	78 10                	js     800689 <vprintfmt+0x1d3>
  800679:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80067c:	29 c1                	sub    %eax,%ecx
  80067e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800681:	89 75 08             	mov    %esi,0x8(%ebp)
  800684:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800687:	eb 15                	jmp    80069e <vprintfmt+0x1e8>
  800689:	b8 00 00 00 00       	mov    $0x0,%eax
  80068e:	eb e9                	jmp    800679 <vprintfmt+0x1c3>
					putch(ch, putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	52                   	push   %edx
  800695:	ff 55 08             	call   *0x8(%ebp)
  800698:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069b:	ff 4d e0             	decl   -0x20(%ebp)
  80069e:	47                   	inc    %edi
  80069f:	8a 47 ff             	mov    -0x1(%edi),%al
  8006a2:	0f be d0             	movsbl %al,%edx
  8006a5:	85 d2                	test   %edx,%edx
  8006a7:	74 59                	je     800702 <vprintfmt+0x24c>
  8006a9:	85 f6                	test   %esi,%esi
  8006ab:	78 03                	js     8006b0 <vprintfmt+0x1fa>
  8006ad:	4e                   	dec    %esi
  8006ae:	78 2f                	js     8006df <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006b4:	74 da                	je     800690 <vprintfmt+0x1da>
  8006b6:	0f be c0             	movsbl %al,%eax
  8006b9:	83 e8 20             	sub    $0x20,%eax
  8006bc:	83 f8 5e             	cmp    $0x5e,%eax
  8006bf:	76 cf                	jbe    800690 <vprintfmt+0x1da>
					putch('?', putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	6a 3f                	push   $0x3f
  8006c7:	ff 55 08             	call   *0x8(%ebp)
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	eb cc                	jmp    80069b <vprintfmt+0x1e5>
  8006cf:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d5:	eb c7                	jmp    80069e <vprintfmt+0x1e8>
  8006d7:	89 75 08             	mov    %esi,0x8(%ebp)
  8006da:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006dd:	eb bf                	jmp    80069e <vprintfmt+0x1e8>
  8006df:	8b 75 08             	mov    0x8(%ebp),%esi
  8006e2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006e5:	eb 0c                	jmp    8006f3 <vprintfmt+0x23d>
				putch(' ', putdat);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	53                   	push   %ebx
  8006eb:	6a 20                	push   $0x20
  8006ed:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006ef:	4f                   	dec    %edi
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	85 ff                	test   %edi,%edi
  8006f5:	7f f0                	jg     8006e7 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8006f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fd:	e9 76 01 00 00       	jmp    800878 <vprintfmt+0x3c2>
  800702:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800705:	8b 75 08             	mov    0x8(%ebp),%esi
  800708:	eb e9                	jmp    8006f3 <vprintfmt+0x23d>
	if (lflag >= 2)
  80070a:	83 f9 01             	cmp    $0x1,%ecx
  80070d:	7f 1f                	jg     80072e <vprintfmt+0x278>
	else if (lflag)
  80070f:	85 c9                	test   %ecx,%ecx
  800711:	75 48                	jne    80075b <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071b:	89 c1                	mov    %eax,%ecx
  80071d:	c1 f9 1f             	sar    $0x1f,%ecx
  800720:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
  80072c:	eb 17                	jmp    800745 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 50 04             	mov    0x4(%eax),%edx
  800734:	8b 00                	mov    (%eax),%eax
  800736:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800739:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8d 40 08             	lea    0x8(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800745:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800748:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80074b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80074f:	78 25                	js     800776 <vprintfmt+0x2c0>
			base = 10;
  800751:	b8 0a 00 00 00       	mov    $0xa,%eax
  800756:	e9 03 01 00 00       	jmp    80085e <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800763:	89 c1                	mov    %eax,%ecx
  800765:	c1 f9 1f             	sar    $0x1f,%ecx
  800768:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8d 40 04             	lea    0x4(%eax),%eax
  800771:	89 45 14             	mov    %eax,0x14(%ebp)
  800774:	eb cf                	jmp    800745 <vprintfmt+0x28f>
				putch('-', putdat);
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	53                   	push   %ebx
  80077a:	6a 2d                	push   $0x2d
  80077c:	ff d6                	call   *%esi
				num = -(long long) num;
  80077e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800781:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800784:	f7 da                	neg    %edx
  800786:	83 d1 00             	adc    $0x0,%ecx
  800789:	f7 d9                	neg    %ecx
  80078b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80078e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800793:	e9 c6 00 00 00       	jmp    80085e <vprintfmt+0x3a8>
	if (lflag >= 2)
  800798:	83 f9 01             	cmp    $0x1,%ecx
  80079b:	7f 1e                	jg     8007bb <vprintfmt+0x305>
	else if (lflag)
  80079d:	85 c9                	test   %ecx,%ecx
  80079f:	75 32                	jne    8007d3 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8b 10                	mov    (%eax),%edx
  8007a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ab:	8d 40 04             	lea    0x4(%eax),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b6:	e9 a3 00 00 00       	jmp    80085e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8b 10                	mov    (%eax),%edx
  8007c0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c3:	8d 40 08             	lea    0x8(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ce:	e9 8b 00 00 00       	jmp    80085e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 10                	mov    (%eax),%edx
  8007d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e8:	eb 74                	jmp    80085e <vprintfmt+0x3a8>
	if (lflag >= 2)
  8007ea:	83 f9 01             	cmp    $0x1,%ecx
  8007ed:	7f 1b                	jg     80080a <vprintfmt+0x354>
	else if (lflag)
  8007ef:	85 c9                	test   %ecx,%ecx
  8007f1:	75 2c                	jne    80081f <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 10                	mov    (%eax),%edx
  8007f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fd:	8d 40 04             	lea    0x4(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800803:	b8 08 00 00 00       	mov    $0x8,%eax
  800808:	eb 54                	jmp    80085e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8b 10                	mov    (%eax),%edx
  80080f:	8b 48 04             	mov    0x4(%eax),%ecx
  800812:	8d 40 08             	lea    0x8(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800818:	b8 08 00 00 00       	mov    $0x8,%eax
  80081d:	eb 3f                	jmp    80085e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 10                	mov    (%eax),%edx
  800824:	b9 00 00 00 00       	mov    $0x0,%ecx
  800829:	8d 40 04             	lea    0x4(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082f:	b8 08 00 00 00       	mov    $0x8,%eax
  800834:	eb 28                	jmp    80085e <vprintfmt+0x3a8>
			putch('0', putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	6a 30                	push   $0x30
  80083c:	ff d6                	call   *%esi
			putch('x', putdat);
  80083e:	83 c4 08             	add    $0x8,%esp
  800841:	53                   	push   %ebx
  800842:	6a 78                	push   $0x78
  800844:	ff d6                	call   *%esi
			num = (unsigned long long)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 10                	mov    (%eax),%edx
  80084b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800850:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800853:	8d 40 04             	lea    0x4(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800859:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80085e:	83 ec 0c             	sub    $0xc,%esp
  800861:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800865:	57                   	push   %edi
  800866:	ff 75 e0             	pushl  -0x20(%ebp)
  800869:	50                   	push   %eax
  80086a:	51                   	push   %ecx
  80086b:	52                   	push   %edx
  80086c:	89 da                	mov    %ebx,%edx
  80086e:	89 f0                	mov    %esi,%eax
  800870:	e8 5b fb ff ff       	call   8003d0 <printnum>
			break;
  800875:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800878:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087b:	47                   	inc    %edi
  80087c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800880:	83 f8 25             	cmp    $0x25,%eax
  800883:	0f 84 44 fc ff ff    	je     8004cd <vprintfmt+0x17>
			if (ch == '\0')
  800889:	85 c0                	test   %eax,%eax
  80088b:	0f 84 89 00 00 00    	je     80091a <vprintfmt+0x464>
			putch(ch, putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	53                   	push   %ebx
  800895:	50                   	push   %eax
  800896:	ff d6                	call   *%esi
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	eb de                	jmp    80087b <vprintfmt+0x3c5>
	if (lflag >= 2)
  80089d:	83 f9 01             	cmp    $0x1,%ecx
  8008a0:	7f 1b                	jg     8008bd <vprintfmt+0x407>
	else if (lflag)
  8008a2:	85 c9                	test   %ecx,%ecx
  8008a4:	75 2c                	jne    8008d2 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8b 10                	mov    (%eax),%edx
  8008ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008b0:	8d 40 04             	lea    0x4(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8008bb:	eb a1                	jmp    80085e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8b 10                	mov    (%eax),%edx
  8008c2:	8b 48 04             	mov    0x4(%eax),%ecx
  8008c5:	8d 40 08             	lea    0x8(%eax),%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d0:	eb 8c                	jmp    80085e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 10                	mov    (%eax),%edx
  8008d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008dc:	8d 40 04             	lea    0x4(%eax),%eax
  8008df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8008e7:	e9 72 ff ff ff       	jmp    80085e <vprintfmt+0x3a8>
			putch(ch, putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	53                   	push   %ebx
  8008f0:	6a 25                	push   $0x25
  8008f2:	ff d6                	call   *%esi
			break;
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	e9 7c ff ff ff       	jmp    800878 <vprintfmt+0x3c2>
			putch('%', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 25                	push   $0x25
  800902:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	89 f8                	mov    %edi,%eax
  800909:	eb 01                	jmp    80090c <vprintfmt+0x456>
  80090b:	48                   	dec    %eax
  80090c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800910:	75 f9                	jne    80090b <vprintfmt+0x455>
  800912:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800915:	e9 5e ff ff ff       	jmp    800878 <vprintfmt+0x3c2>
}
  80091a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091d:	5b                   	pop    %ebx
  80091e:	5e                   	pop    %esi
  80091f:	5f                   	pop    %edi
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	83 ec 18             	sub    $0x18,%esp
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800931:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800935:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093f:	85 c0                	test   %eax,%eax
  800941:	74 26                	je     800969 <vsnprintf+0x47>
  800943:	85 d2                	test   %edx,%edx
  800945:	7e 29                	jle    800970 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800947:	ff 75 14             	pushl  0x14(%ebp)
  80094a:	ff 75 10             	pushl  0x10(%ebp)
  80094d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800950:	50                   	push   %eax
  800951:	68 7d 04 80 00       	push   $0x80047d
  800956:	e8 5b fb ff ff       	call   8004b6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80095b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800964:	83 c4 10             	add    $0x10,%esp
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    
		return -E_INVAL;
  800969:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096e:	eb f7                	jmp    800967 <vsnprintf+0x45>
  800970:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800975:	eb f0                	jmp    800967 <vsnprintf+0x45>

00800977 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80097d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800980:	50                   	push   %eax
  800981:	ff 75 10             	pushl  0x10(%ebp)
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	e8 93 ff ff ff       	call   800922 <vsnprintf>
	va_end(ap);

	return rc;
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800997:	b8 00 00 00 00       	mov    $0x0,%eax
  80099c:	eb 01                	jmp    80099f <strlen+0xe>
		n++;
  80099e:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80099f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009a3:	75 f9                	jne    80099e <strlen+0xd>
	return n;
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b5:	eb 01                	jmp    8009b8 <strnlen+0x11>
		n++;
  8009b7:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b8:	39 d0                	cmp    %edx,%eax
  8009ba:	74 06                	je     8009c2 <strnlen+0x1b>
  8009bc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009c0:	75 f5                	jne    8009b7 <strnlen+0x10>
	return n;
}
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009ce:	89 c2                	mov    %eax,%edx
  8009d0:	42                   	inc    %edx
  8009d1:	41                   	inc    %ecx
  8009d2:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8009d5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d8:	84 db                	test   %bl,%bl
  8009da:	75 f4                	jne    8009d0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009dc:	5b                   	pop    %ebx
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	53                   	push   %ebx
  8009e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009e6:	53                   	push   %ebx
  8009e7:	e8 a5 ff ff ff       	call   800991 <strlen>
  8009ec:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	01 d8                	add    %ebx,%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 ca ff ff ff       	call   8009c4 <strcpy>
	return dst;
}
  8009fa:	89 d8                	mov    %ebx,%eax
  8009fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ff:	c9                   	leave  
  800a00:	c3                   	ret    

00800a01 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	56                   	push   %esi
  800a05:	53                   	push   %ebx
  800a06:	8b 75 08             	mov    0x8(%ebp),%esi
  800a09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0c:	89 f3                	mov    %esi,%ebx
  800a0e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a11:	89 f2                	mov    %esi,%edx
  800a13:	eb 0c                	jmp    800a21 <strncpy+0x20>
		*dst++ = *src;
  800a15:	42                   	inc    %edx
  800a16:	8a 01                	mov    (%ecx),%al
  800a18:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a1b:	80 39 01             	cmpb   $0x1,(%ecx)
  800a1e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a21:	39 da                	cmp    %ebx,%edx
  800a23:	75 f0                	jne    800a15 <strncpy+0x14>
	}
	return ret;
}
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	5b                   	pop    %ebx
  800a28:	5e                   	pop    %esi
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	56                   	push   %esi
  800a2f:	53                   	push   %ebx
  800a30:	8b 75 08             	mov    0x8(%ebp),%esi
  800a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a39:	85 c0                	test   %eax,%eax
  800a3b:	74 20                	je     800a5d <strlcpy+0x32>
  800a3d:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800a41:	89 f0                	mov    %esi,%eax
  800a43:	eb 05                	jmp    800a4a <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a45:	40                   	inc    %eax
  800a46:	42                   	inc    %edx
  800a47:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a4a:	39 d8                	cmp    %ebx,%eax
  800a4c:	74 06                	je     800a54 <strlcpy+0x29>
  800a4e:	8a 0a                	mov    (%edx),%cl
  800a50:	84 c9                	test   %cl,%cl
  800a52:	75 f1                	jne    800a45 <strlcpy+0x1a>
		*dst = '\0';
  800a54:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a57:	29 f0                	sub    %esi,%eax
}
  800a59:	5b                   	pop    %ebx
  800a5a:	5e                   	pop    %esi
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    
  800a5d:	89 f0                	mov    %esi,%eax
  800a5f:	eb f6                	jmp    800a57 <strlcpy+0x2c>

00800a61 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a67:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a6a:	eb 02                	jmp    800a6e <strcmp+0xd>
		p++, q++;
  800a6c:	41                   	inc    %ecx
  800a6d:	42                   	inc    %edx
	while (*p && *p == *q)
  800a6e:	8a 01                	mov    (%ecx),%al
  800a70:	84 c0                	test   %al,%al
  800a72:	74 04                	je     800a78 <strcmp+0x17>
  800a74:	3a 02                	cmp    (%edx),%al
  800a76:	74 f4                	je     800a6c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a78:	0f b6 c0             	movzbl %al,%eax
  800a7b:	0f b6 12             	movzbl (%edx),%edx
  800a7e:	29 d0                	sub    %edx,%eax
}
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	53                   	push   %ebx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8c:	89 c3                	mov    %eax,%ebx
  800a8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a91:	eb 02                	jmp    800a95 <strncmp+0x13>
		n--, p++, q++;
  800a93:	40                   	inc    %eax
  800a94:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800a95:	39 d8                	cmp    %ebx,%eax
  800a97:	74 15                	je     800aae <strncmp+0x2c>
  800a99:	8a 08                	mov    (%eax),%cl
  800a9b:	84 c9                	test   %cl,%cl
  800a9d:	74 04                	je     800aa3 <strncmp+0x21>
  800a9f:	3a 0a                	cmp    (%edx),%cl
  800aa1:	74 f0                	je     800a93 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa3:	0f b6 00             	movzbl (%eax),%eax
  800aa6:	0f b6 12             	movzbl (%edx),%edx
  800aa9:	29 d0                	sub    %edx,%eax
}
  800aab:	5b                   	pop    %ebx
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    
		return 0;
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	eb f6                	jmp    800aab <strncmp+0x29>

00800ab5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800abe:	8a 10                	mov    (%eax),%dl
  800ac0:	84 d2                	test   %dl,%dl
  800ac2:	74 07                	je     800acb <strchr+0x16>
		if (*s == c)
  800ac4:	38 ca                	cmp    %cl,%dl
  800ac6:	74 08                	je     800ad0 <strchr+0x1b>
	for (; *s; s++)
  800ac8:	40                   	inc    %eax
  800ac9:	eb f3                	jmp    800abe <strchr+0x9>
			return (char *) s;
	return 0;
  800acb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    

00800ad2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800adb:	8a 10                	mov    (%eax),%dl
  800add:	84 d2                	test   %dl,%dl
  800adf:	74 07                	je     800ae8 <strfind+0x16>
		if (*s == c)
  800ae1:	38 ca                	cmp    %cl,%dl
  800ae3:	74 03                	je     800ae8 <strfind+0x16>
	for (; *s; s++)
  800ae5:	40                   	inc    %eax
  800ae6:	eb f3                	jmp    800adb <strfind+0x9>
			break;
	return (char *) s;
}
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	57                   	push   %edi
  800aee:	56                   	push   %esi
  800aef:	53                   	push   %ebx
  800af0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af6:	85 c9                	test   %ecx,%ecx
  800af8:	74 13                	je     800b0d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800afa:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b00:	75 05                	jne    800b07 <memset+0x1d>
  800b02:	f6 c1 03             	test   $0x3,%cl
  800b05:	74 0d                	je     800b14 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	fc                   	cld    
  800b0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0d:	89 f8                	mov    %edi,%eax
  800b0f:	5b                   	pop    %ebx
  800b10:	5e                   	pop    %esi
  800b11:	5f                   	pop    %edi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    
		c &= 0xFF;
  800b14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b18:	89 d3                	mov    %edx,%ebx
  800b1a:	c1 e3 08             	shl    $0x8,%ebx
  800b1d:	89 d0                	mov    %edx,%eax
  800b1f:	c1 e0 18             	shl    $0x18,%eax
  800b22:	89 d6                	mov    %edx,%esi
  800b24:	c1 e6 10             	shl    $0x10,%esi
  800b27:	09 f0                	or     %esi,%eax
  800b29:	09 c2                	or     %eax,%edx
  800b2b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b2d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	fc                   	cld    
  800b33:	f3 ab                	rep stos %eax,%es:(%edi)
  800b35:	eb d6                	jmp    800b0d <memset+0x23>

00800b37 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	57                   	push   %edi
  800b3b:	56                   	push   %esi
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b42:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b45:	39 c6                	cmp    %eax,%esi
  800b47:	73 33                	jae    800b7c <memmove+0x45>
  800b49:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b4c:	39 d0                	cmp    %edx,%eax
  800b4e:	73 2c                	jae    800b7c <memmove+0x45>
		s += n;
		d += n;
  800b50:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b53:	89 d6                	mov    %edx,%esi
  800b55:	09 fe                	or     %edi,%esi
  800b57:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b5d:	75 13                	jne    800b72 <memmove+0x3b>
  800b5f:	f6 c1 03             	test   $0x3,%cl
  800b62:	75 0e                	jne    800b72 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b64:	83 ef 04             	sub    $0x4,%edi
  800b67:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b6a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b6d:	fd                   	std    
  800b6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b70:	eb 07                	jmp    800b79 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b72:	4f                   	dec    %edi
  800b73:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b76:	fd                   	std    
  800b77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b79:	fc                   	cld    
  800b7a:	eb 13                	jmp    800b8f <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7c:	89 f2                	mov    %esi,%edx
  800b7e:	09 c2                	or     %eax,%edx
  800b80:	f6 c2 03             	test   $0x3,%dl
  800b83:	75 05                	jne    800b8a <memmove+0x53>
  800b85:	f6 c1 03             	test   $0x3,%cl
  800b88:	74 09                	je     800b93 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b8a:	89 c7                	mov    %eax,%edi
  800b8c:	fc                   	cld    
  800b8d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b93:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b96:	89 c7                	mov    %eax,%edi
  800b98:	fc                   	cld    
  800b99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9b:	eb f2                	jmp    800b8f <memmove+0x58>

00800b9d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ba0:	ff 75 10             	pushl  0x10(%ebp)
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 89 ff ff ff       	call   800b37 <memmove>
}
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	89 c6                	mov    %eax,%esi
  800bba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800bbd:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800bc0:	39 f0                	cmp    %esi,%eax
  800bc2:	74 16                	je     800bda <memcmp+0x2a>
		if (*s1 != *s2)
  800bc4:	8a 08                	mov    (%eax),%cl
  800bc6:	8a 1a                	mov    (%edx),%bl
  800bc8:	38 d9                	cmp    %bl,%cl
  800bca:	75 04                	jne    800bd0 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bcc:	40                   	inc    %eax
  800bcd:	42                   	inc    %edx
  800bce:	eb f0                	jmp    800bc0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bd0:	0f b6 c1             	movzbl %cl,%eax
  800bd3:	0f b6 db             	movzbl %bl,%ebx
  800bd6:	29 d8                	sub    %ebx,%eax
  800bd8:	eb 05                	jmp    800bdf <memcmp+0x2f>
	}

	return 0;
  800bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bec:	89 c2                	mov    %eax,%edx
  800bee:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bf1:	39 d0                	cmp    %edx,%eax
  800bf3:	73 07                	jae    800bfc <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bf5:	38 08                	cmp    %cl,(%eax)
  800bf7:	74 03                	je     800bfc <memfind+0x19>
	for (; s < ends; s++)
  800bf9:	40                   	inc    %eax
  800bfa:	eb f5                	jmp    800bf1 <memfind+0xe>
			break;
	return (void *) s;
}
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c07:	eb 01                	jmp    800c0a <strtol+0xc>
		s++;
  800c09:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800c0a:	8a 01                	mov    (%ecx),%al
  800c0c:	3c 20                	cmp    $0x20,%al
  800c0e:	74 f9                	je     800c09 <strtol+0xb>
  800c10:	3c 09                	cmp    $0x9,%al
  800c12:	74 f5                	je     800c09 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800c14:	3c 2b                	cmp    $0x2b,%al
  800c16:	74 2b                	je     800c43 <strtol+0x45>
		s++;
	else if (*s == '-')
  800c18:	3c 2d                	cmp    $0x2d,%al
  800c1a:	74 2f                	je     800c4b <strtol+0x4d>
	int neg = 0;
  800c1c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c21:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800c28:	75 12                	jne    800c3c <strtol+0x3e>
  800c2a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c2d:	74 24                	je     800c53 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c33:	75 07                	jne    800c3c <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c35:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	eb 4e                	jmp    800c91 <strtol+0x93>
		s++;
  800c43:	41                   	inc    %ecx
	int neg = 0;
  800c44:	bf 00 00 00 00       	mov    $0x0,%edi
  800c49:	eb d6                	jmp    800c21 <strtol+0x23>
		s++, neg = 1;
  800c4b:	41                   	inc    %ecx
  800c4c:	bf 01 00 00 00       	mov    $0x1,%edi
  800c51:	eb ce                	jmp    800c21 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c53:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c57:	74 10                	je     800c69 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5d:	75 dd                	jne    800c3c <strtol+0x3e>
		s++, base = 8;
  800c5f:	41                   	inc    %ecx
  800c60:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c67:	eb d3                	jmp    800c3c <strtol+0x3e>
		s += 2, base = 16;
  800c69:	83 c1 02             	add    $0x2,%ecx
  800c6c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c73:	eb c7                	jmp    800c3c <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c75:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c78:	89 f3                	mov    %esi,%ebx
  800c7a:	80 fb 19             	cmp    $0x19,%bl
  800c7d:	77 24                	ja     800ca3 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800c7f:	0f be d2             	movsbl %dl,%edx
  800c82:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c85:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c88:	7d 2b                	jge    800cb5 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800c8a:	41                   	inc    %ecx
  800c8b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c8f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c91:	8a 11                	mov    (%ecx),%dl
  800c93:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800c96:	80 fb 09             	cmp    $0x9,%bl
  800c99:	77 da                	ja     800c75 <strtol+0x77>
			dig = *s - '0';
  800c9b:	0f be d2             	movsbl %dl,%edx
  800c9e:	83 ea 30             	sub    $0x30,%edx
  800ca1:	eb e2                	jmp    800c85 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800ca3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ca6:	89 f3                	mov    %esi,%ebx
  800ca8:	80 fb 19             	cmp    $0x19,%bl
  800cab:	77 08                	ja     800cb5 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800cad:	0f be d2             	movsbl %dl,%edx
  800cb0:	83 ea 37             	sub    $0x37,%edx
  800cb3:	eb d0                	jmp    800c85 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb9:	74 05                	je     800cc0 <strtol+0xc2>
		*endptr = (char *) s;
  800cbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cbe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cc0:	85 ff                	test   %edi,%edi
  800cc2:	74 02                	je     800cc6 <strtol+0xc8>
  800cc4:	f7 d8                	neg    %eax
}
  800cc6:	5b                   	pop    %ebx
  800cc7:	5e                   	pop    %esi
  800cc8:	5f                   	pop    %edi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <atoi>:

int
atoi(const char *s)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800cce:	6a 0a                	push   $0xa
  800cd0:	6a 00                	push   $0x0
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 24 ff ff ff       	call   800bfe <strtol>
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	89 c3                	mov    %eax,%ebx
  800cef:	89 c7                	mov    %eax,%edi
  800cf1:	89 c6                	mov    %eax,%esi
  800cf3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <sys_cgetc>:

int
sys_cgetc(void)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d00:	ba 00 00 00 00       	mov    $0x0,%edx
  800d05:	b8 01 00 00 00       	mov    $0x1,%eax
  800d0a:	89 d1                	mov    %edx,%ecx
  800d0c:	89 d3                	mov    %edx,%ebx
  800d0e:	89 d7                	mov    %edx,%edi
  800d10:	89 d6                	mov    %edx,%esi
  800d12:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
  800d1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d27:	b8 03 00 00 00       	mov    $0x3,%eax
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	89 cb                	mov    %ecx,%ebx
  800d31:	89 cf                	mov    %ecx,%edi
  800d33:	89 ce                	mov    %ecx,%esi
  800d35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d37:	85 c0                	test   %eax,%eax
  800d39:	7f 08                	jg     800d43 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d43:	83 ec 0c             	sub    $0xc,%esp
  800d46:	50                   	push   %eax
  800d47:	6a 03                	push   $0x3
  800d49:	68 df 27 80 00       	push   $0x8027df
  800d4e:	6a 23                	push   $0x23
  800d50:	68 fc 27 80 00       	push   $0x8027fc
  800d55:	e8 f7 f5 ff ff       	call   800351 <_panic>

00800d5a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d60:	ba 00 00 00 00       	mov    $0x0,%edx
  800d65:	b8 02 00 00 00       	mov    $0x2,%eax
  800d6a:	89 d1                	mov    %edx,%ecx
  800d6c:	89 d3                	mov    %edx,%ebx
  800d6e:	89 d7                	mov    %edx,%edi
  800d70:	89 d6                	mov    %edx,%esi
  800d72:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	57                   	push   %edi
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
  800d7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d82:	be 00 00 00 00       	mov    $0x0,%esi
  800d87:	b8 04 00 00 00       	mov    $0x4,%eax
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d95:	89 f7                	mov    %esi,%edi
  800d97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	7f 08                	jg     800da5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da5:	83 ec 0c             	sub    $0xc,%esp
  800da8:	50                   	push   %eax
  800da9:	6a 04                	push   $0x4
  800dab:	68 df 27 80 00       	push   $0x8027df
  800db0:	6a 23                	push   $0x23
  800db2:	68 fc 27 80 00       	push   $0x8027fc
  800db7:	e8 95 f5 ff ff       	call   800351 <_panic>

00800dbc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	57                   	push   %edi
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
  800dc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc5:	b8 05 00 00 00       	mov    $0x5,%eax
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd6:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	7f 08                	jg     800de7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de7:	83 ec 0c             	sub    $0xc,%esp
  800dea:	50                   	push   %eax
  800deb:	6a 05                	push   $0x5
  800ded:	68 df 27 80 00       	push   $0x8027df
  800df2:	6a 23                	push   $0x23
  800df4:	68 fc 27 80 00       	push   $0x8027fc
  800df9:	e8 53 f5 ff ff       	call   800351 <_panic>

00800dfe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	57                   	push   %edi
  800e02:	56                   	push   %esi
  800e03:	53                   	push   %ebx
  800e04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0c:	b8 06 00 00 00       	mov    $0x6,%eax
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	89 df                	mov    %ebx,%edi
  800e19:	89 de                	mov    %ebx,%esi
  800e1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	7f 08                	jg     800e29 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	50                   	push   %eax
  800e2d:	6a 06                	push   $0x6
  800e2f:	68 df 27 80 00       	push   $0x8027df
  800e34:	6a 23                	push   $0x23
  800e36:	68 fc 27 80 00       	push   $0x8027fc
  800e3b:	e8 11 f5 ff ff       	call   800351 <_panic>

00800e40 <sys_yield>:

void
sys_yield(void)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e46:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e50:	89 d1                	mov    %edx,%ecx
  800e52:	89 d3                	mov    %edx,%ebx
  800e54:	89 d7                	mov    %edx,%edi
  800e56:	89 d6                	mov    %edx,%esi
  800e58:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	57                   	push   %edi
  800e63:	56                   	push   %esi
  800e64:	53                   	push   %ebx
  800e65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6d:	b8 08 00 00 00       	mov    $0x8,%eax
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	89 df                	mov    %ebx,%edi
  800e7a:	89 de                	mov    %ebx,%esi
  800e7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	7f 08                	jg     800e8a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8a:	83 ec 0c             	sub    $0xc,%esp
  800e8d:	50                   	push   %eax
  800e8e:	6a 08                	push   $0x8
  800e90:	68 df 27 80 00       	push   $0x8027df
  800e95:	6a 23                	push   $0x23
  800e97:	68 fc 27 80 00       	push   $0x8027fc
  800e9c:	e8 b0 f4 ff ff       	call   800351 <_panic>

00800ea1 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	89 cb                	mov    %ecx,%ebx
  800eb9:	89 cf                	mov    %ecx,%edi
  800ebb:	89 ce                	mov    %ecx,%esi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 0c                	push   $0xc
  800ed1:	68 df 27 80 00       	push   $0x8027df
  800ed6:	6a 23                	push   $0x23
  800ed8:	68 fc 27 80 00       	push   $0x8027fc
  800edd:	e8 6f f4 ff ff       	call   800351 <_panic>

00800ee2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	89 df                	mov    %ebx,%edi
  800efd:	89 de                	mov    %ebx,%esi
  800eff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f01:	85 c0                	test   %eax,%eax
  800f03:	7f 08                	jg     800f0d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0d:	83 ec 0c             	sub    $0xc,%esp
  800f10:	50                   	push   %eax
  800f11:	6a 09                	push   $0x9
  800f13:	68 df 27 80 00       	push   $0x8027df
  800f18:	6a 23                	push   $0x23
  800f1a:	68 fc 27 80 00       	push   $0x8027fc
  800f1f:	e8 2d f4 ff ff       	call   800351 <_panic>

00800f24 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f32:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3d:	89 df                	mov    %ebx,%edi
  800f3f:	89 de                	mov    %ebx,%esi
  800f41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	7f 08                	jg     800f4f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	50                   	push   %eax
  800f53:	6a 0a                	push   $0xa
  800f55:	68 df 27 80 00       	push   $0x8027df
  800f5a:	6a 23                	push   $0x23
  800f5c:	68 fc 27 80 00       	push   $0x8027fc
  800f61:	e8 eb f3 ff ff       	call   800351 <_panic>

00800f66 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6c:	be 00 00 00 00       	mov    $0x0,%esi
  800f71:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f82:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	57                   	push   %edi
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f97:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	89 cb                	mov    %ecx,%ebx
  800fa1:	89 cf                	mov    %ecx,%edi
  800fa3:	89 ce                	mov    %ecx,%esi
  800fa5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	7f 08                	jg     800fb3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	50                   	push   %eax
  800fb7:	6a 0e                	push   $0xe
  800fb9:	68 df 27 80 00       	push   $0x8027df
  800fbe:	6a 23                	push   $0x23
  800fc0:	68 fc 27 80 00       	push   $0x8027fc
  800fc5:	e8 87 f3 ff ff       	call   800351 <_panic>

00800fca <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	57                   	push   %edi
  800fce:	56                   	push   %esi
  800fcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd0:	be 00 00 00 00       	mov    $0x0,%esi
  800fd5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe3:	89 f7                	mov    %esi,%edi
  800fe5:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff2:	be 00 00 00 00       	mov    $0x0,%esi
  800ff7:	b8 10 00 00 00       	mov    $0x10,%eax
  800ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801005:	89 f7                	mov    %esi,%edi
  801007:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5f                   	pop    %edi
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <sys_set_console_color>:

void sys_set_console_color(int color) {
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
	asm volatile("int %1\n"
  801014:	b9 00 00 00 00       	mov    $0x0,%ecx
  801019:	b8 11 00 00 00       	mov    $0x11,%eax
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	89 cb                	mov    %ecx,%ebx
  801023:	89 cf                	mov    %ecx,%edi
  801025:	89 ce                	mov    %ecx,%esi
  801027:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80103a:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  80103c:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80103f:	83 3a 01             	cmpl   $0x1,(%edx)
  801042:	7e 15                	jle    801059 <argstart+0x2b>
  801044:	85 c9                	test   %ecx,%ecx
  801046:	74 18                	je     801060 <argstart+0x32>
  801048:	ba 8a 24 80 00       	mov    $0x80248a,%edx
  80104d:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801050:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801059:	ba 00 00 00 00       	mov    $0x0,%edx
  80105e:	eb ed                	jmp    80104d <argstart+0x1f>
  801060:	ba 00 00 00 00       	mov    $0x0,%edx
  801065:	eb e6                	jmp    80104d <argstart+0x1f>

00801067 <argnext>:

int
argnext(struct Argstate *args)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	53                   	push   %ebx
  80106b:	83 ec 04             	sub    $0x4,%esp
  80106e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801071:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801078:	8b 43 08             	mov    0x8(%ebx),%eax
  80107b:	85 c0                	test   %eax,%eax
  80107d:	74 6d                	je     8010ec <argnext+0x85>
		return -1;

	if (!*args->curarg) {
  80107f:	80 38 00             	cmpb   $0x0,(%eax)
  801082:	75 45                	jne    8010c9 <argnext+0x62>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801084:	8b 0b                	mov    (%ebx),%ecx
  801086:	83 39 01             	cmpl   $0x1,(%ecx)
  801089:	74 53                	je     8010de <argnext+0x77>
		    || args->argv[1][0] != '-'
  80108b:	8b 53 04             	mov    0x4(%ebx),%edx
  80108e:	8b 42 04             	mov    0x4(%edx),%eax
  801091:	80 38 2d             	cmpb   $0x2d,(%eax)
  801094:	75 48                	jne    8010de <argnext+0x77>
		    || args->argv[1][1] == '\0')
  801096:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80109a:	74 42                	je     8010de <argnext+0x77>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80109c:	40                   	inc    %eax
  80109d:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010a0:	83 ec 04             	sub    $0x4,%esp
  8010a3:	8b 01                	mov    (%ecx),%eax
  8010a5:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8010ac:	50                   	push   %eax
  8010ad:	8d 42 08             	lea    0x8(%edx),%eax
  8010b0:	50                   	push   %eax
  8010b1:	83 c2 04             	add    $0x4,%edx
  8010b4:	52                   	push   %edx
  8010b5:	e8 7d fa ff ff       	call   800b37 <memmove>
		(*args->argc)--;
  8010ba:	8b 03                	mov    (%ebx),%eax
  8010bc:	ff 08                	decl   (%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8010be:	8b 43 08             	mov    0x8(%ebx),%eax
  8010c1:	83 c4 10             	add    $0x10,%esp
  8010c4:	80 38 2d             	cmpb   $0x2d,(%eax)
  8010c7:	74 0f                	je     8010d8 <argnext+0x71>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8010c9:	8b 53 08             	mov    0x8(%ebx),%edx
  8010cc:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8010cf:	42                   	inc    %edx
  8010d0:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8010d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d6:	c9                   	leave  
  8010d7:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8010d8:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8010dc:	75 eb                	jne    8010c9 <argnext+0x62>
	args->curarg = 0;
  8010de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8010e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010ea:	eb e7                	jmp    8010d3 <argnext+0x6c>
		return -1;
  8010ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010f1:	eb e0                	jmp    8010d3 <argnext+0x6c>

008010f3 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	53                   	push   %ebx
  8010f7:	83 ec 04             	sub    $0x4,%esp
  8010fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8010fd:	8b 43 08             	mov    0x8(%ebx),%eax
  801100:	85 c0                	test   %eax,%eax
  801102:	74 5a                	je     80115e <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801104:	80 38 00             	cmpb   $0x0,(%eax)
  801107:	74 12                	je     80111b <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801109:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  80110c:	c7 43 08 8a 24 80 00 	movl   $0x80248a,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801113:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801116:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801119:	c9                   	leave  
  80111a:	c3                   	ret    
	} else if (*args->argc > 1) {
  80111b:	8b 13                	mov    (%ebx),%edx
  80111d:	83 3a 01             	cmpl   $0x1,(%edx)
  801120:	7e 2c                	jle    80114e <argnextvalue+0x5b>
		args->argvalue = args->argv[1];
  801122:	8b 43 04             	mov    0x4(%ebx),%eax
  801125:	8b 48 04             	mov    0x4(%eax),%ecx
  801128:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	8b 12                	mov    (%edx),%edx
  801130:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801137:	52                   	push   %edx
  801138:	8d 50 08             	lea    0x8(%eax),%edx
  80113b:	52                   	push   %edx
  80113c:	83 c0 04             	add    $0x4,%eax
  80113f:	50                   	push   %eax
  801140:	e8 f2 f9 ff ff       	call   800b37 <memmove>
		(*args->argc)--;
  801145:	8b 03                	mov    (%ebx),%eax
  801147:	ff 08                	decl   (%eax)
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	eb c5                	jmp    801113 <argnextvalue+0x20>
		args->argvalue = 0;
  80114e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801155:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  80115c:	eb b5                	jmp    801113 <argnextvalue+0x20>
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb b1                	jmp    801116 <argnextvalue+0x23>

00801165 <argvalue>:
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80116e:	8b 51 0c             	mov    0xc(%ecx),%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	85 d2                	test   %edx,%edx
  801175:	74 02                	je     801179 <argvalue+0x14>
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	51                   	push   %ecx
  80117d:	e8 71 ff ff ff       	call   8010f3 <argnextvalue>
  801182:	83 c4 10             	add    $0x10,%esp
  801185:	eb f0                	jmp    801177 <argvalue+0x12>

00801187 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	05 00 00 00 30       	add    $0x30000000,%eax
  801192:	c1 e8 0c             	shr    $0xc,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    

008011ae <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011b9:	89 c2                	mov    %eax,%edx
  8011bb:	c1 ea 16             	shr    $0x16,%edx
  8011be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c5:	f6 c2 01             	test   $0x1,%dl
  8011c8:	74 2a                	je     8011f4 <fd_alloc+0x46>
  8011ca:	89 c2                	mov    %eax,%edx
  8011cc:	c1 ea 0c             	shr    $0xc,%edx
  8011cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d6:	f6 c2 01             	test   $0x1,%dl
  8011d9:	74 19                	je     8011f4 <fd_alloc+0x46>
  8011db:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011e0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011e5:	75 d2                	jne    8011b9 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011e7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011ed:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011f2:	eb 07                	jmp    8011fb <fd_alloc+0x4d>
			*fd_store = fd;
  8011f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801200:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801204:	77 39                	ja     80123f <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	c1 e0 0c             	shl    $0xc,%eax
  80120c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801211:	89 c2                	mov    %eax,%edx
  801213:	c1 ea 16             	shr    $0x16,%edx
  801216:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80121d:	f6 c2 01             	test   $0x1,%dl
  801220:	74 24                	je     801246 <fd_lookup+0x49>
  801222:	89 c2                	mov    %eax,%edx
  801224:	c1 ea 0c             	shr    $0xc,%edx
  801227:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122e:	f6 c2 01             	test   $0x1,%dl
  801231:	74 1a                	je     80124d <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801233:	8b 55 0c             	mov    0xc(%ebp),%edx
  801236:	89 02                	mov    %eax,(%edx)
	return 0;
  801238:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123d:	5d                   	pop    %ebp
  80123e:	c3                   	ret    
		return -E_INVAL;
  80123f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801244:	eb f7                	jmp    80123d <fd_lookup+0x40>
		return -E_INVAL;
  801246:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124b:	eb f0                	jmp    80123d <fd_lookup+0x40>
  80124d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801252:	eb e9                	jmp    80123d <fd_lookup+0x40>

00801254 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125d:	ba 88 28 80 00       	mov    $0x802888,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801262:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801267:	39 08                	cmp    %ecx,(%eax)
  801269:	74 33                	je     80129e <dev_lookup+0x4a>
  80126b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80126e:	8b 02                	mov    (%edx),%eax
  801270:	85 c0                	test   %eax,%eax
  801272:	75 f3                	jne    801267 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801274:	a1 20 44 80 00       	mov    0x804420,%eax
  801279:	8b 40 48             	mov    0x48(%eax),%eax
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	51                   	push   %ecx
  801280:	50                   	push   %eax
  801281:	68 0c 28 80 00       	push   $0x80280c
  801286:	e8 ae 0d 00 00       	call   802039 <cprintf>
	*dev = 0;
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    
			*dev = devtab[i];
  80129e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a8:	eb f2                	jmp    80129c <dev_lookup+0x48>

008012aa <fd_close>:
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 1c             	sub    $0x1c,%esp
  8012b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012bc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012c3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c6:	50                   	push   %eax
  8012c7:	e8 31 ff ff ff       	call   8011fd <fd_lookup>
  8012cc:	89 c7                	mov    %eax,%edi
  8012ce:	83 c4 08             	add    $0x8,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	78 05                	js     8012da <fd_close+0x30>
	    || fd != fd2)
  8012d5:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8012d8:	74 13                	je     8012ed <fd_close+0x43>
		return (must_exist ? r : 0);
  8012da:	84 db                	test   %bl,%bl
  8012dc:	75 05                	jne    8012e3 <fd_close+0x39>
  8012de:	bf 00 00 00 00       	mov    $0x0,%edi
}
  8012e3:	89 f8                	mov    %edi,%eax
  8012e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e8:	5b                   	pop    %ebx
  8012e9:	5e                   	pop    %esi
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 36                	pushl  (%esi)
  8012f6:	e8 59 ff ff ff       	call   801254 <dev_lookup>
  8012fb:	89 c7                	mov    %eax,%edi
  8012fd:	83 c4 10             	add    $0x10,%esp
  801300:	85 c0                	test   %eax,%eax
  801302:	78 15                	js     801319 <fd_close+0x6f>
		if (dev->dev_close)
  801304:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801307:	8b 40 10             	mov    0x10(%eax),%eax
  80130a:	85 c0                	test   %eax,%eax
  80130c:	74 1b                	je     801329 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80130e:	83 ec 0c             	sub    $0xc,%esp
  801311:	56                   	push   %esi
  801312:	ff d0                	call   *%eax
  801314:	89 c7                	mov    %eax,%edi
  801316:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801319:	83 ec 08             	sub    $0x8,%esp
  80131c:	56                   	push   %esi
  80131d:	6a 00                	push   $0x0
  80131f:	e8 da fa ff ff       	call   800dfe <sys_page_unmap>
	return r;
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	eb ba                	jmp    8012e3 <fd_close+0x39>
			r = 0;
  801329:	bf 00 00 00 00       	mov    $0x0,%edi
  80132e:	eb e9                	jmp    801319 <fd_close+0x6f>

00801330 <close>:

int
close(int fdnum)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801339:	50                   	push   %eax
  80133a:	ff 75 08             	pushl  0x8(%ebp)
  80133d:	e8 bb fe ff ff       	call   8011fd <fd_lookup>
  801342:	83 c4 08             	add    $0x8,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 10                	js     801359 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	6a 01                	push   $0x1
  80134e:	ff 75 f4             	pushl  -0xc(%ebp)
  801351:	e8 54 ff ff ff       	call   8012aa <fd_close>
  801356:	83 c4 10             	add    $0x10,%esp
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <close_all>:

void
close_all(void)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	53                   	push   %ebx
  80135f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801362:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	53                   	push   %ebx
  80136b:	e8 c0 ff ff ff       	call   801330 <close>
	for (i = 0; i < MAXFD; i++)
  801370:	43                   	inc    %ebx
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	83 fb 20             	cmp    $0x20,%ebx
  801377:	75 ee                	jne    801367 <close_all+0xc>
}
  801379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	57                   	push   %edi
  801382:	56                   	push   %esi
  801383:	53                   	push   %ebx
  801384:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801387:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80138a:	50                   	push   %eax
  80138b:	ff 75 08             	pushl  0x8(%ebp)
  80138e:	e8 6a fe ff ff       	call   8011fd <fd_lookup>
  801393:	89 c3                	mov    %eax,%ebx
  801395:	83 c4 08             	add    $0x8,%esp
  801398:	85 c0                	test   %eax,%eax
  80139a:	0f 88 81 00 00 00    	js     801421 <dup+0xa3>
		return r;
	close(newfdnum);
  8013a0:	83 ec 0c             	sub    $0xc,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 85 ff ff ff       	call   801330 <close>

	newfd = INDEX2FD(newfdnum);
  8013ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ae:	c1 e6 0c             	shl    $0xc,%esi
  8013b1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013b7:	83 c4 04             	add    $0x4,%esp
  8013ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013bd:	e8 d5 fd ff ff       	call   801197 <fd2data>
  8013c2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013c4:	89 34 24             	mov    %esi,(%esp)
  8013c7:	e8 cb fd ff ff       	call   801197 <fd2data>
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013d1:	89 d8                	mov    %ebx,%eax
  8013d3:	c1 e8 16             	shr    $0x16,%eax
  8013d6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013dd:	a8 01                	test   $0x1,%al
  8013df:	74 11                	je     8013f2 <dup+0x74>
  8013e1:	89 d8                	mov    %ebx,%eax
  8013e3:	c1 e8 0c             	shr    $0xc,%eax
  8013e6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013ed:	f6 c2 01             	test   $0x1,%dl
  8013f0:	75 39                	jne    80142b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f5:	89 d0                	mov    %edx,%eax
  8013f7:	c1 e8 0c             	shr    $0xc,%eax
  8013fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	25 07 0e 00 00       	and    $0xe07,%eax
  801409:	50                   	push   %eax
  80140a:	56                   	push   %esi
  80140b:	6a 00                	push   $0x0
  80140d:	52                   	push   %edx
  80140e:	6a 00                	push   $0x0
  801410:	e8 a7 f9 ff ff       	call   800dbc <sys_page_map>
  801415:	89 c3                	mov    %eax,%ebx
  801417:	83 c4 20             	add    $0x20,%esp
  80141a:	85 c0                	test   %eax,%eax
  80141c:	78 31                	js     80144f <dup+0xd1>
		goto err;

	return newfdnum;
  80141e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801421:	89 d8                	mov    %ebx,%eax
  801423:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5f                   	pop    %edi
  801429:	5d                   	pop    %ebp
  80142a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80142b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801432:	83 ec 0c             	sub    $0xc,%esp
  801435:	25 07 0e 00 00       	and    $0xe07,%eax
  80143a:	50                   	push   %eax
  80143b:	57                   	push   %edi
  80143c:	6a 00                	push   $0x0
  80143e:	53                   	push   %ebx
  80143f:	6a 00                	push   $0x0
  801441:	e8 76 f9 ff ff       	call   800dbc <sys_page_map>
  801446:	89 c3                	mov    %eax,%ebx
  801448:	83 c4 20             	add    $0x20,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	79 a3                	jns    8013f2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80144f:	83 ec 08             	sub    $0x8,%esp
  801452:	56                   	push   %esi
  801453:	6a 00                	push   $0x0
  801455:	e8 a4 f9 ff ff       	call   800dfe <sys_page_unmap>
	sys_page_unmap(0, nva);
  80145a:	83 c4 08             	add    $0x8,%esp
  80145d:	57                   	push   %edi
  80145e:	6a 00                	push   $0x0
  801460:	e8 99 f9 ff ff       	call   800dfe <sys_page_unmap>
	return r;
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	eb b7                	jmp    801421 <dup+0xa3>

0080146a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	53                   	push   %ebx
  80146e:	83 ec 14             	sub    $0x14,%esp
  801471:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801474:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801477:	50                   	push   %eax
  801478:	53                   	push   %ebx
  801479:	e8 7f fd ff ff       	call   8011fd <fd_lookup>
  80147e:	83 c4 08             	add    $0x8,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 3f                	js     8014c4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801485:	83 ec 08             	sub    $0x8,%esp
  801488:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148f:	ff 30                	pushl  (%eax)
  801491:	e8 be fd ff ff       	call   801254 <dev_lookup>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 27                	js     8014c4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80149d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014a0:	8b 42 08             	mov    0x8(%edx),%eax
  8014a3:	83 e0 03             	and    $0x3,%eax
  8014a6:	83 f8 01             	cmp    $0x1,%eax
  8014a9:	74 1e                	je     8014c9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ae:	8b 40 08             	mov    0x8(%eax),%eax
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	74 35                	je     8014ea <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	ff 75 10             	pushl  0x10(%ebp)
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	52                   	push   %edx
  8014bf:	ff d0                	call   *%eax
  8014c1:	83 c4 10             	add    $0x10,%esp
}
  8014c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c9:	a1 20 44 80 00       	mov    0x804420,%eax
  8014ce:	8b 40 48             	mov    0x48(%eax),%eax
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	53                   	push   %ebx
  8014d5:	50                   	push   %eax
  8014d6:	68 4d 28 80 00       	push   $0x80284d
  8014db:	e8 59 0b 00 00       	call   802039 <cprintf>
		return -E_INVAL;
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e8:	eb da                	jmp    8014c4 <read+0x5a>
		return -E_NOT_SUPP;
  8014ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ef:	eb d3                	jmp    8014c4 <read+0x5a>

008014f1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	57                   	push   %edi
  8014f5:	56                   	push   %esi
  8014f6:	53                   	push   %ebx
  8014f7:	83 ec 0c             	sub    $0xc,%esp
  8014fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014fd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801500:	bb 00 00 00 00       	mov    $0x0,%ebx
  801505:	39 f3                	cmp    %esi,%ebx
  801507:	73 25                	jae    80152e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	89 f0                	mov    %esi,%eax
  80150e:	29 d8                	sub    %ebx,%eax
  801510:	50                   	push   %eax
  801511:	89 d8                	mov    %ebx,%eax
  801513:	03 45 0c             	add    0xc(%ebp),%eax
  801516:	50                   	push   %eax
  801517:	57                   	push   %edi
  801518:	e8 4d ff ff ff       	call   80146a <read>
		if (m < 0)
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 08                	js     80152c <readn+0x3b>
			return m;
		if (m == 0)
  801524:	85 c0                	test   %eax,%eax
  801526:	74 06                	je     80152e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801528:	01 c3                	add    %eax,%ebx
  80152a:	eb d9                	jmp    801505 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80152c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80152e:	89 d8                	mov    %ebx,%eax
  801530:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5f                   	pop    %edi
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	53                   	push   %ebx
  80153c:	83 ec 14             	sub    $0x14,%esp
  80153f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801542:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801545:	50                   	push   %eax
  801546:	53                   	push   %ebx
  801547:	e8 b1 fc ff ff       	call   8011fd <fd_lookup>
  80154c:	83 c4 08             	add    $0x8,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 3a                	js     80158d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801559:	50                   	push   %eax
  80155a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155d:	ff 30                	pushl  (%eax)
  80155f:	e8 f0 fc ff ff       	call   801254 <dev_lookup>
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	78 22                	js     80158d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801572:	74 1e                	je     801592 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801577:	8b 52 0c             	mov    0xc(%edx),%edx
  80157a:	85 d2                	test   %edx,%edx
  80157c:	74 35                	je     8015b3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80157e:	83 ec 04             	sub    $0x4,%esp
  801581:	ff 75 10             	pushl  0x10(%ebp)
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	50                   	push   %eax
  801588:	ff d2                	call   *%edx
  80158a:	83 c4 10             	add    $0x10,%esp
}
  80158d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801590:	c9                   	leave  
  801591:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801592:	a1 20 44 80 00       	mov    0x804420,%eax
  801597:	8b 40 48             	mov    0x48(%eax),%eax
  80159a:	83 ec 04             	sub    $0x4,%esp
  80159d:	53                   	push   %ebx
  80159e:	50                   	push   %eax
  80159f:	68 69 28 80 00       	push   $0x802869
  8015a4:	e8 90 0a 00 00       	call   802039 <cprintf>
		return -E_INVAL;
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b1:	eb da                	jmp    80158d <write+0x55>
		return -E_NOT_SUPP;
  8015b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b8:	eb d3                	jmp    80158d <write+0x55>

008015ba <seek>:

int
seek(int fdnum, off_t offset)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015c3:	50                   	push   %eax
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	e8 31 fc ff ff       	call   8011fd <fd_lookup>
  8015cc:	83 c4 08             	add    $0x8,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 0e                	js     8015e1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	53                   	push   %ebx
  8015e7:	83 ec 14             	sub    $0x14,%esp
  8015ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f0:	50                   	push   %eax
  8015f1:	53                   	push   %ebx
  8015f2:	e8 06 fc ff ff       	call   8011fd <fd_lookup>
  8015f7:	83 c4 08             	add    $0x8,%esp
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	78 37                	js     801635 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801604:	50                   	push   %eax
  801605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801608:	ff 30                	pushl  (%eax)
  80160a:	e8 45 fc ff ff       	call   801254 <dev_lookup>
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	85 c0                	test   %eax,%eax
  801614:	78 1f                	js     801635 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801619:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80161d:	74 1b                	je     80163a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80161f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801622:	8b 52 18             	mov    0x18(%edx),%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	74 32                	je     80165b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801629:	83 ec 08             	sub    $0x8,%esp
  80162c:	ff 75 0c             	pushl  0xc(%ebp)
  80162f:	50                   	push   %eax
  801630:	ff d2                	call   *%edx
  801632:	83 c4 10             	add    $0x10,%esp
}
  801635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801638:	c9                   	leave  
  801639:	c3                   	ret    
			thisenv->env_id, fdnum);
  80163a:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80163f:	8b 40 48             	mov    0x48(%eax),%eax
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	53                   	push   %ebx
  801646:	50                   	push   %eax
  801647:	68 2c 28 80 00       	push   $0x80282c
  80164c:	e8 e8 09 00 00       	call   802039 <cprintf>
		return -E_INVAL;
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801659:	eb da                	jmp    801635 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80165b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801660:	eb d3                	jmp    801635 <ftruncate+0x52>

00801662 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	53                   	push   %ebx
  801666:	83 ec 14             	sub    $0x14,%esp
  801669:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166f:	50                   	push   %eax
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 85 fb ff ff       	call   8011fd <fd_lookup>
  801678:	83 c4 08             	add    $0x8,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	78 4b                	js     8016ca <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801685:	50                   	push   %eax
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	ff 30                	pushl  (%eax)
  80168b:	e8 c4 fb ff ff       	call   801254 <dev_lookup>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	85 c0                	test   %eax,%eax
  801695:	78 33                	js     8016ca <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80169e:	74 2f                	je     8016cf <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016a3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016aa:	00 00 00 
	stat->st_type = 0;
  8016ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b4:	00 00 00 
	stat->st_dev = dev;
  8016b7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016bd:	83 ec 08             	sub    $0x8,%esp
  8016c0:	53                   	push   %ebx
  8016c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c4:	ff 50 14             	call   *0x14(%eax)
  8016c7:	83 c4 10             	add    $0x10,%esp
}
  8016ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    
		return -E_NOT_SUPP;
  8016cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d4:	eb f4                	jmp    8016ca <fstat+0x68>

008016d6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	56                   	push   %esi
  8016da:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	6a 00                	push   $0x0
  8016e0:	ff 75 08             	pushl  0x8(%ebp)
  8016e3:	e8 34 02 00 00       	call   80191c <open>
  8016e8:	89 c3                	mov    %eax,%ebx
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 1b                	js     80170c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016f1:	83 ec 08             	sub    $0x8,%esp
  8016f4:	ff 75 0c             	pushl  0xc(%ebp)
  8016f7:	50                   	push   %eax
  8016f8:	e8 65 ff ff ff       	call   801662 <fstat>
  8016fd:	89 c6                	mov    %eax,%esi
	close(fd);
  8016ff:	89 1c 24             	mov    %ebx,(%esp)
  801702:	e8 29 fc ff ff       	call   801330 <close>
	return r;
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	89 f3                	mov    %esi,%ebx
}
  80170c:	89 d8                	mov    %ebx,%eax
  80170e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801711:	5b                   	pop    %ebx
  801712:	5e                   	pop    %esi
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    

00801715 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	56                   	push   %esi
  801719:	53                   	push   %ebx
  80171a:	89 c6                	mov    %eax,%esi
  80171c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80171e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801725:	74 27                	je     80174e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801727:	6a 07                	push   $0x7
  801729:	68 00 50 80 00       	push   $0x805000
  80172e:	56                   	push   %esi
  80172f:	ff 35 00 40 80 00    	pushl  0x804000
  801735:	e8 9c 09 00 00       	call   8020d6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173a:	83 c4 0c             	add    $0xc,%esp
  80173d:	6a 00                	push   $0x0
  80173f:	53                   	push   %ebx
  801740:	6a 00                	push   $0x0
  801742:	e8 06 09 00 00       	call   80204d <ipc_recv>
}
  801747:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174a:	5b                   	pop    %ebx
  80174b:	5e                   	pop    %esi
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	6a 01                	push   $0x1
  801753:	e8 da 09 00 00       	call   802132 <ipc_find_env>
  801758:	a3 00 40 80 00       	mov    %eax,0x804000
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	eb c5                	jmp    801727 <fsipc+0x12>

00801762 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8b 40 0c             	mov    0xc(%eax),%eax
  80176e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801773:	8b 45 0c             	mov    0xc(%ebp),%eax
  801776:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80177b:	ba 00 00 00 00       	mov    $0x0,%edx
  801780:	b8 02 00 00 00       	mov    $0x2,%eax
  801785:	e8 8b ff ff ff       	call   801715 <fsipc>
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <devfile_flush>:
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8b 40 0c             	mov    0xc(%eax),%eax
  801798:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80179d:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a2:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a7:	e8 69 ff ff ff       	call   801715 <fsipc>
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <devfile_stat>:
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8017be:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c8:	b8 05 00 00 00       	mov    $0x5,%eax
  8017cd:	e8 43 ff ff ff       	call   801715 <fsipc>
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 2c                	js     801802 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	68 00 50 80 00       	push   $0x805000
  8017de:	53                   	push   %ebx
  8017df:	e8 e0 f1 ff ff       	call   8009c4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e4:	a1 80 50 80 00       	mov    0x805080,%eax
  8017e9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8017ef:	a1 84 50 80 00       	mov    0x805084,%eax
  8017f4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <devfile_write>:
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	53                   	push   %ebx
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801811:	89 d8                	mov    %ebx,%eax
  801813:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801819:	76 05                	jbe    801820 <devfile_write+0x19>
  80181b:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801820:	8b 55 08             	mov    0x8(%ebp),%edx
  801823:	8b 52 0c             	mov    0xc(%edx),%edx
  801826:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80182c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	50                   	push   %eax
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	68 08 50 80 00       	push   $0x805008
  80183d:	e8 f5 f2 ff ff       	call   800b37 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801842:	ba 00 00 00 00       	mov    $0x0,%edx
  801847:	b8 04 00 00 00       	mov    $0x4,%eax
  80184c:	e8 c4 fe ff ff       	call   801715 <fsipc>
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	78 0b                	js     801863 <devfile_write+0x5c>
	assert(r <= n);
  801858:	39 c3                	cmp    %eax,%ebx
  80185a:	72 0c                	jb     801868 <devfile_write+0x61>
	assert(r <= PGSIZE);
  80185c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801861:	7f 1e                	jg     801881 <devfile_write+0x7a>
}
  801863:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801866:	c9                   	leave  
  801867:	c3                   	ret    
	assert(r <= n);
  801868:	68 98 28 80 00       	push   $0x802898
  80186d:	68 9f 28 80 00       	push   $0x80289f
  801872:	68 98 00 00 00       	push   $0x98
  801877:	68 b4 28 80 00       	push   $0x8028b4
  80187c:	e8 d0 ea ff ff       	call   800351 <_panic>
	assert(r <= PGSIZE);
  801881:	68 bf 28 80 00       	push   $0x8028bf
  801886:	68 9f 28 80 00       	push   $0x80289f
  80188b:	68 99 00 00 00       	push   $0x99
  801890:	68 b4 28 80 00       	push   $0x8028b4
  801895:	e8 b7 ea ff ff       	call   800351 <_panic>

0080189a <devfile_read>:
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ad:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8018bd:	e8 53 fe ff ff       	call   801715 <fsipc>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 1f                	js     8018e7 <devfile_read+0x4d>
	assert(r <= n);
  8018c8:	39 c6                	cmp    %eax,%esi
  8018ca:	72 24                	jb     8018f0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018d1:	7f 33                	jg     801906 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	50                   	push   %eax
  8018d7:	68 00 50 80 00       	push   $0x805000
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	e8 53 f2 ff ff       	call   800b37 <memmove>
	return r;
  8018e4:	83 c4 10             	add    $0x10,%esp
}
  8018e7:	89 d8                	mov    %ebx,%eax
  8018e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ec:	5b                   	pop    %ebx
  8018ed:	5e                   	pop    %esi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
	assert(r <= n);
  8018f0:	68 98 28 80 00       	push   $0x802898
  8018f5:	68 9f 28 80 00       	push   $0x80289f
  8018fa:	6a 7c                	push   $0x7c
  8018fc:	68 b4 28 80 00       	push   $0x8028b4
  801901:	e8 4b ea ff ff       	call   800351 <_panic>
	assert(r <= PGSIZE);
  801906:	68 bf 28 80 00       	push   $0x8028bf
  80190b:	68 9f 28 80 00       	push   $0x80289f
  801910:	6a 7d                	push   $0x7d
  801912:	68 b4 28 80 00       	push   $0x8028b4
  801917:	e8 35 ea ff ff       	call   800351 <_panic>

0080191c <open>:
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	56                   	push   %esi
  801920:	53                   	push   %ebx
  801921:	83 ec 1c             	sub    $0x1c,%esp
  801924:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801927:	56                   	push   %esi
  801928:	e8 64 f0 ff ff       	call   800991 <strlen>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801935:	7f 6c                	jg     8019a3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801937:	83 ec 0c             	sub    $0xc,%esp
  80193a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193d:	50                   	push   %eax
  80193e:	e8 6b f8 ff ff       	call   8011ae <fd_alloc>
  801943:	89 c3                	mov    %eax,%ebx
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 3c                	js     801988 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	56                   	push   %esi
  801950:	68 00 50 80 00       	push   $0x805000
  801955:	e8 6a f0 ff ff       	call   8009c4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801965:	b8 01 00 00 00       	mov    $0x1,%eax
  80196a:	e8 a6 fd ff ff       	call   801715 <fsipc>
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	85 c0                	test   %eax,%eax
  801976:	78 19                	js     801991 <open+0x75>
	return fd2num(fd);
  801978:	83 ec 0c             	sub    $0xc,%esp
  80197b:	ff 75 f4             	pushl  -0xc(%ebp)
  80197e:	e8 04 f8 ff ff       	call   801187 <fd2num>
  801983:	89 c3                	mov    %eax,%ebx
  801985:	83 c4 10             	add    $0x10,%esp
}
  801988:	89 d8                	mov    %ebx,%eax
  80198a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5e                   	pop    %esi
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    
		fd_close(fd, 0);
  801991:	83 ec 08             	sub    $0x8,%esp
  801994:	6a 00                	push   $0x0
  801996:	ff 75 f4             	pushl  -0xc(%ebp)
  801999:	e8 0c f9 ff ff       	call   8012aa <fd_close>
		return r;
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	eb e5                	jmp    801988 <open+0x6c>
		return -E_BAD_PATH;
  8019a3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019a8:	eb de                	jmp    801988 <open+0x6c>

008019aa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ba:	e8 56 fd ff ff       	call   801715 <fsipc>
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8019c1:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019c5:	7e 38                	jle    8019ff <writebuf+0x3e>
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	53                   	push   %ebx
  8019cb:	83 ec 08             	sub    $0x8,%esp
  8019ce:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019d0:	ff 70 04             	pushl  0x4(%eax)
  8019d3:	8d 40 10             	lea    0x10(%eax),%eax
  8019d6:	50                   	push   %eax
  8019d7:	ff 33                	pushl  (%ebx)
  8019d9:	e8 5a fb ff ff       	call   801538 <write>
		if (result > 0)
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	7e 03                	jle    8019e8 <writebuf+0x27>
			b->result += result;
  8019e5:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019e8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019eb:	74 0e                	je     8019fb <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8019ed:	89 c2                	mov    %eax,%edx
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	7e 05                	jle    8019f8 <writebuf+0x37>
  8019f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f8:	89 53 0c             	mov    %edx,0xc(%ebx)
	}
}
  8019fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <putch>:

static void
putch(int ch, void *thunk)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	53                   	push   %ebx
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a0a:	8b 53 04             	mov    0x4(%ebx),%edx
  801a0d:	8d 42 01             	lea    0x1(%edx),%eax
  801a10:	89 43 04             	mov    %eax,0x4(%ebx)
  801a13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a16:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a1a:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a1f:	74 06                	je     801a27 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a21:	83 c4 04             	add    $0x4,%esp
  801a24:	5b                   	pop    %ebx
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    
		writebuf(b);
  801a27:	89 d8                	mov    %ebx,%eax
  801a29:	e8 93 ff ff ff       	call   8019c1 <writebuf>
		b->idx = 0;
  801a2e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a35:	eb ea                	jmp    801a21 <putch+0x21>

00801a37 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a50:	00 00 00 
	b.result = 0;
  801a53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a5a:	00 00 00 
	b.error = 1;
  801a5d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a64:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a67:	ff 75 10             	pushl  0x10(%ebp)
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a73:	50                   	push   %eax
  801a74:	68 00 1a 80 00       	push   $0x801a00
  801a79:	e8 38 ea ff ff       	call   8004b6 <vprintfmt>
	if (b.idx > 0)
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a88:	7e 0b                	jle    801a95 <vfprintf+0x5e>
		writebuf(&b);
  801a8a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a90:	e8 2c ff ff ff       	call   8019c1 <writebuf>

	return (b.result ? b.result : b.error);
  801a95:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	75 06                	jne    801aa5 <vfprintf+0x6e>
  801a9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801aad:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ab0:	50                   	push   %eax
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	ff 75 08             	pushl  0x8(%ebp)
  801ab7:	e8 7b ff ff ff       	call   801a37 <vfprintf>
	va_end(ap);

	return cnt;
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <printf>:

int
printf(const char *fmt, ...)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ac4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801ac7:	50                   	push   %eax
  801ac8:	ff 75 08             	pushl  0x8(%ebp)
  801acb:	6a 01                	push   $0x1
  801acd:	e8 65 ff ff ff       	call   801a37 <vfprintf>
	va_end(ap);

	return cnt;
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	56                   	push   %esi
  801ad8:	53                   	push   %ebx
  801ad9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801adc:	83 ec 0c             	sub    $0xc,%esp
  801adf:	ff 75 08             	pushl  0x8(%ebp)
  801ae2:	e8 b0 f6 ff ff       	call   801197 <fd2data>
  801ae7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ae9:	83 c4 08             	add    $0x8,%esp
  801aec:	68 cb 28 80 00       	push   $0x8028cb
  801af1:	53                   	push   %ebx
  801af2:	e8 cd ee ff ff       	call   8009c4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801af7:	8b 46 04             	mov    0x4(%esi),%eax
  801afa:	2b 06                	sub    (%esi),%eax
  801afc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801b02:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801b09:	10 00 00 
	stat->st_dev = &devpipe;
  801b0c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b13:	30 80 00 
	return 0;
}
  801b16:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1e:	5b                   	pop    %ebx
  801b1f:	5e                   	pop    %esi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    

00801b22 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	53                   	push   %ebx
  801b26:	83 ec 0c             	sub    $0xc,%esp
  801b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b2c:	53                   	push   %ebx
  801b2d:	6a 00                	push   $0x0
  801b2f:	e8 ca f2 ff ff       	call   800dfe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b34:	89 1c 24             	mov    %ebx,(%esp)
  801b37:	e8 5b f6 ff ff       	call   801197 <fd2data>
  801b3c:	83 c4 08             	add    $0x8,%esp
  801b3f:	50                   	push   %eax
  801b40:	6a 00                	push   $0x0
  801b42:	e8 b7 f2 ff ff       	call   800dfe <sys_page_unmap>
}
  801b47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <_pipeisclosed>:
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	57                   	push   %edi
  801b50:	56                   	push   %esi
  801b51:	53                   	push   %ebx
  801b52:	83 ec 1c             	sub    $0x1c,%esp
  801b55:	89 c7                	mov    %eax,%edi
  801b57:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b59:	a1 20 44 80 00       	mov    0x804420,%eax
  801b5e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b61:	83 ec 0c             	sub    $0xc,%esp
  801b64:	57                   	push   %edi
  801b65:	e8 0a 06 00 00       	call   802174 <pageref>
  801b6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b6d:	89 34 24             	mov    %esi,(%esp)
  801b70:	e8 ff 05 00 00       	call   802174 <pageref>
		nn = thisenv->env_runs;
  801b75:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801b7b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	39 cb                	cmp    %ecx,%ebx
  801b83:	74 1b                	je     801ba0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b85:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b88:	75 cf                	jne    801b59 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b8a:	8b 42 58             	mov    0x58(%edx),%eax
  801b8d:	6a 01                	push   $0x1
  801b8f:	50                   	push   %eax
  801b90:	53                   	push   %ebx
  801b91:	68 d2 28 80 00       	push   $0x8028d2
  801b96:	e8 9e 04 00 00       	call   802039 <cprintf>
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	eb b9                	jmp    801b59 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ba0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba3:	0f 94 c0             	sete   %al
  801ba6:	0f b6 c0             	movzbl %al,%eax
}
  801ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bac:	5b                   	pop    %ebx
  801bad:	5e                   	pop    %esi
  801bae:	5f                   	pop    %edi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    

00801bb1 <devpipe_write>:
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	57                   	push   %edi
  801bb5:	56                   	push   %esi
  801bb6:	53                   	push   %ebx
  801bb7:	83 ec 18             	sub    $0x18,%esp
  801bba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bbd:	56                   	push   %esi
  801bbe:	e8 d4 f5 ff ff       	call   801197 <fd2data>
  801bc3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bc5:	83 c4 10             	add    $0x10,%esp
  801bc8:	bf 00 00 00 00       	mov    $0x0,%edi
  801bcd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bd0:	74 41                	je     801c13 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bd2:	8b 53 04             	mov    0x4(%ebx),%edx
  801bd5:	8b 03                	mov    (%ebx),%eax
  801bd7:	83 c0 20             	add    $0x20,%eax
  801bda:	39 c2                	cmp    %eax,%edx
  801bdc:	72 14                	jb     801bf2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bde:	89 da                	mov    %ebx,%edx
  801be0:	89 f0                	mov    %esi,%eax
  801be2:	e8 65 ff ff ff       	call   801b4c <_pipeisclosed>
  801be7:	85 c0                	test   %eax,%eax
  801be9:	75 2c                	jne    801c17 <devpipe_write+0x66>
			sys_yield();
  801beb:	e8 50 f2 ff ff       	call   800e40 <sys_yield>
  801bf0:	eb e0                	jmp    801bd2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801bf8:	89 d0                	mov    %edx,%eax
  801bfa:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801bff:	78 0b                	js     801c0c <devpipe_write+0x5b>
  801c01:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801c05:	42                   	inc    %edx
  801c06:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c09:	47                   	inc    %edi
  801c0a:	eb c1                	jmp    801bcd <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c0c:	48                   	dec    %eax
  801c0d:	83 c8 e0             	or     $0xffffffe0,%eax
  801c10:	40                   	inc    %eax
  801c11:	eb ee                	jmp    801c01 <devpipe_write+0x50>
	return i;
  801c13:	89 f8                	mov    %edi,%eax
  801c15:	eb 05                	jmp    801c1c <devpipe_write+0x6b>
				return 0;
  801c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    

00801c24 <devpipe_read>:
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	57                   	push   %edi
  801c28:	56                   	push   %esi
  801c29:	53                   	push   %ebx
  801c2a:	83 ec 18             	sub    $0x18,%esp
  801c2d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c30:	57                   	push   %edi
  801c31:	e8 61 f5 ff ff       	call   801197 <fd2data>
  801c36:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c40:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c43:	74 46                	je     801c8b <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801c45:	8b 06                	mov    (%esi),%eax
  801c47:	3b 46 04             	cmp    0x4(%esi),%eax
  801c4a:	75 22                	jne    801c6e <devpipe_read+0x4a>
			if (i > 0)
  801c4c:	85 db                	test   %ebx,%ebx
  801c4e:	74 0a                	je     801c5a <devpipe_read+0x36>
				return i;
  801c50:	89 d8                	mov    %ebx,%eax
}
  801c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5f                   	pop    %edi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801c5a:	89 f2                	mov    %esi,%edx
  801c5c:	89 f8                	mov    %edi,%eax
  801c5e:	e8 e9 fe ff ff       	call   801b4c <_pipeisclosed>
  801c63:	85 c0                	test   %eax,%eax
  801c65:	75 28                	jne    801c8f <devpipe_read+0x6b>
			sys_yield();
  801c67:	e8 d4 f1 ff ff       	call   800e40 <sys_yield>
  801c6c:	eb d7                	jmp    801c45 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c6e:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801c73:	78 0f                	js     801c84 <devpipe_read+0x60>
  801c75:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c7c:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c7f:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801c81:	43                   	inc    %ebx
  801c82:	eb bc                	jmp    801c40 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c84:	48                   	dec    %eax
  801c85:	83 c8 e0             	or     $0xffffffe0,%eax
  801c88:	40                   	inc    %eax
  801c89:	eb ea                	jmp    801c75 <devpipe_read+0x51>
	return i;
  801c8b:	89 d8                	mov    %ebx,%eax
  801c8d:	eb c3                	jmp    801c52 <devpipe_read+0x2e>
				return 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	eb bc                	jmp    801c52 <devpipe_read+0x2e>

00801c96 <pipe>:
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	56                   	push   %esi
  801c9a:	53                   	push   %ebx
  801c9b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca1:	50                   	push   %eax
  801ca2:	e8 07 f5 ff ff       	call   8011ae <fd_alloc>
  801ca7:	89 c3                	mov    %eax,%ebx
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	85 c0                	test   %eax,%eax
  801cae:	0f 88 2a 01 00 00    	js     801dde <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	68 07 04 00 00       	push   $0x407
  801cbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbf:	6a 00                	push   $0x0
  801cc1:	e8 b3 f0 ff ff       	call   800d79 <sys_page_alloc>
  801cc6:	89 c3                	mov    %eax,%ebx
  801cc8:	83 c4 10             	add    $0x10,%esp
  801ccb:	85 c0                	test   %eax,%eax
  801ccd:	0f 88 0b 01 00 00    	js     801dde <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd9:	50                   	push   %eax
  801cda:	e8 cf f4 ff ff       	call   8011ae <fd_alloc>
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	0f 88 e2 00 00 00    	js     801dce <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	68 07 04 00 00       	push   $0x407
  801cf4:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf7:	6a 00                	push   $0x0
  801cf9:	e8 7b f0 ff ff       	call   800d79 <sys_page_alloc>
  801cfe:	89 c3                	mov    %eax,%ebx
  801d00:	83 c4 10             	add    $0x10,%esp
  801d03:	85 c0                	test   %eax,%eax
  801d05:	0f 88 c3 00 00 00    	js     801dce <pipe+0x138>
	va = fd2data(fd0);
  801d0b:	83 ec 0c             	sub    $0xc,%esp
  801d0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d11:	e8 81 f4 ff ff       	call   801197 <fd2data>
  801d16:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d18:	83 c4 0c             	add    $0xc,%esp
  801d1b:	68 07 04 00 00       	push   $0x407
  801d20:	50                   	push   %eax
  801d21:	6a 00                	push   $0x0
  801d23:	e8 51 f0 ff ff       	call   800d79 <sys_page_alloc>
  801d28:	89 c3                	mov    %eax,%ebx
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	0f 88 89 00 00 00    	js     801dbe <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	ff 75 f0             	pushl  -0x10(%ebp)
  801d3b:	e8 57 f4 ff ff       	call   801197 <fd2data>
  801d40:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d47:	50                   	push   %eax
  801d48:	6a 00                	push   $0x0
  801d4a:	56                   	push   %esi
  801d4b:	6a 00                	push   $0x0
  801d4d:	e8 6a f0 ff ff       	call   800dbc <sys_page_map>
  801d52:	89 c3                	mov    %eax,%ebx
  801d54:	83 c4 20             	add    $0x20,%esp
  801d57:	85 c0                	test   %eax,%eax
  801d59:	78 55                	js     801db0 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801d5b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d64:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d70:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d79:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d85:	83 ec 0c             	sub    $0xc,%esp
  801d88:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8b:	e8 f7 f3 ff ff       	call   801187 <fd2num>
  801d90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d93:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d95:	83 c4 04             	add    $0x4,%esp
  801d98:	ff 75 f0             	pushl  -0x10(%ebp)
  801d9b:	e8 e7 f3 ff ff       	call   801187 <fd2num>
  801da0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dae:	eb 2e                	jmp    801dde <pipe+0x148>
	sys_page_unmap(0, va);
  801db0:	83 ec 08             	sub    $0x8,%esp
  801db3:	56                   	push   %esi
  801db4:	6a 00                	push   $0x0
  801db6:	e8 43 f0 ff ff       	call   800dfe <sys_page_unmap>
  801dbb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dbe:	83 ec 08             	sub    $0x8,%esp
  801dc1:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 33 f0 ff ff       	call   800dfe <sys_page_unmap>
  801dcb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dce:	83 ec 08             	sub    $0x8,%esp
  801dd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd4:	6a 00                	push   $0x0
  801dd6:	e8 23 f0 ff ff       	call   800dfe <sys_page_unmap>
  801ddb:	83 c4 10             	add    $0x10,%esp
}
  801dde:	89 d8                	mov    %ebx,%eax
  801de0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <pipeisclosed>:
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ded:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df0:	50                   	push   %eax
  801df1:	ff 75 08             	pushl  0x8(%ebp)
  801df4:	e8 04 f4 ff ff       	call   8011fd <fd_lookup>
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	78 18                	js     801e18 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	ff 75 f4             	pushl  -0xc(%ebp)
  801e06:	e8 8c f3 ff ff       	call   801197 <fd2data>
	return _pipeisclosed(fd, p);
  801e0b:	89 c2                	mov    %eax,%edx
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	e8 37 fd ff ff       	call   801b4c <_pipeisclosed>
  801e15:	83 c4 10             	add    $0x10,%esp
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    

00801e24 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	53                   	push   %ebx
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801e2e:	68 ea 28 80 00       	push   $0x8028ea
  801e33:	53                   	push   %ebx
  801e34:	e8 8b eb ff ff       	call   8009c4 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801e39:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801e40:	20 00 00 
	return 0;
}
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <devcons_write>:
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	57                   	push   %edi
  801e51:	56                   	push   %esi
  801e52:	53                   	push   %ebx
  801e53:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e59:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e5e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e64:	eb 1d                	jmp    801e83 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801e66:	83 ec 04             	sub    $0x4,%esp
  801e69:	53                   	push   %ebx
  801e6a:	03 45 0c             	add    0xc(%ebp),%eax
  801e6d:	50                   	push   %eax
  801e6e:	57                   	push   %edi
  801e6f:	e8 c3 ec ff ff       	call   800b37 <memmove>
		sys_cputs(buf, m);
  801e74:	83 c4 08             	add    $0x8,%esp
  801e77:	53                   	push   %ebx
  801e78:	57                   	push   %edi
  801e79:	e8 5e ee ff ff       	call   800cdc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e7e:	01 de                	add    %ebx,%esi
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	89 f0                	mov    %esi,%eax
  801e85:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e88:	73 11                	jae    801e9b <devcons_write+0x4e>
		m = n - tot;
  801e8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e8d:	29 f3                	sub    %esi,%ebx
  801e8f:	83 fb 7f             	cmp    $0x7f,%ebx
  801e92:	76 d2                	jbe    801e66 <devcons_write+0x19>
  801e94:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801e99:	eb cb                	jmp    801e66 <devcons_write+0x19>
}
  801e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e9e:	5b                   	pop    %ebx
  801e9f:	5e                   	pop    %esi
  801ea0:	5f                   	pop    %edi
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <devcons_read>:
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801ea9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ead:	75 0c                	jne    801ebb <devcons_read+0x18>
		return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	eb 21                	jmp    801ed7 <devcons_read+0x34>
		sys_yield();
  801eb6:	e8 85 ef ff ff       	call   800e40 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ebb:	e8 3a ee ff ff       	call   800cfa <sys_cgetc>
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	74 f2                	je     801eb6 <devcons_read+0x13>
	if (c < 0)
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	78 0f                	js     801ed7 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801ec8:	83 f8 04             	cmp    $0x4,%eax
  801ecb:	74 0c                	je     801ed9 <devcons_read+0x36>
	*(char*)vbuf = c;
  801ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed0:	88 02                	mov    %al,(%edx)
	return 1;
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    
		return 0;
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	eb f7                	jmp    801ed7 <devcons_read+0x34>

00801ee0 <cputchar>:
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801eec:	6a 01                	push   $0x1
  801eee:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ef1:	50                   	push   %eax
  801ef2:	e8 e5 ed ff ff       	call   800cdc <sys_cputs>
}
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <getchar>:
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f02:	6a 01                	push   $0x1
  801f04:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f07:	50                   	push   %eax
  801f08:	6a 00                	push   $0x0
  801f0a:	e8 5b f5 ff ff       	call   80146a <read>
	if (r < 0)
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	85 c0                	test   %eax,%eax
  801f14:	78 08                	js     801f1e <getchar+0x22>
	if (r < 1)
  801f16:	85 c0                	test   %eax,%eax
  801f18:	7e 06                	jle    801f20 <getchar+0x24>
	return c;
  801f1a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    
		return -E_EOF;
  801f20:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f25:	eb f7                	jmp    801f1e <getchar+0x22>

00801f27 <iscons>:
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f30:	50                   	push   %eax
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	e8 c4 f2 ff ff       	call   8011fd <fd_lookup>
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 11                	js     801f51 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f49:	39 10                	cmp    %edx,(%eax)
  801f4b:	0f 94 c0             	sete   %al
  801f4e:	0f b6 c0             	movzbl %al,%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <opencons>:
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5c:	50                   	push   %eax
  801f5d:	e8 4c f2 ff ff       	call   8011ae <fd_alloc>
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 3a                	js     801fa3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	68 07 04 00 00       	push   $0x407
  801f71:	ff 75 f4             	pushl  -0xc(%ebp)
  801f74:	6a 00                	push   $0x0
  801f76:	e8 fe ed ff ff       	call   800d79 <sys_page_alloc>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 21                	js     801fa3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f82:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	50                   	push   %eax
  801f9b:	e8 e7 f1 ff ff       	call   801187 <fd2num>
  801fa0:	83 c4 10             	add    $0x10,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	53                   	push   %ebx
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801faf:	8b 13                	mov    (%ebx),%edx
  801fb1:	8d 42 01             	lea    0x1(%edx),%eax
  801fb4:	89 03                	mov    %eax,(%ebx)
  801fb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801fbd:	3d ff 00 00 00       	cmp    $0xff,%eax
  801fc2:	74 08                	je     801fcc <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801fc4:	ff 43 04             	incl   0x4(%ebx)
}
  801fc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801fcc:	83 ec 08             	sub    $0x8,%esp
  801fcf:	68 ff 00 00 00       	push   $0xff
  801fd4:	8d 43 08             	lea    0x8(%ebx),%eax
  801fd7:	50                   	push   %eax
  801fd8:	e8 ff ec ff ff       	call   800cdc <sys_cputs>
		b->idx = 0;
  801fdd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fe3:	83 c4 10             	add    $0x10,%esp
  801fe6:	eb dc                	jmp    801fc4 <putch+0x1f>

00801fe8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801ff1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ff8:	00 00 00 
	b.cnt = 0;
  801ffb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  802002:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  802011:	50                   	push   %eax
  802012:	68 a5 1f 80 00       	push   $0x801fa5
  802017:	e8 9a e4 ff ff       	call   8004b6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80201c:	83 c4 08             	add    $0x8,%esp
  80201f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  802025:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80202b:	50                   	push   %eax
  80202c:	e8 ab ec ff ff       	call   800cdc <sys_cputs>

	return b.cnt;
}
  802031:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80203f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  802042:	50                   	push   %eax
  802043:	ff 75 08             	pushl  0x8(%ebp)
  802046:	e8 9d ff ff ff       	call   801fe8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	57                   	push   %edi
  802051:	56                   	push   %esi
  802052:	53                   	push   %ebx
  802053:	83 ec 0c             	sub    $0xc,%esp
  802056:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802059:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80205c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  80205f:	85 ff                	test   %edi,%edi
  802061:	74 53                	je     8020b6 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  802063:	83 ec 0c             	sub    $0xc,%esp
  802066:	57                   	push   %edi
  802067:	e8 1d ef ff ff       	call   800f89 <sys_ipc_recv>
  80206c:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  80206f:	85 db                	test   %ebx,%ebx
  802071:	74 0b                	je     80207e <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802073:	8b 15 20 44 80 00    	mov    0x804420,%edx
  802079:	8b 52 74             	mov    0x74(%edx),%edx
  80207c:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  80207e:	85 f6                	test   %esi,%esi
  802080:	74 0f                	je     802091 <ipc_recv+0x44>
  802082:	85 ff                	test   %edi,%edi
  802084:	74 0b                	je     802091 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802086:	8b 15 20 44 80 00    	mov    0x804420,%edx
  80208c:	8b 52 78             	mov    0x78(%edx),%edx
  80208f:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  802091:	85 c0                	test   %eax,%eax
  802093:	74 30                	je     8020c5 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802095:	85 db                	test   %ebx,%ebx
  802097:	74 06                	je     80209f <ipc_recv+0x52>
      		*from_env_store = 0;
  802099:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  80209f:	85 f6                	test   %esi,%esi
  8020a1:	74 2c                	je     8020cf <ipc_recv+0x82>
      		*perm_store = 0;
  8020a3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  8020a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  8020ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8020b6:	83 ec 0c             	sub    $0xc,%esp
  8020b9:	6a ff                	push   $0xffffffff
  8020bb:	e8 c9 ee ff ff       	call   800f89 <sys_ipc_recv>
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	eb aa                	jmp    80206f <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  8020c5:	a1 20 44 80 00       	mov    0x804420,%eax
  8020ca:	8b 40 70             	mov    0x70(%eax),%eax
  8020cd:	eb df                	jmp    8020ae <ipc_recv+0x61>
		return -1;
  8020cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020d4:	eb d8                	jmp    8020ae <ipc_recv+0x61>

008020d6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020e5:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8020e8:	85 db                	test   %ebx,%ebx
  8020ea:	75 22                	jne    80210e <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8020ec:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8020f1:	eb 1b                	jmp    80210e <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8020f3:	68 f8 28 80 00       	push   $0x8028f8
  8020f8:	68 9f 28 80 00       	push   $0x80289f
  8020fd:	6a 48                	push   $0x48
  8020ff:	68 1c 29 80 00       	push   $0x80291c
  802104:	e8 48 e2 ff ff       	call   800351 <_panic>
		sys_yield();
  802109:	e8 32 ed ff ff       	call   800e40 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  80210e:	57                   	push   %edi
  80210f:	53                   	push   %ebx
  802110:	56                   	push   %esi
  802111:	ff 75 08             	pushl  0x8(%ebp)
  802114:	e8 4d ee ff ff       	call   800f66 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80211f:	74 e8                	je     802109 <ipc_send+0x33>
  802121:	85 c0                	test   %eax,%eax
  802123:	75 ce                	jne    8020f3 <ipc_send+0x1d>
		sys_yield();
  802125:	e8 16 ed ff ff       	call   800e40 <sys_yield>
		
	}
	
}
  80212a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80212d:	5b                   	pop    %ebx
  80212e:	5e                   	pop    %esi
  80212f:	5f                   	pop    %edi
  802130:	5d                   	pop    %ebp
  802131:	c3                   	ret    

00802132 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80213d:	89 c2                	mov    %eax,%edx
  80213f:	c1 e2 05             	shl    $0x5,%edx
  802142:	29 c2                	sub    %eax,%edx
  802144:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  80214b:	8b 52 50             	mov    0x50(%edx),%edx
  80214e:	39 ca                	cmp    %ecx,%edx
  802150:	74 0f                	je     802161 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802152:	40                   	inc    %eax
  802153:	3d 00 04 00 00       	cmp    $0x400,%eax
  802158:	75 e3                	jne    80213d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80215a:	b8 00 00 00 00       	mov    $0x0,%eax
  80215f:	eb 11                	jmp    802172 <ipc_find_env+0x40>
			return envs[i].env_id;
  802161:	89 c2                	mov    %eax,%edx
  802163:	c1 e2 05             	shl    $0x5,%edx
  802166:	29 c2                	sub    %eax,%edx
  802168:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80216f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    

00802174 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	c1 e8 16             	shr    $0x16,%eax
  80217d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802184:	a8 01                	test   $0x1,%al
  802186:	74 21                	je     8021a9 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	c1 e8 0c             	shr    $0xc,%eax
  80218e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802195:	a8 01                	test   $0x1,%al
  802197:	74 17                	je     8021b0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802199:	c1 e8 0c             	shr    $0xc,%eax
  80219c:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  8021a3:	ef 
  8021a4:	0f b7 c0             	movzwl %ax,%eax
  8021a7:	eb 05                	jmp    8021ae <pageref+0x3a>
		return 0;
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    
		return 0;
  8021b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b5:	eb f7                	jmp    8021ae <pageref+0x3a>
  8021b7:	90                   	nop

008021b8 <__udivdi3>:
  8021b8:	55                   	push   %ebp
  8021b9:	57                   	push   %edi
  8021ba:	56                   	push   %esi
  8021bb:	53                   	push   %ebx
  8021bc:	83 ec 1c             	sub    $0x1c,%esp
  8021bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021cb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021cf:	89 ca                	mov    %ecx,%edx
  8021d1:	89 f8                	mov    %edi,%eax
  8021d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021d7:	85 f6                	test   %esi,%esi
  8021d9:	75 2d                	jne    802208 <__udivdi3+0x50>
  8021db:	39 cf                	cmp    %ecx,%edi
  8021dd:	77 65                	ja     802244 <__udivdi3+0x8c>
  8021df:	89 fd                	mov    %edi,%ebp
  8021e1:	85 ff                	test   %edi,%edi
  8021e3:	75 0b                	jne    8021f0 <__udivdi3+0x38>
  8021e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ea:	31 d2                	xor    %edx,%edx
  8021ec:	f7 f7                	div    %edi
  8021ee:	89 c5                	mov    %eax,%ebp
  8021f0:	31 d2                	xor    %edx,%edx
  8021f2:	89 c8                	mov    %ecx,%eax
  8021f4:	f7 f5                	div    %ebp
  8021f6:	89 c1                	mov    %eax,%ecx
  8021f8:	89 d8                	mov    %ebx,%eax
  8021fa:	f7 f5                	div    %ebp
  8021fc:	89 cf                	mov    %ecx,%edi
  8021fe:	89 fa                	mov    %edi,%edx
  802200:	83 c4 1c             	add    $0x1c,%esp
  802203:	5b                   	pop    %ebx
  802204:	5e                   	pop    %esi
  802205:	5f                   	pop    %edi
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    
  802208:	39 ce                	cmp    %ecx,%esi
  80220a:	77 28                	ja     802234 <__udivdi3+0x7c>
  80220c:	0f bd fe             	bsr    %esi,%edi
  80220f:	83 f7 1f             	xor    $0x1f,%edi
  802212:	75 40                	jne    802254 <__udivdi3+0x9c>
  802214:	39 ce                	cmp    %ecx,%esi
  802216:	72 0a                	jb     802222 <__udivdi3+0x6a>
  802218:	3b 44 24 04          	cmp    0x4(%esp),%eax
  80221c:	0f 87 9e 00 00 00    	ja     8022c0 <__udivdi3+0x108>
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	89 fa                	mov    %edi,%edx
  802229:	83 c4 1c             	add    $0x1c,%esp
  80222c:	5b                   	pop    %ebx
  80222d:	5e                   	pop    %esi
  80222e:	5f                   	pop    %edi
  80222f:	5d                   	pop    %ebp
  802230:	c3                   	ret    
  802231:	8d 76 00             	lea    0x0(%esi),%esi
  802234:	31 ff                	xor    %edi,%edi
  802236:	31 c0                	xor    %eax,%eax
  802238:	89 fa                	mov    %edi,%edx
  80223a:	83 c4 1c             	add    $0x1c,%esp
  80223d:	5b                   	pop    %ebx
  80223e:	5e                   	pop    %esi
  80223f:	5f                   	pop    %edi
  802240:	5d                   	pop    %ebp
  802241:	c3                   	ret    
  802242:	66 90                	xchg   %ax,%ax
  802244:	89 d8                	mov    %ebx,%eax
  802246:	f7 f7                	div    %edi
  802248:	31 ff                	xor    %edi,%edi
  80224a:	89 fa                	mov    %edi,%edx
  80224c:	83 c4 1c             	add    $0x1c,%esp
  80224f:	5b                   	pop    %ebx
  802250:	5e                   	pop    %esi
  802251:	5f                   	pop    %edi
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    
  802254:	bd 20 00 00 00       	mov    $0x20,%ebp
  802259:	29 fd                	sub    %edi,%ebp
  80225b:	89 f9                	mov    %edi,%ecx
  80225d:	d3 e6                	shl    %cl,%esi
  80225f:	89 c3                	mov    %eax,%ebx
  802261:	89 e9                	mov    %ebp,%ecx
  802263:	d3 eb                	shr    %cl,%ebx
  802265:	89 d9                	mov    %ebx,%ecx
  802267:	09 f1                	or     %esi,%ecx
  802269:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80226d:	89 f9                	mov    %edi,%ecx
  80226f:	d3 e0                	shl    %cl,%eax
  802271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802275:	89 d6                	mov    %edx,%esi
  802277:	89 e9                	mov    %ebp,%ecx
  802279:	d3 ee                	shr    %cl,%esi
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 e2                	shl    %cl,%edx
  80227f:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802283:	89 e9                	mov    %ebp,%ecx
  802285:	d3 eb                	shr    %cl,%ebx
  802287:	09 da                	or     %ebx,%edx
  802289:	89 d0                	mov    %edx,%eax
  80228b:	89 f2                	mov    %esi,%edx
  80228d:	f7 74 24 08          	divl   0x8(%esp)
  802291:	89 d6                	mov    %edx,%esi
  802293:	89 c3                	mov    %eax,%ebx
  802295:	f7 64 24 0c          	mull   0xc(%esp)
  802299:	39 d6                	cmp    %edx,%esi
  80229b:	72 17                	jb     8022b4 <__udivdi3+0xfc>
  80229d:	74 09                	je     8022a8 <__udivdi3+0xf0>
  80229f:	89 d8                	mov    %ebx,%eax
  8022a1:	31 ff                	xor    %edi,%edi
  8022a3:	e9 56 ff ff ff       	jmp    8021fe <__udivdi3+0x46>
  8022a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022ac:	89 f9                	mov    %edi,%ecx
  8022ae:	d3 e2                	shl    %cl,%edx
  8022b0:	39 c2                	cmp    %eax,%edx
  8022b2:	73 eb                	jae    80229f <__udivdi3+0xe7>
  8022b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022b7:	31 ff                	xor    %edi,%edi
  8022b9:	e9 40 ff ff ff       	jmp    8021fe <__udivdi3+0x46>
  8022be:	66 90                	xchg   %ax,%ax
  8022c0:	31 c0                	xor    %eax,%eax
  8022c2:	e9 37 ff ff ff       	jmp    8021fe <__udivdi3+0x46>
  8022c7:	90                   	nop

008022c8 <__umoddi3>:
  8022c8:	55                   	push   %ebp
  8022c9:	57                   	push   %edi
  8022ca:	56                   	push   %esi
  8022cb:	53                   	push   %ebx
  8022cc:	83 ec 1c             	sub    $0x1c,%esp
  8022cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e7:	89 3c 24             	mov    %edi,(%esp)
  8022ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022ee:	89 f2                	mov    %esi,%edx
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	75 18                	jne    80230c <__umoddi3+0x44>
  8022f4:	39 f7                	cmp    %esi,%edi
  8022f6:	0f 86 a0 00 00 00    	jbe    80239c <__umoddi3+0xd4>
  8022fc:	89 c8                	mov    %ecx,%eax
  8022fe:	f7 f7                	div    %edi
  802300:	89 d0                	mov    %edx,%eax
  802302:	31 d2                	xor    %edx,%edx
  802304:	83 c4 1c             	add    $0x1c,%esp
  802307:	5b                   	pop    %ebx
  802308:	5e                   	pop    %esi
  802309:	5f                   	pop    %edi
  80230a:	5d                   	pop    %ebp
  80230b:	c3                   	ret    
  80230c:	89 f3                	mov    %esi,%ebx
  80230e:	39 f0                	cmp    %esi,%eax
  802310:	0f 87 a6 00 00 00    	ja     8023bc <__umoddi3+0xf4>
  802316:	0f bd e8             	bsr    %eax,%ebp
  802319:	83 f5 1f             	xor    $0x1f,%ebp
  80231c:	0f 84 a6 00 00 00    	je     8023c8 <__umoddi3+0x100>
  802322:	bf 20 00 00 00       	mov    $0x20,%edi
  802327:	29 ef                	sub    %ebp,%edi
  802329:	89 e9                	mov    %ebp,%ecx
  80232b:	d3 e0                	shl    %cl,%eax
  80232d:	8b 34 24             	mov    (%esp),%esi
  802330:	89 f2                	mov    %esi,%edx
  802332:	89 f9                	mov    %edi,%ecx
  802334:	d3 ea                	shr    %cl,%edx
  802336:	09 c2                	or     %eax,%edx
  802338:	89 14 24             	mov    %edx,(%esp)
  80233b:	89 f2                	mov    %esi,%edx
  80233d:	89 e9                	mov    %ebp,%ecx
  80233f:	d3 e2                	shl    %cl,%edx
  802341:	89 54 24 04          	mov    %edx,0x4(%esp)
  802345:	89 de                	mov    %ebx,%esi
  802347:	89 f9                	mov    %edi,%ecx
  802349:	d3 ee                	shr    %cl,%esi
  80234b:	89 e9                	mov    %ebp,%ecx
  80234d:	d3 e3                	shl    %cl,%ebx
  80234f:	8b 54 24 08          	mov    0x8(%esp),%edx
  802353:	89 d0                	mov    %edx,%eax
  802355:	89 f9                	mov    %edi,%ecx
  802357:	d3 e8                	shr    %cl,%eax
  802359:	09 d8                	or     %ebx,%eax
  80235b:	89 d3                	mov    %edx,%ebx
  80235d:	89 e9                	mov    %ebp,%ecx
  80235f:	d3 e3                	shl    %cl,%ebx
  802361:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802365:	89 f2                	mov    %esi,%edx
  802367:	f7 34 24             	divl   (%esp)
  80236a:	89 d6                	mov    %edx,%esi
  80236c:	f7 64 24 04          	mull   0x4(%esp)
  802370:	89 c3                	mov    %eax,%ebx
  802372:	89 d1                	mov    %edx,%ecx
  802374:	39 d6                	cmp    %edx,%esi
  802376:	72 7c                	jb     8023f4 <__umoddi3+0x12c>
  802378:	74 72                	je     8023ec <__umoddi3+0x124>
  80237a:	8b 54 24 08          	mov    0x8(%esp),%edx
  80237e:	29 da                	sub    %ebx,%edx
  802380:	19 ce                	sbb    %ecx,%esi
  802382:	89 f0                	mov    %esi,%eax
  802384:	89 f9                	mov    %edi,%ecx
  802386:	d3 e0                	shl    %cl,%eax
  802388:	89 e9                	mov    %ebp,%ecx
  80238a:	d3 ea                	shr    %cl,%edx
  80238c:	09 d0                	or     %edx,%eax
  80238e:	89 e9                	mov    %ebp,%ecx
  802390:	d3 ee                	shr    %cl,%esi
  802392:	89 f2                	mov    %esi,%edx
  802394:	83 c4 1c             	add    $0x1c,%esp
  802397:	5b                   	pop    %ebx
  802398:	5e                   	pop    %esi
  802399:	5f                   	pop    %edi
  80239a:	5d                   	pop    %ebp
  80239b:	c3                   	ret    
  80239c:	89 fd                	mov    %edi,%ebp
  80239e:	85 ff                	test   %edi,%edi
  8023a0:	75 0b                	jne    8023ad <__umoddi3+0xe5>
  8023a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a7:	31 d2                	xor    %edx,%edx
  8023a9:	f7 f7                	div    %edi
  8023ab:	89 c5                	mov    %eax,%ebp
  8023ad:	89 f0                	mov    %esi,%eax
  8023af:	31 d2                	xor    %edx,%edx
  8023b1:	f7 f5                	div    %ebp
  8023b3:	89 c8                	mov    %ecx,%eax
  8023b5:	f7 f5                	div    %ebp
  8023b7:	e9 44 ff ff ff       	jmp    802300 <__umoddi3+0x38>
  8023bc:	89 c8                	mov    %ecx,%eax
  8023be:	89 f2                	mov    %esi,%edx
  8023c0:	83 c4 1c             	add    $0x1c,%esp
  8023c3:	5b                   	pop    %ebx
  8023c4:	5e                   	pop    %esi
  8023c5:	5f                   	pop    %edi
  8023c6:	5d                   	pop    %ebp
  8023c7:	c3                   	ret    
  8023c8:	39 f0                	cmp    %esi,%eax
  8023ca:	72 05                	jb     8023d1 <__umoddi3+0x109>
  8023cc:	39 0c 24             	cmp    %ecx,(%esp)
  8023cf:	77 0c                	ja     8023dd <__umoddi3+0x115>
  8023d1:	89 f2                	mov    %esi,%edx
  8023d3:	29 f9                	sub    %edi,%ecx
  8023d5:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023d9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023dd:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023e1:	83 c4 1c             	add    $0x1c,%esp
  8023e4:	5b                   	pop    %ebx
  8023e5:	5e                   	pop    %esi
  8023e6:	5f                   	pop    %edi
  8023e7:	5d                   	pop    %ebp
  8023e8:	c3                   	ret    
  8023e9:	8d 76 00             	lea    0x0(%esi),%esi
  8023ec:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8023f0:	73 88                	jae    80237a <__umoddi3+0xb2>
  8023f2:	66 90                	xchg   %ax,%ax
  8023f4:	2b 44 24 04          	sub    0x4(%esp),%eax
  8023f8:	1b 14 24             	sbb    (%esp),%edx
  8023fb:	89 d1                	mov    %edx,%ecx
  8023fd:	89 c3                	mov    %eax,%ebx
  8023ff:	e9 76 ff ff ff       	jmp    80237a <__umoddi3+0xb2>
