
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 d4 00 00 00       	call   800122 <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	89 c2                	mov    %eax,%edx
  800055:	c1 e2 05             	shl    $0x5,%edx
  800058:	29 c2                	sub    %eax,%edx
  80005a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800061:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800066:	85 db                	test   %ebx,%ebx
  800068:	7e 07                	jle    800071 <libmain+0x33>
		binaryname = argv[0];
  80006a:	8b 06                	mov    (%esi),%eax
  80006c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800071:	83 ec 08             	sub    $0x8,%esp
  800074:	56                   	push   %esi
  800075:	53                   	push   %ebx
  800076:	e8 b8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007b:	e8 0a 00 00 00       	call   80008a <exit>
}
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800086:	5b                   	pop    %ebx
  800087:	5e                   	pop    %esi
  800088:	5d                   	pop    %ebp
  800089:	c3                   	ret    

0080008a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008a:	55                   	push   %ebp
  80008b:	89 e5                	mov    %esp,%ebp
  80008d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800090:	e8 35 05 00 00       	call   8005ca <close_all>
	sys_env_destroy(0);
  800095:	83 ec 0c             	sub    $0xc,%esp
  800098:	6a 00                	push   $0x0
  80009a:	e8 42 00 00 00       	call   8000e1 <sys_env_destroy>
}
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	c9                   	leave  
  8000a3:	c3                   	ret    

008000a4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	57                   	push   %edi
  8000a8:	56                   	push   %esi
  8000a9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b5:	89 c3                	mov    %eax,%ebx
  8000b7:	89 c7                	mov    %eax,%edi
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5f                   	pop    %edi
  8000c0:	5d                   	pop    %ebp
  8000c1:	c3                   	ret    

008000c2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c2:	55                   	push   %ebp
  8000c3:	89 e5                	mov    %esp,%ebp
  8000c5:	57                   	push   %edi
  8000c6:	56                   	push   %esi
  8000c7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	89 d3                	mov    %edx,%ebx
  8000d6:	89 d7                	mov    %edx,%edi
  8000d8:	89 d6                	mov    %edx,%esi
  8000da:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5f                   	pop    %edi
  8000df:	5d                   	pop    %ebp
  8000e0:	c3                   	ret    

008000e1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	57                   	push   %edi
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f7:	89 cb                	mov    %ecx,%ebx
  8000f9:	89 cf                	mov    %ecx,%edi
  8000fb:	89 ce                	mov    %ecx,%esi
  8000fd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000ff:	85 c0                	test   %eax,%eax
  800101:	7f 08                	jg     80010b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800103:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800106:	5b                   	pop    %ebx
  800107:	5e                   	pop    %esi
  800108:	5f                   	pop    %edi
  800109:	5d                   	pop    %ebp
  80010a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	6a 03                	push   $0x3
  800111:	68 0a 1f 80 00       	push   $0x801f0a
  800116:	6a 23                	push   $0x23
  800118:	68 27 1f 80 00       	push   $0x801f27
  80011d:	e8 df 0f 00 00       	call   801101 <_panic>

00800122 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	57                   	push   %edi
  800126:	56                   	push   %esi
  800127:	53                   	push   %ebx
	asm volatile("int %1\n"
  800128:	ba 00 00 00 00       	mov    $0x0,%edx
  80012d:	b8 02 00 00 00       	mov    $0x2,%eax
  800132:	89 d1                	mov    %edx,%ecx
  800134:	89 d3                	mov    %edx,%ebx
  800136:	89 d7                	mov    %edx,%edi
  800138:	89 d6                	mov    %edx,%esi
  80013a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013c:	5b                   	pop    %ebx
  80013d:	5e                   	pop    %esi
  80013e:	5f                   	pop    %edi
  80013f:	5d                   	pop    %ebp
  800140:	c3                   	ret    

00800141 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	57                   	push   %edi
  800145:	56                   	push   %esi
  800146:	53                   	push   %ebx
  800147:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80014a:	be 00 00 00 00       	mov    $0x0,%esi
  80014f:	b8 04 00 00 00       	mov    $0x4,%eax
  800154:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800157:	8b 55 08             	mov    0x8(%ebp),%edx
  80015a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80015d:	89 f7                	mov    %esi,%edi
  80015f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800161:	85 c0                	test   %eax,%eax
  800163:	7f 08                	jg     80016d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800165:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5f                   	pop    %edi
  80016b:	5d                   	pop    %ebp
  80016c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	50                   	push   %eax
  800171:	6a 04                	push   $0x4
  800173:	68 0a 1f 80 00       	push   $0x801f0a
  800178:	6a 23                	push   $0x23
  80017a:	68 27 1f 80 00       	push   $0x801f27
  80017f:	e8 7d 0f 00 00       	call   801101 <_panic>

00800184 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	57                   	push   %edi
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
  80018a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80018d:	b8 05 00 00 00       	mov    $0x5,%eax
  800192:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800195:	8b 55 08             	mov    0x8(%ebp),%edx
  800198:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80019e:	8b 75 18             	mov    0x18(%ebp),%esi
  8001a1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a3:	85 c0                	test   %eax,%eax
  8001a5:	7f 08                	jg     8001af <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001aa:	5b                   	pop    %ebx
  8001ab:	5e                   	pop    %esi
  8001ac:	5f                   	pop    %edi
  8001ad:	5d                   	pop    %ebp
  8001ae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	50                   	push   %eax
  8001b3:	6a 05                	push   $0x5
  8001b5:	68 0a 1f 80 00       	push   $0x801f0a
  8001ba:	6a 23                	push   $0x23
  8001bc:	68 27 1f 80 00       	push   $0x801f27
  8001c1:	e8 3b 0f 00 00       	call   801101 <_panic>

008001c6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	57                   	push   %edi
  8001ca:	56                   	push   %esi
  8001cb:	53                   	push   %ebx
  8001cc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d4:	b8 06 00 00 00       	mov    $0x6,%eax
  8001d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001df:	89 df                	mov    %ebx,%edi
  8001e1:	89 de                	mov    %ebx,%esi
  8001e3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e5:	85 c0                	test   %eax,%eax
  8001e7:	7f 08                	jg     8001f1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ec:	5b                   	pop    %ebx
  8001ed:	5e                   	pop    %esi
  8001ee:	5f                   	pop    %edi
  8001ef:	5d                   	pop    %ebp
  8001f0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	50                   	push   %eax
  8001f5:	6a 06                	push   $0x6
  8001f7:	68 0a 1f 80 00       	push   $0x801f0a
  8001fc:	6a 23                	push   $0x23
  8001fe:	68 27 1f 80 00       	push   $0x801f27
  800203:	e8 f9 0e 00 00       	call   801101 <_panic>

00800208 <sys_yield>:

void
sys_yield(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	57                   	push   %edi
  80020c:	56                   	push   %esi
  80020d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80020e:	ba 00 00 00 00       	mov    $0x0,%edx
  800213:	b8 0b 00 00 00       	mov    $0xb,%eax
  800218:	89 d1                	mov    %edx,%ecx
  80021a:	89 d3                	mov    %edx,%ebx
  80021c:	89 d7                	mov    %edx,%edi
  80021e:	89 d6                	mov    %edx,%esi
  800220:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800222:	5b                   	pop    %ebx
  800223:	5e                   	pop    %esi
  800224:	5f                   	pop    %edi
  800225:	5d                   	pop    %ebp
  800226:	c3                   	ret    

00800227 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	57                   	push   %edi
  80022b:	56                   	push   %esi
  80022c:	53                   	push   %ebx
  80022d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800230:	bb 00 00 00 00       	mov    $0x0,%ebx
  800235:	b8 08 00 00 00       	mov    $0x8,%eax
  80023a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023d:	8b 55 08             	mov    0x8(%ebp),%edx
  800240:	89 df                	mov    %ebx,%edi
  800242:	89 de                	mov    %ebx,%esi
  800244:	cd 30                	int    $0x30
	if(check && ret > 0)
  800246:	85 c0                	test   %eax,%eax
  800248:	7f 08                	jg     800252 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024d:	5b                   	pop    %ebx
  80024e:	5e                   	pop    %esi
  80024f:	5f                   	pop    %edi
  800250:	5d                   	pop    %ebp
  800251:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	50                   	push   %eax
  800256:	6a 08                	push   $0x8
  800258:	68 0a 1f 80 00       	push   $0x801f0a
  80025d:	6a 23                	push   $0x23
  80025f:	68 27 1f 80 00       	push   $0x801f27
  800264:	e8 98 0e 00 00       	call   801101 <_panic>

00800269 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	57                   	push   %edi
  80026d:	56                   	push   %esi
  80026e:	53                   	push   %ebx
  80026f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800272:	b9 00 00 00 00       	mov    $0x0,%ecx
  800277:	b8 0c 00 00 00       	mov    $0xc,%eax
  80027c:	8b 55 08             	mov    0x8(%ebp),%edx
  80027f:	89 cb                	mov    %ecx,%ebx
  800281:	89 cf                	mov    %ecx,%edi
  800283:	89 ce                	mov    %ecx,%esi
  800285:	cd 30                	int    $0x30
	if(check && ret > 0)
  800287:	85 c0                	test   %eax,%eax
  800289:	7f 08                	jg     800293 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  80028b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028e:	5b                   	pop    %ebx
  80028f:	5e                   	pop    %esi
  800290:	5f                   	pop    %edi
  800291:	5d                   	pop    %ebp
  800292:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	50                   	push   %eax
  800297:	6a 0c                	push   $0xc
  800299:	68 0a 1f 80 00       	push   $0x801f0a
  80029e:	6a 23                	push   $0x23
  8002a0:	68 27 1f 80 00       	push   $0x801f27
  8002a5:	e8 57 0e 00 00       	call   801101 <_panic>

008002aa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	57                   	push   %edi
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b8:	b8 09 00 00 00       	mov    $0x9,%eax
  8002bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c3:	89 df                	mov    %ebx,%edi
  8002c5:	89 de                	mov    %ebx,%esi
  8002c7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c9:	85 c0                	test   %eax,%eax
  8002cb:	7f 08                	jg     8002d5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d0:	5b                   	pop    %ebx
  8002d1:	5e                   	pop    %esi
  8002d2:	5f                   	pop    %edi
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d5:	83 ec 0c             	sub    $0xc,%esp
  8002d8:	50                   	push   %eax
  8002d9:	6a 09                	push   $0x9
  8002db:	68 0a 1f 80 00       	push   $0x801f0a
  8002e0:	6a 23                	push   $0x23
  8002e2:	68 27 1f 80 00       	push   $0x801f27
  8002e7:	e8 15 0e 00 00       	call   801101 <_panic>

008002ec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	57                   	push   %edi
  8002f0:	56                   	push   %esi
  8002f1:	53                   	push   %ebx
  8002f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800302:	8b 55 08             	mov    0x8(%ebp),%edx
  800305:	89 df                	mov    %ebx,%edi
  800307:	89 de                	mov    %ebx,%esi
  800309:	cd 30                	int    $0x30
	if(check && ret > 0)
  80030b:	85 c0                	test   %eax,%eax
  80030d:	7f 08                	jg     800317 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800312:	5b                   	pop    %ebx
  800313:	5e                   	pop    %esi
  800314:	5f                   	pop    %edi
  800315:	5d                   	pop    %ebp
  800316:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	50                   	push   %eax
  80031b:	6a 0a                	push   $0xa
  80031d:	68 0a 1f 80 00       	push   $0x801f0a
  800322:	6a 23                	push   $0x23
  800324:	68 27 1f 80 00       	push   $0x801f27
  800329:	e8 d3 0d 00 00       	call   801101 <_panic>

0080032e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	57                   	push   %edi
  800332:	56                   	push   %esi
  800333:	53                   	push   %ebx
	asm volatile("int %1\n"
  800334:	be 00 00 00 00       	mov    $0x0,%esi
  800339:	b8 0d 00 00 00       	mov    $0xd,%eax
  80033e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800341:	8b 55 08             	mov    0x8(%ebp),%edx
  800344:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800347:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80034c:	5b                   	pop    %ebx
  80034d:	5e                   	pop    %esi
  80034e:	5f                   	pop    %edi
  80034f:	5d                   	pop    %ebp
  800350:	c3                   	ret    

00800351 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	57                   	push   %edi
  800355:	56                   	push   %esi
  800356:	53                   	push   %ebx
  800357:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80035f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800364:	8b 55 08             	mov    0x8(%ebp),%edx
  800367:	89 cb                	mov    %ecx,%ebx
  800369:	89 cf                	mov    %ecx,%edi
  80036b:	89 ce                	mov    %ecx,%esi
  80036d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80036f:	85 c0                	test   %eax,%eax
  800371:	7f 08                	jg     80037b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800373:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800376:	5b                   	pop    %ebx
  800377:	5e                   	pop    %esi
  800378:	5f                   	pop    %edi
  800379:	5d                   	pop    %ebp
  80037a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	50                   	push   %eax
  80037f:	6a 0e                	push   $0xe
  800381:	68 0a 1f 80 00       	push   $0x801f0a
  800386:	6a 23                	push   $0x23
  800388:	68 27 1f 80 00       	push   $0x801f27
  80038d:	e8 6f 0d 00 00       	call   801101 <_panic>

00800392 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	57                   	push   %edi
  800396:	56                   	push   %esi
  800397:	53                   	push   %ebx
	asm volatile("int %1\n"
  800398:	be 00 00 00 00       	mov    $0x0,%esi
  80039d:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003ab:	89 f7                	mov    %esi,%edi
  8003ad:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003af:	5b                   	pop    %ebx
  8003b0:	5e                   	pop    %esi
  8003b1:	5f                   	pop    %edi
  8003b2:	5d                   	pop    %ebp
  8003b3:	c3                   	ret    

008003b4 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	57                   	push   %edi
  8003b8:	56                   	push   %esi
  8003b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ba:	be 00 00 00 00       	mov    $0x0,%esi
  8003bf:	b8 10 00 00 00       	mov    $0x10,%eax
  8003c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003cd:	89 f7                	mov    %esi,%edi
  8003cf:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003d1:	5b                   	pop    %ebx
  8003d2:	5e                   	pop    %esi
  8003d3:	5f                   	pop    %edi
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	57                   	push   %edi
  8003da:	56                   	push   %esi
  8003db:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003e1:	b8 11 00 00 00       	mov    $0x11,%eax
  8003e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e9:	89 cb                	mov    %ecx,%ebx
  8003eb:	89 cf                	mov    %ecx,%edi
  8003ed:	89 ce                	mov    %ecx,%esi
  8003ef:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8003f1:	5b                   	pop    %ebx
  8003f2:	5e                   	pop    %esi
  8003f3:	5f                   	pop    %edi
  8003f4:	5d                   	pop    %ebp
  8003f5:	c3                   	ret    

008003f6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	05 00 00 00 30       	add    $0x30000000,%eax
  800401:	c1 e8 0c             	shr    $0xc,%eax
}
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800411:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800416:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80041b:	5d                   	pop    %ebp
  80041c:	c3                   	ret    

0080041d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800423:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800428:	89 c2                	mov    %eax,%edx
  80042a:	c1 ea 16             	shr    $0x16,%edx
  80042d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800434:	f6 c2 01             	test   $0x1,%dl
  800437:	74 2a                	je     800463 <fd_alloc+0x46>
  800439:	89 c2                	mov    %eax,%edx
  80043b:	c1 ea 0c             	shr    $0xc,%edx
  80043e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800445:	f6 c2 01             	test   $0x1,%dl
  800448:	74 19                	je     800463 <fd_alloc+0x46>
  80044a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80044f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800454:	75 d2                	jne    800428 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800456:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80045c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800461:	eb 07                	jmp    80046a <fd_alloc+0x4d>
			*fd_store = fd;
  800463:	89 01                	mov    %eax,(%ecx)
			return 0;
  800465:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80046f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800473:	77 39                	ja     8004ae <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	c1 e0 0c             	shl    $0xc,%eax
  80047b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800480:	89 c2                	mov    %eax,%edx
  800482:	c1 ea 16             	shr    $0x16,%edx
  800485:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80048c:	f6 c2 01             	test   $0x1,%dl
  80048f:	74 24                	je     8004b5 <fd_lookup+0x49>
  800491:	89 c2                	mov    %eax,%edx
  800493:	c1 ea 0c             	shr    $0xc,%edx
  800496:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80049d:	f6 c2 01             	test   $0x1,%dl
  8004a0:	74 1a                	je     8004bc <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a5:	89 02                	mov    %eax,(%edx)
	return 0;
  8004a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004ac:	5d                   	pop    %ebp
  8004ad:	c3                   	ret    
		return -E_INVAL;
  8004ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004b3:	eb f7                	jmp    8004ac <fd_lookup+0x40>
		return -E_INVAL;
  8004b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004ba:	eb f0                	jmp    8004ac <fd_lookup+0x40>
  8004bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004c1:	eb e9                	jmp    8004ac <fd_lookup+0x40>

008004c3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004cc:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004d1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004d6:	39 08                	cmp    %ecx,(%eax)
  8004d8:	74 33                	je     80050d <dev_lookup+0x4a>
  8004da:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004dd:	8b 02                	mov    (%edx),%eax
  8004df:	85 c0                	test   %eax,%eax
  8004e1:	75 f3                	jne    8004d6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8004e8:	8b 40 48             	mov    0x48(%eax),%eax
  8004eb:	83 ec 04             	sub    $0x4,%esp
  8004ee:	51                   	push   %ecx
  8004ef:	50                   	push   %eax
  8004f0:	68 38 1f 80 00       	push   $0x801f38
  8004f5:	e8 1a 0d 00 00       	call   801214 <cprintf>
	*dev = 0;
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    
			*dev = devtab[i];
  80050d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800510:	89 01                	mov    %eax,(%ecx)
			return 0;
  800512:	b8 00 00 00 00       	mov    $0x0,%eax
  800517:	eb f2                	jmp    80050b <dev_lookup+0x48>

00800519 <fd_close>:
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	57                   	push   %edi
  80051d:	56                   	push   %esi
  80051e:	53                   	push   %ebx
  80051f:	83 ec 1c             	sub    $0x1c,%esp
  800522:	8b 75 08             	mov    0x8(%ebp),%esi
  800525:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800528:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80052b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80052c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800532:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800535:	50                   	push   %eax
  800536:	e8 31 ff ff ff       	call   80046c <fd_lookup>
  80053b:	89 c7                	mov    %eax,%edi
  80053d:	83 c4 08             	add    $0x8,%esp
  800540:	85 c0                	test   %eax,%eax
  800542:	78 05                	js     800549 <fd_close+0x30>
	    || fd != fd2)
  800544:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800547:	74 13                	je     80055c <fd_close+0x43>
		return (must_exist ? r : 0);
  800549:	84 db                	test   %bl,%bl
  80054b:	75 05                	jne    800552 <fd_close+0x39>
  80054d:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800552:	89 f8                	mov    %edi,%eax
  800554:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800557:	5b                   	pop    %ebx
  800558:	5e                   	pop    %esi
  800559:	5f                   	pop    %edi
  80055a:	5d                   	pop    %ebp
  80055b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800562:	50                   	push   %eax
  800563:	ff 36                	pushl  (%esi)
  800565:	e8 59 ff ff ff       	call   8004c3 <dev_lookup>
  80056a:	89 c7                	mov    %eax,%edi
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	85 c0                	test   %eax,%eax
  800571:	78 15                	js     800588 <fd_close+0x6f>
		if (dev->dev_close)
  800573:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800576:	8b 40 10             	mov    0x10(%eax),%eax
  800579:	85 c0                	test   %eax,%eax
  80057b:	74 1b                	je     800598 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80057d:	83 ec 0c             	sub    $0xc,%esp
  800580:	56                   	push   %esi
  800581:	ff d0                	call   *%eax
  800583:	89 c7                	mov    %eax,%edi
  800585:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	56                   	push   %esi
  80058c:	6a 00                	push   $0x0
  80058e:	e8 33 fc ff ff       	call   8001c6 <sys_page_unmap>
	return r;
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	eb ba                	jmp    800552 <fd_close+0x39>
			r = 0;
  800598:	bf 00 00 00 00       	mov    $0x0,%edi
  80059d:	eb e9                	jmp    800588 <fd_close+0x6f>

0080059f <close>:

int
close(int fdnum)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005a8:	50                   	push   %eax
  8005a9:	ff 75 08             	pushl  0x8(%ebp)
  8005ac:	e8 bb fe ff ff       	call   80046c <fd_lookup>
  8005b1:	83 c4 08             	add    $0x8,%esp
  8005b4:	85 c0                	test   %eax,%eax
  8005b6:	78 10                	js     8005c8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	6a 01                	push   $0x1
  8005bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c0:	e8 54 ff ff ff       	call   800519 <fd_close>
  8005c5:	83 c4 10             	add    $0x10,%esp
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <close_all>:

void
close_all(void)
{
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	53                   	push   %ebx
  8005ce:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005d6:	83 ec 0c             	sub    $0xc,%esp
  8005d9:	53                   	push   %ebx
  8005da:	e8 c0 ff ff ff       	call   80059f <close>
	for (i = 0; i < MAXFD; i++)
  8005df:	43                   	inc    %ebx
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	83 fb 20             	cmp    $0x20,%ebx
  8005e6:	75 ee                	jne    8005d6 <close_all+0xc>
}
  8005e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005eb:	c9                   	leave  
  8005ec:	c3                   	ret    

008005ed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	57                   	push   %edi
  8005f1:	56                   	push   %esi
  8005f2:	53                   	push   %ebx
  8005f3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005f9:	50                   	push   %eax
  8005fa:	ff 75 08             	pushl  0x8(%ebp)
  8005fd:	e8 6a fe ff ff       	call   80046c <fd_lookup>
  800602:	89 c3                	mov    %eax,%ebx
  800604:	83 c4 08             	add    $0x8,%esp
  800607:	85 c0                	test   %eax,%eax
  800609:	0f 88 81 00 00 00    	js     800690 <dup+0xa3>
		return r;
	close(newfdnum);
  80060f:	83 ec 0c             	sub    $0xc,%esp
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	e8 85 ff ff ff       	call   80059f <close>

	newfd = INDEX2FD(newfdnum);
  80061a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80061d:	c1 e6 0c             	shl    $0xc,%esi
  800620:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800626:	83 c4 04             	add    $0x4,%esp
  800629:	ff 75 e4             	pushl  -0x1c(%ebp)
  80062c:	e8 d5 fd ff ff       	call   800406 <fd2data>
  800631:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800633:	89 34 24             	mov    %esi,(%esp)
  800636:	e8 cb fd ff ff       	call   800406 <fd2data>
  80063b:	83 c4 10             	add    $0x10,%esp
  80063e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800640:	89 d8                	mov    %ebx,%eax
  800642:	c1 e8 16             	shr    $0x16,%eax
  800645:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80064c:	a8 01                	test   $0x1,%al
  80064e:	74 11                	je     800661 <dup+0x74>
  800650:	89 d8                	mov    %ebx,%eax
  800652:	c1 e8 0c             	shr    $0xc,%eax
  800655:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80065c:	f6 c2 01             	test   $0x1,%dl
  80065f:	75 39                	jne    80069a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800661:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800664:	89 d0                	mov    %edx,%eax
  800666:	c1 e8 0c             	shr    $0xc,%eax
  800669:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800670:	83 ec 0c             	sub    $0xc,%esp
  800673:	25 07 0e 00 00       	and    $0xe07,%eax
  800678:	50                   	push   %eax
  800679:	56                   	push   %esi
  80067a:	6a 00                	push   $0x0
  80067c:	52                   	push   %edx
  80067d:	6a 00                	push   $0x0
  80067f:	e8 00 fb ff ff       	call   800184 <sys_page_map>
  800684:	89 c3                	mov    %eax,%ebx
  800686:	83 c4 20             	add    $0x20,%esp
  800689:	85 c0                	test   %eax,%eax
  80068b:	78 31                	js     8006be <dup+0xd1>
		goto err;

	return newfdnum;
  80068d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800690:	89 d8                	mov    %ebx,%eax
  800692:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800695:	5b                   	pop    %ebx
  800696:	5e                   	pop    %esi
  800697:	5f                   	pop    %edi
  800698:	5d                   	pop    %ebp
  800699:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80069a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006a1:	83 ec 0c             	sub    $0xc,%esp
  8006a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8006a9:	50                   	push   %eax
  8006aa:	57                   	push   %edi
  8006ab:	6a 00                	push   $0x0
  8006ad:	53                   	push   %ebx
  8006ae:	6a 00                	push   $0x0
  8006b0:	e8 cf fa ff ff       	call   800184 <sys_page_map>
  8006b5:	89 c3                	mov    %eax,%ebx
  8006b7:	83 c4 20             	add    $0x20,%esp
  8006ba:	85 c0                	test   %eax,%eax
  8006bc:	79 a3                	jns    800661 <dup+0x74>
	sys_page_unmap(0, newfd);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	56                   	push   %esi
  8006c2:	6a 00                	push   $0x0
  8006c4:	e8 fd fa ff ff       	call   8001c6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006c9:	83 c4 08             	add    $0x8,%esp
  8006cc:	57                   	push   %edi
  8006cd:	6a 00                	push   $0x0
  8006cf:	e8 f2 fa ff ff       	call   8001c6 <sys_page_unmap>
	return r;
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	eb b7                	jmp    800690 <dup+0xa3>

008006d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006d9:	55                   	push   %ebp
  8006da:	89 e5                	mov    %esp,%ebp
  8006dc:	53                   	push   %ebx
  8006dd:	83 ec 14             	sub    $0x14,%esp
  8006e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006e6:	50                   	push   %eax
  8006e7:	53                   	push   %ebx
  8006e8:	e8 7f fd ff ff       	call   80046c <fd_lookup>
  8006ed:	83 c4 08             	add    $0x8,%esp
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	78 3f                	js     800733 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006fa:	50                   	push   %eax
  8006fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fe:	ff 30                	pushl  (%eax)
  800700:	e8 be fd ff ff       	call   8004c3 <dev_lookup>
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	85 c0                	test   %eax,%eax
  80070a:	78 27                	js     800733 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80070c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80070f:	8b 42 08             	mov    0x8(%edx),%eax
  800712:	83 e0 03             	and    $0x3,%eax
  800715:	83 f8 01             	cmp    $0x1,%eax
  800718:	74 1e                	je     800738 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80071d:	8b 40 08             	mov    0x8(%eax),%eax
  800720:	85 c0                	test   %eax,%eax
  800722:	74 35                	je     800759 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800724:	83 ec 04             	sub    $0x4,%esp
  800727:	ff 75 10             	pushl  0x10(%ebp)
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	52                   	push   %edx
  80072e:	ff d0                	call   *%eax
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800736:	c9                   	leave  
  800737:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800738:	a1 04 40 80 00       	mov    0x804004,%eax
  80073d:	8b 40 48             	mov    0x48(%eax),%eax
  800740:	83 ec 04             	sub    $0x4,%esp
  800743:	53                   	push   %ebx
  800744:	50                   	push   %eax
  800745:	68 79 1f 80 00       	push   $0x801f79
  80074a:	e8 c5 0a 00 00       	call   801214 <cprintf>
		return -E_INVAL;
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800757:	eb da                	jmp    800733 <read+0x5a>
		return -E_NOT_SUPP;
  800759:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80075e:	eb d3                	jmp    800733 <read+0x5a>

00800760 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	57                   	push   %edi
  800764:	56                   	push   %esi
  800765:	53                   	push   %ebx
  800766:	83 ec 0c             	sub    $0xc,%esp
  800769:	8b 7d 08             	mov    0x8(%ebp),%edi
  80076c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80076f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800774:	39 f3                	cmp    %esi,%ebx
  800776:	73 25                	jae    80079d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	89 f0                	mov    %esi,%eax
  80077d:	29 d8                	sub    %ebx,%eax
  80077f:	50                   	push   %eax
  800780:	89 d8                	mov    %ebx,%eax
  800782:	03 45 0c             	add    0xc(%ebp),%eax
  800785:	50                   	push   %eax
  800786:	57                   	push   %edi
  800787:	e8 4d ff ff ff       	call   8006d9 <read>
		if (m < 0)
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	85 c0                	test   %eax,%eax
  800791:	78 08                	js     80079b <readn+0x3b>
			return m;
		if (m == 0)
  800793:	85 c0                	test   %eax,%eax
  800795:	74 06                	je     80079d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800797:	01 c3                	add    %eax,%ebx
  800799:	eb d9                	jmp    800774 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80079b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80079d:	89 d8                	mov    %ebx,%eax
  80079f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a2:	5b                   	pop    %ebx
  8007a3:	5e                   	pop    %esi
  8007a4:	5f                   	pop    %edi
  8007a5:	5d                   	pop    %ebp
  8007a6:	c3                   	ret    

008007a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	53                   	push   %ebx
  8007ab:	83 ec 14             	sub    $0x14,%esp
  8007ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	53                   	push   %ebx
  8007b6:	e8 b1 fc ff ff       	call   80046c <fd_lookup>
  8007bb:	83 c4 08             	add    $0x8,%esp
  8007be:	85 c0                	test   %eax,%eax
  8007c0:	78 3a                	js     8007fc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c8:	50                   	push   %eax
  8007c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cc:	ff 30                	pushl  (%eax)
  8007ce:	e8 f0 fc ff ff       	call   8004c3 <dev_lookup>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	85 c0                	test   %eax,%eax
  8007d8:	78 22                	js     8007fc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007e1:	74 1e                	je     800801 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8007e9:	85 d2                	test   %edx,%edx
  8007eb:	74 35                	je     800822 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007ed:	83 ec 04             	sub    $0x4,%esp
  8007f0:	ff 75 10             	pushl  0x10(%ebp)
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	50                   	push   %eax
  8007f7:	ff d2                	call   *%edx
  8007f9:	83 c4 10             	add    $0x10,%esp
}
  8007fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800801:	a1 04 40 80 00       	mov    0x804004,%eax
  800806:	8b 40 48             	mov    0x48(%eax),%eax
  800809:	83 ec 04             	sub    $0x4,%esp
  80080c:	53                   	push   %ebx
  80080d:	50                   	push   %eax
  80080e:	68 95 1f 80 00       	push   $0x801f95
  800813:	e8 fc 09 00 00       	call   801214 <cprintf>
		return -E_INVAL;
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800820:	eb da                	jmp    8007fc <write+0x55>
		return -E_NOT_SUPP;
  800822:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800827:	eb d3                	jmp    8007fc <write+0x55>

00800829 <seek>:

int
seek(int fdnum, off_t offset)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80082f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800832:	50                   	push   %eax
  800833:	ff 75 08             	pushl  0x8(%ebp)
  800836:	e8 31 fc ff ff       	call   80046c <fd_lookup>
  80083b:	83 c4 08             	add    $0x8,%esp
  80083e:	85 c0                	test   %eax,%eax
  800840:	78 0e                	js     800850 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800845:	8b 55 0c             	mov    0xc(%ebp),%edx
  800848:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    

00800852 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	83 ec 14             	sub    $0x14,%esp
  800859:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085f:	50                   	push   %eax
  800860:	53                   	push   %ebx
  800861:	e8 06 fc ff ff       	call   80046c <fd_lookup>
  800866:	83 c4 08             	add    $0x8,%esp
  800869:	85 c0                	test   %eax,%eax
  80086b:	78 37                	js     8008a4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800877:	ff 30                	pushl  (%eax)
  800879:	e8 45 fc ff ff       	call   8004c3 <dev_lookup>
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	85 c0                	test   %eax,%eax
  800883:	78 1f                	js     8008a4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800888:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80088c:	74 1b                	je     8008a9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80088e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800891:	8b 52 18             	mov    0x18(%edx),%edx
  800894:	85 d2                	test   %edx,%edx
  800896:	74 32                	je     8008ca <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	50                   	push   %eax
  80089f:	ff d2                	call   *%edx
  8008a1:	83 c4 10             	add    $0x10,%esp
}
  8008a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008a9:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008ae:	8b 40 48             	mov    0x48(%eax),%eax
  8008b1:	83 ec 04             	sub    $0x4,%esp
  8008b4:	53                   	push   %ebx
  8008b5:	50                   	push   %eax
  8008b6:	68 58 1f 80 00       	push   $0x801f58
  8008bb:	e8 54 09 00 00       	call   801214 <cprintf>
		return -E_INVAL;
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c8:	eb da                	jmp    8008a4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8008ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008cf:	eb d3                	jmp    8008a4 <ftruncate+0x52>

008008d1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	53                   	push   %ebx
  8008d5:	83 ec 14             	sub    $0x14,%esp
  8008d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008de:	50                   	push   %eax
  8008df:	ff 75 08             	pushl  0x8(%ebp)
  8008e2:	e8 85 fb ff ff       	call   80046c <fd_lookup>
  8008e7:	83 c4 08             	add    $0x8,%esp
  8008ea:	85 c0                	test   %eax,%eax
  8008ec:	78 4b                	js     800939 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008f4:	50                   	push   %eax
  8008f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f8:	ff 30                	pushl  (%eax)
  8008fa:	e8 c4 fb ff ff       	call   8004c3 <dev_lookup>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	85 c0                	test   %eax,%eax
  800904:	78 33                	js     800939 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800909:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80090d:	74 2f                	je     80093e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80090f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800912:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800919:	00 00 00 
	stat->st_type = 0;
  80091c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800923:	00 00 00 
	stat->st_dev = dev;
  800926:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	53                   	push   %ebx
  800930:	ff 75 f0             	pushl  -0x10(%ebp)
  800933:	ff 50 14             	call   *0x14(%eax)
  800936:	83 c4 10             	add    $0x10,%esp
}
  800939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    
		return -E_NOT_SUPP;
  80093e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800943:	eb f4                	jmp    800939 <fstat+0x68>

00800945 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	56                   	push   %esi
  800949:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	6a 00                	push   $0x0
  80094f:	ff 75 08             	pushl  0x8(%ebp)
  800952:	e8 34 02 00 00       	call   800b8b <open>
  800957:	89 c3                	mov    %eax,%ebx
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	85 c0                	test   %eax,%eax
  80095e:	78 1b                	js     80097b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	50                   	push   %eax
  800967:	e8 65 ff ff ff       	call   8008d1 <fstat>
  80096c:	89 c6                	mov    %eax,%esi
	close(fd);
  80096e:	89 1c 24             	mov    %ebx,(%esp)
  800971:	e8 29 fc ff ff       	call   80059f <close>
	return r;
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 f3                	mov    %esi,%ebx
}
  80097b:	89 d8                	mov    %ebx,%eax
  80097d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800980:	5b                   	pop    %ebx
  800981:	5e                   	pop    %esi
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	89 c6                	mov    %eax,%esi
  80098b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80098d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800994:	74 27                	je     8009bd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800996:	6a 07                	push   $0x7
  800998:	68 00 50 80 00       	push   $0x805000
  80099d:	56                   	push   %esi
  80099e:	ff 35 00 40 80 00    	pushl  0x804000
  8009a4:	e8 14 12 00 00       	call   801bbd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009a9:	83 c4 0c             	add    $0xc,%esp
  8009ac:	6a 00                	push   $0x0
  8009ae:	53                   	push   %ebx
  8009af:	6a 00                	push   $0x0
  8009b1:	e8 7e 11 00 00       	call   801b34 <ipc_recv>
}
  8009b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009b9:	5b                   	pop    %ebx
  8009ba:	5e                   	pop    %esi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009bd:	83 ec 0c             	sub    $0xc,%esp
  8009c0:	6a 01                	push   $0x1
  8009c2:	e8 52 12 00 00       	call   801c19 <ipc_find_env>
  8009c7:	a3 00 40 80 00       	mov    %eax,0x804000
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	eb c5                	jmp    800996 <fsipc+0x12>

008009d1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 40 0c             	mov    0xc(%eax),%eax
  8009dd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8009f4:	e8 8b ff ff ff       	call   800984 <fsipc>
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <devfile_flush>:
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8b 40 0c             	mov    0xc(%eax),%eax
  800a07:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a11:	b8 06 00 00 00       	mov    $0x6,%eax
  800a16:	e8 69 ff ff ff       	call   800984 <fsipc>
}
  800a1b:	c9                   	leave  
  800a1c:	c3                   	ret    

00800a1d <devfile_stat>:
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	53                   	push   %ebx
  800a21:	83 ec 04             	sub    $0x4,%esp
  800a24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  800a2d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a32:	ba 00 00 00 00       	mov    $0x0,%edx
  800a37:	b8 05 00 00 00       	mov    $0x5,%eax
  800a3c:	e8 43 ff ff ff       	call   800984 <fsipc>
  800a41:	85 c0                	test   %eax,%eax
  800a43:	78 2c                	js     800a71 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	68 00 50 80 00       	push   $0x805000
  800a4d:	53                   	push   %ebx
  800a4e:	e8 c9 0d 00 00       	call   80181c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a53:	a1 80 50 80 00       	mov    0x805080,%eax
  800a58:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a5e:	a1 84 50 80 00       	mov    0x805084,%eax
  800a63:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a69:	83 c4 10             	add    $0x10,%esp
  800a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a74:	c9                   	leave  
  800a75:	c3                   	ret    

00800a76 <devfile_write>:
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	53                   	push   %ebx
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800a80:	89 d8                	mov    %ebx,%eax
  800a82:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800a88:	76 05                	jbe    800a8f <devfile_write+0x19>
  800a8a:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800a92:	8b 52 0c             	mov    0xc(%edx),%edx
  800a95:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800a9b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	68 08 50 80 00       	push   $0x805008
  800aac:	e8 de 0e 00 00       	call   80198f <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab6:	b8 04 00 00 00       	mov    $0x4,%eax
  800abb:	e8 c4 fe ff ff       	call   800984 <fsipc>
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	85 c0                	test   %eax,%eax
  800ac5:	78 0b                	js     800ad2 <devfile_write+0x5c>
	assert(r <= n);
  800ac7:	39 c3                	cmp    %eax,%ebx
  800ac9:	72 0c                	jb     800ad7 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800acb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad0:	7f 1e                	jg     800af0 <devfile_write+0x7a>
}
  800ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    
	assert(r <= n);
  800ad7:	68 c4 1f 80 00       	push   $0x801fc4
  800adc:	68 cb 1f 80 00       	push   $0x801fcb
  800ae1:	68 98 00 00 00       	push   $0x98
  800ae6:	68 e0 1f 80 00       	push   $0x801fe0
  800aeb:	e8 11 06 00 00       	call   801101 <_panic>
	assert(r <= PGSIZE);
  800af0:	68 eb 1f 80 00       	push   $0x801feb
  800af5:	68 cb 1f 80 00       	push   $0x801fcb
  800afa:	68 99 00 00 00       	push   $0x99
  800aff:	68 e0 1f 80 00       	push   $0x801fe0
  800b04:	e8 f8 05 00 00       	call   801101 <_panic>

00800b09 <devfile_read>:
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	56                   	push   %esi
  800b0d:	53                   	push   %ebx
  800b0e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 40 0c             	mov    0xc(%eax),%eax
  800b17:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b1c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b22:	ba 00 00 00 00       	mov    $0x0,%edx
  800b27:	b8 03 00 00 00       	mov    $0x3,%eax
  800b2c:	e8 53 fe ff ff       	call   800984 <fsipc>
  800b31:	89 c3                	mov    %eax,%ebx
  800b33:	85 c0                	test   %eax,%eax
  800b35:	78 1f                	js     800b56 <devfile_read+0x4d>
	assert(r <= n);
  800b37:	39 c6                	cmp    %eax,%esi
  800b39:	72 24                	jb     800b5f <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b3b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b40:	7f 33                	jg     800b75 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b42:	83 ec 04             	sub    $0x4,%esp
  800b45:	50                   	push   %eax
  800b46:	68 00 50 80 00       	push   $0x805000
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	e8 3c 0e 00 00       	call   80198f <memmove>
	return r;
  800b53:	83 c4 10             	add    $0x10,%esp
}
  800b56:	89 d8                	mov    %ebx,%eax
  800b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    
	assert(r <= n);
  800b5f:	68 c4 1f 80 00       	push   $0x801fc4
  800b64:	68 cb 1f 80 00       	push   $0x801fcb
  800b69:	6a 7c                	push   $0x7c
  800b6b:	68 e0 1f 80 00       	push   $0x801fe0
  800b70:	e8 8c 05 00 00       	call   801101 <_panic>
	assert(r <= PGSIZE);
  800b75:	68 eb 1f 80 00       	push   $0x801feb
  800b7a:	68 cb 1f 80 00       	push   $0x801fcb
  800b7f:	6a 7d                	push   $0x7d
  800b81:	68 e0 1f 80 00       	push   $0x801fe0
  800b86:	e8 76 05 00 00       	call   801101 <_panic>

00800b8b <open>:
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	56                   	push   %esi
  800b8f:	53                   	push   %ebx
  800b90:	83 ec 1c             	sub    $0x1c,%esp
  800b93:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b96:	56                   	push   %esi
  800b97:	e8 4d 0c 00 00       	call   8017e9 <strlen>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ba4:	7f 6c                	jg     800c12 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bac:	50                   	push   %eax
  800bad:	e8 6b f8 ff ff       	call   80041d <fd_alloc>
  800bb2:	89 c3                	mov    %eax,%ebx
  800bb4:	83 c4 10             	add    $0x10,%esp
  800bb7:	85 c0                	test   %eax,%eax
  800bb9:	78 3c                	js     800bf7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	56                   	push   %esi
  800bbf:	68 00 50 80 00       	push   $0x805000
  800bc4:	e8 53 0c 00 00       	call   80181c <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd4:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd9:	e8 a6 fd ff ff       	call   800984 <fsipc>
  800bde:	89 c3                	mov    %eax,%ebx
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	85 c0                	test   %eax,%eax
  800be5:	78 19                	js     800c00 <open+0x75>
	return fd2num(fd);
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	e8 04 f8 ff ff       	call   8003f6 <fd2num>
  800bf2:	89 c3                	mov    %eax,%ebx
  800bf4:	83 c4 10             	add    $0x10,%esp
}
  800bf7:	89 d8                	mov    %ebx,%eax
  800bf9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bfc:	5b                   	pop    %ebx
  800bfd:	5e                   	pop    %esi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    
		fd_close(fd, 0);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	6a 00                	push   $0x0
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	e8 0c f9 ff ff       	call   800519 <fd_close>
		return r;
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	eb e5                	jmp    800bf7 <open+0x6c>
		return -E_BAD_PATH;
  800c12:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c17:	eb de                	jmp    800bf7 <open+0x6c>

00800c19 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c24:	b8 08 00 00 00       	mov    $0x8,%eax
  800c29:	e8 56 fd ff ff       	call   800984 <fsipc>
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c38:	83 ec 0c             	sub    $0xc,%esp
  800c3b:	ff 75 08             	pushl  0x8(%ebp)
  800c3e:	e8 c3 f7 ff ff       	call   800406 <fd2data>
  800c43:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c45:	83 c4 08             	add    $0x8,%esp
  800c48:	68 f7 1f 80 00       	push   $0x801ff7
  800c4d:	53                   	push   %ebx
  800c4e:	e8 c9 0b 00 00       	call   80181c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c53:	8b 46 04             	mov    0x4(%esi),%eax
  800c56:	2b 06                	sub    (%esi),%eax
  800c58:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c5e:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800c65:	10 00 00 
	stat->st_dev = &devpipe;
  800c68:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c6f:	30 80 00 
	return 0;
}
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
  800c77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	53                   	push   %ebx
  800c82:	83 ec 0c             	sub    $0xc,%esp
  800c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c88:	53                   	push   %ebx
  800c89:	6a 00                	push   $0x0
  800c8b:	e8 36 f5 ff ff       	call   8001c6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c90:	89 1c 24             	mov    %ebx,(%esp)
  800c93:	e8 6e f7 ff ff       	call   800406 <fd2data>
  800c98:	83 c4 08             	add    $0x8,%esp
  800c9b:	50                   	push   %eax
  800c9c:	6a 00                	push   $0x0
  800c9e:	e8 23 f5 ff ff       	call   8001c6 <sys_page_unmap>
}
  800ca3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca6:	c9                   	leave  
  800ca7:	c3                   	ret    

00800ca8 <_pipeisclosed>:
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	57                   	push   %edi
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	83 ec 1c             	sub    $0x1c,%esp
  800cb1:	89 c7                	mov    %eax,%edi
  800cb3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cb5:	a1 04 40 80 00       	mov    0x804004,%eax
  800cba:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800cbd:	83 ec 0c             	sub    $0xc,%esp
  800cc0:	57                   	push   %edi
  800cc1:	e8 95 0f 00 00       	call   801c5b <pageref>
  800cc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cc9:	89 34 24             	mov    %esi,(%esp)
  800ccc:	e8 8a 0f 00 00       	call   801c5b <pageref>
		nn = thisenv->env_runs;
  800cd1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cd7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800cda:	83 c4 10             	add    $0x10,%esp
  800cdd:	39 cb                	cmp    %ecx,%ebx
  800cdf:	74 1b                	je     800cfc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800ce1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ce4:	75 cf                	jne    800cb5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800ce6:	8b 42 58             	mov    0x58(%edx),%eax
  800ce9:	6a 01                	push   $0x1
  800ceb:	50                   	push   %eax
  800cec:	53                   	push   %ebx
  800ced:	68 fe 1f 80 00       	push   $0x801ffe
  800cf2:	e8 1d 05 00 00       	call   801214 <cprintf>
  800cf7:	83 c4 10             	add    $0x10,%esp
  800cfa:	eb b9                	jmp    800cb5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800cfc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cff:	0f 94 c0             	sete   %al
  800d02:	0f b6 c0             	movzbl %al,%eax
}
  800d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <devpipe_write>:
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 18             	sub    $0x18,%esp
  800d16:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d19:	56                   	push   %esi
  800d1a:	e8 e7 f6 ff ff       	call   800406 <fd2data>
  800d1f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d21:	83 c4 10             	add    $0x10,%esp
  800d24:	bf 00 00 00 00       	mov    $0x0,%edi
  800d29:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d2c:	74 41                	je     800d6f <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d2e:	8b 53 04             	mov    0x4(%ebx),%edx
  800d31:	8b 03                	mov    (%ebx),%eax
  800d33:	83 c0 20             	add    $0x20,%eax
  800d36:	39 c2                	cmp    %eax,%edx
  800d38:	72 14                	jb     800d4e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d3a:	89 da                	mov    %ebx,%edx
  800d3c:	89 f0                	mov    %esi,%eax
  800d3e:	e8 65 ff ff ff       	call   800ca8 <_pipeisclosed>
  800d43:	85 c0                	test   %eax,%eax
  800d45:	75 2c                	jne    800d73 <devpipe_write+0x66>
			sys_yield();
  800d47:	e8 bc f4 ff ff       	call   800208 <sys_yield>
  800d4c:	eb e0                	jmp    800d2e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d54:	89 d0                	mov    %edx,%eax
  800d56:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d5b:	78 0b                	js     800d68 <devpipe_write+0x5b>
  800d5d:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d61:	42                   	inc    %edx
  800d62:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d65:	47                   	inc    %edi
  800d66:	eb c1                	jmp    800d29 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d68:	48                   	dec    %eax
  800d69:	83 c8 e0             	or     $0xffffffe0,%eax
  800d6c:	40                   	inc    %eax
  800d6d:	eb ee                	jmp    800d5d <devpipe_write+0x50>
	return i;
  800d6f:	89 f8                	mov    %edi,%eax
  800d71:	eb 05                	jmp    800d78 <devpipe_write+0x6b>
				return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <devpipe_read>:
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 18             	sub    $0x18,%esp
  800d89:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d8c:	57                   	push   %edi
  800d8d:	e8 74 f6 ff ff       	call   800406 <fd2data>
  800d92:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800d94:	83 c4 10             	add    $0x10,%esp
  800d97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9c:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800d9f:	74 46                	je     800de7 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800da1:	8b 06                	mov    (%esi),%eax
  800da3:	3b 46 04             	cmp    0x4(%esi),%eax
  800da6:	75 22                	jne    800dca <devpipe_read+0x4a>
			if (i > 0)
  800da8:	85 db                	test   %ebx,%ebx
  800daa:	74 0a                	je     800db6 <devpipe_read+0x36>
				return i;
  800dac:	89 d8                	mov    %ebx,%eax
}
  800dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800db6:	89 f2                	mov    %esi,%edx
  800db8:	89 f8                	mov    %edi,%eax
  800dba:	e8 e9 fe ff ff       	call   800ca8 <_pipeisclosed>
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	75 28                	jne    800deb <devpipe_read+0x6b>
			sys_yield();
  800dc3:	e8 40 f4 ff ff       	call   800208 <sys_yield>
  800dc8:	eb d7                	jmp    800da1 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dca:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800dcf:	78 0f                	js     800de0 <devpipe_read+0x60>
  800dd1:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800ddb:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800ddd:	43                   	inc    %ebx
  800dde:	eb bc                	jmp    800d9c <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800de0:	48                   	dec    %eax
  800de1:	83 c8 e0             	or     $0xffffffe0,%eax
  800de4:	40                   	inc    %eax
  800de5:	eb ea                	jmp    800dd1 <devpipe_read+0x51>
	return i;
  800de7:	89 d8                	mov    %ebx,%eax
  800de9:	eb c3                	jmp    800dae <devpipe_read+0x2e>
				return 0;
  800deb:	b8 00 00 00 00       	mov    $0x0,%eax
  800df0:	eb bc                	jmp    800dae <devpipe_read+0x2e>

00800df2 <pipe>:
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dfd:	50                   	push   %eax
  800dfe:	e8 1a f6 ff ff       	call   80041d <fd_alloc>
  800e03:	89 c3                	mov    %eax,%ebx
  800e05:	83 c4 10             	add    $0x10,%esp
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	0f 88 2a 01 00 00    	js     800f3a <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	68 07 04 00 00       	push   $0x407
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	6a 00                	push   $0x0
  800e1d:	e8 1f f3 ff ff       	call   800141 <sys_page_alloc>
  800e22:	89 c3                	mov    %eax,%ebx
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	85 c0                	test   %eax,%eax
  800e29:	0f 88 0b 01 00 00    	js     800f3a <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e35:	50                   	push   %eax
  800e36:	e8 e2 f5 ff ff       	call   80041d <fd_alloc>
  800e3b:	89 c3                	mov    %eax,%ebx
  800e3d:	83 c4 10             	add    $0x10,%esp
  800e40:	85 c0                	test   %eax,%eax
  800e42:	0f 88 e2 00 00 00    	js     800f2a <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e48:	83 ec 04             	sub    $0x4,%esp
  800e4b:	68 07 04 00 00       	push   $0x407
  800e50:	ff 75 f0             	pushl  -0x10(%ebp)
  800e53:	6a 00                	push   $0x0
  800e55:	e8 e7 f2 ff ff       	call   800141 <sys_page_alloc>
  800e5a:	89 c3                	mov    %eax,%ebx
  800e5c:	83 c4 10             	add    $0x10,%esp
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	0f 88 c3 00 00 00    	js     800f2a <pipe+0x138>
	va = fd2data(fd0);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6d:	e8 94 f5 ff ff       	call   800406 <fd2data>
  800e72:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e74:	83 c4 0c             	add    $0xc,%esp
  800e77:	68 07 04 00 00       	push   $0x407
  800e7c:	50                   	push   %eax
  800e7d:	6a 00                	push   $0x0
  800e7f:	e8 bd f2 ff ff       	call   800141 <sys_page_alloc>
  800e84:	89 c3                	mov    %eax,%ebx
  800e86:	83 c4 10             	add    $0x10,%esp
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	0f 88 89 00 00 00    	js     800f1a <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e91:	83 ec 0c             	sub    $0xc,%esp
  800e94:	ff 75 f0             	pushl  -0x10(%ebp)
  800e97:	e8 6a f5 ff ff       	call   800406 <fd2data>
  800e9c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800ea3:	50                   	push   %eax
  800ea4:	6a 00                	push   $0x0
  800ea6:	56                   	push   %esi
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 d6 f2 ff ff       	call   800184 <sys_page_map>
  800eae:	89 c3                	mov    %eax,%ebx
  800eb0:	83 c4 20             	add    $0x20,%esp
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	78 55                	js     800f0c <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800eb7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800ecc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eda:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800ee1:	83 ec 0c             	sub    $0xc,%esp
  800ee4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee7:	e8 0a f5 ff ff       	call   8003f6 <fd2num>
  800eec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eef:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ef1:	83 c4 04             	add    $0x4,%esp
  800ef4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef7:	e8 fa f4 ff ff       	call   8003f6 <fd2num>
  800efc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eff:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f02:	83 c4 10             	add    $0x10,%esp
  800f05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0a:	eb 2e                	jmp    800f3a <pipe+0x148>
	sys_page_unmap(0, va);
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	56                   	push   %esi
  800f10:	6a 00                	push   $0x0
  800f12:	e8 af f2 ff ff       	call   8001c6 <sys_page_unmap>
  800f17:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800f20:	6a 00                	push   $0x0
  800f22:	e8 9f f2 ff ff       	call   8001c6 <sys_page_unmap>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f30:	6a 00                	push   $0x0
  800f32:	e8 8f f2 ff ff       	call   8001c6 <sys_page_unmap>
  800f37:	83 c4 10             	add    $0x10,%esp
}
  800f3a:	89 d8                	mov    %ebx,%eax
  800f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f3f:	5b                   	pop    %ebx
  800f40:	5e                   	pop    %esi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <pipeisclosed>:
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f4c:	50                   	push   %eax
  800f4d:	ff 75 08             	pushl  0x8(%ebp)
  800f50:	e8 17 f5 ff ff       	call   80046c <fd_lookup>
  800f55:	83 c4 10             	add    $0x10,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	78 18                	js     800f74 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f62:	e8 9f f4 ff ff       	call   800406 <fd2data>
	return _pipeisclosed(fd, p);
  800f67:	89 c2                	mov    %eax,%edx
  800f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6c:	e8 37 fd ff ff       	call   800ca8 <_pipeisclosed>
  800f71:	83 c4 10             	add    $0x10,%esp
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800f79:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	53                   	push   %ebx
  800f84:	83 ec 0c             	sub    $0xc,%esp
  800f87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800f8a:	68 16 20 80 00       	push   $0x802016
  800f8f:	53                   	push   %ebx
  800f90:	e8 87 08 00 00       	call   80181c <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800f95:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800f9c:	20 00 00 
	return 0;
}
  800f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <devcons_write>:
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fb5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fba:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fc0:	eb 1d                	jmp    800fdf <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800fc2:	83 ec 04             	sub    $0x4,%esp
  800fc5:	53                   	push   %ebx
  800fc6:	03 45 0c             	add    0xc(%ebp),%eax
  800fc9:	50                   	push   %eax
  800fca:	57                   	push   %edi
  800fcb:	e8 bf 09 00 00       	call   80198f <memmove>
		sys_cputs(buf, m);
  800fd0:	83 c4 08             	add    $0x8,%esp
  800fd3:	53                   	push   %ebx
  800fd4:	57                   	push   %edi
  800fd5:	e8 ca f0 ff ff       	call   8000a4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fda:	01 de                	add    %ebx,%esi
  800fdc:	83 c4 10             	add    $0x10,%esp
  800fdf:	89 f0                	mov    %esi,%eax
  800fe1:	3b 75 10             	cmp    0x10(%ebp),%esi
  800fe4:	73 11                	jae    800ff7 <devcons_write+0x4e>
		m = n - tot;
  800fe6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe9:	29 f3                	sub    %esi,%ebx
  800feb:	83 fb 7f             	cmp    $0x7f,%ebx
  800fee:	76 d2                	jbe    800fc2 <devcons_write+0x19>
  800ff0:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800ff5:	eb cb                	jmp    800fc2 <devcons_write+0x19>
}
  800ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <devcons_read>:
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801005:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801009:	75 0c                	jne    801017 <devcons_read+0x18>
		return 0;
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
  801010:	eb 21                	jmp    801033 <devcons_read+0x34>
		sys_yield();
  801012:	e8 f1 f1 ff ff       	call   800208 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801017:	e8 a6 f0 ff ff       	call   8000c2 <sys_cgetc>
  80101c:	85 c0                	test   %eax,%eax
  80101e:	74 f2                	je     801012 <devcons_read+0x13>
	if (c < 0)
  801020:	85 c0                	test   %eax,%eax
  801022:	78 0f                	js     801033 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801024:	83 f8 04             	cmp    $0x4,%eax
  801027:	74 0c                	je     801035 <devcons_read+0x36>
	*(char*)vbuf = c;
  801029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102c:	88 02                	mov    %al,(%edx)
	return 1;
  80102e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    
		return 0;
  801035:	b8 00 00 00 00       	mov    $0x0,%eax
  80103a:	eb f7                	jmp    801033 <devcons_read+0x34>

0080103c <cputchar>:
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801048:	6a 01                	push   $0x1
  80104a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80104d:	50                   	push   %eax
  80104e:	e8 51 f0 ff ff       	call   8000a4 <sys_cputs>
}
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <getchar>:
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80105e:	6a 01                	push   $0x1
  801060:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801063:	50                   	push   %eax
  801064:	6a 00                	push   $0x0
  801066:	e8 6e f6 ff ff       	call   8006d9 <read>
	if (r < 0)
  80106b:	83 c4 10             	add    $0x10,%esp
  80106e:	85 c0                	test   %eax,%eax
  801070:	78 08                	js     80107a <getchar+0x22>
	if (r < 1)
  801072:	85 c0                	test   %eax,%eax
  801074:	7e 06                	jle    80107c <getchar+0x24>
	return c;
  801076:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    
		return -E_EOF;
  80107c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801081:	eb f7                	jmp    80107a <getchar+0x22>

00801083 <iscons>:
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801089:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	ff 75 08             	pushl  0x8(%ebp)
  801090:	e8 d7 f3 ff ff       	call   80046c <fd_lookup>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	85 c0                	test   %eax,%eax
  80109a:	78 11                	js     8010ad <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80109c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010a5:	39 10                	cmp    %edx,(%eax)
  8010a7:	0f 94 c0             	sete   %al
  8010aa:	0f b6 c0             	movzbl %al,%eax
}
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <opencons>:
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010b8:	50                   	push   %eax
  8010b9:	e8 5f f3 ff ff       	call   80041d <fd_alloc>
  8010be:	83 c4 10             	add    $0x10,%esp
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	78 3a                	js     8010ff <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010c5:	83 ec 04             	sub    $0x4,%esp
  8010c8:	68 07 04 00 00       	push   $0x407
  8010cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d0:	6a 00                	push   $0x0
  8010d2:	e8 6a f0 ff ff       	call   800141 <sys_page_alloc>
  8010d7:	83 c4 10             	add    $0x10,%esp
  8010da:	85 c0                	test   %eax,%eax
  8010dc:	78 21                	js     8010ff <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8010de:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ec:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010f3:	83 ec 0c             	sub    $0xc,%esp
  8010f6:	50                   	push   %eax
  8010f7:	e8 fa f2 ff ff       	call   8003f6 <fd2num>
  8010fc:	83 c4 10             	add    $0x10,%esp
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	57                   	push   %edi
  801105:	56                   	push   %esi
  801106:	53                   	push   %ebx
  801107:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80110d:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801110:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801116:	e8 07 f0 ff ff       	call   800122 <sys_getenvid>
  80111b:	83 ec 04             	sub    $0x4,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	ff 75 08             	pushl  0x8(%ebp)
  801124:	53                   	push   %ebx
  801125:	50                   	push   %eax
  801126:	68 24 20 80 00       	push   $0x802024
  80112b:	68 00 01 00 00       	push   $0x100
  801130:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801136:	56                   	push   %esi
  801137:	e8 93 06 00 00       	call   8017cf <snprintf>
  80113c:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80113e:	83 c4 20             	add    $0x20,%esp
  801141:	57                   	push   %edi
  801142:	ff 75 10             	pushl  0x10(%ebp)
  801145:	bf 00 01 00 00       	mov    $0x100,%edi
  80114a:	89 f8                	mov    %edi,%eax
  80114c:	29 d8                	sub    %ebx,%eax
  80114e:	50                   	push   %eax
  80114f:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801152:	50                   	push   %eax
  801153:	e8 22 06 00 00       	call   80177a <vsnprintf>
  801158:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80115a:	83 c4 0c             	add    $0xc,%esp
  80115d:	68 0f 20 80 00       	push   $0x80200f
  801162:	29 df                	sub    %ebx,%edi
  801164:	57                   	push   %edi
  801165:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801168:	50                   	push   %eax
  801169:	e8 61 06 00 00       	call   8017cf <snprintf>
	sys_cputs(buf, r);
  80116e:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801171:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801173:	53                   	push   %ebx
  801174:	56                   	push   %esi
  801175:	e8 2a ef ff ff       	call   8000a4 <sys_cputs>
  80117a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80117d:	cc                   	int3   
  80117e:	eb fd                	jmp    80117d <_panic+0x7c>

00801180 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	53                   	push   %ebx
  801184:	83 ec 04             	sub    $0x4,%esp
  801187:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80118a:	8b 13                	mov    (%ebx),%edx
  80118c:	8d 42 01             	lea    0x1(%edx),%eax
  80118f:	89 03                	mov    %eax,(%ebx)
  801191:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801194:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801198:	3d ff 00 00 00       	cmp    $0xff,%eax
  80119d:	74 08                	je     8011a7 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80119f:	ff 43 04             	incl   0x4(%ebx)
}
  8011a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011a7:	83 ec 08             	sub    $0x8,%esp
  8011aa:	68 ff 00 00 00       	push   $0xff
  8011af:	8d 43 08             	lea    0x8(%ebx),%eax
  8011b2:	50                   	push   %eax
  8011b3:	e8 ec ee ff ff       	call   8000a4 <sys_cputs>
		b->idx = 0;
  8011b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	eb dc                	jmp    80119f <putch+0x1f>

008011c3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011d3:	00 00 00 
	b.cnt = 0;
  8011d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011dd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011e0:	ff 75 0c             	pushl  0xc(%ebp)
  8011e3:	ff 75 08             	pushl  0x8(%ebp)
  8011e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011ec:	50                   	push   %eax
  8011ed:	68 80 11 80 00       	push   $0x801180
  8011f2:	e8 17 01 00 00       	call   80130e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011f7:	83 c4 08             	add    $0x8,%esp
  8011fa:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801200:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801206:	50                   	push   %eax
  801207:	e8 98 ee ff ff       	call   8000a4 <sys_cputs>

	return b.cnt;
}
  80120c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80121a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80121d:	50                   	push   %eax
  80121e:	ff 75 08             	pushl  0x8(%ebp)
  801221:	e8 9d ff ff ff       	call   8011c3 <vcprintf>
	va_end(ap);

	return cnt;
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	57                   	push   %edi
  80122c:	56                   	push   %esi
  80122d:	53                   	push   %ebx
  80122e:	83 ec 1c             	sub    $0x1c,%esp
  801231:	89 c7                	mov    %eax,%edi
  801233:	89 d6                	mov    %edx,%esi
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80123e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801241:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801244:	bb 00 00 00 00       	mov    $0x0,%ebx
  801249:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80124c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80124f:	39 d3                	cmp    %edx,%ebx
  801251:	72 05                	jb     801258 <printnum+0x30>
  801253:	39 45 10             	cmp    %eax,0x10(%ebp)
  801256:	77 78                	ja     8012d0 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801258:	83 ec 0c             	sub    $0xc,%esp
  80125b:	ff 75 18             	pushl  0x18(%ebp)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801264:	53                   	push   %ebx
  801265:	ff 75 10             	pushl  0x10(%ebp)
  801268:	83 ec 08             	sub    $0x8,%esp
  80126b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80126e:	ff 75 e0             	pushl  -0x20(%ebp)
  801271:	ff 75 dc             	pushl  -0x24(%ebp)
  801274:	ff 75 d8             	pushl  -0x28(%ebp)
  801277:	e8 24 0a 00 00       	call   801ca0 <__udivdi3>
  80127c:	83 c4 18             	add    $0x18,%esp
  80127f:	52                   	push   %edx
  801280:	50                   	push   %eax
  801281:	89 f2                	mov    %esi,%edx
  801283:	89 f8                	mov    %edi,%eax
  801285:	e8 9e ff ff ff       	call   801228 <printnum>
  80128a:	83 c4 20             	add    $0x20,%esp
  80128d:	eb 11                	jmp    8012a0 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	56                   	push   %esi
  801293:	ff 75 18             	pushl  0x18(%ebp)
  801296:	ff d7                	call   *%edi
  801298:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80129b:	4b                   	dec    %ebx
  80129c:	85 db                	test   %ebx,%ebx
  80129e:	7f ef                	jg     80128f <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012a0:	83 ec 08             	sub    $0x8,%esp
  8012a3:	56                   	push   %esi
  8012a4:	83 ec 04             	sub    $0x4,%esp
  8012a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8012ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8012b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8012b3:	e8 f8 0a 00 00       	call   801db0 <__umoddi3>
  8012b8:	83 c4 14             	add    $0x14,%esp
  8012bb:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  8012c2:	50                   	push   %eax
  8012c3:	ff d7                	call   *%edi
}
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cb:	5b                   	pop    %ebx
  8012cc:	5e                   	pop    %esi
  8012cd:	5f                   	pop    %edi
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    
  8012d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d3:	eb c6                	jmp    80129b <printnum+0x73>

008012d5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012db:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8012de:	8b 10                	mov    (%eax),%edx
  8012e0:	3b 50 04             	cmp    0x4(%eax),%edx
  8012e3:	73 0a                	jae    8012ef <sprintputch+0x1a>
		*b->buf++ = ch;
  8012e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e8:	89 08                	mov    %ecx,(%eax)
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	88 02                	mov    %al,(%edx)
}
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <printfmt>:
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012f7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012fa:	50                   	push   %eax
  8012fb:	ff 75 10             	pushl  0x10(%ebp)
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	ff 75 08             	pushl  0x8(%ebp)
  801304:	e8 05 00 00 00       	call   80130e <vprintfmt>
}
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <vprintfmt>:
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	57                   	push   %edi
  801312:	56                   	push   %esi
  801313:	53                   	push   %ebx
  801314:	83 ec 2c             	sub    $0x2c,%esp
  801317:	8b 75 08             	mov    0x8(%ebp),%esi
  80131a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80131d:	8b 7d 10             	mov    0x10(%ebp),%edi
  801320:	e9 ae 03 00 00       	jmp    8016d3 <vprintfmt+0x3c5>
  801325:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801329:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801330:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801337:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80133e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801343:	8d 47 01             	lea    0x1(%edi),%eax
  801346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801349:	8a 17                	mov    (%edi),%dl
  80134b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80134e:	3c 55                	cmp    $0x55,%al
  801350:	0f 87 fe 03 00 00    	ja     801754 <vprintfmt+0x446>
  801356:	0f b6 c0             	movzbl %al,%eax
  801359:	ff 24 85 80 21 80 00 	jmp    *0x802180(,%eax,4)
  801360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801363:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801367:	eb da                	jmp    801343 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801369:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80136c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801370:	eb d1                	jmp    801343 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801372:	0f b6 d2             	movzbl %dl,%edx
  801375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801378:	b8 00 00 00 00       	mov    $0x0,%eax
  80137d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801380:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801383:	01 c0                	add    %eax,%eax
  801385:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  801389:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80138c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80138f:	83 f9 09             	cmp    $0x9,%ecx
  801392:	77 52                	ja     8013e6 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  801394:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  801395:	eb e9                	jmp    801380 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  801397:	8b 45 14             	mov    0x14(%ebp),%eax
  80139a:	8b 00                	mov    (%eax),%eax
  80139c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80139f:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a2:	8d 40 04             	lea    0x4(%eax),%eax
  8013a5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013af:	79 92                	jns    801343 <vprintfmt+0x35>
				width = precision, precision = -1;
  8013b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013b7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013be:	eb 83                	jmp    801343 <vprintfmt+0x35>
  8013c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013c4:	78 08                	js     8013ce <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8013c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013c9:	e9 75 ff ff ff       	jmp    801343 <vprintfmt+0x35>
  8013ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013d5:	eb ef                	jmp    8013c6 <vprintfmt+0xb8>
  8013d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013da:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8013e1:	e9 5d ff ff ff       	jmp    801343 <vprintfmt+0x35>
  8013e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013ec:	eb bd                	jmp    8013ab <vprintfmt+0x9d>
			lflag++;
  8013ee:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013f2:	e9 4c ff ff ff       	jmp    801343 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8013f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fa:	8d 78 04             	lea    0x4(%eax),%edi
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	53                   	push   %ebx
  801401:	ff 30                	pushl  (%eax)
  801403:	ff d6                	call   *%esi
			break;
  801405:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801408:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80140b:	e9 c0 02 00 00       	jmp    8016d0 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  801410:	8b 45 14             	mov    0x14(%ebp),%eax
  801413:	8d 78 04             	lea    0x4(%eax),%edi
  801416:	8b 00                	mov    (%eax),%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 2a                	js     801446 <vprintfmt+0x138>
  80141c:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80141e:	83 f8 0f             	cmp    $0xf,%eax
  801421:	7f 27                	jg     80144a <vprintfmt+0x13c>
  801423:	8b 04 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%eax
  80142a:	85 c0                	test   %eax,%eax
  80142c:	74 1c                	je     80144a <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80142e:	50                   	push   %eax
  80142f:	68 dd 1f 80 00       	push   $0x801fdd
  801434:	53                   	push   %ebx
  801435:	56                   	push   %esi
  801436:	e8 b6 fe ff ff       	call   8012f1 <printfmt>
  80143b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80143e:	89 7d 14             	mov    %edi,0x14(%ebp)
  801441:	e9 8a 02 00 00       	jmp    8016d0 <vprintfmt+0x3c2>
  801446:	f7 d8                	neg    %eax
  801448:	eb d2                	jmp    80141c <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80144a:	52                   	push   %edx
  80144b:	68 5f 20 80 00       	push   $0x80205f
  801450:	53                   	push   %ebx
  801451:	56                   	push   %esi
  801452:	e8 9a fe ff ff       	call   8012f1 <printfmt>
  801457:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80145a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80145d:	e9 6e 02 00 00       	jmp    8016d0 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  801462:	8b 45 14             	mov    0x14(%ebp),%eax
  801465:	83 c0 04             	add    $0x4,%eax
  801468:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80146b:	8b 45 14             	mov    0x14(%ebp),%eax
  80146e:	8b 38                	mov    (%eax),%edi
  801470:	85 ff                	test   %edi,%edi
  801472:	74 39                	je     8014ad <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  801474:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801478:	0f 8e a9 00 00 00    	jle    801527 <vprintfmt+0x219>
  80147e:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801482:	0f 84 a7 00 00 00    	je     80152f <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 d0             	pushl  -0x30(%ebp)
  80148e:	57                   	push   %edi
  80148f:	e8 6b 03 00 00       	call   8017ff <strnlen>
  801494:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801497:	29 c1                	sub    %eax,%ecx
  801499:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80149c:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80149f:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8014a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014a6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014a9:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014ab:	eb 14                	jmp    8014c1 <vprintfmt+0x1b3>
				p = "(null)";
  8014ad:	bf 58 20 80 00       	mov    $0x802058,%edi
  8014b2:	eb c0                	jmp    801474 <vprintfmt+0x166>
					putch(padc, putdat);
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	53                   	push   %ebx
  8014b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8014bb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014bd:	4f                   	dec    %edi
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	85 ff                	test   %edi,%edi
  8014c3:	7f ef                	jg     8014b4 <vprintfmt+0x1a6>
  8014c5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8014c8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014cb:	89 c8                	mov    %ecx,%eax
  8014cd:	85 c9                	test   %ecx,%ecx
  8014cf:	78 10                	js     8014e1 <vprintfmt+0x1d3>
  8014d1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014d4:	29 c1                	sub    %eax,%ecx
  8014d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8014d9:	89 75 08             	mov    %esi,0x8(%ebp)
  8014dc:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8014df:	eb 15                	jmp    8014f6 <vprintfmt+0x1e8>
  8014e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e6:	eb e9                	jmp    8014d1 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	53                   	push   %ebx
  8014ec:	52                   	push   %edx
  8014ed:	ff 55 08             	call   *0x8(%ebp)
  8014f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014f3:	ff 4d e0             	decl   -0x20(%ebp)
  8014f6:	47                   	inc    %edi
  8014f7:	8a 47 ff             	mov    -0x1(%edi),%al
  8014fa:	0f be d0             	movsbl %al,%edx
  8014fd:	85 d2                	test   %edx,%edx
  8014ff:	74 59                	je     80155a <vprintfmt+0x24c>
  801501:	85 f6                	test   %esi,%esi
  801503:	78 03                	js     801508 <vprintfmt+0x1fa>
  801505:	4e                   	dec    %esi
  801506:	78 2f                	js     801537 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801508:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80150c:	74 da                	je     8014e8 <vprintfmt+0x1da>
  80150e:	0f be c0             	movsbl %al,%eax
  801511:	83 e8 20             	sub    $0x20,%eax
  801514:	83 f8 5e             	cmp    $0x5e,%eax
  801517:	76 cf                	jbe    8014e8 <vprintfmt+0x1da>
					putch('?', putdat);
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	53                   	push   %ebx
  80151d:	6a 3f                	push   $0x3f
  80151f:	ff 55 08             	call   *0x8(%ebp)
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	eb cc                	jmp    8014f3 <vprintfmt+0x1e5>
  801527:	89 75 08             	mov    %esi,0x8(%ebp)
  80152a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80152d:	eb c7                	jmp    8014f6 <vprintfmt+0x1e8>
  80152f:	89 75 08             	mov    %esi,0x8(%ebp)
  801532:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801535:	eb bf                	jmp    8014f6 <vprintfmt+0x1e8>
  801537:	8b 75 08             	mov    0x8(%ebp),%esi
  80153a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80153d:	eb 0c                	jmp    80154b <vprintfmt+0x23d>
				putch(' ', putdat);
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	53                   	push   %ebx
  801543:	6a 20                	push   $0x20
  801545:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801547:	4f                   	dec    %edi
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	85 ff                	test   %edi,%edi
  80154d:	7f f0                	jg     80153f <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80154f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801552:	89 45 14             	mov    %eax,0x14(%ebp)
  801555:	e9 76 01 00 00       	jmp    8016d0 <vprintfmt+0x3c2>
  80155a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80155d:	8b 75 08             	mov    0x8(%ebp),%esi
  801560:	eb e9                	jmp    80154b <vprintfmt+0x23d>
	if (lflag >= 2)
  801562:	83 f9 01             	cmp    $0x1,%ecx
  801565:	7f 1f                	jg     801586 <vprintfmt+0x278>
	else if (lflag)
  801567:	85 c9                	test   %ecx,%ecx
  801569:	75 48                	jne    8015b3 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80156b:	8b 45 14             	mov    0x14(%ebp),%eax
  80156e:	8b 00                	mov    (%eax),%eax
  801570:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801573:	89 c1                	mov    %eax,%ecx
  801575:	c1 f9 1f             	sar    $0x1f,%ecx
  801578:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80157b:	8b 45 14             	mov    0x14(%ebp),%eax
  80157e:	8d 40 04             	lea    0x4(%eax),%eax
  801581:	89 45 14             	mov    %eax,0x14(%ebp)
  801584:	eb 17                	jmp    80159d <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  801586:	8b 45 14             	mov    0x14(%ebp),%eax
  801589:	8b 50 04             	mov    0x4(%eax),%edx
  80158c:	8b 00                	mov    (%eax),%eax
  80158e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801591:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801594:	8b 45 14             	mov    0x14(%ebp),%eax
  801597:	8d 40 08             	lea    0x8(%eax),%eax
  80159a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80159d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8015a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015a7:	78 25                	js     8015ce <vprintfmt+0x2c0>
			base = 10;
  8015a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015ae:	e9 03 01 00 00       	jmp    8016b6 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b6:	8b 00                	mov    (%eax),%eax
  8015b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015bb:	89 c1                	mov    %eax,%ecx
  8015bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8015c0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c6:	8d 40 04             	lea    0x4(%eax),%eax
  8015c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8015cc:	eb cf                	jmp    80159d <vprintfmt+0x28f>
				putch('-', putdat);
  8015ce:	83 ec 08             	sub    $0x8,%esp
  8015d1:	53                   	push   %ebx
  8015d2:	6a 2d                	push   $0x2d
  8015d4:	ff d6                	call   *%esi
				num = -(long long) num;
  8015d6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015d9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8015dc:	f7 da                	neg    %edx
  8015de:	83 d1 00             	adc    $0x0,%ecx
  8015e1:	f7 d9                	neg    %ecx
  8015e3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8015e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015eb:	e9 c6 00 00 00       	jmp    8016b6 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8015f0:	83 f9 01             	cmp    $0x1,%ecx
  8015f3:	7f 1e                	jg     801613 <vprintfmt+0x305>
	else if (lflag)
  8015f5:	85 c9                	test   %ecx,%ecx
  8015f7:	75 32                	jne    80162b <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8015f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fc:	8b 10                	mov    (%eax),%edx
  8015fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801603:	8d 40 04             	lea    0x4(%eax),%eax
  801606:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801609:	b8 0a 00 00 00       	mov    $0xa,%eax
  80160e:	e9 a3 00 00 00       	jmp    8016b6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801613:	8b 45 14             	mov    0x14(%ebp),%eax
  801616:	8b 10                	mov    (%eax),%edx
  801618:	8b 48 04             	mov    0x4(%eax),%ecx
  80161b:	8d 40 08             	lea    0x8(%eax),%eax
  80161e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801621:	b8 0a 00 00 00       	mov    $0xa,%eax
  801626:	e9 8b 00 00 00       	jmp    8016b6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80162b:	8b 45 14             	mov    0x14(%ebp),%eax
  80162e:	8b 10                	mov    (%eax),%edx
  801630:	b9 00 00 00 00       	mov    $0x0,%ecx
  801635:	8d 40 04             	lea    0x4(%eax),%eax
  801638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80163b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801640:	eb 74                	jmp    8016b6 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801642:	83 f9 01             	cmp    $0x1,%ecx
  801645:	7f 1b                	jg     801662 <vprintfmt+0x354>
	else if (lflag)
  801647:	85 c9                	test   %ecx,%ecx
  801649:	75 2c                	jne    801677 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80164b:	8b 45 14             	mov    0x14(%ebp),%eax
  80164e:	8b 10                	mov    (%eax),%edx
  801650:	b9 00 00 00 00       	mov    $0x0,%ecx
  801655:	8d 40 04             	lea    0x4(%eax),%eax
  801658:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80165b:	b8 08 00 00 00       	mov    $0x8,%eax
  801660:	eb 54                	jmp    8016b6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801662:	8b 45 14             	mov    0x14(%ebp),%eax
  801665:	8b 10                	mov    (%eax),%edx
  801667:	8b 48 04             	mov    0x4(%eax),%ecx
  80166a:	8d 40 08             	lea    0x8(%eax),%eax
  80166d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801670:	b8 08 00 00 00       	mov    $0x8,%eax
  801675:	eb 3f                	jmp    8016b6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801677:	8b 45 14             	mov    0x14(%ebp),%eax
  80167a:	8b 10                	mov    (%eax),%edx
  80167c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801681:	8d 40 04             	lea    0x4(%eax),%eax
  801684:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801687:	b8 08 00 00 00       	mov    $0x8,%eax
  80168c:	eb 28                	jmp    8016b6 <vprintfmt+0x3a8>
			putch('0', putdat);
  80168e:	83 ec 08             	sub    $0x8,%esp
  801691:	53                   	push   %ebx
  801692:	6a 30                	push   $0x30
  801694:	ff d6                	call   *%esi
			putch('x', putdat);
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	53                   	push   %ebx
  80169a:	6a 78                	push   $0x78
  80169c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	8b 10                	mov    (%eax),%edx
  8016a3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016a8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016ab:	8d 40 04             	lea    0x4(%eax),%eax
  8016ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016b1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016bd:	57                   	push   %edi
  8016be:	ff 75 e0             	pushl  -0x20(%ebp)
  8016c1:	50                   	push   %eax
  8016c2:	51                   	push   %ecx
  8016c3:	52                   	push   %edx
  8016c4:	89 da                	mov    %ebx,%edx
  8016c6:	89 f0                	mov    %esi,%eax
  8016c8:	e8 5b fb ff ff       	call   801228 <printnum>
			break;
  8016cd:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8016d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016d3:	47                   	inc    %edi
  8016d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016d8:	83 f8 25             	cmp    $0x25,%eax
  8016db:	0f 84 44 fc ff ff    	je     801325 <vprintfmt+0x17>
			if (ch == '\0')
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	0f 84 89 00 00 00    	je     801772 <vprintfmt+0x464>
			putch(ch, putdat);
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	53                   	push   %ebx
  8016ed:	50                   	push   %eax
  8016ee:	ff d6                	call   *%esi
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	eb de                	jmp    8016d3 <vprintfmt+0x3c5>
	if (lflag >= 2)
  8016f5:	83 f9 01             	cmp    $0x1,%ecx
  8016f8:	7f 1b                	jg     801715 <vprintfmt+0x407>
	else if (lflag)
  8016fa:	85 c9                	test   %ecx,%ecx
  8016fc:	75 2c                	jne    80172a <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8016fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801701:	8b 10                	mov    (%eax),%edx
  801703:	b9 00 00 00 00       	mov    $0x0,%ecx
  801708:	8d 40 04             	lea    0x4(%eax),%eax
  80170b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80170e:	b8 10 00 00 00       	mov    $0x10,%eax
  801713:	eb a1                	jmp    8016b6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801715:	8b 45 14             	mov    0x14(%ebp),%eax
  801718:	8b 10                	mov    (%eax),%edx
  80171a:	8b 48 04             	mov    0x4(%eax),%ecx
  80171d:	8d 40 08             	lea    0x8(%eax),%eax
  801720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801723:	b8 10 00 00 00       	mov    $0x10,%eax
  801728:	eb 8c                	jmp    8016b6 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80172a:	8b 45 14             	mov    0x14(%ebp),%eax
  80172d:	8b 10                	mov    (%eax),%edx
  80172f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801734:	8d 40 04             	lea    0x4(%eax),%eax
  801737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80173a:	b8 10 00 00 00       	mov    $0x10,%eax
  80173f:	e9 72 ff ff ff       	jmp    8016b6 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801744:	83 ec 08             	sub    $0x8,%esp
  801747:	53                   	push   %ebx
  801748:	6a 25                	push   $0x25
  80174a:	ff d6                	call   *%esi
			break;
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	e9 7c ff ff ff       	jmp    8016d0 <vprintfmt+0x3c2>
			putch('%', putdat);
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	53                   	push   %ebx
  801758:	6a 25                	push   $0x25
  80175a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	89 f8                	mov    %edi,%eax
  801761:	eb 01                	jmp    801764 <vprintfmt+0x456>
  801763:	48                   	dec    %eax
  801764:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801768:	75 f9                	jne    801763 <vprintfmt+0x455>
  80176a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80176d:	e9 5e ff ff ff       	jmp    8016d0 <vprintfmt+0x3c2>
}
  801772:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5f                   	pop    %edi
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    

0080177a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 18             	sub    $0x18,%esp
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801786:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801789:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80178d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801797:	85 c0                	test   %eax,%eax
  801799:	74 26                	je     8017c1 <vsnprintf+0x47>
  80179b:	85 d2                	test   %edx,%edx
  80179d:	7e 29                	jle    8017c8 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80179f:	ff 75 14             	pushl  0x14(%ebp)
  8017a2:	ff 75 10             	pushl  0x10(%ebp)
  8017a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017a8:	50                   	push   %eax
  8017a9:	68 d5 12 80 00       	push   $0x8012d5
  8017ae:	e8 5b fb ff ff       	call   80130e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bc:	83 c4 10             	add    $0x10,%esp
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    
		return -E_INVAL;
  8017c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c6:	eb f7                	jmp    8017bf <vsnprintf+0x45>
  8017c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cd:	eb f0                	jmp    8017bf <vsnprintf+0x45>

008017cf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017d8:	50                   	push   %eax
  8017d9:	ff 75 10             	pushl  0x10(%ebp)
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	ff 75 08             	pushl  0x8(%ebp)
  8017e2:	e8 93 ff ff ff       	call   80177a <vsnprintf>
	va_end(ap);

	return rc;
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f4:	eb 01                	jmp    8017f7 <strlen+0xe>
		n++;
  8017f6:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8017f7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8017fb:	75 f9                	jne    8017f6 <strlen+0xd>
	return n;
}
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801805:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801808:	b8 00 00 00 00       	mov    $0x0,%eax
  80180d:	eb 01                	jmp    801810 <strnlen+0x11>
		n++;
  80180f:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801810:	39 d0                	cmp    %edx,%eax
  801812:	74 06                	je     80181a <strnlen+0x1b>
  801814:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801818:	75 f5                	jne    80180f <strnlen+0x10>
	return n;
}
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	53                   	push   %ebx
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801826:	89 c2                	mov    %eax,%edx
  801828:	42                   	inc    %edx
  801829:	41                   	inc    %ecx
  80182a:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80182d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801830:	84 db                	test   %bl,%bl
  801832:	75 f4                	jne    801828 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801834:	5b                   	pop    %ebx
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    

00801837 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	53                   	push   %ebx
  80183b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80183e:	53                   	push   %ebx
  80183f:	e8 a5 ff ff ff       	call   8017e9 <strlen>
  801844:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	01 d8                	add    %ebx,%eax
  80184c:	50                   	push   %eax
  80184d:	e8 ca ff ff ff       	call   80181c <strcpy>
	return dst;
}
  801852:	89 d8                	mov    %ebx,%eax
  801854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	56                   	push   %esi
  80185d:	53                   	push   %ebx
  80185e:	8b 75 08             	mov    0x8(%ebp),%esi
  801861:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801864:	89 f3                	mov    %esi,%ebx
  801866:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801869:	89 f2                	mov    %esi,%edx
  80186b:	eb 0c                	jmp    801879 <strncpy+0x20>
		*dst++ = *src;
  80186d:	42                   	inc    %edx
  80186e:	8a 01                	mov    (%ecx),%al
  801870:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801873:	80 39 01             	cmpb   $0x1,(%ecx)
  801876:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801879:	39 da                	cmp    %ebx,%edx
  80187b:	75 f0                	jne    80186d <strncpy+0x14>
	}
	return ret;
}
  80187d:	89 f0                	mov    %esi,%eax
  80187f:	5b                   	pop    %ebx
  801880:	5e                   	pop    %esi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	8b 75 08             	mov    0x8(%ebp),%esi
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801891:	85 c0                	test   %eax,%eax
  801893:	74 20                	je     8018b5 <strlcpy+0x32>
  801895:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  801899:	89 f0                	mov    %esi,%eax
  80189b:	eb 05                	jmp    8018a2 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80189d:	40                   	inc    %eax
  80189e:	42                   	inc    %edx
  80189f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8018a2:	39 d8                	cmp    %ebx,%eax
  8018a4:	74 06                	je     8018ac <strlcpy+0x29>
  8018a6:	8a 0a                	mov    (%edx),%cl
  8018a8:	84 c9                	test   %cl,%cl
  8018aa:	75 f1                	jne    80189d <strlcpy+0x1a>
		*dst = '\0';
  8018ac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018af:	29 f0                	sub    %esi,%eax
}
  8018b1:	5b                   	pop    %ebx
  8018b2:	5e                   	pop    %esi
  8018b3:	5d                   	pop    %ebp
  8018b4:	c3                   	ret    
  8018b5:	89 f0                	mov    %esi,%eax
  8018b7:	eb f6                	jmp    8018af <strlcpy+0x2c>

008018b9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018c2:	eb 02                	jmp    8018c6 <strcmp+0xd>
		p++, q++;
  8018c4:	41                   	inc    %ecx
  8018c5:	42                   	inc    %edx
	while (*p && *p == *q)
  8018c6:	8a 01                	mov    (%ecx),%al
  8018c8:	84 c0                	test   %al,%al
  8018ca:	74 04                	je     8018d0 <strcmp+0x17>
  8018cc:	3a 02                	cmp    (%edx),%al
  8018ce:	74 f4                	je     8018c4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d0:	0f b6 c0             	movzbl %al,%eax
  8018d3:	0f b6 12             	movzbl (%edx),%edx
  8018d6:	29 d0                	sub    %edx,%eax
}
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    

008018da <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	89 c3                	mov    %eax,%ebx
  8018e6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018e9:	eb 02                	jmp    8018ed <strncmp+0x13>
		n--, p++, q++;
  8018eb:	40                   	inc    %eax
  8018ec:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8018ed:	39 d8                	cmp    %ebx,%eax
  8018ef:	74 15                	je     801906 <strncmp+0x2c>
  8018f1:	8a 08                	mov    (%eax),%cl
  8018f3:	84 c9                	test   %cl,%cl
  8018f5:	74 04                	je     8018fb <strncmp+0x21>
  8018f7:	3a 0a                	cmp    (%edx),%cl
  8018f9:	74 f0                	je     8018eb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018fb:	0f b6 00             	movzbl (%eax),%eax
  8018fe:	0f b6 12             	movzbl (%edx),%edx
  801901:	29 d0                	sub    %edx,%eax
}
  801903:	5b                   	pop    %ebx
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    
		return 0;
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
  80190b:	eb f6                	jmp    801903 <strncmp+0x29>

0080190d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801916:	8a 10                	mov    (%eax),%dl
  801918:	84 d2                	test   %dl,%dl
  80191a:	74 07                	je     801923 <strchr+0x16>
		if (*s == c)
  80191c:	38 ca                	cmp    %cl,%dl
  80191e:	74 08                	je     801928 <strchr+0x1b>
	for (; *s; s++)
  801920:	40                   	inc    %eax
  801921:	eb f3                	jmp    801916 <strchr+0x9>
			return (char *) s;
	return 0;
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801933:	8a 10                	mov    (%eax),%dl
  801935:	84 d2                	test   %dl,%dl
  801937:	74 07                	je     801940 <strfind+0x16>
		if (*s == c)
  801939:	38 ca                	cmp    %cl,%dl
  80193b:	74 03                	je     801940 <strfind+0x16>
	for (; *s; s++)
  80193d:	40                   	inc    %eax
  80193e:	eb f3                	jmp    801933 <strfind+0x9>
			break;
	return (char *) s;
}
  801940:	5d                   	pop    %ebp
  801941:	c3                   	ret    

00801942 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	57                   	push   %edi
  801946:	56                   	push   %esi
  801947:	53                   	push   %ebx
  801948:	8b 7d 08             	mov    0x8(%ebp),%edi
  80194b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80194e:	85 c9                	test   %ecx,%ecx
  801950:	74 13                	je     801965 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801952:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801958:	75 05                	jne    80195f <memset+0x1d>
  80195a:	f6 c1 03             	test   $0x3,%cl
  80195d:	74 0d                	je     80196c <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80195f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801962:	fc                   	cld    
  801963:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801965:	89 f8                	mov    %edi,%eax
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
		c &= 0xFF;
  80196c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801970:	89 d3                	mov    %edx,%ebx
  801972:	c1 e3 08             	shl    $0x8,%ebx
  801975:	89 d0                	mov    %edx,%eax
  801977:	c1 e0 18             	shl    $0x18,%eax
  80197a:	89 d6                	mov    %edx,%esi
  80197c:	c1 e6 10             	shl    $0x10,%esi
  80197f:	09 f0                	or     %esi,%eax
  801981:	09 c2                	or     %eax,%edx
  801983:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801985:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801988:	89 d0                	mov    %edx,%eax
  80198a:	fc                   	cld    
  80198b:	f3 ab                	rep stos %eax,%es:(%edi)
  80198d:	eb d6                	jmp    801965 <memset+0x23>

0080198f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	57                   	push   %edi
  801993:	56                   	push   %esi
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	8b 75 0c             	mov    0xc(%ebp),%esi
  80199a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80199d:	39 c6                	cmp    %eax,%esi
  80199f:	73 33                	jae    8019d4 <memmove+0x45>
  8019a1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019a4:	39 d0                	cmp    %edx,%eax
  8019a6:	73 2c                	jae    8019d4 <memmove+0x45>
		s += n;
		d += n;
  8019a8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019ab:	89 d6                	mov    %edx,%esi
  8019ad:	09 fe                	or     %edi,%esi
  8019af:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019b5:	75 13                	jne    8019ca <memmove+0x3b>
  8019b7:	f6 c1 03             	test   $0x3,%cl
  8019ba:	75 0e                	jne    8019ca <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019bc:	83 ef 04             	sub    $0x4,%edi
  8019bf:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019c2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019c5:	fd                   	std    
  8019c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019c8:	eb 07                	jmp    8019d1 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019ca:	4f                   	dec    %edi
  8019cb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019ce:	fd                   	std    
  8019cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019d1:	fc                   	cld    
  8019d2:	eb 13                	jmp    8019e7 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019d4:	89 f2                	mov    %esi,%edx
  8019d6:	09 c2                	or     %eax,%edx
  8019d8:	f6 c2 03             	test   $0x3,%dl
  8019db:	75 05                	jne    8019e2 <memmove+0x53>
  8019dd:	f6 c1 03             	test   $0x3,%cl
  8019e0:	74 09                	je     8019eb <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019e2:	89 c7                	mov    %eax,%edi
  8019e4:	fc                   	cld    
  8019e5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019e7:	5e                   	pop    %esi
  8019e8:	5f                   	pop    %edi
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019eb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019ee:	89 c7                	mov    %eax,%edi
  8019f0:	fc                   	cld    
  8019f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019f3:	eb f2                	jmp    8019e7 <memmove+0x58>

008019f5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8019f8:	ff 75 10             	pushl  0x10(%ebp)
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	e8 89 ff ff ff       	call   80198f <memmove>
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	56                   	push   %esi
  801a0c:	53                   	push   %ebx
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	89 c6                	mov    %eax,%esi
  801a12:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a18:	39 f0                	cmp    %esi,%eax
  801a1a:	74 16                	je     801a32 <memcmp+0x2a>
		if (*s1 != *s2)
  801a1c:	8a 08                	mov    (%eax),%cl
  801a1e:	8a 1a                	mov    (%edx),%bl
  801a20:	38 d9                	cmp    %bl,%cl
  801a22:	75 04                	jne    801a28 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a24:	40                   	inc    %eax
  801a25:	42                   	inc    %edx
  801a26:	eb f0                	jmp    801a18 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a28:	0f b6 c1             	movzbl %cl,%eax
  801a2b:	0f b6 db             	movzbl %bl,%ebx
  801a2e:	29 d8                	sub    %ebx,%eax
  801a30:	eb 05                	jmp    801a37 <memcmp+0x2f>
	}

	return 0;
  801a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5d                   	pop    %ebp
  801a3a:	c3                   	ret    

00801a3b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a44:	89 c2                	mov    %eax,%edx
  801a46:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a49:	39 d0                	cmp    %edx,%eax
  801a4b:	73 07                	jae    801a54 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a4d:	38 08                	cmp    %cl,(%eax)
  801a4f:	74 03                	je     801a54 <memfind+0x19>
	for (; s < ends; s++)
  801a51:	40                   	inc    %eax
  801a52:	eb f5                	jmp    801a49 <memfind+0xe>
			break;
	return (void *) s;
}
  801a54:	5d                   	pop    %ebp
  801a55:	c3                   	ret    

00801a56 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	57                   	push   %edi
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a5f:	eb 01                	jmp    801a62 <strtol+0xc>
		s++;
  801a61:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a62:	8a 01                	mov    (%ecx),%al
  801a64:	3c 20                	cmp    $0x20,%al
  801a66:	74 f9                	je     801a61 <strtol+0xb>
  801a68:	3c 09                	cmp    $0x9,%al
  801a6a:	74 f5                	je     801a61 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801a6c:	3c 2b                	cmp    $0x2b,%al
  801a6e:	74 2b                	je     801a9b <strtol+0x45>
		s++;
	else if (*s == '-')
  801a70:	3c 2d                	cmp    $0x2d,%al
  801a72:	74 2f                	je     801aa3 <strtol+0x4d>
	int neg = 0;
  801a74:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a79:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801a80:	75 12                	jne    801a94 <strtol+0x3e>
  801a82:	80 39 30             	cmpb   $0x30,(%ecx)
  801a85:	74 24                	je     801aab <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801a87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a8b:	75 07                	jne    801a94 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a8d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
  801a99:	eb 4e                	jmp    801ae9 <strtol+0x93>
		s++;
  801a9b:	41                   	inc    %ecx
	int neg = 0;
  801a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa1:	eb d6                	jmp    801a79 <strtol+0x23>
		s++, neg = 1;
  801aa3:	41                   	inc    %ecx
  801aa4:	bf 01 00 00 00       	mov    $0x1,%edi
  801aa9:	eb ce                	jmp    801a79 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aab:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801aaf:	74 10                	je     801ac1 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801ab1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ab5:	75 dd                	jne    801a94 <strtol+0x3e>
		s++, base = 8;
  801ab7:	41                   	inc    %ecx
  801ab8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801abf:	eb d3                	jmp    801a94 <strtol+0x3e>
		s += 2, base = 16;
  801ac1:	83 c1 02             	add    $0x2,%ecx
  801ac4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801acb:	eb c7                	jmp    801a94 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801acd:	8d 72 9f             	lea    -0x61(%edx),%esi
  801ad0:	89 f3                	mov    %esi,%ebx
  801ad2:	80 fb 19             	cmp    $0x19,%bl
  801ad5:	77 24                	ja     801afb <strtol+0xa5>
			dig = *s - 'a' + 10;
  801ad7:	0f be d2             	movsbl %dl,%edx
  801ada:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801add:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ae0:	7d 2b                	jge    801b0d <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801ae2:	41                   	inc    %ecx
  801ae3:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ae7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ae9:	8a 11                	mov    (%ecx),%dl
  801aeb:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801aee:	80 fb 09             	cmp    $0x9,%bl
  801af1:	77 da                	ja     801acd <strtol+0x77>
			dig = *s - '0';
  801af3:	0f be d2             	movsbl %dl,%edx
  801af6:	83 ea 30             	sub    $0x30,%edx
  801af9:	eb e2                	jmp    801add <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801afb:	8d 72 bf             	lea    -0x41(%edx),%esi
  801afe:	89 f3                	mov    %esi,%ebx
  801b00:	80 fb 19             	cmp    $0x19,%bl
  801b03:	77 08                	ja     801b0d <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b05:	0f be d2             	movsbl %dl,%edx
  801b08:	83 ea 37             	sub    $0x37,%edx
  801b0b:	eb d0                	jmp    801add <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b11:	74 05                	je     801b18 <strtol+0xc2>
		*endptr = (char *) s;
  801b13:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b16:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b18:	85 ff                	test   %edi,%edi
  801b1a:	74 02                	je     801b1e <strtol+0xc8>
  801b1c:	f7 d8                	neg    %eax
}
  801b1e:	5b                   	pop    %ebx
  801b1f:	5e                   	pop    %esi
  801b20:	5f                   	pop    %edi
  801b21:	5d                   	pop    %ebp
  801b22:	c3                   	ret    

00801b23 <atoi>:

int
atoi(const char *s)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b26:	6a 0a                	push   $0xa
  801b28:	6a 00                	push   $0x0
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	e8 24 ff ff ff       	call   801a56 <strtol>
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	57                   	push   %edi
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 0c             	sub    $0xc,%esp
  801b3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b40:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b43:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b46:	85 ff                	test   %edi,%edi
  801b48:	74 53                	je     801b9d <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	57                   	push   %edi
  801b4e:	e8 fe e7 ff ff       	call   800351 <sys_ipc_recv>
  801b53:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b56:	85 db                	test   %ebx,%ebx
  801b58:	74 0b                	je     801b65 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b5a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b60:	8b 52 74             	mov    0x74(%edx),%edx
  801b63:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b65:	85 f6                	test   %esi,%esi
  801b67:	74 0f                	je     801b78 <ipc_recv+0x44>
  801b69:	85 ff                	test   %edi,%edi
  801b6b:	74 0b                	je     801b78 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b6d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b73:	8b 52 78             	mov    0x78(%edx),%edx
  801b76:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b78:	85 c0                	test   %eax,%eax
  801b7a:	74 30                	je     801bac <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b7c:	85 db                	test   %ebx,%ebx
  801b7e:	74 06                	je     801b86 <ipc_recv+0x52>
      		*from_env_store = 0;
  801b80:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801b86:	85 f6                	test   %esi,%esi
  801b88:	74 2c                	je     801bb6 <ipc_recv+0x82>
      		*perm_store = 0;
  801b8a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801b95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5e                   	pop    %esi
  801b9a:	5f                   	pop    %edi
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801b9d:	83 ec 0c             	sub    $0xc,%esp
  801ba0:	6a ff                	push   $0xffffffff
  801ba2:	e8 aa e7 ff ff       	call   800351 <sys_ipc_recv>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	eb aa                	jmp    801b56 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bac:	a1 04 40 80 00       	mov    0x804004,%eax
  801bb1:	8b 40 70             	mov    0x70(%eax),%eax
  801bb4:	eb df                	jmp    801b95 <ipc_recv+0x61>
		return -1;
  801bb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bbb:	eb d8                	jmp    801b95 <ipc_recv+0x61>

00801bbd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	57                   	push   %edi
  801bc1:	56                   	push   %esi
  801bc2:	53                   	push   %ebx
  801bc3:	83 ec 0c             	sub    $0xc,%esp
  801bc6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bcc:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bcf:	85 db                	test   %ebx,%ebx
  801bd1:	75 22                	jne    801bf5 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bd3:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801bd8:	eb 1b                	jmp    801bf5 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bda:	68 40 23 80 00       	push   $0x802340
  801bdf:	68 cb 1f 80 00       	push   $0x801fcb
  801be4:	6a 48                	push   $0x48
  801be6:	68 64 23 80 00       	push   $0x802364
  801beb:	e8 11 f5 ff ff       	call   801101 <_panic>
		sys_yield();
  801bf0:	e8 13 e6 ff ff       	call   800208 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801bf5:	57                   	push   %edi
  801bf6:	53                   	push   %ebx
  801bf7:	56                   	push   %esi
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	e8 2e e7 ff ff       	call   80032e <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c06:	74 e8                	je     801bf0 <ipc_send+0x33>
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	75 ce                	jne    801bda <ipc_send+0x1d>
		sys_yield();
  801c0c:	e8 f7 e5 ff ff       	call   800208 <sys_yield>
		
	}
	
}
  801c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c14:	5b                   	pop    %ebx
  801c15:	5e                   	pop    %esi
  801c16:	5f                   	pop    %edi
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c24:	89 c2                	mov    %eax,%edx
  801c26:	c1 e2 05             	shl    $0x5,%edx
  801c29:	29 c2                	sub    %eax,%edx
  801c2b:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c32:	8b 52 50             	mov    0x50(%edx),%edx
  801c35:	39 ca                	cmp    %ecx,%edx
  801c37:	74 0f                	je     801c48 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c39:	40                   	inc    %eax
  801c3a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c3f:	75 e3                	jne    801c24 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
  801c46:	eb 11                	jmp    801c59 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c48:	89 c2                	mov    %eax,%edx
  801c4a:	c1 e2 05             	shl    $0x5,%edx
  801c4d:	29 c2                	sub    %eax,%edx
  801c4f:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c56:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c59:	5d                   	pop    %ebp
  801c5a:	c3                   	ret    

00801c5b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	c1 e8 16             	shr    $0x16,%eax
  801c64:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c6b:	a8 01                	test   $0x1,%al
  801c6d:	74 21                	je     801c90 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	c1 e8 0c             	shr    $0xc,%eax
  801c75:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c7c:	a8 01                	test   $0x1,%al
  801c7e:	74 17                	je     801c97 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c80:	c1 e8 0c             	shr    $0xc,%eax
  801c83:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c8a:	ef 
  801c8b:	0f b7 c0             	movzwl %ax,%eax
  801c8e:	eb 05                	jmp    801c95 <pageref+0x3a>
		return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c95:	5d                   	pop    %ebp
  801c96:	c3                   	ret    
		return 0;
  801c97:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9c:	eb f7                	jmp    801c95 <pageref+0x3a>
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <__udivdi3>:
  801ca0:	55                   	push   %ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 1c             	sub    $0x1c,%esp
  801ca7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801caf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cb7:	89 ca                	mov    %ecx,%edx
  801cb9:	89 f8                	mov    %edi,%eax
  801cbb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cbf:	85 f6                	test   %esi,%esi
  801cc1:	75 2d                	jne    801cf0 <__udivdi3+0x50>
  801cc3:	39 cf                	cmp    %ecx,%edi
  801cc5:	77 65                	ja     801d2c <__udivdi3+0x8c>
  801cc7:	89 fd                	mov    %edi,%ebp
  801cc9:	85 ff                	test   %edi,%edi
  801ccb:	75 0b                	jne    801cd8 <__udivdi3+0x38>
  801ccd:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd2:	31 d2                	xor    %edx,%edx
  801cd4:	f7 f7                	div    %edi
  801cd6:	89 c5                	mov    %eax,%ebp
  801cd8:	31 d2                	xor    %edx,%edx
  801cda:	89 c8                	mov    %ecx,%eax
  801cdc:	f7 f5                	div    %ebp
  801cde:	89 c1                	mov    %eax,%ecx
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	f7 f5                	div    %ebp
  801ce4:	89 cf                	mov    %ecx,%edi
  801ce6:	89 fa                	mov    %edi,%edx
  801ce8:	83 c4 1c             	add    $0x1c,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    
  801cf0:	39 ce                	cmp    %ecx,%esi
  801cf2:	77 28                	ja     801d1c <__udivdi3+0x7c>
  801cf4:	0f bd fe             	bsr    %esi,%edi
  801cf7:	83 f7 1f             	xor    $0x1f,%edi
  801cfa:	75 40                	jne    801d3c <__udivdi3+0x9c>
  801cfc:	39 ce                	cmp    %ecx,%esi
  801cfe:	72 0a                	jb     801d0a <__udivdi3+0x6a>
  801d00:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d04:	0f 87 9e 00 00 00    	ja     801da8 <__udivdi3+0x108>
  801d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0f:	89 fa                	mov    %edi,%edx
  801d11:	83 c4 1c             	add    $0x1c,%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5f                   	pop    %edi
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    
  801d19:	8d 76 00             	lea    0x0(%esi),%esi
  801d1c:	31 ff                	xor    %edi,%edi
  801d1e:	31 c0                	xor    %eax,%eax
  801d20:	89 fa                	mov    %edi,%edx
  801d22:	83 c4 1c             	add    $0x1c,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    
  801d2a:	66 90                	xchg   %ax,%ax
  801d2c:	89 d8                	mov    %ebx,%eax
  801d2e:	f7 f7                	div    %edi
  801d30:	31 ff                	xor    %edi,%edi
  801d32:	89 fa                	mov    %edi,%edx
  801d34:	83 c4 1c             	add    $0x1c,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5f                   	pop    %edi
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    
  801d3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d41:	29 fd                	sub    %edi,%ebp
  801d43:	89 f9                	mov    %edi,%ecx
  801d45:	d3 e6                	shl    %cl,%esi
  801d47:	89 c3                	mov    %eax,%ebx
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 eb                	shr    %cl,%ebx
  801d4d:	89 d9                	mov    %ebx,%ecx
  801d4f:	09 f1                	or     %esi,%ecx
  801d51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d55:	89 f9                	mov    %edi,%ecx
  801d57:	d3 e0                	shl    %cl,%eax
  801d59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d5d:	89 d6                	mov    %edx,%esi
  801d5f:	89 e9                	mov    %ebp,%ecx
  801d61:	d3 ee                	shr    %cl,%esi
  801d63:	89 f9                	mov    %edi,%ecx
  801d65:	d3 e2                	shl    %cl,%edx
  801d67:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d6b:	89 e9                	mov    %ebp,%ecx
  801d6d:	d3 eb                	shr    %cl,%ebx
  801d6f:	09 da                	or     %ebx,%edx
  801d71:	89 d0                	mov    %edx,%eax
  801d73:	89 f2                	mov    %esi,%edx
  801d75:	f7 74 24 08          	divl   0x8(%esp)
  801d79:	89 d6                	mov    %edx,%esi
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	f7 64 24 0c          	mull   0xc(%esp)
  801d81:	39 d6                	cmp    %edx,%esi
  801d83:	72 17                	jb     801d9c <__udivdi3+0xfc>
  801d85:	74 09                	je     801d90 <__udivdi3+0xf0>
  801d87:	89 d8                	mov    %ebx,%eax
  801d89:	31 ff                	xor    %edi,%edi
  801d8b:	e9 56 ff ff ff       	jmp    801ce6 <__udivdi3+0x46>
  801d90:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d94:	89 f9                	mov    %edi,%ecx
  801d96:	d3 e2                	shl    %cl,%edx
  801d98:	39 c2                	cmp    %eax,%edx
  801d9a:	73 eb                	jae    801d87 <__udivdi3+0xe7>
  801d9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d9f:	31 ff                	xor    %edi,%edi
  801da1:	e9 40 ff ff ff       	jmp    801ce6 <__udivdi3+0x46>
  801da6:	66 90                	xchg   %ax,%ax
  801da8:	31 c0                	xor    %eax,%eax
  801daa:	e9 37 ff ff ff       	jmp    801ce6 <__udivdi3+0x46>
  801daf:	90                   	nop

00801db0 <__umoddi3>:
  801db0:	55                   	push   %ebp
  801db1:	57                   	push   %edi
  801db2:	56                   	push   %esi
  801db3:	53                   	push   %ebx
  801db4:	83 ec 1c             	sub    $0x1c,%esp
  801db7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dbb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dc3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dcb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dcf:	89 3c 24             	mov    %edi,(%esp)
  801dd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dd6:	89 f2                	mov    %esi,%edx
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	75 18                	jne    801df4 <__umoddi3+0x44>
  801ddc:	39 f7                	cmp    %esi,%edi
  801dde:	0f 86 a0 00 00 00    	jbe    801e84 <__umoddi3+0xd4>
  801de4:	89 c8                	mov    %ecx,%eax
  801de6:	f7 f7                	div    %edi
  801de8:	89 d0                	mov    %edx,%eax
  801dea:	31 d2                	xor    %edx,%edx
  801dec:	83 c4 1c             	add    $0x1c,%esp
  801def:	5b                   	pop    %ebx
  801df0:	5e                   	pop    %esi
  801df1:	5f                   	pop    %edi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    
  801df4:	89 f3                	mov    %esi,%ebx
  801df6:	39 f0                	cmp    %esi,%eax
  801df8:	0f 87 a6 00 00 00    	ja     801ea4 <__umoddi3+0xf4>
  801dfe:	0f bd e8             	bsr    %eax,%ebp
  801e01:	83 f5 1f             	xor    $0x1f,%ebp
  801e04:	0f 84 a6 00 00 00    	je     801eb0 <__umoddi3+0x100>
  801e0a:	bf 20 00 00 00       	mov    $0x20,%edi
  801e0f:	29 ef                	sub    %ebp,%edi
  801e11:	89 e9                	mov    %ebp,%ecx
  801e13:	d3 e0                	shl    %cl,%eax
  801e15:	8b 34 24             	mov    (%esp),%esi
  801e18:	89 f2                	mov    %esi,%edx
  801e1a:	89 f9                	mov    %edi,%ecx
  801e1c:	d3 ea                	shr    %cl,%edx
  801e1e:	09 c2                	or     %eax,%edx
  801e20:	89 14 24             	mov    %edx,(%esp)
  801e23:	89 f2                	mov    %esi,%edx
  801e25:	89 e9                	mov    %ebp,%ecx
  801e27:	d3 e2                	shl    %cl,%edx
  801e29:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e2d:	89 de                	mov    %ebx,%esi
  801e2f:	89 f9                	mov    %edi,%ecx
  801e31:	d3 ee                	shr    %cl,%esi
  801e33:	89 e9                	mov    %ebp,%ecx
  801e35:	d3 e3                	shl    %cl,%ebx
  801e37:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e3b:	89 d0                	mov    %edx,%eax
  801e3d:	89 f9                	mov    %edi,%ecx
  801e3f:	d3 e8                	shr    %cl,%eax
  801e41:	09 d8                	or     %ebx,%eax
  801e43:	89 d3                	mov    %edx,%ebx
  801e45:	89 e9                	mov    %ebp,%ecx
  801e47:	d3 e3                	shl    %cl,%ebx
  801e49:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e4d:	89 f2                	mov    %esi,%edx
  801e4f:	f7 34 24             	divl   (%esp)
  801e52:	89 d6                	mov    %edx,%esi
  801e54:	f7 64 24 04          	mull   0x4(%esp)
  801e58:	89 c3                	mov    %eax,%ebx
  801e5a:	89 d1                	mov    %edx,%ecx
  801e5c:	39 d6                	cmp    %edx,%esi
  801e5e:	72 7c                	jb     801edc <__umoddi3+0x12c>
  801e60:	74 72                	je     801ed4 <__umoddi3+0x124>
  801e62:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e66:	29 da                	sub    %ebx,%edx
  801e68:	19 ce                	sbb    %ecx,%esi
  801e6a:	89 f0                	mov    %esi,%eax
  801e6c:	89 f9                	mov    %edi,%ecx
  801e6e:	d3 e0                	shl    %cl,%eax
  801e70:	89 e9                	mov    %ebp,%ecx
  801e72:	d3 ea                	shr    %cl,%edx
  801e74:	09 d0                	or     %edx,%eax
  801e76:	89 e9                	mov    %ebp,%ecx
  801e78:	d3 ee                	shr    %cl,%esi
  801e7a:	89 f2                	mov    %esi,%edx
  801e7c:	83 c4 1c             	add    $0x1c,%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    
  801e84:	89 fd                	mov    %edi,%ebp
  801e86:	85 ff                	test   %edi,%edi
  801e88:	75 0b                	jne    801e95 <__umoddi3+0xe5>
  801e8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8f:	31 d2                	xor    %edx,%edx
  801e91:	f7 f7                	div    %edi
  801e93:	89 c5                	mov    %eax,%ebp
  801e95:	89 f0                	mov    %esi,%eax
  801e97:	31 d2                	xor    %edx,%edx
  801e99:	f7 f5                	div    %ebp
  801e9b:	89 c8                	mov    %ecx,%eax
  801e9d:	f7 f5                	div    %ebp
  801e9f:	e9 44 ff ff ff       	jmp    801de8 <__umoddi3+0x38>
  801ea4:	89 c8                	mov    %ecx,%eax
  801ea6:	89 f2                	mov    %esi,%edx
  801ea8:	83 c4 1c             	add    $0x1c,%esp
  801eab:	5b                   	pop    %ebx
  801eac:	5e                   	pop    %esi
  801ead:	5f                   	pop    %edi
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    
  801eb0:	39 f0                	cmp    %esi,%eax
  801eb2:	72 05                	jb     801eb9 <__umoddi3+0x109>
  801eb4:	39 0c 24             	cmp    %ecx,(%esp)
  801eb7:	77 0c                	ja     801ec5 <__umoddi3+0x115>
  801eb9:	89 f2                	mov    %esi,%edx
  801ebb:	29 f9                	sub    %edi,%ecx
  801ebd:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ec1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec5:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ec9:	83 c4 1c             	add    $0x1c,%esp
  801ecc:	5b                   	pop    %ebx
  801ecd:	5e                   	pop    %esi
  801ece:	5f                   	pop    %edi
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    
  801ed1:	8d 76 00             	lea    0x0(%esi),%esi
  801ed4:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ed8:	73 88                	jae    801e62 <__umoddi3+0xb2>
  801eda:	66 90                	xchg   %ax,%ax
  801edc:	2b 44 24 04          	sub    0x4(%esp),%eax
  801ee0:	1b 14 24             	sbb    (%esp),%edx
  801ee3:	89 d1                	mov    %edx,%ecx
  801ee5:	89 c3                	mov    %eax,%ebx
  801ee7:	e9 76 ff ff ff       	jmp    801e62 <__umoddi3+0xb2>
