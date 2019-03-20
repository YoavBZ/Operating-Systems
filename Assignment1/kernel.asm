
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3

  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 20 d6 10 80       	mov    $0x8010d620,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80100041:	ba 00 85 10 80       	mov    $0x80108500,%edx
{
80100046:	89 e5                	mov    %esp,%ebp
80100048:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100049:	bb 1c 1d 11 80       	mov    $0x80111d1c,%ebx
{
8010004e:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
80100051:	89 54 24 04          	mov    %edx,0x4(%esp)
80100055:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
8010005c:	e8 af 56 00 00       	call   80105710 <initlock>
  bcache.head.prev = &bcache.head;
80100061:	b9 1c 1d 11 80       	mov    $0x80111d1c,%ecx
  bcache.head.next = &bcache.head;
80100066:	ba 1c 1d 11 80       	mov    $0x80111d1c,%edx
8010006b:	89 1d 70 1d 11 80    	mov    %ebx,0x80111d70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100071:	bb 54 d6 10 80       	mov    $0x8010d654,%ebx
  bcache.head.prev = &bcache.head;
80100076:	89 0d 6c 1d 11 80    	mov    %ecx,0x80111d6c
8010007c:	eb 04                	jmp    80100082 <binit+0x42>
8010007e:	66 90                	xchg   %ax,%ax
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	b8 07 85 10 80       	mov    $0x80108507,%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 1c 1d 11 80 	movl   $0x80111d1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 44 24 04          	mov    %eax,0x4(%esp)
80100095:	8d 43 0c             	lea    0xc(%ebx),%eax
80100098:	89 04 24             	mov    %eax,(%esp)
8010009b:	e8 40 55 00 00       	call   801055e0 <initsleeplock>
    bcache.head.next->prev = b;
801000a0:	a1 70 1d 11 80       	mov    0x80111d70,%eax
801000a5:	89 da                	mov    %ebx,%edx
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000b0:	3d 1c 1d 11 80       	cmp    $0x80111d1c,%eax
    bcache.head.next = b;
801000b5:	89 1d 70 1d 11 80    	mov    %ebx,0x80111d70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	83 c4 14             	add    $0x14,%esp
801000c0:	5b                   	pop    %ebx
801000c1:	5d                   	pop    %ebp
801000c2:	c3                   	ret    
801000c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&bcache.lock);
801000d9:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
{
801000e0:	8b 75 08             	mov    0x8(%ebp),%esi
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 75 57 00 00       	call   80105860 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 70 1d 11 80    	mov    0x80111d70,%ebx
801000f1:	81 fb 1c 1d 11 80    	cmp    $0x80111d1c,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 1d 11 80    	cmp    $0x80111d1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	ff 43 4c             	incl   0x4c(%ebx)
80100118:	eb 40                	jmp    8010015a <bread+0x8a>
8010011a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 1d 11 80    	mov    0x80111d6c,%ebx
80100126:	81 fb 1c 1d 11 80    	cmp    $0x80111d1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 1d 11 80    	cmp    $0x80111d1c,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
80100161:	e8 9a 57 00 00       	call   80105900 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 af 54 00 00       	call   80105620 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 32 21 00 00       	call   801022b0 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 0e 85 10 80 	movl   $0x8010850e,(%esp)
8010018f:	e8 dc 01 00 00       	call   80100370 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 0b 55 00 00       	call   801056c0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 e7 20 00 00       	jmp    801022b0 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 1f 85 10 80 	movl   $0x8010851f,(%esp)
801001d0:	e8 9b 01 00 00       	call   80100370 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 ca 54 00 00       	call   801056c0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5a                	je     80100254 <brelse+0x74>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 7e 54 00 00       	call   80105680 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
80100209:	e8 52 56 00 00       	call   80105860 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	ff 4b 4c             	decl   0x4c(%ebx)
80100211:	75 2f                	jne    80100242 <brelse+0x62>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100213:	8b 43 54             	mov    0x54(%ebx),%eax
80100216:	8b 53 50             	mov    0x50(%ebx),%edx
80100219:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021c:	8b 43 50             	mov    0x50(%ebx),%eax
8010021f:	8b 53 54             	mov    0x54(%ebx),%edx
80100222:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100225:	a1 70 1d 11 80       	mov    0x80111d70,%eax
    b->prev = &bcache.head;
8010022a:	c7 43 50 1c 1d 11 80 	movl   $0x80111d1c,0x50(%ebx)
    b->next = bcache.head.next;
80100231:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100234:	a1 70 1d 11 80       	mov    0x80111d70,%eax
80100239:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023c:	89 1d 70 1d 11 80    	mov    %ebx,0x80111d70
  }
  
  release(&bcache.lock);
80100242:	c7 45 08 20 d6 10 80 	movl   $0x8010d620,0x8(%ebp)
}
80100249:	83 c4 10             	add    $0x10,%esp
8010024c:	5b                   	pop    %ebx
8010024d:	5e                   	pop    %esi
8010024e:	5d                   	pop    %ebp
  release(&bcache.lock);
8010024f:	e9 ac 56 00 00       	jmp    80105900 <release>
    panic("brelse");
80100254:	c7 04 24 26 85 10 80 	movl   $0x80108526,(%esp)
8010025b:	e8 10 01 00 00       	call   80100370 <panic>

80100260 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100260:	55                   	push   %ebp
80100261:	89 e5                	mov    %esp,%ebp
80100263:	57                   	push   %edi
80100264:	56                   	push   %esi
80100265:	53                   	push   %ebx
80100266:	83 ec 2c             	sub    $0x2c,%esp
80100269:	8b 7d 08             	mov    0x8(%ebp),%edi
8010026c:	8b 75 10             	mov    0x10(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010026f:	89 3c 24             	mov    %edi,(%esp)
80100272:	e8 69 15 00 00       	call   801017e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100277:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010027e:	e8 dd 55 00 00       	call   80105860 <acquire>
  while(n > 0){
80100283:	31 c0                	xor    %eax,%eax
80100285:	85 f6                	test   %esi,%esi
80100287:	0f 8e a3 00 00 00    	jle    80100330 <consoleread+0xd0>
8010028d:	89 f3                	mov    %esi,%ebx
8010028f:	89 75 10             	mov    %esi,0x10(%ebp)
80100292:	8b 75 0c             	mov    0xc(%ebp),%esi
    while(input.r == input.w){
80100295:	8b 15 00 20 11 80    	mov    0x80112000,%edx
8010029b:	39 15 04 20 11 80    	cmp    %edx,0x80112004
801002a1:	74 28                	je     801002cb <consoleread+0x6b>
801002a3:	eb 5b                	jmp    80100300 <consoleread+0xa0>
801002a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002a8:	b8 20 c5 10 80       	mov    $0x8010c520,%eax
801002ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801002b1:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
801002b8:	e8 23 42 00 00       	call   801044e0 <sleep>
    while(input.r == input.w){
801002bd:	8b 15 00 20 11 80    	mov    0x80112000,%edx
801002c3:	3b 15 04 20 11 80    	cmp    0x80112004,%edx
801002c9:	75 35                	jne    80100300 <consoleread+0xa0>
      if(myproc()->killed){
801002cb:	e8 f0 37 00 00       	call   80103ac0 <myproc>
801002d0:	8b 50 24             	mov    0x24(%eax),%edx
801002d3:	85 d2                	test   %edx,%edx
801002d5:	74 d1                	je     801002a8 <consoleread+0x48>
        release(&cons.lock);
801002d7:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002de:	e8 1d 56 00 00       	call   80105900 <release>
        ilock(ip);
801002e3:	89 3c 24             	mov    %edi,(%esp)
801002e6:	e8 15 14 00 00       	call   80101700 <ilock>
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002eb:	83 c4 2c             	add    $0x2c,%esp
        return -1;
801002ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801002f3:	5b                   	pop    %ebx
801002f4:	5e                   	pop    %esi
801002f5:	5f                   	pop    %edi
801002f6:	5d                   	pop    %ebp
801002f7:	c3                   	ret    
801002f8:	90                   	nop
801002f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100300:	8d 42 01             	lea    0x1(%edx),%eax
80100303:	a3 00 20 11 80       	mov    %eax,0x80112000
80100308:	89 d0                	mov    %edx,%eax
8010030a:	83 e0 7f             	and    $0x7f,%eax
8010030d:	0f be 80 80 1f 11 80 	movsbl -0x7feee080(%eax),%eax
    if(c == C('D')){  // EOF
80100314:	83 f8 04             	cmp    $0x4,%eax
80100317:	74 39                	je     80100352 <consoleread+0xf2>
    *dst++ = c;
80100319:	46                   	inc    %esi
    --n;
8010031a:	4b                   	dec    %ebx
    if(c == '\n')
8010031b:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
8010031e:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100321:	74 42                	je     80100365 <consoleread+0x105>
  while(n > 0){
80100323:	85 db                	test   %ebx,%ebx
80100325:	0f 85 6a ff ff ff    	jne    80100295 <consoleread+0x35>
8010032b:	8b 75 10             	mov    0x10(%ebp),%esi
8010032e:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100330:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
80100337:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010033a:	e8 c1 55 00 00       	call   80105900 <release>
  ilock(ip);
8010033f:	89 3c 24             	mov    %edi,(%esp)
80100342:	e8 b9 13 00 00       	call   80101700 <ilock>
80100347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
8010034a:	83 c4 2c             	add    $0x2c,%esp
8010034d:	5b                   	pop    %ebx
8010034e:	5e                   	pop    %esi
8010034f:	5f                   	pop    %edi
80100350:	5d                   	pop    %ebp
80100351:	c3                   	ret    
80100352:	8b 75 10             	mov    0x10(%ebp),%esi
80100355:	89 f0                	mov    %esi,%eax
80100357:	29 d8                	sub    %ebx,%eax
      if(n < target){
80100359:	39 f3                	cmp    %esi,%ebx
8010035b:	73 d3                	jae    80100330 <consoleread+0xd0>
        input.r--;
8010035d:	89 15 00 20 11 80    	mov    %edx,0x80112000
80100363:	eb cb                	jmp    80100330 <consoleread+0xd0>
80100365:	8b 75 10             	mov    0x10(%ebp),%esi
80100368:	89 f0                	mov    %esi,%eax
8010036a:	29 d8                	sub    %ebx,%eax
8010036c:	eb c2                	jmp    80100330 <consoleread+0xd0>
8010036e:	66 90                	xchg   %ax,%ax

80100370 <panic>:
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  cons.locking = 0;
80100379:	31 d2                	xor    %edx,%edx
8010037b:	89 15 54 c5 10 80    	mov    %edx,0x8010c554
  getcallerpcs(&s, pcs);
80100381:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100384:	e8 57 25 00 00       	call   801028e0 <lapicid>
80100389:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010038c:	c7 04 24 2d 85 10 80 	movl   $0x8010852d,(%esp)
80100393:	89 44 24 04          	mov    %eax,0x4(%esp)
80100397:	e8 b4 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010039c:	8b 45 08             	mov    0x8(%ebp),%eax
8010039f:	89 04 24             	mov    %eax,(%esp)
801003a2:	e8 a9 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
801003a7:	c7 04 24 1b 8b 10 80 	movl   $0x80108b1b,(%esp)
801003ae:	e8 9d 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ba:	89 04 24             	mov    %eax,(%esp)
801003bd:	e8 6e 53 00 00       	call   80105730 <getcallerpcs>
801003c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf(" %p", pcs[i]);
801003d0:	8b 03                	mov    (%ebx),%eax
801003d2:	83 c3 04             	add    $0x4,%ebx
801003d5:	c7 04 24 41 85 10 80 	movl   $0x80108541,(%esp)
801003dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801003e0:	e8 6b 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x60>
  panicked = 1; // freeze other CPU
801003e9:	b8 01 00 00 00       	mov    $0x1,%eax
801003ee:	a3 58 c5 10 80       	mov    %eax,0x8010c558
801003f3:	eb fe                	jmp    801003f3 <panic+0x83>
801003f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100400 <consputc>:
  if(panicked){
80100400:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100406:	85 d2                	test   %edx,%edx
80100408:	74 06                	je     80100410 <consputc+0x10>
8010040a:	fa                   	cli    
8010040b:	eb fe                	jmp    8010040b <consputc+0xb>
8010040d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 2c             	sub    $0x2c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 9f 00 00 00    	je     801004c5 <consputc+0xc5>
    uartputc(c);
80100426:	89 04 24             	mov    %eax,(%esp)
80100429:	e8 b2 6c 00 00       	call   801070e0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010042e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100433:	b0 0e                	mov    $0xe,%al
80100435:	89 f2                	mov    %esi,%edx
80100437:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100438:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010043d:	89 ca                	mov    %ecx,%edx
8010043f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100440:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100443:	89 f2                	mov    %esi,%edx
80100445:	c1 e0 08             	shl    $0x8,%eax
80100448:	89 c7                	mov    %eax,%edi
8010044a:	b0 0f                	mov    $0xf,%al
8010044c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044d:	89 ca                	mov    %ecx,%edx
8010044f:	ec                   	in     (%dx),%al
80100450:	0f b6 c8             	movzbl %al,%ecx
  pos |= inb(CRTPORT+1);
80100453:	09 f9                	or     %edi,%ecx
  if(c == '\n')
80100455:	83 fb 0a             	cmp    $0xa,%ebx
80100458:	0f 84 ff 00 00 00    	je     8010055d <consputc+0x15d>
  else if(c == BACKSPACE){
8010045e:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100464:	0f 84 e5 00 00 00    	je     8010054f <consputc+0x14f>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010046a:	0f b6 c3             	movzbl %bl,%eax
8010046d:	0d 00 07 00 00       	or     $0x700,%eax
80100472:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
80100479:	80 
8010047a:	41                   	inc    %ecx
  if(pos < 0 || pos > 25*80)
8010047b:	81 f9 d0 07 00 00    	cmp    $0x7d0,%ecx
80100481:	0f 8f bc 00 00 00    	jg     80100543 <consputc+0x143>
  if((pos/80) >= 24){  // Scroll up.
80100487:	81 f9 7f 07 00 00    	cmp    $0x77f,%ecx
8010048d:	7f 5f                	jg     801004ee <consputc+0xee>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048f:	be d4 03 00 00       	mov    $0x3d4,%esi
80100494:	b0 0e                	mov    $0xe,%al
80100496:	89 f2                	mov    %esi,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT+1, pos>>8);
8010049e:	89 c8                	mov    %ecx,%eax
801004a0:	c1 f8 08             	sar    $0x8,%eax
801004a3:	89 da                	mov    %ebx,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	b0 0f                	mov    $0xf,%al
801004a8:	89 f2                	mov    %esi,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	88 c8                	mov    %cl,%al
801004ad:	89 da                	mov    %ebx,%edx
801004af:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b0:	b8 20 07 00 00       	mov    $0x720,%eax
801004b5:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
801004bc:	80 
}
801004bd:	83 c4 2c             	add    $0x2c,%esp
801004c0:	5b                   	pop    %ebx
801004c1:	5e                   	pop    %esi
801004c2:	5f                   	pop    %edi
801004c3:	5d                   	pop    %ebp
801004c4:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004cc:	e8 0f 6c 00 00       	call   801070e0 <uartputc>
801004d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004d8:	e8 03 6c 00 00       	call   801070e0 <uartputc>
801004dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004e4:	e8 f7 6b 00 00       	call   801070e0 <uartputc>
801004e9:	e9 40 ff ff ff       	jmp    8010042e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004ee:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004f5:	00 
801004f6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004fd:	80 
801004fe:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
80100505:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100508:	e8 03 55 00 00       	call   80105a10 <memmove>
    pos -= 80;
8010050d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100510:	b8 80 07 00 00       	mov    $0x780,%eax
80100515:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010051c:	00 
    pos -= 80;
8010051d:	83 e9 50             	sub    $0x50,%ecx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100520:	29 c8                	sub    %ecx,%eax
80100522:	01 c0                	add    %eax,%eax
80100524:	89 44 24 08          	mov    %eax,0x8(%esp)
80100528:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
8010052b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100530:	89 04 24             	mov    %eax,(%esp)
80100533:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100536:	e8 15 54 00 00       	call   80105950 <memset>
8010053b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010053e:	e9 4c ff ff ff       	jmp    8010048f <consputc+0x8f>
    panic("pos under/overflow");
80100543:	c7 04 24 45 85 10 80 	movl   $0x80108545,(%esp)
8010054a:	e8 21 fe ff ff       	call   80100370 <panic>
    if(pos > 0) --pos;
8010054f:	85 c9                	test   %ecx,%ecx
80100551:	0f 84 38 ff ff ff    	je     8010048f <consputc+0x8f>
80100557:	49                   	dec    %ecx
80100558:	e9 1e ff ff ff       	jmp    8010047b <consputc+0x7b>
    pos += 80 - pos%80;
8010055d:	89 c8                	mov    %ecx,%eax
8010055f:	bb 50 00 00 00       	mov    $0x50,%ebx
80100564:	99                   	cltd   
80100565:	f7 fb                	idiv   %ebx
80100567:	29 d3                	sub    %edx,%ebx
80100569:	01 d9                	add    %ebx,%ecx
8010056b:	e9 0b ff ff ff       	jmp    8010047b <consputc+0x7b>

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	53                   	push   %ebx
80100576:	89 d3                	mov    %edx,%ebx
80100578:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
{
8010057d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100580:	74 04                	je     80100586 <printint+0x16>
80100582:	85 c0                	test   %eax,%eax
80100584:	78 62                	js     801005e8 <printint+0x78>
    x = xx;
80100586:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010058d:	31 c9                	xor    %ecx,%ecx
8010058f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100592:	eb 06                	jmp    8010059a <printint+0x2a>
80100594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100598:	89 f9                	mov    %edi,%ecx
8010059a:	31 d2                	xor    %edx,%edx
8010059c:	f7 f3                	div    %ebx
8010059e:	8d 79 01             	lea    0x1(%ecx),%edi
801005a1:	0f b6 92 70 85 10 80 	movzbl -0x7fef7a90(%edx),%edx
  }while((x /= base) != 0);
801005a8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005aa:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005ad:	75 e9                	jne    80100598 <printint+0x28>
  if(sign)
801005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005b2:	85 c0                	test   %eax,%eax
801005b4:	74 08                	je     801005be <printint+0x4e>
    buf[i++] = '-';
801005b6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005bb:	8d 79 02             	lea    0x2(%ecx),%edi
801005be:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    consputc(buf[i]);
801005d0:	0f be 03             	movsbl (%ebx),%eax
801005d3:	4b                   	dec    %ebx
801005d4:	e8 27 fe ff ff       	call   80100400 <consputc>
  while(--i >= 0)
801005d9:	39 f3                	cmp    %esi,%ebx
801005db:	75 f3                	jne    801005d0 <printint+0x60>
}
801005dd:	83 c4 2c             	add    $0x2c,%esp
801005e0:	5b                   	pop    %ebx
801005e1:	5e                   	pop    %esi
801005e2:	5f                   	pop    %edi
801005e3:	5d                   	pop    %ebp
801005e4:	c3                   	ret    
801005e5:	8d 76 00             	lea    0x0(%esi),%esi
    x = -xx;
801005e8:	f7 d8                	neg    %eax
801005ea:	eb a1                	jmp    8010058d <printint+0x1d>
801005ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 d9 11 00 00       	call   801017e0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010060e:	e8 4d 52 00 00       	call   80105860 <acquire>
  for(i = 0; i < n; i++)
80100613:	85 f6                	test   %esi,%esi
80100615:	7e 16                	jle    8010062d <consolewrite+0x3d>
80100617:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010061a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	47                   	inc    %edi
80100624:	e8 d7 fd ff ff       	call   80100400 <consputc>
  for(i = 0; i < n; i++)
80100629:	39 fb                	cmp    %edi,%ebx
8010062b:	75 f3                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062d:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
80100634:	e8 c7 52 00 00       	call   80105900 <release>
  ilock(ip);
80100639:	8b 45 08             	mov    0x8(%ebp),%eax
8010063c:	89 04 24             	mov    %eax,(%esp)
8010063f:	e8 bc 10 00 00       	call   80101700 <ilock>

  return n;
}
80100644:	83 c4 1c             	add    $0x1c,%esp
80100647:	89 f0                	mov    %esi,%eax
80100649:	5b                   	pop    %ebx
8010064a:	5e                   	pop    %esi
8010064b:	5f                   	pop    %edi
8010064c:	5d                   	pop    %ebp
8010064d:	c3                   	ret    
8010064e:	66 90                	xchg   %ax,%ax

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 2c             	sub    $0x2c,%esp
  locking = cons.locking;
80100659:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100663:	0f 85 47 01 00 00    	jne    801007b0 <cprintf+0x160>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100671:	0f 84 4a 01 00 00    	je     801007c1 <cprintf+0x171>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100677:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
8010067a:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010067d:	31 db                	xor    %ebx,%ebx
8010067f:	89 cf                	mov    %ecx,%edi
80100681:	85 c0                	test   %eax,%eax
80100683:	75 59                	jne    801006de <cprintf+0x8e>
80100685:	eb 79                	jmp    80100700 <cprintf+0xb0>
80100687:	89 f6                	mov    %esi,%esi
80100689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100690:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100693:	85 d2                	test   %edx,%edx
80100695:	74 69                	je     80100700 <cprintf+0xb0>
80100697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010069a:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010069d:	83 fa 70             	cmp    $0x70,%edx
801006a0:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801006a3:	0f 84 81 00 00 00    	je     8010072a <cprintf+0xda>
801006a9:	7f 75                	jg     80100720 <cprintf+0xd0>
801006ab:	83 fa 25             	cmp    $0x25,%edx
801006ae:	0f 84 e4 00 00 00    	je     80100798 <cprintf+0x148>
801006b4:	83 fa 64             	cmp    $0x64,%edx
801006b7:	0f 85 8b 00 00 00    	jne    80100748 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006bd:	8d 47 04             	lea    0x4(%edi),%eax
801006c0:	b9 01 00 00 00       	mov    $0x1,%ecx
801006c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006c8:	8b 07                	mov    (%edi),%eax
801006ca:	ba 0a 00 00 00       	mov    $0xa,%edx
801006cf:	e8 9c fe ff ff       	call   80100570 <printint>
801006d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 06             	movzbl (%esi),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 22                	je     80100700 <cprintf+0xb0>
801006de:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801006e1:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006e4:	83 f8 25             	cmp    $0x25,%eax
801006e7:	8d 34 11             	lea    (%ecx,%edx,1),%esi
801006ea:	74 a4                	je     80100690 <cprintf+0x40>
801006ec:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006ef:	e8 0c fd ff ff       	call   80100400 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f4:	0f b6 06             	movzbl (%esi),%eax
      continue;
801006f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fa:	85 c0                	test   %eax,%eax
      continue;
801006fc:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	75 de                	jne    801006de <cprintf+0x8e>
  if(locking)
80100700:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100703:	85 c0                	test   %eax,%eax
80100705:	74 0c                	je     80100713 <cprintf+0xc3>
    release(&cons.lock);
80100707:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010070e:	e8 ed 51 00 00       	call   80105900 <release>
}
80100713:	83 c4 2c             	add    $0x2c,%esp
80100716:	5b                   	pop    %ebx
80100717:	5e                   	pop    %esi
80100718:	5f                   	pop    %edi
80100719:	5d                   	pop    %ebp
8010071a:	c3                   	ret    
8010071b:	90                   	nop
8010071c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 43                	je     80100768 <cprintf+0x118>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010072a:	8d 47 04             	lea    0x4(%edi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100732:	8b 07                	mov    (%edi),%eax
80100734:	ba 10 00 00 00       	mov    $0x10,%edx
80100739:	e8 32 fe ff ff       	call   80100570 <printint>
8010073e:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
80100741:	eb 94                	jmp    801006d7 <cprintf+0x87>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100750:	e8 ab fc ff ff       	call   80100400 <consputc>
      consputc(c);
80100755:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 a1 fc ff ff       	call   80100400 <consputc>
      break;
8010075f:	e9 73 ff ff ff       	jmp    801006d7 <cprintf+0x87>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100768:	8d 47 04             	lea    0x4(%edi),%eax
8010076b:	8b 3f                	mov    (%edi),%edi
8010076d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100770:	85 ff                	test   %edi,%edi
80100772:	75 12                	jne    80100786 <cprintf+0x136>
        s = "(null)";
80100774:	bf 58 85 10 80       	mov    $0x80108558,%edi
      for(; *s; s++)
80100779:	b8 28 00 00 00       	mov    $0x28,%eax
8010077e:	66 90                	xchg   %ax,%ax
        consputc(*s);
80100780:	e8 7b fc ff ff       	call   80100400 <consputc>
      for(; *s; s++)
80100785:	47                   	inc    %edi
80100786:	0f be 07             	movsbl (%edi),%eax
80100789:	84 c0                	test   %al,%al
8010078b:	75 f3                	jne    80100780 <cprintf+0x130>
      if((s = (char*)*argp++) == 0)
8010078d:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100790:	e9 42 ff ff ff       	jmp    801006d7 <cprintf+0x87>
80100795:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
80100798:	b8 25 00 00 00       	mov    $0x25,%eax
8010079d:	e8 5e fc ff ff       	call   80100400 <consputc>
      break;
801007a2:	e9 30 ff ff ff       	jmp    801006d7 <cprintf+0x87>
801007a7:	89 f6                	mov    %esi,%esi
801007a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    acquire(&cons.lock);
801007b0:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801007b7:	e8 a4 50 00 00       	call   80105860 <acquire>
801007bc:	e9 a8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007c1:	c7 04 24 5f 85 10 80 	movl   $0x8010855f,(%esp)
801007c8:	e8 a3 fb ff ff       	call   80100370 <panic>
801007cd:	8d 76 00             	lea    0x0(%esi),%esi

801007d0 <consoleintr>:
{
801007d0:	55                   	push   %ebp
801007d1:	89 e5                	mov    %esp,%ebp
801007d3:	56                   	push   %esi
  int c, doprocdump = 0;
801007d4:	31 f6                	xor    %esi,%esi
{
801007d6:	53                   	push   %ebx
801007d7:	83 ec 20             	sub    $0x20,%esp
  acquire(&cons.lock);
801007da:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
{
801007e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007e4:	e8 77 50 00 00       	call   80105860 <acquire>
801007e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((c = getc()) >= 0){
801007f0:	ff d3                	call   *%ebx
801007f2:	85 c0                	test   %eax,%eax
801007f4:	89 c2                	mov    %eax,%edx
801007f6:	78 48                	js     80100840 <consoleintr+0x70>
    switch(c){
801007f8:	83 fa 10             	cmp    $0x10,%edx
801007fb:	0f 84 e7 00 00 00    	je     801008e8 <consoleintr+0x118>
80100801:	7e 5d                	jle    80100860 <consoleintr+0x90>
80100803:	83 fa 15             	cmp    $0x15,%edx
80100806:	0f 84 ec 00 00 00    	je     801008f8 <consoleintr+0x128>
8010080c:	83 fa 7f             	cmp    $0x7f,%edx
8010080f:	90                   	nop
80100810:	75 53                	jne    80100865 <consoleintr+0x95>
      if(input.e != input.w){
80100812:	a1 08 20 11 80       	mov    0x80112008,%eax
80100817:	3b 05 04 20 11 80    	cmp    0x80112004,%eax
8010081d:	74 d1                	je     801007f0 <consoleintr+0x20>
        input.e--;
8010081f:	48                   	dec    %eax
80100820:	a3 08 20 11 80       	mov    %eax,0x80112008
        consputc(BACKSPACE);
80100825:	b8 00 01 00 00       	mov    $0x100,%eax
8010082a:	e8 d1 fb ff ff       	call   80100400 <consputc>
  while((c = getc()) >= 0){
8010082f:	ff d3                	call   *%ebx
80100831:	85 c0                	test   %eax,%eax
80100833:	89 c2                	mov    %eax,%edx
80100835:	79 c1                	jns    801007f8 <consoleintr+0x28>
80100837:	89 f6                	mov    %esi,%esi
80100839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&cons.lock);
80100840:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
80100847:	e8 b4 50 00 00       	call   80105900 <release>
  if(doprocdump) {
8010084c:	85 f6                	test   %esi,%esi
8010084e:	0f 85 f4 00 00 00    	jne    80100948 <consoleintr+0x178>
}
80100854:	83 c4 20             	add    $0x20,%esp
80100857:	5b                   	pop    %ebx
80100858:	5e                   	pop    %esi
80100859:	5d                   	pop    %ebp
8010085a:	c3                   	ret    
8010085b:	90                   	nop
8010085c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100860:	83 fa 08             	cmp    $0x8,%edx
80100863:	74 ad                	je     80100812 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100865:	85 d2                	test   %edx,%edx
80100867:	74 87                	je     801007f0 <consoleintr+0x20>
80100869:	a1 08 20 11 80       	mov    0x80112008,%eax
8010086e:	89 c1                	mov    %eax,%ecx
80100870:	2b 0d 00 20 11 80    	sub    0x80112000,%ecx
80100876:	83 f9 7f             	cmp    $0x7f,%ecx
80100879:	0f 87 71 ff ff ff    	ja     801007f0 <consoleintr+0x20>
8010087f:	8d 48 01             	lea    0x1(%eax),%ecx
80100882:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100885:	83 fa 0d             	cmp    $0xd,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100888:	89 0d 08 20 11 80    	mov    %ecx,0x80112008
        c = (c == '\r') ? '\n' : c;
8010088e:	0f 84 c4 00 00 00    	je     80100958 <consoleintr+0x188>
        input.buf[input.e++ % INPUT_BUF] = c;
80100894:	88 90 80 1f 11 80    	mov    %dl,-0x7feee080(%eax)
        consputc(c);
8010089a:	89 d0                	mov    %edx,%eax
8010089c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010089f:	e8 5c fb ff ff       	call   80100400 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008a7:	83 fa 0a             	cmp    $0xa,%edx
801008aa:	0f 84 b9 00 00 00    	je     80100969 <consoleintr+0x199>
801008b0:	83 fa 04             	cmp    $0x4,%edx
801008b3:	0f 84 b0 00 00 00    	je     80100969 <consoleintr+0x199>
801008b9:	a1 00 20 11 80       	mov    0x80112000,%eax
801008be:	83 e8 80             	sub    $0xffffff80,%eax
801008c1:	39 05 08 20 11 80    	cmp    %eax,0x80112008
801008c7:	0f 85 23 ff ff ff    	jne    801007f0 <consoleintr+0x20>
          wakeup(&input.r);
801008cd:	c7 04 24 00 20 11 80 	movl   $0x80112000,(%esp)
          input.w = input.e;
801008d4:	a3 04 20 11 80       	mov    %eax,0x80112004
          wakeup(&input.r);
801008d9:	e8 22 3e 00 00       	call   80104700 <wakeup>
801008de:	e9 0d ff ff ff       	jmp    801007f0 <consoleintr+0x20>
801008e3:	90                   	nop
801008e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
801008e8:	be 01 00 00 00       	mov    $0x1,%esi
801008ed:	e9 fe fe ff ff       	jmp    801007f0 <consoleintr+0x20>
801008f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
801008f8:	a1 08 20 11 80       	mov    0x80112008,%eax
801008fd:	39 05 04 20 11 80    	cmp    %eax,0x80112004
80100903:	75 2b                	jne    80100930 <consoleintr+0x160>
80100905:	e9 e6 fe ff ff       	jmp    801007f0 <consoleintr+0x20>
8010090a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100910:	a3 08 20 11 80       	mov    %eax,0x80112008
        consputc(BACKSPACE);
80100915:	b8 00 01 00 00       	mov    $0x100,%eax
8010091a:	e8 e1 fa ff ff       	call   80100400 <consputc>
      while(input.e != input.w &&
8010091f:	a1 08 20 11 80       	mov    0x80112008,%eax
80100924:	3b 05 04 20 11 80    	cmp    0x80112004,%eax
8010092a:	0f 84 c0 fe ff ff    	je     801007f0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100930:	48                   	dec    %eax
80100931:	89 c2                	mov    %eax,%edx
80100933:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100936:	80 ba 80 1f 11 80 0a 	cmpb   $0xa,-0x7feee080(%edx)
8010093d:	75 d1                	jne    80100910 <consoleintr+0x140>
8010093f:	e9 ac fe ff ff       	jmp    801007f0 <consoleintr+0x20>
80100944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80100948:	83 c4 20             	add    $0x20,%esp
8010094b:	5b                   	pop    %ebx
8010094c:	5e                   	pop    %esi
8010094d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
8010094e:	e9 8d 3e 00 00       	jmp    801047e0 <procdump>
80100953:	90                   	nop
80100954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100958:	c6 80 80 1f 11 80 0a 	movb   $0xa,-0x7feee080(%eax)
        consputc(c);
8010095f:	b8 0a 00 00 00       	mov    $0xa,%eax
80100964:	e8 97 fa ff ff       	call   80100400 <consputc>
80100969:	a1 08 20 11 80       	mov    0x80112008,%eax
8010096e:	e9 5a ff ff ff       	jmp    801008cd <consoleintr+0xfd>
80100973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100980 <consoleinit>:

void
consoleinit(void)
{
80100980:	55                   	push   %ebp
  initlock(&cons.lock, "console");
80100981:	b8 68 85 10 80       	mov    $0x80108568,%eax
{
80100986:	89 e5                	mov    %esp,%ebp
80100988:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
8010098b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010098f:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
80100996:	e8 75 4d 00 00       	call   80105710 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
8010099b:	b8 01 00 00 00       	mov    $0x1,%eax
  devsw[CONSOLE].write = consolewrite;
801009a0:	ba f0 05 10 80       	mov    $0x801005f0,%edx
  cons.locking = 1;
801009a5:	a3 54 c5 10 80       	mov    %eax,0x8010c554

  ioapicenable(IRQ_KBD, 0);
801009aa:	31 c0                	xor    %eax,%eax
  devsw[CONSOLE].read = consoleread;
801009ac:	b9 60 02 10 80       	mov    $0x80100260,%ecx
  ioapicenable(IRQ_KBD, 0);
801009b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
801009bc:	89 15 cc 29 11 80    	mov    %edx,0x801129cc
  devsw[CONSOLE].read = consoleread;
801009c2:	89 0d c8 29 11 80    	mov    %ecx,0x801129c8
  ioapicenable(IRQ_KBD, 0);
801009c8:	e8 83 1a 00 00       	call   80102450 <ioapicenable>
}
801009cd:	c9                   	leave  
801009ce:	c3                   	ret    
801009cf:	90                   	nop

801009d0 <exec>:
#include "syscall.h"


int
exec(char *path, char **argv)
{
801009d0:	55                   	push   %ebp
801009d1:	89 e5                	mov    %esp,%ebp
801009d3:	57                   	push   %edi
801009d4:	56                   	push   %esi
801009d5:	53                   	push   %ebx
801009d6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009dc:	e8 df 30 00 00       	call   80103ac0 <myproc>
801009e1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009e7:	e8 54 23 00 00       	call   80102d40 <begin_op>
  
  if((ip = namei(path)) == 0){
801009ec:	8b 45 08             	mov    0x8(%ebp),%eax
801009ef:	89 04 24             	mov    %eax,(%esp)
801009f2:	e8 89 16 00 00       	call   80102080 <namei>
801009f7:	85 c0                	test   %eax,%eax
801009f9:	74 38                	je     80100a33 <exec+0x63>
      end_op();
      return -1;
    }

  ilock(ip);
801009fb:	89 04 24             	mov    %eax,(%esp)
801009fe:	89 c7                	mov    %eax,%edi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a00:	31 db                	xor    %ebx,%ebx
  ilock(ip);
80100a02:	e8 f9 0c 00 00       	call   80101700 <ilock>
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a07:	b9 34 00 00 00       	mov    $0x34,%ecx
80100a0c:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a12:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80100a16:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a1e:	89 3c 24             	mov    %edi,(%esp)
80100a21:	e8 ba 0f 00 00       	call   801019e0 <readi>
80100a26:	83 f8 34             	cmp    $0x34,%eax
80100a29:	74 25                	je     80100a50 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a2b:	89 3c 24             	mov    %edi,(%esp)
80100a2e:	e8 5d 0f 00 00       	call   80101990 <iunlockput>
    end_op();
80100a33:	e8 78 23 00 00       	call   80102db0 <end_op>
  }
  return -1;
80100a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a3d:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a43:	5b                   	pop    %ebx
80100a44:	5e                   	pop    %esi
80100a45:	5f                   	pop    %edi
80100a46:	5d                   	pop    %ebp
80100a47:	c3                   	ret    
80100a48:	90                   	nop
80100a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a50:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a57:	45 4c 46 
80100a5a:	75 cf                	jne    80100a2b <exec+0x5b>
  if((pgdir = setupkvm()) == 0)
80100a5c:	e8 df 77 00 00       	call   80108240 <setupkvm>
80100a61:	85 c0                	test   %eax,%eax
80100a63:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a69:	74 c0                	je     80100a2b <exec+0x5b>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a6b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
80100a71:	31 f6                	xor    %esi,%esi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a73:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a7a:	00 
80100a7b:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100a81:	0f 84 98 02 00 00    	je     80100d1f <exec+0x34f>
80100a87:	31 db                	xor    %ebx,%ebx
80100a89:	e9 8c 00 00 00       	jmp    80100b1a <exec+0x14a>
80100a8e:	66 90                	xchg   %ax,%ax
    if(ph.type != ELF_PROG_LOAD)
80100a90:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a97:	75 75                	jne    80100b0e <exec+0x13e>
    if(ph.memsz < ph.filesz)
80100a99:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a9f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aa5:	0f 82 a4 00 00 00    	jb     80100b4f <exec+0x17f>
80100aab:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab1:	0f 82 98 00 00 00    	jb     80100b4f <exec+0x17f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ab7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac1:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ac5:	89 04 24             	mov    %eax,(%esp)
80100ac8:	e8 93 75 00 00       	call   80108060 <allocuvm>
80100acd:	85 c0                	test   %eax,%eax
80100acf:	89 c6                	mov    %eax,%esi
80100ad1:	74 7c                	je     80100b4f <exec+0x17f>
    if(ph.vaddr % PGSIZE != 0)
80100ad3:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ad9:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ade:	75 6f                	jne    80100b4f <exec+0x17f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ae0:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100aea:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100af0:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100af4:	89 54 24 10          	mov    %edx,0x10(%esp)
80100af8:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100afe:	89 04 24             	mov    %eax,(%esp)
80100b01:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b05:	e8 96 74 00 00       	call   80107fa0 <loaduvm>
80100b0a:	85 c0                	test   %eax,%eax
80100b0c:	78 41                	js     80100b4f <exec+0x17f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b0e:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b15:	43                   	inc    %ebx
80100b16:	39 d8                	cmp    %ebx,%eax
80100b18:	7e 48                	jle    80100b62 <exec+0x192>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b1a:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100b20:	b8 20 00 00 00       	mov    $0x20,%eax
80100b25:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100b29:	89 d8                	mov    %ebx,%eax
80100b2b:	c1 e0 05             	shl    $0x5,%eax
80100b2e:	89 3c 24             	mov    %edi,(%esp)
80100b31:	01 d0                	add    %edx,%eax
80100b33:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b37:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b41:	e8 9a 0e 00 00       	call   801019e0 <readi>
80100b46:	83 f8 20             	cmp    $0x20,%eax
80100b49:	0f 84 41 ff ff ff    	je     80100a90 <exec+0xc0>
    freevm(pgdir);
80100b4f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b55:	89 04 24             	mov    %eax,(%esp)
80100b58:	e8 63 76 00 00       	call   801081c0 <freevm>
80100b5d:	e9 c9 fe ff ff       	jmp    80100a2b <exec+0x5b>
80100b62:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100b68:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100b6e:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100b74:	89 3c 24             	mov    %edi,(%esp)
80100b77:	e8 14 0e 00 00       	call   80101990 <iunlockput>
  end_op();
80100b7c:	e8 2f 22 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b81:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b87:	89 74 24 04          	mov    %esi,0x4(%esp)
80100b8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b8f:	89 04 24             	mov    %eax,(%esp)
80100b92:	e8 c9 74 00 00       	call   80108060 <allocuvm>
80100b97:	85 c0                	test   %eax,%eax
80100b99:	89 c6                	mov    %eax,%esi
80100b9b:	75 18                	jne    80100bb5 <exec+0x1e5>
    freevm(pgdir);
80100b9d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ba3:	89 04 24             	mov    %eax,(%esp)
80100ba6:	e8 15 76 00 00       	call   801081c0 <freevm>
  return -1;
80100bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb0:	e9 88 fe ff ff       	jmp    80100a3d <exec+0x6d>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bb5:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100bbb:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bc1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  for(argc = 0; argv[argc]; argc++) {
80100bc7:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc9:	89 04 24             	mov    %eax,(%esp)
80100bcc:	e8 0f 77 00 00       	call   801082e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd4:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bda:	8b 00                	mov    (%eax),%eax
80100bdc:	85 c0                	test   %eax,%eax
80100bde:	74 73                	je     80100c53 <exec+0x283>
80100be0:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100be6:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100bec:	eb 07                	jmp    80100bf5 <exec+0x225>
80100bee:	66 90                	xchg   %ax,%ax
    if(argc >= MAXARG)
80100bf0:	83 ff 20             	cmp    $0x20,%edi
80100bf3:	74 a8                	je     80100b9d <exec+0x1cd>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf5:	89 04 24             	mov    %eax,(%esp)
80100bf8:	e8 73 4f 00 00       	call   80105b70 <strlen>
80100bfd:	f7 d0                	not    %eax
80100bff:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c01:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c04:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c07:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c0a:	89 04 24             	mov    %eax,(%esp)
80100c0d:	e8 5e 4f 00 00       	call   80105b70 <strlen>
80100c12:	40                   	inc    %eax
80100c13:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c17:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c1a:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c21:	89 34 24             	mov    %esi,(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	e8 23 78 00 00       	call   80108450 <copyout>
80100c2d:	85 c0                	test   %eax,%eax
80100c2f:	0f 88 68 ff ff ff    	js     80100b9d <exec+0x1cd>
  for(argc = 0; argv[argc]; argc++) {
80100c35:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c38:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c3e:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c45:	47                   	inc    %edi
80100c46:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c49:	85 c0                	test   %eax,%eax
80100c4b:	75 a3                	jne    80100bf0 <exec+0x220>
80100c4d:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[3+argc] = 0;
80100c53:	31 c0                	xor    %eax,%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100c55:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  ustack[3+argc] = 0;
80100c5a:	89 84 bd 64 ff ff ff 	mov    %eax,-0x9c(%ebp,%edi,4)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c61:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100c68:	89 8d 58 ff ff ff    	mov    %ecx,-0xa8(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c6e:	89 d9                	mov    %ebx,%ecx
80100c70:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100c72:	83 c0 0c             	add    $0xc,%eax
80100c75:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c81:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c85:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[1] = argc;
80100c89:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c8f:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c92:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c98:	e8 b3 77 00 00       	call   80108450 <copyout>
80100c9d:	85 c0                	test   %eax,%eax
80100c9f:	0f 88 f8 fe ff ff    	js     80100b9d <exec+0x1cd>
  for(last=s=path; *s; s++)
80100ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80100ca8:	0f b6 00             	movzbl (%eax),%eax
80100cab:	84 c0                	test   %al,%al
80100cad:	74 15                	je     80100cc4 <exec+0x2f4>
80100caf:	8b 55 08             	mov    0x8(%ebp),%edx
80100cb2:	89 d1                	mov    %edx,%ecx
80100cb4:	41                   	inc    %ecx
80100cb5:	3c 2f                	cmp    $0x2f,%al
80100cb7:	0f b6 01             	movzbl (%ecx),%eax
80100cba:	0f 44 d1             	cmove  %ecx,%edx
80100cbd:	84 c0                	test   %al,%al
80100cbf:	75 f3                	jne    80100cb4 <exec+0x2e4>
80100cc1:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cc4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cca:	8b 45 08             	mov    0x8(%ebp),%eax
80100ccd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cd4:	00 
80100cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd9:	89 f8                	mov    %edi,%eax
80100cdb:	83 c0 6c             	add    $0x6c,%eax
80100cde:	89 04 24             	mov    %eax,(%esp)
80100ce1:	e8 4a 4e 00 00       	call   80105b30 <safestrcpy>
  curproc->pgdir = pgdir;
80100ce6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100cec:	89 f9                	mov    %edi,%ecx
80100cee:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100cf1:	89 31                	mov    %esi,(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100cf3:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->pgdir = pgdir;
80100cf6:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100cf9:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100cff:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d02:	8b 41 18             	mov    0x18(%ecx),%eax
80100d05:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d08:	89 0c 24             	mov    %ecx,(%esp)
80100d0b:	e8 00 71 00 00       	call   80107e10 <switchuvm>
  freevm(oldpgdir);
80100d10:	89 3c 24             	mov    %edi,(%esp)
80100d13:	e8 a8 74 00 00       	call   801081c0 <freevm>
  return 0;
80100d18:	31 c0                	xor    %eax,%eax
80100d1a:	e9 1e fd ff ff       	jmp    80100a3d <exec+0x6d>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d1f:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100d24:	e9 4b fe ff ff       	jmp    80100b74 <exec+0x1a4>
80100d29:	66 90                	xchg   %ax,%ax
80100d2b:	66 90                	xchg   %ax,%ax
80100d2d:	66 90                	xchg   %ax,%ax
80100d2f:	90                   	nop

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
  initlock(&ftable.lock, "ftable");
80100d31:	b8 81 85 10 80       	mov    $0x80108581,%eax
{
80100d36:	89 e5                	mov    %esp,%ebp
80100d38:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d3f:	c7 04 24 20 20 11 80 	movl   $0x80112020,(%esp)
80100d46:	e8 c5 49 00 00       	call   80105710 <initlock>
}
80100d4b:	c9                   	leave  
80100d4c:	c3                   	ret    
80100d4d:	8d 76 00             	lea    0x0(%esi),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb 54 20 11 80       	mov    $0x80112054,%ebx
{
80100d59:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d5c:	c7 04 24 20 20 11 80 	movl   $0x80112020,(%esp)
80100d63:	e8 f8 4a 00 00       	call   80105860 <acquire>
80100d68:	eb 11                	jmp    80100d7b <filealloc+0x2b>
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb b4 29 11 80    	cmp    $0x801129b4,%ebx
80100d79:	73 25                	jae    80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
80100d82:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d89:	c7 04 24 20 20 11 80 	movl   $0x80112020,(%esp)
80100d90:	e8 6b 4b 00 00       	call   80105900 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d95:	83 c4 14             	add    $0x14,%esp
80100d98:	89 d8                	mov    %ebx,%eax
80100d9a:	5b                   	pop    %ebx
80100d9b:	5d                   	pop    %ebp
80100d9c:	c3                   	ret    
80100d9d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100da0:	c7 04 24 20 20 11 80 	movl   $0x80112020,(%esp)
  return 0;
80100da7:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100da9:	e8 52 4b 00 00       	call   80105900 <release>
}
80100dae:	83 c4 14             	add    $0x14,%esp
80100db1:	89 d8                	mov    %ebx,%eax
80100db3:	5b                   	pop    %ebx
80100db4:	5d                   	pop    %ebp
80100db5:	c3                   	ret    
80100db6:	8d 76 00             	lea    0x0(%esi),%esi
80100db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 14             	sub    $0x14,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	c7 04 24 20 20 11 80 	movl   $0x80112020,(%esp)
80100dd1:	e8 8a 4a 00 00       	call   80105860 <acquire>
  if(f->ref < 1)
80100dd6:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd9:	85 c0                	test   %eax,%eax
80100ddb:	7e 18                	jle    80100df5 <filedup+0x35>
    panic("filedup");
  f->ref++;
80100ddd:	40                   	inc    %eax
80100dde:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de1:	c7 04 24 20 20 11 80 	movl   $0x80112020,(%esp)
80100de8:	e8 13 4b 00 00       	call   80105900 <release>
  return f;
}
80100ded:	83 c4 14             	add    $0x14,%esp
80100df0:	89 d8                	mov    %ebx,%eax
80100df2:	5b                   	pop    %ebx
80100df3:	5d                   	pop    %ebp
80100df4:	c3                   	ret    
    panic("filedup");
80100df5:	c7 04 24 88 85 10 80 	movl   $0x80108588,(%esp)
80100dfc:	e8 6f f5 ff ff       	call   80100370 <panic>
80100e01:	eb 0d                	jmp    80100e10 <fileclose>
80100e03:	90                   	nop
80100e04:	90                   	nop
80100e05:	90                   	nop
80100e06:	90                   	nop
80100e07:	90                   	nop
80100e08:	90                   	nop
80100e09:	90                   	nop
80100e0a:	90                   	nop
80100e0b:	90                   	nop
80100e0c:	90                   	nop
80100e0d:	90                   	nop
80100e0e:	90                   	nop
80100e0f:	90                   	nop

80100e10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 38             	sub    $0x38,%esp
80100e16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	c7 04 24 20 20 11 80 	movl   $0x80112020,(%esp)
{
80100e23:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100e26:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&ftable.lock);
80100e29:	e8 32 4a 00 00       	call   80105860 <acquire>
  if(f->ref < 1)
80100e2e:	8b 43 04             	mov    0x4(%ebx),%eax
80100e31:	85 c0                	test   %eax,%eax
80100e33:	0f 8e a0 00 00 00    	jle    80100ed9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100e39:	48                   	dec    %eax
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	89 43 04             	mov    %eax,0x4(%ebx)
80100e3f:	74 1f                	je     80100e60 <fileclose+0x50>
    release(&ftable.lock);
80100e41:	c7 45 08 20 20 11 80 	movl   $0x80112020,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e48:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100e4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100e4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100e51:	89 ec                	mov    %ebp,%esp
80100e53:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e54:	e9 a7 4a 00 00       	jmp    80105900 <release>
80100e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e60:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e64:	8b 3b                	mov    (%ebx),%edi
80100e66:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e69:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e6f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e72:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100e75:	c7 04 24 20 20 11 80 	movl   $0x80112020,(%esp)
  ff = *f;
80100e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e7f:	e8 7c 4a 00 00       	call   80105900 <release>
  if(ff.type == FD_PIPE)
80100e84:	83 ff 01             	cmp    $0x1,%edi
80100e87:	74 17                	je     80100ea0 <fileclose+0x90>
  else if(ff.type == FD_INODE){
80100e89:	83 ff 02             	cmp    $0x2,%edi
80100e8c:	74 2a                	je     80100eb8 <fileclose+0xa8>
}
80100e8e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100e91:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100e94:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100e97:	89 ec                	mov    %ebp,%esp
80100e99:	5d                   	pop    %ebp
80100e9a:	c3                   	ret    
80100e9b:	90                   	nop
80100e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pipeclose(ff.pipe, ff.writable);
80100ea0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ea4:	89 34 24             	mov    %esi,(%esp)
80100ea7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100eab:	e8 c0 26 00 00       	call   80103570 <pipeclose>
80100eb0:	eb dc                	jmp    80100e8e <fileclose+0x7e>
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100eb8:	e8 83 1e 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec0:	89 04 24             	mov    %eax,(%esp)
80100ec3:	e8 68 09 00 00       	call   80101830 <iput>
}
80100ec8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100ecb:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100ece:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100ed1:	89 ec                	mov    %ebp,%esp
80100ed3:	5d                   	pop    %ebp
    end_op();
80100ed4:	e9 d7 1e 00 00       	jmp    80102db0 <end_op>
    panic("fileclose");
80100ed9:	c7 04 24 90 85 10 80 	movl   $0x80108590,(%esp)
80100ee0:	e8 8b f4 ff ff       	call   80100370 <panic>
80100ee5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ef0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 f6 07 00 00       	call   80101700 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 94 0a 00 00       	call   801019b0 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 b9 08 00 00       	call   801017e0 <iunlock>
    return 0;
80100f27:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f29:	83 c4 14             	add    $0x14,%esp
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
  return -1;
80100f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f35:	eb f2                	jmp    80100f29 <filestat+0x39>
80100f37:	89 f6                	mov    %esi,%esi
80100f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	83 ec 38             	sub    $0x38,%esp
80100f46:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100f4f:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f52:	89 7d fc             	mov    %edi,-0x4(%ebp)
80100f55:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f58:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f5c:	74 72                	je     80100fd0 <fileread+0x90>
    return -1;
  if(f->type == FD_PIPE)
80100f5e:	8b 03                	mov    (%ebx),%eax
80100f60:	83 f8 01             	cmp    $0x1,%eax
80100f63:	74 53                	je     80100fb8 <fileread+0x78>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f65:	83 f8 02             	cmp    $0x2,%eax
80100f68:	75 6d                	jne    80100fd7 <fileread+0x97>
    ilock(f->ip);
80100f6a:	8b 43 10             	mov    0x10(%ebx),%eax
80100f6d:	89 04 24             	mov    %eax,(%esp)
80100f70:	e8 8b 07 00 00       	call   80101700 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f79:	8b 43 14             	mov    0x14(%ebx),%eax
80100f7c:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f80:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f84:	8b 43 10             	mov    0x10(%ebx),%eax
80100f87:	89 04 24             	mov    %eax,(%esp)
80100f8a:	e8 51 0a 00 00       	call   801019e0 <readi>
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	7e 03                	jle    80100f96 <fileread+0x56>
      f->off += r;
80100f93:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f96:	8b 53 10             	mov    0x10(%ebx),%edx
80100f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100f9c:	89 14 24             	mov    %edx,(%esp)
80100f9f:	e8 3c 08 00 00       	call   801017e0 <iunlock>
    return r;
80100fa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100fa7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100faa:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100fad:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100fb0:	89 ec                	mov    %ebp,%esp
80100fb2:	5d                   	pop    %ebp
80100fb3:	c3                   	ret    
80100fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80100fb8:	8b 43 0c             	mov    0xc(%ebx),%eax
}
80100fbb:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100fbe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100fc1:	8b 7d fc             	mov    -0x4(%ebp),%edi
    return piperead(f->pipe, addr, n);
80100fc4:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc7:	89 ec                	mov    %ebp,%esp
80100fc9:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fca:	e9 51 27 00 00       	jmp    80103720 <piperead>
80100fcf:	90                   	nop
    return -1;
80100fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fd5:	eb d0                	jmp    80100fa7 <fileread+0x67>
  panic("fileread");
80100fd7:	c7 04 24 9a 85 10 80 	movl   $0x8010859a,(%esp)
80100fde:	e8 8d f3 ff ff       	call   80100370 <panic>
80100fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 2c             	sub    $0x2c,%esp
80100ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ffc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101002:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101005:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 ae 00 00 00    	je     801010c0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 07                	mov    (%edi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d8 00 00 00    	jne    801010fe <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 f6                	xor    %esi,%esi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 31                	jg     80101060 <filewrite+0x70>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101038:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010103b:	01 47 14             	add    %eax,0x14(%edi)
8010103e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101041:	89 0c 24             	mov    %ecx,(%esp)
80101044:	e8 97 07 00 00       	call   801017e0 <iunlock>
      end_op();
80101049:	e8 62 1d 00 00       	call   80102db0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101051:	39 c3                	cmp    %eax,%ebx
80101053:	0f 85 99 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
80101059:	01 de                	add    %ebx,%esi
    while(i < n){
8010105b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010105e:	7e 70                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101060:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101063:	b8 00 06 00 00       	mov    $0x600,%eax
80101068:	29 f3                	sub    %esi,%ebx
8010106a:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101070:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101073:	e8 c8 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
80101078:	8b 47 10             	mov    0x10(%edi),%eax
8010107b:	89 04 24             	mov    %eax,(%esp)
8010107e:	e8 7d 06 00 00       	call   80101700 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101083:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80101087:	8b 47 14             	mov    0x14(%edi),%eax
8010108a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010108e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101091:	01 f0                	add    %esi,%eax
80101093:	89 44 24 04          	mov    %eax,0x4(%esp)
80101097:	8b 47 10             	mov    0x10(%edi),%eax
8010109a:	89 04 24             	mov    %eax,(%esp)
8010109d:	e8 5e 0a 00 00       	call   80101b00 <writei>
801010a2:	85 c0                	test   %eax,%eax
801010a4:	7f 92                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
801010a6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010ac:	89 0c 24             	mov    %ecx,(%esp)
801010af:	e8 2c 07 00 00       	call   801017e0 <iunlock>
      end_op();
801010b4:	e8 f7 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
801010b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010bc:	85 c0                	test   %eax,%eax
801010be:	74 91                	je     80101051 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010c3:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
801010c8:	5b                   	pop    %ebx
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
801010cf:	90                   	nop
    return i == n ? n : -1;
801010d0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801010d3:	75 eb                	jne    801010c0 <filewrite+0xd0>
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	89 f0                	mov    %esi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 47 0c             	mov    0xc(%edi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	83 c4 2c             	add    $0x2c,%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 1e 25 00 00       	jmp    80103610 <pipewrite>
        panic("short filewrite");
801010f2:	c7 04 24 a3 85 10 80 	movl   $0x801085a3,(%esp)
801010f9:	e8 72 f2 ff ff       	call   80100370 <panic>
  panic("filewrite");
801010fe:	c7 04 24 a9 85 10 80 	movl   $0x801085a9,(%esp)
80101105:	e8 66 f2 ff ff       	call   80100370 <panic>
8010110a:	66 90                	xchg   %ax,%ax
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 2c             	sub    $0x2c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 35 20 2a 11 80    	mov    0x80112a20,%esi
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 f6                	test   %esi,%esi
80101124:	0f 84 7e 00 00 00    	je     801011a8 <balloc+0x98>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	8b 1d 38 2a 11 80    	mov    0x80112a38,%ebx
8010113a:	89 f0                	mov    %esi,%eax
8010113c:	c1 f8 0c             	sar    $0xc,%eax
8010113f:	01 d8                	add    %ebx,%eax
80101141:	89 44 24 04          	mov    %eax,0x4(%esp)
80101145:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101148:	89 04 24             	mov    %eax,(%esp)
8010114b:	e8 80 ef ff ff       	call   801000d0 <bread>
80101150:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101152:	a1 20 2a 11 80       	mov    0x80112a20,%eax
80101157:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010115a:	31 c0                	xor    %eax,%eax
8010115c:	eb 2b                	jmp    80101189 <balloc+0x79>
8010115e:	66 90                	xchg   %ax,%ax
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
80101162:	bf 01 00 00 00       	mov    $0x1,%edi
80101167:	83 e1 07             	and    $0x7,%ecx
8010116a:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116c:	89 c1                	mov    %eax,%ecx
8010116e:	c1 f9 03             	sar    $0x3,%ecx
      m = 1 << (bi % 8);
80101171:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101174:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101179:	85 7d e4             	test   %edi,-0x1c(%ebp)
8010117c:	89 fa                	mov    %edi,%edx
8010117e:	74 38                	je     801011b8 <balloc+0xa8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101180:	40                   	inc    %eax
80101181:	46                   	inc    %esi
80101182:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101187:	74 05                	je     8010118e <balloc+0x7e>
80101189:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118c:	77 d2                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010118e:	89 1c 24             	mov    %ebx,(%esp)
80101191:	e8 4a f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101196:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
8010119d:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a0:	39 05 20 2a 11 80    	cmp    %eax,0x80112a20
801011a6:	77 89                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011a8:	c7 04 24 b3 85 10 80 	movl   $0x801085b3,(%esp)
801011af:	e8 bc f1 ff ff       	call   80100370 <panic>
801011b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801011bc:	08 c2                	or     %al,%dl
801011be:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
801011c2:	89 1c 24             	mov    %ebx,(%esp)
801011c5:	e8 16 1d 00 00       	call   80102ee0 <log_write>
        brelse(bp);
801011ca:	89 1c 24             	mov    %ebx,(%esp)
801011cd:	e8 0e f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d5:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d9:	89 04 24             	mov    %eax,(%esp)
801011dc:	e8 ef ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011e1:	ba 00 02 00 00       	mov    $0x200,%edx
801011e6:	31 c9                	xor    %ecx,%ecx
801011e8:	89 54 24 08          	mov    %edx,0x8(%esp)
801011ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  bp = bread(dev, bno);
801011f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 53 47 00 00       	call   80105950 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 db 1c 00 00       	call   80102ee0 <log_write>
  brelse(bp);
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
}
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101227:	31 f6                	xor    %esi,%esi
{
80101229:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 74 2a 11 80       	mov    $0x80112a74,%ebx
{
8010122f:	83 ec 2c             	sub    $0x2c,%esp
  acquire(&icache.lock);
80101232:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
{
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010123c:	e8 1f 46 00 00       	call   80105860 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 18                	jmp    8010125e <iget+0x3e>
80101246:	8d 76 00             	lea    0x0(%esi),%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 94 46 11 80    	cmp    $0x80114694,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 47                	je     801012b0 <iget+0x90>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 94 46 11 80    	cmp    $0x80114694,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 4d                	je     801012d1 <iget+0xb1>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101284:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101286:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101289:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101290:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101297:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
8010129e:	e8 5d 46 00 00       	call   80105900 <release>

  return ip;
}
801012a3:	83 c4 2c             	add    $0x2c,%esp
801012a6:	89 f0                	mov    %esi,%eax
801012a8:	5b                   	pop    %ebx
801012a9:	5e                   	pop    %esi
801012aa:	5f                   	pop    %edi
801012ab:	5d                   	pop    %ebp
801012ac:	c3                   	ret    
801012ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801012b3:	75 b4                	jne    80101269 <iget+0x49>
      ip->ref++;
801012b5:	41                   	inc    %ecx
      return ip;
801012b6:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012b8:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
      ip->ref++;
801012bf:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012c2:	e8 39 46 00 00       	call   80105900 <release>
}
801012c7:	83 c4 2c             	add    $0x2c,%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
    panic("iget: no inodes");
801012d1:	c7 04 24 c9 85 10 80 	movl   $0x801085c9,(%esp)
801012d8:	e8 93 f0 ff ff       	call   80100370 <panic>
801012dd:	8d 76 00             	lea    0x0(%esi),%esi

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	83 ec 38             	sub    $0x38,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012e6:	83 fa 0b             	cmp    $0xb,%edx
{
801012e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
801012ec:	89 c6                	mov    %eax,%esi
801012ee:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801012f1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(bn < NDIRECT){
801012f4:	77 1a                	ja     80101310 <bmap+0x30>
801012f6:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801012f9:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801012fc:	85 db                	test   %ebx,%ebx
801012fe:	74 70                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
80101300:	89 d8                	mov    %ebx,%eax
80101302:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101305:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101308:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010130b:	89 ec                	mov    %ebp,%esp
8010130d:	5d                   	pop    %ebp
8010130e:	c3                   	ret    
8010130f:	90                   	nop
  bn -= NDIRECT;
80101310:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
80101313:	83 fb 7f             	cmp    $0x7f,%ebx
80101316:	0f 87 85 00 00 00    	ja     801013a1 <bmap+0xc1>
    if((addr = ip->addrs[NDIRECT]) == 0)
8010131c:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101322:	8b 00                	mov    (%eax),%eax
80101324:	85 d2                	test   %edx,%edx
80101326:	74 68                	je     80101390 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101328:	89 54 24 04          	mov    %edx,0x4(%esp)
8010132c:	89 04 24             	mov    %eax,(%esp)
8010132f:	e8 9c ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101334:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101338:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010133a:	8b 1a                	mov    (%edx),%ebx
8010133c:	85 db                	test   %ebx,%ebx
8010133e:	75 19                	jne    80101359 <bmap+0x79>
      a[bn] = addr = balloc(ip->dev);
80101340:	8b 06                	mov    (%esi),%eax
80101342:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101345:	e8 c6 fd ff ff       	call   80101110 <balloc>
8010134a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010134d:	89 02                	mov    %eax,(%edx)
8010134f:	89 c3                	mov    %eax,%ebx
      log_write(bp);
80101351:	89 3c 24             	mov    %edi,(%esp)
80101354:	e8 87 1b 00 00       	call   80102ee0 <log_write>
    brelse(bp);
80101359:	89 3c 24             	mov    %edi,(%esp)
8010135c:	e8 7f ee ff ff       	call   801001e0 <brelse>
}
80101361:	89 d8                	mov    %ebx,%eax
80101363:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101366:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101369:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010136c:	89 ec                	mov    %ebp,%esp
8010136e:	5d                   	pop    %ebp
8010136f:	c3                   	ret    
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 00                	mov    (%eax),%eax
80101372:	e8 99 fd ff ff       	call   80101110 <balloc>
80101377:	89 47 5c             	mov    %eax,0x5c(%edi)
8010137a:	89 c3                	mov    %eax,%ebx
}
8010137c:	89 d8                	mov    %ebx,%eax
8010137e:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101381:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101384:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101387:	89 ec                	mov    %ebp,%esp
80101389:	5d                   	pop    %ebp
8010138a:	c3                   	ret    
8010138b:	90                   	nop
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101390:	e8 7b fd ff ff       	call   80101110 <balloc>
80101395:	89 c2                	mov    %eax,%edx
80101397:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010139d:	8b 06                	mov    (%esi),%eax
8010139f:	eb 87                	jmp    80101328 <bmap+0x48>
  panic("bmap: out of range");
801013a1:	c7 04 24 d9 85 10 80 	movl   $0x801085d9,(%esp)
801013a8:	e8 c3 ef ff ff       	call   80100370 <panic>
801013ad:	8d 76 00             	lea    0x0(%esi),%esi

801013b0 <getExecCommandName.part.5>:
    return 0;
  }
  return ip;
}

char* getExecCommandName(char* path){
801013b0:	55                   	push   %ebp
  if(*path != '/'){
    return path;
  }

  while (*path != '\0')
801013b1:	80 38 00             	cmpb   $0x0,(%eax)
char* getExecCommandName(char* path){
801013b4:	89 e5                	mov    %esp,%ebp
  while (*path != '\0')
801013b6:	74 1a                	je     801013d2 <getExecCommandName.part.5+0x22>
801013b8:	90                   	nop
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    path++;
801013c0:	40                   	inc    %eax
  while (*path != '\0')
801013c1:	80 38 00             	cmpb   $0x0,(%eax)
801013c4:	75 fa                	jne    801013c0 <getExecCommandName.part.5+0x10>
  while (*path != '/')
801013c6:	80 78 ff 2f          	cmpb   $0x2f,-0x1(%eax)
    path--;
801013ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  while (*path != '/')
801013cd:	74 0c                	je     801013db <getExecCommandName.part.5+0x2b>
801013cf:	90                   	nop
801013d0:	89 d0                	mov    %edx,%eax
801013d2:	80 78 ff 2f          	cmpb   $0x2f,-0x1(%eax)
    path--;
801013d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  while (*path != '/')
801013d9:	75 f5                	jne    801013d0 <getExecCommandName.part.5+0x20>

  path++;
  return path;
}
801013db:	5d                   	pop    %ebp
801013dc:	c3                   	ret    
801013dd:	8d 76 00             	lea    0x0(%esi),%esi

801013e0 <readsb>:
{
801013e0:	55                   	push   %ebp
  bp = bread(dev, 1);
801013e1:	b8 01 00 00 00       	mov    $0x1,%eax
{
801013e6:	89 e5                	mov    %esp,%ebp
801013e8:	83 ec 18             	sub    $0x18,%esp
  bp = bread(dev, 1);
801013eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ef:	8b 45 08             	mov    0x8(%ebp),%eax
{
801013f2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801013f5:	89 75 fc             	mov    %esi,-0x4(%ebp)
801013f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013fb:	89 04 24             	mov    %eax,(%esp)
801013fe:	e8 cd ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101403:	ba 1c 00 00 00       	mov    $0x1c,%edx
80101408:	89 34 24             	mov    %esi,(%esp)
8010140b:	89 54 24 08          	mov    %edx,0x8(%esp)
  bp = bread(dev, 1);
8010140f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101411:	8d 40 5c             	lea    0x5c(%eax),%eax
80101414:	89 44 24 04          	mov    %eax,0x4(%esp)
80101418:	e8 f3 45 00 00       	call   80105a10 <memmove>
}
8010141d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  brelse(bp);
80101420:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101423:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80101426:	89 ec                	mov    %ebp,%esp
80101428:	5d                   	pop    %ebp
  brelse(bp);
80101429:	e9 b2 ed ff ff       	jmp    801001e0 <brelse>
8010142e:	66 90                	xchg   %ax,%ax

80101430 <bfree>:
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	56                   	push   %esi
80101434:	89 c6                	mov    %eax,%esi
80101436:	53                   	push   %ebx
80101437:	89 d3                	mov    %edx,%ebx
80101439:	83 ec 10             	sub    $0x10,%esp
  readsb(dev, &sb);
8010143c:	ba 20 2a 11 80       	mov    $0x80112a20,%edx
80101441:	89 54 24 04          	mov    %edx,0x4(%esp)
80101445:	89 04 24             	mov    %eax,(%esp)
80101448:	e8 93 ff ff ff       	call   801013e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010144d:	8b 0d 38 2a 11 80    	mov    0x80112a38,%ecx
80101453:	89 da                	mov    %ebx,%edx
80101455:	c1 ea 0c             	shr    $0xc,%edx
80101458:	89 34 24             	mov    %esi,(%esp)
8010145b:	01 ca                	add    %ecx,%edx
8010145d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101466:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101468:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010146b:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010146e:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101474:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101476:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
8010147b:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
  m = 1 << (bi % 8);
80101480:	d3 e0                	shl    %cl,%eax
80101482:	89 c1                	mov    %eax,%ecx
  if((bp->data[bi/8] & m) == 0)
80101484:	85 c2                	test   %eax,%edx
80101486:	74 1f                	je     801014a7 <bfree+0x77>
  bp->data[bi/8] &= ~m;
80101488:	f6 d1                	not    %cl
8010148a:	20 d1                	and    %dl,%cl
8010148c:	88 4c 1e 5c          	mov    %cl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101490:	89 34 24             	mov    %esi,(%esp)
80101493:	e8 48 1a 00 00       	call   80102ee0 <log_write>
  brelse(bp);
80101498:	89 34 24             	mov    %esi,(%esp)
8010149b:	e8 40 ed ff ff       	call   801001e0 <brelse>
}
801014a0:	83 c4 10             	add    $0x10,%esp
801014a3:	5b                   	pop    %ebx
801014a4:	5e                   	pop    %esi
801014a5:	5d                   	pop    %ebp
801014a6:	c3                   	ret    
    panic("freeing free block");
801014a7:	c7 04 24 ec 85 10 80 	movl   $0x801085ec,(%esp)
801014ae:	e8 bd ee ff ff       	call   80100370 <panic>
801014b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
  initlock(&icache.lock, "icache");
801014c1:	b9 ff 85 10 80       	mov    $0x801085ff,%ecx
{
801014c6:	89 e5                	mov    %esp,%ebp
801014c8:	53                   	push   %ebx
801014c9:	bb 80 2a 11 80       	mov    $0x80112a80,%ebx
801014ce:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
801014d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801014d5:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
801014dc:	e8 2f 42 00 00       	call   80105710 <initlock>
801014e1:	eb 0d                	jmp    801014f0 <iinit+0x30>
801014e3:	90                   	nop
801014e4:	90                   	nop
801014e5:	90                   	nop
801014e6:	90                   	nop
801014e7:	90                   	nop
801014e8:	90                   	nop
801014e9:	90                   	nop
801014ea:	90                   	nop
801014eb:	90                   	nop
801014ec:	90                   	nop
801014ed:	90                   	nop
801014ee:	90                   	nop
801014ef:	90                   	nop
    initsleeplock(&icache.inode[i].lock, "inode");
801014f0:	ba 06 86 10 80       	mov    $0x80108606,%edx
801014f5:	89 1c 24             	mov    %ebx,(%esp)
801014f8:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101502:	e8 d9 40 00 00       	call   801055e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101507:	81 fb a0 46 11 80    	cmp    $0x801146a0,%ebx
8010150d:	75 e1                	jne    801014f0 <iinit+0x30>
  readsb(dev, &sb);
8010150f:	b8 20 2a 11 80       	mov    $0x80112a20,%eax
80101514:	89 44 24 04          	mov    %eax,0x4(%esp)
80101518:	8b 45 08             	mov    0x8(%ebp),%eax
8010151b:	89 04 24             	mov    %eax,(%esp)
8010151e:	e8 bd fe ff ff       	call   801013e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101523:	a1 38 2a 11 80       	mov    0x80112a38,%eax
80101528:	c7 04 24 7c 86 10 80 	movl   $0x8010867c,(%esp)
8010152f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101533:	a1 34 2a 11 80       	mov    0x80112a34,%eax
80101538:	89 44 24 18          	mov    %eax,0x18(%esp)
8010153c:	a1 30 2a 11 80       	mov    0x80112a30,%eax
80101541:	89 44 24 14          	mov    %eax,0x14(%esp)
80101545:	a1 2c 2a 11 80       	mov    0x80112a2c,%eax
8010154a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010154e:	a1 28 2a 11 80       	mov    0x80112a28,%eax
80101553:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101557:	a1 24 2a 11 80       	mov    0x80112a24,%eax
8010155c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101560:	a1 20 2a 11 80       	mov    0x80112a20,%eax
80101565:	89 44 24 04          	mov    %eax,0x4(%esp)
80101569:	e8 e2 f0 ff ff       	call   80100650 <cprintf>
}
8010156e:	83 c4 24             	add    $0x24,%esp
80101571:	5b                   	pop    %ebx
80101572:	5d                   	pop    %ebp
80101573:	c3                   	ret    
80101574:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010157a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101580 <ialloc>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	53                   	push   %ebx
80101586:	83 ec 2c             	sub    $0x2c,%esp
80101589:	0f bf 45 0c          	movswl 0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010158d:	83 3d 28 2a 11 80 01 	cmpl   $0x1,0x80112a28
{
80101594:	8b 75 08             	mov    0x8(%ebp),%esi
80101597:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010159a:	0f 86 91 00 00 00    	jbe    80101631 <ialloc+0xb1>
801015a0:	bb 01 00 00 00       	mov    $0x1,%ebx
801015a5:	eb 1a                	jmp    801015c1 <ialloc+0x41>
801015a7:	89 f6                	mov    %esi,%esi
801015a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015b0:	89 3c 24             	mov    %edi,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015b3:	43                   	inc    %ebx
    brelse(bp);
801015b4:	e8 27 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015b9:	39 1d 28 2a 11 80    	cmp    %ebx,0x80112a28
801015bf:	76 70                	jbe    80101631 <ialloc+0xb1>
    bp = bread(dev, IBLOCK(inum, sb));
801015c1:	8b 0d 34 2a 11 80    	mov    0x80112a34,%ecx
801015c7:	89 d8                	mov    %ebx,%eax
801015c9:	c1 e8 03             	shr    $0x3,%eax
801015cc:	89 34 24             	mov    %esi,(%esp)
801015cf:	01 c8                	add    %ecx,%eax
801015d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801015d5:	e8 f6 ea ff ff       	call   801000d0 <bread>
801015da:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015dc:	89 d8                	mov    %ebx,%eax
801015de:	83 e0 07             	and    $0x7,%eax
801015e1:	c1 e0 06             	shl    $0x6,%eax
801015e4:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015e8:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015ec:	75 c2                	jne    801015b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015ee:	31 d2                	xor    %edx,%edx
801015f0:	b8 40 00 00 00       	mov    $0x40,%eax
801015f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801015f9:	89 0c 24             	mov    %ecx,(%esp)
801015fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80101600:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101603:	e8 48 43 00 00       	call   80105950 <memset>
      dip->type = type;
80101608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010160b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010160e:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101611:	89 3c 24             	mov    %edi,(%esp)
80101614:	e8 c7 18 00 00       	call   80102ee0 <log_write>
      brelse(bp);
80101619:	89 3c 24             	mov    %edi,(%esp)
8010161c:	e8 bf eb ff ff       	call   801001e0 <brelse>
}
80101621:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
80101624:	89 da                	mov    %ebx,%edx
}
80101626:	5b                   	pop    %ebx
      return iget(dev, inum);
80101627:	89 f0                	mov    %esi,%eax
}
80101629:	5e                   	pop    %esi
8010162a:	5f                   	pop    %edi
8010162b:	5d                   	pop    %ebp
      return iget(dev, inum);
8010162c:	e9 ef fb ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
80101631:	c7 04 24 0c 86 10 80 	movl   $0x8010860c,(%esp)
80101638:	e8 33 ed ff ff       	call   80100370 <panic>
8010163d:	8d 76 00             	lea    0x0(%esi),%esi

80101640 <iupdate>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	83 ec 10             	sub    $0x10,%esp
80101648:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010164b:	8b 15 34 2a 11 80    	mov    0x80112a34,%edx
80101651:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101654:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101657:	c1 e8 03             	shr    $0x3,%eax
8010165a:	01 d0                	add    %edx,%eax
8010165c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101660:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101663:	89 04 24             	mov    %eax,(%esp)
80101666:	e8 65 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
8010166b:	0f bf 53 f4          	movswl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166f:	b9 34 00 00 00       	mov    $0x34,%ecx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101674:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101676:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101679:	83 e0 07             	and    $0x7,%eax
8010167c:	c1 e0 06             	shl    $0x6,%eax
8010167f:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101683:	66 89 10             	mov    %dx,(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101686:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101689:	0f bf 53 f6          	movswl -0xa(%ebx),%edx
8010168d:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101691:	0f bf 53 f8          	movswl -0x8(%ebx),%edx
80101695:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101699:	0f bf 53 fa          	movswl -0x6(%ebx),%edx
8010169d:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016a1:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016a4:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801016ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801016af:	89 04 24             	mov    %eax,(%esp)
801016b2:	e8 59 43 00 00       	call   80105a10 <memmove>
  log_write(bp);
801016b7:	89 34 24             	mov    %esi,(%esp)
801016ba:	e8 21 18 00 00       	call   80102ee0 <log_write>
  brelse(bp);
801016bf:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016c2:	83 c4 10             	add    $0x10,%esp
801016c5:	5b                   	pop    %ebx
801016c6:	5e                   	pop    %esi
801016c7:	5d                   	pop    %ebp
  brelse(bp);
801016c8:	e9 13 eb ff ff       	jmp    801001e0 <brelse>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <idup>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	53                   	push   %ebx
801016d4:	83 ec 14             	sub    $0x14,%esp
801016d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016da:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
801016e1:	e8 7a 41 00 00       	call   80105860 <acquire>
  ip->ref++;
801016e6:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
801016e9:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
801016f0:	e8 0b 42 00 00       	call   80105900 <release>
}
801016f5:	83 c4 14             	add    $0x14,%esp
801016f8:	89 d8                	mov    %ebx,%eax
801016fa:	5b                   	pop    %ebx
801016fb:	5d                   	pop    %ebp
801016fc:	c3                   	ret    
801016fd:	8d 76 00             	lea    0x0(%esi),%esi

80101700 <ilock>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	83 ec 10             	sub    $0x10,%esp
80101708:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010170b:	85 db                	test   %ebx,%ebx
8010170d:	0f 84 be 00 00 00    	je     801017d1 <ilock+0xd1>
80101713:	8b 43 08             	mov    0x8(%ebx),%eax
80101716:	85 c0                	test   %eax,%eax
80101718:	0f 8e b3 00 00 00    	jle    801017d1 <ilock+0xd1>
  acquiresleep(&ip->lock);
8010171e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101721:	89 04 24             	mov    %eax,(%esp)
80101724:	e8 f7 3e 00 00       	call   80105620 <acquiresleep>
  if(ip->valid == 0){
80101729:	8b 73 4c             	mov    0x4c(%ebx),%esi
8010172c:	85 f6                	test   %esi,%esi
8010172e:	74 10                	je     80101740 <ilock+0x40>
}
80101730:	83 c4 10             	add    $0x10,%esp
80101733:	5b                   	pop    %ebx
80101734:	5e                   	pop    %esi
80101735:	5d                   	pop    %ebp
80101736:	c3                   	ret    
80101737:	89 f6                	mov    %esi,%esi
80101739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101740:	8b 43 04             	mov    0x4(%ebx),%eax
80101743:	8b 15 34 2a 11 80    	mov    0x80112a34,%edx
80101749:	c1 e8 03             	shr    $0x3,%eax
8010174c:	01 d0                	add    %edx,%eax
8010174e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101752:	8b 03                	mov    (%ebx),%eax
80101754:	89 04 24             	mov    %eax,(%esp)
80101757:	e8 74 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010175c:	b9 34 00 00 00       	mov    $0x34,%ecx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101761:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101763:	8b 43 04             	mov    0x4(%ebx),%eax
80101766:	83 e0 07             	and    $0x7,%eax
80101769:	c1 e0 06             	shl    $0x6,%eax
8010176c:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101770:	0f bf 10             	movswl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101773:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101776:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010177a:	0f bf 50 f6          	movswl -0xa(%eax),%edx
8010177e:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101782:	0f bf 50 f8          	movswl -0x8(%eax),%edx
80101786:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010178a:	0f bf 50 fa          	movswl -0x6(%eax),%edx
8010178e:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101792:	8b 50 fc             	mov    -0x4(%eax),%edx
80101795:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101798:	89 44 24 04          	mov    %eax,0x4(%esp)
8010179c:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010179f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801017a3:	89 04 24             	mov    %eax,(%esp)
801017a6:	e8 65 42 00 00       	call   80105a10 <memmove>
    brelse(bp);
801017ab:	89 34 24             	mov    %esi,(%esp)
801017ae:	e8 2d ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017b3:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017b8:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017bf:	0f 85 6b ff ff ff    	jne    80101730 <ilock+0x30>
      panic("ilock: no type");
801017c5:	c7 04 24 24 86 10 80 	movl   $0x80108624,(%esp)
801017cc:	e8 9f eb ff ff       	call   80100370 <panic>
    panic("ilock");
801017d1:	c7 04 24 1e 86 10 80 	movl   $0x8010861e,(%esp)
801017d8:	e8 93 eb ff ff       	call   80100370 <panic>
801017dd:	8d 76 00             	lea    0x0(%esi),%esi

801017e0 <iunlock>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	83 ec 18             	sub    $0x18,%esp
801017e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801017e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801017ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017ef:	85 db                	test   %ebx,%ebx
801017f1:	74 27                	je     8010181a <iunlock+0x3a>
801017f3:	8d 73 0c             	lea    0xc(%ebx),%esi
801017f6:	89 34 24             	mov    %esi,(%esp)
801017f9:	e8 c2 3e 00 00       	call   801056c0 <holdingsleep>
801017fe:	85 c0                	test   %eax,%eax
80101800:	74 18                	je     8010181a <iunlock+0x3a>
80101802:	8b 43 08             	mov    0x8(%ebx),%eax
80101805:	85 c0                	test   %eax,%eax
80101807:	7e 11                	jle    8010181a <iunlock+0x3a>
  releasesleep(&ip->lock);
80101809:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010180c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010180f:	8b 75 fc             	mov    -0x4(%ebp),%esi
80101812:	89 ec                	mov    %ebp,%esp
80101814:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101815:	e9 66 3e 00 00       	jmp    80105680 <releasesleep>
    panic("iunlock");
8010181a:	c7 04 24 33 86 10 80 	movl   $0x80108633,(%esp)
80101821:	e8 4a eb ff ff       	call   80100370 <panic>
80101826:	8d 76 00             	lea    0x0(%esi),%esi
80101829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101830 <iput>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	83 ec 38             	sub    $0x38,%esp
80101836:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101839:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010183c:	89 7d fc             	mov    %edi,-0x4(%ebp)
8010183f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquiresleep(&ip->lock);
80101842:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101845:	89 3c 24             	mov    %edi,(%esp)
80101848:	e8 d3 3d 00 00       	call   80105620 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010184d:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101850:	85 d2                	test   %edx,%edx
80101852:	74 07                	je     8010185b <iput+0x2b>
80101854:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101859:	74 35                	je     80101890 <iput+0x60>
  releasesleep(&ip->lock);
8010185b:	89 3c 24             	mov    %edi,(%esp)
8010185e:	e8 1d 3e 00 00       	call   80105680 <releasesleep>
  acquire(&icache.lock);
80101863:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
8010186a:	e8 f1 3f 00 00       	call   80105860 <acquire>
  ip->ref--;
8010186f:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
80101872:	c7 45 08 40 2a 11 80 	movl   $0x80112a40,0x8(%ebp)
}
80101879:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010187c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010187f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101882:	89 ec                	mov    %ebp,%esp
80101884:	5d                   	pop    %ebp
  release(&icache.lock);
80101885:	e9 76 40 00 00       	jmp    80105900 <release>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101890:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
80101897:	e8 c4 3f 00 00       	call   80105860 <acquire>
    int r = ip->ref;
8010189c:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
8010189f:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
801018a6:	e8 55 40 00 00       	call   80105900 <release>
    if(r == 1){
801018ab:	4e                   	dec    %esi
801018ac:	75 ad                	jne    8010185b <iput+0x2b>
801018ae:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018b4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018b7:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018ba:	89 cf                	mov    %ecx,%edi
801018bc:	eb 09                	jmp    801018c7 <iput+0x97>
801018be:	66 90                	xchg   %ax,%ax
801018c0:	83 c6 04             	add    $0x4,%esi
  for(i = 0; i < NDIRECT; i++){
801018c3:	39 fe                	cmp    %edi,%esi
801018c5:	74 19                	je     801018e0 <iput+0xb0>
    if(ip->addrs[i]){
801018c7:	8b 16                	mov    (%esi),%edx
801018c9:	85 d2                	test   %edx,%edx
801018cb:	74 f3                	je     801018c0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018cd:	8b 03                	mov    (%ebx),%eax
801018cf:	e8 5c fb ff ff       	call   80101430 <bfree>
      ip->addrs[i] = 0;
801018d4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018da:	eb e4                	jmp    801018c0 <iput+0x90>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(ip->addrs[NDIRECT]){
801018e0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018e9:	85 c0                	test   %eax,%eax
801018eb:	75 33                	jne    80101920 <iput+0xf0>
  ip->size = 0;
801018ed:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018f4:	89 1c 24             	mov    %ebx,(%esp)
801018f7:	e8 44 fd ff ff       	call   80101640 <iupdate>
      ip->type = 0;
801018fc:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101902:	89 1c 24             	mov    %ebx,(%esp)
80101905:	e8 36 fd ff ff       	call   80101640 <iupdate>
      ip->valid = 0;
8010190a:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101911:	e9 45 ff ff ff       	jmp    8010185b <iput+0x2b>
80101916:	8d 76 00             	lea    0x0(%esi),%esi
80101919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101920:	89 44 24 04          	mov    %eax,0x4(%esp)
80101924:	8b 03                	mov    (%ebx),%eax
80101926:	89 04 24             	mov    %eax,(%esp)
80101929:	e8 a2 e7 ff ff       	call   801000d0 <bread>
8010192e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101931:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101937:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010193a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010193d:	89 cf                	mov    %ecx,%edi
8010193f:	eb 0e                	jmp    8010194f <iput+0x11f>
80101941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101948:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010194b:	39 fe                	cmp    %edi,%esi
8010194d:	74 0f                	je     8010195e <iput+0x12e>
      if(a[j])
8010194f:	8b 16                	mov    (%esi),%edx
80101951:	85 d2                	test   %edx,%edx
80101953:	74 f3                	je     80101948 <iput+0x118>
        bfree(ip->dev, a[j]);
80101955:	8b 03                	mov    (%ebx),%eax
80101957:	e8 d4 fa ff ff       	call   80101430 <bfree>
8010195c:	eb ea                	jmp    80101948 <iput+0x118>
    brelse(bp);
8010195e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101961:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101964:	89 04 24             	mov    %eax,(%esp)
80101967:	e8 74 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010196c:	8b 03                	mov    (%ebx),%eax
8010196e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101974:	e8 b7 fa ff ff       	call   80101430 <bfree>
    ip->addrs[NDIRECT] = 0;
80101979:	31 c0                	xor    %eax,%eax
8010197b:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101981:	e9 67 ff ff ff       	jmp    801018ed <iput+0xbd>
80101986:	8d 76 00             	lea    0x0(%esi),%esi
80101989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101990 <iunlockput>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	53                   	push   %ebx
80101994:	83 ec 14             	sub    $0x14,%esp
80101997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010199a:	89 1c 24             	mov    %ebx,(%esp)
8010199d:	e8 3e fe ff ff       	call   801017e0 <iunlock>
  iput(ip);
801019a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801019a5:	83 c4 14             	add    $0x14,%esp
801019a8:	5b                   	pop    %ebx
801019a9:	5d                   	pop    %ebp
  iput(ip);
801019aa:	e9 81 fe ff ff       	jmp    80101830 <iput>
801019af:	90                   	nop

801019b0 <stati>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	8b 55 08             	mov    0x8(%ebp),%edx
801019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019b9:	8b 0a                	mov    (%edx),%ecx
801019bb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019be:	8b 4a 04             	mov    0x4(%edx),%ecx
801019c1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019c4:	0f bf 4a 50          	movswl 0x50(%edx),%ecx
801019c8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019cb:	0f bf 4a 56          	movswl 0x56(%edx),%ecx
801019cf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019d3:	8b 52 58             	mov    0x58(%edx),%edx
801019d6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019d9:	5d                   	pop    %ebp
801019da:	c3                   	ret    
801019db:	90                   	nop
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019e0 <readi>:
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 3c             	sub    $0x3c,%esp
801019e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019ec:	8b 7d 08             	mov    0x8(%ebp),%edi
801019ef:	8b 75 10             	mov    0x10(%ebp),%esi
801019f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
801019f5:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
801019f8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
801019fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a00:	0f 84 ca 00 00 00    	je     80101ad0 <readi+0xf0>
  if(off > ip->size || off + n < off)
80101a06:	8b 47 58             	mov    0x58(%edi),%eax
80101a09:	39 c6                	cmp    %eax,%esi
80101a0b:	0f 87 e3 00 00 00    	ja     80101af4 <readi+0x114>
80101a11:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101a14:	01 f2                	add    %esi,%edx
80101a16:	0f 82 d8 00 00 00    	jb     80101af4 <readi+0x114>
  if(off + n > ip->size)
80101a1c:	39 d0                	cmp    %edx,%eax
80101a1e:	0f 82 9c 00 00 00    	jb     80101ac0 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a27:	85 c0                	test   %eax,%eax
80101a29:	0f 84 86 00 00 00    	je     80101ab5 <readi+0xd5>
80101a2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a36:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80101a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a40:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80101a43:	89 f2                	mov    %esi,%edx
80101a45:	c1 ea 09             	shr    $0x9,%edx
80101a48:	89 f8                	mov    %edi,%eax
80101a4a:	e8 91 f8 ff ff       	call   801012e0 <bmap>
80101a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a53:	8b 07                	mov    (%edi),%eax
80101a55:	89 04 24             	mov    %eax,(%esp)
80101a58:	e8 73 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a5d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a60:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a68:	29 df                	sub    %ebx,%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a6a:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6c:	89 f0                	mov    %esi,%eax
80101a6e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a73:	89 fb                	mov    %edi,%ebx
80101a75:	29 c1                	sub    %eax,%ecx
80101a77:	39 f9                	cmp    %edi,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a79:	8b 7d dc             	mov    -0x24(%ebp),%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7c:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a7f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a83:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a85:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101a89:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a8d:	89 3c 24             	mov    %edi,(%esp)
80101a90:	89 55 d8             	mov    %edx,-0x28(%ebp)
80101a93:	e8 78 3f 00 00       	call   80105a10 <memmove>
    brelse(bp);
80101a98:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101a9b:	89 14 24             	mov    %edx,(%esp)
80101a9e:	e8 3d e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa3:	89 f9                	mov    %edi,%ecx
80101aa5:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101aa8:	01 d9                	add    %ebx,%ecx
80101aaa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101aad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ab0:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ab3:	77 8b                	ja     80101a40 <readi+0x60>
  return n;
80101ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ab8:	83 c4 3c             	add    $0x3c,%esp
80101abb:	5b                   	pop    %ebx
80101abc:	5e                   	pop    %esi
80101abd:	5f                   	pop    %edi
80101abe:	5d                   	pop    %ebp
80101abf:	c3                   	ret    
    n = ip->size - off;
80101ac0:	29 f0                	sub    %esi,%eax
80101ac2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101ac5:	e9 5a ff ff ff       	jmp    80101a24 <readi+0x44>
80101aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 1a                	ja     80101af4 <readi+0x114>
80101ada:	8b 04 c5 c0 29 11 80 	mov    -0x7feed640(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0f                	je     80101af4 <readi+0x114>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101ae8:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101aeb:	83 c4 3c             	add    $0x3c,%esp
80101aee:	5b                   	pop    %ebx
80101aef:	5e                   	pop    %esi
80101af0:	5f                   	pop    %edi
80101af1:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101af2:	ff e0                	jmp    *%eax
      return -1;
80101af4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af9:	eb bd                	jmp    80101ab8 <readi+0xd8>
80101afb:	90                   	nop
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b00 <writei>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 2c             	sub    $0x2c,%esp
80101b09:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b0c:	8b 7d 08             	mov    0x8(%ebp),%edi
80101b0f:	8b 75 10             	mov    0x10(%ebp),%esi
80101b12:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b15:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b18:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
80101b1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(ip->type == T_DEV){
80101b20:	0f 84 da 00 00 00    	je     80101c00 <writei+0x100>
  if(off > ip->size || off + n < off)
80101b26:	39 77 58             	cmp    %esi,0x58(%edi)
80101b29:	0f 82 09 01 00 00    	jb     80101c38 <writei+0x138>
80101b2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b32:	31 d2                	xor    %edx,%edx
80101b34:	01 f0                	add    %esi,%eax
80101b36:	0f 82 03 01 00 00    	jb     80101c3f <writei+0x13f>
  if(off + n > MAXFILE*BSIZE)
80101b3c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b41:	0f 87 f1 00 00 00    	ja     80101c38 <writei+0x138>
80101b47:	85 d2                	test   %edx,%edx
80101b49:	0f 85 e9 00 00 00    	jne    80101c38 <writei+0x138>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b4f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101b52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b59:	85 c9                	test   %ecx,%ecx
80101b5b:	0f 84 8c 00 00 00    	je     80101bed <writei+0xed>
80101b61:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b73:	89 f8                	mov    %edi,%eax
80101b75:	89 da                	mov    %ebx,%edx
80101b77:	c1 ea 09             	shr    $0x9,%edx
80101b7a:	e8 61 f7 ff ff       	call   801012e0 <bmap>
80101b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b83:	8b 07                	mov    (%edi),%eax
80101b85:	89 04 24             	mov    %eax,(%esp)
80101b88:	e8 43 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b90:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b95:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b98:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9a:	89 d8                	mov    %ebx,%eax
80101b9c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101b9f:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ba4:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ba6:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101baa:	29 d3                	sub    %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bac:	8b 55 d8             	mov    -0x28(%ebp),%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101baf:	39 d9                	cmp    %ebx,%ecx
80101bb1:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bb4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101bb8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bbc:	89 04 24             	mov    %eax,(%esp)
80101bbf:	e8 4c 3e 00 00       	call   80105a10 <memmove>
    log_write(bp);
80101bc4:	89 34 24             	mov    %esi,(%esp)
80101bc7:	e8 14 13 00 00       	call   80102ee0 <log_write>
    brelse(bp);
80101bcc:	89 34 24             	mov    %esi,(%esp)
80101bcf:	e8 0c e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd4:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bd7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bda:	01 5d d8             	add    %ebx,-0x28(%ebp)
80101bdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101be0:	39 4d dc             	cmp    %ecx,-0x24(%ebp)
80101be3:	77 8b                	ja     80101b70 <writei+0x70>
80101be5:	8b 75 e0             	mov    -0x20(%ebp),%esi
  if(n > 0 && off > ip->size){
80101be8:	3b 77 58             	cmp    0x58(%edi),%esi
80101beb:	77 3b                	ja     80101c28 <writei+0x128>
  return n;
80101bed:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80101bf0:	83 c4 2c             	add    $0x2c,%esp
80101bf3:	5b                   	pop    %ebx
80101bf4:	5e                   	pop    %esi
80101bf5:	5f                   	pop    %edi
80101bf6:	5d                   	pop    %ebp
80101bf7:	c3                   	ret    
80101bf8:	90                   	nop
80101bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c00:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101c04:	66 83 f8 09          	cmp    $0x9,%ax
80101c08:	77 2e                	ja     80101c38 <writei+0x138>
80101c0a:	8b 04 c5 c4 29 11 80 	mov    -0x7feed63c(,%eax,8),%eax
80101c11:	85 c0                	test   %eax,%eax
80101c13:	74 23                	je     80101c38 <writei+0x138>
    return devsw[ip->major].write(ip, src, n);
80101c15:	8b 7d dc             	mov    -0x24(%ebp),%edi
80101c18:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c1b:	83 c4 2c             	add    $0x2c,%esp
80101c1e:	5b                   	pop    %ebx
80101c1f:	5e                   	pop    %esi
80101c20:	5f                   	pop    %edi
80101c21:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c22:	ff e0                	jmp    *%eax
80101c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c28:	89 77 58             	mov    %esi,0x58(%edi)
    iupdate(ip);
80101c2b:	89 3c 24             	mov    %edi,(%esp)
80101c2e:	e8 0d fa ff ff       	call   80101640 <iupdate>
80101c33:	eb b8                	jmp    80101bed <writei+0xed>
80101c35:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
80101c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c3d:	eb b1                	jmp    80101bf0 <writei+0xf0>
80101c3f:	ba 01 00 00 00       	mov    $0x1,%edx
80101c44:	e9 f3 fe ff ff       	jmp    80101b3c <writei+0x3c>
80101c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c50 <namecmp>:
{
80101c50:	55                   	push   %ebp
  return strncmp(s, t, DIRSIZ);
80101c51:	b8 0e 00 00 00       	mov    $0xe,%eax
{
80101c56:	89 e5                	mov    %esp,%ebp
80101c58:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101c5b:	89 44 24 08          	mov    %eax,0x8(%esp)
80101c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c62:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	89 04 24             	mov    %eax,(%esp)
80101c6c:	e8 ff 3d 00 00       	call   80105a70 <strncmp>
}
80101c71:	c9                   	leave  
80101c72:	c3                   	ret    
80101c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c80 <dirlookup>:
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	83 ec 2c             	sub    $0x2c,%esp
80101c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(dp->type != T_DIR)
80101c8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c91:	0f 85 a4 00 00 00    	jne    80101d3b <dirlookup+0xbb>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c97:	8b 43 58             	mov    0x58(%ebx),%eax
80101c9a:	31 ff                	xor    %edi,%edi
80101c9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c9f:	85 c0                	test   %eax,%eax
80101ca1:	74 59                	je     80101cfc <dirlookup+0x7c>
80101ca3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cb0:	b9 10 00 00 00       	mov    $0x10,%ecx
80101cb5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101cb9:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101cbd:	89 74 24 04          	mov    %esi,0x4(%esp)
80101cc1:	89 1c 24             	mov    %ebx,(%esp)
80101cc4:	e8 17 fd ff ff       	call   801019e0 <readi>
80101cc9:	83 f8 10             	cmp    $0x10,%eax
80101ccc:	75 61                	jne    80101d2f <dirlookup+0xaf>
    if(de.inum == 0)
80101cce:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cd3:	74 1f                	je     80101cf4 <dirlookup+0x74>
  return strncmp(s, t, DIRSIZ);
80101cd5:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cd8:	ba 0e 00 00 00       	mov    $0xe,%edx
80101cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ce4:	89 54 24 08          	mov    %edx,0x8(%esp)
80101ce8:	89 04 24             	mov    %eax,(%esp)
80101ceb:	e8 80 3d 00 00       	call   80105a70 <strncmp>
    if(namecmp(name, de.name) == 0){
80101cf0:	85 c0                	test   %eax,%eax
80101cf2:	74 1c                	je     80101d10 <dirlookup+0x90>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf4:	83 c7 10             	add    $0x10,%edi
80101cf7:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cfa:	72 b4                	jb     80101cb0 <dirlookup+0x30>
}
80101cfc:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101cff:	31 c0                	xor    %eax,%eax
}
80101d01:	5b                   	pop    %ebx
80101d02:	5e                   	pop    %esi
80101d03:	5f                   	pop    %edi
80101d04:	5d                   	pop    %ebp
80101d05:	c3                   	ret    
80101d06:	8d 76 00             	lea    0x0(%esi),%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(poff)
80101d10:	8b 45 10             	mov    0x10(%ebp),%eax
80101d13:	85 c0                	test   %eax,%eax
80101d15:	74 05                	je     80101d1c <dirlookup+0x9c>
        *poff = off;
80101d17:	8b 45 10             	mov    0x10(%ebp),%eax
80101d1a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d1c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d20:	8b 03                	mov    (%ebx),%eax
80101d22:	e8 f9 f4 ff ff       	call   80101220 <iget>
}
80101d27:	83 c4 2c             	add    $0x2c,%esp
80101d2a:	5b                   	pop    %ebx
80101d2b:	5e                   	pop    %esi
80101d2c:	5f                   	pop    %edi
80101d2d:	5d                   	pop    %ebp
80101d2e:	c3                   	ret    
      panic("dirlookup read");
80101d2f:	c7 04 24 4d 86 10 80 	movl   $0x8010864d,(%esp)
80101d36:	e8 35 e6 ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
80101d3b:	c7 04 24 3b 86 10 80 	movl   $0x8010863b,(%esp)
80101d42:	e8 29 e6 ff ff       	call   80100370 <panic>
80101d47:	89 f6                	mov    %esi,%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d50 <namex>:
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	89 cf                	mov    %ecx,%edi
80101d56:	56                   	push   %esi
80101d57:	53                   	push   %ebx
80101d58:	89 c3                	mov    %eax,%ebx
80101d5a:	83 ec 2c             	sub    $0x2c,%esp
  if(*path == '/')
80101d5d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d63:	0f 84 5b 01 00 00    	je     80101ec4 <namex+0x174>
    ip = idup(myproc()->cwd);
80101d69:	e8 52 1d 00 00       	call   80103ac0 <myproc>
80101d6e:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d71:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
80101d78:	e8 e3 3a 00 00       	call   80105860 <acquire>
  ip->ref++;
80101d7d:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101d80:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
80101d87:	e8 74 3b 00 00       	call   80105900 <release>
80101d8c:	eb 03                	jmp    80101d91 <namex+0x41>
80101d8e:	66 90                	xchg   %ax,%ax
    path++;
80101d90:	43                   	inc    %ebx
  while(*path == '/')
80101d91:	0f b6 03             	movzbl (%ebx),%eax
80101d94:	3c 2f                	cmp    $0x2f,%al
80101d96:	74 f8                	je     80101d90 <namex+0x40>
  if(*path == 0)
80101d98:	84 c0                	test   %al,%al
80101d9a:	0f 84 f0 00 00 00    	je     80101e90 <namex+0x140>
  while(*path != '/' && *path != 0)
80101da0:	0f b6 03             	movzbl (%ebx),%eax
80101da3:	3c 2f                	cmp    $0x2f,%al
80101da5:	0f 84 b5 00 00 00    	je     80101e60 <namex+0x110>
80101dab:	84 c0                	test   %al,%al
80101dad:	89 da                	mov    %ebx,%edx
80101daf:	75 13                	jne    80101dc4 <namex+0x74>
80101db1:	e9 aa 00 00 00       	jmp    80101e60 <namex+0x110>
80101db6:	8d 76 00             	lea    0x0(%esi),%esi
80101db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101dc0:	84 c0                	test   %al,%al
80101dc2:	74 08                	je     80101dcc <namex+0x7c>
    path++;
80101dc4:	42                   	inc    %edx
  while(*path != '/' && *path != 0)
80101dc5:	0f b6 02             	movzbl (%edx),%eax
80101dc8:	3c 2f                	cmp    $0x2f,%al
80101dca:	75 f4                	jne    80101dc0 <namex+0x70>
80101dcc:	89 d1                	mov    %edx,%ecx
80101dce:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101dd0:	83 f9 0d             	cmp    $0xd,%ecx
80101dd3:	0f 8e 8b 00 00 00    	jle    80101e64 <namex+0x114>
    memmove(name, s, DIRSIZ);
80101dd9:	b8 0e 00 00 00       	mov    $0xe,%eax
80101dde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101de2:	89 44 24 08          	mov    %eax,0x8(%esp)
80101de6:	89 3c 24             	mov    %edi,(%esp)
80101de9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101dec:	e8 1f 3c 00 00       	call   80105a10 <memmove>
    path++;
80101df1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101df4:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101df6:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101df9:	75 0b                	jne    80101e06 <namex+0xb6>
80101dfb:	90                   	nop
80101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e00:	43                   	inc    %ebx
  while(*path == '/')
80101e01:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e04:	74 fa                	je     80101e00 <namex+0xb0>
    ilock(ip);
80101e06:	89 34 24             	mov    %esi,(%esp)
80101e09:	e8 f2 f8 ff ff       	call   80101700 <ilock>
    if(ip->type != T_DIR){
80101e0e:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e13:	0f 85 8f 00 00 00    	jne    80101ea8 <namex+0x158>
    if(nameiparent && *path == '\0'){
80101e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e1c:	85 c0                	test   %eax,%eax
80101e1e:	74 09                	je     80101e29 <namex+0xd9>
80101e20:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e23:	0f 84 b1 00 00 00    	je     80101eda <namex+0x18a>
    if((next = dirlookup(ip, name, 0)) == 0){
80101e29:	31 c9                	xor    %ecx,%ecx
80101e2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101e2f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101e33:	89 34 24             	mov    %esi,(%esp)
80101e36:	e8 45 fe ff ff       	call   80101c80 <dirlookup>
80101e3b:	85 c0                	test   %eax,%eax
80101e3d:	74 69                	je     80101ea8 <namex+0x158>
  iunlock(ip);
80101e3f:	89 34 24             	mov    %esi,(%esp)
80101e42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e45:	e8 96 f9 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101e4a:	89 34 24             	mov    %esi,(%esp)
80101e4d:	e8 de f9 ff ff       	call   80101830 <iput>
80101e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e55:	89 c6                	mov    %eax,%esi
80101e57:	e9 35 ff ff ff       	jmp    80101d91 <namex+0x41>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e60:	89 da                	mov    %ebx,%edx
80101e62:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e64:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101e68:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e6c:	89 3c 24             	mov    %edi,(%esp)
80101e6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e72:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e75:	e8 96 3b 00 00       	call   80105a10 <memmove>
    name[len] = 0;
80101e7a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e80:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e84:	89 d3                	mov    %edx,%ebx
80101e86:	e9 6b ff ff ff       	jmp    80101df6 <namex+0xa6>
80101e8b:	90                   	nop
80101e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(nameiparent){
80101e90:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e93:	85 d2                	test   %edx,%edx
80101e95:	75 55                	jne    80101eec <namex+0x19c>
}
80101e97:	83 c4 2c             	add    $0x2c,%esp
80101e9a:	89 f0                	mov    %esi,%eax
80101e9c:	5b                   	pop    %ebx
80101e9d:	5e                   	pop    %esi
80101e9e:	5f                   	pop    %edi
80101e9f:	5d                   	pop    %ebp
80101ea0:	c3                   	ret    
80101ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ea8:	89 34 24             	mov    %esi,(%esp)
80101eab:	e8 30 f9 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101eb0:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101eb3:	31 f6                	xor    %esi,%esi
  iput(ip);
80101eb5:	e8 76 f9 ff ff       	call   80101830 <iput>
}
80101eba:	83 c4 2c             	add    $0x2c,%esp
80101ebd:	89 f0                	mov    %esi,%eax
80101ebf:	5b                   	pop    %ebx
80101ec0:	5e                   	pop    %esi
80101ec1:	5f                   	pop    %edi
80101ec2:	5d                   	pop    %ebp
80101ec3:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101ec4:	ba 01 00 00 00       	mov    $0x1,%edx
80101ec9:	b8 01 00 00 00       	mov    $0x1,%eax
80101ece:	e8 4d f3 ff ff       	call   80101220 <iget>
80101ed3:	89 c6                	mov    %eax,%esi
80101ed5:	e9 b7 fe ff ff       	jmp    80101d91 <namex+0x41>
      iunlock(ip);
80101eda:	89 34 24             	mov    %esi,(%esp)
80101edd:	e8 fe f8 ff ff       	call   801017e0 <iunlock>
}
80101ee2:	83 c4 2c             	add    $0x2c,%esp
80101ee5:	89 f0                	mov    %esi,%eax
80101ee7:	5b                   	pop    %ebx
80101ee8:	5e                   	pop    %esi
80101ee9:	5f                   	pop    %edi
80101eea:	5d                   	pop    %ebp
80101eeb:	c3                   	ret    
    iput(ip);
80101eec:	89 34 24             	mov    %esi,(%esp)
    return 0;
80101eef:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ef1:	e8 3a f9 ff ff       	call   80101830 <iput>
    return 0;
80101ef6:	eb 9f                	jmp    80101e97 <namex+0x147>
80101ef8:	90                   	nop
80101ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f00 <dirlink>:
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f06:	31 db                	xor    %ebx,%ebx
{
80101f08:	83 ec 2c             	sub    $0x2c,%esp
80101f0b:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f11:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101f15:	89 3c 24             	mov    %edi,(%esp)
80101f18:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f1c:	e8 5f fd ff ff       	call   80101c80 <dirlookup>
80101f21:	85 c0                	test   %eax,%eax
80101f23:	0f 85 8e 00 00 00    	jne    80101fb7 <dirlink+0xb7>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f29:	8b 5f 58             	mov    0x58(%edi),%ebx
80101f2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f2f:	85 db                	test   %ebx,%ebx
80101f31:	74 3a                	je     80101f6d <dirlink+0x6d>
80101f33:	31 db                	xor    %ebx,%ebx
80101f35:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f38:	eb 0e                	jmp    80101f48 <dirlink+0x48>
80101f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f40:	83 c3 10             	add    $0x10,%ebx
80101f43:	3b 5f 58             	cmp    0x58(%edi),%ebx
80101f46:	73 25                	jae    80101f6d <dirlink+0x6d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f48:	b9 10 00 00 00       	mov    $0x10,%ecx
80101f4d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101f51:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101f55:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f59:	89 3c 24             	mov    %edi,(%esp)
80101f5c:	e8 7f fa ff ff       	call   801019e0 <readi>
80101f61:	83 f8 10             	cmp    $0x10,%eax
80101f64:	75 60                	jne    80101fc6 <dirlink+0xc6>
    if(de.inum == 0)
80101f66:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f6b:	75 d3                	jne    80101f40 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101f6d:	b8 0e 00 00 00       	mov    $0xe,%eax
80101f72:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f76:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f79:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f7d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f80:	89 04 24             	mov    %eax,(%esp)
80101f83:	e8 48 3b 00 00       	call   80105ad0 <strncpy>
  de.inum = inum;
80101f88:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f8b:	ba 10 00 00 00       	mov    $0x10,%edx
80101f90:	89 54 24 0c          	mov    %edx,0xc(%esp)
80101f94:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101f98:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f9c:	89 3c 24             	mov    %edi,(%esp)
  de.inum = inum;
80101f9f:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fa3:	e8 58 fb ff ff       	call   80101b00 <writei>
80101fa8:	83 f8 10             	cmp    $0x10,%eax
80101fab:	75 25                	jne    80101fd2 <dirlink+0xd2>
  return 0;
80101fad:	31 c0                	xor    %eax,%eax
}
80101faf:	83 c4 2c             	add    $0x2c,%esp
80101fb2:	5b                   	pop    %ebx
80101fb3:	5e                   	pop    %esi
80101fb4:	5f                   	pop    %edi
80101fb5:	5d                   	pop    %ebp
80101fb6:	c3                   	ret    
    iput(ip);
80101fb7:	89 04 24             	mov    %eax,(%esp)
80101fba:	e8 71 f8 ff ff       	call   80101830 <iput>
    return -1;
80101fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc4:	eb e9                	jmp    80101faf <dirlink+0xaf>
      panic("dirlink read");
80101fc6:	c7 04 24 5c 86 10 80 	movl   $0x8010865c,(%esp)
80101fcd:	e8 9e e3 ff ff       	call   80100370 <panic>
    panic("dirlink");
80101fd2:	c7 04 24 42 8f 10 80 	movl   $0x80108f42,(%esp)
80101fd9:	e8 92 e3 ff ff       	call   80100370 <panic>
80101fde:	66 90                	xchg   %ax,%ax

80101fe0 <getExecCommandName>:
char* getExecCommandName(char* path){
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  if(*path != '/'){
80101fe6:	80 38 2f             	cmpb   $0x2f,(%eax)
80101fe9:	74 05                	je     80101ff0 <getExecCommandName+0x10>
}
80101feb:	5d                   	pop    %ebp
80101fec:	c3                   	ret    
80101fed:	8d 76 00             	lea    0x0(%esi),%esi
80101ff0:	5d                   	pop    %ebp
80101ff1:	e9 ba f3 ff ff       	jmp    801013b0 <getExecCommandName.part.5>
80101ff6:	8d 76 00             	lea    0x0(%esi),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <namei_path>:



struct inode*
namei_path(char *path){
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	53                   	push   %ebx
80102004:	81 ec 14 04 00 00    	sub    $0x414,%esp
8010200a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(*path != '/'){
8010200d:	80 38 2f             	cmpb   $0x2f,(%eax)
80102010:	74 5e                	je     80102070 <namei_path+0x70>

struct inode*
namei(char *path)
{
  char name[DIRSIZ];
  return namex(path, 0, name);
80102012:	8d 9d 10 fc ff ff    	lea    -0x3f0(%ebp),%ebx
80102018:	31 d2                	xor    %edx,%edx
8010201a:	89 d9                	mov    %ebx,%ecx
8010201c:	b8 69 86 10 80       	mov    $0x80108669,%eax
80102021:	e8 2a fd ff ff       	call   80101d50 <namex>
  readi(pathInode , str , 0 , 1000);
80102026:	ba e8 03 00 00       	mov    $0x3e8,%edx
8010202b:	31 c9                	xor    %ecx,%ecx
8010202d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80102031:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80102035:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80102039:	89 04 24             	mov    %eax,(%esp)
8010203c:	e8 9f f9 ff ff       	call   801019e0 <readi>
   cprintf("im here");
80102041:	c7 04 24 6f 86 10 80 	movl   $0x8010866f,(%esp)
80102048:	e8 03 e6 ff ff       	call   80100650 <cprintf>
     if((returnedInode = namex(currPath, 0, name))){
8010204d:	8d 8d 02 fc ff ff    	lea    -0x3fe(%ebp),%ecx
80102053:	31 d2                	xor    %edx,%edx
80102055:	b8 77 86 10 80       	mov    $0x80108677,%eax
8010205a:	e8 f1 fc ff ff       	call   80101d50 <namex>
}
8010205f:	81 c4 14 04 00 00    	add    $0x414,%esp
80102065:	5b                   	pop    %ebx
80102066:	5d                   	pop    %ebp
80102067:	c3                   	ret    
80102068:	90                   	nop
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102070:	e8 3b f3 ff ff       	call   801013b0 <getExecCommandName.part.5>
80102075:	eb 9b                	jmp    80102012 <namei_path+0x12>
80102077:	89 f6                	mov    %esi,%esi
80102079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102080 <namei>:
{
80102080:	55                   	push   %ebp
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 bd fc ff ff       	call   80101d50 <namex>
}
80102093:	c9                   	leave  
80102094:	c3                   	ret    
80102095:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 9c fc ff ff       	jmp    80101d50 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	56                   	push   %esi
801020c4:	53                   	push   %ebx
801020c5:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
801020c8:	85 c0                	test   %eax,%eax
801020ca:	0f 84 a8 00 00 00    	je     80102178 <idestart+0xb8>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d0:	8b 48 08             	mov    0x8(%eax),%ecx
801020d3:	89 c6                	mov    %eax,%esi
801020d5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
801020db:	0f 87 8b 00 00 00    	ja     8010216c <idestart+0xac>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e1:	bb f7 01 00 00       	mov    $0x1f7,%ebx
801020e6:	8d 76 00             	lea    0x0(%esi),%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020f0:	89 da                	mov    %ebx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	24 c0                	and    $0xc0,%al
801020f5:	3c 40                	cmp    $0x40,%al
801020f7:	75 f7                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020f9:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020fe:	31 c0                	xor    %eax,%eax
80102100:	ee                   	out    %al,(%dx)
80102101:	b0 01                	mov    $0x1,%al
80102103:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102108:	ee                   	out    %al,(%dx)
80102109:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010210e:	88 c8                	mov    %cl,%al
80102110:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102111:	c1 f9 08             	sar    $0x8,%ecx
80102114:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102119:	89 c8                	mov    %ecx,%eax
8010211b:	ee                   	out    %al,(%dx)
8010211c:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102121:	31 c0                	xor    %eax,%eax
80102123:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102124:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102128:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010212d:	c0 e0 04             	shl    $0x4,%al
80102130:	24 10                	and    $0x10,%al
80102132:	0c e0                	or     $0xe0,%al
80102134:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102135:	f6 06 04             	testb  $0x4,(%esi)
80102138:	75 16                	jne    80102150 <idestart+0x90>
8010213a:	b0 20                	mov    $0x20,%al
8010213c:	89 da                	mov    %ebx,%edx
8010213e:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010213f:	83 c4 10             	add    $0x10,%esp
80102142:	5b                   	pop    %ebx
80102143:	5e                   	pop    %esi
80102144:	5d                   	pop    %ebp
80102145:	c3                   	ret    
80102146:	8d 76 00             	lea    0x0(%esi),%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102150:	b0 30                	mov    $0x30,%al
80102152:	89 da                	mov    %ebx,%edx
80102154:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102155:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010215a:	83 c6 5c             	add    $0x5c,%esi
8010215d:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102162:	fc                   	cld    
80102163:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102165:	83 c4 10             	add    $0x10,%esp
80102168:	5b                   	pop    %ebx
80102169:	5e                   	pop    %esi
8010216a:	5d                   	pop    %ebp
8010216b:	c3                   	ret    
    panic("incorrect blockno");
8010216c:	c7 04 24 d8 86 10 80 	movl   $0x801086d8,(%esp)
80102173:	e8 f8 e1 ff ff       	call   80100370 <panic>
    panic("idestart");
80102178:	c7 04 24 cf 86 10 80 	movl   $0x801086cf,(%esp)
8010217f:	e8 ec e1 ff ff       	call   80100370 <panic>
80102184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010218a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102190 <ideinit>:
{
80102190:	55                   	push   %ebp
  initlock(&idelock, "ide");
80102191:	ba ea 86 10 80       	mov    $0x801086ea,%edx
{
80102196:	89 e5                	mov    %esp,%ebp
80102198:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
8010219b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010219f:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
801021a6:	e8 65 35 00 00       	call   80105710 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021ab:	a1 60 4d 11 80       	mov    0x80114d60,%eax
801021b0:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801021b7:	48                   	dec    %eax
801021b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801021bc:	e8 8f 02 00 00       	call   80102450 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021c1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021c6:	8d 76 00             	lea    0x0(%esi),%esi
801021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801021d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021d1:	24 c0                	and    $0xc0,%al
801021d3:	3c 40                	cmp    $0x40,%al
801021d5:	75 f9                	jne    801021d0 <ideinit+0x40>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d7:	b0 f0                	mov    $0xf0,%al
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
801021df:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e4:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021e9:	eb 08                	jmp    801021f3 <ideinit+0x63>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
801021f0:	49                   	dec    %ecx
801021f1:	74 0f                	je     80102202 <ideinit+0x72>
801021f3:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021f4:	84 c0                	test   %al,%al
801021f6:	74 f8                	je     801021f0 <ideinit+0x60>
      havedisk1 = 1;
801021f8:	b8 01 00 00 00       	mov    $0x1,%eax
801021fd:	a3 60 c5 10 80       	mov    %eax,0x8010c560
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102202:	b0 e0                	mov    $0xe0,%al
80102204:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102209:	ee                   	out    %al,(%dx)
}
8010220a:	c9                   	leave  
8010220b:	c3                   	ret    
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102210 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102216:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
{
8010221d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80102220:	89 75 f8             	mov    %esi,-0x8(%ebp)
80102223:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&idelock);
80102226:	e8 35 36 00 00       	call   80105860 <acquire>

  if((b = idequeue) == 0){
8010222b:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102231:	85 db                	test   %ebx,%ebx
80102233:	74 5c                	je     80102291 <ideintr+0x81>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102235:	8b 43 58             	mov    0x58(%ebx),%eax
80102238:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010223d:	8b 0b                	mov    (%ebx),%ecx
8010223f:	f6 c1 04             	test   $0x4,%cl
80102242:	75 2f                	jne    80102273 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102244:	be f7 01 00 00       	mov    $0x1f7,%esi
80102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102250:	89 f2                	mov    %esi,%edx
80102252:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102253:	88 c2                	mov    %al,%dl
80102255:	80 e2 c0             	and    $0xc0,%dl
80102258:	80 fa 40             	cmp    $0x40,%dl
8010225b:	75 f3                	jne    80102250 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010225d:	a8 21                	test   $0x21,%al
8010225f:	75 12                	jne    80102273 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102261:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102264:	b9 80 00 00 00       	mov    $0x80,%ecx
80102269:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010226e:	fc                   	cld    
8010226f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102271:	8b 0b                	mov    (%ebx),%ecx

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102273:	83 e1 fb             	and    $0xfffffffb,%ecx
80102276:	83 c9 02             	or     $0x2,%ecx
80102279:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
8010227b:	89 1c 24             	mov    %ebx,(%esp)
8010227e:	e8 7d 24 00 00       	call   80104700 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102283:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102288:	85 c0                	test   %eax,%eax
8010228a:	74 05                	je     80102291 <ideintr+0x81>
    idestart(idequeue);
8010228c:	e8 2f fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
80102291:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
80102298:	e8 63 36 00 00       	call   80105900 <release>

  release(&idelock);
}
8010229d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801022a0:	8b 75 f8             	mov    -0x8(%ebp),%esi
801022a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
801022a6:	89 ec                	mov    %ebp,%esp
801022a8:	5d                   	pop    %ebp
801022a9:	c3                   	ret    
801022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	53                   	push   %ebx
801022b4:	83 ec 14             	sub    $0x14,%esp
801022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801022bd:	89 04 24             	mov    %eax,(%esp)
801022c0:	e8 fb 33 00 00       	call   801056c0 <holdingsleep>
801022c5:	85 c0                	test   %eax,%eax
801022c7:	0f 84 b6 00 00 00    	je     80102383 <iderw+0xd3>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022cd:	8b 03                	mov    (%ebx),%eax
801022cf:	83 e0 06             	and    $0x6,%eax
801022d2:	83 f8 02             	cmp    $0x2,%eax
801022d5:	0f 84 9c 00 00 00    	je     80102377 <iderw+0xc7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022db:	8b 4b 04             	mov    0x4(%ebx),%ecx
801022de:	85 c9                	test   %ecx,%ecx
801022e0:	74 0e                	je     801022f0 <iderw+0x40>
801022e2:	8b 15 60 c5 10 80    	mov    0x8010c560,%edx
801022e8:	85 d2                	test   %edx,%edx
801022ea:	0f 84 9f 00 00 00    	je     8010238f <iderw+0xdf>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022f0:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
801022f7:	e8 64 35 00 00       	call   80105860 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022fc:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
  b->qnext = 0;
80102302:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102309:	85 d2                	test   %edx,%edx
8010230b:	75 05                	jne    80102312 <iderw+0x62>
8010230d:	eb 61                	jmp    80102370 <iderw+0xc0>
8010230f:	90                   	nop
80102310:	89 c2                	mov    %eax,%edx
80102312:	8b 42 58             	mov    0x58(%edx),%eax
80102315:	85 c0                	test   %eax,%eax
80102317:	75 f7                	jne    80102310 <iderw+0x60>
80102319:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010231c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010231e:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
80102324:	75 1b                	jne    80102341 <iderw+0x91>
80102326:	eb 38                	jmp    80102360 <iderw+0xb0>
80102328:	90                   	nop
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80102330:	b8 80 c5 10 80       	mov    $0x8010c580,%eax
80102335:	89 44 24 04          	mov    %eax,0x4(%esp)
80102339:	89 1c 24             	mov    %ebx,(%esp)
8010233c:	e8 9f 21 00 00       	call   801044e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102341:	8b 03                	mov    (%ebx),%eax
80102343:	83 e0 06             	and    $0x6,%eax
80102346:	83 f8 02             	cmp    $0x2,%eax
80102349:	75 e5                	jne    80102330 <iderw+0x80>
  }


  release(&idelock);
8010234b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102352:	83 c4 14             	add    $0x14,%esp
80102355:	5b                   	pop    %ebx
80102356:	5d                   	pop    %ebp
  release(&idelock);
80102357:	e9 a4 35 00 00       	jmp    80105900 <release>
8010235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102360:	89 d8                	mov    %ebx,%eax
80102362:	e8 59 fd ff ff       	call   801020c0 <idestart>
80102367:	eb d8                	jmp    80102341 <iderw+0x91>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102370:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102375:	eb a5                	jmp    8010231c <iderw+0x6c>
    panic("iderw: nothing to do");
80102377:	c7 04 24 04 87 10 80 	movl   $0x80108704,(%esp)
8010237e:	e8 ed df ff ff       	call   80100370 <panic>
    panic("iderw: buf not locked");
80102383:	c7 04 24 ee 86 10 80 	movl   $0x801086ee,(%esp)
8010238a:	e8 e1 df ff ff       	call   80100370 <panic>
    panic("iderw: ide disk 1 not present");
8010238f:	c7 04 24 19 87 10 80 	movl   $0x80108719,(%esp)
80102396:	e8 d5 df ff ff       	call   80100370 <panic>
8010239b:	66 90                	xchg   %ax,%ax
8010239d:	66 90                	xchg   %ax,%ax
8010239f:	90                   	nop

801023a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023a0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023a1:	b8 00 00 c0 fe       	mov    $0xfec00000,%eax
{
801023a6:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801023a8:	ba 01 00 00 00       	mov    $0x1,%edx
{
801023ad:	56                   	push   %esi
801023ae:	53                   	push   %ebx
801023af:	83 ec 10             	sub    $0x10,%esp
  ioapic = (volatile struct ioapic*)IOAPIC;
801023b2:	a3 94 46 11 80       	mov    %eax,0x80114694
  ioapic->reg = reg;
801023b7:	89 15 00 00 c0 fe    	mov    %edx,0xfec00000
  return ioapic->data;
801023bd:	a1 94 46 11 80       	mov    0x80114694,%eax
801023c2:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801023c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801023cb:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023d1:	0f b6 15 c0 47 11 80 	movzbl 0x801147c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023d8:	c1 eb 10             	shr    $0x10,%ebx
801023db:	0f b6 db             	movzbl %bl,%ebx
  return ioapic->data;
801023de:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023e1:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023e4:	39 c2                	cmp    %eax,%edx
801023e6:	74 12                	je     801023fa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023e8:	c7 04 24 38 87 10 80 	movl   $0x80108738,(%esp)
801023ef:	e8 5c e2 ff ff       	call   80100650 <cprintf>
801023f4:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
801023fa:	83 c3 21             	add    $0x21,%ebx
{
801023fd:	ba 10 00 00 00       	mov    $0x10,%edx
80102402:	b8 20 00 00 00       	mov    $0x20,%eax
80102407:	89 f6                	mov    %esi,%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102410:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102412:	89 c6                	mov    %eax,%esi
80102414:	40                   	inc    %eax
  ioapic->data = data;
80102415:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010241b:	81 ce 00 00 01 00    	or     $0x10000,%esi
  ioapic->data = data;
80102421:	89 71 10             	mov    %esi,0x10(%ecx)
80102424:	8d 72 01             	lea    0x1(%edx),%esi
80102427:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010242a:	89 31                	mov    %esi,(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242c:	39 d8                	cmp    %ebx,%eax
  ioapic->data = data;
8010242e:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
80102434:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010243b:	75 d3                	jne    80102410 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010243d:	83 c4 10             	add    $0x10,%esp
80102440:	5b                   	pop    %ebx
80102441:	5e                   	pop    %esi
80102442:	5d                   	pop    %ebp
80102443:	c3                   	ret    
80102444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010244a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102450 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102450:	55                   	push   %ebp
  ioapic->reg = reg;
80102451:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
{
80102457:	89 e5                	mov    %esp,%ebp
80102459:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010245c:	8d 50 20             	lea    0x20(%eax),%edx
8010245f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102463:	89 01                	mov    %eax,(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	40                   	inc    %eax
  ioapic->data = data;
80102466:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
8010246c:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102472:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102474:	a1 94 46 11 80       	mov    0x80114694,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102479:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010247c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010247f:	5d                   	pop    %ebp
80102480:	c3                   	ret    
80102481:	66 90                	xchg   %ax,%ax
80102483:	66 90                	xchg   %ax,%ax
80102485:	66 90                	xchg   %ax,%ax
80102487:	66 90                	xchg   %ax,%ax
80102489:	66 90                	xchg   %ax,%ax
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
80102497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010249a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024a0:	0f 85 80 00 00 00    	jne    80102526 <kfree+0x96>
801024a6:	81 fb 08 7b 11 80    	cmp    $0x80117b08,%ebx
801024ac:	72 78                	jb     80102526 <kfree+0x96>
801024ae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024b4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024b9:	77 6b                	ja     80102526 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024bb:	ba 00 10 00 00       	mov    $0x1000,%edx
801024c0:	b9 01 00 00 00       	mov    $0x1,%ecx
801024c5:	89 54 24 08          	mov    %edx,0x8(%esp)
801024c9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801024cd:	89 1c 24             	mov    %ebx,(%esp)
801024d0:	e8 7b 34 00 00       	call   80105950 <memset>

  if(kmem.use_lock)
801024d5:	a1 d4 46 11 80       	mov    0x801146d4,%eax
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 3a                	jne    80102518 <kfree+0x88>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024de:	a1 d8 46 11 80       	mov    0x801146d8,%eax
801024e3:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024e5:	a1 d4 46 11 80       	mov    0x801146d4,%eax
  kmem.freelist = r;
801024ea:	89 1d d8 46 11 80    	mov    %ebx,0x801146d8
  if(kmem.use_lock)
801024f0:	85 c0                	test   %eax,%eax
801024f2:	75 0c                	jne    80102500 <kfree+0x70>
    release(&kmem.lock);
}
801024f4:	83 c4 14             	add    $0x14,%esp
801024f7:	5b                   	pop    %ebx
801024f8:	5d                   	pop    %ebp
801024f9:	c3                   	ret    
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 a0 46 11 80 	movl   $0x801146a0,0x8(%ebp)
}
80102507:	83 c4 14             	add    $0x14,%esp
8010250a:	5b                   	pop    %ebx
8010250b:	5d                   	pop    %ebp
    release(&kmem.lock);
8010250c:	e9 ef 33 00 00       	jmp    80105900 <release>
80102511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102518:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
8010251f:	e8 3c 33 00 00       	call   80105860 <acquire>
80102524:	eb b8                	jmp    801024de <kfree+0x4e>
    panic("kfree");
80102526:	c7 04 24 6a 87 10 80 	movl   $0x8010876a,(%esp)
8010252d:	e8 3e de ff ff       	call   80100370 <panic>
80102532:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102540 <freerange>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
80102545:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102548:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010254b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010254e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102554:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102560:	39 de                	cmp    %ebx,%esi
80102562:	72 24                	jb     80102588 <freerange+0x48>
80102564:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010256a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    kfree(p);
80102570:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102576:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010257c:	89 04 24             	mov    %eax,(%esp)
8010257f:	e8 0c ff ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102584:	39 f3                	cmp    %esi,%ebx
80102586:	76 e8                	jbe    80102570 <freerange+0x30>
}
80102588:	83 c4 10             	add    $0x10,%esp
8010258b:	5b                   	pop    %ebx
8010258c:	5e                   	pop    %esi
8010258d:	5d                   	pop    %ebp
8010258e:	c3                   	ret    
8010258f:	90                   	nop

80102590 <kinit1>:
{
80102590:	55                   	push   %ebp
  initlock(&kmem.lock, "kmem");
80102591:	b8 70 87 10 80       	mov    $0x80108770,%eax
{
80102596:	89 e5                	mov    %esp,%ebp
80102598:	56                   	push   %esi
80102599:	53                   	push   %ebx
8010259a:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
8010259d:	89 44 24 04          	mov    %eax,0x4(%esp)
{
801025a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025a4:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
801025ab:	e8 60 31 00 00       	call   80105710 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
801025b3:	31 d2                	xor    %edx,%edx
801025b5:	89 15 d4 46 11 80    	mov    %edx,0x801146d4
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 27                	jb     801025f8 <kinit1+0x68>
801025d1:	eb 0d                	jmp    801025e0 <kinit1+0x50>
801025d3:	90                   	nop
801025d4:	90                   	nop
801025d5:	90                   	nop
801025d6:	90                   	nop
801025d7:	90                   	nop
801025d8:	90                   	nop
801025d9:	90                   	nop
801025da:	90                   	nop
801025db:	90                   	nop
801025dc:	90                   	nop
801025dd:	90                   	nop
801025de:	90                   	nop
801025df:	90                   	nop
    kfree(p);
801025e0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025ec:	89 04 24             	mov    %eax,(%esp)
801025ef:	e8 9c fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f4:	39 de                	cmp    %ebx,%esi
801025f6:	73 e8                	jae    801025e0 <kinit1+0x50>
}
801025f8:	83 c4 10             	add    $0x10,%esp
801025fb:	5b                   	pop    %ebx
801025fc:	5e                   	pop    %esi
801025fd:	5d                   	pop    %ebp
801025fe:	c3                   	ret    
801025ff:	90                   	nop

80102600 <kinit2>:
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	56                   	push   %esi
80102604:	53                   	push   %ebx
80102605:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102608:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010260b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010260e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102614:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102620:	39 de                	cmp    %ebx,%esi
80102622:	72 24                	jb     80102648 <kinit2+0x48>
80102624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010262a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    kfree(p);
80102630:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102636:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010263c:	89 04 24             	mov    %eax,(%esp)
8010263f:	e8 4c fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102644:	39 de                	cmp    %ebx,%esi
80102646:	73 e8                	jae    80102630 <kinit2+0x30>
  kmem.use_lock = 1;
80102648:	b8 01 00 00 00       	mov    $0x1,%eax
8010264d:	a3 d4 46 11 80       	mov    %eax,0x801146d4
}
80102652:	83 c4 10             	add    $0x10,%esp
80102655:	5b                   	pop    %ebx
80102656:	5e                   	pop    %esi
80102657:	5d                   	pop    %ebp
80102658:	c3                   	ret    
80102659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102660 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102660:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102665:	85 c0                	test   %eax,%eax
80102667:	75 1f                	jne    80102688 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102669:	a1 d8 46 11 80       	mov    0x801146d8,%eax
  if(r)
8010266e:	85 c0                	test   %eax,%eax
80102670:	74 0e                	je     80102680 <kalloc+0x20>
    kmem.freelist = r->next;
80102672:	8b 10                	mov    (%eax),%edx
80102674:	89 15 d8 46 11 80    	mov    %edx,0x801146d8
8010267a:	c3                   	ret    
8010267b:	90                   	nop
8010267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102680:	c3                   	ret    
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102688:	55                   	push   %ebp
80102689:	89 e5                	mov    %esp,%ebp
8010268b:	83 ec 28             	sub    $0x28,%esp
    acquire(&kmem.lock);
8010268e:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
80102695:	e8 c6 31 00 00       	call   80105860 <acquire>
  r = kmem.freelist;
8010269a:	a1 d8 46 11 80       	mov    0x801146d8,%eax
8010269f:	8b 15 d4 46 11 80    	mov    0x801146d4,%edx
  if(r)
801026a5:	85 c0                	test   %eax,%eax
801026a7:	74 08                	je     801026b1 <kalloc+0x51>
    kmem.freelist = r->next;
801026a9:	8b 08                	mov    (%eax),%ecx
801026ab:	89 0d d8 46 11 80    	mov    %ecx,0x801146d8
  if(kmem.use_lock)
801026b1:	85 d2                	test   %edx,%edx
801026b3:	74 12                	je     801026c7 <kalloc+0x67>
    release(&kmem.lock);
801026b5:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
801026bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026bf:	e8 3c 32 00 00       	call   80105900 <release>
  return (char*)r;
801026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801026c7:	c9                   	leave  
801026c8:	c3                   	ret    
801026c9:	66 90                	xchg   %ax,%ax
801026cb:	66 90                	xchg   %ax,%ax
801026cd:	66 90                	xchg   %ax,%ax
801026cf:	90                   	nop

801026d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d0:	ba 64 00 00 00       	mov    $0x64,%edx
801026d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026d6:	24 01                	and    $0x1,%al
801026d8:	84 c0                	test   %al,%al
801026da:	0f 84 d0 00 00 00    	je     801027b0 <kbdgetc+0xe0>
{
801026e0:	55                   	push   %ebp
801026e1:	ba 60 00 00 00       	mov    $0x60,%edx
801026e6:	89 e5                	mov    %esp,%ebp
801026e8:	53                   	push   %ebx
801026e9:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026ea:	0f b6 d0             	movzbl %al,%edx
801026ed:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx

  if(data == 0xE0){
801026f3:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026f9:	0f 84 89 00 00 00    	je     80102788 <kbdgetc+0xb8>
801026ff:	89 d9                	mov    %ebx,%ecx
80102701:	83 e1 40             	and    $0x40,%ecx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102704:	84 c0                	test   %al,%al
80102706:	78 58                	js     80102760 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102708:	85 c9                	test   %ecx,%ecx
8010270a:	74 08                	je     80102714 <kbdgetc+0x44>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010270c:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
8010270e:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102711:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102714:	0f b6 8a a0 88 10 80 	movzbl -0x7fef7760(%edx),%ecx
  shift ^= togglecode[data];
8010271b:	0f b6 82 a0 87 10 80 	movzbl -0x7fef7860(%edx),%eax
  shift |= shiftcode[data];
80102722:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102724:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102726:	89 c8                	mov    %ecx,%eax
80102728:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010272b:	f6 c1 08             	test   $0x8,%cl
  c = charcode[shift & (CTL | SHIFT)][data];
8010272e:	8b 04 85 80 87 10 80 	mov    -0x7fef7880(,%eax,4),%eax
  shift ^= togglecode[data];
80102735:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010273b:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010273f:	74 40                	je     80102781 <kbdgetc+0xb1>
    if('a' <= c && c <= 'z')
80102741:	8d 50 9f             	lea    -0x61(%eax),%edx
80102744:	83 fa 19             	cmp    $0x19,%edx
80102747:	76 57                	jbe    801027a0 <kbdgetc+0xd0>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102749:	8d 50 bf             	lea    -0x41(%eax),%edx
8010274c:	83 fa 19             	cmp    $0x19,%edx
8010274f:	77 30                	ja     80102781 <kbdgetc+0xb1>
      c += 'a' - 'A';
80102751:	83 c0 20             	add    $0x20,%eax
  }
  return c;
80102754:	eb 2b                	jmp    80102781 <kbdgetc+0xb1>
80102756:	8d 76 00             	lea    0x0(%esi),%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    data = (shift & E0ESC ? data : data & 0x7F);
80102760:	85 c9                	test   %ecx,%ecx
80102762:	75 05                	jne    80102769 <kbdgetc+0x99>
80102764:	24 7f                	and    $0x7f,%al
80102766:	0f b6 d0             	movzbl %al,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102769:	0f b6 82 a0 88 10 80 	movzbl -0x7fef7760(%edx),%eax
80102770:	0c 40                	or     $0x40,%al
80102772:	0f b6 c8             	movzbl %al,%ecx
    return 0;
80102775:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102777:	f7 d1                	not    %ecx
80102779:	21 d9                	and    %ebx,%ecx
8010277b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102781:	5b                   	pop    %ebx
80102782:	5d                   	pop    %ebp
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102788:	83 cb 40             	or     $0x40,%ebx
    return 0;
8010278b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010278d:	89 1d b4 c5 10 80    	mov    %ebx,0x8010c5b4
}
80102793:	5b                   	pop    %ebx
80102794:	5d                   	pop    %ebp
80102795:	c3                   	ret    
80102796:	8d 76 00             	lea    0x0(%esi),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801027a0:	5b                   	pop    %ebx
      c += 'A' - 'a';
801027a1:	83 e8 20             	sub    $0x20,%eax
}
801027a4:	5d                   	pop    %ebp
801027a5:	c3                   	ret    
801027a6:	8d 76 00             	lea    0x0(%esi),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801027b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027b5:	c3                   	ret    
801027b6:	8d 76 00             	lea    0x0(%esi),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <kbdintr>:

void
kbdintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801027c6:	c7 04 24 d0 26 10 80 	movl   $0x801026d0,(%esp)
801027cd:	e8 fe df ff ff       	call   801007d0 <consoleintr>
}
801027d2:	c9                   	leave  
801027d3:	c3                   	ret    
801027d4:	66 90                	xchg   %ax,%ax
801027d6:	66 90                	xchg   %ax,%ax
801027d8:	66 90                	xchg   %ax,%ax
801027da:	66 90                	xchg   %ax,%ax
801027dc:	66 90                	xchg   %ax,%ax
801027de:	66 90                	xchg   %ax,%ax

801027e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027e0:	a1 dc 46 11 80       	mov    0x801146dc,%eax
{
801027e5:	55                   	push   %ebp
801027e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801027e8:	85 c0                	test   %eax,%eax
801027ea:	0f 84 c6 00 00 00    	je     801028b6 <lapicinit+0xd6>
  lapic[index] = value;
801027f0:	ba 3f 01 00 00       	mov    $0x13f,%edx
801027f5:	b9 0b 00 00 00       	mov    $0xb,%ecx
801027fa:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102800:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102803:	89 88 e0 03 00 00    	mov    %ecx,0x3e0(%eax)
80102809:	b9 80 96 98 00       	mov    $0x989680,%ecx
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	ba 20 00 02 00       	mov    $0x20020,%edx
80102816:	89 90 20 03 00 00    	mov    %edx,0x320(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281c:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281f:	89 88 80 03 00 00    	mov    %ecx,0x380(%eax)
80102825:	b9 00 00 01 00       	mov    $0x10000,%ecx
  lapic[ID];  // wait for write to finish, by reading
8010282a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282d:	ba 00 00 01 00       	mov    $0x10000,%edx
80102832:	89 90 50 03 00 00    	mov    %edx,0x350(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102838:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283b:	89 88 60 03 00 00    	mov    %ecx,0x360(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102844:	8b 50 30             	mov    0x30(%eax),%edx
80102847:	c1 ea 10             	shr    $0x10,%edx
8010284a:	80 fa 03             	cmp    $0x3,%dl
8010284d:	77 71                	ja     801028c0 <lapicinit+0xe0>
  lapic[index] = value;
8010284f:	b9 33 00 00 00       	mov    $0x33,%ecx
80102854:	89 88 70 03 00 00    	mov    %ecx,0x370(%eax)
8010285a:	31 c9                	xor    %ecx,%ecx
  lapic[ID];  // wait for write to finish, by reading
8010285c:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285f:	31 d2                	xor    %edx,%edx
80102861:	89 90 80 02 00 00    	mov    %edx,0x280(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	89 88 80 02 00 00    	mov    %ecx,0x280(%eax)
80102870:	31 c9                	xor    %ecx,%ecx
  lapic[ID];  // wait for write to finish, by reading
80102872:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102875:	31 d2                	xor    %edx,%edx
80102877:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102886:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102889:	ba 00 85 08 00       	mov    $0x88500,%edx
8010288e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102894:	8b 50 20             	mov    0x20(%eax),%edx
80102897:	89 f6                	mov    %esi,%esi
80102899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028a6:	f6 c6 10             	test   $0x10,%dh
801028a9:	75 f5                	jne    801028a0 <lapicinit+0xc0>
  lapic[index] = value;
801028ab:	31 d2                	xor    %edx,%edx
801028ad:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b3:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028b6:	5d                   	pop    %ebp
801028b7:	c3                   	ret    
801028b8:	90                   	nop
801028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028c0:	b9 00 00 01 00       	mov    $0x10000,%ecx
801028c5:	89 88 40 03 00 00    	mov    %ecx,0x340(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028cb:	8b 50 20             	mov    0x20(%eax),%edx
801028ce:	e9 7c ff ff ff       	jmp    8010284f <lapicinit+0x6f>
801028d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028e0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028e0:	a1 dc 46 11 80       	mov    0x801146dc,%eax
{
801028e5:	55                   	push   %ebp
801028e6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801028e8:	85 c0                	test   %eax,%eax
801028ea:	74 0c                	je     801028f8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ec:	8b 40 20             	mov    0x20(%eax),%eax
}
801028ef:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
801028f0:	c1 e8 18             	shr    $0x18,%eax
}
801028f3:	c3                   	ret    
801028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028f8:	31 c0                	xor    %eax,%eax
}
801028fa:	5d                   	pop    %ebp
801028fb:	c3                   	ret    
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102900:	a1 dc 46 11 80       	mov    0x801146dc,%eax
{
80102905:	55                   	push   %ebp
80102906:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102908:	85 c0                	test   %eax,%eax
8010290a:	74 0b                	je     80102917 <lapiceoi+0x17>
  lapic[index] = value;
8010290c:	31 d2                	xor    %edx,%edx
8010290e:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102917:	5d                   	pop    %ebp
80102918:	c3                   	ret    
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
}
80102923:	5d                   	pop    %ebp
80102924:	c3                   	ret    
80102925:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102930 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102930:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102931:	b0 0f                	mov    $0xf,%al
80102933:	89 e5                	mov    %esp,%ebp
80102935:	ba 70 00 00 00       	mov    $0x70,%edx
8010293a:	53                   	push   %ebx
8010293b:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
8010293f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102942:	ee                   	out    %al,(%dx)
80102943:	b0 0a                	mov    $0xa,%al
80102945:	ba 71 00 00 00       	mov    $0x71,%edx
8010294a:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010294b:	31 c0                	xor    %eax,%eax
8010294d:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102953:	89 d8                	mov    %ebx,%eax
80102955:	c1 e8 04             	shr    $0x4,%eax
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010295e:	c1 e1 18             	shl    $0x18,%ecx
  lapic[index] = value;
80102961:	a1 dc 46 11 80       	mov    0x801146dc,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102966:	c1 eb 0c             	shr    $0xc,%ebx
80102969:	81 cb 00 06 00 00    	or     $0x600,%ebx
  lapic[index] = value;
8010296f:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102975:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102978:	ba 00 c5 00 00       	mov    $0xc500,%edx
8010297d:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102986:	ba 00 85 00 00       	mov    $0x8500,%edx
8010298b:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102991:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102994:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299d:	89 98 00 03 00 00    	mov    %ebx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a6:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029af:	89 98 00 03 00 00    	mov    %ebx,0x300(%eax)
    microdelay(200);
  }
}
801029b5:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029b6:	8b 40 20             	mov    0x20(%eax),%eax
}
801029b9:	5d                   	pop    %ebp
801029ba:	c3                   	ret    
801029bb:	90                   	nop
801029bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029c0:	55                   	push   %ebp
801029c1:	b0 0b                	mov    $0xb,%al
801029c3:	89 e5                	mov    %esp,%ebp
801029c5:	ba 70 00 00 00       	mov    $0x70,%edx
801029ca:	57                   	push   %edi
801029cb:	56                   	push   %esi
801029cc:	53                   	push   %ebx
801029cd:	83 ec 5c             	sub    $0x5c,%esp
801029d0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d1:	ba 71 00 00 00       	mov    $0x71,%edx
801029d6:	ec                   	in     (%dx),%al
801029d7:	24 04                	and    $0x4,%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d9:	be 70 00 00 00       	mov    $0x70,%esi
801029de:	88 45 b2             	mov    %al,-0x4e(%ebp)
801029e1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801029e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
801029f0:	31 c0                	xor    %eax,%eax
801029f2:	89 f2                	mov    %esi,%edx
801029f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f5:	bb 71 00 00 00       	mov    $0x71,%ebx
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ec                   	in     (%dx),%al
801029fd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a00:	89 f2                	mov    %esi,%edx
80102a02:	b0 02                	mov    $0x2,%al
80102a04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a05:	89 da                	mov    %ebx,%edx
80102a07:	ec                   	in     (%dx),%al
80102a08:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0b:	89 f2                	mov    %esi,%edx
80102a0d:	b0 04                	mov    $0x4,%al
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 da                	mov    %ebx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 f2                	mov    %esi,%edx
80102a18:	b0 07                	mov    $0x7,%al
80102a1a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1b:	89 da                	mov    %ebx,%edx
80102a1d:	ec                   	in     (%dx),%al
80102a1e:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a21:	89 f2                	mov    %esi,%edx
80102a23:	b0 08                	mov    $0x8,%al
80102a25:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	ec                   	in     (%dx),%al
80102a29:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	b0 09                	mov    $0x9,%al
80102a30:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a31:	89 da                	mov    %ebx,%edx
80102a33:	ec                   	in     (%dx),%al
80102a34:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a37:	89 f2                	mov    %esi,%edx
80102a39:	b0 0a                	mov    $0xa,%al
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 da                	mov    %ebx,%edx
80102a3e:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a3f:	84 c0                	test   %al,%al
80102a41:	78 ad                	js     801029f0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a43:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a47:	89 f2                	mov    %esi,%edx
80102a49:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80102a4c:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a4f:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a53:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a56:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5a:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5d:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a61:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a64:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
80102a68:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102a6b:	31 c0                	xor    %eax,%eax
80102a6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6e:	89 da                	mov    %ebx,%edx
80102a70:	ec                   	in     (%dx),%al
80102a71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 f2                	mov    %esi,%edx
80102a76:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a79:	b0 02                	mov    $0x2,%al
80102a7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	ec                   	in     (%dx),%al
80102a7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a82:	89 f2                	mov    %esi,%edx
80102a84:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a87:	b0 04                	mov    $0x4,%al
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 da                	mov    %ebx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 f2                	mov    %esi,%edx
80102a92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a95:	b0 07                	mov    $0x7,%al
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 da                	mov    %ebx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 f2                	mov    %esi,%edx
80102aa0:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa3:	b0 08                	mov    $0x8,%al
80102aa5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa6:	89 da                	mov    %ebx,%edx
80102aa8:	ec                   	in     (%dx),%al
80102aa9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aac:	89 f2                	mov    %esi,%edx
80102aae:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab1:	b0 09                	mov    $0x9,%al
80102ab3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	ec                   	in     (%dx),%al
80102ab7:	0f b6 c0             	movzbl %al,%eax
80102aba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abd:	b8 18 00 00 00       	mov    $0x18,%eax
80102ac2:	89 44 24 08          	mov    %eax,0x8(%esp)
80102ac6:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ac9:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102acd:	89 04 24             	mov    %eax,(%esp)
80102ad0:	e8 db 2e 00 00       	call   801059b0 <memcmp>
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	0f 85 13 ff ff ff    	jne    801029f0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102add:	80 7d b2 00          	cmpb   $0x0,-0x4e(%ebp)
80102ae1:	75 78                	jne    80102b5b <cmostime+0x19b>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae3:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae6:	89 c2                	mov    %eax,%edx
80102ae8:	83 e0 0f             	and    $0xf,%eax
80102aeb:	c1 ea 04             	shr    $0x4,%edx
80102aee:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af1:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af7:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afa:	89 c2                	mov    %eax,%edx
80102afc:	83 e0 0f             	and    $0xf,%eax
80102aff:	c1 ea 04             	shr    $0x4,%edx
80102b02:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b05:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b08:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b0e:	89 c2                	mov    %eax,%edx
80102b10:	83 e0 0f             	and    $0xf,%eax
80102b13:	c1 ea 04             	shr    $0x4,%edx
80102b16:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b19:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1c:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b1f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b22:	89 c2                	mov    %eax,%edx
80102b24:	83 e0 0f             	and    $0xf,%eax
80102b27:	c1 ea 04             	shr    $0x4,%edx
80102b2a:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b30:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b33:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b36:	89 c2                	mov    %eax,%edx
80102b38:	83 e0 0f             	and    $0xf,%eax
80102b3b:	c1 ea 04             	shr    $0x4,%edx
80102b3e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b41:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b44:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b47:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4a:	89 c2                	mov    %eax,%edx
80102b4c:	83 e0 0f             	and    $0xf,%eax
80102b4f:	c1 ea 04             	shr    $0x4,%edx
80102b52:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b55:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b58:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5b:	31 c0                	xor    %eax,%eax
80102b5d:	8b 54 05 b8          	mov    -0x48(%ebp,%eax,1),%edx
80102b61:	8b 7d 08             	mov    0x8(%ebp),%edi
80102b64:	89 14 07             	mov    %edx,(%edi,%eax,1)
80102b67:	83 c0 04             	add    $0x4,%eax
80102b6a:	83 f8 18             	cmp    $0x18,%eax
80102b6d:	72 ee                	jb     80102b5d <cmostime+0x19d>
  r->year += 2000;
80102b6f:	81 47 14 d0 07 00 00 	addl   $0x7d0,0x14(%edi)
}
80102b76:	83 c4 5c             	add    $0x5c,%esp
80102b79:	5b                   	pop    %ebx
80102b7a:	5e                   	pop    %esi
80102b7b:	5f                   	pop    %edi
80102b7c:	5d                   	pop    %ebp
80102b7d:	c3                   	ret    
80102b7e:	66 90                	xchg   %ax,%ax

80102b80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b80:	8b 15 28 47 11 80    	mov    0x80114728,%edx
80102b86:	85 d2                	test   %edx,%edx
80102b88:	0f 8e 92 00 00 00    	jle    80102c20 <install_trans+0xa0>
{
80102b8e:	55                   	push   %ebp
80102b8f:	89 e5                	mov    %esp,%ebp
80102b91:	57                   	push   %edi
80102b92:	56                   	push   %esi
80102b93:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b94:	31 db                	xor    %ebx,%ebx
{
80102b96:	83 ec 1c             	sub    $0x1c,%esp
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ba0:	a1 14 47 11 80       	mov    0x80114714,%eax
80102ba5:	01 d8                	add    %ebx,%eax
80102ba7:	40                   	inc    %eax
80102ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bac:	a1 24 47 11 80       	mov    0x80114724,%eax
80102bb1:	89 04 24             	mov    %eax,(%esp)
80102bb4:	e8 17 d5 ff ff       	call   801000d0 <bread>
80102bb9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bbb:	8b 04 9d 2c 47 11 80 	mov    -0x7feeb8d4(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102bc2:	43                   	inc    %ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bc7:	a1 24 47 11 80       	mov    0x80114724,%eax
80102bcc:	89 04 24             	mov    %eax,(%esp)
80102bcf:	e8 fc d4 ff ff       	call   801000d0 <bread>
80102bd4:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bd6:	b8 00 02 00 00       	mov    $0x200,%eax
80102bdb:	89 44 24 08          	mov    %eax,0x8(%esp)
80102bdf:	8d 47 5c             	lea    0x5c(%edi),%eax
80102be2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102be6:	8d 46 5c             	lea    0x5c(%esi),%eax
80102be9:	89 04 24             	mov    %eax,(%esp)
80102bec:	e8 1f 2e 00 00       	call   80105a10 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf1:	89 34 24             	mov    %esi,(%esp)
80102bf4:	e8 a7 d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102bf9:	89 3c 24             	mov    %edi,(%esp)
80102bfc:	e8 df d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 d7 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c09:	39 1d 28 47 11 80    	cmp    %ebx,0x80114728
80102c0f:	7f 8f                	jg     80102ba0 <install_trans+0x20>
  }
}
80102c11:	83 c4 1c             	add    $0x1c,%esp
80102c14:	5b                   	pop    %ebx
80102c15:	5e                   	pop    %esi
80102c16:	5f                   	pop    %edi
80102c17:	5d                   	pop    %ebp
80102c18:	c3                   	ret    
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c20:	c3                   	ret    
80102c21:	eb 0d                	jmp    80102c30 <write_head>
80102c23:	90                   	nop
80102c24:	90                   	nop
80102c25:	90                   	nop
80102c26:	90                   	nop
80102c27:	90                   	nop
80102c28:	90                   	nop
80102c29:	90                   	nop
80102c2a:	90                   	nop
80102c2b:	90                   	nop
80102c2c:	90                   	nop
80102c2d:	90                   	nop
80102c2e:	90                   	nop
80102c2f:	90                   	nop

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	56                   	push   %esi
80102c34:	53                   	push   %ebx
80102c35:	83 ec 10             	sub    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c38:	a1 14 47 11 80       	mov    0x80114714,%eax
80102c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c41:	a1 24 47 11 80       	mov    0x80114724,%eax
80102c46:	89 04 24             	mov    %eax,(%esp)
80102c49:	e8 82 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c4e:	8b 1d 28 47 11 80    	mov    0x80114728,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c54:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102c56:	89 c6                	mov    %eax,%esi
  hb->n = log.lh.n;
80102c58:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c5b:	7e 24                	jle    80102c81 <write_head+0x51>
80102c5d:	c1 e3 02             	shl    $0x2,%ebx
80102c60:	31 d2                	xor    %edx,%edx
80102c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    hb->block[i] = log.lh.block[i];
80102c70:	8b 8a 2c 47 11 80    	mov    -0x7feeb8d4(%edx),%ecx
80102c76:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c7d:	39 da                	cmp    %ebx,%edx
80102c7f:	75 ef                	jne    80102c70 <write_head+0x40>
  }
  bwrite(buf);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 17 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c89:	89 34 24             	mov    %esi,(%esp)
80102c8c:	e8 4f d5 ff ff       	call   801001e0 <brelse>
}
80102c91:	83 c4 10             	add    $0x10,%esp
80102c94:	5b                   	pop    %ebx
80102c95:	5e                   	pop    %esi
80102c96:	5d                   	pop    %ebp
80102c97:	c3                   	ret    
80102c98:	90                   	nop
80102c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
  initlock(&log.lock, "log");
80102ca1:	ba a0 89 10 80       	mov    $0x801089a0,%edx
{
80102ca6:	89 e5                	mov    %esp,%ebp
80102ca8:	53                   	push   %ebx
80102ca9:	83 ec 34             	sub    $0x34,%esp
80102cac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caf:	89 54 24 04          	mov    %edx,0x4(%esp)
80102cb3:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80102cba:	e8 51 2a 00 00       	call   80105710 <initlock>
  readsb(dev, &sb);
80102cbf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cc6:	89 1c 24             	mov    %ebx,(%esp)
80102cc9:	e8 12 e7 ff ff       	call   801013e0 <readsb>
  log.start = sb.logstart;
80102cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102cd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102cd4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102cd7:	89 1d 24 47 11 80    	mov    %ebx,0x80114724
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.start = sb.logstart;
80102ce1:	a3 14 47 11 80       	mov    %eax,0x80114714
  log.size = sb.nlog;
80102ce6:	89 15 18 47 11 80    	mov    %edx,0x80114718
  struct buf *buf = bread(log.dev, log.start);
80102cec:	e8 df d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102cf1:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102cf4:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102cf6:	89 1d 28 47 11 80    	mov    %ebx,0x80114728
  for (i = 0; i < log.lh.n; i++) {
80102cfc:	7e 23                	jle    80102d21 <initlog+0x81>
80102cfe:	c1 e3 02             	shl    $0x2,%ebx
80102d01:	31 d2                	xor    %edx,%edx
80102d03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.lh.block[i] = lh->block[i];
80102d10:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d14:	83 c2 04             	add    $0x4,%edx
80102d17:	89 8a 28 47 11 80    	mov    %ecx,-0x7feeb8d8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d1d:	39 d3                	cmp    %edx,%ebx
80102d1f:	75 ef                	jne    80102d10 <initlog+0x70>
  brelse(buf);
80102d21:	89 04 24             	mov    %eax,(%esp)
80102d24:	e8 b7 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d29:	e8 52 fe ff ff       	call   80102b80 <install_trans>
  log.lh.n = 0;
80102d2e:	31 c0                	xor    %eax,%eax
80102d30:	a3 28 47 11 80       	mov    %eax,0x80114728
  write_head(); // clear the log
80102d35:	e8 f6 fe ff ff       	call   80102c30 <write_head>
}
80102d3a:	83 c4 34             	add    $0x34,%esp
80102d3d:	5b                   	pop    %ebx
80102d3e:	5d                   	pop    %ebp
80102d3f:	c3                   	ret    

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102d46:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80102d4d:	e8 0e 2b 00 00       	call   80105860 <acquire>
80102d52:	eb 19                	jmp    80102d6d <begin_op+0x2d>
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	b8 e0 46 11 80       	mov    $0x801146e0,%eax
80102d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d61:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80102d68:	e8 73 17 00 00       	call   801044e0 <sleep>
    if(log.committing){
80102d6d:	8b 15 20 47 11 80    	mov    0x80114720,%edx
80102d73:	85 d2                	test   %edx,%edx
80102d75:	75 e1                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d77:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80102d7c:	8b 15 28 47 11 80    	mov    0x80114728,%edx
80102d82:	40                   	inc    %eax
80102d83:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d86:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d89:	83 fa 1e             	cmp    $0x1e,%edx
80102d8c:	7f ca                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8e:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
      log.outstanding += 1;
80102d95:	a3 1c 47 11 80       	mov    %eax,0x8011471c
      release(&log.lock);
80102d9a:	e8 61 2b 00 00       	call   80105900 <release>
      break;
    }
  }
}
80102d9f:	c9                   	leave  
80102da0:	c3                   	ret    
80102da1:	eb 0d                	jmp    80102db0 <end_op>
80102da3:	90                   	nop
80102da4:	90                   	nop
80102da5:	90                   	nop
80102da6:	90                   	nop
80102da7:	90                   	nop
80102da8:	90                   	nop
80102da9:	90                   	nop
80102daa:	90                   	nop
80102dab:	90                   	nop
80102dac:	90                   	nop
80102dad:	90                   	nop
80102dae:	90                   	nop
80102daf:	90                   	nop

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80102dc0:	e8 9b 2a 00 00       	call   80105860 <acquire>
  log.outstanding -= 1;
80102dc5:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80102dca:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102dcd:	a1 20 47 11 80       	mov    0x80114720,%eax
  log.outstanding -= 1;
80102dd2:	89 1d 1c 47 11 80    	mov    %ebx,0x8011471c
  if(log.committing)
80102dd8:	85 c0                	test   %eax,%eax
80102dda:	0f 85 e8 00 00 00    	jne    80102ec8 <end_op+0x118>
    panic("log.committing");
  if(log.outstanding == 0){
80102de0:	85 db                	test   %ebx,%ebx
80102de2:	0f 85 c0 00 00 00    	jne    80102ea8 <end_op+0xf8>
    do_commit = 1;
    log.committing = 1;
80102de8:	be 01 00 00 00       	mov    $0x1,%esi
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ded:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
    log.committing = 1;
80102df4:	89 35 20 47 11 80    	mov    %esi,0x80114720
  release(&log.lock);
80102dfa:	e8 01 2b 00 00       	call   80105900 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102dff:	8b 3d 28 47 11 80    	mov    0x80114728,%edi
80102e05:	85 ff                	test   %edi,%edi
80102e07:	0f 8e 88 00 00 00    	jle    80102e95 <end_op+0xe5>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e0d:	a1 14 47 11 80       	mov    0x80114714,%eax
80102e12:	01 d8                	add    %ebx,%eax
80102e14:	40                   	inc    %eax
80102e15:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e19:	a1 24 47 11 80       	mov    0x80114724,%eax
80102e1e:	89 04 24             	mov    %eax,(%esp)
80102e21:	e8 aa d2 ff ff       	call   801000d0 <bread>
80102e26:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e28:	8b 04 9d 2c 47 11 80 	mov    -0x7feeb8d4(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102e2f:	43                   	inc    %ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e30:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e34:	a1 24 47 11 80       	mov    0x80114724,%eax
80102e39:	89 04 24             	mov    %eax,(%esp)
80102e3c:	e8 8f d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e41:	b9 00 02 00 00       	mov    $0x200,%ecx
80102e46:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e4a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e4c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e53:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e56:	89 04 24             	mov    %eax,(%esp)
80102e59:	e8 b2 2b 00 00       	call   80105a10 <memmove>
    bwrite(to);  // write the log
80102e5e:	89 34 24             	mov    %esi,(%esp)
80102e61:	e8 3a d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e66:	89 3c 24             	mov    %edi,(%esp)
80102e69:	e8 72 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e6e:	89 34 24             	mov    %esi,(%esp)
80102e71:	e8 6a d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e76:	3b 1d 28 47 11 80    	cmp    0x80114728,%ebx
80102e7c:	7c 8f                	jl     80102e0d <end_op+0x5d>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e7e:	e8 ad fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102e83:	e8 f8 fc ff ff       	call   80102b80 <install_trans>
    log.lh.n = 0;
80102e88:	31 d2                	xor    %edx,%edx
80102e8a:	89 15 28 47 11 80    	mov    %edx,0x80114728
    write_head();    // Erase the transaction from the log
80102e90:	e8 9b fd ff ff       	call   80102c30 <write_head>
    acquire(&log.lock);
80102e95:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80102e9c:	e8 bf 29 00 00       	call   80105860 <acquire>
    log.committing = 0;
80102ea1:	31 c0                	xor    %eax,%eax
80102ea3:	a3 20 47 11 80       	mov    %eax,0x80114720
    wakeup(&log);
80102ea8:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80102eaf:	e8 4c 18 00 00       	call   80104700 <wakeup>
    release(&log.lock);
80102eb4:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80102ebb:	e8 40 2a 00 00       	call   80105900 <release>
}
80102ec0:	83 c4 1c             	add    $0x1c,%esp
80102ec3:	5b                   	pop    %ebx
80102ec4:	5e                   	pop    %esi
80102ec5:	5f                   	pop    %edi
80102ec6:	5d                   	pop    %ebp
80102ec7:	c3                   	ret    
    panic("log.committing");
80102ec8:	c7 04 24 a4 89 10 80 	movl   $0x801089a4,(%esp)
80102ecf:	e8 9c d4 ff ff       	call   80100370 <panic>
80102ed4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102eda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102ee0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	53                   	push   %ebx
80102ee4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ee7:	8b 15 28 47 11 80    	mov    0x80114728,%edx
{
80102eed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ef0:	83 fa 1d             	cmp    $0x1d,%edx
80102ef3:	0f 8f 95 00 00 00    	jg     80102f8e <log_write+0xae>
80102ef9:	a1 18 47 11 80       	mov    0x80114718,%eax
80102efe:	48                   	dec    %eax
80102eff:	39 c2                	cmp    %eax,%edx
80102f01:	0f 8d 87 00 00 00    	jge    80102f8e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f07:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80102f0c:	85 c0                	test   %eax,%eax
80102f0e:	0f 8e 86 00 00 00    	jle    80102f9a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f14:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80102f1b:	e8 40 29 00 00       	call   80105860 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f20:	8b 0d 28 47 11 80    	mov    0x80114728,%ecx
80102f26:	83 f9 00             	cmp    $0x0,%ecx
80102f29:	7e 55                	jle    80102f80 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f2b:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f2e:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f30:	3b 15 2c 47 11 80    	cmp    0x8011472c,%edx
80102f36:	75 11                	jne    80102f49 <log_write+0x69>
80102f38:	eb 36                	jmp    80102f70 <log_write+0x90>
80102f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f40:	39 14 85 2c 47 11 80 	cmp    %edx,-0x7feeb8d4(,%eax,4)
80102f47:	74 27                	je     80102f70 <log_write+0x90>
  for (i = 0; i < log.lh.n; i++) {
80102f49:	40                   	inc    %eax
80102f4a:	39 c1                	cmp    %eax,%ecx
80102f4c:	75 f2                	jne    80102f40 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f4e:	89 14 85 2c 47 11 80 	mov    %edx,-0x7feeb8d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f55:	40                   	inc    %eax
80102f56:	a3 28 47 11 80       	mov    %eax,0x80114728
  b->flags |= B_DIRTY; // prevent eviction
80102f5b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f5e:	c7 45 08 e0 46 11 80 	movl   $0x801146e0,0x8(%ebp)
}
80102f65:	83 c4 14             	add    $0x14,%esp
80102f68:	5b                   	pop    %ebx
80102f69:	5d                   	pop    %ebp
  release(&log.lock);
80102f6a:	e9 91 29 00 00       	jmp    80105900 <release>
80102f6f:	90                   	nop
  log.lh.block[i] = b->blockno;
80102f70:	89 14 85 2c 47 11 80 	mov    %edx,-0x7feeb8d4(,%eax,4)
80102f77:	eb e2                	jmp    80102f5b <log_write+0x7b>
80102f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f80:	8b 43 08             	mov    0x8(%ebx),%eax
80102f83:	a3 2c 47 11 80       	mov    %eax,0x8011472c
  if (i == log.lh.n)
80102f88:	75 d1                	jne    80102f5b <log_write+0x7b>
80102f8a:	31 c0                	xor    %eax,%eax
80102f8c:	eb c7                	jmp    80102f55 <log_write+0x75>
    panic("too big a transaction");
80102f8e:	c7 04 24 b3 89 10 80 	movl   $0x801089b3,(%esp)
80102f95:	e8 d6 d3 ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
80102f9a:	c7 04 24 c9 89 10 80 	movl   $0x801089c9,(%esp)
80102fa1:	e8 ca d3 ff ff       	call   80100370 <panic>
80102fa6:	66 90                	xchg   %ax,%ax
80102fa8:	66 90                	xchg   %ax,%ax
80102faa:	66 90                	xchg   %ax,%ax
80102fac:	66 90                	xchg   %ax,%ax
80102fae:	66 90                	xchg   %ax,%ax

80102fb0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 14             	sub    $0x14,%esp
  switchkvm();
80102fb7:	e8 34 4e 00 00       	call   80107df0 <switchkvm>
  seginit();
80102fbc:	e8 9f 4d 00 00       	call   80107d60 <seginit>
  lapicinit();
80102fc1:	e8 1a f8 ff ff       	call   801027e0 <lapicinit>
}

static void
mpmain(void) //called by the non-boot AP cpus
{
  struct cpu* c = mycpu();
80102fc6:	e8 55 0a 00 00       	call   80103a20 <mycpu>
80102fcb:	89 c3                	mov    %eax,%ebx
  cprintf("cpu%d: is witing for the \"pioneer\" cpu to finish its initialization.\n", cpuid());
80102fcd:	e8 ce 0a 00 00       	call   80103aa0 <cpuid>
80102fd2:	c7 04 24 e4 89 10 80 	movl   $0x801089e4,(%esp)
80102fd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fdd:	e8 6e d6 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102fe2:	e8 b9 3c 00 00       	call   80106ca0 <idtinit>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fe7:	b8 01 00 00 00       	mov    $0x1,%eax
80102fec:	f0 87 83 a0 00 00 00 	lock xchg %eax,0xa0(%ebx)
80102ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  xchg(&(c->started), 1); // tell startothers() we're up
  while(c->started != 0); // wait for the "pioneer" cpu to finish the scheduling data structures initialization
80103000:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103006:	85 c0                	test   %eax,%eax
80103008:	75 f6                	jne    80103000 <mpenter+0x50>
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
8010300a:	e8 91 0a 00 00       	call   80103aa0 <cpuid>
8010300f:	89 c3                	mov    %eax,%ebx
80103011:	e8 8a 0a 00 00       	call   80103aa0 <cpuid>
80103016:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010301a:	c7 04 24 34 8a 10 80 	movl   $0x80108a34,(%esp)
80103021:	89 44 24 04          	mov    %eax,0x4(%esp)
80103025:	e8 26 d6 ff ff       	call   80100650 <cprintf>
  scheduler();     // start running processes
8010302a:	e8 41 10 00 00       	call   80104070 <scheduler>
8010302f:	90                   	nop

80103030 <main>:
{
80103030:	55                   	push   %ebp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103031:	b8 00 00 40 80       	mov    $0x80400000,%eax
{
80103036:	89 e5                	mov    %esp,%ebp
80103038:	53                   	push   %ebx
80103039:	83 e4 f0             	and    $0xfffffff0,%esp
8010303c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010303f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103043:	c7 04 24 08 7b 11 80 	movl   $0x80117b08,(%esp)
8010304a:	e8 41 f5 ff ff       	call   80102590 <kinit1>
  kvmalloc();      // kernel page table
8010304f:	e8 6c 52 00 00       	call   801082c0 <kvmalloc>
  mpinit();        // detect other processors
80103054:	e8 17 02 00 00       	call   80103270 <mpinit>
  lapicinit();     // interrupt controller
80103059:	e8 82 f7 ff ff       	call   801027e0 <lapicinit>
8010305e:	66 90                	xchg   %ax,%ax
  seginit();       // segment descriptors
80103060:	e8 fb 4c 00 00       	call   80107d60 <seginit>
  picinit();       // disable pic
80103065:	e8 e6 03 00 00       	call   80103450 <picinit>
  ioapicinit();    // another interrupt controller
8010306a:	e8 31 f3 ff ff       	call   801023a0 <ioapicinit>
8010306f:	90                   	nop
  consoleinit();   // console hardware
80103070:	e8 0b d9 ff ff       	call   80100980 <consoleinit>
  uartinit();      // serial port
80103075:	e8 b6 3f 00 00       	call   80107030 <uartinit>
  pinit();         // process table
8010307a:	e8 81 09 00 00       	call   80103a00 <pinit>
8010307f:	90                   	nop
  tvinit();        // trap vectors
80103080:	e8 9b 3b 00 00       	call   80106c20 <tvinit>
  binit();         // buffer cache
80103085:	e8 b6 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010308a:	e8 a1 dc ff ff       	call   80100d30 <fileinit>
8010308f:	90                   	nop
  ideinit();       // disk 
80103090:	e8 fb f0 ff ff       	call   80102190 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103095:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010309a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010309e:	b8 8c c4 10 80       	mov    $0x8010c48c,%eax
801030a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801030a7:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
801030ae:	e8 5d 29 00 00       	call   80105a10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030b3:	a1 60 4d 11 80       	mov    0x80114d60,%eax
801030b8:	8d 14 80             	lea    (%eax,%eax,4),%edx
801030bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030be:	c1 e0 04             	shl    $0x4,%eax
801030c1:	05 e0 47 11 80       	add    $0x801147e0,%eax
801030c6:	3d e0 47 11 80       	cmp    $0x801147e0,%eax
801030cb:	0f 86 86 00 00 00    	jbe    80103157 <main+0x127>
801030d1:	bb e0 47 11 80       	mov    $0x801147e0,%ebx
801030d6:	8d 76 00             	lea    0x0(%esi),%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801030e0:	e8 3b 09 00 00       	call   80103a20 <mycpu>
801030e5:	39 d8                	cmp    %ebx,%eax
801030e7:	74 51                	je     8010313a <main+0x10a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030e9:	e8 72 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
801030ee:	ba b0 2f 10 80       	mov    $0x80102fb0,%edx
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030f3:	b9 00 b0 10 00       	mov    $0x10b000,%ecx
    *(void(**)(void))(code-8) = mpenter;
801030f8:	89 15 f8 6f 00 80    	mov    %edx,0x80006ff8
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030fe:	89 0d f4 6f 00 80    	mov    %ecx,0x80006ff4
    *(void**)(code-4) = stack + KSTACKSIZE;
80103104:	05 00 10 00 00       	add    $0x1000,%eax
80103109:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010310e:	b8 00 70 00 00       	mov    $0x7000,%eax
80103113:	89 44 24 04          	mov    %eax,0x4(%esp)
80103117:	0f b6 03             	movzbl (%ebx),%eax
8010311a:	89 04 24             	mov    %eax,(%esp)
8010311d:	e8 0e f8 ff ff       	call   80102930 <lapicstartap>
80103122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
  for(c = cpus; c < cpus+ncpu; c++){
8010313a:	a1 60 4d 11 80       	mov    0x80114d60,%eax
8010313f:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103145:	8d 14 80             	lea    (%eax,%eax,4),%edx
80103148:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010314b:	c1 e0 04             	shl    $0x4,%eax
8010314e:	05 e0 47 11 80       	add    $0x801147e0,%eax
80103153:	39 c3                	cmp    %eax,%ebx
80103155:	72 89                	jb     801030e0 <main+0xb0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103157:	b8 00 00 00 8e       	mov    $0x8e000000,%eax
8010315c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103160:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103167:	e8 94 f4 ff ff       	call   80102600 <kinit2>
  initSchedDS(); // initialize the data structures for the processes sceduling policies
8010316c:	e8 0f 1a 00 00       	call   80104b80 <initSchedDS>
	__sync_synchronize();
80103171:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  for(struct cpu *c = cpus; c < cpus + ncpu; ++c) //releases the non-boot AP cpus that are wating at mpmain at main.c
80103176:	a1 60 4d 11 80       	mov    0x80114d60,%eax
8010317b:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010317e:	8d 0c 50             	lea    (%eax,%edx,2),%ecx
80103181:	c1 e1 04             	shl    $0x4,%ecx
80103184:	81 c1 e0 47 11 80    	add    $0x801147e0,%ecx
8010318a:	81 f9 e0 47 11 80    	cmp    $0x801147e0,%ecx
80103190:	76 21                	jbe    801031b3 <main+0x183>
80103192:	ba e0 47 11 80       	mov    $0x801147e0,%edx
80103197:	31 db                	xor    %ebx,%ebx
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	89 d8                	mov    %ebx,%eax
801031a2:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
801031a9:	81 c2 b0 00 00 00    	add    $0xb0,%edx
801031af:	39 ca                	cmp    %ecx,%edx
801031b1:	72 ed                	jb     801031a0 <main+0x170>
  userinit();      // first user process
801031b3:	e8 38 09 00 00       	call   80103af0 <userinit>
  cprintf("\"pioneer\" cpu%d: starting %d\n", cpuid(), cpuid());
801031b8:	e8 e3 08 00 00       	call   80103aa0 <cpuid>
801031bd:	89 c3                	mov    %eax,%ebx
801031bf:	e8 dc 08 00 00       	call   80103aa0 <cpuid>
801031c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801031c8:	c7 04 24 2a 8a 10 80 	movl   $0x80108a2a,(%esp)
801031cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801031d3:	e8 78 d4 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
801031d8:	e8 c3 3a 00 00       	call   80106ca0 <idtinit>
  scheduler();     // start running processes
801031dd:	e8 8e 0e 00 00       	call   80104070 <scheduler>
801031e2:	66 90                	xchg   %ax,%ax
801031e4:	66 90                	xchg   %ax,%ax
801031e6:	66 90                	xchg   %ax,%ax
801031e8:	66 90                	xchg   %ax,%ax
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031fb:	53                   	push   %ebx
  e = addr+len;
801031fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031ff:	83 ec 1c             	sub    $0x1c,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103202:	39 de                	cmp    %ebx,%esi
80103204:	72 10                	jb     80103216 <mpsearch1+0x26>
80103206:	eb 58                	jmp    80103260 <mpsearch1+0x70>
80103208:	90                   	nop
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103210:	39 d3                	cmp    %edx,%ebx
80103212:	89 d6                	mov    %edx,%esi
80103214:	76 4a                	jbe    80103260 <mpsearch1+0x70>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103216:	ba 48 8a 10 80       	mov    $0x80108a48,%edx
8010321b:	b8 04 00 00 00       	mov    $0x4,%eax
80103220:	89 54 24 04          	mov    %edx,0x4(%esp)
80103224:	89 44 24 08          	mov    %eax,0x8(%esp)
80103228:	89 34 24             	mov    %esi,(%esp)
8010322b:	e8 80 27 00 00       	call   801059b0 <memcmp>
80103230:	8d 56 10             	lea    0x10(%esi),%edx
80103233:	85 c0                	test   %eax,%eax
80103235:	75 d9                	jne    80103210 <mpsearch1+0x20>
80103237:	89 f1                	mov    %esi,%ecx
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103240:	0f b6 39             	movzbl (%ecx),%edi
80103243:	41                   	inc    %ecx
80103244:	01 f8                	add    %edi,%eax
  for(i=0; i<len; i++)
80103246:	39 d1                	cmp    %edx,%ecx
80103248:	75 f6                	jne    80103240 <mpsearch1+0x50>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010324a:	84 c0                	test   %al,%al
8010324c:	75 c2                	jne    80103210 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
8010324e:	83 c4 1c             	add    $0x1c,%esp
80103251:	89 f0                	mov    %esi,%eax
80103253:	5b                   	pop    %ebx
80103254:	5e                   	pop    %esi
80103255:	5f                   	pop    %edi
80103256:	5d                   	pop    %ebp
80103257:	c3                   	ret    
80103258:	90                   	nop
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103260:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80103263:	31 f6                	xor    %esi,%esi
}
80103265:	5b                   	pop    %ebx
80103266:	89 f0                	mov    %esi,%eax
80103268:	5e                   	pop    %esi
80103269:	5f                   	pop    %edi
8010326a:	5d                   	pop    %ebp
8010326b:	c3                   	ret    
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103270 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 2c             	sub    $0x2c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103279:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103280:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103287:	c1 e0 08             	shl    $0x8,%eax
8010328a:	09 d0                	or     %edx,%eax
8010328c:	c1 e0 04             	shl    $0x4,%eax
8010328f:	75 1b                	jne    801032ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103291:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103298:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010329f:	c1 e0 08             	shl    $0x8,%eax
801032a2:	09 d0                	or     %edx,%eax
801032a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032ac:	ba 00 04 00 00       	mov    $0x400,%edx
801032b1:	e8 3a ff ff ff       	call   801031f0 <mpsearch1>
801032b6:	85 c0                	test   %eax,%eax
801032b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032bb:	0f 84 4f 01 00 00    	je     80103410 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032c4:	8b 58 04             	mov    0x4(%eax),%ebx
801032c7:	85 db                	test   %ebx,%ebx
801032c9:	0f 84 61 01 00 00    	je     80103430 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801032cf:	b8 04 00 00 00       	mov    $0x4,%eax
801032d4:	ba 65 8a 10 80       	mov    $0x80108a65,%edx
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032d9:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801032df:	89 44 24 08          	mov    %eax,0x8(%esp)
801032e3:	89 54 24 04          	mov    %edx,0x4(%esp)
801032e7:	89 34 24             	mov    %esi,(%esp)
801032ea:	e8 c1 26 00 00       	call   801059b0 <memcmp>
801032ef:	85 c0                	test   %eax,%eax
801032f1:	0f 85 39 01 00 00    	jne    80103430 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032f7:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032fe:	3c 01                	cmp    $0x1,%al
80103300:	0f 95 c2             	setne  %dl
80103303:	3c 04                	cmp    $0x4,%al
80103305:	0f 95 c0             	setne  %al
80103308:	20 d0                	and    %dl,%al
8010330a:	0f 85 20 01 00 00    	jne    80103430 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103310:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103317:	85 ff                	test   %edi,%edi
80103319:	74 24                	je     8010333f <mpinit+0xcf>
8010331b:	89 f0                	mov    %esi,%eax
8010331d:	01 f7                	add    %esi,%edi
  sum = 0;
8010331f:	31 d2                	xor    %edx,%edx
80103321:	eb 0d                	jmp    80103330 <mpinit+0xc0>
80103323:	90                   	nop
80103324:	90                   	nop
80103325:	90                   	nop
80103326:	90                   	nop
80103327:	90                   	nop
80103328:	90                   	nop
80103329:	90                   	nop
8010332a:	90                   	nop
8010332b:	90                   	nop
8010332c:	90                   	nop
8010332d:	90                   	nop
8010332e:	90                   	nop
8010332f:	90                   	nop
    sum += addr[i];
80103330:	0f b6 08             	movzbl (%eax),%ecx
80103333:	40                   	inc    %eax
80103334:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103336:	39 c7                	cmp    %eax,%edi
80103338:	75 f6                	jne    80103330 <mpinit+0xc0>
8010333a:	84 d2                	test   %dl,%dl
8010333c:	0f 95 c0             	setne  %al
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010333f:	85 f6                	test   %esi,%esi
80103341:	0f 84 e9 00 00 00    	je     80103430 <mpinit+0x1c0>
80103347:	84 c0                	test   %al,%al
80103349:	0f 85 e1 00 00 00    	jne    80103430 <mpinit+0x1c0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010334f:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103355:	8d 93 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%edx
  ismp = 1;
8010335b:	b9 01 00 00 00       	mov    $0x1,%ecx
  lapic = (uint*)conf->lapicaddr;
80103360:	a3 dc 46 11 80       	mov    %eax,0x801146dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103365:	0f b7 83 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%eax
8010336c:	01 c6                	add    %eax,%esi
8010336e:	66 90                	xchg   %ax,%ax
80103370:	39 d6                	cmp    %edx,%esi
80103372:	76 23                	jbe    80103397 <mpinit+0x127>
    switch(*p){
80103374:	0f b6 02             	movzbl (%edx),%eax
80103377:	3c 04                	cmp    $0x4,%al
80103379:	0f 87 c9 00 00 00    	ja     80103448 <mpinit+0x1d8>
8010337f:	ff 24 85 8c 8a 10 80 	jmp    *-0x7fef7574(,%eax,4)
80103386:	8d 76 00             	lea    0x0(%esi),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103390:	83 c2 08             	add    $0x8,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103393:	39 d6                	cmp    %edx,%esi
80103395:	77 dd                	ja     80103374 <mpinit+0x104>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103397:	85 c9                	test   %ecx,%ecx
80103399:	0f 84 9d 00 00 00    	je     8010343c <mpinit+0x1cc>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801033a6:	74 11                	je     801033b9 <mpinit+0x149>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a8:	b0 70                	mov    $0x70,%al
801033aa:	ba 22 00 00 00       	mov    $0x22,%edx
801033af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033b0:	ba 23 00 00 00       	mov    $0x23,%edx
801033b5:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033b6:	0c 01                	or     $0x1,%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033b8:	ee                   	out    %al,(%dx)
  }
}
801033b9:	83 c4 2c             	add    $0x2c,%esp
801033bc:	5b                   	pop    %ebx
801033bd:	5e                   	pop    %esi
801033be:	5f                   	pop    %edi
801033bf:	5d                   	pop    %ebp
801033c0:	c3                   	ret    
801033c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801033c8:	8b 1d 60 4d 11 80    	mov    0x80114d60,%ebx
801033ce:	83 fb 07             	cmp    $0x7,%ebx
801033d1:	7f 1a                	jg     801033ed <mpinit+0x17d>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033d3:	0f b6 42 01          	movzbl 0x1(%edx),%eax
801033d7:	8d 3c 9b             	lea    (%ebx,%ebx,4),%edi
801033da:	8d 3c 7b             	lea    (%ebx,%edi,2),%edi
        ncpu++;
801033dd:	43                   	inc    %ebx
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033de:	c1 e7 04             	shl    $0x4,%edi
        ncpu++;
801033e1:	89 1d 60 4d 11 80    	mov    %ebx,0x80114d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033e7:	88 87 e0 47 11 80    	mov    %al,-0x7feeb820(%edi)
      p += sizeof(struct mpproc);
801033ed:	83 c2 14             	add    $0x14,%edx
      continue;
801033f0:	e9 7b ff ff ff       	jmp    80103370 <mpinit+0x100>
801033f5:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
801033f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
801033fc:	83 c2 08             	add    $0x8,%edx
      ioapicid = ioapic->apicno;
801033ff:	a2 c0 47 11 80       	mov    %al,0x801147c0
      continue;
80103404:	e9 67 ff ff ff       	jmp    80103370 <mpinit+0x100>
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103410:	ba 00 00 01 00       	mov    $0x10000,%edx
80103415:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010341a:	e8 d1 fd ff ff       	call   801031f0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010341f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103421:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103424:	0f 85 97 fe ff ff    	jne    801032c1 <mpinit+0x51>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103430:	c7 04 24 4d 8a 10 80 	movl   $0x80108a4d,(%esp)
80103437:	e8 34 cf ff ff       	call   80100370 <panic>
    panic("Didn't find a suitable machine");
8010343c:	c7 04 24 6c 8a 10 80 	movl   $0x80108a6c,(%esp)
80103443:	e8 28 cf ff ff       	call   80100370 <panic>
      ismp = 0;
80103448:	31 c9                	xor    %ecx,%ecx
8010344a:	e9 28 ff ff ff       	jmp    80103377 <mpinit+0x107>
8010344f:	90                   	nop

80103450 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103450:	55                   	push   %ebp
80103451:	b0 ff                	mov    $0xff,%al
80103453:	89 e5                	mov    %esp,%ebp
80103455:	ba 21 00 00 00       	mov    $0x21,%edx
8010345a:	ee                   	out    %al,(%dx)
8010345b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103460:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103461:	5d                   	pop    %ebp
80103462:	c3                   	ret    
80103463:	66 90                	xchg   %ax,%ax
80103465:	66 90                	xchg   %ax,%ax
80103467:	66 90                	xchg   %ax,%ax
80103469:	66 90                	xchg   %ax,%ax
8010346b:	66 90                	xchg   %ax,%ax
8010346d:	66 90                	xchg   %ax,%ax
8010346f:	90                   	nop

80103470 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	56                   	push   %esi
80103474:	53                   	push   %ebx
80103475:	83 ec 20             	sub    $0x20,%esp
80103478:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010347b:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010347e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103484:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010348a:	e8 c1 d8 ff ff       	call   80100d50 <filealloc>
8010348f:	85 c0                	test   %eax,%eax
80103491:	89 03                	mov    %eax,(%ebx)
80103493:	74 1b                	je     801034b0 <pipealloc+0x40>
80103495:	e8 b6 d8 ff ff       	call   80100d50 <filealloc>
8010349a:	85 c0                	test   %eax,%eax
8010349c:	89 06                	mov    %eax,(%esi)
8010349e:	74 30                	je     801034d0 <pipealloc+0x60>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034a0:	e8 bb f1 ff ff       	call   80102660 <kalloc>
801034a5:	85 c0                	test   %eax,%eax
801034a7:	75 47                	jne    801034f0 <pipealloc+0x80>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801034a9:	8b 03                	mov    (%ebx),%eax
801034ab:	85 c0                	test   %eax,%eax
801034ad:	75 27                	jne    801034d6 <pipealloc+0x66>
801034af:	90                   	nop
    fileclose(*f0);
  if(*f1)
801034b0:	8b 06                	mov    (%esi),%eax
801034b2:	85 c0                	test   %eax,%eax
801034b4:	74 08                	je     801034be <pipealloc+0x4e>
    fileclose(*f1);
801034b6:	89 04 24             	mov    %eax,(%esp)
801034b9:	e8 52 d9 ff ff       	call   80100e10 <fileclose>
  return -1;
}
801034be:	83 c4 20             	add    $0x20,%esp
  return -1;
801034c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034c6:	5b                   	pop    %ebx
801034c7:	5e                   	pop    %esi
801034c8:	5d                   	pop    %ebp
801034c9:	c3                   	ret    
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
801034d0:	8b 03                	mov    (%ebx),%eax
801034d2:	85 c0                	test   %eax,%eax
801034d4:	74 e8                	je     801034be <pipealloc+0x4e>
    fileclose(*f0);
801034d6:	89 04 24             	mov    %eax,(%esp)
801034d9:	e8 32 d9 ff ff       	call   80100e10 <fileclose>
  if(*f1)
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	85 c0                	test   %eax,%eax
801034e2:	75 d2                	jne    801034b6 <pipealloc+0x46>
801034e4:	eb d8                	jmp    801034be <pipealloc+0x4e>
801034e6:	8d 76 00             	lea    0x0(%esi),%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  p->readopen = 1;
801034f0:	ba 01 00 00 00       	mov    $0x1,%edx
  p->writeopen = 1;
801034f5:	b9 01 00 00 00       	mov    $0x1,%ecx
  p->readopen = 1;
801034fa:	89 90 3c 02 00 00    	mov    %edx,0x23c(%eax)
  p->nwrite = 0;
80103500:	31 d2                	xor    %edx,%edx
  p->writeopen = 1;
80103502:	89 88 40 02 00 00    	mov    %ecx,0x240(%eax)
  p->nread = 0;
80103508:	31 c9                	xor    %ecx,%ecx
  p->nwrite = 0;
8010350a:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
  initlock(&p->lock, "pipe");
80103510:	ba a0 8a 10 80       	mov    $0x80108aa0,%edx
  p->nread = 0;
80103515:	89 88 34 02 00 00    	mov    %ecx,0x234(%eax)
  initlock(&p->lock, "pipe");
8010351b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010351f:	89 04 24             	mov    %eax,(%esp)
80103522:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103525:	e8 e6 21 00 00       	call   80105710 <initlock>
  (*f0)->type = FD_PIPE;
8010352a:	8b 13                	mov    (%ebx),%edx
  (*f0)->pipe = p;
8010352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  (*f0)->type = FD_PIPE;
8010352f:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
  (*f0)->readable = 1;
80103535:	8b 13                	mov    (%ebx),%edx
80103537:	c6 42 08 01          	movb   $0x1,0x8(%edx)
  (*f0)->writable = 0;
8010353b:	8b 13                	mov    (%ebx),%edx
8010353d:	c6 42 09 00          	movb   $0x0,0x9(%edx)
  (*f0)->pipe = p;
80103541:	8b 13                	mov    (%ebx),%edx
80103543:	89 42 0c             	mov    %eax,0xc(%edx)
  (*f1)->type = FD_PIPE;
80103546:	8b 16                	mov    (%esi),%edx
80103548:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
  (*f1)->readable = 0;
8010354e:	8b 16                	mov    (%esi),%edx
80103550:	c6 42 08 00          	movb   $0x0,0x8(%edx)
  (*f1)->writable = 1;
80103554:	8b 16                	mov    (%esi),%edx
80103556:	c6 42 09 01          	movb   $0x1,0x9(%edx)
  (*f1)->pipe = p;
8010355a:	8b 16                	mov    (%esi),%edx
8010355c:	89 42 0c             	mov    %eax,0xc(%edx)
}
8010355f:	83 c4 20             	add    $0x20,%esp
  return 0;
80103562:	31 c0                	xor    %eax,%eax
}
80103564:	5b                   	pop    %ebx
80103565:	5e                   	pop    %esi
80103566:	5d                   	pop    %ebp
80103567:	c3                   	ret    
80103568:	90                   	nop
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103570 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	83 ec 18             	sub    $0x18,%esp
80103576:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80103579:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010357c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010357f:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103582:	89 1c 24             	mov    %ebx,(%esp)
80103585:	e8 d6 22 00 00       	call   80105860 <acquire>
  if(writable){
8010358a:	85 f6                	test   %esi,%esi
8010358c:	74 42                	je     801035d0 <pipeclose+0x60>
    p->writeopen = 0;
8010358e:	31 f6                	xor    %esi,%esi
    wakeup(&p->nread);
80103590:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103596:	89 b3 40 02 00 00    	mov    %esi,0x240(%ebx)
    wakeup(&p->nread);
8010359c:	89 04 24             	mov    %eax,(%esp)
8010359f:	e8 5c 11 00 00       	call   80104700 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035a4:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035aa:	85 d2                	test   %edx,%edx
801035ac:	75 0a                	jne    801035b8 <pipeclose+0x48>
801035ae:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035b4:	85 c0                	test   %eax,%eax
801035b6:	74 38                	je     801035f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035b8:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035bb:	8b 75 fc             	mov    -0x4(%ebp),%esi
801035be:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801035c1:	89 ec                	mov    %ebp,%esp
801035c3:	5d                   	pop    %ebp
    release(&p->lock);
801035c4:	e9 37 23 00 00       	jmp    80105900 <release>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->readopen = 0;
801035d0:	31 c9                	xor    %ecx,%ecx
    wakeup(&p->nwrite);
801035d2:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035d8:	89 8b 3c 02 00 00    	mov    %ecx,0x23c(%ebx)
    wakeup(&p->nwrite);
801035de:	89 04 24             	mov    %eax,(%esp)
801035e1:	e8 1a 11 00 00       	call   80104700 <wakeup>
801035e6:	eb bc                	jmp    801035a4 <pipeclose+0x34>
801035e8:	90                   	nop
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035f0:	89 1c 24             	mov    %ebx,(%esp)
801035f3:	e8 08 23 00 00       	call   80105900 <release>
}
801035f8:	8b 75 fc             	mov    -0x4(%ebp),%esi
    kfree((char*)p);
801035fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035fe:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103601:	89 ec                	mov    %ebp,%esp
80103603:	5d                   	pop    %ebp
    kfree((char*)p);
80103604:	e9 87 ee ff ff       	jmp    80102490 <kfree>
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103610 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 2c             	sub    $0x2c,%esp
80103619:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010361c:	89 3c 24             	mov    %edi,(%esp)
8010361f:	e8 3c 22 00 00       	call   80105860 <acquire>
  for(i = 0; i < n; i++){
80103624:	8b 75 10             	mov    0x10(%ebp),%esi
80103627:	85 f6                	test   %esi,%esi
80103629:	0f 8e c7 00 00 00    	jle    801036f6 <pipewrite+0xe6>
8010362f:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103632:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103638:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010363b:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
80103641:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103644:	01 d8                	add    %ebx,%eax
80103646:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103649:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
8010364f:	05 00 02 00 00       	add    $0x200,%eax
80103654:	39 c1                	cmp    %eax,%ecx
80103656:	75 6c                	jne    801036c4 <pipewrite+0xb4>
      if(p->readopen == 0 || myproc()->killed){
80103658:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010365e:	85 c0                	test   %eax,%eax
80103660:	74 4d                	je     801036af <pipewrite+0x9f>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103662:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103668:	eb 39                	jmp    801036a3 <pipewrite+0x93>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103670:	89 34 24             	mov    %esi,(%esp)
80103673:	e8 88 10 00 00       	call   80104700 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103678:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010367c:	89 1c 24             	mov    %ebx,(%esp)
8010367f:	e8 5c 0e 00 00       	call   801044e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103684:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
8010368a:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
80103690:	05 00 02 00 00       	add    $0x200,%eax
80103695:	39 c2                	cmp    %eax,%edx
80103697:	75 37                	jne    801036d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103699:	8b 8f 3c 02 00 00    	mov    0x23c(%edi),%ecx
8010369f:	85 c9                	test   %ecx,%ecx
801036a1:	74 0c                	je     801036af <pipewrite+0x9f>
801036a3:	e8 18 04 00 00       	call   80103ac0 <myproc>
801036a8:	8b 50 24             	mov    0x24(%eax),%edx
801036ab:	85 d2                	test   %edx,%edx
801036ad:	74 c1                	je     80103670 <pipewrite+0x60>
        release(&p->lock);
801036af:	89 3c 24             	mov    %edi,(%esp)
801036b2:	e8 49 22 00 00       	call   80105900 <release>
        return -1;
801036b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036bc:	83 c4 2c             	add    $0x2c,%esp
801036bf:	5b                   	pop    %ebx
801036c0:	5e                   	pop    %esi
801036c1:	5f                   	pop    %edi
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036c4:	89 ca                	mov    %ecx,%edx
801036c6:	8d 76 00             	lea    0x0(%esi),%esi
801036c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801036d3:	8d 4a 01             	lea    0x1(%edx),%ecx
801036d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036dc:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801036e2:	0f b6 03             	movzbl (%ebx),%eax
801036e5:	43                   	inc    %ebx
  for(i = 0; i < n; i++){
801036e6:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801036e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036ec:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
  for(i = 0; i < n; i++){
801036f0:	0f 85 53 ff ff ff    	jne    80103649 <pipewrite+0x39>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036f6:	8d 87 34 02 00 00    	lea    0x234(%edi),%eax
801036fc:	89 04 24             	mov    %eax,(%esp)
801036ff:	e8 fc 0f 00 00       	call   80104700 <wakeup>
  release(&p->lock);
80103704:	89 3c 24             	mov    %edi,(%esp)
80103707:	e8 f4 21 00 00       	call   80105900 <release>
  return n;
8010370c:	8b 45 10             	mov    0x10(%ebp),%eax
8010370f:	eb ab                	jmp    801036bc <pipewrite+0xac>
80103711:	eb 0d                	jmp    80103720 <piperead>
80103713:	90                   	nop
80103714:	90                   	nop
80103715:	90                   	nop
80103716:	90                   	nop
80103717:	90                   	nop
80103718:	90                   	nop
80103719:	90                   	nop
8010371a:	90                   	nop
8010371b:	90                   	nop
8010371c:	90                   	nop
8010371d:	90                   	nop
8010371e:	90                   	nop
8010371f:	90                   	nop

80103720 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 1c             	sub    $0x1c,%esp
80103729:	8b 75 08             	mov    0x8(%ebp),%esi
8010372c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010372f:	89 34 24             	mov    %esi,(%esp)
80103732:	e8 29 21 00 00       	call   80105860 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103737:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010373d:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103743:	75 6b                	jne    801037b0 <piperead+0x90>
80103745:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010374b:	85 db                	test   %ebx,%ebx
8010374d:	0f 84 bd 00 00 00    	je     80103810 <piperead+0xf0>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103753:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103759:	eb 2d                	jmp    80103788 <piperead+0x68>
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103760:	89 74 24 04          	mov    %esi,0x4(%esp)
80103764:	89 1c 24             	mov    %ebx,(%esp)
80103767:	e8 74 0d 00 00       	call   801044e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010376c:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103772:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103778:	75 36                	jne    801037b0 <piperead+0x90>
8010377a:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103780:	85 d2                	test   %edx,%edx
80103782:	0f 84 88 00 00 00    	je     80103810 <piperead+0xf0>
    if(myproc()->killed){
80103788:	e8 33 03 00 00       	call   80103ac0 <myproc>
8010378d:	8b 48 24             	mov    0x24(%eax),%ecx
80103790:	85 c9                	test   %ecx,%ecx
80103792:	74 cc                	je     80103760 <piperead+0x40>
      release(&p->lock);
80103794:	89 34 24             	mov    %esi,(%esp)
      return -1;
80103797:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010379c:	e8 5f 21 00 00       	call   80105900 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801037a1:	83 c4 1c             	add    $0x1c,%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	90                   	nop
801037ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b0:	8b 45 10             	mov    0x10(%ebp),%eax
801037b3:	85 c0                	test   %eax,%eax
801037b5:	7e 59                	jle    80103810 <piperead+0xf0>
    if(p->nread == p->nwrite)
801037b7:	31 db                	xor    %ebx,%ebx
801037b9:	eb 13                	jmp    801037ce <piperead+0xae>
801037bb:	90                   	nop
801037bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037c0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037c6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037cc:	74 1d                	je     801037eb <piperead+0xcb>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037ce:	8d 41 01             	lea    0x1(%ecx),%eax
801037d1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801037d7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801037dd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801037e2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037e5:	43                   	inc    %ebx
801037e6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037e9:	75 d5                	jne    801037c0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037eb:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037f1:	89 04 24             	mov    %eax,(%esp)
801037f4:	e8 07 0f 00 00       	call   80104700 <wakeup>
  release(&p->lock);
801037f9:	89 34 24             	mov    %esi,(%esp)
801037fc:	e8 ff 20 00 00       	call   80105900 <release>
}
80103801:	83 c4 1c             	add    $0x1c,%esp
80103804:	89 d8                	mov    %ebx,%eax
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret    
8010380b:	90                   	nop
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103810:	31 db                	xor    %ebx,%ebx
80103812:	eb d7                	jmp    801037eb <piperead+0xcb>
80103814:	66 90                	xchg   %ax,%ax
80103816:	66 90                	xchg   %ax,%ax
80103818:	66 90                	xchg   %ax,%ax
8010381a:	66 90                	xchg   %ax,%ax
8010381c:	66 90                	xchg   %ax,%ax
8010381e:	66 90                	xchg   %ax,%ax

80103820 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103825:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
{
8010382a:	83 ec 10             	sub    $0x10,%esp
8010382d:	eb 0f                	jmp    8010383e <wakeup1+0x1e>
8010382f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103836:	81 fb b4 72 11 80    	cmp    $0x801172b4,%ebx
8010383c:	73 62                	jae    801038a0 <wakeup1+0x80>
    if(p->state == SLEEPING && p->chan == chan){
8010383e:	8b 53 0c             	mov    0xc(%ebx),%edx
80103841:	83 fa 02             	cmp    $0x2,%edx
80103844:	75 ea                	jne    80103830 <wakeup1+0x10>
80103846:	39 43 20             	cmp    %eax,0x20(%ebx)
80103849:	75 e5                	jne    80103830 <wakeup1+0x10>
      long long * accRunnable = null;
      long long * accRunning = null;
      boolean notEmptyRunnable = pq.getMinAccumulator(accRunnable);
8010384b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103852:	ff 15 e8 c5 10 80    	call   *0x8010c5e8
      boolean notEmptyRunning = rpholder.getMinAccumulator(accRunning);
80103858:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      boolean notEmptyRunnable = pq.getMinAccumulator(accRunnable);
8010385f:	89 c6                	mov    %eax,%esi
      boolean notEmptyRunning = rpholder.getMinAccumulator(accRunning);
80103861:	ff 15 cc c5 10 80    	call   *0x8010c5cc
      if(!notEmptyRunnable && !notEmptyRunning){
80103867:	89 f1                	mov    %esi,%ecx
80103869:	09 c1                	or     %eax,%ecx
8010386b:	75 23                	jne    80103890 <wakeup1+0x70>
        p->accumulator = 0;
8010386d:	31 c0                	xor    %eax,%eax
8010386f:	31 d2                	xor    %edx,%edx
80103871:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
80103877:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
      }
      if(notEmptyRunnable && !notEmptyRunning ){
        p->accumulator = *accRunnable;
      }
      else{
        p->accumulator = (*accRunning > *accRunnable) ? *accRunning : *accRunnable ;
8010387d:	a1 00 00 00 00       	mov    0x0,%eax
80103882:	8b 15 04 00 00 00    	mov    0x4,%edx
80103888:	0f 0b                	ud2    
8010388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(!notEmptyRunnable && notEmptyRunning ){
80103890:	85 f6                	test   %esi,%esi
80103892:	75 e9                	jne    8010387d <wakeup1+0x5d>
80103894:	eb e7                	jmp    8010387d <wakeup1+0x5d>
80103896:	8d 76 00             	lea    0x0(%esi),%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if(!pq.put(p)){
         panic("add to pq has a problem, function:wakeup1");
        }
      }
   }
}
801038a0:	83 c4 10             	add    $0x10,%esp
801038a3:	5b                   	pop    %ebx
801038a4:	5e                   	pop    %esi
801038a5:	5d                   	pop    %ebp
801038a6:	c3                   	ret    
801038a7:	89 f6                	mov    %esi,%esi
801038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038b0 <allocproc>:
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038b4:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
{
801038b9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801038bc:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
801038c3:	e8 98 1f 00 00       	call   80105860 <acquire>
801038c8:	eb 18                	jmp    801038e2 <allocproc+0x32>
801038ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038d0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801038d6:	81 fb b4 72 11 80    	cmp    $0x801172b4,%ebx
801038dc:	0f 83 7e 00 00 00    	jae    80103960 <allocproc+0xb0>
    if(p->state == UNUSED)
801038e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801038e5:	85 c0                	test   %eax,%eax
801038e7:	75 e7                	jne    801038d0 <allocproc+0x20>
    p->pid = nextpid++;
801038e9:	a1 08 c0 10 80       	mov    0x8010c008,%eax
    p->state = EMBRYO;
801038ee:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
801038f5:	8d 50 01             	lea    0x1(%eax),%edx
801038f8:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
801038fb:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
    p->pid = nextpid++;
80103902:	89 15 08 c0 10 80    	mov    %edx,0x8010c008
    release(&ptable.lock);
80103908:	e8 f3 1f 00 00       	call   80105900 <release>
    if((p->kstack = kalloc()) == 0){
8010390d:	e8 4e ed ff ff       	call   80102660 <kalloc>
80103912:	85 c0                	test   %eax,%eax
80103914:	89 43 08             	mov    %eax,0x8(%ebx)
80103917:	74 5d                	je     80103976 <allocproc+0xc6>
    sp -= sizeof *p->tf;
80103919:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(p->context, 0, sizeof *p->context);
8010391f:	b9 14 00 00 00       	mov    $0x14,%ecx
    sp -= sizeof *p->tf;
80103924:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint*)sp = (uint)trapret;
80103927:	ba 15 6c 10 80       	mov    $0x80106c15,%edx
    sp -= sizeof *p->context;
8010392c:	05 9c 0f 00 00       	add    $0xf9c,%eax
    *(uint*)sp = (uint)trapret;
80103931:	89 50 14             	mov    %edx,0x14(%eax)
    memset(p->context, 0, sizeof *p->context);
80103934:	31 d2                	xor    %edx,%edx
    p->context = (struct context*)sp;
80103936:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103939:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010393d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103941:	89 04 24             	mov    %eax,(%esp)
80103944:	e8 07 20 00 00       	call   80105950 <memset>
    p->context->eip = (uint)forkret;
80103949:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010394c:	c7 40 10 90 39 10 80 	movl   $0x80103990,0x10(%eax)
}
80103953:	83 c4 14             	add    $0x14,%esp
80103956:	89 d8                	mov    %ebx,%eax
80103958:	5b                   	pop    %ebx
80103959:	5d                   	pop    %ebp
8010395a:	c3                   	ret    
8010395b:	90                   	nop
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103960:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
  return 0;
80103967:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103969:	e8 92 1f 00 00       	call   80105900 <release>
}
8010396e:	83 c4 14             	add    $0x14,%esp
80103971:	89 d8                	mov    %ebx,%eax
80103973:	5b                   	pop    %ebx
80103974:	5d                   	pop    %ebp
80103975:	c3                   	ret    
      p->state = UNUSED;
80103976:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
      return 0;
8010397d:	31 db                	xor    %ebx,%ebx
8010397f:	eb d2                	jmp    80103953 <allocproc+0xa3>
80103981:	eb 0d                	jmp    80103990 <forkret>
80103983:	90                   	nop
80103984:	90                   	nop
80103985:	90                   	nop
80103986:	90                   	nop
80103987:	90                   	nop
80103988:	90                   	nop
80103989:	90                   	nop
8010398a:	90                   	nop
8010398b:	90                   	nop
8010398c:	90                   	nop
8010398d:	90                   	nop
8010398e:	90                   	nop
8010398f:	90                   	nop

80103990 <forkret>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 18             	sub    $0x18,%esp
  release(&ptable.lock);
80103996:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
8010399d:	e8 5e 1f 00 00       	call   80105900 <release>
  if (first) {
801039a2:	8b 15 00 c0 10 80    	mov    0x8010c000,%edx
801039a8:	85 d2                	test   %edx,%edx
801039aa:	75 04                	jne    801039b0 <forkret+0x20>
}
801039ac:	c9                   	leave  
801039ad:	c3                   	ret    
801039ae:	66 90                	xchg   %ax,%ax
    first = 0;
801039b0:	31 c0                	xor    %eax,%eax
    iinit(ROOTDEV);
801039b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801039b9:	a3 00 c0 10 80       	mov    %eax,0x8010c000
    iinit(ROOTDEV);
801039be:	e8 fd da ff ff       	call   801014c0 <iinit>
    initlog(ROOTDEV);
801039c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039ca:	e8 d1 f2 ff ff       	call   80102ca0 <initlog>
}
801039cf:	c9                   	leave  
801039d0:	c3                   	ret    
801039d1:	eb 0d                	jmp    801039e0 <getAccumulator>
801039d3:	90                   	nop
801039d4:	90                   	nop
801039d5:	90                   	nop
801039d6:	90                   	nop
801039d7:	90                   	nop
801039d8:	90                   	nop
801039d9:	90                   	nop
801039da:	90                   	nop
801039db:	90                   	nop
801039dc:	90                   	nop
801039dd:	90                   	nop
801039de:	90                   	nop
801039df:	90                   	nop

801039e0 <getAccumulator>:
long long getAccumulator(struct proc *p) {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
  return p->accumulator;
801039e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801039e6:	5d                   	pop    %ebp
  return p->accumulator;
801039e7:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801039ed:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801039f3:	c3                   	ret    
801039f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a00 <pinit>:
{
80103a00:	55                   	push   %ebp
  initlock(&ptable.lock, "ptable");
80103a01:	b8 a5 8a 10 80       	mov    $0x80108aa5,%eax
{
80103a06:	89 e5                	mov    %esp,%ebp
80103a08:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a0f:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103a16:	e8 f5 1c 00 00       	call   80105710 <initlock>
}
80103a1b:	c9                   	leave  
80103a1c:	c3                   	ret    
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi

80103a20 <mycpu>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
80103a25:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a28:	9c                   	pushf  
80103a29:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a2a:	f6 c4 02             	test   $0x2,%ah
80103a2d:	75 5b                	jne    80103a8a <mycpu+0x6a>
  apicid = lapicid();
80103a2f:	e8 ac ee ff ff       	call   801028e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a34:	8b 35 60 4d 11 80    	mov    0x80114d60,%esi
80103a3a:	85 f6                	test   %esi,%esi
80103a3c:	7e 40                	jle    80103a7e <mycpu+0x5e>
    if (cpus[i].apicid == apicid)
80103a3e:	0f b6 15 e0 47 11 80 	movzbl 0x801147e0,%edx
80103a45:	39 d0                	cmp    %edx,%eax
80103a47:	74 2e                	je     80103a77 <mycpu+0x57>
80103a49:	b9 90 48 11 80       	mov    $0x80114890,%ecx
  for (i = 0; i < ncpu; ++i) {
80103a4e:	31 d2                	xor    %edx,%edx
80103a50:	42                   	inc    %edx
80103a51:	39 f2                	cmp    %esi,%edx
80103a53:	74 29                	je     80103a7e <mycpu+0x5e>
    if (cpus[i].apicid == apicid)
80103a55:	0f b6 19             	movzbl (%ecx),%ebx
80103a58:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103a5e:	39 c3                	cmp    %eax,%ebx
80103a60:	75 ee                	jne    80103a50 <mycpu+0x30>
80103a62:	8d 04 92             	lea    (%edx,%edx,4),%eax
80103a65:	8d 04 42             	lea    (%edx,%eax,2),%eax
80103a68:	c1 e0 04             	shl    $0x4,%eax
80103a6b:	05 e0 47 11 80       	add    $0x801147e0,%eax
}
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	5b                   	pop    %ebx
80103a74:	5e                   	pop    %esi
80103a75:	5d                   	pop    %ebp
80103a76:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a77:	b8 e0 47 11 80       	mov    $0x801147e0,%eax
      return &cpus[i];
80103a7c:	eb f2                	jmp    80103a70 <mycpu+0x50>
  panic("unknown apicid\n");
80103a7e:	c7 04 24 ac 8a 10 80 	movl   $0x80108aac,(%esp)
80103a85:	e8 e6 c8 ff ff       	call   80100370 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a8a:	c7 04 24 d4 8b 10 80 	movl   $0x80108bd4,(%esp)
80103a91:	e8 da c8 ff ff       	call   80100370 <panic>
80103a96:	8d 76 00             	lea    0x0(%esi),%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103aa0 <cpuid>:
cpuid() {
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103aa6:	e8 75 ff ff ff       	call   80103a20 <mycpu>
}
80103aab:	c9                   	leave  
  return mycpu()-cpus;
80103aac:	2d e0 47 11 80       	sub    $0x801147e0,%eax
80103ab1:	c1 f8 04             	sar    $0x4,%eax
80103ab4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aba:	c3                   	ret    
80103abb:	90                   	nop
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <myproc>:
myproc(void) {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
80103ac4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ac7:	e8 b4 1c 00 00       	call   80105780 <pushcli>
  c = mycpu();
80103acc:	e8 4f ff ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103ad1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad7:	e8 e4 1c 00 00       	call   801057c0 <popcli>
}
80103adc:	5a                   	pop    %edx
80103add:	89 d8                	mov    %ebx,%eax
80103adf:	5b                   	pop    %ebx
80103ae0:	5d                   	pop    %ebp
80103ae1:	c3                   	ret    
80103ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103af0 <userinit>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
80103af4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103af7:	e8 b4 fd ff ff       	call   801038b0 <allocproc>
80103afc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103afe:	a3 bc c5 10 80       	mov    %eax,0x8010c5bc
  if((p->pgdir = setupkvm()) == 0)
80103b03:	e8 38 47 00 00       	call   80108240 <setupkvm>
80103b08:	85 c0                	test   %eax,%eax
80103b0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b0d:	0f 84 2b 01 00 00    	je     80103c3e <userinit+0x14e>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b13:	b9 60 c4 10 80       	mov    $0x8010c460,%ecx
80103b18:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103b1d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80103b21:	89 54 24 08          	mov    %edx,0x8(%esp)
80103b25:	89 04 24             	mov    %eax,(%esp)
80103b28:	e8 e3 43 00 00       	call   80107f10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b2d:	b8 4c 00 00 00       	mov    $0x4c,%eax
  p->sz = PGSIZE;
80103b32:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b38:	89 44 24 08          	mov    %eax,0x8(%esp)
80103b3c:	31 c0                	xor    %eax,%eax
80103b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b42:	8b 43 18             	mov    0x18(%ebx),%eax
80103b45:	89 04 24             	mov    %eax,(%esp)
80103b48:	e8 03 1e 00 00       	call   80105950 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4d:	8b 43 18             	mov    0x18(%ebx),%eax
80103b50:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b56:	8b 43 18             	mov    0x18(%ebx),%eax
80103b59:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b62:	8b 50 2c             	mov    0x2c(%eax),%edx
80103b65:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b69:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6c:	8b 50 2c             	mov    0x2c(%eax),%edx
80103b6f:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b73:	8b 43 18             	mov    0x18(%ebx),%eax
80103b76:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b7d:	8b 43 18             	mov    0x18(%ebx),%eax
80103b80:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b87:	8b 43 18             	mov    0x18(%ebx),%eax
80103b8a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b91:	b8 10 00 00 00       	mov    $0x10,%eax
80103b96:	89 44 24 08          	mov    %eax,0x8(%esp)
80103b9a:	b8 d5 8a 10 80       	mov    $0x80108ad5,%eax
80103b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ba3:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ba6:	89 04 24             	mov    %eax,(%esp)
80103ba9:	e8 82 1f 00 00       	call   80105b30 <safestrcpy>
  p->cwd = namei("/");
80103bae:	c7 04 24 de 8a 10 80 	movl   $0x80108ade,(%esp)
80103bb5:	e8 c6 e4 ff ff       	call   80102080 <namei>
  p->waitingTime = 0;
80103bba:	31 c9                	xor    %ecx,%ecx
  p->priority = 5;
80103bbc:	ba 05 00 00 00       	mov    $0x5,%edx
80103bc1:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
  p->waitingTime = 0;
80103bc7:	89 8b 8c 00 00 00    	mov    %ecx,0x8c(%ebx)
  p->cwd = namei("/");
80103bcd:	89 43 68             	mov    %eax,0x68(%ebx)
  p->accumulator = 0;
80103bd0:	31 c0                	xor    %eax,%eax
80103bd2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
80103bd8:	31 c0                	xor    %eax,%eax
80103bda:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  p->waitingTime = 0;
80103be0:	31 c0                	xor    %eax,%eax
80103be2:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  acquire(&ptable.lock);
80103be8:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103bef:	e8 6c 1c 00 00       	call   80105860 <acquire>
  if(currPolicy == ROUND_ROBIN){
80103bf4:	83 3d 04 c0 10 80 01 	cmpl   $0x1,0x8010c004
  p->state = RUNNABLE;
80103bfb:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    if(!rrq.enqueue(p)){
80103c02:	89 1c 24             	mov    %ebx,(%esp)
  if(currPolicy == ROUND_ROBIN){
80103c05:	74 21                	je     80103c28 <userinit+0x138>
    if(!pq.put(p)){
80103c07:	ff 15 e4 c5 10 80    	call   *0x8010c5e4
80103c0d:	85 c0                	test   %eax,%eax
80103c0f:	74 39                	je     80103c4a <userinit+0x15a>
  release(&ptable.lock);
80103c11:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103c18:	e8 e3 1c 00 00       	call   80105900 <release>
}
80103c1d:	83 c4 14             	add    $0x14,%esp
80103c20:	5b                   	pop    %ebx
80103c21:	5d                   	pop    %ebp
80103c22:	c3                   	ret    
80103c23:	90                   	nop
80103c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!rrq.enqueue(p)){
80103c28:	ff 15 d4 c5 10 80    	call   *0x8010c5d4
80103c2e:	85 c0                	test   %eax,%eax
80103c30:	75 df                	jne    80103c11 <userinit+0x121>
      panic("add to rrq has a problem, function:userinit");
80103c32:	c7 04 24 fc 8b 10 80 	movl   $0x80108bfc,(%esp)
80103c39:	e8 32 c7 ff ff       	call   80100370 <panic>
    panic("userinit: out of memory?");
80103c3e:	c7 04 24 bc 8a 10 80 	movl   $0x80108abc,(%esp)
80103c45:	e8 26 c7 ff ff       	call   80100370 <panic>
      panic("add to pq has a problem, function:userinit");
80103c4a:	c7 04 24 28 8c 10 80 	movl   $0x80108c28,(%esp)
80103c51:	e8 1a c7 ff ff       	call   80100370 <panic>
80103c56:	8d 76 00             	lea    0x0(%esi),%esi
80103c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c60 <growproc>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	53                   	push   %ebx
80103c65:	83 ec 10             	sub    $0x10,%esp
80103c68:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c6b:	e8 10 1b 00 00       	call   80105780 <pushcli>
  c = mycpu();
80103c70:	e8 ab fd ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103c75:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c7b:	e8 40 1b 00 00       	call   801057c0 <popcli>
  if(n > 0){
80103c80:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c83:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c85:	7f 19                	jg     80103ca0 <growproc+0x40>
  } else if(n < 0){
80103c87:	75 37                	jne    80103cc0 <growproc+0x60>
  curproc->sz = sz;
80103c89:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c8b:	89 1c 24             	mov    %ebx,(%esp)
80103c8e:	e8 7d 41 00 00       	call   80107e10 <switchuvm>
  return 0;
80103c93:	31 c0                	xor    %eax,%eax
}
80103c95:	83 c4 10             	add    $0x10,%esp
80103c98:	5b                   	pop    %ebx
80103c99:	5e                   	pop    %esi
80103c9a:	5d                   	pop    %ebp
80103c9b:	c3                   	ret    
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca0:	01 c6                	add    %eax,%esi
80103ca2:	89 74 24 08          	mov    %esi,0x8(%esp)
80103ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
80103caa:	8b 43 04             	mov    0x4(%ebx),%eax
80103cad:	89 04 24             	mov    %eax,(%esp)
80103cb0:	e8 ab 43 00 00       	call   80108060 <allocuvm>
80103cb5:	85 c0                	test   %eax,%eax
80103cb7:	75 d0                	jne    80103c89 <growproc+0x29>
      return -1;
80103cb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cbe:	eb d5                	jmp    80103c95 <growproc+0x35>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc0:	01 c6                	add    %eax,%esi
80103cc2:	89 74 24 08          	mov    %esi,0x8(%esp)
80103cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cca:	8b 43 04             	mov    0x4(%ebx),%eax
80103ccd:	89 04 24             	mov    %eax,(%esp)
80103cd0:	e8 bb 44 00 00       	call   80108190 <deallocuvm>
80103cd5:	85 c0                	test   %eax,%eax
80103cd7:	75 b0                	jne    80103c89 <growproc+0x29>
80103cd9:	eb de                	jmp    80103cb9 <growproc+0x59>
80103cdb:	90                   	nop
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <fork>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
80103ce5:	53                   	push   %ebx
80103ce6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ce9:	e8 92 1a 00 00       	call   80105780 <pushcli>
  c = mycpu();
80103cee:	e8 2d fd ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103cf3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103cf9:	e8 c2 1a 00 00       	call   801057c0 <popcli>
  if((np = allocproc()) == 0){
80103cfe:	e8 ad fb ff ff       	call   801038b0 <allocproc>
80103d03:	85 c0                	test   %eax,%eax
80103d05:	0f 84 1e 01 00 00    	je     80103e29 <fork+0x149>
80103d0b:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d0d:	8b 06                	mov    (%esi),%eax
80103d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d13:	8b 46 04             	mov    0x4(%esi),%eax
80103d16:	89 04 24             	mov    %eax,(%esp)
80103d19:	e8 f2 45 00 00       	call   80108310 <copyuvm>
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	89 47 04             	mov    %eax,0x4(%edi)
80103d23:	0f 84 e7 00 00 00    	je     80103e10 <fork+0x130>
  np->sz = curproc->sz;
80103d29:	8b 06                	mov    (%esi),%eax
  np->parent = curproc;
80103d2b:	89 77 14             	mov    %esi,0x14(%edi)
  *np->tf = *curproc->tf;
80103d2e:	8b 57 18             	mov    0x18(%edi),%edx
  np->sz = curproc->sz;
80103d31:	89 07                	mov    %eax,(%edi)
  *np->tf = *curproc->tf;
80103d33:	31 c0                	xor    %eax,%eax
80103d35:	8b 4e 18             	mov    0x18(%esi),%ecx
80103d38:	8b 1c 01             	mov    (%ecx,%eax,1),%ebx
80103d3b:	89 1c 02             	mov    %ebx,(%edx,%eax,1)
80103d3e:	83 c0 04             	add    $0x4,%eax
80103d41:	83 f8 4c             	cmp    $0x4c,%eax
80103d44:	72 f2                	jb     80103d38 <fork+0x58>
  np->tf->eax = 0;
80103d46:	8b 47 18             	mov    0x18(%edi),%eax
  for(i = 0; i < NOFILE; i++)
80103d49:	31 db                	xor    %ebx,%ebx
  np->tf->eax = 0;
80103d4b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
80103d60:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103d64:	85 c0                	test   %eax,%eax
80103d66:	74 0c                	je     80103d74 <fork+0x94>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d68:	89 04 24             	mov    %eax,(%esp)
80103d6b:	e8 50 d0 ff ff       	call   80100dc0 <filedup>
80103d70:	89 44 9f 28          	mov    %eax,0x28(%edi,%ebx,4)
  for(i = 0; i < NOFILE; i++)
80103d74:	43                   	inc    %ebx
80103d75:	83 fb 10             	cmp    $0x10,%ebx
80103d78:	75 e6                	jne    80103d60 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103d7a:	8b 46 68             	mov    0x68(%esi),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d7d:	83 c6 6c             	add    $0x6c,%esi
  np->priority = 5;
80103d80:	bb 05 00 00 00       	mov    $0x5,%ebx
  np->cwd = idup(curproc->cwd);
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 43 d9 ff ff       	call   801016d0 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d8d:	b9 10 00 00 00       	mov    $0x10,%ecx
  np->cwd = idup(curproc->cwd);
80103d92:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d95:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103d9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  np->waitingTime = 0;
80103da0:	31 f6                	xor    %esi,%esi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103da2:	89 04 24             	mov    %eax,(%esp)
80103da5:	e8 86 1d 00 00       	call   80105b30 <safestrcpy>
  acquire(&ptable.lock);
80103daa:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103db1:	e8 aa 1a 00 00       	call   80105860 <acquire>
  np->waitingTime = 0;
80103db6:	31 c0                	xor    %eax,%eax
  np->priority = 5;
80103db8:	89 9f 80 00 00 00    	mov    %ebx,0x80(%edi)
  np->state = RUNNABLE;
80103dbe:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->waitingTime = 0;
80103dc5:	89 b7 8c 00 00 00    	mov    %esi,0x8c(%edi)
80103dcb:	89 87 90 00 00 00    	mov    %eax,0x90(%edi)
  boolean notEmptyRunnable = pq.getMinAccumulator(accRunnable);
80103dd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103dd8:	ff 15 e8 c5 10 80    	call   *0x8010c5e8
  boolean notEmptyRunning = rpholder.getMinAccumulator(accRunning);
80103dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  boolean notEmptyRunnable = pq.getMinAccumulator(accRunnable);
80103de5:	89 c3                	mov    %eax,%ebx
  boolean notEmptyRunning = rpholder.getMinAccumulator(accRunning);
80103de7:	ff 15 cc c5 10 80    	call   *0x8010c5cc
  if(!notEmptyRunnable && !notEmptyRunning){
80103ded:	89 da                	mov    %ebx,%edx
80103def:	09 c2                	or     %eax,%edx
80103df1:	75 4d                	jne    80103e40 <fork+0x160>
    np->accumulator = 0;
80103df3:	31 c0                	xor    %eax,%eax
80103df5:	31 d2                	xor    %edx,%edx
80103df7:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
80103dfd:	89 97 88 00 00 00    	mov    %edx,0x88(%edi)
    np->accumulator = (*accRunning > *accRunnable) ? *accRunnable : *accRunning ;
80103e03:	a1 00 00 00 00       	mov    0x0,%eax
80103e08:	8b 15 04 00 00 00    	mov    0x4,%edx
80103e0e:	0f 0b                	ud2    
    kfree(np->kstack);
80103e10:	8b 47 08             	mov    0x8(%edi),%eax
80103e13:	89 04 24             	mov    %eax,(%esp)
80103e16:	e8 75 e6 ff ff       	call   80102490 <kfree>
    np->kstack = 0;
80103e1b:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103e22:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
}
80103e29:	83 c4 1c             	add    $0x1c,%esp
80103e2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e31:	5b                   	pop    %ebx
80103e32:	5e                   	pop    %esi
80103e33:	5f                   	pop    %edi
80103e34:	5d                   	pop    %ebp
80103e35:	c3                   	ret    
80103e36:	8d 76 00             	lea    0x0(%esi),%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(!notEmptyRunnable && notEmptyRunning ){
80103e40:	85 db                	test   %ebx,%ebx
80103e42:	75 bf                	jne    80103e03 <fork+0x123>
80103e44:	eb bd                	jmp    80103e03 <fork+0x123>
80103e46:	8d 76 00             	lea    0x0(%esi),%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e50 <detach>:
detach(int pid){
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	56                   	push   %esi
80103e54:	53                   	push   %ebx
80103e55:	83 ec 10             	sub    $0x10,%esp
80103e58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103e5b:	e8 20 19 00 00       	call   80105780 <pushcli>
  c = mycpu();
80103e60:	e8 bb fb ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103e65:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e6b:	e8 50 19 00 00       	call   801057c0 <popcli>
  acquire(&ptable.lock);
80103e70:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103e77:	e8 e4 19 00 00       	call   80105860 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7c:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80103e81:	eb 11                	jmp    80103e94 <detach+0x44>
80103e83:	90                   	nop
80103e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e88:	05 94 00 00 00       	add    $0x94,%eax
80103e8d:	3d b4 72 11 80       	cmp    $0x801172b4,%eax
80103e92:	73 2c                	jae    80103ec0 <detach+0x70>
    if(p->pid == pid ){
80103e94:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e97:	75 ef                	jne    80103e88 <detach+0x38>
      if(p->parent == curproc){
80103e99:	39 70 14             	cmp    %esi,0x14(%eax)
80103e9c:	75 26                	jne    80103ec4 <detach+0x74>
        p->parent = initproc;
80103e9e:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
  int returnValue = 0;
80103ea4:	31 db                	xor    %ebx,%ebx
        p->parent = initproc;
80103ea6:	89 50 14             	mov    %edx,0x14(%eax)
  release(&ptable.lock);
80103ea9:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103eb0:	e8 4b 1a 00 00       	call   80105900 <release>
}
80103eb5:	83 c4 10             	add    $0x10,%esp
80103eb8:	89 d8                	mov    %ebx,%eax
80103eba:	5b                   	pop    %ebx
80103ebb:	5e                   	pop    %esi
80103ebc:	5d                   	pop    %ebp
80103ebd:	c3                   	ret    
80103ebe:	66 90                	xchg   %ax,%ax
  int returnValue = 0;
80103ec0:	31 db                	xor    %ebx,%ebx
80103ec2:	eb e5                	jmp    80103ea9 <detach+0x59>
        returnValue = -1;
80103ec4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ec9:	eb de                	jmp    80103ea9 <detach+0x59>
80103ecb:	90                   	nop
80103ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <policy>:
policy(int policy){ //1 - round robin , 2 - priority , 3 - extended priority
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
80103ed4:	83 ec 14             	sub    $0x14,%esp
80103ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(policy < 1 || policy > 3){
80103eda:	8d 43 ff             	lea    -0x1(%ebx),%eax
80103edd:	83 f8 02             	cmp    $0x2,%eax
80103ee0:	0f 87 a0 00 00 00    	ja     80103f86 <policy+0xb6>
  acquire(&ptable.lock);
80103ee6:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103eed:	e8 6e 19 00 00       	call   80105860 <acquire>
  if(policy == ROUND_ROBIN){
80103ef2:	83 fb 01             	cmp    $0x1,%ebx
80103ef5:	74 29                	je     80103f20 <policy+0x50>
  else if(policy == PRIORITY){
80103ef7:	83 fb 02             	cmp    $0x2,%ebx
80103efa:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
80103f00:	74 4f                	je     80103f51 <policy+0x81>
    rrq.switchToPriorityQueuePolicy();
80103f02:	ff d2                	call   *%edx
  currPolicy = policy;
80103f04:	89 1d 04 c0 10 80    	mov    %ebx,0x8010c004
  release(&ptable.lock);
80103f0a:	c7 45 08 80 4d 11 80 	movl   $0x80114d80,0x8(%ebp)
}
80103f11:	83 c4 14             	add    $0x14,%esp
80103f14:	5b                   	pop    %ebx
80103f15:	5d                   	pop    %ebp
  release(&ptable.lock);
80103f16:	e9 e5 19 00 00       	jmp    80105900 <release>
80103f1b:	90                   	nop
80103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f20:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80103f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p->accumulator = 0;
80103f30:	31 d2                	xor    %edx,%edx
80103f32:	31 c9                	xor    %ecx,%ecx
80103f34:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3a:	05 94 00 00 00       	add    $0x94,%eax
      p->accumulator = 0;
80103f3f:	89 48 f4             	mov    %ecx,-0xc(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f42:	3d b4 72 11 80       	cmp    $0x801172b4,%eax
80103f47:	72 e7                	jb     80103f30 <policy+0x60>
    pq.switchToRoundRobinPolicy();
80103f49:	ff 15 f0 c5 10 80    	call   *0x8010c5f0
80103f4f:	eb b3                	jmp    80103f04 <policy+0x34>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f51:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80103f56:	8d 76 00             	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->priority == 0){
80103f60:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80103f66:	85 c9                	test   %ecx,%ecx
80103f68:	75 0b                	jne    80103f75 <policy+0xa5>
        p->priority = 1;
80103f6a:	b9 01 00 00 00       	mov    $0x1,%ecx
80103f6f:	89 88 80 00 00 00    	mov    %ecx,0x80(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f75:	05 94 00 00 00       	add    $0x94,%eax
80103f7a:	3d b4 72 11 80       	cmp    $0x801172b4,%eax
80103f7f:	72 df                	jb     80103f60 <policy+0x90>
80103f81:	e9 7c ff ff ff       	jmp    80103f02 <policy+0x32>
    panic("bad policy choise");
80103f86:	c7 04 24 e0 8a 10 80 	movl   $0x80108ae0,(%esp)
80103f8d:	e8 de c3 ff ff       	call   80100370 <panic>
80103f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <priority>:
priority(int priority){
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	83 ec 18             	sub    $0x18,%esp
80103fa6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80103fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  pushcli();
80103faf:	e8 cc 17 00 00       	call   80105780 <pushcli>
  c = mycpu();
80103fb4:	e8 67 fa ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103fb9:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fbf:	e8 fc 17 00 00       	call   801057c0 <popcli>
  if(currPolicy != PRIORITY){
80103fc4:	83 3d 04 c0 10 80 02 	cmpl   $0x2,0x8010c004
80103fcb:	74 33                	je     80104000 <priority+0x60>
    if(priority < 1 || priority > 10){
80103fcd:	8d 43 ff             	lea    -0x1(%ebx),%eax
80103fd0:	83 f8 09             	cmp    $0x9,%eax
80103fd3:	77 30                	ja     80104005 <priority+0x65>
  acquire(&ptable.lock);
80103fd5:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103fdc:	e8 7f 18 00 00       	call   80105860 <acquire>
  curproc->priority = priority;
80103fe1:	89 9e 80 00 00 00    	mov    %ebx,0x80(%esi)
}
80103fe7:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  release(&ptable.lock);
80103fea:	c7 45 08 80 4d 11 80 	movl   $0x80114d80,0x8(%ebp)
}
80103ff1:	8b 75 fc             	mov    -0x4(%ebp),%esi
80103ff4:	89 ec                	mov    %ebp,%esp
80103ff6:	5d                   	pop    %ebp
  release(&ptable.lock);
80103ff7:	e9 04 19 00 00       	jmp    80105900 <release>
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     if(priority < 0 || priority > 10){
80104000:	83 fb 0a             	cmp    $0xa,%ebx
80104003:	76 d0                	jbe    80103fd5 <priority+0x35>
      panic ("bad priority");
80104005:	c7 04 24 f2 8a 10 80 	movl   $0x80108af2,(%esp)
8010400c:	e8 5f c3 ff ff       	call   80100370 <panic>
80104011:	eb 0d                	jmp    80104020 <getMaxWaitingTime>
80104013:	90                   	nop
80104014:	90                   	nop
80104015:	90                   	nop
80104016:	90                   	nop
80104017:	90                   	nop
80104018:	90                   	nop
80104019:	90                   	nop
8010401a:	90                   	nop
8010401b:	90                   	nop
8010401c:	90                   	nop
8010401d:	90                   	nop
8010401e:	90                   	nop
8010401f:	90                   	nop

80104020 <getMaxWaitingTime>:
getMaxWaitingTime (){
80104020:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104021:	ba b4 4d 11 80       	mov    $0x80114db4,%edx
getMaxWaitingTime (){
80104026:	89 e5                	mov    %esp,%ebp
  struct proc *maxProc = null;
80104028:	31 c0                	xor    %eax,%eax
getMaxWaitingTime (){
8010402a:	57                   	push   %edi
  long long maxValue = 0;
8010402b:	31 ff                	xor    %edi,%edi
getMaxWaitingTime (){
8010402d:	56                   	push   %esi
  long long maxValue = 0;
8010402e:	31 f6                	xor    %esi,%esi
getMaxWaitingTime (){
80104030:	53                   	push   %ebx
80104031:	eb 0d                	jmp    80104040 <getMaxWaitingTime+0x20>
80104033:	90                   	nop
80104034:	90                   	nop
80104035:	90                   	nop
80104036:	90                   	nop
80104037:	90                   	nop
80104038:	90                   	nop
80104039:	90                   	nop
8010403a:	90                   	nop
8010403b:	90                   	nop
8010403c:	90                   	nop
8010403d:	90                   	nop
8010403e:	90                   	nop
8010403f:	90                   	nop
    if(p->waitingTime > maxValue){
80104040:	8b 8a 90 00 00 00    	mov    0x90(%edx),%ecx
80104046:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
8010404c:	39 f1                	cmp    %esi,%ecx
8010404e:	7c 0c                	jl     8010405c <getMaxWaitingTime+0x3c>
80104050:	7f 04                	jg     80104056 <getMaxWaitingTime+0x36>
80104052:	39 fb                	cmp    %edi,%ebx
80104054:	76 06                	jbe    8010405c <getMaxWaitingTime+0x3c>
80104056:	89 df                	mov    %ebx,%edi
80104058:	89 ce                	mov    %ecx,%esi
8010405a:	89 d0                	mov    %edx,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405c:	81 c2 94 00 00 00    	add    $0x94,%edx
80104062:	81 fa b4 72 11 80    	cmp    $0x801172b4,%edx
80104068:	72 d6                	jb     80104040 <getMaxWaitingTime+0x20>
}
8010406a:	5b                   	pop    %ebx
8010406b:	5e                   	pop    %esi
8010406c:	5f                   	pop    %edi
8010406d:	5d                   	pop    %ebp
8010406e:	c3                   	ret    
8010406f:	90                   	nop

80104070 <scheduler>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
  struct proc *p = null;
80104076:	31 db                	xor    %ebx,%ebx
{
80104078:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
8010407b:	e8 a0 f9 ff ff       	call   80103a20 <mycpu>
  c->proc = 0;
80104080:	31 d2                	xor    %edx,%edx
80104082:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
  struct cpu *c = mycpu();
80104088:	89 c7                	mov    %eax,%edi
      swtch(&(c->scheduler), p->context);
8010408a:	8d 40 04             	lea    0x4(%eax),%eax
8010408d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104090:	e9 87 00 00 00       	jmp    8010411c <scheduler+0xac>
80104095:	8d 76 00             	lea    0x0(%esi),%esi
    switch(currPolicy){
80104098:	83 f8 03             	cmp    $0x3,%eax
8010409b:	0f 84 ef 00 00 00    	je     80104190 <scheduler+0x120>
801040a1:	48                   	dec    %eax
801040a2:	0f 84 b8 00 00 00    	je     80104160 <scheduler+0xf0>
    if(p != null){
801040a8:	85 db                	test   %ebx,%ebx
801040aa:	74 64                	je     80104110 <scheduler+0xa0>
      cprintf("Current state = %d\n", p->state);
801040ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801040af:	c7 04 24 ff 8a 10 80 	movl   $0x80108aff,(%esp)
801040b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801040ba:	e8 91 c5 ff ff       	call   80100650 <cprintf>
      c->proc = p;
801040bf:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
      switchuvm(p);
801040c5:	89 1c 24             	mov    %ebx,(%esp)
801040c8:	e8 43 3d 00 00       	call   80107e10 <switchuvm>
      p->state = RUNNING;
801040cd:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      cprintf("add now \n");
801040d4:	c7 04 24 13 8b 10 80 	movl   $0x80108b13,(%esp)
801040db:	e8 70 c5 ff ff       	call   80100650 <cprintf>
      if(!rpholder.add(p)){
801040e0:	89 1c 24             	mov    %ebx,(%esp)
801040e3:	ff 15 c4 c5 10 80    	call   *0x8010c5c4
801040e9:	85 c0                	test   %eax,%eax
801040eb:	0f 84 08 01 00 00    	je     801041f9 <scheduler+0x189>
      swtch(&(c->scheduler), p->context);
801040f1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801040f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801040f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801040fb:	89 04 24             	mov    %eax,(%esp)
801040fe:	e8 86 1a 00 00       	call   80105b89 <swtch>
      switchkvm();
80104103:	e8 e8 3c 00 00       	call   80107df0 <switchkvm>
      c->proc = 0;
80104108:	31 c0                	xor    %eax,%eax
8010410a:	89 87 ac 00 00 00    	mov    %eax,0xac(%edi)
    release(&ptable.lock);
80104110:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104117:	e8 e4 17 00 00       	call   80105900 <release>
  asm volatile("sti");
8010411c:	fb                   	sti    
    acquire(&ptable.lock);
8010411d:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104124:	e8 37 17 00 00       	call   80105860 <acquire>
    switch(currPolicy){
80104129:	a1 04 c0 10 80       	mov    0x8010c004,%eax
8010412e:	83 f8 02             	cmp    $0x2,%eax
80104131:	0f 85 61 ff ff ff    	jne    80104098 <scheduler+0x28>
         p = pq.extractMin();
80104137:	ff 15 ec c5 10 80    	call   *0x8010c5ec
8010413d:	89 c3                	mov    %eax,%ebx
         if(!pq.extractProc(p)){
8010413f:	89 1c 24             	mov    %ebx,(%esp)
80104142:	ff 15 f4 c5 10 80    	call   *0x8010c5f4
80104148:	85 c0                	test   %eax,%eax
8010414a:	0f 85 58 ff ff ff    	jne    801040a8 <scheduler+0x38>
            panic("remove from pq has a problem, function:scheduler");
80104150:	c7 04 24 88 8c 10 80 	movl   $0x80108c88,(%esp)
80104157:	e8 14 c2 ff ff       	call   80100370 <panic>
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(!rrq.isEmpty()){
80104160:	ff 15 d0 c5 10 80    	call   *0x8010c5d0
80104166:	85 c0                	test   %eax,%eax
80104168:	0f 85 3a ff ff ff    	jne    801040a8 <scheduler+0x38>
8010416e:	66 90                	xchg   %ax,%ax
          p = rrq.dequeue();
80104170:	ff 15 d8 c5 10 80    	call   *0x8010c5d8
          if(p == null){
80104176:	85 c0                	test   %eax,%eax
          p = rrq.dequeue();
80104178:	89 c3                	mov    %eax,%ebx
          if(p == null){
8010417a:	0f 85 2c ff ff ff    	jne    801040ac <scheduler+0x3c>
            panic("remove from rrq has a problem, function:scheduler");
80104180:	c7 04 24 54 8c 10 80 	movl   $0x80108c54,(%esp)
80104187:	e8 e4 c1 ff ff       	call   80100370 <panic>
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(quantumTime >= 100){
80104190:	83 3d b8 c5 10 80 63 	cmpl   $0x63,0x8010c5b8
80104197:	7e 9e                	jle    80104137 <scheduler+0xc7>
  long long maxValue = 0;
80104199:	31 c9                	xor    %ecx,%ecx
  struct proc *maxProc = null;
8010419b:	31 db                	xor    %ebx,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010419d:	89 7d e0             	mov    %edi,-0x20(%ebp)
  long long maxValue = 0;
801041a0:	31 f6                	xor    %esi,%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a2:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
          quantumTime = 0;
801041a7:	c7 05 b8 c5 10 80 00 	movl   $0x0,0x8010c5b8
801041ae:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b1:	89 cf                	mov    %ecx,%edi
801041b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(p->waitingTime > maxValue){
801041c0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801041c6:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
801041cc:	39 f2                	cmp    %esi,%edx
801041ce:	7c 0c                	jl     801041dc <scheduler+0x16c>
801041d0:	7f 04                	jg     801041d6 <scheduler+0x166>
801041d2:	39 f9                	cmp    %edi,%ecx
801041d4:	76 06                	jbe    801041dc <scheduler+0x16c>
801041d6:	89 cf                	mov    %ecx,%edi
801041d8:	89 d6                	mov    %edx,%esi
801041da:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041dc:	05 94 00 00 00       	add    $0x94,%eax
801041e1:	3d b4 72 11 80       	cmp    $0x801172b4,%eax
801041e6:	72 d8                	jb     801041c0 <scheduler+0x150>
          pq.extractProc(p);
801041e8:	89 1c 24             	mov    %ebx,(%esp)
801041eb:	8b 7d e0             	mov    -0x20(%ebp),%edi
801041ee:	ff 15 f4 c5 10 80    	call   *0x8010c5f4
801041f4:	e9 46 ff ff ff       	jmp    8010413f <scheduler+0xcf>
        panic("add to rp has a problem, function:scheduler");
801041f9:	c7 04 24 bc 8c 10 80 	movl   $0x80108cbc,(%esp)
80104200:	e8 6b c1 ff ff       	call   80100370 <panic>
80104205:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104210 <sched>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
80104215:	83 ec 10             	sub    $0x10,%esp
  pushcli();
80104218:	e8 63 15 00 00       	call   80105780 <pushcli>
  c = mycpu();
8010421d:	e8 fe f7 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104222:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104228:	e8 93 15 00 00       	call   801057c0 <popcli>
  if(!holding(&ptable.lock))
8010422d:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104234:	e8 e7 15 00 00       	call   80105820 <holding>
80104239:	85 c0                	test   %eax,%eax
8010423b:	74 51                	je     8010428e <sched+0x7e>
  if(mycpu()->ncli != 1)
8010423d:	e8 de f7 ff ff       	call   80103a20 <mycpu>
80104242:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104249:	75 67                	jne    801042b2 <sched+0xa2>
  if(p->state == RUNNING)
8010424b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010424e:	83 f8 04             	cmp    $0x4,%eax
80104251:	74 53                	je     801042a6 <sched+0x96>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104253:	9c                   	pushf  
80104254:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104255:	f6 c4 02             	test   $0x2,%ah
80104258:	75 40                	jne    8010429a <sched+0x8a>
  intena = mycpu()->intena;
8010425a:	e8 c1 f7 ff ff       	call   80103a20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010425f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104262:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104268:	e8 b3 f7 ff ff       	call   80103a20 <mycpu>
8010426d:	8b 40 04             	mov    0x4(%eax),%eax
80104270:	89 1c 24             	mov    %ebx,(%esp)
80104273:	89 44 24 04          	mov    %eax,0x4(%esp)
80104277:	e8 0d 19 00 00       	call   80105b89 <swtch>
  mycpu()->intena = intena;
8010427c:	e8 9f f7 ff ff       	call   80103a20 <mycpu>
80104281:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	5b                   	pop    %ebx
8010428b:	5e                   	pop    %esi
8010428c:	5d                   	pop    %ebp
8010428d:	c3                   	ret    
    panic("sched ptable.lock");
8010428e:	c7 04 24 1d 8b 10 80 	movl   $0x80108b1d,(%esp)
80104295:	e8 d6 c0 ff ff       	call   80100370 <panic>
    panic("sched interruptible");
8010429a:	c7 04 24 49 8b 10 80 	movl   $0x80108b49,(%esp)
801042a1:	e8 ca c0 ff ff       	call   80100370 <panic>
    panic("sched running");
801042a6:	c7 04 24 3b 8b 10 80 	movl   $0x80108b3b,(%esp)
801042ad:	e8 be c0 ff ff       	call   80100370 <panic>
    panic("sched locks");
801042b2:	c7 04 24 2f 8b 10 80 	movl   $0x80108b2f,(%esp)
801042b9:	e8 b2 c0 ff ff       	call   80100370 <panic>
801042be:	66 90                	xchg   %ax,%ax

801042c0 <exit>:
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	57                   	push   %edi
801042c4:	56                   	push   %esi
801042c5:	53                   	push   %ebx
801042c6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042c9:	e8 b2 14 00 00       	call   80105780 <pushcli>
  c = mycpu();
801042ce:	e8 4d f7 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
801042d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042d9:	e8 e2 14 00 00       	call   801057c0 <popcli>
  if(curproc == initproc)
801042de:	39 35 bc c5 10 80    	cmp    %esi,0x8010c5bc
801042e4:	0f 84 df 00 00 00    	je     801043c9 <exit+0x109>
801042ea:	8d 5e 28             	lea    0x28(%esi),%ebx
801042ed:	8d 7e 68             	lea    0x68(%esi),%edi
    if(curproc->ofile[fd]){
801042f0:	8b 03                	mov    (%ebx),%eax
801042f2:	85 c0                	test   %eax,%eax
801042f4:	74 0e                	je     80104304 <exit+0x44>
      fileclose(curproc->ofile[fd]);
801042f6:	89 04 24             	mov    %eax,(%esp)
801042f9:	e8 12 cb ff ff       	call   80100e10 <fileclose>
      curproc->ofile[fd] = 0;
801042fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104304:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80104307:	39 df                	cmp    %ebx,%edi
80104309:	75 e5                	jne    801042f0 <exit+0x30>
  begin_op();
8010430b:	e8 30 ea ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80104310:	8b 46 68             	mov    0x68(%esi),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104313:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
  iput(curproc->cwd);
80104318:	89 04 24             	mov    %eax,(%esp)
8010431b:	e8 10 d5 ff ff       	call   80101830 <iput>
  end_op();
80104320:	e8 8b ea ff ff       	call   80102db0 <end_op>
  curproc->exitStatus = status;
80104325:	8b 45 08             	mov    0x8(%ebp),%eax
  curproc->cwd = 0;
80104328:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  curproc->exitStatus = status;
8010432f:	89 46 7c             	mov    %eax,0x7c(%esi)
  acquire(&ptable.lock);
80104332:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104339:	e8 22 15 00 00       	call   80105860 <acquire>
  wakeup1(curproc->parent);
8010433e:	8b 46 14             	mov    0x14(%esi),%eax
80104341:	e8 da f4 ff ff       	call   80103820 <wakeup1>
80104346:	eb 16                	jmp    8010435e <exit+0x9e>
80104348:	90                   	nop
80104349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104350:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104356:	81 fb b4 72 11 80    	cmp    $0x801172b4,%ebx
8010435c:	73 32                	jae    80104390 <exit+0xd0>
    if(p->parent == curproc){
8010435e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104361:	75 ed                	jne    80104350 <exit+0x90>
      if(p->state == ZOMBIE)
80104363:	8b 53 0c             	mov    0xc(%ebx),%edx
      p->parent = initproc;
80104366:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
      if(p->state == ZOMBIE)
8010436b:	83 fa 05             	cmp    $0x5,%edx
      p->parent = initproc;
8010436e:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80104371:	75 dd                	jne    80104350 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104373:	81 c3 94 00 00 00    	add    $0x94,%ebx
        wakeup1(initproc);
80104379:	e8 a2 f4 ff ff       	call   80103820 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010437e:	81 fb b4 72 11 80    	cmp    $0x801172b4,%ebx
80104384:	72 d8                	jb     8010435e <exit+0x9e>
80104386:	8d 76 00             	lea    0x0(%esi),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(curproc->state == RUNNING){
80104390:	8b 46 0c             	mov    0xc(%esi),%eax
80104393:	83 f8 04             	cmp    $0x4,%eax
80104396:	75 0d                	jne    801043a5 <exit+0xe5>
    if(!rpholder.remove(p)){
80104398:	89 1c 24             	mov    %ebx,(%esp)
8010439b:	ff 15 c8 c5 10 80    	call   *0x8010c5c8
801043a1:	85 c0                	test   %eax,%eax
801043a3:	74 18                	je     801043bd <exit+0xfd>
  curproc->state = ZOMBIE;
801043a5:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801043ac:	e8 5f fe ff ff       	call   80104210 <sched>
  panic("zombie exit");
801043b1:	c7 04 24 6a 8b 10 80 	movl   $0x80108b6a,(%esp)
801043b8:	e8 b3 bf ff ff       	call   80100370 <panic>
     panic("remove from rpholder has a problem, function:exit");
801043bd:	c7 04 24 e8 8c 10 80 	movl   $0x80108ce8,(%esp)
801043c4:	e8 a7 bf ff ff       	call   80100370 <panic>
    panic("init exiting");
801043c9:	c7 04 24 5d 8b 10 80 	movl   $0x80108b5d,(%esp)
801043d0:	e8 9b bf ff ff       	call   80100370 <panic>
801043d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <yield>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801043e7:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
801043ee:	e8 6d 14 00 00       	call   80105860 <acquire>
  pushcli();
801043f3:	e8 88 13 00 00       	call   80105780 <pushcli>
  c = mycpu();
801043f8:	e8 23 f6 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
801043fd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104403:	e8 b8 13 00 00       	call   801057c0 <popcli>
  for(runnerProc= ptable.proc; runnerProc < &ptable.proc[NPROC]; runnerProc++){
80104408:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
  quantumTime ++;
8010440d:	ff 05 b8 c5 10 80    	incl   0x8010c5b8
80104413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(runnerProc != p){
80104420:	39 c3                	cmp    %eax,%ebx
80104422:	74 0e                	je     80104432 <yield+0x52>
      runnerProc->waitingTime ++ ;
80104424:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
8010442b:	83 90 90 00 00 00 00 	adcl   $0x0,0x90(%eax)
  for(runnerProc= ptable.proc; runnerProc < &ptable.proc[NPROC]; runnerProc++){
80104432:	05 94 00 00 00       	add    $0x94,%eax
80104437:	3d b4 72 11 80       	cmp    $0x801172b4,%eax
8010443c:	72 e2                	jb     80104420 <yield+0x40>
  p->waitingTime = 0;
8010443e:	31 c0                	xor    %eax,%eax
80104440:	31 d2                	xor    %edx,%edx
80104442:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  p->accumulator += p->priority;
80104448:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  p->waitingTime = 0;
8010444e:	89 93 90 00 00 00    	mov    %edx,0x90(%ebx)
  p->state = RUNNABLE;
80104454:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->accumulator += p->priority;
8010445b:	99                   	cltd   
8010445c:	01 83 84 00 00 00    	add    %eax,0x84(%ebx)
80104462:	11 93 88 00 00 00    	adc    %edx,0x88(%ebx)
  cprintf("remove now \n");
80104468:	c7 04 24 76 8b 10 80 	movl   $0x80108b76,(%esp)
8010446f:	e8 dc c1 ff ff       	call   80100650 <cprintf>
  if(!rpholder.remove(p)){
80104474:	89 1c 24             	mov    %ebx,(%esp)
80104477:	ff 15 c8 c5 10 80    	call   *0x8010c5c8
8010447d:	85 c0                	test   %eax,%eax
8010447f:	74 43                	je     801044c4 <yield+0xe4>
  if(currPolicy == ROUND_ROBIN){
80104481:	83 3d 04 c0 10 80 01 	cmpl   $0x1,0x8010c004
    if(!rrq.enqueue(p)){
80104488:	89 1c 24             	mov    %ebx,(%esp)
  if(currPolicy == ROUND_ROBIN){
8010448b:	74 21                	je     801044ae <yield+0xce>
    if(!pq.put(p)){
8010448d:	ff 15 e4 c5 10 80    	call   *0x8010c5e4
80104493:	85 c0                	test   %eax,%eax
80104495:	74 39                	je     801044d0 <yield+0xf0>
  sched();
80104497:	e8 74 fd ff ff       	call   80104210 <sched>
  release(&ptable.lock);
8010449c:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
801044a3:	e8 58 14 00 00       	call   80105900 <release>
}
801044a8:	83 c4 14             	add    $0x14,%esp
801044ab:	5b                   	pop    %ebx
801044ac:	5d                   	pop    %ebp
801044ad:	c3                   	ret    
    if(!rrq.enqueue(p)){
801044ae:	ff 15 d4 c5 10 80    	call   *0x8010c5d4
801044b4:	85 c0                	test   %eax,%eax
801044b6:	75 df                	jne    80104497 <yield+0xb7>
      panic("add to rrq has a problem, function:yield");
801044b8:	c7 04 24 50 8d 10 80 	movl   $0x80108d50,(%esp)
801044bf:	e8 ac be ff ff       	call   80100370 <panic>
    panic("remove from rpholder has a problem, function:yield");
801044c4:	c7 04 24 1c 8d 10 80 	movl   $0x80108d1c,(%esp)
801044cb:	e8 a0 be ff ff       	call   80100370 <panic>
      panic("add to pq has a problem, function:yield");
801044d0:	c7 04 24 7c 8d 10 80 	movl   $0x80108d7c,(%esp)
801044d7:	e8 94 be ff ff       	call   80100370 <panic>
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044e0 <sleep>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	83 ec 28             	sub    $0x28,%esp
801044e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801044e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
801044ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801044ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
801044f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801044f5:	e8 86 12 00 00       	call   80105780 <pushcli>
  c = mycpu();
801044fa:	e8 21 f5 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
801044ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104505:	e8 b6 12 00 00       	call   801057c0 <popcli>
  if(p == 0)
8010450a:	85 db                	test   %ebx,%ebx
8010450c:	0f 84 b7 00 00 00    	je     801045c9 <sleep+0xe9>
  if(lk == 0)
80104512:	85 f6                	test   %esi,%esi
80104514:	0f 84 bb 00 00 00    	je     801045d5 <sleep+0xf5>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010451a:	81 fe 80 4d 11 80    	cmp    $0x80114d80,%esi
80104520:	74 14                	je     80104536 <sleep+0x56>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104522:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104529:	e8 32 13 00 00       	call   80105860 <acquire>
    release(lk);
8010452e:	89 34 24             	mov    %esi,(%esp)
80104531:	e8 ca 13 00 00       	call   80105900 <release>
  p->state = SLEEPING;
80104536:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  if(p->state == RUNNING && !rpholder.remove(p)){
8010453d:	8b 43 0c             	mov    0xc(%ebx),%eax
  p->chan = chan;
80104540:	89 7b 20             	mov    %edi,0x20(%ebx)
  if(p->state == RUNNING && !rpholder.remove(p)){
80104543:	83 f8 04             	cmp    $0x4,%eax
80104546:	75 11                	jne    80104559 <sleep+0x79>
80104548:	89 1c 24             	mov    %ebx,(%esp)
8010454b:	ff 15 c8 c5 10 80    	call   *0x8010c5c8
80104551:	85 c0                	test   %eax,%eax
80104553:	0f 84 88 00 00 00    	je     801045e1 <sleep+0x101>
  if(p->state == RUNNABLE && currPolicy == ROUND_ROBIN && !rrq.dequeue()){
80104559:	8b 43 0c             	mov    0xc(%ebx),%eax
8010455c:	83 f8 03             	cmp    $0x3,%eax
8010455f:	75 13                	jne    80104574 <sleep+0x94>
80104561:	83 3d 04 c0 10 80 01 	cmpl   $0x1,0x8010c004
80104568:	75 0a                	jne    80104574 <sleep+0x94>
8010456a:	ff 15 d8 c5 10 80    	call   *0x8010c5d8
80104570:	85 c0                	test   %eax,%eax
80104572:	74 49                	je     801045bd <sleep+0xdd>
  sched();
80104574:	e8 97 fc ff ff       	call   80104210 <sched>
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104579:	81 fe 80 4d 11 80    	cmp    $0x80114d80,%esi
  p->chan = 0;
8010457f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104586:	74 28                	je     801045b0 <sleep+0xd0>
    release(&ptable.lock);
80104588:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
8010458f:	e8 6c 13 00 00       	call   80105900 <release>
}
80104594:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    acquire(lk);
80104597:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010459a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010459d:	8b 75 f8             	mov    -0x8(%ebp),%esi
801045a0:	89 ec                	mov    %ebp,%esp
801045a2:	5d                   	pop    %ebp
    acquire(lk);
801045a3:	e9 b8 12 00 00       	jmp    80105860 <acquire>
801045a8:	90                   	nop
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801045b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801045b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
801045b6:	8b 7d fc             	mov    -0x4(%ebp),%edi
801045b9:	89 ec                	mov    %ebp,%esp
801045bb:	5d                   	pop    %ebp
801045bc:	c3                   	ret    
    panic("remove from rrq has a problem, function:sleep");
801045bd:	c7 04 24 d8 8d 10 80 	movl   $0x80108dd8,(%esp)
801045c4:	e8 a7 bd ff ff       	call   80100370 <panic>
    panic("sleep");
801045c9:	c7 04 24 83 8b 10 80 	movl   $0x80108b83,(%esp)
801045d0:	e8 9b bd ff ff       	call   80100370 <panic>
    panic("sleep without lk");
801045d5:	c7 04 24 89 8b 10 80 	movl   $0x80108b89,(%esp)
801045dc:	e8 8f bd ff ff       	call   80100370 <panic>
    panic("remove from rpholder has a problem, function:sleep");
801045e1:	c7 04 24 a4 8d 10 80 	movl   $0x80108da4,(%esp)
801045e8:	e8 83 bd ff ff       	call   80100370 <panic>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi

801045f0 <wait>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	56                   	push   %esi
801045f5:	53                   	push   %ebx
801045f6:	83 ec 1c             	sub    $0x1c,%esp
801045f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801045fc:	e8 7f 11 00 00       	call   80105780 <pushcli>
  c = mycpu();
80104601:	e8 1a f4 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104606:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010460c:	e8 af 11 00 00       	call   801057c0 <popcli>
  acquire(&ptable.lock);
80104611:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104618:	e8 43 12 00 00       	call   80105860 <acquire>
    havekids = 0;
8010461d:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010461f:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
80104624:	eb 18                	jmp    8010463e <wait+0x4e>
80104626:	8d 76 00             	lea    0x0(%esi),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104630:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104636:	81 fb b4 72 11 80    	cmp    $0x801172b4,%ebx
8010463c:	73 20                	jae    8010465e <wait+0x6e>
      if(p->parent != curproc)
8010463e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104641:	75 ed                	jne    80104630 <wait+0x40>
      if(p->state == ZOMBIE){
80104643:	8b 43 0c             	mov    0xc(%ebx),%eax
80104646:	83 f8 05             	cmp    $0x5,%eax
80104649:	74 35                	je     80104680 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010464b:	81 c3 94 00 00 00    	add    $0x94,%ebx
      havekids = 1;
80104651:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104656:	81 fb b4 72 11 80    	cmp    $0x801172b4,%ebx
8010465c:	72 e0                	jb     8010463e <wait+0x4e>
      if(!havekids || curproc->killed){
8010465e:	85 c0                	test   %eax,%eax
80104660:	74 7d                	je     801046df <wait+0xef>
80104662:	8b 56 24             	mov    0x24(%esi),%edx
80104665:	85 d2                	test   %edx,%edx
80104667:	75 76                	jne    801046df <wait+0xef>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104669:	b8 80 4d 11 80       	mov    $0x80114d80,%eax
8010466e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104672:	89 34 24             	mov    %esi,(%esp)
80104675:	e8 66 fe ff ff       	call   801044e0 <sleep>
    havekids = 0;
8010467a:	eb a1                	jmp    8010461d <wait+0x2d>
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104680:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80104683:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104686:	89 04 24             	mov    %eax,(%esp)
80104689:	e8 02 de ff ff       	call   80102490 <kfree>
        freevm(p->pgdir);
8010468e:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80104691:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104698:	89 04 24             	mov    %eax,(%esp)
8010469b:	e8 20 3b 00 00       	call   801081c0 <freevm>
        release(&ptable.lock);
801046a0:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
        p->pid = 0;
801046a7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801046ae:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801046b5:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801046b9:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801046c0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801046c7:	e8 34 12 00 00       	call   80105900 <release>
        if(status != null){
801046cc:	85 ff                	test   %edi,%edi
801046ce:	74 05                	je     801046d5 <wait+0xe5>
          *status = p->exitStatus;
801046d0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801046d3:	89 07                	mov    %eax,(%edi)
}
801046d5:	83 c4 1c             	add    $0x1c,%esp
801046d8:	89 f0                	mov    %esi,%eax
801046da:	5b                   	pop    %ebx
801046db:	5e                   	pop    %esi
801046dc:	5f                   	pop    %edi
801046dd:	5d                   	pop    %ebp
801046de:	c3                   	ret    
        release(&ptable.lock);
801046df:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
        return -1;
801046e6:	be ff ff ff ff       	mov    $0xffffffff,%esi
        release(&ptable.lock);
801046eb:	e8 10 12 00 00       	call   80105900 <release>
        return -1;
801046f0:	eb e3                	jmp    801046d5 <wait+0xe5>
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <wakeup>:

// Wake up all processes sleeping on chan.
  void
  wakeup(void *chan)
  {
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 14             	sub    $0x14,%esp
80104707:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010470a:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104711:	e8 4a 11 00 00       	call   80105860 <acquire>
    wakeup1(chan);
80104716:	89 d8                	mov    %ebx,%eax
80104718:	e8 03 f1 ff ff       	call   80103820 <wakeup1>
    release(&ptable.lock);
8010471d:	c7 45 08 80 4d 11 80 	movl   $0x80114d80,0x8(%ebp)
  }
80104724:	83 c4 14             	add    $0x14,%esp
80104727:	5b                   	pop    %ebx
80104728:	5d                   	pop    %ebp
    release(&ptable.lock);
80104729:	e9 d2 11 00 00       	jmp    80105900 <release>
8010472e:	66 90                	xchg   %ax,%ax

80104730 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
  int
  kill(int pid)
  {
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 14             	sub    $0x14,%esp
    struct proc *p;

    acquire(&ptable.lock);
80104737:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
  {
8010473e:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80104741:	e8 1a 11 00 00       	call   80105860 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104746:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
8010474b:	eb 0f                	jmp    8010475c <kill+0x2c>
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
80104750:	05 94 00 00 00       	add    $0x94,%eax
80104755:	3d b4 72 11 80       	cmp    $0x801172b4,%eax
8010475a:	73 4c                	jae    801047a8 <kill+0x78>
      if(p->pid == pid){
8010475c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010475f:	75 ef                	jne    80104750 <kill+0x20>
        p->killed = 1;
      // Wake process from sleep if necessary.
        if(p->state == SLEEPING){
80104761:	8b 50 0c             	mov    0xc(%eax),%edx
        p->killed = 1;
80104764:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        if(p->state == SLEEPING){
8010476b:	83 fa 02             	cmp    $0x2,%edx
8010476e:	75 1d                	jne    8010478d <kill+0x5d>
          p->state = RUNNABLE;
          if(currPolicy == ROUND_ROBIN){
80104770:	83 3d 04 c0 10 80 01 	cmpl   $0x1,0x8010c004
          p->state = RUNNABLE;
80104777:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            if(!rrq.enqueue(p)){
8010477e:	89 04 24             	mov    %eax,(%esp)
          if(currPolicy == ROUND_ROBIN){
80104781:	74 3d                	je     801047c0 <kill+0x90>
              panic("add to rrq has a problem,function:kill");
            }
          }
          else{
            if(!pq.put(p)){
80104783:	ff 15 e4 c5 10 80    	call   *0x8010c5e4
80104789:	85 c0                	test   %eax,%eax
8010478b:	74 3d                	je     801047ca <kill+0x9a>
              panic("add to rrq has a problem,function:kill");
            }
          }
        }
        release(&ptable.lock);
8010478d:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104794:	e8 67 11 00 00       	call   80105900 <release>
        return 0;
      }
    }
    release(&ptable.lock);
    return -1;
  }
80104799:	83 c4 14             	add    $0x14,%esp
        return 0;
8010479c:	31 c0                	xor    %eax,%eax
  }
8010479e:	5b                   	pop    %ebx
8010479f:	5d                   	pop    %ebp
801047a0:	c3                   	ret    
801047a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801047a8:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
801047af:	e8 4c 11 00 00       	call   80105900 <release>
  }
801047b4:	83 c4 14             	add    $0x14,%esp
    return -1;
801047b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
801047bc:	5b                   	pop    %ebx
801047bd:	5d                   	pop    %ebp
801047be:	c3                   	ret    
801047bf:	90                   	nop
            if(!rrq.enqueue(p)){
801047c0:	ff 15 d4 c5 10 80    	call   *0x8010c5d4
801047c6:	85 c0                	test   %eax,%eax
801047c8:	75 c3                	jne    8010478d <kill+0x5d>
              panic("add to rrq has a problem,function:kill");
801047ca:	c7 04 24 08 8e 10 80 	movl   $0x80108e08,(%esp)
801047d1:	e8 9a bb ff ff       	call   80100370 <panic>
801047d6:	8d 76 00             	lea    0x0(%esi),%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
  void
  procdump(void)
  {
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e6:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
  {
801047eb:	83 ec 4c             	sub    $0x4c,%esp
801047ee:	eb 1e                	jmp    8010480e <procdump+0x2e>
      if(p->state == SLEEPING){
        getcallerpcs((uint*)p->context->ebp+2, pc);
        for(i=0; i<10 && pc[i] != 0; i++)
          cprintf(" %p", pc[i]);
      }
      cprintf("\n");
801047f0:	c7 04 24 1b 8b 10 80 	movl   $0x80108b1b,(%esp)
801047f7:	e8 54 be ff ff       	call   80100650 <cprintf>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047fc:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104802:	81 fb b4 72 11 80    	cmp    $0x801172b4,%ebx
80104808:	0f 83 b2 00 00 00    	jae    801048c0 <procdump+0xe0>
      if(p->state == UNUSED)
8010480e:	8b 43 0c             	mov    0xc(%ebx),%eax
80104811:	85 c0                	test   %eax,%eax
80104813:	74 e7                	je     801047fc <procdump+0x1c>
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104815:	8b 43 0c             	mov    0xc(%ebx),%eax
        state = "???";
80104818:	b8 9a 8b 10 80       	mov    $0x80108b9a,%eax
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010481d:	8b 53 0c             	mov    0xc(%ebx),%edx
80104820:	83 fa 05             	cmp    $0x5,%edx
80104823:	77 18                	ja     8010483d <procdump+0x5d>
80104825:	8b 53 0c             	mov    0xc(%ebx),%edx
80104828:	8b 14 95 30 8e 10 80 	mov    -0x7fef71d0(,%edx,4),%edx
8010482f:	85 d2                	test   %edx,%edx
80104831:	74 0a                	je     8010483d <procdump+0x5d>
        state = states[p->state];
80104833:	8b 43 0c             	mov    0xc(%ebx),%eax
80104836:	8b 04 85 30 8e 10 80 	mov    -0x7fef71d0(,%eax,4),%eax
      cprintf("%d %s %s", p->pid, state, p->name);
8010483d:	89 44 24 08          	mov    %eax,0x8(%esp)
80104841:	8b 43 10             	mov    0x10(%ebx),%eax
80104844:	8d 53 6c             	lea    0x6c(%ebx),%edx
80104847:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010484b:	c7 04 24 9e 8b 10 80 	movl   $0x80108b9e,(%esp)
80104852:	89 44 24 04          	mov    %eax,0x4(%esp)
80104856:	e8 f5 bd ff ff       	call   80100650 <cprintf>
      if(p->state == SLEEPING){
8010485b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010485e:	83 f8 02             	cmp    $0x2,%eax
80104861:	75 8d                	jne    801047f0 <procdump+0x10>
        getcallerpcs((uint*)p->context->ebp+2, pc);
80104863:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104866:	89 44 24 04          	mov    %eax,0x4(%esp)
8010486a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010486d:	8d 75 c0             	lea    -0x40(%ebp),%esi
80104870:	8d 7d e8             	lea    -0x18(%ebp),%edi
80104873:	8b 40 0c             	mov    0xc(%eax),%eax
80104876:	83 c0 08             	add    $0x8,%eax
80104879:	89 04 24             	mov    %eax,(%esp)
8010487c:	e8 af 0e 00 00       	call   80105730 <getcallerpcs>
80104881:	eb 0d                	jmp    80104890 <procdump+0xb0>
80104883:	90                   	nop
80104884:	90                   	nop
80104885:	90                   	nop
80104886:	90                   	nop
80104887:	90                   	nop
80104888:	90                   	nop
80104889:	90                   	nop
8010488a:	90                   	nop
8010488b:	90                   	nop
8010488c:	90                   	nop
8010488d:	90                   	nop
8010488e:	90                   	nop
8010488f:	90                   	nop
        for(i=0; i<10 && pc[i] != 0; i++)
80104890:	8b 16                	mov    (%esi),%edx
80104892:	85 d2                	test   %edx,%edx
80104894:	0f 84 56 ff ff ff    	je     801047f0 <procdump+0x10>
          cprintf(" %p", pc[i]);
8010489a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010489e:	83 c6 04             	add    $0x4,%esi
801048a1:	c7 04 24 41 85 10 80 	movl   $0x80108541,(%esp)
801048a8:	e8 a3 bd ff ff       	call   80100650 <cprintf>
        for(i=0; i<10 && pc[i] != 0; i++)
801048ad:	39 f7                	cmp    %esi,%edi
801048af:	75 df                	jne    80104890 <procdump+0xb0>
801048b1:	e9 3a ff ff ff       	jmp    801047f0 <procdump+0x10>
801048b6:	8d 76 00             	lea    0x0(%esi),%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
  }
801048c0:	83 c4 4c             	add    $0x4c,%esp
801048c3:	5b                   	pop    %ebx
801048c4:	5e                   	pop    %esi
801048c5:	5f                   	pop    %edi
801048c6:	5d                   	pop    %ebp
801048c7:	c3                   	ret    
801048c8:	66 90                	xchg   %ax,%ax
801048ca:	66 90                	xchg   %ax,%ax
801048cc:	66 90                	xchg   %ax,%ax
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <isEmptyPriorityQueue>:
Proc* MapNode::dequeue() {
	return listOfProcs.dequeue();
}

bool Map::isEmpty() {
	return !root;
801048d0:	a1 10 c6 10 80       	mov    0x8010c610,%eax
static boolean isEmptyPriorityQueue() {
801048d5:	55                   	push   %ebp
801048d6:	89 e5                	mov    %esp,%ebp
}
801048d8:	5d                   	pop    %ebp
	return !root;
801048d9:	8b 00                	mov    (%eax),%eax
801048db:	85 c0                	test   %eax,%eax
801048dd:	0f 94 c0             	sete   %al
801048e0:	0f b6 c0             	movzbl %al,%eax
}
801048e3:	c3                   	ret    
801048e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048f0 <getMinAccumulatorPriorityQueue>:
	return !root;
801048f0:	a1 10 c6 10 80       	mov    0x8010c610,%eax
801048f5:	8b 10                	mov    (%eax),%edx
	
	return root->put(p);
}

bool Map::getMinKey(long long *pkey) {
	if(isEmpty())
801048f7:	85 d2                	test   %edx,%edx
801048f9:	74 35                	je     80104930 <getMinAccumulatorPriorityQueue+0x40>
static boolean getMinAccumulatorPriorityQueue(long long* pkey) {
801048fb:	55                   	push   %ebp
801048fc:	89 e5                	mov    %esp,%ebp
801048fe:	53                   	push   %ebx
801048ff:	eb 09                	jmp    8010490a <getMinAccumulatorPriorityQueue+0x1a>
80104901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	while(minNode->left)
80104908:	89 c2                	mov    %eax,%edx
8010490a:	8b 42 18             	mov    0x18(%edx),%eax
8010490d:	85 c0                	test   %eax,%eax
8010490f:	75 f7                	jne    80104908 <getMinAccumulatorPriorityQueue+0x18>
	*pkey = getMinNode()->key;
80104911:	8b 45 08             	mov    0x8(%ebp),%eax
80104914:	8b 5a 04             	mov    0x4(%edx),%ebx
80104917:	8b 0a                	mov    (%edx),%ecx
80104919:	89 58 04             	mov    %ebx,0x4(%eax)
8010491c:	89 08                	mov    %ecx,(%eax)
8010491e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104923:	5b                   	pop    %ebx
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret    
80104926:	8d 76 00             	lea    0x0(%esi),%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if(isEmpty())
80104930:	31 c0                	xor    %eax,%eax
}
80104932:	c3                   	ret    
80104933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <isEmptyRoundRobinQueue>:
	return !first;
80104940:	a1 0c c6 10 80       	mov    0x8010c60c,%eax
static boolean isEmptyRoundRobinQueue() {
80104945:	55                   	push   %ebp
80104946:	89 e5                	mov    %esp,%ebp
}
80104948:	5d                   	pop    %ebp
	return !first;
80104949:	8b 00                	mov    (%eax),%eax
8010494b:	85 c0                	test   %eax,%eax
8010494d:	0f 94 c0             	sete   %al
80104950:	0f b6 c0             	movzbl %al,%eax
}
80104953:	c3                   	ret    
80104954:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010495a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104960 <enqueueRoundRobinQueue>:
	if(!freeLinks)
80104960:	a1 04 c6 10 80       	mov    0x8010c604,%eax
80104965:	85 c0                	test   %eax,%eax
80104967:	74 47                	je     801049b0 <enqueueRoundRobinQueue+0x50>
static boolean enqueueRoundRobinQueue(Proc *p) {
80104969:	55                   	push   %ebp
	return roundRobinQ->enqueue(p);
8010496a:	8b 0d 0c c6 10 80    	mov    0x8010c60c,%ecx
	freeLinks = freeLinks->next;
80104970:	8b 50 04             	mov    0x4(%eax),%edx
static boolean enqueueRoundRobinQueue(Proc *p) {
80104973:	89 e5                	mov    %esp,%ebp
	ans->next = null;
80104975:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	freeLinks = freeLinks->next;
8010497c:	89 15 04 c6 10 80    	mov    %edx,0x8010c604
	ans->p = p;
80104982:	8b 55 08             	mov    0x8(%ebp),%edx
80104985:	89 10                	mov    %edx,(%eax)
	if(isEmpty()) first = link;
80104987:	8b 11                	mov    (%ecx),%edx
80104989:	85 d2                	test   %edx,%edx
8010498b:	74 2b                	je     801049b8 <enqueueRoundRobinQueue+0x58>
	else last->next = link;
8010498d:	8b 51 04             	mov    0x4(%ecx),%edx
80104990:	89 42 04             	mov    %eax,0x4(%edx)
80104993:	eb 05                	jmp    8010499a <enqueueRoundRobinQueue+0x3a>
80104995:	8d 76 00             	lea    0x0(%esi),%esi
	while(ans->next)
80104998:	89 d0                	mov    %edx,%eax
8010499a:	8b 50 04             	mov    0x4(%eax),%edx
8010499d:	85 d2                	test   %edx,%edx
8010499f:	75 f7                	jne    80104998 <enqueueRoundRobinQueue+0x38>
	last = link->getLast();
801049a1:	89 41 04             	mov    %eax,0x4(%ecx)
801049a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret    
801049ab:	90                   	nop
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if(!freeLinks)
801049b0:	31 c0                	xor    %eax,%eax
}
801049b2:	c3                   	ret    
801049b3:	90                   	nop
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if(isEmpty()) first = link;
801049b8:	89 01                	mov    %eax,(%ecx)
801049ba:	eb de                	jmp    8010499a <enqueueRoundRobinQueue+0x3a>
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049c0 <dequeueRoundRobinQueue>:
	return roundRobinQ->dequeue();
801049c0:	8b 0d 0c c6 10 80    	mov    0x8010c60c,%ecx
	return !first;
801049c6:	8b 11                	mov    (%ecx),%edx
	if(isEmpty())
801049c8:	85 d2                	test   %edx,%edx
801049ca:	74 3c                	je     80104a08 <dequeueRoundRobinQueue+0x48>
static Proc* dequeueRoundRobinQueue() {
801049cc:	55                   	push   %ebp
801049cd:	89 e5                	mov    %esp,%ebp
801049cf:	83 ec 08             	sub    $0x8,%esp
801049d2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	link->next = freeLinks;
801049d5:	8b 35 04 c6 10 80    	mov    0x8010c604,%esi
static Proc* dequeueRoundRobinQueue() {
801049db:	89 5d f8             	mov    %ebx,-0x8(%ebp)
	Link *next = first->next;
801049de:	8b 5a 04             	mov    0x4(%edx),%ebx
	Proc *p = first->p;
801049e1:	8b 02                	mov    (%edx),%eax
	link->next = freeLinks;
801049e3:	89 72 04             	mov    %esi,0x4(%edx)
	freeLinks = link;
801049e6:	89 15 04 c6 10 80    	mov    %edx,0x8010c604
	if(isEmpty())
801049ec:	85 db                	test   %ebx,%ebx
	first = next;
801049ee:	89 19                	mov    %ebx,(%ecx)
	if(isEmpty())
801049f0:	75 07                	jne    801049f9 <dequeueRoundRobinQueue+0x39>
		last = null;
801049f2:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
}
801049f9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801049fc:	8b 75 fc             	mov    -0x4(%ebp),%esi
801049ff:	89 ec                	mov    %ebp,%esp
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return null;
80104a08:	31 c0                	xor    %eax,%eax
}
80104a0a:	c3                   	ret    
80104a0b:	90                   	nop
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <isEmptyRunningProcessHolder>:
	return !first;
80104a10:	a1 08 c6 10 80       	mov    0x8010c608,%eax
static boolean isEmptyRunningProcessHolder() {
80104a15:	55                   	push   %ebp
80104a16:	89 e5                	mov    %esp,%ebp
}
80104a18:	5d                   	pop    %ebp
	return !first;
80104a19:	8b 00                	mov    (%eax),%eax
80104a1b:	85 c0                	test   %eax,%eax
80104a1d:	0f 94 c0             	sete   %al
80104a20:	0f b6 c0             	movzbl %al,%eax
}
80104a23:	c3                   	ret    
80104a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a30 <addRunningProcessHolder>:
	if(!freeLinks)
80104a30:	a1 04 c6 10 80       	mov    0x8010c604,%eax
80104a35:	85 c0                	test   %eax,%eax
80104a37:	74 47                	je     80104a80 <addRunningProcessHolder+0x50>
static boolean addRunningProcessHolder(Proc* p) {
80104a39:	55                   	push   %ebp
	return runningProcHolder->enqueue(p);
80104a3a:	8b 0d 08 c6 10 80    	mov    0x8010c608,%ecx
	freeLinks = freeLinks->next;
80104a40:	8b 50 04             	mov    0x4(%eax),%edx
static boolean addRunningProcessHolder(Proc* p) {
80104a43:	89 e5                	mov    %esp,%ebp
	ans->next = null;
80104a45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	freeLinks = freeLinks->next;
80104a4c:	89 15 04 c6 10 80    	mov    %edx,0x8010c604
	ans->p = p;
80104a52:	8b 55 08             	mov    0x8(%ebp),%edx
80104a55:	89 10                	mov    %edx,(%eax)
	if(isEmpty()) first = link;
80104a57:	8b 11                	mov    (%ecx),%edx
80104a59:	85 d2                	test   %edx,%edx
80104a5b:	74 2b                	je     80104a88 <addRunningProcessHolder+0x58>
	else last->next = link;
80104a5d:	8b 51 04             	mov    0x4(%ecx),%edx
80104a60:	89 42 04             	mov    %eax,0x4(%edx)
80104a63:	eb 05                	jmp    80104a6a <addRunningProcessHolder+0x3a>
80104a65:	8d 76 00             	lea    0x0(%esi),%esi
	while(ans->next)
80104a68:	89 d0                	mov    %edx,%eax
80104a6a:	8b 50 04             	mov    0x4(%eax),%edx
80104a6d:	85 d2                	test   %edx,%edx
80104a6f:	75 f7                	jne    80104a68 <addRunningProcessHolder+0x38>
	last = link->getLast();
80104a71:	89 41 04             	mov    %eax,0x4(%ecx)
80104a74:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret    
80104a7b:	90                   	nop
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if(!freeLinks)
80104a80:	31 c0                	xor    %eax,%eax
}
80104a82:	c3                   	ret    
80104a83:	90                   	nop
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if(isEmpty()) first = link;
80104a88:	89 01                	mov    %eax,(%ecx)
80104a8a:	eb de                	jmp    80104a6a <addRunningProcessHolder+0x3a>
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <_ZL9allocNodeP4procx>:
static MapNode* allocNode(Proc *p, long long key) {
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
	if(!freeNodes)
80104a95:	8b 1d 00 c6 10 80    	mov    0x8010c600,%ebx
80104a9b:	85 db                	test   %ebx,%ebx
80104a9d:	74 4d                	je     80104aec <_ZL9allocNodeP4procx+0x5c>
	ans->key = key;
80104a9f:	89 13                	mov    %edx,(%ebx)
	if(!freeLinks)
80104aa1:	8b 15 04 c6 10 80    	mov    0x8010c604,%edx
	freeNodes = freeNodes->next;
80104aa7:	8b 73 10             	mov    0x10(%ebx),%esi
	ans->key = key;
80104aaa:	89 4b 04             	mov    %ecx,0x4(%ebx)
	ans->next = null;
80104aad:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
	if(!freeLinks)
80104ab4:	85 d2                	test   %edx,%edx
	freeNodes = freeNodes->next;
80104ab6:	89 35 00 c6 10 80    	mov    %esi,0x8010c600
	if(!freeLinks)
80104abc:	74 3f                	je     80104afd <_ZL9allocNodeP4procx+0x6d>
	freeLinks = freeLinks->next;
80104abe:	8b 4a 04             	mov    0x4(%edx),%ecx
	ans->p = p;
80104ac1:	89 02                	mov    %eax,(%edx)
	ans->next = null;
80104ac3:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
	if(isEmpty()) first = link;
80104aca:	8b 43 08             	mov    0x8(%ebx),%eax
	freeLinks = freeLinks->next;
80104acd:	89 0d 04 c6 10 80    	mov    %ecx,0x8010c604
	if(isEmpty()) first = link;
80104ad3:	85 c0                	test   %eax,%eax
80104ad5:	74 21                	je     80104af8 <_ZL9allocNodeP4procx+0x68>
	else last->next = link;
80104ad7:	8b 43 0c             	mov    0xc(%ebx),%eax
80104ada:	89 50 04             	mov    %edx,0x4(%eax)
80104add:	eb 03                	jmp    80104ae2 <_ZL9allocNodeP4procx+0x52>
80104adf:	90                   	nop
	while(ans->next)
80104ae0:	89 ca                	mov    %ecx,%edx
80104ae2:	8b 4a 04             	mov    0x4(%edx),%ecx
80104ae5:	85 c9                	test   %ecx,%ecx
80104ae7:	75 f7                	jne    80104ae0 <_ZL9allocNodeP4procx+0x50>
	last = link->getLast();
80104ae9:	89 53 0c             	mov    %edx,0xc(%ebx)
}
80104aec:	89 d8                	mov    %ebx,%eax
80104aee:	5b                   	pop    %ebx
80104aef:	5e                   	pop    %esi
80104af0:	5d                   	pop    %ebp
80104af1:	c3                   	ret    
80104af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if(isEmpty()) first = link;
80104af8:	89 53 08             	mov    %edx,0x8(%ebx)
80104afb:	eb e5                	jmp    80104ae2 <_ZL9allocNodeP4procx+0x52>
	node->parent = node->left = node->right = null;
80104afd:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
80104b04:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
80104b0b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	node->next = freeNodes;
80104b12:	89 73 10             	mov    %esi,0x10(%ebx)
	freeNodes = node;
80104b15:	89 1d 00 c6 10 80    	mov    %ebx,0x8010c600
		return null;
80104b1b:	31 db                	xor    %ebx,%ebx
80104b1d:	eb cd                	jmp    80104aec <_ZL9allocNodeP4procx+0x5c>
80104b1f:	90                   	nop

80104b20 <_ZL8mymallocj>:
static char* mymalloc(uint size) {
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	89 c3                	mov    %eax,%ebx
80104b26:	83 ec 14             	sub    $0x14,%esp
	if(spaceLeft < size) {
80104b29:	8b 15 f8 c5 10 80    	mov    0x8010c5f8,%edx
80104b2f:	39 c2                	cmp    %eax,%edx
80104b31:	73 26                	jae    80104b59 <_ZL8mymallocj+0x39>
		data = kalloc();
80104b33:	e8 28 db ff ff       	call   80102660 <kalloc>
		memset(data, 0, PGSIZE);
80104b38:	ba 00 10 00 00       	mov    $0x1000,%edx
80104b3d:	31 c9                	xor    %ecx,%ecx
80104b3f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80104b47:	89 04 24             	mov    %eax,(%esp)
		data = kalloc();
80104b4a:	a3 fc c5 10 80       	mov    %eax,0x8010c5fc
		memset(data, 0, PGSIZE);
80104b4f:	e8 fc 0d 00 00       	call   80105950 <memset>
80104b54:	ba 00 10 00 00       	mov    $0x1000,%edx
	char* ans = data;
80104b59:	a1 fc c5 10 80       	mov    0x8010c5fc,%eax
	spaceLeft -= size;
80104b5e:	29 da                	sub    %ebx,%edx
80104b60:	89 15 f8 c5 10 80    	mov    %edx,0x8010c5f8
	data += size;
80104b66:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104b69:	89 0d fc c5 10 80    	mov    %ecx,0x8010c5fc
}
80104b6f:	83 c4 14             	add    $0x14,%esp
80104b72:	5b                   	pop    %ebx
80104b73:	5d                   	pop    %ebp
80104b74:	c3                   	ret    
80104b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <initSchedDS>:
void initSchedDS() { //called once by the "pioneer" cpu from the main function in main.c
80104b80:	55                   	push   %ebp
	data               = null;
80104b81:	31 c0                	xor    %eax,%eax
void initSchedDS() { //called once by the "pioneer" cpu from the main function in main.c
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	53                   	push   %ebx
	freeLinks = null;
80104b86:	bb 80 00 00 00       	mov    $0x80,%ebx
void initSchedDS() { //called once by the "pioneer" cpu from the main function in main.c
80104b8b:	83 ec 04             	sub    $0x4,%esp
	data               = null;
80104b8e:	a3 fc c5 10 80       	mov    %eax,0x8010c5fc
	spaceLeft          = 0u;
80104b93:	31 c0                	xor    %eax,%eax
80104b95:	a3 f8 c5 10 80       	mov    %eax,0x8010c5f8
	priorityQ          = (Map*)mymalloc(sizeof(Map));
80104b9a:	b8 04 00 00 00       	mov    $0x4,%eax
80104b9f:	e8 7c ff ff ff       	call   80104b20 <_ZL8mymallocj>
80104ba4:	a3 10 c6 10 80       	mov    %eax,0x8010c610
	*priorityQ         = Map();
80104ba9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	roundRobinQ        = (LinkedList*)mymalloc(sizeof(LinkedList));
80104baf:	b8 08 00 00 00       	mov    $0x8,%eax
80104bb4:	e8 67 ff ff ff       	call   80104b20 <_ZL8mymallocj>
80104bb9:	a3 0c c6 10 80       	mov    %eax,0x8010c60c
	*roundRobinQ       = LinkedList();
80104bbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104bc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	runningProcHolder  = (LinkedList*)mymalloc(sizeof(LinkedList));
80104bcb:	b8 08 00 00 00       	mov    $0x8,%eax
80104bd0:	e8 4b ff ff ff       	call   80104b20 <_ZL8mymallocj>
80104bd5:	a3 08 c6 10 80       	mov    %eax,0x8010c608
	*runningProcHolder = LinkedList();
80104bda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104be0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	freeLinks = null;
80104be7:	31 c0                	xor    %eax,%eax
80104be9:	a3 04 c6 10 80       	mov    %eax,0x8010c604
80104bee:	66 90                	xchg   %ax,%ax
		Link *link = (Link*)mymalloc(sizeof(Link));
80104bf0:	b8 08 00 00 00       	mov    $0x8,%eax
80104bf5:	e8 26 ff ff ff       	call   80104b20 <_ZL8mymallocj>
		link->next = freeLinks;
80104bfa:	8b 15 04 c6 10 80    	mov    0x8010c604,%edx
	for(int i = 0; i < NPROCLIST; ++i) {
80104c00:	4b                   	dec    %ebx
		*link = Link();
80104c01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		link->next = freeLinks;
80104c07:	89 50 04             	mov    %edx,0x4(%eax)
		freeLinks = link;
80104c0a:	a3 04 c6 10 80       	mov    %eax,0x8010c604
	for(int i = 0; i < NPROCLIST; ++i) {
80104c0f:	75 df                	jne    80104bf0 <initSchedDS+0x70>
	freeNodes = null;
80104c11:	31 c0                	xor    %eax,%eax
80104c13:	bb 80 00 00 00       	mov    $0x80,%ebx
80104c18:	a3 00 c6 10 80       	mov    %eax,0x8010c600
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
		MapNode *node = (MapNode*)mymalloc(sizeof(MapNode));
80104c20:	b8 20 00 00 00       	mov    $0x20,%eax
80104c25:	e8 f6 fe ff ff       	call   80104b20 <_ZL8mymallocj>
		node->next = freeNodes;
80104c2a:	8b 15 00 c6 10 80    	mov    0x8010c600,%edx
	for(int i = 0; i < NPROCMAP; ++i) {
80104c30:	4b                   	dec    %ebx
		*node = MapNode();
80104c31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104c38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
80104c3f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
80104c46:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
80104c4d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
		node->next = freeNodes;
80104c54:	89 50 10             	mov    %edx,0x10(%eax)
		freeNodes = node;
80104c57:	a3 00 c6 10 80       	mov    %eax,0x8010c600
	for(int i = 0; i < NPROCMAP; ++i) {
80104c5c:	75 c2                	jne    80104c20 <initSchedDS+0xa0>
	pq.isEmpty                      = isEmptyPriorityQueue;
80104c5e:	b8 d0 48 10 80       	mov    $0x801048d0,%eax
	pq.put                          = putPriorityQueue;
80104c63:	ba 50 52 10 80       	mov    $0x80105250,%edx
	pq.isEmpty                      = isEmptyPriorityQueue;
80104c68:	a3 e0 c5 10 80       	mov    %eax,0x8010c5e0
	pq.switchToRoundRobinPolicy     = switchToRoundRobinPolicyPriorityQueue;
80104c6d:	b8 10 54 10 80       	mov    $0x80105410,%eax
	pq.getMinAccumulator            = getMinAccumulatorPriorityQueue;
80104c72:	b9 f0 48 10 80       	mov    $0x801048f0,%ecx
	pq.switchToRoundRobinPolicy     = switchToRoundRobinPolicyPriorityQueue;
80104c77:	a3 f0 c5 10 80       	mov    %eax,0x8010c5f0
	pq.extractProc                  = extractProcPriorityQueue;
80104c7c:	b8 f0 54 10 80       	mov    $0x801054f0,%eax
	pq.extractMin                   = extractMinPriorityQueue;
80104c81:	bb 70 53 10 80       	mov    $0x80105370,%ebx
	pq.extractProc                  = extractProcPriorityQueue;
80104c86:	a3 f4 c5 10 80       	mov    %eax,0x8010c5f4
	rrq.isEmpty                     = isEmptyRoundRobinQueue;
80104c8b:	b8 40 49 10 80       	mov    $0x80104940,%eax
80104c90:	a3 d0 c5 10 80       	mov    %eax,0x8010c5d0
	rrq.enqueue                     = enqueueRoundRobinQueue;
80104c95:	b8 60 49 10 80       	mov    $0x80104960,%eax
80104c9a:	a3 d4 c5 10 80       	mov    %eax,0x8010c5d4
	rrq.dequeue                     = dequeueRoundRobinQueue;
80104c9f:	b8 c0 49 10 80       	mov    $0x801049c0,%eax
80104ca4:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
	rrq.switchToPriorityQueuePolicy = switchToPriorityQueuePolicyRoundRobinQueue;
80104ca9:	b8 80 4f 10 80       	mov    $0x80104f80,%eax
	pq.put                          = putPriorityQueue;
80104cae:	89 15 e4 c5 10 80    	mov    %edx,0x8010c5e4
	rpholder.isEmpty                = isEmptyRunningProcessHolder;
80104cb4:	ba 10 4a 10 80       	mov    $0x80104a10,%edx
	pq.getMinAccumulator            = getMinAccumulatorPriorityQueue;
80104cb9:	89 0d e8 c5 10 80    	mov    %ecx,0x8010c5e8
	rpholder.add                    = addRunningProcessHolder;
80104cbf:	b9 30 4a 10 80       	mov    $0x80104a30,%ecx
	pq.extractMin                   = extractMinPriorityQueue;
80104cc4:	89 1d ec c5 10 80    	mov    %ebx,0x8010c5ec
	rpholder.remove                 = removeRunningProcessHolder;
80104cca:	bb e0 4e 10 80       	mov    $0x80104ee0,%ebx
	rrq.switchToPriorityQueuePolicy = switchToPriorityQueuePolicyRoundRobinQueue;
80104ccf:	a3 dc c5 10 80       	mov    %eax,0x8010c5dc
	rpholder.getMinAccumulator      = getMinAccumulatorRunningProcessHolder;
80104cd4:	b8 10 50 10 80       	mov    $0x80105010,%eax
	rpholder.remove                 = removeRunningProcessHolder;
80104cd9:	89 1d c8 c5 10 80    	mov    %ebx,0x8010c5c8
	rpholder.isEmpty                = isEmptyRunningProcessHolder;
80104cdf:	89 15 c0 c5 10 80    	mov    %edx,0x8010c5c0
	rpholder.add                    = addRunningProcessHolder;
80104ce5:	89 0d c4 c5 10 80    	mov    %ecx,0x8010c5c4
	rpholder.getMinAccumulator      = getMinAccumulatorRunningProcessHolder;
80104ceb:	a3 cc c5 10 80       	mov    %eax,0x8010c5cc
}
80104cf0:	58                   	pop    %eax
80104cf1:	5b                   	pop    %ebx
80104cf2:	5d                   	pop    %ebp
80104cf3:	c3                   	ret    
80104cf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d00 <_ZN4Link7getLastEv>:
Link* Link::getLast() {
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	8b 45 08             	mov    0x8(%ebp),%eax
80104d06:	eb 0a                	jmp    80104d12 <_ZN4Link7getLastEv+0x12>
80104d08:	90                   	nop
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d10:	89 d0                	mov    %edx,%eax
	while(ans->next)
80104d12:	8b 50 04             	mov    0x4(%eax),%edx
80104d15:	85 d2                	test   %edx,%edx
80104d17:	75 f7                	jne    80104d10 <_ZN4Link7getLastEv+0x10>
}
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret    
80104d1b:	90                   	nop
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d20 <_ZN10LinkedList7isEmptyEv>:
bool LinkedList::isEmpty() {
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
	return !first;
80104d23:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104d26:	5d                   	pop    %ebp
	return !first;
80104d27:	8b 00                	mov    (%eax),%eax
80104d29:	85 c0                	test   %eax,%eax
80104d2b:	0f 94 c0             	sete   %al
}
80104d2e:	c3                   	ret    
80104d2f:	90                   	nop

80104d30 <_ZN10LinkedList6appendEP4Link>:
void LinkedList::append(Link *link) {
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d36:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if(!link)
80104d39:	85 d2                	test   %edx,%edx
80104d3b:	74 1f                	je     80104d5c <_ZN10LinkedList6appendEP4Link+0x2c>
	if(isEmpty()) first = link;
80104d3d:	8b 01                	mov    (%ecx),%eax
80104d3f:	85 c0                	test   %eax,%eax
80104d41:	74 1d                	je     80104d60 <_ZN10LinkedList6appendEP4Link+0x30>
	else last->next = link;
80104d43:	8b 41 04             	mov    0x4(%ecx),%eax
80104d46:	89 50 04             	mov    %edx,0x4(%eax)
80104d49:	eb 07                	jmp    80104d52 <_ZN10LinkedList6appendEP4Link+0x22>
80104d4b:	90                   	nop
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while(ans->next)
80104d50:	89 c2                	mov    %eax,%edx
80104d52:	8b 42 04             	mov    0x4(%edx),%eax
80104d55:	85 c0                	test   %eax,%eax
80104d57:	75 f7                	jne    80104d50 <_ZN10LinkedList6appendEP4Link+0x20>
	last = link->getLast();
80104d59:	89 51 04             	mov    %edx,0x4(%ecx)
}
80104d5c:	5d                   	pop    %ebp
80104d5d:	c3                   	ret    
80104d5e:	66 90                	xchg   %ax,%ax
	if(isEmpty()) first = link;
80104d60:	89 11                	mov    %edx,(%ecx)
80104d62:	eb ee                	jmp    80104d52 <_ZN10LinkedList6appendEP4Link+0x22>
80104d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d70 <_ZN10LinkedList7enqueueEP4proc>:
	if(!freeLinks)
80104d70:	a1 04 c6 10 80       	mov    0x8010c604,%eax
bool LinkedList::enqueue(Proc *p) {
80104d75:	55                   	push   %ebp
80104d76:	89 e5                	mov    %esp,%ebp
80104d78:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if(!freeLinks)
80104d7b:	85 c0                	test   %eax,%eax
80104d7d:	74 41                	je     80104dc0 <_ZN10LinkedList7enqueueEP4proc+0x50>
	freeLinks = freeLinks->next;
80104d7f:	8b 50 04             	mov    0x4(%eax),%edx
	ans->next = null;
80104d82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	freeLinks = freeLinks->next;
80104d89:	89 15 04 c6 10 80    	mov    %edx,0x8010c604
	ans->p = p;
80104d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d92:	89 10                	mov    %edx,(%eax)
	if(isEmpty()) first = link;
80104d94:	8b 11                	mov    (%ecx),%edx
80104d96:	85 d2                	test   %edx,%edx
80104d98:	74 2e                	je     80104dc8 <_ZN10LinkedList7enqueueEP4proc+0x58>
	else last->next = link;
80104d9a:	8b 51 04             	mov    0x4(%ecx),%edx
80104d9d:	89 42 04             	mov    %eax,0x4(%edx)
80104da0:	eb 08                	jmp    80104daa <_ZN10LinkedList7enqueueEP4proc+0x3a>
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while(ans->next)
80104da8:	89 d0                	mov    %edx,%eax
80104daa:	8b 50 04             	mov    0x4(%eax),%edx
80104dad:	85 d2                	test   %edx,%edx
80104daf:	75 f7                	jne    80104da8 <_ZN10LinkedList7enqueueEP4proc+0x38>
	last = link->getLast();
80104db1:	89 41 04             	mov    %eax,0x4(%ecx)
	return true;
80104db4:	b0 01                	mov    $0x1,%al
}
80104db6:	5d                   	pop    %ebp
80104db7:	c3                   	ret    
80104db8:	90                   	nop
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return false;
80104dc0:	31 c0                	xor    %eax,%eax
}
80104dc2:	5d                   	pop    %ebp
80104dc3:	c3                   	ret    
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if(isEmpty()) first = link;
80104dc8:	89 01                	mov    %eax,(%ecx)
80104dca:	eb de                	jmp    80104daa <_ZN10LinkedList7enqueueEP4proc+0x3a>
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <_ZN10LinkedList7dequeueEv>:
Proc* LinkedList::dequeue() {
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 08             	sub    $0x8,%esp
80104dd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dd9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104ddc:	89 75 fc             	mov    %esi,-0x4(%ebp)
	return !first;
80104ddf:	8b 11                	mov    (%ecx),%edx
	if(isEmpty())
80104de1:	85 d2                	test   %edx,%edx
80104de3:	74 2b                	je     80104e10 <_ZN10LinkedList7dequeueEv+0x40>
	Link *next = first->next;
80104de5:	8b 5a 04             	mov    0x4(%edx),%ebx
	link->next = freeLinks;
80104de8:	8b 35 04 c6 10 80    	mov    0x8010c604,%esi
	Proc *p = first->p;
80104dee:	8b 02                	mov    (%edx),%eax
	freeLinks = link;
80104df0:	89 15 04 c6 10 80    	mov    %edx,0x8010c604
	if(isEmpty())
80104df6:	85 db                	test   %ebx,%ebx
	link->next = freeLinks;
80104df8:	89 72 04             	mov    %esi,0x4(%edx)
	first = next;
80104dfb:	89 19                	mov    %ebx,(%ecx)
	if(isEmpty())
80104dfd:	75 07                	jne    80104e06 <_ZN10LinkedList7dequeueEv+0x36>
		last = null;
80104dff:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
}
80104e06:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104e09:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104e0c:	89 ec                	mov    %ebp,%esp
80104e0e:	5d                   	pop    %ebp
80104e0f:	c3                   	ret    
		return null;
80104e10:	31 c0                	xor    %eax,%eax
80104e12:	eb f2                	jmp    80104e06 <_ZN10LinkedList7dequeueEv+0x36>
80104e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e20 <_ZN10LinkedList6removeEP4proc>:
bool LinkedList::remove(Proc *p) {
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	8b 75 08             	mov    0x8(%ebp),%esi
80104e27:	53                   	push   %ebx
80104e28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	return !first;
80104e2b:	8b 1e                	mov    (%esi),%ebx
	if(isEmpty())
80104e2d:	85 db                	test   %ebx,%ebx
80104e2f:	74 2f                	je     80104e60 <_ZN10LinkedList6removeEP4proc+0x40>
	if(first->p == p) {
80104e31:	39 0b                	cmp    %ecx,(%ebx)
80104e33:	8b 53 04             	mov    0x4(%ebx),%edx
80104e36:	74 70                	je     80104ea8 <_ZN10LinkedList6removeEP4proc+0x88>
	while(cur) {
80104e38:	85 d2                	test   %edx,%edx
80104e3a:	74 24                	je     80104e60 <_ZN10LinkedList6removeEP4proc+0x40>
		if(cur->p == p) {
80104e3c:	3b 0a                	cmp    (%edx),%ecx
80104e3e:	66 90                	xchg   %ax,%ax
80104e40:	75 0c                	jne    80104e4e <_ZN10LinkedList6removeEP4proc+0x2e>
80104e42:	eb 2c                	jmp    80104e70 <_ZN10LinkedList6removeEP4proc+0x50>
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e48:	39 08                	cmp    %ecx,(%eax)
80104e4a:	74 34                	je     80104e80 <_ZN10LinkedList6removeEP4proc+0x60>
80104e4c:	89 c2                	mov    %eax,%edx
		cur = cur->next;
80104e4e:	8b 42 04             	mov    0x4(%edx),%eax
	while(cur) {
80104e51:	85 c0                	test   %eax,%eax
80104e53:	75 f3                	jne    80104e48 <_ZN10LinkedList6removeEP4proc+0x28>
}
80104e55:	5b                   	pop    %ebx
80104e56:	5e                   	pop    %esi
80104e57:	5d                   	pop    %ebp
80104e58:	c3                   	ret    
80104e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e60:	5b                   	pop    %ebx
		return false;
80104e61:	31 c0                	xor    %eax,%eax
}
80104e63:	5e                   	pop    %esi
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
80104e66:	8d 76 00             	lea    0x0(%esi),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		if(cur->p == p) {
80104e70:	89 d0                	mov    %edx,%eax
80104e72:	89 da                	mov    %ebx,%edx
80104e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
			prev->next = cur->next;
80104e80:	8b 48 04             	mov    0x4(%eax),%ecx
80104e83:	89 4a 04             	mov    %ecx,0x4(%edx)
			if(!(cur->next)) //removes the last link
80104e86:	8b 48 04             	mov    0x4(%eax),%ecx
80104e89:	85 c9                	test   %ecx,%ecx
80104e8b:	74 43                	je     80104ed0 <_ZN10LinkedList6removeEP4proc+0xb0>
	link->next = freeLinks;
80104e8d:	8b 15 04 c6 10 80    	mov    0x8010c604,%edx
	freeLinks = link;
80104e93:	a3 04 c6 10 80       	mov    %eax,0x8010c604
	link->next = freeLinks;
80104e98:	89 50 04             	mov    %edx,0x4(%eax)
			return true;
80104e9b:	b0 01                	mov    $0x1,%al
}
80104e9d:	5b                   	pop    %ebx
80104e9e:	5e                   	pop    %esi
80104e9f:	5d                   	pop    %ebp
80104ea0:	c3                   	ret    
80104ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	link->next = freeLinks;
80104ea8:	a1 04 c6 10 80       	mov    0x8010c604,%eax
	if(isEmpty())
80104ead:	85 d2                	test   %edx,%edx
	freeLinks = link;
80104eaf:	89 1d 04 c6 10 80    	mov    %ebx,0x8010c604
	link->next = freeLinks;
80104eb5:	89 43 04             	mov    %eax,0x4(%ebx)
		return true;
80104eb8:	b0 01                	mov    $0x1,%al
	first = next;
80104eba:	89 16                	mov    %edx,(%esi)
	if(isEmpty())
80104ebc:	75 97                	jne    80104e55 <_ZN10LinkedList6removeEP4proc+0x35>
		last = null;
80104ebe:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
80104ec5:	eb 8e                	jmp    80104e55 <_ZN10LinkedList6removeEP4proc+0x35>
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
				last = prev;
80104ed0:	89 56 04             	mov    %edx,0x4(%esi)
80104ed3:	eb b8                	jmp    80104e8d <_ZN10LinkedList6removeEP4proc+0x6d>
80104ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <removeRunningProcessHolder>:
static boolean removeRunningProcessHolder(Proc* p) {
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	83 ec 08             	sub    $0x8,%esp
	return runningProcHolder->remove(p);
80104ee6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eed:	a1 08 c6 10 80       	mov    0x8010c608,%eax
80104ef2:	89 04 24             	mov    %eax,(%esp)
80104ef5:	e8 26 ff ff ff       	call   80104e20 <_ZN10LinkedList6removeEP4proc>
}
80104efa:	c9                   	leave  
	return runningProcHolder->remove(p);
80104efb:	0f b6 c0             	movzbl %al,%eax
}
80104efe:	c3                   	ret    
80104eff:	90                   	nop

80104f00 <_ZN10LinkedList8transferEv>:
	if(!priorityQ->isEmpty())
80104f00:	8b 15 10 c6 10 80    	mov    0x8010c610,%edx
		return false;
80104f06:	31 c0                	xor    %eax,%eax
bool LinkedList::transfer() {
80104f08:	55                   	push   %ebp
80104f09:	89 e5                	mov    %esp,%ebp
80104f0b:	53                   	push   %ebx
80104f0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if(!priorityQ->isEmpty())
80104f0f:	8b 1a                	mov    (%edx),%ebx
80104f11:	85 db                	test   %ebx,%ebx
80104f13:	74 0b                	je     80104f20 <_ZN10LinkedList8transferEv+0x20>
}
80104f15:	5b                   	pop    %ebx
80104f16:	5d                   	pop    %ebp
80104f17:	c3                   	ret    
80104f18:	90                   	nop
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if(!isEmpty()) {
80104f20:	8b 19                	mov    (%ecx),%ebx
80104f22:	85 db                	test   %ebx,%ebx
80104f24:	74 4a                	je     80104f70 <_ZN10LinkedList8transferEv+0x70>
	if(!freeNodes)
80104f26:	8b 1d 00 c6 10 80    	mov    0x8010c600,%ebx
80104f2c:	85 db                	test   %ebx,%ebx
80104f2e:	74 e5                	je     80104f15 <_ZN10LinkedList8transferEv+0x15>
	freeNodes = freeNodes->next;
80104f30:	8b 43 10             	mov    0x10(%ebx),%eax
	ans->key = key;
80104f33:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	ans->next = null;
80104f39:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
	ans->key = key;
80104f40:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	freeNodes = freeNodes->next;
80104f47:	a3 00 c6 10 80       	mov    %eax,0x8010c600
		node->listOfProcs.first = first;
80104f4c:	8b 01                	mov    (%ecx),%eax
80104f4e:	89 43 08             	mov    %eax,0x8(%ebx)
		node->listOfProcs.last = last;
80104f51:	8b 41 04             	mov    0x4(%ecx),%eax
80104f54:	89 43 0c             	mov    %eax,0xc(%ebx)
	return true;
80104f57:	b0 01                	mov    $0x1,%al
		first = last = null;
80104f59:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
80104f60:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
		priorityQ->root = node;
80104f66:	89 1a                	mov    %ebx,(%edx)
}
80104f68:	5b                   	pop    %ebx
80104f69:	5d                   	pop    %ebp
80104f6a:	c3                   	ret    
80104f6b:	90                   	nop
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return true;
80104f70:	b0 01                	mov    $0x1,%al
80104f72:	eb a1                	jmp    80104f15 <_ZN10LinkedList8transferEv+0x15>
80104f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f80 <switchToPriorityQueuePolicyRoundRobinQueue>:
static boolean switchToPriorityQueuePolicyRoundRobinQueue() {
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	83 ec 04             	sub    $0x4,%esp
	return roundRobinQ->transfer();
80104f86:	a1 0c c6 10 80       	mov    0x8010c60c,%eax
80104f8b:	89 04 24             	mov    %eax,(%esp)
80104f8e:	e8 6d ff ff ff       	call   80104f00 <_ZN10LinkedList8transferEv>
}
80104f93:	c9                   	leave  
	return roundRobinQ->transfer();
80104f94:	0f b6 c0             	movzbl %al,%eax
}
80104f97:	c3                   	ret    
80104f98:	90                   	nop
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <_ZN10LinkedList9getMinKeyEPx>:
bool LinkedList::getMinKey(long long *pkey) {
80104fa0:	55                   	push   %ebp
80104fa1:	31 c0                	xor    %eax,%eax
80104fa3:	89 e5                	mov    %esp,%ebp
80104fa5:	57                   	push   %edi
80104fa6:	56                   	push   %esi
80104fa7:	53                   	push   %ebx
80104fa8:	83 ec 1c             	sub    $0x1c,%esp
80104fab:	8b 7d 08             	mov    0x8(%ebp),%edi
	return !first;
80104fae:	8b 17                	mov    (%edi),%edx
	if(isEmpty())
80104fb0:	85 d2                	test   %edx,%edx
80104fb2:	74 41                	je     80104ff5 <_ZN10LinkedList9getMinKeyEPx+0x55>
	long long minKey = getAccumulator(first->p);
80104fb4:	8b 02                	mov    (%edx),%eax
80104fb6:	89 04 24             	mov    %eax,(%esp)
80104fb9:	e8 22 ea ff ff       	call   801039e0 <getAccumulator>
	forEach([&](Proc *p) {
80104fbe:	8b 3f                	mov    (%edi),%edi
	void append(Link *link); //appends the given list to the queue. No allocations always succeeds.
	
	template<typename Func>
	void forEach(const Func& accept) { //for-each loop. gets a function that applies the procin each link node.
		Link *link = first;
		while(link) {
80104fc0:	85 ff                	test   %edi,%edi
	long long minKey = getAccumulator(first->p);
80104fc2:	89 c6                	mov    %eax,%esi
80104fc4:	89 d3                	mov    %edx,%ebx
80104fc6:	74 23                	je     80104feb <_ZN10LinkedList9getMinKeyEPx+0x4b>
80104fc8:	90                   	nop
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		long long key = getAccumulator(p);
80104fd0:	8b 07                	mov    (%edi),%eax
80104fd2:	89 04 24             	mov    %eax,(%esp)
80104fd5:	e8 06 ea ff ff       	call   801039e0 <getAccumulator>
80104fda:	39 d3                	cmp    %edx,%ebx
80104fdc:	7c 06                	jl     80104fe4 <_ZN10LinkedList9getMinKeyEPx+0x44>
80104fde:	7f 20                	jg     80105000 <_ZN10LinkedList9getMinKeyEPx+0x60>
80104fe0:	39 c6                	cmp    %eax,%esi
80104fe2:	77 1c                	ja     80105000 <_ZN10LinkedList9getMinKeyEPx+0x60>
			accept(link->p);
			link = link->next;
80104fe4:	8b 7f 04             	mov    0x4(%edi),%edi
		while(link) {
80104fe7:	85 ff                	test   %edi,%edi
80104fe9:	75 e5                	jne    80104fd0 <_ZN10LinkedList9getMinKeyEPx+0x30>
	*pkey = minKey;
80104feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fee:	89 30                	mov    %esi,(%eax)
80104ff0:	89 58 04             	mov    %ebx,0x4(%eax)
	return true;
80104ff3:	b0 01                	mov    $0x1,%al
}
80104ff5:	83 c4 1c             	add    $0x1c,%esp
80104ff8:	5b                   	pop    %ebx
80104ff9:	5e                   	pop    %esi
80104ffa:	5f                   	pop    %edi
80104ffb:	5d                   	pop    %ebp
80104ffc:	c3                   	ret    
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
			link = link->next;
80105000:	8b 7f 04             	mov    0x4(%edi),%edi
80105003:	89 c6                	mov    %eax,%esi
80105005:	89 d3                	mov    %edx,%ebx
		while(link) {
80105007:	85 ff                	test   %edi,%edi
80105009:	75 c5                	jne    80104fd0 <_ZN10LinkedList9getMinKeyEPx+0x30>
8010500b:	eb de                	jmp    80104feb <_ZN10LinkedList9getMinKeyEPx+0x4b>
8010500d:	8d 76 00             	lea    0x0(%esi),%esi

80105010 <getMinAccumulatorRunningProcessHolder>:
static boolean getMinAccumulatorRunningProcessHolder(long long *pkey) {
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 18             	sub    $0x18,%esp
	return runningProcHolder->getMinKey(pkey);
80105016:	8b 45 08             	mov    0x8(%ebp),%eax
80105019:	89 44 24 04          	mov    %eax,0x4(%esp)
8010501d:	a1 08 c6 10 80       	mov    0x8010c608,%eax
80105022:	89 04 24             	mov    %eax,(%esp)
80105025:	e8 76 ff ff ff       	call   80104fa0 <_ZN10LinkedList9getMinKeyEPx>
}
8010502a:	c9                   	leave  
	return runningProcHolder->getMinKey(pkey);
8010502b:	0f b6 c0             	movzbl %al,%eax
}
8010502e:	c3                   	ret    
8010502f:	90                   	nop

80105030 <_ZN7MapNode7isEmptyEv>:
bool MapNode::isEmpty() {
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
	return !first;
80105033:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105036:	5d                   	pop    %ebp
	return !first;
80105037:	8b 40 08             	mov    0x8(%eax),%eax
8010503a:	85 c0                	test   %eax,%eax
8010503c:	0f 94 c0             	sete   %al
}
8010503f:	c3                   	ret    

80105040 <_ZN7MapNode3putEP4proc>:
bool MapNode::put(Proc *p) { //we can not use recursion, since the stack of xv6 is too small....
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
80105046:	83 ec 2c             	sub    $0x2c,%esp
	long long key = getAccumulator(p);
80105049:	8b 45 0c             	mov    0xc(%ebp),%eax
bool MapNode::put(Proc *p) { //we can not use recursion, since the stack of xv6 is too small....
8010504c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	long long key = getAccumulator(p);
8010504f:	89 04 24             	mov    %eax,(%esp)
80105052:	e8 89 e9 ff ff       	call   801039e0 <getAccumulator>
80105057:	89 d1                	mov    %edx,%ecx
80105059:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(key == node->key)
80105060:	8b 13                	mov    (%ebx),%edx
80105062:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80105065:	8b 43 04             	mov    0x4(%ebx),%eax
80105068:	31 d7                	xor    %edx,%edi
8010506a:	89 fe                	mov    %edi,%esi
8010506c:	89 c7                	mov    %eax,%edi
8010506e:	31 cf                	xor    %ecx,%edi
80105070:	09 fe                	or     %edi,%esi
80105072:	74 4c                	je     801050c0 <_ZN7MapNode3putEP4proc+0x80>
		else if(key < node->key) { //left
80105074:	39 c8                	cmp    %ecx,%eax
80105076:	7c 20                	jl     80105098 <_ZN7MapNode3putEP4proc+0x58>
80105078:	7f 08                	jg     80105082 <_ZN7MapNode3putEP4proc+0x42>
8010507a:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
80105080:	76 16                	jbe    80105098 <_ZN7MapNode3putEP4proc+0x58>
			if(node->left)
80105082:	8b 43 18             	mov    0x18(%ebx),%eax
80105085:	85 c0                	test   %eax,%eax
80105087:	0f 84 83 00 00 00    	je     80105110 <_ZN7MapNode3putEP4proc+0xd0>
bool MapNode::put(Proc *p) { //we can not use recursion, since the stack of xv6 is too small....
8010508d:	89 c3                	mov    %eax,%ebx
8010508f:	eb cf                	jmp    80105060 <_ZN7MapNode3putEP4proc+0x20>
80105091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			if(node->right)
80105098:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010509b:	85 c0                	test   %eax,%eax
8010509d:	75 ee                	jne    8010508d <_ZN7MapNode3putEP4proc+0x4d>
8010509f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				node->right = allocNode(p, key);
801050a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a5:	89 f2                	mov    %esi,%edx
801050a7:	e8 e4 f9 ff ff       	call   80104a90 <_ZL9allocNodeP4procx>
				if(node->right) {
801050ac:	85 c0                	test   %eax,%eax
				node->right = allocNode(p, key);
801050ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
				if(node->right) {
801050b1:	74 71                	je     80105124 <_ZN7MapNode3putEP4proc+0xe4>
					node->right->parent = node;
801050b3:	89 58 14             	mov    %ebx,0x14(%eax)
}
801050b6:	83 c4 2c             	add    $0x2c,%esp
					return true;
801050b9:	b0 01                	mov    $0x1,%al
}
801050bb:	5b                   	pop    %ebx
801050bc:	5e                   	pop    %esi
801050bd:	5f                   	pop    %edi
801050be:	5d                   	pop    %ebp
801050bf:	c3                   	ret    
	if(!freeLinks)
801050c0:	a1 04 c6 10 80       	mov    0x8010c604,%eax
801050c5:	85 c0                	test   %eax,%eax
801050c7:	74 5b                	je     80105124 <_ZN7MapNode3putEP4proc+0xe4>
	ans->p = p;
801050c9:	8b 75 0c             	mov    0xc(%ebp),%esi
	freeLinks = freeLinks->next;
801050cc:	8b 50 04             	mov    0x4(%eax),%edx
	ans->next = null;
801050cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	ans->p = p;
801050d6:	89 30                	mov    %esi,(%eax)
	freeLinks = freeLinks->next;
801050d8:	89 15 04 c6 10 80    	mov    %edx,0x8010c604
	if(isEmpty()) first = link;
801050de:	8b 53 08             	mov    0x8(%ebx),%edx
801050e1:	85 d2                	test   %edx,%edx
801050e3:	74 4b                	je     80105130 <_ZN7MapNode3putEP4proc+0xf0>
	else last->next = link;
801050e5:	8b 53 0c             	mov    0xc(%ebx),%edx
801050e8:	89 42 04             	mov    %eax,0x4(%edx)
801050eb:	eb 05                	jmp    801050f2 <_ZN7MapNode3putEP4proc+0xb2>
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
	while(ans->next)
801050f0:	89 d0                	mov    %edx,%eax
801050f2:	8b 50 04             	mov    0x4(%eax),%edx
801050f5:	85 d2                	test   %edx,%edx
801050f7:	75 f7                	jne    801050f0 <_ZN7MapNode3putEP4proc+0xb0>
	last = link->getLast();
801050f9:	89 43 0c             	mov    %eax,0xc(%ebx)
}
801050fc:	83 c4 2c             	add    $0x2c,%esp
	return true;
801050ff:	b0 01                	mov    $0x1,%al
}
80105101:	5b                   	pop    %ebx
80105102:	5e                   	pop    %esi
80105103:	5f                   	pop    %edi
80105104:	5d                   	pop    %ebp
80105105:	c3                   	ret    
80105106:	8d 76 00             	lea    0x0(%esi),%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105110:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				node->left = allocNode(p, key);
80105113:	8b 45 0c             	mov    0xc(%ebp),%eax
80105116:	89 f2                	mov    %esi,%edx
80105118:	e8 73 f9 ff ff       	call   80104a90 <_ZL9allocNodeP4procx>
				if(node->left) {
8010511d:	85 c0                	test   %eax,%eax
				node->left = allocNode(p, key);
8010511f:	89 43 18             	mov    %eax,0x18(%ebx)
				if(node->left) {
80105122:	75 8f                	jne    801050b3 <_ZN7MapNode3putEP4proc+0x73>
}
80105124:	83 c4 2c             	add    $0x2c,%esp
		return false;
80105127:	31 c0                	xor    %eax,%eax
}
80105129:	5b                   	pop    %ebx
8010512a:	5e                   	pop    %esi
8010512b:	5f                   	pop    %edi
8010512c:	5d                   	pop    %ebp
8010512d:	c3                   	ret    
8010512e:	66 90                	xchg   %ax,%ax
	if(isEmpty()) first = link;
80105130:	89 43 08             	mov    %eax,0x8(%ebx)
80105133:	eb bd                	jmp    801050f2 <_ZN7MapNode3putEP4proc+0xb2>
80105135:	90                   	nop
80105136:	8d 76 00             	lea    0x0(%esi),%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105140 <_ZN7MapNode10getMinNodeEv>:
MapNode* MapNode::getMinNode() { //no recursion.
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	8b 45 08             	mov    0x8(%ebp),%eax
80105146:	eb 0a                	jmp    80105152 <_ZN7MapNode10getMinNodeEv+0x12>
80105148:	90                   	nop
80105149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105150:	89 d0                	mov    %edx,%eax
	while(minNode->left)
80105152:	8b 50 18             	mov    0x18(%eax),%edx
80105155:	85 d2                	test   %edx,%edx
80105157:	75 f7                	jne    80105150 <_ZN7MapNode10getMinNodeEv+0x10>
}
80105159:	5d                   	pop    %ebp
8010515a:	c3                   	ret    
8010515b:	90                   	nop
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <_ZN7MapNode9getMinKeyEPx>:
void MapNode::getMinKey(long long *pkey) {
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	8b 55 08             	mov    0x8(%ebp),%edx
80105166:	53                   	push   %ebx
80105167:	eb 09                	jmp    80105172 <_ZN7MapNode9getMinKeyEPx+0x12>
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	while(minNode->left)
80105170:	89 c2                	mov    %eax,%edx
80105172:	8b 42 18             	mov    0x18(%edx),%eax
80105175:	85 c0                	test   %eax,%eax
80105177:	75 f7                	jne    80105170 <_ZN7MapNode9getMinKeyEPx+0x10>
	*pkey = getMinNode()->key;
80105179:	8b 5a 04             	mov    0x4(%edx),%ebx
8010517c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010517f:	8b 0a                	mov    (%edx),%ecx
80105181:	89 58 04             	mov    %ebx,0x4(%eax)
80105184:	89 08                	mov    %ecx,(%eax)
}
80105186:	5b                   	pop    %ebx
80105187:	5d                   	pop    %ebp
80105188:	c3                   	ret    
80105189:	90                   	nop
8010518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105190 <_ZN7MapNode7dequeueEv>:
Proc* MapNode::dequeue() {
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	83 ec 08             	sub    $0x8,%esp
80105196:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105199:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010519c:	89 75 fc             	mov    %esi,-0x4(%ebp)
	return !first;
8010519f:	8b 51 08             	mov    0x8(%ecx),%edx
	if(isEmpty())
801051a2:	85 d2                	test   %edx,%edx
801051a4:	74 32                	je     801051d8 <_ZN7MapNode7dequeueEv+0x48>
	Link *next = first->next;
801051a6:	8b 5a 04             	mov    0x4(%edx),%ebx
	link->next = freeLinks;
801051a9:	8b 35 04 c6 10 80    	mov    0x8010c604,%esi
	Proc *p = first->p;
801051af:	8b 02                	mov    (%edx),%eax
	freeLinks = link;
801051b1:	89 15 04 c6 10 80    	mov    %edx,0x8010c604
	if(isEmpty())
801051b7:	85 db                	test   %ebx,%ebx
	link->next = freeLinks;
801051b9:	89 72 04             	mov    %esi,0x4(%edx)
	first = next;
801051bc:	89 59 08             	mov    %ebx,0x8(%ecx)
	if(isEmpty())
801051bf:	75 07                	jne    801051c8 <_ZN7MapNode7dequeueEv+0x38>
		last = null;
801051c1:	c7 41 0c 00 00 00 00 	movl   $0x0,0xc(%ecx)
}
801051c8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801051cb:	8b 75 fc             	mov    -0x4(%ebp),%esi
801051ce:	89 ec                	mov    %ebp,%esp
801051d0:	5d                   	pop    %ebp
801051d1:	c3                   	ret    
801051d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		return null;
801051d8:	31 c0                	xor    %eax,%eax
	return listOfProcs.dequeue();
801051da:	eb ec                	jmp    801051c8 <_ZN7MapNode7dequeueEv+0x38>
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <_ZN3Map7isEmptyEv>:
bool Map::isEmpty() {
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
	return !root;
801051e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801051e6:	5d                   	pop    %ebp
	return !root;
801051e7:	8b 00                	mov    (%eax),%eax
801051e9:	85 c0                	test   %eax,%eax
801051eb:	0f 94 c0             	sete   %al
}
801051ee:	c3                   	ret    
801051ef:	90                   	nop

801051f0 <_ZN3Map3putEP4proc>:
bool Map::put(Proc *p) {
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	83 ec 18             	sub    $0x18,%esp
801051f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801051f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801051fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
801051ff:	8b 75 08             	mov    0x8(%ebp),%esi
	long long key = getAccumulator(p);
80105202:	89 1c 24             	mov    %ebx,(%esp)
80105205:	e8 d6 e7 ff ff       	call   801039e0 <getAccumulator>
	return !root;
8010520a:	8b 0e                	mov    (%esi),%ecx
	if(isEmpty()) {
8010520c:	85 c9                	test   %ecx,%ecx
8010520e:	74 18                	je     80105228 <_ZN3Map3putEP4proc+0x38>
	return root->put(p);
80105210:	89 5d 0c             	mov    %ebx,0xc(%ebp)
}
80105213:	8b 75 fc             	mov    -0x4(%ebp),%esi
	return root->put(p);
80105216:	89 4d 08             	mov    %ecx,0x8(%ebp)
}
80105219:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010521c:	89 ec                	mov    %ebp,%esp
8010521e:	5d                   	pop    %ebp
	return root->put(p);
8010521f:	e9 1c fe ff ff       	jmp    80105040 <_ZN7MapNode3putEP4proc>
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		root = allocNode(p, key);
80105228:	89 d1                	mov    %edx,%ecx
8010522a:	89 c2                	mov    %eax,%edx
8010522c:	89 d8                	mov    %ebx,%eax
8010522e:	e8 5d f8 ff ff       	call   80104a90 <_ZL9allocNodeP4procx>
80105233:	89 06                	mov    %eax,(%esi)
		return !isEmpty();
80105235:	85 c0                	test   %eax,%eax
80105237:	0f 95 c0             	setne  %al
}
8010523a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010523d:	8b 75 fc             	mov    -0x4(%ebp),%esi
80105240:	89 ec                	mov    %ebp,%esp
80105242:	5d                   	pop    %ebp
80105243:	c3                   	ret    
80105244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010524a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105250 <putPriorityQueue>:
static boolean putPriorityQueue(Proc* p) {
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	83 ec 18             	sub    $0x18,%esp
	return priorityQ->put(p);
80105256:	8b 45 08             	mov    0x8(%ebp),%eax
80105259:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525d:	a1 10 c6 10 80       	mov    0x8010c610,%eax
80105262:	89 04 24             	mov    %eax,(%esp)
80105265:	e8 86 ff ff ff       	call   801051f0 <_ZN3Map3putEP4proc>
}
8010526a:	c9                   	leave  
	return priorityQ->put(p);
8010526b:	0f b6 c0             	movzbl %al,%eax
}
8010526e:	c3                   	ret    
8010526f:	90                   	nop

80105270 <_ZN3Map9getMinKeyEPx>:
bool Map::getMinKey(long long *pkey) {
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
	return !root;
80105273:	8b 45 08             	mov    0x8(%ebp),%eax
bool Map::getMinKey(long long *pkey) {
80105276:	53                   	push   %ebx
	return !root;
80105277:	8b 10                	mov    (%eax),%edx
	if(isEmpty())
80105279:	85 d2                	test   %edx,%edx
8010527b:	75 05                	jne    80105282 <_ZN3Map9getMinKeyEPx+0x12>
8010527d:	eb 21                	jmp    801052a0 <_ZN3Map9getMinKeyEPx+0x30>
8010527f:	90                   	nop
	while(minNode->left)
80105280:	89 c2                	mov    %eax,%edx
80105282:	8b 42 18             	mov    0x18(%edx),%eax
80105285:	85 c0                	test   %eax,%eax
80105287:	75 f7                	jne    80105280 <_ZN3Map9getMinKeyEPx+0x10>
	*pkey = getMinNode()->key;
80105289:	8b 45 0c             	mov    0xc(%ebp),%eax
8010528c:	8b 5a 04             	mov    0x4(%edx),%ebx
8010528f:	8b 0a                	mov    (%edx),%ecx
80105291:	89 58 04             	mov    %ebx,0x4(%eax)
80105294:	89 08                	mov    %ecx,(%eax)
		return false;

	root->getMinKey(pkey);
	return true;
80105296:	b0 01                	mov    $0x1,%al
}
80105298:	5b                   	pop    %ebx
80105299:	5d                   	pop    %ebp
8010529a:	c3                   	ret    
8010529b:	90                   	nop
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052a0:	5b                   	pop    %ebx
		return false;
801052a1:	31 c0                	xor    %eax,%eax
}
801052a3:	5d                   	pop    %ebp
801052a4:	c3                   	ret    
801052a5:	90                   	nop
801052a6:	8d 76 00             	lea    0x0(%esi),%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <_ZN3Map10extractMinEv>:

Proc* Map::extractMin() {
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	8b 75 08             	mov    0x8(%ebp),%esi
801052b8:	53                   	push   %ebx
	return !root;
801052b9:	8b 1e                	mov    (%esi),%ebx
	if(isEmpty())
801052bb:	85 db                	test   %ebx,%ebx
801052bd:	0f 84 a5 00 00 00    	je     80105368 <_ZN3Map10extractMinEv+0xb8>
801052c3:	89 da                	mov    %ebx,%edx
801052c5:	eb 0b                	jmp    801052d2 <_ZN3Map10extractMinEv+0x22>
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	while(minNode->left)
801052d0:	89 c2                	mov    %eax,%edx
801052d2:	8b 42 18             	mov    0x18(%edx),%eax
801052d5:	85 c0                	test   %eax,%eax
801052d7:	75 f7                	jne    801052d0 <_ZN3Map10extractMinEv+0x20>
	return !first;
801052d9:	8b 4a 08             	mov    0x8(%edx),%ecx
	if(isEmpty())
801052dc:	85 c9                	test   %ecx,%ecx
801052de:	74 70                	je     80105350 <_ZN3Map10extractMinEv+0xa0>
	Link *next = first->next;
801052e0:	8b 59 04             	mov    0x4(%ecx),%ebx
	link->next = freeLinks;
801052e3:	8b 3d 04 c6 10 80    	mov    0x8010c604,%edi
	Proc *p = first->p;
801052e9:	8b 01                	mov    (%ecx),%eax
	freeLinks = link;
801052eb:	89 0d 04 c6 10 80    	mov    %ecx,0x8010c604
	if(isEmpty())
801052f1:	85 db                	test   %ebx,%ebx
	link->next = freeLinks;
801052f3:	89 79 04             	mov    %edi,0x4(%ecx)
	first = next;
801052f6:	89 5a 08             	mov    %ebx,0x8(%edx)
	if(isEmpty())
801052f9:	74 05                	je     80105300 <_ZN3Map10extractMinEv+0x50>
		}
		deallocNode(minNode);
	}

	return p;
}
801052fb:	5b                   	pop    %ebx
801052fc:	5e                   	pop    %esi
801052fd:	5f                   	pop    %edi
801052fe:	5d                   	pop    %ebp
801052ff:	c3                   	ret    
		last = null;
80105300:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
80105307:	8b 4a 1c             	mov    0x1c(%edx),%ecx
8010530a:	8b 1e                	mov    (%esi),%ebx
		if(minNode == root) {
8010530c:	39 da                	cmp    %ebx,%edx
8010530e:	74 49                	je     80105359 <_ZN3Map10extractMinEv+0xa9>
			MapNode *parent = minNode->parent;
80105310:	8b 5a 14             	mov    0x14(%edx),%ebx
			parent->left = minNode->right;
80105313:	89 4b 18             	mov    %ecx,0x18(%ebx)
			if(minNode->right)
80105316:	8b 4a 1c             	mov    0x1c(%edx),%ecx
80105319:	85 c9                	test   %ecx,%ecx
8010531b:	74 03                	je     80105320 <_ZN3Map10extractMinEv+0x70>
				minNode->right->parent = parent;
8010531d:	89 59 14             	mov    %ebx,0x14(%ecx)
	node->next = freeNodes;
80105320:	8b 0d 00 c6 10 80    	mov    0x8010c600,%ecx
	node->parent = node->left = node->right = null;
80105326:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
8010532d:	c7 42 18 00 00 00 00 	movl   $0x0,0x18(%edx)
80105334:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
	node->next = freeNodes;
8010533b:	89 4a 10             	mov    %ecx,0x10(%edx)
}
8010533e:	5b                   	pop    %ebx
	freeNodes = node;
8010533f:	89 15 00 c6 10 80    	mov    %edx,0x8010c600
}
80105345:	5e                   	pop    %esi
80105346:	5f                   	pop    %edi
80105347:	5d                   	pop    %ebp
80105348:	c3                   	ret    
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return null;
80105350:	31 c0                	xor    %eax,%eax
		if(minNode == root) {
80105352:	39 da                	cmp    %ebx,%edx
80105354:	8b 4a 1c             	mov    0x1c(%edx),%ecx
80105357:	75 b7                	jne    80105310 <_ZN3Map10extractMinEv+0x60>
			if(!isEmpty())
80105359:	85 c9                	test   %ecx,%ecx
			root = minNode->right;
8010535b:	89 0e                	mov    %ecx,(%esi)
			if(!isEmpty())
8010535d:	74 c1                	je     80105320 <_ZN3Map10extractMinEv+0x70>
				root->parent = null;
8010535f:	c7 41 14 00 00 00 00 	movl   $0x0,0x14(%ecx)
80105366:	eb b8                	jmp    80105320 <_ZN3Map10extractMinEv+0x70>
		return null;
80105368:	31 c0                	xor    %eax,%eax
8010536a:	eb 8f                	jmp    801052fb <_ZN3Map10extractMinEv+0x4b>
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <extractMinPriorityQueue>:
static Proc* extractMinPriorityQueue() {
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 04             	sub    $0x4,%esp
	return priorityQ->extractMin();
80105376:	a1 10 c6 10 80       	mov    0x8010c610,%eax
8010537b:	89 04 24             	mov    %eax,(%esp)
8010537e:	e8 2d ff ff ff       	call   801052b0 <_ZN3Map10extractMinEv>
}
80105383:	c9                   	leave  
80105384:	c3                   	ret    
80105385:	90                   	nop
80105386:	8d 76 00             	lea    0x0(%esi),%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <_ZN3Map8transferEv.part.1>:

bool Map::transfer() {
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
80105395:	89 c3                	mov    %eax,%ebx
80105397:	83 ec 04             	sub    $0x4,%esp
8010539a:	eb 16                	jmp    801053b2 <_ZN3Map8transferEv.part.1+0x22>
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if(!roundRobinQ->isEmpty())
		return false;

	while(!isEmpty()) {
		Proc* p = extractMin();
801053a0:	89 1c 24             	mov    %ebx,(%esp)
801053a3:	e8 08 ff ff ff       	call   801052b0 <_ZN3Map10extractMinEv>
	if(!freeLinks)
801053a8:	8b 15 04 c6 10 80    	mov    0x8010c604,%edx
801053ae:	85 d2                	test   %edx,%edx
801053b0:	75 0e                	jne    801053c0 <_ZN3Map8transferEv.part.1+0x30>
	while(!isEmpty()) {
801053b2:	8b 03                	mov    (%ebx),%eax
801053b4:	85 c0                	test   %eax,%eax
801053b6:	75 e8                	jne    801053a0 <_ZN3Map8transferEv.part.1+0x10>
		roundRobinQ->enqueue(p); //should succeed.
	}

	return true;
}
801053b8:	5a                   	pop    %edx
801053b9:	b0 01                	mov    $0x1,%al
801053bb:	5b                   	pop    %ebx
801053bc:	5e                   	pop    %esi
801053bd:	5d                   	pop    %ebp
801053be:	c3                   	ret    
801053bf:	90                   	nop
	freeLinks = freeLinks->next;
801053c0:	8b 72 04             	mov    0x4(%edx),%esi
		roundRobinQ->enqueue(p); //should succeed.
801053c3:	8b 0d 0c c6 10 80    	mov    0x8010c60c,%ecx
	ans->next = null;
801053c9:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
	ans->p = p;
801053d0:	89 02                	mov    %eax,(%edx)
	freeLinks = freeLinks->next;
801053d2:	89 35 04 c6 10 80    	mov    %esi,0x8010c604
	if(isEmpty()) first = link;
801053d8:	8b 31                	mov    (%ecx),%esi
801053da:	85 f6                	test   %esi,%esi
801053dc:	74 22                	je     80105400 <_ZN3Map8transferEv.part.1+0x70>
	else last->next = link;
801053de:	8b 41 04             	mov    0x4(%ecx),%eax
801053e1:	89 50 04             	mov    %edx,0x4(%eax)
801053e4:	eb 0c                	jmp    801053f2 <_ZN3Map8transferEv.part.1+0x62>
801053e6:	8d 76 00             	lea    0x0(%esi),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	while(ans->next)
801053f0:	89 c2                	mov    %eax,%edx
801053f2:	8b 42 04             	mov    0x4(%edx),%eax
801053f5:	85 c0                	test   %eax,%eax
801053f7:	75 f7                	jne    801053f0 <_ZN3Map8transferEv.part.1+0x60>
	last = link->getLast();
801053f9:	89 51 04             	mov    %edx,0x4(%ecx)
801053fc:	eb b4                	jmp    801053b2 <_ZN3Map8transferEv.part.1+0x22>
801053fe:	66 90                	xchg   %ax,%ax
	if(isEmpty()) first = link;
80105400:	89 11                	mov    %edx,(%ecx)
80105402:	eb ee                	jmp    801053f2 <_ZN3Map8transferEv.part.1+0x62>
80105404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010540a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105410 <switchToRoundRobinPolicyPriorityQueue>:
	if(!roundRobinQ->isEmpty())
80105410:	8b 15 0c c6 10 80    	mov    0x8010c60c,%edx
80105416:	8b 02                	mov    (%edx),%eax
80105418:	85 c0                	test   %eax,%eax
8010541a:	74 04                	je     80105420 <switchToRoundRobinPolicyPriorityQueue+0x10>
8010541c:	31 c0                	xor    %eax,%eax
}
8010541e:	c3                   	ret    
8010541f:	90                   	nop
80105420:	a1 10 c6 10 80       	mov    0x8010c610,%eax
static boolean switchToRoundRobinPolicyPriorityQueue() {
80105425:	55                   	push   %ebp
80105426:	89 e5                	mov    %esp,%ebp
80105428:	e8 63 ff ff ff       	call   80105390 <_ZN3Map8transferEv.part.1>
}
8010542d:	5d                   	pop    %ebp
8010542e:	0f b6 c0             	movzbl %al,%eax
80105431:	c3                   	ret    
80105432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <_ZN3Map8transferEv>:
	return !first;
80105440:	8b 15 0c c6 10 80    	mov    0x8010c60c,%edx
bool Map::transfer() {
80105446:	55                   	push   %ebp
80105447:	89 e5                	mov    %esp,%ebp
80105449:	8b 45 08             	mov    0x8(%ebp),%eax
	if(!roundRobinQ->isEmpty())
8010544c:	8b 12                	mov    (%edx),%edx
8010544e:	85 d2                	test   %edx,%edx
80105450:	74 0e                	je     80105460 <_ZN3Map8transferEv+0x20>
}
80105452:	31 c0                	xor    %eax,%eax
80105454:	5d                   	pop    %ebp
80105455:	c3                   	ret    
80105456:	8d 76 00             	lea    0x0(%esi),%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105460:	5d                   	pop    %ebp
80105461:	e9 2a ff ff ff       	jmp    80105390 <_ZN3Map8transferEv.part.1>
80105466:	8d 76 00             	lea    0x0(%esi),%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <_ZN3Map11extractProcEP4proc>:

bool Map::extractProc(Proc *p) {
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	56                   	push   %esi
80105474:	53                   	push   %ebx
80105475:	83 ec 30             	sub    $0x30,%esp
	if(!freeNodes)
80105478:	8b 15 00 c6 10 80    	mov    0x8010c600,%edx
bool Map::extractProc(Proc *p) {
8010547e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105481:	8b 75 0c             	mov    0xc(%ebp),%esi
	if(!freeNodes)
80105484:	85 d2                	test   %edx,%edx
80105486:	74 50                	je     801054d8 <_ZN3Map11extractProcEP4proc+0x68>
	MapNode *next, *parent, *left, *right;
};

class Map {
public:
	Map(): root(null) {}
80105488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		return false;

	bool ans = false;
8010548f:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80105493:	eb 13                	jmp    801054a8 <_ZN3Map11extractProcEP4proc+0x38>
80105495:	8d 76 00             	lea    0x0(%esi),%esi
	Map tempMap;
	while(!isEmpty()) {
		Proc *otherP = extractMin();
80105498:	89 1c 24             	mov    %ebx,(%esp)
8010549b:	e8 10 fe ff ff       	call   801052b0 <_ZN3Map10extractMinEv>
		if(otherP != p)
801054a0:	39 f0                	cmp    %esi,%eax
801054a2:	75 1c                	jne    801054c0 <_ZN3Map11extractProcEP4proc+0x50>
			tempMap.put(otherP); //should scucceed.
		else ans = true;
801054a4:	c6 45 e7 01          	movb   $0x1,-0x19(%ebp)
	while(!isEmpty()) {
801054a8:	8b 03                	mov    (%ebx),%eax
801054aa:	85 c0                	test   %eax,%eax
801054ac:	75 ea                	jne    80105498 <_ZN3Map11extractProcEP4proc+0x28>
	}
	root = tempMap.root;
801054ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b1:	89 03                	mov    %eax,(%ebx)
	return ans;
}
801054b3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801054b7:	83 c4 30             	add    $0x30,%esp
801054ba:	5b                   	pop    %ebx
801054bb:	5e                   	pop    %esi
801054bc:	5d                   	pop    %ebp
801054bd:	c3                   	ret    
801054be:	66 90                	xchg   %ax,%ax
			tempMap.put(otherP); //should scucceed.
801054c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801054c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054c7:	89 04 24             	mov    %eax,(%esp)
801054ca:	e8 21 fd ff ff       	call   801051f0 <_ZN3Map3putEP4proc>
801054cf:	eb d7                	jmp    801054a8 <_ZN3Map11extractProcEP4proc+0x38>
801054d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return false;
801054d8:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
}
801054dc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801054e0:	83 c4 30             	add    $0x30,%esp
801054e3:	5b                   	pop    %ebx
801054e4:	5e                   	pop    %esi
801054e5:	5d                   	pop    %ebp
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <extractProcPriorityQueue>:
static boolean extractProcPriorityQueue(Proc *p) {
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	83 ec 18             	sub    $0x18,%esp
	return priorityQ->extractProc(p);
801054f6:	8b 45 08             	mov    0x8(%ebp),%eax
801054f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801054fd:	a1 10 c6 10 80       	mov    0x8010c610,%eax
80105502:	89 04 24             	mov    %eax,(%esp)
80105505:	e8 66 ff ff ff       	call   80105470 <_ZN3Map11extractProcEP4proc>
}
8010550a:	c9                   	leave  
	return priorityQ->extractProc(p);
8010550b:	0f b6 c0             	movzbl %al,%eax
}
8010550e:	c3                   	ret    
8010550f:	90                   	nop

80105510 <__moddi3>:

long long __moddi3(long long number, long long divisor) { //returns number%divisor
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
80105516:	83 ec 2c             	sub    $0x2c,%esp
80105519:	8b 45 08             	mov    0x8(%ebp),%eax
8010551c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010551f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105522:	8b 45 10             	mov    0x10(%ebp),%eax
80105525:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105528:	8b 55 14             	mov    0x14(%ebp),%edx
8010552b:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010552e:	89 d7                	mov    %edx,%edi
	if(divisor == 0)
80105530:	09 c2                	or     %eax,%edx
80105532:	0f 84 9a 00 00 00    	je     801055d2 <__moddi3+0xc2>
		panic((char*)"divide by zero!!!\n");

	bool isNumberNegative = false;
	if(number < 0) {
80105538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	bool isNumberNegative = false;
8010553b:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
	if(number < 0) {
8010553f:	85 c0                	test   %eax,%eax
80105541:	79 0e                	jns    80105551 <__moddi3+0x41>
		number = -number;
80105543:	f7 5d e0             	negl   -0x20(%ebp)
		isNumberNegative = true;
80105546:	c6 45 df 01          	movb   $0x1,-0x21(%ebp)
		number = -number;
8010554a:	83 55 e4 00          	adcl   $0x0,-0x1c(%ebp)
8010554e:	f7 5d e4             	negl   -0x1c(%ebp)
80105551:	8b 55 d8             	mov    -0x28(%ebp),%edx
80105554:	89 f8                	mov    %edi,%eax
80105556:	c1 ff 1f             	sar    $0x1f,%edi
80105559:	31 f8                	xor    %edi,%eax
8010555b:	89 f9                	mov    %edi,%ecx
8010555d:	31 fa                	xor    %edi,%edx
8010555f:	89 c7                	mov    %eax,%edi
80105561:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105564:	89 d6                	mov    %edx,%esi
80105566:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105569:	29 ce                	sub    %ecx,%esi
8010556b:	19 cf                	sbb    %ecx,%edi
	if(divisor < 0)
		divisor = -divisor;

	for(;;) {
		long long divisor2 = divisor;
		while(number >= divisor2) {
8010556d:	39 fa                	cmp    %edi,%edx
8010556f:	7d 1f                	jge    80105590 <__moddi3+0x80>
			if(divisor2 + divisor2 > 0) //exponential decay.
				divisor2 += divisor2;
		}

		if(number < divisor)
			return isNumberNegative ? -number : number;
80105571:	80 7d df 00          	cmpb   $0x0,-0x21(%ebp)
80105575:	74 07                	je     8010557e <__moddi3+0x6e>
80105577:	f7 d8                	neg    %eax
80105579:	83 d2 00             	adc    $0x0,%edx
8010557c:	f7 da                	neg    %edx
	}
}
8010557e:	83 c4 2c             	add    $0x2c,%esp
80105581:	5b                   	pop    %ebx
80105582:	5e                   	pop    %esi
80105583:	5f                   	pop    %edi
80105584:	5d                   	pop    %ebp
80105585:	c3                   	ret    
80105586:	8d 76 00             	lea    0x0(%esi),%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		while(number >= divisor2) {
80105590:	7f 04                	jg     80105596 <__moddi3+0x86>
80105592:	39 f0                	cmp    %esi,%eax
80105594:	72 db                	jb     80105571 <__moddi3+0x61>
80105596:	89 f1                	mov    %esi,%ecx
80105598:	89 fb                	mov    %edi,%ebx
8010559a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			number -= divisor2;
801055a0:	29 c8                	sub    %ecx,%eax
801055a2:	19 da                	sbb    %ebx,%edx
				divisor2 += divisor2;
801055a4:	0f a4 cb 01          	shld   $0x1,%ecx,%ebx
801055a8:	01 c9                	add    %ecx,%ecx
		while(number >= divisor2) {
801055aa:	39 da                	cmp    %ebx,%edx
801055ac:	7f f2                	jg     801055a0 <__moddi3+0x90>
801055ae:	7d 18                	jge    801055c8 <__moddi3+0xb8>
		if(number < divisor)
801055b0:	39 d7                	cmp    %edx,%edi
801055b2:	7c b9                	jl     8010556d <__moddi3+0x5d>
801055b4:	7f bb                	jg     80105571 <__moddi3+0x61>
801055b6:	39 c6                	cmp    %eax,%esi
801055b8:	76 b3                	jbe    8010556d <__moddi3+0x5d>
801055ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055c0:	eb af                	jmp    80105571 <__moddi3+0x61>
801055c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		while(number >= divisor2) {
801055c8:	39 c8                	cmp    %ecx,%eax
801055ca:	73 d4                	jae    801055a0 <__moddi3+0x90>
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055d0:	eb de                	jmp    801055b0 <__moddi3+0xa0>
		panic((char*)"divide by zero!!!\n");
801055d2:	c7 04 24 48 8e 10 80 	movl   $0x80108e48,(%esp)
801055d9:	e8 92 ad ff ff       	call   80100370 <panic>
801055de:	66 90                	xchg   %ax,%ax

801055e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801055e0:	55                   	push   %ebp
  initlock(&lk->lk, "sleep lock");
801055e1:	b8 5b 8e 10 80       	mov    $0x80108e5b,%eax
{
801055e6:	89 e5                	mov    %esp,%ebp
801055e8:	53                   	push   %ebx
801055e9:	83 ec 14             	sub    $0x14,%esp
801055ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801055ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801055f3:	8d 43 04             	lea    0x4(%ebx),%eax
801055f6:	89 04 24             	mov    %eax,(%esp)
801055f9:	e8 12 01 00 00       	call   80105710 <initlock>
  lk->name = name;
801055fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80105601:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80105607:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010560e:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105611:	83 c4 14             	add    $0x14,%esp
80105614:	5b                   	pop    %ebx
80105615:	5d                   	pop    %ebp
80105616:	c3                   	ret    
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105620 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	56                   	push   %esi
80105624:	53                   	push   %ebx
80105625:	83 ec 10             	sub    $0x10,%esp
80105628:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010562b:	8d 73 04             	lea    0x4(%ebx),%esi
8010562e:	89 34 24             	mov    %esi,(%esp)
80105631:	e8 2a 02 00 00       	call   80105860 <acquire>
  while (lk->locked) {
80105636:	8b 13                	mov    (%ebx),%edx
80105638:	85 d2                	test   %edx,%edx
8010563a:	74 16                	je     80105652 <acquiresleep+0x32>
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105640:	89 74 24 04          	mov    %esi,0x4(%esp)
80105644:	89 1c 24             	mov    %ebx,(%esp)
80105647:	e8 94 ee ff ff       	call   801044e0 <sleep>
  while (lk->locked) {
8010564c:	8b 03                	mov    (%ebx),%eax
8010564e:	85 c0                	test   %eax,%eax
80105650:	75 ee                	jne    80105640 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105652:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105658:	e8 63 e4 ff ff       	call   80103ac0 <myproc>
8010565d:	8b 40 10             	mov    0x10(%eax),%eax
80105660:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105663:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	5b                   	pop    %ebx
8010566a:	5e                   	pop    %esi
8010566b:	5d                   	pop    %ebp
  release(&lk->lk);
8010566c:	e9 8f 02 00 00       	jmp    80105900 <release>
80105671:	eb 0d                	jmp    80105680 <releasesleep>
80105673:	90                   	nop
80105674:	90                   	nop
80105675:	90                   	nop
80105676:	90                   	nop
80105677:	90                   	nop
80105678:	90                   	nop
80105679:	90                   	nop
8010567a:	90                   	nop
8010567b:	90                   	nop
8010567c:	90                   	nop
8010567d:	90                   	nop
8010567e:	90                   	nop
8010567f:	90                   	nop

80105680 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 18             	sub    $0x18,%esp
80105686:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80105689:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010568c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  acquire(&lk->lk);
8010568f:	8d 73 04             	lea    0x4(%ebx),%esi
80105692:	89 34 24             	mov    %esi,(%esp)
80105695:	e8 c6 01 00 00       	call   80105860 <acquire>
  lk->locked = 0;
8010569a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801056a0:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801056a7:	89 1c 24             	mov    %ebx,(%esp)
801056aa:	e8 51 f0 ff ff       	call   80104700 <wakeup>
  release(&lk->lk);
}
801056af:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  release(&lk->lk);
801056b2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801056b5:	8b 75 fc             	mov    -0x4(%ebp),%esi
801056b8:	89 ec                	mov    %ebp,%esp
801056ba:	5d                   	pop    %ebp
  release(&lk->lk);
801056bb:	e9 40 02 00 00       	jmp    80105900 <release>

801056c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 28             	sub    $0x28,%esp
801056c6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801056c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801056cc:	89 7d fc             	mov    %edi,-0x4(%ebp)
801056cf:	89 75 f8             	mov    %esi,-0x8(%ebp)
801056d2:	31 f6                	xor    %esi,%esi
  int r;
  
  acquire(&lk->lk);
801056d4:	8d 7b 04             	lea    0x4(%ebx),%edi
801056d7:	89 3c 24             	mov    %edi,(%esp)
801056da:	e8 81 01 00 00       	call   80105860 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801056df:	8b 03                	mov    (%ebx),%eax
801056e1:	85 c0                	test   %eax,%eax
801056e3:	74 11                	je     801056f6 <holdingsleep+0x36>
801056e5:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801056e8:	e8 d3 e3 ff ff       	call   80103ac0 <myproc>
801056ed:	39 58 10             	cmp    %ebx,0x10(%eax)
801056f0:	0f 94 c0             	sete   %al
801056f3:	0f b6 f0             	movzbl %al,%esi
  release(&lk->lk);
801056f6:	89 3c 24             	mov    %edi,(%esp)
801056f9:	e8 02 02 00 00       	call   80105900 <release>
  return r;
}
801056fe:	89 f0                	mov    %esi,%eax
80105700:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105703:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105706:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105709:	89 ec                	mov    %ebp,%esp
8010570b:	5d                   	pop    %ebp
8010570c:	c3                   	ret    
8010570d:	66 90                	xchg   %ax,%ax
8010570f:	90                   	nop

80105710 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105716:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010571f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105722:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105729:	5d                   	pop    %ebp
8010572a:	c3                   	ret    
8010572b:	90                   	nop
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105730:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105731:	31 d2                	xor    %edx,%edx
{
80105733:	89 e5                	mov    %esp,%ebp
  ebp = (uint*)v - 2;
80105735:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105738:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010573b:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010573c:	83 e8 08             	sub    $0x8,%eax
8010573f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105740:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105746:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010574c:	77 12                	ja     80105760 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010574e:	8b 58 04             	mov    0x4(%eax),%ebx
80105751:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105754:	42                   	inc    %edx
80105755:	83 fa 0a             	cmp    $0xa,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105758:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010575a:	75 e4                	jne    80105740 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010575c:	5b                   	pop    %ebx
8010575d:	5d                   	pop    %ebp
8010575e:	c3                   	ret    
8010575f:	90                   	nop
80105760:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105763:	83 c1 28             	add    $0x28,%ecx
80105766:	8d 76 00             	lea    0x0(%esi),%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105776:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105779:	39 c1                	cmp    %eax,%ecx
8010577b:	75 f3                	jne    80105770 <getcallerpcs+0x40>
}
8010577d:	5b                   	pop    %ebx
8010577e:	5d                   	pop    %ebp
8010577f:	c3                   	ret    

80105780 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 04             	sub    $0x4,%esp
80105787:	9c                   	pushf  
80105788:	5b                   	pop    %ebx
  asm volatile("cli");
80105789:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010578a:	e8 91 e2 ff ff       	call   80103a20 <mycpu>
8010578f:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105795:	85 d2                	test   %edx,%edx
80105797:	75 11                	jne    801057aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105799:	e8 82 e2 ff ff       	call   80103a20 <mycpu>
8010579e:	81 e3 00 02 00 00    	and    $0x200,%ebx
801057a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801057aa:	e8 71 e2 ff ff       	call   80103a20 <mycpu>
801057af:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
801057b5:	58                   	pop    %eax
801057b6:	5b                   	pop    %ebx
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057c0 <popcli>:

void
popcli(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801057c6:	9c                   	pushf  
801057c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801057c8:	f6 c4 02             	test   $0x2,%ah
801057cb:	75 35                	jne    80105802 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801057cd:	e8 4e e2 ff ff       	call   80103a20 <mycpu>
801057d2:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
801057d8:	78 34                	js     8010580e <popcli+0x4e>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801057da:	e8 41 e2 ff ff       	call   80103a20 <mycpu>
801057df:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801057e5:	85 d2                	test   %edx,%edx
801057e7:	74 07                	je     801057f0 <popcli+0x30>
    sti();
}
801057e9:	c9                   	leave  
801057ea:	c3                   	ret    
801057eb:	90                   	nop
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801057f0:	e8 2b e2 ff ff       	call   80103a20 <mycpu>
801057f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801057fb:	85 c0                	test   %eax,%eax
801057fd:	74 ea                	je     801057e9 <popcli+0x29>
  asm volatile("sti");
801057ff:	fb                   	sti    
}
80105800:	c9                   	leave  
80105801:	c3                   	ret    
    panic("popcli - interruptible");
80105802:	c7 04 24 66 8e 10 80 	movl   $0x80108e66,(%esp)
80105809:	e8 62 ab ff ff       	call   80100370 <panic>
    panic("popcli");
8010580e:	c7 04 24 7d 8e 10 80 	movl   $0x80108e7d,(%esp)
80105815:	e8 56 ab ff ff       	call   80100370 <panic>
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105820 <holding>:
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	83 ec 08             	sub    $0x8,%esp
80105826:	89 75 fc             	mov    %esi,-0x4(%ebp)
80105829:	8b 75 08             	mov    0x8(%ebp),%esi
8010582c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010582f:	31 db                	xor    %ebx,%ebx
  pushcli();
80105831:	e8 4a ff ff ff       	call   80105780 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105836:	8b 06                	mov    (%esi),%eax
80105838:	85 c0                	test   %eax,%eax
8010583a:	74 10                	je     8010584c <holding+0x2c>
8010583c:	8b 5e 08             	mov    0x8(%esi),%ebx
8010583f:	e8 dc e1 ff ff       	call   80103a20 <mycpu>
80105844:	39 c3                	cmp    %eax,%ebx
80105846:	0f 94 c3             	sete   %bl
80105849:	0f b6 db             	movzbl %bl,%ebx
  popcli();
8010584c:	e8 6f ff ff ff       	call   801057c0 <popcli>
}
80105851:	89 d8                	mov    %ebx,%eax
80105853:	8b 75 fc             	mov    -0x4(%ebp),%esi
80105856:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80105859:	89 ec                	mov    %ebp,%esp
8010585b:	5d                   	pop    %ebp
8010585c:	c3                   	ret    
8010585d:	8d 76 00             	lea    0x0(%esi),%esi

80105860 <acquire>:
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
80105865:	83 ec 10             	sub    $0x10,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105868:	e8 13 ff ff ff       	call   80105780 <pushcli>
  if(holding(lk))
8010586d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105870:	89 1c 24             	mov    %ebx,(%esp)
80105873:	e8 a8 ff ff ff       	call   80105820 <holding>
80105878:	85 c0                	test   %eax,%eax
8010587a:	75 78                	jne    801058f4 <acquire+0x94>
8010587c:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
8010587e:	ba 01 00 00 00       	mov    $0x1,%edx
80105883:	eb 06                	jmp    8010588b <acquire+0x2b>
80105885:	8d 76 00             	lea    0x0(%esi),%esi
80105888:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010588b:	89 d0                	mov    %edx,%eax
8010588d:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105890:	85 c0                	test   %eax,%eax
80105892:	75 f4                	jne    80105888 <acquire+0x28>
  __sync_synchronize();
80105894:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105899:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010589c:	e8 7f e1 ff ff       	call   80103a20 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801058a1:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801058a4:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801058a7:	89 e8                	mov    %ebp,%eax
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801058b0:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801058b6:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801058bc:	77 1a                	ja     801058d8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801058be:	8b 48 04             	mov    0x4(%eax),%ecx
801058c1:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801058c4:	46                   	inc    %esi
801058c5:	83 fe 0a             	cmp    $0xa,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801058c8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801058ca:	75 e4                	jne    801058b0 <acquire+0x50>
}
801058cc:	83 c4 10             	add    $0x10,%esp
801058cf:	5b                   	pop    %ebx
801058d0:	5e                   	pop    %esi
801058d1:	5d                   	pop    %ebp
801058d2:	c3                   	ret    
801058d3:	90                   	nop
801058d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058d8:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801058db:	83 c2 28             	add    $0x28,%edx
801058de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801058e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801058e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801058e9:	39 d0                	cmp    %edx,%eax
801058eb:	75 f3                	jne    801058e0 <acquire+0x80>
}
801058ed:	83 c4 10             	add    $0x10,%esp
801058f0:	5b                   	pop    %ebx
801058f1:	5e                   	pop    %esi
801058f2:	5d                   	pop    %ebp
801058f3:	c3                   	ret    
    panic("acquire");
801058f4:	c7 04 24 84 8e 10 80 	movl   $0x80108e84,(%esp)
801058fb:	e8 70 aa ff ff       	call   80100370 <panic>

80105900 <release>:
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
80105904:	83 ec 14             	sub    $0x14,%esp
80105907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010590a:	89 1c 24             	mov    %ebx,(%esp)
8010590d:	e8 0e ff ff ff       	call   80105820 <holding>
80105912:	85 c0                	test   %eax,%eax
80105914:	74 23                	je     80105939 <release+0x39>
  lk->pcs[0] = 0;
80105916:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010591d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105924:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105929:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010592f:	83 c4 14             	add    $0x14,%esp
80105932:	5b                   	pop    %ebx
80105933:	5d                   	pop    %ebp
  popcli();
80105934:	e9 87 fe ff ff       	jmp    801057c0 <popcli>
    panic("release");
80105939:	c7 04 24 8c 8e 10 80 	movl   $0x80108e8c,(%esp)
80105940:	e8 2b aa ff ff       	call   80100370 <panic>
80105945:	66 90                	xchg   %ax,%ax
80105947:	66 90                	xchg   %ax,%ax
80105949:	66 90                	xchg   %ax,%ax
8010594b:	66 90                	xchg   %ax,%ax
8010594d:	66 90                	xchg   %ax,%ax
8010594f:	90                   	nop

80105950 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 08             	sub    $0x8,%esp
80105956:	8b 55 08             	mov    0x8(%ebp),%edx
80105959:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010595c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010595f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if ((int)dst%4 == 0 && n%4 == 0){
80105962:	f6 c2 03             	test   $0x3,%dl
80105965:	75 05                	jne    8010596c <memset+0x1c>
80105967:	f6 c1 03             	test   $0x3,%cl
8010596a:	74 14                	je     80105980 <memset+0x30>
  asm volatile("cld; rep stosb" :
8010596c:	89 d7                	mov    %edx,%edi
8010596e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105971:	fc                   	cld    
80105972:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80105974:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80105977:	89 d0                	mov    %edx,%eax
80105979:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010597c:	89 ec                	mov    %ebp,%esp
8010597e:	5d                   	pop    %ebp
8010597f:	c3                   	ret    
    c &= 0xFF;
80105980:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105984:	c1 e9 02             	shr    $0x2,%ecx
80105987:	89 f8                	mov    %edi,%eax
80105989:	89 fb                	mov    %edi,%ebx
8010598b:	c1 e0 18             	shl    $0x18,%eax
8010598e:	c1 e3 10             	shl    $0x10,%ebx
80105991:	09 d8                	or     %ebx,%eax
80105993:	09 f8                	or     %edi,%eax
80105995:	c1 e7 08             	shl    $0x8,%edi
80105998:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010599a:	89 d7                	mov    %edx,%edi
8010599c:	fc                   	cld    
8010599d:	f3 ab                	rep stos %eax,%es:(%edi)
}
8010599f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801059a2:	89 d0                	mov    %edx,%eax
801059a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801059a7:	89 ec                	mov    %ebp,%esp
801059a9:	5d                   	pop    %ebp
801059aa:	c3                   	ret    
801059ab:	90                   	nop
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801059b7:	56                   	push   %esi
801059b8:	8b 75 08             	mov    0x8(%ebp),%esi
801059bb:	53                   	push   %ebx
801059bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801059bf:	85 db                	test   %ebx,%ebx
801059c1:	74 27                	je     801059ea <memcmp+0x3a>
    if(*s1 != *s2)
801059c3:	0f b6 16             	movzbl (%esi),%edx
801059c6:	0f b6 0f             	movzbl (%edi),%ecx
801059c9:	38 d1                	cmp    %dl,%cl
801059cb:	75 2b                	jne    801059f8 <memcmp+0x48>
801059cd:	b8 01 00 00 00       	mov    $0x1,%eax
801059d2:	eb 12                	jmp    801059e6 <memcmp+0x36>
801059d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059d8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801059dc:	40                   	inc    %eax
801059dd:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801059e2:	38 ca                	cmp    %cl,%dl
801059e4:	75 12                	jne    801059f8 <memcmp+0x48>
  while(n-- > 0){
801059e6:	39 d8                	cmp    %ebx,%eax
801059e8:	75 ee                	jne    801059d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801059ea:	5b                   	pop    %ebx
  return 0;
801059eb:	31 c0                	xor    %eax,%eax
}
801059ed:	5e                   	pop    %esi
801059ee:	5f                   	pop    %edi
801059ef:	5d                   	pop    %ebp
801059f0:	c3                   	ret    
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059f8:	5b                   	pop    %ebx
      return *s1 - *s2;
801059f9:	0f b6 c2             	movzbl %dl,%eax
801059fc:	29 c8                	sub    %ecx,%eax
}
801059fe:	5e                   	pop    %esi
801059ff:	5f                   	pop    %edi
80105a00:	5d                   	pop    %ebp
80105a01:	c3                   	ret    
80105a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	56                   	push   %esi
80105a14:	8b 45 08             	mov    0x8(%ebp),%eax
80105a17:	53                   	push   %ebx
80105a18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105a1b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105a1e:	39 c3                	cmp    %eax,%ebx
80105a20:	73 26                	jae    80105a48 <memmove+0x38>
80105a22:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105a25:	39 c8                	cmp    %ecx,%eax
80105a27:	73 1f                	jae    80105a48 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105a29:	85 f6                	test   %esi,%esi
80105a2b:	8d 56 ff             	lea    -0x1(%esi),%edx
80105a2e:	74 0d                	je     80105a3d <memmove+0x2d>
      *--d = *--s;
80105a30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105a34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105a37:	4a                   	dec    %edx
80105a38:	83 fa ff             	cmp    $0xffffffff,%edx
80105a3b:	75 f3                	jne    80105a30 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105a3d:	5b                   	pop    %ebx
80105a3e:	5e                   	pop    %esi
80105a3f:	5d                   	pop    %ebp
80105a40:	c3                   	ret    
80105a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105a48:	31 d2                	xor    %edx,%edx
80105a4a:	85 f6                	test   %esi,%esi
80105a4c:	74 ef                	je     80105a3d <memmove+0x2d>
80105a4e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105a50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105a54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105a57:	42                   	inc    %edx
    while(n-- > 0)
80105a58:	39 d6                	cmp    %edx,%esi
80105a5a:	75 f4                	jne    80105a50 <memmove+0x40>
}
80105a5c:	5b                   	pop    %ebx
80105a5d:	5e                   	pop    %esi
80105a5e:	5d                   	pop    %ebp
80105a5f:	c3                   	ret    

80105a60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105a63:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105a64:	eb aa                	jmp    80105a10 <memmove>
80105a66:	8d 76 00             	lea    0x0(%esi),%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a70 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	57                   	push   %edi
80105a74:	8b 7d 10             	mov    0x10(%ebp),%edi
80105a77:	56                   	push   %esi
80105a78:	8b 75 0c             	mov    0xc(%ebp),%esi
80105a7b:	53                   	push   %ebx
80105a7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80105a7f:	85 ff                	test   %edi,%edi
80105a81:	74 2d                	je     80105ab0 <strncmp+0x40>
80105a83:	0f b6 03             	movzbl (%ebx),%eax
80105a86:	0f b6 0e             	movzbl (%esi),%ecx
80105a89:	84 c0                	test   %al,%al
80105a8b:	74 37                	je     80105ac4 <strncmp+0x54>
80105a8d:	38 c1                	cmp    %al,%cl
80105a8f:	75 33                	jne    80105ac4 <strncmp+0x54>
80105a91:	01 f7                	add    %esi,%edi
80105a93:	eb 13                	jmp    80105aa8 <strncmp+0x38>
80105a95:	8d 76 00             	lea    0x0(%esi),%esi
80105a98:	0f b6 03             	movzbl (%ebx),%eax
80105a9b:	84 c0                	test   %al,%al
80105a9d:	74 21                	je     80105ac0 <strncmp+0x50>
80105a9f:	0f b6 0a             	movzbl (%edx),%ecx
80105aa2:	89 d6                	mov    %edx,%esi
80105aa4:	38 c8                	cmp    %cl,%al
80105aa6:	75 1c                	jne    80105ac4 <strncmp+0x54>
    n--, p++, q++;
80105aa8:	8d 56 01             	lea    0x1(%esi),%edx
80105aab:	43                   	inc    %ebx
  while(n > 0 && *p && *p == *q)
80105aac:	39 fa                	cmp    %edi,%edx
80105aae:	75 e8                	jne    80105a98 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105ab0:	5b                   	pop    %ebx
    return 0;
80105ab1:	31 c0                	xor    %eax,%eax
}
80105ab3:	5e                   	pop    %esi
80105ab4:	5f                   	pop    %edi
80105ab5:	5d                   	pop    %ebp
80105ab6:	c3                   	ret    
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ac0:	0f b6 4e 01          	movzbl 0x1(%esi),%ecx
80105ac4:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
80105ac5:	29 c8                	sub    %ecx,%eax
}
80105ac7:	5e                   	pop    %esi
80105ac8:	5f                   	pop    %edi
80105ac9:	5d                   	pop    %ebp
80105aca:	c3                   	ret    
80105acb:	90                   	nop
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad6:	56                   	push   %esi
80105ad7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105ada:	53                   	push   %ebx
80105adb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105ade:	89 c2                	mov    %eax,%edx
80105ae0:	eb 15                	jmp    80105af7 <strncpy+0x27>
80105ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ae8:	46                   	inc    %esi
80105ae9:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
80105aed:	42                   	inc    %edx
80105aee:	84 c9                	test   %cl,%cl
80105af0:	88 4a ff             	mov    %cl,-0x1(%edx)
80105af3:	74 09                	je     80105afe <strncpy+0x2e>
80105af5:	89 d9                	mov    %ebx,%ecx
80105af7:	85 c9                	test   %ecx,%ecx
80105af9:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80105afc:	7f ea                	jg     80105ae8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105afe:	31 c9                	xor    %ecx,%ecx
80105b00:	85 db                	test   %ebx,%ebx
80105b02:	7e 19                	jle    80105b1d <strncpy+0x4d>
80105b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    *s++ = 0;
80105b10:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105b14:	89 de                	mov    %ebx,%esi
80105b16:	41                   	inc    %ecx
80105b17:	29 ce                	sub    %ecx,%esi
  while(n-- > 0)
80105b19:	85 f6                	test   %esi,%esi
80105b1b:	7f f3                	jg     80105b10 <strncpy+0x40>
  return os;
}
80105b1d:	5b                   	pop    %ebx
80105b1e:	5e                   	pop    %esi
80105b1f:	5d                   	pop    %ebp
80105b20:	c3                   	ret    
80105b21:	eb 0d                	jmp    80105b30 <safestrcpy>
80105b23:	90                   	nop
80105b24:	90                   	nop
80105b25:	90                   	nop
80105b26:	90                   	nop
80105b27:	90                   	nop
80105b28:	90                   	nop
80105b29:	90                   	nop
80105b2a:	90                   	nop
80105b2b:	90                   	nop
80105b2c:	90                   	nop
80105b2d:	90                   	nop
80105b2e:	90                   	nop
80105b2f:	90                   	nop

80105b30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105b36:	56                   	push   %esi
80105b37:	8b 45 08             	mov    0x8(%ebp),%eax
80105b3a:	53                   	push   %ebx
80105b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80105b3e:	85 c9                	test   %ecx,%ecx
80105b40:	7e 22                	jle    80105b64 <safestrcpy+0x34>
80105b42:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105b46:	89 c1                	mov    %eax,%ecx
80105b48:	eb 13                	jmp    80105b5d <safestrcpy+0x2d>
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105b50:	42                   	inc    %edx
80105b51:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105b55:	41                   	inc    %ecx
80105b56:	84 db                	test   %bl,%bl
80105b58:	88 59 ff             	mov    %bl,-0x1(%ecx)
80105b5b:	74 04                	je     80105b61 <safestrcpy+0x31>
80105b5d:	39 f2                	cmp    %esi,%edx
80105b5f:	75 ef                	jne    80105b50 <safestrcpy+0x20>
    ;
  *s = 0;
80105b61:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105b64:	5b                   	pop    %ebx
80105b65:	5e                   	pop    %esi
80105b66:	5d                   	pop    %ebp
80105b67:	c3                   	ret    
80105b68:	90                   	nop
80105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b70 <strlen>:

int
strlen(const char *s)
{
80105b70:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105b71:	31 c0                	xor    %eax,%eax
{
80105b73:	89 e5                	mov    %esp,%ebp
80105b75:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105b78:	80 3a 00             	cmpb   $0x0,(%edx)
80105b7b:	74 0a                	je     80105b87 <strlen+0x17>
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi
80105b80:	40                   	inc    %eax
80105b81:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105b85:	75 f9                	jne    80105b80 <strlen+0x10>
    ;
  return n;
}
80105b87:	5d                   	pop    %ebp
80105b88:	c3                   	ret    

80105b89 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105b89:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105b8d:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105b91:	55                   	push   %ebp
  pushl %ebx
80105b92:	53                   	push   %ebx
  pushl %esi
80105b93:	56                   	push   %esi
  pushl %edi
80105b94:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105b95:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105b97:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105b99:	5f                   	pop    %edi
  popl %esi
80105b9a:	5e                   	pop    %esi
  popl %ebx
80105b9b:	5b                   	pop    %ebx
  popl %ebp
80105b9c:	5d                   	pop    %ebp
  ret
80105b9d:	c3                   	ret    
80105b9e:	66 90                	xchg   %ax,%ax

80105ba0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	53                   	push   %ebx
80105ba4:	83 ec 04             	sub    $0x4,%esp
80105ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105baa:	e8 11 df ff ff       	call   80103ac0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105baf:	8b 00                	mov    (%eax),%eax
80105bb1:	39 d8                	cmp    %ebx,%eax
80105bb3:	76 1b                	jbe    80105bd0 <fetchint+0x30>
80105bb5:	8d 53 04             	lea    0x4(%ebx),%edx
80105bb8:	39 d0                	cmp    %edx,%eax
80105bba:	72 14                	jb     80105bd0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bbf:	8b 13                	mov    (%ebx),%edx
80105bc1:	89 10                	mov    %edx,(%eax)
  return 0;
80105bc3:	31 c0                	xor    %eax,%eax
}
80105bc5:	5a                   	pop    %edx
80105bc6:	5b                   	pop    %ebx
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret    
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd5:	eb ee                	jmp    80105bc5 <fetchint+0x25>
80105bd7:	89 f6                	mov    %esi,%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105be0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	53                   	push   %ebx
80105be4:	83 ec 04             	sub    $0x4,%esp
80105be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105bea:	e8 d1 de ff ff       	call   80103ac0 <myproc>

  if(addr >= curproc->sz)
80105bef:	39 18                	cmp    %ebx,(%eax)
80105bf1:	76 27                	jbe    80105c1a <fetchstr+0x3a>
    return -1;
  *pp = (char*)addr;
80105bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105bf6:	89 da                	mov    %ebx,%edx
80105bf8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80105bfa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80105bfc:	39 c3                	cmp    %eax,%ebx
80105bfe:	73 1a                	jae    80105c1a <fetchstr+0x3a>
    if(*s == 0)
80105c00:	80 3b 00             	cmpb   $0x0,(%ebx)
80105c03:	75 10                	jne    80105c15 <fetchstr+0x35>
80105c05:	eb 29                	jmp    80105c30 <fetchstr+0x50>
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c10:	80 3a 00             	cmpb   $0x0,(%edx)
80105c13:	74 13                	je     80105c28 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80105c15:	42                   	inc    %edx
80105c16:	39 d0                	cmp    %edx,%eax
80105c18:	77 f6                	ja     80105c10 <fetchstr+0x30>
    return -1;
80105c1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105c1f:	5a                   	pop    %edx
80105c20:	5b                   	pop    %ebx
80105c21:	5d                   	pop    %ebp
80105c22:	c3                   	ret    
80105c23:	90                   	nop
80105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c28:	89 d0                	mov    %edx,%eax
80105c2a:	5a                   	pop    %edx
80105c2b:	29 d8                	sub    %ebx,%eax
80105c2d:	5b                   	pop    %ebx
80105c2e:	5d                   	pop    %ebp
80105c2f:	c3                   	ret    
    if(*s == 0)
80105c30:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105c32:	eb eb                	jmp    80105c1f <fetchstr+0x3f>
80105c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	56                   	push   %esi
80105c44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c45:	e8 76 de ff ff       	call   80103ac0 <myproc>
80105c4a:	8b 55 08             	mov    0x8(%ebp),%edx
80105c4d:	8b 40 18             	mov    0x18(%eax),%eax
80105c50:	8b 40 44             	mov    0x44(%eax),%eax
80105c53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c56:	e8 65 de ff ff       	call   80103ac0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c5e:	8b 00                	mov    (%eax),%eax
80105c60:	39 c6                	cmp    %eax,%esi
80105c62:	73 1c                	jae    80105c80 <argint+0x40>
80105c64:	8d 53 08             	lea    0x8(%ebx),%edx
80105c67:	39 d0                	cmp    %edx,%eax
80105c69:	72 15                	jb     80105c80 <argint+0x40>
  *ip = *(int*)(addr);
80105c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c6e:	8b 53 04             	mov    0x4(%ebx),%edx
80105c71:	89 10                	mov    %edx,(%eax)
  return 0;
80105c73:	31 c0                	xor    %eax,%eax
}
80105c75:	5b                   	pop    %ebx
80105c76:	5e                   	pop    %esi
80105c77:	5d                   	pop    %ebp
80105c78:	c3                   	ret    
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c85:	eb ee                	jmp    80105c75 <argint+0x35>
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	56                   	push   %esi
80105c94:	53                   	push   %ebx
80105c95:	83 ec 20             	sub    $0x20,%esp
80105c98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105c9b:	e8 20 de ff ff       	call   80103ac0 <myproc>
80105ca0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105ca2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80105cac:	89 04 24             	mov    %eax,(%esp)
80105caf:	e8 8c ff ff ff       	call   80105c40 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105cb4:	c1 e8 1f             	shr    $0x1f,%eax
80105cb7:	84 c0                	test   %al,%al
80105cb9:	75 2d                	jne    80105ce8 <argptr+0x58>
80105cbb:	89 d8                	mov    %ebx,%eax
80105cbd:	c1 e8 1f             	shr    $0x1f,%eax
80105cc0:	84 c0                	test   %al,%al
80105cc2:	75 24                	jne    80105ce8 <argptr+0x58>
80105cc4:	8b 16                	mov    (%esi),%edx
80105cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc9:	39 c2                	cmp    %eax,%edx
80105ccb:	76 1b                	jbe    80105ce8 <argptr+0x58>
80105ccd:	01 c3                	add    %eax,%ebx
80105ccf:	39 da                	cmp    %ebx,%edx
80105cd1:	72 15                	jb     80105ce8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80105cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cd6:	89 02                	mov    %eax,(%edx)
  return 0;
80105cd8:	31 c0                	xor    %eax,%eax
}
80105cda:	83 c4 20             	add    $0x20,%esp
80105cdd:	5b                   	pop    %ebx
80105cde:	5e                   	pop    %esi
80105cdf:	5d                   	pop    %ebp
80105ce0:	c3                   	ret    
80105ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ced:	eb eb                	jmp    80105cda <argptr+0x4a>
80105cef:	90                   	nop

80105cf0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105cf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80105d00:	89 04 24             	mov    %eax,(%esp)
80105d03:	e8 38 ff ff ff       	call   80105c40 <argint>
80105d08:	85 c0                	test   %eax,%eax
80105d0a:	78 14                	js     80105d20 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d16:	89 04 24             	mov    %eax,(%esp)
80105d19:	e8 c2 fe ff ff       	call   80105be0 <fetchstr>
}
80105d1e:	c9                   	leave  
80105d1f:	c3                   	ret    
    return -1;
80105d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <syscall>:
[SYS_detach]  sys_detach,
};

void
syscall(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	53                   	push   %ebx
80105d34:	83 ec 14             	sub    $0x14,%esp
  int num;
  struct proc *curproc = myproc();
80105d37:	e8 84 dd ff ff       	call   80103ac0 <myproc>
80105d3c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105d3e:	8b 40 18             	mov    0x18(%eax),%eax
80105d41:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105d44:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d47:	83 fa 15             	cmp    $0x15,%edx
80105d4a:	77 1c                	ja     80105d68 <syscall+0x38>
80105d4c:	8b 14 85 c0 8e 10 80 	mov    -0x7fef7140(,%eax,4),%edx
80105d53:	85 d2                	test   %edx,%edx
80105d55:	74 11                	je     80105d68 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105d57:	ff d2                	call   *%edx
80105d59:	8b 53 18             	mov    0x18(%ebx),%edx
80105d5c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105d5f:	83 c4 14             	add    $0x14,%esp
80105d62:	5b                   	pop    %ebx
80105d63:	5d                   	pop    %ebp
80105d64:	c3                   	ret    
80105d65:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105d68:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80105d6c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80105d6f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80105d73:	8b 43 10             	mov    0x10(%ebx),%eax
80105d76:	c7 04 24 94 8e 10 80 	movl   $0x80108e94,(%esp)
80105d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d81:	e8 ca a8 ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80105d86:	8b 43 18             	mov    0x18(%ebx),%eax
80105d89:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105d90:	83 c4 14             	add    $0x14,%esp
80105d93:	5b                   	pop    %ebx
80105d94:	5d                   	pop    %ebp
80105d95:	c3                   	ret    
80105d96:	66 90                	xchg   %ax,%ax
80105d98:	66 90                	xchg   %ax,%ax
80105d9a:	66 90                	xchg   %ax,%ax
80105d9c:	66 90                	xchg   %ax,%ax
80105d9e:	66 90                	xchg   %ax,%ax

80105da0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105da0:	55                   	push   %ebp
80105da1:	0f bf d2             	movswl %dx,%edx
80105da4:	89 e5                	mov    %esp,%ebp
80105da6:	83 ec 58             	sub    $0x58,%esp
80105da9:	89 7d fc             	mov    %edi,-0x4(%ebp)
80105dac:	0f bf 7d 08          	movswl 0x8(%ebp),%edi
80105db0:	0f bf c9             	movswl %cx,%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105db3:	89 04 24             	mov    %eax,(%esp)
{
80105db6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80105db9:	89 75 f8             	mov    %esi,-0x8(%ebp)
80105dbc:	89 7d bc             	mov    %edi,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105dbf:	8d 7d da             	lea    -0x26(%ebp),%edi
80105dc2:	89 7c 24 04          	mov    %edi,0x4(%esp)
{
80105dc6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105dc9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105dcc:	e8 cf c2 ff ff       	call   801020a0 <nameiparent>
80105dd1:	85 c0                	test   %eax,%eax
80105dd3:	0f 84 4f 01 00 00    	je     80105f28 <create+0x188>
    return 0;
  ilock(dp);
80105dd9:	89 04 24             	mov    %eax,(%esp)
80105ddc:	89 c3                	mov    %eax,%ebx
80105dde:	e8 1d b9 ff ff       	call   80101700 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105de3:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105de6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dea:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105dee:	89 1c 24             	mov    %ebx,(%esp)
80105df1:	e8 8a be ff ff       	call   80101c80 <dirlookup>
80105df6:	85 c0                	test   %eax,%eax
80105df8:	89 c6                	mov    %eax,%esi
80105dfa:	74 34                	je     80105e30 <create+0x90>
    iunlockput(dp);
80105dfc:	89 1c 24             	mov    %ebx,(%esp)
80105dff:	e8 8c bb ff ff       	call   80101990 <iunlockput>
    ilock(ip);
80105e04:	89 34 24             	mov    %esi,(%esp)
80105e07:	e8 f4 b8 ff ff       	call   80101700 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105e0c:	83 7d c4 02          	cmpl   $0x2,-0x3c(%ebp)
80105e10:	0f 85 9a 00 00 00    	jne    80105eb0 <create+0x110>
80105e16:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105e1b:	0f 85 8f 00 00 00    	jne    80105eb0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105e21:	89 f0                	mov    %esi,%eax
80105e23:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105e26:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105e29:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105e2c:	89 ec                	mov    %ebp,%esp
80105e2e:	5d                   	pop    %ebp
80105e2f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105e30:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105e33:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e37:	8b 03                	mov    (%ebx),%eax
80105e39:	89 04 24             	mov    %eax,(%esp)
80105e3c:	e8 3f b7 ff ff       	call   80101580 <ialloc>
80105e41:	85 c0                	test   %eax,%eax
80105e43:	89 c6                	mov    %eax,%esi
80105e45:	0f 84 f0 00 00 00    	je     80105f3b <create+0x19b>
  ilock(ip);
80105e4b:	89 04 24             	mov    %eax,(%esp)
80105e4e:	e8 ad b8 ff ff       	call   80101700 <ilock>
  ip->major = major;
80105e53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  ip->nlink = 1;
80105e56:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  ip->major = major;
80105e5c:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105e60:	8b 45 bc             	mov    -0x44(%ebp),%eax
80105e63:	66 89 46 54          	mov    %ax,0x54(%esi)
  iupdate(ip);
80105e67:	89 34 24             	mov    %esi,(%esp)
80105e6a:	e8 d1 b7 ff ff       	call   80101640 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105e6f:	83 7d c4 01          	cmpl   $0x1,-0x3c(%ebp)
80105e73:	74 5b                	je     80105ed0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105e75:	8b 46 04             	mov    0x4(%esi),%eax
80105e78:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105e7c:	89 1c 24             	mov    %ebx,(%esp)
80105e7f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e83:	e8 78 c0 ff ff       	call   80101f00 <dirlink>
80105e88:	85 c0                	test   %eax,%eax
80105e8a:	0f 88 9f 00 00 00    	js     80105f2f <create+0x18f>
  iunlockput(dp);
80105e90:	89 1c 24             	mov    %ebx,(%esp)
80105e93:	e8 f8 ba ff ff       	call   80101990 <iunlockput>
}
80105e98:	89 f0                	mov    %esi,%eax
80105e9a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105e9d:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105ea0:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105ea3:	89 ec                	mov    %ebp,%esp
80105ea5:	5d                   	pop    %ebp
80105ea6:	c3                   	ret    
80105ea7:	89 f6                	mov    %esi,%esi
80105ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105eb0:	89 34 24             	mov    %esi,(%esp)
    return 0;
80105eb3:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105eb5:	e8 d6 ba ff ff       	call   80101990 <iunlockput>
}
80105eba:	89 f0                	mov    %esi,%eax
80105ebc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105ebf:	8b 75 f8             	mov    -0x8(%ebp),%esi
80105ec2:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105ec5:	89 ec                	mov    %ebp,%esp
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105ed0:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
80105ed4:	89 1c 24             	mov    %ebx,(%esp)
80105ed7:	e8 64 b7 ff ff       	call   80101640 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105edc:	8b 46 04             	mov    0x4(%esi),%eax
80105edf:	ba 38 8f 10 80       	mov    $0x80108f38,%edx
80105ee4:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ee8:	89 34 24             	mov    %esi,(%esp)
80105eeb:	89 44 24 08          	mov    %eax,0x8(%esp)
80105eef:	e8 0c c0 ff ff       	call   80101f00 <dirlink>
80105ef4:	85 c0                	test   %eax,%eax
80105ef6:	78 20                	js     80105f18 <create+0x178>
80105ef8:	8b 43 04             	mov    0x4(%ebx),%eax
80105efb:	89 34 24             	mov    %esi,(%esp)
80105efe:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f02:	b8 37 8f 10 80       	mov    $0x80108f37,%eax
80105f07:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f0b:	e8 f0 bf ff ff       	call   80101f00 <dirlink>
80105f10:	85 c0                	test   %eax,%eax
80105f12:	0f 89 5d ff ff ff    	jns    80105e75 <create+0xd5>
      panic("create dots");
80105f18:	c7 04 24 2b 8f 10 80 	movl   $0x80108f2b,(%esp)
80105f1f:	e8 4c a4 ff ff       	call   80100370 <panic>
80105f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80105f28:	31 f6                	xor    %esi,%esi
80105f2a:	e9 f2 fe ff ff       	jmp    80105e21 <create+0x81>
    panic("create: dirlink");
80105f2f:	c7 04 24 3a 8f 10 80 	movl   $0x80108f3a,(%esp)
80105f36:	e8 35 a4 ff ff       	call   80100370 <panic>
    panic("create: ialloc");
80105f3b:	c7 04 24 1c 8f 10 80 	movl   $0x80108f1c,(%esp)
80105f42:	e8 29 a4 ff ff       	call   80100370 <panic>
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f50 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	56                   	push   %esi
80105f54:	89 d6                	mov    %edx,%esi
80105f56:	53                   	push   %ebx
80105f57:	89 c3                	mov    %eax,%ebx
80105f59:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80105f5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f6a:	e8 d1 fc ff ff       	call   80105c40 <argint>
80105f6f:	85 c0                	test   %eax,%eax
80105f71:	78 2d                	js     80105fa0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105f73:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105f77:	77 27                	ja     80105fa0 <argfd.constprop.0+0x50>
80105f79:	e8 42 db ff ff       	call   80103ac0 <myproc>
80105f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f81:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105f85:	85 c0                	test   %eax,%eax
80105f87:	74 17                	je     80105fa0 <argfd.constprop.0+0x50>
  if(pfd)
80105f89:	85 db                	test   %ebx,%ebx
80105f8b:	74 02                	je     80105f8f <argfd.constprop.0+0x3f>
    *pfd = fd;
80105f8d:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105f8f:	89 06                	mov    %eax,(%esi)
  return 0;
80105f91:	31 c0                	xor    %eax,%eax
}
80105f93:	83 c4 20             	add    $0x20,%esp
80105f96:	5b                   	pop    %ebx
80105f97:	5e                   	pop    %esi
80105f98:	5d                   	pop    %ebp
80105f99:	c3                   	ret    
80105f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa5:	eb ec                	jmp    80105f93 <argfd.constprop.0+0x43>
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fb0 <sys_dup>:
{
80105fb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105fb1:	31 c0                	xor    %eax,%eax
{
80105fb3:	89 e5                	mov    %esp,%ebp
80105fb5:	56                   	push   %esi
80105fb6:	53                   	push   %ebx
80105fb7:	83 ec 20             	sub    $0x20,%esp
  if(argfd(0, 0, &f) < 0)
80105fba:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105fbd:	e8 8e ff ff ff       	call   80105f50 <argfd.constprop.0>
80105fc2:	85 c0                	test   %eax,%eax
80105fc4:	78 3a                	js     80106000 <sys_dup+0x50>
  if((fd=fdalloc(f)) < 0)
80105fc6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105fc9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105fcb:	e8 f0 da ff ff       	call   80103ac0 <myproc>
80105fd0:	eb 0c                	jmp    80105fde <sys_dup+0x2e>
80105fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105fd8:	43                   	inc    %ebx
80105fd9:	83 fb 10             	cmp    $0x10,%ebx
80105fdc:	74 22                	je     80106000 <sys_dup+0x50>
    if(curproc->ofile[fd] == 0){
80105fde:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105fe2:	85 d2                	test   %edx,%edx
80105fe4:	75 f2                	jne    80105fd8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105fe6:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fed:	89 04 24             	mov    %eax,(%esp)
80105ff0:	e8 cb ad ff ff       	call   80100dc0 <filedup>
}
80105ff5:	83 c4 20             	add    $0x20,%esp
80105ff8:	89 d8                	mov    %ebx,%eax
80105ffa:	5b                   	pop    %ebx
80105ffb:	5e                   	pop    %esi
80105ffc:	5d                   	pop    %ebp
80105ffd:	c3                   	ret    
80105ffe:	66 90                	xchg   %ax,%ax
80106000:	83 c4 20             	add    $0x20,%esp
    return -1;
80106003:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106008:	89 d8                	mov    %ebx,%eax
8010600a:	5b                   	pop    %ebx
8010600b:	5e                   	pop    %esi
8010600c:	5d                   	pop    %ebp
8010600d:	c3                   	ret    
8010600e:	66 90                	xchg   %ax,%ax

80106010 <sys_read>:
{
80106010:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106011:	31 c0                	xor    %eax,%eax
{
80106013:	89 e5                	mov    %esp,%ebp
80106015:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106018:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010601b:	e8 30 ff ff ff       	call   80105f50 <argfd.constprop.0>
80106020:	85 c0                	test   %eax,%eax
80106022:	78 54                	js     80106078 <sys_read+0x68>
80106024:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106027:	89 44 24 04          	mov    %eax,0x4(%esp)
8010602b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106032:	e8 09 fc ff ff       	call   80105c40 <argint>
80106037:	85 c0                	test   %eax,%eax
80106039:	78 3d                	js     80106078 <sys_read+0x68>
8010603b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106045:	89 44 24 08          	mov    %eax,0x8(%esp)
80106049:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010604c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106050:	e8 3b fc ff ff       	call   80105c90 <argptr>
80106055:	85 c0                	test   %eax,%eax
80106057:	78 1f                	js     80106078 <sys_read+0x68>
  return fileread(f, p, n);
80106059:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010605c:	89 44 24 08          	mov    %eax,0x8(%esp)
80106060:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106063:	89 44 24 04          	mov    %eax,0x4(%esp)
80106067:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010606a:	89 04 24             	mov    %eax,(%esp)
8010606d:	e8 ce ae ff ff       	call   80100f40 <fileread>
}
80106072:	c9                   	leave  
80106073:	c3                   	ret    
80106074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010607d:	c9                   	leave  
8010607e:	c3                   	ret    
8010607f:	90                   	nop

80106080 <sys_write>:
{
80106080:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106081:	31 c0                	xor    %eax,%eax
{
80106083:	89 e5                	mov    %esp,%ebp
80106085:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106088:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010608b:	e8 c0 fe ff ff       	call   80105f50 <argfd.constprop.0>
80106090:	85 c0                	test   %eax,%eax
80106092:	78 54                	js     801060e8 <sys_write+0x68>
80106094:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106097:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801060a2:	e8 99 fb ff ff       	call   80105c40 <argint>
801060a7:	85 c0                	test   %eax,%eax
801060a9:	78 3d                	js     801060e8 <sys_write+0x68>
801060ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801060b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801060c0:	e8 cb fb ff ff       	call   80105c90 <argptr>
801060c5:	85 c0                	test   %eax,%eax
801060c7:	78 1f                	js     801060e8 <sys_write+0x68>
  return filewrite(f, p, n);
801060c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060cc:	89 44 24 08          	mov    %eax,0x8(%esp)
801060d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801060da:	89 04 24             	mov    %eax,(%esp)
801060dd:	e8 0e af ff ff       	call   80100ff0 <filewrite>
}
801060e2:	c9                   	leave  
801060e3:	c3                   	ret    
801060e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ed:	c9                   	leave  
801060ee:	c3                   	ret    
801060ef:	90                   	nop

801060f0 <sys_close>:
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
801060f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801060f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060fc:	e8 4f fe ff ff       	call   80105f50 <argfd.constprop.0>
80106101:	85 c0                	test   %eax,%eax
80106103:	78 23                	js     80106128 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80106105:	e8 b6 d9 ff ff       	call   80103ac0 <myproc>
8010610a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010610d:	31 c9                	xor    %ecx,%ecx
8010610f:	89 4c 90 28          	mov    %ecx,0x28(%eax,%edx,4)
  fileclose(f);
80106113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106116:	89 04 24             	mov    %eax,(%esp)
80106119:	e8 f2 ac ff ff       	call   80100e10 <fileclose>
  return 0;
8010611e:	31 c0                	xor    %eax,%eax
}
80106120:	c9                   	leave  
80106121:	c3                   	ret    
80106122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010612d:	c9                   	leave  
8010612e:	c3                   	ret    
8010612f:	90                   	nop

80106130 <sys_fstat>:
{
80106130:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106131:	31 c0                	xor    %eax,%eax
{
80106133:	89 e5                	mov    %esp,%ebp
80106135:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106138:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010613b:	e8 10 fe ff ff       	call   80105f50 <argfd.constprop.0>
80106140:	85 c0                	test   %eax,%eax
80106142:	78 3c                	js     80106180 <sys_fstat+0x50>
80106144:	b8 14 00 00 00       	mov    $0x14,%eax
80106149:	89 44 24 08          	mov    %eax,0x8(%esp)
8010614d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106150:	89 44 24 04          	mov    %eax,0x4(%esp)
80106154:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010615b:	e8 30 fb ff ff       	call   80105c90 <argptr>
80106160:	85 c0                	test   %eax,%eax
80106162:	78 1c                	js     80106180 <sys_fstat+0x50>
  return filestat(f, st);
80106164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106167:	89 44 24 04          	mov    %eax,0x4(%esp)
8010616b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010616e:	89 04 24             	mov    %eax,(%esp)
80106171:	e8 7a ad ff ff       	call   80100ef0 <filestat>
}
80106176:	c9                   	leave  
80106177:	c3                   	ret    
80106178:	90                   	nop
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106185:	c9                   	leave  
80106186:	c3                   	ret    
80106187:	89 f6                	mov    %esi,%esi
80106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106190 <sys_link>:
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	57                   	push   %edi
80106194:	56                   	push   %esi
80106195:	53                   	push   %ebx
80106196:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106199:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010619c:	89 44 24 04          	mov    %eax,0x4(%esp)
801061a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061a7:	e8 44 fb ff ff       	call   80105cf0 <argstr>
801061ac:	85 c0                	test   %eax,%eax
801061ae:	0f 88 e5 00 00 00    	js     80106299 <sys_link+0x109>
801061b4:	8d 45 d0             	lea    -0x30(%ebp),%eax
801061b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801061bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801061c2:	e8 29 fb ff ff       	call   80105cf0 <argstr>
801061c7:	85 c0                	test   %eax,%eax
801061c9:	0f 88 ca 00 00 00    	js     80106299 <sys_link+0x109>
  begin_op();
801061cf:	e8 6c cb ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
801061d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801061d7:	89 04 24             	mov    %eax,(%esp)
801061da:	e8 a1 be ff ff       	call   80102080 <namei>
801061df:	85 c0                	test   %eax,%eax
801061e1:	89 c3                	mov    %eax,%ebx
801061e3:	0f 84 ab 00 00 00    	je     80106294 <sys_link+0x104>
  ilock(ip);
801061e9:	89 04 24             	mov    %eax,(%esp)
801061ec:	e8 0f b5 ff ff       	call   80101700 <ilock>
  if(ip->type == T_DIR){
801061f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801061f6:	0f 84 90 00 00 00    	je     8010628c <sys_link+0xfc>
  ip->nlink++;
801061fc:	66 ff 43 56          	incw   0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106200:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106203:	89 1c 24             	mov    %ebx,(%esp)
80106206:	e8 35 b4 ff ff       	call   80101640 <iupdate>
  iunlock(ip);
8010620b:	89 1c 24             	mov    %ebx,(%esp)
8010620e:	e8 cd b5 ff ff       	call   801017e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106213:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106216:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010621a:	89 04 24             	mov    %eax,(%esp)
8010621d:	e8 7e be ff ff       	call   801020a0 <nameiparent>
80106222:	85 c0                	test   %eax,%eax
80106224:	89 c6                	mov    %eax,%esi
80106226:	74 50                	je     80106278 <sys_link+0xe8>
  ilock(dp);
80106228:	89 04 24             	mov    %eax,(%esp)
8010622b:	e8 d0 b4 ff ff       	call   80101700 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106230:	8b 03                	mov    (%ebx),%eax
80106232:	39 06                	cmp    %eax,(%esi)
80106234:	75 3a                	jne    80106270 <sys_link+0xe0>
80106236:	8b 43 04             	mov    0x4(%ebx),%eax
80106239:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010623d:	89 34 24             	mov    %esi,(%esp)
80106240:	89 44 24 08          	mov    %eax,0x8(%esp)
80106244:	e8 b7 bc ff ff       	call   80101f00 <dirlink>
80106249:	85 c0                	test   %eax,%eax
8010624b:	78 23                	js     80106270 <sys_link+0xe0>
  iunlockput(dp);
8010624d:	89 34 24             	mov    %esi,(%esp)
80106250:	e8 3b b7 ff ff       	call   80101990 <iunlockput>
  iput(ip);
80106255:	89 1c 24             	mov    %ebx,(%esp)
80106258:	e8 d3 b5 ff ff       	call   80101830 <iput>
  end_op();
8010625d:	e8 4e cb ff ff       	call   80102db0 <end_op>
}
80106262:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80106265:	31 c0                	xor    %eax,%eax
}
80106267:	5b                   	pop    %ebx
80106268:	5e                   	pop    %esi
80106269:	5f                   	pop    %edi
8010626a:	5d                   	pop    %ebp
8010626b:	c3                   	ret    
8010626c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp);
80106270:	89 34 24             	mov    %esi,(%esp)
80106273:	e8 18 b7 ff ff       	call   80101990 <iunlockput>
  ilock(ip);
80106278:	89 1c 24             	mov    %ebx,(%esp)
8010627b:	e8 80 b4 ff ff       	call   80101700 <ilock>
  ip->nlink--;
80106280:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80106284:	89 1c 24             	mov    %ebx,(%esp)
80106287:	e8 b4 b3 ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
8010628c:	89 1c 24             	mov    %ebx,(%esp)
8010628f:	e8 fc b6 ff ff       	call   80101990 <iunlockput>
  end_op();
80106294:	e8 17 cb ff ff       	call   80102db0 <end_op>
}
80106299:	83 c4 3c             	add    $0x3c,%esp
  return -1;
8010629c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062a1:	5b                   	pop    %ebx
801062a2:	5e                   	pop    %esi
801062a3:	5f                   	pop    %edi
801062a4:	5d                   	pop    %ebp
801062a5:	c3                   	ret    
801062a6:	8d 76 00             	lea    0x0(%esi),%esi
801062a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062b0 <sys_unlink>:
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	57                   	push   %edi
801062b4:	56                   	push   %esi
801062b5:	53                   	push   %ebx
801062b6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
801062b9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801062bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801062c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062c7:	e8 24 fa ff ff       	call   80105cf0 <argstr>
801062cc:	85 c0                	test   %eax,%eax
801062ce:	0f 88 68 01 00 00    	js     8010643c <sys_unlink+0x18c>
  begin_op();
801062d4:	e8 67 ca ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801062d9:	8b 45 c0             	mov    -0x40(%ebp),%eax
801062dc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801062df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801062e3:	89 04 24             	mov    %eax,(%esp)
801062e6:	e8 b5 bd ff ff       	call   801020a0 <nameiparent>
801062eb:	85 c0                	test   %eax,%eax
801062ed:	89 c6                	mov    %eax,%esi
801062ef:	0f 84 42 01 00 00    	je     80106437 <sys_unlink+0x187>
  ilock(dp);
801062f5:	89 04 24             	mov    %eax,(%esp)
801062f8:	e8 03 b4 ff ff       	call   80101700 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801062fd:	b8 38 8f 10 80       	mov    $0x80108f38,%eax
80106302:	89 44 24 04          	mov    %eax,0x4(%esp)
80106306:	89 1c 24             	mov    %ebx,(%esp)
80106309:	e8 42 b9 ff ff       	call   80101c50 <namecmp>
8010630e:	85 c0                	test   %eax,%eax
80106310:	0f 84 19 01 00 00    	je     8010642f <sys_unlink+0x17f>
80106316:	b8 37 8f 10 80       	mov    $0x80108f37,%eax
8010631b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010631f:	89 1c 24             	mov    %ebx,(%esp)
80106322:	e8 29 b9 ff ff       	call   80101c50 <namecmp>
80106327:	85 c0                	test   %eax,%eax
80106329:	0f 84 00 01 00 00    	je     8010642f <sys_unlink+0x17f>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010632f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106332:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106336:	89 44 24 08          	mov    %eax,0x8(%esp)
8010633a:	89 34 24             	mov    %esi,(%esp)
8010633d:	e8 3e b9 ff ff       	call   80101c80 <dirlookup>
80106342:	85 c0                	test   %eax,%eax
80106344:	89 c3                	mov    %eax,%ebx
80106346:	0f 84 e3 00 00 00    	je     8010642f <sys_unlink+0x17f>
  ilock(ip);
8010634c:	89 04 24             	mov    %eax,(%esp)
8010634f:	e8 ac b3 ff ff       	call   80101700 <ilock>
  if(ip->nlink < 1)
80106354:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106359:	0f 8e 0e 01 00 00    	jle    8010646d <sys_unlink+0x1bd>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010635f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106364:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106367:	74 77                	je     801063e0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
80106369:	31 d2                	xor    %edx,%edx
8010636b:	b8 10 00 00 00       	mov    $0x10,%eax
80106370:	89 54 24 04          	mov    %edx,0x4(%esp)
80106374:	89 44 24 08          	mov    %eax,0x8(%esp)
80106378:	89 3c 24             	mov    %edi,(%esp)
8010637b:	e8 d0 f5 ff ff       	call   80105950 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106380:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80106383:	b9 10 00 00 00       	mov    $0x10,%ecx
80106388:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010638c:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106390:	89 34 24             	mov    %esi,(%esp)
80106393:	89 44 24 08          	mov    %eax,0x8(%esp)
80106397:	e8 64 b7 ff ff       	call   80101b00 <writei>
8010639c:	83 f8 10             	cmp    $0x10,%eax
8010639f:	0f 85 d4 00 00 00    	jne    80106479 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801063a5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801063aa:	0f 84 a0 00 00 00    	je     80106450 <sys_unlink+0x1a0>
  iunlockput(dp);
801063b0:	89 34 24             	mov    %esi,(%esp)
801063b3:	e8 d8 b5 ff ff       	call   80101990 <iunlockput>
  ip->nlink--;
801063b8:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801063bc:	89 1c 24             	mov    %ebx,(%esp)
801063bf:	e8 7c b2 ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
801063c4:	89 1c 24             	mov    %ebx,(%esp)
801063c7:	e8 c4 b5 ff ff       	call   80101990 <iunlockput>
  end_op();
801063cc:	e8 df c9 ff ff       	call   80102db0 <end_op>
}
801063d1:	83 c4 5c             	add    $0x5c,%esp
  return 0;
801063d4:	31 c0                	xor    %eax,%eax
}
801063d6:	5b                   	pop    %ebx
801063d7:	5e                   	pop    %esi
801063d8:	5f                   	pop    %edi
801063d9:	5d                   	pop    %ebp
801063da:	c3                   	ret    
801063db:	90                   	nop
801063dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801063e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801063e4:	76 83                	jbe    80106369 <sys_unlink+0xb9>
801063e6:	ba 20 00 00 00       	mov    $0x20,%edx
801063eb:	eb 0f                	jmp    801063fc <sys_unlink+0x14c>
801063ed:	8d 76 00             	lea    0x0(%esi),%esi
801063f0:	83 c2 10             	add    $0x10,%edx
801063f3:	3b 53 58             	cmp    0x58(%ebx),%edx
801063f6:	0f 83 6d ff ff ff    	jae    80106369 <sys_unlink+0xb9>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063fc:	b8 10 00 00 00       	mov    $0x10,%eax
80106401:	89 54 24 08          	mov    %edx,0x8(%esp)
80106405:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106409:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010640d:	89 1c 24             	mov    %ebx,(%esp)
80106410:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80106413:	e8 c8 b5 ff ff       	call   801019e0 <readi>
80106418:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010641b:	83 f8 10             	cmp    $0x10,%eax
8010641e:	75 41                	jne    80106461 <sys_unlink+0x1b1>
    if(de.inum != 0)
80106420:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106425:	74 c9                	je     801063f0 <sys_unlink+0x140>
    iunlockput(ip);
80106427:	89 1c 24             	mov    %ebx,(%esp)
8010642a:	e8 61 b5 ff ff       	call   80101990 <iunlockput>
  iunlockput(dp);
8010642f:	89 34 24             	mov    %esi,(%esp)
80106432:	e8 59 b5 ff ff       	call   80101990 <iunlockput>
  end_op();
80106437:	e8 74 c9 ff ff       	call   80102db0 <end_op>
}
8010643c:	83 c4 5c             	add    $0x5c,%esp
  return -1;
8010643f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106444:	5b                   	pop    %ebx
80106445:	5e                   	pop    %esi
80106446:	5f                   	pop    %edi
80106447:	5d                   	pop    %ebp
80106448:	c3                   	ret    
80106449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80106450:	66 ff 4e 56          	decw   0x56(%esi)
    iupdate(dp);
80106454:	89 34 24             	mov    %esi,(%esp)
80106457:	e8 e4 b1 ff ff       	call   80101640 <iupdate>
8010645c:	e9 4f ff ff ff       	jmp    801063b0 <sys_unlink+0x100>
      panic("isdirempty: readi");
80106461:	c7 04 24 5c 8f 10 80 	movl   $0x80108f5c,(%esp)
80106468:	e8 03 9f ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
8010646d:	c7 04 24 4a 8f 10 80 	movl   $0x80108f4a,(%esp)
80106474:	e8 f7 9e ff ff       	call   80100370 <panic>
    panic("unlink: writei");
80106479:	c7 04 24 6e 8f 10 80 	movl   $0x80108f6e,(%esp)
80106480:	e8 eb 9e ff ff       	call   80100370 <panic>
80106485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106490 <sys_open>:

int
sys_open(void)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	57                   	push   %edi
80106494:	56                   	push   %esi
80106495:	53                   	push   %ebx
80106496:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106499:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010649c:	89 44 24 04          	mov    %eax,0x4(%esp)
801064a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064a7:	e8 44 f8 ff ff       	call   80105cf0 <argstr>
801064ac:	85 c0                	test   %eax,%eax
801064ae:	0f 88 e9 00 00 00    	js     8010659d <sys_open+0x10d>
801064b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801064bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801064c2:	e8 79 f7 ff ff       	call   80105c40 <argint>
801064c7:	85 c0                	test   %eax,%eax
801064c9:	0f 88 ce 00 00 00    	js     8010659d <sys_open+0x10d>
    return -1;

  begin_op();
801064cf:	e8 6c c8 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
801064d4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801064d8:	0f 85 9a 00 00 00    	jne    80106578 <sys_open+0xe8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801064de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064e1:	89 04 24             	mov    %eax,(%esp)
801064e4:	e8 97 bb ff ff       	call   80102080 <namei>
801064e9:	85 c0                	test   %eax,%eax
801064eb:	89 c6                	mov    %eax,%esi
801064ed:	0f 84 a5 00 00 00    	je     80106598 <sys_open+0x108>
      end_op();
      return -1;
    }
    ilock(ip);
801064f3:	89 04 24             	mov    %eax,(%esp)
801064f6:	e8 05 b2 ff ff       	call   80101700 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801064fb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106500:	0f 84 a2 00 00 00    	je     801065a8 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106506:	e8 45 a8 ff ff       	call   80100d50 <filealloc>
8010650b:	85 c0                	test   %eax,%eax
8010650d:	89 c7                	mov    %eax,%edi
8010650f:	0f 84 9e 00 00 00    	je     801065b3 <sys_open+0x123>
  struct proc *curproc = myproc();
80106515:	e8 a6 d5 ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010651a:	31 db                	xor    %ebx,%ebx
8010651c:	eb 0c                	jmp    8010652a <sys_open+0x9a>
8010651e:	66 90                	xchg   %ax,%ax
80106520:	43                   	inc    %ebx
80106521:	83 fb 10             	cmp    $0x10,%ebx
80106524:	0f 84 96 00 00 00    	je     801065c0 <sys_open+0x130>
    if(curproc->ofile[fd] == 0){
8010652a:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010652e:	85 d2                	test   %edx,%edx
80106530:	75 ee                	jne    80106520 <sys_open+0x90>
      curproc->ofile[fd] = f;
80106532:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106536:	89 34 24             	mov    %esi,(%esp)
80106539:	e8 a2 b2 ff ff       	call   801017e0 <iunlock>
  end_op();
8010653e:	e8 6d c8 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
80106543:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106549:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->ip = ip;
8010654c:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
8010654f:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106556:	89 d0                	mov    %edx,%eax
80106558:	f7 d0                	not    %eax
8010655a:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010655d:	f6 c2 03             	test   $0x3,%dl
  f->readable = !(omode & O_WRONLY);
80106560:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106563:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106567:	83 c4 2c             	add    $0x2c,%esp
8010656a:	89 d8                	mov    %ebx,%eax
8010656c:	5b                   	pop    %ebx
8010656d:	5e                   	pop    %esi
8010656e:	5f                   	pop    %edi
8010656f:	5d                   	pop    %ebp
80106570:	c3                   	ret    
80106571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106578:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010657b:	31 c9                	xor    %ecx,%ecx
8010657d:	ba 02 00 00 00       	mov    $0x2,%edx
80106582:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106589:	e8 12 f8 ff ff       	call   80105da0 <create>
    if(ip == 0){
8010658e:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106590:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106592:	0f 85 6e ff ff ff    	jne    80106506 <sys_open+0x76>
    end_op();
80106598:	e8 13 c8 ff ff       	call   80102db0 <end_op>
    return -1;
8010659d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065a2:	eb c3                	jmp    80106567 <sys_open+0xd7>
801065a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801065a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801065ab:	85 c9                	test   %ecx,%ecx
801065ad:	0f 84 53 ff ff ff    	je     80106506 <sys_open+0x76>
    iunlockput(ip);
801065b3:	89 34 24             	mov    %esi,(%esp)
801065b6:	e8 d5 b3 ff ff       	call   80101990 <iunlockput>
801065bb:	eb db                	jmp    80106598 <sys_open+0x108>
801065bd:	8d 76 00             	lea    0x0(%esi),%esi
      fileclose(f);
801065c0:	89 3c 24             	mov    %edi,(%esp)
801065c3:	e8 48 a8 ff ff       	call   80100e10 <fileclose>
801065c8:	eb e9                	jmp    801065b3 <sys_open+0x123>
801065ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065d6:	e8 65 c7 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065de:	89 44 24 04          	mov    %eax,0x4(%esp)
801065e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065e9:	e8 02 f7 ff ff       	call   80105cf0 <argstr>
801065ee:	85 c0                	test   %eax,%eax
801065f0:	78 2e                	js     80106620 <sys_mkdir+0x50>
801065f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f5:	31 c9                	xor    %ecx,%ecx
801065f7:	ba 01 00 00 00       	mov    $0x1,%edx
801065fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106603:	e8 98 f7 ff ff       	call   80105da0 <create>
80106608:	85 c0                	test   %eax,%eax
8010660a:	74 14                	je     80106620 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010660c:	89 04 24             	mov    %eax,(%esp)
8010660f:	e8 7c b3 ff ff       	call   80101990 <iunlockput>
  end_op();
80106614:	e8 97 c7 ff ff       	call   80102db0 <end_op>
  return 0;
80106619:	31 c0                	xor    %eax,%eax
}
8010661b:	c9                   	leave  
8010661c:	c3                   	ret    
8010661d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80106620:	e8 8b c7 ff ff       	call   80102db0 <end_op>
    return -1;
80106625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010662a:	c9                   	leave  
8010662b:	c3                   	ret    
8010662c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106630 <sys_mknod>:

int
sys_mknod(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106636:	e8 05 c7 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010663b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010663e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106649:	e8 a2 f6 ff ff       	call   80105cf0 <argstr>
8010664e:	85 c0                	test   %eax,%eax
80106650:	78 5e                	js     801066b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106652:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106655:	89 44 24 04          	mov    %eax,0x4(%esp)
80106659:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106660:	e8 db f5 ff ff       	call   80105c40 <argint>
  if((argstr(0, &path)) < 0 ||
80106665:	85 c0                	test   %eax,%eax
80106667:	78 47                	js     801066b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106669:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010666c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106670:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106677:	e8 c4 f5 ff ff       	call   80105c40 <argint>
     argint(1, &major) < 0 ||
8010667c:	85 c0                	test   %eax,%eax
8010667e:	78 30                	js     801066b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106680:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80106684:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80106689:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010668d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80106690:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106693:	e8 08 f7 ff ff       	call   80105da0 <create>
80106698:	85 c0                	test   %eax,%eax
8010669a:	74 14                	je     801066b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010669c:	89 04 24             	mov    %eax,(%esp)
8010669f:	e8 ec b2 ff ff       	call   80101990 <iunlockput>
  end_op();
801066a4:	e8 07 c7 ff ff       	call   80102db0 <end_op>
  return 0;
801066a9:	31 c0                	xor    %eax,%eax
}
801066ab:	c9                   	leave  
801066ac:	c3                   	ret    
801066ad:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801066b0:	e8 fb c6 ff ff       	call   80102db0 <end_op>
    return -1;
801066b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066ba:	c9                   	leave  
801066bb:	c3                   	ret    
801066bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066c0 <sys_chdir>:

int
sys_chdir(void)
{
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	56                   	push   %esi
801066c4:	53                   	push   %ebx
801066c5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801066c8:	e8 f3 d3 ff ff       	call   80103ac0 <myproc>
801066cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801066cf:	e8 6c c6 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801066d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801066db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066e2:	e8 09 f6 ff ff       	call   80105cf0 <argstr>
801066e7:	85 c0                	test   %eax,%eax
801066e9:	78 4a                	js     80106735 <sys_chdir+0x75>
801066eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ee:	89 04 24             	mov    %eax,(%esp)
801066f1:	e8 8a b9 ff ff       	call   80102080 <namei>
801066f6:	85 c0                	test   %eax,%eax
801066f8:	89 c3                	mov    %eax,%ebx
801066fa:	74 39                	je     80106735 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801066fc:	89 04 24             	mov    %eax,(%esp)
801066ff:	e8 fc af ff ff       	call   80101700 <ilock>
  if(ip->type != T_DIR){
80106704:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80106709:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010670c:	75 22                	jne    80106730 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010670e:	e8 cd b0 ff ff       	call   801017e0 <iunlock>
  iput(curproc->cwd);
80106713:	8b 46 68             	mov    0x68(%esi),%eax
80106716:	89 04 24             	mov    %eax,(%esp)
80106719:	e8 12 b1 ff ff       	call   80101830 <iput>
  end_op();
8010671e:	e8 8d c6 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
  return 0;
80106723:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80106725:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80106728:	83 c4 20             	add    $0x20,%esp
8010672b:	5b                   	pop    %ebx
8010672c:	5e                   	pop    %esi
8010672d:	5d                   	pop    %ebp
8010672e:	c3                   	ret    
8010672f:	90                   	nop
    iunlockput(ip);
80106730:	e8 5b b2 ff ff       	call   80101990 <iunlockput>
    end_op();
80106735:	e8 76 c6 ff ff       	call   80102db0 <end_op>
    return -1;
8010673a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673f:	eb e7                	jmp    80106728 <sys_chdir+0x68>
80106741:	eb 0d                	jmp    80106750 <sys_exec>
80106743:	90                   	nop
80106744:	90                   	nop
80106745:	90                   	nop
80106746:	90                   	nop
80106747:	90                   	nop
80106748:	90                   	nop
80106749:	90                   	nop
8010674a:	90                   	nop
8010674b:	90                   	nop
8010674c:	90                   	nop
8010674d:	90                   	nop
8010674e:	90                   	nop
8010674f:	90                   	nop

80106750 <sys_exec>:

int
sys_exec(void)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010675c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80106762:	89 44 24 04          	mov    %eax,0x4(%esp)
80106766:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010676d:	e8 7e f5 ff ff       	call   80105cf0 <argstr>
80106772:	85 c0                	test   %eax,%eax
80106774:	0f 88 8e 00 00 00    	js     80106808 <sys_exec+0xb8>
8010677a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106780:	89 44 24 04          	mov    %eax,0x4(%esp)
80106784:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010678b:	e8 b0 f4 ff ff       	call   80105c40 <argint>
80106790:	85 c0                	test   %eax,%eax
80106792:	78 74                	js     80106808 <sys_exec+0xb8>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106794:	ba 80 00 00 00       	mov    $0x80,%edx
80106799:	31 c9                	xor    %ecx,%ecx
8010679b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801067a1:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801067a3:	89 54 24 08          	mov    %edx,0x8(%esp)
801067a7:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801067ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801067b1:	89 04 24             	mov    %eax,(%esp)
801067b4:	e8 97 f1 ff ff       	call   80105950 <memset>
801067b9:	eb 2e                	jmp    801067e9 <sys_exec+0x99>
801067bb:	90                   	nop
801067bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801067c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801067c6:	85 c0                	test   %eax,%eax
801067c8:	74 56                	je     80106820 <sys_exec+0xd0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801067ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801067d0:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801067d3:	89 54 24 04          	mov    %edx,0x4(%esp)
801067d7:	89 04 24             	mov    %eax,(%esp)
801067da:	e8 01 f4 ff ff       	call   80105be0 <fetchstr>
801067df:	85 c0                	test   %eax,%eax
801067e1:	78 25                	js     80106808 <sys_exec+0xb8>
  for(i=0;; i++){
801067e3:	43                   	inc    %ebx
    if(i >= NELEM(argv))
801067e4:	83 fb 20             	cmp    $0x20,%ebx
801067e7:	74 1f                	je     80106808 <sys_exec+0xb8>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801067e9:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801067ef:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801067f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801067fa:	01 f0                	add    %esi,%eax
801067fc:	89 04 24             	mov    %eax,(%esp)
801067ff:	e8 9c f3 ff ff       	call   80105ba0 <fetchint>
80106804:	85 c0                	test   %eax,%eax
80106806:	79 b8                	jns    801067c0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
80106808:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
8010680e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106813:	5b                   	pop    %ebx
80106814:	5e                   	pop    %esi
80106815:	5f                   	pop    %edi
80106816:	5d                   	pop    %ebp
80106817:	c3                   	ret    
80106818:	90                   	nop
80106819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106820:	31 c0                	xor    %eax,%eax
80106822:	89 84 9d 68 ff ff ff 	mov    %eax,-0x98(%ebp,%ebx,4)
  return exec(path, argv);
80106829:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010682f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106833:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80106839:	89 04 24             	mov    %eax,(%esp)
8010683c:	e8 8f a1 ff ff       	call   801009d0 <exec>
}
80106841:	81 c4 ac 00 00 00    	add    $0xac,%esp
80106847:	5b                   	pop    %ebx
80106848:	5e                   	pop    %esi
80106849:	5f                   	pop    %edi
8010684a:	5d                   	pop    %ebp
8010684b:	c3                   	ret    
8010684c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106850 <sys_pipe>:

int
sys_pipe(void)
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	57                   	push   %edi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106854:	bf 08 00 00 00       	mov    $0x8,%edi
{
80106859:	56                   	push   %esi
8010685a:	53                   	push   %ebx
8010685b:	83 ec 2c             	sub    $0x2c,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010685e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106861:	89 7c 24 08          	mov    %edi,0x8(%esp)
80106865:	89 44 24 04          	mov    %eax,0x4(%esp)
80106869:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106870:	e8 1b f4 ff ff       	call   80105c90 <argptr>
80106875:	85 c0                	test   %eax,%eax
80106877:	0f 88 a9 00 00 00    	js     80106926 <sys_pipe+0xd6>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010687d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106880:	89 44 24 04          	mov    %eax,0x4(%esp)
80106884:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106887:	89 04 24             	mov    %eax,(%esp)
8010688a:	e8 e1 cb ff ff       	call   80103470 <pipealloc>
8010688f:	85 c0                	test   %eax,%eax
80106891:	0f 88 8f 00 00 00    	js     80106926 <sys_pipe+0xd6>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106897:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010689a:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010689c:	e8 1f d2 ff ff       	call   80103ac0 <myproc>
801068a1:	eb 0b                	jmp    801068ae <sys_pipe+0x5e>
801068a3:	90                   	nop
801068a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801068a8:	43                   	inc    %ebx
801068a9:	83 fb 10             	cmp    $0x10,%ebx
801068ac:	74 62                	je     80106910 <sys_pipe+0xc0>
    if(curproc->ofile[fd] == 0){
801068ae:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801068b2:	85 f6                	test   %esi,%esi
801068b4:	75 f2                	jne    801068a8 <sys_pipe+0x58>
      curproc->ofile[fd] = f;
801068b6:	8d 73 08             	lea    0x8(%ebx),%esi
801068b9:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801068c0:	e8 fb d1 ff ff       	call   80103ac0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801068c5:	31 d2                	xor    %edx,%edx
801068c7:	eb 0d                	jmp    801068d6 <sys_pipe+0x86>
801068c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068d0:	42                   	inc    %edx
801068d1:	83 fa 10             	cmp    $0x10,%edx
801068d4:	74 2a                	je     80106900 <sys_pipe+0xb0>
    if(curproc->ofile[fd] == 0){
801068d6:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801068da:	85 c9                	test   %ecx,%ecx
801068dc:	75 f2                	jne    801068d0 <sys_pipe+0x80>
      curproc->ofile[fd] = f;
801068de:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801068e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801068e5:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801068e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801068ea:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801068ed:	31 c0                	xor    %eax,%eax
}
801068ef:	83 c4 2c             	add    $0x2c,%esp
801068f2:	5b                   	pop    %ebx
801068f3:	5e                   	pop    %esi
801068f4:	5f                   	pop    %edi
801068f5:	5d                   	pop    %ebp
801068f6:	c3                   	ret    
801068f7:	89 f6                	mov    %esi,%esi
801068f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      myproc()->ofile[fd0] = 0;
80106900:	e8 bb d1 ff ff       	call   80103ac0 <myproc>
80106905:	31 d2                	xor    %edx,%edx
80106907:	89 54 b0 08          	mov    %edx,0x8(%eax,%esi,4)
8010690b:	90                   	nop
8010690c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(rf);
80106910:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106913:	89 04 24             	mov    %eax,(%esp)
80106916:	e8 f5 a4 ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
8010691b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010691e:	89 04 24             	mov    %eax,(%esp)
80106921:	e8 ea a4 ff ff       	call   80100e10 <fileclose>
    return -1;
80106926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010692b:	eb c2                	jmp    801068ef <sys_pipe+0x9f>
8010692d:	66 90                	xchg   %ax,%ax
8010692f:	90                   	nop

80106930 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106933:	5d                   	pop    %ebp
  return fork();
80106934:	e9 a7 d3 ff ff       	jmp    80103ce0 <fork>
80106939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106940 <sys_exit>:

int
sys_exit(void)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	83 ec 28             	sub    $0x28,%esp
  int status;
  if(argint(0, &status) < 0)
80106946:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106949:	89 44 24 04          	mov    %eax,0x4(%esp)
8010694d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106954:	e8 e7 f2 ff ff       	call   80105c40 <argint>
80106959:	85 c0                	test   %eax,%eax
8010695b:	78 13                	js     80106970 <sys_exit+0x30>
    return -1;
  exit(status);
8010695d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106960:	89 04 24             	mov    %eax,(%esp)
80106963:	e8 58 d9 ff ff       	call   801042c0 <exit>
  return 0;
80106968:	31 c0                	xor    %eax,%eax
}
8010696a:	c9                   	leave  
8010696b:	c3                   	ret    
8010696c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106975:	c9                   	leave  
80106976:	c3                   	ret    
80106977:	89 f6                	mov    %esi,%esi
80106979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106980 <sys_wait>:

int
sys_wait(void)
{
80106980:	55                   	push   %ebp
  int * status;
  if(argptr(0, (char**)&status,4) < 0)
80106981:	b8 04 00 00 00       	mov    $0x4,%eax
{
80106986:	89 e5                	mov    %esp,%ebp
80106988:	83 ec 28             	sub    $0x28,%esp
  if(argptr(0, (char**)&status,4) < 0)
8010698b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010698f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106992:	89 44 24 04          	mov    %eax,0x4(%esp)
80106996:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010699d:	e8 ee f2 ff ff       	call   80105c90 <argptr>
801069a2:	85 c0                	test   %eax,%eax
801069a4:	78 12                	js     801069b8 <sys_wait+0x38>
    return -1;
  return wait(status);
801069a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069a9:	89 04 24             	mov    %eax,(%esp)
801069ac:	e8 3f dc ff ff       	call   801045f0 <wait>

}
801069b1:	c9                   	leave  
801069b2:	c3                   	ret    
801069b3:	90                   	nop
801069b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801069b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069bd:	c9                   	leave  
801069be:	c3                   	ret    
801069bf:	90                   	nop

801069c0 <sys_detach>:

int
sys_detach(void)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	83 ec 28             	sub    $0x28,%esp
  int pid;
  if(argint(0, &pid) < 0)
801069c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801069cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069d4:	e8 67 f2 ff ff       	call   80105c40 <argint>
801069d9:	85 c0                	test   %eax,%eax
801069db:	78 13                	js     801069f0 <sys_detach+0x30>
    return -1;
  return detach(pid);
801069dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069e0:	89 04 24             	mov    %eax,(%esp)
801069e3:	e8 68 d4 ff ff       	call   80103e50 <detach>
}
801069e8:	c9                   	leave  
801069e9:	c3                   	ret    
801069ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801069f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069f5:	c9                   	leave  
801069f6:	c3                   	ret    
801069f7:	89 f6                	mov    %esi,%esi
801069f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a00 <sys_policy>:

int
sys_policy(void)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	83 ec 28             	sub    $0x28,%esp
  int policyValue;

  if(argint(0, &policyValue) < 0)
80106a06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a09:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a14:	e8 27 f2 ff ff       	call   80105c40 <argint>
80106a19:	85 c0                	test   %eax,%eax
80106a1b:	78 13                	js     80106a30 <sys_policy+0x30>
    return -1;
  policy(policyValue);
80106a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a20:	89 04 24             	mov    %eax,(%esp)
80106a23:	e8 a8 d4 ff ff       	call   80103ed0 <policy>
  return 0;
80106a28:	31 c0                	xor    %eax,%eax
}
80106a2a:	c9                   	leave  
80106a2b:	c3                   	ret    
80106a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a35:	c9                   	leave  
80106a36:	c3                   	ret    
80106a37:	89 f6                	mov    %esi,%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a40 <sys_priority>:

int
sys_priority(void)
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	83 ec 28             	sub    $0x28,%esp
  int priorityValue;

  if(argint(0, &priorityValue) < 0)
80106a46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a49:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a54:	e8 e7 f1 ff ff       	call   80105c40 <argint>
80106a59:	85 c0                	test   %eax,%eax
80106a5b:	78 13                	js     80106a70 <sys_priority+0x30>
    return -1;
  priority(priorityValue);
80106a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a60:	89 04 24             	mov    %eax,(%esp)
80106a63:	e8 38 d5 ff ff       	call   80103fa0 <priority>
  return 0;
80106a68:	31 c0                	xor    %eax,%eax
}
80106a6a:	c9                   	leave  
80106a6b:	c3                   	ret    
80106a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a75:	c9                   	leave  
80106a76:	c3                   	ret    
80106a77:	89 f6                	mov    %esi,%esi
80106a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a80 <sys_kill>:

int
sys_kill(void)
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a89:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a94:	e8 a7 f1 ff ff       	call   80105c40 <argint>
80106a99:	85 c0                	test   %eax,%eax
80106a9b:	78 13                	js     80106ab0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aa0:	89 04 24             	mov    %eax,(%esp)
80106aa3:	e8 88 dc ff ff       	call   80104730 <kill>
}
80106aa8:	c9                   	leave  
80106aa9:	c3                   	ret    
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ab5:	c9                   	leave  
80106ab6:	c3                   	ret    
80106ab7:	89 f6                	mov    %esi,%esi
80106ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ac0 <sys_getpid>:

int
sys_getpid(void)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106ac6:	e8 f5 cf ff ff       	call   80103ac0 <myproc>
80106acb:	8b 40 10             	mov    0x10(%eax),%eax
}
80106ace:	c9                   	leave  
80106acf:	c3                   	ret    

80106ad0 <sys_sbrk>:

int
sys_sbrk(void)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	53                   	push   %ebx
80106ad4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106ad7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ada:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ade:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ae5:	e8 56 f1 ff ff       	call   80105c40 <argint>
80106aea:	85 c0                	test   %eax,%eax
80106aec:	78 22                	js     80106b10 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106aee:	e8 cd cf ff ff       	call   80103ac0 <myproc>
80106af3:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106af8:	89 04 24             	mov    %eax,(%esp)
80106afb:	e8 60 d1 ff ff       	call   80103c60 <growproc>
80106b00:	85 c0                	test   %eax,%eax
80106b02:	78 0c                	js     80106b10 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106b04:	83 c4 24             	add    $0x24,%esp
80106b07:	89 d8                	mov    %ebx,%eax
80106b09:	5b                   	pop    %ebx
80106b0a:	5d                   	pop    %ebp
80106b0b:	c3                   	ret    
80106b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106b10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106b15:	eb ed                	jmp    80106b04 <sys_sbrk+0x34>
80106b17:	89 f6                	mov    %esi,%esi
80106b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b20 <sys_sleep>:

int
sys_sleep(void)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	53                   	push   %ebx
80106b24:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106b27:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b35:	e8 06 f1 ff ff       	call   80105c40 <argint>
80106b3a:	85 c0                	test   %eax,%eax
80106b3c:	78 7e                	js     80106bbc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
80106b3e:	c7 04 24 c0 72 11 80 	movl   $0x801172c0,(%esp)
80106b45:	e8 16 ed ff ff       	call   80105860 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106b4a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  ticks0 = ticks;
80106b4d:	8b 1d 00 7b 11 80    	mov    0x80117b00,%ebx
  while(ticks - ticks0 < n){
80106b53:	85 c9                	test   %ecx,%ecx
80106b55:	75 2a                	jne    80106b81 <sys_sleep+0x61>
80106b57:	eb 4f                	jmp    80106ba8 <sys_sleep+0x88>
80106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106b60:	b8 c0 72 11 80       	mov    $0x801172c0,%eax
80106b65:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b69:	c7 04 24 00 7b 11 80 	movl   $0x80117b00,(%esp)
80106b70:	e8 6b d9 ff ff       	call   801044e0 <sleep>
  while(ticks - ticks0 < n){
80106b75:	a1 00 7b 11 80       	mov    0x80117b00,%eax
80106b7a:	29 d8                	sub    %ebx,%eax
80106b7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106b7f:	73 27                	jae    80106ba8 <sys_sleep+0x88>
    if(myproc()->killed){
80106b81:	e8 3a cf ff ff       	call   80103ac0 <myproc>
80106b86:	8b 50 24             	mov    0x24(%eax),%edx
80106b89:	85 d2                	test   %edx,%edx
80106b8b:	74 d3                	je     80106b60 <sys_sleep+0x40>
      release(&tickslock);
80106b8d:	c7 04 24 c0 72 11 80 	movl   $0x801172c0,(%esp)
80106b94:	e8 67 ed ff ff       	call   80105900 <release>
  }
  release(&tickslock);
  return 0;
}
80106b99:	83 c4 24             	add    $0x24,%esp
      return -1;
80106b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ba1:	5b                   	pop    %ebx
80106ba2:	5d                   	pop    %ebp
80106ba3:	c3                   	ret    
80106ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80106ba8:	c7 04 24 c0 72 11 80 	movl   $0x801172c0,(%esp)
80106baf:	e8 4c ed ff ff       	call   80105900 <release>
  return 0;
80106bb4:	31 c0                	xor    %eax,%eax
}
80106bb6:	83 c4 24             	add    $0x24,%esp
80106bb9:	5b                   	pop    %ebx
80106bba:	5d                   	pop    %ebp
80106bbb:	c3                   	ret    
    return -1;
80106bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc1:	eb f3                	jmp    80106bb6 <sys_sleep+0x96>
80106bc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bd0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	53                   	push   %ebx
80106bd4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80106bd7:	c7 04 24 c0 72 11 80 	movl   $0x801172c0,(%esp)
80106bde:	e8 7d ec ff ff       	call   80105860 <acquire>
  xticks = ticks;
80106be3:	8b 1d 00 7b 11 80    	mov    0x80117b00,%ebx
  release(&tickslock);
80106be9:	c7 04 24 c0 72 11 80 	movl   $0x801172c0,(%esp)
80106bf0:	e8 0b ed ff ff       	call   80105900 <release>
  return xticks;
}
80106bf5:	83 c4 14             	add    $0x14,%esp
80106bf8:	89 d8                	mov    %ebx,%eax
80106bfa:	5b                   	pop    %ebx
80106bfb:	5d                   	pop    %ebp
80106bfc:	c3                   	ret    

80106bfd <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106bfd:	1e                   	push   %ds
  pushl %es
80106bfe:	06                   	push   %es
  pushl %fs
80106bff:	0f a0                	push   %fs
  pushl %gs
80106c01:	0f a8                	push   %gs
  pushal
80106c03:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106c04:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106c08:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106c0a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106c0c:	54                   	push   %esp
  call trap
80106c0d:	e8 be 00 00 00       	call   80106cd0 <trap>
  addl $4, %esp
80106c12:	83 c4 04             	add    $0x4,%esp

80106c15 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106c15:	61                   	popa   
  popl %gs
80106c16:	0f a9                	pop    %gs
  popl %fs
80106c18:	0f a1                	pop    %fs
  popl %es
80106c1a:	07                   	pop    %es
  popl %ds
80106c1b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106c1c:	83 c4 08             	add    $0x8,%esp
  iret
80106c1f:	cf                   	iret   

80106c20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106c20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106c21:	31 c0                	xor    %eax,%eax
{
80106c23:	89 e5                	mov    %esp,%ebp
80106c25:	83 ec 18             	sub    $0x18,%esp
80106c28:	90                   	nop
80106c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106c30:	8b 14 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%edx
80106c37:	b9 08 00 00 8e       	mov    $0x8e000008,%ecx
80106c3c:	89 0c c5 02 73 11 80 	mov    %ecx,-0x7fee8cfe(,%eax,8)
80106c43:	66 89 14 c5 00 73 11 	mov    %dx,-0x7fee8d00(,%eax,8)
80106c4a:	80 
80106c4b:	c1 ea 10             	shr    $0x10,%edx
80106c4e:	66 89 14 c5 06 73 11 	mov    %dx,-0x7fee8cfa(,%eax,8)
80106c55:	80 
  for(i = 0; i < 256; i++)
80106c56:	40                   	inc    %eax
80106c57:	3d 00 01 00 00       	cmp    $0x100,%eax
80106c5c:	75 d2                	jne    80106c30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106c5e:	a1 0c c1 10 80       	mov    0x8010c10c,%eax

  initlock(&tickslock, "time");
80106c63:	b9 7d 8f 10 80       	mov    $0x80108f7d,%ecx
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106c68:	ba 08 00 00 ef       	mov    $0xef000008,%edx
  initlock(&tickslock, "time");
80106c6d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106c71:	c7 04 24 c0 72 11 80 	movl   $0x801172c0,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106c78:	89 15 02 75 11 80    	mov    %edx,0x80117502
80106c7e:	66 a3 00 75 11 80    	mov    %ax,0x80117500
80106c84:	c1 e8 10             	shr    $0x10,%eax
80106c87:	66 a3 06 75 11 80    	mov    %ax,0x80117506
  initlock(&tickslock, "time");
80106c8d:	e8 7e ea ff ff       	call   80105710 <initlock>
}
80106c92:	c9                   	leave  
80106c93:	c3                   	ret    
80106c94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ca0 <idtinit>:

void
idtinit(void)
{
80106ca0:	55                   	push   %ebp
  pd[1] = (uint)p;
80106ca1:	b8 00 73 11 80       	mov    $0x80117300,%eax
80106ca6:	89 e5                	mov    %esp,%ebp
80106ca8:	0f b7 d0             	movzwl %ax,%edx
  pd[2] = (uint)p >> 16;
80106cab:	c1 e8 10             	shr    $0x10,%eax
80106cae:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106cb1:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80106cb7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106cbb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106cbf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106cc2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106cc5:	c9                   	leave  
80106cc6:	c3                   	ret    
80106cc7:	89 f6                	mov    %esi,%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	83 ec 48             	sub    $0x48,%esp
80106cd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80106cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106cdc:	89 75 f8             	mov    %esi,-0x8(%ebp)
80106cdf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
80106ce2:	8b 43 30             	mov    0x30(%ebx),%eax
80106ce5:	83 f8 40             	cmp    $0x40,%eax
80106ce8:	0f 84 02 01 00 00    	je     80106df0 <trap+0x120>
    if(myproc()->killed)
      exit(0);
    return;
  }

  switch(tf->trapno){
80106cee:	83 e8 20             	sub    $0x20,%eax
80106cf1:	83 f8 1f             	cmp    $0x1f,%eax
80106cf4:	77 0a                	ja     80106d00 <trap+0x30>
80106cf6:	ff 24 85 24 90 10 80 	jmp    *-0x7fef6fdc(,%eax,4)
80106cfd:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106d00:	e8 bb cd ff ff       	call   80103ac0 <myproc>
80106d05:	8b 7b 38             	mov    0x38(%ebx),%edi
80106d08:	85 c0                	test   %eax,%eax
80106d0a:	0f 84 5f 02 00 00    	je     80106f6f <trap+0x29f>
80106d10:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106d14:	0f 84 55 02 00 00    	je     80106f6f <trap+0x29f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d1a:	0f 20 d1             	mov    %cr2,%ecx
80106d1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d20:	e8 7b cd ff ff       	call   80103aa0 <cpuid>
80106d25:	8b 73 30             	mov    0x30(%ebx),%esi
80106d28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d2b:	8b 43 34             	mov    0x34(%ebx),%eax
80106d2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106d31:	e8 8a cd ff ff       	call   80103ac0 <myproc>
80106d36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d39:	e8 82 cd ff ff       	call   80103ac0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106d41:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80106d45:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d48:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106d4b:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106d4f:	89 54 24 14          	mov    %edx,0x14(%esp)
80106d53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80106d56:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d59:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80106d5d:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d61:	89 54 24 10          	mov    %edx,0x10(%esp)
80106d65:	8b 40 10             	mov    0x10(%eax),%eax
80106d68:	c7 04 24 e0 8f 10 80 	movl   $0x80108fe0,(%esp)
80106d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d73:	e8 d8 98 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106d78:	e8 43 cd ff ff       	call   80103ac0 <myproc>
80106d7d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d84:	e8 37 cd ff ff       	call   80103ac0 <myproc>
80106d89:	85 c0                	test   %eax,%eax
80106d8b:	74 1b                	je     80106da8 <trap+0xd8>
80106d8d:	e8 2e cd ff ff       	call   80103ac0 <myproc>
80106d92:	8b 50 24             	mov    0x24(%eax),%edx
80106d95:	85 d2                	test   %edx,%edx
80106d97:	74 0f                	je     80106da8 <trap+0xd8>
80106d99:	8b 43 3c             	mov    0x3c(%ebx),%eax
80106d9c:	83 e0 03             	and    $0x3,%eax
80106d9f:	83 f8 03             	cmp    $0x3,%eax
80106da2:	0f 84 80 01 00 00    	je     80106f28 <trap+0x258>
    exit(0);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106da8:	e8 13 cd ff ff       	call   80103ac0 <myproc>
80106dad:	85 c0                	test   %eax,%eax
80106daf:	74 0d                	je     80106dbe <trap+0xee>
80106db1:	e8 0a cd ff ff       	call   80103ac0 <myproc>
80106db6:	8b 40 0c             	mov    0xc(%eax),%eax
80106db9:	83 f8 04             	cmp    $0x4,%eax
80106dbc:	74 7a                	je     80106e38 <trap+0x168>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106dbe:	e8 fd cc ff ff       	call   80103ac0 <myproc>
80106dc3:	85 c0                	test   %eax,%eax
80106dc5:	74 17                	je     80106dde <trap+0x10e>
80106dc7:	e8 f4 cc ff ff       	call   80103ac0 <myproc>
80106dcc:	8b 40 24             	mov    0x24(%eax),%eax
80106dcf:	85 c0                	test   %eax,%eax
80106dd1:	74 0b                	je     80106dde <trap+0x10e>
80106dd3:	8b 43 3c             	mov    0x3c(%ebx),%eax
80106dd6:	83 e0 03             	and    $0x3,%eax
80106dd9:	83 f8 03             	cmp    $0x3,%eax
80106ddc:	74 3b                	je     80106e19 <trap+0x149>
    exit(0);
}
80106dde:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80106de1:	8b 75 f8             	mov    -0x8(%ebp),%esi
80106de4:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106de7:	89 ec                	mov    %ebp,%esp
80106de9:	5d                   	pop    %ebp
80106dea:	c3                   	ret    
80106deb:	90                   	nop
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106df0:	e8 cb cc ff ff       	call   80103ac0 <myproc>
80106df5:	8b 70 24             	mov    0x24(%eax),%esi
80106df8:	85 f6                	test   %esi,%esi
80106dfa:	0f 85 10 01 00 00    	jne    80106f10 <trap+0x240>
    myproc()->tf = tf;
80106e00:	e8 bb cc ff ff       	call   80103ac0 <myproc>
80106e05:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106e08:	e8 23 ef ff ff       	call   80105d30 <syscall>
    if(myproc()->killed)
80106e0d:	e8 ae cc ff ff       	call   80103ac0 <myproc>
80106e12:	8b 48 24             	mov    0x24(%eax),%ecx
80106e15:	85 c9                	test   %ecx,%ecx
80106e17:	74 c5                	je     80106dde <trap+0x10e>
      exit(0);
80106e19:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
80106e20:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80106e23:	8b 75 f8             	mov    -0x8(%ebp),%esi
80106e26:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106e29:	89 ec                	mov    %ebp,%esp
80106e2b:	5d                   	pop    %ebp
      exit(0);
80106e2c:	e9 8f d4 ff ff       	jmp    801042c0 <exit>
80106e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106e38:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106e3c:	75 80                	jne    80106dbe <trap+0xee>
    yield();
80106e3e:	e8 9d d5 ff ff       	call   801043e0 <yield>
80106e43:	e9 76 ff ff ff       	jmp    80106dbe <trap+0xee>
80106e48:	90                   	nop
80106e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106e50:	e8 4b cc ff ff       	call   80103aa0 <cpuid>
80106e55:	85 c0                	test   %eax,%eax
80106e57:	0f 84 e3 00 00 00    	je     80106f40 <trap+0x270>
80106e5d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80106e60:	e8 9b ba ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e65:	e8 56 cc ff ff       	call   80103ac0 <myproc>
80106e6a:	85 c0                	test   %eax,%eax
80106e6c:	0f 85 1b ff ff ff    	jne    80106d8d <trap+0xbd>
80106e72:	e9 31 ff ff ff       	jmp    80106da8 <trap+0xd8>
80106e77:	89 f6                	mov    %esi,%esi
80106e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
80106e80:	e8 3b b9 ff ff       	call   801027c0 <kbdintr>
    lapiceoi();
80106e85:	e8 76 ba ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e8a:	e8 31 cc ff ff       	call   80103ac0 <myproc>
80106e8f:	85 c0                	test   %eax,%eax
80106e91:	0f 85 f6 fe ff ff    	jne    80106d8d <trap+0xbd>
80106e97:	e9 0c ff ff ff       	jmp    80106da8 <trap+0xd8>
80106e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106ea0:	e8 6b 02 00 00       	call   80107110 <uartintr>
    lapiceoi();
80106ea5:	e8 56 ba ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106eaa:	e8 11 cc ff ff       	call   80103ac0 <myproc>
80106eaf:	85 c0                	test   %eax,%eax
80106eb1:	0f 85 d6 fe ff ff    	jne    80106d8d <trap+0xbd>
80106eb7:	e9 ec fe ff ff       	jmp    80106da8 <trap+0xd8>
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ec0:	8b 7b 38             	mov    0x38(%ebx),%edi
80106ec3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106ec7:	e8 d4 cb ff ff       	call   80103aa0 <cpuid>
80106ecc:	c7 04 24 88 8f 10 80 	movl   $0x80108f88,(%esp)
80106ed3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106ed7:	89 74 24 08          	mov    %esi,0x8(%esp)
80106edb:	89 44 24 04          	mov    %eax,0x4(%esp)
80106edf:	e8 6c 97 ff ff       	call   80100650 <cprintf>
    lapiceoi();
80106ee4:	e8 17 ba ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ee9:	e8 d2 cb ff ff       	call   80103ac0 <myproc>
80106eee:	85 c0                	test   %eax,%eax
80106ef0:	0f 85 97 fe ff ff    	jne    80106d8d <trap+0xbd>
80106ef6:	e9 ad fe ff ff       	jmp    80106da8 <trap+0xd8>
80106efb:	90                   	nop
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106f00:	e8 0b b3 ff ff       	call   80102210 <ideintr>
80106f05:	e9 53 ff ff ff       	jmp    80106e5d <trap+0x18d>
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit(0);
80106f10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f17:	e8 a4 d3 ff ff       	call   801042c0 <exit>
80106f1c:	e9 df fe ff ff       	jmp    80106e00 <trap+0x130>
80106f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit(0);
80106f28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f2f:	e8 8c d3 ff ff       	call   801042c0 <exit>
80106f34:	e9 6f fe ff ff       	jmp    80106da8 <trap+0xd8>
80106f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      acquire(&tickslock);
80106f40:	c7 04 24 c0 72 11 80 	movl   $0x801172c0,(%esp)
80106f47:	e8 14 e9 ff ff       	call   80105860 <acquire>
      wakeup(&ticks);
80106f4c:	c7 04 24 00 7b 11 80 	movl   $0x80117b00,(%esp)
      ticks++;
80106f53:	ff 05 00 7b 11 80    	incl   0x80117b00
      wakeup(&ticks);
80106f59:	e8 a2 d7 ff ff       	call   80104700 <wakeup>
      release(&tickslock);
80106f5e:	c7 04 24 c0 72 11 80 	movl   $0x801172c0,(%esp)
80106f65:	e8 96 e9 ff ff       	call   80105900 <release>
80106f6a:	e9 ee fe ff ff       	jmp    80106e5d <trap+0x18d>
80106f6f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106f72:	e8 29 cb ff ff       	call   80103aa0 <cpuid>
80106f77:	89 74 24 10          	mov    %esi,0x10(%esp)
80106f7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106f7f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106f83:	8b 43 30             	mov    0x30(%ebx),%eax
80106f86:	c7 04 24 ac 8f 10 80 	movl   $0x80108fac,(%esp)
80106f8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f91:	e8 ba 96 ff ff       	call   80100650 <cprintf>
      panic("trap");
80106f96:	c7 04 24 82 8f 10 80 	movl   $0x80108f82,(%esp)
80106f9d:	e8 ce 93 ff ff       	call   80100370 <panic>
80106fa2:	66 90                	xchg   %ax,%ax
80106fa4:	66 90                	xchg   %ax,%ax
80106fa6:	66 90                	xchg   %ax,%ax
80106fa8:	66 90                	xchg   %ax,%ax
80106faa:	66 90                	xchg   %ax,%ax
80106fac:	66 90                	xchg   %ax,%ax
80106fae:	66 90                	xchg   %ax,%ax

80106fb0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106fb0:	a1 14 c6 10 80       	mov    0x8010c614,%eax
{
80106fb5:	55                   	push   %ebp
80106fb6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106fb8:	85 c0                	test   %eax,%eax
80106fba:	74 1c                	je     80106fd8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106fbc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106fc1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106fc2:	24 01                	and    $0x1,%al
80106fc4:	84 c0                	test   %al,%al
80106fc6:	74 10                	je     80106fd8 <uartgetc+0x28>
80106fc8:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106fcd:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106fce:	0f b6 c0             	movzbl %al,%eax
}
80106fd1:	5d                   	pop    %ebp
80106fd2:	c3                   	ret    
80106fd3:	90                   	nop
80106fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fdd:	5d                   	pop    %ebp
80106fde:	c3                   	ret    
80106fdf:	90                   	nop

80106fe0 <uartputc.part.0>:
uartputc(int c)
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	56                   	push   %esi
80106fe4:	be fd 03 00 00       	mov    $0x3fd,%esi
80106fe9:	53                   	push   %ebx
80106fea:	bb 80 00 00 00       	mov    $0x80,%ebx
80106fef:	83 ec 20             	sub    $0x20,%esp
80106ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ff5:	eb 18                	jmp    8010700f <uartputc.part.0+0x2f>
80106ff7:	89 f6                	mov    %esi,%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80107000:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107007:	e8 14 b9 ff ff       	call   80102920 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010700c:	4b                   	dec    %ebx
8010700d:	74 09                	je     80107018 <uartputc.part.0+0x38>
8010700f:	89 f2                	mov    %esi,%edx
80107011:	ec                   	in     (%dx),%al
80107012:	24 20                	and    $0x20,%al
80107014:	84 c0                	test   %al,%al
80107016:	74 e8                	je     80107000 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107018:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010701d:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
80107021:	ee                   	out    %al,(%dx)
}
80107022:	83 c4 20             	add    $0x20,%esp
80107025:	5b                   	pop    %ebx
80107026:	5e                   	pop    %esi
80107027:	5d                   	pop    %ebp
80107028:	c3                   	ret    
80107029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107030 <uartinit>:
{
80107030:	55                   	push   %ebp
80107031:	31 c9                	xor    %ecx,%ecx
80107033:	89 e5                	mov    %esp,%ebp
80107035:	88 c8                	mov    %cl,%al
80107037:	57                   	push   %edi
80107038:	56                   	push   %esi
80107039:	53                   	push   %ebx
8010703a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010703f:	83 ec 1c             	sub    $0x1c,%esp
80107042:	89 da                	mov    %ebx,%edx
80107044:	ee                   	out    %al,(%dx)
80107045:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010704a:	b0 80                	mov    $0x80,%al
8010704c:	89 fa                	mov    %edi,%edx
8010704e:	ee                   	out    %al,(%dx)
8010704f:	b0 0c                	mov    $0xc,%al
80107051:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107056:	ee                   	out    %al,(%dx)
80107057:	be f9 03 00 00       	mov    $0x3f9,%esi
8010705c:	88 c8                	mov    %cl,%al
8010705e:	89 f2                	mov    %esi,%edx
80107060:	ee                   	out    %al,(%dx)
80107061:	b0 03                	mov    $0x3,%al
80107063:	89 fa                	mov    %edi,%edx
80107065:	ee                   	out    %al,(%dx)
80107066:	ba fc 03 00 00       	mov    $0x3fc,%edx
8010706b:	88 c8                	mov    %cl,%al
8010706d:	ee                   	out    %al,(%dx)
8010706e:	b0 01                	mov    $0x1,%al
80107070:	89 f2                	mov    %esi,%edx
80107072:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107073:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107078:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107079:	fe c0                	inc    %al
8010707b:	74 52                	je     801070cf <uartinit+0x9f>
  uart = 1;
8010707d:	b9 01 00 00 00       	mov    $0x1,%ecx
80107082:	89 da                	mov    %ebx,%edx
80107084:	89 0d 14 c6 10 80    	mov    %ecx,0x8010c614
8010708a:	ec                   	in     (%dx),%al
8010708b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107090:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107091:	31 db                	xor    %ebx,%ebx
80107093:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  for(p="xv6...\n"; *p; p++)
80107097:	bb a4 90 10 80       	mov    $0x801090a4,%ebx
  ioapicenable(IRQ_COM1, 0);
8010709c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801070a3:	e8 a8 b3 ff ff       	call   80102450 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801070a8:	b8 78 00 00 00       	mov    $0x78,%eax
801070ad:	eb 09                	jmp    801070b8 <uartinit+0x88>
801070af:	90                   	nop
801070b0:	43                   	inc    %ebx
801070b1:	0f be 03             	movsbl (%ebx),%eax
801070b4:	84 c0                	test   %al,%al
801070b6:	74 17                	je     801070cf <uartinit+0x9f>
  if(!uart)
801070b8:	8b 15 14 c6 10 80    	mov    0x8010c614,%edx
801070be:	85 d2                	test   %edx,%edx
801070c0:	74 ee                	je     801070b0 <uartinit+0x80>
  for(p="xv6...\n"; *p; p++)
801070c2:	43                   	inc    %ebx
801070c3:	e8 18 ff ff ff       	call   80106fe0 <uartputc.part.0>
801070c8:	0f be 03             	movsbl (%ebx),%eax
801070cb:	84 c0                	test   %al,%al
801070cd:	75 e9                	jne    801070b8 <uartinit+0x88>
}
801070cf:	83 c4 1c             	add    $0x1c,%esp
801070d2:	5b                   	pop    %ebx
801070d3:	5e                   	pop    %esi
801070d4:	5f                   	pop    %edi
801070d5:	5d                   	pop    %ebp
801070d6:	c3                   	ret    
801070d7:	89 f6                	mov    %esi,%esi
801070d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070e0 <uartputc>:
  if(!uart)
801070e0:	8b 15 14 c6 10 80    	mov    0x8010c614,%edx
{
801070e6:	55                   	push   %ebp
801070e7:	89 e5                	mov    %esp,%ebp
801070e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801070ec:	85 d2                	test   %edx,%edx
801070ee:	74 10                	je     80107100 <uartputc+0x20>
}
801070f0:	5d                   	pop    %ebp
801070f1:	e9 ea fe ff ff       	jmp    80106fe0 <uartputc.part.0>
801070f6:	8d 76 00             	lea    0x0(%esi),%esi
801070f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107100:	5d                   	pop    %ebp
80107101:	c3                   	ret    
80107102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107110 <uartintr>:

void
uartintr(void)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107116:	c7 04 24 b0 6f 10 80 	movl   $0x80106fb0,(%esp)
8010711d:	e8 ae 96 ff ff       	call   801007d0 <consoleintr>
}
80107122:	c9                   	leave  
80107123:	c3                   	ret    

80107124 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107124:	6a 00                	push   $0x0
  pushl $0
80107126:	6a 00                	push   $0x0
  jmp alltraps
80107128:	e9 d0 fa ff ff       	jmp    80106bfd <alltraps>

8010712d <vector1>:
.globl vector1
vector1:
  pushl $0
8010712d:	6a 00                	push   $0x0
  pushl $1
8010712f:	6a 01                	push   $0x1
  jmp alltraps
80107131:	e9 c7 fa ff ff       	jmp    80106bfd <alltraps>

80107136 <vector2>:
.globl vector2
vector2:
  pushl $0
80107136:	6a 00                	push   $0x0
  pushl $2
80107138:	6a 02                	push   $0x2
  jmp alltraps
8010713a:	e9 be fa ff ff       	jmp    80106bfd <alltraps>

8010713f <vector3>:
.globl vector3
vector3:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $3
80107141:	6a 03                	push   $0x3
  jmp alltraps
80107143:	e9 b5 fa ff ff       	jmp    80106bfd <alltraps>

80107148 <vector4>:
.globl vector4
vector4:
  pushl $0
80107148:	6a 00                	push   $0x0
  pushl $4
8010714a:	6a 04                	push   $0x4
  jmp alltraps
8010714c:	e9 ac fa ff ff       	jmp    80106bfd <alltraps>

80107151 <vector5>:
.globl vector5
vector5:
  pushl $0
80107151:	6a 00                	push   $0x0
  pushl $5
80107153:	6a 05                	push   $0x5
  jmp alltraps
80107155:	e9 a3 fa ff ff       	jmp    80106bfd <alltraps>

8010715a <vector6>:
.globl vector6
vector6:
  pushl $0
8010715a:	6a 00                	push   $0x0
  pushl $6
8010715c:	6a 06                	push   $0x6
  jmp alltraps
8010715e:	e9 9a fa ff ff       	jmp    80106bfd <alltraps>

80107163 <vector7>:
.globl vector7
vector7:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $7
80107165:	6a 07                	push   $0x7
  jmp alltraps
80107167:	e9 91 fa ff ff       	jmp    80106bfd <alltraps>

8010716c <vector8>:
.globl vector8
vector8:
  pushl $8
8010716c:	6a 08                	push   $0x8
  jmp alltraps
8010716e:	e9 8a fa ff ff       	jmp    80106bfd <alltraps>

80107173 <vector9>:
.globl vector9
vector9:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $9
80107175:	6a 09                	push   $0x9
  jmp alltraps
80107177:	e9 81 fa ff ff       	jmp    80106bfd <alltraps>

8010717c <vector10>:
.globl vector10
vector10:
  pushl $10
8010717c:	6a 0a                	push   $0xa
  jmp alltraps
8010717e:	e9 7a fa ff ff       	jmp    80106bfd <alltraps>

80107183 <vector11>:
.globl vector11
vector11:
  pushl $11
80107183:	6a 0b                	push   $0xb
  jmp alltraps
80107185:	e9 73 fa ff ff       	jmp    80106bfd <alltraps>

8010718a <vector12>:
.globl vector12
vector12:
  pushl $12
8010718a:	6a 0c                	push   $0xc
  jmp alltraps
8010718c:	e9 6c fa ff ff       	jmp    80106bfd <alltraps>

80107191 <vector13>:
.globl vector13
vector13:
  pushl $13
80107191:	6a 0d                	push   $0xd
  jmp alltraps
80107193:	e9 65 fa ff ff       	jmp    80106bfd <alltraps>

80107198 <vector14>:
.globl vector14
vector14:
  pushl $14
80107198:	6a 0e                	push   $0xe
  jmp alltraps
8010719a:	e9 5e fa ff ff       	jmp    80106bfd <alltraps>

8010719f <vector15>:
.globl vector15
vector15:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $15
801071a1:	6a 0f                	push   $0xf
  jmp alltraps
801071a3:	e9 55 fa ff ff       	jmp    80106bfd <alltraps>

801071a8 <vector16>:
.globl vector16
vector16:
  pushl $0
801071a8:	6a 00                	push   $0x0
  pushl $16
801071aa:	6a 10                	push   $0x10
  jmp alltraps
801071ac:	e9 4c fa ff ff       	jmp    80106bfd <alltraps>

801071b1 <vector17>:
.globl vector17
vector17:
  pushl $17
801071b1:	6a 11                	push   $0x11
  jmp alltraps
801071b3:	e9 45 fa ff ff       	jmp    80106bfd <alltraps>

801071b8 <vector18>:
.globl vector18
vector18:
  pushl $0
801071b8:	6a 00                	push   $0x0
  pushl $18
801071ba:	6a 12                	push   $0x12
  jmp alltraps
801071bc:	e9 3c fa ff ff       	jmp    80106bfd <alltraps>

801071c1 <vector19>:
.globl vector19
vector19:
  pushl $0
801071c1:	6a 00                	push   $0x0
  pushl $19
801071c3:	6a 13                	push   $0x13
  jmp alltraps
801071c5:	e9 33 fa ff ff       	jmp    80106bfd <alltraps>

801071ca <vector20>:
.globl vector20
vector20:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $20
801071cc:	6a 14                	push   $0x14
  jmp alltraps
801071ce:	e9 2a fa ff ff       	jmp    80106bfd <alltraps>

801071d3 <vector21>:
.globl vector21
vector21:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $21
801071d5:	6a 15                	push   $0x15
  jmp alltraps
801071d7:	e9 21 fa ff ff       	jmp    80106bfd <alltraps>

801071dc <vector22>:
.globl vector22
vector22:
  pushl $0
801071dc:	6a 00                	push   $0x0
  pushl $22
801071de:	6a 16                	push   $0x16
  jmp alltraps
801071e0:	e9 18 fa ff ff       	jmp    80106bfd <alltraps>

801071e5 <vector23>:
.globl vector23
vector23:
  pushl $0
801071e5:	6a 00                	push   $0x0
  pushl $23
801071e7:	6a 17                	push   $0x17
  jmp alltraps
801071e9:	e9 0f fa ff ff       	jmp    80106bfd <alltraps>

801071ee <vector24>:
.globl vector24
vector24:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $24
801071f0:	6a 18                	push   $0x18
  jmp alltraps
801071f2:	e9 06 fa ff ff       	jmp    80106bfd <alltraps>

801071f7 <vector25>:
.globl vector25
vector25:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $25
801071f9:	6a 19                	push   $0x19
  jmp alltraps
801071fb:	e9 fd f9 ff ff       	jmp    80106bfd <alltraps>

80107200 <vector26>:
.globl vector26
vector26:
  pushl $0
80107200:	6a 00                	push   $0x0
  pushl $26
80107202:	6a 1a                	push   $0x1a
  jmp alltraps
80107204:	e9 f4 f9 ff ff       	jmp    80106bfd <alltraps>

80107209 <vector27>:
.globl vector27
vector27:
  pushl $0
80107209:	6a 00                	push   $0x0
  pushl $27
8010720b:	6a 1b                	push   $0x1b
  jmp alltraps
8010720d:	e9 eb f9 ff ff       	jmp    80106bfd <alltraps>

80107212 <vector28>:
.globl vector28
vector28:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $28
80107214:	6a 1c                	push   $0x1c
  jmp alltraps
80107216:	e9 e2 f9 ff ff       	jmp    80106bfd <alltraps>

8010721b <vector29>:
.globl vector29
vector29:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $29
8010721d:	6a 1d                	push   $0x1d
  jmp alltraps
8010721f:	e9 d9 f9 ff ff       	jmp    80106bfd <alltraps>

80107224 <vector30>:
.globl vector30
vector30:
  pushl $0
80107224:	6a 00                	push   $0x0
  pushl $30
80107226:	6a 1e                	push   $0x1e
  jmp alltraps
80107228:	e9 d0 f9 ff ff       	jmp    80106bfd <alltraps>

8010722d <vector31>:
.globl vector31
vector31:
  pushl $0
8010722d:	6a 00                	push   $0x0
  pushl $31
8010722f:	6a 1f                	push   $0x1f
  jmp alltraps
80107231:	e9 c7 f9 ff ff       	jmp    80106bfd <alltraps>

80107236 <vector32>:
.globl vector32
vector32:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $32
80107238:	6a 20                	push   $0x20
  jmp alltraps
8010723a:	e9 be f9 ff ff       	jmp    80106bfd <alltraps>

8010723f <vector33>:
.globl vector33
vector33:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $33
80107241:	6a 21                	push   $0x21
  jmp alltraps
80107243:	e9 b5 f9 ff ff       	jmp    80106bfd <alltraps>

80107248 <vector34>:
.globl vector34
vector34:
  pushl $0
80107248:	6a 00                	push   $0x0
  pushl $34
8010724a:	6a 22                	push   $0x22
  jmp alltraps
8010724c:	e9 ac f9 ff ff       	jmp    80106bfd <alltraps>

80107251 <vector35>:
.globl vector35
vector35:
  pushl $0
80107251:	6a 00                	push   $0x0
  pushl $35
80107253:	6a 23                	push   $0x23
  jmp alltraps
80107255:	e9 a3 f9 ff ff       	jmp    80106bfd <alltraps>

8010725a <vector36>:
.globl vector36
vector36:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $36
8010725c:	6a 24                	push   $0x24
  jmp alltraps
8010725e:	e9 9a f9 ff ff       	jmp    80106bfd <alltraps>

80107263 <vector37>:
.globl vector37
vector37:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $37
80107265:	6a 25                	push   $0x25
  jmp alltraps
80107267:	e9 91 f9 ff ff       	jmp    80106bfd <alltraps>

8010726c <vector38>:
.globl vector38
vector38:
  pushl $0
8010726c:	6a 00                	push   $0x0
  pushl $38
8010726e:	6a 26                	push   $0x26
  jmp alltraps
80107270:	e9 88 f9 ff ff       	jmp    80106bfd <alltraps>

80107275 <vector39>:
.globl vector39
vector39:
  pushl $0
80107275:	6a 00                	push   $0x0
  pushl $39
80107277:	6a 27                	push   $0x27
  jmp alltraps
80107279:	e9 7f f9 ff ff       	jmp    80106bfd <alltraps>

8010727e <vector40>:
.globl vector40
vector40:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $40
80107280:	6a 28                	push   $0x28
  jmp alltraps
80107282:	e9 76 f9 ff ff       	jmp    80106bfd <alltraps>

80107287 <vector41>:
.globl vector41
vector41:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $41
80107289:	6a 29                	push   $0x29
  jmp alltraps
8010728b:	e9 6d f9 ff ff       	jmp    80106bfd <alltraps>

80107290 <vector42>:
.globl vector42
vector42:
  pushl $0
80107290:	6a 00                	push   $0x0
  pushl $42
80107292:	6a 2a                	push   $0x2a
  jmp alltraps
80107294:	e9 64 f9 ff ff       	jmp    80106bfd <alltraps>

80107299 <vector43>:
.globl vector43
vector43:
  pushl $0
80107299:	6a 00                	push   $0x0
  pushl $43
8010729b:	6a 2b                	push   $0x2b
  jmp alltraps
8010729d:	e9 5b f9 ff ff       	jmp    80106bfd <alltraps>

801072a2 <vector44>:
.globl vector44
vector44:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $44
801072a4:	6a 2c                	push   $0x2c
  jmp alltraps
801072a6:	e9 52 f9 ff ff       	jmp    80106bfd <alltraps>

801072ab <vector45>:
.globl vector45
vector45:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $45
801072ad:	6a 2d                	push   $0x2d
  jmp alltraps
801072af:	e9 49 f9 ff ff       	jmp    80106bfd <alltraps>

801072b4 <vector46>:
.globl vector46
vector46:
  pushl $0
801072b4:	6a 00                	push   $0x0
  pushl $46
801072b6:	6a 2e                	push   $0x2e
  jmp alltraps
801072b8:	e9 40 f9 ff ff       	jmp    80106bfd <alltraps>

801072bd <vector47>:
.globl vector47
vector47:
  pushl $0
801072bd:	6a 00                	push   $0x0
  pushl $47
801072bf:	6a 2f                	push   $0x2f
  jmp alltraps
801072c1:	e9 37 f9 ff ff       	jmp    80106bfd <alltraps>

801072c6 <vector48>:
.globl vector48
vector48:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $48
801072c8:	6a 30                	push   $0x30
  jmp alltraps
801072ca:	e9 2e f9 ff ff       	jmp    80106bfd <alltraps>

801072cf <vector49>:
.globl vector49
vector49:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $49
801072d1:	6a 31                	push   $0x31
  jmp alltraps
801072d3:	e9 25 f9 ff ff       	jmp    80106bfd <alltraps>

801072d8 <vector50>:
.globl vector50
vector50:
  pushl $0
801072d8:	6a 00                	push   $0x0
  pushl $50
801072da:	6a 32                	push   $0x32
  jmp alltraps
801072dc:	e9 1c f9 ff ff       	jmp    80106bfd <alltraps>

801072e1 <vector51>:
.globl vector51
vector51:
  pushl $0
801072e1:	6a 00                	push   $0x0
  pushl $51
801072e3:	6a 33                	push   $0x33
  jmp alltraps
801072e5:	e9 13 f9 ff ff       	jmp    80106bfd <alltraps>

801072ea <vector52>:
.globl vector52
vector52:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $52
801072ec:	6a 34                	push   $0x34
  jmp alltraps
801072ee:	e9 0a f9 ff ff       	jmp    80106bfd <alltraps>

801072f3 <vector53>:
.globl vector53
vector53:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $53
801072f5:	6a 35                	push   $0x35
  jmp alltraps
801072f7:	e9 01 f9 ff ff       	jmp    80106bfd <alltraps>

801072fc <vector54>:
.globl vector54
vector54:
  pushl $0
801072fc:	6a 00                	push   $0x0
  pushl $54
801072fe:	6a 36                	push   $0x36
  jmp alltraps
80107300:	e9 f8 f8 ff ff       	jmp    80106bfd <alltraps>

80107305 <vector55>:
.globl vector55
vector55:
  pushl $0
80107305:	6a 00                	push   $0x0
  pushl $55
80107307:	6a 37                	push   $0x37
  jmp alltraps
80107309:	e9 ef f8 ff ff       	jmp    80106bfd <alltraps>

8010730e <vector56>:
.globl vector56
vector56:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $56
80107310:	6a 38                	push   $0x38
  jmp alltraps
80107312:	e9 e6 f8 ff ff       	jmp    80106bfd <alltraps>

80107317 <vector57>:
.globl vector57
vector57:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $57
80107319:	6a 39                	push   $0x39
  jmp alltraps
8010731b:	e9 dd f8 ff ff       	jmp    80106bfd <alltraps>

80107320 <vector58>:
.globl vector58
vector58:
  pushl $0
80107320:	6a 00                	push   $0x0
  pushl $58
80107322:	6a 3a                	push   $0x3a
  jmp alltraps
80107324:	e9 d4 f8 ff ff       	jmp    80106bfd <alltraps>

80107329 <vector59>:
.globl vector59
vector59:
  pushl $0
80107329:	6a 00                	push   $0x0
  pushl $59
8010732b:	6a 3b                	push   $0x3b
  jmp alltraps
8010732d:	e9 cb f8 ff ff       	jmp    80106bfd <alltraps>

80107332 <vector60>:
.globl vector60
vector60:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $60
80107334:	6a 3c                	push   $0x3c
  jmp alltraps
80107336:	e9 c2 f8 ff ff       	jmp    80106bfd <alltraps>

8010733b <vector61>:
.globl vector61
vector61:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $61
8010733d:	6a 3d                	push   $0x3d
  jmp alltraps
8010733f:	e9 b9 f8 ff ff       	jmp    80106bfd <alltraps>

80107344 <vector62>:
.globl vector62
vector62:
  pushl $0
80107344:	6a 00                	push   $0x0
  pushl $62
80107346:	6a 3e                	push   $0x3e
  jmp alltraps
80107348:	e9 b0 f8 ff ff       	jmp    80106bfd <alltraps>

8010734d <vector63>:
.globl vector63
vector63:
  pushl $0
8010734d:	6a 00                	push   $0x0
  pushl $63
8010734f:	6a 3f                	push   $0x3f
  jmp alltraps
80107351:	e9 a7 f8 ff ff       	jmp    80106bfd <alltraps>

80107356 <vector64>:
.globl vector64
vector64:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $64
80107358:	6a 40                	push   $0x40
  jmp alltraps
8010735a:	e9 9e f8 ff ff       	jmp    80106bfd <alltraps>

8010735f <vector65>:
.globl vector65
vector65:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $65
80107361:	6a 41                	push   $0x41
  jmp alltraps
80107363:	e9 95 f8 ff ff       	jmp    80106bfd <alltraps>

80107368 <vector66>:
.globl vector66
vector66:
  pushl $0
80107368:	6a 00                	push   $0x0
  pushl $66
8010736a:	6a 42                	push   $0x42
  jmp alltraps
8010736c:	e9 8c f8 ff ff       	jmp    80106bfd <alltraps>

80107371 <vector67>:
.globl vector67
vector67:
  pushl $0
80107371:	6a 00                	push   $0x0
  pushl $67
80107373:	6a 43                	push   $0x43
  jmp alltraps
80107375:	e9 83 f8 ff ff       	jmp    80106bfd <alltraps>

8010737a <vector68>:
.globl vector68
vector68:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $68
8010737c:	6a 44                	push   $0x44
  jmp alltraps
8010737e:	e9 7a f8 ff ff       	jmp    80106bfd <alltraps>

80107383 <vector69>:
.globl vector69
vector69:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $69
80107385:	6a 45                	push   $0x45
  jmp alltraps
80107387:	e9 71 f8 ff ff       	jmp    80106bfd <alltraps>

8010738c <vector70>:
.globl vector70
vector70:
  pushl $0
8010738c:	6a 00                	push   $0x0
  pushl $70
8010738e:	6a 46                	push   $0x46
  jmp alltraps
80107390:	e9 68 f8 ff ff       	jmp    80106bfd <alltraps>

80107395 <vector71>:
.globl vector71
vector71:
  pushl $0
80107395:	6a 00                	push   $0x0
  pushl $71
80107397:	6a 47                	push   $0x47
  jmp alltraps
80107399:	e9 5f f8 ff ff       	jmp    80106bfd <alltraps>

8010739e <vector72>:
.globl vector72
vector72:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $72
801073a0:	6a 48                	push   $0x48
  jmp alltraps
801073a2:	e9 56 f8 ff ff       	jmp    80106bfd <alltraps>

801073a7 <vector73>:
.globl vector73
vector73:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $73
801073a9:	6a 49                	push   $0x49
  jmp alltraps
801073ab:	e9 4d f8 ff ff       	jmp    80106bfd <alltraps>

801073b0 <vector74>:
.globl vector74
vector74:
  pushl $0
801073b0:	6a 00                	push   $0x0
  pushl $74
801073b2:	6a 4a                	push   $0x4a
  jmp alltraps
801073b4:	e9 44 f8 ff ff       	jmp    80106bfd <alltraps>

801073b9 <vector75>:
.globl vector75
vector75:
  pushl $0
801073b9:	6a 00                	push   $0x0
  pushl $75
801073bb:	6a 4b                	push   $0x4b
  jmp alltraps
801073bd:	e9 3b f8 ff ff       	jmp    80106bfd <alltraps>

801073c2 <vector76>:
.globl vector76
vector76:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $76
801073c4:	6a 4c                	push   $0x4c
  jmp alltraps
801073c6:	e9 32 f8 ff ff       	jmp    80106bfd <alltraps>

801073cb <vector77>:
.globl vector77
vector77:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $77
801073cd:	6a 4d                	push   $0x4d
  jmp alltraps
801073cf:	e9 29 f8 ff ff       	jmp    80106bfd <alltraps>

801073d4 <vector78>:
.globl vector78
vector78:
  pushl $0
801073d4:	6a 00                	push   $0x0
  pushl $78
801073d6:	6a 4e                	push   $0x4e
  jmp alltraps
801073d8:	e9 20 f8 ff ff       	jmp    80106bfd <alltraps>

801073dd <vector79>:
.globl vector79
vector79:
  pushl $0
801073dd:	6a 00                	push   $0x0
  pushl $79
801073df:	6a 4f                	push   $0x4f
  jmp alltraps
801073e1:	e9 17 f8 ff ff       	jmp    80106bfd <alltraps>

801073e6 <vector80>:
.globl vector80
vector80:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $80
801073e8:	6a 50                	push   $0x50
  jmp alltraps
801073ea:	e9 0e f8 ff ff       	jmp    80106bfd <alltraps>

801073ef <vector81>:
.globl vector81
vector81:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $81
801073f1:	6a 51                	push   $0x51
  jmp alltraps
801073f3:	e9 05 f8 ff ff       	jmp    80106bfd <alltraps>

801073f8 <vector82>:
.globl vector82
vector82:
  pushl $0
801073f8:	6a 00                	push   $0x0
  pushl $82
801073fa:	6a 52                	push   $0x52
  jmp alltraps
801073fc:	e9 fc f7 ff ff       	jmp    80106bfd <alltraps>

80107401 <vector83>:
.globl vector83
vector83:
  pushl $0
80107401:	6a 00                	push   $0x0
  pushl $83
80107403:	6a 53                	push   $0x53
  jmp alltraps
80107405:	e9 f3 f7 ff ff       	jmp    80106bfd <alltraps>

8010740a <vector84>:
.globl vector84
vector84:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $84
8010740c:	6a 54                	push   $0x54
  jmp alltraps
8010740e:	e9 ea f7 ff ff       	jmp    80106bfd <alltraps>

80107413 <vector85>:
.globl vector85
vector85:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $85
80107415:	6a 55                	push   $0x55
  jmp alltraps
80107417:	e9 e1 f7 ff ff       	jmp    80106bfd <alltraps>

8010741c <vector86>:
.globl vector86
vector86:
  pushl $0
8010741c:	6a 00                	push   $0x0
  pushl $86
8010741e:	6a 56                	push   $0x56
  jmp alltraps
80107420:	e9 d8 f7 ff ff       	jmp    80106bfd <alltraps>

80107425 <vector87>:
.globl vector87
vector87:
  pushl $0
80107425:	6a 00                	push   $0x0
  pushl $87
80107427:	6a 57                	push   $0x57
  jmp alltraps
80107429:	e9 cf f7 ff ff       	jmp    80106bfd <alltraps>

8010742e <vector88>:
.globl vector88
vector88:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $88
80107430:	6a 58                	push   $0x58
  jmp alltraps
80107432:	e9 c6 f7 ff ff       	jmp    80106bfd <alltraps>

80107437 <vector89>:
.globl vector89
vector89:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $89
80107439:	6a 59                	push   $0x59
  jmp alltraps
8010743b:	e9 bd f7 ff ff       	jmp    80106bfd <alltraps>

80107440 <vector90>:
.globl vector90
vector90:
  pushl $0
80107440:	6a 00                	push   $0x0
  pushl $90
80107442:	6a 5a                	push   $0x5a
  jmp alltraps
80107444:	e9 b4 f7 ff ff       	jmp    80106bfd <alltraps>

80107449 <vector91>:
.globl vector91
vector91:
  pushl $0
80107449:	6a 00                	push   $0x0
  pushl $91
8010744b:	6a 5b                	push   $0x5b
  jmp alltraps
8010744d:	e9 ab f7 ff ff       	jmp    80106bfd <alltraps>

80107452 <vector92>:
.globl vector92
vector92:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $92
80107454:	6a 5c                	push   $0x5c
  jmp alltraps
80107456:	e9 a2 f7 ff ff       	jmp    80106bfd <alltraps>

8010745b <vector93>:
.globl vector93
vector93:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $93
8010745d:	6a 5d                	push   $0x5d
  jmp alltraps
8010745f:	e9 99 f7 ff ff       	jmp    80106bfd <alltraps>

80107464 <vector94>:
.globl vector94
vector94:
  pushl $0
80107464:	6a 00                	push   $0x0
  pushl $94
80107466:	6a 5e                	push   $0x5e
  jmp alltraps
80107468:	e9 90 f7 ff ff       	jmp    80106bfd <alltraps>

8010746d <vector95>:
.globl vector95
vector95:
  pushl $0
8010746d:	6a 00                	push   $0x0
  pushl $95
8010746f:	6a 5f                	push   $0x5f
  jmp alltraps
80107471:	e9 87 f7 ff ff       	jmp    80106bfd <alltraps>

80107476 <vector96>:
.globl vector96
vector96:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $96
80107478:	6a 60                	push   $0x60
  jmp alltraps
8010747a:	e9 7e f7 ff ff       	jmp    80106bfd <alltraps>

8010747f <vector97>:
.globl vector97
vector97:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $97
80107481:	6a 61                	push   $0x61
  jmp alltraps
80107483:	e9 75 f7 ff ff       	jmp    80106bfd <alltraps>

80107488 <vector98>:
.globl vector98
vector98:
  pushl $0
80107488:	6a 00                	push   $0x0
  pushl $98
8010748a:	6a 62                	push   $0x62
  jmp alltraps
8010748c:	e9 6c f7 ff ff       	jmp    80106bfd <alltraps>

80107491 <vector99>:
.globl vector99
vector99:
  pushl $0
80107491:	6a 00                	push   $0x0
  pushl $99
80107493:	6a 63                	push   $0x63
  jmp alltraps
80107495:	e9 63 f7 ff ff       	jmp    80106bfd <alltraps>

8010749a <vector100>:
.globl vector100
vector100:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $100
8010749c:	6a 64                	push   $0x64
  jmp alltraps
8010749e:	e9 5a f7 ff ff       	jmp    80106bfd <alltraps>

801074a3 <vector101>:
.globl vector101
vector101:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $101
801074a5:	6a 65                	push   $0x65
  jmp alltraps
801074a7:	e9 51 f7 ff ff       	jmp    80106bfd <alltraps>

801074ac <vector102>:
.globl vector102
vector102:
  pushl $0
801074ac:	6a 00                	push   $0x0
  pushl $102
801074ae:	6a 66                	push   $0x66
  jmp alltraps
801074b0:	e9 48 f7 ff ff       	jmp    80106bfd <alltraps>

801074b5 <vector103>:
.globl vector103
vector103:
  pushl $0
801074b5:	6a 00                	push   $0x0
  pushl $103
801074b7:	6a 67                	push   $0x67
  jmp alltraps
801074b9:	e9 3f f7 ff ff       	jmp    80106bfd <alltraps>

801074be <vector104>:
.globl vector104
vector104:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $104
801074c0:	6a 68                	push   $0x68
  jmp alltraps
801074c2:	e9 36 f7 ff ff       	jmp    80106bfd <alltraps>

801074c7 <vector105>:
.globl vector105
vector105:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $105
801074c9:	6a 69                	push   $0x69
  jmp alltraps
801074cb:	e9 2d f7 ff ff       	jmp    80106bfd <alltraps>

801074d0 <vector106>:
.globl vector106
vector106:
  pushl $0
801074d0:	6a 00                	push   $0x0
  pushl $106
801074d2:	6a 6a                	push   $0x6a
  jmp alltraps
801074d4:	e9 24 f7 ff ff       	jmp    80106bfd <alltraps>

801074d9 <vector107>:
.globl vector107
vector107:
  pushl $0
801074d9:	6a 00                	push   $0x0
  pushl $107
801074db:	6a 6b                	push   $0x6b
  jmp alltraps
801074dd:	e9 1b f7 ff ff       	jmp    80106bfd <alltraps>

801074e2 <vector108>:
.globl vector108
vector108:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $108
801074e4:	6a 6c                	push   $0x6c
  jmp alltraps
801074e6:	e9 12 f7 ff ff       	jmp    80106bfd <alltraps>

801074eb <vector109>:
.globl vector109
vector109:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $109
801074ed:	6a 6d                	push   $0x6d
  jmp alltraps
801074ef:	e9 09 f7 ff ff       	jmp    80106bfd <alltraps>

801074f4 <vector110>:
.globl vector110
vector110:
  pushl $0
801074f4:	6a 00                	push   $0x0
  pushl $110
801074f6:	6a 6e                	push   $0x6e
  jmp alltraps
801074f8:	e9 00 f7 ff ff       	jmp    80106bfd <alltraps>

801074fd <vector111>:
.globl vector111
vector111:
  pushl $0
801074fd:	6a 00                	push   $0x0
  pushl $111
801074ff:	6a 6f                	push   $0x6f
  jmp alltraps
80107501:	e9 f7 f6 ff ff       	jmp    80106bfd <alltraps>

80107506 <vector112>:
.globl vector112
vector112:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $112
80107508:	6a 70                	push   $0x70
  jmp alltraps
8010750a:	e9 ee f6 ff ff       	jmp    80106bfd <alltraps>

8010750f <vector113>:
.globl vector113
vector113:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $113
80107511:	6a 71                	push   $0x71
  jmp alltraps
80107513:	e9 e5 f6 ff ff       	jmp    80106bfd <alltraps>

80107518 <vector114>:
.globl vector114
vector114:
  pushl $0
80107518:	6a 00                	push   $0x0
  pushl $114
8010751a:	6a 72                	push   $0x72
  jmp alltraps
8010751c:	e9 dc f6 ff ff       	jmp    80106bfd <alltraps>

80107521 <vector115>:
.globl vector115
vector115:
  pushl $0
80107521:	6a 00                	push   $0x0
  pushl $115
80107523:	6a 73                	push   $0x73
  jmp alltraps
80107525:	e9 d3 f6 ff ff       	jmp    80106bfd <alltraps>

8010752a <vector116>:
.globl vector116
vector116:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $116
8010752c:	6a 74                	push   $0x74
  jmp alltraps
8010752e:	e9 ca f6 ff ff       	jmp    80106bfd <alltraps>

80107533 <vector117>:
.globl vector117
vector117:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $117
80107535:	6a 75                	push   $0x75
  jmp alltraps
80107537:	e9 c1 f6 ff ff       	jmp    80106bfd <alltraps>

8010753c <vector118>:
.globl vector118
vector118:
  pushl $0
8010753c:	6a 00                	push   $0x0
  pushl $118
8010753e:	6a 76                	push   $0x76
  jmp alltraps
80107540:	e9 b8 f6 ff ff       	jmp    80106bfd <alltraps>

80107545 <vector119>:
.globl vector119
vector119:
  pushl $0
80107545:	6a 00                	push   $0x0
  pushl $119
80107547:	6a 77                	push   $0x77
  jmp alltraps
80107549:	e9 af f6 ff ff       	jmp    80106bfd <alltraps>

8010754e <vector120>:
.globl vector120
vector120:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $120
80107550:	6a 78                	push   $0x78
  jmp alltraps
80107552:	e9 a6 f6 ff ff       	jmp    80106bfd <alltraps>

80107557 <vector121>:
.globl vector121
vector121:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $121
80107559:	6a 79                	push   $0x79
  jmp alltraps
8010755b:	e9 9d f6 ff ff       	jmp    80106bfd <alltraps>

80107560 <vector122>:
.globl vector122
vector122:
  pushl $0
80107560:	6a 00                	push   $0x0
  pushl $122
80107562:	6a 7a                	push   $0x7a
  jmp alltraps
80107564:	e9 94 f6 ff ff       	jmp    80106bfd <alltraps>

80107569 <vector123>:
.globl vector123
vector123:
  pushl $0
80107569:	6a 00                	push   $0x0
  pushl $123
8010756b:	6a 7b                	push   $0x7b
  jmp alltraps
8010756d:	e9 8b f6 ff ff       	jmp    80106bfd <alltraps>

80107572 <vector124>:
.globl vector124
vector124:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $124
80107574:	6a 7c                	push   $0x7c
  jmp alltraps
80107576:	e9 82 f6 ff ff       	jmp    80106bfd <alltraps>

8010757b <vector125>:
.globl vector125
vector125:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $125
8010757d:	6a 7d                	push   $0x7d
  jmp alltraps
8010757f:	e9 79 f6 ff ff       	jmp    80106bfd <alltraps>

80107584 <vector126>:
.globl vector126
vector126:
  pushl $0
80107584:	6a 00                	push   $0x0
  pushl $126
80107586:	6a 7e                	push   $0x7e
  jmp alltraps
80107588:	e9 70 f6 ff ff       	jmp    80106bfd <alltraps>

8010758d <vector127>:
.globl vector127
vector127:
  pushl $0
8010758d:	6a 00                	push   $0x0
  pushl $127
8010758f:	6a 7f                	push   $0x7f
  jmp alltraps
80107591:	e9 67 f6 ff ff       	jmp    80106bfd <alltraps>

80107596 <vector128>:
.globl vector128
vector128:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $128
80107598:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010759d:	e9 5b f6 ff ff       	jmp    80106bfd <alltraps>

801075a2 <vector129>:
.globl vector129
vector129:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $129
801075a4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801075a9:	e9 4f f6 ff ff       	jmp    80106bfd <alltraps>

801075ae <vector130>:
.globl vector130
vector130:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $130
801075b0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801075b5:	e9 43 f6 ff ff       	jmp    80106bfd <alltraps>

801075ba <vector131>:
.globl vector131
vector131:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $131
801075bc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801075c1:	e9 37 f6 ff ff       	jmp    80106bfd <alltraps>

801075c6 <vector132>:
.globl vector132
vector132:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $132
801075c8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801075cd:	e9 2b f6 ff ff       	jmp    80106bfd <alltraps>

801075d2 <vector133>:
.globl vector133
vector133:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $133
801075d4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801075d9:	e9 1f f6 ff ff       	jmp    80106bfd <alltraps>

801075de <vector134>:
.globl vector134
vector134:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $134
801075e0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801075e5:	e9 13 f6 ff ff       	jmp    80106bfd <alltraps>

801075ea <vector135>:
.globl vector135
vector135:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $135
801075ec:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801075f1:	e9 07 f6 ff ff       	jmp    80106bfd <alltraps>

801075f6 <vector136>:
.globl vector136
vector136:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $136
801075f8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801075fd:	e9 fb f5 ff ff       	jmp    80106bfd <alltraps>

80107602 <vector137>:
.globl vector137
vector137:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $137
80107604:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107609:	e9 ef f5 ff ff       	jmp    80106bfd <alltraps>

8010760e <vector138>:
.globl vector138
vector138:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $138
80107610:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107615:	e9 e3 f5 ff ff       	jmp    80106bfd <alltraps>

8010761a <vector139>:
.globl vector139
vector139:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $139
8010761c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107621:	e9 d7 f5 ff ff       	jmp    80106bfd <alltraps>

80107626 <vector140>:
.globl vector140
vector140:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $140
80107628:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010762d:	e9 cb f5 ff ff       	jmp    80106bfd <alltraps>

80107632 <vector141>:
.globl vector141
vector141:
  pushl $0
80107632:	6a 00                	push   $0x0
  pushl $141
80107634:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107639:	e9 bf f5 ff ff       	jmp    80106bfd <alltraps>

8010763e <vector142>:
.globl vector142
vector142:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $142
80107640:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107645:	e9 b3 f5 ff ff       	jmp    80106bfd <alltraps>

8010764a <vector143>:
.globl vector143
vector143:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $143
8010764c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107651:	e9 a7 f5 ff ff       	jmp    80106bfd <alltraps>

80107656 <vector144>:
.globl vector144
vector144:
  pushl $0
80107656:	6a 00                	push   $0x0
  pushl $144
80107658:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010765d:	e9 9b f5 ff ff       	jmp    80106bfd <alltraps>

80107662 <vector145>:
.globl vector145
vector145:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $145
80107664:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107669:	e9 8f f5 ff ff       	jmp    80106bfd <alltraps>

8010766e <vector146>:
.globl vector146
vector146:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $146
80107670:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107675:	e9 83 f5 ff ff       	jmp    80106bfd <alltraps>

8010767a <vector147>:
.globl vector147
vector147:
  pushl $0
8010767a:	6a 00                	push   $0x0
  pushl $147
8010767c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107681:	e9 77 f5 ff ff       	jmp    80106bfd <alltraps>

80107686 <vector148>:
.globl vector148
vector148:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $148
80107688:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010768d:	e9 6b f5 ff ff       	jmp    80106bfd <alltraps>

80107692 <vector149>:
.globl vector149
vector149:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $149
80107694:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107699:	e9 5f f5 ff ff       	jmp    80106bfd <alltraps>

8010769e <vector150>:
.globl vector150
vector150:
  pushl $0
8010769e:	6a 00                	push   $0x0
  pushl $150
801076a0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801076a5:	e9 53 f5 ff ff       	jmp    80106bfd <alltraps>

801076aa <vector151>:
.globl vector151
vector151:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $151
801076ac:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801076b1:	e9 47 f5 ff ff       	jmp    80106bfd <alltraps>

801076b6 <vector152>:
.globl vector152
vector152:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $152
801076b8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801076bd:	e9 3b f5 ff ff       	jmp    80106bfd <alltraps>

801076c2 <vector153>:
.globl vector153
vector153:
  pushl $0
801076c2:	6a 00                	push   $0x0
  pushl $153
801076c4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801076c9:	e9 2f f5 ff ff       	jmp    80106bfd <alltraps>

801076ce <vector154>:
.globl vector154
vector154:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $154
801076d0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801076d5:	e9 23 f5 ff ff       	jmp    80106bfd <alltraps>

801076da <vector155>:
.globl vector155
vector155:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $155
801076dc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801076e1:	e9 17 f5 ff ff       	jmp    80106bfd <alltraps>

801076e6 <vector156>:
.globl vector156
vector156:
  pushl $0
801076e6:	6a 00                	push   $0x0
  pushl $156
801076e8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801076ed:	e9 0b f5 ff ff       	jmp    80106bfd <alltraps>

801076f2 <vector157>:
.globl vector157
vector157:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $157
801076f4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801076f9:	e9 ff f4 ff ff       	jmp    80106bfd <alltraps>

801076fe <vector158>:
.globl vector158
vector158:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $158
80107700:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107705:	e9 f3 f4 ff ff       	jmp    80106bfd <alltraps>

8010770a <vector159>:
.globl vector159
vector159:
  pushl $0
8010770a:	6a 00                	push   $0x0
  pushl $159
8010770c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107711:	e9 e7 f4 ff ff       	jmp    80106bfd <alltraps>

80107716 <vector160>:
.globl vector160
vector160:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $160
80107718:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010771d:	e9 db f4 ff ff       	jmp    80106bfd <alltraps>

80107722 <vector161>:
.globl vector161
vector161:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $161
80107724:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107729:	e9 cf f4 ff ff       	jmp    80106bfd <alltraps>

8010772e <vector162>:
.globl vector162
vector162:
  pushl $0
8010772e:	6a 00                	push   $0x0
  pushl $162
80107730:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107735:	e9 c3 f4 ff ff       	jmp    80106bfd <alltraps>

8010773a <vector163>:
.globl vector163
vector163:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $163
8010773c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107741:	e9 b7 f4 ff ff       	jmp    80106bfd <alltraps>

80107746 <vector164>:
.globl vector164
vector164:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $164
80107748:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010774d:	e9 ab f4 ff ff       	jmp    80106bfd <alltraps>

80107752 <vector165>:
.globl vector165
vector165:
  pushl $0
80107752:	6a 00                	push   $0x0
  pushl $165
80107754:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107759:	e9 9f f4 ff ff       	jmp    80106bfd <alltraps>

8010775e <vector166>:
.globl vector166
vector166:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $166
80107760:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107765:	e9 93 f4 ff ff       	jmp    80106bfd <alltraps>

8010776a <vector167>:
.globl vector167
vector167:
  pushl $0
8010776a:	6a 00                	push   $0x0
  pushl $167
8010776c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107771:	e9 87 f4 ff ff       	jmp    80106bfd <alltraps>

80107776 <vector168>:
.globl vector168
vector168:
  pushl $0
80107776:	6a 00                	push   $0x0
  pushl $168
80107778:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010777d:	e9 7b f4 ff ff       	jmp    80106bfd <alltraps>

80107782 <vector169>:
.globl vector169
vector169:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $169
80107784:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107789:	e9 6f f4 ff ff       	jmp    80106bfd <alltraps>

8010778e <vector170>:
.globl vector170
vector170:
  pushl $0
8010778e:	6a 00                	push   $0x0
  pushl $170
80107790:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107795:	e9 63 f4 ff ff       	jmp    80106bfd <alltraps>

8010779a <vector171>:
.globl vector171
vector171:
  pushl $0
8010779a:	6a 00                	push   $0x0
  pushl $171
8010779c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801077a1:	e9 57 f4 ff ff       	jmp    80106bfd <alltraps>

801077a6 <vector172>:
.globl vector172
vector172:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $172
801077a8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801077ad:	e9 4b f4 ff ff       	jmp    80106bfd <alltraps>

801077b2 <vector173>:
.globl vector173
vector173:
  pushl $0
801077b2:	6a 00                	push   $0x0
  pushl $173
801077b4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801077b9:	e9 3f f4 ff ff       	jmp    80106bfd <alltraps>

801077be <vector174>:
.globl vector174
vector174:
  pushl $0
801077be:	6a 00                	push   $0x0
  pushl $174
801077c0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801077c5:	e9 33 f4 ff ff       	jmp    80106bfd <alltraps>

801077ca <vector175>:
.globl vector175
vector175:
  pushl $0
801077ca:	6a 00                	push   $0x0
  pushl $175
801077cc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801077d1:	e9 27 f4 ff ff       	jmp    80106bfd <alltraps>

801077d6 <vector176>:
.globl vector176
vector176:
  pushl $0
801077d6:	6a 00                	push   $0x0
  pushl $176
801077d8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801077dd:	e9 1b f4 ff ff       	jmp    80106bfd <alltraps>

801077e2 <vector177>:
.globl vector177
vector177:
  pushl $0
801077e2:	6a 00                	push   $0x0
  pushl $177
801077e4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801077e9:	e9 0f f4 ff ff       	jmp    80106bfd <alltraps>

801077ee <vector178>:
.globl vector178
vector178:
  pushl $0
801077ee:	6a 00                	push   $0x0
  pushl $178
801077f0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801077f5:	e9 03 f4 ff ff       	jmp    80106bfd <alltraps>

801077fa <vector179>:
.globl vector179
vector179:
  pushl $0
801077fa:	6a 00                	push   $0x0
  pushl $179
801077fc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107801:	e9 f7 f3 ff ff       	jmp    80106bfd <alltraps>

80107806 <vector180>:
.globl vector180
vector180:
  pushl $0
80107806:	6a 00                	push   $0x0
  pushl $180
80107808:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010780d:	e9 eb f3 ff ff       	jmp    80106bfd <alltraps>

80107812 <vector181>:
.globl vector181
vector181:
  pushl $0
80107812:	6a 00                	push   $0x0
  pushl $181
80107814:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107819:	e9 df f3 ff ff       	jmp    80106bfd <alltraps>

8010781e <vector182>:
.globl vector182
vector182:
  pushl $0
8010781e:	6a 00                	push   $0x0
  pushl $182
80107820:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107825:	e9 d3 f3 ff ff       	jmp    80106bfd <alltraps>

8010782a <vector183>:
.globl vector183
vector183:
  pushl $0
8010782a:	6a 00                	push   $0x0
  pushl $183
8010782c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107831:	e9 c7 f3 ff ff       	jmp    80106bfd <alltraps>

80107836 <vector184>:
.globl vector184
vector184:
  pushl $0
80107836:	6a 00                	push   $0x0
  pushl $184
80107838:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010783d:	e9 bb f3 ff ff       	jmp    80106bfd <alltraps>

80107842 <vector185>:
.globl vector185
vector185:
  pushl $0
80107842:	6a 00                	push   $0x0
  pushl $185
80107844:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107849:	e9 af f3 ff ff       	jmp    80106bfd <alltraps>

8010784e <vector186>:
.globl vector186
vector186:
  pushl $0
8010784e:	6a 00                	push   $0x0
  pushl $186
80107850:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107855:	e9 a3 f3 ff ff       	jmp    80106bfd <alltraps>

8010785a <vector187>:
.globl vector187
vector187:
  pushl $0
8010785a:	6a 00                	push   $0x0
  pushl $187
8010785c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107861:	e9 97 f3 ff ff       	jmp    80106bfd <alltraps>

80107866 <vector188>:
.globl vector188
vector188:
  pushl $0
80107866:	6a 00                	push   $0x0
  pushl $188
80107868:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010786d:	e9 8b f3 ff ff       	jmp    80106bfd <alltraps>

80107872 <vector189>:
.globl vector189
vector189:
  pushl $0
80107872:	6a 00                	push   $0x0
  pushl $189
80107874:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107879:	e9 7f f3 ff ff       	jmp    80106bfd <alltraps>

8010787e <vector190>:
.globl vector190
vector190:
  pushl $0
8010787e:	6a 00                	push   $0x0
  pushl $190
80107880:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107885:	e9 73 f3 ff ff       	jmp    80106bfd <alltraps>

8010788a <vector191>:
.globl vector191
vector191:
  pushl $0
8010788a:	6a 00                	push   $0x0
  pushl $191
8010788c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107891:	e9 67 f3 ff ff       	jmp    80106bfd <alltraps>

80107896 <vector192>:
.globl vector192
vector192:
  pushl $0
80107896:	6a 00                	push   $0x0
  pushl $192
80107898:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010789d:	e9 5b f3 ff ff       	jmp    80106bfd <alltraps>

801078a2 <vector193>:
.globl vector193
vector193:
  pushl $0
801078a2:	6a 00                	push   $0x0
  pushl $193
801078a4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801078a9:	e9 4f f3 ff ff       	jmp    80106bfd <alltraps>

801078ae <vector194>:
.globl vector194
vector194:
  pushl $0
801078ae:	6a 00                	push   $0x0
  pushl $194
801078b0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801078b5:	e9 43 f3 ff ff       	jmp    80106bfd <alltraps>

801078ba <vector195>:
.globl vector195
vector195:
  pushl $0
801078ba:	6a 00                	push   $0x0
  pushl $195
801078bc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801078c1:	e9 37 f3 ff ff       	jmp    80106bfd <alltraps>

801078c6 <vector196>:
.globl vector196
vector196:
  pushl $0
801078c6:	6a 00                	push   $0x0
  pushl $196
801078c8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801078cd:	e9 2b f3 ff ff       	jmp    80106bfd <alltraps>

801078d2 <vector197>:
.globl vector197
vector197:
  pushl $0
801078d2:	6a 00                	push   $0x0
  pushl $197
801078d4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801078d9:	e9 1f f3 ff ff       	jmp    80106bfd <alltraps>

801078de <vector198>:
.globl vector198
vector198:
  pushl $0
801078de:	6a 00                	push   $0x0
  pushl $198
801078e0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801078e5:	e9 13 f3 ff ff       	jmp    80106bfd <alltraps>

801078ea <vector199>:
.globl vector199
vector199:
  pushl $0
801078ea:	6a 00                	push   $0x0
  pushl $199
801078ec:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801078f1:	e9 07 f3 ff ff       	jmp    80106bfd <alltraps>

801078f6 <vector200>:
.globl vector200
vector200:
  pushl $0
801078f6:	6a 00                	push   $0x0
  pushl $200
801078f8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801078fd:	e9 fb f2 ff ff       	jmp    80106bfd <alltraps>

80107902 <vector201>:
.globl vector201
vector201:
  pushl $0
80107902:	6a 00                	push   $0x0
  pushl $201
80107904:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107909:	e9 ef f2 ff ff       	jmp    80106bfd <alltraps>

8010790e <vector202>:
.globl vector202
vector202:
  pushl $0
8010790e:	6a 00                	push   $0x0
  pushl $202
80107910:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107915:	e9 e3 f2 ff ff       	jmp    80106bfd <alltraps>

8010791a <vector203>:
.globl vector203
vector203:
  pushl $0
8010791a:	6a 00                	push   $0x0
  pushl $203
8010791c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107921:	e9 d7 f2 ff ff       	jmp    80106bfd <alltraps>

80107926 <vector204>:
.globl vector204
vector204:
  pushl $0
80107926:	6a 00                	push   $0x0
  pushl $204
80107928:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010792d:	e9 cb f2 ff ff       	jmp    80106bfd <alltraps>

80107932 <vector205>:
.globl vector205
vector205:
  pushl $0
80107932:	6a 00                	push   $0x0
  pushl $205
80107934:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107939:	e9 bf f2 ff ff       	jmp    80106bfd <alltraps>

8010793e <vector206>:
.globl vector206
vector206:
  pushl $0
8010793e:	6a 00                	push   $0x0
  pushl $206
80107940:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107945:	e9 b3 f2 ff ff       	jmp    80106bfd <alltraps>

8010794a <vector207>:
.globl vector207
vector207:
  pushl $0
8010794a:	6a 00                	push   $0x0
  pushl $207
8010794c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107951:	e9 a7 f2 ff ff       	jmp    80106bfd <alltraps>

80107956 <vector208>:
.globl vector208
vector208:
  pushl $0
80107956:	6a 00                	push   $0x0
  pushl $208
80107958:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010795d:	e9 9b f2 ff ff       	jmp    80106bfd <alltraps>

80107962 <vector209>:
.globl vector209
vector209:
  pushl $0
80107962:	6a 00                	push   $0x0
  pushl $209
80107964:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107969:	e9 8f f2 ff ff       	jmp    80106bfd <alltraps>

8010796e <vector210>:
.globl vector210
vector210:
  pushl $0
8010796e:	6a 00                	push   $0x0
  pushl $210
80107970:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107975:	e9 83 f2 ff ff       	jmp    80106bfd <alltraps>

8010797a <vector211>:
.globl vector211
vector211:
  pushl $0
8010797a:	6a 00                	push   $0x0
  pushl $211
8010797c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107981:	e9 77 f2 ff ff       	jmp    80106bfd <alltraps>

80107986 <vector212>:
.globl vector212
vector212:
  pushl $0
80107986:	6a 00                	push   $0x0
  pushl $212
80107988:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010798d:	e9 6b f2 ff ff       	jmp    80106bfd <alltraps>

80107992 <vector213>:
.globl vector213
vector213:
  pushl $0
80107992:	6a 00                	push   $0x0
  pushl $213
80107994:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107999:	e9 5f f2 ff ff       	jmp    80106bfd <alltraps>

8010799e <vector214>:
.globl vector214
vector214:
  pushl $0
8010799e:	6a 00                	push   $0x0
  pushl $214
801079a0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801079a5:	e9 53 f2 ff ff       	jmp    80106bfd <alltraps>

801079aa <vector215>:
.globl vector215
vector215:
  pushl $0
801079aa:	6a 00                	push   $0x0
  pushl $215
801079ac:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801079b1:	e9 47 f2 ff ff       	jmp    80106bfd <alltraps>

801079b6 <vector216>:
.globl vector216
vector216:
  pushl $0
801079b6:	6a 00                	push   $0x0
  pushl $216
801079b8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801079bd:	e9 3b f2 ff ff       	jmp    80106bfd <alltraps>

801079c2 <vector217>:
.globl vector217
vector217:
  pushl $0
801079c2:	6a 00                	push   $0x0
  pushl $217
801079c4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801079c9:	e9 2f f2 ff ff       	jmp    80106bfd <alltraps>

801079ce <vector218>:
.globl vector218
vector218:
  pushl $0
801079ce:	6a 00                	push   $0x0
  pushl $218
801079d0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801079d5:	e9 23 f2 ff ff       	jmp    80106bfd <alltraps>

801079da <vector219>:
.globl vector219
vector219:
  pushl $0
801079da:	6a 00                	push   $0x0
  pushl $219
801079dc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801079e1:	e9 17 f2 ff ff       	jmp    80106bfd <alltraps>

801079e6 <vector220>:
.globl vector220
vector220:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $220
801079e8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801079ed:	e9 0b f2 ff ff       	jmp    80106bfd <alltraps>

801079f2 <vector221>:
.globl vector221
vector221:
  pushl $0
801079f2:	6a 00                	push   $0x0
  pushl $221
801079f4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801079f9:	e9 ff f1 ff ff       	jmp    80106bfd <alltraps>

801079fe <vector222>:
.globl vector222
vector222:
  pushl $0
801079fe:	6a 00                	push   $0x0
  pushl $222
80107a00:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a05:	e9 f3 f1 ff ff       	jmp    80106bfd <alltraps>

80107a0a <vector223>:
.globl vector223
vector223:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $223
80107a0c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a11:	e9 e7 f1 ff ff       	jmp    80106bfd <alltraps>

80107a16 <vector224>:
.globl vector224
vector224:
  pushl $0
80107a16:	6a 00                	push   $0x0
  pushl $224
80107a18:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107a1d:	e9 db f1 ff ff       	jmp    80106bfd <alltraps>

80107a22 <vector225>:
.globl vector225
vector225:
  pushl $0
80107a22:	6a 00                	push   $0x0
  pushl $225
80107a24:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107a29:	e9 cf f1 ff ff       	jmp    80106bfd <alltraps>

80107a2e <vector226>:
.globl vector226
vector226:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $226
80107a30:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107a35:	e9 c3 f1 ff ff       	jmp    80106bfd <alltraps>

80107a3a <vector227>:
.globl vector227
vector227:
  pushl $0
80107a3a:	6a 00                	push   $0x0
  pushl $227
80107a3c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107a41:	e9 b7 f1 ff ff       	jmp    80106bfd <alltraps>

80107a46 <vector228>:
.globl vector228
vector228:
  pushl $0
80107a46:	6a 00                	push   $0x0
  pushl $228
80107a48:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a4d:	e9 ab f1 ff ff       	jmp    80106bfd <alltraps>

80107a52 <vector229>:
.globl vector229
vector229:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $229
80107a54:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a59:	e9 9f f1 ff ff       	jmp    80106bfd <alltraps>

80107a5e <vector230>:
.globl vector230
vector230:
  pushl $0
80107a5e:	6a 00                	push   $0x0
  pushl $230
80107a60:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107a65:	e9 93 f1 ff ff       	jmp    80106bfd <alltraps>

80107a6a <vector231>:
.globl vector231
vector231:
  pushl $0
80107a6a:	6a 00                	push   $0x0
  pushl $231
80107a6c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107a71:	e9 87 f1 ff ff       	jmp    80106bfd <alltraps>

80107a76 <vector232>:
.globl vector232
vector232:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $232
80107a78:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107a7d:	e9 7b f1 ff ff       	jmp    80106bfd <alltraps>

80107a82 <vector233>:
.globl vector233
vector233:
  pushl $0
80107a82:	6a 00                	push   $0x0
  pushl $233
80107a84:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107a89:	e9 6f f1 ff ff       	jmp    80106bfd <alltraps>

80107a8e <vector234>:
.globl vector234
vector234:
  pushl $0
80107a8e:	6a 00                	push   $0x0
  pushl $234
80107a90:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107a95:	e9 63 f1 ff ff       	jmp    80106bfd <alltraps>

80107a9a <vector235>:
.globl vector235
vector235:
  pushl $0
80107a9a:	6a 00                	push   $0x0
  pushl $235
80107a9c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107aa1:	e9 57 f1 ff ff       	jmp    80106bfd <alltraps>

80107aa6 <vector236>:
.globl vector236
vector236:
  pushl $0
80107aa6:	6a 00                	push   $0x0
  pushl $236
80107aa8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107aad:	e9 4b f1 ff ff       	jmp    80106bfd <alltraps>

80107ab2 <vector237>:
.globl vector237
vector237:
  pushl $0
80107ab2:	6a 00                	push   $0x0
  pushl $237
80107ab4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107ab9:	e9 3f f1 ff ff       	jmp    80106bfd <alltraps>

80107abe <vector238>:
.globl vector238
vector238:
  pushl $0
80107abe:	6a 00                	push   $0x0
  pushl $238
80107ac0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107ac5:	e9 33 f1 ff ff       	jmp    80106bfd <alltraps>

80107aca <vector239>:
.globl vector239
vector239:
  pushl $0
80107aca:	6a 00                	push   $0x0
  pushl $239
80107acc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107ad1:	e9 27 f1 ff ff       	jmp    80106bfd <alltraps>

80107ad6 <vector240>:
.globl vector240
vector240:
  pushl $0
80107ad6:	6a 00                	push   $0x0
  pushl $240
80107ad8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107add:	e9 1b f1 ff ff       	jmp    80106bfd <alltraps>

80107ae2 <vector241>:
.globl vector241
vector241:
  pushl $0
80107ae2:	6a 00                	push   $0x0
  pushl $241
80107ae4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107ae9:	e9 0f f1 ff ff       	jmp    80106bfd <alltraps>

80107aee <vector242>:
.globl vector242
vector242:
  pushl $0
80107aee:	6a 00                	push   $0x0
  pushl $242
80107af0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107af5:	e9 03 f1 ff ff       	jmp    80106bfd <alltraps>

80107afa <vector243>:
.globl vector243
vector243:
  pushl $0
80107afa:	6a 00                	push   $0x0
  pushl $243
80107afc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b01:	e9 f7 f0 ff ff       	jmp    80106bfd <alltraps>

80107b06 <vector244>:
.globl vector244
vector244:
  pushl $0
80107b06:	6a 00                	push   $0x0
  pushl $244
80107b08:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b0d:	e9 eb f0 ff ff       	jmp    80106bfd <alltraps>

80107b12 <vector245>:
.globl vector245
vector245:
  pushl $0
80107b12:	6a 00                	push   $0x0
  pushl $245
80107b14:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b19:	e9 df f0 ff ff       	jmp    80106bfd <alltraps>

80107b1e <vector246>:
.globl vector246
vector246:
  pushl $0
80107b1e:	6a 00                	push   $0x0
  pushl $246
80107b20:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107b25:	e9 d3 f0 ff ff       	jmp    80106bfd <alltraps>

80107b2a <vector247>:
.globl vector247
vector247:
  pushl $0
80107b2a:	6a 00                	push   $0x0
  pushl $247
80107b2c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107b31:	e9 c7 f0 ff ff       	jmp    80106bfd <alltraps>

80107b36 <vector248>:
.globl vector248
vector248:
  pushl $0
80107b36:	6a 00                	push   $0x0
  pushl $248
80107b38:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107b3d:	e9 bb f0 ff ff       	jmp    80106bfd <alltraps>

80107b42 <vector249>:
.globl vector249
vector249:
  pushl $0
80107b42:	6a 00                	push   $0x0
  pushl $249
80107b44:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107b49:	e9 af f0 ff ff       	jmp    80106bfd <alltraps>

80107b4e <vector250>:
.globl vector250
vector250:
  pushl $0
80107b4e:	6a 00                	push   $0x0
  pushl $250
80107b50:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b55:	e9 a3 f0 ff ff       	jmp    80106bfd <alltraps>

80107b5a <vector251>:
.globl vector251
vector251:
  pushl $0
80107b5a:	6a 00                	push   $0x0
  pushl $251
80107b5c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107b61:	e9 97 f0 ff ff       	jmp    80106bfd <alltraps>

80107b66 <vector252>:
.globl vector252
vector252:
  pushl $0
80107b66:	6a 00                	push   $0x0
  pushl $252
80107b68:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107b6d:	e9 8b f0 ff ff       	jmp    80106bfd <alltraps>

80107b72 <vector253>:
.globl vector253
vector253:
  pushl $0
80107b72:	6a 00                	push   $0x0
  pushl $253
80107b74:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107b79:	e9 7f f0 ff ff       	jmp    80106bfd <alltraps>

80107b7e <vector254>:
.globl vector254
vector254:
  pushl $0
80107b7e:	6a 00                	push   $0x0
  pushl $254
80107b80:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107b85:	e9 73 f0 ff ff       	jmp    80106bfd <alltraps>

80107b8a <vector255>:
.globl vector255
vector255:
  pushl $0
80107b8a:	6a 00                	push   $0x0
  pushl $255
80107b8c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107b91:	e9 67 f0 ff ff       	jmp    80106bfd <alltraps>
80107b96:	66 90                	xchg   %ax,%ax
80107b98:	66 90                	xchg   %ax,%ax
80107b9a:	66 90                	xchg   %ax,%ax
80107b9c:	66 90                	xchg   %ax,%ax
80107b9e:	66 90                	xchg   %ax,%ax

80107ba0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	83 ec 28             	sub    $0x28,%esp
80107ba6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107ba9:	89 d3                	mov    %edx,%ebx
80107bab:	c1 eb 16             	shr    $0x16,%ebx
{
80107bae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  pde = &pgdir[PDX(va)];
80107bb1:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107bb4:	89 7d fc             	mov    %edi,-0x4(%ebp)
80107bb7:	89 d7                	mov    %edx,%edi
  if(*pde & PTE_P){
80107bb9:	8b 06                	mov    (%esi),%eax
80107bbb:	a8 01                	test   $0x1,%al
80107bbd:	74 29                	je     80107be8 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bc4:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107bca:	c1 ef 0a             	shr    $0xa,%edi
}
80107bcd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  return &pgtab[PTX(va)];
80107bd0:	89 fa                	mov    %edi,%edx
}
80107bd2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  return &pgtab[PTX(va)];
80107bd5:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107bdb:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107bde:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80107be1:	89 ec                	mov    %ebp,%esp
80107be3:	5d                   	pop    %ebp
80107be4:	c3                   	ret    
80107be5:	8d 76 00             	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107be8:	85 c9                	test   %ecx,%ecx
80107bea:	74 34                	je     80107c20 <walkpgdir+0x80>
80107bec:	e8 6f aa ff ff       	call   80102660 <kalloc>
80107bf1:	85 c0                	test   %eax,%eax
80107bf3:	89 c3                	mov    %eax,%ebx
80107bf5:	74 29                	je     80107c20 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
80107bf7:	b8 00 10 00 00       	mov    $0x1000,%eax
80107bfc:	31 d2                	xor    %edx,%edx
80107bfe:	89 44 24 08          	mov    %eax,0x8(%esp)
80107c02:	89 54 24 04          	mov    %edx,0x4(%esp)
80107c06:	89 1c 24             	mov    %ebx,(%esp)
80107c09:	e8 42 dd ff ff       	call   80105950 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107c0e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c14:	83 c8 07             	or     $0x7,%eax
80107c17:	89 06                	mov    %eax,(%esi)
80107c19:	eb af                	jmp    80107bca <walkpgdir+0x2a>
80107c1b:	90                   	nop
80107c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80107c20:	8b 5d f4             	mov    -0xc(%ebp),%ebx
      return 0;
80107c23:	31 c0                	xor    %eax,%eax
}
80107c25:	8b 75 f8             	mov    -0x8(%ebp),%esi
80107c28:	8b 7d fc             	mov    -0x4(%ebp),%edi
80107c2b:	89 ec                	mov    %ebp,%esp
80107c2d:	5d                   	pop    %ebp
80107c2e:	c3                   	ret    
80107c2f:	90                   	nop

80107c30 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	57                   	push   %edi
80107c34:	56                   	push   %esi
80107c35:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107c36:	89 d3                	mov    %edx,%ebx
{
80107c38:	83 ec 2c             	sub    $0x2c,%esp
  a = (char*)PGROUNDDOWN((uint)va);
80107c3b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107c41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107c44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107c48:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c50:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107c53:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c56:	29 df                	sub    %ebx,%edi
80107c58:	83 c8 01             	or     $0x1,%eax
80107c5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107c5e:	eb 17                	jmp    80107c77 <mappages+0x47>
    if(*pte & PTE_P)
80107c60:	f6 00 01             	testb  $0x1,(%eax)
80107c63:	75 45                	jne    80107caa <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107c65:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107c68:	09 d6                	or     %edx,%esi
    if(a == last)
80107c6a:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80107c6d:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107c6f:	74 2f                	je     80107ca0 <mappages+0x70>
      break;
    a += PGSIZE;
80107c71:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c7a:	b9 01 00 00 00       	mov    $0x1,%ecx
80107c7f:	89 da                	mov    %ebx,%edx
80107c81:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107c84:	e8 17 ff ff ff       	call   80107ba0 <walkpgdir>
80107c89:	85 c0                	test   %eax,%eax
80107c8b:	75 d3                	jne    80107c60 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107c8d:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80107c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c95:	5b                   	pop    %ebx
80107c96:	5e                   	pop    %esi
80107c97:	5f                   	pop    %edi
80107c98:	5d                   	pop    %ebp
80107c99:	c3                   	ret    
80107c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ca0:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80107ca3:	31 c0                	xor    %eax,%eax
}
80107ca5:	5b                   	pop    %ebx
80107ca6:	5e                   	pop    %esi
80107ca7:	5f                   	pop    %edi
80107ca8:	5d                   	pop    %ebp
80107ca9:	c3                   	ret    
      panic("remap");
80107caa:	c7 04 24 ac 90 10 80 	movl   $0x801090ac,(%esp)
80107cb1:	e8 ba 86 ff ff       	call   80100370 <panic>
80107cb6:	8d 76 00             	lea    0x0(%esi),%esi
80107cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107cc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	57                   	push   %edi
80107cc4:	89 c7                	mov    %eax,%edi
80107cc6:	56                   	push   %esi
80107cc7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107cc8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107cce:	83 ec 2c             	sub    $0x2c,%esp
  a = PGROUNDUP(newsz);
80107cd1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107cd7:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107cd9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107cdc:	73 62                	jae    80107d40 <deallocuvm.part.0+0x80>
80107cde:	89 d6                	mov    %edx,%esi
80107ce0:	eb 39                	jmp    80107d1b <deallocuvm.part.0+0x5b>
80107ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107ce8:	8b 10                	mov    (%eax),%edx
80107cea:	f6 c2 01             	test   $0x1,%dl
80107ced:	74 22                	je     80107d11 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107cef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107cf5:	74 54                	je     80107d4b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80107cf7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80107cfd:	89 14 24             	mov    %edx,(%esp)
80107d00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d03:	e8 88 a7 ff ff       	call   80102490 <kfree>
      *pte = 0;
80107d08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107d11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d17:	39 f3                	cmp    %esi,%ebx
80107d19:	73 25                	jae    80107d40 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107d1b:	31 c9                	xor    %ecx,%ecx
80107d1d:	89 da                	mov    %ebx,%edx
80107d1f:	89 f8                	mov    %edi,%eax
80107d21:	e8 7a fe ff ff       	call   80107ba0 <walkpgdir>
    if(!pte)
80107d26:	85 c0                	test   %eax,%eax
80107d28:	75 be                	jne    80107ce8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107d2a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107d30:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107d36:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d3c:	39 f3                	cmp    %esi,%ebx
80107d3e:	72 db                	jb     80107d1b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80107d40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d43:	83 c4 2c             	add    $0x2c,%esp
80107d46:	5b                   	pop    %ebx
80107d47:	5e                   	pop    %esi
80107d48:	5f                   	pop    %edi
80107d49:	5d                   	pop    %ebp
80107d4a:	c3                   	ret    
        panic("kfree");
80107d4b:	c7 04 24 6a 87 10 80 	movl   $0x8010876a,(%esp)
80107d52:	e8 19 86 ff ff       	call   80100370 <panic>
80107d57:	89 f6                	mov    %esi,%esi
80107d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d60 <seginit>:
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107d66:	e8 35 bd ff ff       	call   80103aa0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d6b:	b9 00 9a cf 00       	mov    $0xcf9a00,%ecx
  pd[0] = size-1;
80107d70:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
80107d76:	8d 14 80             	lea    (%eax,%eax,4),%edx
80107d79:	8d 04 50             	lea    (%eax,%edx,2),%eax
80107d7c:	ba ff ff 00 00       	mov    $0xffff,%edx
80107d81:	c1 e0 04             	shl    $0x4,%eax
80107d84:	89 90 58 48 11 80    	mov    %edx,-0x7feeb7a8(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d8a:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d8f:	89 88 5c 48 11 80    	mov    %ecx,-0x7feeb7a4(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d95:	b9 00 92 cf 00       	mov    $0xcf9200,%ecx
80107d9a:	89 90 60 48 11 80    	mov    %edx,-0x7feeb7a0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107da0:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107da5:	89 88 64 48 11 80    	mov    %ecx,-0x7feeb79c(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107dab:	b9 00 fa cf 00       	mov    $0xcffa00,%ecx
80107db0:	89 90 68 48 11 80    	mov    %edx,-0x7feeb798(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107db6:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107dbb:	89 88 6c 48 11 80    	mov    %ecx,-0x7feeb794(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107dc1:	b9 00 f2 cf 00       	mov    $0xcff200,%ecx
80107dc6:	89 90 70 48 11 80    	mov    %edx,-0x7feeb790(%eax)
80107dcc:	89 88 74 48 11 80    	mov    %ecx,-0x7feeb78c(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107dd2:	05 50 48 11 80       	add    $0x80114850,%eax
  pd[1] = (uint)p;
80107dd7:	0f b7 d0             	movzwl %ax,%edx
  pd[2] = (uint)p >> 16;
80107dda:	c1 e8 10             	shr    $0x10,%eax
  pd[1] = (uint)p;
80107ddd:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107de1:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107de5:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107de8:	0f 01 10             	lgdtl  (%eax)
}
80107deb:	c9                   	leave  
80107dec:	c3                   	ret    
80107ded:	8d 76 00             	lea    0x0(%esi),%esi

80107df0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107df0:	a1 04 7b 11 80       	mov    0x80117b04,%eax
{
80107df5:	55                   	push   %ebp
80107df6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107df8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107dfd:	0f 22 d8             	mov    %eax,%cr3
}
80107e00:	5d                   	pop    %ebp
80107e01:	c3                   	ret    
80107e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e10 <switchuvm>:
{
80107e10:	55                   	push   %ebp
80107e11:	89 e5                	mov    %esp,%ebp
80107e13:	57                   	push   %edi
80107e14:	56                   	push   %esi
80107e15:	53                   	push   %ebx
80107e16:	83 ec 2c             	sub    $0x2c,%esp
80107e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107e1c:	85 db                	test   %ebx,%ebx
80107e1e:	0f 84 c5 00 00 00    	je     80107ee9 <switchuvm+0xd9>
  if(p->kstack == 0)
80107e24:	8b 7b 08             	mov    0x8(%ebx),%edi
80107e27:	85 ff                	test   %edi,%edi
80107e29:	0f 84 d2 00 00 00    	je     80107f01 <switchuvm+0xf1>
  if(p->pgdir == 0)
80107e2f:	8b 73 04             	mov    0x4(%ebx),%esi
80107e32:	85 f6                	test   %esi,%esi
80107e34:	0f 84 bb 00 00 00    	je     80107ef5 <switchuvm+0xe5>
  pushcli();
80107e3a:	e8 41 d9 ff ff       	call   80105780 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107e3f:	e8 dc bb ff ff       	call   80103a20 <mycpu>
80107e44:	89 c6                	mov    %eax,%esi
80107e46:	e8 d5 bb ff ff       	call   80103a20 <mycpu>
80107e4b:	89 c7                	mov    %eax,%edi
80107e4d:	e8 ce bb ff ff       	call   80103a20 <mycpu>
80107e52:	83 c7 08             	add    $0x8,%edi
80107e55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e58:	e8 c3 bb ff ff       	call   80103a20 <mycpu>
80107e5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107e60:	ba 67 00 00 00       	mov    $0x67,%edx
80107e65:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107e6c:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107e73:	83 c1 08             	add    $0x8,%ecx
80107e76:	c1 e9 10             	shr    $0x10,%ecx
80107e79:	83 c0 08             	add    $0x8,%eax
80107e7c:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107e82:	c1 e8 18             	shr    $0x18,%eax
80107e85:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107e8a:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
80107e91:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
80107e97:	e8 84 bb ff ff       	call   80103a20 <mycpu>
80107e9c:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107ea3:	e8 78 bb ff ff       	call   80103a20 <mycpu>
80107ea8:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107eae:	8b 73 08             	mov    0x8(%ebx),%esi
80107eb1:	e8 6a bb ff ff       	call   80103a20 <mycpu>
80107eb6:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ebc:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107ebf:	e8 5c bb ff ff       	call   80103a20 <mycpu>
80107ec4:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107eca:	b8 28 00 00 00       	mov    $0x28,%eax
80107ecf:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107ed2:	8b 43 04             	mov    0x4(%ebx),%eax
80107ed5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107eda:	0f 22 d8             	mov    %eax,%cr3
}
80107edd:	83 c4 2c             	add    $0x2c,%esp
80107ee0:	5b                   	pop    %ebx
80107ee1:	5e                   	pop    %esi
80107ee2:	5f                   	pop    %edi
80107ee3:	5d                   	pop    %ebp
  popcli();
80107ee4:	e9 d7 d8 ff ff       	jmp    801057c0 <popcli>
    panic("switchuvm: no process");
80107ee9:	c7 04 24 b2 90 10 80 	movl   $0x801090b2,(%esp)
80107ef0:	e8 7b 84 ff ff       	call   80100370 <panic>
    panic("switchuvm: no pgdir");
80107ef5:	c7 04 24 dd 90 10 80 	movl   $0x801090dd,(%esp)
80107efc:	e8 6f 84 ff ff       	call   80100370 <panic>
    panic("switchuvm: no kstack");
80107f01:	c7 04 24 c8 90 10 80 	movl   $0x801090c8,(%esp)
80107f08:	e8 63 84 ff ff       	call   80100370 <panic>
80107f0d:	8d 76 00             	lea    0x0(%esi),%esi

80107f10 <inituvm>:
{
80107f10:	55                   	push   %ebp
80107f11:	89 e5                	mov    %esp,%ebp
80107f13:	83 ec 38             	sub    $0x38,%esp
80107f16:	89 75 f8             	mov    %esi,-0x8(%ebp)
80107f19:	8b 75 10             	mov    0x10(%ebp),%esi
80107f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107f1f:	89 7d fc             	mov    %edi,-0x4(%ebp)
80107f22:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107f25:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  if(sz >= PGSIZE)
80107f28:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107f31:	77 59                	ja     80107f8c <inituvm+0x7c>
  mem = kalloc();
80107f33:	e8 28 a7 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80107f38:	31 d2                	xor    %edx,%edx
80107f3a:	89 54 24 04          	mov    %edx,0x4(%esp)
  mem = kalloc();
80107f3e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107f40:	b8 00 10 00 00       	mov    $0x1000,%eax
80107f45:	89 1c 24             	mov    %ebx,(%esp)
80107f48:	89 44 24 08          	mov    %eax,0x8(%esp)
80107f4c:	e8 ff d9 ff ff       	call   80105950 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107f51:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f57:	b9 06 00 00 00       	mov    $0x6,%ecx
80107f5c:	89 04 24             	mov    %eax,(%esp)
80107f5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f62:	31 d2                	xor    %edx,%edx
80107f64:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80107f68:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f6d:	e8 be fc ff ff       	call   80107c30 <mappages>
  memmove(mem, init, sz);
80107f72:	89 75 10             	mov    %esi,0x10(%ebp)
}
80107f75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  memmove(mem, init, sz);
80107f78:	89 7d 0c             	mov    %edi,0xc(%ebp)
}
80107f7b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  memmove(mem, init, sz);
80107f7e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107f81:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80107f84:	89 ec                	mov    %ebp,%esp
80107f86:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107f87:	e9 84 da ff ff       	jmp    80105a10 <memmove>
    panic("inituvm: more than a page");
80107f8c:	c7 04 24 f1 90 10 80 	movl   $0x801090f1,(%esp)
80107f93:	e8 d8 83 ff ff       	call   80100370 <panic>
80107f98:	90                   	nop
80107f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107fa0 <loaduvm>:
{
80107fa0:	55                   	push   %ebp
80107fa1:	89 e5                	mov    %esp,%ebp
80107fa3:	57                   	push   %edi
80107fa4:	56                   	push   %esi
80107fa5:	53                   	push   %ebx
80107fa6:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80107fa9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107fb0:	0f 85 98 00 00 00    	jne    8010804e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80107fb6:	8b 75 18             	mov    0x18(%ebp),%esi
80107fb9:	31 db                	xor    %ebx,%ebx
80107fbb:	85 f6                	test   %esi,%esi
80107fbd:	75 1a                	jne    80107fd9 <loaduvm+0x39>
80107fbf:	eb 77                	jmp    80108038 <loaduvm+0x98>
80107fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107fce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107fd4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107fd7:	76 5f                	jbe    80108038 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fdc:	31 c9                	xor    %ecx,%ecx
80107fde:	8b 45 08             	mov    0x8(%ebp),%eax
80107fe1:	01 da                	add    %ebx,%edx
80107fe3:	e8 b8 fb ff ff       	call   80107ba0 <walkpgdir>
80107fe8:	85 c0                	test   %eax,%eax
80107fea:	74 56                	je     80108042 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
80107fec:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
80107fee:	bf 00 10 00 00       	mov    $0x1000,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ff3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80107ff6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107ffb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108001:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108004:	05 00 00 00 80       	add    $0x80000000,%eax
80108009:	89 44 24 04          	mov    %eax,0x4(%esp)
8010800d:	8b 45 10             	mov    0x10(%ebp),%eax
80108010:	01 d9                	add    %ebx,%ecx
80108012:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80108016:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010801a:	89 04 24             	mov    %eax,(%esp)
8010801d:	e8 be 99 ff ff       	call   801019e0 <readi>
80108022:	39 f8                	cmp    %edi,%eax
80108024:	74 a2                	je     80107fc8 <loaduvm+0x28>
}
80108026:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80108029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010802e:	5b                   	pop    %ebx
8010802f:	5e                   	pop    %esi
80108030:	5f                   	pop    %edi
80108031:	5d                   	pop    %ebp
80108032:	c3                   	ret    
80108033:	90                   	nop
80108034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108038:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010803b:	31 c0                	xor    %eax,%eax
}
8010803d:	5b                   	pop    %ebx
8010803e:	5e                   	pop    %esi
8010803f:	5f                   	pop    %edi
80108040:	5d                   	pop    %ebp
80108041:	c3                   	ret    
      panic("loaduvm: address should exist");
80108042:	c7 04 24 0b 91 10 80 	movl   $0x8010910b,(%esp)
80108049:	e8 22 83 ff ff       	call   80100370 <panic>
    panic("loaduvm: addr must be page aligned");
8010804e:	c7 04 24 ac 91 10 80 	movl   $0x801091ac,(%esp)
80108055:	e8 16 83 ff ff       	call   80100370 <panic>
8010805a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108060 <allocuvm>:
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	57                   	push   %edi
80108064:	56                   	push   %esi
80108065:	53                   	push   %ebx
80108066:	83 ec 2c             	sub    $0x2c,%esp
  if(newsz >= KERNBASE)
80108069:	8b 7d 10             	mov    0x10(%ebp),%edi
8010806c:	85 ff                	test   %edi,%edi
8010806e:	0f 88 91 00 00 00    	js     80108105 <allocuvm+0xa5>
  if(newsz < oldsz)
80108074:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80108077:	0f 82 9b 00 00 00    	jb     80108118 <allocuvm+0xb8>
  a = PGROUNDUP(oldsz);
8010807d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108080:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80108086:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010808c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010808f:	0f 86 86 00 00 00    	jbe    8010811b <allocuvm+0xbb>
80108095:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80108098:	8b 7d 08             	mov    0x8(%ebp),%edi
8010809b:	eb 49                	jmp    801080e6 <allocuvm+0x86>
8010809d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801080a0:	31 d2                	xor    %edx,%edx
801080a2:	b8 00 10 00 00       	mov    $0x1000,%eax
801080a7:	89 54 24 04          	mov    %edx,0x4(%esp)
801080ab:	89 44 24 08          	mov    %eax,0x8(%esp)
801080af:	89 34 24             	mov    %esi,(%esp)
801080b2:	e8 99 d8 ff ff       	call   80105950 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801080b7:	b9 06 00 00 00       	mov    $0x6,%ecx
801080bc:	89 da                	mov    %ebx,%edx
801080be:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801080c4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801080c8:	b9 00 10 00 00       	mov    $0x1000,%ecx
801080cd:	89 04 24             	mov    %eax,(%esp)
801080d0:	89 f8                	mov    %edi,%eax
801080d2:	e8 59 fb ff ff       	call   80107c30 <mappages>
801080d7:	85 c0                	test   %eax,%eax
801080d9:	78 4d                	js     80108128 <allocuvm+0xc8>
  for(; a < newsz; a += PGSIZE){
801080db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801080e1:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801080e4:	76 7a                	jbe    80108160 <allocuvm+0x100>
    mem = kalloc();
801080e6:	e8 75 a5 ff ff       	call   80102660 <kalloc>
    if(mem == 0){
801080eb:	85 c0                	test   %eax,%eax
    mem = kalloc();
801080ed:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801080ef:	75 af                	jne    801080a0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801080f1:	c7 04 24 29 91 10 80 	movl   $0x80109129,(%esp)
801080f8:	e8 53 85 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801080fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108100:	39 45 10             	cmp    %eax,0x10(%ebp)
80108103:	77 6b                	ja     80108170 <allocuvm+0x110>
}
80108105:	83 c4 2c             	add    $0x2c,%esp
    return 0;
80108108:	31 ff                	xor    %edi,%edi
}
8010810a:	5b                   	pop    %ebx
8010810b:	89 f8                	mov    %edi,%eax
8010810d:	5e                   	pop    %esi
8010810e:	5f                   	pop    %edi
8010810f:	5d                   	pop    %ebp
80108110:	c3                   	ret    
80108111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108118:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
8010811b:	83 c4 2c             	add    $0x2c,%esp
8010811e:	89 f8                	mov    %edi,%eax
80108120:	5b                   	pop    %ebx
80108121:	5e                   	pop    %esi
80108122:	5f                   	pop    %edi
80108123:	5d                   	pop    %ebp
80108124:	c3                   	ret    
80108125:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108128:	c7 04 24 41 91 10 80 	movl   $0x80109141,(%esp)
8010812f:	e8 1c 85 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80108134:	8b 45 0c             	mov    0xc(%ebp),%eax
80108137:	39 45 10             	cmp    %eax,0x10(%ebp)
8010813a:	76 0d                	jbe    80108149 <allocuvm+0xe9>
8010813c:	89 c1                	mov    %eax,%ecx
8010813e:	8b 55 10             	mov    0x10(%ebp),%edx
80108141:	8b 45 08             	mov    0x8(%ebp),%eax
80108144:	e8 77 fb ff ff       	call   80107cc0 <deallocuvm.part.0>
      kfree(mem);
80108149:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010814c:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010814e:	e8 3d a3 ff ff       	call   80102490 <kfree>
}
80108153:	83 c4 2c             	add    $0x2c,%esp
80108156:	89 f8                	mov    %edi,%eax
80108158:	5b                   	pop    %ebx
80108159:	5e                   	pop    %esi
8010815a:	5f                   	pop    %edi
8010815b:	5d                   	pop    %ebp
8010815c:	c3                   	ret    
8010815d:	8d 76 00             	lea    0x0(%esi),%esi
80108160:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80108163:	83 c4 2c             	add    $0x2c,%esp
80108166:	5b                   	pop    %ebx
80108167:	5e                   	pop    %esi
80108168:	89 f8                	mov    %edi,%eax
8010816a:	5f                   	pop    %edi
8010816b:	5d                   	pop    %ebp
8010816c:	c3                   	ret    
8010816d:	8d 76 00             	lea    0x0(%esi),%esi
80108170:	89 c1                	mov    %eax,%ecx
80108172:	8b 55 10             	mov    0x10(%ebp),%edx
      return 0;
80108175:	31 ff                	xor    %edi,%edi
80108177:	8b 45 08             	mov    0x8(%ebp),%eax
8010817a:	e8 41 fb ff ff       	call   80107cc0 <deallocuvm.part.0>
8010817f:	eb 9a                	jmp    8010811b <allocuvm+0xbb>
80108181:	eb 0d                	jmp    80108190 <deallocuvm>
80108183:	90                   	nop
80108184:	90                   	nop
80108185:	90                   	nop
80108186:	90                   	nop
80108187:	90                   	nop
80108188:	90                   	nop
80108189:	90                   	nop
8010818a:	90                   	nop
8010818b:	90                   	nop
8010818c:	90                   	nop
8010818d:	90                   	nop
8010818e:	90                   	nop
8010818f:	90                   	nop

80108190 <deallocuvm>:
{
80108190:	55                   	push   %ebp
80108191:	89 e5                	mov    %esp,%ebp
80108193:	8b 55 0c             	mov    0xc(%ebp),%edx
80108196:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108199:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010819c:	39 d1                	cmp    %edx,%ecx
8010819e:	73 10                	jae    801081b0 <deallocuvm+0x20>
}
801081a0:	5d                   	pop    %ebp
801081a1:	e9 1a fb ff ff       	jmp    80107cc0 <deallocuvm.part.0>
801081a6:	8d 76 00             	lea    0x0(%esi),%esi
801081a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801081b0:	89 d0                	mov    %edx,%eax
801081b2:	5d                   	pop    %ebp
801081b3:	c3                   	ret    
801081b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801081ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801081c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801081c0:	55                   	push   %ebp
801081c1:	89 e5                	mov    %esp,%ebp
801081c3:	57                   	push   %edi
801081c4:	56                   	push   %esi
801081c5:	53                   	push   %ebx
801081c6:	83 ec 1c             	sub    $0x1c,%esp
801081c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801081cc:	85 f6                	test   %esi,%esi
801081ce:	74 55                	je     80108225 <freevm+0x65>
801081d0:	31 c9                	xor    %ecx,%ecx
801081d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801081d7:	89 f0                	mov    %esi,%eax
801081d9:	89 f3                	mov    %esi,%ebx
801081db:	e8 e0 fa ff ff       	call   80107cc0 <deallocuvm.part.0>
801081e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801081e6:	eb 0f                	jmp    801081f7 <freevm+0x37>
801081e8:	90                   	nop
801081e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081f0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801081f3:	39 fb                	cmp    %edi,%ebx
801081f5:	74 1f                	je     80108216 <freevm+0x56>
    if(pgdir[i] & PTE_P){
801081f7:	8b 03                	mov    (%ebx),%eax
801081f9:	a8 01                	test   $0x1,%al
801081fb:	74 f3                	je     801081f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801081fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108202:	83 c3 04             	add    $0x4,%ebx
80108205:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010820a:	89 04 24             	mov    %eax,(%esp)
8010820d:	e8 7e a2 ff ff       	call   80102490 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80108212:	39 fb                	cmp    %edi,%ebx
80108214:	75 e1                	jne    801081f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108216:	89 75 08             	mov    %esi,0x8(%ebp)
}
80108219:	83 c4 1c             	add    $0x1c,%esp
8010821c:	5b                   	pop    %ebx
8010821d:	5e                   	pop    %esi
8010821e:	5f                   	pop    %edi
8010821f:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108220:	e9 6b a2 ff ff       	jmp    80102490 <kfree>
    panic("freevm: no pgdir");
80108225:	c7 04 24 5d 91 10 80 	movl   $0x8010915d,(%esp)
8010822c:	e8 3f 81 ff ff       	call   80100370 <panic>
80108231:	eb 0d                	jmp    80108240 <setupkvm>
80108233:	90                   	nop
80108234:	90                   	nop
80108235:	90                   	nop
80108236:	90                   	nop
80108237:	90                   	nop
80108238:	90                   	nop
80108239:	90                   	nop
8010823a:	90                   	nop
8010823b:	90                   	nop
8010823c:	90                   	nop
8010823d:	90                   	nop
8010823e:	90                   	nop
8010823f:	90                   	nop

80108240 <setupkvm>:
{
80108240:	55                   	push   %ebp
80108241:	89 e5                	mov    %esp,%ebp
80108243:	56                   	push   %esi
80108244:	53                   	push   %ebx
80108245:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80108248:	e8 13 a4 ff ff       	call   80102660 <kalloc>
8010824d:	85 c0                	test   %eax,%eax
8010824f:	89 c6                	mov    %eax,%esi
80108251:	74 46                	je     80108299 <setupkvm+0x59>
  memset(pgdir, 0, PGSIZE);
80108253:	b8 00 10 00 00       	mov    $0x1000,%eax
80108258:	31 d2                	xor    %edx,%edx
8010825a:	89 44 24 08          	mov    %eax,0x8(%esp)
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010825e:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108263:	89 54 24 04          	mov    %edx,0x4(%esp)
80108267:	89 34 24             	mov    %esi,(%esp)
8010826a:	e8 e1 d6 ff ff       	call   80105950 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010826f:	8b 53 0c             	mov    0xc(%ebx),%edx
                (uint)k->phys_start, k->perm) < 0) {
80108272:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108275:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108278:	89 54 24 04          	mov    %edx,0x4(%esp)
8010827c:	8b 13                	mov    (%ebx),%edx
8010827e:	89 04 24             	mov    %eax,(%esp)
80108281:	29 c1                	sub    %eax,%ecx
80108283:	89 f0                	mov    %esi,%eax
80108285:	e8 a6 f9 ff ff       	call   80107c30 <mappages>
8010828a:	85 c0                	test   %eax,%eax
8010828c:	78 1a                	js     801082a8 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010828e:	83 c3 10             	add    $0x10,%ebx
80108291:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108297:	75 d6                	jne    8010826f <setupkvm+0x2f>
}
80108299:	83 c4 10             	add    $0x10,%esp
8010829c:	89 f0                	mov    %esi,%eax
8010829e:	5b                   	pop    %ebx
8010829f:	5e                   	pop    %esi
801082a0:	5d                   	pop    %ebp
801082a1:	c3                   	ret    
801082a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      freevm(pgdir);
801082a8:	89 34 24             	mov    %esi,(%esp)
      return 0;
801082ab:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801082ad:	e8 0e ff ff ff       	call   801081c0 <freevm>
}
801082b2:	83 c4 10             	add    $0x10,%esp
801082b5:	89 f0                	mov    %esi,%eax
801082b7:	5b                   	pop    %ebx
801082b8:	5e                   	pop    %esi
801082b9:	5d                   	pop    %ebp
801082ba:	c3                   	ret    
801082bb:	90                   	nop
801082bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801082c0 <kvmalloc>:
{
801082c0:	55                   	push   %ebp
801082c1:	89 e5                	mov    %esp,%ebp
801082c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801082c6:	e8 75 ff ff ff       	call   80108240 <setupkvm>
801082cb:	a3 04 7b 11 80       	mov    %eax,0x80117b04
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801082d0:	05 00 00 00 80       	add    $0x80000000,%eax
801082d5:	0f 22 d8             	mov    %eax,%cr3
}
801082d8:	c9                   	leave  
801082d9:	c3                   	ret    
801082da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801082e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801082e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801082e1:	31 c9                	xor    %ecx,%ecx
{
801082e3:	89 e5                	mov    %esp,%ebp
801082e5:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
801082e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801082eb:	8b 45 08             	mov    0x8(%ebp),%eax
801082ee:	e8 ad f8 ff ff       	call   80107ba0 <walkpgdir>
  if(pte == 0)
801082f3:	85 c0                	test   %eax,%eax
801082f5:	74 05                	je     801082fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801082f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801082fa:	c9                   	leave  
801082fb:	c3                   	ret    
    panic("clearpteu");
801082fc:	c7 04 24 6e 91 10 80 	movl   $0x8010916e,(%esp)
80108303:	e8 68 80 ff ff       	call   80100370 <panic>
80108308:	90                   	nop
80108309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108310 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108310:	55                   	push   %ebp
80108311:	89 e5                	mov    %esp,%ebp
80108313:	57                   	push   %edi
80108314:	56                   	push   %esi
80108315:	53                   	push   %ebx
80108316:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108319:	e8 22 ff ff ff       	call   80108240 <setupkvm>
8010831e:	85 c0                	test   %eax,%eax
80108320:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108323:	0f 84 a3 00 00 00    	je     801083cc <copyuvm+0xbc>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108329:	8b 55 0c             	mov    0xc(%ebp),%edx
8010832c:	85 d2                	test   %edx,%edx
8010832e:	0f 84 98 00 00 00    	je     801083cc <copyuvm+0xbc>
80108334:	31 ff                	xor    %edi,%edi
80108336:	eb 50                	jmp    80108388 <copyuvm+0x78>
80108338:	90                   	nop
80108339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108340:	b8 00 10 00 00       	mov    $0x1000,%eax
80108345:	89 44 24 08          	mov    %eax,0x8(%esp)
80108349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010834c:	89 34 24             	mov    %esi,(%esp)
8010834f:	05 00 00 00 80       	add    $0x80000000,%eax
80108354:	89 44 24 04          	mov    %eax,0x4(%esp)
80108358:	e8 b3 d6 ff ff       	call   80105a10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010835d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80108363:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108368:	89 04 24             	mov    %eax,(%esp)
8010836b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010836e:	89 fa                	mov    %edi,%edx
80108370:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80108374:	e8 b7 f8 ff ff       	call   80107c30 <mappages>
80108379:	85 c0                	test   %eax,%eax
8010837b:	78 63                	js     801083e0 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
8010837d:	81 c7 00 10 00 00    	add    $0x1000,%edi
80108383:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80108386:	76 44                	jbe    801083cc <copyuvm+0xbc>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108388:	8b 45 08             	mov    0x8(%ebp),%eax
8010838b:	31 c9                	xor    %ecx,%ecx
8010838d:	89 fa                	mov    %edi,%edx
8010838f:	e8 0c f8 ff ff       	call   80107ba0 <walkpgdir>
80108394:	85 c0                	test   %eax,%eax
80108396:	74 5e                	je     801083f6 <copyuvm+0xe6>
    if(!(*pte & PTE_P))
80108398:	8b 18                	mov    (%eax),%ebx
8010839a:	f6 c3 01             	test   $0x1,%bl
8010839d:	74 4b                	je     801083ea <copyuvm+0xda>
    pa = PTE_ADDR(*pte);
8010839f:	89 d8                	mov    %ebx,%eax
    flags = PTE_FLAGS(*pte);
801083a1:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801083a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801083af:	e8 ac a2 ff ff       	call   80102660 <kalloc>
801083b4:	85 c0                	test   %eax,%eax
801083b6:	89 c6                	mov    %eax,%esi
801083b8:	75 86                	jne    80108340 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801083ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083bd:	89 04 24             	mov    %eax,(%esp)
801083c0:	e8 fb fd ff ff       	call   801081c0 <freevm>
  return 0;
801083c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801083cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083cf:	83 c4 2c             	add    $0x2c,%esp
801083d2:	5b                   	pop    %ebx
801083d3:	5e                   	pop    %esi
801083d4:	5f                   	pop    %edi
801083d5:	5d                   	pop    %ebp
801083d6:	c3                   	ret    
801083d7:	89 f6                	mov    %esi,%esi
801083d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      kfree(mem);
801083e0:	89 34 24             	mov    %esi,(%esp)
801083e3:	e8 a8 a0 ff ff       	call   80102490 <kfree>
      goto bad;
801083e8:	eb d0                	jmp    801083ba <copyuvm+0xaa>
      panic("copyuvm: page not present");
801083ea:	c7 04 24 92 91 10 80 	movl   $0x80109192,(%esp)
801083f1:	e8 7a 7f ff ff       	call   80100370 <panic>
      panic("copyuvm: pte should exist");
801083f6:	c7 04 24 78 91 10 80 	movl   $0x80109178,(%esp)
801083fd:	e8 6e 7f ff ff       	call   80100370 <panic>
80108402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108410 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108410:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108411:	31 c9                	xor    %ecx,%ecx
{
80108413:	89 e5                	mov    %esp,%ebp
80108415:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108418:	8b 55 0c             	mov    0xc(%ebp),%edx
8010841b:	8b 45 08             	mov    0x8(%ebp),%eax
8010841e:	e8 7d f7 ff ff       	call   80107ba0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108423:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80108425:	89 c2                	mov    %eax,%edx
80108427:	83 e2 05             	and    $0x5,%edx
8010842a:	83 fa 05             	cmp    $0x5,%edx
8010842d:	75 11                	jne    80108440 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010842f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108434:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108439:	c9                   	leave  
8010843a:	c3                   	ret    
8010843b:	90                   	nop
8010843c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80108440:	31 c0                	xor    %eax,%eax
}
80108442:	c9                   	leave  
80108443:	c3                   	ret    
80108444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010844a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108450 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108450:	55                   	push   %ebp
80108451:	89 e5                	mov    %esp,%ebp
80108453:	57                   	push   %edi
80108454:	56                   	push   %esi
80108455:	53                   	push   %ebx
80108456:	83 ec 2c             	sub    $0x2c,%esp
80108459:	8b 75 14             	mov    0x14(%ebp),%esi
8010845c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010845f:	85 f6                	test   %esi,%esi
80108461:	74 75                	je     801084d8 <copyout+0x88>
80108463:	89 da                	mov    %ebx,%edx
80108465:	eb 3f                	jmp    801084a6 <copyout+0x56>
80108467:	89 f6                	mov    %esi,%esi
80108469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108470:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108473:	89 df                	mov    %ebx,%edi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108475:	8b 4d 10             	mov    0x10(%ebp),%ecx
    n = PGSIZE - (va - va0);
80108478:	29 d7                	sub    %edx,%edi
8010847a:	81 c7 00 10 00 00    	add    $0x1000,%edi
80108480:	39 f7                	cmp    %esi,%edi
80108482:	0f 47 fe             	cmova  %esi,%edi
    memmove(pa0 + (va - va0), buf, n);
80108485:	29 da                	sub    %ebx,%edx
80108487:	01 c2                	add    %eax,%edx
80108489:	89 14 24             	mov    %edx,(%esp)
8010848c:	89 7c 24 08          	mov    %edi,0x8(%esp)
80108490:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80108494:	e8 77 d5 ff ff       	call   80105a10 <memmove>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80108499:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    buf += n;
8010849f:	01 7d 10             	add    %edi,0x10(%ebp)
  while(len > 0){
801084a2:	29 fe                	sub    %edi,%esi
801084a4:	74 32                	je     801084d8 <copyout+0x88>
    pa0 = uva2ka(pgdir, (char*)va0);
801084a6:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
801084a9:	89 d3                	mov    %edx,%ebx
801084ab:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    pa0 = uva2ka(pgdir, (char*)va0);
801084b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
801084b5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801084b8:	89 04 24             	mov    %eax,(%esp)
801084bb:	e8 50 ff ff ff       	call   80108410 <uva2ka>
    if(pa0 == 0)
801084c0:	85 c0                	test   %eax,%eax
801084c2:	75 ac                	jne    80108470 <copyout+0x20>
  }
  return 0;
}
801084c4:	83 c4 2c             	add    $0x2c,%esp
      return -1;
801084c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801084cc:	5b                   	pop    %ebx
801084cd:	5e                   	pop    %esi
801084ce:	5f                   	pop    %edi
801084cf:	5d                   	pop    %ebp
801084d0:	c3                   	ret    
801084d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084d8:	83 c4 2c             	add    $0x2c,%esp
  return 0;
801084db:	31 c0                	xor    %eax,%eax
}
801084dd:	5b                   	pop    %ebx
801084de:	5e                   	pop    %esi
801084df:	5f                   	pop    %edi
801084e0:	5d                   	pop    %ebp
801084e1:	c3                   	ret    
