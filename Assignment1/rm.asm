
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

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
   c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  if(argc < 2){
   f:	83 ff 01             	cmp    $0x1,%edi
  12:	7e 4a                	jle    5e <main+0x5e>
  14:	8b 45 0c             	mov    0xc(%ebp),%eax
    printf(2, "Usage: rm files...\n");
    exit(0);
  }

  for(i = 1; i < argc; i++){
  17:	be 01 00 00 00       	mov    $0x1,%esi
  1c:	8d 58 04             	lea    0x4(%eax),%ebx
  1f:	90                   	nop
    if(unlink(argv[i]) < 0){
  20:	8b 03                	mov    (%ebx),%eax
  22:	89 04 24             	mov    %eax,(%esp)
  25:	e8 ce 02 00 00       	call   2f8 <unlink>
  2a:	85 c0                	test   %eax,%eax
  2c:	78 14                	js     42 <main+0x42>
  for(i = 1; i < argc; i++){
  2e:	46                   	inc    %esi
  2f:	83 c3 04             	add    $0x4,%ebx
  32:	39 f7                	cmp    %esi,%edi
  34:	75 ea                	jne    20 <main+0x20>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3d:	e8 66 02 00 00       	call   2a8 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  42:	8b 03                	mov    (%ebx),%eax
  44:	c7 44 24 04 8c 07 00 	movl   $0x78c,0x4(%esp)
  4b:	00 
  4c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	e8 a4 03 00 00       	call   400 <printf>
      break;
  5c:	eb d8                	jmp    36 <main+0x36>
    printf(2, "Usage: rm files...\n");
  5e:	c7 44 24 04 78 07 00 	movl   $0x778,0x4(%esp)
  65:	00 
  66:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6d:	e8 8e 03 00 00       	call   400 <printf>
    exit(0);
  72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  79:	e8 2a 02 00 00       	call   2a8 <exit>
  7e:	66 90                	xchg   %ax,%ax

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	8b 45 08             	mov    0x8(%ebp),%eax
  86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  89:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	89 c2                	mov    %eax,%edx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  90:	41                   	inc    %ecx
  91:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  95:	42                   	inc    %edx
  96:	84 db                	test   %bl,%bl
  98:	88 5a ff             	mov    %bl,-0x1(%edx)
  9b:	75 f3                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9d:	5b                   	pop    %ebx
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a6:	53                   	push   %ebx
  a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  aa:	0f b6 01             	movzbl (%ecx),%eax
  ad:	0f b6 13             	movzbl (%ebx),%edx
  b0:	84 c0                	test   %al,%al
  b2:	75 18                	jne    cc <strcmp+0x2c>
  b4:	eb 22                	jmp    d8 <strcmp+0x38>
  b6:	8d 76 00             	lea    0x0(%esi),%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  c0:	41                   	inc    %ecx
  while(*p && *p == *q)
  c1:	0f b6 01             	movzbl (%ecx),%eax
    p++, q++;
  c4:	43                   	inc    %ebx
  c5:	0f b6 13             	movzbl (%ebx),%edx
  while(*p && *p == *q)
  c8:	84 c0                	test   %al,%al
  ca:	74 0c                	je     d8 <strcmp+0x38>
  cc:	38 d0                	cmp    %dl,%al
  ce:	74 f0                	je     c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
  d0:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
  d1:	29 d0                	sub    %edx,%eax
}
  d3:	5d                   	pop    %ebp
  d4:	c3                   	ret    
  d5:	8d 76 00             	lea    0x0(%esi),%esi
  d8:	5b                   	pop    %ebx
  d9:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  db:	29 d0                	sub    %edx,%eax
}
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    
  df:	90                   	nop

000000e0 <strlen>:

uint
strlen(const char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  e6:	80 39 00             	cmpb   $0x0,(%ecx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 d2                	xor    %edx,%edx
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	42                   	inc    %edx
  f1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f5:	89 d0                	mov    %edx,%eax
  f7:	75 f7                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    
  fb:	90                   	nop
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(n = 0; s[n]; n++)
 100:	31 c0                	xor    %eax,%eax
}
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
 116:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 d7                	mov    %edx,%edi
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 122:	5f                   	pop    %edi
 123:	89 d0                	mov    %edx,%eax
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 13a:	0f b6 10             	movzbl (%eax),%edx
 13d:	84 d2                	test   %dl,%dl
 13f:	74 1b                	je     15c <strchr+0x2c>
    if(*s == c)
 141:	38 d1                	cmp    %dl,%cl
 143:	75 0f                	jne    154 <strchr+0x24>
 145:	eb 17                	jmp    15e <strchr+0x2e>
 147:	89 f6                	mov    %esi,%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 150:	38 ca                	cmp    %cl,%dl
 152:	74 0a                	je     15e <strchr+0x2e>
  for(; *s; s++)
 154:	40                   	inc    %eax
 155:	0f b6 10             	movzbl (%eax),%edx
 158:	84 d2                	test   %dl,%dl
 15a:	75 f4                	jne    150 <strchr+0x20>
      return (char*)s;
  return 0;
 15c:	31 c0                	xor    %eax,%eax
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 165:	31 f6                	xor    %esi,%esi
{
 167:	53                   	push   %ebx
 168:	83 ec 3c             	sub    $0x3c,%esp
 16b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cc = read(0, &c, 1);
 16e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 171:	eb 32                	jmp    1a5 <gets+0x45>
 173:	90                   	nop
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cc = read(0, &c, 1);
 178:	ba 01 00 00 00       	mov    $0x1,%edx
 17d:	89 54 24 08          	mov    %edx,0x8(%esp)
 181:	89 7c 24 04          	mov    %edi,0x4(%esp)
 185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 18c:	e8 2f 01 00 00       	call   2c0 <read>
    if(cc < 1)
 191:	85 c0                	test   %eax,%eax
 193:	7e 19                	jle    1ae <gets+0x4e>
      break;
    buf[i++] = c;
 195:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 199:	43                   	inc    %ebx
 19a:	88 43 ff             	mov    %al,-0x1(%ebx)
    if(c == '\n' || c == '\r')
 19d:	3c 0a                	cmp    $0xa,%al
 19f:	74 1f                	je     1c0 <gets+0x60>
 1a1:	3c 0d                	cmp    $0xd,%al
 1a3:	74 1b                	je     1c0 <gets+0x60>
  for(i=0; i+1 < max; ){
 1a5:	46                   	inc    %esi
 1a6:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1a9:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1ac:	7c ca                	jl     178 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 1ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1b1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	83 c4 3c             	add    $0x3c,%esp
 1ba:	5b                   	pop    %ebx
 1bb:	5e                   	pop    %esi
 1bc:	5f                   	pop    %edi
 1bd:	5d                   	pop    %ebp
 1be:	c3                   	ret    
 1bf:	90                   	nop
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	01 c6                	add    %eax,%esi
 1c5:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 1c8:	eb e4                	jmp    1ae <gets+0x4e>
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d1:	31 c0                	xor    %eax,%eax
{
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 1d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
{
 1df:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1e2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 fb 00 00 00       	call   2e8 <open>
  if(fd < 0)
 1ed:	85 c0                	test   %eax,%eax
 1ef:	78 2f                	js     220 <stat+0x50>
 1f1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f6:	89 1c 24             	mov    %ebx,(%esp)
 1f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fd:	e8 fe 00 00 00       	call   300 <fstat>
  close(fd);
 202:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 205:	89 c6                	mov    %eax,%esi
  close(fd);
 207:	e8 c4 00 00 00       	call   2d0 <close>
  return r;
}
 20c:	89 f0                	mov    %esi,%eax
 20e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 211:	8b 75 fc             	mov    -0x4(%ebp),%esi
 214:	89 ec                	mov    %ebp,%esp
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
 218:	90                   	nop
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 220:	be ff ff ff ff       	mov    $0xffffffff,%esi
 225:	eb e5                	jmp    20c <stat+0x3c>
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <atoi>:

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 4d 08             	mov    0x8(%ebp),%ecx
 236:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 237:	0f be 11             	movsbl (%ecx),%edx
 23a:	88 d0                	mov    %dl,%al
 23c:	2c 30                	sub    $0x30,%al
 23e:	3c 09                	cmp    $0x9,%al
  n = 0;
 240:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 245:	77 1e                	ja     265 <atoi+0x35>
 247:	89 f6                	mov    %esi,%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 250:	41                   	inc    %ecx
 251:	8d 04 80             	lea    (%eax,%eax,4),%eax
 254:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 258:	0f be 11             	movsbl (%ecx),%edx
 25b:	88 d3                	mov    %dl,%bl
 25d:	80 eb 30             	sub    $0x30,%bl
 260:	80 fb 09             	cmp    $0x9,%bl
 263:	76 eb                	jbe    250 <atoi+0x20>
  return n;
}
 265:	5b                   	pop    %ebx
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
 268:	90                   	nop
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000270 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	53                   	push   %ebx
 278:	8b 5d 10             	mov    0x10(%ebp),%ebx
 27b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 db                	test   %ebx,%ebx
 280:	7e 1a                	jle    29c <memmove+0x2c>
 282:	31 d2                	xor    %edx,%edx
 284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 28a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    *dst++ = *src++;
 290:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 294:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 297:	42                   	inc    %edx
  while(n-- > 0)
 298:	39 d3                	cmp    %edx,%ebx
 29a:	75 f4                	jne    290 <memmove+0x20>
  return vdst;
}
 29c:	5b                   	pop    %ebx
 29d:	5e                   	pop    %esi
 29e:	5d                   	pop    %ebp
 29f:	c3                   	ret    

000002a0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a0:	b8 01 00 00 00       	mov    $0x1,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <exit>:
SYSCALL(exit)
 2a8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <wait>:
SYSCALL(wait)
 2b0:	b8 03 00 00 00       	mov    $0x3,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <pipe>:
SYSCALL(pipe)
 2b8:	b8 04 00 00 00       	mov    $0x4,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <read>:
SYSCALL(read)
 2c0:	b8 05 00 00 00       	mov    $0x5,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <write>:
SYSCALL(write)
 2c8:	b8 10 00 00 00       	mov    $0x10,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <close>:
SYSCALL(close)
 2d0:	b8 15 00 00 00       	mov    $0x15,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <kill>:
SYSCALL(kill)
 2d8:	b8 06 00 00 00       	mov    $0x6,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exec>:
SYSCALL(exec)
 2e0:	b8 07 00 00 00       	mov    $0x7,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <open>:
SYSCALL(open)
 2e8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <mknod>:
SYSCALL(mknod)
 2f0:	b8 11 00 00 00       	mov    $0x11,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <unlink>:
SYSCALL(unlink)
 2f8:	b8 12 00 00 00       	mov    $0x12,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <fstat>:
SYSCALL(fstat)
 300:	b8 08 00 00 00       	mov    $0x8,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <link>:
SYSCALL(link)
 308:	b8 13 00 00 00       	mov    $0x13,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mkdir>:
SYSCALL(mkdir)
 310:	b8 14 00 00 00       	mov    $0x14,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <chdir>:
SYSCALL(chdir)
 318:	b8 09 00 00 00       	mov    $0x9,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <dup>:
SYSCALL(dup)
 320:	b8 0a 00 00 00       	mov    $0xa,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <getpid>:
SYSCALL(getpid)
 328:	b8 0b 00 00 00       	mov    $0xb,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <sbrk>:
SYSCALL(sbrk)
 330:	b8 0c 00 00 00       	mov    $0xc,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <sleep>:
SYSCALL(sleep)
 338:	b8 0d 00 00 00       	mov    $0xd,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <uptime>:
SYSCALL(uptime)
 340:	b8 0e 00 00 00       	mov    $0xe,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <detach>:
SYSCALL(detach)
 348:	b8 16 00 00 00       	mov    $0x16,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <policy>:
SYSCALL(policy)
 350:	b8 17 00 00 00       	mov    $0x17,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <priority>:
 358:	b8 18 00 00 00       	mov    $0x18,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 366:	89 d3                	mov    %edx,%ebx
 368:	c1 eb 1f             	shr    $0x1f,%ebx
{
 36b:	83 ec 4c             	sub    $0x4c,%esp
  if(sgn && xx < 0){
 36e:	84 db                	test   %bl,%bl
{
 370:	89 45 c0             	mov    %eax,-0x40(%ebp)
 373:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 375:	74 79                	je     3f0 <printint+0x90>
 377:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 37b:	74 73                	je     3f0 <printint+0x90>
    neg = 1;
    x = -xx;
 37d:	f7 d8                	neg    %eax
    neg = 1;
 37f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 386:	31 f6                	xor    %esi,%esi
 388:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 38b:	eb 05                	jmp    392 <printint+0x32>
 38d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 390:	89 fe                	mov    %edi,%esi
 392:	31 d2                	xor    %edx,%edx
 394:	f7 f1                	div    %ecx
 396:	8d 7e 01             	lea    0x1(%esi),%edi
 399:	0f b6 92 ac 07 00 00 	movzbl 0x7ac(%edx),%edx
  }while((x /= base) != 0);
 3a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3a2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 3a5:	75 e9                	jne    390 <printint+0x30>
  if(neg)
 3a7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 3aa:	85 d2                	test   %edx,%edx
 3ac:	74 08                	je     3b6 <printint+0x56>
    buf[i++] = '-';
 3ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 3b3:	8d 7e 02             	lea    0x2(%esi),%edi
 3b6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 3ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	0f b6 06             	movzbl (%esi),%eax
 3c3:	4e                   	dec    %esi
  write(fd, &c, 1);
 3c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 3c8:	89 3c 24             	mov    %edi,(%esp)
 3cb:	88 45 d7             	mov    %al,-0x29(%ebp)
 3ce:	b8 01 00 00 00       	mov    $0x1,%eax
 3d3:	89 44 24 08          	mov    %eax,0x8(%esp)
 3d7:	e8 ec fe ff ff       	call   2c8 <write>

  while(--i >= 0)
 3dc:	39 de                	cmp    %ebx,%esi
 3de:	75 e0                	jne    3c0 <printint+0x60>
    putc(fd, buf[i]);
}
 3e0:	83 c4 4c             	add    $0x4c,%esp
 3e3:	5b                   	pop    %ebx
 3e4:	5e                   	pop    %esi
 3e5:	5f                   	pop    %edi
 3e6:	5d                   	pop    %ebp
 3e7:	c3                   	ret    
 3e8:	90                   	nop
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3f0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3f7:	eb 8d                	jmp    386 <printint+0x26>
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000400 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 409:	8b 75 0c             	mov    0xc(%ebp),%esi
 40c:	0f b6 1e             	movzbl (%esi),%ebx
 40f:	84 db                	test   %bl,%bl
 411:	0f 84 d1 00 00 00    	je     4e8 <printf+0xe8>
  state = 0;
 417:	31 ff                	xor    %edi,%edi
 419:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 41a:	8d 45 10             	lea    0x10(%ebp),%eax
  write(fd, &c, 1);
 41d:	89 fa                	mov    %edi,%edx
 41f:	8b 7d 08             	mov    0x8(%ebp),%edi
  ap = (uint*)(void*)&fmt + 1;
 422:	89 45 d0             	mov    %eax,-0x30(%ebp)
 425:	eb 41                	jmp    468 <printf+0x68>
 427:	89 f6                	mov    %esi,%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 430:	83 f8 25             	cmp    $0x25,%eax
 433:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 436:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 43b:	74 1e                	je     45b <printf+0x5b>
  write(fd, &c, 1);
 43d:	b8 01 00 00 00       	mov    $0x1,%eax
 442:	89 44 24 08          	mov    %eax,0x8(%esp)
 446:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 449:	89 44 24 04          	mov    %eax,0x4(%esp)
 44d:	89 3c 24             	mov    %edi,(%esp)
 450:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 453:	e8 70 fe ff ff       	call   2c8 <write>
 458:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 45b:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 45c:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 460:	84 db                	test   %bl,%bl
 462:	0f 84 80 00 00 00    	je     4e8 <printf+0xe8>
    if(state == 0){
 468:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 46a:	0f be cb             	movsbl %bl,%ecx
 46d:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 470:	74 be                	je     430 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 472:	83 fa 25             	cmp    $0x25,%edx
 475:	75 e4                	jne    45b <printf+0x5b>
      if(c == 'd'){
 477:	83 f8 64             	cmp    $0x64,%eax
 47a:	0f 84 f0 00 00 00    	je     570 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 480:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 486:	83 f9 70             	cmp    $0x70,%ecx
 489:	74 65                	je     4f0 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 48b:	83 f8 73             	cmp    $0x73,%eax
 48e:	0f 84 8c 00 00 00    	je     520 <printf+0x120>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 494:	83 f8 63             	cmp    $0x63,%eax
 497:	0f 84 13 01 00 00    	je     5b0 <printf+0x1b0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 49d:	83 f8 25             	cmp    $0x25,%eax
 4a0:	0f 84 e2 00 00 00    	je     588 <printf+0x188>
  write(fd, &c, 1);
 4a6:	b8 01 00 00 00       	mov    $0x1,%eax
 4ab:	46                   	inc    %esi
 4ac:	89 44 24 08          	mov    %eax,0x8(%esp)
 4b0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b7:	89 3c 24             	mov    %edi,(%esp)
 4ba:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4be:	e8 05 fe ff ff       	call   2c8 <write>
 4c3:	ba 01 00 00 00       	mov    $0x1,%edx
 4c8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4cb:	89 54 24 08          	mov    %edx,0x8(%esp)
 4cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d3:	89 3c 24             	mov    %edi,(%esp)
 4d6:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4d9:	e8 ea fd ff ff       	call   2c8 <write>
  for(i = 0; fmt[i]; i++){
 4de:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e2:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4e4:	84 db                	test   %bl,%bl
 4e6:	75 80                	jne    468 <printf+0x68>
    }
  }
}
 4e8:	83 c4 3c             	add    $0x3c,%esp
 4eb:	5b                   	pop    %ebx
 4ec:	5e                   	pop    %esi
 4ed:	5f                   	pop    %edi
 4ee:	5d                   	pop    %ebp
 4ef:	c3                   	ret    
        printint(fd, *ap, 16, 0);
 4f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4f7:	b9 10 00 00 00       	mov    $0x10,%ecx
 4fc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4ff:	89 f8                	mov    %edi,%eax
 501:	8b 13                	mov    (%ebx),%edx
 503:	e8 58 fe ff ff       	call   360 <printint>
        ap++;
 508:	89 d8                	mov    %ebx,%eax
      state = 0;
 50a:	31 d2                	xor    %edx,%edx
        ap++;
 50c:	83 c0 04             	add    $0x4,%eax
 50f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 512:	e9 44 ff ff ff       	jmp    45b <printf+0x5b>
 517:	89 f6                	mov    %esi,%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        s = (char*)*ap;
 520:	8b 45 d0             	mov    -0x30(%ebp),%eax
 523:	8b 10                	mov    (%eax),%edx
        ap++;
 525:	83 c0 04             	add    $0x4,%eax
 528:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 52b:	85 d2                	test   %edx,%edx
 52d:	0f 84 aa 00 00 00    	je     5dd <printf+0x1dd>
        while(*s != 0){
 533:	0f b6 02             	movzbl (%edx),%eax
        s = (char*)*ap;
 536:	89 d3                	mov    %edx,%ebx
        while(*s != 0){
 538:	84 c0                	test   %al,%al
 53a:	74 27                	je     563 <printf+0x163>
 53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 540:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 543:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 548:	43                   	inc    %ebx
  write(fd, &c, 1);
 549:	89 44 24 08          	mov    %eax,0x8(%esp)
 54d:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 550:	89 44 24 04          	mov    %eax,0x4(%esp)
 554:	89 3c 24             	mov    %edi,(%esp)
 557:	e8 6c fd ff ff       	call   2c8 <write>
        while(*s != 0){
 55c:	0f b6 03             	movzbl (%ebx),%eax
 55f:	84 c0                	test   %al,%al
 561:	75 dd                	jne    540 <printf+0x140>
      state = 0;
 563:	31 d2                	xor    %edx,%edx
 565:	e9 f1 fe ff ff       	jmp    45b <printf+0x5b>
 56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 570:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 577:	b9 0a 00 00 00       	mov    $0xa,%ecx
 57c:	e9 7b ff ff ff       	jmp    4fc <printf+0xfc>
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 588:	b9 01 00 00 00       	mov    $0x1,%ecx
 58d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 590:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 594:	89 44 24 04          	mov    %eax,0x4(%esp)
 598:	89 3c 24             	mov    %edi,(%esp)
 59b:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 59e:	e8 25 fd ff ff       	call   2c8 <write>
      state = 0;
 5a3:	31 d2                	xor    %edx,%edx
 5a5:	e9 b1 fe ff ff       	jmp    45b <printf+0x5b>
 5aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, *ap);
 5b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5b3:	8b 03                	mov    (%ebx),%eax
        ap++;
 5b5:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 5b8:	89 3c 24             	mov    %edi,(%esp)
        putc(fd, *ap);
 5bb:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5be:	b8 01 00 00 00       	mov    $0x1,%eax
 5c3:	89 44 24 08          	mov    %eax,0x8(%esp)
 5c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ce:	e8 f5 fc ff ff       	call   2c8 <write>
      state = 0;
 5d3:	31 d2                	xor    %edx,%edx
        ap++;
 5d5:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5d8:	e9 7e fe ff ff       	jmp    45b <printf+0x5b>
          s = "(null)";
 5dd:	bb a5 07 00 00       	mov    $0x7a5,%ebx
        while(*s != 0){
 5e2:	b0 28                	mov    $0x28,%al
 5e4:	e9 57 ff ff ff       	jmp    540 <printf+0x140>
 5e9:	66 90                	xchg   %ax,%ax
 5eb:	66 90                	xchg   %ax,%ax
 5ed:	66 90                	xchg   %ax,%ax
 5ef:	90                   	nop

000005f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	a1 3c 0a 00 00       	mov    0xa3c,%eax
{
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	53                   	push   %ebx
 5fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 601:	eb 0d                	jmp    610 <free+0x20>
 603:	90                   	nop
 604:	90                   	nop
 605:	90                   	nop
 606:	90                   	nop
 607:	90                   	nop
 608:	90                   	nop
 609:	90                   	nop
 60a:	90                   	nop
 60b:	90                   	nop
 60c:	90                   	nop
 60d:	90                   	nop
 60e:	90                   	nop
 60f:	90                   	nop
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 610:	39 c8                	cmp    %ecx,%eax
 612:	8b 10                	mov    (%eax),%edx
 614:	73 32                	jae    648 <free+0x58>
 616:	39 d1                	cmp    %edx,%ecx
 618:	72 04                	jb     61e <free+0x2e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61a:	39 d0                	cmp    %edx,%eax
 61c:	72 32                	jb     650 <free+0x60>
      break;
  if(bp + bp->s.size == p->s.ptr){
 61e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 621:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 624:	39 fa                	cmp    %edi,%edx
 626:	74 30                	je     658 <free+0x68>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 628:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 62b:	8b 50 04             	mov    0x4(%eax),%edx
 62e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 631:	39 f1                	cmp    %esi,%ecx
 633:	74 3c                	je     671 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 635:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 637:	5b                   	pop    %ebx
  freep = p;
 638:	a3 3c 0a 00 00       	mov    %eax,0xa3c
}
 63d:	5e                   	pop    %esi
 63e:	5f                   	pop    %edi
 63f:	5d                   	pop    %ebp
 640:	c3                   	ret    
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 648:	39 d0                	cmp    %edx,%eax
 64a:	72 04                	jb     650 <free+0x60>
 64c:	39 d1                	cmp    %edx,%ecx
 64e:	72 ce                	jb     61e <free+0x2e>
{
 650:	89 d0                	mov    %edx,%eax
 652:	eb bc                	jmp    610 <free+0x20>
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 658:	8b 7a 04             	mov    0x4(%edx),%edi
 65b:	01 fe                	add    %edi,%esi
 65d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 660:	8b 10                	mov    (%eax),%edx
 662:	8b 12                	mov    (%edx),%edx
 664:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 667:	8b 50 04             	mov    0x4(%eax),%edx
 66a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 66d:	39 f1                	cmp    %esi,%ecx
 66f:	75 c4                	jne    635 <free+0x45>
    p->s.size += bp->s.size;
 671:	8b 4b fc             	mov    -0x4(%ebx),%ecx
  freep = p;
 674:	a3 3c 0a 00 00       	mov    %eax,0xa3c
    p->s.size += bp->s.size;
 679:	01 ca                	add    %ecx,%edx
 67b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 67e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 681:	89 10                	mov    %edx,(%eax)
}
 683:	5b                   	pop    %ebx
 684:	5e                   	pop    %esi
 685:	5f                   	pop    %edi
 686:	5d                   	pop    %ebp
 687:	c3                   	ret    
 688:	90                   	nop
 689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 15 3c 0a 00 00    	mov    0xa3c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	8d 78 07             	lea    0x7(%eax),%edi
 6a5:	c1 ef 03             	shr    $0x3,%edi
 6a8:	47                   	inc    %edi
  if((prevp = freep) == 0){
 6a9:	85 d2                	test   %edx,%edx
 6ab:	0f 84 8f 00 00 00    	je     740 <malloc+0xb0>
 6b1:	8b 02                	mov    (%edx),%eax
 6b3:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6b6:	39 cf                	cmp    %ecx,%edi
 6b8:	76 66                	jbe    720 <malloc+0x90>
 6ba:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6c0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c5:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6c8:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6cf:	eb 10                	jmp    6e1 <malloc+0x51>
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6da:	8b 48 04             	mov    0x4(%eax),%ecx
 6dd:	39 f9                	cmp    %edi,%ecx
 6df:	73 3f                	jae    720 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e1:	39 05 3c 0a 00 00    	cmp    %eax,0xa3c
 6e7:	89 c2                	mov    %eax,%edx
 6e9:	75 ed                	jne    6d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6eb:	89 34 24             	mov    %esi,(%esp)
 6ee:	e8 3d fc ff ff       	call   330 <sbrk>
  if(p == (char*)-1)
 6f3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f6:	74 18                	je     710 <malloc+0x80>
  hp->s.size = nu;
 6f8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6fb:	83 c0 08             	add    $0x8,%eax
 6fe:	89 04 24             	mov    %eax,(%esp)
 701:	e8 ea fe ff ff       	call   5f0 <free>
  return freep;
 706:	8b 15 3c 0a 00 00    	mov    0xa3c,%edx
      if((p = morecore(nunits)) == 0)
 70c:	85 d2                	test   %edx,%edx
 70e:	75 c8                	jne    6d8 <malloc+0x48>
        return 0;
  }
}
 710:	83 c4 1c             	add    $0x1c,%esp
        return 0;
 713:	31 c0                	xor    %eax,%eax
}
 715:	5b                   	pop    %ebx
 716:	5e                   	pop    %esi
 717:	5f                   	pop    %edi
 718:	5d                   	pop    %ebp
 719:	c3                   	ret    
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 720:	39 cf                	cmp    %ecx,%edi
 722:	74 4c                	je     770 <malloc+0xe0>
        p->s.size -= nunits;
 724:	29 f9                	sub    %edi,%ecx
 726:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 729:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 72c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 72f:	89 15 3c 0a 00 00    	mov    %edx,0xa3c
}
 735:	83 c4 1c             	add    $0x1c,%esp
      return (void*)(p + 1);
 738:	83 c0 08             	add    $0x8,%eax
}
 73b:	5b                   	pop    %ebx
 73c:	5e                   	pop    %esi
 73d:	5f                   	pop    %edi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 740:	b8 40 0a 00 00       	mov    $0xa40,%eax
 745:	ba 40 0a 00 00       	mov    $0xa40,%edx
    base.s.size = 0;
 74a:	31 c9                	xor    %ecx,%ecx
    base.s.ptr = freep = prevp = &base;
 74c:	a3 3c 0a 00 00       	mov    %eax,0xa3c
    base.s.size = 0;
 751:	b8 40 0a 00 00       	mov    $0xa40,%eax
    base.s.ptr = freep = prevp = &base;
 756:	89 15 40 0a 00 00    	mov    %edx,0xa40
    base.s.size = 0;
 75c:	89 0d 44 0a 00 00    	mov    %ecx,0xa44
 762:	e9 53 ff ff ff       	jmp    6ba <malloc+0x2a>
 767:	89 f6                	mov    %esi,%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        prevp->s.ptr = p->s.ptr;
 770:	8b 08                	mov    (%eax),%ecx
 772:	89 0a                	mov    %ecx,(%edx)
 774:	eb b9                	jmp    72f <malloc+0x9f>
