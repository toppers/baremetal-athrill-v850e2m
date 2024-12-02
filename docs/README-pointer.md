# これは何？

V850命令セットでC言語のポインタ操作を理解します。

## ポインタとは？

ポインタとは、メモリアドレスを格納するための変数です。メモリアドレスとは、コンピュータのメモリ上の位置を示す番号です。ポインタは、メモリ上のデータにアクセスするために使用されます。

### ポインタの宣言

ポインタを宣言するには、次のようにします。

```c
int *p;
```

この例では、`int`型のポインタ`p`を宣言しています。`*`はポインタを示す演算子です。

### ポインタの初期化

ポインタを初期化するには、次のようにします。

```c
int *p;
int x = 10;
p = &x;
```

この例では、`int`型の変数`x`を宣言し、そのアドレスを`p`に代入しています。`&`はアドレス演算子です。

### ポインタを使ったメモリ参照

ポインタを参照するには、次のようにします。

```c
int *p;
int x = 10;
p = &x;
int y = *p;
```

### ポインタを使ったメモリ書き込み

ポインタを使ってメモリ上のデータを書き換えることができます。

```c
int *p;
int x = 10;
p = &x;
*p = 20;
```

この例では、`p`が`x`のアドレスを指している状態から、`p`が指すメモリ上のデータを20に書き換えています。

## ポインタ操作で使うV850命令セット

|命令|説明|
|---|---|
|mov|レジスタ間のデータ転送|
|ld.w|メモリからワードデータを読み込む|
|st.w|ワードデータをメモリに書き込む|
|add|加算|
|movea|レジスタ間のアドレス転送|