# frozen_string_literal: true

include Math

require "prime"
require "set"
require "tsort"

# メインの処理を行うメソッド
def main
  puts "template実行"
end

# アルファベットの配列
ALP ||= ("a".."z").to_a

# 無限大を表す定数
INF ||= 0xffffffffffffffff

# 二つの数のうち大きい方を返す関数
def max(a, b)
  a > b ? a : b
end

# 二つの数のうち小さい方を返す関数
def min(a, b)
  a < b ? a : b
end

# 整数を取得するメソッド
def gif
  gets.to_i
end

# 浮動小数点数を取得するメソッド
def gff
  gets.to_f
end

# 文字列を取得するメソッド
def gsf
  gets.chomp
end

# 整数の配列を取得するメソッド
def gi
  gets.split.map(&:to_i)
end

# 浮動小数点数の配列を取得するメソッド
def gf
  gets.split.map(&:to_f)
end

# 文字列の配列を取得するメソッド
def gs
  gets.chomp.split.map(&:to_s)
end

# 文字の配列を取得するメソッド
def gc
  gets.chomp.split("")
end

# 素因数分解を行うメソッド
def pr(num)
  num.prime_division
end

# 素数かどうかを判定するメソッド
def pr?(num)
  Prime.prime?(num)
end

# 桁数を返すメソッド
def digit(num)
  num.to_s.length
end

# 指定したサイズの配列を生成するメソッド
def array(s, ini = nil)
  Array.new(s) { ini }
end

# 指定したサイズの二次元配列を生成するメソッド
def darray(s1, s2, ini = nil)
  Array.new(s1) { Array.new(s2) { ini } }
end

# 指定した回数分だけブロック内の処理を繰り返すメソッド
def rep(num, &block)
  num.times(&block)
end

# 指定した範囲でブロック内の処理を繰り返すメソッド
def repl(st, en, n = 1, &block)
  st.step(en, n, &block)
end

# プログラムが直接実行された場合にメインの処理を実行する
main if __FILE__ == $PROGRAM_NAME
