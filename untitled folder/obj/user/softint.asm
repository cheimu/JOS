
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $14");	// page fault
  800036:	cd 0e                	int    $0xe
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800045:	e8 d4 00 00 00       	call   80011e <sys_getenvid>
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	89 c2                	mov    %eax,%edx
  800051:	c1 e2 05             	shl    $0x5,%edx
  800054:	29 c2                	sub    %eax,%edx
  800056:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80005d:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800062:	85 db                	test   %ebx,%ebx
  800064:	7e 07                	jle    80006d <libmain+0x33>
		binaryname = argv[0];
  800066:	8b 06                	mov    (%esi),%eax
  800068:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006d:	83 ec 08             	sub    $0x8,%esp
  800070:	56                   	push   %esi
  800071:	53                   	push   %ebx
  800072:	e8 bc ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800077:	e8 0a 00 00 00       	call   800086 <exit>
}
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800082:	5b                   	pop    %ebx
  800083:	5e                   	pop    %esi
  800084:	5d                   	pop    %ebp
  800085:	c3                   	ret    

00800086 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800086:	55                   	push   %ebp
  800087:	89 e5                	mov    %esp,%ebp
  800089:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008c:	e8 35 05 00 00       	call   8005c6 <close_all>
	sys_env_destroy(0);
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	6a 00                	push   $0x0
  800096:	e8 42 00 00 00       	call   8000dd <sys_env_destroy>
}
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	c9                   	leave  
  80009f:	c3                   	ret    

008000a0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b1:	89 c3                	mov    %eax,%ebx
  8000b3:	89 c7                	mov    %eax,%edi
  8000b5:	89 c6                	mov    %eax,%esi
  8000b7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b9:	5b                   	pop    %ebx
  8000ba:	5e                   	pop    %esi
  8000bb:	5f                   	pop    %edi
  8000bc:	5d                   	pop    %ebp
  8000bd:	c3                   	ret    

008000be <sys_cgetc>:

int
sys_cgetc(void)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	57                   	push   %edi
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ce:	89 d1                	mov    %edx,%ecx
  8000d0:	89 d3                	mov    %edx,%ebx
  8000d2:	89 d7                	mov    %edx,%edi
  8000d4:	89 d6                	mov    %edx,%esi
  8000d6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d8:	5b                   	pop    %ebx
  8000d9:	5e                   	pop    %esi
  8000da:	5f                   	pop    %edi
  8000db:	5d                   	pop    %ebp
  8000dc:	c3                   	ret    

008000dd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	57                   	push   %edi
  8000e1:	56                   	push   %esi
  8000e2:	53                   	push   %ebx
  8000e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f3:	89 cb                	mov    %ecx,%ebx
  8000f5:	89 cf                	mov    %ecx,%edi
  8000f7:	89 ce                	mov    %ecx,%esi
  8000f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fb:	85 c0                	test   %eax,%eax
  8000fd:	7f 08                	jg     800107 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5f                   	pop    %edi
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	50                   	push   %eax
  80010b:	6a 03                	push   $0x3
  80010d:	68 0a 1f 80 00       	push   $0x801f0a
  800112:	6a 23                	push   $0x23
  800114:	68 27 1f 80 00       	push   $0x801f27
  800119:	e8 df 0f 00 00       	call   8010fd <_panic>

0080011e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80011e:	55                   	push   %ebp
  80011f:	89 e5                	mov    %esp,%ebp
  800121:	57                   	push   %edi
  800122:	56                   	push   %esi
  800123:	53                   	push   %ebx
	asm volatile("int %1\n"
  800124:	ba 00 00 00 00       	mov    $0x0,%edx
  800129:	b8 02 00 00 00       	mov    $0x2,%eax
  80012e:	89 d1                	mov    %edx,%ecx
  800130:	89 d3                	mov    %edx,%ebx
  800132:	89 d7                	mov    %edx,%edi
  800134:	89 d6                	mov    %edx,%esi
  800136:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5f                   	pop    %edi
  80013b:	5d                   	pop    %ebp
  80013c:	c3                   	ret    

0080013d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	57                   	push   %edi
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800146:	be 00 00 00 00       	mov    $0x0,%esi
  80014b:	b8 04 00 00 00       	mov    $0x4,%eax
  800150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800153:	8b 55 08             	mov    0x8(%ebp),%edx
  800156:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800159:	89 f7                	mov    %esi,%edi
  80015b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80015d:	85 c0                	test   %eax,%eax
  80015f:	7f 08                	jg     800169 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	50                   	push   %eax
  80016d:	6a 04                	push   $0x4
  80016f:	68 0a 1f 80 00       	push   $0x801f0a
  800174:	6a 23                	push   $0x23
  800176:	68 27 1f 80 00       	push   $0x801f27
  80017b:	e8 7d 0f 00 00       	call   8010fd <_panic>

00800180 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800189:	b8 05 00 00 00       	mov    $0x5,%eax
  80018e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800191:	8b 55 08             	mov    0x8(%ebp),%edx
  800194:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800197:	8b 7d 14             	mov    0x14(%ebp),%edi
  80019a:	8b 75 18             	mov    0x18(%ebp),%esi
  80019d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	7f 08                	jg     8001ab <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a6:	5b                   	pop    %ebx
  8001a7:	5e                   	pop    %esi
  8001a8:	5f                   	pop    %edi
  8001a9:	5d                   	pop    %ebp
  8001aa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	6a 05                	push   $0x5
  8001b1:	68 0a 1f 80 00       	push   $0x801f0a
  8001b6:	6a 23                	push   $0x23
  8001b8:	68 27 1f 80 00       	push   $0x801f27
  8001bd:	e8 3b 0f 00 00       	call   8010fd <_panic>

008001c2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	57                   	push   %edi
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d0:	b8 06 00 00 00       	mov    $0x6,%eax
  8001d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001db:	89 df                	mov    %ebx,%edi
  8001dd:	89 de                	mov    %ebx,%esi
  8001df:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e1:	85 c0                	test   %eax,%eax
  8001e3:	7f 08                	jg     8001ed <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e8:	5b                   	pop    %ebx
  8001e9:	5e                   	pop    %esi
  8001ea:	5f                   	pop    %edi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	50                   	push   %eax
  8001f1:	6a 06                	push   $0x6
  8001f3:	68 0a 1f 80 00       	push   $0x801f0a
  8001f8:	6a 23                	push   $0x23
  8001fa:	68 27 1f 80 00       	push   $0x801f27
  8001ff:	e8 f9 0e 00 00       	call   8010fd <_panic>

00800204 <sys_yield>:

void
sys_yield(void)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
	asm volatile("int %1\n"
  80020a:	ba 00 00 00 00       	mov    $0x0,%edx
  80020f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800214:	89 d1                	mov    %edx,%ecx
  800216:	89 d3                	mov    %edx,%ebx
  800218:	89 d7                	mov    %edx,%edi
  80021a:	89 d6                	mov    %edx,%esi
  80021c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80021e:	5b                   	pop    %ebx
  80021f:	5e                   	pop    %esi
  800220:	5f                   	pop    %edi
  800221:	5d                   	pop    %ebp
  800222:	c3                   	ret    

00800223 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	57                   	push   %edi
  800227:	56                   	push   %esi
  800228:	53                   	push   %ebx
  800229:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800231:	b8 08 00 00 00       	mov    $0x8,%eax
  800236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800239:	8b 55 08             	mov    0x8(%ebp),%edx
  80023c:	89 df                	mov    %ebx,%edi
  80023e:	89 de                	mov    %ebx,%esi
  800240:	cd 30                	int    $0x30
	if(check && ret > 0)
  800242:	85 c0                	test   %eax,%eax
  800244:	7f 08                	jg     80024e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800246:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800249:	5b                   	pop    %ebx
  80024a:	5e                   	pop    %esi
  80024b:	5f                   	pop    %edi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	50                   	push   %eax
  800252:	6a 08                	push   $0x8
  800254:	68 0a 1f 80 00       	push   $0x801f0a
  800259:	6a 23                	push   $0x23
  80025b:	68 27 1f 80 00       	push   $0x801f27
  800260:	e8 98 0e 00 00       	call   8010fd <_panic>

00800265 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	57                   	push   %edi
  800269:	56                   	push   %esi
  80026a:	53                   	push   %ebx
  80026b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800273:	b8 0c 00 00 00       	mov    $0xc,%eax
  800278:	8b 55 08             	mov    0x8(%ebp),%edx
  80027b:	89 cb                	mov    %ecx,%ebx
  80027d:	89 cf                	mov    %ecx,%edi
  80027f:	89 ce                	mov    %ecx,%esi
  800281:	cd 30                	int    $0x30
	if(check && ret > 0)
  800283:	85 c0                	test   %eax,%eax
  800285:	7f 08                	jg     80028f <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	6a 0c                	push   $0xc
  800295:	68 0a 1f 80 00       	push   $0x801f0a
  80029a:	6a 23                	push   $0x23
  80029c:	68 27 1f 80 00       	push   $0x801f27
  8002a1:	e8 57 0e 00 00       	call   8010fd <_panic>

008002a6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	57                   	push   %edi
  8002aa:	56                   	push   %esi
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b4:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bf:	89 df                	mov    %ebx,%edi
  8002c1:	89 de                	mov    %ebx,%esi
  8002c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c5:	85 c0                	test   %eax,%eax
  8002c7:	7f 08                	jg     8002d1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cc:	5b                   	pop    %ebx
  8002cd:	5e                   	pop    %esi
  8002ce:	5f                   	pop    %edi
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d1:	83 ec 0c             	sub    $0xc,%esp
  8002d4:	50                   	push   %eax
  8002d5:	6a 09                	push   $0x9
  8002d7:	68 0a 1f 80 00       	push   $0x801f0a
  8002dc:	6a 23                	push   $0x23
  8002de:	68 27 1f 80 00       	push   $0x801f27
  8002e3:	e8 15 0e 00 00       	call   8010fd <_panic>

008002e8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	57                   	push   %edi
  8002ec:	56                   	push   %esi
  8002ed:	53                   	push   %ebx
  8002ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800301:	89 df                	mov    %ebx,%edi
  800303:	89 de                	mov    %ebx,%esi
  800305:	cd 30                	int    $0x30
	if(check && ret > 0)
  800307:	85 c0                	test   %eax,%eax
  800309:	7f 08                	jg     800313 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800313:	83 ec 0c             	sub    $0xc,%esp
  800316:	50                   	push   %eax
  800317:	6a 0a                	push   $0xa
  800319:	68 0a 1f 80 00       	push   $0x801f0a
  80031e:	6a 23                	push   $0x23
  800320:	68 27 1f 80 00       	push   $0x801f27
  800325:	e8 d3 0d 00 00       	call   8010fd <_panic>

0080032a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	57                   	push   %edi
  80032e:	56                   	push   %esi
  80032f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800330:	be 00 00 00 00       	mov    $0x0,%esi
  800335:	b8 0d 00 00 00       	mov    $0xd,%eax
  80033a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033d:	8b 55 08             	mov    0x8(%ebp),%edx
  800340:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800343:	8b 7d 14             	mov    0x14(%ebp),%edi
  800346:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800348:	5b                   	pop    %ebx
  800349:	5e                   	pop    %esi
  80034a:	5f                   	pop    %edi
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	57                   	push   %edi
  800351:	56                   	push   %esi
  800352:	53                   	push   %ebx
  800353:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800356:	b9 00 00 00 00       	mov    $0x0,%ecx
  80035b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800360:	8b 55 08             	mov    0x8(%ebp),%edx
  800363:	89 cb                	mov    %ecx,%ebx
  800365:	89 cf                	mov    %ecx,%edi
  800367:	89 ce                	mov    %ecx,%esi
  800369:	cd 30                	int    $0x30
	if(check && ret > 0)
  80036b:	85 c0                	test   %eax,%eax
  80036d:	7f 08                	jg     800377 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80036f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800372:	5b                   	pop    %ebx
  800373:	5e                   	pop    %esi
  800374:	5f                   	pop    %edi
  800375:	5d                   	pop    %ebp
  800376:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800377:	83 ec 0c             	sub    $0xc,%esp
  80037a:	50                   	push   %eax
  80037b:	6a 0e                	push   $0xe
  80037d:	68 0a 1f 80 00       	push   $0x801f0a
  800382:	6a 23                	push   $0x23
  800384:	68 27 1f 80 00       	push   $0x801f27
  800389:	e8 6f 0d 00 00       	call   8010fd <_panic>

0080038e <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
	asm volatile("int %1\n"
  800394:	be 00 00 00 00       	mov    $0x0,%esi
  800399:	b8 0f 00 00 00       	mov    $0xf,%eax
  80039e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003a7:	89 f7                	mov    %esi,%edi
  8003a9:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003ab:	5b                   	pop    %ebx
  8003ac:	5e                   	pop    %esi
  8003ad:	5f                   	pop    %edi
  8003ae:	5d                   	pop    %ebp
  8003af:	c3                   	ret    

008003b0 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	57                   	push   %edi
  8003b4:	56                   	push   %esi
  8003b5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003b6:	be 00 00 00 00       	mov    $0x0,%esi
  8003bb:	b8 10 00 00 00       	mov    $0x10,%eax
  8003c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003c9:	89 f7                	mov    %esi,%edi
  8003cb:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003cd:	5b                   	pop    %ebx
  8003ce:	5e                   	pop    %esi
  8003cf:	5f                   	pop    %edi
  8003d0:	5d                   	pop    %ebp
  8003d1:	c3                   	ret    

008003d2 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003d2:	55                   	push   %ebp
  8003d3:	89 e5                	mov    %esp,%ebp
  8003d5:	57                   	push   %edi
  8003d6:	56                   	push   %esi
  8003d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003dd:	b8 11 00 00 00       	mov    $0x11,%eax
  8003e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e5:	89 cb                	mov    %ecx,%ebx
  8003e7:	89 cf                	mov    %ecx,%edi
  8003e9:	89 ce                	mov    %ecx,%esi
  8003eb:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8003ed:	5b                   	pop    %ebx
  8003ee:	5e                   	pop    %esi
  8003ef:	5f                   	pop    %edi
  8003f0:	5d                   	pop    %ebp
  8003f1:	c3                   	ret    

008003f2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	05 00 00 00 30       	add    $0x30000000,%eax
  8003fd:	c1 e8 0c             	shr    $0xc,%eax
}
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    

00800402 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80040d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800412:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800417:	5d                   	pop    %ebp
  800418:	c3                   	ret    

00800419 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80041f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800424:	89 c2                	mov    %eax,%edx
  800426:	c1 ea 16             	shr    $0x16,%edx
  800429:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800430:	f6 c2 01             	test   $0x1,%dl
  800433:	74 2a                	je     80045f <fd_alloc+0x46>
  800435:	89 c2                	mov    %eax,%edx
  800437:	c1 ea 0c             	shr    $0xc,%edx
  80043a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800441:	f6 c2 01             	test   $0x1,%dl
  800444:	74 19                	je     80045f <fd_alloc+0x46>
  800446:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80044b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800450:	75 d2                	jne    800424 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800452:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800458:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80045d:	eb 07                	jmp    800466 <fd_alloc+0x4d>
			*fd_store = fd;
  80045f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800461:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800466:	5d                   	pop    %ebp
  800467:	c3                   	ret    

00800468 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80046b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  80046f:	77 39                	ja     8004aa <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	c1 e0 0c             	shl    $0xc,%eax
  800477:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80047c:	89 c2                	mov    %eax,%edx
  80047e:	c1 ea 16             	shr    $0x16,%edx
  800481:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800488:	f6 c2 01             	test   $0x1,%dl
  80048b:	74 24                	je     8004b1 <fd_lookup+0x49>
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	c1 ea 0c             	shr    $0xc,%edx
  800492:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800499:	f6 c2 01             	test   $0x1,%dl
  80049c:	74 1a                	je     8004b8 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80049e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a1:	89 02                	mov    %eax,(%edx)
	return 0;
  8004a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a8:	5d                   	pop    %ebp
  8004a9:	c3                   	ret    
		return -E_INVAL;
  8004aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004af:	eb f7                	jmp    8004a8 <fd_lookup+0x40>
		return -E_INVAL;
  8004b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004b6:	eb f0                	jmp    8004a8 <fd_lookup+0x40>
  8004b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004bd:	eb e9                	jmp    8004a8 <fd_lookup+0x40>

008004bf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c8:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004cd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004d2:	39 08                	cmp    %ecx,(%eax)
  8004d4:	74 33                	je     800509 <dev_lookup+0x4a>
  8004d6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004d9:	8b 02                	mov    (%edx),%eax
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	75 f3                	jne    8004d2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004df:	a1 04 40 80 00       	mov    0x804004,%eax
  8004e4:	8b 40 48             	mov    0x48(%eax),%eax
  8004e7:	83 ec 04             	sub    $0x4,%esp
  8004ea:	51                   	push   %ecx
  8004eb:	50                   	push   %eax
  8004ec:	68 38 1f 80 00       	push   $0x801f38
  8004f1:	e8 1a 0d 00 00       	call   801210 <cprintf>
	*dev = 0;
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800507:	c9                   	leave  
  800508:	c3                   	ret    
			*dev = devtab[i];
  800509:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	eb f2                	jmp    800507 <dev_lookup+0x48>

00800515 <fd_close>:
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	57                   	push   %edi
  800519:	56                   	push   %esi
  80051a:	53                   	push   %ebx
  80051b:	83 ec 1c             	sub    $0x1c,%esp
  80051e:	8b 75 08             	mov    0x8(%ebp),%esi
  800521:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800524:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800527:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800528:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80052e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800531:	50                   	push   %eax
  800532:	e8 31 ff ff ff       	call   800468 <fd_lookup>
  800537:	89 c7                	mov    %eax,%edi
  800539:	83 c4 08             	add    $0x8,%esp
  80053c:	85 c0                	test   %eax,%eax
  80053e:	78 05                	js     800545 <fd_close+0x30>
	    || fd != fd2)
  800540:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800543:	74 13                	je     800558 <fd_close+0x43>
		return (must_exist ? r : 0);
  800545:	84 db                	test   %bl,%bl
  800547:	75 05                	jne    80054e <fd_close+0x39>
  800549:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80054e:	89 f8                	mov    %edi,%eax
  800550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800553:	5b                   	pop    %ebx
  800554:	5e                   	pop    %esi
  800555:	5f                   	pop    %edi
  800556:	5d                   	pop    %ebp
  800557:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80055e:	50                   	push   %eax
  80055f:	ff 36                	pushl  (%esi)
  800561:	e8 59 ff ff ff       	call   8004bf <dev_lookup>
  800566:	89 c7                	mov    %eax,%edi
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	85 c0                	test   %eax,%eax
  80056d:	78 15                	js     800584 <fd_close+0x6f>
		if (dev->dev_close)
  80056f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800572:	8b 40 10             	mov    0x10(%eax),%eax
  800575:	85 c0                	test   %eax,%eax
  800577:	74 1b                	je     800594 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800579:	83 ec 0c             	sub    $0xc,%esp
  80057c:	56                   	push   %esi
  80057d:	ff d0                	call   *%eax
  80057f:	89 c7                	mov    %eax,%edi
  800581:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	56                   	push   %esi
  800588:	6a 00                	push   $0x0
  80058a:	e8 33 fc ff ff       	call   8001c2 <sys_page_unmap>
	return r;
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	eb ba                	jmp    80054e <fd_close+0x39>
			r = 0;
  800594:	bf 00 00 00 00       	mov    $0x0,%edi
  800599:	eb e9                	jmp    800584 <fd_close+0x6f>

0080059b <close>:

int
close(int fdnum)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005a4:	50                   	push   %eax
  8005a5:	ff 75 08             	pushl  0x8(%ebp)
  8005a8:	e8 bb fe ff ff       	call   800468 <fd_lookup>
  8005ad:	83 c4 08             	add    $0x8,%esp
  8005b0:	85 c0                	test   %eax,%eax
  8005b2:	78 10                	js     8005c4 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	6a 01                	push   $0x1
  8005b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bc:	e8 54 ff ff ff       	call   800515 <fd_close>
  8005c1:	83 c4 10             	add    $0x10,%esp
}
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <close_all>:

void
close_all(void)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	e8 c0 ff ff ff       	call   80059b <close>
	for (i = 0; i < MAXFD; i++)
  8005db:	43                   	inc    %ebx
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	83 fb 20             	cmp    $0x20,%ebx
  8005e2:	75 ee                	jne    8005d2 <close_all+0xc>
}
  8005e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	57                   	push   %edi
  8005ed:	56                   	push   %esi
  8005ee:	53                   	push   %ebx
  8005ef:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005f5:	50                   	push   %eax
  8005f6:	ff 75 08             	pushl  0x8(%ebp)
  8005f9:	e8 6a fe ff ff       	call   800468 <fd_lookup>
  8005fe:	89 c3                	mov    %eax,%ebx
  800600:	83 c4 08             	add    $0x8,%esp
  800603:	85 c0                	test   %eax,%eax
  800605:	0f 88 81 00 00 00    	js     80068c <dup+0xa3>
		return r;
	close(newfdnum);
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	ff 75 0c             	pushl  0xc(%ebp)
  800611:	e8 85 ff ff ff       	call   80059b <close>

	newfd = INDEX2FD(newfdnum);
  800616:	8b 75 0c             	mov    0xc(%ebp),%esi
  800619:	c1 e6 0c             	shl    $0xc,%esi
  80061c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800622:	83 c4 04             	add    $0x4,%esp
  800625:	ff 75 e4             	pushl  -0x1c(%ebp)
  800628:	e8 d5 fd ff ff       	call   800402 <fd2data>
  80062d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80062f:	89 34 24             	mov    %esi,(%esp)
  800632:	e8 cb fd ff ff       	call   800402 <fd2data>
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80063c:	89 d8                	mov    %ebx,%eax
  80063e:	c1 e8 16             	shr    $0x16,%eax
  800641:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800648:	a8 01                	test   $0x1,%al
  80064a:	74 11                	je     80065d <dup+0x74>
  80064c:	89 d8                	mov    %ebx,%eax
  80064e:	c1 e8 0c             	shr    $0xc,%eax
  800651:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800658:	f6 c2 01             	test   $0x1,%dl
  80065b:	75 39                	jne    800696 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80065d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800660:	89 d0                	mov    %edx,%eax
  800662:	c1 e8 0c             	shr    $0xc,%eax
  800665:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80066c:	83 ec 0c             	sub    $0xc,%esp
  80066f:	25 07 0e 00 00       	and    $0xe07,%eax
  800674:	50                   	push   %eax
  800675:	56                   	push   %esi
  800676:	6a 00                	push   $0x0
  800678:	52                   	push   %edx
  800679:	6a 00                	push   $0x0
  80067b:	e8 00 fb ff ff       	call   800180 <sys_page_map>
  800680:	89 c3                	mov    %eax,%ebx
  800682:	83 c4 20             	add    $0x20,%esp
  800685:	85 c0                	test   %eax,%eax
  800687:	78 31                	js     8006ba <dup+0xd1>
		goto err;

	return newfdnum;
  800689:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80068c:	89 d8                	mov    %ebx,%eax
  80068e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800691:	5b                   	pop    %ebx
  800692:	5e                   	pop    %esi
  800693:	5f                   	pop    %edi
  800694:	5d                   	pop    %ebp
  800695:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800696:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80069d:	83 ec 0c             	sub    $0xc,%esp
  8006a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8006a5:	50                   	push   %eax
  8006a6:	57                   	push   %edi
  8006a7:	6a 00                	push   $0x0
  8006a9:	53                   	push   %ebx
  8006aa:	6a 00                	push   $0x0
  8006ac:	e8 cf fa ff ff       	call   800180 <sys_page_map>
  8006b1:	89 c3                	mov    %eax,%ebx
  8006b3:	83 c4 20             	add    $0x20,%esp
  8006b6:	85 c0                	test   %eax,%eax
  8006b8:	79 a3                	jns    80065d <dup+0x74>
	sys_page_unmap(0, newfd);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	56                   	push   %esi
  8006be:	6a 00                	push   $0x0
  8006c0:	e8 fd fa ff ff       	call   8001c2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006c5:	83 c4 08             	add    $0x8,%esp
  8006c8:	57                   	push   %edi
  8006c9:	6a 00                	push   $0x0
  8006cb:	e8 f2 fa ff ff       	call   8001c2 <sys_page_unmap>
	return r;
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	eb b7                	jmp    80068c <dup+0xa3>

008006d5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	53                   	push   %ebx
  8006d9:	83 ec 14             	sub    $0x14,%esp
  8006dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006e2:	50                   	push   %eax
  8006e3:	53                   	push   %ebx
  8006e4:	e8 7f fd ff ff       	call   800468 <fd_lookup>
  8006e9:	83 c4 08             	add    $0x8,%esp
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	78 3f                	js     80072f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006f6:	50                   	push   %eax
  8006f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fa:	ff 30                	pushl  (%eax)
  8006fc:	e8 be fd ff ff       	call   8004bf <dev_lookup>
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	85 c0                	test   %eax,%eax
  800706:	78 27                	js     80072f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800708:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80070b:	8b 42 08             	mov    0x8(%edx),%eax
  80070e:	83 e0 03             	and    $0x3,%eax
  800711:	83 f8 01             	cmp    $0x1,%eax
  800714:	74 1e                	je     800734 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800719:	8b 40 08             	mov    0x8(%eax),%eax
  80071c:	85 c0                	test   %eax,%eax
  80071e:	74 35                	je     800755 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800720:	83 ec 04             	sub    $0x4,%esp
  800723:	ff 75 10             	pushl  0x10(%ebp)
  800726:	ff 75 0c             	pushl  0xc(%ebp)
  800729:	52                   	push   %edx
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
}
  80072f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800732:	c9                   	leave  
  800733:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800734:	a1 04 40 80 00       	mov    0x804004,%eax
  800739:	8b 40 48             	mov    0x48(%eax),%eax
  80073c:	83 ec 04             	sub    $0x4,%esp
  80073f:	53                   	push   %ebx
  800740:	50                   	push   %eax
  800741:	68 79 1f 80 00       	push   $0x801f79
  800746:	e8 c5 0a 00 00       	call   801210 <cprintf>
		return -E_INVAL;
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800753:	eb da                	jmp    80072f <read+0x5a>
		return -E_NOT_SUPP;
  800755:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80075a:	eb d3                	jmp    80072f <read+0x5a>

0080075c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	57                   	push   %edi
  800760:	56                   	push   %esi
  800761:	53                   	push   %ebx
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	8b 7d 08             	mov    0x8(%ebp),%edi
  800768:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80076b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800770:	39 f3                	cmp    %esi,%ebx
  800772:	73 25                	jae    800799 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800774:	83 ec 04             	sub    $0x4,%esp
  800777:	89 f0                	mov    %esi,%eax
  800779:	29 d8                	sub    %ebx,%eax
  80077b:	50                   	push   %eax
  80077c:	89 d8                	mov    %ebx,%eax
  80077e:	03 45 0c             	add    0xc(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	57                   	push   %edi
  800783:	e8 4d ff ff ff       	call   8006d5 <read>
		if (m < 0)
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	85 c0                	test   %eax,%eax
  80078d:	78 08                	js     800797 <readn+0x3b>
			return m;
		if (m == 0)
  80078f:	85 c0                	test   %eax,%eax
  800791:	74 06                	je     800799 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800793:	01 c3                	add    %eax,%ebx
  800795:	eb d9                	jmp    800770 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800797:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800799:	89 d8                	mov    %ebx,%eax
  80079b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079e:	5b                   	pop    %ebx
  80079f:	5e                   	pop    %esi
  8007a0:	5f                   	pop    %edi
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	53                   	push   %ebx
  8007a7:	83 ec 14             	sub    $0x14,%esp
  8007aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	53                   	push   %ebx
  8007b2:	e8 b1 fc ff ff       	call   800468 <fd_lookup>
  8007b7:	83 c4 08             	add    $0x8,%esp
  8007ba:	85 c0                	test   %eax,%eax
  8007bc:	78 3a                	js     8007f8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c4:	50                   	push   %eax
  8007c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c8:	ff 30                	pushl  (%eax)
  8007ca:	e8 f0 fc ff ff       	call   8004bf <dev_lookup>
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	85 c0                	test   %eax,%eax
  8007d4:	78 22                	js     8007f8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007dd:	74 1e                	je     8007fd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8007e5:	85 d2                	test   %edx,%edx
  8007e7:	74 35                	je     80081e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	ff 75 10             	pushl  0x10(%ebp)
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	50                   	push   %eax
  8007f3:	ff d2                	call   *%edx
  8007f5:	83 c4 10             	add    $0x10,%esp
}
  8007f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007fd:	a1 04 40 80 00       	mov    0x804004,%eax
  800802:	8b 40 48             	mov    0x48(%eax),%eax
  800805:	83 ec 04             	sub    $0x4,%esp
  800808:	53                   	push   %ebx
  800809:	50                   	push   %eax
  80080a:	68 95 1f 80 00       	push   $0x801f95
  80080f:	e8 fc 09 00 00       	call   801210 <cprintf>
		return -E_INVAL;
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081c:	eb da                	jmp    8007f8 <write+0x55>
		return -E_NOT_SUPP;
  80081e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800823:	eb d3                	jmp    8007f8 <write+0x55>

00800825 <seek>:

int
seek(int fdnum, off_t offset)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80082b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80082e:	50                   	push   %eax
  80082f:	ff 75 08             	pushl  0x8(%ebp)
  800832:	e8 31 fc ff ff       	call   800468 <fd_lookup>
  800837:	83 c4 08             	add    $0x8,%esp
  80083a:	85 c0                	test   %eax,%eax
  80083c:	78 0e                	js     80084c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80083e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800841:	8b 55 0c             	mov    0xc(%ebp),%edx
  800844:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800847:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80084c:	c9                   	leave  
  80084d:	c3                   	ret    

0080084e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	53                   	push   %ebx
  800852:	83 ec 14             	sub    $0x14,%esp
  800855:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800858:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085b:	50                   	push   %eax
  80085c:	53                   	push   %ebx
  80085d:	e8 06 fc ff ff       	call   800468 <fd_lookup>
  800862:	83 c4 08             	add    $0x8,%esp
  800865:	85 c0                	test   %eax,%eax
  800867:	78 37                	js     8008a0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800873:	ff 30                	pushl  (%eax)
  800875:	e8 45 fc ff ff       	call   8004bf <dev_lookup>
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	85 c0                	test   %eax,%eax
  80087f:	78 1f                	js     8008a0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800884:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800888:	74 1b                	je     8008a5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80088a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088d:	8b 52 18             	mov    0x18(%edx),%edx
  800890:	85 d2                	test   %edx,%edx
  800892:	74 32                	je     8008c6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	50                   	push   %eax
  80089b:	ff d2                	call   *%edx
  80089d:	83 c4 10             	add    $0x10,%esp
}
  8008a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a3:	c9                   	leave  
  8008a4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008a5:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008aa:	8b 40 48             	mov    0x48(%eax),%eax
  8008ad:	83 ec 04             	sub    $0x4,%esp
  8008b0:	53                   	push   %ebx
  8008b1:	50                   	push   %eax
  8008b2:	68 58 1f 80 00       	push   $0x801f58
  8008b7:	e8 54 09 00 00       	call   801210 <cprintf>
		return -E_INVAL;
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c4:	eb da                	jmp    8008a0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8008c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008cb:	eb d3                	jmp    8008a0 <ftruncate+0x52>

008008cd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	53                   	push   %ebx
  8008d1:	83 ec 14             	sub    $0x14,%esp
  8008d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008da:	50                   	push   %eax
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 85 fb ff ff       	call   800468 <fd_lookup>
  8008e3:	83 c4 08             	add    $0x8,%esp
  8008e6:	85 c0                	test   %eax,%eax
  8008e8:	78 4b                	js     800935 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008f0:	50                   	push   %eax
  8008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f4:	ff 30                	pushl  (%eax)
  8008f6:	e8 c4 fb ff ff       	call   8004bf <dev_lookup>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	85 c0                	test   %eax,%eax
  800900:	78 33                	js     800935 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800905:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800909:	74 2f                	je     80093a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80090b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80090e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800915:	00 00 00 
	stat->st_type = 0;
  800918:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80091f:	00 00 00 
	stat->st_dev = dev;
  800922:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	53                   	push   %ebx
  80092c:	ff 75 f0             	pushl  -0x10(%ebp)
  80092f:	ff 50 14             	call   *0x14(%eax)
  800932:	83 c4 10             	add    $0x10,%esp
}
  800935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800938:	c9                   	leave  
  800939:	c3                   	ret    
		return -E_NOT_SUPP;
  80093a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80093f:	eb f4                	jmp    800935 <fstat+0x68>

00800941 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	56                   	push   %esi
  800945:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	6a 00                	push   $0x0
  80094b:	ff 75 08             	pushl  0x8(%ebp)
  80094e:	e8 34 02 00 00       	call   800b87 <open>
  800953:	89 c3                	mov    %eax,%ebx
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	85 c0                	test   %eax,%eax
  80095a:	78 1b                	js     800977 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	50                   	push   %eax
  800963:	e8 65 ff ff ff       	call   8008cd <fstat>
  800968:	89 c6                	mov    %eax,%esi
	close(fd);
  80096a:	89 1c 24             	mov    %ebx,(%esp)
  80096d:	e8 29 fc ff ff       	call   80059b <close>
	return r;
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 f3                	mov    %esi,%ebx
}
  800977:	89 d8                	mov    %ebx,%eax
  800979:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80097c:	5b                   	pop    %ebx
  80097d:	5e                   	pop    %esi
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	89 c6                	mov    %eax,%esi
  800987:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800989:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800990:	74 27                	je     8009b9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800992:	6a 07                	push   $0x7
  800994:	68 00 50 80 00       	push   $0x805000
  800999:	56                   	push   %esi
  80099a:	ff 35 00 40 80 00    	pushl  0x804000
  8009a0:	e8 14 12 00 00       	call   801bb9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009a5:	83 c4 0c             	add    $0xc,%esp
  8009a8:	6a 00                	push   $0x0
  8009aa:	53                   	push   %ebx
  8009ab:	6a 00                	push   $0x0
  8009ad:	e8 7e 11 00 00       	call   801b30 <ipc_recv>
}
  8009b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009b5:	5b                   	pop    %ebx
  8009b6:	5e                   	pop    %esi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009b9:	83 ec 0c             	sub    $0xc,%esp
  8009bc:	6a 01                	push   $0x1
  8009be:	e8 52 12 00 00       	call   801c15 <ipc_find_env>
  8009c3:	a3 00 40 80 00       	mov    %eax,0x804000
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	eb c5                	jmp    800992 <fsipc+0x12>

008009cd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8009d9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009eb:	b8 02 00 00 00       	mov    $0x2,%eax
  8009f0:	e8 8b ff ff ff       	call   800980 <fsipc>
}
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <devfile_flush>:
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8b 40 0c             	mov    0xc(%eax),%eax
  800a03:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	b8 06 00 00 00       	mov    $0x6,%eax
  800a12:	e8 69 ff ff ff       	call   800980 <fsipc>
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <devfile_stat>:
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	53                   	push   %ebx
  800a1d:	83 ec 04             	sub    $0x4,%esp
  800a20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 40 0c             	mov    0xc(%eax),%eax
  800a29:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a33:	b8 05 00 00 00       	mov    $0x5,%eax
  800a38:	e8 43 ff ff ff       	call   800980 <fsipc>
  800a3d:	85 c0                	test   %eax,%eax
  800a3f:	78 2c                	js     800a6d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	68 00 50 80 00       	push   $0x805000
  800a49:	53                   	push   %ebx
  800a4a:	e8 c9 0d 00 00       	call   801818 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a4f:	a1 80 50 80 00       	mov    0x805080,%eax
  800a54:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a5a:	a1 84 50 80 00       	mov    0x805084,%eax
  800a5f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <devfile_write>:
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	53                   	push   %ebx
  800a76:	83 ec 04             	sub    $0x4,%esp
  800a79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800a7c:	89 d8                	mov    %ebx,%eax
  800a7e:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800a84:	76 05                	jbe    800a8b <devfile_write+0x19>
  800a86:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8e:	8b 52 0c             	mov    0xc(%edx),%edx
  800a91:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800a97:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800a9c:	83 ec 04             	sub    $0x4,%esp
  800a9f:	50                   	push   %eax
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	68 08 50 80 00       	push   $0x805008
  800aa8:	e8 de 0e 00 00       	call   80198b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800aad:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ab7:	e8 c4 fe ff ff       	call   800980 <fsipc>
  800abc:	83 c4 10             	add    $0x10,%esp
  800abf:	85 c0                	test   %eax,%eax
  800ac1:	78 0b                	js     800ace <devfile_write+0x5c>
	assert(r <= n);
  800ac3:	39 c3                	cmp    %eax,%ebx
  800ac5:	72 0c                	jb     800ad3 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800ac7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800acc:	7f 1e                	jg     800aec <devfile_write+0x7a>
}
  800ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    
	assert(r <= n);
  800ad3:	68 c4 1f 80 00       	push   $0x801fc4
  800ad8:	68 cb 1f 80 00       	push   $0x801fcb
  800add:	68 98 00 00 00       	push   $0x98
  800ae2:	68 e0 1f 80 00       	push   $0x801fe0
  800ae7:	e8 11 06 00 00       	call   8010fd <_panic>
	assert(r <= PGSIZE);
  800aec:	68 eb 1f 80 00       	push   $0x801feb
  800af1:	68 cb 1f 80 00       	push   $0x801fcb
  800af6:	68 99 00 00 00       	push   $0x99
  800afb:	68 e0 1f 80 00       	push   $0x801fe0
  800b00:	e8 f8 05 00 00       	call   8010fd <_panic>

00800b05 <devfile_read>:
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
  800b0a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 40 0c             	mov    0xc(%eax),%eax
  800b13:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b18:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b23:	b8 03 00 00 00       	mov    $0x3,%eax
  800b28:	e8 53 fe ff ff       	call   800980 <fsipc>
  800b2d:	89 c3                	mov    %eax,%ebx
  800b2f:	85 c0                	test   %eax,%eax
  800b31:	78 1f                	js     800b52 <devfile_read+0x4d>
	assert(r <= n);
  800b33:	39 c6                	cmp    %eax,%esi
  800b35:	72 24                	jb     800b5b <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b37:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b3c:	7f 33                	jg     800b71 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b3e:	83 ec 04             	sub    $0x4,%esp
  800b41:	50                   	push   %eax
  800b42:	68 00 50 80 00       	push   $0x805000
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	e8 3c 0e 00 00       	call   80198b <memmove>
	return r;
  800b4f:	83 c4 10             	add    $0x10,%esp
}
  800b52:	89 d8                	mov    %ebx,%eax
  800b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    
	assert(r <= n);
  800b5b:	68 c4 1f 80 00       	push   $0x801fc4
  800b60:	68 cb 1f 80 00       	push   $0x801fcb
  800b65:	6a 7c                	push   $0x7c
  800b67:	68 e0 1f 80 00       	push   $0x801fe0
  800b6c:	e8 8c 05 00 00       	call   8010fd <_panic>
	assert(r <= PGSIZE);
  800b71:	68 eb 1f 80 00       	push   $0x801feb
  800b76:	68 cb 1f 80 00       	push   $0x801fcb
  800b7b:	6a 7d                	push   $0x7d
  800b7d:	68 e0 1f 80 00       	push   $0x801fe0
  800b82:	e8 76 05 00 00       	call   8010fd <_panic>

00800b87 <open>:
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
  800b8c:	83 ec 1c             	sub    $0x1c,%esp
  800b8f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b92:	56                   	push   %esi
  800b93:	e8 4d 0c 00 00       	call   8017e5 <strlen>
  800b98:	83 c4 10             	add    $0x10,%esp
  800b9b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ba0:	7f 6c                	jg     800c0e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ba2:	83 ec 0c             	sub    $0xc,%esp
  800ba5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 6b f8 ff ff       	call   800419 <fd_alloc>
  800bae:	89 c3                	mov    %eax,%ebx
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	85 c0                	test   %eax,%eax
  800bb5:	78 3c                	js     800bf3 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	56                   	push   %esi
  800bbb:	68 00 50 80 00       	push   $0x805000
  800bc0:	e8 53 0c 00 00       	call   801818 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd0:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd5:	e8 a6 fd ff ff       	call   800980 <fsipc>
  800bda:	89 c3                	mov    %eax,%ebx
  800bdc:	83 c4 10             	add    $0x10,%esp
  800bdf:	85 c0                	test   %eax,%eax
  800be1:	78 19                	js     800bfc <open+0x75>
	return fd2num(fd);
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	ff 75 f4             	pushl  -0xc(%ebp)
  800be9:	e8 04 f8 ff ff       	call   8003f2 <fd2num>
  800bee:	89 c3                	mov    %eax,%ebx
  800bf0:	83 c4 10             	add    $0x10,%esp
}
  800bf3:	89 d8                	mov    %ebx,%eax
  800bf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf8:	5b                   	pop    %ebx
  800bf9:	5e                   	pop    %esi
  800bfa:	5d                   	pop    %ebp
  800bfb:	c3                   	ret    
		fd_close(fd, 0);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	6a 00                	push   $0x0
  800c01:	ff 75 f4             	pushl  -0xc(%ebp)
  800c04:	e8 0c f9 ff ff       	call   800515 <fd_close>
		return r;
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	eb e5                	jmp    800bf3 <open+0x6c>
		return -E_BAD_PATH;
  800c0e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c13:	eb de                	jmp    800bf3 <open+0x6c>

00800c15 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	b8 08 00 00 00       	mov    $0x8,%eax
  800c25:	e8 56 fd ff ff       	call   800980 <fsipc>
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	ff 75 08             	pushl  0x8(%ebp)
  800c3a:	e8 c3 f7 ff ff       	call   800402 <fd2data>
  800c3f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c41:	83 c4 08             	add    $0x8,%esp
  800c44:	68 f7 1f 80 00       	push   $0x801ff7
  800c49:	53                   	push   %ebx
  800c4a:	e8 c9 0b 00 00       	call   801818 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c4f:	8b 46 04             	mov    0x4(%esi),%eax
  800c52:	2b 06                	sub    (%esi),%eax
  800c54:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c5a:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800c61:	10 00 00 
	stat->st_dev = &devpipe;
  800c64:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c6b:	30 80 00 
	return 0;
}
  800c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c76:	5b                   	pop    %ebx
  800c77:	5e                   	pop    %esi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	53                   	push   %ebx
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c84:	53                   	push   %ebx
  800c85:	6a 00                	push   $0x0
  800c87:	e8 36 f5 ff ff       	call   8001c2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c8c:	89 1c 24             	mov    %ebx,(%esp)
  800c8f:	e8 6e f7 ff ff       	call   800402 <fd2data>
  800c94:	83 c4 08             	add    $0x8,%esp
  800c97:	50                   	push   %eax
  800c98:	6a 00                	push   $0x0
  800c9a:	e8 23 f5 ff ff       	call   8001c2 <sys_page_unmap>
}
  800c9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <_pipeisclosed>:
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
  800caa:	83 ec 1c             	sub    $0x1c,%esp
  800cad:	89 c7                	mov    %eax,%edi
  800caf:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cb1:	a1 04 40 80 00       	mov    0x804004,%eax
  800cb6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800cb9:	83 ec 0c             	sub    $0xc,%esp
  800cbc:	57                   	push   %edi
  800cbd:	e8 95 0f 00 00       	call   801c57 <pageref>
  800cc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cc5:	89 34 24             	mov    %esi,(%esp)
  800cc8:	e8 8a 0f 00 00       	call   801c57 <pageref>
		nn = thisenv->env_runs;
  800ccd:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cd3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800cd6:	83 c4 10             	add    $0x10,%esp
  800cd9:	39 cb                	cmp    %ecx,%ebx
  800cdb:	74 1b                	je     800cf8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800cdd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ce0:	75 cf                	jne    800cb1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800ce2:	8b 42 58             	mov    0x58(%edx),%eax
  800ce5:	6a 01                	push   $0x1
  800ce7:	50                   	push   %eax
  800ce8:	53                   	push   %ebx
  800ce9:	68 fe 1f 80 00       	push   $0x801ffe
  800cee:	e8 1d 05 00 00       	call   801210 <cprintf>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	eb b9                	jmp    800cb1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800cf8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cfb:	0f 94 c0             	sete   %al
  800cfe:	0f b6 c0             	movzbl %al,%eax
}
  800d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <devpipe_write>:
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
  800d0f:	83 ec 18             	sub    $0x18,%esp
  800d12:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d15:	56                   	push   %esi
  800d16:	e8 e7 f6 ff ff       	call   800402 <fd2data>
  800d1b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d1d:	83 c4 10             	add    $0x10,%esp
  800d20:	bf 00 00 00 00       	mov    $0x0,%edi
  800d25:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d28:	74 41                	je     800d6b <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d2a:	8b 53 04             	mov    0x4(%ebx),%edx
  800d2d:	8b 03                	mov    (%ebx),%eax
  800d2f:	83 c0 20             	add    $0x20,%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	72 14                	jb     800d4a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d36:	89 da                	mov    %ebx,%edx
  800d38:	89 f0                	mov    %esi,%eax
  800d3a:	e8 65 ff ff ff       	call   800ca4 <_pipeisclosed>
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	75 2c                	jne    800d6f <devpipe_write+0x66>
			sys_yield();
  800d43:	e8 bc f4 ff ff       	call   800204 <sys_yield>
  800d48:	eb e0                	jmp    800d2a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d50:	89 d0                	mov    %edx,%eax
  800d52:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d57:	78 0b                	js     800d64 <devpipe_write+0x5b>
  800d59:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d5d:	42                   	inc    %edx
  800d5e:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d61:	47                   	inc    %edi
  800d62:	eb c1                	jmp    800d25 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d64:	48                   	dec    %eax
  800d65:	83 c8 e0             	or     $0xffffffe0,%eax
  800d68:	40                   	inc    %eax
  800d69:	eb ee                	jmp    800d59 <devpipe_write+0x50>
	return i;
  800d6b:	89 f8                	mov    %edi,%eax
  800d6d:	eb 05                	jmp    800d74 <devpipe_write+0x6b>
				return 0;
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <devpipe_read>:
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	57                   	push   %edi
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	83 ec 18             	sub    $0x18,%esp
  800d85:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d88:	57                   	push   %edi
  800d89:	e8 74 f6 ff ff       	call   800402 <fd2data>
  800d8e:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800d9b:	74 46                	je     800de3 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800d9d:	8b 06                	mov    (%esi),%eax
  800d9f:	3b 46 04             	cmp    0x4(%esi),%eax
  800da2:	75 22                	jne    800dc6 <devpipe_read+0x4a>
			if (i > 0)
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	74 0a                	je     800db2 <devpipe_read+0x36>
				return i;
  800da8:	89 d8                	mov    %ebx,%eax
}
  800daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800db2:	89 f2                	mov    %esi,%edx
  800db4:	89 f8                	mov    %edi,%eax
  800db6:	e8 e9 fe ff ff       	call   800ca4 <_pipeisclosed>
  800dbb:	85 c0                	test   %eax,%eax
  800dbd:	75 28                	jne    800de7 <devpipe_read+0x6b>
			sys_yield();
  800dbf:	e8 40 f4 ff ff       	call   800204 <sys_yield>
  800dc4:	eb d7                	jmp    800d9d <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dc6:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800dcb:	78 0f                	js     800ddc <devpipe_read+0x60>
  800dcd:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800dd7:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800dd9:	43                   	inc    %ebx
  800dda:	eb bc                	jmp    800d98 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ddc:	48                   	dec    %eax
  800ddd:	83 c8 e0             	or     $0xffffffe0,%eax
  800de0:	40                   	inc    %eax
  800de1:	eb ea                	jmp    800dcd <devpipe_read+0x51>
	return i;
  800de3:	89 d8                	mov    %ebx,%eax
  800de5:	eb c3                	jmp    800daa <devpipe_read+0x2e>
				return 0;
  800de7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dec:	eb bc                	jmp    800daa <devpipe_read+0x2e>

00800dee <pipe>:
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800df6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800df9:	50                   	push   %eax
  800dfa:	e8 1a f6 ff ff       	call   800419 <fd_alloc>
  800dff:	89 c3                	mov    %eax,%ebx
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	85 c0                	test   %eax,%eax
  800e06:	0f 88 2a 01 00 00    	js     800f36 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0c:	83 ec 04             	sub    $0x4,%esp
  800e0f:	68 07 04 00 00       	push   $0x407
  800e14:	ff 75 f4             	pushl  -0xc(%ebp)
  800e17:	6a 00                	push   $0x0
  800e19:	e8 1f f3 ff ff       	call   80013d <sys_page_alloc>
  800e1e:	89 c3                	mov    %eax,%ebx
  800e20:	83 c4 10             	add    $0x10,%esp
  800e23:	85 c0                	test   %eax,%eax
  800e25:	0f 88 0b 01 00 00    	js     800f36 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e31:	50                   	push   %eax
  800e32:	e8 e2 f5 ff ff       	call   800419 <fd_alloc>
  800e37:	89 c3                	mov    %eax,%ebx
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	0f 88 e2 00 00 00    	js     800f26 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e44:	83 ec 04             	sub    $0x4,%esp
  800e47:	68 07 04 00 00       	push   $0x407
  800e4c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e4f:	6a 00                	push   $0x0
  800e51:	e8 e7 f2 ff ff       	call   80013d <sys_page_alloc>
  800e56:	89 c3                	mov    %eax,%ebx
  800e58:	83 c4 10             	add    $0x10,%esp
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	0f 88 c3 00 00 00    	js     800f26 <pipe+0x138>
	va = fd2data(fd0);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	ff 75 f4             	pushl  -0xc(%ebp)
  800e69:	e8 94 f5 ff ff       	call   800402 <fd2data>
  800e6e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e70:	83 c4 0c             	add    $0xc,%esp
  800e73:	68 07 04 00 00       	push   $0x407
  800e78:	50                   	push   %eax
  800e79:	6a 00                	push   $0x0
  800e7b:	e8 bd f2 ff ff       	call   80013d <sys_page_alloc>
  800e80:	89 c3                	mov    %eax,%ebx
  800e82:	83 c4 10             	add    $0x10,%esp
  800e85:	85 c0                	test   %eax,%eax
  800e87:	0f 88 89 00 00 00    	js     800f16 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	ff 75 f0             	pushl  -0x10(%ebp)
  800e93:	e8 6a f5 ff ff       	call   800402 <fd2data>
  800e98:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e9f:	50                   	push   %eax
  800ea0:	6a 00                	push   $0x0
  800ea2:	56                   	push   %esi
  800ea3:	6a 00                	push   $0x0
  800ea5:	e8 d6 f2 ff ff       	call   800180 <sys_page_map>
  800eaa:	89 c3                	mov    %eax,%ebx
  800eac:	83 c4 20             	add    $0x20,%esp
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	78 55                	js     800f08 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800eb3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebc:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800ec8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed1:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800edd:	83 ec 0c             	sub    $0xc,%esp
  800ee0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee3:	e8 0a f5 ff ff       	call   8003f2 <fd2num>
  800ee8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eeb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800eed:	83 c4 04             	add    $0x4,%esp
  800ef0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef3:	e8 fa f4 ff ff       	call   8003f2 <fd2num>
  800ef8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800efe:	83 c4 10             	add    $0x10,%esp
  800f01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f06:	eb 2e                	jmp    800f36 <pipe+0x148>
	sys_page_unmap(0, va);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	56                   	push   %esi
  800f0c:	6a 00                	push   $0x0
  800f0e:	e8 af f2 ff ff       	call   8001c2 <sys_page_unmap>
  800f13:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	ff 75 f0             	pushl  -0x10(%ebp)
  800f1c:	6a 00                	push   $0x0
  800f1e:	e8 9f f2 ff ff       	call   8001c2 <sys_page_unmap>
  800f23:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2c:	6a 00                	push   $0x0
  800f2e:	e8 8f f2 ff ff       	call   8001c2 <sys_page_unmap>
  800f33:	83 c4 10             	add    $0x10,%esp
}
  800f36:	89 d8                	mov    %ebx,%eax
  800f38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <pipeisclosed>:
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f48:	50                   	push   %eax
  800f49:	ff 75 08             	pushl  0x8(%ebp)
  800f4c:	e8 17 f5 ff ff       	call   800468 <fd_lookup>
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	85 c0                	test   %eax,%eax
  800f56:	78 18                	js     800f70 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5e:	e8 9f f4 ff ff       	call   800402 <fd2data>
	return _pipeisclosed(fd, p);
  800f63:	89 c2                	mov    %eax,%edx
  800f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f68:	e8 37 fd ff ff       	call   800ca4 <_pipeisclosed>
  800f6d:	83 c4 10             	add    $0x10,%esp
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800f75:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800f86:	68 16 20 80 00       	push   $0x802016
  800f8b:	53                   	push   %ebx
  800f8c:	e8 87 08 00 00       	call   801818 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800f91:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800f98:	20 00 00 
	return 0;
}
  800f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <devcons_write>:
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
  800fab:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fb1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fb6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fbc:	eb 1d                	jmp    800fdb <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800fbe:	83 ec 04             	sub    $0x4,%esp
  800fc1:	53                   	push   %ebx
  800fc2:	03 45 0c             	add    0xc(%ebp),%eax
  800fc5:	50                   	push   %eax
  800fc6:	57                   	push   %edi
  800fc7:	e8 bf 09 00 00       	call   80198b <memmove>
		sys_cputs(buf, m);
  800fcc:	83 c4 08             	add    $0x8,%esp
  800fcf:	53                   	push   %ebx
  800fd0:	57                   	push   %edi
  800fd1:	e8 ca f0 ff ff       	call   8000a0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fd6:	01 de                	add    %ebx,%esi
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	89 f0                	mov    %esi,%eax
  800fdd:	3b 75 10             	cmp    0x10(%ebp),%esi
  800fe0:	73 11                	jae    800ff3 <devcons_write+0x4e>
		m = n - tot;
  800fe2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe5:	29 f3                	sub    %esi,%ebx
  800fe7:	83 fb 7f             	cmp    $0x7f,%ebx
  800fea:	76 d2                	jbe    800fbe <devcons_write+0x19>
  800fec:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800ff1:	eb cb                	jmp    800fbe <devcons_write+0x19>
}
  800ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <devcons_read>:
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801001:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801005:	75 0c                	jne    801013 <devcons_read+0x18>
		return 0;
  801007:	b8 00 00 00 00       	mov    $0x0,%eax
  80100c:	eb 21                	jmp    80102f <devcons_read+0x34>
		sys_yield();
  80100e:	e8 f1 f1 ff ff       	call   800204 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801013:	e8 a6 f0 ff ff       	call   8000be <sys_cgetc>
  801018:	85 c0                	test   %eax,%eax
  80101a:	74 f2                	je     80100e <devcons_read+0x13>
	if (c < 0)
  80101c:	85 c0                	test   %eax,%eax
  80101e:	78 0f                	js     80102f <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801020:	83 f8 04             	cmp    $0x4,%eax
  801023:	74 0c                	je     801031 <devcons_read+0x36>
	*(char*)vbuf = c;
  801025:	8b 55 0c             	mov    0xc(%ebp),%edx
  801028:	88 02                	mov    %al,(%edx)
	return 1;
  80102a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    
		return 0;
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
  801036:	eb f7                	jmp    80102f <devcons_read+0x34>

00801038 <cputchar>:
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801044:	6a 01                	push   $0x1
  801046:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801049:	50                   	push   %eax
  80104a:	e8 51 f0 ff ff       	call   8000a0 <sys_cputs>
}
  80104f:	83 c4 10             	add    $0x10,%esp
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <getchar>:
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80105a:	6a 01                	push   $0x1
  80105c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80105f:	50                   	push   %eax
  801060:	6a 00                	push   $0x0
  801062:	e8 6e f6 ff ff       	call   8006d5 <read>
	if (r < 0)
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	85 c0                	test   %eax,%eax
  80106c:	78 08                	js     801076 <getchar+0x22>
	if (r < 1)
  80106e:	85 c0                	test   %eax,%eax
  801070:	7e 06                	jle    801078 <getchar+0x24>
	return c;
  801072:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801076:	c9                   	leave  
  801077:	c3                   	ret    
		return -E_EOF;
  801078:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80107d:	eb f7                	jmp    801076 <getchar+0x22>

0080107f <iscons>:
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801085:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801088:	50                   	push   %eax
  801089:	ff 75 08             	pushl  0x8(%ebp)
  80108c:	e8 d7 f3 ff ff       	call   800468 <fd_lookup>
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	85 c0                	test   %eax,%eax
  801096:	78 11                	js     8010a9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010a1:	39 10                	cmp    %edx,(%eax)
  8010a3:	0f 94 c0             	sete   %al
  8010a6:	0f b6 c0             	movzbl %al,%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <opencons>:
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010b4:	50                   	push   %eax
  8010b5:	e8 5f f3 ff ff       	call   800419 <fd_alloc>
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 3a                	js     8010fb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 07 04 00 00       	push   $0x407
  8010c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8010cc:	6a 00                	push   $0x0
  8010ce:	e8 6a f0 ff ff       	call   80013d <sys_page_alloc>
  8010d3:	83 c4 10             	add    $0x10,%esp
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	78 21                	js     8010fb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8010da:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010ef:	83 ec 0c             	sub    $0xc,%esp
  8010f2:	50                   	push   %eax
  8010f3:	e8 fa f2 ff ff       	call   8003f2 <fd2num>
  8010f8:	83 c4 10             	add    $0x10,%esp
}
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	57                   	push   %edi
  801101:	56                   	push   %esi
  801102:	53                   	push   %ebx
  801103:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801109:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80110c:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801112:	e8 07 f0 ff ff       	call   80011e <sys_getenvid>
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	ff 75 08             	pushl  0x8(%ebp)
  801120:	53                   	push   %ebx
  801121:	50                   	push   %eax
  801122:	68 24 20 80 00       	push   $0x802024
  801127:	68 00 01 00 00       	push   $0x100
  80112c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801132:	56                   	push   %esi
  801133:	e8 93 06 00 00       	call   8017cb <snprintf>
  801138:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80113a:	83 c4 20             	add    $0x20,%esp
  80113d:	57                   	push   %edi
  80113e:	ff 75 10             	pushl  0x10(%ebp)
  801141:	bf 00 01 00 00       	mov    $0x100,%edi
  801146:	89 f8                	mov    %edi,%eax
  801148:	29 d8                	sub    %ebx,%eax
  80114a:	50                   	push   %eax
  80114b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80114e:	50                   	push   %eax
  80114f:	e8 22 06 00 00       	call   801776 <vsnprintf>
  801154:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801156:	83 c4 0c             	add    $0xc,%esp
  801159:	68 0f 20 80 00       	push   $0x80200f
  80115e:	29 df                	sub    %ebx,%edi
  801160:	57                   	push   %edi
  801161:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801164:	50                   	push   %eax
  801165:	e8 61 06 00 00       	call   8017cb <snprintf>
	sys_cputs(buf, r);
  80116a:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80116d:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80116f:	53                   	push   %ebx
  801170:	56                   	push   %esi
  801171:	e8 2a ef ff ff       	call   8000a0 <sys_cputs>
  801176:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801179:	cc                   	int3   
  80117a:	eb fd                	jmp    801179 <_panic+0x7c>

0080117c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	53                   	push   %ebx
  801180:	83 ec 04             	sub    $0x4,%esp
  801183:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801186:	8b 13                	mov    (%ebx),%edx
  801188:	8d 42 01             	lea    0x1(%edx),%eax
  80118b:	89 03                	mov    %eax,(%ebx)
  80118d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801190:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801194:	3d ff 00 00 00       	cmp    $0xff,%eax
  801199:	74 08                	je     8011a3 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80119b:	ff 43 04             	incl   0x4(%ebx)
}
  80119e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	68 ff 00 00 00       	push   $0xff
  8011ab:	8d 43 08             	lea    0x8(%ebx),%eax
  8011ae:	50                   	push   %eax
  8011af:	e8 ec ee ff ff       	call   8000a0 <sys_cputs>
		b->idx = 0;
  8011b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	eb dc                	jmp    80119b <putch+0x1f>

008011bf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011cf:	00 00 00 
	b.cnt = 0;
  8011d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011dc:	ff 75 0c             	pushl  0xc(%ebp)
  8011df:	ff 75 08             	pushl  0x8(%ebp)
  8011e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011e8:	50                   	push   %eax
  8011e9:	68 7c 11 80 00       	push   $0x80117c
  8011ee:	e8 17 01 00 00       	call   80130a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011f3:	83 c4 08             	add    $0x8,%esp
  8011f6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011fc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	e8 98 ee ff ff       	call   8000a0 <sys_cputs>

	return b.cnt;
}
  801208:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801216:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801219:	50                   	push   %eax
  80121a:	ff 75 08             	pushl  0x8(%ebp)
  80121d:	e8 9d ff ff ff       	call   8011bf <vcprintf>
	va_end(ap);

	return cnt;
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	57                   	push   %edi
  801228:	56                   	push   %esi
  801229:	53                   	push   %ebx
  80122a:	83 ec 1c             	sub    $0x1c,%esp
  80122d:	89 c7                	mov    %eax,%edi
  80122f:	89 d6                	mov    %edx,%esi
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80123a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80123d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801240:	bb 00 00 00 00       	mov    $0x0,%ebx
  801245:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801248:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80124b:	39 d3                	cmp    %edx,%ebx
  80124d:	72 05                	jb     801254 <printnum+0x30>
  80124f:	39 45 10             	cmp    %eax,0x10(%ebp)
  801252:	77 78                	ja     8012cc <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801254:	83 ec 0c             	sub    $0xc,%esp
  801257:	ff 75 18             	pushl  0x18(%ebp)
  80125a:	8b 45 14             	mov    0x14(%ebp),%eax
  80125d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801260:	53                   	push   %ebx
  801261:	ff 75 10             	pushl  0x10(%ebp)
  801264:	83 ec 08             	sub    $0x8,%esp
  801267:	ff 75 e4             	pushl  -0x1c(%ebp)
  80126a:	ff 75 e0             	pushl  -0x20(%ebp)
  80126d:	ff 75 dc             	pushl  -0x24(%ebp)
  801270:	ff 75 d8             	pushl  -0x28(%ebp)
  801273:	e8 24 0a 00 00       	call   801c9c <__udivdi3>
  801278:	83 c4 18             	add    $0x18,%esp
  80127b:	52                   	push   %edx
  80127c:	50                   	push   %eax
  80127d:	89 f2                	mov    %esi,%edx
  80127f:	89 f8                	mov    %edi,%eax
  801281:	e8 9e ff ff ff       	call   801224 <printnum>
  801286:	83 c4 20             	add    $0x20,%esp
  801289:	eb 11                	jmp    80129c <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	56                   	push   %esi
  80128f:	ff 75 18             	pushl  0x18(%ebp)
  801292:	ff d7                	call   *%edi
  801294:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801297:	4b                   	dec    %ebx
  801298:	85 db                	test   %ebx,%ebx
  80129a:	7f ef                	jg     80128b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	56                   	push   %esi
  8012a0:	83 ec 04             	sub    $0x4,%esp
  8012a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8012a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8012ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8012af:	e8 f8 0a 00 00       	call   801dac <__umoddi3>
  8012b4:	83 c4 14             	add    $0x14,%esp
  8012b7:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  8012be:	50                   	push   %eax
  8012bf:	ff d7                	call   *%edi
}
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    
  8012cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012cf:	eb c6                	jmp    801297 <printnum+0x73>

008012d1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012d7:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8012da:	8b 10                	mov    (%eax),%edx
  8012dc:	3b 50 04             	cmp    0x4(%eax),%edx
  8012df:	73 0a                	jae    8012eb <sprintputch+0x1a>
		*b->buf++ = ch;
  8012e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e4:	89 08                	mov    %ecx,(%eax)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	88 02                	mov    %al,(%edx)
}
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <printfmt>:
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012f3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012f6:	50                   	push   %eax
  8012f7:	ff 75 10             	pushl  0x10(%ebp)
  8012fa:	ff 75 0c             	pushl  0xc(%ebp)
  8012fd:	ff 75 08             	pushl  0x8(%ebp)
  801300:	e8 05 00 00 00       	call   80130a <vprintfmt>
}
  801305:	83 c4 10             	add    $0x10,%esp
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <vprintfmt>:
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	57                   	push   %edi
  80130e:	56                   	push   %esi
  80130f:	53                   	push   %ebx
  801310:	83 ec 2c             	sub    $0x2c,%esp
  801313:	8b 75 08             	mov    0x8(%ebp),%esi
  801316:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801319:	8b 7d 10             	mov    0x10(%ebp),%edi
  80131c:	e9 ae 03 00 00       	jmp    8016cf <vprintfmt+0x3c5>
  801321:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801325:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80132c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801333:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80133a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80133f:	8d 47 01             	lea    0x1(%edi),%eax
  801342:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801345:	8a 17                	mov    (%edi),%dl
  801347:	8d 42 dd             	lea    -0x23(%edx),%eax
  80134a:	3c 55                	cmp    $0x55,%al
  80134c:	0f 87 fe 03 00 00    	ja     801750 <vprintfmt+0x446>
  801352:	0f b6 c0             	movzbl %al,%eax
  801355:	ff 24 85 80 21 80 00 	jmp    *0x802180(,%eax,4)
  80135c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80135f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801363:	eb da                	jmp    80133f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801368:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80136c:	eb d1                	jmp    80133f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80136e:	0f b6 d2             	movzbl %dl,%edx
  801371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801374:	b8 00 00 00 00       	mov    $0x0,%eax
  801379:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80137c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80137f:	01 c0                	add    %eax,%eax
  801381:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  801385:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801388:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80138b:	83 f9 09             	cmp    $0x9,%ecx
  80138e:	77 52                	ja     8013e2 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  801390:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  801391:	eb e9                	jmp    80137c <vprintfmt+0x72>
			precision = va_arg(ap, int);
  801393:	8b 45 14             	mov    0x14(%ebp),%eax
  801396:	8b 00                	mov    (%eax),%eax
  801398:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80139b:	8b 45 14             	mov    0x14(%ebp),%eax
  80139e:	8d 40 04             	lea    0x4(%eax),%eax
  8013a1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ab:	79 92                	jns    80133f <vprintfmt+0x35>
				width = precision, precision = -1;
  8013ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013b3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013ba:	eb 83                	jmp    80133f <vprintfmt+0x35>
  8013bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013c0:	78 08                	js     8013ca <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8013c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013c5:	e9 75 ff ff ff       	jmp    80133f <vprintfmt+0x35>
  8013ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013d1:	eb ef                	jmp    8013c2 <vprintfmt+0xb8>
  8013d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013d6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8013dd:	e9 5d ff ff ff       	jmp    80133f <vprintfmt+0x35>
  8013e2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013e8:	eb bd                	jmp    8013a7 <vprintfmt+0x9d>
			lflag++;
  8013ea:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013ee:	e9 4c ff ff ff       	jmp    80133f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8013f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f6:	8d 78 04             	lea    0x4(%eax),%edi
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	53                   	push   %ebx
  8013fd:	ff 30                	pushl  (%eax)
  8013ff:	ff d6                	call   *%esi
			break;
  801401:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801404:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801407:	e9 c0 02 00 00       	jmp    8016cc <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80140c:	8b 45 14             	mov    0x14(%ebp),%eax
  80140f:	8d 78 04             	lea    0x4(%eax),%edi
  801412:	8b 00                	mov    (%eax),%eax
  801414:	85 c0                	test   %eax,%eax
  801416:	78 2a                	js     801442 <vprintfmt+0x138>
  801418:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80141a:	83 f8 0f             	cmp    $0xf,%eax
  80141d:	7f 27                	jg     801446 <vprintfmt+0x13c>
  80141f:	8b 04 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%eax
  801426:	85 c0                	test   %eax,%eax
  801428:	74 1c                	je     801446 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80142a:	50                   	push   %eax
  80142b:	68 dd 1f 80 00       	push   $0x801fdd
  801430:	53                   	push   %ebx
  801431:	56                   	push   %esi
  801432:	e8 b6 fe ff ff       	call   8012ed <printfmt>
  801437:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80143a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80143d:	e9 8a 02 00 00       	jmp    8016cc <vprintfmt+0x3c2>
  801442:	f7 d8                	neg    %eax
  801444:	eb d2                	jmp    801418 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801446:	52                   	push   %edx
  801447:	68 5f 20 80 00       	push   $0x80205f
  80144c:	53                   	push   %ebx
  80144d:	56                   	push   %esi
  80144e:	e8 9a fe ff ff       	call   8012ed <printfmt>
  801453:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801456:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801459:	e9 6e 02 00 00       	jmp    8016cc <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	83 c0 04             	add    $0x4,%eax
  801464:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	8b 38                	mov    (%eax),%edi
  80146c:	85 ff                	test   %edi,%edi
  80146e:	74 39                	je     8014a9 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  801470:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801474:	0f 8e a9 00 00 00    	jle    801523 <vprintfmt+0x219>
  80147a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80147e:	0f 84 a7 00 00 00    	je     80152b <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	ff 75 d0             	pushl  -0x30(%ebp)
  80148a:	57                   	push   %edi
  80148b:	e8 6b 03 00 00       	call   8017fb <strnlen>
  801490:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801493:	29 c1                	sub    %eax,%ecx
  801495:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801498:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80149b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80149f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014a2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014a5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014a7:	eb 14                	jmp    8014bd <vprintfmt+0x1b3>
				p = "(null)";
  8014a9:	bf 58 20 80 00       	mov    $0x802058,%edi
  8014ae:	eb c0                	jmp    801470 <vprintfmt+0x166>
					putch(padc, putdat);
  8014b0:	83 ec 08             	sub    $0x8,%esp
  8014b3:	53                   	push   %ebx
  8014b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8014b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014b9:	4f                   	dec    %edi
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 ff                	test   %edi,%edi
  8014bf:	7f ef                	jg     8014b0 <vprintfmt+0x1a6>
  8014c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8014c4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014c7:	89 c8                	mov    %ecx,%eax
  8014c9:	85 c9                	test   %ecx,%ecx
  8014cb:	78 10                	js     8014dd <vprintfmt+0x1d3>
  8014cd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014d0:	29 c1                	sub    %eax,%ecx
  8014d2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8014d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8014d8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8014db:	eb 15                	jmp    8014f2 <vprintfmt+0x1e8>
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	eb e9                	jmp    8014cd <vprintfmt+0x1c3>
					putch(ch, putdat);
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	53                   	push   %ebx
  8014e8:	52                   	push   %edx
  8014e9:	ff 55 08             	call   *0x8(%ebp)
  8014ec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014ef:	ff 4d e0             	decl   -0x20(%ebp)
  8014f2:	47                   	inc    %edi
  8014f3:	8a 47 ff             	mov    -0x1(%edi),%al
  8014f6:	0f be d0             	movsbl %al,%edx
  8014f9:	85 d2                	test   %edx,%edx
  8014fb:	74 59                	je     801556 <vprintfmt+0x24c>
  8014fd:	85 f6                	test   %esi,%esi
  8014ff:	78 03                	js     801504 <vprintfmt+0x1fa>
  801501:	4e                   	dec    %esi
  801502:	78 2f                	js     801533 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801504:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801508:	74 da                	je     8014e4 <vprintfmt+0x1da>
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 20             	sub    $0x20,%eax
  801510:	83 f8 5e             	cmp    $0x5e,%eax
  801513:	76 cf                	jbe    8014e4 <vprintfmt+0x1da>
					putch('?', putdat);
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	53                   	push   %ebx
  801519:	6a 3f                	push   $0x3f
  80151b:	ff 55 08             	call   *0x8(%ebp)
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	eb cc                	jmp    8014ef <vprintfmt+0x1e5>
  801523:	89 75 08             	mov    %esi,0x8(%ebp)
  801526:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801529:	eb c7                	jmp    8014f2 <vprintfmt+0x1e8>
  80152b:	89 75 08             	mov    %esi,0x8(%ebp)
  80152e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801531:	eb bf                	jmp    8014f2 <vprintfmt+0x1e8>
  801533:	8b 75 08             	mov    0x8(%ebp),%esi
  801536:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801539:	eb 0c                	jmp    801547 <vprintfmt+0x23d>
				putch(' ', putdat);
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	53                   	push   %ebx
  80153f:	6a 20                	push   $0x20
  801541:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801543:	4f                   	dec    %edi
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	85 ff                	test   %edi,%edi
  801549:	7f f0                	jg     80153b <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80154b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80154e:	89 45 14             	mov    %eax,0x14(%ebp)
  801551:	e9 76 01 00 00       	jmp    8016cc <vprintfmt+0x3c2>
  801556:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801559:	8b 75 08             	mov    0x8(%ebp),%esi
  80155c:	eb e9                	jmp    801547 <vprintfmt+0x23d>
	if (lflag >= 2)
  80155e:	83 f9 01             	cmp    $0x1,%ecx
  801561:	7f 1f                	jg     801582 <vprintfmt+0x278>
	else if (lflag)
  801563:	85 c9                	test   %ecx,%ecx
  801565:	75 48                	jne    8015af <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  801567:	8b 45 14             	mov    0x14(%ebp),%eax
  80156a:	8b 00                	mov    (%eax),%eax
  80156c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80156f:	89 c1                	mov    %eax,%ecx
  801571:	c1 f9 1f             	sar    $0x1f,%ecx
  801574:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801577:	8b 45 14             	mov    0x14(%ebp),%eax
  80157a:	8d 40 04             	lea    0x4(%eax),%eax
  80157d:	89 45 14             	mov    %eax,0x14(%ebp)
  801580:	eb 17                	jmp    801599 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	8b 50 04             	mov    0x4(%eax),%edx
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80158d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801590:	8b 45 14             	mov    0x14(%ebp),%eax
  801593:	8d 40 08             	lea    0x8(%eax),%eax
  801596:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  801599:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80159c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80159f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015a3:	78 25                	js     8015ca <vprintfmt+0x2c0>
			base = 10;
  8015a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015aa:	e9 03 01 00 00       	jmp    8016b2 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015af:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b2:	8b 00                	mov    (%eax),%eax
  8015b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015b7:	89 c1                	mov    %eax,%ecx
  8015b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8015bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c2:	8d 40 04             	lea    0x4(%eax),%eax
  8015c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8015c8:	eb cf                	jmp    801599 <vprintfmt+0x28f>
				putch('-', putdat);
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	53                   	push   %ebx
  8015ce:	6a 2d                	push   $0x2d
  8015d0:	ff d6                	call   *%esi
				num = -(long long) num;
  8015d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015d5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8015d8:	f7 da                	neg    %edx
  8015da:	83 d1 00             	adc    $0x0,%ecx
  8015dd:	f7 d9                	neg    %ecx
  8015df:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8015e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015e7:	e9 c6 00 00 00       	jmp    8016b2 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8015ec:	83 f9 01             	cmp    $0x1,%ecx
  8015ef:	7f 1e                	jg     80160f <vprintfmt+0x305>
	else if (lflag)
  8015f1:	85 c9                	test   %ecx,%ecx
  8015f3:	75 32                	jne    801627 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8015f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f8:	8b 10                	mov    (%eax),%edx
  8015fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015ff:	8d 40 04             	lea    0x4(%eax),%eax
  801602:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801605:	b8 0a 00 00 00       	mov    $0xa,%eax
  80160a:	e9 a3 00 00 00       	jmp    8016b2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80160f:	8b 45 14             	mov    0x14(%ebp),%eax
  801612:	8b 10                	mov    (%eax),%edx
  801614:	8b 48 04             	mov    0x4(%eax),%ecx
  801617:	8d 40 08             	lea    0x8(%eax),%eax
  80161a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80161d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801622:	e9 8b 00 00 00       	jmp    8016b2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801627:	8b 45 14             	mov    0x14(%ebp),%eax
  80162a:	8b 10                	mov    (%eax),%edx
  80162c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801631:	8d 40 04             	lea    0x4(%eax),%eax
  801634:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801637:	b8 0a 00 00 00       	mov    $0xa,%eax
  80163c:	eb 74                	jmp    8016b2 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80163e:	83 f9 01             	cmp    $0x1,%ecx
  801641:	7f 1b                	jg     80165e <vprintfmt+0x354>
	else if (lflag)
  801643:	85 c9                	test   %ecx,%ecx
  801645:	75 2c                	jne    801673 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801647:	8b 45 14             	mov    0x14(%ebp),%eax
  80164a:	8b 10                	mov    (%eax),%edx
  80164c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801651:	8d 40 04             	lea    0x4(%eax),%eax
  801654:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801657:	b8 08 00 00 00       	mov    $0x8,%eax
  80165c:	eb 54                	jmp    8016b2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80165e:	8b 45 14             	mov    0x14(%ebp),%eax
  801661:	8b 10                	mov    (%eax),%edx
  801663:	8b 48 04             	mov    0x4(%eax),%ecx
  801666:	8d 40 08             	lea    0x8(%eax),%eax
  801669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80166c:	b8 08 00 00 00       	mov    $0x8,%eax
  801671:	eb 3f                	jmp    8016b2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801673:	8b 45 14             	mov    0x14(%ebp),%eax
  801676:	8b 10                	mov    (%eax),%edx
  801678:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167d:	8d 40 04             	lea    0x4(%eax),%eax
  801680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801683:	b8 08 00 00 00       	mov    $0x8,%eax
  801688:	eb 28                	jmp    8016b2 <vprintfmt+0x3a8>
			putch('0', putdat);
  80168a:	83 ec 08             	sub    $0x8,%esp
  80168d:	53                   	push   %ebx
  80168e:	6a 30                	push   $0x30
  801690:	ff d6                	call   *%esi
			putch('x', putdat);
  801692:	83 c4 08             	add    $0x8,%esp
  801695:	53                   	push   %ebx
  801696:	6a 78                	push   $0x78
  801698:	ff d6                	call   *%esi
			num = (unsigned long long)
  80169a:	8b 45 14             	mov    0x14(%ebp),%eax
  80169d:	8b 10                	mov    (%eax),%edx
  80169f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016a4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016a7:	8d 40 04             	lea    0x4(%eax),%eax
  8016aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016ad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016b2:	83 ec 0c             	sub    $0xc,%esp
  8016b5:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016b9:	57                   	push   %edi
  8016ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8016bd:	50                   	push   %eax
  8016be:	51                   	push   %ecx
  8016bf:	52                   	push   %edx
  8016c0:	89 da                	mov    %ebx,%edx
  8016c2:	89 f0                	mov    %esi,%eax
  8016c4:	e8 5b fb ff ff       	call   801224 <printnum>
			break;
  8016c9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8016cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016cf:	47                   	inc    %edi
  8016d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016d4:	83 f8 25             	cmp    $0x25,%eax
  8016d7:	0f 84 44 fc ff ff    	je     801321 <vprintfmt+0x17>
			if (ch == '\0')
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	0f 84 89 00 00 00    	je     80176e <vprintfmt+0x464>
			putch(ch, putdat);
  8016e5:	83 ec 08             	sub    $0x8,%esp
  8016e8:	53                   	push   %ebx
  8016e9:	50                   	push   %eax
  8016ea:	ff d6                	call   *%esi
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	eb de                	jmp    8016cf <vprintfmt+0x3c5>
	if (lflag >= 2)
  8016f1:	83 f9 01             	cmp    $0x1,%ecx
  8016f4:	7f 1b                	jg     801711 <vprintfmt+0x407>
	else if (lflag)
  8016f6:	85 c9                	test   %ecx,%ecx
  8016f8:	75 2c                	jne    801726 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8016fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fd:	8b 10                	mov    (%eax),%edx
  8016ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801704:	8d 40 04             	lea    0x4(%eax),%eax
  801707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80170a:	b8 10 00 00 00       	mov    $0x10,%eax
  80170f:	eb a1                	jmp    8016b2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 10                	mov    (%eax),%edx
  801716:	8b 48 04             	mov    0x4(%eax),%ecx
  801719:	8d 40 08             	lea    0x8(%eax),%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80171f:	b8 10 00 00 00       	mov    $0x10,%eax
  801724:	eb 8c                	jmp    8016b2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801726:	8b 45 14             	mov    0x14(%ebp),%eax
  801729:	8b 10                	mov    (%eax),%edx
  80172b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801730:	8d 40 04             	lea    0x4(%eax),%eax
  801733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801736:	b8 10 00 00 00       	mov    $0x10,%eax
  80173b:	e9 72 ff ff ff       	jmp    8016b2 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	53                   	push   %ebx
  801744:	6a 25                	push   $0x25
  801746:	ff d6                	call   *%esi
			break;
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	e9 7c ff ff ff       	jmp    8016cc <vprintfmt+0x3c2>
			putch('%', putdat);
  801750:	83 ec 08             	sub    $0x8,%esp
  801753:	53                   	push   %ebx
  801754:	6a 25                	push   $0x25
  801756:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	89 f8                	mov    %edi,%eax
  80175d:	eb 01                	jmp    801760 <vprintfmt+0x456>
  80175f:	48                   	dec    %eax
  801760:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801764:	75 f9                	jne    80175f <vprintfmt+0x455>
  801766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801769:	e9 5e ff ff ff       	jmp    8016cc <vprintfmt+0x3c2>
}
  80176e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5f                   	pop    %edi
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801782:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801785:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801789:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80178c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801793:	85 c0                	test   %eax,%eax
  801795:	74 26                	je     8017bd <vsnprintf+0x47>
  801797:	85 d2                	test   %edx,%edx
  801799:	7e 29                	jle    8017c4 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80179b:	ff 75 14             	pushl  0x14(%ebp)
  80179e:	ff 75 10             	pushl  0x10(%ebp)
  8017a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017a4:	50                   	push   %eax
  8017a5:	68 d1 12 80 00       	push   $0x8012d1
  8017aa:	e8 5b fb ff ff       	call   80130a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b8:	83 c4 10             	add    $0x10,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    
		return -E_INVAL;
  8017bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c2:	eb f7                	jmp    8017bb <vsnprintf+0x45>
  8017c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c9:	eb f0                	jmp    8017bb <vsnprintf+0x45>

008017cb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 10             	pushl  0x10(%ebp)
  8017d8:	ff 75 0c             	pushl  0xc(%ebp)
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	e8 93 ff ff ff       	call   801776 <vsnprintf>
	va_end(ap);

	return rc;
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f0:	eb 01                	jmp    8017f3 <strlen+0xe>
		n++;
  8017f2:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8017f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8017f7:	75 f9                	jne    8017f2 <strlen+0xd>
	return n;
}
  8017f9:	5d                   	pop    %ebp
  8017fa:	c3                   	ret    

008017fb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801801:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801804:	b8 00 00 00 00       	mov    $0x0,%eax
  801809:	eb 01                	jmp    80180c <strnlen+0x11>
		n++;
  80180b:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80180c:	39 d0                	cmp    %edx,%eax
  80180e:	74 06                	je     801816 <strnlen+0x1b>
  801810:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801814:	75 f5                	jne    80180b <strnlen+0x10>
	return n;
}
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	53                   	push   %ebx
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801822:	89 c2                	mov    %eax,%edx
  801824:	42                   	inc    %edx
  801825:	41                   	inc    %ecx
  801826:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801829:	88 5a ff             	mov    %bl,-0x1(%edx)
  80182c:	84 db                	test   %bl,%bl
  80182e:	75 f4                	jne    801824 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801830:	5b                   	pop    %ebx
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	53                   	push   %ebx
  801837:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80183a:	53                   	push   %ebx
  80183b:	e8 a5 ff ff ff       	call   8017e5 <strlen>
  801840:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	01 d8                	add    %ebx,%eax
  801848:	50                   	push   %eax
  801849:	e8 ca ff ff ff       	call   801818 <strcpy>
	return dst;
}
  80184e:	89 d8                	mov    %ebx,%eax
  801850:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	8b 75 08             	mov    0x8(%ebp),%esi
  80185d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801860:	89 f3                	mov    %esi,%ebx
  801862:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801865:	89 f2                	mov    %esi,%edx
  801867:	eb 0c                	jmp    801875 <strncpy+0x20>
		*dst++ = *src;
  801869:	42                   	inc    %edx
  80186a:	8a 01                	mov    (%ecx),%al
  80186c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80186f:	80 39 01             	cmpb   $0x1,(%ecx)
  801872:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801875:	39 da                	cmp    %ebx,%edx
  801877:	75 f0                	jne    801869 <strncpy+0x14>
	}
	return ret;
}
  801879:	89 f0                	mov    %esi,%eax
  80187b:	5b                   	pop    %ebx
  80187c:	5e                   	pop    %esi
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    

0080187f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	56                   	push   %esi
  801883:	53                   	push   %ebx
  801884:	8b 75 08             	mov    0x8(%ebp),%esi
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80188d:	85 c0                	test   %eax,%eax
  80188f:	74 20                	je     8018b1 <strlcpy+0x32>
  801891:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  801895:	89 f0                	mov    %esi,%eax
  801897:	eb 05                	jmp    80189e <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801899:	40                   	inc    %eax
  80189a:	42                   	inc    %edx
  80189b:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80189e:	39 d8                	cmp    %ebx,%eax
  8018a0:	74 06                	je     8018a8 <strlcpy+0x29>
  8018a2:	8a 0a                	mov    (%edx),%cl
  8018a4:	84 c9                	test   %cl,%cl
  8018a6:	75 f1                	jne    801899 <strlcpy+0x1a>
		*dst = '\0';
  8018a8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018ab:	29 f0                	sub    %esi,%eax
}
  8018ad:	5b                   	pop    %ebx
  8018ae:	5e                   	pop    %esi
  8018af:	5d                   	pop    %ebp
  8018b0:	c3                   	ret    
  8018b1:	89 f0                	mov    %esi,%eax
  8018b3:	eb f6                	jmp    8018ab <strlcpy+0x2c>

008018b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018be:	eb 02                	jmp    8018c2 <strcmp+0xd>
		p++, q++;
  8018c0:	41                   	inc    %ecx
  8018c1:	42                   	inc    %edx
	while (*p && *p == *q)
  8018c2:	8a 01                	mov    (%ecx),%al
  8018c4:	84 c0                	test   %al,%al
  8018c6:	74 04                	je     8018cc <strcmp+0x17>
  8018c8:	3a 02                	cmp    (%edx),%al
  8018ca:	74 f4                	je     8018c0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018cc:	0f b6 c0             	movzbl %al,%eax
  8018cf:	0f b6 12             	movzbl (%edx),%edx
  8018d2:	29 d0                	sub    %edx,%eax
}
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    

008018d6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	53                   	push   %ebx
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e0:	89 c3                	mov    %eax,%ebx
  8018e2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018e5:	eb 02                	jmp    8018e9 <strncmp+0x13>
		n--, p++, q++;
  8018e7:	40                   	inc    %eax
  8018e8:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8018e9:	39 d8                	cmp    %ebx,%eax
  8018eb:	74 15                	je     801902 <strncmp+0x2c>
  8018ed:	8a 08                	mov    (%eax),%cl
  8018ef:	84 c9                	test   %cl,%cl
  8018f1:	74 04                	je     8018f7 <strncmp+0x21>
  8018f3:	3a 0a                	cmp    (%edx),%cl
  8018f5:	74 f0                	je     8018e7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018f7:	0f b6 00             	movzbl (%eax),%eax
  8018fa:	0f b6 12             	movzbl (%edx),%edx
  8018fd:	29 d0                	sub    %edx,%eax
}
  8018ff:	5b                   	pop    %ebx
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    
		return 0;
  801902:	b8 00 00 00 00       	mov    $0x0,%eax
  801907:	eb f6                	jmp    8018ff <strncmp+0x29>

00801909 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801912:	8a 10                	mov    (%eax),%dl
  801914:	84 d2                	test   %dl,%dl
  801916:	74 07                	je     80191f <strchr+0x16>
		if (*s == c)
  801918:	38 ca                	cmp    %cl,%dl
  80191a:	74 08                	je     801924 <strchr+0x1b>
	for (; *s; s++)
  80191c:	40                   	inc    %eax
  80191d:	eb f3                	jmp    801912 <strchr+0x9>
			return (char *) s;
	return 0;
  80191f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801924:	5d                   	pop    %ebp
  801925:	c3                   	ret    

00801926 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80192f:	8a 10                	mov    (%eax),%dl
  801931:	84 d2                	test   %dl,%dl
  801933:	74 07                	je     80193c <strfind+0x16>
		if (*s == c)
  801935:	38 ca                	cmp    %cl,%dl
  801937:	74 03                	je     80193c <strfind+0x16>
	for (; *s; s++)
  801939:	40                   	inc    %eax
  80193a:	eb f3                	jmp    80192f <strfind+0x9>
			break;
	return (char *) s;
}
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    

0080193e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	57                   	push   %edi
  801942:	56                   	push   %esi
  801943:	53                   	push   %ebx
  801944:	8b 7d 08             	mov    0x8(%ebp),%edi
  801947:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80194a:	85 c9                	test   %ecx,%ecx
  80194c:	74 13                	je     801961 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80194e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801954:	75 05                	jne    80195b <memset+0x1d>
  801956:	f6 c1 03             	test   $0x3,%cl
  801959:	74 0d                	je     801968 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80195b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195e:	fc                   	cld    
  80195f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801961:	89 f8                	mov    %edi,%eax
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5f                   	pop    %edi
  801966:	5d                   	pop    %ebp
  801967:	c3                   	ret    
		c &= 0xFF;
  801968:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80196c:	89 d3                	mov    %edx,%ebx
  80196e:	c1 e3 08             	shl    $0x8,%ebx
  801971:	89 d0                	mov    %edx,%eax
  801973:	c1 e0 18             	shl    $0x18,%eax
  801976:	89 d6                	mov    %edx,%esi
  801978:	c1 e6 10             	shl    $0x10,%esi
  80197b:	09 f0                	or     %esi,%eax
  80197d:	09 c2                	or     %eax,%edx
  80197f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801981:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801984:	89 d0                	mov    %edx,%eax
  801986:	fc                   	cld    
  801987:	f3 ab                	rep stos %eax,%es:(%edi)
  801989:	eb d6                	jmp    801961 <memset+0x23>

0080198b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	57                   	push   %edi
  80198f:	56                   	push   %esi
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8b 75 0c             	mov    0xc(%ebp),%esi
  801996:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801999:	39 c6                	cmp    %eax,%esi
  80199b:	73 33                	jae    8019d0 <memmove+0x45>
  80199d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019a0:	39 d0                	cmp    %edx,%eax
  8019a2:	73 2c                	jae    8019d0 <memmove+0x45>
		s += n;
		d += n;
  8019a4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019a7:	89 d6                	mov    %edx,%esi
  8019a9:	09 fe                	or     %edi,%esi
  8019ab:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019b1:	75 13                	jne    8019c6 <memmove+0x3b>
  8019b3:	f6 c1 03             	test   $0x3,%cl
  8019b6:	75 0e                	jne    8019c6 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019b8:	83 ef 04             	sub    $0x4,%edi
  8019bb:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019be:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019c1:	fd                   	std    
  8019c2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019c4:	eb 07                	jmp    8019cd <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019c6:	4f                   	dec    %edi
  8019c7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019ca:	fd                   	std    
  8019cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019cd:	fc                   	cld    
  8019ce:	eb 13                	jmp    8019e3 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019d0:	89 f2                	mov    %esi,%edx
  8019d2:	09 c2                	or     %eax,%edx
  8019d4:	f6 c2 03             	test   $0x3,%dl
  8019d7:	75 05                	jne    8019de <memmove+0x53>
  8019d9:	f6 c1 03             	test   $0x3,%cl
  8019dc:	74 09                	je     8019e7 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019de:	89 c7                	mov    %eax,%edi
  8019e0:	fc                   	cld    
  8019e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019e3:	5e                   	pop    %esi
  8019e4:	5f                   	pop    %edi
  8019e5:	5d                   	pop    %ebp
  8019e6:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019e7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019ea:	89 c7                	mov    %eax,%edi
  8019ec:	fc                   	cld    
  8019ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ef:	eb f2                	jmp    8019e3 <memmove+0x58>

008019f1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8019f4:	ff 75 10             	pushl  0x10(%ebp)
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	ff 75 08             	pushl  0x8(%ebp)
  8019fd:	e8 89 ff ff ff       	call   80198b <memmove>
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	56                   	push   %esi
  801a08:	53                   	push   %ebx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	89 c6                	mov    %eax,%esi
  801a0e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a11:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a14:	39 f0                	cmp    %esi,%eax
  801a16:	74 16                	je     801a2e <memcmp+0x2a>
		if (*s1 != *s2)
  801a18:	8a 08                	mov    (%eax),%cl
  801a1a:	8a 1a                	mov    (%edx),%bl
  801a1c:	38 d9                	cmp    %bl,%cl
  801a1e:	75 04                	jne    801a24 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a20:	40                   	inc    %eax
  801a21:	42                   	inc    %edx
  801a22:	eb f0                	jmp    801a14 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a24:	0f b6 c1             	movzbl %cl,%eax
  801a27:	0f b6 db             	movzbl %bl,%ebx
  801a2a:	29 d8                	sub    %ebx,%eax
  801a2c:	eb 05                	jmp    801a33 <memcmp+0x2f>
	}

	return 0;
  801a2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    

00801a37 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a40:	89 c2                	mov    %eax,%edx
  801a42:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a45:	39 d0                	cmp    %edx,%eax
  801a47:	73 07                	jae    801a50 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a49:	38 08                	cmp    %cl,(%eax)
  801a4b:	74 03                	je     801a50 <memfind+0x19>
	for (; s < ends; s++)
  801a4d:	40                   	inc    %eax
  801a4e:	eb f5                	jmp    801a45 <memfind+0xe>
			break;
	return (void *) s;
}
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    

00801a52 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	57                   	push   %edi
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a5b:	eb 01                	jmp    801a5e <strtol+0xc>
		s++;
  801a5d:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a5e:	8a 01                	mov    (%ecx),%al
  801a60:	3c 20                	cmp    $0x20,%al
  801a62:	74 f9                	je     801a5d <strtol+0xb>
  801a64:	3c 09                	cmp    $0x9,%al
  801a66:	74 f5                	je     801a5d <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801a68:	3c 2b                	cmp    $0x2b,%al
  801a6a:	74 2b                	je     801a97 <strtol+0x45>
		s++;
	else if (*s == '-')
  801a6c:	3c 2d                	cmp    $0x2d,%al
  801a6e:	74 2f                	je     801a9f <strtol+0x4d>
	int neg = 0;
  801a70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a75:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801a7c:	75 12                	jne    801a90 <strtol+0x3e>
  801a7e:	80 39 30             	cmpb   $0x30,(%ecx)
  801a81:	74 24                	je     801aa7 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801a83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a87:	75 07                	jne    801a90 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a89:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801a90:	b8 00 00 00 00       	mov    $0x0,%eax
  801a95:	eb 4e                	jmp    801ae5 <strtol+0x93>
		s++;
  801a97:	41                   	inc    %ecx
	int neg = 0;
  801a98:	bf 00 00 00 00       	mov    $0x0,%edi
  801a9d:	eb d6                	jmp    801a75 <strtol+0x23>
		s++, neg = 1;
  801a9f:	41                   	inc    %ecx
  801aa0:	bf 01 00 00 00       	mov    $0x1,%edi
  801aa5:	eb ce                	jmp    801a75 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aa7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801aab:	74 10                	je     801abd <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801aad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ab1:	75 dd                	jne    801a90 <strtol+0x3e>
		s++, base = 8;
  801ab3:	41                   	inc    %ecx
  801ab4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801abb:	eb d3                	jmp    801a90 <strtol+0x3e>
		s += 2, base = 16;
  801abd:	83 c1 02             	add    $0x2,%ecx
  801ac0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ac7:	eb c7                	jmp    801a90 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801ac9:	8d 72 9f             	lea    -0x61(%edx),%esi
  801acc:	89 f3                	mov    %esi,%ebx
  801ace:	80 fb 19             	cmp    $0x19,%bl
  801ad1:	77 24                	ja     801af7 <strtol+0xa5>
			dig = *s - 'a' + 10;
  801ad3:	0f be d2             	movsbl %dl,%edx
  801ad6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ad9:	3b 55 10             	cmp    0x10(%ebp),%edx
  801adc:	7d 2b                	jge    801b09 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801ade:	41                   	inc    %ecx
  801adf:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ae3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ae5:	8a 11                	mov    (%ecx),%dl
  801ae7:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801aea:	80 fb 09             	cmp    $0x9,%bl
  801aed:	77 da                	ja     801ac9 <strtol+0x77>
			dig = *s - '0';
  801aef:	0f be d2             	movsbl %dl,%edx
  801af2:	83 ea 30             	sub    $0x30,%edx
  801af5:	eb e2                	jmp    801ad9 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801af7:	8d 72 bf             	lea    -0x41(%edx),%esi
  801afa:	89 f3                	mov    %esi,%ebx
  801afc:	80 fb 19             	cmp    $0x19,%bl
  801aff:	77 08                	ja     801b09 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b01:	0f be d2             	movsbl %dl,%edx
  801b04:	83 ea 37             	sub    $0x37,%edx
  801b07:	eb d0                	jmp    801ad9 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b0d:	74 05                	je     801b14 <strtol+0xc2>
		*endptr = (char *) s;
  801b0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b12:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b14:	85 ff                	test   %edi,%edi
  801b16:	74 02                	je     801b1a <strtol+0xc8>
  801b18:	f7 d8                	neg    %eax
}
  801b1a:	5b                   	pop    %ebx
  801b1b:	5e                   	pop    %esi
  801b1c:	5f                   	pop    %edi
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <atoi>:

int
atoi(const char *s)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b22:	6a 0a                	push   $0xa
  801b24:	6a 00                	push   $0x0
  801b26:	ff 75 08             	pushl  0x8(%ebp)
  801b29:	e8 24 ff ff ff       	call   801a52 <strtol>
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	57                   	push   %edi
  801b34:	56                   	push   %esi
  801b35:	53                   	push   %ebx
  801b36:	83 ec 0c             	sub    $0xc,%esp
  801b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b3f:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b42:	85 ff                	test   %edi,%edi
  801b44:	74 53                	je     801b99 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b46:	83 ec 0c             	sub    $0xc,%esp
  801b49:	57                   	push   %edi
  801b4a:	e8 fe e7 ff ff       	call   80034d <sys_ipc_recv>
  801b4f:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b52:	85 db                	test   %ebx,%ebx
  801b54:	74 0b                	je     801b61 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b56:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b5c:	8b 52 74             	mov    0x74(%edx),%edx
  801b5f:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b61:	85 f6                	test   %esi,%esi
  801b63:	74 0f                	je     801b74 <ipc_recv+0x44>
  801b65:	85 ff                	test   %edi,%edi
  801b67:	74 0b                	je     801b74 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b69:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6f:	8b 52 78             	mov    0x78(%edx),%edx
  801b72:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b74:	85 c0                	test   %eax,%eax
  801b76:	74 30                	je     801ba8 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b78:	85 db                	test   %ebx,%ebx
  801b7a:	74 06                	je     801b82 <ipc_recv+0x52>
      		*from_env_store = 0;
  801b7c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801b82:	85 f6                	test   %esi,%esi
  801b84:	74 2c                	je     801bb2 <ipc_recv+0x82>
      		*perm_store = 0;
  801b86:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801b8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801b91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b94:	5b                   	pop    %ebx
  801b95:	5e                   	pop    %esi
  801b96:	5f                   	pop    %edi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801b99:	83 ec 0c             	sub    $0xc,%esp
  801b9c:	6a ff                	push   $0xffffffff
  801b9e:	e8 aa e7 ff ff       	call   80034d <sys_ipc_recv>
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	eb aa                	jmp    801b52 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801ba8:	a1 04 40 80 00       	mov    0x804004,%eax
  801bad:	8b 40 70             	mov    0x70(%eax),%eax
  801bb0:	eb df                	jmp    801b91 <ipc_recv+0x61>
		return -1;
  801bb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bb7:	eb d8                	jmp    801b91 <ipc_recv+0x61>

00801bb9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	57                   	push   %edi
  801bbd:	56                   	push   %esi
  801bbe:	53                   	push   %ebx
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bc8:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bcb:	85 db                	test   %ebx,%ebx
  801bcd:	75 22                	jne    801bf1 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bcf:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801bd4:	eb 1b                	jmp    801bf1 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bd6:	68 40 23 80 00       	push   $0x802340
  801bdb:	68 cb 1f 80 00       	push   $0x801fcb
  801be0:	6a 48                	push   $0x48
  801be2:	68 64 23 80 00       	push   $0x802364
  801be7:	e8 11 f5 ff ff       	call   8010fd <_panic>
		sys_yield();
  801bec:	e8 13 e6 ff ff       	call   800204 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801bf1:	57                   	push   %edi
  801bf2:	53                   	push   %ebx
  801bf3:	56                   	push   %esi
  801bf4:	ff 75 08             	pushl  0x8(%ebp)
  801bf7:	e8 2e e7 ff ff       	call   80032a <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c02:	74 e8                	je     801bec <ipc_send+0x33>
  801c04:	85 c0                	test   %eax,%eax
  801c06:	75 ce                	jne    801bd6 <ipc_send+0x1d>
		sys_yield();
  801c08:	e8 f7 e5 ff ff       	call   800204 <sys_yield>
		
	}
	
}
  801c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5f                   	pop    %edi
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    

00801c15 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c20:	89 c2                	mov    %eax,%edx
  801c22:	c1 e2 05             	shl    $0x5,%edx
  801c25:	29 c2                	sub    %eax,%edx
  801c27:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c2e:	8b 52 50             	mov    0x50(%edx),%edx
  801c31:	39 ca                	cmp    %ecx,%edx
  801c33:	74 0f                	je     801c44 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c35:	40                   	inc    %eax
  801c36:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c3b:	75 e3                	jne    801c20 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c42:	eb 11                	jmp    801c55 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c44:	89 c2                	mov    %eax,%edx
  801c46:	c1 e2 05             	shl    $0x5,%edx
  801c49:	29 c2                	sub    %eax,%edx
  801c4b:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c52:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    

00801c57 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	c1 e8 16             	shr    $0x16,%eax
  801c60:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c67:	a8 01                	test   $0x1,%al
  801c69:	74 21                	je     801c8c <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	c1 e8 0c             	shr    $0xc,%eax
  801c71:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c78:	a8 01                	test   $0x1,%al
  801c7a:	74 17                	je     801c93 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c7c:	c1 e8 0c             	shr    $0xc,%eax
  801c7f:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c86:	ef 
  801c87:	0f b7 c0             	movzwl %ax,%eax
  801c8a:	eb 05                	jmp    801c91 <pageref+0x3a>
		return 0;
  801c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c91:	5d                   	pop    %ebp
  801c92:	c3                   	ret    
		return 0;
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	eb f7                	jmp    801c91 <pageref+0x3a>
  801c9a:	66 90                	xchg   %ax,%ax

00801c9c <__udivdi3>:
  801c9c:	55                   	push   %ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 1c             	sub    $0x1c,%esp
  801ca3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ca7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801caf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cb3:	89 ca                	mov    %ecx,%edx
  801cb5:	89 f8                	mov    %edi,%eax
  801cb7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cbb:	85 f6                	test   %esi,%esi
  801cbd:	75 2d                	jne    801cec <__udivdi3+0x50>
  801cbf:	39 cf                	cmp    %ecx,%edi
  801cc1:	77 65                	ja     801d28 <__udivdi3+0x8c>
  801cc3:	89 fd                	mov    %edi,%ebp
  801cc5:	85 ff                	test   %edi,%edi
  801cc7:	75 0b                	jne    801cd4 <__udivdi3+0x38>
  801cc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cce:	31 d2                	xor    %edx,%edx
  801cd0:	f7 f7                	div    %edi
  801cd2:	89 c5                	mov    %eax,%ebp
  801cd4:	31 d2                	xor    %edx,%edx
  801cd6:	89 c8                	mov    %ecx,%eax
  801cd8:	f7 f5                	div    %ebp
  801cda:	89 c1                	mov    %eax,%ecx
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	f7 f5                	div    %ebp
  801ce0:	89 cf                	mov    %ecx,%edi
  801ce2:	89 fa                	mov    %edi,%edx
  801ce4:	83 c4 1c             	add    $0x1c,%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
  801cec:	39 ce                	cmp    %ecx,%esi
  801cee:	77 28                	ja     801d18 <__udivdi3+0x7c>
  801cf0:	0f bd fe             	bsr    %esi,%edi
  801cf3:	83 f7 1f             	xor    $0x1f,%edi
  801cf6:	75 40                	jne    801d38 <__udivdi3+0x9c>
  801cf8:	39 ce                	cmp    %ecx,%esi
  801cfa:	72 0a                	jb     801d06 <__udivdi3+0x6a>
  801cfc:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d00:	0f 87 9e 00 00 00    	ja     801da4 <__udivdi3+0x108>
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	89 fa                	mov    %edi,%edx
  801d0d:	83 c4 1c             	add    $0x1c,%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5f                   	pop    %edi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    
  801d15:	8d 76 00             	lea    0x0(%esi),%esi
  801d18:	31 ff                	xor    %edi,%edi
  801d1a:	31 c0                	xor    %eax,%eax
  801d1c:	89 fa                	mov    %edi,%edx
  801d1e:	83 c4 1c             	add    $0x1c,%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    
  801d26:	66 90                	xchg   %ax,%ax
  801d28:	89 d8                	mov    %ebx,%eax
  801d2a:	f7 f7                	div    %edi
  801d2c:	31 ff                	xor    %edi,%edi
  801d2e:	89 fa                	mov    %edi,%edx
  801d30:	83 c4 1c             	add    $0x1c,%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
  801d38:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d3d:	29 fd                	sub    %edi,%ebp
  801d3f:	89 f9                	mov    %edi,%ecx
  801d41:	d3 e6                	shl    %cl,%esi
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	89 e9                	mov    %ebp,%ecx
  801d47:	d3 eb                	shr    %cl,%ebx
  801d49:	89 d9                	mov    %ebx,%ecx
  801d4b:	09 f1                	or     %esi,%ecx
  801d4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d51:	89 f9                	mov    %edi,%ecx
  801d53:	d3 e0                	shl    %cl,%eax
  801d55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d59:	89 d6                	mov    %edx,%esi
  801d5b:	89 e9                	mov    %ebp,%ecx
  801d5d:	d3 ee                	shr    %cl,%esi
  801d5f:	89 f9                	mov    %edi,%ecx
  801d61:	d3 e2                	shl    %cl,%edx
  801d63:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d67:	89 e9                	mov    %ebp,%ecx
  801d69:	d3 eb                	shr    %cl,%ebx
  801d6b:	09 da                	or     %ebx,%edx
  801d6d:	89 d0                	mov    %edx,%eax
  801d6f:	89 f2                	mov    %esi,%edx
  801d71:	f7 74 24 08          	divl   0x8(%esp)
  801d75:	89 d6                	mov    %edx,%esi
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	f7 64 24 0c          	mull   0xc(%esp)
  801d7d:	39 d6                	cmp    %edx,%esi
  801d7f:	72 17                	jb     801d98 <__udivdi3+0xfc>
  801d81:	74 09                	je     801d8c <__udivdi3+0xf0>
  801d83:	89 d8                	mov    %ebx,%eax
  801d85:	31 ff                	xor    %edi,%edi
  801d87:	e9 56 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801d8c:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d90:	89 f9                	mov    %edi,%ecx
  801d92:	d3 e2                	shl    %cl,%edx
  801d94:	39 c2                	cmp    %eax,%edx
  801d96:	73 eb                	jae    801d83 <__udivdi3+0xe7>
  801d98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d9b:	31 ff                	xor    %edi,%edi
  801d9d:	e9 40 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801da2:	66 90                	xchg   %ax,%ax
  801da4:	31 c0                	xor    %eax,%eax
  801da6:	e9 37 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801dab:	90                   	nop

00801dac <__umoddi3>:
  801dac:	55                   	push   %ebp
  801dad:	57                   	push   %edi
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 1c             	sub    $0x1c,%esp
  801db3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801db7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dbf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dcb:	89 3c 24             	mov    %edi,(%esp)
  801dce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dd2:	89 f2                	mov    %esi,%edx
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	75 18                	jne    801df0 <__umoddi3+0x44>
  801dd8:	39 f7                	cmp    %esi,%edi
  801dda:	0f 86 a0 00 00 00    	jbe    801e80 <__umoddi3+0xd4>
  801de0:	89 c8                	mov    %ecx,%eax
  801de2:	f7 f7                	div    %edi
  801de4:	89 d0                	mov    %edx,%eax
  801de6:	31 d2                	xor    %edx,%edx
  801de8:	83 c4 1c             	add    $0x1c,%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    
  801df0:	89 f3                	mov    %esi,%ebx
  801df2:	39 f0                	cmp    %esi,%eax
  801df4:	0f 87 a6 00 00 00    	ja     801ea0 <__umoddi3+0xf4>
  801dfa:	0f bd e8             	bsr    %eax,%ebp
  801dfd:	83 f5 1f             	xor    $0x1f,%ebp
  801e00:	0f 84 a6 00 00 00    	je     801eac <__umoddi3+0x100>
  801e06:	bf 20 00 00 00       	mov    $0x20,%edi
  801e0b:	29 ef                	sub    %ebp,%edi
  801e0d:	89 e9                	mov    %ebp,%ecx
  801e0f:	d3 e0                	shl    %cl,%eax
  801e11:	8b 34 24             	mov    (%esp),%esi
  801e14:	89 f2                	mov    %esi,%edx
  801e16:	89 f9                	mov    %edi,%ecx
  801e18:	d3 ea                	shr    %cl,%edx
  801e1a:	09 c2                	or     %eax,%edx
  801e1c:	89 14 24             	mov    %edx,(%esp)
  801e1f:	89 f2                	mov    %esi,%edx
  801e21:	89 e9                	mov    %ebp,%ecx
  801e23:	d3 e2                	shl    %cl,%edx
  801e25:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e29:	89 de                	mov    %ebx,%esi
  801e2b:	89 f9                	mov    %edi,%ecx
  801e2d:	d3 ee                	shr    %cl,%esi
  801e2f:	89 e9                	mov    %ebp,%ecx
  801e31:	d3 e3                	shl    %cl,%ebx
  801e33:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e37:	89 d0                	mov    %edx,%eax
  801e39:	89 f9                	mov    %edi,%ecx
  801e3b:	d3 e8                	shr    %cl,%eax
  801e3d:	09 d8                	or     %ebx,%eax
  801e3f:	89 d3                	mov    %edx,%ebx
  801e41:	89 e9                	mov    %ebp,%ecx
  801e43:	d3 e3                	shl    %cl,%ebx
  801e45:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e49:	89 f2                	mov    %esi,%edx
  801e4b:	f7 34 24             	divl   (%esp)
  801e4e:	89 d6                	mov    %edx,%esi
  801e50:	f7 64 24 04          	mull   0x4(%esp)
  801e54:	89 c3                	mov    %eax,%ebx
  801e56:	89 d1                	mov    %edx,%ecx
  801e58:	39 d6                	cmp    %edx,%esi
  801e5a:	72 7c                	jb     801ed8 <__umoddi3+0x12c>
  801e5c:	74 72                	je     801ed0 <__umoddi3+0x124>
  801e5e:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e62:	29 da                	sub    %ebx,%edx
  801e64:	19 ce                	sbb    %ecx,%esi
  801e66:	89 f0                	mov    %esi,%eax
  801e68:	89 f9                	mov    %edi,%ecx
  801e6a:	d3 e0                	shl    %cl,%eax
  801e6c:	89 e9                	mov    %ebp,%ecx
  801e6e:	d3 ea                	shr    %cl,%edx
  801e70:	09 d0                	or     %edx,%eax
  801e72:	89 e9                	mov    %ebp,%ecx
  801e74:	d3 ee                	shr    %cl,%esi
  801e76:	89 f2                	mov    %esi,%edx
  801e78:	83 c4 1c             	add    $0x1c,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5f                   	pop    %edi
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    
  801e80:	89 fd                	mov    %edi,%ebp
  801e82:	85 ff                	test   %edi,%edi
  801e84:	75 0b                	jne    801e91 <__umoddi3+0xe5>
  801e86:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8b:	31 d2                	xor    %edx,%edx
  801e8d:	f7 f7                	div    %edi
  801e8f:	89 c5                	mov    %eax,%ebp
  801e91:	89 f0                	mov    %esi,%eax
  801e93:	31 d2                	xor    %edx,%edx
  801e95:	f7 f5                	div    %ebp
  801e97:	89 c8                	mov    %ecx,%eax
  801e99:	f7 f5                	div    %ebp
  801e9b:	e9 44 ff ff ff       	jmp    801de4 <__umoddi3+0x38>
  801ea0:	89 c8                	mov    %ecx,%eax
  801ea2:	89 f2                	mov    %esi,%edx
  801ea4:	83 c4 1c             	add    $0x1c,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    
  801eac:	39 f0                	cmp    %esi,%eax
  801eae:	72 05                	jb     801eb5 <__umoddi3+0x109>
  801eb0:	39 0c 24             	cmp    %ecx,(%esp)
  801eb3:	77 0c                	ja     801ec1 <__umoddi3+0x115>
  801eb5:	89 f2                	mov    %esi,%edx
  801eb7:	29 f9                	sub    %edi,%ecx
  801eb9:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ebd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec1:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ec5:	83 c4 1c             	add    $0x1c,%esp
  801ec8:	5b                   	pop    %ebx
  801ec9:	5e                   	pop    %esi
  801eca:	5f                   	pop    %edi
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    
  801ecd:	8d 76 00             	lea    0x0(%esi),%esi
  801ed0:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ed4:	73 88                	jae    801e5e <__umoddi3+0xb2>
  801ed6:	66 90                	xchg   %ax,%ax
  801ed8:	2b 44 24 04          	sub    0x4(%esp),%eax
  801edc:	1b 14 24             	sbb    (%esp),%edx
  801edf:	89 d1                	mov    %edx,%ecx
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	e9 76 ff ff ff       	jmp    801e5e <__umoddi3+0xb2>
