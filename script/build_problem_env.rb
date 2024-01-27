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
  parsed_data = save_examples(problem_name)
  generate_spec_file(problem_name, parsed_data)
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

  parsed_data
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

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
def generate_spec_file(problem_name, parsed_data)
  num_cases = parsed_data[:output_examples].length
  File.open("spec/#{problem_name}_spec.rb", "w") do |file|
    file.puts "# frozen_string_literal: true"
    file.puts
    file.puts "require \"rspec\""
    file.puts "require \"tempfile\""
    file.puts
    file.puts "def run_problem(problem_name, input_data)"
    file.puts "  Tempfile.create(\"input_data\") do |tmp|"
    file.puts "    tmp.write(input_data)"
    file.puts "    tmp.rewind"
    file.puts "    IO.popen(\"ruby src/#{problem_name}.rb\", \"r+\") do |io|"
    file.puts "      tmp.each_line do |line|"
    file.puts "        io.puts(line.strip)"
    file.puts "      end"
    file.puts "      io.close_write"
    file.puts "      io.read.strip"
    file.puts "    end"
    file.puts "  end"
    file.puts "end"
    file.puts
    file.puts "def read_file(file_path)"
    file.puts "  File.read(file_path)"
    file.puts "end"
    file.puts
    file.puts "RSpec.describe \"#{problem_name}\" do"
    file.puts "  num_cases = #{num_cases}"
    file.puts "  problem_name = \"#{problem_name}\""
    file.puts
    file.puts "  num_cases.times do |i|"
    file.puts "    it \"test case \#{i + 1}\" do"
    file.puts "      input_data = read_file(\"tests/#{problem_name}/sample-\#{i + 1}.in\")"
    file.puts "      expected_output = read_file(\"tests/#{problem_name}/sample-\#{i + 1}.out\").strip"
    file.puts
    file.puts "      actual_output = run_problem(problem_name, input_data)"
    file.puts "      expect(actual_output).to eq(expected_output)"
    file.puts "    end"
    file.puts "  end"
    file.puts "end"
  end
end

# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength

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
