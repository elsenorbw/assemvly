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

  ; now we need to rot the values we have..
  ; for loop yo..
  mov r8, 0
top_of_loop:
  ; do this character..
  mov r9b, [readbuf + r8]
  
  ; we have this byte, just increment it for now..
  ; lowercase test.. 
  cmp r9b, 0x61
  jl uppercase
  cmp r9b, 0x7a
  jg uppercase
  ; and now rot that bad-boy..
  sub r9, 13
  cmp r9b, 0x61
  jge writeback
  add r9, 26
  jmp writeback

uppercase:
  cmp r9b, 0x41
  jl nextone
  cmp r9b, 0x5a
  jg nextone
  ; and now rot that bad-boy..
  sub r9, 13
  cmp r9b, 0x41
  jge writeback
  add r9, 26
  jmp writeback



writeback:
  mov [readbuf + r8], r9b
nextone:
  ; next one..
  add qword r8, 1
  cmp r8, [read_bytes_count]
  jnz top_of_loop


  ; ok we can print the thing out now..
  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  mov rsi, readbuf  ;  
  mov qword rdx, [read_bytes_count]        ;  
  syscall           ; );
  
  jmp readagain



done:
  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );




section .rodata



section .bss
  readbuf: resb 4  ; Our read buffer..
  ;mess: resb 20
  read_bytes_count: resq 1  ; How many bytes were actually read ?
