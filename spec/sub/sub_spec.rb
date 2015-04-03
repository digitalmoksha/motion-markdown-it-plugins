fixture_dir  = fixture_path('sub/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-sub' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Sub)

  generate(File.join(fixture_dir, 'sub.txt'), md)
end
