# frozen_string_literal: true

require "optparse"
require "fileutils"
require_relative "./scraping"

# 問題回答用環境作成クラス
class ProblemBuilder
  TEMPLATE_PATH = "src/template.rb"

  # 初期化
  def initialize(problem_name)
    @problem_name = problem_name
    @problem_directory_name = split_underscore(problem_name)
  end

  # 問題回答用環境を構築するメインメソッド
  def build_problem_env
    ensure_files_exist
    parsed_data = save_examples
    generate_spec_file(parsed_data)
  end

  private

  # ファイルの存在を確認し、必要なファイルを作成する
  def ensure_files_exist
    create_directory("outputs", @problem_name)
    create_file("spec", "#{@problem_name}_spec.rb")
    FileUtils.cp(TEMPLATE_PATH, "src/#{@problem_name}.rb")
  end

  # ディレクトリを作成する
  def create_directory(parent, child)
    path = File.join(parent, child)
    FileUtils.mkdir_p(path) unless File.exist?(path)
  end

  # ファイルを作成する
  def create_file(directory, file_name)
    path = File.join(directory, file_name)
    File.open(path, "w").close unless File.exist?(path)
  end

  # AtCoderの問題ページから入出力例を取得し、ファイルに保存する
  def save_examples
    url = "https://atcoder.jp/contests/#{@problem_directory_name}/tasks/#{@problem_name}"
    parsed_data = Scraping::AtCoderTaskParser.new(url).parse
    input_examples = parsed_data[:input_examples]
    output_examples = parsed_data[:output_examples]
    directory = "tests/#{@problem_name}"
    create_directory("tests", @problem_name)

    input_examples.each_with_index do |input, i|
      File.write("#{directory}/sample-#{i + 1}.in", input)
    end

    output_examples.each_with_index do |output, i|
      File.write("#{directory}/sample-#{i + 1}.out", output)
    end

    parsed_data
  end

  # RSpecのspecファイルを生成する
  def generate_spec_file(parsed_data)
    num_cases = parsed_data[:output_examples].length
    File.open("spec/#{@problem_name}_spec.rb", "w") do |file|
      file.puts generate_spec_template(num_cases)
    end
  end

  # RSpecのspecファイルのテンプレートを生成する
  def generate_spec_template(num_cases)
    <<~SPEC_TEMPLATE
      # frozen_string_literal: true

      require "rspec"
      require "tempfile"

      def run_problem(input_data)
        Tempfile.create("input_data") do |tmp|
          tmp.write(input_data)
          tmp.rewind
          IO.popen("ruby src/#{@problem_name}.rb", "r+") do |io|
            tmp.each_line do |line|
              io.puts(line.strip)
            end
            io.close_write
            io.read.strip
          end
        end
      end

      def read_file(file_path)
        File.read(file_path)
      end

      RSpec::Matchers.define :match_with_normalized_newlines do |expected|
        match do |actual|
          normalize_newlines(actual) == normalize_newlines(expected)
        end

        failure_message do |actual|
          "expected \#{actual.inspect} to match \#{expected.inspect} with normalized newlines"
        end

        def normalize_newlines(str)
          str.gsub(/\\r\n/, "\\n").gsub(/\\r/, "\\n")
        end
      end


      RSpec.describe "#{@problem_name}" do
        num_cases = #{num_cases}

        num_cases.times do |i|
          it "test case \#{i + 1}" do
            input_data = read_file("tests/#{@problem_name}/sample-\#{i + 1}.in")
            expected_output = read_file("tests/#{@problem_name}/sample-\#{i + 1}.out")

            actual_output = run_problem(input_data)
            expect(actual_output).to match_with_normalized_newlines(expected_output)
          end
        end
      end
    SPEC_TEMPLATE
  end

  # 問題名からディレクトリ名を抽出する
  def split_underscore(problem_name)
    match = problem_name.match(/(.+)_/)
    match ? match[1] : (raise "エラー: split_underscoreでエラーです")
  end
end

# コマンドライン引数をパースする
params = {}
OptionParser.new do |opts|
  opts.on("-p", "--problem_name NAME", "問題名を設定") do |v|
    params[:problem_name] = v
  end
end.parse!(ARGV)

# 問題名が指定されていない場合はエラーメッセージを表示して終了する
unless params[:problem_name]
  puts "エラー: problem_name を指定する必要があります。（ex. ruby script/build_problem_env.rb -p abc052_a）"
  exit(1)
end

# 問題回答用環境を構築する
builder = ProblemBuilder.new(params[:problem_name])
builder.build_problem_env if __FILE__ == $PROGRAM_NAME
