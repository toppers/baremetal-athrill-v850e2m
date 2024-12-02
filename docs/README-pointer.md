# これは何？

V850命令セットでC言語のポインタ操作を理解します。

## ポインタとは？

ポインタとは、メモリアドレスを格納するための変数です。メモリアドレスとは、コンピュータのメモリ上の位置を示す番号です。ポインタは、メモリ上のデータにアクセスするために使用されます。

### ポインタの宣言

ポインタを宣言するには、次のようにします。

```c
int *global_value_pointer;
```

この例では、`int`型のポインタ`global_value_pointer`を宣言しています。`*`はポインタを示す演算子です。

### ポインタの初期化

ポインタを初期化するには、次のようにします。

```c
int global_value;
int *global_value_pointer;
global_value_pointer = &global_value;
```

この例では、`int`型の変数`global_value`を宣言し、そのアドレスを`global_value_pointer`に代入しています。`&`はアドレス演算子です。

### ポインタを使ったメモリ参照

ポインタを参照するには、次のようにします。

```c
int value = *global_value_pointer;
```

この例では、`global_value_pointer`が指すメモリ上のデータを`value`に代入しています。

### ポインタを使ったメモリ書き込み

ポインタを使ってメモリ上のデータを書き換えることができます。

```c
*global_value_pointer = 0x87654321;
```

この例では、`global_value_pointer`が指すメモリ上のデータを`0x87654321`に書き換えています。


## ポインタ操作で使うV850命令セット

|命令|説明|
|---|---|
|mov|レジスタ間のデータ転送|
|ld.w|メモリからワードデータを読み込む|
|st.w|ワードデータをメモリに書き込む|
|add|加算|
|movea|レジスタ間のアドレス転送|

## アドレス

|アドレス|内容|
|---|---|
|0x5ff7404|global_value_pointer|
|0x5ff7408|global_value|

athrillでの確認結果：

```
p global_value
global_value = 0 (int:4) @ 0x5ff7408(0x0)
[DBG>p global_value_pointer
global_value_pointer = (int *: 4 ) 0x0  @ 0x5ff7404(0x0)
```

### ポインタの初期化のアセンブラ命令

Cコード：

```c
global_value_pointer = &global_value;
```

アセンブラ命令：
```asm
 a06:	2a 06 04 74 	mov	0x5ff7404, r10
 a0a:	ff 05 
 a0c:	2b 06 08 74 	mov	0x5ff7408, r11
 a10:	ff 05 
 a12:	6a 5f 01 00 	st.w	r11, 0[r10]
```

athrillでの確認結果：

`0xa06`にブレーク設定：
```
[DBG>b 0xa06
break 0xa06
[DBG>c
```

`c`コマンドでCPUをブレークポイントまで実行させる。
```
[CPU>INFO: INITIALIZE POINTER
global_value = 0x12345678

HIT break:0xa06 pointer_init(+0x72)
EDITOR_SEARCH_PATH_0 = ../step1
[NEXT> pc=0xa06 pointer.c 13
```

この時のCPUのレジスタR10とR11の値を確認する。
```
cpu
R10             0x0 Return Value
R11             0xc0a
```

次の命令に進む。
```asm
mov	0x5ff7404, r10
```

```
[DBG>n
[DONE> core0 pc=0xa06 pointer_init(+72) 0xa06: MOV imm32(100627460),r10(0):100627460
EDITOR_SEARCH_PATH_0 = ../step1
[NEXT> pc=0xa0c pointer.c 13
```

この時のCPUのレジスタR10とR11の値を確認する。
```
cpu
R10             0x5ff7404 global_value_pointer(+0x0) Return Value
R11             0xc0a
```

次の命令に進む。
```asm
mov	0x5ff7408, r11
```

```
[DBG>n
[DONE> core0 pc=0xa0c pointer_init(+78) 0xa0c: MOV imm32(100627464),r11(3082):100627464
EDITOR_SEARCH_PATH_0 = ../step1
[NEXT> pc=0xa12 pointer.c 13
```

この時のCPUのレジスタR10とR11の値を確認する。
```
cpu
R10             0x5ff7404 global_value_pointer(+0x0) Return Value
R11             0x5ff7408 global_value(+0x0)
```

次の命令に進む。
```asm
st.w	r11, 0[r10]
```
```
[DBG>n
[DONE> core0 pc=0xa12 pointer_init(+7e) 0xa12: ST.W r11(0x5ff7408), disp16(0) r10(0x5ff7404):0x5ff7408
EDITOR_SEARCH_PATH_0 = ../step1
[NEXT> pc=0xa16 pointer.c 14
```

この時のポインタの値を確認する。
```
[DBG>p global_value_pointer
global_value_pointer = (int *: 4 ) 0x5ff7408  @ 0x5ff7404(0x0)
````

