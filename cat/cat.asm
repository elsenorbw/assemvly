global _start



section .text

_start:

readagain:

  mov rax, 0        ; read (
  mov rdi, 0        ; stdin
  mov rsi, readbuf  ; buffer
  mov rdx, 4
  syscall           ; the number of bytes read is stored in rax

  ; if we're not done..
  cmp rax, 0
  je done

  mov qword [read_bytes_count], rax
  ; mov qword rax, [read_bytes_count]

  ; ok we can print the thing out now..
  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  mov rsi, readbuf  ;  
  mov qword rdx, [read_bytes_count]        ;  
  syscall           ; );
  
  jmp readagain



  cmp rax, 4
  je printfour

  cmp rax, 3
  je printthree

  cmp rax, 2
  je printtwo

  cmp rax, 1
  je printone

  jmp readagain
  

  ; mov [readbuf], al
  ; yes, we have.. 


printfour:
  mov rax, 1
  mov rdi, 1
  mov rsi, four
  mov rdx, fourlen
  syscall
  jmp readagain  

printthree:
  mov rax, 1
  mov rdi, 1
  mov rsi, three
  mov rdx, threelen
  syscall
  jmp readagain

printtwo:
  mov rax, 1
  mov rdi, 1
  mov rsi, two
  mov rdx, twolen
  syscall
  jmp readagain
  
printone:
  mov rax, 1
  mov rdi, 1
  mov rsi, one
  mov rdx, onelen
  syscall
  jmp readagain
  




done:
  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );




section .rodata
  msg: db "Hello, world!", 10
  msglen: equ $ - msg
  one: db "One", 10
  onelen: equ $ - one
  two: db "Two", 10
  twolen: equ $ - two
  three: db "Three", 10
  threelen: equ $ - three
  four: db "Four", 10
  fourlen: equ $ - four

section .bss
  readbuf: resb 4  ; Our read buffer..
  read_bytes_count: resq 1  ; How many bytes were actually read ?
