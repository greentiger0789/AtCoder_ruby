# frozen_string_literal: true

require "net/http"
require "uri"
require "nokogiri"

# AtCoderTaskParserは指定されたURLからAtCoderのタスク情報を取得するクラスです。
class AtCoderTaskParser
  def initialize(url)
    @url = URI.parse(url)
  end

  # ページを解析し、入力例と出力例を抽出して返します。
  def parse
    doc = fetch_page(@url)

    input_examples = extract_examples(doc, "入力例")
    output_examples = extract_examples(doc, "出力例")

    { input_examples: input_examples, output_examples: output_examples }
  end

  private

  # 指定されたURLからページを取得し、Nokogiriのドキュメントオブジェクトを返します。
  def fetch_page(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == "https"
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    Nokogiri::HTML(response.body)
  end

  # ドキュメントから指定された部分の入力例または出力例を抽出して返します。
  def extract_examples(doc, type)
    examples = []
    input_output_parts = doc.css("div.part")
    input_output_parts.each do |part|
      pre_element = part.at_css("pre")
      next unless pre_element

      text = pre_element.text.strip
      examples << text if part.text.include?(type)
    end
    examples
  end
end

def example_main
  url = "https://atcoder.jp/contests/typical90/tasks/typical90_j"
  parsed_data = AtCoderTaskParser.new(url).parse

  parsed_data[:input_examples].each_with_index do |input, i|
    puts "入力例 #{i + 1}:"
    puts input
  end

  parsed_data[:output_examples].each_with_index do |output, i|
    puts "出力例 #{i + 1}:"
    puts output
  end
end

example_main if __FILE__ == $PROGRAM_NAME
