#------------------------------------------------------------------------------
def fixture_path(relative_path)
  main_spec_dir = File.dirname(__FILE__)
  fixture_dir   = File.join(main_spec_dir, relative_path)
end

#------------------------------------------------------------------------------
def generate(datafile, parser)
  tests = get_tests(datafile)

  if ENV['example']
    define_test(tests[ENV['example'].to_i - 1], parser, true)
  else
    tests.each do |t|
      define_test(t, parser)
    end
  end
end

#------------------------------------------------------------------------------
def get_tests(specfile)
  line_number    = 0
  start_line     = 0
  end_line       = 0
  example_number = 0
  markdown_lines = []
  html_lines     = []
  state          = 0  # 0 regular text, 1 markdown example, 2 html output
  headertext     = ''
  tests          = []
  header_re      = /#+ /
  filename       = File.basename(specfile)

  File.open(specfile) do |specf|
    specf.each_line do |line|
      line_number += 1
      if state == 0 && header_re =~ line
        headertext = line.gsub(header_re, '').strip
      end
      if line.strip == "."
        state = (state + 1) % 3
        if state == 0
          example_number += 1
          end_line = line_number
          tests << {
              markdown:   markdown_lines.join.gsub('→',"\t"),
              html:       html_lines.join,
              example:    example_number,
              start_line: start_line,
              end_line:   end_line,
              section:    headertext,
              filename:   filename}
          start_line     = 0
          markdown_lines = []
          html_lines     = []
        end
      elsif state == 1
        if start_line == 0
          start_line = line_number - 1
        end
        markdown_lines << line
      elsif state == 2
        html_lines << line
      end
    end
  end
  return tests
end

#------------------------------------------------------------------------------
def define_test(testcase, parser, debug_tokens = false)

  it "#{testcase[:filename]} #{testcase[:section]} (#{testcase[:example].to_s}/#{testcase[:start_line]}-#{testcase[:end_line]}) with markdown:\n#{testcase[:markdown]}" do
    if debug_tokens
      parser.parse(testcase[:markdown], { references: {} }).each {|token| pp token.to_json}
    end
    expect(parser.render(testcase[:markdown])).to eq testcase[:html]
  end

end
