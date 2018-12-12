
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 30 80 00    	pushl  0x803000
  800044:	e8 6b 00 00 00       	call   8000b4 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 d4 00 00 00       	call   800132 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	89 c2                	mov    %eax,%edx
  800065:	c1 e2 05             	shl    $0x5,%edx
  800068:	29 c2                	sub    %eax,%edx
  80006a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800071:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x33>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a0:	e8 35 05 00 00       	call   8005da <close_all>
	sys_env_destroy(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 42 00 00 00       	call   8000f1 <sys_env_destroy>
}
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	c9                   	leave  
  8000b3:	c3                   	ret    

008000b4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	89 c7                	mov    %eax,%edi
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e2:	89 d1                	mov    %edx,%ecx
  8000e4:	89 d3                	mov    %edx,%ebx
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	89 d6                	mov    %edx,%esi
  8000ea:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ff:	b8 03 00 00 00       	mov    $0x3,%eax
  800104:	8b 55 08             	mov    0x8(%ebp),%edx
  800107:	89 cb                	mov    %ecx,%ebx
  800109:	89 cf                	mov    %ecx,%edi
  80010b:	89 ce                	mov    %ecx,%esi
  80010d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	7f 08                	jg     80011b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800113:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800116:	5b                   	pop    %ebx
  800117:	5e                   	pop    %esi
  800118:	5f                   	pop    %edi
  800119:	5d                   	pop    %ebp
  80011a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	6a 03                	push   $0x3
  800121:	68 18 1f 80 00       	push   $0x801f18
  800126:	6a 23                	push   $0x23
  800128:	68 35 1f 80 00       	push   $0x801f35
  80012d:	e8 df 0f 00 00       	call   801111 <_panic>

00800132 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 02 00 00 00       	mov    $0x2,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
  800157:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015a:	be 00 00 00 00       	mov    $0x0,%esi
  80015f:	b8 04 00 00 00       	mov    $0x4,%eax
  800164:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800167:	8b 55 08             	mov    0x8(%ebp),%edx
  80016a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016d:	89 f7                	mov    %esi,%edi
  80016f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800171:	85 c0                	test   %eax,%eax
  800173:	7f 08                	jg     80017d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800178:	5b                   	pop    %ebx
  800179:	5e                   	pop    %esi
  80017a:	5f                   	pop    %edi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	6a 04                	push   $0x4
  800183:	68 18 1f 80 00       	push   $0x801f18
  800188:	6a 23                	push   $0x23
  80018a:	68 35 1f 80 00       	push   $0x801f35
  80018f:	e8 7d 0f 00 00       	call   801111 <_panic>

00800194 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019d:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	7f 08                	jg     8001bf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ba:	5b                   	pop    %ebx
  8001bb:	5e                   	pop    %esi
  8001bc:	5f                   	pop    %edi
  8001bd:	5d                   	pop    %ebp
  8001be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	50                   	push   %eax
  8001c3:	6a 05                	push   $0x5
  8001c5:	68 18 1f 80 00       	push   $0x801f18
  8001ca:	6a 23                	push   $0x23
  8001cc:	68 35 1f 80 00       	push   $0x801f35
  8001d1:	e8 3b 0f 00 00       	call   801111 <_panic>

008001d6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	57                   	push   %edi
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e4:	b8 06 00 00 00       	mov    $0x6,%eax
  8001e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ef:	89 df                	mov    %ebx,%edi
  8001f1:	89 de                	mov    %ebx,%esi
  8001f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f5:	85 c0                	test   %eax,%eax
  8001f7:	7f 08                	jg     800201 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5f                   	pop    %edi
  8001ff:	5d                   	pop    %ebp
  800200:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	50                   	push   %eax
  800205:	6a 06                	push   $0x6
  800207:	68 18 1f 80 00       	push   $0x801f18
  80020c:	6a 23                	push   $0x23
  80020e:	68 35 1f 80 00       	push   $0x801f35
  800213:	e8 f9 0e 00 00       	call   801111 <_panic>

00800218 <sys_yield>:

void
sys_yield(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	57                   	push   %edi
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	b8 0b 00 00 00       	mov    $0xb,%eax
  800228:	89 d1                	mov    %edx,%ecx
  80022a:	89 d3                	mov    %edx,%ebx
  80022c:	89 d7                	mov    %edx,%edi
  80022e:	89 d6                	mov    %edx,%esi
  800230:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800232:	5b                   	pop    %ebx
  800233:	5e                   	pop    %esi
  800234:	5f                   	pop    %edi
  800235:	5d                   	pop    %ebp
  800236:	c3                   	ret    

00800237 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800240:	bb 00 00 00 00       	mov    $0x0,%ebx
  800245:	b8 08 00 00 00       	mov    $0x8,%eax
  80024a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024d:	8b 55 08             	mov    0x8(%ebp),%edx
  800250:	89 df                	mov    %ebx,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	cd 30                	int    $0x30
	if(check && ret > 0)
  800256:	85 c0                	test   %eax,%eax
  800258:	7f 08                	jg     800262 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80025a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025d:	5b                   	pop    %ebx
  80025e:	5e                   	pop    %esi
  80025f:	5f                   	pop    %edi
  800260:	5d                   	pop    %ebp
  800261:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	50                   	push   %eax
  800266:	6a 08                	push   $0x8
  800268:	68 18 1f 80 00       	push   $0x801f18
  80026d:	6a 23                	push   $0x23
  80026f:	68 35 1f 80 00       	push   $0x801f35
  800274:	e8 98 0e 00 00       	call   801111 <_panic>

00800279 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	57                   	push   %edi
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
  800287:	b8 0c 00 00 00       	mov    $0xc,%eax
  80028c:	8b 55 08             	mov    0x8(%ebp),%edx
  80028f:	89 cb                	mov    %ecx,%ebx
  800291:	89 cf                	mov    %ecx,%edi
  800293:	89 ce                	mov    %ecx,%esi
  800295:	cd 30                	int    $0x30
	if(check && ret > 0)
  800297:	85 c0                	test   %eax,%eax
  800299:	7f 08                	jg     8002a3 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  80029b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029e:	5b                   	pop    %ebx
  80029f:	5e                   	pop    %esi
  8002a0:	5f                   	pop    %edi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	50                   	push   %eax
  8002a7:	6a 0c                	push   $0xc
  8002a9:	68 18 1f 80 00       	push   $0x801f18
  8002ae:	6a 23                	push   $0x23
  8002b0:	68 35 1f 80 00       	push   $0x801f35
  8002b5:	e8 57 0e 00 00       	call   801111 <_panic>

008002ba <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	57                   	push   %edi
  8002be:	56                   	push   %esi
  8002bf:	53                   	push   %ebx
  8002c0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c8:	b8 09 00 00 00       	mov    $0x9,%eax
  8002cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d3:	89 df                	mov    %ebx,%edi
  8002d5:	89 de                	mov    %ebx,%esi
  8002d7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d9:	85 c0                	test   %eax,%eax
  8002db:	7f 08                	jg     8002e5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5e                   	pop    %esi
  8002e2:	5f                   	pop    %edi
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	50                   	push   %eax
  8002e9:	6a 09                	push   $0x9
  8002eb:	68 18 1f 80 00       	push   $0x801f18
  8002f0:	6a 23                	push   $0x23
  8002f2:	68 35 1f 80 00       	push   $0x801f35
  8002f7:	e8 15 0e 00 00       	call   801111 <_panic>

008002fc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	57                   	push   %edi
  800300:	56                   	push   %esi
  800301:	53                   	push   %ebx
  800302:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800305:	bb 00 00 00 00       	mov    $0x0,%ebx
  80030a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80030f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800312:	8b 55 08             	mov    0x8(%ebp),%edx
  800315:	89 df                	mov    %ebx,%edi
  800317:	89 de                	mov    %ebx,%esi
  800319:	cd 30                	int    $0x30
	if(check && ret > 0)
  80031b:	85 c0                	test   %eax,%eax
  80031d:	7f 08                	jg     800327 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800322:	5b                   	pop    %ebx
  800323:	5e                   	pop    %esi
  800324:	5f                   	pop    %edi
  800325:	5d                   	pop    %ebp
  800326:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	50                   	push   %eax
  80032b:	6a 0a                	push   $0xa
  80032d:	68 18 1f 80 00       	push   $0x801f18
  800332:	6a 23                	push   $0x23
  800334:	68 35 1f 80 00       	push   $0x801f35
  800339:	e8 d3 0d 00 00       	call   801111 <_panic>

0080033e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	57                   	push   %edi
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
	asm volatile("int %1\n"
  800344:	be 00 00 00 00       	mov    $0x0,%esi
  800349:	b8 0d 00 00 00       	mov    $0xd,%eax
  80034e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800351:	8b 55 08             	mov    0x8(%ebp),%edx
  800354:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800357:	8b 7d 14             	mov    0x14(%ebp),%edi
  80035a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80035c:	5b                   	pop    %ebx
  80035d:	5e                   	pop    %esi
  80035e:	5f                   	pop    %edi
  80035f:	5d                   	pop    %ebp
  800360:	c3                   	ret    

00800361 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
  800367:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80036a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800374:	8b 55 08             	mov    0x8(%ebp),%edx
  800377:	89 cb                	mov    %ecx,%ebx
  800379:	89 cf                	mov    %ecx,%edi
  80037b:	89 ce                	mov    %ecx,%esi
  80037d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80037f:	85 c0                	test   %eax,%eax
  800381:	7f 08                	jg     80038b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800383:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800386:	5b                   	pop    %ebx
  800387:	5e                   	pop    %esi
  800388:	5f                   	pop    %edi
  800389:	5d                   	pop    %ebp
  80038a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80038b:	83 ec 0c             	sub    $0xc,%esp
  80038e:	50                   	push   %eax
  80038f:	6a 0e                	push   $0xe
  800391:	68 18 1f 80 00       	push   $0x801f18
  800396:	6a 23                	push   $0x23
  800398:	68 35 1f 80 00       	push   $0x801f35
  80039d:	e8 6f 0d 00 00       	call   801111 <_panic>

008003a2 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	57                   	push   %edi
  8003a6:	56                   	push   %esi
  8003a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a8:	be 00 00 00 00       	mov    $0x0,%esi
  8003ad:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003bb:	89 f7                	mov    %esi,%edi
  8003bd:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003bf:	5b                   	pop    %ebx
  8003c0:	5e                   	pop    %esi
  8003c1:	5f                   	pop    %edi
  8003c2:	5d                   	pop    %ebp
  8003c3:	c3                   	ret    

008003c4 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	57                   	push   %edi
  8003c8:	56                   	push   %esi
  8003c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ca:	be 00 00 00 00       	mov    $0x0,%esi
  8003cf:	b8 10 00 00 00       	mov    $0x10,%eax
  8003d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003dd:	89 f7                	mov    %esi,%edi
  8003df:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003e1:	5b                   	pop    %ebx
  8003e2:	5e                   	pop    %esi
  8003e3:	5f                   	pop    %edi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	57                   	push   %edi
  8003ea:	56                   	push   %esi
  8003eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f1:	b8 11 00 00 00       	mov    $0x11,%eax
  8003f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f9:	89 cb                	mov    %ecx,%ebx
  8003fb:	89 cf                	mov    %ecx,%edi
  8003fd:	89 ce                	mov    %ecx,%esi
  8003ff:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800401:	5b                   	pop    %ebx
  800402:	5e                   	pop    %esi
  800403:	5f                   	pop    %edi
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	05 00 00 00 30       	add    $0x30000000,%eax
  800411:	c1 e8 0c             	shr    $0xc,%eax
}
  800414:	5d                   	pop    %ebp
  800415:	c3                   	ret    

00800416 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800421:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800426:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    

0080042d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800433:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800438:	89 c2                	mov    %eax,%edx
  80043a:	c1 ea 16             	shr    $0x16,%edx
  80043d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800444:	f6 c2 01             	test   $0x1,%dl
  800447:	74 2a                	je     800473 <fd_alloc+0x46>
  800449:	89 c2                	mov    %eax,%edx
  80044b:	c1 ea 0c             	shr    $0xc,%edx
  80044e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800455:	f6 c2 01             	test   $0x1,%dl
  800458:	74 19                	je     800473 <fd_alloc+0x46>
  80045a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80045f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800464:	75 d2                	jne    800438 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800466:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80046c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800471:	eb 07                	jmp    80047a <fd_alloc+0x4d>
			*fd_store = fd;
  800473:	89 01                	mov    %eax,(%ecx)
			return 0;
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80047a:	5d                   	pop    %ebp
  80047b:	c3                   	ret    

0080047c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80047c:	55                   	push   %ebp
  80047d:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80047f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800483:	77 39                	ja     8004be <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	c1 e0 0c             	shl    $0xc,%eax
  80048b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800490:	89 c2                	mov    %eax,%edx
  800492:	c1 ea 16             	shr    $0x16,%edx
  800495:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80049c:	f6 c2 01             	test   $0x1,%dl
  80049f:	74 24                	je     8004c5 <fd_lookup+0x49>
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	c1 ea 0c             	shr    $0xc,%edx
  8004a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004ad:	f6 c2 01             	test   $0x1,%dl
  8004b0:	74 1a                	je     8004cc <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b5:	89 02                	mov    %eax,(%edx)
	return 0;
  8004b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004bc:	5d                   	pop    %ebp
  8004bd:	c3                   	ret    
		return -E_INVAL;
  8004be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004c3:	eb f7                	jmp    8004bc <fd_lookup+0x40>
		return -E_INVAL;
  8004c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004ca:	eb f0                	jmp    8004bc <fd_lookup+0x40>
  8004cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004d1:	eb e9                	jmp    8004bc <fd_lookup+0x40>

008004d3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004dc:	ba c0 1f 80 00       	mov    $0x801fc0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004e1:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004e6:	39 08                	cmp    %ecx,(%eax)
  8004e8:	74 33                	je     80051d <dev_lookup+0x4a>
  8004ea:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004ed:	8b 02                	mov    (%edx),%eax
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	75 f3                	jne    8004e6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004f3:	a1 04 40 80 00       	mov    0x804004,%eax
  8004f8:	8b 40 48             	mov    0x48(%eax),%eax
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	51                   	push   %ecx
  8004ff:	50                   	push   %eax
  800500:	68 44 1f 80 00       	push   $0x801f44
  800505:	e8 1a 0d 00 00       	call   801224 <cprintf>
	*dev = 0;
  80050a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80051b:	c9                   	leave  
  80051c:	c3                   	ret    
			*dev = devtab[i];
  80051d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800520:	89 01                	mov    %eax,(%ecx)
			return 0;
  800522:	b8 00 00 00 00       	mov    $0x0,%eax
  800527:	eb f2                	jmp    80051b <dev_lookup+0x48>

00800529 <fd_close>:
{
  800529:	55                   	push   %ebp
  80052a:	89 e5                	mov    %esp,%ebp
  80052c:	57                   	push   %edi
  80052d:	56                   	push   %esi
  80052e:	53                   	push   %ebx
  80052f:	83 ec 1c             	sub    $0x1c,%esp
  800532:	8b 75 08             	mov    0x8(%ebp),%esi
  800535:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800538:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80053b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80053c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800542:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800545:	50                   	push   %eax
  800546:	e8 31 ff ff ff       	call   80047c <fd_lookup>
  80054b:	89 c7                	mov    %eax,%edi
  80054d:	83 c4 08             	add    $0x8,%esp
  800550:	85 c0                	test   %eax,%eax
  800552:	78 05                	js     800559 <fd_close+0x30>
	    || fd != fd2)
  800554:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800557:	74 13                	je     80056c <fd_close+0x43>
		return (must_exist ? r : 0);
  800559:	84 db                	test   %bl,%bl
  80055b:	75 05                	jne    800562 <fd_close+0x39>
  80055d:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800562:	89 f8                	mov    %edi,%eax
  800564:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800567:	5b                   	pop    %ebx
  800568:	5e                   	pop    %esi
  800569:	5f                   	pop    %edi
  80056a:	5d                   	pop    %ebp
  80056b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800572:	50                   	push   %eax
  800573:	ff 36                	pushl  (%esi)
  800575:	e8 59 ff ff ff       	call   8004d3 <dev_lookup>
  80057a:	89 c7                	mov    %eax,%edi
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	85 c0                	test   %eax,%eax
  800581:	78 15                	js     800598 <fd_close+0x6f>
		if (dev->dev_close)
  800583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800586:	8b 40 10             	mov    0x10(%eax),%eax
  800589:	85 c0                	test   %eax,%eax
  80058b:	74 1b                	je     8005a8 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	56                   	push   %esi
  800591:	ff d0                	call   *%eax
  800593:	89 c7                	mov    %eax,%edi
  800595:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	56                   	push   %esi
  80059c:	6a 00                	push   $0x0
  80059e:	e8 33 fc ff ff       	call   8001d6 <sys_page_unmap>
	return r;
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb ba                	jmp    800562 <fd_close+0x39>
			r = 0;
  8005a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8005ad:	eb e9                	jmp    800598 <fd_close+0x6f>

008005af <close>:

int
close(int fdnum)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005b8:	50                   	push   %eax
  8005b9:	ff 75 08             	pushl  0x8(%ebp)
  8005bc:	e8 bb fe ff ff       	call   80047c <fd_lookup>
  8005c1:	83 c4 08             	add    $0x8,%esp
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	78 10                	js     8005d8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	6a 01                	push   $0x1
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	e8 54 ff ff ff       	call   800529 <fd_close>
  8005d5:	83 c4 10             	add    $0x10,%esp
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <close_all>:

void
close_all(void)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	53                   	push   %ebx
  8005de:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005e6:	83 ec 0c             	sub    $0xc,%esp
  8005e9:	53                   	push   %ebx
  8005ea:	e8 c0 ff ff ff       	call   8005af <close>
	for (i = 0; i < MAXFD; i++)
  8005ef:	43                   	inc    %ebx
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	83 fb 20             	cmp    $0x20,%ebx
  8005f6:	75 ee                	jne    8005e6 <close_all+0xc>
}
  8005f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	57                   	push   %edi
  800601:	56                   	push   %esi
  800602:	53                   	push   %ebx
  800603:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800606:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800609:	50                   	push   %eax
  80060a:	ff 75 08             	pushl  0x8(%ebp)
  80060d:	e8 6a fe ff ff       	call   80047c <fd_lookup>
  800612:	89 c3                	mov    %eax,%ebx
  800614:	83 c4 08             	add    $0x8,%esp
  800617:	85 c0                	test   %eax,%eax
  800619:	0f 88 81 00 00 00    	js     8006a0 <dup+0xa3>
		return r;
	close(newfdnum);
  80061f:	83 ec 0c             	sub    $0xc,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	e8 85 ff ff ff       	call   8005af <close>

	newfd = INDEX2FD(newfdnum);
  80062a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80062d:	c1 e6 0c             	shl    $0xc,%esi
  800630:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800636:	83 c4 04             	add    $0x4,%esp
  800639:	ff 75 e4             	pushl  -0x1c(%ebp)
  80063c:	e8 d5 fd ff ff       	call   800416 <fd2data>
  800641:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800643:	89 34 24             	mov    %esi,(%esp)
  800646:	e8 cb fd ff ff       	call   800416 <fd2data>
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800650:	89 d8                	mov    %ebx,%eax
  800652:	c1 e8 16             	shr    $0x16,%eax
  800655:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80065c:	a8 01                	test   $0x1,%al
  80065e:	74 11                	je     800671 <dup+0x74>
  800660:	89 d8                	mov    %ebx,%eax
  800662:	c1 e8 0c             	shr    $0xc,%eax
  800665:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80066c:	f6 c2 01             	test   $0x1,%dl
  80066f:	75 39                	jne    8006aa <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800671:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800674:	89 d0                	mov    %edx,%eax
  800676:	c1 e8 0c             	shr    $0xc,%eax
  800679:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	25 07 0e 00 00       	and    $0xe07,%eax
  800688:	50                   	push   %eax
  800689:	56                   	push   %esi
  80068a:	6a 00                	push   $0x0
  80068c:	52                   	push   %edx
  80068d:	6a 00                	push   $0x0
  80068f:	e8 00 fb ff ff       	call   800194 <sys_page_map>
  800694:	89 c3                	mov    %eax,%ebx
  800696:	83 c4 20             	add    $0x20,%esp
  800699:	85 c0                	test   %eax,%eax
  80069b:	78 31                	js     8006ce <dup+0xd1>
		goto err;

	return newfdnum;
  80069d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006a0:	89 d8                	mov    %ebx,%eax
  8006a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a5:	5b                   	pop    %ebx
  8006a6:	5e                   	pop    %esi
  8006a7:	5f                   	pop    %edi
  8006a8:	5d                   	pop    %ebp
  8006a9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8006b9:	50                   	push   %eax
  8006ba:	57                   	push   %edi
  8006bb:	6a 00                	push   $0x0
  8006bd:	53                   	push   %ebx
  8006be:	6a 00                	push   $0x0
  8006c0:	e8 cf fa ff ff       	call   800194 <sys_page_map>
  8006c5:	89 c3                	mov    %eax,%ebx
  8006c7:	83 c4 20             	add    $0x20,%esp
  8006ca:	85 c0                	test   %eax,%eax
  8006cc:	79 a3                	jns    800671 <dup+0x74>
	sys_page_unmap(0, newfd);
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	56                   	push   %esi
  8006d2:	6a 00                	push   $0x0
  8006d4:	e8 fd fa ff ff       	call   8001d6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006d9:	83 c4 08             	add    $0x8,%esp
  8006dc:	57                   	push   %edi
  8006dd:	6a 00                	push   $0x0
  8006df:	e8 f2 fa ff ff       	call   8001d6 <sys_page_unmap>
	return r;
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	eb b7                	jmp    8006a0 <dup+0xa3>

008006e9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	53                   	push   %ebx
  8006ed:	83 ec 14             	sub    $0x14,%esp
  8006f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006f6:	50                   	push   %eax
  8006f7:	53                   	push   %ebx
  8006f8:	e8 7f fd ff ff       	call   80047c <fd_lookup>
  8006fd:	83 c4 08             	add    $0x8,%esp
  800700:	85 c0                	test   %eax,%eax
  800702:	78 3f                	js     800743 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80070a:	50                   	push   %eax
  80070b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070e:	ff 30                	pushl  (%eax)
  800710:	e8 be fd ff ff       	call   8004d3 <dev_lookup>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	85 c0                	test   %eax,%eax
  80071a:	78 27                	js     800743 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80071c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80071f:	8b 42 08             	mov    0x8(%edx),%eax
  800722:	83 e0 03             	and    $0x3,%eax
  800725:	83 f8 01             	cmp    $0x1,%eax
  800728:	74 1e                	je     800748 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80072a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072d:	8b 40 08             	mov    0x8(%eax),%eax
  800730:	85 c0                	test   %eax,%eax
  800732:	74 35                	je     800769 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800734:	83 ec 04             	sub    $0x4,%esp
  800737:	ff 75 10             	pushl  0x10(%ebp)
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	52                   	push   %edx
  80073e:	ff d0                	call   *%eax
  800740:	83 c4 10             	add    $0x10,%esp
}
  800743:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800746:	c9                   	leave  
  800747:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800748:	a1 04 40 80 00       	mov    0x804004,%eax
  80074d:	8b 40 48             	mov    0x48(%eax),%eax
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	53                   	push   %ebx
  800754:	50                   	push   %eax
  800755:	68 85 1f 80 00       	push   $0x801f85
  80075a:	e8 c5 0a 00 00       	call   801224 <cprintf>
		return -E_INVAL;
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800767:	eb da                	jmp    800743 <read+0x5a>
		return -E_NOT_SUPP;
  800769:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80076e:	eb d3                	jmp    800743 <read+0x5a>

00800770 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	57                   	push   %edi
  800774:	56                   	push   %esi
  800775:	53                   	push   %ebx
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	8b 7d 08             	mov    0x8(%ebp),%edi
  80077c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80077f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800784:	39 f3                	cmp    %esi,%ebx
  800786:	73 25                	jae    8007ad <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800788:	83 ec 04             	sub    $0x4,%esp
  80078b:	89 f0                	mov    %esi,%eax
  80078d:	29 d8                	sub    %ebx,%eax
  80078f:	50                   	push   %eax
  800790:	89 d8                	mov    %ebx,%eax
  800792:	03 45 0c             	add    0xc(%ebp),%eax
  800795:	50                   	push   %eax
  800796:	57                   	push   %edi
  800797:	e8 4d ff ff ff       	call   8006e9 <read>
		if (m < 0)
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	85 c0                	test   %eax,%eax
  8007a1:	78 08                	js     8007ab <readn+0x3b>
			return m;
		if (m == 0)
  8007a3:	85 c0                	test   %eax,%eax
  8007a5:	74 06                	je     8007ad <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8007a7:	01 c3                	add    %eax,%ebx
  8007a9:	eb d9                	jmp    800784 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007ab:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007ad:	89 d8                	mov    %ebx,%eax
  8007af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b2:	5b                   	pop    %ebx
  8007b3:	5e                   	pop    %esi
  8007b4:	5f                   	pop    %edi
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	53                   	push   %ebx
  8007bb:	83 ec 14             	sub    $0x14,%esp
  8007be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007c4:	50                   	push   %eax
  8007c5:	53                   	push   %ebx
  8007c6:	e8 b1 fc ff ff       	call   80047c <fd_lookup>
  8007cb:	83 c4 08             	add    $0x8,%esp
  8007ce:	85 c0                	test   %eax,%eax
  8007d0:	78 3a                	js     80080c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d8:	50                   	push   %eax
  8007d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007dc:	ff 30                	pushl  (%eax)
  8007de:	e8 f0 fc ff ff       	call   8004d3 <dev_lookup>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	85 c0                	test   %eax,%eax
  8007e8:	78 22                	js     80080c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007f1:	74 1e                	je     800811 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f6:	8b 52 0c             	mov    0xc(%edx),%edx
  8007f9:	85 d2                	test   %edx,%edx
  8007fb:	74 35                	je     800832 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	ff 75 10             	pushl  0x10(%ebp)
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	50                   	push   %eax
  800807:	ff d2                	call   *%edx
  800809:	83 c4 10             	add    $0x10,%esp
}
  80080c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080f:	c9                   	leave  
  800810:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800811:	a1 04 40 80 00       	mov    0x804004,%eax
  800816:	8b 40 48             	mov    0x48(%eax),%eax
  800819:	83 ec 04             	sub    $0x4,%esp
  80081c:	53                   	push   %ebx
  80081d:	50                   	push   %eax
  80081e:	68 a1 1f 80 00       	push   $0x801fa1
  800823:	e8 fc 09 00 00       	call   801224 <cprintf>
		return -E_INVAL;
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800830:	eb da                	jmp    80080c <write+0x55>
		return -E_NOT_SUPP;
  800832:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800837:	eb d3                	jmp    80080c <write+0x55>

00800839 <seek>:

int
seek(int fdnum, off_t offset)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80083f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800842:	50                   	push   %eax
  800843:	ff 75 08             	pushl  0x8(%ebp)
  800846:	e8 31 fc ff ff       	call   80047c <fd_lookup>
  80084b:	83 c4 08             	add    $0x8,%esp
  80084e:	85 c0                	test   %eax,%eax
  800850:	78 0e                	js     800860 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800855:	8b 55 0c             	mov    0xc(%ebp),%edx
  800858:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80085b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800860:	c9                   	leave  
  800861:	c3                   	ret    

00800862 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	53                   	push   %ebx
  800866:	83 ec 14             	sub    $0x14,%esp
  800869:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80086c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	53                   	push   %ebx
  800871:	e8 06 fc ff ff       	call   80047c <fd_lookup>
  800876:	83 c4 08             	add    $0x8,%esp
  800879:	85 c0                	test   %eax,%eax
  80087b:	78 37                	js     8008b4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800883:	50                   	push   %eax
  800884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800887:	ff 30                	pushl  (%eax)
  800889:	e8 45 fc ff ff       	call   8004d3 <dev_lookup>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	85 c0                	test   %eax,%eax
  800893:	78 1f                	js     8008b4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800898:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80089c:	74 1b                	je     8008b9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80089e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a1:	8b 52 18             	mov    0x18(%edx),%edx
  8008a4:	85 d2                	test   %edx,%edx
  8008a6:	74 32                	je     8008da <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	50                   	push   %eax
  8008af:	ff d2                	call   *%edx
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008b9:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008be:	8b 40 48             	mov    0x48(%eax),%eax
  8008c1:	83 ec 04             	sub    $0x4,%esp
  8008c4:	53                   	push   %ebx
  8008c5:	50                   	push   %eax
  8008c6:	68 64 1f 80 00       	push   $0x801f64
  8008cb:	e8 54 09 00 00       	call   801224 <cprintf>
		return -E_INVAL;
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d8:	eb da                	jmp    8008b4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8008da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008df:	eb d3                	jmp    8008b4 <ftruncate+0x52>

008008e1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	53                   	push   %ebx
  8008e5:	83 ec 14             	sub    $0x14,%esp
  8008e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008ee:	50                   	push   %eax
  8008ef:	ff 75 08             	pushl  0x8(%ebp)
  8008f2:	e8 85 fb ff ff       	call   80047c <fd_lookup>
  8008f7:	83 c4 08             	add    $0x8,%esp
  8008fa:	85 c0                	test   %eax,%eax
  8008fc:	78 4b                	js     800949 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800904:	50                   	push   %eax
  800905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800908:	ff 30                	pushl  (%eax)
  80090a:	e8 c4 fb ff ff       	call   8004d3 <dev_lookup>
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	85 c0                	test   %eax,%eax
  800914:	78 33                	js     800949 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800919:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80091d:	74 2f                	je     80094e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80091f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800922:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800929:	00 00 00 
	stat->st_type = 0;
  80092c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800933:	00 00 00 
	stat->st_dev = dev;
  800936:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	53                   	push   %ebx
  800940:	ff 75 f0             	pushl  -0x10(%ebp)
  800943:	ff 50 14             	call   *0x14(%eax)
  800946:	83 c4 10             	add    $0x10,%esp
}
  800949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    
		return -E_NOT_SUPP;
  80094e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800953:	eb f4                	jmp    800949 <fstat+0x68>

00800955 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 34 02 00 00       	call   800b9b <open>
  800967:	89 c3                	mov    %eax,%ebx
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	85 c0                	test   %eax,%eax
  80096e:	78 1b                	js     80098b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	50                   	push   %eax
  800977:	e8 65 ff ff ff       	call   8008e1 <fstat>
  80097c:	89 c6                	mov    %eax,%esi
	close(fd);
  80097e:	89 1c 24             	mov    %ebx,(%esp)
  800981:	e8 29 fc ff ff       	call   8005af <close>
	return r;
  800986:	83 c4 10             	add    $0x10,%esp
  800989:	89 f3                	mov    %esi,%ebx
}
  80098b:	89 d8                	mov    %ebx,%eax
  80098d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800990:	5b                   	pop    %ebx
  800991:	5e                   	pop    %esi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	89 c6                	mov    %eax,%esi
  80099b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80099d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009a4:	74 27                	je     8009cd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009a6:	6a 07                	push   $0x7
  8009a8:	68 00 50 80 00       	push   $0x805000
  8009ad:	56                   	push   %esi
  8009ae:	ff 35 00 40 80 00    	pushl  0x804000
  8009b4:	e8 14 12 00 00       	call   801bcd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009b9:	83 c4 0c             	add    $0xc,%esp
  8009bc:	6a 00                	push   $0x0
  8009be:	53                   	push   %ebx
  8009bf:	6a 00                	push   $0x0
  8009c1:	e8 7e 11 00 00       	call   801b44 <ipc_recv>
}
  8009c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c9:	5b                   	pop    %ebx
  8009ca:	5e                   	pop    %esi
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009cd:	83 ec 0c             	sub    $0xc,%esp
  8009d0:	6a 01                	push   $0x1
  8009d2:	e8 52 12 00 00       	call   801c29 <ipc_find_env>
  8009d7:	a3 00 40 80 00       	mov    %eax,0x804000
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	eb c5                	jmp    8009a6 <fsipc+0x12>

008009e1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ff:	b8 02 00 00 00       	mov    $0x2,%eax
  800a04:	e8 8b ff ff ff       	call   800994 <fsipc>
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <devfile_flush>:
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 40 0c             	mov    0xc(%eax),%eax
  800a17:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a21:	b8 06 00 00 00       	mov    $0x6,%eax
  800a26:	e8 69 ff ff ff       	call   800994 <fsipc>
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <devfile_stat>:
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	53                   	push   %ebx
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  800a3d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a42:	ba 00 00 00 00       	mov    $0x0,%edx
  800a47:	b8 05 00 00 00       	mov    $0x5,%eax
  800a4c:	e8 43 ff ff ff       	call   800994 <fsipc>
  800a51:	85 c0                	test   %eax,%eax
  800a53:	78 2c                	js     800a81 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	68 00 50 80 00       	push   $0x805000
  800a5d:	53                   	push   %ebx
  800a5e:	e8 c9 0d 00 00       	call   80182c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a63:	a1 80 50 80 00       	mov    0x805080,%eax
  800a68:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a6e:	a1 84 50 80 00       	mov    0x805084,%eax
  800a73:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a84:	c9                   	leave  
  800a85:	c3                   	ret    

00800a86 <devfile_write>:
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	53                   	push   %ebx
  800a8a:	83 ec 04             	sub    $0x4,%esp
  800a8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800a90:	89 d8                	mov    %ebx,%eax
  800a92:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800a98:	76 05                	jbe    800a9f <devfile_write+0x19>
  800a9a:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa2:	8b 52 0c             	mov    0xc(%edx),%edx
  800aa5:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800aab:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800ab0:	83 ec 04             	sub    $0x4,%esp
  800ab3:	50                   	push   %eax
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	68 08 50 80 00       	push   $0x805008
  800abc:	e8 de 0e 00 00       	call   80199f <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac6:	b8 04 00 00 00       	mov    $0x4,%eax
  800acb:	e8 c4 fe ff ff       	call   800994 <fsipc>
  800ad0:	83 c4 10             	add    $0x10,%esp
  800ad3:	85 c0                	test   %eax,%eax
  800ad5:	78 0b                	js     800ae2 <devfile_write+0x5c>
	assert(r <= n);
  800ad7:	39 c3                	cmp    %eax,%ebx
  800ad9:	72 0c                	jb     800ae7 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800adb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ae0:	7f 1e                	jg     800b00 <devfile_write+0x7a>
}
  800ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    
	assert(r <= n);
  800ae7:	68 d0 1f 80 00       	push   $0x801fd0
  800aec:	68 d7 1f 80 00       	push   $0x801fd7
  800af1:	68 98 00 00 00       	push   $0x98
  800af6:	68 ec 1f 80 00       	push   $0x801fec
  800afb:	e8 11 06 00 00       	call   801111 <_panic>
	assert(r <= PGSIZE);
  800b00:	68 f7 1f 80 00       	push   $0x801ff7
  800b05:	68 d7 1f 80 00       	push   $0x801fd7
  800b0a:	68 99 00 00 00       	push   $0x99
  800b0f:	68 ec 1f 80 00       	push   $0x801fec
  800b14:	e8 f8 05 00 00       	call   801111 <_panic>

00800b19 <devfile_read>:
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
  800b1e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8b 40 0c             	mov    0xc(%eax),%eax
  800b27:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b2c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b32:	ba 00 00 00 00       	mov    $0x0,%edx
  800b37:	b8 03 00 00 00       	mov    $0x3,%eax
  800b3c:	e8 53 fe ff ff       	call   800994 <fsipc>
  800b41:	89 c3                	mov    %eax,%ebx
  800b43:	85 c0                	test   %eax,%eax
  800b45:	78 1f                	js     800b66 <devfile_read+0x4d>
	assert(r <= n);
  800b47:	39 c6                	cmp    %eax,%esi
  800b49:	72 24                	jb     800b6f <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b4b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b50:	7f 33                	jg     800b85 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b52:	83 ec 04             	sub    $0x4,%esp
  800b55:	50                   	push   %eax
  800b56:	68 00 50 80 00       	push   $0x805000
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	e8 3c 0e 00 00       	call   80199f <memmove>
	return r;
  800b63:	83 c4 10             	add    $0x10,%esp
}
  800b66:	89 d8                	mov    %ebx,%eax
  800b68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    
	assert(r <= n);
  800b6f:	68 d0 1f 80 00       	push   $0x801fd0
  800b74:	68 d7 1f 80 00       	push   $0x801fd7
  800b79:	6a 7c                	push   $0x7c
  800b7b:	68 ec 1f 80 00       	push   $0x801fec
  800b80:	e8 8c 05 00 00       	call   801111 <_panic>
	assert(r <= PGSIZE);
  800b85:	68 f7 1f 80 00       	push   $0x801ff7
  800b8a:	68 d7 1f 80 00       	push   $0x801fd7
  800b8f:	6a 7d                	push   $0x7d
  800b91:	68 ec 1f 80 00       	push   $0x801fec
  800b96:	e8 76 05 00 00       	call   801111 <_panic>

00800b9b <open>:
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	56                   	push   %esi
  800b9f:	53                   	push   %ebx
  800ba0:	83 ec 1c             	sub    $0x1c,%esp
  800ba3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ba6:	56                   	push   %esi
  800ba7:	e8 4d 0c 00 00       	call   8017f9 <strlen>
  800bac:	83 c4 10             	add    $0x10,%esp
  800baf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bb4:	7f 6c                	jg     800c22 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800bb6:	83 ec 0c             	sub    $0xc,%esp
  800bb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bbc:	50                   	push   %eax
  800bbd:	e8 6b f8 ff ff       	call   80042d <fd_alloc>
  800bc2:	89 c3                	mov    %eax,%ebx
  800bc4:	83 c4 10             	add    $0x10,%esp
  800bc7:	85 c0                	test   %eax,%eax
  800bc9:	78 3c                	js     800c07 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	56                   	push   %esi
  800bcf:	68 00 50 80 00       	push   $0x805000
  800bd4:	e8 53 0c 00 00       	call   80182c <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800be1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be4:	b8 01 00 00 00       	mov    $0x1,%eax
  800be9:	e8 a6 fd ff ff       	call   800994 <fsipc>
  800bee:	89 c3                	mov    %eax,%ebx
  800bf0:	83 c4 10             	add    $0x10,%esp
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	78 19                	js     800c10 <open+0x75>
	return fd2num(fd);
  800bf7:	83 ec 0c             	sub    $0xc,%esp
  800bfa:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfd:	e8 04 f8 ff ff       	call   800406 <fd2num>
  800c02:	89 c3                	mov    %eax,%ebx
  800c04:	83 c4 10             	add    $0x10,%esp
}
  800c07:	89 d8                	mov    %ebx,%eax
  800c09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    
		fd_close(fd, 0);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	6a 00                	push   $0x0
  800c15:	ff 75 f4             	pushl  -0xc(%ebp)
  800c18:	e8 0c f9 ff ff       	call   800529 <fd_close>
		return r;
  800c1d:	83 c4 10             	add    $0x10,%esp
  800c20:	eb e5                	jmp    800c07 <open+0x6c>
		return -E_BAD_PATH;
  800c22:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c27:	eb de                	jmp    800c07 <open+0x6c>

00800c29 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c34:	b8 08 00 00 00       	mov    $0x8,%eax
  800c39:	e8 56 fd ff ff       	call   800994 <fsipc>
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	ff 75 08             	pushl  0x8(%ebp)
  800c4e:	e8 c3 f7 ff ff       	call   800416 <fd2data>
  800c53:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c55:	83 c4 08             	add    $0x8,%esp
  800c58:	68 03 20 80 00       	push   $0x802003
  800c5d:	53                   	push   %ebx
  800c5e:	e8 c9 0b 00 00       	call   80182c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c63:	8b 46 04             	mov    0x4(%esi),%eax
  800c66:	2b 06                	sub    (%esi),%eax
  800c68:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c6e:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800c75:	10 00 00 
	stat->st_dev = &devpipe;
  800c78:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  800c7f:	30 80 00 
	return 0;
}
  800c82:	b8 00 00 00 00       	mov    $0x0,%eax
  800c87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	53                   	push   %ebx
  800c92:	83 ec 0c             	sub    $0xc,%esp
  800c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c98:	53                   	push   %ebx
  800c99:	6a 00                	push   $0x0
  800c9b:	e8 36 f5 ff ff       	call   8001d6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800ca0:	89 1c 24             	mov    %ebx,(%esp)
  800ca3:	e8 6e f7 ff ff       	call   800416 <fd2data>
  800ca8:	83 c4 08             	add    $0x8,%esp
  800cab:	50                   	push   %eax
  800cac:	6a 00                	push   $0x0
  800cae:	e8 23 f5 ff ff       	call   8001d6 <sys_page_unmap>
}
  800cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <_pipeisclosed>:
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 1c             	sub    $0x1c,%esp
  800cc1:	89 c7                	mov    %eax,%edi
  800cc3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cc5:	a1 04 40 80 00       	mov    0x804004,%eax
  800cca:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800ccd:	83 ec 0c             	sub    $0xc,%esp
  800cd0:	57                   	push   %edi
  800cd1:	e8 95 0f 00 00       	call   801c6b <pageref>
  800cd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd9:	89 34 24             	mov    %esi,(%esp)
  800cdc:	e8 8a 0f 00 00       	call   801c6b <pageref>
		nn = thisenv->env_runs;
  800ce1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800ce7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800cea:	83 c4 10             	add    $0x10,%esp
  800ced:	39 cb                	cmp    %ecx,%ebx
  800cef:	74 1b                	je     800d0c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800cf1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cf4:	75 cf                	jne    800cc5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800cf6:	8b 42 58             	mov    0x58(%edx),%eax
  800cf9:	6a 01                	push   $0x1
  800cfb:	50                   	push   %eax
  800cfc:	53                   	push   %ebx
  800cfd:	68 0a 20 80 00       	push   $0x80200a
  800d02:	e8 1d 05 00 00       	call   801224 <cprintf>
  800d07:	83 c4 10             	add    $0x10,%esp
  800d0a:	eb b9                	jmp    800cc5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800d0c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800d0f:	0f 94 c0             	sete   %al
  800d12:	0f b6 c0             	movzbl %al,%eax
}
  800d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <devpipe_write>:
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	83 ec 18             	sub    $0x18,%esp
  800d26:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d29:	56                   	push   %esi
  800d2a:	e8 e7 f6 ff ff       	call   800416 <fd2data>
  800d2f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	bf 00 00 00 00       	mov    $0x0,%edi
  800d39:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d3c:	74 41                	je     800d7f <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d3e:	8b 53 04             	mov    0x4(%ebx),%edx
  800d41:	8b 03                	mov    (%ebx),%eax
  800d43:	83 c0 20             	add    $0x20,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	72 14                	jb     800d5e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d4a:	89 da                	mov    %ebx,%edx
  800d4c:	89 f0                	mov    %esi,%eax
  800d4e:	e8 65 ff ff ff       	call   800cb8 <_pipeisclosed>
  800d53:	85 c0                	test   %eax,%eax
  800d55:	75 2c                	jne    800d83 <devpipe_write+0x66>
			sys_yield();
  800d57:	e8 bc f4 ff ff       	call   800218 <sys_yield>
  800d5c:	eb e0                	jmp    800d3e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d64:	89 d0                	mov    %edx,%eax
  800d66:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d6b:	78 0b                	js     800d78 <devpipe_write+0x5b>
  800d6d:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d71:	42                   	inc    %edx
  800d72:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d75:	47                   	inc    %edi
  800d76:	eb c1                	jmp    800d39 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d78:	48                   	dec    %eax
  800d79:	83 c8 e0             	or     $0xffffffe0,%eax
  800d7c:	40                   	inc    %eax
  800d7d:	eb ee                	jmp    800d6d <devpipe_write+0x50>
	return i;
  800d7f:	89 f8                	mov    %edi,%eax
  800d81:	eb 05                	jmp    800d88 <devpipe_write+0x6b>
				return 0;
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <devpipe_read>:
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 18             	sub    $0x18,%esp
  800d99:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d9c:	57                   	push   %edi
  800d9d:	e8 74 f6 ff ff       	call   800416 <fd2data>
  800da2:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800da4:	83 c4 10             	add    $0x10,%esp
  800da7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dac:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800daf:	74 46                	je     800df7 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800db1:	8b 06                	mov    (%esi),%eax
  800db3:	3b 46 04             	cmp    0x4(%esi),%eax
  800db6:	75 22                	jne    800dda <devpipe_read+0x4a>
			if (i > 0)
  800db8:	85 db                	test   %ebx,%ebx
  800dba:	74 0a                	je     800dc6 <devpipe_read+0x36>
				return i;
  800dbc:	89 d8                	mov    %ebx,%eax
}
  800dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800dc6:	89 f2                	mov    %esi,%edx
  800dc8:	89 f8                	mov    %edi,%eax
  800dca:	e8 e9 fe ff ff       	call   800cb8 <_pipeisclosed>
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	75 28                	jne    800dfb <devpipe_read+0x6b>
			sys_yield();
  800dd3:	e8 40 f4 ff ff       	call   800218 <sys_yield>
  800dd8:	eb d7                	jmp    800db1 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dda:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800ddf:	78 0f                	js     800df0 <devpipe_read+0x60>
  800de1:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de8:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800deb:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800ded:	43                   	inc    %ebx
  800dee:	eb bc                	jmp    800dac <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800df0:	48                   	dec    %eax
  800df1:	83 c8 e0             	or     $0xffffffe0,%eax
  800df4:	40                   	inc    %eax
  800df5:	eb ea                	jmp    800de1 <devpipe_read+0x51>
	return i;
  800df7:	89 d8                	mov    %ebx,%eax
  800df9:	eb c3                	jmp    800dbe <devpipe_read+0x2e>
				return 0;
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	eb bc                	jmp    800dbe <devpipe_read+0x2e>

00800e02 <pipe>:
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
  800e07:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800e0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 1a f6 ff ff       	call   80042d <fd_alloc>
  800e13:	89 c3                	mov    %eax,%ebx
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	0f 88 2a 01 00 00    	js     800f4a <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e20:	83 ec 04             	sub    $0x4,%esp
  800e23:	68 07 04 00 00       	push   $0x407
  800e28:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2b:	6a 00                	push   $0x0
  800e2d:	e8 1f f3 ff ff       	call   800151 <sys_page_alloc>
  800e32:	89 c3                	mov    %eax,%ebx
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	85 c0                	test   %eax,%eax
  800e39:	0f 88 0b 01 00 00    	js     800f4a <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e45:	50                   	push   %eax
  800e46:	e8 e2 f5 ff ff       	call   80042d <fd_alloc>
  800e4b:	89 c3                	mov    %eax,%ebx
  800e4d:	83 c4 10             	add    $0x10,%esp
  800e50:	85 c0                	test   %eax,%eax
  800e52:	0f 88 e2 00 00 00    	js     800f3a <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e58:	83 ec 04             	sub    $0x4,%esp
  800e5b:	68 07 04 00 00       	push   $0x407
  800e60:	ff 75 f0             	pushl  -0x10(%ebp)
  800e63:	6a 00                	push   $0x0
  800e65:	e8 e7 f2 ff ff       	call   800151 <sys_page_alloc>
  800e6a:	89 c3                	mov    %eax,%ebx
  800e6c:	83 c4 10             	add    $0x10,%esp
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	0f 88 c3 00 00 00    	js     800f3a <pipe+0x138>
	va = fd2data(fd0);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e7d:	e8 94 f5 ff ff       	call   800416 <fd2data>
  800e82:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e84:	83 c4 0c             	add    $0xc,%esp
  800e87:	68 07 04 00 00       	push   $0x407
  800e8c:	50                   	push   %eax
  800e8d:	6a 00                	push   $0x0
  800e8f:	e8 bd f2 ff ff       	call   800151 <sys_page_alloc>
  800e94:	89 c3                	mov    %eax,%ebx
  800e96:	83 c4 10             	add    $0x10,%esp
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	0f 88 89 00 00 00    	js     800f2a <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ea1:	83 ec 0c             	sub    $0xc,%esp
  800ea4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea7:	e8 6a f5 ff ff       	call   800416 <fd2data>
  800eac:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800eb3:	50                   	push   %eax
  800eb4:	6a 00                	push   $0x0
  800eb6:	56                   	push   %esi
  800eb7:	6a 00                	push   $0x0
  800eb9:	e8 d6 f2 ff ff       	call   800194 <sys_page_map>
  800ebe:	89 c3                	mov    %eax,%ebx
  800ec0:	83 c4 20             	add    $0x20,%esp
  800ec3:	85 c0                	test   %eax,%eax
  800ec5:	78 55                	js     800f1c <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800ec7:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800edc:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eea:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800ef1:	83 ec 0c             	sub    $0xc,%esp
  800ef4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef7:	e8 0a f5 ff ff       	call   800406 <fd2num>
  800efc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eff:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800f01:	83 c4 04             	add    $0x4,%esp
  800f04:	ff 75 f0             	pushl  -0x10(%ebp)
  800f07:	e8 fa f4 ff ff       	call   800406 <fd2num>
  800f0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f0f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f12:	83 c4 10             	add    $0x10,%esp
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1a:	eb 2e                	jmp    800f4a <pipe+0x148>
	sys_page_unmap(0, va);
  800f1c:	83 ec 08             	sub    $0x8,%esp
  800f1f:	56                   	push   %esi
  800f20:	6a 00                	push   $0x0
  800f22:	e8 af f2 ff ff       	call   8001d6 <sys_page_unmap>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	ff 75 f0             	pushl  -0x10(%ebp)
  800f30:	6a 00                	push   $0x0
  800f32:	e8 9f f2 ff ff       	call   8001d6 <sys_page_unmap>
  800f37:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f40:	6a 00                	push   $0x0
  800f42:	e8 8f f2 ff ff       	call   8001d6 <sys_page_unmap>
  800f47:	83 c4 10             	add    $0x10,%esp
}
  800f4a:	89 d8                	mov    %ebx,%eax
  800f4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f4f:	5b                   	pop    %ebx
  800f50:	5e                   	pop    %esi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <pipeisclosed>:
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f5c:	50                   	push   %eax
  800f5d:	ff 75 08             	pushl  0x8(%ebp)
  800f60:	e8 17 f5 ff ff       	call   80047c <fd_lookup>
  800f65:	83 c4 10             	add    $0x10,%esp
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	78 18                	js     800f84 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f6c:	83 ec 0c             	sub    $0xc,%esp
  800f6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f72:	e8 9f f4 ff ff       	call   800416 <fd2data>
	return _pipeisclosed(fd, p);
  800f77:	89 c2                	mov    %eax,%edx
  800f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7c:	e8 37 fd ff ff       	call   800cb8 <_pipeisclosed>
  800f81:	83 c4 10             	add    $0x10,%esp
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800f89:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	53                   	push   %ebx
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800f9a:	68 22 20 80 00       	push   $0x802022
  800f9f:	53                   	push   %ebx
  800fa0:	e8 87 08 00 00       	call   80182c <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800fa5:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800fac:	20 00 00 
	return 0;
}
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    

00800fb9 <devcons_write>:
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
  800fbf:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fc5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fca:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fd0:	eb 1d                	jmp    800fef <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800fd2:	83 ec 04             	sub    $0x4,%esp
  800fd5:	53                   	push   %ebx
  800fd6:	03 45 0c             	add    0xc(%ebp),%eax
  800fd9:	50                   	push   %eax
  800fda:	57                   	push   %edi
  800fdb:	e8 bf 09 00 00       	call   80199f <memmove>
		sys_cputs(buf, m);
  800fe0:	83 c4 08             	add    $0x8,%esp
  800fe3:	53                   	push   %ebx
  800fe4:	57                   	push   %edi
  800fe5:	e8 ca f0 ff ff       	call   8000b4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fea:	01 de                	add    %ebx,%esi
  800fec:	83 c4 10             	add    $0x10,%esp
  800fef:	89 f0                	mov    %esi,%eax
  800ff1:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ff4:	73 11                	jae    801007 <devcons_write+0x4e>
		m = n - tot;
  800ff6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff9:	29 f3                	sub    %esi,%ebx
  800ffb:	83 fb 7f             	cmp    $0x7f,%ebx
  800ffe:	76 d2                	jbe    800fd2 <devcons_write+0x19>
  801000:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801005:	eb cb                	jmp    800fd2 <devcons_write+0x19>
}
  801007:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5f                   	pop    %edi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <devcons_read>:
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801015:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801019:	75 0c                	jne    801027 <devcons_read+0x18>
		return 0;
  80101b:	b8 00 00 00 00       	mov    $0x0,%eax
  801020:	eb 21                	jmp    801043 <devcons_read+0x34>
		sys_yield();
  801022:	e8 f1 f1 ff ff       	call   800218 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801027:	e8 a6 f0 ff ff       	call   8000d2 <sys_cgetc>
  80102c:	85 c0                	test   %eax,%eax
  80102e:	74 f2                	je     801022 <devcons_read+0x13>
	if (c < 0)
  801030:	85 c0                	test   %eax,%eax
  801032:	78 0f                	js     801043 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801034:	83 f8 04             	cmp    $0x4,%eax
  801037:	74 0c                	je     801045 <devcons_read+0x36>
	*(char*)vbuf = c;
  801039:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103c:	88 02                	mov    %al,(%edx)
	return 1;
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    
		return 0;
  801045:	b8 00 00 00 00       	mov    $0x0,%eax
  80104a:	eb f7                	jmp    801043 <devcons_read+0x34>

0080104c <cputchar>:
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801058:	6a 01                	push   $0x1
  80105a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80105d:	50                   	push   %eax
  80105e:	e8 51 f0 ff ff       	call   8000b4 <sys_cputs>
}
  801063:	83 c4 10             	add    $0x10,%esp
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <getchar>:
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80106e:	6a 01                	push   $0x1
  801070:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801073:	50                   	push   %eax
  801074:	6a 00                	push   $0x0
  801076:	e8 6e f6 ff ff       	call   8006e9 <read>
	if (r < 0)
  80107b:	83 c4 10             	add    $0x10,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 08                	js     80108a <getchar+0x22>
	if (r < 1)
  801082:	85 c0                	test   %eax,%eax
  801084:	7e 06                	jle    80108c <getchar+0x24>
	return c;
  801086:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    
		return -E_EOF;
  80108c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801091:	eb f7                	jmp    80108a <getchar+0x22>

00801093 <iscons>:
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801099:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80109c:	50                   	push   %eax
  80109d:	ff 75 08             	pushl  0x8(%ebp)
  8010a0:	e8 d7 f3 ff ff       	call   80047c <fd_lookup>
  8010a5:	83 c4 10             	add    $0x10,%esp
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	78 11                	js     8010bd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8010ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010af:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8010b5:	39 10                	cmp    %edx,(%eax)
  8010b7:	0f 94 c0             	sete   %al
  8010ba:	0f b6 c0             	movzbl %al,%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <opencons>:
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c8:	50                   	push   %eax
  8010c9:	e8 5f f3 ff ff       	call   80042d <fd_alloc>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	78 3a                	js     80110f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 07 04 00 00       	push   $0x407
  8010dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8010e0:	6a 00                	push   $0x0
  8010e2:	e8 6a f0 ff ff       	call   800151 <sys_page_alloc>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	78 21                	js     80110f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8010ee:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8010f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801103:	83 ec 0c             	sub    $0xc,%esp
  801106:	50                   	push   %eax
  801107:	e8 fa f2 ff ff       	call   800406 <fd2num>
  80110c:	83 c4 10             	add    $0x10,%esp
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	57                   	push   %edi
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
  801117:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80111d:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801120:	8b 1d 04 30 80 00    	mov    0x803004,%ebx
  801126:	e8 07 f0 ff ff       	call   800132 <sys_getenvid>
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	ff 75 0c             	pushl  0xc(%ebp)
  801131:	ff 75 08             	pushl  0x8(%ebp)
  801134:	53                   	push   %ebx
  801135:	50                   	push   %eax
  801136:	68 30 20 80 00       	push   $0x802030
  80113b:	68 00 01 00 00       	push   $0x100
  801140:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801146:	56                   	push   %esi
  801147:	e8 93 06 00 00       	call   8017df <snprintf>
  80114c:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80114e:	83 c4 20             	add    $0x20,%esp
  801151:	57                   	push   %edi
  801152:	ff 75 10             	pushl  0x10(%ebp)
  801155:	bf 00 01 00 00       	mov    $0x100,%edi
  80115a:	89 f8                	mov    %edi,%eax
  80115c:	29 d8                	sub    %ebx,%eax
  80115e:	50                   	push   %eax
  80115f:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801162:	50                   	push   %eax
  801163:	e8 22 06 00 00       	call   80178a <vsnprintf>
  801168:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80116a:	83 c4 0c             	add    $0xc,%esp
  80116d:	68 1b 20 80 00       	push   $0x80201b
  801172:	29 df                	sub    %ebx,%edi
  801174:	57                   	push   %edi
  801175:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801178:	50                   	push   %eax
  801179:	e8 61 06 00 00       	call   8017df <snprintf>
	sys_cputs(buf, r);
  80117e:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801181:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801183:	53                   	push   %ebx
  801184:	56                   	push   %esi
  801185:	e8 2a ef ff ff       	call   8000b4 <sys_cputs>
  80118a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80118d:	cc                   	int3   
  80118e:	eb fd                	jmp    80118d <_panic+0x7c>

00801190 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	53                   	push   %ebx
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80119a:	8b 13                	mov    (%ebx),%edx
  80119c:	8d 42 01             	lea    0x1(%edx),%eax
  80119f:	89 03                	mov    %eax,(%ebx)
  8011a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8011a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011ad:	74 08                	je     8011b7 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8011af:	ff 43 04             	incl   0x4(%ebx)
}
  8011b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	68 ff 00 00 00       	push   $0xff
  8011bf:	8d 43 08             	lea    0x8(%ebx),%eax
  8011c2:	50                   	push   %eax
  8011c3:	e8 ec ee ff ff       	call   8000b4 <sys_cputs>
		b->idx = 0;
  8011c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	eb dc                	jmp    8011af <putch+0x1f>

008011d3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011dc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011e3:	00 00 00 
	b.cnt = 0;
  8011e6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011ed:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011f0:	ff 75 0c             	pushl  0xc(%ebp)
  8011f3:	ff 75 08             	pushl  0x8(%ebp)
  8011f6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011fc:	50                   	push   %eax
  8011fd:	68 90 11 80 00       	push   $0x801190
  801202:	e8 17 01 00 00       	call   80131e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801207:	83 c4 08             	add    $0x8,%esp
  80120a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801210:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801216:	50                   	push   %eax
  801217:	e8 98 ee ff ff       	call   8000b4 <sys_cputs>

	return b.cnt;
}
  80121c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80122a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80122d:	50                   	push   %eax
  80122e:	ff 75 08             	pushl  0x8(%ebp)
  801231:	e8 9d ff ff ff       	call   8011d3 <vcprintf>
	va_end(ap);

	return cnt;
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	57                   	push   %edi
  80123c:	56                   	push   %esi
  80123d:	53                   	push   %ebx
  80123e:	83 ec 1c             	sub    $0x1c,%esp
  801241:	89 c7                	mov    %eax,%edi
  801243:	89 d6                	mov    %edx,%esi
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80124e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801251:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
  801259:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80125c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80125f:	39 d3                	cmp    %edx,%ebx
  801261:	72 05                	jb     801268 <printnum+0x30>
  801263:	39 45 10             	cmp    %eax,0x10(%ebp)
  801266:	77 78                	ja     8012e0 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801268:	83 ec 0c             	sub    $0xc,%esp
  80126b:	ff 75 18             	pushl  0x18(%ebp)
  80126e:	8b 45 14             	mov    0x14(%ebp),%eax
  801271:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801274:	53                   	push   %ebx
  801275:	ff 75 10             	pushl  0x10(%ebp)
  801278:	83 ec 08             	sub    $0x8,%esp
  80127b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80127e:	ff 75 e0             	pushl  -0x20(%ebp)
  801281:	ff 75 dc             	pushl  -0x24(%ebp)
  801284:	ff 75 d8             	pushl  -0x28(%ebp)
  801287:	e8 24 0a 00 00       	call   801cb0 <__udivdi3>
  80128c:	83 c4 18             	add    $0x18,%esp
  80128f:	52                   	push   %edx
  801290:	50                   	push   %eax
  801291:	89 f2                	mov    %esi,%edx
  801293:	89 f8                	mov    %edi,%eax
  801295:	e8 9e ff ff ff       	call   801238 <printnum>
  80129a:	83 c4 20             	add    $0x20,%esp
  80129d:	eb 11                	jmp    8012b0 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	56                   	push   %esi
  8012a3:	ff 75 18             	pushl  0x18(%ebp)
  8012a6:	ff d7                	call   *%edi
  8012a8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8012ab:	4b                   	dec    %ebx
  8012ac:	85 db                	test   %ebx,%ebx
  8012ae:	7f ef                	jg     80129f <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	56                   	push   %esi
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8012bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8012c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8012c3:	e8 f8 0a 00 00       	call   801dc0 <__umoddi3>
  8012c8:	83 c4 14             	add    $0x14,%esp
  8012cb:	0f be 80 53 20 80 00 	movsbl 0x802053(%eax),%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff d7                	call   *%edi
}
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
  8012e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e3:	eb c6                	jmp    8012ab <printnum+0x73>

008012e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012eb:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8012ee:	8b 10                	mov    (%eax),%edx
  8012f0:	3b 50 04             	cmp    0x4(%eax),%edx
  8012f3:	73 0a                	jae    8012ff <sprintputch+0x1a>
		*b->buf++ = ch;
  8012f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f8:	89 08                	mov    %ecx,(%eax)
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	88 02                	mov    %al,(%edx)
}
  8012ff:	5d                   	pop    %ebp
  801300:	c3                   	ret    

00801301 <printfmt>:
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801307:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80130a:	50                   	push   %eax
  80130b:	ff 75 10             	pushl  0x10(%ebp)
  80130e:	ff 75 0c             	pushl  0xc(%ebp)
  801311:	ff 75 08             	pushl  0x8(%ebp)
  801314:	e8 05 00 00 00       	call   80131e <vprintfmt>
}
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <vprintfmt>:
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	57                   	push   %edi
  801322:	56                   	push   %esi
  801323:	53                   	push   %ebx
  801324:	83 ec 2c             	sub    $0x2c,%esp
  801327:	8b 75 08             	mov    0x8(%ebp),%esi
  80132a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80132d:	8b 7d 10             	mov    0x10(%ebp),%edi
  801330:	e9 ae 03 00 00       	jmp    8016e3 <vprintfmt+0x3c5>
  801335:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801339:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801340:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801347:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80134e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801353:	8d 47 01             	lea    0x1(%edi),%eax
  801356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801359:	8a 17                	mov    (%edi),%dl
  80135b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80135e:	3c 55                	cmp    $0x55,%al
  801360:	0f 87 fe 03 00 00    	ja     801764 <vprintfmt+0x446>
  801366:	0f b6 c0             	movzbl %al,%eax
  801369:	ff 24 85 a0 21 80 00 	jmp    *0x8021a0(,%eax,4)
  801370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801373:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801377:	eb da                	jmp    801353 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80137c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801380:	eb d1                	jmp    801353 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801382:	0f b6 d2             	movzbl %dl,%edx
  801385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801388:	b8 00 00 00 00       	mov    $0x0,%eax
  80138d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801390:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801393:	01 c0                	add    %eax,%eax
  801395:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  801399:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80139c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80139f:	83 f9 09             	cmp    $0x9,%ecx
  8013a2:	77 52                	ja     8013f6 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8013a4:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8013a5:	eb e9                	jmp    801390 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8013a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013aa:	8b 00                	mov    (%eax),%eax
  8013ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013af:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b2:	8d 40 04             	lea    0x4(%eax),%eax
  8013b5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013bf:	79 92                	jns    801353 <vprintfmt+0x35>
				width = precision, precision = -1;
  8013c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013c7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013ce:	eb 83                	jmp    801353 <vprintfmt+0x35>
  8013d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013d4:	78 08                	js     8013de <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8013d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013d9:	e9 75 ff ff ff       	jmp    801353 <vprintfmt+0x35>
  8013de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013e5:	eb ef                	jmp    8013d6 <vprintfmt+0xb8>
  8013e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013ea:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8013f1:	e9 5d ff ff ff       	jmp    801353 <vprintfmt+0x35>
  8013f6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013fc:	eb bd                	jmp    8013bb <vprintfmt+0x9d>
			lflag++;
  8013fe:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801402:	e9 4c ff ff ff       	jmp    801353 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801407:	8b 45 14             	mov    0x14(%ebp),%eax
  80140a:	8d 78 04             	lea    0x4(%eax),%edi
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	53                   	push   %ebx
  801411:	ff 30                	pushl  (%eax)
  801413:	ff d6                	call   *%esi
			break;
  801415:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801418:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80141b:	e9 c0 02 00 00       	jmp    8016e0 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  801420:	8b 45 14             	mov    0x14(%ebp),%eax
  801423:	8d 78 04             	lea    0x4(%eax),%edi
  801426:	8b 00                	mov    (%eax),%eax
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 2a                	js     801456 <vprintfmt+0x138>
  80142c:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80142e:	83 f8 0f             	cmp    $0xf,%eax
  801431:	7f 27                	jg     80145a <vprintfmt+0x13c>
  801433:	8b 04 85 00 23 80 00 	mov    0x802300(,%eax,4),%eax
  80143a:	85 c0                	test   %eax,%eax
  80143c:	74 1c                	je     80145a <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80143e:	50                   	push   %eax
  80143f:	68 e9 1f 80 00       	push   $0x801fe9
  801444:	53                   	push   %ebx
  801445:	56                   	push   %esi
  801446:	e8 b6 fe ff ff       	call   801301 <printfmt>
  80144b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80144e:	89 7d 14             	mov    %edi,0x14(%ebp)
  801451:	e9 8a 02 00 00       	jmp    8016e0 <vprintfmt+0x3c2>
  801456:	f7 d8                	neg    %eax
  801458:	eb d2                	jmp    80142c <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80145a:	52                   	push   %edx
  80145b:	68 6b 20 80 00       	push   $0x80206b
  801460:	53                   	push   %ebx
  801461:	56                   	push   %esi
  801462:	e8 9a fe ff ff       	call   801301 <printfmt>
  801467:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80146a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80146d:	e9 6e 02 00 00       	jmp    8016e0 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  801472:	8b 45 14             	mov    0x14(%ebp),%eax
  801475:	83 c0 04             	add    $0x4,%eax
  801478:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80147b:	8b 45 14             	mov    0x14(%ebp),%eax
  80147e:	8b 38                	mov    (%eax),%edi
  801480:	85 ff                	test   %edi,%edi
  801482:	74 39                	je     8014bd <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  801484:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801488:	0f 8e a9 00 00 00    	jle    801537 <vprintfmt+0x219>
  80148e:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801492:	0f 84 a7 00 00 00    	je     80153f <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	ff 75 d0             	pushl  -0x30(%ebp)
  80149e:	57                   	push   %edi
  80149f:	e8 6b 03 00 00       	call   80180f <strnlen>
  8014a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014a7:	29 c1                	sub    %eax,%ecx
  8014a9:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8014ac:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8014af:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8014b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014b6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014b9:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014bb:	eb 14                	jmp    8014d1 <vprintfmt+0x1b3>
				p = "(null)";
  8014bd:	bf 64 20 80 00       	mov    $0x802064,%edi
  8014c2:	eb c0                	jmp    801484 <vprintfmt+0x166>
					putch(padc, putdat);
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	53                   	push   %ebx
  8014c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8014cb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014cd:	4f                   	dec    %edi
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 ff                	test   %edi,%edi
  8014d3:	7f ef                	jg     8014c4 <vprintfmt+0x1a6>
  8014d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8014d8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014db:	89 c8                	mov    %ecx,%eax
  8014dd:	85 c9                	test   %ecx,%ecx
  8014df:	78 10                	js     8014f1 <vprintfmt+0x1d3>
  8014e1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014e4:	29 c1                	sub    %eax,%ecx
  8014e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8014e9:	89 75 08             	mov    %esi,0x8(%ebp)
  8014ec:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8014ef:	eb 15                	jmp    801506 <vprintfmt+0x1e8>
  8014f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f6:	eb e9                	jmp    8014e1 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	53                   	push   %ebx
  8014fc:	52                   	push   %edx
  8014fd:	ff 55 08             	call   *0x8(%ebp)
  801500:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801503:	ff 4d e0             	decl   -0x20(%ebp)
  801506:	47                   	inc    %edi
  801507:	8a 47 ff             	mov    -0x1(%edi),%al
  80150a:	0f be d0             	movsbl %al,%edx
  80150d:	85 d2                	test   %edx,%edx
  80150f:	74 59                	je     80156a <vprintfmt+0x24c>
  801511:	85 f6                	test   %esi,%esi
  801513:	78 03                	js     801518 <vprintfmt+0x1fa>
  801515:	4e                   	dec    %esi
  801516:	78 2f                	js     801547 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801518:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80151c:	74 da                	je     8014f8 <vprintfmt+0x1da>
  80151e:	0f be c0             	movsbl %al,%eax
  801521:	83 e8 20             	sub    $0x20,%eax
  801524:	83 f8 5e             	cmp    $0x5e,%eax
  801527:	76 cf                	jbe    8014f8 <vprintfmt+0x1da>
					putch('?', putdat);
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	53                   	push   %ebx
  80152d:	6a 3f                	push   $0x3f
  80152f:	ff 55 08             	call   *0x8(%ebp)
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	eb cc                	jmp    801503 <vprintfmt+0x1e5>
  801537:	89 75 08             	mov    %esi,0x8(%ebp)
  80153a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80153d:	eb c7                	jmp    801506 <vprintfmt+0x1e8>
  80153f:	89 75 08             	mov    %esi,0x8(%ebp)
  801542:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801545:	eb bf                	jmp    801506 <vprintfmt+0x1e8>
  801547:	8b 75 08             	mov    0x8(%ebp),%esi
  80154a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80154d:	eb 0c                	jmp    80155b <vprintfmt+0x23d>
				putch(' ', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	53                   	push   %ebx
  801553:	6a 20                	push   $0x20
  801555:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801557:	4f                   	dec    %edi
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 ff                	test   %edi,%edi
  80155d:	7f f0                	jg     80154f <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80155f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801562:	89 45 14             	mov    %eax,0x14(%ebp)
  801565:	e9 76 01 00 00       	jmp    8016e0 <vprintfmt+0x3c2>
  80156a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80156d:	8b 75 08             	mov    0x8(%ebp),%esi
  801570:	eb e9                	jmp    80155b <vprintfmt+0x23d>
	if (lflag >= 2)
  801572:	83 f9 01             	cmp    $0x1,%ecx
  801575:	7f 1f                	jg     801596 <vprintfmt+0x278>
	else if (lflag)
  801577:	85 c9                	test   %ecx,%ecx
  801579:	75 48                	jne    8015c3 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80157b:	8b 45 14             	mov    0x14(%ebp),%eax
  80157e:	8b 00                	mov    (%eax),%eax
  801580:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801583:	89 c1                	mov    %eax,%ecx
  801585:	c1 f9 1f             	sar    $0x1f,%ecx
  801588:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	8d 40 04             	lea    0x4(%eax),%eax
  801591:	89 45 14             	mov    %eax,0x14(%ebp)
  801594:	eb 17                	jmp    8015ad <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  801596:	8b 45 14             	mov    0x14(%ebp),%eax
  801599:	8b 50 04             	mov    0x4(%eax),%edx
  80159c:	8b 00                	mov    (%eax),%eax
  80159e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8015a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a7:	8d 40 08             	lea    0x8(%eax),%eax
  8015aa:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8015ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015b0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8015b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015b7:	78 25                	js     8015de <vprintfmt+0x2c0>
			base = 10;
  8015b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015be:	e9 03 01 00 00       	jmp    8016c6 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c6:	8b 00                	mov    (%eax),%eax
  8015c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015cb:	89 c1                	mov    %eax,%ecx
  8015cd:	c1 f9 1f             	sar    $0x1f,%ecx
  8015d0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d6:	8d 40 04             	lea    0x4(%eax),%eax
  8015d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8015dc:	eb cf                	jmp    8015ad <vprintfmt+0x28f>
				putch('-', putdat);
  8015de:	83 ec 08             	sub    $0x8,%esp
  8015e1:	53                   	push   %ebx
  8015e2:	6a 2d                	push   $0x2d
  8015e4:	ff d6                	call   *%esi
				num = -(long long) num;
  8015e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8015ec:	f7 da                	neg    %edx
  8015ee:	83 d1 00             	adc    $0x0,%ecx
  8015f1:	f7 d9                	neg    %ecx
  8015f3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8015f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015fb:	e9 c6 00 00 00       	jmp    8016c6 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801600:	83 f9 01             	cmp    $0x1,%ecx
  801603:	7f 1e                	jg     801623 <vprintfmt+0x305>
	else if (lflag)
  801605:	85 c9                	test   %ecx,%ecx
  801607:	75 32                	jne    80163b <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  801609:	8b 45 14             	mov    0x14(%ebp),%eax
  80160c:	8b 10                	mov    (%eax),%edx
  80160e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801613:	8d 40 04             	lea    0x4(%eax),%eax
  801616:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801619:	b8 0a 00 00 00       	mov    $0xa,%eax
  80161e:	e9 a3 00 00 00       	jmp    8016c6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801623:	8b 45 14             	mov    0x14(%ebp),%eax
  801626:	8b 10                	mov    (%eax),%edx
  801628:	8b 48 04             	mov    0x4(%eax),%ecx
  80162b:	8d 40 08             	lea    0x8(%eax),%eax
  80162e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801631:	b8 0a 00 00 00       	mov    $0xa,%eax
  801636:	e9 8b 00 00 00       	jmp    8016c6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80163b:	8b 45 14             	mov    0x14(%ebp),%eax
  80163e:	8b 10                	mov    (%eax),%edx
  801640:	b9 00 00 00 00       	mov    $0x0,%ecx
  801645:	8d 40 04             	lea    0x4(%eax),%eax
  801648:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80164b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801650:	eb 74                	jmp    8016c6 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801652:	83 f9 01             	cmp    $0x1,%ecx
  801655:	7f 1b                	jg     801672 <vprintfmt+0x354>
	else if (lflag)
  801657:	85 c9                	test   %ecx,%ecx
  801659:	75 2c                	jne    801687 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80165b:	8b 45 14             	mov    0x14(%ebp),%eax
  80165e:	8b 10                	mov    (%eax),%edx
  801660:	b9 00 00 00 00       	mov    $0x0,%ecx
  801665:	8d 40 04             	lea    0x4(%eax),%eax
  801668:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80166b:	b8 08 00 00 00       	mov    $0x8,%eax
  801670:	eb 54                	jmp    8016c6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801672:	8b 45 14             	mov    0x14(%ebp),%eax
  801675:	8b 10                	mov    (%eax),%edx
  801677:	8b 48 04             	mov    0x4(%eax),%ecx
  80167a:	8d 40 08             	lea    0x8(%eax),%eax
  80167d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801680:	b8 08 00 00 00       	mov    $0x8,%eax
  801685:	eb 3f                	jmp    8016c6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801687:	8b 45 14             	mov    0x14(%ebp),%eax
  80168a:	8b 10                	mov    (%eax),%edx
  80168c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801691:	8d 40 04             	lea    0x4(%eax),%eax
  801694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801697:	b8 08 00 00 00       	mov    $0x8,%eax
  80169c:	eb 28                	jmp    8016c6 <vprintfmt+0x3a8>
			putch('0', putdat);
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	53                   	push   %ebx
  8016a2:	6a 30                	push   $0x30
  8016a4:	ff d6                	call   *%esi
			putch('x', putdat);
  8016a6:	83 c4 08             	add    $0x8,%esp
  8016a9:	53                   	push   %ebx
  8016aa:	6a 78                	push   $0x78
  8016ac:	ff d6                	call   *%esi
			num = (unsigned long long)
  8016ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b1:	8b 10                	mov    (%eax),%edx
  8016b3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016b8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016bb:	8d 40 04             	lea    0x4(%eax),%eax
  8016be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016c1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016cd:	57                   	push   %edi
  8016ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8016d1:	50                   	push   %eax
  8016d2:	51                   	push   %ecx
  8016d3:	52                   	push   %edx
  8016d4:	89 da                	mov    %ebx,%edx
  8016d6:	89 f0                	mov    %esi,%eax
  8016d8:	e8 5b fb ff ff       	call   801238 <printnum>
			break;
  8016dd:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8016e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016e3:	47                   	inc    %edi
  8016e4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016e8:	83 f8 25             	cmp    $0x25,%eax
  8016eb:	0f 84 44 fc ff ff    	je     801335 <vprintfmt+0x17>
			if (ch == '\0')
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	0f 84 89 00 00 00    	je     801782 <vprintfmt+0x464>
			putch(ch, putdat);
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	53                   	push   %ebx
  8016fd:	50                   	push   %eax
  8016fe:	ff d6                	call   *%esi
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	eb de                	jmp    8016e3 <vprintfmt+0x3c5>
	if (lflag >= 2)
  801705:	83 f9 01             	cmp    $0x1,%ecx
  801708:	7f 1b                	jg     801725 <vprintfmt+0x407>
	else if (lflag)
  80170a:	85 c9                	test   %ecx,%ecx
  80170c:	75 2c                	jne    80173a <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80170e:	8b 45 14             	mov    0x14(%ebp),%eax
  801711:	8b 10                	mov    (%eax),%edx
  801713:	b9 00 00 00 00       	mov    $0x0,%ecx
  801718:	8d 40 04             	lea    0x4(%eax),%eax
  80171b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80171e:	b8 10 00 00 00       	mov    $0x10,%eax
  801723:	eb a1                	jmp    8016c6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801725:	8b 45 14             	mov    0x14(%ebp),%eax
  801728:	8b 10                	mov    (%eax),%edx
  80172a:	8b 48 04             	mov    0x4(%eax),%ecx
  80172d:	8d 40 08             	lea    0x8(%eax),%eax
  801730:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801733:	b8 10 00 00 00       	mov    $0x10,%eax
  801738:	eb 8c                	jmp    8016c6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80173a:	8b 45 14             	mov    0x14(%ebp),%eax
  80173d:	8b 10                	mov    (%eax),%edx
  80173f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801744:	8d 40 04             	lea    0x4(%eax),%eax
  801747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80174a:	b8 10 00 00 00       	mov    $0x10,%eax
  80174f:	e9 72 ff ff ff       	jmp    8016c6 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	53                   	push   %ebx
  801758:	6a 25                	push   $0x25
  80175a:	ff d6                	call   *%esi
			break;
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	e9 7c ff ff ff       	jmp    8016e0 <vprintfmt+0x3c2>
			putch('%', putdat);
  801764:	83 ec 08             	sub    $0x8,%esp
  801767:	53                   	push   %ebx
  801768:	6a 25                	push   $0x25
  80176a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	89 f8                	mov    %edi,%eax
  801771:	eb 01                	jmp    801774 <vprintfmt+0x456>
  801773:	48                   	dec    %eax
  801774:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801778:	75 f9                	jne    801773 <vprintfmt+0x455>
  80177a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80177d:	e9 5e ff ff ff       	jmp    8016e0 <vprintfmt+0x3c2>
}
  801782:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5f                   	pop    %edi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    

0080178a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 18             	sub    $0x18,%esp
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801796:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801799:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80179d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8017a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	74 26                	je     8017d1 <vsnprintf+0x47>
  8017ab:	85 d2                	test   %edx,%edx
  8017ad:	7e 29                	jle    8017d8 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017af:	ff 75 14             	pushl  0x14(%ebp)
  8017b2:	ff 75 10             	pushl  0x10(%ebp)
  8017b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b8:	50                   	push   %eax
  8017b9:	68 e5 12 80 00       	push   $0x8012e5
  8017be:	e8 5b fb ff ff       	call   80131e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cc:	83 c4 10             	add    $0x10,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    
		return -E_INVAL;
  8017d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d6:	eb f7                	jmp    8017cf <vsnprintf+0x45>
  8017d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017dd:	eb f0                	jmp    8017cf <vsnprintf+0x45>

008017df <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017e5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017e8:	50                   	push   %eax
  8017e9:	ff 75 10             	pushl  0x10(%ebp)
  8017ec:	ff 75 0c             	pushl  0xc(%ebp)
  8017ef:	ff 75 08             	pushl  0x8(%ebp)
  8017f2:	e8 93 ff ff ff       	call   80178a <vsnprintf>
	va_end(ap);

	return rc;
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801804:	eb 01                	jmp    801807 <strlen+0xe>
		n++;
  801806:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  801807:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80180b:	75 f9                	jne    801806 <strlen+0xd>
	return n;
}
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801815:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
  80181d:	eb 01                	jmp    801820 <strnlen+0x11>
		n++;
  80181f:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801820:	39 d0                	cmp    %edx,%eax
  801822:	74 06                	je     80182a <strnlen+0x1b>
  801824:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801828:	75 f5                	jne    80181f <strnlen+0x10>
	return n;
}
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    

0080182c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	53                   	push   %ebx
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801836:	89 c2                	mov    %eax,%edx
  801838:	42                   	inc    %edx
  801839:	41                   	inc    %ecx
  80183a:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80183d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801840:	84 db                	test   %bl,%bl
  801842:	75 f4                	jne    801838 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801844:	5b                   	pop    %ebx
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    

00801847 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	53                   	push   %ebx
  80184b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80184e:	53                   	push   %ebx
  80184f:	e8 a5 ff ff ff       	call   8017f9 <strlen>
  801854:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	01 d8                	add    %ebx,%eax
  80185c:	50                   	push   %eax
  80185d:	e8 ca ff ff ff       	call   80182c <strcpy>
	return dst;
}
  801862:	89 d8                	mov    %ebx,%eax
  801864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	56                   	push   %esi
  80186d:	53                   	push   %ebx
  80186e:	8b 75 08             	mov    0x8(%ebp),%esi
  801871:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801874:	89 f3                	mov    %esi,%ebx
  801876:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801879:	89 f2                	mov    %esi,%edx
  80187b:	eb 0c                	jmp    801889 <strncpy+0x20>
		*dst++ = *src;
  80187d:	42                   	inc    %edx
  80187e:	8a 01                	mov    (%ecx),%al
  801880:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801883:	80 39 01             	cmpb   $0x1,(%ecx)
  801886:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801889:	39 da                	cmp    %ebx,%edx
  80188b:	75 f0                	jne    80187d <strncpy+0x14>
	}
	return ret;
}
  80188d:	89 f0                	mov    %esi,%eax
  80188f:	5b                   	pop    %ebx
  801890:	5e                   	pop    %esi
  801891:	5d                   	pop    %ebp
  801892:	c3                   	ret    

00801893 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
  801898:	8b 75 08             	mov    0x8(%ebp),%esi
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	74 20                	je     8018c5 <strlcpy+0x32>
  8018a5:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8018a9:	89 f0                	mov    %esi,%eax
  8018ab:	eb 05                	jmp    8018b2 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8018ad:	40                   	inc    %eax
  8018ae:	42                   	inc    %edx
  8018af:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8018b2:	39 d8                	cmp    %ebx,%eax
  8018b4:	74 06                	je     8018bc <strlcpy+0x29>
  8018b6:	8a 0a                	mov    (%edx),%cl
  8018b8:	84 c9                	test   %cl,%cl
  8018ba:	75 f1                	jne    8018ad <strlcpy+0x1a>
		*dst = '\0';
  8018bc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018bf:	29 f0                	sub    %esi,%eax
}
  8018c1:	5b                   	pop    %ebx
  8018c2:	5e                   	pop    %esi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    
  8018c5:	89 f0                	mov    %esi,%eax
  8018c7:	eb f6                	jmp    8018bf <strlcpy+0x2c>

008018c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018d2:	eb 02                	jmp    8018d6 <strcmp+0xd>
		p++, q++;
  8018d4:	41                   	inc    %ecx
  8018d5:	42                   	inc    %edx
	while (*p && *p == *q)
  8018d6:	8a 01                	mov    (%ecx),%al
  8018d8:	84 c0                	test   %al,%al
  8018da:	74 04                	je     8018e0 <strcmp+0x17>
  8018dc:	3a 02                	cmp    (%edx),%al
  8018de:	74 f4                	je     8018d4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018e0:	0f b6 c0             	movzbl %al,%eax
  8018e3:	0f b6 12             	movzbl (%edx),%edx
  8018e6:	29 d0                	sub    %edx,%eax
}
  8018e8:	5d                   	pop    %ebp
  8018e9:	c3                   	ret    

008018ea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	53                   	push   %ebx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f4:	89 c3                	mov    %eax,%ebx
  8018f6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018f9:	eb 02                	jmp    8018fd <strncmp+0x13>
		n--, p++, q++;
  8018fb:	40                   	inc    %eax
  8018fc:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8018fd:	39 d8                	cmp    %ebx,%eax
  8018ff:	74 15                	je     801916 <strncmp+0x2c>
  801901:	8a 08                	mov    (%eax),%cl
  801903:	84 c9                	test   %cl,%cl
  801905:	74 04                	je     80190b <strncmp+0x21>
  801907:	3a 0a                	cmp    (%edx),%cl
  801909:	74 f0                	je     8018fb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80190b:	0f b6 00             	movzbl (%eax),%eax
  80190e:	0f b6 12             	movzbl (%edx),%edx
  801911:	29 d0                	sub    %edx,%eax
}
  801913:	5b                   	pop    %ebx
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    
		return 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	eb f6                	jmp    801913 <strncmp+0x29>

0080191d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801926:	8a 10                	mov    (%eax),%dl
  801928:	84 d2                	test   %dl,%dl
  80192a:	74 07                	je     801933 <strchr+0x16>
		if (*s == c)
  80192c:	38 ca                	cmp    %cl,%dl
  80192e:	74 08                	je     801938 <strchr+0x1b>
	for (; *s; s++)
  801930:	40                   	inc    %eax
  801931:	eb f3                	jmp    801926 <strchr+0x9>
			return (char *) s;
	return 0;
  801933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    

0080193a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801943:	8a 10                	mov    (%eax),%dl
  801945:	84 d2                	test   %dl,%dl
  801947:	74 07                	je     801950 <strfind+0x16>
		if (*s == c)
  801949:	38 ca                	cmp    %cl,%dl
  80194b:	74 03                	je     801950 <strfind+0x16>
	for (; *s; s++)
  80194d:	40                   	inc    %eax
  80194e:	eb f3                	jmp    801943 <strfind+0x9>
			break;
	return (char *) s;
}
  801950:	5d                   	pop    %ebp
  801951:	c3                   	ret    

00801952 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	57                   	push   %edi
  801956:	56                   	push   %esi
  801957:	53                   	push   %ebx
  801958:	8b 7d 08             	mov    0x8(%ebp),%edi
  80195b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80195e:	85 c9                	test   %ecx,%ecx
  801960:	74 13                	je     801975 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801962:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801968:	75 05                	jne    80196f <memset+0x1d>
  80196a:	f6 c1 03             	test   $0x3,%cl
  80196d:	74 0d                	je     80197c <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	fc                   	cld    
  801973:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801975:	89 f8                	mov    %edi,%eax
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5f                   	pop    %edi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    
		c &= 0xFF;
  80197c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801980:	89 d3                	mov    %edx,%ebx
  801982:	c1 e3 08             	shl    $0x8,%ebx
  801985:	89 d0                	mov    %edx,%eax
  801987:	c1 e0 18             	shl    $0x18,%eax
  80198a:	89 d6                	mov    %edx,%esi
  80198c:	c1 e6 10             	shl    $0x10,%esi
  80198f:	09 f0                	or     %esi,%eax
  801991:	09 c2                	or     %eax,%edx
  801993:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801995:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801998:	89 d0                	mov    %edx,%eax
  80199a:	fc                   	cld    
  80199b:	f3 ab                	rep stos %eax,%es:(%edi)
  80199d:	eb d6                	jmp    801975 <memset+0x23>

0080199f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	57                   	push   %edi
  8019a3:	56                   	push   %esi
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019ad:	39 c6                	cmp    %eax,%esi
  8019af:	73 33                	jae    8019e4 <memmove+0x45>
  8019b1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019b4:	39 d0                	cmp    %edx,%eax
  8019b6:	73 2c                	jae    8019e4 <memmove+0x45>
		s += n;
		d += n;
  8019b8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019bb:	89 d6                	mov    %edx,%esi
  8019bd:	09 fe                	or     %edi,%esi
  8019bf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019c5:	75 13                	jne    8019da <memmove+0x3b>
  8019c7:	f6 c1 03             	test   $0x3,%cl
  8019ca:	75 0e                	jne    8019da <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019cc:	83 ef 04             	sub    $0x4,%edi
  8019cf:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019d2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019d5:	fd                   	std    
  8019d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019d8:	eb 07                	jmp    8019e1 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019da:	4f                   	dec    %edi
  8019db:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019de:	fd                   	std    
  8019df:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019e1:	fc                   	cld    
  8019e2:	eb 13                	jmp    8019f7 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019e4:	89 f2                	mov    %esi,%edx
  8019e6:	09 c2                	or     %eax,%edx
  8019e8:	f6 c2 03             	test   $0x3,%dl
  8019eb:	75 05                	jne    8019f2 <memmove+0x53>
  8019ed:	f6 c1 03             	test   $0x3,%cl
  8019f0:	74 09                	je     8019fb <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019f2:	89 c7                	mov    %eax,%edi
  8019f4:	fc                   	cld    
  8019f5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019f7:	5e                   	pop    %esi
  8019f8:	5f                   	pop    %edi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019fb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019fe:	89 c7                	mov    %eax,%edi
  801a00:	fc                   	cld    
  801a01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801a03:	eb f2                	jmp    8019f7 <memmove+0x58>

00801a05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801a08:	ff 75 10             	pushl  0x10(%ebp)
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	ff 75 08             	pushl  0x8(%ebp)
  801a11:	e8 89 ff ff ff       	call   80199f <memmove>
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	56                   	push   %esi
  801a1c:	53                   	push   %ebx
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	89 c6                	mov    %eax,%esi
  801a22:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a25:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a28:	39 f0                	cmp    %esi,%eax
  801a2a:	74 16                	je     801a42 <memcmp+0x2a>
		if (*s1 != *s2)
  801a2c:	8a 08                	mov    (%eax),%cl
  801a2e:	8a 1a                	mov    (%edx),%bl
  801a30:	38 d9                	cmp    %bl,%cl
  801a32:	75 04                	jne    801a38 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a34:	40                   	inc    %eax
  801a35:	42                   	inc    %edx
  801a36:	eb f0                	jmp    801a28 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a38:	0f b6 c1             	movzbl %cl,%eax
  801a3b:	0f b6 db             	movzbl %bl,%ebx
  801a3e:	29 d8                	sub    %ebx,%eax
  801a40:	eb 05                	jmp    801a47 <memcmp+0x2f>
	}

	return 0;
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    

00801a4b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a54:	89 c2                	mov    %eax,%edx
  801a56:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a59:	39 d0                	cmp    %edx,%eax
  801a5b:	73 07                	jae    801a64 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a5d:	38 08                	cmp    %cl,(%eax)
  801a5f:	74 03                	je     801a64 <memfind+0x19>
	for (; s < ends; s++)
  801a61:	40                   	inc    %eax
  801a62:	eb f5                	jmp    801a59 <memfind+0xe>
			break;
	return (void *) s;
}
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    

00801a66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a6f:	eb 01                	jmp    801a72 <strtol+0xc>
		s++;
  801a71:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a72:	8a 01                	mov    (%ecx),%al
  801a74:	3c 20                	cmp    $0x20,%al
  801a76:	74 f9                	je     801a71 <strtol+0xb>
  801a78:	3c 09                	cmp    $0x9,%al
  801a7a:	74 f5                	je     801a71 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801a7c:	3c 2b                	cmp    $0x2b,%al
  801a7e:	74 2b                	je     801aab <strtol+0x45>
		s++;
	else if (*s == '-')
  801a80:	3c 2d                	cmp    $0x2d,%al
  801a82:	74 2f                	je     801ab3 <strtol+0x4d>
	int neg = 0;
  801a84:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a89:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801a90:	75 12                	jne    801aa4 <strtol+0x3e>
  801a92:	80 39 30             	cmpb   $0x30,(%ecx)
  801a95:	74 24                	je     801abb <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801a97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a9b:	75 07                	jne    801aa4 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a9d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa9:	eb 4e                	jmp    801af9 <strtol+0x93>
		s++;
  801aab:	41                   	inc    %ecx
	int neg = 0;
  801aac:	bf 00 00 00 00       	mov    $0x0,%edi
  801ab1:	eb d6                	jmp    801a89 <strtol+0x23>
		s++, neg = 1;
  801ab3:	41                   	inc    %ecx
  801ab4:	bf 01 00 00 00       	mov    $0x1,%edi
  801ab9:	eb ce                	jmp    801a89 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801abb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801abf:	74 10                	je     801ad1 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801ac1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ac5:	75 dd                	jne    801aa4 <strtol+0x3e>
		s++, base = 8;
  801ac7:	41                   	inc    %ecx
  801ac8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801acf:	eb d3                	jmp    801aa4 <strtol+0x3e>
		s += 2, base = 16;
  801ad1:	83 c1 02             	add    $0x2,%ecx
  801ad4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801adb:	eb c7                	jmp    801aa4 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801add:	8d 72 9f             	lea    -0x61(%edx),%esi
  801ae0:	89 f3                	mov    %esi,%ebx
  801ae2:	80 fb 19             	cmp    $0x19,%bl
  801ae5:	77 24                	ja     801b0b <strtol+0xa5>
			dig = *s - 'a' + 10;
  801ae7:	0f be d2             	movsbl %dl,%edx
  801aea:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801aed:	3b 55 10             	cmp    0x10(%ebp),%edx
  801af0:	7d 2b                	jge    801b1d <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801af2:	41                   	inc    %ecx
  801af3:	0f af 45 10          	imul   0x10(%ebp),%eax
  801af7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801af9:	8a 11                	mov    (%ecx),%dl
  801afb:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801afe:	80 fb 09             	cmp    $0x9,%bl
  801b01:	77 da                	ja     801add <strtol+0x77>
			dig = *s - '0';
  801b03:	0f be d2             	movsbl %dl,%edx
  801b06:	83 ea 30             	sub    $0x30,%edx
  801b09:	eb e2                	jmp    801aed <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801b0b:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b0e:	89 f3                	mov    %esi,%ebx
  801b10:	80 fb 19             	cmp    $0x19,%bl
  801b13:	77 08                	ja     801b1d <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b15:	0f be d2             	movsbl %dl,%edx
  801b18:	83 ea 37             	sub    $0x37,%edx
  801b1b:	eb d0                	jmp    801aed <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b21:	74 05                	je     801b28 <strtol+0xc2>
		*endptr = (char *) s;
  801b23:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b26:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b28:	85 ff                	test   %edi,%edi
  801b2a:	74 02                	je     801b2e <strtol+0xc8>
  801b2c:	f7 d8                	neg    %eax
}
  801b2e:	5b                   	pop    %ebx
  801b2f:	5e                   	pop    %esi
  801b30:	5f                   	pop    %edi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    

00801b33 <atoi>:

int
atoi(const char *s)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b36:	6a 0a                	push   $0xa
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 08             	pushl  0x8(%ebp)
  801b3d:	e8 24 ff ff ff       	call   801a66 <strtol>
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	57                   	push   %edi
  801b48:	56                   	push   %esi
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b50:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b53:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b56:	85 ff                	test   %edi,%edi
  801b58:	74 53                	je     801bad <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	57                   	push   %edi
  801b5e:	e8 fe e7 ff ff       	call   800361 <sys_ipc_recv>
  801b63:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b66:	85 db                	test   %ebx,%ebx
  801b68:	74 0b                	je     801b75 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b6a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b70:	8b 52 74             	mov    0x74(%edx),%edx
  801b73:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b75:	85 f6                	test   %esi,%esi
  801b77:	74 0f                	je     801b88 <ipc_recv+0x44>
  801b79:	85 ff                	test   %edi,%edi
  801b7b:	74 0b                	je     801b88 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b7d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b83:	8b 52 78             	mov    0x78(%edx),%edx
  801b86:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	74 30                	je     801bbc <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b8c:	85 db                	test   %ebx,%ebx
  801b8e:	74 06                	je     801b96 <ipc_recv+0x52>
      		*from_env_store = 0;
  801b90:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801b96:	85 f6                	test   %esi,%esi
  801b98:	74 2c                	je     801bc6 <ipc_recv+0x82>
      		*perm_store = 0;
  801b9a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba8:	5b                   	pop    %ebx
  801ba9:	5e                   	pop    %esi
  801baa:	5f                   	pop    %edi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	6a ff                	push   $0xffffffff
  801bb2:	e8 aa e7 ff ff       	call   800361 <sys_ipc_recv>
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	eb aa                	jmp    801b66 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bbc:	a1 04 40 80 00       	mov    0x804004,%eax
  801bc1:	8b 40 70             	mov    0x70(%eax),%eax
  801bc4:	eb df                	jmp    801ba5 <ipc_recv+0x61>
		return -1;
  801bc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bcb:	eb d8                	jmp    801ba5 <ipc_recv+0x61>

00801bcd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	57                   	push   %edi
  801bd1:	56                   	push   %esi
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 0c             	sub    $0xc,%esp
  801bd6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bdc:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bdf:	85 db                	test   %ebx,%ebx
  801be1:	75 22                	jne    801c05 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801be3:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801be8:	eb 1b                	jmp    801c05 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bea:	68 60 23 80 00       	push   $0x802360
  801bef:	68 d7 1f 80 00       	push   $0x801fd7
  801bf4:	6a 48                	push   $0x48
  801bf6:	68 84 23 80 00       	push   $0x802384
  801bfb:	e8 11 f5 ff ff       	call   801111 <_panic>
		sys_yield();
  801c00:	e8 13 e6 ff ff       	call   800218 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c05:	57                   	push   %edi
  801c06:	53                   	push   %ebx
  801c07:	56                   	push   %esi
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	e8 2e e7 ff ff       	call   80033e <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c10:	83 c4 10             	add    $0x10,%esp
  801c13:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c16:	74 e8                	je     801c00 <ipc_send+0x33>
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	75 ce                	jne    801bea <ipc_send+0x1d>
		sys_yield();
  801c1c:	e8 f7 e5 ff ff       	call   800218 <sys_yield>
		
	}
	
}
  801c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c24:	5b                   	pop    %ebx
  801c25:	5e                   	pop    %esi
  801c26:	5f                   	pop    %edi
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    

00801c29 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c34:	89 c2                	mov    %eax,%edx
  801c36:	c1 e2 05             	shl    $0x5,%edx
  801c39:	29 c2                	sub    %eax,%edx
  801c3b:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c42:	8b 52 50             	mov    0x50(%edx),%edx
  801c45:	39 ca                	cmp    %ecx,%edx
  801c47:	74 0f                	je     801c58 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c49:	40                   	inc    %eax
  801c4a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c4f:	75 e3                	jne    801c34 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c51:	b8 00 00 00 00       	mov    $0x0,%eax
  801c56:	eb 11                	jmp    801c69 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c58:	89 c2                	mov    %eax,%edx
  801c5a:	c1 e2 05             	shl    $0x5,%edx
  801c5d:	29 c2                	sub    %eax,%edx
  801c5f:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c66:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c69:	5d                   	pop    %ebp
  801c6a:	c3                   	ret    

00801c6b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	c1 e8 16             	shr    $0x16,%eax
  801c74:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c7b:	a8 01                	test   $0x1,%al
  801c7d:	74 21                	je     801ca0 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	c1 e8 0c             	shr    $0xc,%eax
  801c85:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c8c:	a8 01                	test   $0x1,%al
  801c8e:	74 17                	je     801ca7 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c90:	c1 e8 0c             	shr    $0xc,%eax
  801c93:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c9a:	ef 
  801c9b:	0f b7 c0             	movzwl %ax,%eax
  801c9e:	eb 05                	jmp    801ca5 <pageref+0x3a>
		return 0;
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca5:	5d                   	pop    %ebp
  801ca6:	c3                   	ret    
		return 0;
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cac:	eb f7                	jmp    801ca5 <pageref+0x3a>
  801cae:	66 90                	xchg   %ax,%ax

00801cb0 <__udivdi3>:
  801cb0:	55                   	push   %ebp
  801cb1:	57                   	push   %edi
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 1c             	sub    $0x1c,%esp
  801cb7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cbb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cc3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cc7:	89 ca                	mov    %ecx,%edx
  801cc9:	89 f8                	mov    %edi,%eax
  801ccb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ccf:	85 f6                	test   %esi,%esi
  801cd1:	75 2d                	jne    801d00 <__udivdi3+0x50>
  801cd3:	39 cf                	cmp    %ecx,%edi
  801cd5:	77 65                	ja     801d3c <__udivdi3+0x8c>
  801cd7:	89 fd                	mov    %edi,%ebp
  801cd9:	85 ff                	test   %edi,%edi
  801cdb:	75 0b                	jne    801ce8 <__udivdi3+0x38>
  801cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce2:	31 d2                	xor    %edx,%edx
  801ce4:	f7 f7                	div    %edi
  801ce6:	89 c5                	mov    %eax,%ebp
  801ce8:	31 d2                	xor    %edx,%edx
  801cea:	89 c8                	mov    %ecx,%eax
  801cec:	f7 f5                	div    %ebp
  801cee:	89 c1                	mov    %eax,%ecx
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	f7 f5                	div    %ebp
  801cf4:	89 cf                	mov    %ecx,%edi
  801cf6:	89 fa                	mov    %edi,%edx
  801cf8:	83 c4 1c             	add    $0x1c,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    
  801d00:	39 ce                	cmp    %ecx,%esi
  801d02:	77 28                	ja     801d2c <__udivdi3+0x7c>
  801d04:	0f bd fe             	bsr    %esi,%edi
  801d07:	83 f7 1f             	xor    $0x1f,%edi
  801d0a:	75 40                	jne    801d4c <__udivdi3+0x9c>
  801d0c:	39 ce                	cmp    %ecx,%esi
  801d0e:	72 0a                	jb     801d1a <__udivdi3+0x6a>
  801d10:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d14:	0f 87 9e 00 00 00    	ja     801db8 <__udivdi3+0x108>
  801d1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1f:	89 fa                	mov    %edi,%edx
  801d21:	83 c4 1c             	add    $0x1c,%esp
  801d24:	5b                   	pop    %ebx
  801d25:	5e                   	pop    %esi
  801d26:	5f                   	pop    %edi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    
  801d29:	8d 76 00             	lea    0x0(%esi),%esi
  801d2c:	31 ff                	xor    %edi,%edi
  801d2e:	31 c0                	xor    %eax,%eax
  801d30:	89 fa                	mov    %edi,%edx
  801d32:	83 c4 1c             	add    $0x1c,%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5f                   	pop    %edi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    
  801d3a:	66 90                	xchg   %ax,%ax
  801d3c:	89 d8                	mov    %ebx,%eax
  801d3e:	f7 f7                	div    %edi
  801d40:	31 ff                	xor    %edi,%edi
  801d42:	89 fa                	mov    %edi,%edx
  801d44:	83 c4 1c             	add    $0x1c,%esp
  801d47:	5b                   	pop    %ebx
  801d48:	5e                   	pop    %esi
  801d49:	5f                   	pop    %edi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    
  801d4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d51:	29 fd                	sub    %edi,%ebp
  801d53:	89 f9                	mov    %edi,%ecx
  801d55:	d3 e6                	shl    %cl,%esi
  801d57:	89 c3                	mov    %eax,%ebx
  801d59:	89 e9                	mov    %ebp,%ecx
  801d5b:	d3 eb                	shr    %cl,%ebx
  801d5d:	89 d9                	mov    %ebx,%ecx
  801d5f:	09 f1                	or     %esi,%ecx
  801d61:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d65:	89 f9                	mov    %edi,%ecx
  801d67:	d3 e0                	shl    %cl,%eax
  801d69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d6d:	89 d6                	mov    %edx,%esi
  801d6f:	89 e9                	mov    %ebp,%ecx
  801d71:	d3 ee                	shr    %cl,%esi
  801d73:	89 f9                	mov    %edi,%ecx
  801d75:	d3 e2                	shl    %cl,%edx
  801d77:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d7b:	89 e9                	mov    %ebp,%ecx
  801d7d:	d3 eb                	shr    %cl,%ebx
  801d7f:	09 da                	or     %ebx,%edx
  801d81:	89 d0                	mov    %edx,%eax
  801d83:	89 f2                	mov    %esi,%edx
  801d85:	f7 74 24 08          	divl   0x8(%esp)
  801d89:	89 d6                	mov    %edx,%esi
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	f7 64 24 0c          	mull   0xc(%esp)
  801d91:	39 d6                	cmp    %edx,%esi
  801d93:	72 17                	jb     801dac <__udivdi3+0xfc>
  801d95:	74 09                	je     801da0 <__udivdi3+0xf0>
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	31 ff                	xor    %edi,%edi
  801d9b:	e9 56 ff ff ff       	jmp    801cf6 <__udivdi3+0x46>
  801da0:	8b 54 24 04          	mov    0x4(%esp),%edx
  801da4:	89 f9                	mov    %edi,%ecx
  801da6:	d3 e2                	shl    %cl,%edx
  801da8:	39 c2                	cmp    %eax,%edx
  801daa:	73 eb                	jae    801d97 <__udivdi3+0xe7>
  801dac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801daf:	31 ff                	xor    %edi,%edi
  801db1:	e9 40 ff ff ff       	jmp    801cf6 <__udivdi3+0x46>
  801db6:	66 90                	xchg   %ax,%ax
  801db8:	31 c0                	xor    %eax,%eax
  801dba:	e9 37 ff ff ff       	jmp    801cf6 <__udivdi3+0x46>
  801dbf:	90                   	nop

00801dc0 <__umoddi3>:
  801dc0:	55                   	push   %ebp
  801dc1:	57                   	push   %edi
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	83 ec 1c             	sub    $0x1c,%esp
  801dc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dcb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dcf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dd3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ddb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ddf:	89 3c 24             	mov    %edi,(%esp)
  801de2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801de6:	89 f2                	mov    %esi,%edx
  801de8:	85 c0                	test   %eax,%eax
  801dea:	75 18                	jne    801e04 <__umoddi3+0x44>
  801dec:	39 f7                	cmp    %esi,%edi
  801dee:	0f 86 a0 00 00 00    	jbe    801e94 <__umoddi3+0xd4>
  801df4:	89 c8                	mov    %ecx,%eax
  801df6:	f7 f7                	div    %edi
  801df8:	89 d0                	mov    %edx,%eax
  801dfa:	31 d2                	xor    %edx,%edx
  801dfc:	83 c4 1c             	add    $0x1c,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	5f                   	pop    %edi
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    
  801e04:	89 f3                	mov    %esi,%ebx
  801e06:	39 f0                	cmp    %esi,%eax
  801e08:	0f 87 a6 00 00 00    	ja     801eb4 <__umoddi3+0xf4>
  801e0e:	0f bd e8             	bsr    %eax,%ebp
  801e11:	83 f5 1f             	xor    $0x1f,%ebp
  801e14:	0f 84 a6 00 00 00    	je     801ec0 <__umoddi3+0x100>
  801e1a:	bf 20 00 00 00       	mov    $0x20,%edi
  801e1f:	29 ef                	sub    %ebp,%edi
  801e21:	89 e9                	mov    %ebp,%ecx
  801e23:	d3 e0                	shl    %cl,%eax
  801e25:	8b 34 24             	mov    (%esp),%esi
  801e28:	89 f2                	mov    %esi,%edx
  801e2a:	89 f9                	mov    %edi,%ecx
  801e2c:	d3 ea                	shr    %cl,%edx
  801e2e:	09 c2                	or     %eax,%edx
  801e30:	89 14 24             	mov    %edx,(%esp)
  801e33:	89 f2                	mov    %esi,%edx
  801e35:	89 e9                	mov    %ebp,%ecx
  801e37:	d3 e2                	shl    %cl,%edx
  801e39:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e3d:	89 de                	mov    %ebx,%esi
  801e3f:	89 f9                	mov    %edi,%ecx
  801e41:	d3 ee                	shr    %cl,%esi
  801e43:	89 e9                	mov    %ebp,%ecx
  801e45:	d3 e3                	shl    %cl,%ebx
  801e47:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	89 f9                	mov    %edi,%ecx
  801e4f:	d3 e8                	shr    %cl,%eax
  801e51:	09 d8                	or     %ebx,%eax
  801e53:	89 d3                	mov    %edx,%ebx
  801e55:	89 e9                	mov    %ebp,%ecx
  801e57:	d3 e3                	shl    %cl,%ebx
  801e59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e5d:	89 f2                	mov    %esi,%edx
  801e5f:	f7 34 24             	divl   (%esp)
  801e62:	89 d6                	mov    %edx,%esi
  801e64:	f7 64 24 04          	mull   0x4(%esp)
  801e68:	89 c3                	mov    %eax,%ebx
  801e6a:	89 d1                	mov    %edx,%ecx
  801e6c:	39 d6                	cmp    %edx,%esi
  801e6e:	72 7c                	jb     801eec <__umoddi3+0x12c>
  801e70:	74 72                	je     801ee4 <__umoddi3+0x124>
  801e72:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e76:	29 da                	sub    %ebx,%edx
  801e78:	19 ce                	sbb    %ecx,%esi
  801e7a:	89 f0                	mov    %esi,%eax
  801e7c:	89 f9                	mov    %edi,%ecx
  801e7e:	d3 e0                	shl    %cl,%eax
  801e80:	89 e9                	mov    %ebp,%ecx
  801e82:	d3 ea                	shr    %cl,%edx
  801e84:	09 d0                	or     %edx,%eax
  801e86:	89 e9                	mov    %ebp,%ecx
  801e88:	d3 ee                	shr    %cl,%esi
  801e8a:	89 f2                	mov    %esi,%edx
  801e8c:	83 c4 1c             	add    $0x1c,%esp
  801e8f:	5b                   	pop    %ebx
  801e90:	5e                   	pop    %esi
  801e91:	5f                   	pop    %edi
  801e92:	5d                   	pop    %ebp
  801e93:	c3                   	ret    
  801e94:	89 fd                	mov    %edi,%ebp
  801e96:	85 ff                	test   %edi,%edi
  801e98:	75 0b                	jne    801ea5 <__umoddi3+0xe5>
  801e9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9f:	31 d2                	xor    %edx,%edx
  801ea1:	f7 f7                	div    %edi
  801ea3:	89 c5                	mov    %eax,%ebp
  801ea5:	89 f0                	mov    %esi,%eax
  801ea7:	31 d2                	xor    %edx,%edx
  801ea9:	f7 f5                	div    %ebp
  801eab:	89 c8                	mov    %ecx,%eax
  801ead:	f7 f5                	div    %ebp
  801eaf:	e9 44 ff ff ff       	jmp    801df8 <__umoddi3+0x38>
  801eb4:	89 c8                	mov    %ecx,%eax
  801eb6:	89 f2                	mov    %esi,%edx
  801eb8:	83 c4 1c             	add    $0x1c,%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5e                   	pop    %esi
  801ebd:	5f                   	pop    %edi
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    
  801ec0:	39 f0                	cmp    %esi,%eax
  801ec2:	72 05                	jb     801ec9 <__umoddi3+0x109>
  801ec4:	39 0c 24             	cmp    %ecx,(%esp)
  801ec7:	77 0c                	ja     801ed5 <__umoddi3+0x115>
  801ec9:	89 f2                	mov    %esi,%edx
  801ecb:	29 f9                	sub    %edi,%ecx
  801ecd:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ed1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed5:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ed9:	83 c4 1c             	add    $0x1c,%esp
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5f                   	pop    %edi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    
  801ee1:	8d 76 00             	lea    0x0(%esi),%esi
  801ee4:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ee8:	73 88                	jae    801e72 <__umoddi3+0xb2>
  801eea:	66 90                	xchg   %ax,%ax
  801eec:	2b 44 24 04          	sub    0x4(%esp),%eax
  801ef0:	1b 14 24             	sbb    (%esp),%edx
  801ef3:	89 d1                	mov    %edx,%ecx
  801ef5:	89 c3                	mov    %eax,%ebx
  801ef7:	e9 76 ff ff ff       	jmp    801e72 <__umoddi3+0xb2>
