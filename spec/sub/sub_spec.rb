fixture_dir  = fixture_path('sub/fixtures')

# TODO: these are parsed incorrectly:
#
# ~~~foo~~~
# ~~~foo~ bar~~

#------------------------------------------------------------------------------
describe 'markdown-it-sub' do
  md = MarkdownIt::Parser.new
  md.use(MotionMarkdownItPlugins::Sub)

  generate(File.join(fixture_dir, 'sub.txt'), md)
end
