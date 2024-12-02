#include "v850asm.inc"

.section	".text", "ax"
.align	4
.globl	_training
.type   _training, @function
_training:
    /*****************************
     * START
     *****************************/
    addi 1024, r9, r19

    /*****************************
     * END
     *****************************/
    Lea _main, r10
    jmp [r10]              // r10 の指すアドレスにジャンプ
.size		_training, .-_training