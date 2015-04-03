fixture_dir  = fixture_path('deflist/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-deflist' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Deflist)

  generate(File.join(fixture_dir, 'deflist.txt'), md)
end
