
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 b1 00 00 00       	call   8000e2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800042:	83 ff 01             	cmp    $0x1,%edi
  800045:	7e 24                	jle    80006b <umain+0x38>
  800047:	83 ec 08             	sub    $0x8,%esp
  80004a:	68 a0 1f 80 00       	push   $0x801fa0
  80004f:	ff 76 04             	pushl  0x4(%esi)
  800052:	e8 c1 01 00 00       	call   800218 <strcmp>
  800057:	83 c4 10             	add    $0x10,%esp
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 1b                	jne    800079 <umain+0x46>
		nflag = 1;
		argc--;
  80005e:	4f                   	dec    %edi
		argv++;
  80005f:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800062:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800069:	eb 07                	jmp    800072 <umain+0x3f>
	nflag = 0;
  80006b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	}
	for (i = 1; i < argc; i++) {
  800072:	bb 01 00 00 00       	mov    $0x1,%ebx
  800077:	eb 26                	jmp    80009f <umain+0x6c>
	nflag = 0;
  800079:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800080:	eb f0                	jmp    800072 <umain+0x3f>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800088:	e8 bb 00 00 00       	call   800148 <strlen>
  80008d:	83 c4 0c             	add    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	ff 34 9e             	pushl  (%esi,%ebx,4)
  800094:	6a 01                	push   $0x1
  800096:	e8 fb 0a 00 00       	call   800b96 <write>
	for (i = 1; i < argc; i++) {
  80009b:	43                   	inc    %ebx
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	39 df                	cmp    %ebx,%edi
  8000a1:	7e 1b                	jle    8000be <umain+0x8b>
		if (i > 1)
  8000a3:	83 fb 01             	cmp    $0x1,%ebx
  8000a6:	7e da                	jle    800082 <umain+0x4f>
			write(1, " ", 1);
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	6a 01                	push   $0x1
  8000ad:	68 a3 1f 80 00       	push   $0x801fa3
  8000b2:	6a 01                	push   $0x1
  8000b4:	e8 dd 0a 00 00       	call   800b96 <write>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	eb c4                	jmp    800082 <umain+0x4f>
	}
	if (!nflag)
  8000be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c2:	74 08                	je     8000cc <umain+0x99>
		write(1, "\n", 1);
}
  8000c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c7:	5b                   	pop    %ebx
  8000c8:	5e                   	pop    %esi
  8000c9:	5f                   	pop    %edi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    
		write(1, "\n", 1);
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	6a 01                	push   $0x1
  8000d1:	68 b3 20 80 00       	push   $0x8020b3
  8000d6:	6a 01                	push   $0x1
  8000d8:	e8 b9 0a 00 00       	call   800b96 <write>
  8000dd:	83 c4 10             	add    $0x10,%esp
}
  8000e0:	eb e2                	jmp    8000c4 <umain+0x91>

008000e2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ea:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ed:	e8 1f 04 00 00       	call   800511 <sys_getenvid>
  8000f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f7:	89 c2                	mov    %eax,%edx
  8000f9:	c1 e2 05             	shl    $0x5,%edx
  8000fc:	29 c2                	sub    %eax,%edx
  8000fe:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800105:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010a:	85 db                	test   %ebx,%ebx
  80010c:	7e 07                	jle    800115 <libmain+0x33>
		binaryname = argv[0];
  80010e:	8b 06                	mov    (%esi),%eax
  800110:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
  80011a:	e8 14 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011f:	e8 0a 00 00 00       	call   80012e <exit>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800134:	e8 80 08 00 00       	call   8009b9 <close_all>
	sys_env_destroy(0);
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	e8 8d 03 00 00       	call   8004d0 <sys_env_destroy>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80014e:	b8 00 00 00 00       	mov    $0x0,%eax
  800153:	eb 01                	jmp    800156 <strlen+0xe>
		n++;
  800155:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800156:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80015a:	75 f9                	jne    800155 <strlen+0xd>
	return n;
}
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800164:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800167:	b8 00 00 00 00       	mov    $0x0,%eax
  80016c:	eb 01                	jmp    80016f <strnlen+0x11>
		n++;
  80016e:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80016f:	39 d0                	cmp    %edx,%eax
  800171:	74 06                	je     800179 <strnlen+0x1b>
  800173:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800177:	75 f5                	jne    80016e <strnlen+0x10>
	return n;
}
  800179:	5d                   	pop    %ebp
  80017a:	c3                   	ret    

0080017b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	53                   	push   %ebx
  80017f:	8b 45 08             	mov    0x8(%ebp),%eax
  800182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800185:	89 c2                	mov    %eax,%edx
  800187:	42                   	inc    %edx
  800188:	41                   	inc    %ecx
  800189:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80018c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80018f:	84 db                	test   %bl,%bl
  800191:	75 f4                	jne    800187 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800193:	5b                   	pop    %ebx
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    

00800196 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	53                   	push   %ebx
  80019a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80019d:	53                   	push   %ebx
  80019e:	e8 a5 ff ff ff       	call   800148 <strlen>
  8001a3:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	01 d8                	add    %ebx,%eax
  8001ab:	50                   	push   %eax
  8001ac:	e8 ca ff ff ff       	call   80017b <strcpy>
	return dst;
}
  8001b1:	89 d8                	mov    %ebx,%eax
  8001b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    

008001b8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c3:	89 f3                	mov    %esi,%ebx
  8001c5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001c8:	89 f2                	mov    %esi,%edx
  8001ca:	eb 0c                	jmp    8001d8 <strncpy+0x20>
		*dst++ = *src;
  8001cc:	42                   	inc    %edx
  8001cd:	8a 01                	mov    (%ecx),%al
  8001cf:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001d2:	80 39 01             	cmpb   $0x1,(%ecx)
  8001d5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8001d8:	39 da                	cmp    %ebx,%edx
  8001da:	75 f0                	jne    8001cc <strncpy+0x14>
	}
	return ret;
}
  8001dc:	89 f0                	mov    %esi,%eax
  8001de:	5b                   	pop    %ebx
  8001df:	5e                   	pop    %esi
  8001e0:	5d                   	pop    %ebp
  8001e1:	c3                   	ret    

008001e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8001ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ed:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	74 20                	je     800214 <strlcpy+0x32>
  8001f4:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8001f8:	89 f0                	mov    %esi,%eax
  8001fa:	eb 05                	jmp    800201 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8001fc:	40                   	inc    %eax
  8001fd:	42                   	inc    %edx
  8001fe:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800201:	39 d8                	cmp    %ebx,%eax
  800203:	74 06                	je     80020b <strlcpy+0x29>
  800205:	8a 0a                	mov    (%edx),%cl
  800207:	84 c9                	test   %cl,%cl
  800209:	75 f1                	jne    8001fc <strlcpy+0x1a>
		*dst = '\0';
  80020b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80020e:	29 f0                	sub    %esi,%eax
}
  800210:	5b                   	pop    %ebx
  800211:	5e                   	pop    %esi
  800212:	5d                   	pop    %ebp
  800213:	c3                   	ret    
  800214:	89 f0                	mov    %esi,%eax
  800216:	eb f6                	jmp    80020e <strlcpy+0x2c>

00800218 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800221:	eb 02                	jmp    800225 <strcmp+0xd>
		p++, q++;
  800223:	41                   	inc    %ecx
  800224:	42                   	inc    %edx
	while (*p && *p == *q)
  800225:	8a 01                	mov    (%ecx),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 04                	je     80022f <strcmp+0x17>
  80022b:	3a 02                	cmp    (%edx),%al
  80022d:	74 f4                	je     800223 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80022f:	0f b6 c0             	movzbl %al,%eax
  800232:	0f b6 12             	movzbl (%edx),%edx
  800235:	29 d0                	sub    %edx,%eax
}
  800237:	5d                   	pop    %ebp
  800238:	c3                   	ret    

00800239 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	53                   	push   %ebx
  80023d:	8b 45 08             	mov    0x8(%ebp),%eax
  800240:	8b 55 0c             	mov    0xc(%ebp),%edx
  800243:	89 c3                	mov    %eax,%ebx
  800245:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800248:	eb 02                	jmp    80024c <strncmp+0x13>
		n--, p++, q++;
  80024a:	40                   	inc    %eax
  80024b:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  80024c:	39 d8                	cmp    %ebx,%eax
  80024e:	74 15                	je     800265 <strncmp+0x2c>
  800250:	8a 08                	mov    (%eax),%cl
  800252:	84 c9                	test   %cl,%cl
  800254:	74 04                	je     80025a <strncmp+0x21>
  800256:	3a 0a                	cmp    (%edx),%cl
  800258:	74 f0                	je     80024a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80025a:	0f b6 00             	movzbl (%eax),%eax
  80025d:	0f b6 12             	movzbl (%edx),%edx
  800260:	29 d0                	sub    %edx,%eax
}
  800262:	5b                   	pop    %ebx
  800263:	5d                   	pop    %ebp
  800264:	c3                   	ret    
		return 0;
  800265:	b8 00 00 00 00       	mov    $0x0,%eax
  80026a:	eb f6                	jmp    800262 <strncmp+0x29>

0080026c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800275:	8a 10                	mov    (%eax),%dl
  800277:	84 d2                	test   %dl,%dl
  800279:	74 07                	je     800282 <strchr+0x16>
		if (*s == c)
  80027b:	38 ca                	cmp    %cl,%dl
  80027d:	74 08                	je     800287 <strchr+0x1b>
	for (; *s; s++)
  80027f:	40                   	inc    %eax
  800280:	eb f3                	jmp    800275 <strchr+0x9>
			return (char *) s;
	return 0;
  800282:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    

00800289 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	8b 45 08             	mov    0x8(%ebp),%eax
  80028f:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800292:	8a 10                	mov    (%eax),%dl
  800294:	84 d2                	test   %dl,%dl
  800296:	74 07                	je     80029f <strfind+0x16>
		if (*s == c)
  800298:	38 ca                	cmp    %cl,%dl
  80029a:	74 03                	je     80029f <strfind+0x16>
	for (; *s; s++)
  80029c:	40                   	inc    %eax
  80029d:	eb f3                	jmp    800292 <strfind+0x9>
			break;
	return (char *) s;
}
  80029f:	5d                   	pop    %ebp
  8002a0:	c3                   	ret    

008002a1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	57                   	push   %edi
  8002a5:	56                   	push   %esi
  8002a6:	53                   	push   %ebx
  8002a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002ad:	85 c9                	test   %ecx,%ecx
  8002af:	74 13                	je     8002c4 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002b1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8002b7:	75 05                	jne    8002be <memset+0x1d>
  8002b9:	f6 c1 03             	test   $0x3,%cl
  8002bc:	74 0d                	je     8002cb <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8002be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c1:	fc                   	cld    
  8002c2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8002c4:	89 f8                	mov    %edi,%eax
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    
		c &= 0xFF;
  8002cb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002cf:	89 d3                	mov    %edx,%ebx
  8002d1:	c1 e3 08             	shl    $0x8,%ebx
  8002d4:	89 d0                	mov    %edx,%eax
  8002d6:	c1 e0 18             	shl    $0x18,%eax
  8002d9:	89 d6                	mov    %edx,%esi
  8002db:	c1 e6 10             	shl    $0x10,%esi
  8002de:	09 f0                	or     %esi,%eax
  8002e0:	09 c2                	or     %eax,%edx
  8002e2:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8002e4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8002e7:	89 d0                	mov    %edx,%eax
  8002e9:	fc                   	cld    
  8002ea:	f3 ab                	rep stos %eax,%es:(%edi)
  8002ec:	eb d6                	jmp    8002c4 <memset+0x23>

008002ee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	57                   	push   %edi
  8002f2:	56                   	push   %esi
  8002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8002fc:	39 c6                	cmp    %eax,%esi
  8002fe:	73 33                	jae    800333 <memmove+0x45>
  800300:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800303:	39 d0                	cmp    %edx,%eax
  800305:	73 2c                	jae    800333 <memmove+0x45>
		s += n;
		d += n;
  800307:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80030a:	89 d6                	mov    %edx,%esi
  80030c:	09 fe                	or     %edi,%esi
  80030e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800314:	75 13                	jne    800329 <memmove+0x3b>
  800316:	f6 c1 03             	test   $0x3,%cl
  800319:	75 0e                	jne    800329 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80031b:	83 ef 04             	sub    $0x4,%edi
  80031e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800321:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800324:	fd                   	std    
  800325:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800327:	eb 07                	jmp    800330 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800329:	4f                   	dec    %edi
  80032a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80032d:	fd                   	std    
  80032e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800330:	fc                   	cld    
  800331:	eb 13                	jmp    800346 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800333:	89 f2                	mov    %esi,%edx
  800335:	09 c2                	or     %eax,%edx
  800337:	f6 c2 03             	test   $0x3,%dl
  80033a:	75 05                	jne    800341 <memmove+0x53>
  80033c:	f6 c1 03             	test   $0x3,%cl
  80033f:	74 09                	je     80034a <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800341:	89 c7                	mov    %eax,%edi
  800343:	fc                   	cld    
  800344:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80034a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80034d:	89 c7                	mov    %eax,%edi
  80034f:	fc                   	cld    
  800350:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800352:	eb f2                	jmp    800346 <memmove+0x58>

00800354 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800357:	ff 75 10             	pushl  0x10(%ebp)
  80035a:	ff 75 0c             	pushl  0xc(%ebp)
  80035d:	ff 75 08             	pushl  0x8(%ebp)
  800360:	e8 89 ff ff ff       	call   8002ee <memmove>
}
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	56                   	push   %esi
  80036b:	53                   	push   %ebx
  80036c:	8b 45 08             	mov    0x8(%ebp),%eax
  80036f:	89 c6                	mov    %eax,%esi
  800371:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800374:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800377:	39 f0                	cmp    %esi,%eax
  800379:	74 16                	je     800391 <memcmp+0x2a>
		if (*s1 != *s2)
  80037b:	8a 08                	mov    (%eax),%cl
  80037d:	8a 1a                	mov    (%edx),%bl
  80037f:	38 d9                	cmp    %bl,%cl
  800381:	75 04                	jne    800387 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800383:	40                   	inc    %eax
  800384:	42                   	inc    %edx
  800385:	eb f0                	jmp    800377 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800387:	0f b6 c1             	movzbl %cl,%eax
  80038a:	0f b6 db             	movzbl %bl,%ebx
  80038d:	29 d8                	sub    %ebx,%eax
  80038f:	eb 05                	jmp    800396 <memcmp+0x2f>
	}

	return 0;
  800391:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800396:	5b                   	pop    %ebx
  800397:	5e                   	pop    %esi
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    

0080039a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003a3:	89 c2                	mov    %eax,%edx
  8003a5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8003a8:	39 d0                	cmp    %edx,%eax
  8003aa:	73 07                	jae    8003b3 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003ac:	38 08                	cmp    %cl,(%eax)
  8003ae:	74 03                	je     8003b3 <memfind+0x19>
	for (; s < ends; s++)
  8003b0:	40                   	inc    %eax
  8003b1:	eb f5                	jmp    8003a8 <memfind+0xe>
			break;
	return (void *) s;
}
  8003b3:	5d                   	pop    %ebp
  8003b4:	c3                   	ret    

008003b5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	57                   	push   %edi
  8003b9:	56                   	push   %esi
  8003ba:	53                   	push   %ebx
  8003bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003be:	eb 01                	jmp    8003c1 <strtol+0xc>
		s++;
  8003c0:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8003c1:	8a 01                	mov    (%ecx),%al
  8003c3:	3c 20                	cmp    $0x20,%al
  8003c5:	74 f9                	je     8003c0 <strtol+0xb>
  8003c7:	3c 09                	cmp    $0x9,%al
  8003c9:	74 f5                	je     8003c0 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8003cb:	3c 2b                	cmp    $0x2b,%al
  8003cd:	74 2b                	je     8003fa <strtol+0x45>
		s++;
	else if (*s == '-')
  8003cf:	3c 2d                	cmp    $0x2d,%al
  8003d1:	74 2f                	je     800402 <strtol+0x4d>
	int neg = 0;
  8003d3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8003d8:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8003df:	75 12                	jne    8003f3 <strtol+0x3e>
  8003e1:	80 39 30             	cmpb   $0x30,(%ecx)
  8003e4:	74 24                	je     80040a <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8003e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003ea:	75 07                	jne    8003f3 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8003ec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  8003f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f8:	eb 4e                	jmp    800448 <strtol+0x93>
		s++;
  8003fa:	41                   	inc    %ecx
	int neg = 0;
  8003fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800400:	eb d6                	jmp    8003d8 <strtol+0x23>
		s++, neg = 1;
  800402:	41                   	inc    %ecx
  800403:	bf 01 00 00 00       	mov    $0x1,%edi
  800408:	eb ce                	jmp    8003d8 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80040a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80040e:	74 10                	je     800420 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800410:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800414:	75 dd                	jne    8003f3 <strtol+0x3e>
		s++, base = 8;
  800416:	41                   	inc    %ecx
  800417:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80041e:	eb d3                	jmp    8003f3 <strtol+0x3e>
		s += 2, base = 16;
  800420:	83 c1 02             	add    $0x2,%ecx
  800423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80042a:	eb c7                	jmp    8003f3 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80042c:	8d 72 9f             	lea    -0x61(%edx),%esi
  80042f:	89 f3                	mov    %esi,%ebx
  800431:	80 fb 19             	cmp    $0x19,%bl
  800434:	77 24                	ja     80045a <strtol+0xa5>
			dig = *s - 'a' + 10;
  800436:	0f be d2             	movsbl %dl,%edx
  800439:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80043c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80043f:	7d 2b                	jge    80046c <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800441:	41                   	inc    %ecx
  800442:	0f af 45 10          	imul   0x10(%ebp),%eax
  800446:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800448:	8a 11                	mov    (%ecx),%dl
  80044a:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80044d:	80 fb 09             	cmp    $0x9,%bl
  800450:	77 da                	ja     80042c <strtol+0x77>
			dig = *s - '0';
  800452:	0f be d2             	movsbl %dl,%edx
  800455:	83 ea 30             	sub    $0x30,%edx
  800458:	eb e2                	jmp    80043c <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  80045a:	8d 72 bf             	lea    -0x41(%edx),%esi
  80045d:	89 f3                	mov    %esi,%ebx
  80045f:	80 fb 19             	cmp    $0x19,%bl
  800462:	77 08                	ja     80046c <strtol+0xb7>
			dig = *s - 'A' + 10;
  800464:	0f be d2             	movsbl %dl,%edx
  800467:	83 ea 37             	sub    $0x37,%edx
  80046a:	eb d0                	jmp    80043c <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  80046c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800470:	74 05                	je     800477 <strtol+0xc2>
		*endptr = (char *) s;
  800472:	8b 75 0c             	mov    0xc(%ebp),%esi
  800475:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800477:	85 ff                	test   %edi,%edi
  800479:	74 02                	je     80047d <strtol+0xc8>
  80047b:	f7 d8                	neg    %eax
}
  80047d:	5b                   	pop    %ebx
  80047e:	5e                   	pop    %esi
  80047f:	5f                   	pop    %edi
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <atoi>:

int
atoi(const char *s)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800485:	6a 0a                	push   $0xa
  800487:	6a 00                	push   $0x0
  800489:	ff 75 08             	pushl  0x8(%ebp)
  80048c:	e8 24 ff ff ff       	call   8003b5 <strtol>
}
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	57                   	push   %edi
  800497:	56                   	push   %esi
  800498:	53                   	push   %ebx
	asm volatile("int %1\n"
  800499:	b8 00 00 00 00       	mov    $0x0,%eax
  80049e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a4:	89 c3                	mov    %eax,%ebx
  8004a6:	89 c7                	mov    %eax,%edi
  8004a8:	89 c6                	mov    %eax,%esi
  8004aa:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004ac:	5b                   	pop    %ebx
  8004ad:	5e                   	pop    %esi
  8004ae:	5f                   	pop    %edi
  8004af:	5d                   	pop    %ebp
  8004b0:	c3                   	ret    

008004b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	57                   	push   %edi
  8004b5:	56                   	push   %esi
  8004b6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8004c1:	89 d1                	mov    %edx,%ecx
  8004c3:	89 d3                	mov    %edx,%ebx
  8004c5:	89 d7                	mov    %edx,%edi
  8004c7:	89 d6                	mov    %edx,%esi
  8004c9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8004cb:	5b                   	pop    %ebx
  8004cc:	5e                   	pop    %esi
  8004cd:	5f                   	pop    %edi
  8004ce:	5d                   	pop    %ebp
  8004cf:	c3                   	ret    

008004d0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	57                   	push   %edi
  8004d4:	56                   	push   %esi
  8004d5:	53                   	push   %ebx
  8004d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8004d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004de:	b8 03 00 00 00       	mov    $0x3,%eax
  8004e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e6:	89 cb                	mov    %ecx,%ebx
  8004e8:	89 cf                	mov    %ecx,%edi
  8004ea:	89 ce                	mov    %ecx,%esi
  8004ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8004ee:	85 c0                	test   %eax,%eax
  8004f0:	7f 08                	jg     8004fa <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8004f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f5:	5b                   	pop    %ebx
  8004f6:	5e                   	pop    %esi
  8004f7:	5f                   	pop    %edi
  8004f8:	5d                   	pop    %ebp
  8004f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8004fa:	83 ec 0c             	sub    $0xc,%esp
  8004fd:	50                   	push   %eax
  8004fe:	6a 03                	push   $0x3
  800500:	68 af 1f 80 00       	push   $0x801faf
  800505:	6a 23                	push   $0x23
  800507:	68 cc 1f 80 00       	push   $0x801fcc
  80050c:	e8 df 0f 00 00       	call   8014f0 <_panic>

00800511 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	57                   	push   %edi
  800515:	56                   	push   %esi
  800516:	53                   	push   %ebx
	asm volatile("int %1\n"
  800517:	ba 00 00 00 00       	mov    $0x0,%edx
  80051c:	b8 02 00 00 00       	mov    $0x2,%eax
  800521:	89 d1                	mov    %edx,%ecx
  800523:	89 d3                	mov    %edx,%ebx
  800525:	89 d7                	mov    %edx,%edi
  800527:	89 d6                	mov    %edx,%esi
  800529:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80052b:	5b                   	pop    %ebx
  80052c:	5e                   	pop    %esi
  80052d:	5f                   	pop    %edi
  80052e:	5d                   	pop    %ebp
  80052f:	c3                   	ret    

00800530 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800530:	55                   	push   %ebp
  800531:	89 e5                	mov    %esp,%ebp
  800533:	57                   	push   %edi
  800534:	56                   	push   %esi
  800535:	53                   	push   %ebx
  800536:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800539:	be 00 00 00 00       	mov    $0x0,%esi
  80053e:	b8 04 00 00 00       	mov    $0x4,%eax
  800543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800546:	8b 55 08             	mov    0x8(%ebp),%edx
  800549:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80054c:	89 f7                	mov    %esi,%edi
  80054e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800550:	85 c0                	test   %eax,%eax
  800552:	7f 08                	jg     80055c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800554:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800557:	5b                   	pop    %ebx
  800558:	5e                   	pop    %esi
  800559:	5f                   	pop    %edi
  80055a:	5d                   	pop    %ebp
  80055b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	50                   	push   %eax
  800560:	6a 04                	push   $0x4
  800562:	68 af 1f 80 00       	push   $0x801faf
  800567:	6a 23                	push   $0x23
  800569:	68 cc 1f 80 00       	push   $0x801fcc
  80056e:	e8 7d 0f 00 00       	call   8014f0 <_panic>

00800573 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	57                   	push   %edi
  800577:	56                   	push   %esi
  800578:	53                   	push   %ebx
  800579:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80057c:	b8 05 00 00 00       	mov    $0x5,%eax
  800581:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800584:	8b 55 08             	mov    0x8(%ebp),%edx
  800587:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80058a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80058d:	8b 75 18             	mov    0x18(%ebp),%esi
  800590:	cd 30                	int    $0x30
	if(check && ret > 0)
  800592:	85 c0                	test   %eax,%eax
  800594:	7f 08                	jg     80059e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800596:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800599:	5b                   	pop    %ebx
  80059a:	5e                   	pop    %esi
  80059b:	5f                   	pop    %edi
  80059c:	5d                   	pop    %ebp
  80059d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	6a 05                	push   $0x5
  8005a4:	68 af 1f 80 00       	push   $0x801faf
  8005a9:	6a 23                	push   $0x23
  8005ab:	68 cc 1f 80 00       	push   $0x801fcc
  8005b0:	e8 3b 0f 00 00       	call   8014f0 <_panic>

008005b5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	57                   	push   %edi
  8005b9:	56                   	push   %esi
  8005ba:	53                   	push   %ebx
  8005bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005c3:	b8 06 00 00 00       	mov    $0x6,%eax
  8005c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ce:	89 df                	mov    %ebx,%edi
  8005d0:	89 de                	mov    %ebx,%esi
  8005d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005d4:	85 c0                	test   %eax,%eax
  8005d6:	7f 08                	jg     8005e0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8005d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005db:	5b                   	pop    %ebx
  8005dc:	5e                   	pop    %esi
  8005dd:	5f                   	pop    %edi
  8005de:	5d                   	pop    %ebp
  8005df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	6a 06                	push   $0x6
  8005e6:	68 af 1f 80 00       	push   $0x801faf
  8005eb:	6a 23                	push   $0x23
  8005ed:	68 cc 1f 80 00       	push   $0x801fcc
  8005f2:	e8 f9 0e 00 00       	call   8014f0 <_panic>

008005f7 <sys_yield>:

void
sys_yield(void)
{
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	57                   	push   %edi
  8005fb:	56                   	push   %esi
  8005fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8005fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800602:	b8 0b 00 00 00       	mov    $0xb,%eax
  800607:	89 d1                	mov    %edx,%ecx
  800609:	89 d3                	mov    %edx,%ebx
  80060b:	89 d7                	mov    %edx,%edi
  80060d:	89 d6                	mov    %edx,%esi
  80060f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800611:	5b                   	pop    %ebx
  800612:	5e                   	pop    %esi
  800613:	5f                   	pop    %edi
  800614:	5d                   	pop    %ebp
  800615:	c3                   	ret    

00800616 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	57                   	push   %edi
  80061a:	56                   	push   %esi
  80061b:	53                   	push   %ebx
  80061c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80061f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800624:	b8 08 00 00 00       	mov    $0x8,%eax
  800629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80062c:	8b 55 08             	mov    0x8(%ebp),%edx
  80062f:	89 df                	mov    %ebx,%edi
  800631:	89 de                	mov    %ebx,%esi
  800633:	cd 30                	int    $0x30
	if(check && ret > 0)
  800635:	85 c0                	test   %eax,%eax
  800637:	7f 08                	jg     800641 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800639:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80063c:	5b                   	pop    %ebx
  80063d:	5e                   	pop    %esi
  80063e:	5f                   	pop    %edi
  80063f:	5d                   	pop    %ebp
  800640:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800641:	83 ec 0c             	sub    $0xc,%esp
  800644:	50                   	push   %eax
  800645:	6a 08                	push   $0x8
  800647:	68 af 1f 80 00       	push   $0x801faf
  80064c:	6a 23                	push   $0x23
  80064e:	68 cc 1f 80 00       	push   $0x801fcc
  800653:	e8 98 0e 00 00       	call   8014f0 <_panic>

00800658 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	57                   	push   %edi
  80065c:	56                   	push   %esi
  80065d:	53                   	push   %ebx
  80065e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	b8 0c 00 00 00       	mov    $0xc,%eax
  80066b:	8b 55 08             	mov    0x8(%ebp),%edx
  80066e:	89 cb                	mov    %ecx,%ebx
  800670:	89 cf                	mov    %ecx,%edi
  800672:	89 ce                	mov    %ecx,%esi
  800674:	cd 30                	int    $0x30
	if(check && ret > 0)
  800676:	85 c0                	test   %eax,%eax
  800678:	7f 08                	jg     800682 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  80067a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067d:	5b                   	pop    %ebx
  80067e:	5e                   	pop    %esi
  80067f:	5f                   	pop    %edi
  800680:	5d                   	pop    %ebp
  800681:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800682:	83 ec 0c             	sub    $0xc,%esp
  800685:	50                   	push   %eax
  800686:	6a 0c                	push   $0xc
  800688:	68 af 1f 80 00       	push   $0x801faf
  80068d:	6a 23                	push   $0x23
  80068f:	68 cc 1f 80 00       	push   $0x801fcc
  800694:	e8 57 0e 00 00       	call   8014f0 <_panic>

00800699 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
  80069c:	57                   	push   %edi
  80069d:	56                   	push   %esi
  80069e:	53                   	push   %ebx
  80069f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a7:	b8 09 00 00 00       	mov    $0x9,%eax
  8006ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006af:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b2:	89 df                	mov    %ebx,%edi
  8006b4:	89 de                	mov    %ebx,%esi
  8006b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006b8:	85 c0                	test   %eax,%eax
  8006ba:	7f 08                	jg     8006c4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8006bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006bf:	5b                   	pop    %ebx
  8006c0:	5e                   	pop    %esi
  8006c1:	5f                   	pop    %edi
  8006c2:	5d                   	pop    %ebp
  8006c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006c4:	83 ec 0c             	sub    $0xc,%esp
  8006c7:	50                   	push   %eax
  8006c8:	6a 09                	push   $0x9
  8006ca:	68 af 1f 80 00       	push   $0x801faf
  8006cf:	6a 23                	push   $0x23
  8006d1:	68 cc 1f 80 00       	push   $0x801fcc
  8006d6:	e8 15 0e 00 00       	call   8014f0 <_panic>

008006db <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	57                   	push   %edi
  8006df:	56                   	push   %esi
  8006e0:	53                   	push   %ebx
  8006e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f4:	89 df                	mov    %ebx,%edi
  8006f6:	89 de                	mov    %ebx,%esi
  8006f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	7f 08                	jg     800706 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8006fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800701:	5b                   	pop    %ebx
  800702:	5e                   	pop    %esi
  800703:	5f                   	pop    %edi
  800704:	5d                   	pop    %ebp
  800705:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	50                   	push   %eax
  80070a:	6a 0a                	push   $0xa
  80070c:	68 af 1f 80 00       	push   $0x801faf
  800711:	6a 23                	push   $0x23
  800713:	68 cc 1f 80 00       	push   $0x801fcc
  800718:	e8 d3 0d 00 00       	call   8014f0 <_panic>

0080071d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	57                   	push   %edi
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
	asm volatile("int %1\n"
  800723:	be 00 00 00 00       	mov    $0x0,%esi
  800728:	b8 0d 00 00 00       	mov    $0xd,%eax
  80072d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800730:	8b 55 08             	mov    0x8(%ebp),%edx
  800733:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800736:	8b 7d 14             	mov    0x14(%ebp),%edi
  800739:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80073b:	5b                   	pop    %ebx
  80073c:	5e                   	pop    %esi
  80073d:	5f                   	pop    %edi
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	57                   	push   %edi
  800744:	56                   	push   %esi
  800745:	53                   	push   %ebx
  800746:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800749:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800753:	8b 55 08             	mov    0x8(%ebp),%edx
  800756:	89 cb                	mov    %ecx,%ebx
  800758:	89 cf                	mov    %ecx,%edi
  80075a:	89 ce                	mov    %ecx,%esi
  80075c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80075e:	85 c0                	test   %eax,%eax
  800760:	7f 08                	jg     80076a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800762:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800765:	5b                   	pop    %ebx
  800766:	5e                   	pop    %esi
  800767:	5f                   	pop    %edi
  800768:	5d                   	pop    %ebp
  800769:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80076a:	83 ec 0c             	sub    $0xc,%esp
  80076d:	50                   	push   %eax
  80076e:	6a 0e                	push   $0xe
  800770:	68 af 1f 80 00       	push   $0x801faf
  800775:	6a 23                	push   $0x23
  800777:	68 cc 1f 80 00       	push   $0x801fcc
  80077c:	e8 6f 0d 00 00       	call   8014f0 <_panic>

00800781 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	57                   	push   %edi
  800785:	56                   	push   %esi
  800786:	53                   	push   %ebx
	asm volatile("int %1\n"
  800787:	be 00 00 00 00       	mov    $0x0,%esi
  80078c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800791:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800794:	8b 55 08             	mov    0x8(%ebp),%edx
  800797:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80079a:	89 f7                	mov    %esi,%edi
  80079c:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80079e:	5b                   	pop    %ebx
  80079f:	5e                   	pop    %esi
  8007a0:	5f                   	pop    %edi
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	57                   	push   %edi
  8007a7:	56                   	push   %esi
  8007a8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8007a9:	be 00 00 00 00       	mov    $0x0,%esi
  8007ae:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8007b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007bc:	89 f7                	mov    %esi,%edi
  8007be:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8007c0:	5b                   	pop    %ebx
  8007c1:	5e                   	pop    %esi
  8007c2:	5f                   	pop    %edi
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	57                   	push   %edi
  8007c9:	56                   	push   %esi
  8007ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8007cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d0:	b8 11 00 00 00       	mov    $0x11,%eax
  8007d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d8:	89 cb                	mov    %ecx,%ebx
  8007da:	89 cf                	mov    %ecx,%edi
  8007dc:	89 ce                	mov    %ecx,%esi
  8007de:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8007e0:	5b                   	pop    %ebx
  8007e1:	5e                   	pop    %esi
  8007e2:	5f                   	pop    %edi
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	05 00 00 00 30       	add    $0x30000000,%eax
  8007f0:	c1 e8 0c             	shr    $0xc,%eax
}
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800800:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800805:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800812:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800817:	89 c2                	mov    %eax,%edx
  800819:	c1 ea 16             	shr    $0x16,%edx
  80081c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800823:	f6 c2 01             	test   $0x1,%dl
  800826:	74 2a                	je     800852 <fd_alloc+0x46>
  800828:	89 c2                	mov    %eax,%edx
  80082a:	c1 ea 0c             	shr    $0xc,%edx
  80082d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800834:	f6 c2 01             	test   $0x1,%dl
  800837:	74 19                	je     800852 <fd_alloc+0x46>
  800839:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80083e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800843:	75 d2                	jne    800817 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800845:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80084b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800850:	eb 07                	jmp    800859 <fd_alloc+0x4d>
			*fd_store = fd;
  800852:	89 01                	mov    %eax,(%ecx)
			return 0;
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80085e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800862:	77 39                	ja     80089d <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	c1 e0 0c             	shl    $0xc,%eax
  80086a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80086f:	89 c2                	mov    %eax,%edx
  800871:	c1 ea 16             	shr    $0x16,%edx
  800874:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80087b:	f6 c2 01             	test   $0x1,%dl
  80087e:	74 24                	je     8008a4 <fd_lookup+0x49>
  800880:	89 c2                	mov    %eax,%edx
  800882:	c1 ea 0c             	shr    $0xc,%edx
  800885:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80088c:	f6 c2 01             	test   $0x1,%dl
  80088f:	74 1a                	je     8008ab <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
  800894:	89 02                	mov    %eax,(%edx)
	return 0;
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    
		return -E_INVAL;
  80089d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a2:	eb f7                	jmp    80089b <fd_lookup+0x40>
		return -E_INVAL;
  8008a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a9:	eb f0                	jmp    80089b <fd_lookup+0x40>
  8008ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b0:	eb e9                	jmp    80089b <fd_lookup+0x40>

008008b2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bb:	ba 58 20 80 00       	mov    $0x802058,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8008c0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8008c5:	39 08                	cmp    %ecx,(%eax)
  8008c7:	74 33                	je     8008fc <dev_lookup+0x4a>
  8008c9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8008cc:	8b 02                	mov    (%edx),%eax
  8008ce:	85 c0                	test   %eax,%eax
  8008d0:	75 f3                	jne    8008c5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008d2:	a1 04 40 80 00       	mov    0x804004,%eax
  8008d7:	8b 40 48             	mov    0x48(%eax),%eax
  8008da:	83 ec 04             	sub    $0x4,%esp
  8008dd:	51                   	push   %ecx
  8008de:	50                   	push   %eax
  8008df:	68 dc 1f 80 00       	push   $0x801fdc
  8008e4:	e8 1a 0d 00 00       	call   801603 <cprintf>
	*dev = 0;
  8008e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    
			*dev = devtab[i];
  8008fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ff:	89 01                	mov    %eax,(%ecx)
			return 0;
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	eb f2                	jmp    8008fa <dev_lookup+0x48>

00800908 <fd_close>:
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	57                   	push   %edi
  80090c:	56                   	push   %esi
  80090d:	53                   	push   %ebx
  80090e:	83 ec 1c             	sub    $0x1c,%esp
  800911:	8b 75 08             	mov    0x8(%ebp),%esi
  800914:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800917:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80091a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80091b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800921:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800924:	50                   	push   %eax
  800925:	e8 31 ff ff ff       	call   80085b <fd_lookup>
  80092a:	89 c7                	mov    %eax,%edi
  80092c:	83 c4 08             	add    $0x8,%esp
  80092f:	85 c0                	test   %eax,%eax
  800931:	78 05                	js     800938 <fd_close+0x30>
	    || fd != fd2)
  800933:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800936:	74 13                	je     80094b <fd_close+0x43>
		return (must_exist ? r : 0);
  800938:	84 db                	test   %bl,%bl
  80093a:	75 05                	jne    800941 <fd_close+0x39>
  80093c:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800941:	89 f8                	mov    %edi,%eax
  800943:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800946:	5b                   	pop    %ebx
  800947:	5e                   	pop    %esi
  800948:	5f                   	pop    %edi
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800951:	50                   	push   %eax
  800952:	ff 36                	pushl  (%esi)
  800954:	e8 59 ff ff ff       	call   8008b2 <dev_lookup>
  800959:	89 c7                	mov    %eax,%edi
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	85 c0                	test   %eax,%eax
  800960:	78 15                	js     800977 <fd_close+0x6f>
		if (dev->dev_close)
  800962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800965:	8b 40 10             	mov    0x10(%eax),%eax
  800968:	85 c0                	test   %eax,%eax
  80096a:	74 1b                	je     800987 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80096c:	83 ec 0c             	sub    $0xc,%esp
  80096f:	56                   	push   %esi
  800970:	ff d0                	call   *%eax
  800972:	89 c7                	mov    %eax,%edi
  800974:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	56                   	push   %esi
  80097b:	6a 00                	push   $0x0
  80097d:	e8 33 fc ff ff       	call   8005b5 <sys_page_unmap>
	return r;
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	eb ba                	jmp    800941 <fd_close+0x39>
			r = 0;
  800987:	bf 00 00 00 00       	mov    $0x0,%edi
  80098c:	eb e9                	jmp    800977 <fd_close+0x6f>

0080098e <close>:

int
close(int fdnum)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800994:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800997:	50                   	push   %eax
  800998:	ff 75 08             	pushl  0x8(%ebp)
  80099b:	e8 bb fe ff ff       	call   80085b <fd_lookup>
  8009a0:	83 c4 08             	add    $0x8,%esp
  8009a3:	85 c0                	test   %eax,%eax
  8009a5:	78 10                	js     8009b7 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	6a 01                	push   $0x1
  8009ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8009af:	e8 54 ff ff ff       	call   800908 <fd_close>
  8009b4:	83 c4 10             	add    $0x10,%esp
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <close_all>:

void
close_all(void)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	53                   	push   %ebx
  8009bd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8009c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8009c5:	83 ec 0c             	sub    $0xc,%esp
  8009c8:	53                   	push   %ebx
  8009c9:	e8 c0 ff ff ff       	call   80098e <close>
	for (i = 0; i < MAXFD; i++)
  8009ce:	43                   	inc    %ebx
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	83 fb 20             	cmp    $0x20,%ebx
  8009d5:	75 ee                	jne    8009c5 <close_all+0xc>
}
  8009d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	57                   	push   %edi
  8009e0:	56                   	push   %esi
  8009e1:	53                   	push   %ebx
  8009e2:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8009e8:	50                   	push   %eax
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	e8 6a fe ff ff       	call   80085b <fd_lookup>
  8009f1:	89 c3                	mov    %eax,%ebx
  8009f3:	83 c4 08             	add    $0x8,%esp
  8009f6:	85 c0                	test   %eax,%eax
  8009f8:	0f 88 81 00 00 00    	js     800a7f <dup+0xa3>
		return r;
	close(newfdnum);
  8009fe:	83 ec 0c             	sub    $0xc,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	e8 85 ff ff ff       	call   80098e <close>

	newfd = INDEX2FD(newfdnum);
  800a09:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0c:	c1 e6 0c             	shl    $0xc,%esi
  800a0f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800a15:	83 c4 04             	add    $0x4,%esp
  800a18:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a1b:	e8 d5 fd ff ff       	call   8007f5 <fd2data>
  800a20:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800a22:	89 34 24             	mov    %esi,(%esp)
  800a25:	e8 cb fd ff ff       	call   8007f5 <fd2data>
  800a2a:	83 c4 10             	add    $0x10,%esp
  800a2d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a2f:	89 d8                	mov    %ebx,%eax
  800a31:	c1 e8 16             	shr    $0x16,%eax
  800a34:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800a3b:	a8 01                	test   $0x1,%al
  800a3d:	74 11                	je     800a50 <dup+0x74>
  800a3f:	89 d8                	mov    %ebx,%eax
  800a41:	c1 e8 0c             	shr    $0xc,%eax
  800a44:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800a4b:	f6 c2 01             	test   $0x1,%dl
  800a4e:	75 39                	jne    800a89 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a53:	89 d0                	mov    %edx,%eax
  800a55:	c1 e8 0c             	shr    $0xc,%eax
  800a58:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a5f:	83 ec 0c             	sub    $0xc,%esp
  800a62:	25 07 0e 00 00       	and    $0xe07,%eax
  800a67:	50                   	push   %eax
  800a68:	56                   	push   %esi
  800a69:	6a 00                	push   $0x0
  800a6b:	52                   	push   %edx
  800a6c:	6a 00                	push   $0x0
  800a6e:	e8 00 fb ff ff       	call   800573 <sys_page_map>
  800a73:	89 c3                	mov    %eax,%ebx
  800a75:	83 c4 20             	add    $0x20,%esp
  800a78:	85 c0                	test   %eax,%eax
  800a7a:	78 31                	js     800aad <dup+0xd1>
		goto err;

	return newfdnum;
  800a7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a7f:	89 d8                	mov    %ebx,%eax
  800a81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5f                   	pop    %edi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a89:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a90:	83 ec 0c             	sub    $0xc,%esp
  800a93:	25 07 0e 00 00       	and    $0xe07,%eax
  800a98:	50                   	push   %eax
  800a99:	57                   	push   %edi
  800a9a:	6a 00                	push   $0x0
  800a9c:	53                   	push   %ebx
  800a9d:	6a 00                	push   $0x0
  800a9f:	e8 cf fa ff ff       	call   800573 <sys_page_map>
  800aa4:	89 c3                	mov    %eax,%ebx
  800aa6:	83 c4 20             	add    $0x20,%esp
  800aa9:	85 c0                	test   %eax,%eax
  800aab:	79 a3                	jns    800a50 <dup+0x74>
	sys_page_unmap(0, newfd);
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	56                   	push   %esi
  800ab1:	6a 00                	push   $0x0
  800ab3:	e8 fd fa ff ff       	call   8005b5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800ab8:	83 c4 08             	add    $0x8,%esp
  800abb:	57                   	push   %edi
  800abc:	6a 00                	push   $0x0
  800abe:	e8 f2 fa ff ff       	call   8005b5 <sys_page_unmap>
	return r;
  800ac3:	83 c4 10             	add    $0x10,%esp
  800ac6:	eb b7                	jmp    800a7f <dup+0xa3>

00800ac8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	53                   	push   %ebx
  800acc:	83 ec 14             	sub    $0x14,%esp
  800acf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ad2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ad5:	50                   	push   %eax
  800ad6:	53                   	push   %ebx
  800ad7:	e8 7f fd ff ff       	call   80085b <fd_lookup>
  800adc:	83 c4 08             	add    $0x8,%esp
  800adf:	85 c0                	test   %eax,%eax
  800ae1:	78 3f                	js     800b22 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aed:	ff 30                	pushl  (%eax)
  800aef:	e8 be fd ff ff       	call   8008b2 <dev_lookup>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	85 c0                	test   %eax,%eax
  800af9:	78 27                	js     800b22 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800afb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800afe:	8b 42 08             	mov    0x8(%edx),%eax
  800b01:	83 e0 03             	and    $0x3,%eax
  800b04:	83 f8 01             	cmp    $0x1,%eax
  800b07:	74 1e                	je     800b27 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b0c:	8b 40 08             	mov    0x8(%eax),%eax
  800b0f:	85 c0                	test   %eax,%eax
  800b11:	74 35                	je     800b48 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	ff 75 10             	pushl  0x10(%ebp)
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	52                   	push   %edx
  800b1d:	ff d0                	call   *%eax
  800b1f:	83 c4 10             	add    $0x10,%esp
}
  800b22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b27:	a1 04 40 80 00       	mov    0x804004,%eax
  800b2c:	8b 40 48             	mov    0x48(%eax),%eax
  800b2f:	83 ec 04             	sub    $0x4,%esp
  800b32:	53                   	push   %ebx
  800b33:	50                   	push   %eax
  800b34:	68 1d 20 80 00       	push   $0x80201d
  800b39:	e8 c5 0a 00 00       	call   801603 <cprintf>
		return -E_INVAL;
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b46:	eb da                	jmp    800b22 <read+0x5a>
		return -E_NOT_SUPP;
  800b48:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b4d:	eb d3                	jmp    800b22 <read+0x5a>

00800b4f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	83 ec 0c             	sub    $0xc,%esp
  800b58:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b5b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b63:	39 f3                	cmp    %esi,%ebx
  800b65:	73 25                	jae    800b8c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	89 f0                	mov    %esi,%eax
  800b6c:	29 d8                	sub    %ebx,%eax
  800b6e:	50                   	push   %eax
  800b6f:	89 d8                	mov    %ebx,%eax
  800b71:	03 45 0c             	add    0xc(%ebp),%eax
  800b74:	50                   	push   %eax
  800b75:	57                   	push   %edi
  800b76:	e8 4d ff ff ff       	call   800ac8 <read>
		if (m < 0)
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	85 c0                	test   %eax,%eax
  800b80:	78 08                	js     800b8a <readn+0x3b>
			return m;
		if (m == 0)
  800b82:	85 c0                	test   %eax,%eax
  800b84:	74 06                	je     800b8c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800b86:	01 c3                	add    %eax,%ebx
  800b88:	eb d9                	jmp    800b63 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b8a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b8c:	89 d8                	mov    %ebx,%eax
  800b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b91:	5b                   	pop    %ebx
  800b92:	5e                   	pop    %esi
  800b93:	5f                   	pop    %edi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	53                   	push   %ebx
  800b9a:	83 ec 14             	sub    $0x14,%esp
  800b9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ba0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ba3:	50                   	push   %eax
  800ba4:	53                   	push   %ebx
  800ba5:	e8 b1 fc ff ff       	call   80085b <fd_lookup>
  800baa:	83 c4 08             	add    $0x8,%esp
  800bad:	85 c0                	test   %eax,%eax
  800baf:	78 3a                	js     800beb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bb7:	50                   	push   %eax
  800bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbb:	ff 30                	pushl  (%eax)
  800bbd:	e8 f0 fc ff ff       	call   8008b2 <dev_lookup>
  800bc2:	83 c4 10             	add    $0x10,%esp
  800bc5:	85 c0                	test   %eax,%eax
  800bc7:	78 22                	js     800beb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800bd0:	74 1e                	je     800bf0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd5:	8b 52 0c             	mov    0xc(%edx),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	74 35                	je     800c11 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800bdc:	83 ec 04             	sub    $0x4,%esp
  800bdf:	ff 75 10             	pushl  0x10(%ebp)
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	50                   	push   %eax
  800be6:	ff d2                	call   *%edx
  800be8:	83 c4 10             	add    $0x10,%esp
}
  800beb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800bf0:	a1 04 40 80 00       	mov    0x804004,%eax
  800bf5:	8b 40 48             	mov    0x48(%eax),%eax
  800bf8:	83 ec 04             	sub    $0x4,%esp
  800bfb:	53                   	push   %ebx
  800bfc:	50                   	push   %eax
  800bfd:	68 39 20 80 00       	push   $0x802039
  800c02:	e8 fc 09 00 00       	call   801603 <cprintf>
		return -E_INVAL;
  800c07:	83 c4 10             	add    $0x10,%esp
  800c0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c0f:	eb da                	jmp    800beb <write+0x55>
		return -E_NOT_SUPP;
  800c11:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c16:	eb d3                	jmp    800beb <write+0x55>

00800c18 <seek>:

int
seek(int fdnum, off_t offset)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c1e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800c21:	50                   	push   %eax
  800c22:	ff 75 08             	pushl  0x8(%ebp)
  800c25:	e8 31 fc ff ff       	call   80085b <fd_lookup>
  800c2a:	83 c4 08             	add    $0x8,%esp
  800c2d:	85 c0                	test   %eax,%eax
  800c2f:	78 0e                	js     800c3f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c37:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800c3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	53                   	push   %ebx
  800c45:	83 ec 14             	sub    $0x14,%esp
  800c48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c4e:	50                   	push   %eax
  800c4f:	53                   	push   %ebx
  800c50:	e8 06 fc ff ff       	call   80085b <fd_lookup>
  800c55:	83 c4 08             	add    $0x8,%esp
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	78 37                	js     800c93 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c62:	50                   	push   %eax
  800c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c66:	ff 30                	pushl  (%eax)
  800c68:	e8 45 fc ff ff       	call   8008b2 <dev_lookup>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	85 c0                	test   %eax,%eax
  800c72:	78 1f                	js     800c93 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c77:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c7b:	74 1b                	je     800c98 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c80:	8b 52 18             	mov    0x18(%edx),%edx
  800c83:	85 d2                	test   %edx,%edx
  800c85:	74 32                	je     800cb9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff d2                	call   *%edx
  800c90:	83 c4 10             	add    $0x10,%esp
}
  800c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c98:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c9d:	8b 40 48             	mov    0x48(%eax),%eax
  800ca0:	83 ec 04             	sub    $0x4,%esp
  800ca3:	53                   	push   %ebx
  800ca4:	50                   	push   %eax
  800ca5:	68 fc 1f 80 00       	push   $0x801ffc
  800caa:	e8 54 09 00 00       	call   801603 <cprintf>
		return -E_INVAL;
  800caf:	83 c4 10             	add    $0x10,%esp
  800cb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb7:	eb da                	jmp    800c93 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800cb9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cbe:	eb d3                	jmp    800c93 <ftruncate+0x52>

00800cc0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 14             	sub    $0x14,%esp
  800cc7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	ff 75 08             	pushl  0x8(%ebp)
  800cd1:	e8 85 fb ff ff       	call   80085b <fd_lookup>
  800cd6:	83 c4 08             	add    $0x8,%esp
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	78 4b                	js     800d28 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cdd:	83 ec 08             	sub    $0x8,%esp
  800ce0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ce3:	50                   	push   %eax
  800ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce7:	ff 30                	pushl  (%eax)
  800ce9:	e8 c4 fb ff ff       	call   8008b2 <dev_lookup>
  800cee:	83 c4 10             	add    $0x10,%esp
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	78 33                	js     800d28 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800cfc:	74 2f                	je     800d2d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800cfe:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800d01:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800d08:	00 00 00 
	stat->st_type = 0;
  800d0b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800d12:	00 00 00 
	stat->st_dev = dev;
  800d15:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800d1b:	83 ec 08             	sub    $0x8,%esp
  800d1e:	53                   	push   %ebx
  800d1f:	ff 75 f0             	pushl  -0x10(%ebp)
  800d22:	ff 50 14             	call   *0x14(%eax)
  800d25:	83 c4 10             	add    $0x10,%esp
}
  800d28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    
		return -E_NOT_SUPP;
  800d2d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d32:	eb f4                	jmp    800d28 <fstat+0x68>

00800d34 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800d39:	83 ec 08             	sub    $0x8,%esp
  800d3c:	6a 00                	push   $0x0
  800d3e:	ff 75 08             	pushl  0x8(%ebp)
  800d41:	e8 34 02 00 00       	call   800f7a <open>
  800d46:	89 c3                	mov    %eax,%ebx
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	78 1b                	js     800d6a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800d4f:	83 ec 08             	sub    $0x8,%esp
  800d52:	ff 75 0c             	pushl  0xc(%ebp)
  800d55:	50                   	push   %eax
  800d56:	e8 65 ff ff ff       	call   800cc0 <fstat>
  800d5b:	89 c6                	mov    %eax,%esi
	close(fd);
  800d5d:	89 1c 24             	mov    %ebx,(%esp)
  800d60:	e8 29 fc ff ff       	call   80098e <close>
	return r;
  800d65:	83 c4 10             	add    $0x10,%esp
  800d68:	89 f3                	mov    %esi,%ebx
}
  800d6a:	89 d8                	mov    %ebx,%eax
  800d6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	89 c6                	mov    %eax,%esi
  800d7a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800d7c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800d83:	74 27                	je     800dac <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d85:	6a 07                	push   $0x7
  800d87:	68 00 50 80 00       	push   $0x805000
  800d8c:	56                   	push   %esi
  800d8d:	ff 35 00 40 80 00    	pushl  0x804000
  800d93:	e8 c9 0e 00 00       	call   801c61 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d98:	83 c4 0c             	add    $0xc,%esp
  800d9b:	6a 00                	push   $0x0
  800d9d:	53                   	push   %ebx
  800d9e:	6a 00                	push   $0x0
  800da0:	e8 33 0e 00 00       	call   801bd8 <ipc_recv>
}
  800da5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	6a 01                	push   $0x1
  800db1:	e8 07 0f 00 00       	call   801cbd <ipc_find_env>
  800db6:	a3 00 40 80 00       	mov    %eax,0x804000
  800dbb:	83 c4 10             	add    $0x10,%esp
  800dbe:	eb c5                	jmp    800d85 <fsipc+0x12>

00800dc0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  800dcc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800dd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dde:	b8 02 00 00 00       	mov    $0x2,%eax
  800de3:	e8 8b ff ff ff       	call   800d73 <fsipc>
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <devfile_flush>:
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8b 40 0c             	mov    0xc(%eax),%eax
  800df6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800dfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800e00:	b8 06 00 00 00       	mov    $0x6,%eax
  800e05:	e8 69 ff ff ff       	call   800d73 <fsipc>
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <devfile_stat>:
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 40 0c             	mov    0xc(%eax),%eax
  800e1c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800e21:	ba 00 00 00 00       	mov    $0x0,%edx
  800e26:	b8 05 00 00 00       	mov    $0x5,%eax
  800e2b:	e8 43 ff ff ff       	call   800d73 <fsipc>
  800e30:	85 c0                	test   %eax,%eax
  800e32:	78 2c                	js     800e60 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	68 00 50 80 00       	push   $0x805000
  800e3c:	53                   	push   %ebx
  800e3d:	e8 39 f3 ff ff       	call   80017b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800e42:	a1 80 50 80 00       	mov    0x805080,%eax
  800e47:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800e4d:	a1 84 50 80 00       	mov    0x805084,%eax
  800e52:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800e58:	83 c4 10             	add    $0x10,%esp
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e63:	c9                   	leave  
  800e64:	c3                   	ret    

00800e65 <devfile_write>:
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	53                   	push   %ebx
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800e6f:	89 d8                	mov    %ebx,%eax
  800e71:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800e77:	76 05                	jbe    800e7e <devfile_write+0x19>
  800e79:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 52 0c             	mov    0xc(%edx),%edx
  800e84:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800e8a:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	50                   	push   %eax
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	68 08 50 80 00       	push   $0x805008
  800e9b:	e8 4e f4 ff ff       	call   8002ee <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800ea0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea5:	b8 04 00 00 00       	mov    $0x4,%eax
  800eaa:	e8 c4 fe ff ff       	call   800d73 <fsipc>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	78 0b                	js     800ec1 <devfile_write+0x5c>
	assert(r <= n);
  800eb6:	39 c3                	cmp    %eax,%ebx
  800eb8:	72 0c                	jb     800ec6 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800eba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ebf:	7f 1e                	jg     800edf <devfile_write+0x7a>
}
  800ec1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    
	assert(r <= n);
  800ec6:	68 68 20 80 00       	push   $0x802068
  800ecb:	68 6f 20 80 00       	push   $0x80206f
  800ed0:	68 98 00 00 00       	push   $0x98
  800ed5:	68 84 20 80 00       	push   $0x802084
  800eda:	e8 11 06 00 00       	call   8014f0 <_panic>
	assert(r <= PGSIZE);
  800edf:	68 8f 20 80 00       	push   $0x80208f
  800ee4:	68 6f 20 80 00       	push   $0x80206f
  800ee9:	68 99 00 00 00       	push   $0x99
  800eee:	68 84 20 80 00       	push   $0x802084
  800ef3:	e8 f8 05 00 00       	call   8014f0 <_panic>

00800ef8 <devfile_read>:
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	56                   	push   %esi
  800efc:	53                   	push   %ebx
  800efd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8b 40 0c             	mov    0xc(%eax),%eax
  800f06:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800f0b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800f11:	ba 00 00 00 00       	mov    $0x0,%edx
  800f16:	b8 03 00 00 00       	mov    $0x3,%eax
  800f1b:	e8 53 fe ff ff       	call   800d73 <fsipc>
  800f20:	89 c3                	mov    %eax,%ebx
  800f22:	85 c0                	test   %eax,%eax
  800f24:	78 1f                	js     800f45 <devfile_read+0x4d>
	assert(r <= n);
  800f26:	39 c6                	cmp    %eax,%esi
  800f28:	72 24                	jb     800f4e <devfile_read+0x56>
	assert(r <= PGSIZE);
  800f2a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800f2f:	7f 33                	jg     800f64 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800f31:	83 ec 04             	sub    $0x4,%esp
  800f34:	50                   	push   %eax
  800f35:	68 00 50 80 00       	push   $0x805000
  800f3a:	ff 75 0c             	pushl  0xc(%ebp)
  800f3d:	e8 ac f3 ff ff       	call   8002ee <memmove>
	return r;
  800f42:	83 c4 10             	add    $0x10,%esp
}
  800f45:	89 d8                	mov    %ebx,%eax
  800f47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    
	assert(r <= n);
  800f4e:	68 68 20 80 00       	push   $0x802068
  800f53:	68 6f 20 80 00       	push   $0x80206f
  800f58:	6a 7c                	push   $0x7c
  800f5a:	68 84 20 80 00       	push   $0x802084
  800f5f:	e8 8c 05 00 00       	call   8014f0 <_panic>
	assert(r <= PGSIZE);
  800f64:	68 8f 20 80 00       	push   $0x80208f
  800f69:	68 6f 20 80 00       	push   $0x80206f
  800f6e:	6a 7d                	push   $0x7d
  800f70:	68 84 20 80 00       	push   $0x802084
  800f75:	e8 76 05 00 00       	call   8014f0 <_panic>

00800f7a <open>:
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 1c             	sub    $0x1c,%esp
  800f82:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800f85:	56                   	push   %esi
  800f86:	e8 bd f1 ff ff       	call   800148 <strlen>
  800f8b:	83 c4 10             	add    $0x10,%esp
  800f8e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f93:	7f 6c                	jg     801001 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800f95:	83 ec 0c             	sub    $0xc,%esp
  800f98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f9b:	50                   	push   %eax
  800f9c:	e8 6b f8 ff ff       	call   80080c <fd_alloc>
  800fa1:	89 c3                	mov    %eax,%ebx
  800fa3:	83 c4 10             	add    $0x10,%esp
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	78 3c                	js     800fe6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800faa:	83 ec 08             	sub    $0x8,%esp
  800fad:	56                   	push   %esi
  800fae:	68 00 50 80 00       	push   $0x805000
  800fb3:	e8 c3 f1 ff ff       	call   80017b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc3:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc8:	e8 a6 fd ff ff       	call   800d73 <fsipc>
  800fcd:	89 c3                	mov    %eax,%ebx
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	78 19                	js     800fef <open+0x75>
	return fd2num(fd);
  800fd6:	83 ec 0c             	sub    $0xc,%esp
  800fd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fdc:	e8 04 f8 ff ff       	call   8007e5 <fd2num>
  800fe1:	89 c3                	mov    %eax,%ebx
  800fe3:	83 c4 10             	add    $0x10,%esp
}
  800fe6:	89 d8                	mov    %ebx,%eax
  800fe8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800feb:	5b                   	pop    %ebx
  800fec:	5e                   	pop    %esi
  800fed:	5d                   	pop    %ebp
  800fee:	c3                   	ret    
		fd_close(fd, 0);
  800fef:	83 ec 08             	sub    $0x8,%esp
  800ff2:	6a 00                	push   $0x0
  800ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff7:	e8 0c f9 ff ff       	call   800908 <fd_close>
		return r;
  800ffc:	83 c4 10             	add    $0x10,%esp
  800fff:	eb e5                	jmp    800fe6 <open+0x6c>
		return -E_BAD_PATH;
  801001:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801006:	eb de                	jmp    800fe6 <open+0x6c>

00801008 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80100e:	ba 00 00 00 00       	mov    $0x0,%edx
  801013:	b8 08 00 00 00       	mov    $0x8,%eax
  801018:	e8 56 fd ff ff       	call   800d73 <fsipc>
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801027:	83 ec 0c             	sub    $0xc,%esp
  80102a:	ff 75 08             	pushl  0x8(%ebp)
  80102d:	e8 c3 f7 ff ff       	call   8007f5 <fd2data>
  801032:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801034:	83 c4 08             	add    $0x8,%esp
  801037:	68 9b 20 80 00       	push   $0x80209b
  80103c:	53                   	push   %ebx
  80103d:	e8 39 f1 ff ff       	call   80017b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801042:	8b 46 04             	mov    0x4(%esi),%eax
  801045:	2b 06                	sub    (%esi),%eax
  801047:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80104d:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801054:	10 00 00 
	stat->st_dev = &devpipe;
  801057:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80105e:	30 80 00 
	return 0;
}
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
  801066:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	53                   	push   %ebx
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801077:	53                   	push   %ebx
  801078:	6a 00                	push   $0x0
  80107a:	e8 36 f5 ff ff       	call   8005b5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80107f:	89 1c 24             	mov    %ebx,(%esp)
  801082:	e8 6e f7 ff ff       	call   8007f5 <fd2data>
  801087:	83 c4 08             	add    $0x8,%esp
  80108a:	50                   	push   %eax
  80108b:	6a 00                	push   $0x0
  80108d:	e8 23 f5 ff ff       	call   8005b5 <sys_page_unmap>
}
  801092:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <_pipeisclosed>:
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	57                   	push   %edi
  80109b:	56                   	push   %esi
  80109c:	53                   	push   %ebx
  80109d:	83 ec 1c             	sub    $0x1c,%esp
  8010a0:	89 c7                	mov    %eax,%edi
  8010a2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8010a4:	a1 04 40 80 00       	mov    0x804004,%eax
  8010a9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8010ac:	83 ec 0c             	sub    $0xc,%esp
  8010af:	57                   	push   %edi
  8010b0:	e8 4a 0c 00 00       	call   801cff <pageref>
  8010b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010b8:	89 34 24             	mov    %esi,(%esp)
  8010bb:	e8 3f 0c 00 00       	call   801cff <pageref>
		nn = thisenv->env_runs;
  8010c0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8010c6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	39 cb                	cmp    %ecx,%ebx
  8010ce:	74 1b                	je     8010eb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8010d0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8010d3:	75 cf                	jne    8010a4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8010d5:	8b 42 58             	mov    0x58(%edx),%eax
  8010d8:	6a 01                	push   $0x1
  8010da:	50                   	push   %eax
  8010db:	53                   	push   %ebx
  8010dc:	68 a2 20 80 00       	push   $0x8020a2
  8010e1:	e8 1d 05 00 00       	call   801603 <cprintf>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	eb b9                	jmp    8010a4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8010eb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8010ee:	0f 94 c0             	sete   %al
  8010f1:	0f b6 c0             	movzbl %al,%eax
}
  8010f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <devpipe_write>:
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	57                   	push   %edi
  801100:	56                   	push   %esi
  801101:	53                   	push   %ebx
  801102:	83 ec 18             	sub    $0x18,%esp
  801105:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801108:	56                   	push   %esi
  801109:	e8 e7 f6 ff ff       	call   8007f5 <fd2data>
  80110e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	bf 00 00 00 00       	mov    $0x0,%edi
  801118:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80111b:	74 41                	je     80115e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80111d:	8b 53 04             	mov    0x4(%ebx),%edx
  801120:	8b 03                	mov    (%ebx),%eax
  801122:	83 c0 20             	add    $0x20,%eax
  801125:	39 c2                	cmp    %eax,%edx
  801127:	72 14                	jb     80113d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801129:	89 da                	mov    %ebx,%edx
  80112b:	89 f0                	mov    %esi,%eax
  80112d:	e8 65 ff ff ff       	call   801097 <_pipeisclosed>
  801132:	85 c0                	test   %eax,%eax
  801134:	75 2c                	jne    801162 <devpipe_write+0x66>
			sys_yield();
  801136:	e8 bc f4 ff ff       	call   8005f7 <sys_yield>
  80113b:	eb e0                	jmp    80111d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801143:	89 d0                	mov    %edx,%eax
  801145:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80114a:	78 0b                	js     801157 <devpipe_write+0x5b>
  80114c:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801150:	42                   	inc    %edx
  801151:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801154:	47                   	inc    %edi
  801155:	eb c1                	jmp    801118 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801157:	48                   	dec    %eax
  801158:	83 c8 e0             	or     $0xffffffe0,%eax
  80115b:	40                   	inc    %eax
  80115c:	eb ee                	jmp    80114c <devpipe_write+0x50>
	return i;
  80115e:	89 f8                	mov    %edi,%eax
  801160:	eb 05                	jmp    801167 <devpipe_write+0x6b>
				return 0;
  801162:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801167:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5e                   	pop    %esi
  80116c:	5f                   	pop    %edi
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <devpipe_read>:
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 18             	sub    $0x18,%esp
  801178:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80117b:	57                   	push   %edi
  80117c:	e8 74 f6 ff ff       	call   8007f5 <fd2data>
  801181:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118b:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80118e:	74 46                	je     8011d6 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801190:	8b 06                	mov    (%esi),%eax
  801192:	3b 46 04             	cmp    0x4(%esi),%eax
  801195:	75 22                	jne    8011b9 <devpipe_read+0x4a>
			if (i > 0)
  801197:	85 db                	test   %ebx,%ebx
  801199:	74 0a                	je     8011a5 <devpipe_read+0x36>
				return i;
  80119b:	89 d8                	mov    %ebx,%eax
}
  80119d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a0:	5b                   	pop    %ebx
  8011a1:	5e                   	pop    %esi
  8011a2:	5f                   	pop    %edi
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  8011a5:	89 f2                	mov    %esi,%edx
  8011a7:	89 f8                	mov    %edi,%eax
  8011a9:	e8 e9 fe ff ff       	call   801097 <_pipeisclosed>
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	75 28                	jne    8011da <devpipe_read+0x6b>
			sys_yield();
  8011b2:	e8 40 f4 ff ff       	call   8005f7 <sys_yield>
  8011b7:	eb d7                	jmp    801190 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8011b9:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8011be:	78 0f                	js     8011cf <devpipe_read+0x60>
  8011c0:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8011c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c7:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8011ca:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8011cc:	43                   	inc    %ebx
  8011cd:	eb bc                	jmp    80118b <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8011cf:	48                   	dec    %eax
  8011d0:	83 c8 e0             	or     $0xffffffe0,%eax
  8011d3:	40                   	inc    %eax
  8011d4:	eb ea                	jmp    8011c0 <devpipe_read+0x51>
	return i;
  8011d6:	89 d8                	mov    %ebx,%eax
  8011d8:	eb c3                	jmp    80119d <devpipe_read+0x2e>
				return 0;
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
  8011df:	eb bc                	jmp    80119d <devpipe_read+0x2e>

008011e1 <pipe>:
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	56                   	push   %esi
  8011e5:	53                   	push   %ebx
  8011e6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8011e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ec:	50                   	push   %eax
  8011ed:	e8 1a f6 ff ff       	call   80080c <fd_alloc>
  8011f2:	89 c3                	mov    %eax,%ebx
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	0f 88 2a 01 00 00    	js     801329 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011ff:	83 ec 04             	sub    $0x4,%esp
  801202:	68 07 04 00 00       	push   $0x407
  801207:	ff 75 f4             	pushl  -0xc(%ebp)
  80120a:	6a 00                	push   $0x0
  80120c:	e8 1f f3 ff ff       	call   800530 <sys_page_alloc>
  801211:	89 c3                	mov    %eax,%ebx
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	85 c0                	test   %eax,%eax
  801218:	0f 88 0b 01 00 00    	js     801329 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  80121e:	83 ec 0c             	sub    $0xc,%esp
  801221:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	e8 e2 f5 ff ff       	call   80080c <fd_alloc>
  80122a:	89 c3                	mov    %eax,%ebx
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	0f 88 e2 00 00 00    	js     801319 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	68 07 04 00 00       	push   $0x407
  80123f:	ff 75 f0             	pushl  -0x10(%ebp)
  801242:	6a 00                	push   $0x0
  801244:	e8 e7 f2 ff ff       	call   800530 <sys_page_alloc>
  801249:	89 c3                	mov    %eax,%ebx
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	0f 88 c3 00 00 00    	js     801319 <pipe+0x138>
	va = fd2data(fd0);
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	ff 75 f4             	pushl  -0xc(%ebp)
  80125c:	e8 94 f5 ff ff       	call   8007f5 <fd2data>
  801261:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801263:	83 c4 0c             	add    $0xc,%esp
  801266:	68 07 04 00 00       	push   $0x407
  80126b:	50                   	push   %eax
  80126c:	6a 00                	push   $0x0
  80126e:	e8 bd f2 ff ff       	call   800530 <sys_page_alloc>
  801273:	89 c3                	mov    %eax,%ebx
  801275:	83 c4 10             	add    $0x10,%esp
  801278:	85 c0                	test   %eax,%eax
  80127a:	0f 88 89 00 00 00    	js     801309 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	ff 75 f0             	pushl  -0x10(%ebp)
  801286:	e8 6a f5 ff ff       	call   8007f5 <fd2data>
  80128b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801292:	50                   	push   %eax
  801293:	6a 00                	push   $0x0
  801295:	56                   	push   %esi
  801296:	6a 00                	push   $0x0
  801298:	e8 d6 f2 ff ff       	call   800573 <sys_page_map>
  80129d:	89 c3                	mov    %eax,%ebx
  80129f:	83 c4 20             	add    $0x20,%esp
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	78 55                	js     8012fb <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  8012a6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8012ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012af:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8012b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8012bb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8012c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c4:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8012c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8012d0:	83 ec 0c             	sub    $0xc,%esp
  8012d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d6:	e8 0a f5 ff ff       	call   8007e5 <fd2num>
  8012db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012de:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8012e0:	83 c4 04             	add    $0x4,%esp
  8012e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8012e6:	e8 fa f4 ff ff       	call   8007e5 <fd2num>
  8012eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ee:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f9:	eb 2e                	jmp    801329 <pipe+0x148>
	sys_page_unmap(0, va);
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	56                   	push   %esi
  8012ff:	6a 00                	push   $0x0
  801301:	e8 af f2 ff ff       	call   8005b5 <sys_page_unmap>
  801306:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801309:	83 ec 08             	sub    $0x8,%esp
  80130c:	ff 75 f0             	pushl  -0x10(%ebp)
  80130f:	6a 00                	push   $0x0
  801311:	e8 9f f2 ff ff       	call   8005b5 <sys_page_unmap>
  801316:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801319:	83 ec 08             	sub    $0x8,%esp
  80131c:	ff 75 f4             	pushl  -0xc(%ebp)
  80131f:	6a 00                	push   $0x0
  801321:	e8 8f f2 ff ff       	call   8005b5 <sys_page_unmap>
  801326:	83 c4 10             	add    $0x10,%esp
}
  801329:	89 d8                	mov    %ebx,%eax
  80132b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80132e:	5b                   	pop    %ebx
  80132f:	5e                   	pop    %esi
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    

00801332 <pipeisclosed>:
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801338:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133b:	50                   	push   %eax
  80133c:	ff 75 08             	pushl  0x8(%ebp)
  80133f:	e8 17 f5 ff ff       	call   80085b <fd_lookup>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 18                	js     801363 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	ff 75 f4             	pushl  -0xc(%ebp)
  801351:	e8 9f f4 ff ff       	call   8007f5 <fd2data>
	return _pipeisclosed(fd, p);
  801356:	89 c2                	mov    %eax,%edx
  801358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135b:	e8 37 fd ff ff       	call   801097 <_pipeisclosed>
  801360:	83 c4 10             	add    $0x10,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
  80136d:	5d                   	pop    %ebp
  80136e:	c3                   	ret    

0080136f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	53                   	push   %ebx
  801373:	83 ec 0c             	sub    $0xc,%esp
  801376:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801379:	68 ba 20 80 00       	push   $0x8020ba
  80137e:	53                   	push   %ebx
  80137f:	e8 f7 ed ff ff       	call   80017b <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801384:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  80138b:	20 00 00 
	return 0;
}
  80138e:	b8 00 00 00 00       	mov    $0x0,%eax
  801393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <devcons_write>:
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	57                   	push   %edi
  80139c:	56                   	push   %esi
  80139d:	53                   	push   %ebx
  80139e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8013a4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8013a9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8013af:	eb 1d                	jmp    8013ce <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	53                   	push   %ebx
  8013b5:	03 45 0c             	add    0xc(%ebp),%eax
  8013b8:	50                   	push   %eax
  8013b9:	57                   	push   %edi
  8013ba:	e8 2f ef ff ff       	call   8002ee <memmove>
		sys_cputs(buf, m);
  8013bf:	83 c4 08             	add    $0x8,%esp
  8013c2:	53                   	push   %ebx
  8013c3:	57                   	push   %edi
  8013c4:	e8 ca f0 ff ff       	call   800493 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013c9:	01 de                	add    %ebx,%esi
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 f0                	mov    %esi,%eax
  8013d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8013d3:	73 11                	jae    8013e6 <devcons_write+0x4e>
		m = n - tot;
  8013d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013d8:	29 f3                	sub    %esi,%ebx
  8013da:	83 fb 7f             	cmp    $0x7f,%ebx
  8013dd:	76 d2                	jbe    8013b1 <devcons_write+0x19>
  8013df:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  8013e4:	eb cb                	jmp    8013b1 <devcons_write+0x19>
}
  8013e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5f                   	pop    %edi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <devcons_read>:
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  8013f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f8:	75 0c                	jne    801406 <devcons_read+0x18>
		return 0;
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ff:	eb 21                	jmp    801422 <devcons_read+0x34>
		sys_yield();
  801401:	e8 f1 f1 ff ff       	call   8005f7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801406:	e8 a6 f0 ff ff       	call   8004b1 <sys_cgetc>
  80140b:	85 c0                	test   %eax,%eax
  80140d:	74 f2                	je     801401 <devcons_read+0x13>
	if (c < 0)
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 0f                	js     801422 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801413:	83 f8 04             	cmp    $0x4,%eax
  801416:	74 0c                	je     801424 <devcons_read+0x36>
	*(char*)vbuf = c;
  801418:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141b:	88 02                	mov    %al,(%edx)
	return 1;
  80141d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    
		return 0;
  801424:	b8 00 00 00 00       	mov    $0x0,%eax
  801429:	eb f7                	jmp    801422 <devcons_read+0x34>

0080142b <cputchar>:
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801437:	6a 01                	push   $0x1
  801439:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	e8 51 f0 ff ff       	call   800493 <sys_cputs>
}
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <getchar>:
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80144d:	6a 01                	push   $0x1
  80144f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801452:	50                   	push   %eax
  801453:	6a 00                	push   $0x0
  801455:	e8 6e f6 ff ff       	call   800ac8 <read>
	if (r < 0)
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 08                	js     801469 <getchar+0x22>
	if (r < 1)
  801461:	85 c0                	test   %eax,%eax
  801463:	7e 06                	jle    80146b <getchar+0x24>
	return c;
  801465:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    
		return -E_EOF;
  80146b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801470:	eb f7                	jmp    801469 <getchar+0x22>

00801472 <iscons>:
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801478:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	ff 75 08             	pushl  0x8(%ebp)
  80147f:	e8 d7 f3 ff ff       	call   80085b <fd_lookup>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 11                	js     80149c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801494:	39 10                	cmp    %edx,(%eax)
  801496:	0f 94 c0             	sete   %al
  801499:	0f b6 c0             	movzbl %al,%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <opencons>:
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8014a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a7:	50                   	push   %eax
  8014a8:	e8 5f f3 ff ff       	call   80080c <fd_alloc>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 3a                	js     8014ee <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8014b4:	83 ec 04             	sub    $0x4,%esp
  8014b7:	68 07 04 00 00       	push   $0x407
  8014bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8014bf:	6a 00                	push   $0x0
  8014c1:	e8 6a f0 ff ff       	call   800530 <sys_page_alloc>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	78 21                	js     8014ee <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014cd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8014d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014e2:	83 ec 0c             	sub    $0xc,%esp
  8014e5:	50                   	push   %eax
  8014e6:	e8 fa f2 ff ff       	call   8007e5 <fd2num>
  8014eb:	83 c4 10             	add    $0x10,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	57                   	push   %edi
  8014f4:	56                   	push   %esi
  8014f5:	53                   	push   %ebx
  8014f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  8014fc:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  8014ff:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801505:	e8 07 f0 ff ff       	call   800511 <sys_getenvid>
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	ff 75 0c             	pushl  0xc(%ebp)
  801510:	ff 75 08             	pushl  0x8(%ebp)
  801513:	53                   	push   %ebx
  801514:	50                   	push   %eax
  801515:	68 c8 20 80 00       	push   $0x8020c8
  80151a:	68 00 01 00 00       	push   $0x100
  80151f:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801525:	56                   	push   %esi
  801526:	e8 93 06 00 00       	call   801bbe <snprintf>
  80152b:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80152d:	83 c4 20             	add    $0x20,%esp
  801530:	57                   	push   %edi
  801531:	ff 75 10             	pushl  0x10(%ebp)
  801534:	bf 00 01 00 00       	mov    $0x100,%edi
  801539:	89 f8                	mov    %edi,%eax
  80153b:	29 d8                	sub    %ebx,%eax
  80153d:	50                   	push   %eax
  80153e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801541:	50                   	push   %eax
  801542:	e8 22 06 00 00       	call   801b69 <vsnprintf>
  801547:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801549:	83 c4 0c             	add    $0xc,%esp
  80154c:	68 b3 20 80 00       	push   $0x8020b3
  801551:	29 df                	sub    %ebx,%edi
  801553:	57                   	push   %edi
  801554:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801557:	50                   	push   %eax
  801558:	e8 61 06 00 00       	call   801bbe <snprintf>
	sys_cputs(buf, r);
  80155d:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801560:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801562:	53                   	push   %ebx
  801563:	56                   	push   %esi
  801564:	e8 2a ef ff ff       	call   800493 <sys_cputs>
  801569:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80156c:	cc                   	int3   
  80156d:	eb fd                	jmp    80156c <_panic+0x7c>

0080156f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	53                   	push   %ebx
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801579:	8b 13                	mov    (%ebx),%edx
  80157b:	8d 42 01             	lea    0x1(%edx),%eax
  80157e:	89 03                	mov    %eax,(%ebx)
  801580:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801583:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801587:	3d ff 00 00 00       	cmp    $0xff,%eax
  80158c:	74 08                	je     801596 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80158e:	ff 43 04             	incl   0x4(%ebx)
}
  801591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801594:	c9                   	leave  
  801595:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	68 ff 00 00 00       	push   $0xff
  80159e:	8d 43 08             	lea    0x8(%ebx),%eax
  8015a1:	50                   	push   %eax
  8015a2:	e8 ec ee ff ff       	call   800493 <sys_cputs>
		b->idx = 0;
  8015a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	eb dc                	jmp    80158e <putch+0x1f>

008015b2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8015bb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8015c2:	00 00 00 
	b.cnt = 0;
  8015c5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8015cc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	ff 75 08             	pushl  0x8(%ebp)
  8015d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015db:	50                   	push   %eax
  8015dc:	68 6f 15 80 00       	push   $0x80156f
  8015e1:	e8 17 01 00 00       	call   8016fd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8015e6:	83 c4 08             	add    $0x8,%esp
  8015e9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8015ef:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015f5:	50                   	push   %eax
  8015f6:	e8 98 ee ff ff       	call   800493 <sys_cputs>

	return b.cnt;
}
  8015fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801609:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80160c:	50                   	push   %eax
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	e8 9d ff ff ff       	call   8015b2 <vcprintf>
	va_end(ap);

	return cnt;
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	57                   	push   %edi
  80161b:	56                   	push   %esi
  80161c:	53                   	push   %ebx
  80161d:	83 ec 1c             	sub    $0x1c,%esp
  801620:	89 c7                	mov    %eax,%edi
  801622:	89 d6                	mov    %edx,%esi
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80162d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801630:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801633:	bb 00 00 00 00       	mov    $0x0,%ebx
  801638:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80163b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80163e:	39 d3                	cmp    %edx,%ebx
  801640:	72 05                	jb     801647 <printnum+0x30>
  801642:	39 45 10             	cmp    %eax,0x10(%ebp)
  801645:	77 78                	ja     8016bf <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801647:	83 ec 0c             	sub    $0xc,%esp
  80164a:	ff 75 18             	pushl  0x18(%ebp)
  80164d:	8b 45 14             	mov    0x14(%ebp),%eax
  801650:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801653:	53                   	push   %ebx
  801654:	ff 75 10             	pushl  0x10(%ebp)
  801657:	83 ec 08             	sub    $0x8,%esp
  80165a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80165d:	ff 75 e0             	pushl  -0x20(%ebp)
  801660:	ff 75 dc             	pushl  -0x24(%ebp)
  801663:	ff 75 d8             	pushl  -0x28(%ebp)
  801666:	e8 d9 06 00 00       	call   801d44 <__udivdi3>
  80166b:	83 c4 18             	add    $0x18,%esp
  80166e:	52                   	push   %edx
  80166f:	50                   	push   %eax
  801670:	89 f2                	mov    %esi,%edx
  801672:	89 f8                	mov    %edi,%eax
  801674:	e8 9e ff ff ff       	call   801617 <printnum>
  801679:	83 c4 20             	add    $0x20,%esp
  80167c:	eb 11                	jmp    80168f <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80167e:	83 ec 08             	sub    $0x8,%esp
  801681:	56                   	push   %esi
  801682:	ff 75 18             	pushl  0x18(%ebp)
  801685:	ff d7                	call   *%edi
  801687:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80168a:	4b                   	dec    %ebx
  80168b:	85 db                	test   %ebx,%ebx
  80168d:	7f ef                	jg     80167e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	56                   	push   %esi
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	ff 75 e4             	pushl  -0x1c(%ebp)
  801699:	ff 75 e0             	pushl  -0x20(%ebp)
  80169c:	ff 75 dc             	pushl  -0x24(%ebp)
  80169f:	ff 75 d8             	pushl  -0x28(%ebp)
  8016a2:	e8 ad 07 00 00       	call   801e54 <__umoddi3>
  8016a7:	83 c4 14             	add    $0x14,%esp
  8016aa:	0f be 80 eb 20 80 00 	movsbl 0x8020eb(%eax),%eax
  8016b1:	50                   	push   %eax
  8016b2:	ff d7                	call   *%edi
}
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5f                   	pop    %edi
  8016bd:	5d                   	pop    %ebp
  8016be:	c3                   	ret    
  8016bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c2:	eb c6                	jmp    80168a <printnum+0x73>

008016c4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8016ca:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8016cd:	8b 10                	mov    (%eax),%edx
  8016cf:	3b 50 04             	cmp    0x4(%eax),%edx
  8016d2:	73 0a                	jae    8016de <sprintputch+0x1a>
		*b->buf++ = ch;
  8016d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d7:	89 08                	mov    %ecx,(%eax)
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	88 02                	mov    %al,(%edx)
}
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <printfmt>:
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8016e6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8016e9:	50                   	push   %eax
  8016ea:	ff 75 10             	pushl  0x10(%ebp)
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	ff 75 08             	pushl  0x8(%ebp)
  8016f3:	e8 05 00 00 00       	call   8016fd <vprintfmt>
}
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <vprintfmt>:
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	57                   	push   %edi
  801701:	56                   	push   %esi
  801702:	53                   	push   %ebx
  801703:	83 ec 2c             	sub    $0x2c,%esp
  801706:	8b 75 08             	mov    0x8(%ebp),%esi
  801709:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80170c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80170f:	e9 ae 03 00 00       	jmp    801ac2 <vprintfmt+0x3c5>
  801714:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801718:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80171f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801726:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80172d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801732:	8d 47 01             	lea    0x1(%edi),%eax
  801735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801738:	8a 17                	mov    (%edi),%dl
  80173a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80173d:	3c 55                	cmp    $0x55,%al
  80173f:	0f 87 fe 03 00 00    	ja     801b43 <vprintfmt+0x446>
  801745:	0f b6 c0             	movzbl %al,%eax
  801748:	ff 24 85 20 22 80 00 	jmp    *0x802220(,%eax,4)
  80174f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801752:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801756:	eb da                	jmp    801732 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801758:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80175b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80175f:	eb d1                	jmp    801732 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801761:	0f b6 d2             	movzbl %dl,%edx
  801764:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
  80176c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80176f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801772:	01 c0                	add    %eax,%eax
  801774:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  801778:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80177b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80177e:	83 f9 09             	cmp    $0x9,%ecx
  801781:	77 52                	ja     8017d5 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  801783:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  801784:	eb e9                	jmp    80176f <vprintfmt+0x72>
			precision = va_arg(ap, int);
  801786:	8b 45 14             	mov    0x14(%ebp),%eax
  801789:	8b 00                	mov    (%eax),%eax
  80178b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80178e:	8b 45 14             	mov    0x14(%ebp),%eax
  801791:	8d 40 04             	lea    0x4(%eax),%eax
  801794:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801797:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80179a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80179e:	79 92                	jns    801732 <vprintfmt+0x35>
				width = precision, precision = -1;
  8017a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017a6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8017ad:	eb 83                	jmp    801732 <vprintfmt+0x35>
  8017af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017b3:	78 08                	js     8017bd <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8017b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8017b8:	e9 75 ff ff ff       	jmp    801732 <vprintfmt+0x35>
  8017bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017c4:	eb ef                	jmp    8017b5 <vprintfmt+0xb8>
  8017c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8017c9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8017d0:	e9 5d ff ff ff       	jmp    801732 <vprintfmt+0x35>
  8017d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8017db:	eb bd                	jmp    80179a <vprintfmt+0x9d>
			lflag++;
  8017dd:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017e1:	e9 4c ff ff ff       	jmp    801732 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8017e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e9:	8d 78 04             	lea    0x4(%eax),%edi
  8017ec:	83 ec 08             	sub    $0x8,%esp
  8017ef:	53                   	push   %ebx
  8017f0:	ff 30                	pushl  (%eax)
  8017f2:	ff d6                	call   *%esi
			break;
  8017f4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017f7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017fa:	e9 c0 02 00 00       	jmp    801abf <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8017ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801802:	8d 78 04             	lea    0x4(%eax),%edi
  801805:	8b 00                	mov    (%eax),%eax
  801807:	85 c0                	test   %eax,%eax
  801809:	78 2a                	js     801835 <vprintfmt+0x138>
  80180b:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80180d:	83 f8 0f             	cmp    $0xf,%eax
  801810:	7f 27                	jg     801839 <vprintfmt+0x13c>
  801812:	8b 04 85 80 23 80 00 	mov    0x802380(,%eax,4),%eax
  801819:	85 c0                	test   %eax,%eax
  80181b:	74 1c                	je     801839 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80181d:	50                   	push   %eax
  80181e:	68 81 20 80 00       	push   $0x802081
  801823:	53                   	push   %ebx
  801824:	56                   	push   %esi
  801825:	e8 b6 fe ff ff       	call   8016e0 <printfmt>
  80182a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80182d:	89 7d 14             	mov    %edi,0x14(%ebp)
  801830:	e9 8a 02 00 00       	jmp    801abf <vprintfmt+0x3c2>
  801835:	f7 d8                	neg    %eax
  801837:	eb d2                	jmp    80180b <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801839:	52                   	push   %edx
  80183a:	68 03 21 80 00       	push   $0x802103
  80183f:	53                   	push   %ebx
  801840:	56                   	push   %esi
  801841:	e8 9a fe ff ff       	call   8016e0 <printfmt>
  801846:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801849:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80184c:	e9 6e 02 00 00       	jmp    801abf <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  801851:	8b 45 14             	mov    0x14(%ebp),%eax
  801854:	83 c0 04             	add    $0x4,%eax
  801857:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80185a:	8b 45 14             	mov    0x14(%ebp),%eax
  80185d:	8b 38                	mov    (%eax),%edi
  80185f:	85 ff                	test   %edi,%edi
  801861:	74 39                	je     80189c <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  801863:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801867:	0f 8e a9 00 00 00    	jle    801916 <vprintfmt+0x219>
  80186d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801871:	0f 84 a7 00 00 00    	je     80191e <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  801877:	83 ec 08             	sub    $0x8,%esp
  80187a:	ff 75 d0             	pushl  -0x30(%ebp)
  80187d:	57                   	push   %edi
  80187e:	e8 db e8 ff ff       	call   80015e <strnlen>
  801883:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801886:	29 c1                	sub    %eax,%ecx
  801888:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80188b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80188e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801892:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801895:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801898:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80189a:	eb 14                	jmp    8018b0 <vprintfmt+0x1b3>
				p = "(null)";
  80189c:	bf fc 20 80 00       	mov    $0x8020fc,%edi
  8018a1:	eb c0                	jmp    801863 <vprintfmt+0x166>
					putch(padc, putdat);
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	53                   	push   %ebx
  8018a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8018aa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ac:	4f                   	dec    %edi
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	85 ff                	test   %edi,%edi
  8018b2:	7f ef                	jg     8018a3 <vprintfmt+0x1a6>
  8018b4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8018b7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8018ba:	89 c8                	mov    %ecx,%eax
  8018bc:	85 c9                	test   %ecx,%ecx
  8018be:	78 10                	js     8018d0 <vprintfmt+0x1d3>
  8018c0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8018c3:	29 c1                	sub    %eax,%ecx
  8018c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8018c8:	89 75 08             	mov    %esi,0x8(%ebp)
  8018cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8018ce:	eb 15                	jmp    8018e5 <vprintfmt+0x1e8>
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d5:	eb e9                	jmp    8018c0 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	53                   	push   %ebx
  8018db:	52                   	push   %edx
  8018dc:	ff 55 08             	call   *0x8(%ebp)
  8018df:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018e2:	ff 4d e0             	decl   -0x20(%ebp)
  8018e5:	47                   	inc    %edi
  8018e6:	8a 47 ff             	mov    -0x1(%edi),%al
  8018e9:	0f be d0             	movsbl %al,%edx
  8018ec:	85 d2                	test   %edx,%edx
  8018ee:	74 59                	je     801949 <vprintfmt+0x24c>
  8018f0:	85 f6                	test   %esi,%esi
  8018f2:	78 03                	js     8018f7 <vprintfmt+0x1fa>
  8018f4:	4e                   	dec    %esi
  8018f5:	78 2f                	js     801926 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8018f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018fb:	74 da                	je     8018d7 <vprintfmt+0x1da>
  8018fd:	0f be c0             	movsbl %al,%eax
  801900:	83 e8 20             	sub    $0x20,%eax
  801903:	83 f8 5e             	cmp    $0x5e,%eax
  801906:	76 cf                	jbe    8018d7 <vprintfmt+0x1da>
					putch('?', putdat);
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	53                   	push   %ebx
  80190c:	6a 3f                	push   $0x3f
  80190e:	ff 55 08             	call   *0x8(%ebp)
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	eb cc                	jmp    8018e2 <vprintfmt+0x1e5>
  801916:	89 75 08             	mov    %esi,0x8(%ebp)
  801919:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80191c:	eb c7                	jmp    8018e5 <vprintfmt+0x1e8>
  80191e:	89 75 08             	mov    %esi,0x8(%ebp)
  801921:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801924:	eb bf                	jmp    8018e5 <vprintfmt+0x1e8>
  801926:	8b 75 08             	mov    0x8(%ebp),%esi
  801929:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80192c:	eb 0c                	jmp    80193a <vprintfmt+0x23d>
				putch(' ', putdat);
  80192e:	83 ec 08             	sub    $0x8,%esp
  801931:	53                   	push   %ebx
  801932:	6a 20                	push   $0x20
  801934:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801936:	4f                   	dec    %edi
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	85 ff                	test   %edi,%edi
  80193c:	7f f0                	jg     80192e <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80193e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801941:	89 45 14             	mov    %eax,0x14(%ebp)
  801944:	e9 76 01 00 00       	jmp    801abf <vprintfmt+0x3c2>
  801949:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80194c:	8b 75 08             	mov    0x8(%ebp),%esi
  80194f:	eb e9                	jmp    80193a <vprintfmt+0x23d>
	if (lflag >= 2)
  801951:	83 f9 01             	cmp    $0x1,%ecx
  801954:	7f 1f                	jg     801975 <vprintfmt+0x278>
	else if (lflag)
  801956:	85 c9                	test   %ecx,%ecx
  801958:	75 48                	jne    8019a2 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80195a:	8b 45 14             	mov    0x14(%ebp),%eax
  80195d:	8b 00                	mov    (%eax),%eax
  80195f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801962:	89 c1                	mov    %eax,%ecx
  801964:	c1 f9 1f             	sar    $0x1f,%ecx
  801967:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	8d 40 04             	lea    0x4(%eax),%eax
  801970:	89 45 14             	mov    %eax,0x14(%ebp)
  801973:	eb 17                	jmp    80198c <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	8b 50 04             	mov    0x4(%eax),%edx
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801980:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801983:	8b 45 14             	mov    0x14(%ebp),%eax
  801986:	8d 40 08             	lea    0x8(%eax),%eax
  801989:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80198c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80198f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  801992:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801996:	78 25                	js     8019bd <vprintfmt+0x2c0>
			base = 10;
  801998:	b8 0a 00 00 00       	mov    $0xa,%eax
  80199d:	e9 03 01 00 00       	jmp    801aa5 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8019a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a5:	8b 00                	mov    (%eax),%eax
  8019a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019aa:	89 c1                	mov    %eax,%ecx
  8019ac:	c1 f9 1f             	sar    $0x1f,%ecx
  8019af:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8019b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b5:	8d 40 04             	lea    0x4(%eax),%eax
  8019b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8019bb:	eb cf                	jmp    80198c <vprintfmt+0x28f>
				putch('-', putdat);
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	53                   	push   %ebx
  8019c1:	6a 2d                	push   $0x2d
  8019c3:	ff d6                	call   *%esi
				num = -(long long) num;
  8019c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019cb:	f7 da                	neg    %edx
  8019cd:	83 d1 00             	adc    $0x0,%ecx
  8019d0:	f7 d9                	neg    %ecx
  8019d2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8019d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019da:	e9 c6 00 00 00       	jmp    801aa5 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8019df:	83 f9 01             	cmp    $0x1,%ecx
  8019e2:	7f 1e                	jg     801a02 <vprintfmt+0x305>
	else if (lflag)
  8019e4:	85 c9                	test   %ecx,%ecx
  8019e6:	75 32                	jne    801a1a <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8019e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019eb:	8b 10                	mov    (%eax),%edx
  8019ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f2:	8d 40 04             	lea    0x4(%eax),%eax
  8019f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019fd:	e9 a3 00 00 00       	jmp    801aa5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801a02:	8b 45 14             	mov    0x14(%ebp),%eax
  801a05:	8b 10                	mov    (%eax),%edx
  801a07:	8b 48 04             	mov    0x4(%eax),%ecx
  801a0a:	8d 40 08             	lea    0x8(%eax),%eax
  801a0d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a10:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a15:	e9 8b 00 00 00       	jmp    801aa5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1d:	8b 10                	mov    (%eax),%edx
  801a1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a24:	8d 40 04             	lea    0x4(%eax),%eax
  801a27:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a2f:	eb 74                	jmp    801aa5 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801a31:	83 f9 01             	cmp    $0x1,%ecx
  801a34:	7f 1b                	jg     801a51 <vprintfmt+0x354>
	else if (lflag)
  801a36:	85 c9                	test   %ecx,%ecx
  801a38:	75 2c                	jne    801a66 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3d:	8b 10                	mov    (%eax),%edx
  801a3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a44:	8d 40 04             	lea    0x4(%eax),%eax
  801a47:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a4a:	b8 08 00 00 00       	mov    $0x8,%eax
  801a4f:	eb 54                	jmp    801aa5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801a51:	8b 45 14             	mov    0x14(%ebp),%eax
  801a54:	8b 10                	mov    (%eax),%edx
  801a56:	8b 48 04             	mov    0x4(%eax),%ecx
  801a59:	8d 40 08             	lea    0x8(%eax),%eax
  801a5c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a5f:	b8 08 00 00 00       	mov    $0x8,%eax
  801a64:	eb 3f                	jmp    801aa5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801a66:	8b 45 14             	mov    0x14(%ebp),%eax
  801a69:	8b 10                	mov    (%eax),%edx
  801a6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a70:	8d 40 04             	lea    0x4(%eax),%eax
  801a73:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a76:	b8 08 00 00 00       	mov    $0x8,%eax
  801a7b:	eb 28                	jmp    801aa5 <vprintfmt+0x3a8>
			putch('0', putdat);
  801a7d:	83 ec 08             	sub    $0x8,%esp
  801a80:	53                   	push   %ebx
  801a81:	6a 30                	push   $0x30
  801a83:	ff d6                	call   *%esi
			putch('x', putdat);
  801a85:	83 c4 08             	add    $0x8,%esp
  801a88:	53                   	push   %ebx
  801a89:	6a 78                	push   $0x78
  801a8b:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a90:	8b 10                	mov    (%eax),%edx
  801a92:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a97:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a9a:	8d 40 04             	lea    0x4(%eax),%eax
  801a9d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aa0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801aa5:	83 ec 0c             	sub    $0xc,%esp
  801aa8:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801aac:	57                   	push   %edi
  801aad:	ff 75 e0             	pushl  -0x20(%ebp)
  801ab0:	50                   	push   %eax
  801ab1:	51                   	push   %ecx
  801ab2:	52                   	push   %edx
  801ab3:	89 da                	mov    %ebx,%edx
  801ab5:	89 f0                	mov    %esi,%eax
  801ab7:	e8 5b fb ff ff       	call   801617 <printnum>
			break;
  801abc:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801abf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ac2:	47                   	inc    %edi
  801ac3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ac7:	83 f8 25             	cmp    $0x25,%eax
  801aca:	0f 84 44 fc ff ff    	je     801714 <vprintfmt+0x17>
			if (ch == '\0')
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	0f 84 89 00 00 00    	je     801b61 <vprintfmt+0x464>
			putch(ch, putdat);
  801ad8:	83 ec 08             	sub    $0x8,%esp
  801adb:	53                   	push   %ebx
  801adc:	50                   	push   %eax
  801add:	ff d6                	call   *%esi
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	eb de                	jmp    801ac2 <vprintfmt+0x3c5>
	if (lflag >= 2)
  801ae4:	83 f9 01             	cmp    $0x1,%ecx
  801ae7:	7f 1b                	jg     801b04 <vprintfmt+0x407>
	else if (lflag)
  801ae9:	85 c9                	test   %ecx,%ecx
  801aeb:	75 2c                	jne    801b19 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  801aed:	8b 45 14             	mov    0x14(%ebp),%eax
  801af0:	8b 10                	mov    (%eax),%edx
  801af2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af7:	8d 40 04             	lea    0x4(%eax),%eax
  801afa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801afd:	b8 10 00 00 00       	mov    $0x10,%eax
  801b02:	eb a1                	jmp    801aa5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801b04:	8b 45 14             	mov    0x14(%ebp),%eax
  801b07:	8b 10                	mov    (%eax),%edx
  801b09:	8b 48 04             	mov    0x4(%eax),%ecx
  801b0c:	8d 40 08             	lea    0x8(%eax),%eax
  801b0f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b12:	b8 10 00 00 00       	mov    $0x10,%eax
  801b17:	eb 8c                	jmp    801aa5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801b19:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1c:	8b 10                	mov    (%eax),%edx
  801b1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b23:	8d 40 04             	lea    0x4(%eax),%eax
  801b26:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b29:	b8 10 00 00 00       	mov    $0x10,%eax
  801b2e:	e9 72 ff ff ff       	jmp    801aa5 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801b33:	83 ec 08             	sub    $0x8,%esp
  801b36:	53                   	push   %ebx
  801b37:	6a 25                	push   $0x25
  801b39:	ff d6                	call   *%esi
			break;
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	e9 7c ff ff ff       	jmp    801abf <vprintfmt+0x3c2>
			putch('%', putdat);
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	53                   	push   %ebx
  801b47:	6a 25                	push   $0x25
  801b49:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	89 f8                	mov    %edi,%eax
  801b50:	eb 01                	jmp    801b53 <vprintfmt+0x456>
  801b52:	48                   	dec    %eax
  801b53:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b57:	75 f9                	jne    801b52 <vprintfmt+0x455>
  801b59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b5c:	e9 5e ff ff ff       	jmp    801abf <vprintfmt+0x3c2>
}
  801b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5f                   	pop    %edi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    

00801b69 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 18             	sub    $0x18,%esp
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b78:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b7c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b86:	85 c0                	test   %eax,%eax
  801b88:	74 26                	je     801bb0 <vsnprintf+0x47>
  801b8a:	85 d2                	test   %edx,%edx
  801b8c:	7e 29                	jle    801bb7 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b8e:	ff 75 14             	pushl  0x14(%ebp)
  801b91:	ff 75 10             	pushl  0x10(%ebp)
  801b94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b97:	50                   	push   %eax
  801b98:	68 c4 16 80 00       	push   $0x8016c4
  801b9d:	e8 5b fb ff ff       	call   8016fd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bab:	83 c4 10             	add    $0x10,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    
		return -E_INVAL;
  801bb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bb5:	eb f7                	jmp    801bae <vsnprintf+0x45>
  801bb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bbc:	eb f0                	jmp    801bae <vsnprintf+0x45>

00801bbe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bc4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bc7:	50                   	push   %eax
  801bc8:	ff 75 10             	pushl  0x10(%ebp)
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	e8 93 ff ff ff       	call   801b69 <vsnprintf>
	va_end(ap);

	return rc;
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	57                   	push   %edi
  801bdc:	56                   	push   %esi
  801bdd:	53                   	push   %ebx
  801bde:	83 ec 0c             	sub    $0xc,%esp
  801be1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801be4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801be7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801bea:	85 ff                	test   %edi,%edi
  801bec:	74 53                	je     801c41 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801bee:	83 ec 0c             	sub    $0xc,%esp
  801bf1:	57                   	push   %edi
  801bf2:	e8 49 eb ff ff       	call   800740 <sys_ipc_recv>
  801bf7:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801bfa:	85 db                	test   %ebx,%ebx
  801bfc:	74 0b                	je     801c09 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801bfe:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c04:	8b 52 74             	mov    0x74(%edx),%edx
  801c07:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801c09:	85 f6                	test   %esi,%esi
  801c0b:	74 0f                	je     801c1c <ipc_recv+0x44>
  801c0d:	85 ff                	test   %edi,%edi
  801c0f:	74 0b                	je     801c1c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801c11:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c17:	8b 52 78             	mov    0x78(%edx),%edx
  801c1a:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	74 30                	je     801c50 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801c20:	85 db                	test   %ebx,%ebx
  801c22:	74 06                	je     801c2a <ipc_recv+0x52>
      		*from_env_store = 0;
  801c24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801c2a:	85 f6                	test   %esi,%esi
  801c2c:	74 2c                	je     801c5a <ipc_recv+0x82>
      		*perm_store = 0;
  801c2e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801c34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5f                   	pop    %edi
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801c41:	83 ec 0c             	sub    $0xc,%esp
  801c44:	6a ff                	push   $0xffffffff
  801c46:	e8 f5 ea ff ff       	call   800740 <sys_ipc_recv>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	eb aa                	jmp    801bfa <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801c50:	a1 04 40 80 00       	mov    0x804004,%eax
  801c55:	8b 40 70             	mov    0x70(%eax),%eax
  801c58:	eb df                	jmp    801c39 <ipc_recv+0x61>
		return -1;
  801c5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c5f:	eb d8                	jmp    801c39 <ipc_recv+0x61>

00801c61 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	57                   	push   %edi
  801c65:	56                   	push   %esi
  801c66:	53                   	push   %ebx
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c70:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801c73:	85 db                	test   %ebx,%ebx
  801c75:	75 22                	jne    801c99 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801c77:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801c7c:	eb 1b                	jmp    801c99 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c7e:	68 e0 23 80 00       	push   $0x8023e0
  801c83:	68 6f 20 80 00       	push   $0x80206f
  801c88:	6a 48                	push   $0x48
  801c8a:	68 04 24 80 00       	push   $0x802404
  801c8f:	e8 5c f8 ff ff       	call   8014f0 <_panic>
		sys_yield();
  801c94:	e8 5e e9 ff ff       	call   8005f7 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c99:	57                   	push   %edi
  801c9a:	53                   	push   %ebx
  801c9b:	56                   	push   %esi
  801c9c:	ff 75 08             	pushl  0x8(%ebp)
  801c9f:	e8 79 ea ff ff       	call   80071d <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801ca4:	83 c4 10             	add    $0x10,%esp
  801ca7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801caa:	74 e8                	je     801c94 <ipc_send+0x33>
  801cac:	85 c0                	test   %eax,%eax
  801cae:	75 ce                	jne    801c7e <ipc_send+0x1d>
		sys_yield();
  801cb0:	e8 42 e9 ff ff       	call   8005f7 <sys_yield>
		
	}
	
}
  801cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb8:	5b                   	pop    %ebx
  801cb9:	5e                   	pop    %esi
  801cba:	5f                   	pop    %edi
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    

00801cbd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cc8:	89 c2                	mov    %eax,%edx
  801cca:	c1 e2 05             	shl    $0x5,%edx
  801ccd:	29 c2                	sub    %eax,%edx
  801ccf:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801cd6:	8b 52 50             	mov    0x50(%edx),%edx
  801cd9:	39 ca                	cmp    %ecx,%edx
  801cdb:	74 0f                	je     801cec <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801cdd:	40                   	inc    %eax
  801cde:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ce3:	75 e3                	jne    801cc8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	eb 11                	jmp    801cfd <ipc_find_env+0x40>
			return envs[i].env_id;
  801cec:	89 c2                	mov    %eax,%edx
  801cee:	c1 e2 05             	shl    $0x5,%edx
  801cf1:	29 c2                	sub    %eax,%edx
  801cf3:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801cfa:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    

00801cff <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	c1 e8 16             	shr    $0x16,%eax
  801d08:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d0f:	a8 01                	test   $0x1,%al
  801d11:	74 21                	je     801d34 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	c1 e8 0c             	shr    $0xc,%eax
  801d19:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d20:	a8 01                	test   $0x1,%al
  801d22:	74 17                	je     801d3b <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d24:	c1 e8 0c             	shr    $0xc,%eax
  801d27:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801d2e:	ef 
  801d2f:	0f b7 c0             	movzwl %ax,%eax
  801d32:	eb 05                	jmp    801d39 <pageref+0x3a>
		return 0;
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    
		return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d40:	eb f7                	jmp    801d39 <pageref+0x3a>
  801d42:	66 90                	xchg   %ax,%ax

00801d44 <__udivdi3>:
  801d44:	55                   	push   %ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 1c             	sub    $0x1c,%esp
  801d4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d57:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d5b:	89 ca                	mov    %ecx,%edx
  801d5d:	89 f8                	mov    %edi,%eax
  801d5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d63:	85 f6                	test   %esi,%esi
  801d65:	75 2d                	jne    801d94 <__udivdi3+0x50>
  801d67:	39 cf                	cmp    %ecx,%edi
  801d69:	77 65                	ja     801dd0 <__udivdi3+0x8c>
  801d6b:	89 fd                	mov    %edi,%ebp
  801d6d:	85 ff                	test   %edi,%edi
  801d6f:	75 0b                	jne    801d7c <__udivdi3+0x38>
  801d71:	b8 01 00 00 00       	mov    $0x1,%eax
  801d76:	31 d2                	xor    %edx,%edx
  801d78:	f7 f7                	div    %edi
  801d7a:	89 c5                	mov    %eax,%ebp
  801d7c:	31 d2                	xor    %edx,%edx
  801d7e:	89 c8                	mov    %ecx,%eax
  801d80:	f7 f5                	div    %ebp
  801d82:	89 c1                	mov    %eax,%ecx
  801d84:	89 d8                	mov    %ebx,%eax
  801d86:	f7 f5                	div    %ebp
  801d88:	89 cf                	mov    %ecx,%edi
  801d8a:	89 fa                	mov    %edi,%edx
  801d8c:	83 c4 1c             	add    $0x1c,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    
  801d94:	39 ce                	cmp    %ecx,%esi
  801d96:	77 28                	ja     801dc0 <__udivdi3+0x7c>
  801d98:	0f bd fe             	bsr    %esi,%edi
  801d9b:	83 f7 1f             	xor    $0x1f,%edi
  801d9e:	75 40                	jne    801de0 <__udivdi3+0x9c>
  801da0:	39 ce                	cmp    %ecx,%esi
  801da2:	72 0a                	jb     801dae <__udivdi3+0x6a>
  801da4:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801da8:	0f 87 9e 00 00 00    	ja     801e4c <__udivdi3+0x108>
  801dae:	b8 01 00 00 00       	mov    $0x1,%eax
  801db3:	89 fa                	mov    %edi,%edx
  801db5:	83 c4 1c             	add    $0x1c,%esp
  801db8:	5b                   	pop    %ebx
  801db9:	5e                   	pop    %esi
  801dba:	5f                   	pop    %edi
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    
  801dbd:	8d 76 00             	lea    0x0(%esi),%esi
  801dc0:	31 ff                	xor    %edi,%edi
  801dc2:	31 c0                	xor    %eax,%eax
  801dc4:	89 fa                	mov    %edi,%edx
  801dc6:	83 c4 1c             	add    $0x1c,%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5f                   	pop    %edi
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	89 d8                	mov    %ebx,%eax
  801dd2:	f7 f7                	div    %edi
  801dd4:	31 ff                	xor    %edi,%edi
  801dd6:	89 fa                	mov    %edi,%edx
  801dd8:	83 c4 1c             	add    $0x1c,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
  801de0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801de5:	29 fd                	sub    %edi,%ebp
  801de7:	89 f9                	mov    %edi,%ecx
  801de9:	d3 e6                	shl    %cl,%esi
  801deb:	89 c3                	mov    %eax,%ebx
  801ded:	89 e9                	mov    %ebp,%ecx
  801def:	d3 eb                	shr    %cl,%ebx
  801df1:	89 d9                	mov    %ebx,%ecx
  801df3:	09 f1                	or     %esi,%ecx
  801df5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801df9:	89 f9                	mov    %edi,%ecx
  801dfb:	d3 e0                	shl    %cl,%eax
  801dfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e01:	89 d6                	mov    %edx,%esi
  801e03:	89 e9                	mov    %ebp,%ecx
  801e05:	d3 ee                	shr    %cl,%esi
  801e07:	89 f9                	mov    %edi,%ecx
  801e09:	d3 e2                	shl    %cl,%edx
  801e0b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e0f:	89 e9                	mov    %ebp,%ecx
  801e11:	d3 eb                	shr    %cl,%ebx
  801e13:	09 da                	or     %ebx,%edx
  801e15:	89 d0                	mov    %edx,%eax
  801e17:	89 f2                	mov    %esi,%edx
  801e19:	f7 74 24 08          	divl   0x8(%esp)
  801e1d:	89 d6                	mov    %edx,%esi
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	f7 64 24 0c          	mull   0xc(%esp)
  801e25:	39 d6                	cmp    %edx,%esi
  801e27:	72 17                	jb     801e40 <__udivdi3+0xfc>
  801e29:	74 09                	je     801e34 <__udivdi3+0xf0>
  801e2b:	89 d8                	mov    %ebx,%eax
  801e2d:	31 ff                	xor    %edi,%edi
  801e2f:	e9 56 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e34:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e38:	89 f9                	mov    %edi,%ecx
  801e3a:	d3 e2                	shl    %cl,%edx
  801e3c:	39 c2                	cmp    %eax,%edx
  801e3e:	73 eb                	jae    801e2b <__udivdi3+0xe7>
  801e40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e43:	31 ff                	xor    %edi,%edi
  801e45:	e9 40 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	31 c0                	xor    %eax,%eax
  801e4e:	e9 37 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e53:	90                   	nop

00801e54 <__umoddi3>:
  801e54:	55                   	push   %ebp
  801e55:	57                   	push   %edi
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	83 ec 1c             	sub    $0x1c,%esp
  801e5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e73:	89 3c 24             	mov    %edi,(%esp)
  801e76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e7a:	89 f2                	mov    %esi,%edx
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	75 18                	jne    801e98 <__umoddi3+0x44>
  801e80:	39 f7                	cmp    %esi,%edi
  801e82:	0f 86 a0 00 00 00    	jbe    801f28 <__umoddi3+0xd4>
  801e88:	89 c8                	mov    %ecx,%eax
  801e8a:	f7 f7                	div    %edi
  801e8c:	89 d0                	mov    %edx,%eax
  801e8e:	31 d2                	xor    %edx,%edx
  801e90:	83 c4 1c             	add    $0x1c,%esp
  801e93:	5b                   	pop    %ebx
  801e94:	5e                   	pop    %esi
  801e95:	5f                   	pop    %edi
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    
  801e98:	89 f3                	mov    %esi,%ebx
  801e9a:	39 f0                	cmp    %esi,%eax
  801e9c:	0f 87 a6 00 00 00    	ja     801f48 <__umoddi3+0xf4>
  801ea2:	0f bd e8             	bsr    %eax,%ebp
  801ea5:	83 f5 1f             	xor    $0x1f,%ebp
  801ea8:	0f 84 a6 00 00 00    	je     801f54 <__umoddi3+0x100>
  801eae:	bf 20 00 00 00       	mov    $0x20,%edi
  801eb3:	29 ef                	sub    %ebp,%edi
  801eb5:	89 e9                	mov    %ebp,%ecx
  801eb7:	d3 e0                	shl    %cl,%eax
  801eb9:	8b 34 24             	mov    (%esp),%esi
  801ebc:	89 f2                	mov    %esi,%edx
  801ebe:	89 f9                	mov    %edi,%ecx
  801ec0:	d3 ea                	shr    %cl,%edx
  801ec2:	09 c2                	or     %eax,%edx
  801ec4:	89 14 24             	mov    %edx,(%esp)
  801ec7:	89 f2                	mov    %esi,%edx
  801ec9:	89 e9                	mov    %ebp,%ecx
  801ecb:	d3 e2                	shl    %cl,%edx
  801ecd:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ed1:	89 de                	mov    %ebx,%esi
  801ed3:	89 f9                	mov    %edi,%ecx
  801ed5:	d3 ee                	shr    %cl,%esi
  801ed7:	89 e9                	mov    %ebp,%ecx
  801ed9:	d3 e3                	shl    %cl,%ebx
  801edb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801edf:	89 d0                	mov    %edx,%eax
  801ee1:	89 f9                	mov    %edi,%ecx
  801ee3:	d3 e8                	shr    %cl,%eax
  801ee5:	09 d8                	or     %ebx,%eax
  801ee7:	89 d3                	mov    %edx,%ebx
  801ee9:	89 e9                	mov    %ebp,%ecx
  801eeb:	d3 e3                	shl    %cl,%ebx
  801eed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef1:	89 f2                	mov    %esi,%edx
  801ef3:	f7 34 24             	divl   (%esp)
  801ef6:	89 d6                	mov    %edx,%esi
  801ef8:	f7 64 24 04          	mull   0x4(%esp)
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	89 d1                	mov    %edx,%ecx
  801f00:	39 d6                	cmp    %edx,%esi
  801f02:	72 7c                	jb     801f80 <__umoddi3+0x12c>
  801f04:	74 72                	je     801f78 <__umoddi3+0x124>
  801f06:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f0a:	29 da                	sub    %ebx,%edx
  801f0c:	19 ce                	sbb    %ecx,%esi
  801f0e:	89 f0                	mov    %esi,%eax
  801f10:	89 f9                	mov    %edi,%ecx
  801f12:	d3 e0                	shl    %cl,%eax
  801f14:	89 e9                	mov    %ebp,%ecx
  801f16:	d3 ea                	shr    %cl,%edx
  801f18:	09 d0                	or     %edx,%eax
  801f1a:	89 e9                	mov    %ebp,%ecx
  801f1c:	d3 ee                	shr    %cl,%esi
  801f1e:	89 f2                	mov    %esi,%edx
  801f20:	83 c4 1c             	add    $0x1c,%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5f                   	pop    %edi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    
  801f28:	89 fd                	mov    %edi,%ebp
  801f2a:	85 ff                	test   %edi,%edi
  801f2c:	75 0b                	jne    801f39 <__umoddi3+0xe5>
  801f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f33:	31 d2                	xor    %edx,%edx
  801f35:	f7 f7                	div    %edi
  801f37:	89 c5                	mov    %eax,%ebp
  801f39:	89 f0                	mov    %esi,%eax
  801f3b:	31 d2                	xor    %edx,%edx
  801f3d:	f7 f5                	div    %ebp
  801f3f:	89 c8                	mov    %ecx,%eax
  801f41:	f7 f5                	div    %ebp
  801f43:	e9 44 ff ff ff       	jmp    801e8c <__umoddi3+0x38>
  801f48:	89 c8                	mov    %ecx,%eax
  801f4a:	89 f2                	mov    %esi,%edx
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    
  801f54:	39 f0                	cmp    %esi,%eax
  801f56:	72 05                	jb     801f5d <__umoddi3+0x109>
  801f58:	39 0c 24             	cmp    %ecx,(%esp)
  801f5b:	77 0c                	ja     801f69 <__umoddi3+0x115>
  801f5d:	89 f2                	mov    %esi,%edx
  801f5f:	29 f9                	sub    %edi,%ecx
  801f61:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f65:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f69:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f6d:	83 c4 1c             	add    $0x1c,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5f                   	pop    %edi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
  801f75:	8d 76 00             	lea    0x0(%esi),%esi
  801f78:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f7c:	73 88                	jae    801f06 <__umoddi3+0xb2>
  801f7e:	66 90                	xchg   %ax,%ax
  801f80:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f84:	1b 14 24             	sbb    (%esp),%edx
  801f87:	89 d1                	mov    %edx,%ecx
  801f89:	89 c3                	mov    %eax,%ebx
  801f8b:	e9 76 ff ff ff       	jmp    801f06 <__umoddi3+0xb2>
