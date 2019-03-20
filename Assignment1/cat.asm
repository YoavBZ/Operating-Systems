
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 10             	sub    $0x10,%esp
  int fd, i;

  if(argc <= 1){
   c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  10:	7e 6f                	jle    81 <main+0x81>
  12:	8b 45 0c             	mov    0xc(%ebp),%eax
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
  15:	be 01 00 00 00       	mov    $0x1,%esi
  1a:	8d 78 04             	lea    0x4(%eax),%edi
  1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((fd = open(argv[i], 0)) < 0){
  20:	31 c0                	xor    %eax,%eax
  22:	89 44 24 04          	mov    %eax,0x4(%esp)
  26:	8b 07                	mov    (%edi),%eax
  28:	89 04 24             	mov    %eax,(%esp)
  2b:	e8 78 03 00 00       	call   3a8 <open>
  30:	85 c0                	test   %eax,%eax
  32:	89 c3                	mov    %eax,%ebx
  34:	78 25                	js     5b <main+0x5b>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit(0);
    }
    cat(fd);
  36:	89 04 24             	mov    %eax,(%esp)
  for(i = 1; i < argc; i++){
  39:	46                   	inc    %esi
  3a:	83 c7 04             	add    $0x4,%edi
    cat(fd);
  3d:	e8 5e 00 00 00       	call   a0 <cat>
    close(fd);
  42:	89 1c 24             	mov    %ebx,(%esp)
  45:	e8 46 03 00 00       	call   390 <close>
  for(i = 1; i < argc; i++){
  4a:	39 75 08             	cmp    %esi,0x8(%ebp)
  4d:	75 d1                	jne    20 <main+0x20>
  }
  exit(0);
  4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  56:	e8 0d 03 00 00       	call   368 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  5b:	8b 07                	mov    (%edi),%eax
  5d:	c7 44 24 04 5b 08 00 	movl   $0x85b,0x4(%esp)
  64:	00 
  65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  70:	e8 4b 04 00 00       	call   4c0 <printf>
      exit(0);
  75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7c:	e8 e7 02 00 00       	call   368 <exit>
    cat(0);
  81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  88:	e8 13 00 00 00       	call   a0 <cat>
    exit(0);
  8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  94:	e8 cf 02 00 00       	call   368 <exit>
  99:	66 90                	xchg   %ax,%ax
  9b:	66 90                	xchg   %ax,%ax
  9d:	66 90                	xchg   %ax,%ax
  9f:	90                   	nop

000000a0 <cat>:
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	56                   	push   %esi
  a4:	53                   	push   %ebx
  a5:	83 ec 10             	sub    $0x10,%esp
  a8:	8b 75 08             	mov    0x8(%ebp),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  ab:	eb 20                	jmp    cd <cat+0x2d>
  ad:	8d 76 00             	lea    0x0(%esi),%esi
    if (write(1, buf, n) != n) {
  b0:	b8 60 0b 00 00       	mov    $0xb60,%eax
  b5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c4:	e8 bf 02 00 00       	call   388 <write>
  c9:	39 d8                	cmp    %ebx,%eax
  cb:	75 2a                	jne    f7 <cat+0x57>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  cd:	b8 00 02 00 00       	mov    $0x200,%eax
  d2:	ba 60 0b 00 00       	mov    $0xb60,%edx
  d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  db:	89 54 24 04          	mov    %edx,0x4(%esp)
  df:	89 34 24             	mov    %esi,(%esp)
  e2:	e8 99 02 00 00       	call   380 <read>
  e7:	83 f8 00             	cmp    $0x0,%eax
  ea:	89 c3                	mov    %eax,%ebx
  ec:	7f c2                	jg     b0 <cat+0x10>
  if(n < 0){
  ee:	75 28                	jne    118 <cat+0x78>
}
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	5b                   	pop    %ebx
  f4:	5e                   	pop    %esi
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    
      printf(1, "cat: write error\n");
  f7:	b9 38 08 00 00       	mov    $0x838,%ecx
  fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 100:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 107:	e8 b4 03 00 00       	call   4c0 <printf>
      exit(0);
 10c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 113:	e8 50 02 00 00       	call   368 <exit>
    printf(1, "cat: read error\n");
 118:	c7 44 24 04 4a 08 00 	movl   $0x84a,0x4(%esp)
 11f:	00 
 120:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 127:	e8 94 03 00 00       	call   4c0 <printf>
    exit(0);
 12c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 133:	e8 30 02 00 00       	call   368 <exit>
 138:	66 90                	xchg   %ax,%ax
 13a:	66 90                	xchg   %ax,%ax
 13c:	66 90                	xchg   %ax,%ax
 13e:	66 90                	xchg   %ax,%ax

00000140 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 149:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14a:	89 c2                	mov    %eax,%edx
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 150:	41                   	inc    %ecx
 151:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 155:	42                   	inc    %edx
 156:	84 db                	test   %bl,%bl
 158:	88 5a ff             	mov    %bl,-0x1(%edx)
 15b:	75 f3                	jne    150 <strcpy+0x10>
    ;
  return os;
}
 15d:	5b                   	pop    %ebx
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
 166:	53                   	push   %ebx
 167:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 16a:	0f b6 01             	movzbl (%ecx),%eax
 16d:	0f b6 13             	movzbl (%ebx),%edx
 170:	84 c0                	test   %al,%al
 172:	75 18                	jne    18c <strcmp+0x2c>
 174:	eb 22                	jmp    198 <strcmp+0x38>
 176:	8d 76 00             	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 180:	41                   	inc    %ecx
  while(*p && *p == *q)
 181:	0f b6 01             	movzbl (%ecx),%eax
    p++, q++;
 184:	43                   	inc    %ebx
 185:	0f b6 13             	movzbl (%ebx),%edx
  while(*p && *p == *q)
 188:	84 c0                	test   %al,%al
 18a:	74 0c                	je     198 <strcmp+0x38>
 18c:	38 d0                	cmp    %dl,%al
 18e:	74 f0                	je     180 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
 190:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
 191:	29 d0                	sub    %edx,%eax
}
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    
 195:	8d 76 00             	lea    0x0(%esi),%esi
 198:	5b                   	pop    %ebx
 199:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 19b:	29 d0                	sub    %edx,%eax
}
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret    
 19f:	90                   	nop

000001a0 <strlen>:

uint
strlen(const char *s)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1a6:	80 39 00             	cmpb   $0x0,(%ecx)
 1a9:	74 15                	je     1c0 <strlen+0x20>
 1ab:	31 d2                	xor    %edx,%edx
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
 1b0:	42                   	inc    %edx
 1b1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1b5:	89 d0                	mov    %edx,%eax
 1b7:	75 f7                	jne    1b0 <strlen+0x10>
    ;
  return n;
}
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    
 1bb:	90                   	nop
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(n = 0; s[n]; n++)
 1c0:	31 c0                	xor    %eax,%eax
}
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 55 08             	mov    0x8(%ebp),%edx
 1d6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	89 d7                	mov    %edx,%edi
 1df:	fc                   	cld    
 1e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e2:	5f                   	pop    %edi
 1e3:	89 d0                	mov    %edx,%eax
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
 1e7:	89 f6                	mov    %esi,%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fa:	0f b6 10             	movzbl (%eax),%edx
 1fd:	84 d2                	test   %dl,%dl
 1ff:	74 1b                	je     21c <strchr+0x2c>
    if(*s == c)
 201:	38 d1                	cmp    %dl,%cl
 203:	75 0f                	jne    214 <strchr+0x24>
 205:	eb 17                	jmp    21e <strchr+0x2e>
 207:	89 f6                	mov    %esi,%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 210:	38 ca                	cmp    %cl,%dl
 212:	74 0a                	je     21e <strchr+0x2e>
  for(; *s; s++)
 214:	40                   	inc    %eax
 215:	0f b6 10             	movzbl (%eax),%edx
 218:	84 d2                	test   %dl,%dl
 21a:	75 f4                	jne    210 <strchr+0x20>
      return (char*)s;
  return 0;
 21c:	31 c0                	xor    %eax,%eax
}
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 225:	31 f6                	xor    %esi,%esi
{
 227:	53                   	push   %ebx
 228:	83 ec 3c             	sub    $0x3c,%esp
 22b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cc = read(0, &c, 1);
 22e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 231:	eb 32                	jmp    265 <gets+0x45>
 233:	90                   	nop
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cc = read(0, &c, 1);
 238:	ba 01 00 00 00       	mov    $0x1,%edx
 23d:	89 54 24 08          	mov    %edx,0x8(%esp)
 241:	89 7c 24 04          	mov    %edi,0x4(%esp)
 245:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24c:	e8 2f 01 00 00       	call   380 <read>
    if(cc < 1)
 251:	85 c0                	test   %eax,%eax
 253:	7e 19                	jle    26e <gets+0x4e>
      break;
    buf[i++] = c;
 255:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 259:	43                   	inc    %ebx
 25a:	88 43 ff             	mov    %al,-0x1(%ebx)
    if(c == '\n' || c == '\r')
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 1f                	je     280 <gets+0x60>
 261:	3c 0d                	cmp    $0xd,%al
 263:	74 1b                	je     280 <gets+0x60>
  for(i=0; i+1 < max; ){
 265:	46                   	inc    %esi
 266:	3b 75 0c             	cmp    0xc(%ebp),%esi
 269:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 26c:	7c ca                	jl     238 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 26e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	83 c4 3c             	add    $0x3c,%esp
 27a:	5b                   	pop    %ebx
 27b:	5e                   	pop    %esi
 27c:	5f                   	pop    %edi
 27d:	5d                   	pop    %ebp
 27e:	c3                   	ret    
 27f:	90                   	nop
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	01 c6                	add    %eax,%esi
 285:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 288:	eb e4                	jmp    26e <gets+0x4e>
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000290 <stat>:

int
stat(const char *n, struct stat *st)
{
 290:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 291:	31 c0                	xor    %eax,%eax
{
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 298:	89 44 24 04          	mov    %eax,0x4(%esp)
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
{
 29f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2a2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 2a5:	89 04 24             	mov    %eax,(%esp)
 2a8:	e8 fb 00 00 00       	call   3a8 <open>
  if(fd < 0)
 2ad:	85 c0                	test   %eax,%eax
 2af:	78 2f                	js     2e0 <stat+0x50>
 2b1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	89 1c 24             	mov    %ebx,(%esp)
 2b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bd:	e8 fe 00 00 00       	call   3c0 <fstat>
  close(fd);
 2c2:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2c5:	89 c6                	mov    %eax,%esi
  close(fd);
 2c7:	e8 c4 00 00 00       	call   390 <close>
  return r;
}
 2cc:	89 f0                	mov    %esi,%eax
 2ce:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2d1:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2d4:	89 ec                	mov    %ebp,%esp
 2d6:	5d                   	pop    %ebp
 2d7:	c3                   	ret    
 2d8:	90                   	nop
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 2e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2e5:	eb e5                	jmp    2cc <stat+0x3c>
 2e7:	89 f6                	mov    %esi,%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <atoi>:

int
atoi(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f7:	0f be 11             	movsbl (%ecx),%edx
 2fa:	88 d0                	mov    %dl,%al
 2fc:	2c 30                	sub    $0x30,%al
 2fe:	3c 09                	cmp    $0x9,%al
  n = 0;
 300:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 305:	77 1e                	ja     325 <atoi+0x35>
 307:	89 f6                	mov    %esi,%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 310:	41                   	inc    %ecx
 311:	8d 04 80             	lea    (%eax,%eax,4),%eax
 314:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 318:	0f be 11             	movsbl (%ecx),%edx
 31b:	88 d3                	mov    %dl,%bl
 31d:	80 eb 30             	sub    $0x30,%bl
 320:	80 fb 09             	cmp    $0x9,%bl
 323:	76 eb                	jbe    310 <atoi+0x20>
  return n;
}
 325:	5b                   	pop    %ebx
 326:	5d                   	pop    %ebp
 327:	c3                   	ret    
 328:	90                   	nop
 329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000330 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	56                   	push   %esi
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	53                   	push   %ebx
 338:	8b 5d 10             	mov    0x10(%ebp),%ebx
 33b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33e:	85 db                	test   %ebx,%ebx
 340:	7e 1a                	jle    35c <memmove+0x2c>
 342:	31 d2                	xor    %edx,%edx
 344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 34a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    *dst++ = *src++;
 350:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 354:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 357:	42                   	inc    %edx
  while(n-- > 0)
 358:	39 d3                	cmp    %edx,%ebx
 35a:	75 f4                	jne    350 <memmove+0x20>
  return vdst;
}
 35c:	5b                   	pop    %ebx
 35d:	5e                   	pop    %esi
 35e:	5d                   	pop    %ebp
 35f:	c3                   	ret    

00000360 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 360:	b8 01 00 00 00       	mov    $0x1,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <exit>:
SYSCALL(exit)
 368:	b8 02 00 00 00       	mov    $0x2,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <wait>:
SYSCALL(wait)
 370:	b8 03 00 00 00       	mov    $0x3,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <pipe>:
SYSCALL(pipe)
 378:	b8 04 00 00 00       	mov    $0x4,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <read>:
SYSCALL(read)
 380:	b8 05 00 00 00       	mov    $0x5,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <write>:
SYSCALL(write)
 388:	b8 10 00 00 00       	mov    $0x10,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <close>:
SYSCALL(close)
 390:	b8 15 00 00 00       	mov    $0x15,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <kill>:
SYSCALL(kill)
 398:	b8 06 00 00 00       	mov    $0x6,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <exec>:
SYSCALL(exec)
 3a0:	b8 07 00 00 00       	mov    $0x7,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <open>:
SYSCALL(open)
 3a8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <mknod>:
SYSCALL(mknod)
 3b0:	b8 11 00 00 00       	mov    $0x11,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <unlink>:
SYSCALL(unlink)
 3b8:	b8 12 00 00 00       	mov    $0x12,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <fstat>:
SYSCALL(fstat)
 3c0:	b8 08 00 00 00       	mov    $0x8,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <link>:
SYSCALL(link)
 3c8:	b8 13 00 00 00       	mov    $0x13,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mkdir>:
SYSCALL(mkdir)
 3d0:	b8 14 00 00 00       	mov    $0x14,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <chdir>:
SYSCALL(chdir)
 3d8:	b8 09 00 00 00       	mov    $0x9,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <dup>:
SYSCALL(dup)
 3e0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <getpid>:
SYSCALL(getpid)
 3e8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <sbrk>:
SYSCALL(sbrk)
 3f0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <sleep>:
SYSCALL(sleep)
 3f8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <uptime>:
SYSCALL(uptime)
 400:	b8 0e 00 00 00       	mov    $0xe,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <detach>:
SYSCALL(detach)
 408:	b8 16 00 00 00       	mov    $0x16,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <policy>:
SYSCALL(policy)
 410:	b8 17 00 00 00       	mov    $0x17,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <priority>:
 418:	b8 18 00 00 00       	mov    $0x18,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 426:	89 d3                	mov    %edx,%ebx
 428:	c1 eb 1f             	shr    $0x1f,%ebx
{
 42b:	83 ec 4c             	sub    $0x4c,%esp
  if(sgn && xx < 0){
 42e:	84 db                	test   %bl,%bl
{
 430:	89 45 c0             	mov    %eax,-0x40(%ebp)
 433:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 435:	74 79                	je     4b0 <printint+0x90>
 437:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 43b:	74 73                	je     4b0 <printint+0x90>
    neg = 1;
    x = -xx;
 43d:	f7 d8                	neg    %eax
    neg = 1;
 43f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 446:	31 f6                	xor    %esi,%esi
 448:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 44b:	eb 05                	jmp    452 <printint+0x32>
 44d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 450:	89 fe                	mov    %edi,%esi
 452:	31 d2                	xor    %edx,%edx
 454:	f7 f1                	div    %ecx
 456:	8d 7e 01             	lea    0x1(%esi),%edi
 459:	0f b6 92 78 08 00 00 	movzbl 0x878(%edx),%edx
  }while((x /= base) != 0);
 460:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 462:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 465:	75 e9                	jne    450 <printint+0x30>
  if(neg)
 467:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 46a:	85 d2                	test   %edx,%edx
 46c:	74 08                	je     476 <printint+0x56>
    buf[i++] = '-';
 46e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 473:	8d 7e 02             	lea    0x2(%esi),%edi
 476:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 47a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 47d:	8d 76 00             	lea    0x0(%esi),%esi
 480:	0f b6 06             	movzbl (%esi),%eax
 483:	4e                   	dec    %esi
  write(fd, &c, 1);
 484:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 488:	89 3c 24             	mov    %edi,(%esp)
 48b:	88 45 d7             	mov    %al,-0x29(%ebp)
 48e:	b8 01 00 00 00       	mov    $0x1,%eax
 493:	89 44 24 08          	mov    %eax,0x8(%esp)
 497:	e8 ec fe ff ff       	call   388 <write>

  while(--i >= 0)
 49c:	39 de                	cmp    %ebx,%esi
 49e:	75 e0                	jne    480 <printint+0x60>
    putc(fd, buf[i]);
}
 4a0:	83 c4 4c             	add    $0x4c,%esp
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5f                   	pop    %edi
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    
 4a8:	90                   	nop
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4b0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4b7:	eb 8d                	jmp    446 <printint+0x26>
 4b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
 4c6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c9:	8b 75 0c             	mov    0xc(%ebp),%esi
 4cc:	0f b6 1e             	movzbl (%esi),%ebx
 4cf:	84 db                	test   %bl,%bl
 4d1:	0f 84 d1 00 00 00    	je     5a8 <printf+0xe8>
  state = 0;
 4d7:	31 ff                	xor    %edi,%edi
 4d9:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 4da:	8d 45 10             	lea    0x10(%ebp),%eax
  write(fd, &c, 1);
 4dd:	89 fa                	mov    %edi,%edx
 4df:	8b 7d 08             	mov    0x8(%ebp),%edi
  ap = (uint*)(void*)&fmt + 1;
 4e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4e5:	eb 41                	jmp    528 <printf+0x68>
 4e7:	89 f6                	mov    %esi,%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4f0:	83 f8 25             	cmp    $0x25,%eax
 4f3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 4f6:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4fb:	74 1e                	je     51b <printf+0x5b>
  write(fd, &c, 1);
 4fd:	b8 01 00 00 00       	mov    $0x1,%eax
 502:	89 44 24 08          	mov    %eax,0x8(%esp)
 506:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	89 3c 24             	mov    %edi,(%esp)
 510:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 513:	e8 70 fe ff ff       	call   388 <write>
 518:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 51b:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 51c:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 520:	84 db                	test   %bl,%bl
 522:	0f 84 80 00 00 00    	je     5a8 <printf+0xe8>
    if(state == 0){
 528:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 52a:	0f be cb             	movsbl %bl,%ecx
 52d:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 530:	74 be                	je     4f0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 532:	83 fa 25             	cmp    $0x25,%edx
 535:	75 e4                	jne    51b <printf+0x5b>
      if(c == 'd'){
 537:	83 f8 64             	cmp    $0x64,%eax
 53a:	0f 84 f0 00 00 00    	je     630 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 540:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 546:	83 f9 70             	cmp    $0x70,%ecx
 549:	74 65                	je     5b0 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 54b:	83 f8 73             	cmp    $0x73,%eax
 54e:	0f 84 8c 00 00 00    	je     5e0 <printf+0x120>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 554:	83 f8 63             	cmp    $0x63,%eax
 557:	0f 84 13 01 00 00    	je     670 <printf+0x1b0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 55d:	83 f8 25             	cmp    $0x25,%eax
 560:	0f 84 e2 00 00 00    	je     648 <printf+0x188>
  write(fd, &c, 1);
 566:	b8 01 00 00 00       	mov    $0x1,%eax
 56b:	46                   	inc    %esi
 56c:	89 44 24 08          	mov    %eax,0x8(%esp)
 570:	8d 45 e7             	lea    -0x19(%ebp),%eax
 573:	89 44 24 04          	mov    %eax,0x4(%esp)
 577:	89 3c 24             	mov    %edi,(%esp)
 57a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 57e:	e8 05 fe ff ff       	call   388 <write>
 583:	ba 01 00 00 00       	mov    $0x1,%edx
 588:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 58b:	89 54 24 08          	mov    %edx,0x8(%esp)
 58f:	89 44 24 04          	mov    %eax,0x4(%esp)
 593:	89 3c 24             	mov    %edi,(%esp)
 596:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 599:	e8 ea fd ff ff       	call   388 <write>
  for(i = 0; fmt[i]; i++){
 59e:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5a2:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5a4:	84 db                	test   %bl,%bl
 5a6:	75 80                	jne    528 <printf+0x68>
    }
  }
}
 5a8:	83 c4 3c             	add    $0x3c,%esp
 5ab:	5b                   	pop    %ebx
 5ac:	5e                   	pop    %esi
 5ad:	5f                   	pop    %edi
 5ae:	5d                   	pop    %ebp
 5af:	c3                   	ret    
        printint(fd, *ap, 16, 0);
 5b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5b7:	b9 10 00 00 00       	mov    $0x10,%ecx
 5bc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5bf:	89 f8                	mov    %edi,%eax
 5c1:	8b 13                	mov    (%ebx),%edx
 5c3:	e8 58 fe ff ff       	call   420 <printint>
        ap++;
 5c8:	89 d8                	mov    %ebx,%eax
      state = 0;
 5ca:	31 d2                	xor    %edx,%edx
        ap++;
 5cc:	83 c0 04             	add    $0x4,%eax
 5cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5d2:	e9 44 ff ff ff       	jmp    51b <printf+0x5b>
 5d7:	89 f6                	mov    %esi,%esi
 5d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        s = (char*)*ap;
 5e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5e3:	8b 10                	mov    (%eax),%edx
        ap++;
 5e5:	83 c0 04             	add    $0x4,%eax
 5e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5eb:	85 d2                	test   %edx,%edx
 5ed:	0f 84 aa 00 00 00    	je     69d <printf+0x1dd>
        while(*s != 0){
 5f3:	0f b6 02             	movzbl (%edx),%eax
        s = (char*)*ap;
 5f6:	89 d3                	mov    %edx,%ebx
        while(*s != 0){
 5f8:	84 c0                	test   %al,%al
 5fa:	74 27                	je     623 <printf+0x163>
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 600:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 603:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 608:	43                   	inc    %ebx
  write(fd, &c, 1);
 609:	89 44 24 08          	mov    %eax,0x8(%esp)
 60d:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	89 3c 24             	mov    %edi,(%esp)
 617:	e8 6c fd ff ff       	call   388 <write>
        while(*s != 0){
 61c:	0f b6 03             	movzbl (%ebx),%eax
 61f:	84 c0                	test   %al,%al
 621:	75 dd                	jne    600 <printf+0x140>
      state = 0;
 623:	31 d2                	xor    %edx,%edx
 625:	e9 f1 fe ff ff       	jmp    51b <printf+0x5b>
 62a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 630:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 637:	b9 0a 00 00 00       	mov    $0xa,%ecx
 63c:	e9 7b ff ff ff       	jmp    5bc <printf+0xfc>
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 648:	b9 01 00 00 00       	mov    $0x1,%ecx
 64d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 650:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 654:	89 44 24 04          	mov    %eax,0x4(%esp)
 658:	89 3c 24             	mov    %edi,(%esp)
 65b:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 65e:	e8 25 fd ff ff       	call   388 <write>
      state = 0;
 663:	31 d2                	xor    %edx,%edx
 665:	e9 b1 fe ff ff       	jmp    51b <printf+0x5b>
 66a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, *ap);
 670:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 673:	8b 03                	mov    (%ebx),%eax
        ap++;
 675:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 678:	89 3c 24             	mov    %edi,(%esp)
        putc(fd, *ap);
 67b:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 67e:	b8 01 00 00 00       	mov    $0x1,%eax
 683:	89 44 24 08          	mov    %eax,0x8(%esp)
 687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 68a:	89 44 24 04          	mov    %eax,0x4(%esp)
 68e:	e8 f5 fc ff ff       	call   388 <write>
      state = 0;
 693:	31 d2                	xor    %edx,%edx
        ap++;
 695:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 698:	e9 7e fe ff ff       	jmp    51b <printf+0x5b>
          s = "(null)";
 69d:	bb 70 08 00 00       	mov    $0x870,%ebx
        while(*s != 0){
 6a2:	b0 28                	mov    $0x28,%al
 6a4:	e9 57 ff ff ff       	jmp    600 <printf+0x140>
 6a9:	66 90                	xchg   %ax,%ax
 6ab:	66 90                	xchg   %ax,%ax
 6ad:	66 90                	xchg   %ax,%ax
 6af:	90                   	nop

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b1:	a1 40 0b 00 00       	mov    0xb40,%eax
{
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	57                   	push   %edi
 6b9:	56                   	push   %esi
 6ba:	53                   	push   %ebx
 6bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 6c1:	eb 0d                	jmp    6d0 <free+0x20>
 6c3:	90                   	nop
 6c4:	90                   	nop
 6c5:	90                   	nop
 6c6:	90                   	nop
 6c7:	90                   	nop
 6c8:	90                   	nop
 6c9:	90                   	nop
 6ca:	90                   	nop
 6cb:	90                   	nop
 6cc:	90                   	nop
 6cd:	90                   	nop
 6ce:	90                   	nop
 6cf:	90                   	nop
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d0:	39 c8                	cmp    %ecx,%eax
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	73 32                	jae    708 <free+0x58>
 6d6:	39 d1                	cmp    %edx,%ecx
 6d8:	72 04                	jb     6de <free+0x2e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6da:	39 d0                	cmp    %edx,%eax
 6dc:	72 32                	jb     710 <free+0x60>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6de:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6e1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6e4:	39 fa                	cmp    %edi,%edx
 6e6:	74 30                	je     718 <free+0x68>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6e8:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6eb:	8b 50 04             	mov    0x4(%eax),%edx
 6ee:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6f1:	39 f1                	cmp    %esi,%ecx
 6f3:	74 3c                	je     731 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6f5:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 6f7:	5b                   	pop    %ebx
  freep = p;
 6f8:	a3 40 0b 00 00       	mov    %eax,0xb40
}
 6fd:	5e                   	pop    %esi
 6fe:	5f                   	pop    %edi
 6ff:	5d                   	pop    %ebp
 700:	c3                   	ret    
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	39 d0                	cmp    %edx,%eax
 70a:	72 04                	jb     710 <free+0x60>
 70c:	39 d1                	cmp    %edx,%ecx
 70e:	72 ce                	jb     6de <free+0x2e>
{
 710:	89 d0                	mov    %edx,%eax
 712:	eb bc                	jmp    6d0 <free+0x20>
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 718:	8b 7a 04             	mov    0x4(%edx),%edi
 71b:	01 fe                	add    %edi,%esi
 71d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 720:	8b 10                	mov    (%eax),%edx
 722:	8b 12                	mov    (%edx),%edx
 724:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 727:	8b 50 04             	mov    0x4(%eax),%edx
 72a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 72d:	39 f1                	cmp    %esi,%ecx
 72f:	75 c4                	jne    6f5 <free+0x45>
    p->s.size += bp->s.size;
 731:	8b 4b fc             	mov    -0x4(%ebx),%ecx
  freep = p;
 734:	a3 40 0b 00 00       	mov    %eax,0xb40
    p->s.size += bp->s.size;
 739:	01 ca                	add    %ecx,%edx
 73b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 73e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 741:	89 10                	mov    %edx,(%eax)
}
 743:	5b                   	pop    %ebx
 744:	5e                   	pop    %esi
 745:	5f                   	pop    %edi
 746:	5d                   	pop    %ebp
 747:	c3                   	ret    
 748:	90                   	nop
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000750 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 759:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 75c:	8b 15 40 0b 00 00    	mov    0xb40,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	8d 78 07             	lea    0x7(%eax),%edi
 765:	c1 ef 03             	shr    $0x3,%edi
 768:	47                   	inc    %edi
  if((prevp = freep) == 0){
 769:	85 d2                	test   %edx,%edx
 76b:	0f 84 8f 00 00 00    	je     800 <malloc+0xb0>
 771:	8b 02                	mov    (%edx),%eax
 773:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 776:	39 cf                	cmp    %ecx,%edi
 778:	76 66                	jbe    7e0 <malloc+0x90>
 77a:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 780:	bb 00 10 00 00       	mov    $0x1000,%ebx
 785:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 788:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 78f:	eb 10                	jmp    7a1 <malloc+0x51>
 791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 79a:	8b 48 04             	mov    0x4(%eax),%ecx
 79d:	39 f9                	cmp    %edi,%ecx
 79f:	73 3f                	jae    7e0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a1:	39 05 40 0b 00 00    	cmp    %eax,0xb40
 7a7:	89 c2                	mov    %eax,%edx
 7a9:	75 ed                	jne    798 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 7ab:	89 34 24             	mov    %esi,(%esp)
 7ae:	e8 3d fc ff ff       	call   3f0 <sbrk>
  if(p == (char*)-1)
 7b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7b6:	74 18                	je     7d0 <malloc+0x80>
  hp->s.size = nu;
 7b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7bb:	83 c0 08             	add    $0x8,%eax
 7be:	89 04 24             	mov    %eax,(%esp)
 7c1:	e8 ea fe ff ff       	call   6b0 <free>
  return freep;
 7c6:	8b 15 40 0b 00 00    	mov    0xb40,%edx
      if((p = morecore(nunits)) == 0)
 7cc:	85 d2                	test   %edx,%edx
 7ce:	75 c8                	jne    798 <malloc+0x48>
        return 0;
  }
}
 7d0:	83 c4 1c             	add    $0x1c,%esp
        return 0;
 7d3:	31 c0                	xor    %eax,%eax
}
 7d5:	5b                   	pop    %ebx
 7d6:	5e                   	pop    %esi
 7d7:	5f                   	pop    %edi
 7d8:	5d                   	pop    %ebp
 7d9:	c3                   	ret    
 7da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7e0:	39 cf                	cmp    %ecx,%edi
 7e2:	74 4c                	je     830 <malloc+0xe0>
        p->s.size -= nunits;
 7e4:	29 f9                	sub    %edi,%ecx
 7e6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7ec:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7ef:	89 15 40 0b 00 00    	mov    %edx,0xb40
}
 7f5:	83 c4 1c             	add    $0x1c,%esp
      return (void*)(p + 1);
 7f8:	83 c0 08             	add    $0x8,%eax
}
 7fb:	5b                   	pop    %ebx
 7fc:	5e                   	pop    %esi
 7fd:	5f                   	pop    %edi
 7fe:	5d                   	pop    %ebp
 7ff:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 800:	b8 44 0b 00 00       	mov    $0xb44,%eax
 805:	ba 44 0b 00 00       	mov    $0xb44,%edx
    base.s.size = 0;
 80a:	31 c9                	xor    %ecx,%ecx
    base.s.ptr = freep = prevp = &base;
 80c:	a3 40 0b 00 00       	mov    %eax,0xb40
    base.s.size = 0;
 811:	b8 44 0b 00 00       	mov    $0xb44,%eax
    base.s.ptr = freep = prevp = &base;
 816:	89 15 44 0b 00 00    	mov    %edx,0xb44
    base.s.size = 0;
 81c:	89 0d 48 0b 00 00    	mov    %ecx,0xb48
 822:	e9 53 ff ff ff       	jmp    77a <malloc+0x2a>
 827:	89 f6                	mov    %esi,%esi
 829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        prevp->s.ptr = p->s.ptr;
 830:	8b 08                	mov    (%eax),%ecx
 832:	89 0a                	mov    %ecx,(%edx)
 834:	eb b9                	jmp    7ef <malloc+0x9f>
