fixture_dir  = fixture_path('header_sections/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-header-sections' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::HeaderSections)

  generate(File.join(fixture_dir, 'header_sections.txt'), md)
end
