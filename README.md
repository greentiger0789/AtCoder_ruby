# AtCoder_ruby

競技プログラミングの [AtCoder](https://atcoder.jp/) の過去問を Ruby で解く環境を整えるためのツールです．

## Features

以下の機能を含みます．

- 回答入力用のファイル作成
- 問題ページから入出力例の取得
- 入出力例を使ったテストを行うための spec のファイル作成
- 入出力例を用いたテストの実行

## Requirement

Ruby のバージョン

- Ruby 3.3.0

Gem

- nokogiri
- prime
- rspec

## Installation

Homebrew で rbenv，ruby などをインストールしておく．

必要な gem をインストール．

```bash
gem install nokogiri prime rspec
```

本リポジトリの clone．

```bash
git clone https://github.com/greentiger0789/AtCoder_ruby.git
```

## Usage

例：`https://atcoder.jp/contests/abc042/tasks/abc042_b`の場合

本リポジトリに移動．

```bash
cd AtCoder_ruby
```

問題 URL の最後の文字列「abc042_b」を用いて，以下のコマンドを実行．

```bash
ruby script/build_problem_env.rb -p abc042_b
```

`./src/abc042_b`を開き，問題を解く（main 関数内に解答を記述）．

以下のコマンドでテストを実行．

```bash
ruby script/check_cases.rb -p abc042_b
```

RSpec で正誤判定が行われる．

## Note

- 実行環境は macOS です．
- テストが上手くいったら，提出ページに`./src/abc042_b`内のコードを丸々コピペして，提出ボタンを押すだけです．
- 問題の入出力例をスクレイピングで取得しているので，常識の範囲内の頻度で実行しましょう．

## Author

- [@greentiger0789](https://github.com/greentiger0789)
