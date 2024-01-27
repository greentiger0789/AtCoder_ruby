# frozen_string_literal: true

require "optparse"
require "fileutils"
require_relative "./scraping"

# メイン関数。引数としてパラメータを受け取り、ファイルの存在を確認する関数を呼び出す
def main(params)
  # デバッグ用に問題名を表示
  puts params[:problem_name]
  problem_name = params[:problem_name]
  # ファイルの存在を確認する関数を呼び出す
  ensure_files_exist(problem_name)
  save_examples(problem_name)
end

# ファイルの存在を確認し、存在しない場合は作成する
def ensure_files_exist(problem_name)
  # outputs ディレクトリ内に問題名のディレクトリを作成
  path = File.join("outputs", problem_name)
  FileUtils.mkdir_p(path) unless File.exist?(path)
  # spec ディレクトリ内に問題名_spec.rb ファイルを作成
  path = File.join("spec", "#{problem_name}_spec.rb")
  File.open(path, "w").close unless File.exist?(path)

  # src ディレクトリ内のテンプレートファイルをコピーし、問題名にリネームする
  template_path = File.join("src", "template.rb")
  target_path = File.join("src", "#{problem_name}.rb")
  FileUtils.cp(template_path, target_path)
end

def save_examples(problem_name)
  problem_directory_name = split_underscore(problem_name)
  url = "https://atcoder.jp/contests/#{problem_directory_name}/tasks/#{problem_name}"
  parsed_data = Scraping::AtCoderTaskParser.new(url).parse
  input_examples = parsed_data[:input_examples]
  output_examples = parsed_data[:output_examples]
  directory = "tests/#{problem_name}"
  Dir.mkdir(directory) unless Dir.exist?(directory)
  input_examples.each_with_index do |input, i|
    File.write("#{directory}/sample-#{i + 1}.in", input)
  end
  output_examples.each_with_index do |output, i|
    File.write("#{directory}/sample-#{i + 1}.out", output)
  end
end

def split_underscore(problem_name)
  match = problem_name.match(/(.+)_/)
  if match
    match[1]
  else
    puts "エラー: split_underscoreでエラーです"
    exit(1)
  end
end

params = {}

# コマンドライン引数のパース
OptionParser.new do |opts|
  opts.on("-p", "--problem_name NAME", "問題名を設定します") do |v|
    params[:problem_name] = v
  end
end.parse!(ARGV)

# 引数が指定されていない場合はエラーメッセージを表示して終了する
unless params[:problem_name]
  puts "エラー: problem_name を指定する必要があります。（ex. ruby script/build_problem_env.rb -p abc052_a）"
  exit(1)
end

# デバッグ用にパラメータを表示
p params

# メイン関数を呼び出す
main(params) if __FILE__ == $PROGRAM_NAME
