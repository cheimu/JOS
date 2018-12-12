
obj/user/gofib.debug:     file format elf32-i386


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
  80002c:	e8 30 09 00 00       	call   800961 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <main.$nested0>:

// fib returns a function that returns
// successive Fibonacci numbers.
func fib() func() int {
	a, b := 0, 1
	return func() int {
  800033:	56                   	push   %esi
  800034:	53                   	push   %ebx
		a, b = b, a+b
  800035:	8b 59 04             	mov    0x4(%ecx),%ebx
  800038:	8b 51 08             	mov    0x8(%ecx),%edx
  80003b:	8b 02                	mov    (%edx),%eax
  80003d:	8b 33                	mov    (%ebx),%esi
  80003f:	89 03                	mov    %eax,(%ebx)
  800041:	01 f0                	add    %esi,%eax
  800043:	89 02                	mov    %eax,(%edx)
		return a
  800045:	8b 41 04             	mov    0x4(%ecx),%eax
  800048:	8b 00                	mov    (%eax),%eax
	return func() int {
  80004a:	5b                   	pop    %ebx
  80004b:	5e                   	pop    %esi
  80004c:	c3                   	ret    

0080004d <main.AIe1e$hash>:
  80004d:	83 ec 14             	sub    $0x14,%esp
  800050:	6a 08                	push   $0x8
  800052:	ff 74 24 1c          	pushl  0x1c(%esp)
  800056:	e8 20 01 00 00       	call   80017b <__go_type_hash_empty_interface>
  80005b:	83 c4 1c             	add    $0x1c,%esp
  80005e:	c3                   	ret    

0080005f <main.AIe1e$equal>:
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	8b 44 24 14          	mov    0x14(%esp),%eax
  800066:	ff 70 04             	pushl  0x4(%eax)
  800069:	ff 30                	pushl  (%eax)
  80006b:	8b 44 24 18          	mov    0x18(%esp),%eax
  80006f:	ff 70 04             	pushl  0x4(%eax)
  800072:	ff 30                	pushl  (%eax)
  800074:	e8 75 03 00 00       	call   8003ee <__go_empty_interface_compare>
  800079:	85 c0                	test   %eax,%eax
  80007b:	0f 94 c0             	sete   %al
  80007e:	83 c4 1c             	add    $0x1c,%esp
  800081:	c3                   	ret    

00800082 <main.main>:
	}
}

func main() {
  800082:	55                   	push   %ebp
  800083:	57                   	push   %edi
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	83 ec 24             	sub    $0x24,%esp
	a, b := 0, 1
  800089:	6a 04                	push   $0x4
  80008b:	68 00 2d 80 00       	push   $0x802d00
  800090:	e8 3c 02 00 00       	call   8002d1 <__go_new>
  800095:	89 c6                	mov    %eax,%esi
  800097:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80009d:	83 c4 08             	add    $0x8,%esp
  8000a0:	6a 04                	push   $0x4
  8000a2:	68 00 2d 80 00       	push   $0x802d00
  8000a7:	e8 25 02 00 00       	call   8002d1 <__go_new>
  8000ac:	89 c3                	mov    %eax,%ebx
  8000ae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	return func() int {
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	6a 0c                	push   $0xc
  8000b9:	68 40 2c 80 00       	push   $0x802c40
  8000be:	e8 0e 02 00 00       	call   8002d1 <__go_new>
  8000c3:	89 c5                	mov    %eax,%ebp
  8000c5:	c7 00 33 00 80 00    	movl   $0x800033,(%eax)
  8000cb:	89 70 04             	mov    %esi,0x4(%eax)
  8000ce:	89 58 08             	mov    %ebx,0x8(%eax)
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	f := fib()
	for i := 0; i < 10; i++ {
		sys.Println(f())
  8000d9:	89 e9                	mov    %ebp,%ecx
  8000db:	ff 55 00             	call   *0x0(%ebp)
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	83 ec 08             	sub    $0x8,%esp
  8000e3:	6a 08                	push   $0x8
  8000e5:	68 c0 2a 80 00       	push   $0x802ac0
  8000ea:	e8 e2 01 00 00       	call   8002d1 <__go_new>
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 04                	push   $0x4
  8000f6:	68 00 2d 80 00       	push   $0x802d00
  8000fb:	e8 d1 01 00 00       	call   8002d1 <__go_new>
  800100:	89 38                	mov    %edi,(%eax)
  800102:	c7 06 00 2d 80 00    	movl   $0x802d00,(%esi)
  800108:	89 46 04             	mov    %eax,0x4(%esi)
  80010b:	89 74 24 14          	mov    %esi,0x14(%esp)
  80010f:	c7 44 24 18 01 00 00 	movl   $0x1,0x18(%esp)
  800116:	00 
  800117:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  80011e:	00 
  80011f:	8d 74 24 14          	lea    0x14(%esp),%esi
  800123:	b9 03 00 00 00       	mov    $0x3,%ecx
  800128:	89 e7                	mov    %esp,%edi
  80012a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80012c:	e8 bb 07 00 00       	call   8008ec <go.sys.Println>
	for i := 0; i < 10; i++ {
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	4b                   	dec    %ebx
  800135:	75 a2                	jne    8000d9 <main.main+0x57>
func main() {
  800137:	83 c4 1c             	add    $0x1c,%esp
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <__go_init_main>:
package main
  80013f:	c3                   	ret    

00800140 <__go_type_hash_identity>:
			    const struct go_type_descriptor *td2)
asm("runtime.ifacetypeeq");

uintptr_t
__go_type_hash_identity(const void *key, uintptr_t key_size)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	53                   	push   %ebx
  800144:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800147:	89 da                	mov    %ebx,%edx
  800149:	03 5d 0c             	add    0xc(%ebp),%ebx
	uintptr_t i, hash = 5381;
  80014c:	b8 05 15 00 00       	mov    $0x1505,%eax
	const uint8_t *p = key;

	for (i = 0; i < key_size; ++i)
  800151:	eb 0d                	jmp    800160 <__go_type_hash_identity+0x20>
		hash = hash * 33 + p[i];
  800153:	89 c1                	mov    %eax,%ecx
  800155:	c1 e1 05             	shl    $0x5,%ecx
  800158:	01 c8                	add    %ecx,%eax
  80015a:	0f b6 0a             	movzbl (%edx),%ecx
  80015d:	01 c8                	add    %ecx,%eax
  80015f:	42                   	inc    %edx
	for (i = 0; i < key_size; ++i)
  800160:	39 da                	cmp    %ebx,%edx
  800162:	75 ef                	jne    800153 <__go_type_hash_identity+0x13>
	return hash;
}
  800164:	5b                   	pop    %ebx
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    

00800167 <__go_type_hash_string>:
	panic("go type equal error");
}

uintptr_t
__go_type_hash_string(const void *key, uintptr_t key_size)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	8b 45 08             	mov    0x8(%ebp),%eax
	const struct go_string *s = key;

	return __go_type_hash_identity(key, s->length);
  80016d:	ff 70 04             	pushl  0x4(%eax)
  800170:	50                   	push   %eax
  800171:	e8 ca ff ff ff       	call   800140 <__go_type_hash_identity>
  800176:	83 c4 08             	add    $0x8,%esp
}
  800179:	c9                   	leave  
  80017a:	c3                   	ret    

0080017b <__go_type_hash_empty_interface>:
	return __builtin_call_with_static_chain(e(p1, p2, size), equalfn);
}

uintptr_t
__go_type_hash_empty_interface(const struct go_empty_interface *val, uintptr_t key_size)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	53                   	push   %ebx
  80017f:	83 ec 04             	sub    $0x4,%esp
  800182:	8b 45 08             	mov    0x8(%ebp),%eax
	const struct go_type_descriptor *td = val->type_descriptor;
  800185:	8b 10                	mov    (%eax),%edx
	const void *p;

	if (!td)
  800187:	85 d2                	test   %edx,%edx
  800189:	74 2d                	je     8001b8 <__go_type_hash_empty_interface+0x3d>
	unsigned char code = td->code & GO_CODE_MASK;
  80018b:	8a 0a                	mov    (%edx),%cl
  80018d:	83 e1 1f             	and    $0x1f,%ecx
	return (code == GO_PTR) || (code == GO_UNSAFE_POINTER);
  800190:	80 f9 16             	cmp    $0x16,%cl
  800193:	74 0a                	je     80019f <__go_type_hash_empty_interface+0x24>
		return 0;
	if (__go_is_pointer_type(td))
  800195:	80 f9 1a             	cmp    $0x1a,%cl
  800198:	74 05                	je     80019f <__go_type_hash_empty_interface+0x24>
		p = &val->object;
	else
		p = val->object;
  80019a:	8b 40 04             	mov    0x4(%eax),%eax
  80019d:	eb 03                	jmp    8001a2 <__go_type_hash_empty_interface+0x27>
		p = &val->object;
  80019f:	83 c0 04             	add    $0x4,%eax
	return __go_call_hashfn(td->hashfn, p, td->size);
  8001a2:	8b 5a 0c             	mov    0xc(%edx),%ebx
	return __builtin_call_with_static_chain(h(p, size), hashfn);
  8001a5:	83 ec 08             	sub    $0x8,%esp
  8001a8:	ff 72 04             	pushl  0x4(%edx)
  8001ab:	50                   	push   %eax
  8001ac:	89 d9                	mov    %ebx,%ecx
  8001ae:	ff 13                	call   *(%ebx)
	return __go_call_hashfn(td->hashfn, p, td->size);
  8001b0:	83 c4 10             	add    $0x10,%esp
}
  8001b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    
		return 0;
  8001b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001bd:	eb f4                	jmp    8001b3 <__go_type_hash_empty_interface+0x38>

008001bf <__go_type_equal_identity>:
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	83 ec 0c             	sub    $0xc,%esp
	return memcmp(k1, k2, key_size) == 0;
  8001c5:	ff 75 10             	pushl  0x10(%ebp)
  8001c8:	ff 75 0c             	pushl  0xc(%ebp)
  8001cb:	ff 75 08             	pushl  0x8(%ebp)
  8001ce:	e8 f8 12 00 00       	call   8014cb <memcmp>
  8001d3:	83 c4 10             	add    $0x10,%esp
  8001d6:	85 c0                	test   %eax,%eax
  8001d8:	0f 94 c0             	sete   %al
}
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    

008001dd <__go_ptr_strings_equal>:
}

static _Bool
__go_ptr_strings_equal(const struct go_string *ps1, const struct go_string *ps2)
{
	if (ps1 == ps2)
  8001dd:	39 d0                	cmp    %edx,%eax
  8001df:	74 39                	je     80021a <__go_ptr_strings_equal+0x3d>
		return 1;
	if (!ps1 || !ps2)
  8001e1:	85 c0                	test   %eax,%eax
  8001e3:	74 38                	je     80021d <__go_ptr_strings_equal+0x40>
  8001e5:	85 d2                	test   %edx,%edx
  8001e7:	74 37                	je     800220 <__go_ptr_strings_equal+0x43>
  8001e9:	8b 48 04             	mov    0x4(%eax),%ecx
	return s1.length == s2.length && memcmp(s1.data, s2.data, s1.length) == 0;
  8001ec:	3b 4a 04             	cmp    0x4(%edx),%ecx
  8001ef:	74 09                	je     8001fa <__go_ptr_strings_equal+0x1d>
  8001f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f6:	83 e0 01             	and    $0x1,%eax
		return 0;
	return __go_strings_equal(*ps1, *ps2);
}
  8001f9:	c3                   	ret    
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	83 ec 0c             	sub    $0xc,%esp
	return s1.length == s2.length && memcmp(s1.data, s2.data, s1.length) == 0;
  800200:	51                   	push   %ecx
  800201:	ff 32                	pushl  (%edx)
  800203:	ff 30                	pushl  (%eax)
  800205:	e8 c1 12 00 00       	call   8014cb <memcmp>
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	85 c0                	test   %eax,%eax
  80020f:	0f 94 c0             	sete   %al
  800212:	0f b6 c0             	movzbl %al,%eax
  800215:	83 e0 01             	and    $0x1,%eax
}
  800218:	c9                   	leave  
  800219:	c3                   	ret    
		return 1;
  80021a:	b0 01                	mov    $0x1,%al
  80021c:	c3                   	ret    
		return 0;
  80021d:	b0 00                	mov    $0x0,%al
  80021f:	c3                   	ret    
  800220:	b0 00                	mov    $0x0,%al
  800222:	c3                   	ret    

00800223 <__go_type_equal_string>:

_Bool
__go_type_equal_string(const void *k1, const void *k2, uintptr_t key_size)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 08             	sub    $0x8,%esp
	return __go_ptr_strings_equal(k1, k2);
  800229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022c:	8b 45 08             	mov    0x8(%ebp),%eax
  80022f:	e8 a9 ff ff ff       	call   8001dd <__go_ptr_strings_equal>
}
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <__go_type_hash_error>:
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 0c             	sub    $0xc,%esp
	panic("go type hash error");
  80023c:	68 b4 2d 80 00       	push   $0x802db4
  800241:	6a 55                	push   $0x55
  800243:	68 c7 2d 80 00       	push   $0x802dc7
  800248:	e8 1f 0a 00 00       	call   800c6c <_panic>

0080024d <__go_type_equal_error>:
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 0c             	sub    $0xc,%esp
	panic("go type equal error");
  800253:	68 d3 2d 80 00       	push   $0x802dd3
  800258:	6a 5b                	push   $0x5b
  80025a:	68 c7 2d 80 00       	push   $0x802dc7
  80025f:	e8 08 0a 00 00       	call   800c6c <_panic>

00800264 <umain>:
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	83 ec 08             	sub    $0x8,%esp
	gomain();
  80026a:	e8 13 fe ff ff       	call   800082 <main.main>
}
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <__go_runtime_error>:
	(void *)__go_type_equal_empty_interface
};

void
__go_runtime_error(int32_t i)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	panic("go runtime error: %d", i);
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	68 e7 2d 80 00       	push   $0x802de7
  80027f:	68 e1 00 00 00       	push   $0xe1
  800284:	68 c7 2d 80 00       	push   $0x802dc7
  800289:	e8 de 09 00 00       	call   800c6c <_panic>

0080028e <__go_strcmp>:
}

int
__go_strcmp(struct go_string s1, struct go_string s2)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	56                   	push   %esi
  800292:	53                   	push   %ebx
  800293:	8b 55 08             	mov    0x8(%ebp),%edx
  800296:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800299:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029c:	8b 75 14             	mov    0x14(%ebp),%esi
	int r;

	r = memcmp(s1.data, s2.data, MIN(s1.length, s2.length));
  80029f:	83 ec 04             	sub    $0x4,%esp
  8002a2:	89 d8                	mov    %ebx,%eax
  8002a4:	39 f3                	cmp    %esi,%ebx
  8002a6:	7e 02                	jle    8002aa <__go_strcmp+0x1c>
  8002a8:	89 f0                	mov    %esi,%eax
  8002aa:	50                   	push   %eax
  8002ab:	51                   	push   %ecx
  8002ac:	52                   	push   %edx
  8002ad:	e8 19 12 00 00       	call   8014cb <memcmp>
	if (r)
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	85 c0                	test   %eax,%eax
  8002b7:	75 0a                	jne    8002c3 <__go_strcmp+0x35>
		return r;
	if (s1.length < s2.length)
  8002b9:	39 f3                	cmp    %esi,%ebx
  8002bb:	7c 0d                	jl     8002ca <__go_strcmp+0x3c>
		return -1;
	if (s1.length > s2.length)
  8002bd:	0f 9f c0             	setg   %al
  8002c0:	0f b6 c0             	movzbl %al,%eax
		return 1;
	return 0;
}
  8002c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5d                   	pop    %ebp
  8002c9:	c3                   	ret    
		return -1;
  8002ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8002cf:	eb f2                	jmp    8002c3 <__go_strcmp+0x35>

008002d1 <__go_new>:

void *
__go_new(const struct go_type_descriptor *td, uintptr_t size)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 14             	sub    $0x14,%esp
	return malloc(size);
  8002d7:	ff 75 0c             	pushl  0xc(%ebp)
  8002da:	e8 9a 07 00 00       	call   800a79 <malloc>
}
  8002df:	c9                   	leave  
  8002e0:	c3                   	ret    

008002e1 <__go_new_nopointers>:

// compatibility: for gcc 5
void *
__go_new_nopointers(const struct go_type_descriptor *td, uintptr_t size)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	83 ec 14             	sub    $0x14,%esp
	return malloc(size);
  8002e7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ea:	e8 8a 07 00 00       	call   800a79 <malloc>
	return __go_new(td, size);
}
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <__go_byte_array_to_string>:

// string

struct go_string
__go_byte_array_to_string(const void *data, int length)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	57                   	push   %edi
  8002f5:	56                   	push   %esi
  8002f6:	53                   	push   %ebx
  8002f7:	83 ec 18             	sub    $0x18,%esp
  8002fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002fd:	8b 75 10             	mov    0x10(%ebp),%esi
	struct go_string s;
	void *p;

	p = malloc(length);
  800300:	56                   	push   %esi
  800301:	e8 73 07 00 00       	call   800a79 <malloc>
  800306:	89 c7                	mov    %eax,%edi
	memcpy(p, data, length);
  800308:	83 c4 0c             	add    $0xc,%esp
  80030b:	56                   	push   %esi
  80030c:	ff 75 0c             	pushl  0xc(%ebp)
  80030f:	50                   	push   %eax
  800310:	e8 a3 11 00 00       	call   8014b8 <memcpy>
	s.data = p;
	s.length = length;
	return s;
  800315:	89 3b                	mov    %edi,(%ebx)
  800317:	89 73 04             	mov    %esi,0x4(%ebx)
}
  80031a:	89 d8                	mov    %ebx,%eax
  80031c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031f:	5b                   	pop    %ebx
  800320:	5e                   	pop    %esi
  800321:	5f                   	pop    %edi
  800322:	5d                   	pop    %ebp
  800323:	c2 04 00             	ret    $0x4

00800326 <__go_string_plus>:

struct go_string
__go_string_plus(struct go_string s1, struct go_string s2)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	57                   	push   %edi
  80032a:	56                   	push   %esi
  80032b:	53                   	push   %ebx
  80032c:	83 ec 28             	sub    $0x28,%esp
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800335:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800338:	8b 45 14             	mov    0x14(%ebp),%eax
  80033b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033e:	8b 45 18             	mov    0x18(%ebp),%eax
  800341:	89 45 dc             	mov    %eax,-0x24(%ebp)
	struct go_string s;
	void *p;

	s.length = s1.length + s2.length;
  800344:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
	p = malloc(s.length);
  800347:	57                   	push   %edi
  800348:	e8 2c 07 00 00       	call   800a79 <malloc>
	assert(p);
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	85 c0                	test   %eax,%eax
  800352:	74 32                	je     800386 <__go_string_plus+0x60>
  800354:	89 c6                	mov    %eax,%esi
	memcpy(p, s1.data, s1.length);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	53                   	push   %ebx
  80035a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035d:	50                   	push   %eax
  80035e:	e8 55 11 00 00       	call   8014b8 <memcpy>
	memcpy(p + s1.length, s2.data, s2.length);
  800363:	83 c4 0c             	add    $0xc,%esp
  800366:	ff 75 dc             	pushl  -0x24(%ebp)
  800369:	ff 75 e0             	pushl  -0x20(%ebp)
  80036c:	01 f3                	add    %esi,%ebx
  80036e:	53                   	push   %ebx
  80036f:	e8 44 11 00 00       	call   8014b8 <memcpy>
	s.data = p;
	return s;
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	89 30                	mov    %esi,(%eax)
  800379:	89 78 04             	mov    %edi,0x4(%eax)
}
  80037c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c2 04 00             	ret    $0x4
	assert(p);
  800386:	68 fc 2d 80 00       	push   $0x802dfc
  80038b:	68 fe 2d 80 00       	push   $0x802dfe
  800390:	68 30 01 00 00       	push   $0x130
  800395:	68 c7 2d 80 00       	push   $0x802dc7
  80039a:	e8 cd 08 00 00       	call   800c6c <_panic>

0080039f <runtime.efacetype>:

// interface

const struct go_type_descriptor *
efacetype(struct go_empty_interface e) {
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
	return e.type_descriptor;
}
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	5d                   	pop    %ebp
  8003a6:	c3                   	ret    

008003a7 <runtime.ifacetypeeq>:

_Bool
__go_type_descriptors_equal(const struct go_type_descriptor *td1,
			    const struct go_type_descriptor *td2)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	if (td1 == td2)
  8003b3:	39 d0                	cmp    %edx,%eax
  8003b5:	74 2b                	je     8003e2 <runtime.ifacetypeeq+0x3b>
		return 1;
	if (!td1 || !td2)
  8003b7:	85 c0                	test   %eax,%eax
  8003b9:	74 2b                	je     8003e6 <runtime.ifacetypeeq+0x3f>
  8003bb:	85 d2                	test   %edx,%edx
  8003bd:	74 2b                	je     8003ea <runtime.ifacetypeeq+0x43>
		return 0;
	if (td1->code != td2->code || td1->hash != td2->hash)
  8003bf:	8a 0a                	mov    (%edx),%cl
  8003c1:	38 08                	cmp    %cl,(%eax)
  8003c3:	74 04                	je     8003c9 <runtime.ifacetypeeq+0x22>
		return 0;
  8003c5:	b0 00                	mov    $0x0,%al
	return __go_ptr_strings_equal(td1->reflection, td2->reflection);
}
  8003c7:	c9                   	leave  
  8003c8:	c3                   	ret    
	if (td1->code != td2->code || td1->hash != td2->hash)
  8003c9:	8b 4a 08             	mov    0x8(%edx),%ecx
  8003cc:	39 48 08             	cmp    %ecx,0x8(%eax)
  8003cf:	74 04                	je     8003d5 <runtime.ifacetypeeq+0x2e>
		return 0;
  8003d1:	b0 00                	mov    $0x0,%al
  8003d3:	eb f2                	jmp    8003c7 <runtime.ifacetypeeq+0x20>
	return __go_ptr_strings_equal(td1->reflection, td2->reflection);
  8003d5:	8b 52 18             	mov    0x18(%edx),%edx
  8003d8:	8b 40 18             	mov    0x18(%eax),%eax
  8003db:	e8 fd fd ff ff       	call   8001dd <__go_ptr_strings_equal>
  8003e0:	eb e5                	jmp    8003c7 <runtime.ifacetypeeq+0x20>
		return 1;
  8003e2:	b0 01                	mov    $0x1,%al
  8003e4:	eb e1                	jmp    8003c7 <runtime.ifacetypeeq+0x20>
		return 0;
  8003e6:	b0 00                	mov    $0x0,%al
  8003e8:	eb dd                	jmp    8003c7 <runtime.ifacetypeeq+0x20>
  8003ea:	b0 00                	mov    $0x0,%al
  8003ec:	eb d9                	jmp    8003c7 <runtime.ifacetypeeq+0x20>

008003ee <__go_empty_interface_compare>:
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	57                   	push   %edi
  8003f2:	56                   	push   %esi
  8003f3:	53                   	push   %ebx
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800400:	8b 7d 14             	mov    0x14(%ebp),%edi
	if (td1 == td2)
  800403:	39 c3                	cmp    %eax,%ebx
  800405:	74 4c                	je     800453 <__go_empty_interface_compare+0x65>
	if (!td1 || !td2)
  800407:	85 db                	test   %ebx,%ebx
  800409:	74 4f                	je     80045a <__go_empty_interface_compare+0x6c>
  80040b:	85 c0                	test   %eax,%eax
  80040d:	74 52                	je     800461 <__go_empty_interface_compare+0x73>
	if (!__go_type_descriptors_equal(td1, td2))
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	50                   	push   %eax
  800413:	53                   	push   %ebx
  800414:	e8 8e ff ff ff       	call   8003a7 <runtime.ifacetypeeq>
  800419:	83 c4 10             	add    $0x10,%esp
  80041c:	84 c0                	test   %al,%al
  80041e:	74 48                	je     800468 <__go_empty_interface_compare+0x7a>
	unsigned char code = td->code & GO_CODE_MASK;
  800420:	8a 03                	mov    (%ebx),%al
  800422:	83 e0 1f             	and    $0x1f,%eax
	return (code == GO_PTR) || (code == GO_UNSAFE_POINTER);
  800425:	3c 16                	cmp    $0x16,%al
  800427:	74 20                	je     800449 <__go_empty_interface_compare+0x5b>
	if (__go_is_pointer_type(td1))
  800429:	3c 1a                	cmp    $0x1a,%al
  80042b:	74 1c                	je     800449 <__go_empty_interface_compare+0x5b>
	if (!__go_call_equalfn(td1->equalfn, v1.object, v2.object, td1->size))
  80042d:	8b 43 10             	mov    0x10(%ebx),%eax
	return __builtin_call_with_static_chain(e(p1, p2, size), equalfn);
  800430:	83 ec 04             	sub    $0x4,%esp
  800433:	ff 73 04             	pushl  0x4(%ebx)
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	89 c1                	mov    %eax,%ecx
  80043a:	ff 10                	call   *(%eax)
	if (!__go_call_equalfn(td1->equalfn, v1.object, v2.object, td1->size))
  80043c:	83 c4 10             	add    $0x10,%esp
  80043f:	85 c0                	test   %eax,%eax
  800441:	0f 94 c0             	sete   %al
  800444:	0f b6 c0             	movzbl %al,%eax
  800447:	eb 24                	jmp    80046d <__go_empty_interface_compare+0x7f>
		return v1.object == v2.object ? 0 : 1;
  800449:	39 fe                	cmp    %edi,%esi
  80044b:	0f 95 c0             	setne  %al
  80044e:	0f b6 c0             	movzbl %al,%eax
  800451:	eb 1a                	jmp    80046d <__go_empty_interface_compare+0x7f>
		return 0;
  800453:	b8 00 00 00 00       	mov    $0x0,%eax
  800458:	eb 13                	jmp    80046d <__go_empty_interface_compare+0x7f>
		return 1;
  80045a:	b8 01 00 00 00       	mov    $0x1,%eax
  80045f:	eb 0c                	jmp    80046d <__go_empty_interface_compare+0x7f>
  800461:	b8 01 00 00 00       	mov    $0x1,%eax
  800466:	eb 05                	jmp    80046d <__go_empty_interface_compare+0x7f>
		return 1;
  800468:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80046d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800470:	5b                   	pop    %ebx
  800471:	5e                   	pop    %esi
  800472:	5f                   	pop    %edi
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <__go_type_equal_empty_interface>:
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
	return __go_empty_interface_compare(*v1, *v2) == 0;
  80047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047e:	ff 70 04             	pushl  0x4(%eax)
  800481:	ff 30                	pushl  (%eax)
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	ff 70 04             	pushl  0x4(%eax)
  800489:	ff 30                	pushl  (%eax)
  80048b:	e8 5e ff ff ff       	call   8003ee <__go_empty_interface_compare>
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	85 c0                	test   %eax,%eax
  800495:	0f 94 c0             	sete   %al
}
  800498:	c9                   	leave  
  800499:	c3                   	ret    

0080049a <__go_check_interface_type>:

void
__go_check_interface_type(const struct go_type_descriptor *lhs_descriptor,
			  const struct go_type_descriptor *rhs_descriptor,
			  const struct go_type_descriptor *rhs_inter_descriptor)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
}
  80049d:	5d                   	pop    %ebp
  80049e:	c3                   	ret    

0080049f <__go_append>:

// array

struct go_open_array
__go_append(struct go_open_array a, void *bvalues, uintptr_t bcount, uintptr_t element_size)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	57                   	push   %edi
  8004a3:	56                   	push   %esi
  8004a4:	53                   	push   %ebx
  8004a5:	83 ec 1c             	sub    $0x1c,%esp
  8004a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int count;

	if (!bvalues || bcount == 0)
  8004b7:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  8004bb:	0f 84 90 00 00 00    	je     800551 <__go_append+0xb2>
  8004c1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004c5:	0f 84 86 00 00 00    	je     800551 <__go_append+0xb2>
		return a;
	assert(bcount <= INT_MAX - a.count);
  8004cb:	b8 ff ff ff 7f       	mov    $0x7fffffff,%eax
  8004d0:	29 d8                	sub    %ebx,%eax
  8004d2:	39 45 1c             	cmp    %eax,0x1c(%ebp)
  8004d5:	0f 87 83 00 00 00    	ja     80055e <__go_append+0xbf>
	count = a.count + bcount;
  8004db:	89 d8                	mov    %ebx,%eax
  8004dd:	03 45 1c             	add    0x1c(%ebp),%eax
  8004e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (count > a.capacity) {
  8004e3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e6:	7e 32                	jle    80051a <__go_append+0x7b>
		void *p = malloc(count * element_size);
  8004e8:	83 ec 0c             	sub    $0xc,%esp
  8004eb:	0f af 45 20          	imul   0x20(%ebp),%eax
  8004ef:	50                   	push   %eax
  8004f0:	e8 84 05 00 00       	call   800a79 <malloc>
  8004f5:	89 c1                	mov    %eax,%ecx

		assert(p);
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	85 c0                	test   %eax,%eax
  8004fc:	74 79                	je     800577 <__go_append+0xd8>
		memcpy(p, a.values, a.count * element_size);
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	89 d8                	mov    %ebx,%eax
  800503:	0f af 45 20          	imul   0x20(%ebp),%eax
  800507:	50                   	push   %eax
  800508:	56                   	push   %esi
  800509:	89 ce                	mov    %ecx,%esi
  80050b:	51                   	push   %ecx
  80050c:	e8 a7 0f 00 00       	call   8014b8 <memcpy>
  800511:	83 c4 10             	add    $0x10,%esp
		a.values = p;
		a.capacity = count;
  800514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800517:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	}
	memmove(a.values + a.count * element_size, bvalues, bcount * element_size);
  80051a:	83 ec 04             	sub    $0x4,%esp
  80051d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800520:	0f af 45 20          	imul   0x20(%ebp),%eax
  800524:	50                   	push   %eax
  800525:	ff 75 18             	pushl  0x18(%ebp)
  800528:	0f af 5d 20          	imul   0x20(%ebp),%ebx
  80052c:	01 f3                	add    %esi,%ebx
  80052e:	53                   	push   %ebx
  80052f:	e8 1e 0f 00 00       	call   801452 <memmove>
	a.count = count;
	return a;
  800534:	89 37                	mov    %esi,(%edi)
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	89 47 04             	mov    %eax,0x4(%edi)
  80053c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053f:	89 47 08             	mov    %eax,0x8(%edi)
  800542:	83 c4 10             	add    $0x10,%esp
}
  800545:	89 f8                	mov    %edi,%eax
  800547:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80054a:	5b                   	pop    %ebx
  80054b:	5e                   	pop    %esi
  80054c:	5f                   	pop    %edi
  80054d:	5d                   	pop    %ebp
  80054e:	c2 04 00             	ret    $0x4
		return a;
  800551:	89 37                	mov    %esi,(%edi)
  800553:	89 5f 04             	mov    %ebx,0x4(%edi)
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	89 47 08             	mov    %eax,0x8(%edi)
  80055c:	eb e7                	jmp    800545 <__go_append+0xa6>
	assert(bcount <= INT_MAX - a.count);
  80055e:	68 13 2e 80 00       	push   $0x802e13
  800563:	68 fe 2d 80 00       	push   $0x802dfe
  800568:	68 5b 01 00 00       	push   $0x15b
  80056d:	68 c7 2d 80 00       	push   $0x802dc7
  800572:	e8 f5 06 00 00       	call   800c6c <_panic>
		assert(p);
  800577:	68 fc 2d 80 00       	push   $0x802dfc
  80057c:	68 fe 2d 80 00       	push   $0x802dfe
  800581:	68 60 01 00 00       	push   $0x160
  800586:	68 c7 2d 80 00       	push   $0x802dc7
  80058b:	e8 dc 06 00 00       	call   800c6c <_panic>

00800590 <sys.AIe1e$hash>:
  800590:	83 ec 14             	sub    $0x14,%esp
  800593:	6a 08                	push   $0x8
  800595:	ff 74 24 1c          	pushl  0x1c(%esp)
  800599:	e8 dd fb ff ff       	call   80017b <__go_type_hash_empty_interface>
  80059e:	83 c4 1c             	add    $0x1c,%esp
  8005a1:	c3                   	ret    

008005a2 <sys.AIe1e$equal>:
  8005a2:	83 ec 0c             	sub    $0xc,%esp
  8005a5:	8b 44 24 14          	mov    0x14(%esp),%eax
  8005a9:	ff 70 04             	pushl  0x4(%eax)
  8005ac:	ff 30                	pushl  (%eax)
  8005ae:	8b 44 24 18          	mov    0x18(%esp),%eax
  8005b2:	ff 70 04             	pushl  0x4(%eax)
  8005b5:	ff 30                	pushl  (%eax)
  8005b7:	e8 32 fe ff ff       	call   8003ee <__go_empty_interface_compare>
  8005bc:	85 c0                	test   %eax,%eax
  8005be:	0f 94 c0             	sete   %al
  8005c1:	83 c4 1c             	add    $0x1c,%esp
  8005c4:	c3                   	ret    

008005c5 <go.sys.Itoa>:

func Println(a ...interface{}) {
	Print(append(a, "\n")...)
}

func Itoa(i int) string {
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	57                   	push   %edi
  8005c9:	56                   	push   %esi
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 34             	sub    $0x34,%esp
	var a [32]byte
  8005ce:	6a 20                	push   $0x20
  8005d0:	68 00 2f 80 00       	push   $0x802f00
  8005d5:	e8 f7 fc ff ff       	call   8002d1 <__go_new>
  8005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005e0:	85 f6                	test   %esi,%esi
  8005e2:	78 2e                	js     800612 <go.sys.Itoa+0x4d>
  8005e4:	89 f1                	mov    %esi,%ecx
	if neg {
		i = -i
	}

	k := len(a)
	for i >= 10 {
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 fe 09             	cmp    $0x9,%esi
  8005ec:	0f 8e 18 01 00 00    	jle    80070a <go.sys.Itoa+0x145>
		k--
		q := i / 10
  8005f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8005f7:	f7 ee                	imul   %esi
  8005f9:	89 d3                	mov    %edx,%ebx
  8005fb:	c1 fb 02             	sar    $0x2,%ebx
  8005fe:	c1 fe 1f             	sar    $0x1f,%esi
  800601:	29 f3                	sub    %esi,%ebx
		k--
  800603:	bf 1f 00 00 00       	mov    $0x1f,%edi
  800608:	b8 1f 00 00 00       	mov    $0x1f,%eax
  80060d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800610:	eb 15                	jmp    800627 <go.sys.Itoa+0x62>
  800612:	f7 de                	neg    %esi
  800614:	eb ce                	jmp    8005e4 <go.sys.Itoa+0x1f>
		a[k] = byte(i - q * 10 + '0')
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	6a 01                	push   $0x1
  80061b:	e8 51 fc ff ff       	call   800271 <__go_runtime_error>
  800620:	83 c4 10             	add    $0x10,%esp
		k--
  800623:	89 d9                	mov    %ebx,%ecx
		q := i / 10
  800625:	89 f3                	mov    %esi,%ebx
		a[k] = byte(i - q * 10 + '0')
  800627:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  80062e:	01 d8                	add    %ebx,%eax
  800630:	d1 e0                	shl    %eax
  800632:	83 c1 30             	add    $0x30,%ecx
  800635:	29 c1                	sub    %eax,%ecx
  800637:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80063d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
	for i >= 10 {
  800640:	83 fb 09             	cmp    $0x9,%ebx
  800643:	7e 1e                	jle    800663 <go.sys.Itoa+0x9e>
		k--
  800645:	4f                   	dec    %edi
		q := i / 10
  800646:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80064b:	f7 eb                	imul   %ebx
  80064d:	89 d6                	mov    %edx,%esi
  80064f:	c1 fe 02             	sar    $0x2,%esi
  800652:	89 d8                	mov    %ebx,%eax
  800654:	c1 f8 1f             	sar    $0x1f,%eax
  800657:	29 c6                	sub    %eax,%esi
		a[k] = byte(i - q * 10 + '0')
  800659:	83 ff 1f             	cmp    $0x1f,%edi
  80065c:	77 b8                	ja     800616 <go.sys.Itoa+0x51>
		k--
  80065e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800661:	eb c0                	jmp    800623 <go.sys.Itoa+0x5e>
		i = q
	}

	k--
  800663:	8d 77 ff             	lea    -0x1(%edi),%esi
	a[k] = byte(i + '0')
  800666:	83 fe 1f             	cmp    $0x1f,%esi
  800669:	77 4d                	ja     8006b8 <go.sys.Itoa+0xf3>
	k--
  80066b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	a[k] = byte(i + '0')
  80066e:	83 c3 30             	add    $0x30,%ebx
  800671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800674:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800677:	88 1c 08             	mov    %bl,(%eax,%ecx,1)

	if (neg) {
  80067a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80067e:	78 47                	js     8006c7 <go.sys.Itoa+0x102>
		k--
		a[k] = '-'
	}
	return string(a[k:])
  800680:	83 fe 20             	cmp    $0x20,%esi
  800683:	77 76                	ja     8006fb <go.sys.Itoa+0x136>
  800685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800688:	01 f0                	add    %esi,%eax
  80068a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068d:	b8 20 00 00 00       	mov    $0x20,%eax
  800692:	29 f0                	sub    %esi,%eax
  800694:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800697:	83 ec 04             	sub    $0x4,%esp
  80069a:	ff 75 dc             	pushl  -0x24(%ebp)
  80069d:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a0:	ff 75 08             	pushl  0x8(%ebp)
  8006a3:	e8 49 fc ff ff       	call   8002f1 <__go_byte_array_to_string>
  8006a8:	83 c4 0c             	add    $0xc,%esp
func Itoa(i int) string {
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b1:	5b                   	pop    %ebx
  8006b2:	5e                   	pop    %esi
  8006b3:	5f                   	pop    %edi
  8006b4:	5d                   	pop    %ebp
  8006b5:	c2 04 00             	ret    $0x4
	a[k] = byte(i + '0')
  8006b8:	83 ec 0c             	sub    $0xc,%esp
  8006bb:	6a 01                	push   $0x1
  8006bd:	e8 af fb ff ff       	call   800271 <__go_runtime_error>
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	eb a7                	jmp    80066e <go.sys.Itoa+0xa9>
		k--
  8006c7:	8d 77 fe             	lea    -0x2(%edi),%esi
		a[k] = '-'
  8006ca:	83 fe 1f             	cmp    $0x1f,%esi
  8006cd:	77 0f                	ja     8006de <go.sys.Itoa+0x119>
		k--
  8006cf:	89 75 d0             	mov    %esi,-0x30(%ebp)
		a[k] = '-'
  8006d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d5:	8b 7d d0             	mov    -0x30(%ebp),%edi
  8006d8:	c6 04 38 2d          	movb   $0x2d,(%eax,%edi,1)
  8006dc:	eb a2                	jmp    800680 <go.sys.Itoa+0xbb>
  8006de:	83 ec 0c             	sub    $0xc,%esp
  8006e1:	6a 01                	push   $0x1
  8006e3:	e8 89 fb ff ff       	call   800271 <__go_runtime_error>
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	eb e5                	jmp    8006d2 <go.sys.Itoa+0x10d>
		k--
  8006ed:	be 1e 00 00 00       	mov    $0x1e,%esi
  8006f2:	c7 45 d0 1e 00 00 00 	movl   $0x1e,-0x30(%ebp)
  8006f9:	eb d7                	jmp    8006d2 <go.sys.Itoa+0x10d>
	return string(a[k:])
  8006fb:	83 ec 0c             	sub    $0xc,%esp
  8006fe:	6a 04                	push   $0x4
  800700:	e8 6c fb ff ff       	call   800271 <__go_runtime_error>
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	eb 8d                	jmp    800697 <go.sys.Itoa+0xd2>
	a[k] = byte(i + '0')
  80070a:	8d 46 30             	lea    0x30(%esi),%eax
  80070d:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800710:	88 47 1f             	mov    %al,0x1f(%edi)
	if (neg) {
  800713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800717:	78 d4                	js     8006ed <go.sys.Itoa+0x128>
	k--
  800719:	be 1f 00 00 00       	mov    $0x1f,%esi
  80071e:	e9 5d ff ff ff       	jmp    800680 <go.sys.Itoa+0xbb>

00800723 <go.sys.Sprint>:
func Sprint(a ...interface{}) string {
  800723:	55                   	push   %ebp
  800724:	57                   	push   %edi
  800725:	56                   	push   %esi
  800726:	53                   	push   %ebx
  800727:	83 ec 4c             	sub    $0x4c,%esp
	for _, arg := range a {
  80072a:	8b 44 24 64          	mov    0x64(%esp),%eax
  80072e:	89 44 24 34          	mov    %eax,0x34(%esp)
  800732:	8b 44 24 68          	mov    0x68(%esp),%eax
  800736:	85 c0                	test   %eax,%eax
  800738:	0f 8e 4e 01 00 00    	jle    80088c <go.sys.Sprint+0x169>
  80073e:	89 44 24 30          	mov    %eax,0x30(%esp)
  800742:	bb 00 00 00 00       	mov    $0x0,%ebx
  800747:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
  80074e:	00 
  80074f:	c7 44 24 1c 8c 2e 80 	movl   $0x802e8c,0x1c(%esp)
  800756:	00 
		return Itoa(f)
  800757:	89 dd                	mov    %ebx,%ebp
  800759:	eb 72                	jmp    8007cd <go.sys.Sprint+0xaa>
	for _, arg := range a {
  80075b:	83 ec 0c             	sub    $0xc,%esp
  80075e:	6a 00                	push   $0x0
  800760:	e8 0c fb ff ff       	call   800271 <__go_runtime_error>
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	eb 72                	jmp    8007dc <go.sys.Sprint+0xb9>
	case string:
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 c0 2b 80 00       	push   $0x802bc0
  800772:	ff 74 24 34          	pushl  0x34(%esp)
  800776:	68 c0 30 80 00       	push   $0x8030c0
  80077b:	e8 1a fd ff ff       	call   80049a <__go_check_interface_type>
		return f
  800780:	8b 03                	mov    (%ebx),%eax
  800782:	89 44 24 20          	mov    %eax,0x20(%esp)
  800786:	8b 43 04             	mov    0x4(%ebx),%eax
  800789:	89 44 24 24          	mov    %eax,0x24(%esp)
  80078d:	83 c4 10             	add    $0x10,%esp
		s += sprintArg(arg)
  800790:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  800794:	8b 7c 24 20          	mov    0x20(%esp),%edi
  800798:	83 ec 0c             	sub    $0xc,%esp
  80079b:	ff 74 24 20          	pushl  0x20(%esp)
  80079f:	ff 74 24 20          	pushl  0x20(%esp)
  8007a3:	57                   	push   %edi
  8007a4:	56                   	push   %esi
  8007a5:	8d 44 24 54          	lea    0x54(%esp),%eax
  8007a9:	50                   	push   %eax
  8007aa:	e8 77 fb ff ff       	call   800326 <__go_string_plus>
  8007af:	8b 74 24 54          	mov    0x54(%esp),%esi
  8007b3:	8b 7c 24 58          	mov    0x58(%esp),%edi
  8007b7:	89 74 24 38          	mov    %esi,0x38(%esp)
  8007bb:	89 7c 24 3c          	mov    %edi,0x3c(%esp)
  8007bf:	45                   	inc    %ebp
	for _, arg := range a {
  8007c0:	83 c4 1c             	add    $0x1c,%esp
  8007c3:	3b 6c 24 30          	cmp    0x30(%esp),%ebp
  8007c7:	0f 84 cf 00 00 00    	je     80089c <go.sys.Sprint+0x179>
  8007cd:	85 ed                	test   %ebp,%ebp
  8007cf:	78 8a                	js     80075b <go.sys.Sprint+0x38>
  8007d1:	8d 04 ed 00 00 00 00 	lea    0x0(,%ebp,8),%eax
  8007d8:	89 44 24 24          	mov    %eax,0x24(%esp)
  8007dc:	8b 44 24 34          	mov    0x34(%esp),%eax
  8007e0:	03 44 24 24          	add    0x24(%esp),%eax
  8007e4:	8b 10                	mov    (%eax),%edx
  8007e6:	89 54 24 2c          	mov    %edx,0x2c(%esp)
  8007ea:	8b 58 04             	mov    0x4(%eax),%ebx
	switch f := arg.(type) {
  8007ed:	89 54 24 08          	mov    %edx,0x8(%esp)
  8007f1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	ff 74 24 14          	pushl  0x14(%esp)
  8007fc:	ff 74 24 14          	pushl  0x14(%esp)
  800800:	e8 9a fb ff ff       	call   80039f <runtime.efacetype>
  800805:	89 44 24 38          	mov    %eax,0x38(%esp)
	case string:
  800809:	83 c4 08             	add    $0x8,%esp
  80080c:	50                   	push   %eax
  80080d:	68 c0 30 80 00       	push   $0x8030c0
  800812:	e8 90 fb ff ff       	call   8003a7 <runtime.ifacetypeeq>
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	84 c0                	test   %al,%al
  80081c:	0f 85 48 ff ff ff    	jne    80076a <go.sys.Sprint+0x47>
	case int:
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 74 24 30          	pushl  0x30(%esp)
  800829:	68 00 2d 80 00       	push   $0x802d00
  80082e:	e8 74 fb ff ff       	call   8003a7 <runtime.ifacetypeeq>
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	84 c0                	test   %al,%al
  800838:	75 15                	jne    80084f <go.sys.Sprint+0x12c>
		return "XXX"
  80083a:	c7 44 24 10 8d 2e 80 	movl   $0x802e8d,0x10(%esp)
  800841:	00 
  800842:	c7 44 24 14 03 00 00 	movl   $0x3,0x14(%esp)
  800849:	00 
  80084a:	e9 41 ff ff ff       	jmp    800790 <go.sys.Sprint+0x6d>
	case int:
  80084f:	83 ec 04             	sub    $0x4,%esp
  800852:	68 c0 2b 80 00       	push   $0x802bc0
  800857:	ff 74 24 34          	pushl  0x34(%esp)
  80085b:	68 00 2d 80 00       	push   $0x802d00
  800860:	e8 35 fc ff ff       	call   80049a <__go_check_interface_type>
		return Itoa(f)
  800865:	83 c4 08             	add    $0x8,%esp
  800868:	ff 33                	pushl  (%ebx)
  80086a:	8d 44 24 44          	lea    0x44(%esp),%eax
  80086e:	50                   	push   %eax
  80086f:	e8 51 fd ff ff       	call   8005c5 <go.sys.Itoa>
  800874:	8b 44 24 44          	mov    0x44(%esp),%eax
  800878:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  80087c:	8b 44 24 48          	mov    0x48(%esp),%eax
  800880:	89 44 24 20          	mov    %eax,0x20(%esp)
  800884:	83 c4 0c             	add    $0xc,%esp
  800887:	e9 04 ff ff ff       	jmp    800790 <go.sys.Sprint+0x6d>
	s := ""
  80088c:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
  800893:	00 
  800894:	c7 44 24 1c 8c 2e 80 	movl   $0x802e8c,0x1c(%esp)
  80089b:	00 
	return s
  80089c:	8b 44 24 60          	mov    0x60(%esp),%eax
  8008a0:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8008a4:	89 38                	mov    %edi,(%eax)
  8008a6:	8b 7c 24 20          	mov    0x20(%esp),%edi
  8008aa:	89 78 04             	mov    %edi,0x4(%eax)
func Sprint(a ...interface{}) string {
  8008ad:	83 c4 4c             	add    $0x4c,%esp
  8008b0:	5b                   	pop    %ebx
  8008b1:	5e                   	pop    %esi
  8008b2:	5f                   	pop    %edi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c2 04 00             	ret    $0x4

008008b7 <go.sys.Print>:
func Print(a ...interface{}) {
  8008b7:	57                   	push   %edi
  8008b8:	56                   	push   %esi
  8008b9:	83 ec 14             	sub    $0x14,%esp
	s := Sprint(a...)
  8008bc:	8d 44 24 08          	lea    0x8(%esp),%eax
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8008c8:	89 e7                	mov    %esp,%edi
  8008ca:	8d 74 24 2c          	lea    0x2c(%esp),%esi
  8008ce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008d0:	50                   	push   %eax
  8008d1:	e8 4d fe ff ff       	call   800723 <go.sys.Sprint>
	sys_cputs(s)
  8008d6:	83 c4 04             	add    $0x4,%esp
  8008d9:	ff 74 24 14          	pushl  0x14(%esp)
  8008dd:	ff 74 24 14          	pushl  0x14(%esp)
  8008e1:	e8 11 0d 00 00       	call   8015f7 <sys_cputs>
func Print(a ...interface{}) {
  8008e6:	83 c4 24             	add    $0x24,%esp
  8008e9:	5e                   	pop    %esi
  8008ea:	5f                   	pop    %edi
  8008eb:	c3                   	ret    

008008ec <go.sys.Println>:
func Println(a ...interface{}) {
  8008ec:	57                   	push   %edi
  8008ed:	56                   	push   %esi
  8008ee:	53                   	push   %ebx
  8008ef:	83 ec 18             	sub    $0x18,%esp
	Print(append(a, "\n")...)
  8008f2:	6a 08                	push   $0x8
  8008f4:	68 c0 2a 80 00       	push   $0x802ac0
  8008f9:	e8 d3 f9 ff ff       	call   8002d1 <__go_new>
  8008fe:	89 c6                	mov    %eax,%esi
  800900:	83 c4 08             	add    $0x8,%esp
  800903:	6a 08                	push   $0x8
  800905:	68 c0 30 80 00       	push   $0x8030c0
  80090a:	e8 c2 f9 ff ff       	call   8002d1 <__go_new>
  80090f:	c7 00 91 2e 80 00    	movl   $0x802e91,(%eax)
  800915:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  80091c:	c7 06 c0 30 80 00    	movl   $0x8030c0,(%esi)
  800922:	89 46 04             	mov    %eax,0x4(%esi)
  800925:	8d 5c 24 14          	lea    0x14(%esp),%ebx
  800929:	83 c4 0c             	add    $0xc,%esp
  80092c:	6a 08                	push   $0x8
  80092e:	6a 01                	push   $0x1
  800930:	56                   	push   %esi
  800931:	83 ec 0c             	sub    $0xc,%esp
  800934:	b9 03 00 00 00       	mov    $0x3,%ecx
  800939:	89 e7                	mov    %esp,%edi
  80093b:	8d 74 24 3c          	lea    0x3c(%esp),%esi
  80093f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800941:	53                   	push   %ebx
  800942:	e8 58 fb ff ff       	call   80049f <__go_append>
  800947:	83 c4 0c             	add    $0xc,%esp
  80094a:	b9 03 00 00 00       	mov    $0x3,%ecx
  80094f:	89 e7                	mov    %esp,%edi
  800951:	89 de                	mov    %ebx,%esi
  800953:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800955:	e8 5d ff ff ff       	call   8008b7 <go.sys.Print>
func Println(a ...interface{}) {
  80095a:	83 c4 20             	add    $0x20,%esp
  80095d:	5b                   	pop    %ebx
  80095e:	5e                   	pop    %esi
  80095f:	5f                   	pop    %edi
  800960:	c3                   	ret    

00800961 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	56                   	push   %esi
  800965:	53                   	push   %ebx
  800966:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800969:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80096c:	e8 04 0d 00 00       	call   801675 <sys_getenvid>
  800971:	25 ff 03 00 00       	and    $0x3ff,%eax
  800976:	89 c2                	mov    %eax,%edx
  800978:	c1 e2 05             	shl    $0x5,%edx
  80097b:	29 c2                	sub    %eax,%edx
  80097d:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800984:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800989:	85 db                	test   %ebx,%ebx
  80098b:	7e 07                	jle    800994 <libmain+0x33>
		binaryname = argv[0];
  80098d:	8b 06                	mov    (%esi),%eax
  80098f:	a3 10 40 80 00       	mov    %eax,0x804010

	// call user main routine
	umain(argc, argv);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	e8 c6 f8 ff ff       	call   800264 <umain>

	// exit gracefully
	exit();
  80099e:	e8 0a 00 00 00       	call   8009ad <exit>
}
  8009a3:	83 c4 10             	add    $0x10,%esp
  8009a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009a9:	5b                   	pop    %ebx
  8009aa:	5e                   	pop    %esi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8009b3:	e8 65 11 00 00       	call   801b1d <close_all>
	sys_env_destroy(0);
  8009b8:	83 ec 0c             	sub    $0xc,%esp
  8009bb:	6a 00                	push   $0x0
  8009bd:	e8 72 0c 00 00       	call   801634 <sys_env_destroy>
}
  8009c2:	83 c4 10             	add    $0x10,%esp
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    

008009c7 <free>:
	return v;
}

void
free(void *v)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	53                   	push   %ebx
  8009cb:	83 ec 04             	sub    $0x4,%esp
  8009ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8009d1:	85 db                	test   %ebx,%ebx
  8009d3:	0f 84 8b 00 00 00    	je     800a64 <free+0x9d>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8009d9:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  8009df:	76 5c                	jbe    800a3d <free+0x76>
  8009e1:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  8009e7:	77 54                	ja     800a3d <free+0x76>

	c = ROUNDDOWN(v, PGSIZE);
  8009e9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8009ef:	89 d8                	mov    %ebx,%eax
  8009f1:	c1 e8 0c             	shr    $0xc,%eax
  8009f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8009fb:	f6 c4 02             	test   $0x2,%ah
  8009fe:	74 53                	je     800a53 <free+0x8c>
		sys_page_unmap(0, c);
  800a00:	83 ec 08             	sub    $0x8,%esp
  800a03:	53                   	push   %ebx
  800a04:	6a 00                	push   $0x0
  800a06:	e8 0e 0d 00 00       	call   801719 <sys_page_unmap>
		c += PGSIZE;
  800a0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  800a11:	83 c4 10             	add    $0x10,%esp
  800a14:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  800a1a:	76 08                	jbe    800a24 <free+0x5d>
  800a1c:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  800a22:	76 cb                	jbe    8009ef <free+0x28>
  800a24:	68 db 31 80 00       	push   $0x8031db
  800a29:	68 fe 2d 80 00       	push   $0x802dfe
  800a2e:	68 83 00 00 00       	push   $0x83
  800a33:	68 ce 31 80 00       	push   $0x8031ce
  800a38:	e8 2f 02 00 00       	call   800c6c <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  800a3d:	68 a0 31 80 00       	push   $0x8031a0
  800a42:	68 fe 2d 80 00       	push   $0x802dfe
  800a47:	6a 7c                	push   $0x7c
  800a49:	68 ce 31 80 00       	push   $0x8031ce
  800a4e:	e8 19 02 00 00       	call   800c6c <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  800a53:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  800a59:	48                   	dec    %eax
  800a5a:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  800a60:	85 c0                	test   %eax,%eax
  800a62:	74 05                	je     800a69 <free+0xa2>
		sys_page_unmap(0, c);
}
  800a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    
		sys_page_unmap(0, c);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	53                   	push   %ebx
  800a6d:	6a 00                	push   $0x0
  800a6f:	e8 a5 0c 00 00       	call   801719 <sys_page_unmap>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	eb eb                	jmp    800a64 <free+0x9d>

00800a79 <malloc>:
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	57                   	push   %edi
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	83 ec 2c             	sub    $0x2c,%esp
	if (mptr == 0)
  800a82:	a1 00 50 80 00       	mov    0x805000,%eax
  800a87:	85 c0                	test   %eax,%eax
  800a89:	74 73                	je     800afe <malloc+0x85>
	n = ROUNDUP(n, 4);
  800a8b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a8e:	83 c7 03             	add    $0x3,%edi
  800a91:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800a94:	83 e7 fc             	and    $0xfffffffc,%edi
  800a97:	89 7d dc             	mov    %edi,-0x24(%ebp)
	if (n >= MAXMALLOC)
  800a9a:	81 ff ff ff 0f 00    	cmp    $0xfffff,%edi
  800aa0:	0f 87 bc 01 00 00    	ja     800c62 <malloc+0x1e9>
	if ((uintptr_t) mptr % PGSIZE){
  800aa6:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800aab:	74 30                	je     800add <malloc+0x64>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  800aad:	89 c1                	mov    %eax,%ecx
  800aaf:	c1 e9 0c             	shr    $0xc,%ecx
  800ab2:	8d 54 38 03          	lea    0x3(%eax,%edi,1),%edx
  800ab6:	c1 ea 0c             	shr    $0xc,%edx
  800ab9:	39 d1                	cmp    %edx,%ecx
  800abb:	74 6b                	je     800b28 <malloc+0xaf>
		free(mptr);	/* drop reference to this page */
  800abd:	83 ec 0c             	sub    $0xc,%esp
  800ac0:	50                   	push   %eax
  800ac1:	e8 01 ff ff ff       	call   8009c7 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  800ac6:	a1 00 50 80 00       	mov    0x805000,%eax
  800acb:	05 00 10 00 00       	add    $0x1000,%eax
  800ad0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ad5:	a3 00 50 80 00       	mov    %eax,0x805000
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	8b 35 00 50 80 00    	mov    0x805000,%esi
{
  800ae3:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  800aea:	bf 00 00 00 00       	mov    $0x0,%edi
		if (isfree(mptr, n + 4))
  800aef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800af2:	8d 58 04             	lea    0x4(%eax),%ebx
  800af5:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  800af9:	e9 8d 00 00 00       	jmp    800b8b <malloc+0x112>
		mptr = mbegin;
  800afe:	c7 05 00 50 80 00 00 	movl   $0x8000000,0x805000
  800b05:	00 00 08 
	n = ROUNDUP(n, 4);
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	83 c0 03             	add    $0x3,%eax
  800b0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800b11:	83 e0 fc             	and    $0xfffffffc,%eax
  800b14:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (n >= MAXMALLOC)
  800b17:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  800b1c:	76 bf                	jbe    800add <malloc+0x64>
		return 0;
  800b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b23:	e9 8b 00 00 00       	jmp    800bb3 <malloc+0x13a>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  800b28:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800b2e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			(*ref)++;
  800b34:	ff 42 fc             	incl   -0x4(%edx)
			mptr += n;
  800b37:	89 fa                	mov    %edi,%edx
  800b39:	01 c2                	add    %eax,%edx
  800b3b:	89 15 00 50 80 00    	mov    %edx,0x805000
			return v;
  800b41:	eb 70                	jmp    800bb3 <malloc+0x13a>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  800b43:	05 00 10 00 00       	add    $0x1000,%eax
  800b48:	39 c1                	cmp    %eax,%ecx
  800b4a:	0f 86 92 00 00 00    	jbe    800be2 <malloc+0x169>
		if (va >= (uintptr_t) mend
  800b50:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  800b55:	77 22                	ja     800b79 <malloc+0x100>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	c1 ea 16             	shr    $0x16,%edx
  800b5c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800b63:	f6 c2 01             	test   $0x1,%dl
  800b66:	74 db                	je     800b43 <malloc+0xca>
  800b68:	89 c2                	mov    %eax,%edx
  800b6a:	c1 ea 0c             	shr    $0xc,%edx
  800b6d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800b74:	f6 c2 01             	test   $0x1,%dl
  800b77:	74 ca                	je     800b43 <malloc+0xca>
  800b79:	81 c6 00 10 00 00    	add    $0x1000,%esi
  800b7f:	0f b6 7d e3          	movzbl -0x1d(%ebp),%edi
		if (mptr == mend) {
  800b83:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
  800b89:	74 0a                	je     800b95 <malloc+0x11c>
  800b8b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  800b8e:	89 f0                	mov    %esi,%eax
  800b90:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
  800b93:	eb b3                	jmp    800b48 <malloc+0xcf>
			mptr = mbegin;
  800b95:	be 00 00 00 08       	mov    $0x8000000,%esi
  800b9a:	bf 01 00 00 00       	mov    $0x1,%edi
			if (++nwrap == 2)
  800b9f:	ff 4d d8             	decl   -0x28(%ebp)
  800ba2:	75 e7                	jne    800b8b <malloc+0x112>
  800ba4:	c7 05 00 50 80 00 00 	movl   $0x8000000,0x805000
  800bab:	00 00 08 
				return 0;	/* out of address space */
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5f                   	pop    %edi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    
				sys_page_unmap(0, mptr + i);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	89 f0                	mov    %esi,%eax
  800bc0:	03 05 00 50 80 00    	add    0x805000,%eax
  800bc6:	50                   	push   %eax
  800bc7:	6a 00                	push   $0x0
  800bc9:	e8 4b 0b 00 00       	call   801719 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  800bce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  800bd4:	83 c4 10             	add    $0x10,%esp
  800bd7:	85 f6                	test   %esi,%esi
  800bd9:	79 e0                	jns    800bbb <malloc+0x142>
			return 0;	/* out of physical memory */
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800be0:	eb d1                	jmp    800bb3 <malloc+0x13a>
  800be2:	89 f8                	mov    %edi,%eax
  800be4:	84 c0                	test   %al,%al
  800be6:	75 3c                	jne    800c24 <malloc+0x1ab>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  800be8:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < n + 4; i += PGSIZE){
  800bed:	89 f2                	mov    %esi,%edx
  800bef:	39 f3                	cmp    %esi,%ebx
  800bf1:	76 3b                	jbe    800c2e <malloc+0x1b5>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  800bf3:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
  800bf9:	39 fb                	cmp    %edi,%ebx
  800bfb:	0f 97 c0             	seta   %al
  800bfe:	0f b6 c0             	movzbl %al,%eax
  800c01:	c1 e0 09             	shl    $0x9,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  800c04:	83 ec 04             	sub    $0x4,%esp
  800c07:	83 c8 07             	or     $0x7,%eax
  800c0a:	50                   	push   %eax
  800c0b:	03 15 00 50 80 00    	add    0x805000,%edx
  800c11:	52                   	push   %edx
  800c12:	6a 00                	push   $0x0
  800c14:	e8 7b 0a 00 00       	call   801694 <sys_page_alloc>
  800c19:	83 c4 10             	add    $0x10,%esp
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	78 b7                	js     800bd7 <malloc+0x15e>
	for (i = 0; i < n + 4; i += PGSIZE){
  800c20:	89 fe                	mov    %edi,%esi
  800c22:	eb c9                	jmp    800bed <malloc+0x174>
  800c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c27:	a3 00 50 80 00       	mov    %eax,0x805000
  800c2c:	eb ba                	jmp    800be8 <malloc+0x16f>
	ref = (uint32_t*) (mptr + i - 4);
  800c2e:	a1 00 50 80 00       	mov    0x805000,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  800c33:	c7 44 30 fc 02 00 00 	movl   $0x2,-0x4(%eax,%esi,1)
  800c3a:	00 
	mptr += n;
  800c3b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c3e:	01 c2                	add    %eax,%edx
	if (n % PGSIZE == 0)
  800c40:	f7 45 d4 fc 0f 00 00 	testl  $0xffc,-0x2c(%ebp)
  800c47:	75 0e                	jne    800c57 <malloc+0x1de>
		mptr += 4;
  800c49:	83 c2 04             	add    $0x4,%edx
  800c4c:	89 15 00 50 80 00    	mov    %edx,0x805000
  800c52:	e9 5c ff ff ff       	jmp    800bb3 <malloc+0x13a>
	mptr += n;
  800c57:	89 15 00 50 80 00    	mov    %edx,0x805000
  800c5d:	e9 51 ff ff ff       	jmp    800bb3 <malloc+0x13a>
		return 0;
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
  800c67:	e9 47 ff ff ff       	jmp    800bb3 <malloc+0x13a>

00800c6c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800c78:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800c7b:	8b 1d 10 40 80 00    	mov    0x804010,%ebx
  800c81:	e8 ef 09 00 00       	call   801675 <sys_getenvid>
  800c86:	83 ec 04             	sub    $0x4,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	ff 75 08             	pushl  0x8(%ebp)
  800c8f:	53                   	push   %ebx
  800c90:	50                   	push   %eax
  800c91:	68 f4 31 80 00       	push   $0x8031f4
  800c96:	68 00 01 00 00       	push   $0x100
  800c9b:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800ca1:	56                   	push   %esi
  800ca2:	e8 eb 05 00 00       	call   801292 <snprintf>
  800ca7:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800ca9:	83 c4 20             	add    $0x20,%esp
  800cac:	57                   	push   %edi
  800cad:	ff 75 10             	pushl  0x10(%ebp)
  800cb0:	bf 00 01 00 00       	mov    $0x100,%edi
  800cb5:	89 f8                	mov    %edi,%eax
  800cb7:	29 d8                	sub    %ebx,%eax
  800cb9:	50                   	push   %eax
  800cba:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800cbd:	50                   	push   %eax
  800cbe:	e8 7a 05 00 00       	call   80123d <vsnprintf>
  800cc3:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800cc5:	83 c4 0c             	add    $0xc,%esp
  800cc8:	68 0e 36 80 00       	push   $0x80360e
  800ccd:	29 df                	sub    %ebx,%edi
  800ccf:	57                   	push   %edi
  800cd0:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800cd3:	50                   	push   %eax
  800cd4:	e8 b9 05 00 00       	call   801292 <snprintf>
	sys_cputs(buf, r);
  800cd9:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800cdc:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800cde:	53                   	push   %ebx
  800cdf:	56                   	push   %esi
  800ce0:	e8 12 09 00 00       	call   8015f7 <sys_cputs>
  800ce5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ce8:	cc                   	int3   
  800ce9:	eb fd                	jmp    800ce8 <_panic+0x7c>

00800ceb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	83 ec 1c             	sub    $0x1c,%esp
  800cf4:	89 c7                	mov    %eax,%edi
  800cf6:	89 d6                	mov    %edx,%esi
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d01:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800d0f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800d12:	39 d3                	cmp    %edx,%ebx
  800d14:	72 05                	jb     800d1b <printnum+0x30>
  800d16:	39 45 10             	cmp    %eax,0x10(%ebp)
  800d19:	77 78                	ja     800d93 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d1b:	83 ec 0c             	sub    $0xc,%esp
  800d1e:	ff 75 18             	pushl  0x18(%ebp)
  800d21:	8b 45 14             	mov    0x14(%ebp),%eax
  800d24:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d27:	53                   	push   %ebx
  800d28:	ff 75 10             	pushl  0x10(%ebp)
  800d2b:	83 ec 08             	sub    $0x8,%esp
  800d2e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d31:	ff 75 e0             	pushl  -0x20(%ebp)
  800d34:	ff 75 dc             	pushl  -0x24(%ebp)
  800d37:	ff 75 d8             	pushl  -0x28(%ebp)
  800d3a:	e8 29 1b 00 00       	call   802868 <__udivdi3>
  800d3f:	83 c4 18             	add    $0x18,%esp
  800d42:	52                   	push   %edx
  800d43:	50                   	push   %eax
  800d44:	89 f2                	mov    %esi,%edx
  800d46:	89 f8                	mov    %edi,%eax
  800d48:	e8 9e ff ff ff       	call   800ceb <printnum>
  800d4d:	83 c4 20             	add    $0x20,%esp
  800d50:	eb 11                	jmp    800d63 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	56                   	push   %esi
  800d56:	ff 75 18             	pushl  0x18(%ebp)
  800d59:	ff d7                	call   *%edi
  800d5b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800d5e:	4b                   	dec    %ebx
  800d5f:	85 db                	test   %ebx,%ebx
  800d61:	7f ef                	jg     800d52 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d63:	83 ec 08             	sub    $0x8,%esp
  800d66:	56                   	push   %esi
  800d67:	83 ec 04             	sub    $0x4,%esp
  800d6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d6d:	ff 75 e0             	pushl  -0x20(%ebp)
  800d70:	ff 75 dc             	pushl  -0x24(%ebp)
  800d73:	ff 75 d8             	pushl  -0x28(%ebp)
  800d76:	e8 fd 1b 00 00       	call   802978 <__umoddi3>
  800d7b:	83 c4 14             	add    $0x14,%esp
  800d7e:	0f be 80 17 32 80 00 	movsbl 0x803217(%eax),%eax
  800d85:	50                   	push   %eax
  800d86:	ff d7                	call   *%edi
}
  800d88:	83 c4 10             	add    $0x10,%esp
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
  800d93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800d96:	eb c6                	jmp    800d5e <printnum+0x73>

00800d98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800d9e:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800da1:	8b 10                	mov    (%eax),%edx
  800da3:	3b 50 04             	cmp    0x4(%eax),%edx
  800da6:	73 0a                	jae    800db2 <sprintputch+0x1a>
		*b->buf++ = ch;
  800da8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dab:	89 08                	mov    %ecx,(%eax)
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	88 02                	mov    %al,(%edx)
}
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <printfmt>:
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800dba:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800dbd:	50                   	push   %eax
  800dbe:	ff 75 10             	pushl  0x10(%ebp)
  800dc1:	ff 75 0c             	pushl  0xc(%ebp)
  800dc4:	ff 75 08             	pushl  0x8(%ebp)
  800dc7:	e8 05 00 00 00       	call   800dd1 <vprintfmt>
}
  800dcc:	83 c4 10             	add    $0x10,%esp
  800dcf:	c9                   	leave  
  800dd0:	c3                   	ret    

00800dd1 <vprintfmt>:
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	57                   	push   %edi
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
  800dd7:	83 ec 2c             	sub    $0x2c,%esp
  800dda:	8b 75 08             	mov    0x8(%ebp),%esi
  800ddd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800de0:	8b 7d 10             	mov    0x10(%ebp),%edi
  800de3:	e9 ae 03 00 00       	jmp    801196 <vprintfmt+0x3c5>
  800de8:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800dec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800df3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800dfa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800e01:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800e06:	8d 47 01             	lea    0x1(%edi),%eax
  800e09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e0c:	8a 17                	mov    (%edi),%dl
  800e0e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800e11:	3c 55                	cmp    $0x55,%al
  800e13:	0f 87 fe 03 00 00    	ja     801217 <vprintfmt+0x446>
  800e19:	0f b6 c0             	movzbl %al,%eax
  800e1c:	ff 24 85 60 33 80 00 	jmp    *0x803360(,%eax,4)
  800e23:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800e26:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800e2a:	eb da                	jmp    800e06 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800e2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800e2f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800e33:	eb d1                	jmp    800e06 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800e35:	0f b6 d2             	movzbl %dl,%edx
  800e38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800e43:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800e4c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800e4f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800e52:	83 f9 09             	cmp    $0x9,%ecx
  800e55:	77 52                	ja     800ea9 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800e57:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800e58:	eb e9                	jmp    800e43 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800e5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5d:	8b 00                	mov    (%eax),%eax
  800e5f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800e62:	8b 45 14             	mov    0x14(%ebp),%eax
  800e65:	8d 40 04             	lea    0x4(%eax),%eax
  800e68:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800e6b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800e6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e72:	79 92                	jns    800e06 <vprintfmt+0x35>
				width = precision, precision = -1;
  800e74:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e77:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e7a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800e81:	eb 83                	jmp    800e06 <vprintfmt+0x35>
  800e83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e87:	78 08                	js     800e91 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800e89:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800e8c:	e9 75 ff ff ff       	jmp    800e06 <vprintfmt+0x35>
  800e91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e98:	eb ef                	jmp    800e89 <vprintfmt+0xb8>
  800e9a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800e9d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800ea4:	e9 5d ff ff ff       	jmp    800e06 <vprintfmt+0x35>
  800ea9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800eac:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800eaf:	eb bd                	jmp    800e6e <vprintfmt+0x9d>
			lflag++;
  800eb1:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800eb2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800eb5:	e9 4c ff ff ff       	jmp    800e06 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800eba:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebd:	8d 78 04             	lea    0x4(%eax),%edi
  800ec0:	83 ec 08             	sub    $0x8,%esp
  800ec3:	53                   	push   %ebx
  800ec4:	ff 30                	pushl  (%eax)
  800ec6:	ff d6                	call   *%esi
			break;
  800ec8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800ecb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800ece:	e9 c0 02 00 00       	jmp    801193 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800ed3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed6:	8d 78 04             	lea    0x4(%eax),%edi
  800ed9:	8b 00                	mov    (%eax),%eax
  800edb:	85 c0                	test   %eax,%eax
  800edd:	78 2a                	js     800f09 <vprintfmt+0x138>
  800edf:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ee1:	83 f8 0f             	cmp    $0xf,%eax
  800ee4:	7f 27                	jg     800f0d <vprintfmt+0x13c>
  800ee6:	8b 04 85 c0 34 80 00 	mov    0x8034c0(,%eax,4),%eax
  800eed:	85 c0                	test   %eax,%eax
  800eef:	74 1c                	je     800f0d <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800ef1:	50                   	push   %eax
  800ef2:	68 10 2e 80 00       	push   $0x802e10
  800ef7:	53                   	push   %ebx
  800ef8:	56                   	push   %esi
  800ef9:	e8 b6 fe ff ff       	call   800db4 <printfmt>
  800efe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800f01:	89 7d 14             	mov    %edi,0x14(%ebp)
  800f04:	e9 8a 02 00 00       	jmp    801193 <vprintfmt+0x3c2>
  800f09:	f7 d8                	neg    %eax
  800f0b:	eb d2                	jmp    800edf <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800f0d:	52                   	push   %edx
  800f0e:	68 2f 32 80 00       	push   $0x80322f
  800f13:	53                   	push   %ebx
  800f14:	56                   	push   %esi
  800f15:	e8 9a fe ff ff       	call   800db4 <printfmt>
  800f1a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800f1d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800f20:	e9 6e 02 00 00       	jmp    801193 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800f25:	8b 45 14             	mov    0x14(%ebp),%eax
  800f28:	83 c0 04             	add    $0x4,%eax
  800f2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	8b 38                	mov    (%eax),%edi
  800f33:	85 ff                	test   %edi,%edi
  800f35:	74 39                	je     800f70 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800f37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f3b:	0f 8e a9 00 00 00    	jle    800fea <vprintfmt+0x219>
  800f41:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800f45:	0f 84 a7 00 00 00    	je     800ff2 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f4b:	83 ec 08             	sub    $0x8,%esp
  800f4e:	ff 75 d0             	pushl  -0x30(%ebp)
  800f51:	57                   	push   %edi
  800f52:	e8 6b 03 00 00       	call   8012c2 <strnlen>
  800f57:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800f5a:	29 c1                	sub    %eax,%ecx
  800f5c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800f5f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800f62:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800f66:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f69:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800f6c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800f6e:	eb 14                	jmp    800f84 <vprintfmt+0x1b3>
				p = "(null)";
  800f70:	bf 28 32 80 00       	mov    $0x803228,%edi
  800f75:	eb c0                	jmp    800f37 <vprintfmt+0x166>
					putch(padc, putdat);
  800f77:	83 ec 08             	sub    $0x8,%esp
  800f7a:	53                   	push   %ebx
  800f7b:	ff 75 e0             	pushl  -0x20(%ebp)
  800f7e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800f80:	4f                   	dec    %edi
  800f81:	83 c4 10             	add    $0x10,%esp
  800f84:	85 ff                	test   %edi,%edi
  800f86:	7f ef                	jg     800f77 <vprintfmt+0x1a6>
  800f88:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800f8b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800f8e:	89 c8                	mov    %ecx,%eax
  800f90:	85 c9                	test   %ecx,%ecx
  800f92:	78 10                	js     800fa4 <vprintfmt+0x1d3>
  800f94:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800f97:	29 c1                	sub    %eax,%ecx
  800f99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800f9c:	89 75 08             	mov    %esi,0x8(%ebp)
  800f9f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800fa2:	eb 15                	jmp    800fb9 <vprintfmt+0x1e8>
  800fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa9:	eb e9                	jmp    800f94 <vprintfmt+0x1c3>
					putch(ch, putdat);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	53                   	push   %ebx
  800faf:	52                   	push   %edx
  800fb0:	ff 55 08             	call   *0x8(%ebp)
  800fb3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb6:	ff 4d e0             	decl   -0x20(%ebp)
  800fb9:	47                   	inc    %edi
  800fba:	8a 47 ff             	mov    -0x1(%edi),%al
  800fbd:	0f be d0             	movsbl %al,%edx
  800fc0:	85 d2                	test   %edx,%edx
  800fc2:	74 59                	je     80101d <vprintfmt+0x24c>
  800fc4:	85 f6                	test   %esi,%esi
  800fc6:	78 03                	js     800fcb <vprintfmt+0x1fa>
  800fc8:	4e                   	dec    %esi
  800fc9:	78 2f                	js     800ffa <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800fcb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800fcf:	74 da                	je     800fab <vprintfmt+0x1da>
  800fd1:	0f be c0             	movsbl %al,%eax
  800fd4:	83 e8 20             	sub    $0x20,%eax
  800fd7:	83 f8 5e             	cmp    $0x5e,%eax
  800fda:	76 cf                	jbe    800fab <vprintfmt+0x1da>
					putch('?', putdat);
  800fdc:	83 ec 08             	sub    $0x8,%esp
  800fdf:	53                   	push   %ebx
  800fe0:	6a 3f                	push   $0x3f
  800fe2:	ff 55 08             	call   *0x8(%ebp)
  800fe5:	83 c4 10             	add    $0x10,%esp
  800fe8:	eb cc                	jmp    800fb6 <vprintfmt+0x1e5>
  800fea:	89 75 08             	mov    %esi,0x8(%ebp)
  800fed:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800ff0:	eb c7                	jmp    800fb9 <vprintfmt+0x1e8>
  800ff2:	89 75 08             	mov    %esi,0x8(%ebp)
  800ff5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800ff8:	eb bf                	jmp    800fb9 <vprintfmt+0x1e8>
  800ffa:	8b 75 08             	mov    0x8(%ebp),%esi
  800ffd:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801000:	eb 0c                	jmp    80100e <vprintfmt+0x23d>
				putch(' ', putdat);
  801002:	83 ec 08             	sub    $0x8,%esp
  801005:	53                   	push   %ebx
  801006:	6a 20                	push   $0x20
  801008:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80100a:	4f                   	dec    %edi
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	85 ff                	test   %edi,%edi
  801010:	7f f0                	jg     801002 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  801012:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801015:	89 45 14             	mov    %eax,0x14(%ebp)
  801018:	e9 76 01 00 00       	jmp    801193 <vprintfmt+0x3c2>
  80101d:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801020:	8b 75 08             	mov    0x8(%ebp),%esi
  801023:	eb e9                	jmp    80100e <vprintfmt+0x23d>
	if (lflag >= 2)
  801025:	83 f9 01             	cmp    $0x1,%ecx
  801028:	7f 1f                	jg     801049 <vprintfmt+0x278>
	else if (lflag)
  80102a:	85 c9                	test   %ecx,%ecx
  80102c:	75 48                	jne    801076 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	8b 00                	mov    (%eax),%eax
  801033:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801036:	89 c1                	mov    %eax,%ecx
  801038:	c1 f9 1f             	sar    $0x1f,%ecx
  80103b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8d 40 04             	lea    0x4(%eax),%eax
  801044:	89 45 14             	mov    %eax,0x14(%ebp)
  801047:	eb 17                	jmp    801060 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  801049:	8b 45 14             	mov    0x14(%ebp),%eax
  80104c:	8b 50 04             	mov    0x4(%eax),%edx
  80104f:	8b 00                	mov    (%eax),%eax
  801051:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801054:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801057:	8b 45 14             	mov    0x14(%ebp),%eax
  80105a:	8d 40 08             	lea    0x8(%eax),%eax
  80105d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  801060:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801063:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  801066:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80106a:	78 25                	js     801091 <vprintfmt+0x2c0>
			base = 10;
  80106c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801071:	e9 03 01 00 00       	jmp    801179 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	8b 00                	mov    (%eax),%eax
  80107b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80107e:	89 c1                	mov    %eax,%ecx
  801080:	c1 f9 1f             	sar    $0x1f,%ecx
  801083:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801086:	8b 45 14             	mov    0x14(%ebp),%eax
  801089:	8d 40 04             	lea    0x4(%eax),%eax
  80108c:	89 45 14             	mov    %eax,0x14(%ebp)
  80108f:	eb cf                	jmp    801060 <vprintfmt+0x28f>
				putch('-', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	53                   	push   %ebx
  801095:	6a 2d                	push   $0x2d
  801097:	ff d6                	call   *%esi
				num = -(long long) num;
  801099:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80109c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80109f:	f7 da                	neg    %edx
  8010a1:	83 d1 00             	adc    $0x0,%ecx
  8010a4:	f7 d9                	neg    %ecx
  8010a6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8010a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010ae:	e9 c6 00 00 00       	jmp    801179 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8010b3:	83 f9 01             	cmp    $0x1,%ecx
  8010b6:	7f 1e                	jg     8010d6 <vprintfmt+0x305>
	else if (lflag)
  8010b8:	85 c9                	test   %ecx,%ecx
  8010ba:	75 32                	jne    8010ee <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8010bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bf:	8b 10                	mov    (%eax),%edx
  8010c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c6:	8d 40 04             	lea    0x4(%eax),%eax
  8010c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8010cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010d1:	e9 a3 00 00 00       	jmp    801179 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8010d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d9:	8b 10                	mov    (%eax),%edx
  8010db:	8b 48 04             	mov    0x4(%eax),%ecx
  8010de:	8d 40 08             	lea    0x8(%eax),%eax
  8010e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8010e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010e9:	e9 8b 00 00 00       	jmp    801179 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8010ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f1:	8b 10                	mov    (%eax),%edx
  8010f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f8:	8d 40 04             	lea    0x4(%eax),%eax
  8010fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8010fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  801103:	eb 74                	jmp    801179 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801105:	83 f9 01             	cmp    $0x1,%ecx
  801108:	7f 1b                	jg     801125 <vprintfmt+0x354>
	else if (lflag)
  80110a:	85 c9                	test   %ecx,%ecx
  80110c:	75 2c                	jne    80113a <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80110e:	8b 45 14             	mov    0x14(%ebp),%eax
  801111:	8b 10                	mov    (%eax),%edx
  801113:	b9 00 00 00 00       	mov    $0x0,%ecx
  801118:	8d 40 04             	lea    0x4(%eax),%eax
  80111b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80111e:	b8 08 00 00 00       	mov    $0x8,%eax
  801123:	eb 54                	jmp    801179 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801125:	8b 45 14             	mov    0x14(%ebp),%eax
  801128:	8b 10                	mov    (%eax),%edx
  80112a:	8b 48 04             	mov    0x4(%eax),%ecx
  80112d:	8d 40 08             	lea    0x8(%eax),%eax
  801130:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801133:	b8 08 00 00 00       	mov    $0x8,%eax
  801138:	eb 3f                	jmp    801179 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80113a:	8b 45 14             	mov    0x14(%ebp),%eax
  80113d:	8b 10                	mov    (%eax),%edx
  80113f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801144:	8d 40 04             	lea    0x4(%eax),%eax
  801147:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80114a:	b8 08 00 00 00       	mov    $0x8,%eax
  80114f:	eb 28                	jmp    801179 <vprintfmt+0x3a8>
			putch('0', putdat);
  801151:	83 ec 08             	sub    $0x8,%esp
  801154:	53                   	push   %ebx
  801155:	6a 30                	push   $0x30
  801157:	ff d6                	call   *%esi
			putch('x', putdat);
  801159:	83 c4 08             	add    $0x8,%esp
  80115c:	53                   	push   %ebx
  80115d:	6a 78                	push   $0x78
  80115f:	ff d6                	call   *%esi
			num = (unsigned long long)
  801161:	8b 45 14             	mov    0x14(%ebp),%eax
  801164:	8b 10                	mov    (%eax),%edx
  801166:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80116b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80116e:	8d 40 04             	lea    0x4(%eax),%eax
  801171:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801174:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801180:	57                   	push   %edi
  801181:	ff 75 e0             	pushl  -0x20(%ebp)
  801184:	50                   	push   %eax
  801185:	51                   	push   %ecx
  801186:	52                   	push   %edx
  801187:	89 da                	mov    %ebx,%edx
  801189:	89 f0                	mov    %esi,%eax
  80118b:	e8 5b fb ff ff       	call   800ceb <printnum>
			break;
  801190:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801193:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801196:	47                   	inc    %edi
  801197:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80119b:	83 f8 25             	cmp    $0x25,%eax
  80119e:	0f 84 44 fc ff ff    	je     800de8 <vprintfmt+0x17>
			if (ch == '\0')
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	0f 84 89 00 00 00    	je     801235 <vprintfmt+0x464>
			putch(ch, putdat);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	53                   	push   %ebx
  8011b0:	50                   	push   %eax
  8011b1:	ff d6                	call   *%esi
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	eb de                	jmp    801196 <vprintfmt+0x3c5>
	if (lflag >= 2)
  8011b8:	83 f9 01             	cmp    $0x1,%ecx
  8011bb:	7f 1b                	jg     8011d8 <vprintfmt+0x407>
	else if (lflag)
  8011bd:	85 c9                	test   %ecx,%ecx
  8011bf:	75 2c                	jne    8011ed <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8011c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c4:	8b 10                	mov    (%eax),%edx
  8011c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011cb:	8d 40 04             	lea    0x4(%eax),%eax
  8011ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8011d1:	b8 10 00 00 00       	mov    $0x10,%eax
  8011d6:	eb a1                	jmp    801179 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8011d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011db:	8b 10                	mov    (%eax),%edx
  8011dd:	8b 48 04             	mov    0x4(%eax),%ecx
  8011e0:	8d 40 08             	lea    0x8(%eax),%eax
  8011e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8011e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8011eb:	eb 8c                	jmp    801179 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 10                	mov    (%eax),%edx
  8011f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011f7:	8d 40 04             	lea    0x4(%eax),%eax
  8011fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8011fd:	b8 10 00 00 00       	mov    $0x10,%eax
  801202:	e9 72 ff ff ff       	jmp    801179 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	53                   	push   %ebx
  80120b:	6a 25                	push   $0x25
  80120d:	ff d6                	call   *%esi
			break;
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	e9 7c ff ff ff       	jmp    801193 <vprintfmt+0x3c2>
			putch('%', putdat);
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	53                   	push   %ebx
  80121b:	6a 25                	push   $0x25
  80121d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	89 f8                	mov    %edi,%eax
  801224:	eb 01                	jmp    801227 <vprintfmt+0x456>
  801226:	48                   	dec    %eax
  801227:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80122b:	75 f9                	jne    801226 <vprintfmt+0x455>
  80122d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801230:	e9 5e ff ff ff       	jmp    801193 <vprintfmt+0x3c2>
}
  801235:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801238:	5b                   	pop    %ebx
  801239:	5e                   	pop    %esi
  80123a:	5f                   	pop    %edi
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 18             	sub    $0x18,%esp
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801249:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80124c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801250:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80125a:	85 c0                	test   %eax,%eax
  80125c:	74 26                	je     801284 <vsnprintf+0x47>
  80125e:	85 d2                	test   %edx,%edx
  801260:	7e 29                	jle    80128b <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801262:	ff 75 14             	pushl  0x14(%ebp)
  801265:	ff 75 10             	pushl  0x10(%ebp)
  801268:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80126b:	50                   	push   %eax
  80126c:	68 98 0d 80 00       	push   $0x800d98
  801271:	e8 5b fb ff ff       	call   800dd1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127f:	83 c4 10             	add    $0x10,%esp
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    
		return -E_INVAL;
  801284:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801289:	eb f7                	jmp    801282 <vsnprintf+0x45>
  80128b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801290:	eb f0                	jmp    801282 <vsnprintf+0x45>

00801292 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801298:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80129b:	50                   	push   %eax
  80129c:	ff 75 10             	pushl  0x10(%ebp)
  80129f:	ff 75 0c             	pushl  0xc(%ebp)
  8012a2:	ff 75 08             	pushl  0x8(%ebp)
  8012a5:	e8 93 ff ff ff       	call   80123d <vsnprintf>
	va_end(ap);

	return rc;
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b7:	eb 01                	jmp    8012ba <strlen+0xe>
		n++;
  8012b9:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8012ba:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8012be:	75 f9                	jne    8012b9 <strlen+0xd>
	return n;
}
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    

008012c2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c8:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d0:	eb 01                	jmp    8012d3 <strnlen+0x11>
		n++;
  8012d2:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d3:	39 d0                	cmp    %edx,%eax
  8012d5:	74 06                	je     8012dd <strnlen+0x1b>
  8012d7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8012db:	75 f5                	jne    8012d2 <strnlen+0x10>
	return n;
}
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    

008012df <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	53                   	push   %ebx
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	42                   	inc    %edx
  8012ec:	41                   	inc    %ecx
  8012ed:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8012f0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8012f3:	84 db                	test   %bl,%bl
  8012f5:	75 f4                	jne    8012eb <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8012f7:	5b                   	pop    %ebx
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	53                   	push   %ebx
  8012fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801301:	53                   	push   %ebx
  801302:	e8 a5 ff ff ff       	call   8012ac <strlen>
  801307:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80130a:	ff 75 0c             	pushl  0xc(%ebp)
  80130d:	01 d8                	add    %ebx,%eax
  80130f:	50                   	push   %eax
  801310:	e8 ca ff ff ff       	call   8012df <strcpy>
	return dst;
}
  801315:	89 d8                	mov    %ebx,%eax
  801317:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
  801321:	8b 75 08             	mov    0x8(%ebp),%esi
  801324:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801327:	89 f3                	mov    %esi,%ebx
  801329:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80132c:	89 f2                	mov    %esi,%edx
  80132e:	eb 0c                	jmp    80133c <strncpy+0x20>
		*dst++ = *src;
  801330:	42                   	inc    %edx
  801331:	8a 01                	mov    (%ecx),%al
  801333:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801336:	80 39 01             	cmpb   $0x1,(%ecx)
  801339:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80133c:	39 da                	cmp    %ebx,%edx
  80133e:	75 f0                	jne    801330 <strncpy+0x14>
	}
	return ret;
}
  801340:	89 f0                	mov    %esi,%eax
  801342:	5b                   	pop    %ebx
  801343:	5e                   	pop    %esi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    

00801346 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	56                   	push   %esi
  80134a:	53                   	push   %ebx
  80134b:	8b 75 08             	mov    0x8(%ebp),%esi
  80134e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801354:	85 c0                	test   %eax,%eax
  801356:	74 20                	je     801378 <strlcpy+0x32>
  801358:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  80135c:	89 f0                	mov    %esi,%eax
  80135e:	eb 05                	jmp    801365 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801360:	40                   	inc    %eax
  801361:	42                   	inc    %edx
  801362:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801365:	39 d8                	cmp    %ebx,%eax
  801367:	74 06                	je     80136f <strlcpy+0x29>
  801369:	8a 0a                	mov    (%edx),%cl
  80136b:	84 c9                	test   %cl,%cl
  80136d:	75 f1                	jne    801360 <strlcpy+0x1a>
		*dst = '\0';
  80136f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801372:	29 f0                	sub    %esi,%eax
}
  801374:	5b                   	pop    %ebx
  801375:	5e                   	pop    %esi
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    
  801378:	89 f0                	mov    %esi,%eax
  80137a:	eb f6                	jmp    801372 <strlcpy+0x2c>

0080137c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801382:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801385:	eb 02                	jmp    801389 <strcmp+0xd>
		p++, q++;
  801387:	41                   	inc    %ecx
  801388:	42                   	inc    %edx
	while (*p && *p == *q)
  801389:	8a 01                	mov    (%ecx),%al
  80138b:	84 c0                	test   %al,%al
  80138d:	74 04                	je     801393 <strcmp+0x17>
  80138f:	3a 02                	cmp    (%edx),%al
  801391:	74 f4                	je     801387 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801393:	0f b6 c0             	movzbl %al,%eax
  801396:	0f b6 12             	movzbl (%edx),%edx
  801399:	29 d0                	sub    %edx,%eax
}
  80139b:	5d                   	pop    %ebp
  80139c:	c3                   	ret    

0080139d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	53                   	push   %ebx
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a7:	89 c3                	mov    %eax,%ebx
  8013a9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8013ac:	eb 02                	jmp    8013b0 <strncmp+0x13>
		n--, p++, q++;
  8013ae:	40                   	inc    %eax
  8013af:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8013b0:	39 d8                	cmp    %ebx,%eax
  8013b2:	74 15                	je     8013c9 <strncmp+0x2c>
  8013b4:	8a 08                	mov    (%eax),%cl
  8013b6:	84 c9                	test   %cl,%cl
  8013b8:	74 04                	je     8013be <strncmp+0x21>
  8013ba:	3a 0a                	cmp    (%edx),%cl
  8013bc:	74 f0                	je     8013ae <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	0f b6 00             	movzbl (%eax),%eax
  8013c1:	0f b6 12             	movzbl (%edx),%edx
  8013c4:	29 d0                	sub    %edx,%eax
}
  8013c6:	5b                   	pop    %ebx
  8013c7:	5d                   	pop    %ebp
  8013c8:	c3                   	ret    
		return 0;
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ce:	eb f6                	jmp    8013c6 <strncmp+0x29>

008013d0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8013d9:	8a 10                	mov    (%eax),%dl
  8013db:	84 d2                	test   %dl,%dl
  8013dd:	74 07                	je     8013e6 <strchr+0x16>
		if (*s == c)
  8013df:	38 ca                	cmp    %cl,%dl
  8013e1:	74 08                	je     8013eb <strchr+0x1b>
	for (; *s; s++)
  8013e3:	40                   	inc    %eax
  8013e4:	eb f3                	jmp    8013d9 <strchr+0x9>
			return (char *) s;
	return 0;
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8013f6:	8a 10                	mov    (%eax),%dl
  8013f8:	84 d2                	test   %dl,%dl
  8013fa:	74 07                	je     801403 <strfind+0x16>
		if (*s == c)
  8013fc:	38 ca                	cmp    %cl,%dl
  8013fe:	74 03                	je     801403 <strfind+0x16>
	for (; *s; s++)
  801400:	40                   	inc    %eax
  801401:	eb f3                	jmp    8013f6 <strfind+0x9>
			break;
	return (char *) s;
}
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    

00801405 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	57                   	push   %edi
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
  80140b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80140e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801411:	85 c9                	test   %ecx,%ecx
  801413:	74 13                	je     801428 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801415:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80141b:	75 05                	jne    801422 <memset+0x1d>
  80141d:	f6 c1 03             	test   $0x3,%cl
  801420:	74 0d                	je     80142f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	fc                   	cld    
  801426:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801428:	89 f8                	mov    %edi,%eax
  80142a:	5b                   	pop    %ebx
  80142b:	5e                   	pop    %esi
  80142c:	5f                   	pop    %edi
  80142d:	5d                   	pop    %ebp
  80142e:	c3                   	ret    
		c &= 0xFF;
  80142f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801433:	89 d3                	mov    %edx,%ebx
  801435:	c1 e3 08             	shl    $0x8,%ebx
  801438:	89 d0                	mov    %edx,%eax
  80143a:	c1 e0 18             	shl    $0x18,%eax
  80143d:	89 d6                	mov    %edx,%esi
  80143f:	c1 e6 10             	shl    $0x10,%esi
  801442:	09 f0                	or     %esi,%eax
  801444:	09 c2                	or     %eax,%edx
  801446:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801448:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80144b:	89 d0                	mov    %edx,%eax
  80144d:	fc                   	cld    
  80144e:	f3 ab                	rep stos %eax,%es:(%edi)
  801450:	eb d6                	jmp    801428 <memset+0x23>

00801452 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	57                   	push   %edi
  801456:	56                   	push   %esi
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80145d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801460:	39 c6                	cmp    %eax,%esi
  801462:	73 33                	jae    801497 <memmove+0x45>
  801464:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801467:	39 d0                	cmp    %edx,%eax
  801469:	73 2c                	jae    801497 <memmove+0x45>
		s += n;
		d += n;
  80146b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80146e:	89 d6                	mov    %edx,%esi
  801470:	09 fe                	or     %edi,%esi
  801472:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801478:	75 13                	jne    80148d <memmove+0x3b>
  80147a:	f6 c1 03             	test   $0x3,%cl
  80147d:	75 0e                	jne    80148d <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80147f:	83 ef 04             	sub    $0x4,%edi
  801482:	8d 72 fc             	lea    -0x4(%edx),%esi
  801485:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801488:	fd                   	std    
  801489:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80148b:	eb 07                	jmp    801494 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80148d:	4f                   	dec    %edi
  80148e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801491:	fd                   	std    
  801492:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801494:	fc                   	cld    
  801495:	eb 13                	jmp    8014aa <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801497:	89 f2                	mov    %esi,%edx
  801499:	09 c2                	or     %eax,%edx
  80149b:	f6 c2 03             	test   $0x3,%dl
  80149e:	75 05                	jne    8014a5 <memmove+0x53>
  8014a0:	f6 c1 03             	test   $0x3,%cl
  8014a3:	74 09                	je     8014ae <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014a5:	89 c7                	mov    %eax,%edi
  8014a7:	fc                   	cld    
  8014a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8014aa:	5e                   	pop    %esi
  8014ab:	5f                   	pop    %edi
  8014ac:	5d                   	pop    %ebp
  8014ad:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014ae:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8014b1:	89 c7                	mov    %eax,%edi
  8014b3:	fc                   	cld    
  8014b4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8014b6:	eb f2                	jmp    8014aa <memmove+0x58>

008014b8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8014bb:	ff 75 10             	pushl  0x10(%ebp)
  8014be:	ff 75 0c             	pushl  0xc(%ebp)
  8014c1:	ff 75 08             	pushl  0x8(%ebp)
  8014c4:	e8 89 ff ff ff       	call   801452 <memmove>
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	56                   	push   %esi
  8014cf:	53                   	push   %ebx
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	89 c6                	mov    %eax,%esi
  8014d5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  8014db:	39 f0                	cmp    %esi,%eax
  8014dd:	74 16                	je     8014f5 <memcmp+0x2a>
		if (*s1 != *s2)
  8014df:	8a 08                	mov    (%eax),%cl
  8014e1:	8a 1a                	mov    (%edx),%bl
  8014e3:	38 d9                	cmp    %bl,%cl
  8014e5:	75 04                	jne    8014eb <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8014e7:	40                   	inc    %eax
  8014e8:	42                   	inc    %edx
  8014e9:	eb f0                	jmp    8014db <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8014eb:	0f b6 c1             	movzbl %cl,%eax
  8014ee:	0f b6 db             	movzbl %bl,%ebx
  8014f1:	29 d8                	sub    %ebx,%eax
  8014f3:	eb 05                	jmp    8014fa <memcmp+0x2f>
	}

	return 0;
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fa:	5b                   	pop    %ebx
  8014fb:	5e                   	pop    %esi
  8014fc:	5d                   	pop    %ebp
  8014fd:	c3                   	ret    

008014fe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801507:	89 c2                	mov    %eax,%edx
  801509:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80150c:	39 d0                	cmp    %edx,%eax
  80150e:	73 07                	jae    801517 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801510:	38 08                	cmp    %cl,(%eax)
  801512:	74 03                	je     801517 <memfind+0x19>
	for (; s < ends; s++)
  801514:	40                   	inc    %eax
  801515:	eb f5                	jmp    80150c <memfind+0xe>
			break;
	return (void *) s;
}
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    

00801519 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	57                   	push   %edi
  80151d:	56                   	push   %esi
  80151e:	53                   	push   %ebx
  80151f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801522:	eb 01                	jmp    801525 <strtol+0xc>
		s++;
  801524:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801525:	8a 01                	mov    (%ecx),%al
  801527:	3c 20                	cmp    $0x20,%al
  801529:	74 f9                	je     801524 <strtol+0xb>
  80152b:	3c 09                	cmp    $0x9,%al
  80152d:	74 f5                	je     801524 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  80152f:	3c 2b                	cmp    $0x2b,%al
  801531:	74 2b                	je     80155e <strtol+0x45>
		s++;
	else if (*s == '-')
  801533:	3c 2d                	cmp    $0x2d,%al
  801535:	74 2f                	je     801566 <strtol+0x4d>
	int neg = 0;
  801537:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80153c:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801543:	75 12                	jne    801557 <strtol+0x3e>
  801545:	80 39 30             	cmpb   $0x30,(%ecx)
  801548:	74 24                	je     80156e <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80154a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154e:	75 07                	jne    801557 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801550:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801557:	b8 00 00 00 00       	mov    $0x0,%eax
  80155c:	eb 4e                	jmp    8015ac <strtol+0x93>
		s++;
  80155e:	41                   	inc    %ecx
	int neg = 0;
  80155f:	bf 00 00 00 00       	mov    $0x0,%edi
  801564:	eb d6                	jmp    80153c <strtol+0x23>
		s++, neg = 1;
  801566:	41                   	inc    %ecx
  801567:	bf 01 00 00 00       	mov    $0x1,%edi
  80156c:	eb ce                	jmp    80153c <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80156e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801572:	74 10                	je     801584 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801574:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801578:	75 dd                	jne    801557 <strtol+0x3e>
		s++, base = 8;
  80157a:	41                   	inc    %ecx
  80157b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801582:	eb d3                	jmp    801557 <strtol+0x3e>
		s += 2, base = 16;
  801584:	83 c1 02             	add    $0x2,%ecx
  801587:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80158e:	eb c7                	jmp    801557 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801590:	8d 72 9f             	lea    -0x61(%edx),%esi
  801593:	89 f3                	mov    %esi,%ebx
  801595:	80 fb 19             	cmp    $0x19,%bl
  801598:	77 24                	ja     8015be <strtol+0xa5>
			dig = *s - 'a' + 10;
  80159a:	0f be d2             	movsbl %dl,%edx
  80159d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8015a0:	3b 55 10             	cmp    0x10(%ebp),%edx
  8015a3:	7d 2b                	jge    8015d0 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  8015a5:	41                   	inc    %ecx
  8015a6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015aa:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8015ac:	8a 11                	mov    (%ecx),%dl
  8015ae:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8015b1:	80 fb 09             	cmp    $0x9,%bl
  8015b4:	77 da                	ja     801590 <strtol+0x77>
			dig = *s - '0';
  8015b6:	0f be d2             	movsbl %dl,%edx
  8015b9:	83 ea 30             	sub    $0x30,%edx
  8015bc:	eb e2                	jmp    8015a0 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  8015be:	8d 72 bf             	lea    -0x41(%edx),%esi
  8015c1:	89 f3                	mov    %esi,%ebx
  8015c3:	80 fb 19             	cmp    $0x19,%bl
  8015c6:	77 08                	ja     8015d0 <strtol+0xb7>
			dig = *s - 'A' + 10;
  8015c8:	0f be d2             	movsbl %dl,%edx
  8015cb:	83 ea 37             	sub    $0x37,%edx
  8015ce:	eb d0                	jmp    8015a0 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  8015d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d4:	74 05                	je     8015db <strtol+0xc2>
		*endptr = (char *) s;
  8015d6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015d9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8015db:	85 ff                	test   %edi,%edi
  8015dd:	74 02                	je     8015e1 <strtol+0xc8>
  8015df:	f7 d8                	neg    %eax
}
  8015e1:	5b                   	pop    %ebx
  8015e2:	5e                   	pop    %esi
  8015e3:	5f                   	pop    %edi
  8015e4:	5d                   	pop    %ebp
  8015e5:	c3                   	ret    

008015e6 <atoi>:

int
atoi(const char *s)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  8015e9:	6a 0a                	push   $0xa
  8015eb:	6a 00                	push   $0x0
  8015ed:	ff 75 08             	pushl  0x8(%ebp)
  8015f0:	e8 24 ff ff ff       	call   801519 <strtol>
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	57                   	push   %edi
  8015fb:	56                   	push   %esi
  8015fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801602:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801605:	8b 55 08             	mov    0x8(%ebp),%edx
  801608:	89 c3                	mov    %eax,%ebx
  80160a:	89 c7                	mov    %eax,%edi
  80160c:	89 c6                	mov    %eax,%esi
  80160e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801610:	5b                   	pop    %ebx
  801611:	5e                   	pop    %esi
  801612:	5f                   	pop    %edi
  801613:	5d                   	pop    %ebp
  801614:	c3                   	ret    

00801615 <sys_cgetc>:

int
sys_cgetc(void)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	57                   	push   %edi
  801619:	56                   	push   %esi
  80161a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80161b:	ba 00 00 00 00       	mov    $0x0,%edx
  801620:	b8 01 00 00 00       	mov    $0x1,%eax
  801625:	89 d1                	mov    %edx,%ecx
  801627:	89 d3                	mov    %edx,%ebx
  801629:	89 d7                	mov    %edx,%edi
  80162b:	89 d6                	mov    %edx,%esi
  80162d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80162f:	5b                   	pop    %ebx
  801630:	5e                   	pop    %esi
  801631:	5f                   	pop    %edi
  801632:	5d                   	pop    %ebp
  801633:	c3                   	ret    

00801634 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	57                   	push   %edi
  801638:	56                   	push   %esi
  801639:	53                   	push   %ebx
  80163a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80163d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801642:	b8 03 00 00 00       	mov    $0x3,%eax
  801647:	8b 55 08             	mov    0x8(%ebp),%edx
  80164a:	89 cb                	mov    %ecx,%ebx
  80164c:	89 cf                	mov    %ecx,%edi
  80164e:	89 ce                	mov    %ecx,%esi
  801650:	cd 30                	int    $0x30
	if(check && ret > 0)
  801652:	85 c0                	test   %eax,%eax
  801654:	7f 08                	jg     80165e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801656:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801659:	5b                   	pop    %ebx
  80165a:	5e                   	pop    %esi
  80165b:	5f                   	pop    %edi
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	50                   	push   %eax
  801662:	6a 03                	push   $0x3
  801664:	68 1f 35 80 00       	push   $0x80351f
  801669:	6a 23                	push   $0x23
  80166b:	68 3c 35 80 00       	push   $0x80353c
  801670:	e8 f7 f5 ff ff       	call   800c6c <_panic>

00801675 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	57                   	push   %edi
  801679:	56                   	push   %esi
  80167a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80167b:	ba 00 00 00 00       	mov    $0x0,%edx
  801680:	b8 02 00 00 00       	mov    $0x2,%eax
  801685:	89 d1                	mov    %edx,%ecx
  801687:	89 d3                	mov    %edx,%ebx
  801689:	89 d7                	mov    %edx,%edi
  80168b:	89 d6                	mov    %edx,%esi
  80168d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5f                   	pop    %edi
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    

00801694 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	57                   	push   %edi
  801698:	56                   	push   %esi
  801699:	53                   	push   %ebx
  80169a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80169d:	be 00 00 00 00       	mov    $0x0,%esi
  8016a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016b0:	89 f7                	mov    %esi,%edi
  8016b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	7f 08                	jg     8016c0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8016b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016bb:	5b                   	pop    %ebx
  8016bc:	5e                   	pop    %esi
  8016bd:	5f                   	pop    %edi
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c0:	83 ec 0c             	sub    $0xc,%esp
  8016c3:	50                   	push   %eax
  8016c4:	6a 04                	push   $0x4
  8016c6:	68 1f 35 80 00       	push   $0x80351f
  8016cb:	6a 23                	push   $0x23
  8016cd:	68 3c 35 80 00       	push   $0x80353c
  8016d2:	e8 95 f5 ff ff       	call   800c6c <_panic>

008016d7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	57                   	push   %edi
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8016e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ee:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8016f4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	7f 08                	jg     801702 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8016fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5e                   	pop    %esi
  8016ff:	5f                   	pop    %edi
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801702:	83 ec 0c             	sub    $0xc,%esp
  801705:	50                   	push   %eax
  801706:	6a 05                	push   $0x5
  801708:	68 1f 35 80 00       	push   $0x80351f
  80170d:	6a 23                	push   $0x23
  80170f:	68 3c 35 80 00       	push   $0x80353c
  801714:	e8 53 f5 ff ff       	call   800c6c <_panic>

00801719 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	57                   	push   %edi
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801722:	bb 00 00 00 00       	mov    $0x0,%ebx
  801727:	b8 06 00 00 00       	mov    $0x6,%eax
  80172c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80172f:	8b 55 08             	mov    0x8(%ebp),%edx
  801732:	89 df                	mov    %ebx,%edi
  801734:	89 de                	mov    %ebx,%esi
  801736:	cd 30                	int    $0x30
	if(check && ret > 0)
  801738:	85 c0                	test   %eax,%eax
  80173a:	7f 08                	jg     801744 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80173c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5f                   	pop    %edi
  801742:	5d                   	pop    %ebp
  801743:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801744:	83 ec 0c             	sub    $0xc,%esp
  801747:	50                   	push   %eax
  801748:	6a 06                	push   $0x6
  80174a:	68 1f 35 80 00       	push   $0x80351f
  80174f:	6a 23                	push   $0x23
  801751:	68 3c 35 80 00       	push   $0x80353c
  801756:	e8 11 f5 ff ff       	call   800c6c <_panic>

0080175b <sys_yield>:

void
sys_yield(void)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	57                   	push   %edi
  80175f:	56                   	push   %esi
  801760:	53                   	push   %ebx
	asm volatile("int %1\n"
  801761:	ba 00 00 00 00       	mov    $0x0,%edx
  801766:	b8 0b 00 00 00       	mov    $0xb,%eax
  80176b:	89 d1                	mov    %edx,%ecx
  80176d:	89 d3                	mov    %edx,%ebx
  80176f:	89 d7                	mov    %edx,%edi
  801771:	89 d6                	mov    %edx,%esi
  801773:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5f                   	pop    %edi
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    

0080177a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	57                   	push   %edi
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801783:	bb 00 00 00 00       	mov    $0x0,%ebx
  801788:	b8 08 00 00 00       	mov    $0x8,%eax
  80178d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801790:	8b 55 08             	mov    0x8(%ebp),%edx
  801793:	89 df                	mov    %ebx,%edi
  801795:	89 de                	mov    %ebx,%esi
  801797:	cd 30                	int    $0x30
	if(check && ret > 0)
  801799:	85 c0                	test   %eax,%eax
  80179b:	7f 08                	jg     8017a5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80179d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5e                   	pop    %esi
  8017a2:	5f                   	pop    %edi
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017a5:	83 ec 0c             	sub    $0xc,%esp
  8017a8:	50                   	push   %eax
  8017a9:	6a 08                	push   $0x8
  8017ab:	68 1f 35 80 00       	push   $0x80351f
  8017b0:	6a 23                	push   $0x23
  8017b2:	68 3c 35 80 00       	push   $0x80353c
  8017b7:	e8 b0 f4 ff ff       	call   800c6c <_panic>

008017bc <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	57                   	push   %edi
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ca:	b8 0c 00 00 00       	mov    $0xc,%eax
  8017cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d2:	89 cb                	mov    %ecx,%ebx
  8017d4:	89 cf                	mov    %ecx,%edi
  8017d6:	89 ce                	mov    %ecx,%esi
  8017d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	7f 08                	jg     8017e6 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  8017de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e1:	5b                   	pop    %ebx
  8017e2:	5e                   	pop    %esi
  8017e3:	5f                   	pop    %edi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017e6:	83 ec 0c             	sub    $0xc,%esp
  8017e9:	50                   	push   %eax
  8017ea:	6a 0c                	push   $0xc
  8017ec:	68 1f 35 80 00       	push   $0x80351f
  8017f1:	6a 23                	push   $0x23
  8017f3:	68 3c 35 80 00       	push   $0x80353c
  8017f8:	e8 6f f4 ff ff       	call   800c6c <_panic>

008017fd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	57                   	push   %edi
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
  801803:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801806:	bb 00 00 00 00       	mov    $0x0,%ebx
  80180b:	b8 09 00 00 00       	mov    $0x9,%eax
  801810:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801813:	8b 55 08             	mov    0x8(%ebp),%edx
  801816:	89 df                	mov    %ebx,%edi
  801818:	89 de                	mov    %ebx,%esi
  80181a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80181c:	85 c0                	test   %eax,%eax
  80181e:	7f 08                	jg     801828 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5f                   	pop    %edi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801828:	83 ec 0c             	sub    $0xc,%esp
  80182b:	50                   	push   %eax
  80182c:	6a 09                	push   $0x9
  80182e:	68 1f 35 80 00       	push   $0x80351f
  801833:	6a 23                	push   $0x23
  801835:	68 3c 35 80 00       	push   $0x80353c
  80183a:	e8 2d f4 ff ff       	call   800c6c <_panic>

0080183f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	57                   	push   %edi
  801843:	56                   	push   %esi
  801844:	53                   	push   %ebx
  801845:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801848:	bb 00 00 00 00       	mov    $0x0,%ebx
  80184d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801855:	8b 55 08             	mov    0x8(%ebp),%edx
  801858:	89 df                	mov    %ebx,%edi
  80185a:	89 de                	mov    %ebx,%esi
  80185c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80185e:	85 c0                	test   %eax,%eax
  801860:	7f 08                	jg     80186a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801862:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801865:	5b                   	pop    %ebx
  801866:	5e                   	pop    %esi
  801867:	5f                   	pop    %edi
  801868:	5d                   	pop    %ebp
  801869:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80186a:	83 ec 0c             	sub    $0xc,%esp
  80186d:	50                   	push   %eax
  80186e:	6a 0a                	push   $0xa
  801870:	68 1f 35 80 00       	push   $0x80351f
  801875:	6a 23                	push   $0x23
  801877:	68 3c 35 80 00       	push   $0x80353c
  80187c:	e8 eb f3 ff ff       	call   800c6c <_panic>

00801881 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	57                   	push   %edi
  801885:	56                   	push   %esi
  801886:	53                   	push   %ebx
	asm volatile("int %1\n"
  801887:	be 00 00 00 00       	mov    $0x0,%esi
  80188c:	b8 0d 00 00 00       	mov    $0xd,%eax
  801891:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801894:	8b 55 08             	mov    0x8(%ebp),%edx
  801897:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80189a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80189d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80189f:	5b                   	pop    %ebx
  8018a0:	5e                   	pop    %esi
  8018a1:	5f                   	pop    %edi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    

008018a4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	57                   	push   %edi
  8018a8:	56                   	push   %esi
  8018a9:	53                   	push   %ebx
  8018aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8018b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ba:	89 cb                	mov    %ecx,%ebx
  8018bc:	89 cf                	mov    %ecx,%edi
  8018be:	89 ce                	mov    %ecx,%esi
  8018c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	7f 08                	jg     8018ce <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c9:	5b                   	pop    %ebx
  8018ca:	5e                   	pop    %esi
  8018cb:	5f                   	pop    %edi
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018ce:	83 ec 0c             	sub    $0xc,%esp
  8018d1:	50                   	push   %eax
  8018d2:	6a 0e                	push   $0xe
  8018d4:	68 1f 35 80 00       	push   $0x80351f
  8018d9:	6a 23                	push   $0x23
  8018db:	68 3c 35 80 00       	push   $0x80353c
  8018e0:	e8 87 f3 ff ff       	call   800c6c <_panic>

008018e5 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	57                   	push   %edi
  8018e9:	56                   	push   %esi
  8018ea:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018eb:	be 00 00 00 00       	mov    $0x0,%esi
  8018f0:	b8 0f 00 00 00       	mov    $0xf,%eax
  8018f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018fe:	89 f7                	mov    %esi,%edi
  801900:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801902:	5b                   	pop    %ebx
  801903:	5e                   	pop    %esi
  801904:	5f                   	pop    %edi
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	57                   	push   %edi
  80190b:	56                   	push   %esi
  80190c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80190d:	be 00 00 00 00       	mov    $0x0,%esi
  801912:	b8 10 00 00 00       	mov    $0x10,%eax
  801917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80191a:	8b 55 08             	mov    0x8(%ebp),%edx
  80191d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801920:	89 f7                	mov    %esi,%edi
  801922:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801924:	5b                   	pop    %ebx
  801925:	5e                   	pop    %esi
  801926:	5f                   	pop    %edi
  801927:	5d                   	pop    %ebp
  801928:	c3                   	ret    

00801929 <sys_set_console_color>:

void sys_set_console_color(int color) {
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	57                   	push   %edi
  80192d:	56                   	push   %esi
  80192e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80192f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801934:	b8 11 00 00 00       	mov    $0x11,%eax
  801939:	8b 55 08             	mov    0x8(%ebp),%edx
  80193c:	89 cb                	mov    %ecx,%ebx
  80193e:	89 cf                	mov    %ecx,%edi
  801940:	89 ce                	mov    %ecx,%esi
  801942:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5f                   	pop    %edi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	05 00 00 00 30       	add    $0x30000000,%eax
  801954:	c1 e8 0c             	shr    $0xc,%eax
}
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    

00801959 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801964:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801969:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    

00801970 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801976:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80197b:	89 c2                	mov    %eax,%edx
  80197d:	c1 ea 16             	shr    $0x16,%edx
  801980:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801987:	f6 c2 01             	test   $0x1,%dl
  80198a:	74 2a                	je     8019b6 <fd_alloc+0x46>
  80198c:	89 c2                	mov    %eax,%edx
  80198e:	c1 ea 0c             	shr    $0xc,%edx
  801991:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801998:	f6 c2 01             	test   $0x1,%dl
  80199b:	74 19                	je     8019b6 <fd_alloc+0x46>
  80199d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8019a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8019a7:	75 d2                	jne    80197b <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8019a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8019af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8019b4:	eb 07                	jmp    8019bd <fd_alloc+0x4d>
			*fd_store = fd;
  8019b6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8019b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bd:	5d                   	pop    %ebp
  8019be:	c3                   	ret    

008019bf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8019c2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8019c6:	77 39                	ja     801a01 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	c1 e0 0c             	shl    $0xc,%eax
  8019ce:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8019d3:	89 c2                	mov    %eax,%edx
  8019d5:	c1 ea 16             	shr    $0x16,%edx
  8019d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019df:	f6 c2 01             	test   $0x1,%dl
  8019e2:	74 24                	je     801a08 <fd_lookup+0x49>
  8019e4:	89 c2                	mov    %eax,%edx
  8019e6:	c1 ea 0c             	shr    $0xc,%edx
  8019e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019f0:	f6 c2 01             	test   $0x1,%dl
  8019f3:	74 1a                	je     801a0f <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	89 02                	mov    %eax,(%edx)
	return 0;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ff:	5d                   	pop    %ebp
  801a00:	c3                   	ret    
		return -E_INVAL;
  801a01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a06:	eb f7                	jmp    8019ff <fd_lookup+0x40>
		return -E_INVAL;
  801a08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a0d:	eb f0                	jmp    8019ff <fd_lookup+0x40>
  801a0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a14:	eb e9                	jmp    8019ff <fd_lookup+0x40>

00801a16 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 08             	sub    $0x8,%esp
  801a1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1f:	ba c8 35 80 00       	mov    $0x8035c8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801a24:	b8 14 40 80 00       	mov    $0x804014,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a29:	39 08                	cmp    %ecx,(%eax)
  801a2b:	74 33                	je     801a60 <dev_lookup+0x4a>
  801a2d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801a30:	8b 02                	mov    (%edx),%eax
  801a32:	85 c0                	test   %eax,%eax
  801a34:	75 f3                	jne    801a29 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a36:	a1 08 50 80 00       	mov    0x805008,%eax
  801a3b:	8b 40 48             	mov    0x48(%eax),%eax
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	51                   	push   %ecx
  801a42:	50                   	push   %eax
  801a43:	68 4c 35 80 00       	push   $0x80354c
  801a48:	e8 9b 0c 00 00       	call   8026e8 <cprintf>
	*dev = 0;
  801a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    
			*dev = devtab[i];
  801a60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a63:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6a:	eb f2                	jmp    801a5e <dev_lookup+0x48>

00801a6c <fd_close>:
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	57                   	push   %edi
  801a70:	56                   	push   %esi
  801a71:	53                   	push   %ebx
  801a72:	83 ec 1c             	sub    $0x1c,%esp
  801a75:	8b 75 08             	mov    0x8(%ebp),%esi
  801a78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a7b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a7e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a7f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801a85:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a88:	50                   	push   %eax
  801a89:	e8 31 ff ff ff       	call   8019bf <fd_lookup>
  801a8e:	89 c7                	mov    %eax,%edi
  801a90:	83 c4 08             	add    $0x8,%esp
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 05                	js     801a9c <fd_close+0x30>
	    || fd != fd2)
  801a97:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801a9a:	74 13                	je     801aaf <fd_close+0x43>
		return (must_exist ? r : 0);
  801a9c:	84 db                	test   %bl,%bl
  801a9e:	75 05                	jne    801aa5 <fd_close+0x39>
  801aa0:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801aa5:	89 f8                	mov    %edi,%eax
  801aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aaa:	5b                   	pop    %ebx
  801aab:	5e                   	pop    %esi
  801aac:	5f                   	pop    %edi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ab5:	50                   	push   %eax
  801ab6:	ff 36                	pushl  (%esi)
  801ab8:	e8 59 ff ff ff       	call   801a16 <dev_lookup>
  801abd:	89 c7                	mov    %eax,%edi
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 15                	js     801adb <fd_close+0x6f>
		if (dev->dev_close)
  801ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac9:	8b 40 10             	mov    0x10(%eax),%eax
  801acc:	85 c0                	test   %eax,%eax
  801ace:	74 1b                	je     801aeb <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801ad0:	83 ec 0c             	sub    $0xc,%esp
  801ad3:	56                   	push   %esi
  801ad4:	ff d0                	call   *%eax
  801ad6:	89 c7                	mov    %eax,%edi
  801ad8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	56                   	push   %esi
  801adf:	6a 00                	push   $0x0
  801ae1:	e8 33 fc ff ff       	call   801719 <sys_page_unmap>
	return r;
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	eb ba                	jmp    801aa5 <fd_close+0x39>
			r = 0;
  801aeb:	bf 00 00 00 00       	mov    $0x0,%edi
  801af0:	eb e9                	jmp    801adb <fd_close+0x6f>

00801af2 <close>:

int
close(int fdnum)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801af8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afb:	50                   	push   %eax
  801afc:	ff 75 08             	pushl  0x8(%ebp)
  801aff:	e8 bb fe ff ff       	call   8019bf <fd_lookup>
  801b04:	83 c4 08             	add    $0x8,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 10                	js     801b1b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801b0b:	83 ec 08             	sub    $0x8,%esp
  801b0e:	6a 01                	push   $0x1
  801b10:	ff 75 f4             	pushl  -0xc(%ebp)
  801b13:	e8 54 ff ff ff       	call   801a6c <fd_close>
  801b18:	83 c4 10             	add    $0x10,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <close_all>:

void
close_all(void)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	53                   	push   %ebx
  801b21:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b24:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b29:	83 ec 0c             	sub    $0xc,%esp
  801b2c:	53                   	push   %ebx
  801b2d:	e8 c0 ff ff ff       	call   801af2 <close>
	for (i = 0; i < MAXFD; i++)
  801b32:	43                   	inc    %ebx
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	83 fb 20             	cmp    $0x20,%ebx
  801b39:	75 ee                	jne    801b29 <close_all+0xc>
}
  801b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	57                   	push   %edi
  801b44:	56                   	push   %esi
  801b45:	53                   	push   %ebx
  801b46:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b49:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b4c:	50                   	push   %eax
  801b4d:	ff 75 08             	pushl  0x8(%ebp)
  801b50:	e8 6a fe ff ff       	call   8019bf <fd_lookup>
  801b55:	89 c3                	mov    %eax,%ebx
  801b57:	83 c4 08             	add    $0x8,%esp
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	0f 88 81 00 00 00    	js     801be3 <dup+0xa3>
		return r;
	close(newfdnum);
  801b62:	83 ec 0c             	sub    $0xc,%esp
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	e8 85 ff ff ff       	call   801af2 <close>

	newfd = INDEX2FD(newfdnum);
  801b6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b70:	c1 e6 0c             	shl    $0xc,%esi
  801b73:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801b79:	83 c4 04             	add    $0x4,%esp
  801b7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b7f:	e8 d5 fd ff ff       	call   801959 <fd2data>
  801b84:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b86:	89 34 24             	mov    %esi,(%esp)
  801b89:	e8 cb fd ff ff       	call   801959 <fd2data>
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801b93:	89 d8                	mov    %ebx,%eax
  801b95:	c1 e8 16             	shr    $0x16,%eax
  801b98:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b9f:	a8 01                	test   $0x1,%al
  801ba1:	74 11                	je     801bb4 <dup+0x74>
  801ba3:	89 d8                	mov    %ebx,%eax
  801ba5:	c1 e8 0c             	shr    $0xc,%eax
  801ba8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801baf:	f6 c2 01             	test   $0x1,%dl
  801bb2:	75 39                	jne    801bed <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801bb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb7:	89 d0                	mov    %edx,%eax
  801bb9:	c1 e8 0c             	shr    $0xc,%eax
  801bbc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bc3:	83 ec 0c             	sub    $0xc,%esp
  801bc6:	25 07 0e 00 00       	and    $0xe07,%eax
  801bcb:	50                   	push   %eax
  801bcc:	56                   	push   %esi
  801bcd:	6a 00                	push   $0x0
  801bcf:	52                   	push   %edx
  801bd0:	6a 00                	push   $0x0
  801bd2:	e8 00 fb ff ff       	call   8016d7 <sys_page_map>
  801bd7:	89 c3                	mov    %eax,%ebx
  801bd9:	83 c4 20             	add    $0x20,%esp
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 31                	js     801c11 <dup+0xd1>
		goto err;

	return newfdnum;
  801be0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5f                   	pop    %edi
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801bed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	25 07 0e 00 00       	and    $0xe07,%eax
  801bfc:	50                   	push   %eax
  801bfd:	57                   	push   %edi
  801bfe:	6a 00                	push   $0x0
  801c00:	53                   	push   %ebx
  801c01:	6a 00                	push   $0x0
  801c03:	e8 cf fa ff ff       	call   8016d7 <sys_page_map>
  801c08:	89 c3                	mov    %eax,%ebx
  801c0a:	83 c4 20             	add    $0x20,%esp
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	79 a3                	jns    801bb4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	56                   	push   %esi
  801c15:	6a 00                	push   $0x0
  801c17:	e8 fd fa ff ff       	call   801719 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c1c:	83 c4 08             	add    $0x8,%esp
  801c1f:	57                   	push   %edi
  801c20:	6a 00                	push   $0x0
  801c22:	e8 f2 fa ff ff       	call   801719 <sys_page_unmap>
	return r;
  801c27:	83 c4 10             	add    $0x10,%esp
  801c2a:	eb b7                	jmp    801be3 <dup+0xa3>

00801c2c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	53                   	push   %ebx
  801c30:	83 ec 14             	sub    $0x14,%esp
  801c33:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c39:	50                   	push   %eax
  801c3a:	53                   	push   %ebx
  801c3b:	e8 7f fd ff ff       	call   8019bf <fd_lookup>
  801c40:	83 c4 08             	add    $0x8,%esp
  801c43:	85 c0                	test   %eax,%eax
  801c45:	78 3f                	js     801c86 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c47:	83 ec 08             	sub    $0x8,%esp
  801c4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4d:	50                   	push   %eax
  801c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c51:	ff 30                	pushl  (%eax)
  801c53:	e8 be fd ff ff       	call   801a16 <dev_lookup>
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 27                	js     801c86 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c62:	8b 42 08             	mov    0x8(%edx),%eax
  801c65:	83 e0 03             	and    $0x3,%eax
  801c68:	83 f8 01             	cmp    $0x1,%eax
  801c6b:	74 1e                	je     801c8b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c70:	8b 40 08             	mov    0x8(%eax),%eax
  801c73:	85 c0                	test   %eax,%eax
  801c75:	74 35                	je     801cac <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c77:	83 ec 04             	sub    $0x4,%esp
  801c7a:	ff 75 10             	pushl  0x10(%ebp)
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	52                   	push   %edx
  801c81:	ff d0                	call   *%eax
  801c83:	83 c4 10             	add    $0x10,%esp
}
  801c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c8b:	a1 08 50 80 00       	mov    0x805008,%eax
  801c90:	8b 40 48             	mov    0x48(%eax),%eax
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	53                   	push   %ebx
  801c97:	50                   	push   %eax
  801c98:	68 8d 35 80 00       	push   $0x80358d
  801c9d:	e8 46 0a 00 00       	call   8026e8 <cprintf>
		return -E_INVAL;
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801caa:	eb da                	jmp    801c86 <read+0x5a>
		return -E_NOT_SUPP;
  801cac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cb1:	eb d3                	jmp    801c86 <read+0x5a>

00801cb3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	57                   	push   %edi
  801cb7:	56                   	push   %esi
  801cb8:	53                   	push   %ebx
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cbf:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc7:	39 f3                	cmp    %esi,%ebx
  801cc9:	73 25                	jae    801cf0 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ccb:	83 ec 04             	sub    $0x4,%esp
  801cce:	89 f0                	mov    %esi,%eax
  801cd0:	29 d8                	sub    %ebx,%eax
  801cd2:	50                   	push   %eax
  801cd3:	89 d8                	mov    %ebx,%eax
  801cd5:	03 45 0c             	add    0xc(%ebp),%eax
  801cd8:	50                   	push   %eax
  801cd9:	57                   	push   %edi
  801cda:	e8 4d ff ff ff       	call   801c2c <read>
		if (m < 0)
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 08                	js     801cee <readn+0x3b>
			return m;
		if (m == 0)
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	74 06                	je     801cf0 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801cea:	01 c3                	add    %eax,%ebx
  801cec:	eb d9                	jmp    801cc7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801cee:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5f                   	pop    %edi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    

00801cfa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	53                   	push   %ebx
  801cfe:	83 ec 14             	sub    $0x14,%esp
  801d01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d04:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d07:	50                   	push   %eax
  801d08:	53                   	push   %ebx
  801d09:	e8 b1 fc ff ff       	call   8019bf <fd_lookup>
  801d0e:	83 c4 08             	add    $0x8,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 3a                	js     801d4f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d15:	83 ec 08             	sub    $0x8,%esp
  801d18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d1b:	50                   	push   %eax
  801d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1f:	ff 30                	pushl  (%eax)
  801d21:	e8 f0 fc ff ff       	call   801a16 <dev_lookup>
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 22                	js     801d4f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d30:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d34:	74 1e                	je     801d54 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d39:	8b 52 0c             	mov    0xc(%edx),%edx
  801d3c:	85 d2                	test   %edx,%edx
  801d3e:	74 35                	je     801d75 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d40:	83 ec 04             	sub    $0x4,%esp
  801d43:	ff 75 10             	pushl  0x10(%ebp)
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	50                   	push   %eax
  801d4a:	ff d2                	call   *%edx
  801d4c:	83 c4 10             	add    $0x10,%esp
}
  801d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d54:	a1 08 50 80 00       	mov    0x805008,%eax
  801d59:	8b 40 48             	mov    0x48(%eax),%eax
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	53                   	push   %ebx
  801d60:	50                   	push   %eax
  801d61:	68 a9 35 80 00       	push   $0x8035a9
  801d66:	e8 7d 09 00 00       	call   8026e8 <cprintf>
		return -E_INVAL;
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d73:	eb da                	jmp    801d4f <write+0x55>
		return -E_NOT_SUPP;
  801d75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d7a:	eb d3                	jmp    801d4f <write+0x55>

00801d7c <seek>:

int
seek(int fdnum, off_t offset)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d82:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801d85:	50                   	push   %eax
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	e8 31 fc ff ff       	call   8019bf <fd_lookup>
  801d8e:	83 c4 08             	add    $0x8,%esp
  801d91:	85 c0                	test   %eax,%eax
  801d93:	78 0e                	js     801da3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801d95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	53                   	push   %ebx
  801da9:	83 ec 14             	sub    $0x14,%esp
  801dac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801daf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801db2:	50                   	push   %eax
  801db3:	53                   	push   %ebx
  801db4:	e8 06 fc ff ff       	call   8019bf <fd_lookup>
  801db9:	83 c4 08             	add    $0x8,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 37                	js     801df7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dc0:	83 ec 08             	sub    $0x8,%esp
  801dc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc6:	50                   	push   %eax
  801dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dca:	ff 30                	pushl  (%eax)
  801dcc:	e8 45 fc ff ff       	call   801a16 <dev_lookup>
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 1f                	js     801df7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ddf:	74 1b                	je     801dfc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de4:	8b 52 18             	mov    0x18(%edx),%edx
  801de7:	85 d2                	test   %edx,%edx
  801de9:	74 32                	je     801e1d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801deb:	83 ec 08             	sub    $0x8,%esp
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	50                   	push   %eax
  801df2:	ff d2                	call   *%edx
  801df4:	83 c4 10             	add    $0x10,%esp
}
  801df7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    
			thisenv->env_id, fdnum);
  801dfc:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e01:	8b 40 48             	mov    0x48(%eax),%eax
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	53                   	push   %ebx
  801e08:	50                   	push   %eax
  801e09:	68 6c 35 80 00       	push   $0x80356c
  801e0e:	e8 d5 08 00 00       	call   8026e8 <cprintf>
		return -E_INVAL;
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e1b:	eb da                	jmp    801df7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801e1d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e22:	eb d3                	jmp    801df7 <ftruncate+0x52>

00801e24 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	53                   	push   %ebx
  801e28:	83 ec 14             	sub    $0x14,%esp
  801e2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e31:	50                   	push   %eax
  801e32:	ff 75 08             	pushl  0x8(%ebp)
  801e35:	e8 85 fb ff ff       	call   8019bf <fd_lookup>
  801e3a:	83 c4 08             	add    $0x8,%esp
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	78 4b                	js     801e8c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e41:	83 ec 08             	sub    $0x8,%esp
  801e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e47:	50                   	push   %eax
  801e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4b:	ff 30                	pushl  (%eax)
  801e4d:	e8 c4 fb ff ff       	call   801a16 <dev_lookup>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	78 33                	js     801e8c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e60:	74 2f                	je     801e91 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e62:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e65:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e6c:	00 00 00 
	stat->st_type = 0;
  801e6f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e76:	00 00 00 
	stat->st_dev = dev;
  801e79:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e7f:	83 ec 08             	sub    $0x8,%esp
  801e82:	53                   	push   %ebx
  801e83:	ff 75 f0             	pushl  -0x10(%ebp)
  801e86:	ff 50 14             	call   *0x14(%eax)
  801e89:	83 c4 10             	add    $0x10,%esp
}
  801e8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    
		return -E_NOT_SUPP;
  801e91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e96:	eb f4                	jmp    801e8c <fstat+0x68>

00801e98 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	56                   	push   %esi
  801e9c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e9d:	83 ec 08             	sub    $0x8,%esp
  801ea0:	6a 00                	push   $0x0
  801ea2:	ff 75 08             	pushl  0x8(%ebp)
  801ea5:	e8 34 02 00 00       	call   8020de <open>
  801eaa:	89 c3                	mov    %eax,%ebx
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 1b                	js     801ece <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801eb3:	83 ec 08             	sub    $0x8,%esp
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	50                   	push   %eax
  801eba:	e8 65 ff ff ff       	call   801e24 <fstat>
  801ebf:	89 c6                	mov    %eax,%esi
	close(fd);
  801ec1:	89 1c 24             	mov    %ebx,(%esp)
  801ec4:	e8 29 fc ff ff       	call   801af2 <close>
	return r;
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	89 f3                	mov    %esi,%ebx
}
  801ece:	89 d8                	mov    %ebx,%eax
  801ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5d                   	pop    %ebp
  801ed6:	c3                   	ret    

00801ed7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
  801edc:	89 c6                	mov    %eax,%esi
  801ede:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ee0:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801ee7:	74 27                	je     801f10 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ee9:	6a 07                	push   $0x7
  801eeb:	68 00 60 80 00       	push   $0x806000
  801ef0:	56                   	push   %esi
  801ef1:	ff 35 04 50 80 00    	pushl  0x805004
  801ef7:	e8 89 08 00 00       	call   802785 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801efc:	83 c4 0c             	add    $0xc,%esp
  801eff:	6a 00                	push   $0x0
  801f01:	53                   	push   %ebx
  801f02:	6a 00                	push   $0x0
  801f04:	e8 f3 07 00 00       	call   8026fc <ipc_recv>
}
  801f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0c:	5b                   	pop    %ebx
  801f0d:	5e                   	pop    %esi
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	6a 01                	push   $0x1
  801f15:	e8 c7 08 00 00       	call   8027e1 <ipc_find_env>
  801f1a:	a3 04 50 80 00       	mov    %eax,0x805004
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	eb c5                	jmp    801ee9 <fsipc+0x12>

00801f24 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f30:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f38:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f42:	b8 02 00 00 00       	mov    $0x2,%eax
  801f47:	e8 8b ff ff ff       	call   801ed7 <fsipc>
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <devfile_flush>:
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f64:	b8 06 00 00 00       	mov    $0x6,%eax
  801f69:	e8 69 ff ff ff       	call   801ed7 <fsipc>
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <devfile_stat>:
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	53                   	push   %ebx
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f80:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f85:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8a:	b8 05 00 00 00       	mov    $0x5,%eax
  801f8f:	e8 43 ff ff ff       	call   801ed7 <fsipc>
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 2c                	js     801fc4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f98:	83 ec 08             	sub    $0x8,%esp
  801f9b:	68 00 60 80 00       	push   $0x806000
  801fa0:	53                   	push   %ebx
  801fa1:	e8 39 f3 ff ff       	call   8012df <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801fa6:	a1 80 60 80 00       	mov    0x806080,%eax
  801fab:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801fb1:	a1 84 60 80 00       	mov    0x806084,%eax
  801fb6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <devfile_write>:
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	53                   	push   %ebx
  801fcd:	83 ec 04             	sub    $0x4,%esp
  801fd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801fd3:	89 d8                	mov    %ebx,%eax
  801fd5:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801fdb:	76 05                	jbe    801fe2 <devfile_write+0x19>
  801fdd:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe5:	8b 52 0c             	mov    0xc(%edx),%edx
  801fe8:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = size;
  801fee:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	50                   	push   %eax
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	68 08 60 80 00       	push   $0x806008
  801fff:	e8 4e f4 ff ff       	call   801452 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  802004:	ba 00 00 00 00       	mov    $0x0,%edx
  802009:	b8 04 00 00 00       	mov    $0x4,%eax
  80200e:	e8 c4 fe ff ff       	call   801ed7 <fsipc>
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	85 c0                	test   %eax,%eax
  802018:	78 0b                	js     802025 <devfile_write+0x5c>
	assert(r <= n);
  80201a:	39 c3                	cmp    %eax,%ebx
  80201c:	72 0c                	jb     80202a <devfile_write+0x61>
	assert(r <= PGSIZE);
  80201e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802023:	7f 1e                	jg     802043 <devfile_write+0x7a>
}
  802025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802028:	c9                   	leave  
  802029:	c3                   	ret    
	assert(r <= n);
  80202a:	68 d8 35 80 00       	push   $0x8035d8
  80202f:	68 fe 2d 80 00       	push   $0x802dfe
  802034:	68 98 00 00 00       	push   $0x98
  802039:	68 df 35 80 00       	push   $0x8035df
  80203e:	e8 29 ec ff ff       	call   800c6c <_panic>
	assert(r <= PGSIZE);
  802043:	68 ea 35 80 00       	push   $0x8035ea
  802048:	68 fe 2d 80 00       	push   $0x802dfe
  80204d:	68 99 00 00 00       	push   $0x99
  802052:	68 df 35 80 00       	push   $0x8035df
  802057:	e8 10 ec ff ff       	call   800c6c <_panic>

0080205c <devfile_read>:
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	56                   	push   %esi
  802060:	53                   	push   %ebx
  802061:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	8b 40 0c             	mov    0xc(%eax),%eax
  80206a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80206f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802075:	ba 00 00 00 00       	mov    $0x0,%edx
  80207a:	b8 03 00 00 00       	mov    $0x3,%eax
  80207f:	e8 53 fe ff ff       	call   801ed7 <fsipc>
  802084:	89 c3                	mov    %eax,%ebx
  802086:	85 c0                	test   %eax,%eax
  802088:	78 1f                	js     8020a9 <devfile_read+0x4d>
	assert(r <= n);
  80208a:	39 c6                	cmp    %eax,%esi
  80208c:	72 24                	jb     8020b2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80208e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802093:	7f 33                	jg     8020c8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802095:	83 ec 04             	sub    $0x4,%esp
  802098:	50                   	push   %eax
  802099:	68 00 60 80 00       	push   $0x806000
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	e8 ac f3 ff ff       	call   801452 <memmove>
	return r;
  8020a6:	83 c4 10             	add    $0x10,%esp
}
  8020a9:	89 d8                	mov    %ebx,%eax
  8020ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ae:	5b                   	pop    %ebx
  8020af:	5e                   	pop    %esi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    
	assert(r <= n);
  8020b2:	68 d8 35 80 00       	push   $0x8035d8
  8020b7:	68 fe 2d 80 00       	push   $0x802dfe
  8020bc:	6a 7c                	push   $0x7c
  8020be:	68 df 35 80 00       	push   $0x8035df
  8020c3:	e8 a4 eb ff ff       	call   800c6c <_panic>
	assert(r <= PGSIZE);
  8020c8:	68 ea 35 80 00       	push   $0x8035ea
  8020cd:	68 fe 2d 80 00       	push   $0x802dfe
  8020d2:	6a 7d                	push   $0x7d
  8020d4:	68 df 35 80 00       	push   $0x8035df
  8020d9:	e8 8e eb ff ff       	call   800c6c <_panic>

008020de <open>:
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	56                   	push   %esi
  8020e2:	53                   	push   %ebx
  8020e3:	83 ec 1c             	sub    $0x1c,%esp
  8020e6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8020e9:	56                   	push   %esi
  8020ea:	e8 bd f1 ff ff       	call   8012ac <strlen>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020f7:	7f 6c                	jg     802165 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8020f9:	83 ec 0c             	sub    $0xc,%esp
  8020fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ff:	50                   	push   %eax
  802100:	e8 6b f8 ff ff       	call   801970 <fd_alloc>
  802105:	89 c3                	mov    %eax,%ebx
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 3c                	js     80214a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80210e:	83 ec 08             	sub    $0x8,%esp
  802111:	56                   	push   %esi
  802112:	68 00 60 80 00       	push   $0x806000
  802117:	e8 c3 f1 ff ff       	call   8012df <strcpy>
	fsipcbuf.open.req_omode = mode;
  80211c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802127:	b8 01 00 00 00       	mov    $0x1,%eax
  80212c:	e8 a6 fd ff ff       	call   801ed7 <fsipc>
  802131:	89 c3                	mov    %eax,%ebx
  802133:	83 c4 10             	add    $0x10,%esp
  802136:	85 c0                	test   %eax,%eax
  802138:	78 19                	js     802153 <open+0x75>
	return fd2num(fd);
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	ff 75 f4             	pushl  -0xc(%ebp)
  802140:	e8 04 f8 ff ff       	call   801949 <fd2num>
  802145:	89 c3                	mov    %eax,%ebx
  802147:	83 c4 10             	add    $0x10,%esp
}
  80214a:	89 d8                	mov    %ebx,%eax
  80214c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80214f:	5b                   	pop    %ebx
  802150:	5e                   	pop    %esi
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    
		fd_close(fd, 0);
  802153:	83 ec 08             	sub    $0x8,%esp
  802156:	6a 00                	push   $0x0
  802158:	ff 75 f4             	pushl  -0xc(%ebp)
  80215b:	e8 0c f9 ff ff       	call   801a6c <fd_close>
		return r;
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	eb e5                	jmp    80214a <open+0x6c>
		return -E_BAD_PATH;
  802165:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80216a:	eb de                	jmp    80214a <open+0x6c>

0080216c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802172:	ba 00 00 00 00       	mov    $0x0,%edx
  802177:	b8 08 00 00 00       	mov    $0x8,%eax
  80217c:	e8 56 fd ff ff       	call   801ed7 <fsipc>
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	ff 75 08             	pushl  0x8(%ebp)
  802191:	e8 c3 f7 ff ff       	call   801959 <fd2data>
  802196:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802198:	83 c4 08             	add    $0x8,%esp
  80219b:	68 f6 35 80 00       	push   $0x8035f6
  8021a0:	53                   	push   %ebx
  8021a1:	e8 39 f1 ff ff       	call   8012df <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021a6:	8b 46 04             	mov    0x4(%esi),%eax
  8021a9:	2b 06                	sub    (%esi),%eax
  8021ab:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  8021b1:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  8021b8:	10 00 00 
	stat->st_dev = &devpipe;
  8021bb:	c7 83 88 00 00 00 30 	movl   $0x804030,0x88(%ebx)
  8021c2:	40 80 00 
	return 0;
}
  8021c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    

008021d1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	53                   	push   %ebx
  8021d5:	83 ec 0c             	sub    $0xc,%esp
  8021d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021db:	53                   	push   %ebx
  8021dc:	6a 00                	push   $0x0
  8021de:	e8 36 f5 ff ff       	call   801719 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021e3:	89 1c 24             	mov    %ebx,(%esp)
  8021e6:	e8 6e f7 ff ff       	call   801959 <fd2data>
  8021eb:	83 c4 08             	add    $0x8,%esp
  8021ee:	50                   	push   %eax
  8021ef:	6a 00                	push   $0x0
  8021f1:	e8 23 f5 ff ff       	call   801719 <sys_page_unmap>
}
  8021f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <_pipeisclosed>:
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	57                   	push   %edi
  8021ff:	56                   	push   %esi
  802200:	53                   	push   %ebx
  802201:	83 ec 1c             	sub    $0x1c,%esp
  802204:	89 c7                	mov    %eax,%edi
  802206:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802208:	a1 08 50 80 00       	mov    0x805008,%eax
  80220d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802210:	83 ec 0c             	sub    $0xc,%esp
  802213:	57                   	push   %edi
  802214:	e8 0a 06 00 00       	call   802823 <pageref>
  802219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80221c:	89 34 24             	mov    %esi,(%esp)
  80221f:	e8 ff 05 00 00       	call   802823 <pageref>
		nn = thisenv->env_runs;
  802224:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80222a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80222d:	83 c4 10             	add    $0x10,%esp
  802230:	39 cb                	cmp    %ecx,%ebx
  802232:	74 1b                	je     80224f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802234:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802237:	75 cf                	jne    802208 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802239:	8b 42 58             	mov    0x58(%edx),%eax
  80223c:	6a 01                	push   $0x1
  80223e:	50                   	push   %eax
  80223f:	53                   	push   %ebx
  802240:	68 fd 35 80 00       	push   $0x8035fd
  802245:	e8 9e 04 00 00       	call   8026e8 <cprintf>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	eb b9                	jmp    802208 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80224f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802252:	0f 94 c0             	sete   %al
  802255:	0f b6 c0             	movzbl %al,%eax
}
  802258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5e                   	pop    %esi
  80225d:	5f                   	pop    %edi
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    

00802260 <devpipe_write>:
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	57                   	push   %edi
  802264:	56                   	push   %esi
  802265:	53                   	push   %ebx
  802266:	83 ec 18             	sub    $0x18,%esp
  802269:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80226c:	56                   	push   %esi
  80226d:	e8 e7 f6 ff ff       	call   801959 <fd2data>
  802272:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	bf 00 00 00 00       	mov    $0x0,%edi
  80227c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80227f:	74 41                	je     8022c2 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802281:	8b 53 04             	mov    0x4(%ebx),%edx
  802284:	8b 03                	mov    (%ebx),%eax
  802286:	83 c0 20             	add    $0x20,%eax
  802289:	39 c2                	cmp    %eax,%edx
  80228b:	72 14                	jb     8022a1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80228d:	89 da                	mov    %ebx,%edx
  80228f:	89 f0                	mov    %esi,%eax
  802291:	e8 65 ff ff ff       	call   8021fb <_pipeisclosed>
  802296:	85 c0                	test   %eax,%eax
  802298:	75 2c                	jne    8022c6 <devpipe_write+0x66>
			sys_yield();
  80229a:	e8 bc f4 ff ff       	call   80175b <sys_yield>
  80229f:	eb e0                	jmp    802281 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a4:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  8022a7:	89 d0                	mov    %edx,%eax
  8022a9:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8022ae:	78 0b                	js     8022bb <devpipe_write+0x5b>
  8022b0:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  8022b4:	42                   	inc    %edx
  8022b5:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022b8:	47                   	inc    %edi
  8022b9:	eb c1                	jmp    80227c <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022bb:	48                   	dec    %eax
  8022bc:	83 c8 e0             	or     $0xffffffe0,%eax
  8022bf:	40                   	inc    %eax
  8022c0:	eb ee                	jmp    8022b0 <devpipe_write+0x50>
	return i;
  8022c2:	89 f8                	mov    %edi,%eax
  8022c4:	eb 05                	jmp    8022cb <devpipe_write+0x6b>
				return 0;
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ce:	5b                   	pop    %ebx
  8022cf:	5e                   	pop    %esi
  8022d0:	5f                   	pop    %edi
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    

008022d3 <devpipe_read>:
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	57                   	push   %edi
  8022d7:	56                   	push   %esi
  8022d8:	53                   	push   %ebx
  8022d9:	83 ec 18             	sub    $0x18,%esp
  8022dc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022df:	57                   	push   %edi
  8022e0:	e8 74 f6 ff ff       	call   801959 <fd2data>
  8022e5:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022ef:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8022f2:	74 46                	je     80233a <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  8022f4:	8b 06                	mov    (%esi),%eax
  8022f6:	3b 46 04             	cmp    0x4(%esi),%eax
  8022f9:	75 22                	jne    80231d <devpipe_read+0x4a>
			if (i > 0)
  8022fb:	85 db                	test   %ebx,%ebx
  8022fd:	74 0a                	je     802309 <devpipe_read+0x36>
				return i;
  8022ff:	89 d8                	mov    %ebx,%eax
}
  802301:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802304:	5b                   	pop    %ebx
  802305:	5e                   	pop    %esi
  802306:	5f                   	pop    %edi
  802307:	5d                   	pop    %ebp
  802308:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  802309:	89 f2                	mov    %esi,%edx
  80230b:	89 f8                	mov    %edi,%eax
  80230d:	e8 e9 fe ff ff       	call   8021fb <_pipeisclosed>
  802312:	85 c0                	test   %eax,%eax
  802314:	75 28                	jne    80233e <devpipe_read+0x6b>
			sys_yield();
  802316:	e8 40 f4 ff ff       	call   80175b <sys_yield>
  80231b:	eb d7                	jmp    8022f4 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80231d:	25 1f 00 00 80       	and    $0x8000001f,%eax
  802322:	78 0f                	js     802333 <devpipe_read+0x60>
  802324:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  802328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80232b:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80232e:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  802330:	43                   	inc    %ebx
  802331:	eb bc                	jmp    8022ef <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802333:	48                   	dec    %eax
  802334:	83 c8 e0             	or     $0xffffffe0,%eax
  802337:	40                   	inc    %eax
  802338:	eb ea                	jmp    802324 <devpipe_read+0x51>
	return i;
  80233a:	89 d8                	mov    %ebx,%eax
  80233c:	eb c3                	jmp    802301 <devpipe_read+0x2e>
				return 0;
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
  802343:	eb bc                	jmp    802301 <devpipe_read+0x2e>

00802345 <pipe>:
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	56                   	push   %esi
  802349:	53                   	push   %ebx
  80234a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80234d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802350:	50                   	push   %eax
  802351:	e8 1a f6 ff ff       	call   801970 <fd_alloc>
  802356:	89 c3                	mov    %eax,%ebx
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	85 c0                	test   %eax,%eax
  80235d:	0f 88 2a 01 00 00    	js     80248d <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802363:	83 ec 04             	sub    $0x4,%esp
  802366:	68 07 04 00 00       	push   $0x407
  80236b:	ff 75 f4             	pushl  -0xc(%ebp)
  80236e:	6a 00                	push   $0x0
  802370:	e8 1f f3 ff ff       	call   801694 <sys_page_alloc>
  802375:	89 c3                	mov    %eax,%ebx
  802377:	83 c4 10             	add    $0x10,%esp
  80237a:	85 c0                	test   %eax,%eax
  80237c:	0f 88 0b 01 00 00    	js     80248d <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  802382:	83 ec 0c             	sub    $0xc,%esp
  802385:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802388:	50                   	push   %eax
  802389:	e8 e2 f5 ff ff       	call   801970 <fd_alloc>
  80238e:	89 c3                	mov    %eax,%ebx
  802390:	83 c4 10             	add    $0x10,%esp
  802393:	85 c0                	test   %eax,%eax
  802395:	0f 88 e2 00 00 00    	js     80247d <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239b:	83 ec 04             	sub    $0x4,%esp
  80239e:	68 07 04 00 00       	push   $0x407
  8023a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8023a6:	6a 00                	push   $0x0
  8023a8:	e8 e7 f2 ff ff       	call   801694 <sys_page_alloc>
  8023ad:	89 c3                	mov    %eax,%ebx
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	0f 88 c3 00 00 00    	js     80247d <pipe+0x138>
	va = fd2data(fd0);
  8023ba:	83 ec 0c             	sub    $0xc,%esp
  8023bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c0:	e8 94 f5 ff ff       	call   801959 <fd2data>
  8023c5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023c7:	83 c4 0c             	add    $0xc,%esp
  8023ca:	68 07 04 00 00       	push   $0x407
  8023cf:	50                   	push   %eax
  8023d0:	6a 00                	push   $0x0
  8023d2:	e8 bd f2 ff ff       	call   801694 <sys_page_alloc>
  8023d7:	89 c3                	mov    %eax,%ebx
  8023d9:	83 c4 10             	add    $0x10,%esp
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	0f 88 89 00 00 00    	js     80246d <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e4:	83 ec 0c             	sub    $0xc,%esp
  8023e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ea:	e8 6a f5 ff ff       	call   801959 <fd2data>
  8023ef:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023f6:	50                   	push   %eax
  8023f7:	6a 00                	push   $0x0
  8023f9:	56                   	push   %esi
  8023fa:	6a 00                	push   $0x0
  8023fc:	e8 d6 f2 ff ff       	call   8016d7 <sys_page_map>
  802401:	89 c3                	mov    %eax,%ebx
  802403:	83 c4 20             	add    $0x20,%esp
  802406:	85 c0                	test   %eax,%eax
  802408:	78 55                	js     80245f <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  80240a:	8b 15 30 40 80 00    	mov    0x804030,%edx
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80241f:	8b 15 30 40 80 00    	mov    0x804030,%edx
  802425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802428:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802434:	83 ec 0c             	sub    $0xc,%esp
  802437:	ff 75 f4             	pushl  -0xc(%ebp)
  80243a:	e8 0a f5 ff ff       	call   801949 <fd2num>
  80243f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802442:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802444:	83 c4 04             	add    $0x4,%esp
  802447:	ff 75 f0             	pushl  -0x10(%ebp)
  80244a:	e8 fa f4 ff ff       	call   801949 <fd2num>
  80244f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802452:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802455:	83 c4 10             	add    $0x10,%esp
  802458:	bb 00 00 00 00       	mov    $0x0,%ebx
  80245d:	eb 2e                	jmp    80248d <pipe+0x148>
	sys_page_unmap(0, va);
  80245f:	83 ec 08             	sub    $0x8,%esp
  802462:	56                   	push   %esi
  802463:	6a 00                	push   $0x0
  802465:	e8 af f2 ff ff       	call   801719 <sys_page_unmap>
  80246a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80246d:	83 ec 08             	sub    $0x8,%esp
  802470:	ff 75 f0             	pushl  -0x10(%ebp)
  802473:	6a 00                	push   $0x0
  802475:	e8 9f f2 ff ff       	call   801719 <sys_page_unmap>
  80247a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80247d:	83 ec 08             	sub    $0x8,%esp
  802480:	ff 75 f4             	pushl  -0xc(%ebp)
  802483:	6a 00                	push   $0x0
  802485:	e8 8f f2 ff ff       	call   801719 <sys_page_unmap>
  80248a:	83 c4 10             	add    $0x10,%esp
}
  80248d:	89 d8                	mov    %ebx,%eax
  80248f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802492:	5b                   	pop    %ebx
  802493:	5e                   	pop    %esi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    

00802496 <pipeisclosed>:
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80249c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249f:	50                   	push   %eax
  8024a0:	ff 75 08             	pushl  0x8(%ebp)
  8024a3:	e8 17 f5 ff ff       	call   8019bf <fd_lookup>
  8024a8:	83 c4 10             	add    $0x10,%esp
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	78 18                	js     8024c7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8024af:	83 ec 0c             	sub    $0xc,%esp
  8024b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b5:	e8 9f f4 ff ff       	call   801959 <fd2data>
	return _pipeisclosed(fd, p);
  8024ba:	89 c2                	mov    %eax,%edx
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	e8 37 fd ff ff       	call   8021fb <_pipeisclosed>
  8024c4:	83 c4 10             	add    $0x10,%esp
}
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    

008024d3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	53                   	push   %ebx
  8024d7:	83 ec 0c             	sub    $0xc,%esp
  8024da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  8024dd:	68 15 36 80 00       	push   $0x803615
  8024e2:	53                   	push   %ebx
  8024e3:	e8 f7 ed ff ff       	call   8012df <strcpy>
	stat->st_type = FTYPE_IFCHR;
  8024e8:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8024ef:	20 00 00 
	return 0;
}
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <devcons_write>:
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	57                   	push   %edi
  802500:	56                   	push   %esi
  802501:	53                   	push   %ebx
  802502:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802508:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80250d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802513:	eb 1d                	jmp    802532 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  802515:	83 ec 04             	sub    $0x4,%esp
  802518:	53                   	push   %ebx
  802519:	03 45 0c             	add    0xc(%ebp),%eax
  80251c:	50                   	push   %eax
  80251d:	57                   	push   %edi
  80251e:	e8 2f ef ff ff       	call   801452 <memmove>
		sys_cputs(buf, m);
  802523:	83 c4 08             	add    $0x8,%esp
  802526:	53                   	push   %ebx
  802527:	57                   	push   %edi
  802528:	e8 ca f0 ff ff       	call   8015f7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80252d:	01 de                	add    %ebx,%esi
  80252f:	83 c4 10             	add    $0x10,%esp
  802532:	89 f0                	mov    %esi,%eax
  802534:	3b 75 10             	cmp    0x10(%ebp),%esi
  802537:	73 11                	jae    80254a <devcons_write+0x4e>
		m = n - tot;
  802539:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80253c:	29 f3                	sub    %esi,%ebx
  80253e:	83 fb 7f             	cmp    $0x7f,%ebx
  802541:	76 d2                	jbe    802515 <devcons_write+0x19>
  802543:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  802548:	eb cb                	jmp    802515 <devcons_write+0x19>
}
  80254a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    

00802552 <devcons_read>:
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  802558:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80255c:	75 0c                	jne    80256a <devcons_read+0x18>
		return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	eb 21                	jmp    802586 <devcons_read+0x34>
		sys_yield();
  802565:	e8 f1 f1 ff ff       	call   80175b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80256a:	e8 a6 f0 ff ff       	call   801615 <sys_cgetc>
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 f2                	je     802565 <devcons_read+0x13>
	if (c < 0)
  802573:	85 c0                	test   %eax,%eax
  802575:	78 0f                	js     802586 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  802577:	83 f8 04             	cmp    $0x4,%eax
  80257a:	74 0c                	je     802588 <devcons_read+0x36>
	*(char*)vbuf = c;
  80257c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257f:	88 02                	mov    %al,(%edx)
	return 1;
  802581:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    
		return 0;
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	eb f7                	jmp    802586 <devcons_read+0x34>

0080258f <cputchar>:
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80259b:	6a 01                	push   $0x1
  80259d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025a0:	50                   	push   %eax
  8025a1:	e8 51 f0 ff ff       	call   8015f7 <sys_cputs>
}
  8025a6:	83 c4 10             	add    $0x10,%esp
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <getchar>:
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025b1:	6a 01                	push   $0x1
  8025b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025b6:	50                   	push   %eax
  8025b7:	6a 00                	push   $0x0
  8025b9:	e8 6e f6 ff ff       	call   801c2c <read>
	if (r < 0)
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	78 08                	js     8025cd <getchar+0x22>
	if (r < 1)
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	7e 06                	jle    8025cf <getchar+0x24>
	return c;
  8025c9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    
		return -E_EOF;
  8025cf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025d4:	eb f7                	jmp    8025cd <getchar+0x22>

008025d6 <iscons>:
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025df:	50                   	push   %eax
  8025e0:	ff 75 08             	pushl  0x8(%ebp)
  8025e3:	e8 d7 f3 ff ff       	call   8019bf <fd_lookup>
  8025e8:	83 c4 10             	add    $0x10,%esp
  8025eb:	85 c0                	test   %eax,%eax
  8025ed:	78 11                	js     802600 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8025f8:	39 10                	cmp    %edx,(%eax)
  8025fa:	0f 94 c0             	sete   %al
  8025fd:	0f b6 c0             	movzbl %al,%eax
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <opencons>:
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802608:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80260b:	50                   	push   %eax
  80260c:	e8 5f f3 ff ff       	call   801970 <fd_alloc>
  802611:	83 c4 10             	add    $0x10,%esp
  802614:	85 c0                	test   %eax,%eax
  802616:	78 3a                	js     802652 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	68 07 04 00 00       	push   $0x407
  802620:	ff 75 f4             	pushl  -0xc(%ebp)
  802623:	6a 00                	push   $0x0
  802625:	e8 6a f0 ff ff       	call   801694 <sys_page_alloc>
  80262a:	83 c4 10             	add    $0x10,%esp
  80262d:	85 c0                	test   %eax,%eax
  80262f:	78 21                	js     802652 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802631:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802646:	83 ec 0c             	sub    $0xc,%esp
  802649:	50                   	push   %eax
  80264a:	e8 fa f2 ff ff       	call   801949 <fd2num>
  80264f:	83 c4 10             	add    $0x10,%esp
}
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
  802657:	53                   	push   %ebx
  802658:	83 ec 04             	sub    $0x4,%esp
  80265b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80265e:	8b 13                	mov    (%ebx),%edx
  802660:	8d 42 01             	lea    0x1(%edx),%eax
  802663:	89 03                	mov    %eax,(%ebx)
  802665:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802668:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80266c:	3d ff 00 00 00       	cmp    $0xff,%eax
  802671:	74 08                	je     80267b <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  802673:	ff 43 04             	incl   0x4(%ebx)
}
  802676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802679:	c9                   	leave  
  80267a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80267b:	83 ec 08             	sub    $0x8,%esp
  80267e:	68 ff 00 00 00       	push   $0xff
  802683:	8d 43 08             	lea    0x8(%ebx),%eax
  802686:	50                   	push   %eax
  802687:	e8 6b ef ff ff       	call   8015f7 <sys_cputs>
		b->idx = 0;
  80268c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802692:	83 c4 10             	add    $0x10,%esp
  802695:	eb dc                	jmp    802673 <putch+0x1f>

00802697 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8026a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8026a7:	00 00 00 
	b.cnt = 0;
  8026aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8026b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8026b4:	ff 75 0c             	pushl  0xc(%ebp)
  8026b7:	ff 75 08             	pushl  0x8(%ebp)
  8026ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8026c0:	50                   	push   %eax
  8026c1:	68 54 26 80 00       	push   $0x802654
  8026c6:	e8 06 e7 ff ff       	call   800dd1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8026cb:	83 c4 08             	add    $0x8,%esp
  8026ce:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8026d4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8026da:	50                   	push   %eax
  8026db:	e8 17 ef ff ff       	call   8015f7 <sys_cputs>

	return b.cnt;
}
  8026e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8026ee:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8026f1:	50                   	push   %eax
  8026f2:	ff 75 08             	pushl  0x8(%ebp)
  8026f5:	e8 9d ff ff ff       	call   802697 <vcprintf>
	va_end(ap);

	return cnt;
}
  8026fa:	c9                   	leave  
  8026fb:	c3                   	ret    

008026fc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	57                   	push   %edi
  802700:	56                   	push   %esi
  802701:	53                   	push   %ebx
  802702:	83 ec 0c             	sub    $0xc,%esp
  802705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802708:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80270b:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  80270e:	85 ff                	test   %edi,%edi
  802710:	74 53                	je     802765 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  802712:	83 ec 0c             	sub    $0xc,%esp
  802715:	57                   	push   %edi
  802716:	e8 89 f1 ff ff       	call   8018a4 <sys_ipc_recv>
  80271b:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  80271e:	85 db                	test   %ebx,%ebx
  802720:	74 0b                	je     80272d <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802722:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802728:	8b 52 74             	mov    0x74(%edx),%edx
  80272b:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  80272d:	85 f6                	test   %esi,%esi
  80272f:	74 0f                	je     802740 <ipc_recv+0x44>
  802731:	85 ff                	test   %edi,%edi
  802733:	74 0b                	je     802740 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802735:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80273b:	8b 52 78             	mov    0x78(%edx),%edx
  80273e:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  802740:	85 c0                	test   %eax,%eax
  802742:	74 30                	je     802774 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802744:	85 db                	test   %ebx,%ebx
  802746:	74 06                	je     80274e <ipc_recv+0x52>
      		*from_env_store = 0;
  802748:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  80274e:	85 f6                	test   %esi,%esi
  802750:	74 2c                	je     80277e <ipc_recv+0x82>
      		*perm_store = 0;
  802752:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  802758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  80275d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802760:	5b                   	pop    %ebx
  802761:	5e                   	pop    %esi
  802762:	5f                   	pop    %edi
  802763:	5d                   	pop    %ebp
  802764:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  802765:	83 ec 0c             	sub    $0xc,%esp
  802768:	6a ff                	push   $0xffffffff
  80276a:	e8 35 f1 ff ff       	call   8018a4 <sys_ipc_recv>
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	eb aa                	jmp    80271e <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  802774:	a1 08 50 80 00       	mov    0x805008,%eax
  802779:	8b 40 70             	mov    0x70(%eax),%eax
  80277c:	eb df                	jmp    80275d <ipc_recv+0x61>
		return -1;
  80277e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802783:	eb d8                	jmp    80275d <ipc_recv+0x61>

00802785 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	57                   	push   %edi
  802789:	56                   	push   %esi
  80278a:	53                   	push   %ebx
  80278b:	83 ec 0c             	sub    $0xc,%esp
  80278e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802791:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802794:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  802797:	85 db                	test   %ebx,%ebx
  802799:	75 22                	jne    8027bd <ipc_send+0x38>
		pg = (void *) UTOP+1;
  80279b:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8027a0:	eb 1b                	jmp    8027bd <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8027a2:	68 24 36 80 00       	push   $0x803624
  8027a7:	68 fe 2d 80 00       	push   $0x802dfe
  8027ac:	6a 48                	push   $0x48
  8027ae:	68 48 36 80 00       	push   $0x803648
  8027b3:	e8 b4 e4 ff ff       	call   800c6c <_panic>
		sys_yield();
  8027b8:	e8 9e ef ff ff       	call   80175b <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8027bd:	57                   	push   %edi
  8027be:	53                   	push   %ebx
  8027bf:	56                   	push   %esi
  8027c0:	ff 75 08             	pushl  0x8(%ebp)
  8027c3:	e8 b9 f0 ff ff       	call   801881 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8027c8:	83 c4 10             	add    $0x10,%esp
  8027cb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027ce:	74 e8                	je     8027b8 <ipc_send+0x33>
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	75 ce                	jne    8027a2 <ipc_send+0x1d>
		sys_yield();
  8027d4:	e8 82 ef ff ff       	call   80175b <sys_yield>
		
	}
	
}
  8027d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027dc:	5b                   	pop    %ebx
  8027dd:	5e                   	pop    %esi
  8027de:	5f                   	pop    %edi
  8027df:	5d                   	pop    %ebp
  8027e0:	c3                   	ret    

008027e1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027ec:	89 c2                	mov    %eax,%edx
  8027ee:	c1 e2 05             	shl    $0x5,%edx
  8027f1:	29 c2                	sub    %eax,%edx
  8027f3:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  8027fa:	8b 52 50             	mov    0x50(%edx),%edx
  8027fd:	39 ca                	cmp    %ecx,%edx
  8027ff:	74 0f                	je     802810 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802801:	40                   	inc    %eax
  802802:	3d 00 04 00 00       	cmp    $0x400,%eax
  802807:	75 e3                	jne    8027ec <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802809:	b8 00 00 00 00       	mov    $0x0,%eax
  80280e:	eb 11                	jmp    802821 <ipc_find_env+0x40>
			return envs[i].env_id;
  802810:	89 c2                	mov    %eax,%edx
  802812:	c1 e2 05             	shl    $0x5,%edx
  802815:	29 c2                	sub    %eax,%edx
  802817:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80281e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802821:	5d                   	pop    %ebp
  802822:	c3                   	ret    

00802823 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	c1 e8 16             	shr    $0x16,%eax
  80282c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802833:	a8 01                	test   $0x1,%al
  802835:	74 21                	je     802858 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	c1 e8 0c             	shr    $0xc,%eax
  80283d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802844:	a8 01                	test   $0x1,%al
  802846:	74 17                	je     80285f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802848:	c1 e8 0c             	shr    $0xc,%eax
  80284b:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802852:	ef 
  802853:	0f b7 c0             	movzwl %ax,%eax
  802856:	eb 05                	jmp    80285d <pageref+0x3a>
		return 0;
  802858:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285d:	5d                   	pop    %ebp
  80285e:	c3                   	ret    
		return 0;
  80285f:	b8 00 00 00 00       	mov    $0x0,%eax
  802864:	eb f7                	jmp    80285d <pageref+0x3a>
  802866:	66 90                	xchg   %ax,%ax

00802868 <__udivdi3>:
  802868:	55                   	push   %ebp
  802869:	57                   	push   %edi
  80286a:	56                   	push   %esi
  80286b:	53                   	push   %ebx
  80286c:	83 ec 1c             	sub    $0x1c,%esp
  80286f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802873:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802877:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80287b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80287f:	89 ca                	mov    %ecx,%edx
  802881:	89 f8                	mov    %edi,%eax
  802883:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802887:	85 f6                	test   %esi,%esi
  802889:	75 2d                	jne    8028b8 <__udivdi3+0x50>
  80288b:	39 cf                	cmp    %ecx,%edi
  80288d:	77 65                	ja     8028f4 <__udivdi3+0x8c>
  80288f:	89 fd                	mov    %edi,%ebp
  802891:	85 ff                	test   %edi,%edi
  802893:	75 0b                	jne    8028a0 <__udivdi3+0x38>
  802895:	b8 01 00 00 00       	mov    $0x1,%eax
  80289a:	31 d2                	xor    %edx,%edx
  80289c:	f7 f7                	div    %edi
  80289e:	89 c5                	mov    %eax,%ebp
  8028a0:	31 d2                	xor    %edx,%edx
  8028a2:	89 c8                	mov    %ecx,%eax
  8028a4:	f7 f5                	div    %ebp
  8028a6:	89 c1                	mov    %eax,%ecx
  8028a8:	89 d8                	mov    %ebx,%eax
  8028aa:	f7 f5                	div    %ebp
  8028ac:	89 cf                	mov    %ecx,%edi
  8028ae:	89 fa                	mov    %edi,%edx
  8028b0:	83 c4 1c             	add    $0x1c,%esp
  8028b3:	5b                   	pop    %ebx
  8028b4:	5e                   	pop    %esi
  8028b5:	5f                   	pop    %edi
  8028b6:	5d                   	pop    %ebp
  8028b7:	c3                   	ret    
  8028b8:	39 ce                	cmp    %ecx,%esi
  8028ba:	77 28                	ja     8028e4 <__udivdi3+0x7c>
  8028bc:	0f bd fe             	bsr    %esi,%edi
  8028bf:	83 f7 1f             	xor    $0x1f,%edi
  8028c2:	75 40                	jne    802904 <__udivdi3+0x9c>
  8028c4:	39 ce                	cmp    %ecx,%esi
  8028c6:	72 0a                	jb     8028d2 <__udivdi3+0x6a>
  8028c8:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8028cc:	0f 87 9e 00 00 00    	ja     802970 <__udivdi3+0x108>
  8028d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d7:	89 fa                	mov    %edi,%edx
  8028d9:	83 c4 1c             	add    $0x1c,%esp
  8028dc:	5b                   	pop    %ebx
  8028dd:	5e                   	pop    %esi
  8028de:	5f                   	pop    %edi
  8028df:	5d                   	pop    %ebp
  8028e0:	c3                   	ret    
  8028e1:	8d 76 00             	lea    0x0(%esi),%esi
  8028e4:	31 ff                	xor    %edi,%edi
  8028e6:	31 c0                	xor    %eax,%eax
  8028e8:	89 fa                	mov    %edi,%edx
  8028ea:	83 c4 1c             	add    $0x1c,%esp
  8028ed:	5b                   	pop    %ebx
  8028ee:	5e                   	pop    %esi
  8028ef:	5f                   	pop    %edi
  8028f0:	5d                   	pop    %ebp
  8028f1:	c3                   	ret    
  8028f2:	66 90                	xchg   %ax,%ax
  8028f4:	89 d8                	mov    %ebx,%eax
  8028f6:	f7 f7                	div    %edi
  8028f8:	31 ff                	xor    %edi,%edi
  8028fa:	89 fa                	mov    %edi,%edx
  8028fc:	83 c4 1c             	add    $0x1c,%esp
  8028ff:	5b                   	pop    %ebx
  802900:	5e                   	pop    %esi
  802901:	5f                   	pop    %edi
  802902:	5d                   	pop    %ebp
  802903:	c3                   	ret    
  802904:	bd 20 00 00 00       	mov    $0x20,%ebp
  802909:	29 fd                	sub    %edi,%ebp
  80290b:	89 f9                	mov    %edi,%ecx
  80290d:	d3 e6                	shl    %cl,%esi
  80290f:	89 c3                	mov    %eax,%ebx
  802911:	89 e9                	mov    %ebp,%ecx
  802913:	d3 eb                	shr    %cl,%ebx
  802915:	89 d9                	mov    %ebx,%ecx
  802917:	09 f1                	or     %esi,%ecx
  802919:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80291d:	89 f9                	mov    %edi,%ecx
  80291f:	d3 e0                	shl    %cl,%eax
  802921:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802925:	89 d6                	mov    %edx,%esi
  802927:	89 e9                	mov    %ebp,%ecx
  802929:	d3 ee                	shr    %cl,%esi
  80292b:	89 f9                	mov    %edi,%ecx
  80292d:	d3 e2                	shl    %cl,%edx
  80292f:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802933:	89 e9                	mov    %ebp,%ecx
  802935:	d3 eb                	shr    %cl,%ebx
  802937:	09 da                	or     %ebx,%edx
  802939:	89 d0                	mov    %edx,%eax
  80293b:	89 f2                	mov    %esi,%edx
  80293d:	f7 74 24 08          	divl   0x8(%esp)
  802941:	89 d6                	mov    %edx,%esi
  802943:	89 c3                	mov    %eax,%ebx
  802945:	f7 64 24 0c          	mull   0xc(%esp)
  802949:	39 d6                	cmp    %edx,%esi
  80294b:	72 17                	jb     802964 <__udivdi3+0xfc>
  80294d:	74 09                	je     802958 <__udivdi3+0xf0>
  80294f:	89 d8                	mov    %ebx,%eax
  802951:	31 ff                	xor    %edi,%edi
  802953:	e9 56 ff ff ff       	jmp    8028ae <__udivdi3+0x46>
  802958:	8b 54 24 04          	mov    0x4(%esp),%edx
  80295c:	89 f9                	mov    %edi,%ecx
  80295e:	d3 e2                	shl    %cl,%edx
  802960:	39 c2                	cmp    %eax,%edx
  802962:	73 eb                	jae    80294f <__udivdi3+0xe7>
  802964:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802967:	31 ff                	xor    %edi,%edi
  802969:	e9 40 ff ff ff       	jmp    8028ae <__udivdi3+0x46>
  80296e:	66 90                	xchg   %ax,%ax
  802970:	31 c0                	xor    %eax,%eax
  802972:	e9 37 ff ff ff       	jmp    8028ae <__udivdi3+0x46>
  802977:	90                   	nop

00802978 <__umoddi3>:
  802978:	55                   	push   %ebp
  802979:	57                   	push   %edi
  80297a:	56                   	push   %esi
  80297b:	53                   	push   %ebx
  80297c:	83 ec 1c             	sub    $0x1c,%esp
  80297f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802983:	8b 74 24 34          	mov    0x34(%esp),%esi
  802987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80298b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80298f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802993:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802997:	89 3c 24             	mov    %edi,(%esp)
  80299a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80299e:	89 f2                	mov    %esi,%edx
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	75 18                	jne    8029bc <__umoddi3+0x44>
  8029a4:	39 f7                	cmp    %esi,%edi
  8029a6:	0f 86 a0 00 00 00    	jbe    802a4c <__umoddi3+0xd4>
  8029ac:	89 c8                	mov    %ecx,%eax
  8029ae:	f7 f7                	div    %edi
  8029b0:	89 d0                	mov    %edx,%eax
  8029b2:	31 d2                	xor    %edx,%edx
  8029b4:	83 c4 1c             	add    $0x1c,%esp
  8029b7:	5b                   	pop    %ebx
  8029b8:	5e                   	pop    %esi
  8029b9:	5f                   	pop    %edi
  8029ba:	5d                   	pop    %ebp
  8029bb:	c3                   	ret    
  8029bc:	89 f3                	mov    %esi,%ebx
  8029be:	39 f0                	cmp    %esi,%eax
  8029c0:	0f 87 a6 00 00 00    	ja     802a6c <__umoddi3+0xf4>
  8029c6:	0f bd e8             	bsr    %eax,%ebp
  8029c9:	83 f5 1f             	xor    $0x1f,%ebp
  8029cc:	0f 84 a6 00 00 00    	je     802a78 <__umoddi3+0x100>
  8029d2:	bf 20 00 00 00       	mov    $0x20,%edi
  8029d7:	29 ef                	sub    %ebp,%edi
  8029d9:	89 e9                	mov    %ebp,%ecx
  8029db:	d3 e0                	shl    %cl,%eax
  8029dd:	8b 34 24             	mov    (%esp),%esi
  8029e0:	89 f2                	mov    %esi,%edx
  8029e2:	89 f9                	mov    %edi,%ecx
  8029e4:	d3 ea                	shr    %cl,%edx
  8029e6:	09 c2                	or     %eax,%edx
  8029e8:	89 14 24             	mov    %edx,(%esp)
  8029eb:	89 f2                	mov    %esi,%edx
  8029ed:	89 e9                	mov    %ebp,%ecx
  8029ef:	d3 e2                	shl    %cl,%edx
  8029f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029f5:	89 de                	mov    %ebx,%esi
  8029f7:	89 f9                	mov    %edi,%ecx
  8029f9:	d3 ee                	shr    %cl,%esi
  8029fb:	89 e9                	mov    %ebp,%ecx
  8029fd:	d3 e3                	shl    %cl,%ebx
  8029ff:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a03:	89 d0                	mov    %edx,%eax
  802a05:	89 f9                	mov    %edi,%ecx
  802a07:	d3 e8                	shr    %cl,%eax
  802a09:	09 d8                	or     %ebx,%eax
  802a0b:	89 d3                	mov    %edx,%ebx
  802a0d:	89 e9                	mov    %ebp,%ecx
  802a0f:	d3 e3                	shl    %cl,%ebx
  802a11:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a15:	89 f2                	mov    %esi,%edx
  802a17:	f7 34 24             	divl   (%esp)
  802a1a:	89 d6                	mov    %edx,%esi
  802a1c:	f7 64 24 04          	mull   0x4(%esp)
  802a20:	89 c3                	mov    %eax,%ebx
  802a22:	89 d1                	mov    %edx,%ecx
  802a24:	39 d6                	cmp    %edx,%esi
  802a26:	72 7c                	jb     802aa4 <__umoddi3+0x12c>
  802a28:	74 72                	je     802a9c <__umoddi3+0x124>
  802a2a:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a2e:	29 da                	sub    %ebx,%edx
  802a30:	19 ce                	sbb    %ecx,%esi
  802a32:	89 f0                	mov    %esi,%eax
  802a34:	89 f9                	mov    %edi,%ecx
  802a36:	d3 e0                	shl    %cl,%eax
  802a38:	89 e9                	mov    %ebp,%ecx
  802a3a:	d3 ea                	shr    %cl,%edx
  802a3c:	09 d0                	or     %edx,%eax
  802a3e:	89 e9                	mov    %ebp,%ecx
  802a40:	d3 ee                	shr    %cl,%esi
  802a42:	89 f2                	mov    %esi,%edx
  802a44:	83 c4 1c             	add    $0x1c,%esp
  802a47:	5b                   	pop    %ebx
  802a48:	5e                   	pop    %esi
  802a49:	5f                   	pop    %edi
  802a4a:	5d                   	pop    %ebp
  802a4b:	c3                   	ret    
  802a4c:	89 fd                	mov    %edi,%ebp
  802a4e:	85 ff                	test   %edi,%edi
  802a50:	75 0b                	jne    802a5d <__umoddi3+0xe5>
  802a52:	b8 01 00 00 00       	mov    $0x1,%eax
  802a57:	31 d2                	xor    %edx,%edx
  802a59:	f7 f7                	div    %edi
  802a5b:	89 c5                	mov    %eax,%ebp
  802a5d:	89 f0                	mov    %esi,%eax
  802a5f:	31 d2                	xor    %edx,%edx
  802a61:	f7 f5                	div    %ebp
  802a63:	89 c8                	mov    %ecx,%eax
  802a65:	f7 f5                	div    %ebp
  802a67:	e9 44 ff ff ff       	jmp    8029b0 <__umoddi3+0x38>
  802a6c:	89 c8                	mov    %ecx,%eax
  802a6e:	89 f2                	mov    %esi,%edx
  802a70:	83 c4 1c             	add    $0x1c,%esp
  802a73:	5b                   	pop    %ebx
  802a74:	5e                   	pop    %esi
  802a75:	5f                   	pop    %edi
  802a76:	5d                   	pop    %ebp
  802a77:	c3                   	ret    
  802a78:	39 f0                	cmp    %esi,%eax
  802a7a:	72 05                	jb     802a81 <__umoddi3+0x109>
  802a7c:	39 0c 24             	cmp    %ecx,(%esp)
  802a7f:	77 0c                	ja     802a8d <__umoddi3+0x115>
  802a81:	89 f2                	mov    %esi,%edx
  802a83:	29 f9                	sub    %edi,%ecx
  802a85:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a89:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a8d:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a91:	83 c4 1c             	add    $0x1c,%esp
  802a94:	5b                   	pop    %ebx
  802a95:	5e                   	pop    %esi
  802a96:	5f                   	pop    %edi
  802a97:	5d                   	pop    %ebp
  802a98:	c3                   	ret    
  802a99:	8d 76 00             	lea    0x0(%esi),%esi
  802a9c:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802aa0:	73 88                	jae    802a2a <__umoddi3+0xb2>
  802aa2:	66 90                	xchg   %ax,%ax
  802aa4:	2b 44 24 04          	sub    0x4(%esp),%eax
  802aa8:	1b 14 24             	sbb    (%esp),%edx
  802aab:	89 d1                	mov    %edx,%ecx
  802aad:	89 c3                	mov    %eax,%ebx
  802aaf:	e9 76 ff ff ff       	jmp    802a2a <__umoddi3+0xb2>
