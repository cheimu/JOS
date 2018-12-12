
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 6b 00 00 00       	call   8000ad <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800052:	e8 d4 00 00 00       	call   80012b <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	89 c2                	mov    %eax,%edx
  80005e:	c1 e2 05             	shl    $0x5,%edx
  800061:	29 c2                	sub    %eax,%edx
  800063:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80006a:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006f:	85 db                	test   %ebx,%ebx
  800071:	7e 07                	jle    80007a <libmain+0x33>
		binaryname = argv[0];
  800073:	8b 06                	mov    (%esi),%eax
  800075:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007a:	83 ec 08             	sub    $0x8,%esp
  80007d:	56                   	push   %esi
  80007e:	53                   	push   %ebx
  80007f:	e8 af ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800084:	e8 0a 00 00 00       	call   800093 <exit>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    

00800093 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800099:	e8 35 05 00 00       	call   8005d3 <close_all>
	sys_env_destroy(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 42 00 00 00       	call   8000ea <sys_env_destroy>
}
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	c9                   	leave  
  8000ac:	c3                   	ret    

008000ad <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ad:	55                   	push   %ebp
  8000ae:	89 e5                	mov    %esp,%ebp
  8000b0:	57                   	push   %edi
  8000b1:	56                   	push   %esi
  8000b2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8000be:	89 c3                	mov    %eax,%ebx
  8000c0:	89 c7                	mov    %eax,%edi
  8000c2:	89 c6                	mov    %eax,%esi
  8000c4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c6:	5b                   	pop    %ebx
  8000c7:	5e                   	pop    %esi
  8000c8:	5f                   	pop    %edi
  8000c9:	5d                   	pop    %ebp
  8000ca:	c3                   	ret    

008000cb <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	57                   	push   %edi
  8000cf:	56                   	push   %esi
  8000d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000db:	89 d1                	mov    %edx,%ecx
  8000dd:	89 d3                	mov    %edx,%ebx
  8000df:	89 d7                	mov    %edx,%edi
  8000e1:	89 d6                	mov    %edx,%esi
  8000e3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e5:	5b                   	pop    %ebx
  8000e6:	5e                   	pop    %esi
  8000e7:	5f                   	pop    %edi
  8000e8:	5d                   	pop    %ebp
  8000e9:	c3                   	ret    

008000ea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800100:	89 cb                	mov    %ecx,%ebx
  800102:	89 cf                	mov    %ecx,%edi
  800104:	89 ce                	mov    %ecx,%esi
  800106:	cd 30                	int    $0x30
	if(check && ret > 0)
  800108:	85 c0                	test   %eax,%eax
  80010a:	7f 08                	jg     800114 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5f                   	pop    %edi
  800112:	5d                   	pop    %ebp
  800113:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	50                   	push   %eax
  800118:	6a 03                	push   $0x3
  80011a:	68 0a 1f 80 00       	push   $0x801f0a
  80011f:	6a 23                	push   $0x23
  800121:	68 27 1f 80 00       	push   $0x801f27
  800126:	e8 df 0f 00 00       	call   80110a <_panic>

0080012b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012b:	55                   	push   %ebp
  80012c:	89 e5                	mov    %esp,%ebp
  80012e:	57                   	push   %edi
  80012f:	56                   	push   %esi
  800130:	53                   	push   %ebx
	asm volatile("int %1\n"
  800131:	ba 00 00 00 00       	mov    $0x0,%edx
  800136:	b8 02 00 00 00       	mov    $0x2,%eax
  80013b:	89 d1                	mov    %edx,%ecx
  80013d:	89 d3                	mov    %edx,%ebx
  80013f:	89 d7                	mov    %edx,%edi
  800141:	89 d6                	mov    %edx,%esi
  800143:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5f                   	pop    %edi
  800148:	5d                   	pop    %ebp
  800149:	c3                   	ret    

0080014a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800153:	be 00 00 00 00       	mov    $0x0,%esi
  800158:	b8 04 00 00 00       	mov    $0x4,%eax
  80015d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800160:	8b 55 08             	mov    0x8(%ebp),%edx
  800163:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800166:	89 f7                	mov    %esi,%edi
  800168:	cd 30                	int    $0x30
	if(check && ret > 0)
  80016a:	85 c0                	test   %eax,%eax
  80016c:	7f 08                	jg     800176 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80016e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5f                   	pop    %edi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	50                   	push   %eax
  80017a:	6a 04                	push   $0x4
  80017c:	68 0a 1f 80 00       	push   $0x801f0a
  800181:	6a 23                	push   $0x23
  800183:	68 27 1f 80 00       	push   $0x801f27
  800188:	e8 7d 0f 00 00       	call   80110a <_panic>

0080018d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	57                   	push   %edi
  800191:	56                   	push   %esi
  800192:	53                   	push   %ebx
  800193:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800196:	b8 05 00 00 00       	mov    $0x5,%eax
  80019b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001a7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001aa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ac:	85 c0                	test   %eax,%eax
  8001ae:	7f 08                	jg     8001b8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b3:	5b                   	pop    %ebx
  8001b4:	5e                   	pop    %esi
  8001b5:	5f                   	pop    %edi
  8001b6:	5d                   	pop    %ebp
  8001b7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	50                   	push   %eax
  8001bc:	6a 05                	push   $0x5
  8001be:	68 0a 1f 80 00       	push   $0x801f0a
  8001c3:	6a 23                	push   $0x23
  8001c5:	68 27 1f 80 00       	push   $0x801f27
  8001ca:	e8 3b 0f 00 00       	call   80110a <_panic>

008001cf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	57                   	push   %edi
  8001d3:	56                   	push   %esi
  8001d4:	53                   	push   %ebx
  8001d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8001e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e8:	89 df                	mov    %ebx,%edi
  8001ea:	89 de                	mov    %ebx,%esi
  8001ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ee:	85 c0                	test   %eax,%eax
  8001f0:	7f 08                	jg     8001fa <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f5:	5b                   	pop    %ebx
  8001f6:	5e                   	pop    %esi
  8001f7:	5f                   	pop    %edi
  8001f8:	5d                   	pop    %ebp
  8001f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	6a 06                	push   $0x6
  800200:	68 0a 1f 80 00       	push   $0x801f0a
  800205:	6a 23                	push   $0x23
  800207:	68 27 1f 80 00       	push   $0x801f27
  80020c:	e8 f9 0e 00 00       	call   80110a <_panic>

00800211 <sys_yield>:

void
sys_yield(void)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	57                   	push   %edi
  800215:	56                   	push   %esi
  800216:	53                   	push   %ebx
	asm volatile("int %1\n"
  800217:	ba 00 00 00 00       	mov    $0x0,%edx
  80021c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800221:	89 d1                	mov    %edx,%ecx
  800223:	89 d3                	mov    %edx,%ebx
  800225:	89 d7                	mov    %edx,%edi
  800227:	89 d6                	mov    %edx,%esi
  800229:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80022b:	5b                   	pop    %ebx
  80022c:	5e                   	pop    %esi
  80022d:	5f                   	pop    %edi
  80022e:	5d                   	pop    %ebp
  80022f:	c3                   	ret    

00800230 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800239:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023e:	b8 08 00 00 00       	mov    $0x8,%eax
  800243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800246:	8b 55 08             	mov    0x8(%ebp),%edx
  800249:	89 df                	mov    %ebx,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024f:	85 c0                	test   %eax,%eax
  800251:	7f 08                	jg     80025b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800256:	5b                   	pop    %ebx
  800257:	5e                   	pop    %esi
  800258:	5f                   	pop    %edi
  800259:	5d                   	pop    %ebp
  80025a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	50                   	push   %eax
  80025f:	6a 08                	push   $0x8
  800261:	68 0a 1f 80 00       	push   $0x801f0a
  800266:	6a 23                	push   $0x23
  800268:	68 27 1f 80 00       	push   $0x801f27
  80026d:	e8 98 0e 00 00       	call   80110a <_panic>

00800272 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	57                   	push   %edi
  800276:	56                   	push   %esi
  800277:	53                   	push   %ebx
  800278:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800280:	b8 0c 00 00 00       	mov    $0xc,%eax
  800285:	8b 55 08             	mov    0x8(%ebp),%edx
  800288:	89 cb                	mov    %ecx,%ebx
  80028a:	89 cf                	mov    %ecx,%edi
  80028c:	89 ce                	mov    %ecx,%esi
  80028e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800290:	85 c0                	test   %eax,%eax
  800292:	7f 08                	jg     80029c <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800294:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800297:	5b                   	pop    %ebx
  800298:	5e                   	pop    %esi
  800299:	5f                   	pop    %edi
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	50                   	push   %eax
  8002a0:	6a 0c                	push   $0xc
  8002a2:	68 0a 1f 80 00       	push   $0x801f0a
  8002a7:	6a 23                	push   $0x23
  8002a9:	68 27 1f 80 00       	push   $0x801f27
  8002ae:	e8 57 0e 00 00       	call   80110a <_panic>

008002b3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c1:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cc:	89 df                	mov    %ebx,%edi
  8002ce:	89 de                	mov    %ebx,%esi
  8002d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	7f 08                	jg     8002de <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	50                   	push   %eax
  8002e2:	6a 09                	push   $0x9
  8002e4:	68 0a 1f 80 00       	push   $0x801f0a
  8002e9:	6a 23                	push   $0x23
  8002eb:	68 27 1f 80 00       	push   $0x801f27
  8002f0:	e8 15 0e 00 00       	call   80110a <_panic>

008002f5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800303:	b8 0a 00 00 00       	mov    $0xa,%eax
  800308:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030b:	8b 55 08             	mov    0x8(%ebp),%edx
  80030e:	89 df                	mov    %ebx,%edi
  800310:	89 de                	mov    %ebx,%esi
  800312:	cd 30                	int    $0x30
	if(check && ret > 0)
  800314:	85 c0                	test   %eax,%eax
  800316:	7f 08                	jg     800320 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	50                   	push   %eax
  800324:	6a 0a                	push   $0xa
  800326:	68 0a 1f 80 00       	push   $0x801f0a
  80032b:	6a 23                	push   $0x23
  80032d:	68 27 1f 80 00       	push   $0x801f27
  800332:	e8 d3 0d 00 00       	call   80110a <_panic>

00800337 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	57                   	push   %edi
  80033b:	56                   	push   %esi
  80033c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80033d:	be 00 00 00 00       	mov    $0x0,%esi
  800342:	b8 0d 00 00 00       	mov    $0xd,%eax
  800347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80034a:	8b 55 08             	mov    0x8(%ebp),%edx
  80034d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800350:	8b 7d 14             	mov    0x14(%ebp),%edi
  800353:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800355:	5b                   	pop    %ebx
  800356:	5e                   	pop    %esi
  800357:	5f                   	pop    %edi
  800358:	5d                   	pop    %ebp
  800359:	c3                   	ret    

0080035a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	57                   	push   %edi
  80035e:	56                   	push   %esi
  80035f:	53                   	push   %ebx
  800360:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800363:	b9 00 00 00 00       	mov    $0x0,%ecx
  800368:	b8 0e 00 00 00       	mov    $0xe,%eax
  80036d:	8b 55 08             	mov    0x8(%ebp),%edx
  800370:	89 cb                	mov    %ecx,%ebx
  800372:	89 cf                	mov    %ecx,%edi
  800374:	89 ce                	mov    %ecx,%esi
  800376:	cd 30                	int    $0x30
	if(check && ret > 0)
  800378:	85 c0                	test   %eax,%eax
  80037a:	7f 08                	jg     800384 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80037c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	6a 0e                	push   $0xe
  80038a:	68 0a 1f 80 00       	push   $0x801f0a
  80038f:	6a 23                	push   $0x23
  800391:	68 27 1f 80 00       	push   $0x801f27
  800396:	e8 6f 0d 00 00       	call   80110a <_panic>

0080039b <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	57                   	push   %edi
  80039f:	56                   	push   %esi
  8003a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a1:	be 00 00 00 00       	mov    $0x0,%esi
  8003a6:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003b4:	89 f7                	mov    %esi,%edi
  8003b6:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5f                   	pop    %edi
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	57                   	push   %edi
  8003c1:	56                   	push   %esi
  8003c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003c3:	be 00 00 00 00       	mov    $0x0,%esi
  8003c8:	b8 10 00 00 00       	mov    $0x10,%eax
  8003cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d6:	89 f7                	mov    %esi,%edi
  8003d8:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003da:	5b                   	pop    %ebx
  8003db:	5e                   	pop    %esi
  8003dc:	5f                   	pop    %edi
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	57                   	push   %edi
  8003e3:	56                   	push   %esi
  8003e4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ea:	b8 11 00 00 00       	mov    $0x11,%eax
  8003ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f2:	89 cb                	mov    %ecx,%ebx
  8003f4:	89 cf                	mov    %ecx,%edi
  8003f6:	89 ce                	mov    %ecx,%esi
  8003f8:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8003fa:	5b                   	pop    %ebx
  8003fb:	5e                   	pop    %esi
  8003fc:	5f                   	pop    %edi
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	05 00 00 00 30       	add    $0x30000000,%eax
  80040a:	c1 e8 0c             	shr    $0xc,%eax
}
  80040d:	5d                   	pop    %ebp
  80040e:	c3                   	ret    

0080040f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80041a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80042c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800431:	89 c2                	mov    %eax,%edx
  800433:	c1 ea 16             	shr    $0x16,%edx
  800436:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80043d:	f6 c2 01             	test   $0x1,%dl
  800440:	74 2a                	je     80046c <fd_alloc+0x46>
  800442:	89 c2                	mov    %eax,%edx
  800444:	c1 ea 0c             	shr    $0xc,%edx
  800447:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80044e:	f6 c2 01             	test   $0x1,%dl
  800451:	74 19                	je     80046c <fd_alloc+0x46>
  800453:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800458:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80045d:	75 d2                	jne    800431 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80045f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800465:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80046a:	eb 07                	jmp    800473 <fd_alloc+0x4d>
			*fd_store = fd;
  80046c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80046e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800478:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  80047c:	77 39                	ja     8004b7 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	c1 e0 0c             	shl    $0xc,%eax
  800484:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800489:	89 c2                	mov    %eax,%edx
  80048b:	c1 ea 16             	shr    $0x16,%edx
  80048e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800495:	f6 c2 01             	test   $0x1,%dl
  800498:	74 24                	je     8004be <fd_lookup+0x49>
  80049a:	89 c2                	mov    %eax,%edx
  80049c:	c1 ea 0c             	shr    $0xc,%edx
  80049f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004a6:	f6 c2 01             	test   $0x1,%dl
  8004a9:	74 1a                	je     8004c5 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8004b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    
		return -E_INVAL;
  8004b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004bc:	eb f7                	jmp    8004b5 <fd_lookup+0x40>
		return -E_INVAL;
  8004be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004c3:	eb f0                	jmp    8004b5 <fd_lookup+0x40>
  8004c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004ca:	eb e9                	jmp    8004b5 <fd_lookup+0x40>

008004cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004d5:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004da:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004df:	39 08                	cmp    %ecx,(%eax)
  8004e1:	74 33                	je     800516 <dev_lookup+0x4a>
  8004e3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004e6:	8b 02                	mov    (%edx),%eax
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	75 f3                	jne    8004df <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004ec:	a1 04 40 80 00       	mov    0x804004,%eax
  8004f1:	8b 40 48             	mov    0x48(%eax),%eax
  8004f4:	83 ec 04             	sub    $0x4,%esp
  8004f7:	51                   	push   %ecx
  8004f8:	50                   	push   %eax
  8004f9:	68 38 1f 80 00       	push   $0x801f38
  8004fe:	e8 1a 0d 00 00       	call   80121d <cprintf>
	*dev = 0;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800514:	c9                   	leave  
  800515:	c3                   	ret    
			*dev = devtab[i];
  800516:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800519:	89 01                	mov    %eax,(%ecx)
			return 0;
  80051b:	b8 00 00 00 00       	mov    $0x0,%eax
  800520:	eb f2                	jmp    800514 <dev_lookup+0x48>

00800522 <fd_close>:
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	57                   	push   %edi
  800526:	56                   	push   %esi
  800527:	53                   	push   %ebx
  800528:	83 ec 1c             	sub    $0x1c,%esp
  80052b:	8b 75 08             	mov    0x8(%ebp),%esi
  80052e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800531:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800534:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800535:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80053b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80053e:	50                   	push   %eax
  80053f:	e8 31 ff ff ff       	call   800475 <fd_lookup>
  800544:	89 c7                	mov    %eax,%edi
  800546:	83 c4 08             	add    $0x8,%esp
  800549:	85 c0                	test   %eax,%eax
  80054b:	78 05                	js     800552 <fd_close+0x30>
	    || fd != fd2)
  80054d:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800550:	74 13                	je     800565 <fd_close+0x43>
		return (must_exist ? r : 0);
  800552:	84 db                	test   %bl,%bl
  800554:	75 05                	jne    80055b <fd_close+0x39>
  800556:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80055b:	89 f8                	mov    %edi,%eax
  80055d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800560:	5b                   	pop    %ebx
  800561:	5e                   	pop    %esi
  800562:	5f                   	pop    %edi
  800563:	5d                   	pop    %ebp
  800564:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80056b:	50                   	push   %eax
  80056c:	ff 36                	pushl  (%esi)
  80056e:	e8 59 ff ff ff       	call   8004cc <dev_lookup>
  800573:	89 c7                	mov    %eax,%edi
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	85 c0                	test   %eax,%eax
  80057a:	78 15                	js     800591 <fd_close+0x6f>
		if (dev->dev_close)
  80057c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057f:	8b 40 10             	mov    0x10(%eax),%eax
  800582:	85 c0                	test   %eax,%eax
  800584:	74 1b                	je     8005a1 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800586:	83 ec 0c             	sub    $0xc,%esp
  800589:	56                   	push   %esi
  80058a:	ff d0                	call   *%eax
  80058c:	89 c7                	mov    %eax,%edi
  80058e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	56                   	push   %esi
  800595:	6a 00                	push   $0x0
  800597:	e8 33 fc ff ff       	call   8001cf <sys_page_unmap>
	return r;
  80059c:	83 c4 10             	add    $0x10,%esp
  80059f:	eb ba                	jmp    80055b <fd_close+0x39>
			r = 0;
  8005a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8005a6:	eb e9                	jmp    800591 <fd_close+0x6f>

008005a8 <close>:

int
close(int fdnum)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005b1:	50                   	push   %eax
  8005b2:	ff 75 08             	pushl  0x8(%ebp)
  8005b5:	e8 bb fe ff ff       	call   800475 <fd_lookup>
  8005ba:	83 c4 08             	add    $0x8,%esp
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	78 10                	js     8005d1 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	6a 01                	push   $0x1
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	e8 54 ff ff ff       	call   800522 <fd_close>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	c9                   	leave  
  8005d2:	c3                   	ret    

008005d3 <close_all>:

void
close_all(void)
{
  8005d3:	55                   	push   %ebp
  8005d4:	89 e5                	mov    %esp,%ebp
  8005d6:	53                   	push   %ebx
  8005d7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005da:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005df:	83 ec 0c             	sub    $0xc,%esp
  8005e2:	53                   	push   %ebx
  8005e3:	e8 c0 ff ff ff       	call   8005a8 <close>
	for (i = 0; i < MAXFD; i++)
  8005e8:	43                   	inc    %ebx
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	83 fb 20             	cmp    $0x20,%ebx
  8005ef:	75 ee                	jne    8005df <close_all+0xc>
}
  8005f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	57                   	push   %edi
  8005fa:	56                   	push   %esi
  8005fb:	53                   	push   %ebx
  8005fc:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	ff 75 08             	pushl  0x8(%ebp)
  800606:	e8 6a fe ff ff       	call   800475 <fd_lookup>
  80060b:	89 c3                	mov    %eax,%ebx
  80060d:	83 c4 08             	add    $0x8,%esp
  800610:	85 c0                	test   %eax,%eax
  800612:	0f 88 81 00 00 00    	js     800699 <dup+0xa3>
		return r;
	close(newfdnum);
  800618:	83 ec 0c             	sub    $0xc,%esp
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	e8 85 ff ff ff       	call   8005a8 <close>

	newfd = INDEX2FD(newfdnum);
  800623:	8b 75 0c             	mov    0xc(%ebp),%esi
  800626:	c1 e6 0c             	shl    $0xc,%esi
  800629:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80062f:	83 c4 04             	add    $0x4,%esp
  800632:	ff 75 e4             	pushl  -0x1c(%ebp)
  800635:	e8 d5 fd ff ff       	call   80040f <fd2data>
  80063a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80063c:	89 34 24             	mov    %esi,(%esp)
  80063f:	e8 cb fd ff ff       	call   80040f <fd2data>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800649:	89 d8                	mov    %ebx,%eax
  80064b:	c1 e8 16             	shr    $0x16,%eax
  80064e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800655:	a8 01                	test   $0x1,%al
  800657:	74 11                	je     80066a <dup+0x74>
  800659:	89 d8                	mov    %ebx,%eax
  80065b:	c1 e8 0c             	shr    $0xc,%eax
  80065e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800665:	f6 c2 01             	test   $0x1,%dl
  800668:	75 39                	jne    8006a3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80066a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	c1 e8 0c             	shr    $0xc,%eax
  800672:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800679:	83 ec 0c             	sub    $0xc,%esp
  80067c:	25 07 0e 00 00       	and    $0xe07,%eax
  800681:	50                   	push   %eax
  800682:	56                   	push   %esi
  800683:	6a 00                	push   $0x0
  800685:	52                   	push   %edx
  800686:	6a 00                	push   $0x0
  800688:	e8 00 fb ff ff       	call   80018d <sys_page_map>
  80068d:	89 c3                	mov    %eax,%ebx
  80068f:	83 c4 20             	add    $0x20,%esp
  800692:	85 c0                	test   %eax,%eax
  800694:	78 31                	js     8006c7 <dup+0xd1>
		goto err;

	return newfdnum;
  800696:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800699:	89 d8                	mov    %ebx,%eax
  80069b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80069e:	5b                   	pop    %ebx
  80069f:	5e                   	pop    %esi
  8006a0:	5f                   	pop    %edi
  8006a1:	5d                   	pop    %ebp
  8006a2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8006b2:	50                   	push   %eax
  8006b3:	57                   	push   %edi
  8006b4:	6a 00                	push   $0x0
  8006b6:	53                   	push   %ebx
  8006b7:	6a 00                	push   $0x0
  8006b9:	e8 cf fa ff ff       	call   80018d <sys_page_map>
  8006be:	89 c3                	mov    %eax,%ebx
  8006c0:	83 c4 20             	add    $0x20,%esp
  8006c3:	85 c0                	test   %eax,%eax
  8006c5:	79 a3                	jns    80066a <dup+0x74>
	sys_page_unmap(0, newfd);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	56                   	push   %esi
  8006cb:	6a 00                	push   $0x0
  8006cd:	e8 fd fa ff ff       	call   8001cf <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006d2:	83 c4 08             	add    $0x8,%esp
  8006d5:	57                   	push   %edi
  8006d6:	6a 00                	push   $0x0
  8006d8:	e8 f2 fa ff ff       	call   8001cf <sys_page_unmap>
	return r;
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	eb b7                	jmp    800699 <dup+0xa3>

008006e2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	53                   	push   %ebx
  8006e6:	83 ec 14             	sub    $0x14,%esp
  8006e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006ef:	50                   	push   %eax
  8006f0:	53                   	push   %ebx
  8006f1:	e8 7f fd ff ff       	call   800475 <fd_lookup>
  8006f6:	83 c4 08             	add    $0x8,%esp
  8006f9:	85 c0                	test   %eax,%eax
  8006fb:	78 3f                	js     80073c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800703:	50                   	push   %eax
  800704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800707:	ff 30                	pushl  (%eax)
  800709:	e8 be fd ff ff       	call   8004cc <dev_lookup>
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	85 c0                	test   %eax,%eax
  800713:	78 27                	js     80073c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800715:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800718:	8b 42 08             	mov    0x8(%edx),%eax
  80071b:	83 e0 03             	and    $0x3,%eax
  80071e:	83 f8 01             	cmp    $0x1,%eax
  800721:	74 1e                	je     800741 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800726:	8b 40 08             	mov    0x8(%eax),%eax
  800729:	85 c0                	test   %eax,%eax
  80072b:	74 35                	je     800762 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80072d:	83 ec 04             	sub    $0x4,%esp
  800730:	ff 75 10             	pushl  0x10(%ebp)
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	52                   	push   %edx
  800737:	ff d0                	call   *%eax
  800739:	83 c4 10             	add    $0x10,%esp
}
  80073c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80073f:	c9                   	leave  
  800740:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800741:	a1 04 40 80 00       	mov    0x804004,%eax
  800746:	8b 40 48             	mov    0x48(%eax),%eax
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	53                   	push   %ebx
  80074d:	50                   	push   %eax
  80074e:	68 79 1f 80 00       	push   $0x801f79
  800753:	e8 c5 0a 00 00       	call   80121d <cprintf>
		return -E_INVAL;
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800760:	eb da                	jmp    80073c <read+0x5a>
		return -E_NOT_SUPP;
  800762:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800767:	eb d3                	jmp    80073c <read+0x5a>

00800769 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	57                   	push   %edi
  80076d:	56                   	push   %esi
  80076e:	53                   	push   %ebx
  80076f:	83 ec 0c             	sub    $0xc,%esp
  800772:	8b 7d 08             	mov    0x8(%ebp),%edi
  800775:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800778:	bb 00 00 00 00       	mov    $0x0,%ebx
  80077d:	39 f3                	cmp    %esi,%ebx
  80077f:	73 25                	jae    8007a6 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	89 f0                	mov    %esi,%eax
  800786:	29 d8                	sub    %ebx,%eax
  800788:	50                   	push   %eax
  800789:	89 d8                	mov    %ebx,%eax
  80078b:	03 45 0c             	add    0xc(%ebp),%eax
  80078e:	50                   	push   %eax
  80078f:	57                   	push   %edi
  800790:	e8 4d ff ff ff       	call   8006e2 <read>
		if (m < 0)
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	85 c0                	test   %eax,%eax
  80079a:	78 08                	js     8007a4 <readn+0x3b>
			return m;
		if (m == 0)
  80079c:	85 c0                	test   %eax,%eax
  80079e:	74 06                	je     8007a6 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8007a0:	01 c3                	add    %eax,%ebx
  8007a2:	eb d9                	jmp    80077d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007a4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007a6:	89 d8                	mov    %ebx,%eax
  8007a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ab:	5b                   	pop    %ebx
  8007ac:	5e                   	pop    %esi
  8007ad:	5f                   	pop    %edi
  8007ae:	5d                   	pop    %ebp
  8007af:	c3                   	ret    

008007b0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	53                   	push   %ebx
  8007b4:	83 ec 14             	sub    $0x14,%esp
  8007b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007bd:	50                   	push   %eax
  8007be:	53                   	push   %ebx
  8007bf:	e8 b1 fc ff ff       	call   800475 <fd_lookup>
  8007c4:	83 c4 08             	add    $0x8,%esp
  8007c7:	85 c0                	test   %eax,%eax
  8007c9:	78 3a                	js     800805 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d1:	50                   	push   %eax
  8007d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d5:	ff 30                	pushl  (%eax)
  8007d7:	e8 f0 fc ff ff       	call   8004cc <dev_lookup>
  8007dc:	83 c4 10             	add    $0x10,%esp
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	78 22                	js     800805 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007ea:	74 1e                	je     80080a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ef:	8b 52 0c             	mov    0xc(%edx),%edx
  8007f2:	85 d2                	test   %edx,%edx
  8007f4:	74 35                	je     80082b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007f6:	83 ec 04             	sub    $0x4,%esp
  8007f9:	ff 75 10             	pushl  0x10(%ebp)
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	50                   	push   %eax
  800800:	ff d2                	call   *%edx
  800802:	83 c4 10             	add    $0x10,%esp
}
  800805:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800808:	c9                   	leave  
  800809:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80080a:	a1 04 40 80 00       	mov    0x804004,%eax
  80080f:	8b 40 48             	mov    0x48(%eax),%eax
  800812:	83 ec 04             	sub    $0x4,%esp
  800815:	53                   	push   %ebx
  800816:	50                   	push   %eax
  800817:	68 95 1f 80 00       	push   $0x801f95
  80081c:	e8 fc 09 00 00       	call   80121d <cprintf>
		return -E_INVAL;
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800829:	eb da                	jmp    800805 <write+0x55>
		return -E_NOT_SUPP;
  80082b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800830:	eb d3                	jmp    800805 <write+0x55>

00800832 <seek>:

int
seek(int fdnum, off_t offset)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800838:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80083b:	50                   	push   %eax
  80083c:	ff 75 08             	pushl  0x8(%ebp)
  80083f:	e8 31 fc ff ff       	call   800475 <fd_lookup>
  800844:	83 c4 08             	add    $0x8,%esp
  800847:	85 c0                	test   %eax,%eax
  800849:	78 0e                	js     800859 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80084b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800851:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	83 ec 14             	sub    $0x14,%esp
  800862:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800865:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800868:	50                   	push   %eax
  800869:	53                   	push   %ebx
  80086a:	e8 06 fc ff ff       	call   800475 <fd_lookup>
  80086f:	83 c4 08             	add    $0x8,%esp
  800872:	85 c0                	test   %eax,%eax
  800874:	78 37                	js     8008ad <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087c:	50                   	push   %eax
  80087d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800880:	ff 30                	pushl  (%eax)
  800882:	e8 45 fc ff ff       	call   8004cc <dev_lookup>
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	85 c0                	test   %eax,%eax
  80088c:	78 1f                	js     8008ad <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800895:	74 1b                	je     8008b2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089a:	8b 52 18             	mov    0x18(%edx),%edx
  80089d:	85 d2                	test   %edx,%edx
  80089f:	74 32                	je     8008d3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	50                   	push   %eax
  8008a8:	ff d2                	call   *%edx
  8008aa:	83 c4 10             	add    $0x10,%esp
}
  8008ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008b2:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008b7:	8b 40 48             	mov    0x48(%eax),%eax
  8008ba:	83 ec 04             	sub    $0x4,%esp
  8008bd:	53                   	push   %ebx
  8008be:	50                   	push   %eax
  8008bf:	68 58 1f 80 00       	push   $0x801f58
  8008c4:	e8 54 09 00 00       	call   80121d <cprintf>
		return -E_INVAL;
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d1:	eb da                	jmp    8008ad <ftruncate+0x52>
		return -E_NOT_SUPP;
  8008d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008d8:	eb d3                	jmp    8008ad <ftruncate+0x52>

008008da <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	53                   	push   %ebx
  8008de:	83 ec 14             	sub    $0x14,%esp
  8008e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e7:	50                   	push   %eax
  8008e8:	ff 75 08             	pushl  0x8(%ebp)
  8008eb:	e8 85 fb ff ff       	call   800475 <fd_lookup>
  8008f0:	83 c4 08             	add    $0x8,%esp
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	78 4b                	js     800942 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008fd:	50                   	push   %eax
  8008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800901:	ff 30                	pushl  (%eax)
  800903:	e8 c4 fb ff ff       	call   8004cc <dev_lookup>
  800908:	83 c4 10             	add    $0x10,%esp
  80090b:	85 c0                	test   %eax,%eax
  80090d:	78 33                	js     800942 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80090f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800912:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800916:	74 2f                	je     800947 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800918:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80091b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800922:	00 00 00 
	stat->st_type = 0;
  800925:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80092c:	00 00 00 
	stat->st_dev = dev;
  80092f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	53                   	push   %ebx
  800939:	ff 75 f0             	pushl  -0x10(%ebp)
  80093c:	ff 50 14             	call   *0x14(%eax)
  80093f:	83 c4 10             	add    $0x10,%esp
}
  800942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800945:	c9                   	leave  
  800946:	c3                   	ret    
		return -E_NOT_SUPP;
  800947:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80094c:	eb f4                	jmp    800942 <fstat+0x68>

0080094e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	56                   	push   %esi
  800952:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	6a 00                	push   $0x0
  800958:	ff 75 08             	pushl  0x8(%ebp)
  80095b:	e8 34 02 00 00       	call   800b94 <open>
  800960:	89 c3                	mov    %eax,%ebx
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	85 c0                	test   %eax,%eax
  800967:	78 1b                	js     800984 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	50                   	push   %eax
  800970:	e8 65 ff ff ff       	call   8008da <fstat>
  800975:	89 c6                	mov    %eax,%esi
	close(fd);
  800977:	89 1c 24             	mov    %ebx,(%esp)
  80097a:	e8 29 fc ff ff       	call   8005a8 <close>
	return r;
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	89 f3                	mov    %esi,%ebx
}
  800984:	89 d8                	mov    %ebx,%eax
  800986:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800989:	5b                   	pop    %ebx
  80098a:	5e                   	pop    %esi
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	89 c6                	mov    %eax,%esi
  800994:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800996:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80099d:	74 27                	je     8009c6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80099f:	6a 07                	push   $0x7
  8009a1:	68 00 50 80 00       	push   $0x805000
  8009a6:	56                   	push   %esi
  8009a7:	ff 35 00 40 80 00    	pushl  0x804000
  8009ad:	e8 14 12 00 00       	call   801bc6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009b2:	83 c4 0c             	add    $0xc,%esp
  8009b5:	6a 00                	push   $0x0
  8009b7:	53                   	push   %ebx
  8009b8:	6a 00                	push   $0x0
  8009ba:	e8 7e 11 00 00       	call   801b3d <ipc_recv>
}
  8009bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c2:	5b                   	pop    %ebx
  8009c3:	5e                   	pop    %esi
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009c6:	83 ec 0c             	sub    $0xc,%esp
  8009c9:	6a 01                	push   $0x1
  8009cb:	e8 52 12 00 00       	call   801c22 <ipc_find_env>
  8009d0:	a3 00 40 80 00       	mov    %eax,0x804000
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	eb c5                	jmp    80099f <fsipc+0x12>

008009da <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ee:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f8:	b8 02 00 00 00       	mov    $0x2,%eax
  8009fd:	e8 8b ff ff ff       	call   80098d <fsipc>
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <devfile_flush>:
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8b 40 0c             	mov    0xc(%eax),%eax
  800a10:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a15:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1a:	b8 06 00 00 00       	mov    $0x6,%eax
  800a1f:	e8 69 ff ff ff       	call   80098d <fsipc>
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <devfile_stat>:
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	83 ec 04             	sub    $0x4,%esp
  800a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 40 0c             	mov    0xc(%eax),%eax
  800a36:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a40:	b8 05 00 00 00       	mov    $0x5,%eax
  800a45:	e8 43 ff ff ff       	call   80098d <fsipc>
  800a4a:	85 c0                	test   %eax,%eax
  800a4c:	78 2c                	js     800a7a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	68 00 50 80 00       	push   $0x805000
  800a56:	53                   	push   %ebx
  800a57:	e8 c9 0d 00 00       	call   801825 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a5c:	a1 80 50 80 00       	mov    0x805080,%eax
  800a61:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a67:	a1 84 50 80 00       	mov    0x805084,%eax
  800a6c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a72:	83 c4 10             	add    $0x10,%esp
  800a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7d:	c9                   	leave  
  800a7e:	c3                   	ret    

00800a7f <devfile_write>:
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	53                   	push   %ebx
  800a83:	83 ec 04             	sub    $0x4,%esp
  800a86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800a89:	89 d8                	mov    %ebx,%eax
  800a8b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800a91:	76 05                	jbe    800a98 <devfile_write+0x19>
  800a93:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a98:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9b:	8b 52 0c             	mov    0xc(%edx),%edx
  800a9e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800aa4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800aa9:	83 ec 04             	sub    $0x4,%esp
  800aac:	50                   	push   %eax
  800aad:	ff 75 0c             	pushl  0xc(%ebp)
  800ab0:	68 08 50 80 00       	push   $0x805008
  800ab5:	e8 de 0e 00 00       	call   801998 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800aba:	ba 00 00 00 00       	mov    $0x0,%edx
  800abf:	b8 04 00 00 00       	mov    $0x4,%eax
  800ac4:	e8 c4 fe ff ff       	call   80098d <fsipc>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	78 0b                	js     800adb <devfile_write+0x5c>
	assert(r <= n);
  800ad0:	39 c3                	cmp    %eax,%ebx
  800ad2:	72 0c                	jb     800ae0 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800ad4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad9:	7f 1e                	jg     800af9 <devfile_write+0x7a>
}
  800adb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    
	assert(r <= n);
  800ae0:	68 c4 1f 80 00       	push   $0x801fc4
  800ae5:	68 cb 1f 80 00       	push   $0x801fcb
  800aea:	68 98 00 00 00       	push   $0x98
  800aef:	68 e0 1f 80 00       	push   $0x801fe0
  800af4:	e8 11 06 00 00       	call   80110a <_panic>
	assert(r <= PGSIZE);
  800af9:	68 eb 1f 80 00       	push   $0x801feb
  800afe:	68 cb 1f 80 00       	push   $0x801fcb
  800b03:	68 99 00 00 00       	push   $0x99
  800b08:	68 e0 1f 80 00       	push   $0x801fe0
  800b0d:	e8 f8 05 00 00       	call   80110a <_panic>

00800b12 <devfile_read>:
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	56                   	push   %esi
  800b16:	53                   	push   %ebx
  800b17:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 40 0c             	mov    0xc(%eax),%eax
  800b20:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b25:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b30:	b8 03 00 00 00       	mov    $0x3,%eax
  800b35:	e8 53 fe ff ff       	call   80098d <fsipc>
  800b3a:	89 c3                	mov    %eax,%ebx
  800b3c:	85 c0                	test   %eax,%eax
  800b3e:	78 1f                	js     800b5f <devfile_read+0x4d>
	assert(r <= n);
  800b40:	39 c6                	cmp    %eax,%esi
  800b42:	72 24                	jb     800b68 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b44:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b49:	7f 33                	jg     800b7e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b4b:	83 ec 04             	sub    $0x4,%esp
  800b4e:	50                   	push   %eax
  800b4f:	68 00 50 80 00       	push   $0x805000
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	e8 3c 0e 00 00       	call   801998 <memmove>
	return r;
  800b5c:	83 c4 10             	add    $0x10,%esp
}
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    
	assert(r <= n);
  800b68:	68 c4 1f 80 00       	push   $0x801fc4
  800b6d:	68 cb 1f 80 00       	push   $0x801fcb
  800b72:	6a 7c                	push   $0x7c
  800b74:	68 e0 1f 80 00       	push   $0x801fe0
  800b79:	e8 8c 05 00 00       	call   80110a <_panic>
	assert(r <= PGSIZE);
  800b7e:	68 eb 1f 80 00       	push   $0x801feb
  800b83:	68 cb 1f 80 00       	push   $0x801fcb
  800b88:	6a 7d                	push   $0x7d
  800b8a:	68 e0 1f 80 00       	push   $0x801fe0
  800b8f:	e8 76 05 00 00       	call   80110a <_panic>

00800b94 <open>:
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	83 ec 1c             	sub    $0x1c,%esp
  800b9c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b9f:	56                   	push   %esi
  800ba0:	e8 4d 0c 00 00       	call   8017f2 <strlen>
  800ba5:	83 c4 10             	add    $0x10,%esp
  800ba8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bad:	7f 6c                	jg     800c1b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800baf:	83 ec 0c             	sub    $0xc,%esp
  800bb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bb5:	50                   	push   %eax
  800bb6:	e8 6b f8 ff ff       	call   800426 <fd_alloc>
  800bbb:	89 c3                	mov    %eax,%ebx
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	85 c0                	test   %eax,%eax
  800bc2:	78 3c                	js     800c00 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	56                   	push   %esi
  800bc8:	68 00 50 80 00       	push   $0x805000
  800bcd:	e8 53 0c 00 00       	call   801825 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  800be2:	e8 a6 fd ff ff       	call   80098d <fsipc>
  800be7:	89 c3                	mov    %eax,%ebx
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	85 c0                	test   %eax,%eax
  800bee:	78 19                	js     800c09 <open+0x75>
	return fd2num(fd);
  800bf0:	83 ec 0c             	sub    $0xc,%esp
  800bf3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf6:	e8 04 f8 ff ff       	call   8003ff <fd2num>
  800bfb:	89 c3                	mov    %eax,%ebx
  800bfd:	83 c4 10             	add    $0x10,%esp
}
  800c00:	89 d8                	mov    %ebx,%eax
  800c02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    
		fd_close(fd, 0);
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	6a 00                	push   $0x0
  800c0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c11:	e8 0c f9 ff ff       	call   800522 <fd_close>
		return r;
  800c16:	83 c4 10             	add    $0x10,%esp
  800c19:	eb e5                	jmp    800c00 <open+0x6c>
		return -E_BAD_PATH;
  800c1b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c20:	eb de                	jmp    800c00 <open+0x6c>

00800c22 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c32:	e8 56 fd ff ff       	call   80098d <fsipc>
}
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	56                   	push   %esi
  800c3d:	53                   	push   %ebx
  800c3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c41:	83 ec 0c             	sub    $0xc,%esp
  800c44:	ff 75 08             	pushl  0x8(%ebp)
  800c47:	e8 c3 f7 ff ff       	call   80040f <fd2data>
  800c4c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c4e:	83 c4 08             	add    $0x8,%esp
  800c51:	68 f7 1f 80 00       	push   $0x801ff7
  800c56:	53                   	push   %ebx
  800c57:	e8 c9 0b 00 00       	call   801825 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c5c:	8b 46 04             	mov    0x4(%esi),%eax
  800c5f:	2b 06                	sub    (%esi),%eax
  800c61:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c67:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800c6e:	10 00 00 
	stat->st_dev = &devpipe;
  800c71:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c78:	30 80 00 
	return 0;
}
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c91:	53                   	push   %ebx
  800c92:	6a 00                	push   $0x0
  800c94:	e8 36 f5 ff ff       	call   8001cf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c99:	89 1c 24             	mov    %ebx,(%esp)
  800c9c:	e8 6e f7 ff ff       	call   80040f <fd2data>
  800ca1:	83 c4 08             	add    $0x8,%esp
  800ca4:	50                   	push   %eax
  800ca5:	6a 00                	push   $0x0
  800ca7:	e8 23 f5 ff ff       	call   8001cf <sys_page_unmap>
}
  800cac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <_pipeisclosed>:
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 1c             	sub    $0x1c,%esp
  800cba:	89 c7                	mov    %eax,%edi
  800cbc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cbe:	a1 04 40 80 00       	mov    0x804004,%eax
  800cc3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	57                   	push   %edi
  800cca:	e8 95 0f 00 00       	call   801c64 <pageref>
  800ccf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd2:	89 34 24             	mov    %esi,(%esp)
  800cd5:	e8 8a 0f 00 00       	call   801c64 <pageref>
		nn = thisenv->env_runs;
  800cda:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800ce0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800ce3:	83 c4 10             	add    $0x10,%esp
  800ce6:	39 cb                	cmp    %ecx,%ebx
  800ce8:	74 1b                	je     800d05 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800cea:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ced:	75 cf                	jne    800cbe <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800cef:	8b 42 58             	mov    0x58(%edx),%eax
  800cf2:	6a 01                	push   $0x1
  800cf4:	50                   	push   %eax
  800cf5:	53                   	push   %ebx
  800cf6:	68 fe 1f 80 00       	push   $0x801ffe
  800cfb:	e8 1d 05 00 00       	call   80121d <cprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	eb b9                	jmp    800cbe <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800d05:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800d08:	0f 94 c0             	sete   %al
  800d0b:	0f b6 c0             	movzbl %al,%eax
}
  800d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <devpipe_write>:
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 18             	sub    $0x18,%esp
  800d1f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d22:	56                   	push   %esi
  800d23:	e8 e7 f6 ff ff       	call   80040f <fd2data>
  800d28:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d2a:	83 c4 10             	add    $0x10,%esp
  800d2d:	bf 00 00 00 00       	mov    $0x0,%edi
  800d32:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d35:	74 41                	je     800d78 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d37:	8b 53 04             	mov    0x4(%ebx),%edx
  800d3a:	8b 03                	mov    (%ebx),%eax
  800d3c:	83 c0 20             	add    $0x20,%eax
  800d3f:	39 c2                	cmp    %eax,%edx
  800d41:	72 14                	jb     800d57 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d43:	89 da                	mov    %ebx,%edx
  800d45:	89 f0                	mov    %esi,%eax
  800d47:	e8 65 ff ff ff       	call   800cb1 <_pipeisclosed>
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	75 2c                	jne    800d7c <devpipe_write+0x66>
			sys_yield();
  800d50:	e8 bc f4 ff ff       	call   800211 <sys_yield>
  800d55:	eb e0                	jmp    800d37 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d5d:	89 d0                	mov    %edx,%eax
  800d5f:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d64:	78 0b                	js     800d71 <devpipe_write+0x5b>
  800d66:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d6a:	42                   	inc    %edx
  800d6b:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d6e:	47                   	inc    %edi
  800d6f:	eb c1                	jmp    800d32 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d71:	48                   	dec    %eax
  800d72:	83 c8 e0             	or     $0xffffffe0,%eax
  800d75:	40                   	inc    %eax
  800d76:	eb ee                	jmp    800d66 <devpipe_write+0x50>
	return i;
  800d78:	89 f8                	mov    %edi,%eax
  800d7a:	eb 05                	jmp    800d81 <devpipe_write+0x6b>
				return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <devpipe_read>:
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 18             	sub    $0x18,%esp
  800d92:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d95:	57                   	push   %edi
  800d96:	e8 74 f6 ff ff       	call   80040f <fd2data>
  800d9b:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800d9d:	83 c4 10             	add    $0x10,%esp
  800da0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da5:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800da8:	74 46                	je     800df0 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800daa:	8b 06                	mov    (%esi),%eax
  800dac:	3b 46 04             	cmp    0x4(%esi),%eax
  800daf:	75 22                	jne    800dd3 <devpipe_read+0x4a>
			if (i > 0)
  800db1:	85 db                	test   %ebx,%ebx
  800db3:	74 0a                	je     800dbf <devpipe_read+0x36>
				return i;
  800db5:	89 d8                	mov    %ebx,%eax
}
  800db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5f                   	pop    %edi
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800dbf:	89 f2                	mov    %esi,%edx
  800dc1:	89 f8                	mov    %edi,%eax
  800dc3:	e8 e9 fe ff ff       	call   800cb1 <_pipeisclosed>
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	75 28                	jne    800df4 <devpipe_read+0x6b>
			sys_yield();
  800dcc:	e8 40 f4 ff ff       	call   800211 <sys_yield>
  800dd1:	eb d7                	jmp    800daa <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dd3:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800dd8:	78 0f                	js     800de9 <devpipe_read+0x60>
  800dda:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800de4:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800de6:	43                   	inc    %ebx
  800de7:	eb bc                	jmp    800da5 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800de9:	48                   	dec    %eax
  800dea:	83 c8 e0             	or     $0xffffffe0,%eax
  800ded:	40                   	inc    %eax
  800dee:	eb ea                	jmp    800dda <devpipe_read+0x51>
	return i;
  800df0:	89 d8                	mov    %ebx,%eax
  800df2:	eb c3                	jmp    800db7 <devpipe_read+0x2e>
				return 0;
  800df4:	b8 00 00 00 00       	mov    $0x0,%eax
  800df9:	eb bc                	jmp    800db7 <devpipe_read+0x2e>

00800dfb <pipe>:
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800e03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e06:	50                   	push   %eax
  800e07:	e8 1a f6 ff ff       	call   800426 <fd_alloc>
  800e0c:	89 c3                	mov    %eax,%ebx
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	85 c0                	test   %eax,%eax
  800e13:	0f 88 2a 01 00 00    	js     800f43 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e19:	83 ec 04             	sub    $0x4,%esp
  800e1c:	68 07 04 00 00       	push   $0x407
  800e21:	ff 75 f4             	pushl  -0xc(%ebp)
  800e24:	6a 00                	push   $0x0
  800e26:	e8 1f f3 ff ff       	call   80014a <sys_page_alloc>
  800e2b:	89 c3                	mov    %eax,%ebx
  800e2d:	83 c4 10             	add    $0x10,%esp
  800e30:	85 c0                	test   %eax,%eax
  800e32:	0f 88 0b 01 00 00    	js     800f43 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e3e:	50                   	push   %eax
  800e3f:	e8 e2 f5 ff ff       	call   800426 <fd_alloc>
  800e44:	89 c3                	mov    %eax,%ebx
  800e46:	83 c4 10             	add    $0x10,%esp
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	0f 88 e2 00 00 00    	js     800f33 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e51:	83 ec 04             	sub    $0x4,%esp
  800e54:	68 07 04 00 00       	push   $0x407
  800e59:	ff 75 f0             	pushl  -0x10(%ebp)
  800e5c:	6a 00                	push   $0x0
  800e5e:	e8 e7 f2 ff ff       	call   80014a <sys_page_alloc>
  800e63:	89 c3                	mov    %eax,%ebx
  800e65:	83 c4 10             	add    $0x10,%esp
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	0f 88 c3 00 00 00    	js     800f33 <pipe+0x138>
	va = fd2data(fd0);
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	ff 75 f4             	pushl  -0xc(%ebp)
  800e76:	e8 94 f5 ff ff       	call   80040f <fd2data>
  800e7b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e7d:	83 c4 0c             	add    $0xc,%esp
  800e80:	68 07 04 00 00       	push   $0x407
  800e85:	50                   	push   %eax
  800e86:	6a 00                	push   $0x0
  800e88:	e8 bd f2 ff ff       	call   80014a <sys_page_alloc>
  800e8d:	89 c3                	mov    %eax,%ebx
  800e8f:	83 c4 10             	add    $0x10,%esp
  800e92:	85 c0                	test   %eax,%eax
  800e94:	0f 88 89 00 00 00    	js     800f23 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e9a:	83 ec 0c             	sub    $0xc,%esp
  800e9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea0:	e8 6a f5 ff ff       	call   80040f <fd2data>
  800ea5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800eac:	50                   	push   %eax
  800ead:	6a 00                	push   $0x0
  800eaf:	56                   	push   %esi
  800eb0:	6a 00                	push   $0x0
  800eb2:	e8 d6 f2 ff ff       	call   80018d <sys_page_map>
  800eb7:	89 c3                	mov    %eax,%ebx
  800eb9:	83 c4 20             	add    $0x20,%esp
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	78 55                	js     800f15 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800ec0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec9:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ece:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800ed5:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ede:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef0:	e8 0a f5 ff ff       	call   8003ff <fd2num>
  800ef5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800efa:	83 c4 04             	add    $0x4,%esp
  800efd:	ff 75 f0             	pushl  -0x10(%ebp)
  800f00:	e8 fa f4 ff ff       	call   8003ff <fd2num>
  800f05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f08:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f0b:	83 c4 10             	add    $0x10,%esp
  800f0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f13:	eb 2e                	jmp    800f43 <pipe+0x148>
	sys_page_unmap(0, va);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	56                   	push   %esi
  800f19:	6a 00                	push   $0x0
  800f1b:	e8 af f2 ff ff       	call   8001cf <sys_page_unmap>
  800f20:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f23:	83 ec 08             	sub    $0x8,%esp
  800f26:	ff 75 f0             	pushl  -0x10(%ebp)
  800f29:	6a 00                	push   $0x0
  800f2b:	e8 9f f2 ff ff       	call   8001cf <sys_page_unmap>
  800f30:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f33:	83 ec 08             	sub    $0x8,%esp
  800f36:	ff 75 f4             	pushl  -0xc(%ebp)
  800f39:	6a 00                	push   $0x0
  800f3b:	e8 8f f2 ff ff       	call   8001cf <sys_page_unmap>
  800f40:	83 c4 10             	add    $0x10,%esp
}
  800f43:	89 d8                	mov    %ebx,%eax
  800f45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <pipeisclosed>:
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f55:	50                   	push   %eax
  800f56:	ff 75 08             	pushl  0x8(%ebp)
  800f59:	e8 17 f5 ff ff       	call   800475 <fd_lookup>
  800f5e:	83 c4 10             	add    $0x10,%esp
  800f61:	85 c0                	test   %eax,%eax
  800f63:	78 18                	js     800f7d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f65:	83 ec 0c             	sub    $0xc,%esp
  800f68:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6b:	e8 9f f4 ff ff       	call   80040f <fd2data>
	return _pipeisclosed(fd, p);
  800f70:	89 c2                	mov    %eax,%edx
  800f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f75:	e8 37 fd ff ff       	call   800cb1 <_pipeisclosed>
  800f7a:	83 c4 10             	add    $0x10,%esp
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800f82:	b8 00 00 00 00       	mov    $0x0,%eax
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800f93:	68 16 20 80 00       	push   $0x802016
  800f98:	53                   	push   %ebx
  800f99:	e8 87 08 00 00       	call   801825 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800f9e:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800fa5:	20 00 00 
	return 0;
}
  800fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    

00800fb2 <devcons_write>:
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	57                   	push   %edi
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
  800fb8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fbe:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fc3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fc9:	eb 1d                	jmp    800fe8 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800fcb:	83 ec 04             	sub    $0x4,%esp
  800fce:	53                   	push   %ebx
  800fcf:	03 45 0c             	add    0xc(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	57                   	push   %edi
  800fd4:	e8 bf 09 00 00       	call   801998 <memmove>
		sys_cputs(buf, m);
  800fd9:	83 c4 08             	add    $0x8,%esp
  800fdc:	53                   	push   %ebx
  800fdd:	57                   	push   %edi
  800fde:	e8 ca f0 ff ff       	call   8000ad <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fe3:	01 de                	add    %ebx,%esi
  800fe5:	83 c4 10             	add    $0x10,%esp
  800fe8:	89 f0                	mov    %esi,%eax
  800fea:	3b 75 10             	cmp    0x10(%ebp),%esi
  800fed:	73 11                	jae    801000 <devcons_write+0x4e>
		m = n - tot;
  800fef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff2:	29 f3                	sub    %esi,%ebx
  800ff4:	83 fb 7f             	cmp    $0x7f,%ebx
  800ff7:	76 d2                	jbe    800fcb <devcons_write+0x19>
  800ff9:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800ffe:	eb cb                	jmp    800fcb <devcons_write+0x19>
}
  801000:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5f                   	pop    %edi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <devcons_read>:
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  80100e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801012:	75 0c                	jne    801020 <devcons_read+0x18>
		return 0;
  801014:	b8 00 00 00 00       	mov    $0x0,%eax
  801019:	eb 21                	jmp    80103c <devcons_read+0x34>
		sys_yield();
  80101b:	e8 f1 f1 ff ff       	call   800211 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801020:	e8 a6 f0 ff ff       	call   8000cb <sys_cgetc>
  801025:	85 c0                	test   %eax,%eax
  801027:	74 f2                	je     80101b <devcons_read+0x13>
	if (c < 0)
  801029:	85 c0                	test   %eax,%eax
  80102b:	78 0f                	js     80103c <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  80102d:	83 f8 04             	cmp    $0x4,%eax
  801030:	74 0c                	je     80103e <devcons_read+0x36>
	*(char*)vbuf = c;
  801032:	8b 55 0c             	mov    0xc(%ebp),%edx
  801035:	88 02                	mov    %al,(%edx)
	return 1;
  801037:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    
		return 0;
  80103e:	b8 00 00 00 00       	mov    $0x0,%eax
  801043:	eb f7                	jmp    80103c <devcons_read+0x34>

00801045 <cputchar>:
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801051:	6a 01                	push   $0x1
  801053:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801056:	50                   	push   %eax
  801057:	e8 51 f0 ff ff       	call   8000ad <sys_cputs>
}
  80105c:	83 c4 10             	add    $0x10,%esp
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <getchar>:
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801067:	6a 01                	push   $0x1
  801069:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80106c:	50                   	push   %eax
  80106d:	6a 00                	push   $0x0
  80106f:	e8 6e f6 ff ff       	call   8006e2 <read>
	if (r < 0)
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	85 c0                	test   %eax,%eax
  801079:	78 08                	js     801083 <getchar+0x22>
	if (r < 1)
  80107b:	85 c0                	test   %eax,%eax
  80107d:	7e 06                	jle    801085 <getchar+0x24>
	return c;
  80107f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801083:	c9                   	leave  
  801084:	c3                   	ret    
		return -E_EOF;
  801085:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80108a:	eb f7                	jmp    801083 <getchar+0x22>

0080108c <iscons>:
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801092:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801095:	50                   	push   %eax
  801096:	ff 75 08             	pushl  0x8(%ebp)
  801099:	e8 d7 f3 ff ff       	call   800475 <fd_lookup>
  80109e:	83 c4 10             	add    $0x10,%esp
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	78 11                	js     8010b6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8010a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010ae:	39 10                	cmp    %edx,(%eax)
  8010b0:	0f 94 c0             	sete   %al
  8010b3:	0f b6 c0             	movzbl %al,%eax
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <opencons>:
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c1:	50                   	push   %eax
  8010c2:	e8 5f f3 ff ff       	call   800426 <fd_alloc>
  8010c7:	83 c4 10             	add    $0x10,%esp
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	78 3a                	js     801108 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	68 07 04 00 00       	push   $0x407
  8010d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d9:	6a 00                	push   $0x0
  8010db:	e8 6a f0 ff ff       	call   80014a <sys_page_alloc>
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	78 21                	js     801108 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8010e7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	50                   	push   %eax
  801100:	e8 fa f2 ff ff       	call   8003ff <fd2num>
  801105:	83 c4 10             	add    $0x10,%esp
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	57                   	push   %edi
  80110e:	56                   	push   %esi
  80110f:	53                   	push   %ebx
  801110:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801116:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801119:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  80111f:	e8 07 f0 ff ff       	call   80012b <sys_getenvid>
  801124:	83 ec 04             	sub    $0x4,%esp
  801127:	ff 75 0c             	pushl  0xc(%ebp)
  80112a:	ff 75 08             	pushl  0x8(%ebp)
  80112d:	53                   	push   %ebx
  80112e:	50                   	push   %eax
  80112f:	68 24 20 80 00       	push   $0x802024
  801134:	68 00 01 00 00       	push   $0x100
  801139:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  80113f:	56                   	push   %esi
  801140:	e8 93 06 00 00       	call   8017d8 <snprintf>
  801145:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801147:	83 c4 20             	add    $0x20,%esp
  80114a:	57                   	push   %edi
  80114b:	ff 75 10             	pushl  0x10(%ebp)
  80114e:	bf 00 01 00 00       	mov    $0x100,%edi
  801153:	89 f8                	mov    %edi,%eax
  801155:	29 d8                	sub    %ebx,%eax
  801157:	50                   	push   %eax
  801158:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80115b:	50                   	push   %eax
  80115c:	e8 22 06 00 00       	call   801783 <vsnprintf>
  801161:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801163:	83 c4 0c             	add    $0xc,%esp
  801166:	68 0f 20 80 00       	push   $0x80200f
  80116b:	29 df                	sub    %ebx,%edi
  80116d:	57                   	push   %edi
  80116e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801171:	50                   	push   %eax
  801172:	e8 61 06 00 00       	call   8017d8 <snprintf>
	sys_cputs(buf, r);
  801177:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80117a:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80117c:	53                   	push   %ebx
  80117d:	56                   	push   %esi
  80117e:	e8 2a ef ff ff       	call   8000ad <sys_cputs>
  801183:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801186:	cc                   	int3   
  801187:	eb fd                	jmp    801186 <_panic+0x7c>

00801189 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	53                   	push   %ebx
  80118d:	83 ec 04             	sub    $0x4,%esp
  801190:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801193:	8b 13                	mov    (%ebx),%edx
  801195:	8d 42 01             	lea    0x1(%edx),%eax
  801198:	89 03                	mov    %eax,(%ebx)
  80119a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8011a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011a6:	74 08                	je     8011b0 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8011a8:	ff 43 04             	incl   0x4(%ebx)
}
  8011ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011b0:	83 ec 08             	sub    $0x8,%esp
  8011b3:	68 ff 00 00 00       	push   $0xff
  8011b8:	8d 43 08             	lea    0x8(%ebx),%eax
  8011bb:	50                   	push   %eax
  8011bc:	e8 ec ee ff ff       	call   8000ad <sys_cputs>
		b->idx = 0;
  8011c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	eb dc                	jmp    8011a8 <putch+0x1f>

008011cc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011dc:	00 00 00 
	b.cnt = 0;
  8011df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011e9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ec:	ff 75 08             	pushl  0x8(%ebp)
  8011ef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011f5:	50                   	push   %eax
  8011f6:	68 89 11 80 00       	push   $0x801189
  8011fb:	e8 17 01 00 00       	call   801317 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801200:	83 c4 08             	add    $0x8,%esp
  801203:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801209:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80120f:	50                   	push   %eax
  801210:	e8 98 ee ff ff       	call   8000ad <sys_cputs>

	return b.cnt;
}
  801215:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801223:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801226:	50                   	push   %eax
  801227:	ff 75 08             	pushl  0x8(%ebp)
  80122a:	e8 9d ff ff ff       	call   8011cc <vcprintf>
	va_end(ap);

	return cnt;
}
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	57                   	push   %edi
  801235:	56                   	push   %esi
  801236:	53                   	push   %ebx
  801237:	83 ec 1c             	sub    $0x1c,%esp
  80123a:	89 c7                	mov    %eax,%edi
  80123c:	89 d6                	mov    %edx,%esi
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8b 55 0c             	mov    0xc(%ebp),%edx
  801244:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801247:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80124a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80124d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801252:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801255:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801258:	39 d3                	cmp    %edx,%ebx
  80125a:	72 05                	jb     801261 <printnum+0x30>
  80125c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80125f:	77 78                	ja     8012d9 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801261:	83 ec 0c             	sub    $0xc,%esp
  801264:	ff 75 18             	pushl  0x18(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80126d:	53                   	push   %ebx
  80126e:	ff 75 10             	pushl  0x10(%ebp)
  801271:	83 ec 08             	sub    $0x8,%esp
  801274:	ff 75 e4             	pushl  -0x1c(%ebp)
  801277:	ff 75 e0             	pushl  -0x20(%ebp)
  80127a:	ff 75 dc             	pushl  -0x24(%ebp)
  80127d:	ff 75 d8             	pushl  -0x28(%ebp)
  801280:	e8 23 0a 00 00       	call   801ca8 <__udivdi3>
  801285:	83 c4 18             	add    $0x18,%esp
  801288:	52                   	push   %edx
  801289:	50                   	push   %eax
  80128a:	89 f2                	mov    %esi,%edx
  80128c:	89 f8                	mov    %edi,%eax
  80128e:	e8 9e ff ff ff       	call   801231 <printnum>
  801293:	83 c4 20             	add    $0x20,%esp
  801296:	eb 11                	jmp    8012a9 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801298:	83 ec 08             	sub    $0x8,%esp
  80129b:	56                   	push   %esi
  80129c:	ff 75 18             	pushl  0x18(%ebp)
  80129f:	ff d7                	call   *%edi
  8012a1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8012a4:	4b                   	dec    %ebx
  8012a5:	85 db                	test   %ebx,%ebx
  8012a7:	7f ef                	jg     801298 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012a9:	83 ec 08             	sub    $0x8,%esp
  8012ac:	56                   	push   %esi
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8012b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8012b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8012bc:	e8 f7 0a 00 00       	call   801db8 <__umoddi3>
  8012c1:	83 c4 14             	add    $0x14,%esp
  8012c4:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  8012cb:	50                   	push   %eax
  8012cc:	ff d7                	call   *%edi
}
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d4:	5b                   	pop    %ebx
  8012d5:	5e                   	pop    %esi
  8012d6:	5f                   	pop    %edi
  8012d7:	5d                   	pop    %ebp
  8012d8:	c3                   	ret    
  8012d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012dc:	eb c6                	jmp    8012a4 <printnum+0x73>

008012de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012e4:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8012e7:	8b 10                	mov    (%eax),%edx
  8012e9:	3b 50 04             	cmp    0x4(%eax),%edx
  8012ec:	73 0a                	jae    8012f8 <sprintputch+0x1a>
		*b->buf++ = ch;
  8012ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f1:	89 08                	mov    %ecx,(%eax)
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	88 02                	mov    %al,(%edx)
}
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <printfmt>:
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801300:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801303:	50                   	push   %eax
  801304:	ff 75 10             	pushl  0x10(%ebp)
  801307:	ff 75 0c             	pushl  0xc(%ebp)
  80130a:	ff 75 08             	pushl  0x8(%ebp)
  80130d:	e8 05 00 00 00       	call   801317 <vprintfmt>
}
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <vprintfmt>:
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	57                   	push   %edi
  80131b:	56                   	push   %esi
  80131c:	53                   	push   %ebx
  80131d:	83 ec 2c             	sub    $0x2c,%esp
  801320:	8b 75 08             	mov    0x8(%ebp),%esi
  801323:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801326:	8b 7d 10             	mov    0x10(%ebp),%edi
  801329:	e9 ae 03 00 00       	jmp    8016dc <vprintfmt+0x3c5>
  80132e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801332:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801339:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801340:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801347:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80134c:	8d 47 01             	lea    0x1(%edi),%eax
  80134f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801352:	8a 17                	mov    (%edi),%dl
  801354:	8d 42 dd             	lea    -0x23(%edx),%eax
  801357:	3c 55                	cmp    $0x55,%al
  801359:	0f 87 fe 03 00 00    	ja     80175d <vprintfmt+0x446>
  80135f:	0f b6 c0             	movzbl %al,%eax
  801362:	ff 24 85 80 21 80 00 	jmp    *0x802180(,%eax,4)
  801369:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80136c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801370:	eb da                	jmp    80134c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801375:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801379:	eb d1                	jmp    80134c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80137b:	0f b6 d2             	movzbl %dl,%edx
  80137e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801381:	b8 00 00 00 00       	mov    $0x0,%eax
  801386:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801389:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80138c:	01 c0                	add    %eax,%eax
  80138e:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  801392:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801395:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801398:	83 f9 09             	cmp    $0x9,%ecx
  80139b:	77 52                	ja     8013ef <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80139d:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80139e:	eb e9                	jmp    801389 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8013a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ab:	8d 40 04             	lea    0x4(%eax),%eax
  8013ae:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013b8:	79 92                	jns    80134c <vprintfmt+0x35>
				width = precision, precision = -1;
  8013ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013c0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013c7:	eb 83                	jmp    80134c <vprintfmt+0x35>
  8013c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013cd:	78 08                	js     8013d7 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8013cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013d2:	e9 75 ff ff ff       	jmp    80134c <vprintfmt+0x35>
  8013d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013de:	eb ef                	jmp    8013cf <vprintfmt+0xb8>
  8013e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013e3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8013ea:	e9 5d ff ff ff       	jmp    80134c <vprintfmt+0x35>
  8013ef:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013f5:	eb bd                	jmp    8013b4 <vprintfmt+0x9d>
			lflag++;
  8013f7:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013fb:	e9 4c ff ff ff       	jmp    80134c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801400:	8b 45 14             	mov    0x14(%ebp),%eax
  801403:	8d 78 04             	lea    0x4(%eax),%edi
  801406:	83 ec 08             	sub    $0x8,%esp
  801409:	53                   	push   %ebx
  80140a:	ff 30                	pushl  (%eax)
  80140c:	ff d6                	call   *%esi
			break;
  80140e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801411:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801414:	e9 c0 02 00 00       	jmp    8016d9 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  801419:	8b 45 14             	mov    0x14(%ebp),%eax
  80141c:	8d 78 04             	lea    0x4(%eax),%edi
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	85 c0                	test   %eax,%eax
  801423:	78 2a                	js     80144f <vprintfmt+0x138>
  801425:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801427:	83 f8 0f             	cmp    $0xf,%eax
  80142a:	7f 27                	jg     801453 <vprintfmt+0x13c>
  80142c:	8b 04 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%eax
  801433:	85 c0                	test   %eax,%eax
  801435:	74 1c                	je     801453 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  801437:	50                   	push   %eax
  801438:	68 dd 1f 80 00       	push   $0x801fdd
  80143d:	53                   	push   %ebx
  80143e:	56                   	push   %esi
  80143f:	e8 b6 fe ff ff       	call   8012fa <printfmt>
  801444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80144a:	e9 8a 02 00 00       	jmp    8016d9 <vprintfmt+0x3c2>
  80144f:	f7 d8                	neg    %eax
  801451:	eb d2                	jmp    801425 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801453:	52                   	push   %edx
  801454:	68 5f 20 80 00       	push   $0x80205f
  801459:	53                   	push   %ebx
  80145a:	56                   	push   %esi
  80145b:	e8 9a fe ff ff       	call   8012fa <printfmt>
  801460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801463:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801466:	e9 6e 02 00 00       	jmp    8016d9 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80146b:	8b 45 14             	mov    0x14(%ebp),%eax
  80146e:	83 c0 04             	add    $0x4,%eax
  801471:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801474:	8b 45 14             	mov    0x14(%ebp),%eax
  801477:	8b 38                	mov    (%eax),%edi
  801479:	85 ff                	test   %edi,%edi
  80147b:	74 39                	je     8014b6 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80147d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801481:	0f 8e a9 00 00 00    	jle    801530 <vprintfmt+0x219>
  801487:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80148b:	0f 84 a7 00 00 00    	je     801538 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 d0             	pushl  -0x30(%ebp)
  801497:	57                   	push   %edi
  801498:	e8 6b 03 00 00       	call   801808 <strnlen>
  80149d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014a0:	29 c1                	sub    %eax,%ecx
  8014a2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8014a5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8014a8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8014ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014af:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014b2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014b4:	eb 14                	jmp    8014ca <vprintfmt+0x1b3>
				p = "(null)";
  8014b6:	bf 58 20 80 00       	mov    $0x802058,%edi
  8014bb:	eb c0                	jmp    80147d <vprintfmt+0x166>
					putch(padc, putdat);
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	53                   	push   %ebx
  8014c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8014c4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014c6:	4f                   	dec    %edi
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 ff                	test   %edi,%edi
  8014cc:	7f ef                	jg     8014bd <vprintfmt+0x1a6>
  8014ce:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8014d1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014d4:	89 c8                	mov    %ecx,%eax
  8014d6:	85 c9                	test   %ecx,%ecx
  8014d8:	78 10                	js     8014ea <vprintfmt+0x1d3>
  8014da:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014dd:	29 c1                	sub    %eax,%ecx
  8014df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8014e2:	89 75 08             	mov    %esi,0x8(%ebp)
  8014e5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8014e8:	eb 15                	jmp    8014ff <vprintfmt+0x1e8>
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ef:	eb e9                	jmp    8014da <vprintfmt+0x1c3>
					putch(ch, putdat);
  8014f1:	83 ec 08             	sub    $0x8,%esp
  8014f4:	53                   	push   %ebx
  8014f5:	52                   	push   %edx
  8014f6:	ff 55 08             	call   *0x8(%ebp)
  8014f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014fc:	ff 4d e0             	decl   -0x20(%ebp)
  8014ff:	47                   	inc    %edi
  801500:	8a 47 ff             	mov    -0x1(%edi),%al
  801503:	0f be d0             	movsbl %al,%edx
  801506:	85 d2                	test   %edx,%edx
  801508:	74 59                	je     801563 <vprintfmt+0x24c>
  80150a:	85 f6                	test   %esi,%esi
  80150c:	78 03                	js     801511 <vprintfmt+0x1fa>
  80150e:	4e                   	dec    %esi
  80150f:	78 2f                	js     801540 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801511:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801515:	74 da                	je     8014f1 <vprintfmt+0x1da>
  801517:	0f be c0             	movsbl %al,%eax
  80151a:	83 e8 20             	sub    $0x20,%eax
  80151d:	83 f8 5e             	cmp    $0x5e,%eax
  801520:	76 cf                	jbe    8014f1 <vprintfmt+0x1da>
					putch('?', putdat);
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	53                   	push   %ebx
  801526:	6a 3f                	push   $0x3f
  801528:	ff 55 08             	call   *0x8(%ebp)
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	eb cc                	jmp    8014fc <vprintfmt+0x1e5>
  801530:	89 75 08             	mov    %esi,0x8(%ebp)
  801533:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801536:	eb c7                	jmp    8014ff <vprintfmt+0x1e8>
  801538:	89 75 08             	mov    %esi,0x8(%ebp)
  80153b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80153e:	eb bf                	jmp    8014ff <vprintfmt+0x1e8>
  801540:	8b 75 08             	mov    0x8(%ebp),%esi
  801543:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801546:	eb 0c                	jmp    801554 <vprintfmt+0x23d>
				putch(' ', putdat);
  801548:	83 ec 08             	sub    $0x8,%esp
  80154b:	53                   	push   %ebx
  80154c:	6a 20                	push   $0x20
  80154e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801550:	4f                   	dec    %edi
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 ff                	test   %edi,%edi
  801556:	7f f0                	jg     801548 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  801558:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80155b:	89 45 14             	mov    %eax,0x14(%ebp)
  80155e:	e9 76 01 00 00       	jmp    8016d9 <vprintfmt+0x3c2>
  801563:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801566:	8b 75 08             	mov    0x8(%ebp),%esi
  801569:	eb e9                	jmp    801554 <vprintfmt+0x23d>
	if (lflag >= 2)
  80156b:	83 f9 01             	cmp    $0x1,%ecx
  80156e:	7f 1f                	jg     80158f <vprintfmt+0x278>
	else if (lflag)
  801570:	85 c9                	test   %ecx,%ecx
  801572:	75 48                	jne    8015bc <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80157c:	89 c1                	mov    %eax,%ecx
  80157e:	c1 f9 1f             	sar    $0x1f,%ecx
  801581:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801584:	8b 45 14             	mov    0x14(%ebp),%eax
  801587:	8d 40 04             	lea    0x4(%eax),%eax
  80158a:	89 45 14             	mov    %eax,0x14(%ebp)
  80158d:	eb 17                	jmp    8015a6 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80158f:	8b 45 14             	mov    0x14(%ebp),%eax
  801592:	8b 50 04             	mov    0x4(%eax),%edx
  801595:	8b 00                	mov    (%eax),%eax
  801597:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80159a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80159d:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a0:	8d 40 08             	lea    0x8(%eax),%eax
  8015a3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8015a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8015ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015b0:	78 25                	js     8015d7 <vprintfmt+0x2c0>
			base = 10;
  8015b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015b7:	e9 03 01 00 00       	jmp    8016bf <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bf:	8b 00                	mov    (%eax),%eax
  8015c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015c4:	89 c1                	mov    %eax,%ecx
  8015c6:	c1 f9 1f             	sar    $0x1f,%ecx
  8015c9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cf:	8d 40 04             	lea    0x4(%eax),%eax
  8015d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8015d5:	eb cf                	jmp    8015a6 <vprintfmt+0x28f>
				putch('-', putdat);
  8015d7:	83 ec 08             	sub    $0x8,%esp
  8015da:	53                   	push   %ebx
  8015db:	6a 2d                	push   $0x2d
  8015dd:	ff d6                	call   *%esi
				num = -(long long) num;
  8015df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015e2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8015e5:	f7 da                	neg    %edx
  8015e7:	83 d1 00             	adc    $0x0,%ecx
  8015ea:	f7 d9                	neg    %ecx
  8015ec:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8015ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015f4:	e9 c6 00 00 00       	jmp    8016bf <vprintfmt+0x3a8>
	if (lflag >= 2)
  8015f9:	83 f9 01             	cmp    $0x1,%ecx
  8015fc:	7f 1e                	jg     80161c <vprintfmt+0x305>
	else if (lflag)
  8015fe:	85 c9                	test   %ecx,%ecx
  801600:	75 32                	jne    801634 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  801602:	8b 45 14             	mov    0x14(%ebp),%eax
  801605:	8b 10                	mov    (%eax),%edx
  801607:	b9 00 00 00 00       	mov    $0x0,%ecx
  80160c:	8d 40 04             	lea    0x4(%eax),%eax
  80160f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801612:	b8 0a 00 00 00       	mov    $0xa,%eax
  801617:	e9 a3 00 00 00       	jmp    8016bf <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80161c:	8b 45 14             	mov    0x14(%ebp),%eax
  80161f:	8b 10                	mov    (%eax),%edx
  801621:	8b 48 04             	mov    0x4(%eax),%ecx
  801624:	8d 40 08             	lea    0x8(%eax),%eax
  801627:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80162a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80162f:	e9 8b 00 00 00       	jmp    8016bf <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801634:	8b 45 14             	mov    0x14(%ebp),%eax
  801637:	8b 10                	mov    (%eax),%edx
  801639:	b9 00 00 00 00       	mov    $0x0,%ecx
  80163e:	8d 40 04             	lea    0x4(%eax),%eax
  801641:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801644:	b8 0a 00 00 00       	mov    $0xa,%eax
  801649:	eb 74                	jmp    8016bf <vprintfmt+0x3a8>
	if (lflag >= 2)
  80164b:	83 f9 01             	cmp    $0x1,%ecx
  80164e:	7f 1b                	jg     80166b <vprintfmt+0x354>
	else if (lflag)
  801650:	85 c9                	test   %ecx,%ecx
  801652:	75 2c                	jne    801680 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801654:	8b 45 14             	mov    0x14(%ebp),%eax
  801657:	8b 10                	mov    (%eax),%edx
  801659:	b9 00 00 00 00       	mov    $0x0,%ecx
  80165e:	8d 40 04             	lea    0x4(%eax),%eax
  801661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801664:	b8 08 00 00 00       	mov    $0x8,%eax
  801669:	eb 54                	jmp    8016bf <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80166b:	8b 45 14             	mov    0x14(%ebp),%eax
  80166e:	8b 10                	mov    (%eax),%edx
  801670:	8b 48 04             	mov    0x4(%eax),%ecx
  801673:	8d 40 08             	lea    0x8(%eax),%eax
  801676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801679:	b8 08 00 00 00       	mov    $0x8,%eax
  80167e:	eb 3f                	jmp    8016bf <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801680:	8b 45 14             	mov    0x14(%ebp),%eax
  801683:	8b 10                	mov    (%eax),%edx
  801685:	b9 00 00 00 00       	mov    $0x0,%ecx
  80168a:	8d 40 04             	lea    0x4(%eax),%eax
  80168d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801690:	b8 08 00 00 00       	mov    $0x8,%eax
  801695:	eb 28                	jmp    8016bf <vprintfmt+0x3a8>
			putch('0', putdat);
  801697:	83 ec 08             	sub    $0x8,%esp
  80169a:	53                   	push   %ebx
  80169b:	6a 30                	push   $0x30
  80169d:	ff d6                	call   *%esi
			putch('x', putdat);
  80169f:	83 c4 08             	add    $0x8,%esp
  8016a2:	53                   	push   %ebx
  8016a3:	6a 78                	push   $0x78
  8016a5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8016a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016aa:	8b 10                	mov    (%eax),%edx
  8016ac:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016b1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016b4:	8d 40 04             	lea    0x4(%eax),%eax
  8016b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016ba:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016bf:	83 ec 0c             	sub    $0xc,%esp
  8016c2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016c6:	57                   	push   %edi
  8016c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8016ca:	50                   	push   %eax
  8016cb:	51                   	push   %ecx
  8016cc:	52                   	push   %edx
  8016cd:	89 da                	mov    %ebx,%edx
  8016cf:	89 f0                	mov    %esi,%eax
  8016d1:	e8 5b fb ff ff       	call   801231 <printnum>
			break;
  8016d6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8016d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016dc:	47                   	inc    %edi
  8016dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016e1:	83 f8 25             	cmp    $0x25,%eax
  8016e4:	0f 84 44 fc ff ff    	je     80132e <vprintfmt+0x17>
			if (ch == '\0')
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	0f 84 89 00 00 00    	je     80177b <vprintfmt+0x464>
			putch(ch, putdat);
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	53                   	push   %ebx
  8016f6:	50                   	push   %eax
  8016f7:	ff d6                	call   *%esi
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	eb de                	jmp    8016dc <vprintfmt+0x3c5>
	if (lflag >= 2)
  8016fe:	83 f9 01             	cmp    $0x1,%ecx
  801701:	7f 1b                	jg     80171e <vprintfmt+0x407>
	else if (lflag)
  801703:	85 c9                	test   %ecx,%ecx
  801705:	75 2c                	jne    801733 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  801707:	8b 45 14             	mov    0x14(%ebp),%eax
  80170a:	8b 10                	mov    (%eax),%edx
  80170c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801711:	8d 40 04             	lea    0x4(%eax),%eax
  801714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801717:	b8 10 00 00 00       	mov    $0x10,%eax
  80171c:	eb a1                	jmp    8016bf <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 10                	mov    (%eax),%edx
  801723:	8b 48 04             	mov    0x4(%eax),%ecx
  801726:	8d 40 08             	lea    0x8(%eax),%eax
  801729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80172c:	b8 10 00 00 00       	mov    $0x10,%eax
  801731:	eb 8c                	jmp    8016bf <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801733:	8b 45 14             	mov    0x14(%ebp),%eax
  801736:	8b 10                	mov    (%eax),%edx
  801738:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173d:	8d 40 04             	lea    0x4(%eax),%eax
  801740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801743:	b8 10 00 00 00       	mov    $0x10,%eax
  801748:	e9 72 ff ff ff       	jmp    8016bf <vprintfmt+0x3a8>
			putch(ch, putdat);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	53                   	push   %ebx
  801751:	6a 25                	push   $0x25
  801753:	ff d6                	call   *%esi
			break;
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	e9 7c ff ff ff       	jmp    8016d9 <vprintfmt+0x3c2>
			putch('%', putdat);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	53                   	push   %ebx
  801761:	6a 25                	push   $0x25
  801763:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	89 f8                	mov    %edi,%eax
  80176a:	eb 01                	jmp    80176d <vprintfmt+0x456>
  80176c:	48                   	dec    %eax
  80176d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801771:	75 f9                	jne    80176c <vprintfmt+0x455>
  801773:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801776:	e9 5e ff ff ff       	jmp    8016d9 <vprintfmt+0x3c2>
}
  80177b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177e:	5b                   	pop    %ebx
  80177f:	5e                   	pop    %esi
  801780:	5f                   	pop    %edi
  801781:	5d                   	pop    %ebp
  801782:	c3                   	ret    

00801783 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 18             	sub    $0x18,%esp
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80178f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801792:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801796:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	74 26                	je     8017ca <vsnprintf+0x47>
  8017a4:	85 d2                	test   %edx,%edx
  8017a6:	7e 29                	jle    8017d1 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017a8:	ff 75 14             	pushl  0x14(%ebp)
  8017ab:	ff 75 10             	pushl  0x10(%ebp)
  8017ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b1:	50                   	push   %eax
  8017b2:	68 de 12 80 00       	push   $0x8012de
  8017b7:	e8 5b fb ff ff       	call   801317 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c5:	83 c4 10             	add    $0x10,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    
		return -E_INVAL;
  8017ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cf:	eb f7                	jmp    8017c8 <vsnprintf+0x45>
  8017d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d6:	eb f0                	jmp    8017c8 <vsnprintf+0x45>

008017d8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017de:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017e1:	50                   	push   %eax
  8017e2:	ff 75 10             	pushl  0x10(%ebp)
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	e8 93 ff ff ff       	call   801783 <vsnprintf>
	va_end(ap);

	return rc;
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fd:	eb 01                	jmp    801800 <strlen+0xe>
		n++;
  8017ff:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  801800:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801804:	75 f9                	jne    8017ff <strlen+0xd>
	return n;
}
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    

00801808 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801811:	b8 00 00 00 00       	mov    $0x0,%eax
  801816:	eb 01                	jmp    801819 <strnlen+0x11>
		n++;
  801818:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801819:	39 d0                	cmp    %edx,%eax
  80181b:	74 06                	je     801823 <strnlen+0x1b>
  80181d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801821:	75 f5                	jne    801818 <strnlen+0x10>
	return n;
}
  801823:	5d                   	pop    %ebp
  801824:	c3                   	ret    

00801825 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	53                   	push   %ebx
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80182f:	89 c2                	mov    %eax,%edx
  801831:	42                   	inc    %edx
  801832:	41                   	inc    %ecx
  801833:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801836:	88 5a ff             	mov    %bl,-0x1(%edx)
  801839:	84 db                	test   %bl,%bl
  80183b:	75 f4                	jne    801831 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80183d:	5b                   	pop    %ebx
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	53                   	push   %ebx
  801844:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801847:	53                   	push   %ebx
  801848:	e8 a5 ff ff ff       	call   8017f2 <strlen>
  80184d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	01 d8                	add    %ebx,%eax
  801855:	50                   	push   %eax
  801856:	e8 ca ff ff ff       	call   801825 <strcpy>
	return dst;
}
  80185b:	89 d8                	mov    %ebx,%eax
  80185d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	56                   	push   %esi
  801866:	53                   	push   %ebx
  801867:	8b 75 08             	mov    0x8(%ebp),%esi
  80186a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80186d:	89 f3                	mov    %esi,%ebx
  80186f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801872:	89 f2                	mov    %esi,%edx
  801874:	eb 0c                	jmp    801882 <strncpy+0x20>
		*dst++ = *src;
  801876:	42                   	inc    %edx
  801877:	8a 01                	mov    (%ecx),%al
  801879:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80187c:	80 39 01             	cmpb   $0x1,(%ecx)
  80187f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801882:	39 da                	cmp    %ebx,%edx
  801884:	75 f0                	jne    801876 <strncpy+0x14>
	}
	return ret;
}
  801886:	89 f0                	mov    %esi,%eax
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	8b 75 08             	mov    0x8(%ebp),%esi
  801894:	8b 55 0c             	mov    0xc(%ebp),%edx
  801897:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80189a:	85 c0                	test   %eax,%eax
  80189c:	74 20                	je     8018be <strlcpy+0x32>
  80189e:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8018a2:	89 f0                	mov    %esi,%eax
  8018a4:	eb 05                	jmp    8018ab <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8018a6:	40                   	inc    %eax
  8018a7:	42                   	inc    %edx
  8018a8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8018ab:	39 d8                	cmp    %ebx,%eax
  8018ad:	74 06                	je     8018b5 <strlcpy+0x29>
  8018af:	8a 0a                	mov    (%edx),%cl
  8018b1:	84 c9                	test   %cl,%cl
  8018b3:	75 f1                	jne    8018a6 <strlcpy+0x1a>
		*dst = '\0';
  8018b5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018b8:	29 f0                	sub    %esi,%eax
}
  8018ba:	5b                   	pop    %ebx
  8018bb:	5e                   	pop    %esi
  8018bc:	5d                   	pop    %ebp
  8018bd:	c3                   	ret    
  8018be:	89 f0                	mov    %esi,%eax
  8018c0:	eb f6                	jmp    8018b8 <strlcpy+0x2c>

008018c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018cb:	eb 02                	jmp    8018cf <strcmp+0xd>
		p++, q++;
  8018cd:	41                   	inc    %ecx
  8018ce:	42                   	inc    %edx
	while (*p && *p == *q)
  8018cf:	8a 01                	mov    (%ecx),%al
  8018d1:	84 c0                	test   %al,%al
  8018d3:	74 04                	je     8018d9 <strcmp+0x17>
  8018d5:	3a 02                	cmp    (%edx),%al
  8018d7:	74 f4                	je     8018cd <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d9:	0f b6 c0             	movzbl %al,%eax
  8018dc:	0f b6 12             	movzbl (%edx),%edx
  8018df:	29 d0                	sub    %edx,%eax
}
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	53                   	push   %ebx
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ed:	89 c3                	mov    %eax,%ebx
  8018ef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018f2:	eb 02                	jmp    8018f6 <strncmp+0x13>
		n--, p++, q++;
  8018f4:	40                   	inc    %eax
  8018f5:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8018f6:	39 d8                	cmp    %ebx,%eax
  8018f8:	74 15                	je     80190f <strncmp+0x2c>
  8018fa:	8a 08                	mov    (%eax),%cl
  8018fc:	84 c9                	test   %cl,%cl
  8018fe:	74 04                	je     801904 <strncmp+0x21>
  801900:	3a 0a                	cmp    (%edx),%cl
  801902:	74 f0                	je     8018f4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801904:	0f b6 00             	movzbl (%eax),%eax
  801907:	0f b6 12             	movzbl (%edx),%edx
  80190a:	29 d0                	sub    %edx,%eax
}
  80190c:	5b                   	pop    %ebx
  80190d:	5d                   	pop    %ebp
  80190e:	c3                   	ret    
		return 0;
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
  801914:	eb f6                	jmp    80190c <strncmp+0x29>

00801916 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80191f:	8a 10                	mov    (%eax),%dl
  801921:	84 d2                	test   %dl,%dl
  801923:	74 07                	je     80192c <strchr+0x16>
		if (*s == c)
  801925:	38 ca                	cmp    %cl,%dl
  801927:	74 08                	je     801931 <strchr+0x1b>
	for (; *s; s++)
  801929:	40                   	inc    %eax
  80192a:	eb f3                	jmp    80191f <strchr+0x9>
			return (char *) s;
	return 0;
  80192c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80193c:	8a 10                	mov    (%eax),%dl
  80193e:	84 d2                	test   %dl,%dl
  801940:	74 07                	je     801949 <strfind+0x16>
		if (*s == c)
  801942:	38 ca                	cmp    %cl,%dl
  801944:	74 03                	je     801949 <strfind+0x16>
	for (; *s; s++)
  801946:	40                   	inc    %eax
  801947:	eb f3                	jmp    80193c <strfind+0x9>
			break;
	return (char *) s;
}
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    

0080194b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	57                   	push   %edi
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	8b 7d 08             	mov    0x8(%ebp),%edi
  801954:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801957:	85 c9                	test   %ecx,%ecx
  801959:	74 13                	je     80196e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80195b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801961:	75 05                	jne    801968 <memset+0x1d>
  801963:	f6 c1 03             	test   $0x3,%cl
  801966:	74 0d                	je     801975 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196b:	fc                   	cld    
  80196c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80196e:	89 f8                	mov    %edi,%eax
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5f                   	pop    %edi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    
		c &= 0xFF;
  801975:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801979:	89 d3                	mov    %edx,%ebx
  80197b:	c1 e3 08             	shl    $0x8,%ebx
  80197e:	89 d0                	mov    %edx,%eax
  801980:	c1 e0 18             	shl    $0x18,%eax
  801983:	89 d6                	mov    %edx,%esi
  801985:	c1 e6 10             	shl    $0x10,%esi
  801988:	09 f0                	or     %esi,%eax
  80198a:	09 c2                	or     %eax,%edx
  80198c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80198e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801991:	89 d0                	mov    %edx,%eax
  801993:	fc                   	cld    
  801994:	f3 ab                	rep stos %eax,%es:(%edi)
  801996:	eb d6                	jmp    80196e <memset+0x23>

00801998 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	57                   	push   %edi
  80199c:	56                   	push   %esi
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019a6:	39 c6                	cmp    %eax,%esi
  8019a8:	73 33                	jae    8019dd <memmove+0x45>
  8019aa:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019ad:	39 d0                	cmp    %edx,%eax
  8019af:	73 2c                	jae    8019dd <memmove+0x45>
		s += n;
		d += n;
  8019b1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019b4:	89 d6                	mov    %edx,%esi
  8019b6:	09 fe                	or     %edi,%esi
  8019b8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019be:	75 13                	jne    8019d3 <memmove+0x3b>
  8019c0:	f6 c1 03             	test   $0x3,%cl
  8019c3:	75 0e                	jne    8019d3 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019c5:	83 ef 04             	sub    $0x4,%edi
  8019c8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019cb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019ce:	fd                   	std    
  8019cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019d1:	eb 07                	jmp    8019da <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019d3:	4f                   	dec    %edi
  8019d4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019d7:	fd                   	std    
  8019d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019da:	fc                   	cld    
  8019db:	eb 13                	jmp    8019f0 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019dd:	89 f2                	mov    %esi,%edx
  8019df:	09 c2                	or     %eax,%edx
  8019e1:	f6 c2 03             	test   $0x3,%dl
  8019e4:	75 05                	jne    8019eb <memmove+0x53>
  8019e6:	f6 c1 03             	test   $0x3,%cl
  8019e9:	74 09                	je     8019f4 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019eb:	89 c7                	mov    %eax,%edi
  8019ed:	fc                   	cld    
  8019ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019f0:	5e                   	pop    %esi
  8019f1:	5f                   	pop    %edi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019f4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019f7:	89 c7                	mov    %eax,%edi
  8019f9:	fc                   	cld    
  8019fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019fc:	eb f2                	jmp    8019f0 <memmove+0x58>

008019fe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801a01:	ff 75 10             	pushl  0x10(%ebp)
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	ff 75 08             	pushl  0x8(%ebp)
  801a0a:	e8 89 ff ff ff       	call   801998 <memmove>
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	56                   	push   %esi
  801a15:	53                   	push   %ebx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 c6                	mov    %eax,%esi
  801a1b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a21:	39 f0                	cmp    %esi,%eax
  801a23:	74 16                	je     801a3b <memcmp+0x2a>
		if (*s1 != *s2)
  801a25:	8a 08                	mov    (%eax),%cl
  801a27:	8a 1a                	mov    (%edx),%bl
  801a29:	38 d9                	cmp    %bl,%cl
  801a2b:	75 04                	jne    801a31 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a2d:	40                   	inc    %eax
  801a2e:	42                   	inc    %edx
  801a2f:	eb f0                	jmp    801a21 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a31:	0f b6 c1             	movzbl %cl,%eax
  801a34:	0f b6 db             	movzbl %bl,%ebx
  801a37:	29 d8                	sub    %ebx,%eax
  801a39:	eb 05                	jmp    801a40 <memcmp+0x2f>
	}

	return 0;
  801a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a40:	5b                   	pop    %ebx
  801a41:	5e                   	pop    %esi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    

00801a44 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a4d:	89 c2                	mov    %eax,%edx
  801a4f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a52:	39 d0                	cmp    %edx,%eax
  801a54:	73 07                	jae    801a5d <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a56:	38 08                	cmp    %cl,(%eax)
  801a58:	74 03                	je     801a5d <memfind+0x19>
	for (; s < ends; s++)
  801a5a:	40                   	inc    %eax
  801a5b:	eb f5                	jmp    801a52 <memfind+0xe>
			break;
	return (void *) s;
}
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	57                   	push   %edi
  801a63:	56                   	push   %esi
  801a64:	53                   	push   %ebx
  801a65:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a68:	eb 01                	jmp    801a6b <strtol+0xc>
		s++;
  801a6a:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a6b:	8a 01                	mov    (%ecx),%al
  801a6d:	3c 20                	cmp    $0x20,%al
  801a6f:	74 f9                	je     801a6a <strtol+0xb>
  801a71:	3c 09                	cmp    $0x9,%al
  801a73:	74 f5                	je     801a6a <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801a75:	3c 2b                	cmp    $0x2b,%al
  801a77:	74 2b                	je     801aa4 <strtol+0x45>
		s++;
	else if (*s == '-')
  801a79:	3c 2d                	cmp    $0x2d,%al
  801a7b:	74 2f                	je     801aac <strtol+0x4d>
	int neg = 0;
  801a7d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a82:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801a89:	75 12                	jne    801a9d <strtol+0x3e>
  801a8b:	80 39 30             	cmpb   $0x30,(%ecx)
  801a8e:	74 24                	je     801ab4 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801a90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a94:	75 07                	jne    801a9d <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a96:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa2:	eb 4e                	jmp    801af2 <strtol+0x93>
		s++;
  801aa4:	41                   	inc    %ecx
	int neg = 0;
  801aa5:	bf 00 00 00 00       	mov    $0x0,%edi
  801aaa:	eb d6                	jmp    801a82 <strtol+0x23>
		s++, neg = 1;
  801aac:	41                   	inc    %ecx
  801aad:	bf 01 00 00 00       	mov    $0x1,%edi
  801ab2:	eb ce                	jmp    801a82 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ab4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ab8:	74 10                	je     801aca <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801aba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801abe:	75 dd                	jne    801a9d <strtol+0x3e>
		s++, base = 8;
  801ac0:	41                   	inc    %ecx
  801ac1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801ac8:	eb d3                	jmp    801a9d <strtol+0x3e>
		s += 2, base = 16;
  801aca:	83 c1 02             	add    $0x2,%ecx
  801acd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ad4:	eb c7                	jmp    801a9d <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801ad6:	8d 72 9f             	lea    -0x61(%edx),%esi
  801ad9:	89 f3                	mov    %esi,%ebx
  801adb:	80 fb 19             	cmp    $0x19,%bl
  801ade:	77 24                	ja     801b04 <strtol+0xa5>
			dig = *s - 'a' + 10;
  801ae0:	0f be d2             	movsbl %dl,%edx
  801ae3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ae6:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ae9:	7d 2b                	jge    801b16 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801aeb:	41                   	inc    %ecx
  801aec:	0f af 45 10          	imul   0x10(%ebp),%eax
  801af0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801af2:	8a 11                	mov    (%ecx),%dl
  801af4:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801af7:	80 fb 09             	cmp    $0x9,%bl
  801afa:	77 da                	ja     801ad6 <strtol+0x77>
			dig = *s - '0';
  801afc:	0f be d2             	movsbl %dl,%edx
  801aff:	83 ea 30             	sub    $0x30,%edx
  801b02:	eb e2                	jmp    801ae6 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801b04:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b07:	89 f3                	mov    %esi,%ebx
  801b09:	80 fb 19             	cmp    $0x19,%bl
  801b0c:	77 08                	ja     801b16 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b0e:	0f be d2             	movsbl %dl,%edx
  801b11:	83 ea 37             	sub    $0x37,%edx
  801b14:	eb d0                	jmp    801ae6 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b1a:	74 05                	je     801b21 <strtol+0xc2>
		*endptr = (char *) s;
  801b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b21:	85 ff                	test   %edi,%edi
  801b23:	74 02                	je     801b27 <strtol+0xc8>
  801b25:	f7 d8                	neg    %eax
}
  801b27:	5b                   	pop    %ebx
  801b28:	5e                   	pop    %esi
  801b29:	5f                   	pop    %edi
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    

00801b2c <atoi>:

int
atoi(const char *s)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b2f:	6a 0a                	push   $0xa
  801b31:	6a 00                	push   $0x0
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	e8 24 ff ff ff       	call   801a5f <strtol>
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	57                   	push   %edi
  801b41:	56                   	push   %esi
  801b42:	53                   	push   %ebx
  801b43:	83 ec 0c             	sub    $0xc,%esp
  801b46:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b49:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b4c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b4f:	85 ff                	test   %edi,%edi
  801b51:	74 53                	je     801ba6 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b53:	83 ec 0c             	sub    $0xc,%esp
  801b56:	57                   	push   %edi
  801b57:	e8 fe e7 ff ff       	call   80035a <sys_ipc_recv>
  801b5c:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b5f:	85 db                	test   %ebx,%ebx
  801b61:	74 0b                	je     801b6e <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b63:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b69:	8b 52 74             	mov    0x74(%edx),%edx
  801b6c:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b6e:	85 f6                	test   %esi,%esi
  801b70:	74 0f                	je     801b81 <ipc_recv+0x44>
  801b72:	85 ff                	test   %edi,%edi
  801b74:	74 0b                	je     801b81 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b76:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b7c:	8b 52 78             	mov    0x78(%edx),%edx
  801b7f:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b81:	85 c0                	test   %eax,%eax
  801b83:	74 30                	je     801bb5 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b85:	85 db                	test   %ebx,%ebx
  801b87:	74 06                	je     801b8f <ipc_recv+0x52>
      		*from_env_store = 0;
  801b89:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801b8f:	85 f6                	test   %esi,%esi
  801b91:	74 2c                	je     801bbf <ipc_recv+0x82>
      		*perm_store = 0;
  801b93:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba1:	5b                   	pop    %ebx
  801ba2:	5e                   	pop    %esi
  801ba3:	5f                   	pop    %edi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801ba6:	83 ec 0c             	sub    $0xc,%esp
  801ba9:	6a ff                	push   $0xffffffff
  801bab:	e8 aa e7 ff ff       	call   80035a <sys_ipc_recv>
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	eb aa                	jmp    801b5f <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bb5:	a1 04 40 80 00       	mov    0x804004,%eax
  801bba:	8b 40 70             	mov    0x70(%eax),%eax
  801bbd:	eb df                	jmp    801b9e <ipc_recv+0x61>
		return -1;
  801bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bc4:	eb d8                	jmp    801b9e <ipc_recv+0x61>

00801bc6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	57                   	push   %edi
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 0c             	sub    $0xc,%esp
  801bcf:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bd5:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bd8:	85 db                	test   %ebx,%ebx
  801bda:	75 22                	jne    801bfe <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bdc:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801be1:	eb 1b                	jmp    801bfe <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801be3:	68 40 23 80 00       	push   $0x802340
  801be8:	68 cb 1f 80 00       	push   $0x801fcb
  801bed:	6a 48                	push   $0x48
  801bef:	68 64 23 80 00       	push   $0x802364
  801bf4:	e8 11 f5 ff ff       	call   80110a <_panic>
		sys_yield();
  801bf9:	e8 13 e6 ff ff       	call   800211 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801bfe:	57                   	push   %edi
  801bff:	53                   	push   %ebx
  801c00:	56                   	push   %esi
  801c01:	ff 75 08             	pushl  0x8(%ebp)
  801c04:	e8 2e e7 ff ff       	call   800337 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c0f:	74 e8                	je     801bf9 <ipc_send+0x33>
  801c11:	85 c0                	test   %eax,%eax
  801c13:	75 ce                	jne    801be3 <ipc_send+0x1d>
		sys_yield();
  801c15:	e8 f7 e5 ff ff       	call   800211 <sys_yield>
		
	}
	
}
  801c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5f                   	pop    %edi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    

00801c22 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c28:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c2d:	89 c2                	mov    %eax,%edx
  801c2f:	c1 e2 05             	shl    $0x5,%edx
  801c32:	29 c2                	sub    %eax,%edx
  801c34:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c3b:	8b 52 50             	mov    0x50(%edx),%edx
  801c3e:	39 ca                	cmp    %ecx,%edx
  801c40:	74 0f                	je     801c51 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c42:	40                   	inc    %eax
  801c43:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c48:	75 e3                	jne    801c2d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4f:	eb 11                	jmp    801c62 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c51:	89 c2                	mov    %eax,%edx
  801c53:	c1 e2 05             	shl    $0x5,%edx
  801c56:	29 c2                	sub    %eax,%edx
  801c58:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c5f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    

00801c64 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	c1 e8 16             	shr    $0x16,%eax
  801c6d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c74:	a8 01                	test   $0x1,%al
  801c76:	74 21                	je     801c99 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	c1 e8 0c             	shr    $0xc,%eax
  801c7e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c85:	a8 01                	test   $0x1,%al
  801c87:	74 17                	je     801ca0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c89:	c1 e8 0c             	shr    $0xc,%eax
  801c8c:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c93:	ef 
  801c94:	0f b7 c0             	movzwl %ax,%eax
  801c97:	eb 05                	jmp    801c9e <pageref+0x3a>
		return 0;
  801c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    
		return 0;
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca5:	eb f7                	jmp    801c9e <pageref+0x3a>
  801ca7:	90                   	nop

00801ca8 <__udivdi3>:
  801ca8:	55                   	push   %ebp
  801ca9:	57                   	push   %edi
  801caa:	56                   	push   %esi
  801cab:	53                   	push   %ebx
  801cac:	83 ec 1c             	sub    $0x1c,%esp
  801caf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cb3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cbb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cbf:	89 ca                	mov    %ecx,%edx
  801cc1:	89 f8                	mov    %edi,%eax
  801cc3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cc7:	85 f6                	test   %esi,%esi
  801cc9:	75 2d                	jne    801cf8 <__udivdi3+0x50>
  801ccb:	39 cf                	cmp    %ecx,%edi
  801ccd:	77 65                	ja     801d34 <__udivdi3+0x8c>
  801ccf:	89 fd                	mov    %edi,%ebp
  801cd1:	85 ff                	test   %edi,%edi
  801cd3:	75 0b                	jne    801ce0 <__udivdi3+0x38>
  801cd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cda:	31 d2                	xor    %edx,%edx
  801cdc:	f7 f7                	div    %edi
  801cde:	89 c5                	mov    %eax,%ebp
  801ce0:	31 d2                	xor    %edx,%edx
  801ce2:	89 c8                	mov    %ecx,%eax
  801ce4:	f7 f5                	div    %ebp
  801ce6:	89 c1                	mov    %eax,%ecx
  801ce8:	89 d8                	mov    %ebx,%eax
  801cea:	f7 f5                	div    %ebp
  801cec:	89 cf                	mov    %ecx,%edi
  801cee:	89 fa                	mov    %edi,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	39 ce                	cmp    %ecx,%esi
  801cfa:	77 28                	ja     801d24 <__udivdi3+0x7c>
  801cfc:	0f bd fe             	bsr    %esi,%edi
  801cff:	83 f7 1f             	xor    $0x1f,%edi
  801d02:	75 40                	jne    801d44 <__udivdi3+0x9c>
  801d04:	39 ce                	cmp    %ecx,%esi
  801d06:	72 0a                	jb     801d12 <__udivdi3+0x6a>
  801d08:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d0c:	0f 87 9e 00 00 00    	ja     801db0 <__udivdi3+0x108>
  801d12:	b8 01 00 00 00       	mov    $0x1,%eax
  801d17:	89 fa                	mov    %edi,%edx
  801d19:	83 c4 1c             	add    $0x1c,%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5f                   	pop    %edi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    
  801d21:	8d 76 00             	lea    0x0(%esi),%esi
  801d24:	31 ff                	xor    %edi,%edi
  801d26:	31 c0                	xor    %eax,%eax
  801d28:	89 fa                	mov    %edi,%edx
  801d2a:	83 c4 1c             	add    $0x1c,%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5e                   	pop    %esi
  801d2f:	5f                   	pop    %edi
  801d30:	5d                   	pop    %ebp
  801d31:	c3                   	ret    
  801d32:	66 90                	xchg   %ax,%ax
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	f7 f7                	div    %edi
  801d38:	31 ff                	xor    %edi,%edi
  801d3a:	89 fa                	mov    %edi,%edx
  801d3c:	83 c4 1c             	add    $0x1c,%esp
  801d3f:	5b                   	pop    %ebx
  801d40:	5e                   	pop    %esi
  801d41:	5f                   	pop    %edi
  801d42:	5d                   	pop    %ebp
  801d43:	c3                   	ret    
  801d44:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d49:	29 fd                	sub    %edi,%ebp
  801d4b:	89 f9                	mov    %edi,%ecx
  801d4d:	d3 e6                	shl    %cl,%esi
  801d4f:	89 c3                	mov    %eax,%ebx
  801d51:	89 e9                	mov    %ebp,%ecx
  801d53:	d3 eb                	shr    %cl,%ebx
  801d55:	89 d9                	mov    %ebx,%ecx
  801d57:	09 f1                	or     %esi,%ecx
  801d59:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d5d:	89 f9                	mov    %edi,%ecx
  801d5f:	d3 e0                	shl    %cl,%eax
  801d61:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d65:	89 d6                	mov    %edx,%esi
  801d67:	89 e9                	mov    %ebp,%ecx
  801d69:	d3 ee                	shr    %cl,%esi
  801d6b:	89 f9                	mov    %edi,%ecx
  801d6d:	d3 e2                	shl    %cl,%edx
  801d6f:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d73:	89 e9                	mov    %ebp,%ecx
  801d75:	d3 eb                	shr    %cl,%ebx
  801d77:	09 da                	or     %ebx,%edx
  801d79:	89 d0                	mov    %edx,%eax
  801d7b:	89 f2                	mov    %esi,%edx
  801d7d:	f7 74 24 08          	divl   0x8(%esp)
  801d81:	89 d6                	mov    %edx,%esi
  801d83:	89 c3                	mov    %eax,%ebx
  801d85:	f7 64 24 0c          	mull   0xc(%esp)
  801d89:	39 d6                	cmp    %edx,%esi
  801d8b:	72 17                	jb     801da4 <__udivdi3+0xfc>
  801d8d:	74 09                	je     801d98 <__udivdi3+0xf0>
  801d8f:	89 d8                	mov    %ebx,%eax
  801d91:	31 ff                	xor    %edi,%edi
  801d93:	e9 56 ff ff ff       	jmp    801cee <__udivdi3+0x46>
  801d98:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d9c:	89 f9                	mov    %edi,%ecx
  801d9e:	d3 e2                	shl    %cl,%edx
  801da0:	39 c2                	cmp    %eax,%edx
  801da2:	73 eb                	jae    801d8f <__udivdi3+0xe7>
  801da4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801da7:	31 ff                	xor    %edi,%edi
  801da9:	e9 40 ff ff ff       	jmp    801cee <__udivdi3+0x46>
  801dae:	66 90                	xchg   %ax,%ax
  801db0:	31 c0                	xor    %eax,%eax
  801db2:	e9 37 ff ff ff       	jmp    801cee <__udivdi3+0x46>
  801db7:	90                   	nop

00801db8 <__umoddi3>:
  801db8:	55                   	push   %ebp
  801db9:	57                   	push   %edi
  801dba:	56                   	push   %esi
  801dbb:	53                   	push   %ebx
  801dbc:	83 ec 1c             	sub    $0x1c,%esp
  801dbf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dcf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dd7:	89 3c 24             	mov    %edi,(%esp)
  801dda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dde:	89 f2                	mov    %esi,%edx
  801de0:	85 c0                	test   %eax,%eax
  801de2:	75 18                	jne    801dfc <__umoddi3+0x44>
  801de4:	39 f7                	cmp    %esi,%edi
  801de6:	0f 86 a0 00 00 00    	jbe    801e8c <__umoddi3+0xd4>
  801dec:	89 c8                	mov    %ecx,%eax
  801dee:	f7 f7                	div    %edi
  801df0:	89 d0                	mov    %edx,%eax
  801df2:	31 d2                	xor    %edx,%edx
  801df4:	83 c4 1c             	add    $0x1c,%esp
  801df7:	5b                   	pop    %ebx
  801df8:	5e                   	pop    %esi
  801df9:	5f                   	pop    %edi
  801dfa:	5d                   	pop    %ebp
  801dfb:	c3                   	ret    
  801dfc:	89 f3                	mov    %esi,%ebx
  801dfe:	39 f0                	cmp    %esi,%eax
  801e00:	0f 87 a6 00 00 00    	ja     801eac <__umoddi3+0xf4>
  801e06:	0f bd e8             	bsr    %eax,%ebp
  801e09:	83 f5 1f             	xor    $0x1f,%ebp
  801e0c:	0f 84 a6 00 00 00    	je     801eb8 <__umoddi3+0x100>
  801e12:	bf 20 00 00 00       	mov    $0x20,%edi
  801e17:	29 ef                	sub    %ebp,%edi
  801e19:	89 e9                	mov    %ebp,%ecx
  801e1b:	d3 e0                	shl    %cl,%eax
  801e1d:	8b 34 24             	mov    (%esp),%esi
  801e20:	89 f2                	mov    %esi,%edx
  801e22:	89 f9                	mov    %edi,%ecx
  801e24:	d3 ea                	shr    %cl,%edx
  801e26:	09 c2                	or     %eax,%edx
  801e28:	89 14 24             	mov    %edx,(%esp)
  801e2b:	89 f2                	mov    %esi,%edx
  801e2d:	89 e9                	mov    %ebp,%ecx
  801e2f:	d3 e2                	shl    %cl,%edx
  801e31:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e35:	89 de                	mov    %ebx,%esi
  801e37:	89 f9                	mov    %edi,%ecx
  801e39:	d3 ee                	shr    %cl,%esi
  801e3b:	89 e9                	mov    %ebp,%ecx
  801e3d:	d3 e3                	shl    %cl,%ebx
  801e3f:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	89 f9                	mov    %edi,%ecx
  801e47:	d3 e8                	shr    %cl,%eax
  801e49:	09 d8                	or     %ebx,%eax
  801e4b:	89 d3                	mov    %edx,%ebx
  801e4d:	89 e9                	mov    %ebp,%ecx
  801e4f:	d3 e3                	shl    %cl,%ebx
  801e51:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e55:	89 f2                	mov    %esi,%edx
  801e57:	f7 34 24             	divl   (%esp)
  801e5a:	89 d6                	mov    %edx,%esi
  801e5c:	f7 64 24 04          	mull   0x4(%esp)
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	89 d1                	mov    %edx,%ecx
  801e64:	39 d6                	cmp    %edx,%esi
  801e66:	72 7c                	jb     801ee4 <__umoddi3+0x12c>
  801e68:	74 72                	je     801edc <__umoddi3+0x124>
  801e6a:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e6e:	29 da                	sub    %ebx,%edx
  801e70:	19 ce                	sbb    %ecx,%esi
  801e72:	89 f0                	mov    %esi,%eax
  801e74:	89 f9                	mov    %edi,%ecx
  801e76:	d3 e0                	shl    %cl,%eax
  801e78:	89 e9                	mov    %ebp,%ecx
  801e7a:	d3 ea                	shr    %cl,%edx
  801e7c:	09 d0                	or     %edx,%eax
  801e7e:	89 e9                	mov    %ebp,%ecx
  801e80:	d3 ee                	shr    %cl,%esi
  801e82:	89 f2                	mov    %esi,%edx
  801e84:	83 c4 1c             	add    $0x1c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
  801e8c:	89 fd                	mov    %edi,%ebp
  801e8e:	85 ff                	test   %edi,%edi
  801e90:	75 0b                	jne    801e9d <__umoddi3+0xe5>
  801e92:	b8 01 00 00 00       	mov    $0x1,%eax
  801e97:	31 d2                	xor    %edx,%edx
  801e99:	f7 f7                	div    %edi
  801e9b:	89 c5                	mov    %eax,%ebp
  801e9d:	89 f0                	mov    %esi,%eax
  801e9f:	31 d2                	xor    %edx,%edx
  801ea1:	f7 f5                	div    %ebp
  801ea3:	89 c8                	mov    %ecx,%eax
  801ea5:	f7 f5                	div    %ebp
  801ea7:	e9 44 ff ff ff       	jmp    801df0 <__umoddi3+0x38>
  801eac:	89 c8                	mov    %ecx,%eax
  801eae:	89 f2                	mov    %esi,%edx
  801eb0:	83 c4 1c             	add    $0x1c,%esp
  801eb3:	5b                   	pop    %ebx
  801eb4:	5e                   	pop    %esi
  801eb5:	5f                   	pop    %edi
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    
  801eb8:	39 f0                	cmp    %esi,%eax
  801eba:	72 05                	jb     801ec1 <__umoddi3+0x109>
  801ebc:	39 0c 24             	cmp    %ecx,(%esp)
  801ebf:	77 0c                	ja     801ecd <__umoddi3+0x115>
  801ec1:	89 f2                	mov    %esi,%edx
  801ec3:	29 f9                	sub    %edi,%ecx
  801ec5:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ec9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ecd:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ed1:	83 c4 1c             	add    $0x1c,%esp
  801ed4:	5b                   	pop    %ebx
  801ed5:	5e                   	pop    %esi
  801ed6:	5f                   	pop    %edi
  801ed7:	5d                   	pop    %ebp
  801ed8:	c3                   	ret    
  801ed9:	8d 76 00             	lea    0x0(%esi),%esi
  801edc:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ee0:	73 88                	jae    801e6a <__umoddi3+0xb2>
  801ee2:	66 90                	xchg   %ax,%ax
  801ee4:	2b 44 24 04          	sub    0x4(%esp),%eax
  801ee8:	1b 14 24             	sbb    (%esp),%edx
  801eeb:	89 d1                	mov    %edx,%ecx
  801eed:	89 c3                	mov    %eax,%ebx
  801eef:	e9 76 ff ff ff       	jmp    801e6a <__umoddi3+0xb2>
