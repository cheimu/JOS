
obj/user/gohello.debug:     file format elf32-i386


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
  80002c:	e8 bd 08 00 00       	call   8008ee <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <main.AIe1e$hash>:
  800033:	83 ec 14             	sub    $0x14,%esp
  800036:	6a 08                	push   $0x8
  800038:	ff 74 24 1c          	pushl  0x1c(%esp)
  80003c:	e8 c7 00 00 00       	call   800108 <__go_type_hash_empty_interface>
  800041:	83 c4 1c             	add    $0x1c,%esp
  800044:	c3                   	ret    

00800045 <main.AIe1e$equal>:
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	8b 44 24 14          	mov    0x14(%esp),%eax
  80004c:	ff 70 04             	pushl  0x4(%eax)
  80004f:	ff 30                	pushl  (%eax)
  800051:	8b 44 24 18          	mov    0x18(%esp),%eax
  800055:	ff 70 04             	pushl  0x4(%eax)
  800058:	ff 30                	pushl  (%eax)
  80005a:	e8 1c 03 00 00       	call   80037b <__go_empty_interface_compare>
  80005f:	85 c0                	test   %eax,%eax
  800061:	0f 94 c0             	sete   %al
  800064:	83 c4 1c             	add    $0x1c,%esp
  800067:	c3                   	ret    

00800068 <main.main>:
package main

import "sys"

func main() {
  800068:	57                   	push   %edi
  800069:	56                   	push   %esi
  80006a:	83 ec 1c             	sub    $0x1c,%esp
	sys.Println("hello, go")
  80006d:	6a 08                	push   $0x8
  80006f:	68 80 2b 80 00       	push   $0x802b80
  800074:	e8 e5 01 00 00       	call   80025e <__go_new>
  800079:	89 c6                	mov    %eax,%esi
  80007b:	83 c4 08             	add    $0x8,%esp
  80007e:	6a 08                	push   $0x8
  800080:	68 a0 2a 80 00       	push   $0x802aa0
  800085:	e8 d4 01 00 00       	call   80025e <__go_new>
  80008a:	c7 00 40 2a 80 00    	movl   $0x802a40,(%eax)
  800090:	c7 40 04 09 00 00 00 	movl   $0x9,0x4(%eax)
  800097:	c7 06 a0 2a 80 00    	movl   $0x802aa0,(%esi)
  80009d:	89 46 04             	mov    %eax,0x4(%esi)
  8000a0:	89 74 24 14          	mov    %esi,0x14(%esp)
  8000a4:	c7 44 24 18 01 00 00 	movl   $0x1,0x18(%esp)
  8000ab:	00 
  8000ac:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8000b3:	00 
  8000b4:	8d 74 24 14          	lea    0x14(%esp),%esi
  8000b8:	b9 03 00 00 00       	mov    $0x3,%ecx
  8000bd:	89 e7                	mov    %esp,%edi
  8000bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8000c1:	e8 b3 07 00 00       	call   800879 <go.sys.Println>
func main() {
  8000c6:	83 c4 24             	add    $0x24,%esp
  8000c9:	5e                   	pop    %esi
  8000ca:	5f                   	pop    %edi
  8000cb:	c3                   	ret    

008000cc <__go_init_main>:
package main
  8000cc:	c3                   	ret    

008000cd <__go_type_hash_identity>:
			    const struct go_type_descriptor *td2)
asm("runtime.ifacetypeeq");

uintptr_t
__go_type_hash_identity(const void *key, uintptr_t key_size)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	53                   	push   %ebx
  8000d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d4:	89 da                	mov    %ebx,%edx
  8000d6:	03 5d 0c             	add    0xc(%ebp),%ebx
	uintptr_t i, hash = 5381;
  8000d9:	b8 05 15 00 00       	mov    $0x1505,%eax
	const uint8_t *p = key;

	for (i = 0; i < key_size; ++i)
  8000de:	eb 0d                	jmp    8000ed <__go_type_hash_identity+0x20>
		hash = hash * 33 + p[i];
  8000e0:	89 c1                	mov    %eax,%ecx
  8000e2:	c1 e1 05             	shl    $0x5,%ecx
  8000e5:	01 c8                	add    %ecx,%eax
  8000e7:	0f b6 0a             	movzbl (%edx),%ecx
  8000ea:	01 c8                	add    %ecx,%eax
  8000ec:	42                   	inc    %edx
	for (i = 0; i < key_size; ++i)
  8000ed:	39 da                	cmp    %ebx,%edx
  8000ef:	75 ef                	jne    8000e0 <__go_type_hash_identity+0x13>
	return hash;
}
  8000f1:	5b                   	pop    %ebx
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <__go_type_hash_string>:
	panic("go type equal error");
}

uintptr_t
__go_type_hash_string(const void *key, uintptr_t key_size)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	8b 45 08             	mov    0x8(%ebp),%eax
	const struct go_string *s = key;

	return __go_type_hash_identity(key, s->length);
  8000fa:	ff 70 04             	pushl  0x4(%eax)
  8000fd:	50                   	push   %eax
  8000fe:	e8 ca ff ff ff       	call   8000cd <__go_type_hash_identity>
  800103:	83 c4 08             	add    $0x8,%esp
}
  800106:	c9                   	leave  
  800107:	c3                   	ret    

00800108 <__go_type_hash_empty_interface>:
	return __builtin_call_with_static_chain(e(p1, p2, size), equalfn);
}

uintptr_t
__go_type_hash_empty_interface(const struct go_empty_interface *val, uintptr_t key_size)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	53                   	push   %ebx
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	8b 45 08             	mov    0x8(%ebp),%eax
	const struct go_type_descriptor *td = val->type_descriptor;
  800112:	8b 10                	mov    (%eax),%edx
	const void *p;

	if (!td)
  800114:	85 d2                	test   %edx,%edx
  800116:	74 2d                	je     800145 <__go_type_hash_empty_interface+0x3d>
	unsigned char code = td->code & GO_CODE_MASK;
  800118:	8a 0a                	mov    (%edx),%cl
  80011a:	83 e1 1f             	and    $0x1f,%ecx
	return (code == GO_PTR) || (code == GO_UNSAFE_POINTER);
  80011d:	80 f9 16             	cmp    $0x16,%cl
  800120:	74 0a                	je     80012c <__go_type_hash_empty_interface+0x24>
		return 0;
	if (__go_is_pointer_type(td))
  800122:	80 f9 1a             	cmp    $0x1a,%cl
  800125:	74 05                	je     80012c <__go_type_hash_empty_interface+0x24>
		p = &val->object;
	else
		p = val->object;
  800127:	8b 40 04             	mov    0x4(%eax),%eax
  80012a:	eb 03                	jmp    80012f <__go_type_hash_empty_interface+0x27>
		p = &val->object;
  80012c:	83 c0 04             	add    $0x4,%eax
	return __go_call_hashfn(td->hashfn, p, td->size);
  80012f:	8b 5a 0c             	mov    0xc(%edx),%ebx
	return __builtin_call_with_static_chain(h(p, size), hashfn);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	ff 72 04             	pushl  0x4(%edx)
  800138:	50                   	push   %eax
  800139:	89 d9                	mov    %ebx,%ecx
  80013b:	ff 13                	call   *(%ebx)
	return __go_call_hashfn(td->hashfn, p, td->size);
  80013d:	83 c4 10             	add    $0x10,%esp
}
  800140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800143:	c9                   	leave  
  800144:	c3                   	ret    
		return 0;
  800145:	b8 00 00 00 00       	mov    $0x0,%eax
  80014a:	eb f4                	jmp    800140 <__go_type_hash_empty_interface+0x38>

0080014c <__go_type_equal_identity>:
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 0c             	sub    $0xc,%esp
	return memcmp(k1, k2, key_size) == 0;
  800152:	ff 75 10             	pushl  0x10(%ebp)
  800155:	ff 75 0c             	pushl  0xc(%ebp)
  800158:	ff 75 08             	pushl  0x8(%ebp)
  80015b:	e8 f8 12 00 00       	call   801458 <memcmp>
  800160:	83 c4 10             	add    $0x10,%esp
  800163:	85 c0                	test   %eax,%eax
  800165:	0f 94 c0             	sete   %al
}
  800168:	c9                   	leave  
  800169:	c3                   	ret    

0080016a <__go_ptr_strings_equal>:
}

static _Bool
__go_ptr_strings_equal(const struct go_string *ps1, const struct go_string *ps2)
{
	if (ps1 == ps2)
  80016a:	39 d0                	cmp    %edx,%eax
  80016c:	74 39                	je     8001a7 <__go_ptr_strings_equal+0x3d>
		return 1;
	if (!ps1 || !ps2)
  80016e:	85 c0                	test   %eax,%eax
  800170:	74 38                	je     8001aa <__go_ptr_strings_equal+0x40>
  800172:	85 d2                	test   %edx,%edx
  800174:	74 37                	je     8001ad <__go_ptr_strings_equal+0x43>
  800176:	8b 48 04             	mov    0x4(%eax),%ecx
	return s1.length == s2.length && memcmp(s1.data, s2.data, s1.length) == 0;
  800179:	3b 4a 04             	cmp    0x4(%edx),%ecx
  80017c:	74 09                	je     800187 <__go_ptr_strings_equal+0x1d>
  80017e:	b8 00 00 00 00       	mov    $0x0,%eax
  800183:	83 e0 01             	and    $0x1,%eax
		return 0;
	return __go_strings_equal(*ps1, *ps2);
}
  800186:	c3                   	ret    
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 0c             	sub    $0xc,%esp
	return s1.length == s2.length && memcmp(s1.data, s2.data, s1.length) == 0;
  80018d:	51                   	push   %ecx
  80018e:	ff 32                	pushl  (%edx)
  800190:	ff 30                	pushl  (%eax)
  800192:	e8 c1 12 00 00       	call   801458 <memcmp>
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	85 c0                	test   %eax,%eax
  80019c:	0f 94 c0             	sete   %al
  80019f:	0f b6 c0             	movzbl %al,%eax
  8001a2:	83 e0 01             	and    $0x1,%eax
}
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    
		return 1;
  8001a7:	b0 01                	mov    $0x1,%al
  8001a9:	c3                   	ret    
		return 0;
  8001aa:	b0 00                	mov    $0x0,%al
  8001ac:	c3                   	ret    
  8001ad:	b0 00                	mov    $0x0,%al
  8001af:	c3                   	ret    

008001b0 <__go_type_equal_string>:

_Bool
__go_type_equal_string(const void *k1, const void *k2, uintptr_t key_size)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	83 ec 08             	sub    $0x8,%esp
	return __go_ptr_strings_equal(k1, k2);
  8001b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	e8 a9 ff ff ff       	call   80016a <__go_ptr_strings_equal>
}
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <__go_type_hash_error>:
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	83 ec 0c             	sub    $0xc,%esp
	panic("go type hash error");
  8001c9:	68 90 2c 80 00       	push   $0x802c90
  8001ce:	6a 55                	push   $0x55
  8001d0:	68 a3 2c 80 00       	push   $0x802ca3
  8001d5:	e8 1f 0a 00 00       	call   800bf9 <_panic>

008001da <__go_type_equal_error>:
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	83 ec 0c             	sub    $0xc,%esp
	panic("go type equal error");
  8001e0:	68 af 2c 80 00       	push   $0x802caf
  8001e5:	6a 5b                	push   $0x5b
  8001e7:	68 a3 2c 80 00       	push   $0x802ca3
  8001ec:	e8 08 0a 00 00       	call   800bf9 <_panic>

008001f1 <umain>:
{
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	83 ec 08             	sub    $0x8,%esp
	gomain();
  8001f7:	e8 6c fe ff ff       	call   800068 <main.main>
}
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <__go_runtime_error>:
	(void *)__go_type_equal_empty_interface
};

void
__go_runtime_error(int32_t i)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	83 ec 08             	sub    $0x8,%esp
	panic("go runtime error: %d", i);
  800204:	ff 75 08             	pushl  0x8(%ebp)
  800207:	68 c3 2c 80 00       	push   $0x802cc3
  80020c:	68 e1 00 00 00       	push   $0xe1
  800211:	68 a3 2c 80 00       	push   $0x802ca3
  800216:	e8 de 09 00 00       	call   800bf9 <_panic>

0080021b <__go_strcmp>:
}

int
__go_strcmp(struct go_string s1, struct go_string s2)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	8b 55 08             	mov    0x8(%ebp),%edx
  800223:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800226:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800229:	8b 75 14             	mov    0x14(%ebp),%esi
	int r;

	r = memcmp(s1.data, s2.data, MIN(s1.length, s2.length));
  80022c:	83 ec 04             	sub    $0x4,%esp
  80022f:	89 d8                	mov    %ebx,%eax
  800231:	39 f3                	cmp    %esi,%ebx
  800233:	7e 02                	jle    800237 <__go_strcmp+0x1c>
  800235:	89 f0                	mov    %esi,%eax
  800237:	50                   	push   %eax
  800238:	51                   	push   %ecx
  800239:	52                   	push   %edx
  80023a:	e8 19 12 00 00       	call   801458 <memcmp>
	if (r)
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	85 c0                	test   %eax,%eax
  800244:	75 0a                	jne    800250 <__go_strcmp+0x35>
		return r;
	if (s1.length < s2.length)
  800246:	39 f3                	cmp    %esi,%ebx
  800248:	7c 0d                	jl     800257 <__go_strcmp+0x3c>
		return -1;
	if (s1.length > s2.length)
  80024a:	0f 9f c0             	setg   %al
  80024d:	0f b6 c0             	movzbl %al,%eax
		return 1;
	return 0;
}
  800250:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800253:	5b                   	pop    %ebx
  800254:	5e                   	pop    %esi
  800255:	5d                   	pop    %ebp
  800256:	c3                   	ret    
		return -1;
  800257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80025c:	eb f2                	jmp    800250 <__go_strcmp+0x35>

0080025e <__go_new>:

void *
__go_new(const struct go_type_descriptor *td, uintptr_t size)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 14             	sub    $0x14,%esp
	return malloc(size);
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	e8 9a 07 00 00       	call   800a06 <malloc>
}
  80026c:	c9                   	leave  
  80026d:	c3                   	ret    

0080026e <__go_new_nopointers>:

// compatibility: for gcc 5
void *
__go_new_nopointers(const struct go_type_descriptor *td, uintptr_t size)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	83 ec 14             	sub    $0x14,%esp
	return malloc(size);
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	e8 8a 07 00 00       	call   800a06 <malloc>
	return __go_new(td, size);
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <__go_byte_array_to_string>:

// string

struct go_string
__go_byte_array_to_string(const void *data, int length)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 18             	sub    $0x18,%esp
  800287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80028a:	8b 75 10             	mov    0x10(%ebp),%esi
	struct go_string s;
	void *p;

	p = malloc(length);
  80028d:	56                   	push   %esi
  80028e:	e8 73 07 00 00       	call   800a06 <malloc>
  800293:	89 c7                	mov    %eax,%edi
	memcpy(p, data, length);
  800295:	83 c4 0c             	add    $0xc,%esp
  800298:	56                   	push   %esi
  800299:	ff 75 0c             	pushl  0xc(%ebp)
  80029c:	50                   	push   %eax
  80029d:	e8 a3 11 00 00       	call   801445 <memcpy>
	s.data = p;
	s.length = length;
	return s;
  8002a2:	89 3b                	mov    %edi,(%ebx)
  8002a4:	89 73 04             	mov    %esi,0x4(%ebx)
}
  8002a7:	89 d8                	mov    %ebx,%eax
  8002a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5f                   	pop    %edi
  8002af:	5d                   	pop    %ebp
  8002b0:	c2 04 00             	ret    $0x4

008002b3 <__go_string_plus>:

struct go_string
__go_string_plus(struct go_string s1, struct go_string s2)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 28             	sub    $0x28,%esp
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8002ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
	struct go_string s;
	void *p;

	s.length = s1.length + s2.length;
  8002d1:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
	p = malloc(s.length);
  8002d4:	57                   	push   %edi
  8002d5:	e8 2c 07 00 00       	call   800a06 <malloc>
	assert(p);
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	85 c0                	test   %eax,%eax
  8002df:	74 32                	je     800313 <__go_string_plus+0x60>
  8002e1:	89 c6                	mov    %eax,%esi
	memcpy(p, s1.data, s1.length);
  8002e3:	83 ec 04             	sub    $0x4,%esp
  8002e6:	53                   	push   %ebx
  8002e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ea:	50                   	push   %eax
  8002eb:	e8 55 11 00 00       	call   801445 <memcpy>
	memcpy(p + s1.length, s2.data, s2.length);
  8002f0:	83 c4 0c             	add    $0xc,%esp
  8002f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f9:	01 f3                	add    %esi,%ebx
  8002fb:	53                   	push   %ebx
  8002fc:	e8 44 11 00 00       	call   801445 <memcpy>
	s.data = p;
	return s;
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	89 30                	mov    %esi,(%eax)
  800306:	89 78 04             	mov    %edi,0x4(%eax)
}
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c2 04 00             	ret    $0x4
	assert(p);
  800313:	68 d8 2c 80 00       	push   $0x802cd8
  800318:	68 da 2c 80 00       	push   $0x802cda
  80031d:	68 30 01 00 00       	push   $0x130
  800322:	68 a3 2c 80 00       	push   $0x802ca3
  800327:	e8 cd 08 00 00       	call   800bf9 <_panic>

0080032c <runtime.efacetype>:

// interface

const struct go_type_descriptor *
efacetype(struct go_empty_interface e) {
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
	return e.type_descriptor;
}
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    

00800334 <runtime.ifacetypeeq>:

_Bool
__go_type_descriptors_equal(const struct go_type_descriptor *td1,
			    const struct go_type_descriptor *td2)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	8b 55 0c             	mov    0xc(%ebp),%edx
	if (td1 == td2)
  800340:	39 d0                	cmp    %edx,%eax
  800342:	74 2b                	je     80036f <runtime.ifacetypeeq+0x3b>
		return 1;
	if (!td1 || !td2)
  800344:	85 c0                	test   %eax,%eax
  800346:	74 2b                	je     800373 <runtime.ifacetypeeq+0x3f>
  800348:	85 d2                	test   %edx,%edx
  80034a:	74 2b                	je     800377 <runtime.ifacetypeeq+0x43>
		return 0;
	if (td1->code != td2->code || td1->hash != td2->hash)
  80034c:	8a 0a                	mov    (%edx),%cl
  80034e:	38 08                	cmp    %cl,(%eax)
  800350:	74 04                	je     800356 <runtime.ifacetypeeq+0x22>
		return 0;
  800352:	b0 00                	mov    $0x0,%al
	return __go_ptr_strings_equal(td1->reflection, td2->reflection);
}
  800354:	c9                   	leave  
  800355:	c3                   	ret    
	if (td1->code != td2->code || td1->hash != td2->hash)
  800356:	8b 4a 08             	mov    0x8(%edx),%ecx
  800359:	39 48 08             	cmp    %ecx,0x8(%eax)
  80035c:	74 04                	je     800362 <runtime.ifacetypeeq+0x2e>
		return 0;
  80035e:	b0 00                	mov    $0x0,%al
  800360:	eb f2                	jmp    800354 <runtime.ifacetypeeq+0x20>
	return __go_ptr_strings_equal(td1->reflection, td2->reflection);
  800362:	8b 52 18             	mov    0x18(%edx),%edx
  800365:	8b 40 18             	mov    0x18(%eax),%eax
  800368:	e8 fd fd ff ff       	call   80016a <__go_ptr_strings_equal>
  80036d:	eb e5                	jmp    800354 <runtime.ifacetypeeq+0x20>
		return 1;
  80036f:	b0 01                	mov    $0x1,%al
  800371:	eb e1                	jmp    800354 <runtime.ifacetypeeq+0x20>
		return 0;
  800373:	b0 00                	mov    $0x0,%al
  800375:	eb dd                	jmp    800354 <runtime.ifacetypeeq+0x20>
  800377:	b0 00                	mov    $0x0,%al
  800379:	eb d9                	jmp    800354 <runtime.ifacetypeeq+0x20>

0080037b <__go_empty_interface_compare>:
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	57                   	push   %edi
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
  800381:	83 ec 0c             	sub    $0xc,%esp
  800384:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800387:	8b 75 0c             	mov    0xc(%ebp),%esi
  80038a:	8b 45 10             	mov    0x10(%ebp),%eax
  80038d:	8b 7d 14             	mov    0x14(%ebp),%edi
	if (td1 == td2)
  800390:	39 c3                	cmp    %eax,%ebx
  800392:	74 4c                	je     8003e0 <__go_empty_interface_compare+0x65>
	if (!td1 || !td2)
  800394:	85 db                	test   %ebx,%ebx
  800396:	74 4f                	je     8003e7 <__go_empty_interface_compare+0x6c>
  800398:	85 c0                	test   %eax,%eax
  80039a:	74 52                	je     8003ee <__go_empty_interface_compare+0x73>
	if (!__go_type_descriptors_equal(td1, td2))
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	50                   	push   %eax
  8003a0:	53                   	push   %ebx
  8003a1:	e8 8e ff ff ff       	call   800334 <runtime.ifacetypeeq>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	84 c0                	test   %al,%al
  8003ab:	74 48                	je     8003f5 <__go_empty_interface_compare+0x7a>
	unsigned char code = td->code & GO_CODE_MASK;
  8003ad:	8a 03                	mov    (%ebx),%al
  8003af:	83 e0 1f             	and    $0x1f,%eax
	return (code == GO_PTR) || (code == GO_UNSAFE_POINTER);
  8003b2:	3c 16                	cmp    $0x16,%al
  8003b4:	74 20                	je     8003d6 <__go_empty_interface_compare+0x5b>
	if (__go_is_pointer_type(td1))
  8003b6:	3c 1a                	cmp    $0x1a,%al
  8003b8:	74 1c                	je     8003d6 <__go_empty_interface_compare+0x5b>
	if (!__go_call_equalfn(td1->equalfn, v1.object, v2.object, td1->size))
  8003ba:	8b 43 10             	mov    0x10(%ebx),%eax
	return __builtin_call_with_static_chain(e(p1, p2, size), equalfn);
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	ff 73 04             	pushl  0x4(%ebx)
  8003c3:	57                   	push   %edi
  8003c4:	56                   	push   %esi
  8003c5:	89 c1                	mov    %eax,%ecx
  8003c7:	ff 10                	call   *(%eax)
	if (!__go_call_equalfn(td1->equalfn, v1.object, v2.object, td1->size))
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	85 c0                	test   %eax,%eax
  8003ce:	0f 94 c0             	sete   %al
  8003d1:	0f b6 c0             	movzbl %al,%eax
  8003d4:	eb 24                	jmp    8003fa <__go_empty_interface_compare+0x7f>
		return v1.object == v2.object ? 0 : 1;
  8003d6:	39 fe                	cmp    %edi,%esi
  8003d8:	0f 95 c0             	setne  %al
  8003db:	0f b6 c0             	movzbl %al,%eax
  8003de:	eb 1a                	jmp    8003fa <__go_empty_interface_compare+0x7f>
		return 0;
  8003e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e5:	eb 13                	jmp    8003fa <__go_empty_interface_compare+0x7f>
		return 1;
  8003e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8003ec:	eb 0c                	jmp    8003fa <__go_empty_interface_compare+0x7f>
  8003ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8003f3:	eb 05                	jmp    8003fa <__go_empty_interface_compare+0x7f>
		return 1;
  8003f5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003fd:	5b                   	pop    %ebx
  8003fe:	5e                   	pop    %esi
  8003ff:	5f                   	pop    %edi
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    

00800402 <__go_type_equal_empty_interface>:
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 08             	sub    $0x8,%esp
	return __go_empty_interface_compare(*v1, *v2) == 0;
  800408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040b:	ff 70 04             	pushl  0x4(%eax)
  80040e:	ff 30                	pushl  (%eax)
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	ff 70 04             	pushl  0x4(%eax)
  800416:	ff 30                	pushl  (%eax)
  800418:	e8 5e ff ff ff       	call   80037b <__go_empty_interface_compare>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	85 c0                	test   %eax,%eax
  800422:	0f 94 c0             	sete   %al
}
  800425:	c9                   	leave  
  800426:	c3                   	ret    

00800427 <__go_check_interface_type>:

void
__go_check_interface_type(const struct go_type_descriptor *lhs_descriptor,
			  const struct go_type_descriptor *rhs_descriptor,
			  const struct go_type_descriptor *rhs_inter_descriptor)
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
}
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    

0080042c <__go_append>:

// array

struct go_open_array
__go_append(struct go_open_array a, void *bvalues, uintptr_t bcount, uintptr_t element_size)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	57                   	push   %edi
  800430:	56                   	push   %esi
  800431:	53                   	push   %ebx
  800432:	83 ec 1c             	sub    $0x1c,%esp
  800435:	8b 7d 08             	mov    0x8(%ebp),%edi
  800438:	8b 75 0c             	mov    0xc(%ebp),%esi
  80043b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80043e:	8b 45 14             	mov    0x14(%ebp),%eax
  800441:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int count;

	if (!bvalues || bcount == 0)
  800444:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  800448:	0f 84 90 00 00 00    	je     8004de <__go_append+0xb2>
  80044e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800452:	0f 84 86 00 00 00    	je     8004de <__go_append+0xb2>
		return a;
	assert(bcount <= INT_MAX - a.count);
  800458:	b8 ff ff ff 7f       	mov    $0x7fffffff,%eax
  80045d:	29 d8                	sub    %ebx,%eax
  80045f:	39 45 1c             	cmp    %eax,0x1c(%ebp)
  800462:	0f 87 83 00 00 00    	ja     8004eb <__go_append+0xbf>
	count = a.count + bcount;
  800468:	89 d8                	mov    %ebx,%eax
  80046a:	03 45 1c             	add    0x1c(%ebp),%eax
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (count > a.capacity) {
  800470:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800473:	7e 32                	jle    8004a7 <__go_append+0x7b>
		void *p = malloc(count * element_size);
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	0f af 45 20          	imul   0x20(%ebp),%eax
  80047c:	50                   	push   %eax
  80047d:	e8 84 05 00 00       	call   800a06 <malloc>
  800482:	89 c1                	mov    %eax,%ecx

		assert(p);
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	85 c0                	test   %eax,%eax
  800489:	74 79                	je     800504 <__go_append+0xd8>
		memcpy(p, a.values, a.count * element_size);
  80048b:	83 ec 04             	sub    $0x4,%esp
  80048e:	89 d8                	mov    %ebx,%eax
  800490:	0f af 45 20          	imul   0x20(%ebp),%eax
  800494:	50                   	push   %eax
  800495:	56                   	push   %esi
  800496:	89 ce                	mov    %ecx,%esi
  800498:	51                   	push   %ecx
  800499:	e8 a7 0f 00 00       	call   801445 <memcpy>
  80049e:	83 c4 10             	add    $0x10,%esp
		a.values = p;
		a.capacity = count;
  8004a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	}
	memmove(a.values + a.count * element_size, bvalues, bcount * element_size);
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ad:	0f af 45 20          	imul   0x20(%ebp),%eax
  8004b1:	50                   	push   %eax
  8004b2:	ff 75 18             	pushl  0x18(%ebp)
  8004b5:	0f af 5d 20          	imul   0x20(%ebp),%ebx
  8004b9:	01 f3                	add    %esi,%ebx
  8004bb:	53                   	push   %ebx
  8004bc:	e8 1e 0f 00 00       	call   8013df <memmove>
	a.count = count;
	return a;
  8004c1:	89 37                	mov    %esi,(%edi)
  8004c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c6:	89 47 04             	mov    %eax,0x4(%edi)
  8004c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004cc:	89 47 08             	mov    %eax,0x8(%edi)
  8004cf:	83 c4 10             	add    $0x10,%esp
}
  8004d2:	89 f8                	mov    %edi,%eax
  8004d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d7:	5b                   	pop    %ebx
  8004d8:	5e                   	pop    %esi
  8004d9:	5f                   	pop    %edi
  8004da:	5d                   	pop    %ebp
  8004db:	c2 04 00             	ret    $0x4
		return a;
  8004de:	89 37                	mov    %esi,(%edi)
  8004e0:	89 5f 04             	mov    %ebx,0x4(%edi)
  8004e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004e6:	89 47 08             	mov    %eax,0x8(%edi)
  8004e9:	eb e7                	jmp    8004d2 <__go_append+0xa6>
	assert(bcount <= INT_MAX - a.count);
  8004eb:	68 ef 2c 80 00       	push   $0x802cef
  8004f0:	68 da 2c 80 00       	push   $0x802cda
  8004f5:	68 5b 01 00 00       	push   $0x15b
  8004fa:	68 a3 2c 80 00       	push   $0x802ca3
  8004ff:	e8 f5 06 00 00       	call   800bf9 <_panic>
		assert(p);
  800504:	68 d8 2c 80 00       	push   $0x802cd8
  800509:	68 da 2c 80 00       	push   $0x802cda
  80050e:	68 60 01 00 00       	push   $0x160
  800513:	68 a3 2c 80 00       	push   $0x802ca3
  800518:	e8 dc 06 00 00       	call   800bf9 <_panic>

0080051d <sys.AIe1e$hash>:
  80051d:	83 ec 14             	sub    $0x14,%esp
  800520:	6a 08                	push   $0x8
  800522:	ff 74 24 1c          	pushl  0x1c(%esp)
  800526:	e8 dd fb ff ff       	call   800108 <__go_type_hash_empty_interface>
  80052b:	83 c4 1c             	add    $0x1c,%esp
  80052e:	c3                   	ret    

0080052f <sys.AIe1e$equal>:
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	8b 44 24 14          	mov    0x14(%esp),%eax
  800536:	ff 70 04             	pushl  0x4(%eax)
  800539:	ff 30                	pushl  (%eax)
  80053b:	8b 44 24 18          	mov    0x18(%esp),%eax
  80053f:	ff 70 04             	pushl  0x4(%eax)
  800542:	ff 30                	pushl  (%eax)
  800544:	e8 32 fe ff ff       	call   80037b <__go_empty_interface_compare>
  800549:	85 c0                	test   %eax,%eax
  80054b:	0f 94 c0             	sete   %al
  80054e:	83 c4 1c             	add    $0x1c,%esp
  800551:	c3                   	ret    

00800552 <go.sys.Itoa>:

func Println(a ...interface{}) {
	Print(append(a, "\n")...)
}

func Itoa(i int) string {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	57                   	push   %edi
  800556:	56                   	push   %esi
  800557:	53                   	push   %ebx
  800558:	83 ec 34             	sub    $0x34,%esp
	var a [32]byte
  80055b:	6a 20                	push   $0x20
  80055d:	68 e0 2d 80 00       	push   $0x802de0
  800562:	e8 f7 fc ff ff       	call   80025e <__go_new>
  800567:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80056d:	85 f6                	test   %esi,%esi
  80056f:	78 2e                	js     80059f <go.sys.Itoa+0x4d>
  800571:	89 f1                	mov    %esi,%ecx
	if neg {
		i = -i
	}

	k := len(a)
	for i >= 10 {
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	83 fe 09             	cmp    $0x9,%esi
  800579:	0f 8e 18 01 00 00    	jle    800697 <go.sys.Itoa+0x145>
		k--
		q := i / 10
  80057f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800584:	f7 ee                	imul   %esi
  800586:	89 d3                	mov    %edx,%ebx
  800588:	c1 fb 02             	sar    $0x2,%ebx
  80058b:	c1 fe 1f             	sar    $0x1f,%esi
  80058e:	29 f3                	sub    %esi,%ebx
		k--
  800590:	bf 1f 00 00 00       	mov    $0x1f,%edi
  800595:	b8 1f 00 00 00       	mov    $0x1f,%eax
  80059a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059d:	eb 15                	jmp    8005b4 <go.sys.Itoa+0x62>
  80059f:	f7 de                	neg    %esi
  8005a1:	eb ce                	jmp    800571 <go.sys.Itoa+0x1f>
		a[k] = byte(i - q * 10 + '0')
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	6a 01                	push   $0x1
  8005a8:	e8 51 fc ff ff       	call   8001fe <__go_runtime_error>
  8005ad:	83 c4 10             	add    $0x10,%esp
		k--
  8005b0:	89 d9                	mov    %ebx,%ecx
		q := i / 10
  8005b2:	89 f3                	mov    %esi,%ebx
		a[k] = byte(i - q * 10 + '0')
  8005b4:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  8005bb:	01 d8                	add    %ebx,%eax
  8005bd:	d1 e0                	shl    %eax
  8005bf:	83 c1 30             	add    $0x30,%ecx
  8005c2:	29 c1                	sub    %eax,%ecx
  8005c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ca:	88 0c 10             	mov    %cl,(%eax,%edx,1)
	for i >= 10 {
  8005cd:	83 fb 09             	cmp    $0x9,%ebx
  8005d0:	7e 1e                	jle    8005f0 <go.sys.Itoa+0x9e>
		k--
  8005d2:	4f                   	dec    %edi
		q := i / 10
  8005d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8005d8:	f7 eb                	imul   %ebx
  8005da:	89 d6                	mov    %edx,%esi
  8005dc:	c1 fe 02             	sar    $0x2,%esi
  8005df:	89 d8                	mov    %ebx,%eax
  8005e1:	c1 f8 1f             	sar    $0x1f,%eax
  8005e4:	29 c6                	sub    %eax,%esi
		a[k] = byte(i - q * 10 + '0')
  8005e6:	83 ff 1f             	cmp    $0x1f,%edi
  8005e9:	77 b8                	ja     8005a3 <go.sys.Itoa+0x51>
		k--
  8005eb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8005ee:	eb c0                	jmp    8005b0 <go.sys.Itoa+0x5e>
		i = q
	}

	k--
  8005f0:	8d 77 ff             	lea    -0x1(%edi),%esi
	a[k] = byte(i + '0')
  8005f3:	83 fe 1f             	cmp    $0x1f,%esi
  8005f6:	77 4d                	ja     800645 <go.sys.Itoa+0xf3>
	k--
  8005f8:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	a[k] = byte(i + '0')
  8005fb:	83 c3 30             	add    $0x30,%ebx
  8005fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800601:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800604:	88 1c 08             	mov    %bl,(%eax,%ecx,1)

	if (neg) {
  800607:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80060b:	78 47                	js     800654 <go.sys.Itoa+0x102>
		k--
		a[k] = '-'
	}
	return string(a[k:])
  80060d:	83 fe 20             	cmp    $0x20,%esi
  800610:	77 76                	ja     800688 <go.sys.Itoa+0x136>
  800612:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800615:	01 f0                	add    %esi,%eax
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	b8 20 00 00 00       	mov    $0x20,%eax
  80061f:	29 f0                	sub    %esi,%eax
  800621:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800624:	83 ec 04             	sub    $0x4,%esp
  800627:	ff 75 dc             	pushl  -0x24(%ebp)
  80062a:	ff 75 d8             	pushl  -0x28(%ebp)
  80062d:	ff 75 08             	pushl  0x8(%ebp)
  800630:	e8 49 fc ff ff       	call   80027e <__go_byte_array_to_string>
  800635:	83 c4 0c             	add    $0xc,%esp
func Itoa(i int) string {
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80063e:	5b                   	pop    %ebx
  80063f:	5e                   	pop    %esi
  800640:	5f                   	pop    %edi
  800641:	5d                   	pop    %ebp
  800642:	c2 04 00             	ret    $0x4
	a[k] = byte(i + '0')
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	6a 01                	push   $0x1
  80064a:	e8 af fb ff ff       	call   8001fe <__go_runtime_error>
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	eb a7                	jmp    8005fb <go.sys.Itoa+0xa9>
		k--
  800654:	8d 77 fe             	lea    -0x2(%edi),%esi
		a[k] = '-'
  800657:	83 fe 1f             	cmp    $0x1f,%esi
  80065a:	77 0f                	ja     80066b <go.sys.Itoa+0x119>
		k--
  80065c:	89 75 d0             	mov    %esi,-0x30(%ebp)
		a[k] = '-'
  80065f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800662:	8b 7d d0             	mov    -0x30(%ebp),%edi
  800665:	c6 04 38 2d          	movb   $0x2d,(%eax,%edi,1)
  800669:	eb a2                	jmp    80060d <go.sys.Itoa+0xbb>
  80066b:	83 ec 0c             	sub    $0xc,%esp
  80066e:	6a 01                	push   $0x1
  800670:	e8 89 fb ff ff       	call   8001fe <__go_runtime_error>
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	eb e5                	jmp    80065f <go.sys.Itoa+0x10d>
		k--
  80067a:	be 1e 00 00 00       	mov    $0x1e,%esi
  80067f:	c7 45 d0 1e 00 00 00 	movl   $0x1e,-0x30(%ebp)
  800686:	eb d7                	jmp    80065f <go.sys.Itoa+0x10d>
	return string(a[k:])
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	6a 04                	push   $0x4
  80068d:	e8 6c fb ff ff       	call   8001fe <__go_runtime_error>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	eb 8d                	jmp    800624 <go.sys.Itoa+0xd2>
	a[k] = byte(i + '0')
  800697:	8d 46 30             	lea    0x30(%esi),%eax
  80069a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80069d:	88 47 1f             	mov    %al,0x1f(%edi)
	if (neg) {
  8006a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a4:	78 d4                	js     80067a <go.sys.Itoa+0x128>
	k--
  8006a6:	be 1f 00 00 00       	mov    $0x1f,%esi
  8006ab:	e9 5d ff ff ff       	jmp    80060d <go.sys.Itoa+0xbb>

008006b0 <go.sys.Sprint>:
func Sprint(a ...interface{}) string {
  8006b0:	55                   	push   %ebp
  8006b1:	57                   	push   %edi
  8006b2:	56                   	push   %esi
  8006b3:	53                   	push   %ebx
  8006b4:	83 ec 4c             	sub    $0x4c,%esp
	for _, arg := range a {
  8006b7:	8b 44 24 64          	mov    0x64(%esp),%eax
  8006bb:	89 44 24 34          	mov    %eax,0x34(%esp)
  8006bf:	8b 44 24 68          	mov    0x68(%esp),%eax
  8006c3:	85 c0                	test   %eax,%eax
  8006c5:	0f 8e 4e 01 00 00    	jle    800819 <go.sys.Sprint+0x169>
  8006cb:	89 44 24 30          	mov    %eax,0x30(%esp)
  8006cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d4:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
  8006db:	00 
  8006dc:	c7 44 24 1c 6c 2d 80 	movl   $0x802d6c,0x1c(%esp)
  8006e3:	00 
		return Itoa(f)
  8006e4:	89 dd                	mov    %ebx,%ebp
  8006e6:	eb 72                	jmp    80075a <go.sys.Sprint+0xaa>
	for _, arg := range a {
  8006e8:	83 ec 0c             	sub    $0xc,%esp
  8006eb:	6a 00                	push   $0x0
  8006ed:	e8 0c fb ff ff       	call   8001fe <__go_runtime_error>
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	eb 72                	jmp    800769 <go.sys.Sprint+0xb9>
	case string:
  8006f7:	83 ec 04             	sub    $0x4,%esp
  8006fa:	68 20 2c 80 00       	push   $0x802c20
  8006ff:	ff 74 24 34          	pushl  0x34(%esp)
  800703:	68 a0 2a 80 00       	push   $0x802aa0
  800708:	e8 1a fd ff ff       	call   800427 <__go_check_interface_type>
		return f
  80070d:	8b 03                	mov    (%ebx),%eax
  80070f:	89 44 24 20          	mov    %eax,0x20(%esp)
  800713:	8b 43 04             	mov    0x4(%ebx),%eax
  800716:	89 44 24 24          	mov    %eax,0x24(%esp)
  80071a:	83 c4 10             	add    $0x10,%esp
		s += sprintArg(arg)
  80071d:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  800721:	8b 7c 24 20          	mov    0x20(%esp),%edi
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	ff 74 24 20          	pushl  0x20(%esp)
  80072c:	ff 74 24 20          	pushl  0x20(%esp)
  800730:	57                   	push   %edi
  800731:	56                   	push   %esi
  800732:	8d 44 24 54          	lea    0x54(%esp),%eax
  800736:	50                   	push   %eax
  800737:	e8 77 fb ff ff       	call   8002b3 <__go_string_plus>
  80073c:	8b 74 24 54          	mov    0x54(%esp),%esi
  800740:	8b 7c 24 58          	mov    0x58(%esp),%edi
  800744:	89 74 24 38          	mov    %esi,0x38(%esp)
  800748:	89 7c 24 3c          	mov    %edi,0x3c(%esp)
  80074c:	45                   	inc    %ebp
	for _, arg := range a {
  80074d:	83 c4 1c             	add    $0x1c,%esp
  800750:	3b 6c 24 30          	cmp    0x30(%esp),%ebp
  800754:	0f 84 cf 00 00 00    	je     800829 <go.sys.Sprint+0x179>
  80075a:	85 ed                	test   %ebp,%ebp
  80075c:	78 8a                	js     8006e8 <go.sys.Sprint+0x38>
  80075e:	8d 04 ed 00 00 00 00 	lea    0x0(,%ebp,8),%eax
  800765:	89 44 24 24          	mov    %eax,0x24(%esp)
  800769:	8b 44 24 34          	mov    0x34(%esp),%eax
  80076d:	03 44 24 24          	add    0x24(%esp),%eax
  800771:	8b 10                	mov    (%eax),%edx
  800773:	89 54 24 2c          	mov    %edx,0x2c(%esp)
  800777:	8b 58 04             	mov    0x4(%eax),%ebx
	switch f := arg.(type) {
  80077a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80077e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 74 24 14          	pushl  0x14(%esp)
  800789:	ff 74 24 14          	pushl  0x14(%esp)
  80078d:	e8 9a fb ff ff       	call   80032c <runtime.efacetype>
  800792:	89 44 24 38          	mov    %eax,0x38(%esp)
	case string:
  800796:	83 c4 08             	add    $0x8,%esp
  800799:	50                   	push   %eax
  80079a:	68 a0 2a 80 00       	push   $0x802aa0
  80079f:	e8 90 fb ff ff       	call   800334 <runtime.ifacetypeeq>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	84 c0                	test   %al,%al
  8007a9:	0f 85 48 ff ff ff    	jne    8006f7 <go.sys.Sprint+0x47>
	case int:
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 74 24 30          	pushl  0x30(%esp)
  8007b6:	68 80 2f 80 00       	push   $0x802f80
  8007bb:	e8 74 fb ff ff       	call   800334 <runtime.ifacetypeeq>
  8007c0:	83 c4 10             	add    $0x10,%esp
  8007c3:	84 c0                	test   %al,%al
  8007c5:	75 15                	jne    8007dc <go.sys.Sprint+0x12c>
		return "XXX"
  8007c7:	c7 44 24 10 6d 2d 80 	movl   $0x802d6d,0x10(%esp)
  8007ce:	00 
  8007cf:	c7 44 24 14 03 00 00 	movl   $0x3,0x14(%esp)
  8007d6:	00 
  8007d7:	e9 41 ff ff ff       	jmp    80071d <go.sys.Sprint+0x6d>
	case int:
  8007dc:	83 ec 04             	sub    $0x4,%esp
  8007df:	68 20 2c 80 00       	push   $0x802c20
  8007e4:	ff 74 24 34          	pushl  0x34(%esp)
  8007e8:	68 80 2f 80 00       	push   $0x802f80
  8007ed:	e8 35 fc ff ff       	call   800427 <__go_check_interface_type>
		return Itoa(f)
  8007f2:	83 c4 08             	add    $0x8,%esp
  8007f5:	ff 33                	pushl  (%ebx)
  8007f7:	8d 44 24 44          	lea    0x44(%esp),%eax
  8007fb:	50                   	push   %eax
  8007fc:	e8 51 fd ff ff       	call   800552 <go.sys.Itoa>
  800801:	8b 44 24 44          	mov    0x44(%esp),%eax
  800805:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  800809:	8b 44 24 48          	mov    0x48(%esp),%eax
  80080d:	89 44 24 20          	mov    %eax,0x20(%esp)
  800811:	83 c4 0c             	add    $0xc,%esp
  800814:	e9 04 ff ff ff       	jmp    80071d <go.sys.Sprint+0x6d>
	s := ""
  800819:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
  800820:	00 
  800821:	c7 44 24 1c 6c 2d 80 	movl   $0x802d6c,0x1c(%esp)
  800828:	00 
	return s
  800829:	8b 44 24 60          	mov    0x60(%esp),%eax
  80082d:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  800831:	89 38                	mov    %edi,(%eax)
  800833:	8b 7c 24 20          	mov    0x20(%esp),%edi
  800837:	89 78 04             	mov    %edi,0x4(%eax)
func Sprint(a ...interface{}) string {
  80083a:	83 c4 4c             	add    $0x4c,%esp
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5f                   	pop    %edi
  800840:	5d                   	pop    %ebp
  800841:	c2 04 00             	ret    $0x4

00800844 <go.sys.Print>:
func Print(a ...interface{}) {
  800844:	57                   	push   %edi
  800845:	56                   	push   %esi
  800846:	83 ec 14             	sub    $0x14,%esp
	s := Sprint(a...)
  800849:	8d 44 24 08          	lea    0x8(%esp),%eax
  80084d:	83 ec 0c             	sub    $0xc,%esp
  800850:	b9 03 00 00 00       	mov    $0x3,%ecx
  800855:	89 e7                	mov    %esp,%edi
  800857:	8d 74 24 2c          	lea    0x2c(%esp),%esi
  80085b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80085d:	50                   	push   %eax
  80085e:	e8 4d fe ff ff       	call   8006b0 <go.sys.Sprint>
	sys_cputs(s)
  800863:	83 c4 04             	add    $0x4,%esp
  800866:	ff 74 24 14          	pushl  0x14(%esp)
  80086a:	ff 74 24 14          	pushl  0x14(%esp)
  80086e:	e8 11 0d 00 00       	call   801584 <sys_cputs>
func Print(a ...interface{}) {
  800873:	83 c4 24             	add    $0x24,%esp
  800876:	5e                   	pop    %esi
  800877:	5f                   	pop    %edi
  800878:	c3                   	ret    

00800879 <go.sys.Println>:
func Println(a ...interface{}) {
  800879:	57                   	push   %edi
  80087a:	56                   	push   %esi
  80087b:	53                   	push   %ebx
  80087c:	83 ec 18             	sub    $0x18,%esp
	Print(append(a, "\n")...)
  80087f:	6a 08                	push   $0x8
  800881:	68 80 2b 80 00       	push   $0x802b80
  800886:	e8 d3 f9 ff ff       	call   80025e <__go_new>
  80088b:	89 c6                	mov    %eax,%esi
  80088d:	83 c4 08             	add    $0x8,%esp
  800890:	6a 08                	push   $0x8
  800892:	68 a0 2a 80 00       	push   $0x802aa0
  800897:	e8 c2 f9 ff ff       	call   80025e <__go_new>
  80089c:	c7 00 71 2d 80 00    	movl   $0x802d71,(%eax)
  8008a2:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  8008a9:	c7 06 a0 2a 80 00    	movl   $0x802aa0,(%esi)
  8008af:	89 46 04             	mov    %eax,0x4(%esi)
  8008b2:	8d 5c 24 14          	lea    0x14(%esp),%ebx
  8008b6:	83 c4 0c             	add    $0xc,%esp
  8008b9:	6a 08                	push   $0x8
  8008bb:	6a 01                	push   $0x1
  8008bd:	56                   	push   %esi
  8008be:	83 ec 0c             	sub    $0xc,%esp
  8008c1:	b9 03 00 00 00       	mov    $0x3,%ecx
  8008c6:	89 e7                	mov    %esp,%edi
  8008c8:	8d 74 24 3c          	lea    0x3c(%esp),%esi
  8008cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008ce:	53                   	push   %ebx
  8008cf:	e8 58 fb ff ff       	call   80042c <__go_append>
  8008d4:	83 c4 0c             	add    $0xc,%esp
  8008d7:	b9 03 00 00 00       	mov    $0x3,%ecx
  8008dc:	89 e7                	mov    %esp,%edi
  8008de:	89 de                	mov    %ebx,%esi
  8008e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008e2:	e8 5d ff ff ff       	call   800844 <go.sys.Print>
func Println(a ...interface{}) {
  8008e7:	83 c4 20             	add    $0x20,%esp
  8008ea:	5b                   	pop    %ebx
  8008eb:	5e                   	pop    %esi
  8008ec:	5f                   	pop    %edi
  8008ed:	c3                   	ret    

008008ee <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	56                   	push   %esi
  8008f2:	53                   	push   %ebx
  8008f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008f6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8008f9:	e8 04 0d 00 00       	call   801602 <sys_getenvid>
  8008fe:	25 ff 03 00 00       	and    $0x3ff,%eax
  800903:	89 c2                	mov    %eax,%edx
  800905:	c1 e2 05             	shl    $0x5,%edx
  800908:	29 c2                	sub    %eax,%edx
  80090a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800911:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800916:	85 db                	test   %ebx,%ebx
  800918:	7e 07                	jle    800921 <libmain+0x33>
		binaryname = argv[0];
  80091a:	8b 06                	mov    (%esi),%eax
  80091c:	a3 10 40 80 00       	mov    %eax,0x804010

	// call user main routine
	umain(argc, argv);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	56                   	push   %esi
  800925:	53                   	push   %ebx
  800926:	e8 c6 f8 ff ff       	call   8001f1 <umain>

	// exit gracefully
	exit();
  80092b:	e8 0a 00 00 00       	call   80093a <exit>
}
  800930:	83 c4 10             	add    $0x10,%esp
  800933:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800936:	5b                   	pop    %ebx
  800937:	5e                   	pop    %esi
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800940:	e8 65 11 00 00       	call   801aaa <close_all>
	sys_env_destroy(0);
  800945:	83 ec 0c             	sub    $0xc,%esp
  800948:	6a 00                	push   $0x0
  80094a:	e8 72 0c 00 00       	call   8015c1 <sys_env_destroy>
}
  80094f:	83 c4 10             	add    $0x10,%esp
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <free>:
	return v;
}

void
free(void *v)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	53                   	push   %ebx
  800958:	83 ec 04             	sub    $0x4,%esp
  80095b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  80095e:	85 db                	test   %ebx,%ebx
  800960:	0f 84 8b 00 00 00    	je     8009f1 <free+0x9d>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  800966:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  80096c:	76 5c                	jbe    8009ca <free+0x76>
  80096e:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  800974:	77 54                	ja     8009ca <free+0x76>

	c = ROUNDDOWN(v, PGSIZE);
  800976:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  80097c:	89 d8                	mov    %ebx,%eax
  80097e:	c1 e8 0c             	shr    $0xc,%eax
  800981:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800988:	f6 c4 02             	test   $0x2,%ah
  80098b:	74 53                	je     8009e0 <free+0x8c>
		sys_page_unmap(0, c);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	53                   	push   %ebx
  800991:	6a 00                	push   $0x0
  800993:	e8 0e 0d 00 00       	call   8016a6 <sys_page_unmap>
		c += PGSIZE;
  800998:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  8009a7:	76 08                	jbe    8009b1 <free+0x5d>
  8009a9:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  8009af:	76 cb                	jbe    80097c <free+0x28>
  8009b1:	68 af 30 80 00       	push   $0x8030af
  8009b6:	68 da 2c 80 00       	push   $0x802cda
  8009bb:	68 83 00 00 00       	push   $0x83
  8009c0:	68 a2 30 80 00       	push   $0x8030a2
  8009c5:	e8 2f 02 00 00       	call   800bf9 <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8009ca:	68 74 30 80 00       	push   $0x803074
  8009cf:	68 da 2c 80 00       	push   $0x802cda
  8009d4:	6a 7c                	push   $0x7c
  8009d6:	68 a2 30 80 00       	push   $0x8030a2
  8009db:	e8 19 02 00 00       	call   800bf9 <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  8009e0:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  8009e6:	48                   	dec    %eax
  8009e7:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  8009ed:	85 c0                	test   %eax,%eax
  8009ef:	74 05                	je     8009f6 <free+0xa2>
		sys_page_unmap(0, c);
}
  8009f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    
		sys_page_unmap(0, c);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	53                   	push   %ebx
  8009fa:	6a 00                	push   $0x0
  8009fc:	e8 a5 0c 00 00       	call   8016a6 <sys_page_unmap>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	eb eb                	jmp    8009f1 <free+0x9d>

00800a06 <malloc>:
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	57                   	push   %edi
  800a0a:	56                   	push   %esi
  800a0b:	53                   	push   %ebx
  800a0c:	83 ec 2c             	sub    $0x2c,%esp
	if (mptr == 0)
  800a0f:	a1 00 50 80 00       	mov    0x805000,%eax
  800a14:	85 c0                	test   %eax,%eax
  800a16:	74 73                	je     800a8b <malloc+0x85>
	n = ROUNDUP(n, 4);
  800a18:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1b:	83 c7 03             	add    $0x3,%edi
  800a1e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800a21:	83 e7 fc             	and    $0xfffffffc,%edi
  800a24:	89 7d dc             	mov    %edi,-0x24(%ebp)
	if (n >= MAXMALLOC)
  800a27:	81 ff ff ff 0f 00    	cmp    $0xfffff,%edi
  800a2d:	0f 87 bc 01 00 00    	ja     800bef <malloc+0x1e9>
	if ((uintptr_t) mptr % PGSIZE){
  800a33:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800a38:	74 30                	je     800a6a <malloc+0x64>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  800a3a:	89 c1                	mov    %eax,%ecx
  800a3c:	c1 e9 0c             	shr    $0xc,%ecx
  800a3f:	8d 54 38 03          	lea    0x3(%eax,%edi,1),%edx
  800a43:	c1 ea 0c             	shr    $0xc,%edx
  800a46:	39 d1                	cmp    %edx,%ecx
  800a48:	74 6b                	je     800ab5 <malloc+0xaf>
		free(mptr);	/* drop reference to this page */
  800a4a:	83 ec 0c             	sub    $0xc,%esp
  800a4d:	50                   	push   %eax
  800a4e:	e8 01 ff ff ff       	call   800954 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  800a53:	a1 00 50 80 00       	mov    0x805000,%eax
  800a58:	05 00 10 00 00       	add    $0x1000,%eax
  800a5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a62:	a3 00 50 80 00       	mov    %eax,0x805000
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	8b 35 00 50 80 00    	mov    0x805000,%esi
{
  800a70:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  800a77:	bf 00 00 00 00       	mov    $0x0,%edi
		if (isfree(mptr, n + 4))
  800a7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a7f:	8d 58 04             	lea    0x4(%eax),%ebx
  800a82:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  800a86:	e9 8d 00 00 00       	jmp    800b18 <malloc+0x112>
		mptr = mbegin;
  800a8b:	c7 05 00 50 80 00 00 	movl   $0x8000000,0x805000
  800a92:	00 00 08 
	n = ROUNDUP(n, 4);
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	83 c0 03             	add    $0x3,%eax
  800a9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800a9e:	83 e0 fc             	and    $0xfffffffc,%eax
  800aa1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (n >= MAXMALLOC)
  800aa4:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  800aa9:	76 bf                	jbe    800a6a <malloc+0x64>
		return 0;
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab0:	e9 8b 00 00 00       	jmp    800b40 <malloc+0x13a>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  800ab5:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800abb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			(*ref)++;
  800ac1:	ff 42 fc             	incl   -0x4(%edx)
			mptr += n;
  800ac4:	89 fa                	mov    %edi,%edx
  800ac6:	01 c2                	add    %eax,%edx
  800ac8:	89 15 00 50 80 00    	mov    %edx,0x805000
			return v;
  800ace:	eb 70                	jmp    800b40 <malloc+0x13a>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  800ad0:	05 00 10 00 00       	add    $0x1000,%eax
  800ad5:	39 c1                	cmp    %eax,%ecx
  800ad7:	0f 86 92 00 00 00    	jbe    800b6f <malloc+0x169>
		if (va >= (uintptr_t) mend
  800add:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  800ae2:	77 22                	ja     800b06 <malloc+0x100>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  800ae4:	89 c2                	mov    %eax,%edx
  800ae6:	c1 ea 16             	shr    $0x16,%edx
  800ae9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800af0:	f6 c2 01             	test   $0x1,%dl
  800af3:	74 db                	je     800ad0 <malloc+0xca>
  800af5:	89 c2                	mov    %eax,%edx
  800af7:	c1 ea 0c             	shr    $0xc,%edx
  800afa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800b01:	f6 c2 01             	test   $0x1,%dl
  800b04:	74 ca                	je     800ad0 <malloc+0xca>
  800b06:	81 c6 00 10 00 00    	add    $0x1000,%esi
  800b0c:	0f b6 7d e3          	movzbl -0x1d(%ebp),%edi
		if (mptr == mend) {
  800b10:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
  800b16:	74 0a                	je     800b22 <malloc+0x11c>
  800b18:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  800b1b:	89 f0                	mov    %esi,%eax
  800b1d:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
  800b20:	eb b3                	jmp    800ad5 <malloc+0xcf>
			mptr = mbegin;
  800b22:	be 00 00 00 08       	mov    $0x8000000,%esi
  800b27:	bf 01 00 00 00       	mov    $0x1,%edi
			if (++nwrap == 2)
  800b2c:	ff 4d d8             	decl   -0x28(%ebp)
  800b2f:	75 e7                	jne    800b18 <malloc+0x112>
  800b31:	c7 05 00 50 80 00 00 	movl   $0x8000000,0x805000
  800b38:	00 00 08 
				return 0;	/* out of address space */
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    
				sys_page_unmap(0, mptr + i);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	89 f0                	mov    %esi,%eax
  800b4d:	03 05 00 50 80 00    	add    0x805000,%eax
  800b53:	50                   	push   %eax
  800b54:	6a 00                	push   $0x0
  800b56:	e8 4b 0b 00 00       	call   8016a6 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  800b5b:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	85 f6                	test   %esi,%esi
  800b66:	79 e0                	jns    800b48 <malloc+0x142>
			return 0;	/* out of physical memory */
  800b68:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6d:	eb d1                	jmp    800b40 <malloc+0x13a>
  800b6f:	89 f8                	mov    %edi,%eax
  800b71:	84 c0                	test   %al,%al
  800b73:	75 3c                	jne    800bb1 <malloc+0x1ab>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  800b75:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < n + 4; i += PGSIZE){
  800b7a:	89 f2                	mov    %esi,%edx
  800b7c:	39 f3                	cmp    %esi,%ebx
  800b7e:	76 3b                	jbe    800bbb <malloc+0x1b5>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  800b80:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
  800b86:	39 fb                	cmp    %edi,%ebx
  800b88:	0f 97 c0             	seta   %al
  800b8b:	0f b6 c0             	movzbl %al,%eax
  800b8e:	c1 e0 09             	shl    $0x9,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  800b91:	83 ec 04             	sub    $0x4,%esp
  800b94:	83 c8 07             	or     $0x7,%eax
  800b97:	50                   	push   %eax
  800b98:	03 15 00 50 80 00    	add    0x805000,%edx
  800b9e:	52                   	push   %edx
  800b9f:	6a 00                	push   $0x0
  800ba1:	e8 7b 0a 00 00       	call   801621 <sys_page_alloc>
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	85 c0                	test   %eax,%eax
  800bab:	78 b7                	js     800b64 <malloc+0x15e>
	for (i = 0; i < n + 4; i += PGSIZE){
  800bad:	89 fe                	mov    %edi,%esi
  800baf:	eb c9                	jmp    800b7a <malloc+0x174>
  800bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bb4:	a3 00 50 80 00       	mov    %eax,0x805000
  800bb9:	eb ba                	jmp    800b75 <malloc+0x16f>
	ref = (uint32_t*) (mptr + i - 4);
  800bbb:	a1 00 50 80 00       	mov    0x805000,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  800bc0:	c7 44 30 fc 02 00 00 	movl   $0x2,-0x4(%eax,%esi,1)
  800bc7:	00 
	mptr += n;
  800bc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800bcb:	01 c2                	add    %eax,%edx
	if (n % PGSIZE == 0)
  800bcd:	f7 45 d4 fc 0f 00 00 	testl  $0xffc,-0x2c(%ebp)
  800bd4:	75 0e                	jne    800be4 <malloc+0x1de>
		mptr += 4;
  800bd6:	83 c2 04             	add    $0x4,%edx
  800bd9:	89 15 00 50 80 00    	mov    %edx,0x805000
  800bdf:	e9 5c ff ff ff       	jmp    800b40 <malloc+0x13a>
	mptr += n;
  800be4:	89 15 00 50 80 00    	mov    %edx,0x805000
  800bea:	e9 51 ff ff ff       	jmp    800b40 <malloc+0x13a>
		return 0;
  800bef:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf4:	e9 47 ff ff ff       	jmp    800b40 <malloc+0x13a>

00800bf9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800c05:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800c08:	8b 1d 10 40 80 00    	mov    0x804010,%ebx
  800c0e:	e8 ef 09 00 00       	call   801602 <sys_getenvid>
  800c13:	83 ec 04             	sub    $0x4,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	ff 75 08             	pushl  0x8(%ebp)
  800c1c:	53                   	push   %ebx
  800c1d:	50                   	push   %eax
  800c1e:	68 c8 30 80 00       	push   $0x8030c8
  800c23:	68 00 01 00 00       	push   $0x100
  800c28:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800c2e:	56                   	push   %esi
  800c2f:	e8 eb 05 00 00       	call   80121f <snprintf>
  800c34:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800c36:	83 c4 20             	add    $0x20,%esp
  800c39:	57                   	push   %edi
  800c3a:	ff 75 10             	pushl  0x10(%ebp)
  800c3d:	bf 00 01 00 00       	mov    $0x100,%edi
  800c42:	89 f8                	mov    %edi,%eax
  800c44:	29 d8                	sub    %ebx,%eax
  800c46:	50                   	push   %eax
  800c47:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800c4a:	50                   	push   %eax
  800c4b:	e8 7a 05 00 00       	call   8011ca <vsnprintf>
  800c50:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800c52:	83 c4 0c             	add    $0xc,%esp
  800c55:	68 ce 34 80 00       	push   $0x8034ce
  800c5a:	29 df                	sub    %ebx,%edi
  800c5c:	57                   	push   %edi
  800c5d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800c60:	50                   	push   %eax
  800c61:	e8 b9 05 00 00       	call   80121f <snprintf>
	sys_cputs(buf, r);
  800c66:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800c69:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800c6b:	53                   	push   %ebx
  800c6c:	56                   	push   %esi
  800c6d:	e8 12 09 00 00       	call   801584 <sys_cputs>
  800c72:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c75:	cc                   	int3   
  800c76:	eb fd                	jmp    800c75 <_panic+0x7c>

00800c78 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
  800c7e:	83 ec 1c             	sub    $0x1c,%esp
  800c81:	89 c7                	mov    %eax,%edi
  800c83:	89 d6                	mov    %edx,%esi
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c8e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800c9c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800c9f:	39 d3                	cmp    %edx,%ebx
  800ca1:	72 05                	jb     800ca8 <printnum+0x30>
  800ca3:	39 45 10             	cmp    %eax,0x10(%ebp)
  800ca6:	77 78                	ja     800d20 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ca8:	83 ec 0c             	sub    $0xc,%esp
  800cab:	ff 75 18             	pushl  0x18(%ebp)
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cb4:	53                   	push   %ebx
  800cb5:	ff 75 10             	pushl  0x10(%ebp)
  800cb8:	83 ec 08             	sub    $0x8,%esp
  800cbb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cbe:	ff 75 e0             	pushl  -0x20(%ebp)
  800cc1:	ff 75 dc             	pushl  -0x24(%ebp)
  800cc4:	ff 75 d8             	pushl  -0x28(%ebp)
  800cc7:	e8 28 1b 00 00       	call   8027f4 <__udivdi3>
  800ccc:	83 c4 18             	add    $0x18,%esp
  800ccf:	52                   	push   %edx
  800cd0:	50                   	push   %eax
  800cd1:	89 f2                	mov    %esi,%edx
  800cd3:	89 f8                	mov    %edi,%eax
  800cd5:	e8 9e ff ff ff       	call   800c78 <printnum>
  800cda:	83 c4 20             	add    $0x20,%esp
  800cdd:	eb 11                	jmp    800cf0 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	56                   	push   %esi
  800ce3:	ff 75 18             	pushl  0x18(%ebp)
  800ce6:	ff d7                	call   *%edi
  800ce8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800ceb:	4b                   	dec    %ebx
  800cec:	85 db                	test   %ebx,%ebx
  800cee:	7f ef                	jg     800cdf <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	56                   	push   %esi
  800cf4:	83 ec 04             	sub    $0x4,%esp
  800cf7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfa:	ff 75 e0             	pushl  -0x20(%ebp)
  800cfd:	ff 75 dc             	pushl  -0x24(%ebp)
  800d00:	ff 75 d8             	pushl  -0x28(%ebp)
  800d03:	e8 fc 1b 00 00       	call   802904 <__umoddi3>
  800d08:	83 c4 14             	add    $0x14,%esp
  800d0b:	0f be 80 eb 30 80 00 	movsbl 0x8030eb(%eax),%eax
  800d12:	50                   	push   %eax
  800d13:	ff d7                	call   *%edi
}
  800d15:	83 c4 10             	add    $0x10,%esp
  800d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    
  800d20:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800d23:	eb c6                	jmp    800ceb <printnum+0x73>

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800d2b:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800d2e:	8b 10                	mov    (%eax),%edx
  800d30:	3b 50 04             	cmp    0x4(%eax),%edx
  800d33:	73 0a                	jae    800d3f <sprintputch+0x1a>
		*b->buf++ = ch;
  800d35:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d38:	89 08                	mov    %ecx,(%eax)
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	88 02                	mov    %al,(%edx)
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <printfmt>:
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800d47:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800d4a:	50                   	push   %eax
  800d4b:	ff 75 10             	pushl  0x10(%ebp)
  800d4e:	ff 75 0c             	pushl  0xc(%ebp)
  800d51:	ff 75 08             	pushl  0x8(%ebp)
  800d54:	e8 05 00 00 00       	call   800d5e <vprintfmt>
}
  800d59:	83 c4 10             	add    $0x10,%esp
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <vprintfmt>:
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
  800d64:	83 ec 2c             	sub    $0x2c,%esp
  800d67:	8b 75 08             	mov    0x8(%ebp),%esi
  800d6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d6d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800d70:	e9 ae 03 00 00       	jmp    801123 <vprintfmt+0x3c5>
  800d75:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800d79:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800d80:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800d87:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d93:	8d 47 01             	lea    0x1(%edi),%eax
  800d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d99:	8a 17                	mov    (%edi),%dl
  800d9b:	8d 42 dd             	lea    -0x23(%edx),%eax
  800d9e:	3c 55                	cmp    $0x55,%al
  800da0:	0f 87 fe 03 00 00    	ja     8011a4 <vprintfmt+0x446>
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	ff 24 85 20 32 80 00 	jmp    *0x803220(,%eax,4)
  800db0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800db3:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800db7:	eb da                	jmp    800d93 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800db9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800dbc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800dc0:	eb d1                	jmp    800d93 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800dc2:	0f b6 d2             	movzbl %dl,%edx
  800dc5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800dd0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800dd3:	01 c0                	add    %eax,%eax
  800dd5:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800dd9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800ddc:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800ddf:	83 f9 09             	cmp    $0x9,%ecx
  800de2:	77 52                	ja     800e36 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800de4:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800de5:	eb e9                	jmp    800dd0 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800de7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800def:	8b 45 14             	mov    0x14(%ebp),%eax
  800df2:	8d 40 04             	lea    0x4(%eax),%eax
  800df5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800df8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800dfb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dff:	79 92                	jns    800d93 <vprintfmt+0x35>
				width = precision, precision = -1;
  800e01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e04:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e07:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800e0e:	eb 83                	jmp    800d93 <vprintfmt+0x35>
  800e10:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e14:	78 08                	js     800e1e <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800e16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800e19:	e9 75 ff ff ff       	jmp    800d93 <vprintfmt+0x35>
  800e1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e25:	eb ef                	jmp    800e16 <vprintfmt+0xb8>
  800e27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800e2a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800e31:	e9 5d ff ff ff       	jmp    800d93 <vprintfmt+0x35>
  800e36:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800e39:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e3c:	eb bd                	jmp    800dfb <vprintfmt+0x9d>
			lflag++;
  800e3e:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800e3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800e42:	e9 4c ff ff ff       	jmp    800d93 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800e47:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4a:	8d 78 04             	lea    0x4(%eax),%edi
  800e4d:	83 ec 08             	sub    $0x8,%esp
  800e50:	53                   	push   %ebx
  800e51:	ff 30                	pushl  (%eax)
  800e53:	ff d6                	call   *%esi
			break;
  800e55:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800e58:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800e5b:	e9 c0 02 00 00       	jmp    801120 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800e60:	8b 45 14             	mov    0x14(%ebp),%eax
  800e63:	8d 78 04             	lea    0x4(%eax),%edi
  800e66:	8b 00                	mov    (%eax),%eax
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	78 2a                	js     800e96 <vprintfmt+0x138>
  800e6c:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e6e:	83 f8 0f             	cmp    $0xf,%eax
  800e71:	7f 27                	jg     800e9a <vprintfmt+0x13c>
  800e73:	8b 04 85 80 33 80 00 	mov    0x803380(,%eax,4),%eax
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	74 1c                	je     800e9a <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800e7e:	50                   	push   %eax
  800e7f:	68 ec 2c 80 00       	push   $0x802cec
  800e84:	53                   	push   %ebx
  800e85:	56                   	push   %esi
  800e86:	e8 b6 fe ff ff       	call   800d41 <printfmt>
  800e8b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800e8e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800e91:	e9 8a 02 00 00       	jmp    801120 <vprintfmt+0x3c2>
  800e96:	f7 d8                	neg    %eax
  800e98:	eb d2                	jmp    800e6c <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800e9a:	52                   	push   %edx
  800e9b:	68 03 31 80 00       	push   $0x803103
  800ea0:	53                   	push   %ebx
  800ea1:	56                   	push   %esi
  800ea2:	e8 9a fe ff ff       	call   800d41 <printfmt>
  800ea7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800eaa:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800ead:	e9 6e 02 00 00       	jmp    801120 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800eb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb5:	83 c0 04             	add    $0x4,%eax
  800eb8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800ebb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebe:	8b 38                	mov    (%eax),%edi
  800ec0:	85 ff                	test   %edi,%edi
  800ec2:	74 39                	je     800efd <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800ec4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ec8:	0f 8e a9 00 00 00    	jle    800f77 <vprintfmt+0x219>
  800ece:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800ed2:	0f 84 a7 00 00 00    	je     800f7f <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	ff 75 d0             	pushl  -0x30(%ebp)
  800ede:	57                   	push   %edi
  800edf:	e8 6b 03 00 00       	call   80124f <strnlen>
  800ee4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ee7:	29 c1                	sub    %eax,%ecx
  800ee9:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800eec:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800eef:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800ef3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ef6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800ef9:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800efb:	eb 14                	jmp    800f11 <vprintfmt+0x1b3>
				p = "(null)";
  800efd:	bf fc 30 80 00       	mov    $0x8030fc,%edi
  800f02:	eb c0                	jmp    800ec4 <vprintfmt+0x166>
					putch(padc, putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	53                   	push   %ebx
  800f08:	ff 75 e0             	pushl  -0x20(%ebp)
  800f0b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800f0d:	4f                   	dec    %edi
  800f0e:	83 c4 10             	add    $0x10,%esp
  800f11:	85 ff                	test   %edi,%edi
  800f13:	7f ef                	jg     800f04 <vprintfmt+0x1a6>
  800f15:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800f18:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800f1b:	89 c8                	mov    %ecx,%eax
  800f1d:	85 c9                	test   %ecx,%ecx
  800f1f:	78 10                	js     800f31 <vprintfmt+0x1d3>
  800f21:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800f24:	29 c1                	sub    %eax,%ecx
  800f26:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800f29:	89 75 08             	mov    %esi,0x8(%ebp)
  800f2c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800f2f:	eb 15                	jmp    800f46 <vprintfmt+0x1e8>
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
  800f36:	eb e9                	jmp    800f21 <vprintfmt+0x1c3>
					putch(ch, putdat);
  800f38:	83 ec 08             	sub    $0x8,%esp
  800f3b:	53                   	push   %ebx
  800f3c:	52                   	push   %edx
  800f3d:	ff 55 08             	call   *0x8(%ebp)
  800f40:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f43:	ff 4d e0             	decl   -0x20(%ebp)
  800f46:	47                   	inc    %edi
  800f47:	8a 47 ff             	mov    -0x1(%edi),%al
  800f4a:	0f be d0             	movsbl %al,%edx
  800f4d:	85 d2                	test   %edx,%edx
  800f4f:	74 59                	je     800faa <vprintfmt+0x24c>
  800f51:	85 f6                	test   %esi,%esi
  800f53:	78 03                	js     800f58 <vprintfmt+0x1fa>
  800f55:	4e                   	dec    %esi
  800f56:	78 2f                	js     800f87 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800f58:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800f5c:	74 da                	je     800f38 <vprintfmt+0x1da>
  800f5e:	0f be c0             	movsbl %al,%eax
  800f61:	83 e8 20             	sub    $0x20,%eax
  800f64:	83 f8 5e             	cmp    $0x5e,%eax
  800f67:	76 cf                	jbe    800f38 <vprintfmt+0x1da>
					putch('?', putdat);
  800f69:	83 ec 08             	sub    $0x8,%esp
  800f6c:	53                   	push   %ebx
  800f6d:	6a 3f                	push   $0x3f
  800f6f:	ff 55 08             	call   *0x8(%ebp)
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	eb cc                	jmp    800f43 <vprintfmt+0x1e5>
  800f77:	89 75 08             	mov    %esi,0x8(%ebp)
  800f7a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800f7d:	eb c7                	jmp    800f46 <vprintfmt+0x1e8>
  800f7f:	89 75 08             	mov    %esi,0x8(%ebp)
  800f82:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800f85:	eb bf                	jmp    800f46 <vprintfmt+0x1e8>
  800f87:	8b 75 08             	mov    0x8(%ebp),%esi
  800f8a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800f8d:	eb 0c                	jmp    800f9b <vprintfmt+0x23d>
				putch(' ', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	53                   	push   %ebx
  800f93:	6a 20                	push   $0x20
  800f95:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800f97:	4f                   	dec    %edi
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	85 ff                	test   %edi,%edi
  800f9d:	7f f0                	jg     800f8f <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800f9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800fa2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fa5:	e9 76 01 00 00       	jmp    801120 <vprintfmt+0x3c2>
  800faa:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800fad:	8b 75 08             	mov    0x8(%ebp),%esi
  800fb0:	eb e9                	jmp    800f9b <vprintfmt+0x23d>
	if (lflag >= 2)
  800fb2:	83 f9 01             	cmp    $0x1,%ecx
  800fb5:	7f 1f                	jg     800fd6 <vprintfmt+0x278>
	else if (lflag)
  800fb7:	85 c9                	test   %ecx,%ecx
  800fb9:	75 48                	jne    801003 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800fbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbe:	8b 00                	mov    (%eax),%eax
  800fc0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fc3:	89 c1                	mov    %eax,%ecx
  800fc5:	c1 f9 1f             	sar    $0x1f,%ecx
  800fc8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800fcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fce:	8d 40 04             	lea    0x4(%eax),%eax
  800fd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd4:	eb 17                	jmp    800fed <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800fd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd9:	8b 50 04             	mov    0x4(%eax),%edx
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800fe1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800fe4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe7:	8d 40 08             	lea    0x8(%eax),%eax
  800fea:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800fed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ff0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800ff3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ff7:	78 25                	js     80101e <vprintfmt+0x2c0>
			base = 10;
  800ff9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffe:	e9 03 01 00 00       	jmp    801106 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  801003:	8b 45 14             	mov    0x14(%ebp),%eax
  801006:	8b 00                	mov    (%eax),%eax
  801008:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80100b:	89 c1                	mov    %eax,%ecx
  80100d:	c1 f9 1f             	sar    $0x1f,%ecx
  801010:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801013:	8b 45 14             	mov    0x14(%ebp),%eax
  801016:	8d 40 04             	lea    0x4(%eax),%eax
  801019:	89 45 14             	mov    %eax,0x14(%ebp)
  80101c:	eb cf                	jmp    800fed <vprintfmt+0x28f>
				putch('-', putdat);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	53                   	push   %ebx
  801022:	6a 2d                	push   $0x2d
  801024:	ff d6                	call   *%esi
				num = -(long long) num;
  801026:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801029:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80102c:	f7 da                	neg    %edx
  80102e:	83 d1 00             	adc    $0x0,%ecx
  801031:	f7 d9                	neg    %ecx
  801033:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801036:	b8 0a 00 00 00       	mov    $0xa,%eax
  80103b:	e9 c6 00 00 00       	jmp    801106 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801040:	83 f9 01             	cmp    $0x1,%ecx
  801043:	7f 1e                	jg     801063 <vprintfmt+0x305>
	else if (lflag)
  801045:	85 c9                	test   %ecx,%ecx
  801047:	75 32                	jne    80107b <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  801049:	8b 45 14             	mov    0x14(%ebp),%eax
  80104c:	8b 10                	mov    (%eax),%edx
  80104e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801053:	8d 40 04             	lea    0x4(%eax),%eax
  801056:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801059:	b8 0a 00 00 00       	mov    $0xa,%eax
  80105e:	e9 a3 00 00 00       	jmp    801106 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801063:	8b 45 14             	mov    0x14(%ebp),%eax
  801066:	8b 10                	mov    (%eax),%edx
  801068:	8b 48 04             	mov    0x4(%eax),%ecx
  80106b:	8d 40 08             	lea    0x8(%eax),%eax
  80106e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801071:	b8 0a 00 00 00       	mov    $0xa,%eax
  801076:	e9 8b 00 00 00       	jmp    801106 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80107b:	8b 45 14             	mov    0x14(%ebp),%eax
  80107e:	8b 10                	mov    (%eax),%edx
  801080:	b9 00 00 00 00       	mov    $0x0,%ecx
  801085:	8d 40 04             	lea    0x4(%eax),%eax
  801088:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80108b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801090:	eb 74                	jmp    801106 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801092:	83 f9 01             	cmp    $0x1,%ecx
  801095:	7f 1b                	jg     8010b2 <vprintfmt+0x354>
	else if (lflag)
  801097:	85 c9                	test   %ecx,%ecx
  801099:	75 2c                	jne    8010c7 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80109b:	8b 45 14             	mov    0x14(%ebp),%eax
  80109e:	8b 10                	mov    (%eax),%edx
  8010a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a5:	8d 40 04             	lea    0x4(%eax),%eax
  8010a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8010ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8010b0:	eb 54                	jmp    801106 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8010b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b5:	8b 10                	mov    (%eax),%edx
  8010b7:	8b 48 04             	mov    0x4(%eax),%ecx
  8010ba:	8d 40 08             	lea    0x8(%eax),%eax
  8010bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8010c0:	b8 08 00 00 00       	mov    $0x8,%eax
  8010c5:	eb 3f                	jmp    801106 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8010c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ca:	8b 10                	mov    (%eax),%edx
  8010cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d1:	8d 40 04             	lea    0x4(%eax),%eax
  8010d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8010d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8010dc:	eb 28                	jmp    801106 <vprintfmt+0x3a8>
			putch('0', putdat);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	53                   	push   %ebx
  8010e2:	6a 30                	push   $0x30
  8010e4:	ff d6                	call   *%esi
			putch('x', putdat);
  8010e6:	83 c4 08             	add    $0x8,%esp
  8010e9:	53                   	push   %ebx
  8010ea:	6a 78                	push   $0x78
  8010ec:	ff d6                	call   *%esi
			num = (unsigned long long)
  8010ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f1:	8b 10                	mov    (%eax),%edx
  8010f3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8010f8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8010fb:	8d 40 04             	lea    0x4(%eax),%eax
  8010fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801101:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80110d:	57                   	push   %edi
  80110e:	ff 75 e0             	pushl  -0x20(%ebp)
  801111:	50                   	push   %eax
  801112:	51                   	push   %ecx
  801113:	52                   	push   %edx
  801114:	89 da                	mov    %ebx,%edx
  801116:	89 f0                	mov    %esi,%eax
  801118:	e8 5b fb ff ff       	call   800c78 <printnum>
			break;
  80111d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801120:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801123:	47                   	inc    %edi
  801124:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801128:	83 f8 25             	cmp    $0x25,%eax
  80112b:	0f 84 44 fc ff ff    	je     800d75 <vprintfmt+0x17>
			if (ch == '\0')
  801131:	85 c0                	test   %eax,%eax
  801133:	0f 84 89 00 00 00    	je     8011c2 <vprintfmt+0x464>
			putch(ch, putdat);
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	53                   	push   %ebx
  80113d:	50                   	push   %eax
  80113e:	ff d6                	call   *%esi
  801140:	83 c4 10             	add    $0x10,%esp
  801143:	eb de                	jmp    801123 <vprintfmt+0x3c5>
	if (lflag >= 2)
  801145:	83 f9 01             	cmp    $0x1,%ecx
  801148:	7f 1b                	jg     801165 <vprintfmt+0x407>
	else if (lflag)
  80114a:	85 c9                	test   %ecx,%ecx
  80114c:	75 2c                	jne    80117a <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80114e:	8b 45 14             	mov    0x14(%ebp),%eax
  801151:	8b 10                	mov    (%eax),%edx
  801153:	b9 00 00 00 00       	mov    $0x0,%ecx
  801158:	8d 40 04             	lea    0x4(%eax),%eax
  80115b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80115e:	b8 10 00 00 00       	mov    $0x10,%eax
  801163:	eb a1                	jmp    801106 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801165:	8b 45 14             	mov    0x14(%ebp),%eax
  801168:	8b 10                	mov    (%eax),%edx
  80116a:	8b 48 04             	mov    0x4(%eax),%ecx
  80116d:	8d 40 08             	lea    0x8(%eax),%eax
  801170:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801173:	b8 10 00 00 00       	mov    $0x10,%eax
  801178:	eb 8c                	jmp    801106 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80117a:	8b 45 14             	mov    0x14(%ebp),%eax
  80117d:	8b 10                	mov    (%eax),%edx
  80117f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801184:	8d 40 04             	lea    0x4(%eax),%eax
  801187:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80118a:	b8 10 00 00 00       	mov    $0x10,%eax
  80118f:	e9 72 ff ff ff       	jmp    801106 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	53                   	push   %ebx
  801198:	6a 25                	push   $0x25
  80119a:	ff d6                	call   *%esi
			break;
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	e9 7c ff ff ff       	jmp    801120 <vprintfmt+0x3c2>
			putch('%', putdat);
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	53                   	push   %ebx
  8011a8:	6a 25                	push   $0x25
  8011aa:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011ac:	83 c4 10             	add    $0x10,%esp
  8011af:	89 f8                	mov    %edi,%eax
  8011b1:	eb 01                	jmp    8011b4 <vprintfmt+0x456>
  8011b3:	48                   	dec    %eax
  8011b4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8011b8:	75 f9                	jne    8011b3 <vprintfmt+0x455>
  8011ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011bd:	e9 5e ff ff ff       	jmp    801120 <vprintfmt+0x3c2>
}
  8011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 18             	sub    $0x18,%esp
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011d9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8011dd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8011e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	74 26                	je     801211 <vsnprintf+0x47>
  8011eb:	85 d2                	test   %edx,%edx
  8011ed:	7e 29                	jle    801218 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011ef:	ff 75 14             	pushl  0x14(%ebp)
  8011f2:	ff 75 10             	pushl  0x10(%ebp)
  8011f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f8:	50                   	push   %eax
  8011f9:	68 25 0d 80 00       	push   $0x800d25
  8011fe:	e8 5b fb ff ff       	call   800d5e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801206:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120c:	83 c4 10             	add    $0x10,%esp
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    
		return -E_INVAL;
  801211:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801216:	eb f7                	jmp    80120f <vsnprintf+0x45>
  801218:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121d:	eb f0                	jmp    80120f <vsnprintf+0x45>

0080121f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801225:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801228:	50                   	push   %eax
  801229:	ff 75 10             	pushl  0x10(%ebp)
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 93 ff ff ff       	call   8011ca <vsnprintf>
	va_end(ap);

	return rc;
}
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	eb 01                	jmp    801247 <strlen+0xe>
		n++;
  801246:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  801247:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80124b:	75 f9                	jne    801246 <strlen+0xd>
	return n;
}
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    

0080124f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801255:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801258:	b8 00 00 00 00       	mov    $0x0,%eax
  80125d:	eb 01                	jmp    801260 <strnlen+0x11>
		n++;
  80125f:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801260:	39 d0                	cmp    %edx,%eax
  801262:	74 06                	je     80126a <strnlen+0x1b>
  801264:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801268:	75 f5                	jne    80125f <strnlen+0x10>
	return n;
}
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	53                   	push   %ebx
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801276:	89 c2                	mov    %eax,%edx
  801278:	42                   	inc    %edx
  801279:	41                   	inc    %ecx
  80127a:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80127d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801280:	84 db                	test   %bl,%bl
  801282:	75 f4                	jne    801278 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801284:	5b                   	pop    %ebx
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    

00801287 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	53                   	push   %ebx
  80128b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80128e:	53                   	push   %ebx
  80128f:	e8 a5 ff ff ff       	call   801239 <strlen>
  801294:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801297:	ff 75 0c             	pushl  0xc(%ebp)
  80129a:	01 d8                	add    %ebx,%eax
  80129c:	50                   	push   %eax
  80129d:	e8 ca ff ff ff       	call   80126c <strcpy>
	return dst;
}
  8012a2:	89 d8                	mov    %ebx,%eax
  8012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b4:	89 f3                	mov    %esi,%ebx
  8012b6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012b9:	89 f2                	mov    %esi,%edx
  8012bb:	eb 0c                	jmp    8012c9 <strncpy+0x20>
		*dst++ = *src;
  8012bd:	42                   	inc    %edx
  8012be:	8a 01                	mov    (%ecx),%al
  8012c0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012c3:	80 39 01             	cmpb   $0x1,(%ecx)
  8012c6:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8012c9:	39 da                	cmp    %ebx,%edx
  8012cb:	75 f0                	jne    8012bd <strncpy+0x14>
	}
	return ret;
}
  8012cd:	89 f0                	mov    %esi,%eax
  8012cf:	5b                   	pop    %ebx
  8012d0:	5e                   	pop    %esi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
  8012d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8012db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	74 20                	je     801305 <strlcpy+0x32>
  8012e5:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8012e9:	89 f0                	mov    %esi,%eax
  8012eb:	eb 05                	jmp    8012f2 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8012ed:	40                   	inc    %eax
  8012ee:	42                   	inc    %edx
  8012ef:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8012f2:	39 d8                	cmp    %ebx,%eax
  8012f4:	74 06                	je     8012fc <strlcpy+0x29>
  8012f6:	8a 0a                	mov    (%edx),%cl
  8012f8:	84 c9                	test   %cl,%cl
  8012fa:	75 f1                	jne    8012ed <strlcpy+0x1a>
		*dst = '\0';
  8012fc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012ff:	29 f0                	sub    %esi,%eax
}
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    
  801305:	89 f0                	mov    %esi,%eax
  801307:	eb f6                	jmp    8012ff <strlcpy+0x2c>

00801309 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801312:	eb 02                	jmp    801316 <strcmp+0xd>
		p++, q++;
  801314:	41                   	inc    %ecx
  801315:	42                   	inc    %edx
	while (*p && *p == *q)
  801316:	8a 01                	mov    (%ecx),%al
  801318:	84 c0                	test   %al,%al
  80131a:	74 04                	je     801320 <strcmp+0x17>
  80131c:	3a 02                	cmp    (%edx),%al
  80131e:	74 f4                	je     801314 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801320:	0f b6 c0             	movzbl %al,%eax
  801323:	0f b6 12             	movzbl (%edx),%edx
  801326:	29 d0                	sub    %edx,%eax
}
  801328:	5d                   	pop    %ebp
  801329:	c3                   	ret    

0080132a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	53                   	push   %ebx
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8b 55 0c             	mov    0xc(%ebp),%edx
  801334:	89 c3                	mov    %eax,%ebx
  801336:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801339:	eb 02                	jmp    80133d <strncmp+0x13>
		n--, p++, q++;
  80133b:	40                   	inc    %eax
  80133c:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  80133d:	39 d8                	cmp    %ebx,%eax
  80133f:	74 15                	je     801356 <strncmp+0x2c>
  801341:	8a 08                	mov    (%eax),%cl
  801343:	84 c9                	test   %cl,%cl
  801345:	74 04                	je     80134b <strncmp+0x21>
  801347:	3a 0a                	cmp    (%edx),%cl
  801349:	74 f0                	je     80133b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80134b:	0f b6 00             	movzbl (%eax),%eax
  80134e:	0f b6 12             	movzbl (%edx),%edx
  801351:	29 d0                	sub    %edx,%eax
}
  801353:	5b                   	pop    %ebx
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    
		return 0;
  801356:	b8 00 00 00 00       	mov    $0x0,%eax
  80135b:	eb f6                	jmp    801353 <strncmp+0x29>

0080135d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801366:	8a 10                	mov    (%eax),%dl
  801368:	84 d2                	test   %dl,%dl
  80136a:	74 07                	je     801373 <strchr+0x16>
		if (*s == c)
  80136c:	38 ca                	cmp    %cl,%dl
  80136e:	74 08                	je     801378 <strchr+0x1b>
	for (; *s; s++)
  801370:	40                   	inc    %eax
  801371:	eb f3                	jmp    801366 <strchr+0x9>
			return (char *) s;
	return 0;
  801373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801383:	8a 10                	mov    (%eax),%dl
  801385:	84 d2                	test   %dl,%dl
  801387:	74 07                	je     801390 <strfind+0x16>
		if (*s == c)
  801389:	38 ca                	cmp    %cl,%dl
  80138b:	74 03                	je     801390 <strfind+0x16>
	for (; *s; s++)
  80138d:	40                   	inc    %eax
  80138e:	eb f3                	jmp    801383 <strfind+0x9>
			break;
	return (char *) s;
}
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    

00801392 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	57                   	push   %edi
  801396:	56                   	push   %esi
  801397:	53                   	push   %ebx
  801398:	8b 7d 08             	mov    0x8(%ebp),%edi
  80139b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80139e:	85 c9                	test   %ecx,%ecx
  8013a0:	74 13                	je     8013b5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8013a2:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8013a8:	75 05                	jne    8013af <memset+0x1d>
  8013aa:	f6 c1 03             	test   $0x3,%cl
  8013ad:	74 0d                	je     8013bc <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	fc                   	cld    
  8013b3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8013b5:	89 f8                	mov    %edi,%eax
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5f                   	pop    %edi
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    
		c &= 0xFF;
  8013bc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013c0:	89 d3                	mov    %edx,%ebx
  8013c2:	c1 e3 08             	shl    $0x8,%ebx
  8013c5:	89 d0                	mov    %edx,%eax
  8013c7:	c1 e0 18             	shl    $0x18,%eax
  8013ca:	89 d6                	mov    %edx,%esi
  8013cc:	c1 e6 10             	shl    $0x10,%esi
  8013cf:	09 f0                	or     %esi,%eax
  8013d1:	09 c2                	or     %eax,%edx
  8013d3:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8013d5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8013d8:	89 d0                	mov    %edx,%eax
  8013da:	fc                   	cld    
  8013db:	f3 ab                	rep stos %eax,%es:(%edi)
  8013dd:	eb d6                	jmp    8013b5 <memset+0x23>

008013df <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	57                   	push   %edi
  8013e3:	56                   	push   %esi
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013ed:	39 c6                	cmp    %eax,%esi
  8013ef:	73 33                	jae    801424 <memmove+0x45>
  8013f1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8013f4:	39 d0                	cmp    %edx,%eax
  8013f6:	73 2c                	jae    801424 <memmove+0x45>
		s += n;
		d += n;
  8013f8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013fb:	89 d6                	mov    %edx,%esi
  8013fd:	09 fe                	or     %edi,%esi
  8013ff:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801405:	75 13                	jne    80141a <memmove+0x3b>
  801407:	f6 c1 03             	test   $0x3,%cl
  80140a:	75 0e                	jne    80141a <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80140c:	83 ef 04             	sub    $0x4,%edi
  80140f:	8d 72 fc             	lea    -0x4(%edx),%esi
  801412:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801415:	fd                   	std    
  801416:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801418:	eb 07                	jmp    801421 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80141a:	4f                   	dec    %edi
  80141b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80141e:	fd                   	std    
  80141f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801421:	fc                   	cld    
  801422:	eb 13                	jmp    801437 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801424:	89 f2                	mov    %esi,%edx
  801426:	09 c2                	or     %eax,%edx
  801428:	f6 c2 03             	test   $0x3,%dl
  80142b:	75 05                	jne    801432 <memmove+0x53>
  80142d:	f6 c1 03             	test   $0x3,%cl
  801430:	74 09                	je     80143b <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801432:	89 c7                	mov    %eax,%edi
  801434:	fc                   	cld    
  801435:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801437:	5e                   	pop    %esi
  801438:	5f                   	pop    %edi
  801439:	5d                   	pop    %ebp
  80143a:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80143b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80143e:	89 c7                	mov    %eax,%edi
  801440:	fc                   	cld    
  801441:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801443:	eb f2                	jmp    801437 <memmove+0x58>

00801445 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801448:	ff 75 10             	pushl  0x10(%ebp)
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	e8 89 ff ff ff       	call   8013df <memmove>
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	56                   	push   %esi
  80145c:	53                   	push   %ebx
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	89 c6                	mov    %eax,%esi
  801462:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801465:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801468:	39 f0                	cmp    %esi,%eax
  80146a:	74 16                	je     801482 <memcmp+0x2a>
		if (*s1 != *s2)
  80146c:	8a 08                	mov    (%eax),%cl
  80146e:	8a 1a                	mov    (%edx),%bl
  801470:	38 d9                	cmp    %bl,%cl
  801472:	75 04                	jne    801478 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801474:	40                   	inc    %eax
  801475:	42                   	inc    %edx
  801476:	eb f0                	jmp    801468 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801478:	0f b6 c1             	movzbl %cl,%eax
  80147b:	0f b6 db             	movzbl %bl,%ebx
  80147e:	29 d8                	sub    %ebx,%eax
  801480:	eb 05                	jmp    801487 <memcmp+0x2f>
	}

	return 0;
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801487:	5b                   	pop    %ebx
  801488:	5e                   	pop    %esi
  801489:	5d                   	pop    %ebp
  80148a:	c3                   	ret    

0080148b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801494:	89 c2                	mov    %eax,%edx
  801496:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801499:	39 d0                	cmp    %edx,%eax
  80149b:	73 07                	jae    8014a4 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  80149d:	38 08                	cmp    %cl,(%eax)
  80149f:	74 03                	je     8014a4 <memfind+0x19>
	for (; s < ends; s++)
  8014a1:	40                   	inc    %eax
  8014a2:	eb f5                	jmp    801499 <memfind+0xe>
			break;
	return (void *) s;
}
  8014a4:	5d                   	pop    %ebp
  8014a5:	c3                   	ret    

008014a6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	57                   	push   %edi
  8014aa:	56                   	push   %esi
  8014ab:	53                   	push   %ebx
  8014ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014af:	eb 01                	jmp    8014b2 <strtol+0xc>
		s++;
  8014b1:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8014b2:	8a 01                	mov    (%ecx),%al
  8014b4:	3c 20                	cmp    $0x20,%al
  8014b6:	74 f9                	je     8014b1 <strtol+0xb>
  8014b8:	3c 09                	cmp    $0x9,%al
  8014ba:	74 f5                	je     8014b1 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8014bc:	3c 2b                	cmp    $0x2b,%al
  8014be:	74 2b                	je     8014eb <strtol+0x45>
		s++;
	else if (*s == '-')
  8014c0:	3c 2d                	cmp    $0x2d,%al
  8014c2:	74 2f                	je     8014f3 <strtol+0x4d>
	int neg = 0;
  8014c4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014c9:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8014d0:	75 12                	jne    8014e4 <strtol+0x3e>
  8014d2:	80 39 30             	cmpb   $0x30,(%ecx)
  8014d5:	74 24                	je     8014fb <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8014d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014db:	75 07                	jne    8014e4 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8014dd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e9:	eb 4e                	jmp    801539 <strtol+0x93>
		s++;
  8014eb:	41                   	inc    %ecx
	int neg = 0;
  8014ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8014f1:	eb d6                	jmp    8014c9 <strtol+0x23>
		s++, neg = 1;
  8014f3:	41                   	inc    %ecx
  8014f4:	bf 01 00 00 00       	mov    $0x1,%edi
  8014f9:	eb ce                	jmp    8014c9 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014fb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8014ff:	74 10                	je     801511 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801501:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801505:	75 dd                	jne    8014e4 <strtol+0x3e>
		s++, base = 8;
  801507:	41                   	inc    %ecx
  801508:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80150f:	eb d3                	jmp    8014e4 <strtol+0x3e>
		s += 2, base = 16;
  801511:	83 c1 02             	add    $0x2,%ecx
  801514:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80151b:	eb c7                	jmp    8014e4 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80151d:	8d 72 9f             	lea    -0x61(%edx),%esi
  801520:	89 f3                	mov    %esi,%ebx
  801522:	80 fb 19             	cmp    $0x19,%bl
  801525:	77 24                	ja     80154b <strtol+0xa5>
			dig = *s - 'a' + 10;
  801527:	0f be d2             	movsbl %dl,%edx
  80152a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80152d:	3b 55 10             	cmp    0x10(%ebp),%edx
  801530:	7d 2b                	jge    80155d <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801532:	41                   	inc    %ecx
  801533:	0f af 45 10          	imul   0x10(%ebp),%eax
  801537:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801539:	8a 11                	mov    (%ecx),%dl
  80153b:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80153e:	80 fb 09             	cmp    $0x9,%bl
  801541:	77 da                	ja     80151d <strtol+0x77>
			dig = *s - '0';
  801543:	0f be d2             	movsbl %dl,%edx
  801546:	83 ea 30             	sub    $0x30,%edx
  801549:	eb e2                	jmp    80152d <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  80154b:	8d 72 bf             	lea    -0x41(%edx),%esi
  80154e:	89 f3                	mov    %esi,%ebx
  801550:	80 fb 19             	cmp    $0x19,%bl
  801553:	77 08                	ja     80155d <strtol+0xb7>
			dig = *s - 'A' + 10;
  801555:	0f be d2             	movsbl %dl,%edx
  801558:	83 ea 37             	sub    $0x37,%edx
  80155b:	eb d0                	jmp    80152d <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  80155d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801561:	74 05                	je     801568 <strtol+0xc2>
		*endptr = (char *) s;
  801563:	8b 75 0c             	mov    0xc(%ebp),%esi
  801566:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801568:	85 ff                	test   %edi,%edi
  80156a:	74 02                	je     80156e <strtol+0xc8>
  80156c:	f7 d8                	neg    %eax
}
  80156e:	5b                   	pop    %ebx
  80156f:	5e                   	pop    %esi
  801570:	5f                   	pop    %edi
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    

00801573 <atoi>:

int
atoi(const char *s)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801576:	6a 0a                	push   $0xa
  801578:	6a 00                	push   $0x0
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 24 ff ff ff       	call   8014a6 <strtol>
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	57                   	push   %edi
  801588:	56                   	push   %esi
  801589:	53                   	push   %ebx
	asm volatile("int %1\n"
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
  80158f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801592:	8b 55 08             	mov    0x8(%ebp),%edx
  801595:	89 c3                	mov    %eax,%ebx
  801597:	89 c7                	mov    %eax,%edi
  801599:	89 c6                	mov    %eax,%esi
  80159b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80159d:	5b                   	pop    %ebx
  80159e:	5e                   	pop    %esi
  80159f:	5f                   	pop    %edi
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	57                   	push   %edi
  8015a6:	56                   	push   %esi
  8015a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b2:	89 d1                	mov    %edx,%ecx
  8015b4:	89 d3                	mov    %edx,%ebx
  8015b6:	89 d7                	mov    %edx,%edi
  8015b8:	89 d6                	mov    %edx,%esi
  8015ba:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8015bc:	5b                   	pop    %ebx
  8015bd:	5e                   	pop    %esi
  8015be:	5f                   	pop    %edi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    

008015c1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	57                   	push   %edi
  8015c5:	56                   	push   %esi
  8015c6:	53                   	push   %ebx
  8015c7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	89 cb                	mov    %ecx,%ebx
  8015d9:	89 cf                	mov    %ecx,%edi
  8015db:	89 ce                	mov    %ecx,%esi
  8015dd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	7f 08                	jg     8015eb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8015e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5f                   	pop    %edi
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015eb:	83 ec 0c             	sub    $0xc,%esp
  8015ee:	50                   	push   %eax
  8015ef:	6a 03                	push   $0x3
  8015f1:	68 df 33 80 00       	push   $0x8033df
  8015f6:	6a 23                	push   $0x23
  8015f8:	68 fc 33 80 00       	push   $0x8033fc
  8015fd:	e8 f7 f5 ff ff       	call   800bf9 <_panic>

00801602 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	57                   	push   %edi
  801606:	56                   	push   %esi
  801607:	53                   	push   %ebx
	asm volatile("int %1\n"
  801608:	ba 00 00 00 00       	mov    $0x0,%edx
  80160d:	b8 02 00 00 00       	mov    $0x2,%eax
  801612:	89 d1                	mov    %edx,%ecx
  801614:	89 d3                	mov    %edx,%ebx
  801616:	89 d7                	mov    %edx,%edi
  801618:	89 d6                	mov    %edx,%esi
  80161a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80161c:	5b                   	pop    %ebx
  80161d:	5e                   	pop    %esi
  80161e:	5f                   	pop    %edi
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    

00801621 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	57                   	push   %edi
  801625:	56                   	push   %esi
  801626:	53                   	push   %ebx
  801627:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80162a:	be 00 00 00 00       	mov    $0x0,%esi
  80162f:	b8 04 00 00 00       	mov    $0x4,%eax
  801634:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801637:	8b 55 08             	mov    0x8(%ebp),%edx
  80163a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80163d:	89 f7                	mov    %esi,%edi
  80163f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801641:	85 c0                	test   %eax,%eax
  801643:	7f 08                	jg     80164d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801645:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801648:	5b                   	pop    %ebx
  801649:	5e                   	pop    %esi
  80164a:	5f                   	pop    %edi
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80164d:	83 ec 0c             	sub    $0xc,%esp
  801650:	50                   	push   %eax
  801651:	6a 04                	push   $0x4
  801653:	68 df 33 80 00       	push   $0x8033df
  801658:	6a 23                	push   $0x23
  80165a:	68 fc 33 80 00       	push   $0x8033fc
  80165f:	e8 95 f5 ff ff       	call   800bf9 <_panic>

00801664 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	57                   	push   %edi
  801668:	56                   	push   %esi
  801669:	53                   	push   %ebx
  80166a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80166d:	b8 05 00 00 00       	mov    $0x5,%eax
  801672:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801675:	8b 55 08             	mov    0x8(%ebp),%edx
  801678:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80167b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80167e:	8b 75 18             	mov    0x18(%ebp),%esi
  801681:	cd 30                	int    $0x30
	if(check && ret > 0)
  801683:	85 c0                	test   %eax,%eax
  801685:	7f 08                	jg     80168f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801687:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168a:	5b                   	pop    %ebx
  80168b:	5e                   	pop    %esi
  80168c:	5f                   	pop    %edi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80168f:	83 ec 0c             	sub    $0xc,%esp
  801692:	50                   	push   %eax
  801693:	6a 05                	push   $0x5
  801695:	68 df 33 80 00       	push   $0x8033df
  80169a:	6a 23                	push   $0x23
  80169c:	68 fc 33 80 00       	push   $0x8033fc
  8016a1:	e8 53 f5 ff ff       	call   800bf9 <_panic>

008016a6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	57                   	push   %edi
  8016aa:	56                   	push   %esi
  8016ab:	53                   	push   %ebx
  8016ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b4:	b8 06 00 00 00       	mov    $0x6,%eax
  8016b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bf:	89 df                	mov    %ebx,%edi
  8016c1:	89 de                	mov    %ebx,%esi
  8016c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	7f 08                	jg     8016d1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cc:	5b                   	pop    %ebx
  8016cd:	5e                   	pop    %esi
  8016ce:	5f                   	pop    %edi
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016d1:	83 ec 0c             	sub    $0xc,%esp
  8016d4:	50                   	push   %eax
  8016d5:	6a 06                	push   $0x6
  8016d7:	68 df 33 80 00       	push   $0x8033df
  8016dc:	6a 23                	push   $0x23
  8016de:	68 fc 33 80 00       	push   $0x8033fc
  8016e3:	e8 11 f5 ff ff       	call   800bf9 <_panic>

008016e8 <sys_yield>:

void
sys_yield(void)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	57                   	push   %edi
  8016ec:	56                   	push   %esi
  8016ed:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016f8:	89 d1                	mov    %edx,%ecx
  8016fa:	89 d3                	mov    %edx,%ebx
  8016fc:	89 d7                	mov    %edx,%edi
  8016fe:	89 d6                	mov    %edx,%esi
  801700:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801702:	5b                   	pop    %ebx
  801703:	5e                   	pop    %esi
  801704:	5f                   	pop    %edi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	57                   	push   %edi
  80170b:	56                   	push   %esi
  80170c:	53                   	push   %ebx
  80170d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801710:	bb 00 00 00 00       	mov    $0x0,%ebx
  801715:	b8 08 00 00 00       	mov    $0x8,%eax
  80171a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80171d:	8b 55 08             	mov    0x8(%ebp),%edx
  801720:	89 df                	mov    %ebx,%edi
  801722:	89 de                	mov    %ebx,%esi
  801724:	cd 30                	int    $0x30
	if(check && ret > 0)
  801726:	85 c0                	test   %eax,%eax
  801728:	7f 08                	jg     801732 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80172a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172d:	5b                   	pop    %ebx
  80172e:	5e                   	pop    %esi
  80172f:	5f                   	pop    %edi
  801730:	5d                   	pop    %ebp
  801731:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	50                   	push   %eax
  801736:	6a 08                	push   $0x8
  801738:	68 df 33 80 00       	push   $0x8033df
  80173d:	6a 23                	push   $0x23
  80173f:	68 fc 33 80 00       	push   $0x8033fc
  801744:	e8 b0 f4 ff ff       	call   800bf9 <_panic>

00801749 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	57                   	push   %edi
  80174d:	56                   	push   %esi
  80174e:	53                   	push   %ebx
  80174f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801752:	b9 00 00 00 00       	mov    $0x0,%ecx
  801757:	b8 0c 00 00 00       	mov    $0xc,%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 cb                	mov    %ecx,%ebx
  801761:	89 cf                	mov    %ecx,%edi
  801763:	89 ce                	mov    %ecx,%esi
  801765:	cd 30                	int    $0x30
	if(check && ret > 0)
  801767:	85 c0                	test   %eax,%eax
  801769:	7f 08                	jg     801773 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  80176b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80176e:	5b                   	pop    %ebx
  80176f:	5e                   	pop    %esi
  801770:	5f                   	pop    %edi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801773:	83 ec 0c             	sub    $0xc,%esp
  801776:	50                   	push   %eax
  801777:	6a 0c                	push   $0xc
  801779:	68 df 33 80 00       	push   $0x8033df
  80177e:	6a 23                	push   $0x23
  801780:	68 fc 33 80 00       	push   $0x8033fc
  801785:	e8 6f f4 ff ff       	call   800bf9 <_panic>

0080178a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	57                   	push   %edi
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
  801790:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801793:	bb 00 00 00 00       	mov    $0x0,%ebx
  801798:	b8 09 00 00 00       	mov    $0x9,%eax
  80179d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a3:	89 df                	mov    %ebx,%edi
  8017a5:	89 de                	mov    %ebx,%esi
  8017a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	7f 08                	jg     8017b5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8017ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b0:	5b                   	pop    %ebx
  8017b1:	5e                   	pop    %esi
  8017b2:	5f                   	pop    %edi
  8017b3:	5d                   	pop    %ebp
  8017b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017b5:	83 ec 0c             	sub    $0xc,%esp
  8017b8:	50                   	push   %eax
  8017b9:	6a 09                	push   $0x9
  8017bb:	68 df 33 80 00       	push   $0x8033df
  8017c0:	6a 23                	push   $0x23
  8017c2:	68 fc 33 80 00       	push   $0x8033fc
  8017c7:	e8 2d f4 ff ff       	call   800bf9 <_panic>

008017cc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	57                   	push   %edi
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8017df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e5:	89 df                	mov    %ebx,%edi
  8017e7:	89 de                	mov    %ebx,%esi
  8017e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	7f 08                	jg     8017f7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8017ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5f                   	pop    %edi
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017f7:	83 ec 0c             	sub    $0xc,%esp
  8017fa:	50                   	push   %eax
  8017fb:	6a 0a                	push   $0xa
  8017fd:	68 df 33 80 00       	push   $0x8033df
  801802:	6a 23                	push   $0x23
  801804:	68 fc 33 80 00       	push   $0x8033fc
  801809:	e8 eb f3 ff ff       	call   800bf9 <_panic>

0080180e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	57                   	push   %edi
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
	asm volatile("int %1\n"
  801814:	be 00 00 00 00       	mov    $0x0,%esi
  801819:	b8 0d 00 00 00       	mov    $0xd,%eax
  80181e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801821:	8b 55 08             	mov    0x8(%ebp),%edx
  801824:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801827:	8b 7d 14             	mov    0x14(%ebp),%edi
  80182a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80182c:	5b                   	pop    %ebx
  80182d:	5e                   	pop    %esi
  80182e:	5f                   	pop    %edi
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    

00801831 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	57                   	push   %edi
  801835:	56                   	push   %esi
  801836:	53                   	push   %ebx
  801837:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80183a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80183f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801844:	8b 55 08             	mov    0x8(%ebp),%edx
  801847:	89 cb                	mov    %ecx,%ebx
  801849:	89 cf                	mov    %ecx,%edi
  80184b:	89 ce                	mov    %ecx,%esi
  80184d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80184f:	85 c0                	test   %eax,%eax
  801851:	7f 08                	jg     80185b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801853:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801856:	5b                   	pop    %ebx
  801857:	5e                   	pop    %esi
  801858:	5f                   	pop    %edi
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	50                   	push   %eax
  80185f:	6a 0e                	push   $0xe
  801861:	68 df 33 80 00       	push   $0x8033df
  801866:	6a 23                	push   $0x23
  801868:	68 fc 33 80 00       	push   $0x8033fc
  80186d:	e8 87 f3 ff ff       	call   800bf9 <_panic>

00801872 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	57                   	push   %edi
  801876:	56                   	push   %esi
  801877:	53                   	push   %ebx
	asm volatile("int %1\n"
  801878:	be 00 00 00 00       	mov    $0x0,%esi
  80187d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801882:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801885:	8b 55 08             	mov    0x8(%ebp),%edx
  801888:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80188b:	89 f7                	mov    %esi,%edi
  80188d:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80188f:	5b                   	pop    %ebx
  801890:	5e                   	pop    %esi
  801891:	5f                   	pop    %edi
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    

00801894 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	57                   	push   %edi
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
	asm volatile("int %1\n"
  80189a:	be 00 00 00 00       	mov    $0x0,%esi
  80189f:	b8 10 00 00 00       	mov    $0x10,%eax
  8018a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018ad:	89 f7                	mov    %esi,%edi
  8018af:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8018b1:	5b                   	pop    %ebx
  8018b2:	5e                   	pop    %esi
  8018b3:	5f                   	pop    %edi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	57                   	push   %edi
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c1:	b8 11 00 00 00       	mov    $0x11,%eax
  8018c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c9:	89 cb                	mov    %ecx,%ebx
  8018cb:	89 cf                	mov    %ecx,%edi
  8018cd:	89 ce                	mov    %ecx,%esi
  8018cf:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5f                   	pop    %edi
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    

008018d6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	05 00 00 00 30       	add    $0x30000000,%eax
  8018e1:	c1 e8 0c             	shr    $0xc,%eax
}
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8018f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018f6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    

008018fd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801903:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801908:	89 c2                	mov    %eax,%edx
  80190a:	c1 ea 16             	shr    $0x16,%edx
  80190d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801914:	f6 c2 01             	test   $0x1,%dl
  801917:	74 2a                	je     801943 <fd_alloc+0x46>
  801919:	89 c2                	mov    %eax,%edx
  80191b:	c1 ea 0c             	shr    $0xc,%edx
  80191e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801925:	f6 c2 01             	test   $0x1,%dl
  801928:	74 19                	je     801943 <fd_alloc+0x46>
  80192a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80192f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801934:	75 d2                	jne    801908 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801936:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80193c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801941:	eb 07                	jmp    80194a <fd_alloc+0x4d>
			*fd_store = fd;
  801943:	89 01                	mov    %eax,(%ecx)
			return 0;
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    

0080194c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80194f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801953:	77 39                	ja     80198e <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	c1 e0 0c             	shl    $0xc,%eax
  80195b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801960:	89 c2                	mov    %eax,%edx
  801962:	c1 ea 16             	shr    $0x16,%edx
  801965:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80196c:	f6 c2 01             	test   $0x1,%dl
  80196f:	74 24                	je     801995 <fd_lookup+0x49>
  801971:	89 c2                	mov    %eax,%edx
  801973:	c1 ea 0c             	shr    $0xc,%edx
  801976:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80197d:	f6 c2 01             	test   $0x1,%dl
  801980:	74 1a                	je     80199c <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	89 02                	mov    %eax,(%edx)
	return 0;
  801987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198c:	5d                   	pop    %ebp
  80198d:	c3                   	ret    
		return -E_INVAL;
  80198e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801993:	eb f7                	jmp    80198c <fd_lookup+0x40>
		return -E_INVAL;
  801995:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80199a:	eb f0                	jmp    80198c <fd_lookup+0x40>
  80199c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a1:	eb e9                	jmp    80198c <fd_lookup+0x40>

008019a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ac:	ba 88 34 80 00       	mov    $0x803488,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8019b1:	b8 14 40 80 00       	mov    $0x804014,%eax
		if (devtab[i]->dev_id == dev_id) {
  8019b6:	39 08                	cmp    %ecx,(%eax)
  8019b8:	74 33                	je     8019ed <dev_lookup+0x4a>
  8019ba:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8019bd:	8b 02                	mov    (%edx),%eax
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	75 f3                	jne    8019b6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019c3:	a1 08 50 80 00       	mov    0x805008,%eax
  8019c8:	8b 40 48             	mov    0x48(%eax),%eax
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	51                   	push   %ecx
  8019cf:	50                   	push   %eax
  8019d0:	68 0c 34 80 00       	push   $0x80340c
  8019d5:	e8 9b 0c 00 00       	call   802675 <cprintf>
	*dev = 0;
  8019da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    
			*dev = devtab[i];
  8019ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019f0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8019f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f7:	eb f2                	jmp    8019eb <dev_lookup+0x48>

008019f9 <fd_close>:
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	57                   	push   %edi
  8019fd:	56                   	push   %esi
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 1c             	sub    $0x1c,%esp
  801a02:	8b 75 08             	mov    0x8(%ebp),%esi
  801a05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a08:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a0b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a0c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a12:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a15:	50                   	push   %eax
  801a16:	e8 31 ff ff ff       	call   80194c <fd_lookup>
  801a1b:	89 c7                	mov    %eax,%edi
  801a1d:	83 c4 08             	add    $0x8,%esp
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 05                	js     801a29 <fd_close+0x30>
	    || fd != fd2)
  801a24:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801a27:	74 13                	je     801a3c <fd_close+0x43>
		return (must_exist ? r : 0);
  801a29:	84 db                	test   %bl,%bl
  801a2b:	75 05                	jne    801a32 <fd_close+0x39>
  801a2d:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801a32:	89 f8                	mov    %edi,%eax
  801a34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5f                   	pop    %edi
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a3c:	83 ec 08             	sub    $0x8,%esp
  801a3f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a42:	50                   	push   %eax
  801a43:	ff 36                	pushl  (%esi)
  801a45:	e8 59 ff ff ff       	call   8019a3 <dev_lookup>
  801a4a:	89 c7                	mov    %eax,%edi
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	78 15                	js     801a68 <fd_close+0x6f>
		if (dev->dev_close)
  801a53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a56:	8b 40 10             	mov    0x10(%eax),%eax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	74 1b                	je     801a78 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	56                   	push   %esi
  801a61:	ff d0                	call   *%eax
  801a63:	89 c7                	mov    %eax,%edi
  801a65:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	56                   	push   %esi
  801a6c:	6a 00                	push   $0x0
  801a6e:	e8 33 fc ff ff       	call   8016a6 <sys_page_unmap>
	return r;
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	eb ba                	jmp    801a32 <fd_close+0x39>
			r = 0;
  801a78:	bf 00 00 00 00       	mov    $0x0,%edi
  801a7d:	eb e9                	jmp    801a68 <fd_close+0x6f>

00801a7f <close>:

int
close(int fdnum)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a88:	50                   	push   %eax
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	e8 bb fe ff ff       	call   80194c <fd_lookup>
  801a91:	83 c4 08             	add    $0x8,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	78 10                	js     801aa8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801a98:	83 ec 08             	sub    $0x8,%esp
  801a9b:	6a 01                	push   $0x1
  801a9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa0:	e8 54 ff ff ff       	call   8019f9 <fd_close>
  801aa5:	83 c4 10             	add    $0x10,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <close_all>:

void
close_all(void)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	53                   	push   %ebx
  801aae:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ab1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ab6:	83 ec 0c             	sub    $0xc,%esp
  801ab9:	53                   	push   %ebx
  801aba:	e8 c0 ff ff ff       	call   801a7f <close>
	for (i = 0; i < MAXFD; i++)
  801abf:	43                   	inc    %ebx
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	83 fb 20             	cmp    $0x20,%ebx
  801ac6:	75 ee                	jne    801ab6 <close_all+0xc>
}
  801ac8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	57                   	push   %edi
  801ad1:	56                   	push   %esi
  801ad2:	53                   	push   %ebx
  801ad3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ad6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ad9:	50                   	push   %eax
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	e8 6a fe ff ff       	call   80194c <fd_lookup>
  801ae2:	89 c3                	mov    %eax,%ebx
  801ae4:	83 c4 08             	add    $0x8,%esp
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	0f 88 81 00 00 00    	js     801b70 <dup+0xa3>
		return r;
	close(newfdnum);
  801aef:	83 ec 0c             	sub    $0xc,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	e8 85 ff ff ff       	call   801a7f <close>

	newfd = INDEX2FD(newfdnum);
  801afa:	8b 75 0c             	mov    0xc(%ebp),%esi
  801afd:	c1 e6 0c             	shl    $0xc,%esi
  801b00:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b06:	83 c4 04             	add    $0x4,%esp
  801b09:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b0c:	e8 d5 fd ff ff       	call   8018e6 <fd2data>
  801b11:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b13:	89 34 24             	mov    %esi,(%esp)
  801b16:	e8 cb fd ff ff       	call   8018e6 <fd2data>
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b20:	89 d8                	mov    %ebx,%eax
  801b22:	c1 e8 16             	shr    $0x16,%eax
  801b25:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b2c:	a8 01                	test   $0x1,%al
  801b2e:	74 11                	je     801b41 <dup+0x74>
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	c1 e8 0c             	shr    $0xc,%eax
  801b35:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b3c:	f6 c2 01             	test   $0x1,%dl
  801b3f:	75 39                	jne    801b7a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b44:	89 d0                	mov    %edx,%eax
  801b46:	c1 e8 0c             	shr    $0xc,%eax
  801b49:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	25 07 0e 00 00       	and    $0xe07,%eax
  801b58:	50                   	push   %eax
  801b59:	56                   	push   %esi
  801b5a:	6a 00                	push   $0x0
  801b5c:	52                   	push   %edx
  801b5d:	6a 00                	push   $0x0
  801b5f:	e8 00 fb ff ff       	call   801664 <sys_page_map>
  801b64:	89 c3                	mov    %eax,%ebx
  801b66:	83 c4 20             	add    $0x20,%esp
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	78 31                	js     801b9e <dup+0xd1>
		goto err;

	return newfdnum;
  801b6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b70:	89 d8                	mov    %ebx,%eax
  801b72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b75:	5b                   	pop    %ebx
  801b76:	5e                   	pop    %esi
  801b77:	5f                   	pop    %edi
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b7a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b81:	83 ec 0c             	sub    $0xc,%esp
  801b84:	25 07 0e 00 00       	and    $0xe07,%eax
  801b89:	50                   	push   %eax
  801b8a:	57                   	push   %edi
  801b8b:	6a 00                	push   $0x0
  801b8d:	53                   	push   %ebx
  801b8e:	6a 00                	push   $0x0
  801b90:	e8 cf fa ff ff       	call   801664 <sys_page_map>
  801b95:	89 c3                	mov    %eax,%ebx
  801b97:	83 c4 20             	add    $0x20,%esp
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	79 a3                	jns    801b41 <dup+0x74>
	sys_page_unmap(0, newfd);
  801b9e:	83 ec 08             	sub    $0x8,%esp
  801ba1:	56                   	push   %esi
  801ba2:	6a 00                	push   $0x0
  801ba4:	e8 fd fa ff ff       	call   8016a6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ba9:	83 c4 08             	add    $0x8,%esp
  801bac:	57                   	push   %edi
  801bad:	6a 00                	push   $0x0
  801baf:	e8 f2 fa ff ff       	call   8016a6 <sys_page_unmap>
	return r;
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	eb b7                	jmp    801b70 <dup+0xa3>

00801bb9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	53                   	push   %ebx
  801bbd:	83 ec 14             	sub    $0x14,%esp
  801bc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc6:	50                   	push   %eax
  801bc7:	53                   	push   %ebx
  801bc8:	e8 7f fd ff ff       	call   80194c <fd_lookup>
  801bcd:	83 c4 08             	add    $0x8,%esp
  801bd0:	85 c0                	test   %eax,%eax
  801bd2:	78 3f                	js     801c13 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bd4:	83 ec 08             	sub    $0x8,%esp
  801bd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bda:	50                   	push   %eax
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bde:	ff 30                	pushl  (%eax)
  801be0:	e8 be fd ff ff       	call   8019a3 <dev_lookup>
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	85 c0                	test   %eax,%eax
  801bea:	78 27                	js     801c13 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801bec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bef:	8b 42 08             	mov    0x8(%edx),%eax
  801bf2:	83 e0 03             	and    $0x3,%eax
  801bf5:	83 f8 01             	cmp    $0x1,%eax
  801bf8:	74 1e                	je     801c18 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfd:	8b 40 08             	mov    0x8(%eax),%eax
  801c00:	85 c0                	test   %eax,%eax
  801c02:	74 35                	je     801c39 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	ff 75 10             	pushl  0x10(%ebp)
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	52                   	push   %edx
  801c0e:	ff d0                	call   *%eax
  801c10:	83 c4 10             	add    $0x10,%esp
}
  801c13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c18:	a1 08 50 80 00       	mov    0x805008,%eax
  801c1d:	8b 40 48             	mov    0x48(%eax),%eax
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	53                   	push   %ebx
  801c24:	50                   	push   %eax
  801c25:	68 4d 34 80 00       	push   $0x80344d
  801c2a:	e8 46 0a 00 00       	call   802675 <cprintf>
		return -E_INVAL;
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c37:	eb da                	jmp    801c13 <read+0x5a>
		return -E_NOT_SUPP;
  801c39:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3e:	eb d3                	jmp    801c13 <read+0x5a>

00801c40 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	57                   	push   %edi
  801c44:	56                   	push   %esi
  801c45:	53                   	push   %ebx
  801c46:	83 ec 0c             	sub    $0xc,%esp
  801c49:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c4c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c54:	39 f3                	cmp    %esi,%ebx
  801c56:	73 25                	jae    801c7d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	89 f0                	mov    %esi,%eax
  801c5d:	29 d8                	sub    %ebx,%eax
  801c5f:	50                   	push   %eax
  801c60:	89 d8                	mov    %ebx,%eax
  801c62:	03 45 0c             	add    0xc(%ebp),%eax
  801c65:	50                   	push   %eax
  801c66:	57                   	push   %edi
  801c67:	e8 4d ff ff ff       	call   801bb9 <read>
		if (m < 0)
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	78 08                	js     801c7b <readn+0x3b>
			return m;
		if (m == 0)
  801c73:	85 c0                	test   %eax,%eax
  801c75:	74 06                	je     801c7d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801c77:	01 c3                	add    %eax,%ebx
  801c79:	eb d9                	jmp    801c54 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c7b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801c7d:	89 d8                	mov    %ebx,%eax
  801c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c82:	5b                   	pop    %ebx
  801c83:	5e                   	pop    %esi
  801c84:	5f                   	pop    %edi
  801c85:	5d                   	pop    %ebp
  801c86:	c3                   	ret    

00801c87 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 14             	sub    $0x14,%esp
  801c8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c94:	50                   	push   %eax
  801c95:	53                   	push   %ebx
  801c96:	e8 b1 fc ff ff       	call   80194c <fd_lookup>
  801c9b:	83 c4 08             	add    $0x8,%esp
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 3a                	js     801cdc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ca2:	83 ec 08             	sub    $0x8,%esp
  801ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca8:	50                   	push   %eax
  801ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cac:	ff 30                	pushl  (%eax)
  801cae:	e8 f0 fc ff ff       	call   8019a3 <dev_lookup>
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	78 22                	js     801cdc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cc1:	74 1e                	je     801ce1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc6:	8b 52 0c             	mov    0xc(%edx),%edx
  801cc9:	85 d2                	test   %edx,%edx
  801ccb:	74 35                	je     801d02 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	ff 75 10             	pushl  0x10(%ebp)
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	50                   	push   %eax
  801cd7:	ff d2                	call   *%edx
  801cd9:	83 c4 10             	add    $0x10,%esp
}
  801cdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ce1:	a1 08 50 80 00       	mov    0x805008,%eax
  801ce6:	8b 40 48             	mov    0x48(%eax),%eax
  801ce9:	83 ec 04             	sub    $0x4,%esp
  801cec:	53                   	push   %ebx
  801ced:	50                   	push   %eax
  801cee:	68 69 34 80 00       	push   $0x803469
  801cf3:	e8 7d 09 00 00       	call   802675 <cprintf>
		return -E_INVAL;
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d00:	eb da                	jmp    801cdc <write+0x55>
		return -E_NOT_SUPP;
  801d02:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d07:	eb d3                	jmp    801cdc <write+0x55>

00801d09 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d0f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801d12:	50                   	push   %eax
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	e8 31 fc ff ff       	call   80194c <fd_lookup>
  801d1b:	83 c4 08             	add    $0x8,%esp
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	78 0e                	js     801d30 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d28:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	53                   	push   %ebx
  801d36:	83 ec 14             	sub    $0x14,%esp
  801d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3f:	50                   	push   %eax
  801d40:	53                   	push   %ebx
  801d41:	e8 06 fc ff ff       	call   80194c <fd_lookup>
  801d46:	83 c4 08             	add    $0x8,%esp
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 37                	js     801d84 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d4d:	83 ec 08             	sub    $0x8,%esp
  801d50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d53:	50                   	push   %eax
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d57:	ff 30                	pushl  (%eax)
  801d59:	e8 45 fc ff ff       	call   8019a3 <dev_lookup>
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	85 c0                	test   %eax,%eax
  801d63:	78 1f                	js     801d84 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d68:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d6c:	74 1b                	je     801d89 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d71:	8b 52 18             	mov    0x18(%edx),%edx
  801d74:	85 d2                	test   %edx,%edx
  801d76:	74 32                	je     801daa <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d78:	83 ec 08             	sub    $0x8,%esp
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	50                   	push   %eax
  801d7f:	ff d2                	call   *%edx
  801d81:	83 c4 10             	add    $0x10,%esp
}
  801d84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    
			thisenv->env_id, fdnum);
  801d89:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d8e:	8b 40 48             	mov    0x48(%eax),%eax
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	53                   	push   %ebx
  801d95:	50                   	push   %eax
  801d96:	68 2c 34 80 00       	push   $0x80342c
  801d9b:	e8 d5 08 00 00       	call   802675 <cprintf>
		return -E_INVAL;
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da8:	eb da                	jmp    801d84 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801daa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801daf:	eb d3                	jmp    801d84 <ftruncate+0x52>

00801db1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	53                   	push   %ebx
  801db5:	83 ec 14             	sub    $0x14,%esp
  801db8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dbb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dbe:	50                   	push   %eax
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	e8 85 fb ff ff       	call   80194c <fd_lookup>
  801dc7:	83 c4 08             	add    $0x8,%esp
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 4b                	js     801e19 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dce:	83 ec 08             	sub    $0x8,%esp
  801dd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd4:	50                   	push   %eax
  801dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd8:	ff 30                	pushl  (%eax)
  801dda:	e8 c4 fb ff ff       	call   8019a3 <dev_lookup>
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	85 c0                	test   %eax,%eax
  801de4:	78 33                	js     801e19 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ded:	74 2f                	je     801e1e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801def:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801df2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801df9:	00 00 00 
	stat->st_type = 0;
  801dfc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e03:	00 00 00 
	stat->st_dev = dev;
  801e06:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e0c:	83 ec 08             	sub    $0x8,%esp
  801e0f:	53                   	push   %ebx
  801e10:	ff 75 f0             	pushl  -0x10(%ebp)
  801e13:	ff 50 14             	call   *0x14(%eax)
  801e16:	83 c4 10             	add    $0x10,%esp
}
  801e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    
		return -E_NOT_SUPP;
  801e1e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e23:	eb f4                	jmp    801e19 <fstat+0x68>

00801e25 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	56                   	push   %esi
  801e29:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e2a:	83 ec 08             	sub    $0x8,%esp
  801e2d:	6a 00                	push   $0x0
  801e2f:	ff 75 08             	pushl  0x8(%ebp)
  801e32:	e8 34 02 00 00       	call   80206b <open>
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	83 c4 10             	add    $0x10,%esp
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 1b                	js     801e5b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	ff 75 0c             	pushl  0xc(%ebp)
  801e46:	50                   	push   %eax
  801e47:	e8 65 ff ff ff       	call   801db1 <fstat>
  801e4c:	89 c6                	mov    %eax,%esi
	close(fd);
  801e4e:	89 1c 24             	mov    %ebx,(%esp)
  801e51:	e8 29 fc ff ff       	call   801a7f <close>
	return r;
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	89 f3                	mov    %esi,%ebx
}
  801e5b:	89 d8                	mov    %ebx,%eax
  801e5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5e                   	pop    %esi
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    

00801e64 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	56                   	push   %esi
  801e68:	53                   	push   %ebx
  801e69:	89 c6                	mov    %eax,%esi
  801e6b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e6d:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e74:	74 27                	je     801e9d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e76:	6a 07                	push   $0x7
  801e78:	68 00 60 80 00       	push   $0x806000
  801e7d:	56                   	push   %esi
  801e7e:	ff 35 04 50 80 00    	pushl  0x805004
  801e84:	e8 89 08 00 00       	call   802712 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e89:	83 c4 0c             	add    $0xc,%esp
  801e8c:	6a 00                	push   $0x0
  801e8e:	53                   	push   %ebx
  801e8f:	6a 00                	push   $0x0
  801e91:	e8 f3 07 00 00       	call   802689 <ipc_recv>
}
  801e96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e99:	5b                   	pop    %ebx
  801e9a:	5e                   	pop    %esi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	6a 01                	push   $0x1
  801ea2:	e8 c7 08 00 00       	call   80276e <ipc_find_env>
  801ea7:	a3 04 50 80 00       	mov    %eax,0x805004
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	eb c5                	jmp    801e76 <fsipc+0x12>

00801eb1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801eca:	ba 00 00 00 00       	mov    $0x0,%edx
  801ecf:	b8 02 00 00 00       	mov    $0x2,%eax
  801ed4:	e8 8b ff ff ff       	call   801e64 <fsipc>
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <devfile_flush>:
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee7:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801eec:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef1:	b8 06 00 00 00       	mov    $0x6,%eax
  801ef6:	e8 69 ff ff ff       	call   801e64 <fsipc>
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <devfile_stat>:
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	53                   	push   %ebx
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f12:	ba 00 00 00 00       	mov    $0x0,%edx
  801f17:	b8 05 00 00 00       	mov    $0x5,%eax
  801f1c:	e8 43 ff ff ff       	call   801e64 <fsipc>
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 2c                	js     801f51 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f25:	83 ec 08             	sub    $0x8,%esp
  801f28:	68 00 60 80 00       	push   $0x806000
  801f2d:	53                   	push   %ebx
  801f2e:	e8 39 f3 ff ff       	call   80126c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f33:	a1 80 60 80 00       	mov    0x806080,%eax
  801f38:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801f3e:	a1 84 60 80 00       	mov    0x806084,%eax
  801f43:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <devfile_write>:
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	53                   	push   %ebx
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801f60:	89 d8                	mov    %ebx,%eax
  801f62:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801f68:	76 05                	jbe    801f6f <devfile_write+0x19>
  801f6a:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f72:	8b 52 0c             	mov    0xc(%edx),%edx
  801f75:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = size;
  801f7b:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801f80:	83 ec 04             	sub    $0x4,%esp
  801f83:	50                   	push   %eax
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	68 08 60 80 00       	push   $0x806008
  801f8c:	e8 4e f4 ff ff       	call   8013df <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801f91:	ba 00 00 00 00       	mov    $0x0,%edx
  801f96:	b8 04 00 00 00       	mov    $0x4,%eax
  801f9b:	e8 c4 fe ff ff       	call   801e64 <fsipc>
  801fa0:	83 c4 10             	add    $0x10,%esp
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	78 0b                	js     801fb2 <devfile_write+0x5c>
	assert(r <= n);
  801fa7:	39 c3                	cmp    %eax,%ebx
  801fa9:	72 0c                	jb     801fb7 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801fab:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fb0:	7f 1e                	jg     801fd0 <devfile_write+0x7a>
}
  801fb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    
	assert(r <= n);
  801fb7:	68 98 34 80 00       	push   $0x803498
  801fbc:	68 da 2c 80 00       	push   $0x802cda
  801fc1:	68 98 00 00 00       	push   $0x98
  801fc6:	68 9f 34 80 00       	push   $0x80349f
  801fcb:	e8 29 ec ff ff       	call   800bf9 <_panic>
	assert(r <= PGSIZE);
  801fd0:	68 aa 34 80 00       	push   $0x8034aa
  801fd5:	68 da 2c 80 00       	push   $0x802cda
  801fda:	68 99 00 00 00       	push   $0x99
  801fdf:	68 9f 34 80 00       	push   $0x80349f
  801fe4:	e8 10 ec ff ff       	call   800bf9 <_panic>

00801fe9 <devfile_read>:
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	56                   	push   %esi
  801fed:	53                   	push   %ebx
  801fee:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ffc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802002:	ba 00 00 00 00       	mov    $0x0,%edx
  802007:	b8 03 00 00 00       	mov    $0x3,%eax
  80200c:	e8 53 fe ff ff       	call   801e64 <fsipc>
  802011:	89 c3                	mov    %eax,%ebx
  802013:	85 c0                	test   %eax,%eax
  802015:	78 1f                	js     802036 <devfile_read+0x4d>
	assert(r <= n);
  802017:	39 c6                	cmp    %eax,%esi
  802019:	72 24                	jb     80203f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80201b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802020:	7f 33                	jg     802055 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	50                   	push   %eax
  802026:	68 00 60 80 00       	push   $0x806000
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	e8 ac f3 ff ff       	call   8013df <memmove>
	return r;
  802033:	83 c4 10             	add    $0x10,%esp
}
  802036:	89 d8                	mov    %ebx,%eax
  802038:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    
	assert(r <= n);
  80203f:	68 98 34 80 00       	push   $0x803498
  802044:	68 da 2c 80 00       	push   $0x802cda
  802049:	6a 7c                	push   $0x7c
  80204b:	68 9f 34 80 00       	push   $0x80349f
  802050:	e8 a4 eb ff ff       	call   800bf9 <_panic>
	assert(r <= PGSIZE);
  802055:	68 aa 34 80 00       	push   $0x8034aa
  80205a:	68 da 2c 80 00       	push   $0x802cda
  80205f:	6a 7d                	push   $0x7d
  802061:	68 9f 34 80 00       	push   $0x80349f
  802066:	e8 8e eb ff ff       	call   800bf9 <_panic>

0080206b <open>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	56                   	push   %esi
  80206f:	53                   	push   %ebx
  802070:	83 ec 1c             	sub    $0x1c,%esp
  802073:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802076:	56                   	push   %esi
  802077:	e8 bd f1 ff ff       	call   801239 <strlen>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802084:	7f 6c                	jg     8020f2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802086:	83 ec 0c             	sub    $0xc,%esp
  802089:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208c:	50                   	push   %eax
  80208d:	e8 6b f8 ff ff       	call   8018fd <fd_alloc>
  802092:	89 c3                	mov    %eax,%ebx
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	85 c0                	test   %eax,%eax
  802099:	78 3c                	js     8020d7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80209b:	83 ec 08             	sub    $0x8,%esp
  80209e:	56                   	push   %esi
  80209f:	68 00 60 80 00       	push   $0x806000
  8020a4:	e8 c3 f1 ff ff       	call   80126c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8020a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ac:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b9:	e8 a6 fd ff ff       	call   801e64 <fsipc>
  8020be:	89 c3                	mov    %eax,%ebx
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	78 19                	js     8020e0 <open+0x75>
	return fd2num(fd);
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8020cd:	e8 04 f8 ff ff       	call   8018d6 <fd2num>
  8020d2:	89 c3                	mov    %eax,%ebx
  8020d4:	83 c4 10             	add    $0x10,%esp
}
  8020d7:	89 d8                	mov    %ebx,%eax
  8020d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020dc:	5b                   	pop    %ebx
  8020dd:	5e                   	pop    %esi
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    
		fd_close(fd, 0);
  8020e0:	83 ec 08             	sub    $0x8,%esp
  8020e3:	6a 00                	push   $0x0
  8020e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e8:	e8 0c f9 ff ff       	call   8019f9 <fd_close>
		return r;
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	eb e5                	jmp    8020d7 <open+0x6c>
		return -E_BAD_PATH;
  8020f2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8020f7:	eb de                	jmp    8020d7 <open+0x6c>

008020f9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8020ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802104:	b8 08 00 00 00       	mov    $0x8,%eax
  802109:	e8 56 fd ff ff       	call   801e64 <fsipc>
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	56                   	push   %esi
  802114:	53                   	push   %ebx
  802115:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	ff 75 08             	pushl  0x8(%ebp)
  80211e:	e8 c3 f7 ff ff       	call   8018e6 <fd2data>
  802123:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802125:	83 c4 08             	add    $0x8,%esp
  802128:	68 b6 34 80 00       	push   $0x8034b6
  80212d:	53                   	push   %ebx
  80212e:	e8 39 f1 ff ff       	call   80126c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802133:	8b 46 04             	mov    0x4(%esi),%eax
  802136:	2b 06                	sub    (%esi),%eax
  802138:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80213e:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  802145:	10 00 00 
	stat->st_dev = &devpipe;
  802148:	c7 83 88 00 00 00 30 	movl   $0x804030,0x88(%ebx)
  80214f:	40 80 00 
	return 0;
}
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
  802157:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215a:	5b                   	pop    %ebx
  80215b:	5e                   	pop    %esi
  80215c:	5d                   	pop    %ebp
  80215d:	c3                   	ret    

0080215e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	53                   	push   %ebx
  802162:	83 ec 0c             	sub    $0xc,%esp
  802165:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802168:	53                   	push   %ebx
  802169:	6a 00                	push   $0x0
  80216b:	e8 36 f5 ff ff       	call   8016a6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802170:	89 1c 24             	mov    %ebx,(%esp)
  802173:	e8 6e f7 ff ff       	call   8018e6 <fd2data>
  802178:	83 c4 08             	add    $0x8,%esp
  80217b:	50                   	push   %eax
  80217c:	6a 00                	push   $0x0
  80217e:	e8 23 f5 ff ff       	call   8016a6 <sys_page_unmap>
}
  802183:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <_pipeisclosed>:
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	57                   	push   %edi
  80218c:	56                   	push   %esi
  80218d:	53                   	push   %ebx
  80218e:	83 ec 1c             	sub    $0x1c,%esp
  802191:	89 c7                	mov    %eax,%edi
  802193:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802195:	a1 08 50 80 00       	mov    0x805008,%eax
  80219a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80219d:	83 ec 0c             	sub    $0xc,%esp
  8021a0:	57                   	push   %edi
  8021a1:	e8 0a 06 00 00       	call   8027b0 <pageref>
  8021a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021a9:	89 34 24             	mov    %esi,(%esp)
  8021ac:	e8 ff 05 00 00       	call   8027b0 <pageref>
		nn = thisenv->env_runs;
  8021b1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8021b7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021ba:	83 c4 10             	add    $0x10,%esp
  8021bd:	39 cb                	cmp    %ecx,%ebx
  8021bf:	74 1b                	je     8021dc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021c1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021c4:	75 cf                	jne    802195 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021c6:	8b 42 58             	mov    0x58(%edx),%eax
  8021c9:	6a 01                	push   $0x1
  8021cb:	50                   	push   %eax
  8021cc:	53                   	push   %ebx
  8021cd:	68 bd 34 80 00       	push   $0x8034bd
  8021d2:	e8 9e 04 00 00       	call   802675 <cprintf>
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	eb b9                	jmp    802195 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021dc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021df:	0f 94 c0             	sete   %al
  8021e2:	0f b6 c0             	movzbl %al,%eax
}
  8021e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021e8:	5b                   	pop    %ebx
  8021e9:	5e                   	pop    %esi
  8021ea:	5f                   	pop    %edi
  8021eb:	5d                   	pop    %ebp
  8021ec:	c3                   	ret    

008021ed <devpipe_write>:
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	57                   	push   %edi
  8021f1:	56                   	push   %esi
  8021f2:	53                   	push   %ebx
  8021f3:	83 ec 18             	sub    $0x18,%esp
  8021f6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021f9:	56                   	push   %esi
  8021fa:	e8 e7 f6 ff ff       	call   8018e6 <fd2data>
  8021ff:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	bf 00 00 00 00       	mov    $0x0,%edi
  802209:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80220c:	74 41                	je     80224f <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80220e:	8b 53 04             	mov    0x4(%ebx),%edx
  802211:	8b 03                	mov    (%ebx),%eax
  802213:	83 c0 20             	add    $0x20,%eax
  802216:	39 c2                	cmp    %eax,%edx
  802218:	72 14                	jb     80222e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80221a:	89 da                	mov    %ebx,%edx
  80221c:	89 f0                	mov    %esi,%eax
  80221e:	e8 65 ff ff ff       	call   802188 <_pipeisclosed>
  802223:	85 c0                	test   %eax,%eax
  802225:	75 2c                	jne    802253 <devpipe_write+0x66>
			sys_yield();
  802227:	e8 bc f4 ff ff       	call   8016e8 <sys_yield>
  80222c:	eb e0                	jmp    80220e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80222e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802231:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  802234:	89 d0                	mov    %edx,%eax
  802236:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80223b:	78 0b                	js     802248 <devpipe_write+0x5b>
  80223d:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  802241:	42                   	inc    %edx
  802242:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802245:	47                   	inc    %edi
  802246:	eb c1                	jmp    802209 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802248:	48                   	dec    %eax
  802249:	83 c8 e0             	or     $0xffffffe0,%eax
  80224c:	40                   	inc    %eax
  80224d:	eb ee                	jmp    80223d <devpipe_write+0x50>
	return i;
  80224f:	89 f8                	mov    %edi,%eax
  802251:	eb 05                	jmp    802258 <devpipe_write+0x6b>
				return 0;
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5e                   	pop    %esi
  80225d:	5f                   	pop    %edi
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    

00802260 <devpipe_read>:
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	57                   	push   %edi
  802264:	56                   	push   %esi
  802265:	53                   	push   %ebx
  802266:	83 ec 18             	sub    $0x18,%esp
  802269:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80226c:	57                   	push   %edi
  80226d:	e8 74 f6 ff ff       	call   8018e6 <fd2data>
  802272:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	bb 00 00 00 00       	mov    $0x0,%ebx
  80227c:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80227f:	74 46                	je     8022c7 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  802281:	8b 06                	mov    (%esi),%eax
  802283:	3b 46 04             	cmp    0x4(%esi),%eax
  802286:	75 22                	jne    8022aa <devpipe_read+0x4a>
			if (i > 0)
  802288:	85 db                	test   %ebx,%ebx
  80228a:	74 0a                	je     802296 <devpipe_read+0x36>
				return i;
  80228c:	89 d8                	mov    %ebx,%eax
}
  80228e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802291:	5b                   	pop    %ebx
  802292:	5e                   	pop    %esi
  802293:	5f                   	pop    %edi
  802294:	5d                   	pop    %ebp
  802295:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  802296:	89 f2                	mov    %esi,%edx
  802298:	89 f8                	mov    %edi,%eax
  80229a:	e8 e9 fe ff ff       	call   802188 <_pipeisclosed>
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	75 28                	jne    8022cb <devpipe_read+0x6b>
			sys_yield();
  8022a3:	e8 40 f4 ff ff       	call   8016e8 <sys_yield>
  8022a8:	eb d7                	jmp    802281 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022aa:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8022af:	78 0f                	js     8022c0 <devpipe_read+0x60>
  8022b1:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8022b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022b8:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8022bb:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8022bd:	43                   	inc    %ebx
  8022be:	eb bc                	jmp    80227c <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022c0:	48                   	dec    %eax
  8022c1:	83 c8 e0             	or     $0xffffffe0,%eax
  8022c4:	40                   	inc    %eax
  8022c5:	eb ea                	jmp    8022b1 <devpipe_read+0x51>
	return i;
  8022c7:	89 d8                	mov    %ebx,%eax
  8022c9:	eb c3                	jmp    80228e <devpipe_read+0x2e>
				return 0;
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d0:	eb bc                	jmp    80228e <devpipe_read+0x2e>

008022d2 <pipe>:
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	56                   	push   %esi
  8022d6:	53                   	push   %ebx
  8022d7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022dd:	50                   	push   %eax
  8022de:	e8 1a f6 ff ff       	call   8018fd <fd_alloc>
  8022e3:	89 c3                	mov    %eax,%ebx
  8022e5:	83 c4 10             	add    $0x10,%esp
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	0f 88 2a 01 00 00    	js     80241a <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	68 07 04 00 00       	push   $0x407
  8022f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fb:	6a 00                	push   $0x0
  8022fd:	e8 1f f3 ff ff       	call   801621 <sys_page_alloc>
  802302:	89 c3                	mov    %eax,%ebx
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	85 c0                	test   %eax,%eax
  802309:	0f 88 0b 01 00 00    	js     80241a <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  80230f:	83 ec 0c             	sub    $0xc,%esp
  802312:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802315:	50                   	push   %eax
  802316:	e8 e2 f5 ff ff       	call   8018fd <fd_alloc>
  80231b:	89 c3                	mov    %eax,%ebx
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	85 c0                	test   %eax,%eax
  802322:	0f 88 e2 00 00 00    	js     80240a <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 07 04 00 00       	push   $0x407
  802330:	ff 75 f0             	pushl  -0x10(%ebp)
  802333:	6a 00                	push   $0x0
  802335:	e8 e7 f2 ff ff       	call   801621 <sys_page_alloc>
  80233a:	89 c3                	mov    %eax,%ebx
  80233c:	83 c4 10             	add    $0x10,%esp
  80233f:	85 c0                	test   %eax,%eax
  802341:	0f 88 c3 00 00 00    	js     80240a <pipe+0x138>
	va = fd2data(fd0);
  802347:	83 ec 0c             	sub    $0xc,%esp
  80234a:	ff 75 f4             	pushl  -0xc(%ebp)
  80234d:	e8 94 f5 ff ff       	call   8018e6 <fd2data>
  802352:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802354:	83 c4 0c             	add    $0xc,%esp
  802357:	68 07 04 00 00       	push   $0x407
  80235c:	50                   	push   %eax
  80235d:	6a 00                	push   $0x0
  80235f:	e8 bd f2 ff ff       	call   801621 <sys_page_alloc>
  802364:	89 c3                	mov    %eax,%ebx
  802366:	83 c4 10             	add    $0x10,%esp
  802369:	85 c0                	test   %eax,%eax
  80236b:	0f 88 89 00 00 00    	js     8023fa <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802371:	83 ec 0c             	sub    $0xc,%esp
  802374:	ff 75 f0             	pushl  -0x10(%ebp)
  802377:	e8 6a f5 ff ff       	call   8018e6 <fd2data>
  80237c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802383:	50                   	push   %eax
  802384:	6a 00                	push   $0x0
  802386:	56                   	push   %esi
  802387:	6a 00                	push   $0x0
  802389:	e8 d6 f2 ff ff       	call   801664 <sys_page_map>
  80238e:	89 c3                	mov    %eax,%ebx
  802390:	83 c4 20             	add    $0x20,%esp
  802393:	85 c0                	test   %eax,%eax
  802395:	78 55                	js     8023ec <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  802397:	8b 15 30 40 80 00    	mov    0x804030,%edx
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8023ac:	8b 15 30 40 80 00    	mov    0x804030,%edx
  8023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8023b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023c1:	83 ec 0c             	sub    $0xc,%esp
  8023c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c7:	e8 0a f5 ff ff       	call   8018d6 <fd2num>
  8023cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023cf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023d1:	83 c4 04             	add    $0x4,%esp
  8023d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8023d7:	e8 fa f4 ff ff       	call   8018d6 <fd2num>
  8023dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023df:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023e2:	83 c4 10             	add    $0x10,%esp
  8023e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023ea:	eb 2e                	jmp    80241a <pipe+0x148>
	sys_page_unmap(0, va);
  8023ec:	83 ec 08             	sub    $0x8,%esp
  8023ef:	56                   	push   %esi
  8023f0:	6a 00                	push   $0x0
  8023f2:	e8 af f2 ff ff       	call   8016a6 <sys_page_unmap>
  8023f7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023fa:	83 ec 08             	sub    $0x8,%esp
  8023fd:	ff 75 f0             	pushl  -0x10(%ebp)
  802400:	6a 00                	push   $0x0
  802402:	e8 9f f2 ff ff       	call   8016a6 <sys_page_unmap>
  802407:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80240a:	83 ec 08             	sub    $0x8,%esp
  80240d:	ff 75 f4             	pushl  -0xc(%ebp)
  802410:	6a 00                	push   $0x0
  802412:	e8 8f f2 ff ff       	call   8016a6 <sys_page_unmap>
  802417:	83 c4 10             	add    $0x10,%esp
}
  80241a:	89 d8                	mov    %ebx,%eax
  80241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    

00802423 <pipeisclosed>:
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802429:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80242c:	50                   	push   %eax
  80242d:	ff 75 08             	pushl  0x8(%ebp)
  802430:	e8 17 f5 ff ff       	call   80194c <fd_lookup>
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	85 c0                	test   %eax,%eax
  80243a:	78 18                	js     802454 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80243c:	83 ec 0c             	sub    $0xc,%esp
  80243f:	ff 75 f4             	pushl  -0xc(%ebp)
  802442:	e8 9f f4 ff ff       	call   8018e6 <fd2data>
	return _pipeisclosed(fd, p);
  802447:	89 c2                	mov    %eax,%edx
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	e8 37 fd ff ff       	call   802188 <_pipeisclosed>
  802451:	83 c4 10             	add    $0x10,%esp
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	5d                   	pop    %ebp
  80245f:	c3                   	ret    

00802460 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	53                   	push   %ebx
  802464:	83 ec 0c             	sub    $0xc,%esp
  802467:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  80246a:	68 d5 34 80 00       	push   $0x8034d5
  80246f:	53                   	push   %ebx
  802470:	e8 f7 ed ff ff       	call   80126c <strcpy>
	stat->st_type = FTYPE_IFCHR;
  802475:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  80247c:	20 00 00 
	return 0;
}
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
  802484:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <devcons_write>:
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	57                   	push   %edi
  80248d:	56                   	push   %esi
  80248e:	53                   	push   %ebx
  80248f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802495:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80249a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024a0:	eb 1d                	jmp    8024bf <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  8024a2:	83 ec 04             	sub    $0x4,%esp
  8024a5:	53                   	push   %ebx
  8024a6:	03 45 0c             	add    0xc(%ebp),%eax
  8024a9:	50                   	push   %eax
  8024aa:	57                   	push   %edi
  8024ab:	e8 2f ef ff ff       	call   8013df <memmove>
		sys_cputs(buf, m);
  8024b0:	83 c4 08             	add    $0x8,%esp
  8024b3:	53                   	push   %ebx
  8024b4:	57                   	push   %edi
  8024b5:	e8 ca f0 ff ff       	call   801584 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024ba:	01 de                	add    %ebx,%esi
  8024bc:	83 c4 10             	add    $0x10,%esp
  8024bf:	89 f0                	mov    %esi,%eax
  8024c1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024c4:	73 11                	jae    8024d7 <devcons_write+0x4e>
		m = n - tot;
  8024c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024c9:	29 f3                	sub    %esi,%ebx
  8024cb:	83 fb 7f             	cmp    $0x7f,%ebx
  8024ce:	76 d2                	jbe    8024a2 <devcons_write+0x19>
  8024d0:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  8024d5:	eb cb                	jmp    8024a2 <devcons_write+0x19>
}
  8024d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024da:	5b                   	pop    %ebx
  8024db:	5e                   	pop    %esi
  8024dc:	5f                   	pop    %edi
  8024dd:	5d                   	pop    %ebp
  8024de:	c3                   	ret    

008024df <devcons_read>:
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  8024e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024e9:	75 0c                	jne    8024f7 <devcons_read+0x18>
		return 0;
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f0:	eb 21                	jmp    802513 <devcons_read+0x34>
		sys_yield();
  8024f2:	e8 f1 f1 ff ff       	call   8016e8 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8024f7:	e8 a6 f0 ff ff       	call   8015a2 <sys_cgetc>
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	74 f2                	je     8024f2 <devcons_read+0x13>
	if (c < 0)
  802500:	85 c0                	test   %eax,%eax
  802502:	78 0f                	js     802513 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  802504:	83 f8 04             	cmp    $0x4,%eax
  802507:	74 0c                	je     802515 <devcons_read+0x36>
	*(char*)vbuf = c;
  802509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250c:	88 02                	mov    %al,(%edx)
	return 1;
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    
		return 0;
  802515:	b8 00 00 00 00       	mov    $0x0,%eax
  80251a:	eb f7                	jmp    802513 <devcons_read+0x34>

0080251c <cputchar>:
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802528:	6a 01                	push   $0x1
  80252a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80252d:	50                   	push   %eax
  80252e:	e8 51 f0 ff ff       	call   801584 <sys_cputs>
}
  802533:	83 c4 10             	add    $0x10,%esp
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <getchar>:
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80253e:	6a 01                	push   $0x1
  802540:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802543:	50                   	push   %eax
  802544:	6a 00                	push   $0x0
  802546:	e8 6e f6 ff ff       	call   801bb9 <read>
	if (r < 0)
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	85 c0                	test   %eax,%eax
  802550:	78 08                	js     80255a <getchar+0x22>
	if (r < 1)
  802552:	85 c0                	test   %eax,%eax
  802554:	7e 06                	jle    80255c <getchar+0x24>
	return c;
  802556:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    
		return -E_EOF;
  80255c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802561:	eb f7                	jmp    80255a <getchar+0x22>

00802563 <iscons>:
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802569:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80256c:	50                   	push   %eax
  80256d:	ff 75 08             	pushl  0x8(%ebp)
  802570:	e8 d7 f3 ff ff       	call   80194c <fd_lookup>
  802575:	83 c4 10             	add    $0x10,%esp
  802578:	85 c0                	test   %eax,%eax
  80257a:	78 11                	js     80258d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802585:	39 10                	cmp    %edx,(%eax)
  802587:	0f 94 c0             	sete   %al
  80258a:	0f b6 c0             	movzbl %al,%eax
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <opencons>:
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802595:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802598:	50                   	push   %eax
  802599:	e8 5f f3 ff ff       	call   8018fd <fd_alloc>
  80259e:	83 c4 10             	add    $0x10,%esp
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	78 3a                	js     8025df <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025a5:	83 ec 04             	sub    $0x4,%esp
  8025a8:	68 07 04 00 00       	push   $0x407
  8025ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b0:	6a 00                	push   $0x0
  8025b2:	e8 6a f0 ff ff       	call   801621 <sys_page_alloc>
  8025b7:	83 c4 10             	add    $0x10,%esp
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	78 21                	js     8025df <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8025be:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025d3:	83 ec 0c             	sub    $0xc,%esp
  8025d6:	50                   	push   %eax
  8025d7:	e8 fa f2 ff ff       	call   8018d6 <fd2num>
  8025dc:	83 c4 10             	add    $0x10,%esp
}
  8025df:	c9                   	leave  
  8025e0:	c3                   	ret    

008025e1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	53                   	push   %ebx
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8025eb:	8b 13                	mov    (%ebx),%edx
  8025ed:	8d 42 01             	lea    0x1(%edx),%eax
  8025f0:	89 03                	mov    %eax,(%ebx)
  8025f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8025f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8025fe:	74 08                	je     802608 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  802600:	ff 43 04             	incl   0x4(%ebx)
}
  802603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802606:	c9                   	leave  
  802607:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  802608:	83 ec 08             	sub    $0x8,%esp
  80260b:	68 ff 00 00 00       	push   $0xff
  802610:	8d 43 08             	lea    0x8(%ebx),%eax
  802613:	50                   	push   %eax
  802614:	e8 6b ef ff ff       	call   801584 <sys_cputs>
		b->idx = 0;
  802619:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80261f:	83 c4 10             	add    $0x10,%esp
  802622:	eb dc                	jmp    802600 <putch+0x1f>

00802624 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80262d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802634:	00 00 00 
	b.cnt = 0;
  802637:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80263e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  802641:	ff 75 0c             	pushl  0xc(%ebp)
  802644:	ff 75 08             	pushl  0x8(%ebp)
  802647:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80264d:	50                   	push   %eax
  80264e:	68 e1 25 80 00       	push   $0x8025e1
  802653:	e8 06 e7 ff ff       	call   800d5e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  802658:	83 c4 08             	add    $0x8,%esp
  80265b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  802661:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  802667:	50                   	push   %eax
  802668:	e8 17 ef ff ff       	call   801584 <sys_cputs>

	return b.cnt;
}
  80266d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80267b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80267e:	50                   	push   %eax
  80267f:	ff 75 08             	pushl  0x8(%ebp)
  802682:	e8 9d ff ff ff       	call   802624 <vcprintf>
	va_end(ap);

	return cnt;
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
  80268c:	57                   	push   %edi
  80268d:	56                   	push   %esi
  80268e:	53                   	push   %ebx
  80268f:	83 ec 0c             	sub    $0xc,%esp
  802692:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802695:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802698:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  80269b:	85 ff                	test   %edi,%edi
  80269d:	74 53                	je     8026f2 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  80269f:	83 ec 0c             	sub    $0xc,%esp
  8026a2:	57                   	push   %edi
  8026a3:	e8 89 f1 ff ff       	call   801831 <sys_ipc_recv>
  8026a8:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  8026ab:	85 db                	test   %ebx,%ebx
  8026ad:	74 0b                	je     8026ba <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8026af:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8026b5:	8b 52 74             	mov    0x74(%edx),%edx
  8026b8:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  8026ba:	85 f6                	test   %esi,%esi
  8026bc:	74 0f                	je     8026cd <ipc_recv+0x44>
  8026be:	85 ff                	test   %edi,%edi
  8026c0:	74 0b                	je     8026cd <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8026c2:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8026c8:	8b 52 78             	mov    0x78(%edx),%edx
  8026cb:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 30                	je     802701 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  8026d1:	85 db                	test   %ebx,%ebx
  8026d3:	74 06                	je     8026db <ipc_recv+0x52>
      		*from_env_store = 0;
  8026d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  8026db:	85 f6                	test   %esi,%esi
  8026dd:	74 2c                	je     80270b <ipc_recv+0x82>
      		*perm_store = 0;
  8026df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  8026e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  8026ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5e                   	pop    %esi
  8026ef:	5f                   	pop    %edi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8026f2:	83 ec 0c             	sub    $0xc,%esp
  8026f5:	6a ff                	push   $0xffffffff
  8026f7:	e8 35 f1 ff ff       	call   801831 <sys_ipc_recv>
  8026fc:	83 c4 10             	add    $0x10,%esp
  8026ff:	eb aa                	jmp    8026ab <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  802701:	a1 08 50 80 00       	mov    0x805008,%eax
  802706:	8b 40 70             	mov    0x70(%eax),%eax
  802709:	eb df                	jmp    8026ea <ipc_recv+0x61>
		return -1;
  80270b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802710:	eb d8                	jmp    8026ea <ipc_recv+0x61>

00802712 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
  802715:	57                   	push   %edi
  802716:	56                   	push   %esi
  802717:	53                   	push   %ebx
  802718:	83 ec 0c             	sub    $0xc,%esp
  80271b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80271e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802721:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  802724:	85 db                	test   %ebx,%ebx
  802726:	75 22                	jne    80274a <ipc_send+0x38>
		pg = (void *) UTOP+1;
  802728:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  80272d:	eb 1b                	jmp    80274a <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  80272f:	68 e4 34 80 00       	push   $0x8034e4
  802734:	68 da 2c 80 00       	push   $0x802cda
  802739:	6a 48                	push   $0x48
  80273b:	68 08 35 80 00       	push   $0x803508
  802740:	e8 b4 e4 ff ff       	call   800bf9 <_panic>
		sys_yield();
  802745:	e8 9e ef ff ff       	call   8016e8 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  80274a:	57                   	push   %edi
  80274b:	53                   	push   %ebx
  80274c:	56                   	push   %esi
  80274d:	ff 75 08             	pushl  0x8(%ebp)
  802750:	e8 b9 f0 ff ff       	call   80180e <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  802755:	83 c4 10             	add    $0x10,%esp
  802758:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80275b:	74 e8                	je     802745 <ipc_send+0x33>
  80275d:	85 c0                	test   %eax,%eax
  80275f:	75 ce                	jne    80272f <ipc_send+0x1d>
		sys_yield();
  802761:	e8 82 ef ff ff       	call   8016e8 <sys_yield>
		
	}
	
}
  802766:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802769:	5b                   	pop    %ebx
  80276a:	5e                   	pop    %esi
  80276b:	5f                   	pop    %edi
  80276c:	5d                   	pop    %ebp
  80276d:	c3                   	ret    

0080276e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802774:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802779:	89 c2                	mov    %eax,%edx
  80277b:	c1 e2 05             	shl    $0x5,%edx
  80277e:	29 c2                	sub    %eax,%edx
  802780:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  802787:	8b 52 50             	mov    0x50(%edx),%edx
  80278a:	39 ca                	cmp    %ecx,%edx
  80278c:	74 0f                	je     80279d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80278e:	40                   	inc    %eax
  80278f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802794:	75 e3                	jne    802779 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
  80279b:	eb 11                	jmp    8027ae <ipc_find_env+0x40>
			return envs[i].env_id;
  80279d:	89 c2                	mov    %eax,%edx
  80279f:	c1 e2 05             	shl    $0x5,%edx
  8027a2:	29 c2                	sub    %eax,%edx
  8027a4:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8027ab:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027ae:	5d                   	pop    %ebp
  8027af:	c3                   	ret    

008027b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b6:	c1 e8 16             	shr    $0x16,%eax
  8027b9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8027c0:	a8 01                	test   $0x1,%al
  8027c2:	74 21                	je     8027e5 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	c1 e8 0c             	shr    $0xc,%eax
  8027ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027d1:	a8 01                	test   $0x1,%al
  8027d3:	74 17                	je     8027ec <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027d5:	c1 e8 0c             	shr    $0xc,%eax
  8027d8:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  8027df:	ef 
  8027e0:	0f b7 c0             	movzwl %ax,%eax
  8027e3:	eb 05                	jmp    8027ea <pageref+0x3a>
		return 0;
  8027e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ea:	5d                   	pop    %ebp
  8027eb:	c3                   	ret    
		return 0;
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f1:	eb f7                	jmp    8027ea <pageref+0x3a>
  8027f3:	90                   	nop

008027f4 <__udivdi3>:
  8027f4:	55                   	push   %ebp
  8027f5:	57                   	push   %edi
  8027f6:	56                   	push   %esi
  8027f7:	53                   	push   %ebx
  8027f8:	83 ec 1c             	sub    $0x1c,%esp
  8027fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8027ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802803:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802807:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80280b:	89 ca                	mov    %ecx,%edx
  80280d:	89 f8                	mov    %edi,%eax
  80280f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802813:	85 f6                	test   %esi,%esi
  802815:	75 2d                	jne    802844 <__udivdi3+0x50>
  802817:	39 cf                	cmp    %ecx,%edi
  802819:	77 65                	ja     802880 <__udivdi3+0x8c>
  80281b:	89 fd                	mov    %edi,%ebp
  80281d:	85 ff                	test   %edi,%edi
  80281f:	75 0b                	jne    80282c <__udivdi3+0x38>
  802821:	b8 01 00 00 00       	mov    $0x1,%eax
  802826:	31 d2                	xor    %edx,%edx
  802828:	f7 f7                	div    %edi
  80282a:	89 c5                	mov    %eax,%ebp
  80282c:	31 d2                	xor    %edx,%edx
  80282e:	89 c8                	mov    %ecx,%eax
  802830:	f7 f5                	div    %ebp
  802832:	89 c1                	mov    %eax,%ecx
  802834:	89 d8                	mov    %ebx,%eax
  802836:	f7 f5                	div    %ebp
  802838:	89 cf                	mov    %ecx,%edi
  80283a:	89 fa                	mov    %edi,%edx
  80283c:	83 c4 1c             	add    $0x1c,%esp
  80283f:	5b                   	pop    %ebx
  802840:	5e                   	pop    %esi
  802841:	5f                   	pop    %edi
  802842:	5d                   	pop    %ebp
  802843:	c3                   	ret    
  802844:	39 ce                	cmp    %ecx,%esi
  802846:	77 28                	ja     802870 <__udivdi3+0x7c>
  802848:	0f bd fe             	bsr    %esi,%edi
  80284b:	83 f7 1f             	xor    $0x1f,%edi
  80284e:	75 40                	jne    802890 <__udivdi3+0x9c>
  802850:	39 ce                	cmp    %ecx,%esi
  802852:	72 0a                	jb     80285e <__udivdi3+0x6a>
  802854:	3b 44 24 04          	cmp    0x4(%esp),%eax
  802858:	0f 87 9e 00 00 00    	ja     8028fc <__udivdi3+0x108>
  80285e:	b8 01 00 00 00       	mov    $0x1,%eax
  802863:	89 fa                	mov    %edi,%edx
  802865:	83 c4 1c             	add    $0x1c,%esp
  802868:	5b                   	pop    %ebx
  802869:	5e                   	pop    %esi
  80286a:	5f                   	pop    %edi
  80286b:	5d                   	pop    %ebp
  80286c:	c3                   	ret    
  80286d:	8d 76 00             	lea    0x0(%esi),%esi
  802870:	31 ff                	xor    %edi,%edi
  802872:	31 c0                	xor    %eax,%eax
  802874:	89 fa                	mov    %edi,%edx
  802876:	83 c4 1c             	add    $0x1c,%esp
  802879:	5b                   	pop    %ebx
  80287a:	5e                   	pop    %esi
  80287b:	5f                   	pop    %edi
  80287c:	5d                   	pop    %ebp
  80287d:	c3                   	ret    
  80287e:	66 90                	xchg   %ax,%ax
  802880:	89 d8                	mov    %ebx,%eax
  802882:	f7 f7                	div    %edi
  802884:	31 ff                	xor    %edi,%edi
  802886:	89 fa                	mov    %edi,%edx
  802888:	83 c4 1c             	add    $0x1c,%esp
  80288b:	5b                   	pop    %ebx
  80288c:	5e                   	pop    %esi
  80288d:	5f                   	pop    %edi
  80288e:	5d                   	pop    %ebp
  80288f:	c3                   	ret    
  802890:	bd 20 00 00 00       	mov    $0x20,%ebp
  802895:	29 fd                	sub    %edi,%ebp
  802897:	89 f9                	mov    %edi,%ecx
  802899:	d3 e6                	shl    %cl,%esi
  80289b:	89 c3                	mov    %eax,%ebx
  80289d:	89 e9                	mov    %ebp,%ecx
  80289f:	d3 eb                	shr    %cl,%ebx
  8028a1:	89 d9                	mov    %ebx,%ecx
  8028a3:	09 f1                	or     %esi,%ecx
  8028a5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028a9:	89 f9                	mov    %edi,%ecx
  8028ab:	d3 e0                	shl    %cl,%eax
  8028ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028b1:	89 d6                	mov    %edx,%esi
  8028b3:	89 e9                	mov    %ebp,%ecx
  8028b5:	d3 ee                	shr    %cl,%esi
  8028b7:	89 f9                	mov    %edi,%ecx
  8028b9:	d3 e2                	shl    %cl,%edx
  8028bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8028bf:	89 e9                	mov    %ebp,%ecx
  8028c1:	d3 eb                	shr    %cl,%ebx
  8028c3:	09 da                	or     %ebx,%edx
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	89 f2                	mov    %esi,%edx
  8028c9:	f7 74 24 08          	divl   0x8(%esp)
  8028cd:	89 d6                	mov    %edx,%esi
  8028cf:	89 c3                	mov    %eax,%ebx
  8028d1:	f7 64 24 0c          	mull   0xc(%esp)
  8028d5:	39 d6                	cmp    %edx,%esi
  8028d7:	72 17                	jb     8028f0 <__udivdi3+0xfc>
  8028d9:	74 09                	je     8028e4 <__udivdi3+0xf0>
  8028db:	89 d8                	mov    %ebx,%eax
  8028dd:	31 ff                	xor    %edi,%edi
  8028df:	e9 56 ff ff ff       	jmp    80283a <__udivdi3+0x46>
  8028e4:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028e8:	89 f9                	mov    %edi,%ecx
  8028ea:	d3 e2                	shl    %cl,%edx
  8028ec:	39 c2                	cmp    %eax,%edx
  8028ee:	73 eb                	jae    8028db <__udivdi3+0xe7>
  8028f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028f3:	31 ff                	xor    %edi,%edi
  8028f5:	e9 40 ff ff ff       	jmp    80283a <__udivdi3+0x46>
  8028fa:	66 90                	xchg   %ax,%ax
  8028fc:	31 c0                	xor    %eax,%eax
  8028fe:	e9 37 ff ff ff       	jmp    80283a <__udivdi3+0x46>
  802903:	90                   	nop

00802904 <__umoddi3>:
  802904:	55                   	push   %ebp
  802905:	57                   	push   %edi
  802906:	56                   	push   %esi
  802907:	53                   	push   %ebx
  802908:	83 ec 1c             	sub    $0x1c,%esp
  80290b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80290f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802913:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802917:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80291b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80291f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802923:	89 3c 24             	mov    %edi,(%esp)
  802926:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80292a:	89 f2                	mov    %esi,%edx
  80292c:	85 c0                	test   %eax,%eax
  80292e:	75 18                	jne    802948 <__umoddi3+0x44>
  802930:	39 f7                	cmp    %esi,%edi
  802932:	0f 86 a0 00 00 00    	jbe    8029d8 <__umoddi3+0xd4>
  802938:	89 c8                	mov    %ecx,%eax
  80293a:	f7 f7                	div    %edi
  80293c:	89 d0                	mov    %edx,%eax
  80293e:	31 d2                	xor    %edx,%edx
  802940:	83 c4 1c             	add    $0x1c,%esp
  802943:	5b                   	pop    %ebx
  802944:	5e                   	pop    %esi
  802945:	5f                   	pop    %edi
  802946:	5d                   	pop    %ebp
  802947:	c3                   	ret    
  802948:	89 f3                	mov    %esi,%ebx
  80294a:	39 f0                	cmp    %esi,%eax
  80294c:	0f 87 a6 00 00 00    	ja     8029f8 <__umoddi3+0xf4>
  802952:	0f bd e8             	bsr    %eax,%ebp
  802955:	83 f5 1f             	xor    $0x1f,%ebp
  802958:	0f 84 a6 00 00 00    	je     802a04 <__umoddi3+0x100>
  80295e:	bf 20 00 00 00       	mov    $0x20,%edi
  802963:	29 ef                	sub    %ebp,%edi
  802965:	89 e9                	mov    %ebp,%ecx
  802967:	d3 e0                	shl    %cl,%eax
  802969:	8b 34 24             	mov    (%esp),%esi
  80296c:	89 f2                	mov    %esi,%edx
  80296e:	89 f9                	mov    %edi,%ecx
  802970:	d3 ea                	shr    %cl,%edx
  802972:	09 c2                	or     %eax,%edx
  802974:	89 14 24             	mov    %edx,(%esp)
  802977:	89 f2                	mov    %esi,%edx
  802979:	89 e9                	mov    %ebp,%ecx
  80297b:	d3 e2                	shl    %cl,%edx
  80297d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802981:	89 de                	mov    %ebx,%esi
  802983:	89 f9                	mov    %edi,%ecx
  802985:	d3 ee                	shr    %cl,%esi
  802987:	89 e9                	mov    %ebp,%ecx
  802989:	d3 e3                	shl    %cl,%ebx
  80298b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80298f:	89 d0                	mov    %edx,%eax
  802991:	89 f9                	mov    %edi,%ecx
  802993:	d3 e8                	shr    %cl,%eax
  802995:	09 d8                	or     %ebx,%eax
  802997:	89 d3                	mov    %edx,%ebx
  802999:	89 e9                	mov    %ebp,%ecx
  80299b:	d3 e3                	shl    %cl,%ebx
  80299d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029a1:	89 f2                	mov    %esi,%edx
  8029a3:	f7 34 24             	divl   (%esp)
  8029a6:	89 d6                	mov    %edx,%esi
  8029a8:	f7 64 24 04          	mull   0x4(%esp)
  8029ac:	89 c3                	mov    %eax,%ebx
  8029ae:	89 d1                	mov    %edx,%ecx
  8029b0:	39 d6                	cmp    %edx,%esi
  8029b2:	72 7c                	jb     802a30 <__umoddi3+0x12c>
  8029b4:	74 72                	je     802a28 <__umoddi3+0x124>
  8029b6:	8b 54 24 08          	mov    0x8(%esp),%edx
  8029ba:	29 da                	sub    %ebx,%edx
  8029bc:	19 ce                	sbb    %ecx,%esi
  8029be:	89 f0                	mov    %esi,%eax
  8029c0:	89 f9                	mov    %edi,%ecx
  8029c2:	d3 e0                	shl    %cl,%eax
  8029c4:	89 e9                	mov    %ebp,%ecx
  8029c6:	d3 ea                	shr    %cl,%edx
  8029c8:	09 d0                	or     %edx,%eax
  8029ca:	89 e9                	mov    %ebp,%ecx
  8029cc:	d3 ee                	shr    %cl,%esi
  8029ce:	89 f2                	mov    %esi,%edx
  8029d0:	83 c4 1c             	add    $0x1c,%esp
  8029d3:	5b                   	pop    %ebx
  8029d4:	5e                   	pop    %esi
  8029d5:	5f                   	pop    %edi
  8029d6:	5d                   	pop    %ebp
  8029d7:	c3                   	ret    
  8029d8:	89 fd                	mov    %edi,%ebp
  8029da:	85 ff                	test   %edi,%edi
  8029dc:	75 0b                	jne    8029e9 <__umoddi3+0xe5>
  8029de:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e3:	31 d2                	xor    %edx,%edx
  8029e5:	f7 f7                	div    %edi
  8029e7:	89 c5                	mov    %eax,%ebp
  8029e9:	89 f0                	mov    %esi,%eax
  8029eb:	31 d2                	xor    %edx,%edx
  8029ed:	f7 f5                	div    %ebp
  8029ef:	89 c8                	mov    %ecx,%eax
  8029f1:	f7 f5                	div    %ebp
  8029f3:	e9 44 ff ff ff       	jmp    80293c <__umoddi3+0x38>
  8029f8:	89 c8                	mov    %ecx,%eax
  8029fa:	89 f2                	mov    %esi,%edx
  8029fc:	83 c4 1c             	add    $0x1c,%esp
  8029ff:	5b                   	pop    %ebx
  802a00:	5e                   	pop    %esi
  802a01:	5f                   	pop    %edi
  802a02:	5d                   	pop    %ebp
  802a03:	c3                   	ret    
  802a04:	39 f0                	cmp    %esi,%eax
  802a06:	72 05                	jb     802a0d <__umoddi3+0x109>
  802a08:	39 0c 24             	cmp    %ecx,(%esp)
  802a0b:	77 0c                	ja     802a19 <__umoddi3+0x115>
  802a0d:	89 f2                	mov    %esi,%edx
  802a0f:	29 f9                	sub    %edi,%ecx
  802a11:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a15:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a19:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a1d:	83 c4 1c             	add    $0x1c,%esp
  802a20:	5b                   	pop    %ebx
  802a21:	5e                   	pop    %esi
  802a22:	5f                   	pop    %edi
  802a23:	5d                   	pop    %ebp
  802a24:	c3                   	ret    
  802a25:	8d 76 00             	lea    0x0(%esi),%esi
  802a28:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802a2c:	73 88                	jae    8029b6 <__umoddi3+0xb2>
  802a2e:	66 90                	xchg   %ax,%ax
  802a30:	2b 44 24 04          	sub    0x4(%esp),%eax
  802a34:	1b 14 24             	sbb    (%esp),%edx
  802a37:	89 d1                	mov    %edx,%ecx
  802a39:	89 c3                	mov    %eax,%ebx
  802a3b:	e9 76 ff ff ff       	jmp    8029b6 <__umoddi3+0xb2>
