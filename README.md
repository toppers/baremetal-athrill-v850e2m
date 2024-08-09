# baremetal-athrill-v850e2m

このリポジトリでは、アセンブラ言語(v850)で作成したプログラムをCPUエミュレータ[Athrill](https://www.toppers.jp/athrill.html)で動かすことができます。これにより、CPUレジスタの動きやメモリの関係、さらにはC言語プログラムのポインタ理解に役立てることができます。

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

## ベアメタルプログラム・ビルド環境のインストール

ベアメタルのプログラムをビルドするには、v850のクロスコンパイラが必要になります。このリポジトリには、Dockerを使用してクロスコンパイル環境をインストールする必要があります。

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

## サンプルプログラムのビルド方法

サンプルプログラムのビルドは、サンプルプログラム名を指定して実行します。

例：サンプルプログラム名が`step1`の場合
```bash
bash docker/build.bash step1
```

成功すると、以下のログが出力されます。

```bash
bash docker/build.bash step1
arm64
Mac
ROOT_PATH=/root
ATHRILL_ROOT=/root/athrill-target-v850e2m
BUILD_PATH=/root/workspace/build
CPU_CONFIG_PATH=/root/athrill-target-v850e2m/src/cpu/config
v850-elf-gcc -c -I. -I/root/common -I/root/athrill-target-v850e2m/src/cpu/config -O0 -mdisable-callt -mno-app-regs -mtda=0 -gdwarf-2 -Wall -Wno-unused-label -Wpointer-arith  -mv850e2 -Wa,-mno-bcond17 -Wa,-mwarn-signed-overflow -Wa,-mwarn-unsigned-overflow start.S
v850-elf-gcc -c -I. -I/root/common -I/root/athrill-target-v850e2m/src/cpu/config -O0 -mdisable-callt -mno-app-regs -mtda=0 -gdwarf-2 -Wall -Wno-unused-label -Wpointer-arith  -mv850e2 -Wa,-mno-bcond17 -Wa,-mwarn-signed-overflow -Wa,-mwarn-unsigned-overflow vector.S
v850-elf-gcc -c -I. -I/root/common -I/root/athrill-target-v850e2m/src/cpu/config -O0 -mdisable-callt -mno-app-regs -mtda=0 -gdwarf-2 -Wall -Wno-unused-label -Wpointer-arith  -mv850e2 -Wa,-mno-bcond17 -Wa,-mwarn-signed-overflow -Wa,-mwarn-unsigned-overflow training.S
v850-elf-gcc -c -I. -I/root/common -I/root/athrill-target-v850e2m/src/cpu/config -O0 -mdisable-callt -mno-app-regs -mtda=0 -gdwarf-2 -Wall -Wno-unused-label -Wpointer-arith  -mv850e2 -Wa,-mno-bcond17 -Wa,-mwarn-signed-overflow -Wa,-mwarn-unsigned-overflow main.c
v850-elf-gcc -c -I. -I/root/common -I/root/athrill-target-v850e2m/src/cpu/config -O0 -mdisable-callt -mno-app-regs -mtda=0 -gdwarf-2 -Wall -Wno-unused-label -Wpointer-arith  -mv850e2 -Wa,-mno-bcond17 -Wa,-mwarn-signed-overflow -Wa,-mwarn-unsigned-overflow test_suite.c
v850-elf-gcc -c -I. -I/root/common -I/root/athrill-target-v850e2m/src/cpu/config -O0 -mdisable-callt -mno-app-regs -mtda=0 -gdwarf-2 -Wall -Wno-unused-label -Wpointer-arith  -mv850e2 -Wa,-mno-bcond17 -Wa,-mwarn-signed-overflow -Wa,-mwarn-unsigned-overflow test_instruction.S
v850-elf-gcc -O0 -mdisable-callt -mno-app-regs -mtda=0 -gdwarf-2 -Wall -Wno-unused-label -Wpointer-arith  -mv850e2 -Wa,-mno-bcond17 -Wa,-mwarn-signed-overflow -Wa,-mwarn-unsigned-overflow -nostdlib -T /root/workspace/build/v850esfk3.ld -o test_main.elf start.o vector.o training.o main.o test_suite.o test_instruction.o -Wl,-Map,test_main.elf.map -lm -lgcc -lc
v850-elf-objdump -d test_main.elf > test_main.elf.dump
```

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

サンプルプログラムでは、[main.c](./workspace/step1/main.c) が実行されるまでの一連の処理が含まれています。プログラムの実行は [vector.S](./workspace/step1/vector.S) およびスタートアップルーチン [start.S](./workspace/step1/start.S) から始まり、最終的に `main` 関数に制御が渡されます。これにより、ベアメタルプログラムの動作の本質を学ぶことができます。

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

このルーチンでは、スタックの初期化と割り込みの無効化/有効化を行い、その後 [training.S](./workspace/step1/training.S)の`_training` ラベルへジャンプします。

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

[test_suite.c](./workspace/step1/test_suite.c)の`test_suite` では、以下のような `addi` 命令のテストが含まれています。

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

## Athrillでサンプルプログラムを動かそう！

Athrillでサンプルプログラムを動かすには、サンプルプログラム名を引数にして、`workspace/run/exec.bash` を実行するだけです。


実行方法：
```
% bash workspace/run/exec.bash step1
core id num=1
ROM : START=0x0 SIZE=512
RAM : START=0x5ff7000 SIZE=512
ELF SET CACHE RIGION:addr=0x0 size=2 [KB]
Elf loading was succeeded:0x0 - 0x9d0 : 2.464 KB
Elf loading was succeeded:0x9d0 - 0xddc : 0.0 KB
ELF SYMBOL SECTION LOADED:index=15
ELF SYMBOL SECTION LOADED:sym_num=43
ELF STRING TABLE SECTION LOADED:index=16
DEBUG_FUNC_FT_LOG_SIZE=1024
[DBG>
HIT break:0x0
```

成功すると、このように、０番地でCPUが停止した状態になります。

この状態でCPUレジスタ状態を確認してみましょう。cpuコマンドです。

```
cpu
***CPU<0>***
PC              0x0
R0              0x0
R1              0x0
R2              0x0
R3              0x0 Stack Pointer
R4              0x0
R5              0x0
R6              0x0 Arg1
R7              0x0 Arg2
R8              0x0 Arg3
R9              0x0 Arg4
R10             0x0 Return Value
R11             0x0
R12             0x0
R13             0x0
R14             0x0
R15             0x0
R16             0x0
R17             0x0
R18             0x0
R19             0x0
R20             0x0
R21             0x0
R22             0x0
R23             0x0
R24             0x0
R25             0x0
R26             0x0
R27             0x0
R28             0x0
R29             0x0
R30             0x0
R31             0x0
EIPC            0x0
EIPSW           0x0
ECR             0x0
PSW             0x20
SCCFG           0x0
SCBP            0x0
EIIC            0x0
FEIC            0x0
FEPC            0x0
FEPSW           0x0
CTBP            0x0
EIWR            0x0
FEWR            0x0
BSEL            0x0
VSECR = 0x00000000
VSTID = 0x00000000
VSADR = 0x00000000
VMECR = 0x00000000
VMTID = 0x00000000
VMADR = 0x00000000
MPM = 0x00000000
MPC = 0x00000000
TID = 0x00000000
```

ご覧の通り、PSW以外は全て０ですね。

次に、１命令実行してみましょう。`n`コマンドです。

```
[DBG>n
[DONE> core0 pc=0x0 null(null) 0x0: JR disp22(2000):0x7d0
```

このように、`JR` 命令が実行されていることがわかります。
cpuコマンドでプログラムカウンタを参照すると、このようにジャンプしたアドレスがセットされていることがわかりますね。
```
PC              0x7d0 start(+0x0)
```

このままステップ実行を続けると、命令実行に従って、CPUレジスタがどのように変化するかをみてみるとCPUの理解が深まると思います。
それでは、処理継続させて、main関数でブレークできるようにしましょう。`b`コマンドです。

```
[DBG>b main
break main 0x874
```

ブレーク設定されたメッセージが出力されました。このまま `c` コマンドでコンティニューします。

```
[DBG>c
[CPU>
HIT break:0x874 main(+0x0)
```

うまくブレークされました。`ft`コマンドを実行すると、処理の流れが見えます。

```
[DBG>ft 10
core0: <(null)                        (0xffffffea)> [  2] <0x000> start
core0: <test_data_uint32              (0x000)> [  1] <0x000> training
core0: <test_data_uint32              (0x000)> [  0] <0x000> main
```

`start｀ から始まり、`training` を経て、`main` 関数に入っていることがわかります。

それでは、`main`関数を実行してみましょう。プログラム断片はこうです。

```C
int global_value;
int *global_value_pointer;
int main(void)
{
	global_value_pointer = &global_value;
```

`global_value_pointer` は、ポインタ変数です。
`main`関数の中で、`global_value`のアドレスを格納していますね。

ここで、これらの変数のメモリを参照してみましょう。`p` コマンドです。

```
[DBG>p global_value_pointer
global_value_pointer = (int *: 4 ) 0x0  @ 0x5ff7000(0x0)
[DBG>p global_value
global_value = 0 (int:4) @ 0x5ff7408(0x0)
```

`global_value_pointer` と `global_value` はそれぞれ、`0x5ff7000` と `0x5ff7408` にメモリ確保されており、値は０ですね。
このまま処理を進めましょう。

```
[DBG>n
[DONE> core0 pc=0x874 main(+0) 0x874: ADD imm5(-8),r3(100627460):100627452
[DBG>n
[DONE> core0 pc=0x876 main(+2) 0x876: ST.W r31(0x0), disp16(4) r3(0x5ff73fc):0x0
[DBG>n
[DONE> core0 pc=0x87a main(+6) 0x87a: ST.W r29(0x0), disp16(0) r3(0x5ff73fc):0x0
[DBG>n
[DONE> core0 pc=0x87e main(+a) 0x87e: MOV r3(100627452),r29(0)
[DBG>n
[DONE> core0 pc=0x880 main(+c) 0x880: MOV imm32(100626432),r10(0):100626432
[DBG>n
[DONE> core0 pc=0x886 main(+12) 0x886: MOV imm32(100627464),r11(0):100627464
[DBG>n
[DONE> core0 pc=0x88c main(+18) 0x88c: ST.W r11(0x5ff7408), disp16(0) r10(0x5ff7000):0x5ff7408
[DBG>p global_value_pointer
global_value_pointer = (int *: 4 ) 0x5ff7408  @ 0x5ff7000(0x0)
```

`global_value_pointer` に、`global_value` のアドレス `0x5ff7408`が設定されましたね。C言語のポインタ操作をこのようにアセンブラ命令レベルで追いかけると理解が深まると思います。

ちなみに、`cpu`コマンドでレジスタ情報も見てみましょう。

```
R10             0x5ff7000 global_value_pointer(+0x0) Return Value
R11             0x5ff7408 global_value(+0x0)
```

作業用に、`R10` と `R11` にアドレスを一時格納した形跡が見て取れますね。

このまま、プログラを実行しましょう。

```
c
[CPU>

Hello World!

PASSED : do_test_add1_1
```

最終的にプログラムを実行すると、シリアル出力に Hello World! が表示され、テストも通過したことが確認できます。

Athrillを使用したアセンブラ言語レベルでの高度なデバッグを体験できました。このリポジトリを使って、V850アセンブリ言語の理解を深め、ベアメタルプログラムのデバッグを学んでください。皆さんからのフィードバックをお待ちしています！
