fixture_dir  = fixture_path('abbr/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-abbr' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Abbr)
  generate(File.join(fixture_dir, 'abbr.txt'), md)
end
