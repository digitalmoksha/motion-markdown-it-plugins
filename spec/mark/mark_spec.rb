fixture_dir  = fixture_path('mark/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-mark' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Mark)

  generate(File.join(fixture_dir, 'mark.txt'), md)
end
