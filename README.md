# Small MIPS Processor

教育目的で開発された、小規模なMIPSアーキテクチャのプロセッサ実装です。
基本的な演算、メモリ操作、制御構文をサポートしており、CPUの動作原理やハードウェア記述言語（VHDL）の学習に最適な構成になっています。

## 特徴 (Features)
* **教育特化:** CPUの基本動作を理解しやすいシンプルな設計。
* **専用ツールチェーン:** 本プロセッサ向けのC言語風コンパイラ（`.mif` 出力対応）を別途開発・利用可能。

## 実装済み命令セット (Supported Instructions)

プロセッサがサポートしているMIPS命令の一覧です。

| カテゴリ | 命令 (Instructions) | 概要 |
| :--- | :--- | :--- |
| **演算 (Arithmetic/Logic)** | `add`, `addu`, `addi`, `addiu`<br>`sub`, `subu`<br>`mult`, `multu`, `div`, `divu`<br>`and`, `andi`, `or`, `ori`, `nor`<br>`xor`, `xori`<br>`lui` | 加減乗除、論理演算、即値ロード |
| **比較 (Comparison)** | `slt`, `sltu`, `slti`, `sltiu` | 大小比較（セットオンレスザン） |
| **メモリ操作 (Memory)** | `lb`, `lw`, `sb`, `sw` | メモリへのロード / ストア |
| **シフト (Shift)** | `sll`, `srl`, `sra`<br>`sllv`, `srlv`, `srav` | 論理 / 算術ビットシフト |
| **分岐 (Branch)** | `beq`, `bne` | 条件分岐 |
| **ジャンプ (Jump)** | `j`, `jal`, `jr`, `jalr` | 無条件ジャンプ / 関数呼び出し |
| **Hi/Loレジスタ (HiLo)** | `mfhi`, `mflo` | 乗除算結果（余り・商）の取得 |

## 使い方 (Getting Started)

### 1. リポジトリのクローン
```bash
git clone [https://github.com/soyaOHNO/mini-MIPS_VHDL.git](https://github.com/soyaOHNO/mini-MIPS_VHDL.git)
cd mini-MIPS_VHDL
```

### 2. シミュレーション / 実行

1. 「Quartus Prime」をインストールします．
2. OpenProject で，Open Project -> `s-MIPS.qpf` を開きます．
3. `InstructionMemory.mif` を所定のディレクトリに配置します．
4. 「Processing -> Update Memory Initialization File」で `.mif` を更新し，「Processing -> Start Assembler」でコンパイルします．
5. 「Programmer -> Start」で書き込みを行います．

## 本アーキテクチャ向けのアセンブラ

* [mycompiler](./Compiler/): 本アーキテクチャ向けのアセンブラ・最適化器を内包した自作コンパイラ．C言語風のコードから直接 `InstructionMemory.mif` を生成できます．

