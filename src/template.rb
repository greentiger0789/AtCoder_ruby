# frozen_string_literal: true

include Math

require "prime"
require "set"
require "tsort"

def main
  puts "template実行"
end

ALP = ("a".."z").to_a
INF = 0xffffffffffffffff
def max(a, b)
  a > b ? a : b
end

def min(a, b)
  a < b ? a : b
end

def gif
  gets.to_i
end

def gff
  gets.to_f
end

def gsf
  gets.chomp
end

def gi
  gets.split.map(&:to_i)
end

def gf
  gets.split.map(&:to_f)
end

def gs
  gets.chomp.split.map(&:to_s)
end

def gc
  gets.chomp.split("")
end

def pr(num)
  num.prime_division
end

def pr?(num)
  Prime.prime?(num)
end

def digit(num)
  num.to_s.length
end

def array(s, ini = nil)
  Array.new(s) { ini }
end

def darray(s1, s2, ini = nil)
  Array.new(s1) { Array.new(s2) { ini } }
end

def rep(num, &block)
  num.times(&block)
end

def repl(st, en, n = 1, &block)
  st.step(en, n, &block)
end

main if __FILE__ == $PROGRAM_NAME
