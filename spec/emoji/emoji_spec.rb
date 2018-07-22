fixture_dir  = fixture_path('emoji/fixtures')

#------------------------------------------------------------------------------
describe 'markdown-it-emoji' do
  describe 'default' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::Emoji)

    generate(File.join(fixture_dir, 'default/emoji.txt'), md)
    generate(File.join(fixture_dir, 'default/aliases.txt'), md)
    generate(File.join(fixture_dir, 'full.txt'), md)
  end

  describe 'options' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::Emoji, {
      defs: {
        'one' => '!!!one!!!',
        'fifty' => '!!50!!'
      },
      shortcuts: {
        'fifty' => [ ':50', '|50' ],
        'one' => ':uno'
      }
    })

    generate(File.join(fixture_dir, 'options.txt'), md)
  end

  describe 'whitelist' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::Emoji, { enabled: [ 'smile', 'grin' ] })

    generate(File.join(fixture_dir, 'whitelist.txt'), md)
  end

  describe 'autolinks' do
    md = MarkdownIt::Parser.new({ linkify: true })
    md.use(MotionMarkdownItPlugins::Emoji)

    generate(File.join(fixture_dir, 'autolinks.txt'), md)
  end
end

describe 'markdown-it-emoji-light' do
  describe 'default' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::EmojiLight)

    generate(File.join(fixture_dir, 'default/emoji.txt'), md)
    generate(File.join(fixture_dir, 'default/aliases.txt'), md)
    generate(File.join(fixture_dir, 'light.txt'), md)
  end

  describe 'options' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::EmojiLight, {
      defs: {
        'one' => '!!!one!!!',
        'fifty' => '!!50!!'
      },
      shortcuts: {
        'fifty' => [ ':50', '|50' ],
        'one' => ':uno'
      }
    })

    generate(File.join(fixture_dir, 'options.txt'), md)
  end

  describe 'whitelist' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::EmojiLight, { enabled: [ 'smile', 'grin' ] })

    generate(File.join(fixture_dir, 'whitelist.txt'), md)
  end

  describe 'autolinks' do
    md = MarkdownIt::Parser.new({ linkify: true })
    md.use(MotionMarkdownItPlugins::EmojiLight)

    generate(File.join(fixture_dir, 'autolinks.txt'), md)
  end
end

describe 'integrity' do
  it 'all shortcuts should exist' do
    MotionMarkdownItPlugins::EmojiPlugin::Data::Shortcuts::EMOJIES_DEF_SHORTCUTS.keys.each do |name|
      expect(MotionMarkdownItPlugins::EmojiPlugin::Data::Full::EMOJIES_DEF_FULL[name]).not_to eq nil
    end
  end

  it 'no chars with "uXXXX" names allowed' do
    MotionMarkdownItPlugins::EmojiPlugin::Data::Full::EMOJIES_DEF_FULL.keys.each do |name|
      expect(/^u[0-9a-b]{4,}$/ =~ name).to eq nil
    end
  end

  it 'all light chars should exist' do

    visible = File.read(File.join(fixture_dir, 'visible.txt'))

    available = MotionMarkdownItPlugins::EmojiPlugin::Data::Light::EMOJIES_DEF_LIGHT.keys.map do |k|
      MotionMarkdownItPlugins::EmojiPlugin::Data::Light::EMOJIES_DEF_LIGHT[k].gsub(/\uFE0F/, '')
    end

    missed = ''

    visible.each_char do |ch|
      missed << ch unless available.include?(ch)
    end

    expect(missed.length).to eq 0
  end
end
