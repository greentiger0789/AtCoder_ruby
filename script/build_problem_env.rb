# frozen_string_literal: true

require "optparse"
require "fileutils"

def main(params)
  puts params[:problem_name]
  problem_name = params[:problem_name]
  num_cases = params[:num_cases]
  check_file_exists(problem_name)
end

def check_file_exists(problem_name)
  path = File.join("outputs", problem_name)
  FileUtils.mkdir_p(path) unless File.exist?(path)
  path = File.join("spec", "#{problem_name}_spec.rb")
  File.open(path, "w").close unless File.exist?(path)

  template_path = File.join("src", "template.rb")
  target_path = File.join("src", "#{problem_name}.rb")
  FileUtils.cp(template_path, target_path)
end

params = {}

OptionParser.new do |opts|
  opts.on("-p", "--problem_name NAME", "問題名を設定します") do |v|
    params[:problem_name] = v
  end
  opts.on("-n", "--num_cases NUM", Integer, "ケースの数を設定します") do |v|
    params[:num_cases] = v
  end
end.parse!(ARGV)

# 引数が指定されていない場合はエラーメッセージを表示して終了する
unless params[:problem_name] && params[:num_cases]
  puts "エラー: problem_name と num_cases はどちらも指定する必要があります。（ex. ruby script/build_problem_env.rb -p abc052_a -n 2）"
  exit(1)
end

p params

main(params) if __FILE__ == $PROGRAM_NAME
