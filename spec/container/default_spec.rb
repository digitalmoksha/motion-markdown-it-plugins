fixture_dir  = fixture_path('container/fixtures')

#------------------------------------------------------------------------------
describe 'default container' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Container, 'name')
  generate(File.join(fixture_dir, 'default.txt'), md)
end
