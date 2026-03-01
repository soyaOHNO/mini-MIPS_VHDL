# Small MIPS Processor

教育目的で作成した、小規模なMIPSアーキテクチャのプロセッサ実装です。
基本的な演算、メモリ操作、制御構文をサポートしており、CPUの動作原理やハードウェア記述言語（VHDL）を学習できます。

シングルサイクルプロセッサは設計が完了していて，パイプラインプロセッサは設計途中です．

## 特徴 (Features)
* **教育用:** CPUの基本動作を理解しやすいシンプルな設計。
* **簡易的なデバッグ:** PCを任意で進められ，その時点のレジスタの中身を確認可能。
* **専用コンパイラ:** 本プロセッサ向けのC言語風コンパイラ（`.mif` 出力対応）を別途開発・利用可能。

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

## 使用するもの（Item/Tools）

* 設計 :Quartus Prime Lite Edition
* FPGA :DE1-SoC

## 使い方 (Getting Started)

### 1. リポジトリのクローン
```bash
git clone https://github.com/soyaOHNO/mini-MIPS_VHDL.git
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

## 参考資料

* [コンピュータの構成と設計　MIPS Edition　第6版](https://www.amazon.co.jp/s?k=%E3%82%B3%E3%83%B3%E3%83%94%E3%83%A5%E3%83%BC%E3%82%BF+%E3%81%AE+%E6%A7%8B%E6%88%90+%E3%81%A8+%E8%A8%AD%E8%A8%88+%E7%AC%AC+6+%E7%89%88&language=ja_JP&adgrpid=1319416600139462&hvadid=82463780345373&hvbmt=be&hvdev=c&hvlocphy=140379&hvnetw=o&hvqmt=e&hvtargid=kwd-82464951240908%3Aloc-96&hydadcr=27296_14889407&jp-ad-ap=0&mcid=b43e83964095349f94eb46dfa36bd391&msclkid=8e65070002001c4319086ea0a7dcd9ed&tag=jpdeskstandse-22&ref=pd_sl_1iedwq1s4g_e) - David Patterson / John L.Hennessy 著  成田 光彰 訳（日経BP、2021年11月8日）
* [はじめての インテル® SoC FPGA 演習マニュアル（Atlas-SoC / DE10-Nano ボード版）](https://www.macnica.co.jp/business/semiconductor/articles/SoC-Trial_Seminar_Exercise_atlas_de10nano_v20.1_r3.pdf)
* [FPGAのBRAM（Block RAM）完全ガイド：構造・動作モード・ベンダ比較と設計ベストプラクティス](https://everplay.jp/column/20453)

