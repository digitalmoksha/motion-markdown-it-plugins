fixture_dir  = fixture_path('ins/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-ins' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Ins)

  generate(File.join(fixture_dir, 'ins.txt'), md)
end
