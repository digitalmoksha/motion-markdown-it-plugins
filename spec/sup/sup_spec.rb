fixture_dir  = fixture_path('sup/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-sup' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Sup)

  generate(File.join(fixture_dir, 'sup.txt'), md)
end
