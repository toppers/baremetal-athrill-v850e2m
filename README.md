# baremetal-athrill-v850e2m

このリポジトリでは、アセンブラ言語(v850)で作成したプログラムをCPUエミュレータAthrillで動かすことができます。これにより、CPUレジスタの動きやメモリの関係、さらにはC言語プログラムのポインタ理解に役立てることができます。

## 動作環境
- macOS
- Ubuntu 22.04

## インストール方法

以下のコマンドを実行して、Athrillをビルドします。

```bash
bash build-athrill.bash
```

ビルドが成功すると、以下のようなメッセージが表示されます。

```
Usage:athrill -c<core num> -m <memory config file> [OPTION]... <load_file>
 -c                             : set core num. if -c is not set, core num = 2.
 -i                             : execute on the interaction mode. if -i is not set, execute on the background mode.
 -r                             : execute on the remote mode. this option is valid on the interaction mode.
 -t<timeout>                    : set program end time using <timeout> clocks. this option is valid on the background mode.
 -m<memory config file>         : set athrill memory configuration. rom, ram region is configured on your system.
 -d<device config file>         : set device parameter.
OK: athrill2 is created on /Users/tmori/project/oss/baremetal-athrill-v850e2m/athrill-target-v850e2m/cmake-build/athrill2
```

このメッセージが表示されれば、Athrillのビルドが成功しています。

## ベアメタルプログラムのビルド

ベアメタルのプログラムをビルドするには、v850のクロスコンパイラが必要になります。このリポジトリには、Dockerを使用してクロスコンパイル環境をセットアップするスクリプトが含まれています。

以下のコマンドを実行して、Dockerイメージを作成します。

```bash
bash docker/create-image.bash
```

成功すると、Dockerイメージが作成されます。作成されたイメージは、以下のコマンドで確認できます。

```bash
docker images
```

コマンドの出力例は以下の通りです：

```
REPOSITORY                            TAG            IMAGE ID       CREATED         SIZE
toppersjp/athrill-v850e2m-builder     v1.0.0         ca4510b27935   5 hours ago     2.03GB
```

このイメージを使用して、ベアメタルプログラムのビルドを行うことができます。

## サンプルプログラムの説明

このリポジトリには、ベアメタルプログラムの学習に役立つサンプルプログラムが含まれています。サンプルプログラムのファイルは `workspace/step1` ディレクトリにあります。

```bash
ls workspace/step1
```

```
Makefile                start.S                 test_main.elf           test_suite.c
device_config.txt       test_check.h            test_main.elf.map       training.S
main.c                  test_data.h             test_reg.h              v850asm.inc
memory.txt              test_instruction.S      test_serial.h           vector.S
```

### プログラムの流れ

サンプルプログラムでは、`main.c` が実行されるまでの一連の処理が含まれています。プログラムの実行は `vector.S` およびスタートアップルーチン `start.S` から始まり、最終的に `main` 関数に制御が渡されます。これにより、ベアメタルプログラムの動作の本質を学ぶことができます。

#### スタートアップルーチン `start.S`

`start.S` は、プログラムの初期化を行うスタートアップルーチンです。ここでは、以下のようなコードが含まれています。

```assembly
.section	".text" , "ax"
.align	4
.globl	_start, _training
.type   _start, @function
_start:
	di
	Lea _stack_data, r3
	addi 1024, sp r3
	ei
	br	_training
.size	_start, .-_start
```

このルーチンでは、スタックの初期化と割り込みの無効化/有効化を行い、その後 `_training` ラベルへジャンプします。

#### トレーニングコード `_training`

`_training` ラベルには、アセンブラ言語でのジャンプ呼び出し練習として以下のコードが含まれています。

```assembly
.section	".text" , "ax"
.align	4
.globl	_training
.type   _training, @function
_training:
    /*****************************
     * START
     *****************************/

    addi 1024, r9 r19

    /*****************************
     * END
     *****************************/
    br _main
.size	_training, .-_training
```

このコードでは、`r9` レジスタに `1024` を加算し、その結果を `r19` に格納します。その後、`main` 関数にジャンプします。

### `main.c` の説明

`main.c` には、`main` 関数が定義されています。

```c
#include "test_serial.h"

unsigned char stack_data[1024];

extern void test_suite(void);

unsigned int test_data_uint32;

void test_print(const char *str)
{
	int i;
	for (i = 0; str[i] != '\0'; i++) {
		*(SERIAL_OUT_ADDR) = str[i];
	}
	*(SERIAL_OUT_ADDR) = '\n';
}

int global_value;
int *global_value_pointer;
int main(void)
{
	global_value_pointer = &global_value;

	*global_value_pointer = 999;
	test_print("\n");
	test_print("Hello World!\n");

	test_suite();
	while (1) {
		;
	}
}
```

この `main` 関数では、グローバル変数を利用したポインタアクセスが行われており、CPUがどのようにポインタを扱うかを学ぶことができます。また、標準出力はシリアルデバイスへのアクセスを通して行われています。最後に、テストスイートを呼び出して `addi` 命令のテストを実行します。

### テストスイート `test_suite`

`test_suite` では、以下のような `addi` 命令のテストが含まれています。

```assembly
#include "test_data.h"
#include "test_reg.h"
#include "v850asm.inc"

/*
 * ADD reg1, reg2
 */

.section	".text" , "ax"
.align	4

.global	_do_test_add1_1
.type   _do_test_add1_1, @function
_do_test_add1_1:
	addi	-20, sp, sp
	st.w	r20, 0[sp]
	st.w	r21, 4[sp]
	st.w	r22, 8[sp]
	st.w	r23, 12[sp]
	st.w	r24, 16[sp]
	/*
	 * prepare
	 */
	mov -1, r10
	 
	/* set input */
	mov 0x0,  r20
	mov 0x0,  r21
	/* set expect */
	mov 0x0, r22
	mov 0x1, r24
	ldsr r0, psw

	/*
	 * do test
	 */
	add r20, r21

	/*
	 * done
	 */
	 /* get test results*/
	 stsr psw, r23
	 cmp r21, r22
	 bne add1_0_test_fail
	 cmp r23, r24
	 bne add1_0_test_fail

	mov r0, r10

add1_0_test_fail:
	ld.w	0[sp], r20
	ld.w	4[sp], r21
	ld.w	8[sp], r22
	ld.w	12[sp], r23
	ld.w	16[sp], r24
	
	addi	20, sp, sp
	jmp		[lp]
.size	_do_test_add1_1, .-_do_test_add1_1
```

このコードでは、`addi` 命令の動作をテストし、期待された結果と比較する処理が行われています。

ベアメタルプログラムを理解するための格好の教材となっており、特にCPUレジスタやポインタアクセスの理解に役立つ内容となっています。

