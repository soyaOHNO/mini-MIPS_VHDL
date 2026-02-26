# mycompiler について

これは，作成したMIPSが受け付ける機械語ファイル（InstructionMemory.mif）に変換するプログラムである．
実行はLinux環境でのみ行える．

## 実行方法

1. この「Compiler」ディレクトリごとLinux環境に置く．
2. test.myprogram にコードを入力．
3. 「./mycompiler/mycompiler test.myprogram」で実行．
4. 作成された「InstructionMemory.mif」を自作MIPSに使用する．

## 

このコードは岡山大学の教育用に使われる言語仕様を参考に作成されています．

また自作MIPSは，岡山大学の教育用シミュレーションである「MAPS」の命令セットを実行できます．

