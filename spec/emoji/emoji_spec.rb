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
        one: '!!!one!!!',
        fifty: '!!50!!'
      },
      shortcuts: {
        fifty: [ ':50', '|50' ],
        one: ':uno'
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

# describe('markdown-it-emoji-light', function () {
#   var md;
#
#   md = markdownit().use(emoji_light);
#   generate(path.join(__dirname, 'fixtures/default'), { header: true }, md);
#
#   generate(path.join(__dirname, 'fixtures/light.txt'), { header: true }, md);
#
#   md = markdownit().use(emoji_light, {
#     defs: {
#       one: '!!!one!!!',
#       fifty: '!!50!!'
#     },
#     shortcuts: {
#       fifty: [ ':50', '|50' ],
#       one: ':uno'
#     }
#   });
#   generate(path.join(__dirname, 'fixtures/options.txt'), { header: true }, md);
#
#
#   md = markdownit().use(emoji_light, { enabled: [ 'smile', 'grin' ] });
#   generate(path.join(__dirname, 'fixtures/whitelist.txt'), { header: true }, md);
#
#   md = markdownit({ linkify: true }).use(emoji);
#   generate(path.join(__dirname, 'fixtures/autolinks.txt'), { header: true }, md);
# });
#
#
# var emojies_shortcuts  = require('../lib/data/shortcuts');
# var emojies_defs       = require('../lib/data/full.json');
# var emojies_defs_light = require('../lib/data/light.json');
#
# describe('integrity', function () {
#
#   it('all shortcuts should exist', function () {
#     Object.keys(emojies_shortcuts).forEach(function (name) {
#       assert(emojies_defs[name], "shortcut doesn't exist: " + name);
#     });
#   });
#
#   it('no chars with "uXXXX" names allowed', function () {
#     Object.keys(emojies_defs).forEach(function (name) {
#       if (/^u[0-9a-b]{4,}$/i.test(name)) {
#         throw Error('Name ' + name + ' not allowed');
#       }
#     });
#   });
#
#   it('all light chars should exist', function () {
#     var visible = fs.readFileSync(path.join(__dirname, '../support/visible.txt'), 'utf8');
#
#     var available = Object.keys(emojies_defs_light).map(function (k) {
#       return emojies_defs_light[k].replace(/\uFE0F/g, '');
#     });
#
#     var missed = '';
#
#     Array.from(visible).forEach(function (ch) {
#       if (available.indexOf(ch) < 0) missed += ch;
#     });
#
#     if (missed) {
#       throw new Error('Characters ' + missed + ' missed.');
#     }
#   });
#
# });
