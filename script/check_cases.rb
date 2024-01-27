# frozen_string_literal: true

require "optparse"

# メイン関数
def main(params)
  problem_name = params[:problem_name]
  system("rspec spec/#{problem_name}_spec.rb")
end

params = {}

# コマンドライン引数のパース
OptionParser.new do |opts|
  opts.on("-p", "--problem_name NAME", "問題名を設定") do |v|
    params[:problem_name] = v
  end
end.parse!(ARGV)

# 引数が指定されていない場合はエラーメッセージを表示して終了する
unless params[:problem_name]
  puts "エラー: problem_name を指定する必要があります。（ex. ruby script/check_cases.rb -p abc052_a）"
  exit(1)
end

# メイン関数を呼び出す
main(params) if __FILE__ == $PROGRAM_NAME
