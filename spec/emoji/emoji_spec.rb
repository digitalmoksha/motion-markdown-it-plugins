fixture_dir  = fixture_path('emoji/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-emoji' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Emoji)

  generate(File.join(fixture_dir, 'emoji.txt'), md)
end
