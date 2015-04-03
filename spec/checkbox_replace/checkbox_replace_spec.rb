fixture_dir  = fixture_path('checkbox_replace/fixtures')

describe 'markdown-it-checkbox' do

  #------------------------------------------------------------------------------
  describe 'markdown-it-checkbox()' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::CheckboxReplace, {divWrap: false})
    specfile  = File.join(fixture_dir, 'checkbox.txt')
    tests     = get_tests(specfile)
    tests.each do |t|
      define_test(t, md)
    end

    #------------------------------------------------------------------------------
    it 'should pass irrelevant markdown' do
      md  = MarkdownIt::Parser.new
      res = md.render('# test')
      expect(res).to eq "<h1>test</h1>\n"
    end
  end

  #------------------------------------------------------------------------------
  describe 'markdown-it-checkbox(options)' do

    #------------------------------------------------------------------------------
    it 'should should optionally wrap arround a div layer' do
      md = MarkdownIt::Parser.new
      md.use(MotionMarkdownItPlugins::CheckboxReplace, {divWrap: true})
      res = md.render('[X] test written')
      expect(res).to eq '<p>' +
        '<div class="checkbox">' +
        '<input type="checkbox" id="checkbox0" checked="true">' +
        '<label for="checkbox0">test written</label>' +
        '</div>' +
        "</p>\n"
    end

    #------------------------------------------------------------------------------
    it 'should should optionally change class of div layer' do
      md = MarkdownIt::Parser.new
      md.use(MotionMarkdownItPlugins::CheckboxReplace, {divWrap: true, divClass: 'cb'})
      res = md.render('[X] test written')
      expect(res).to eq '<p>' +
        '<div class="cb">' +
        '<input type="checkbox" id="checkbox0" checked="true">' +
        '<label for="checkbox0">test written</label>' +
        '</div>' +
        "</p>\n"
    end

    #------------------------------------------------------------------------------
    it 'should should optionally change the id' do
      md = MarkdownIt::Parser.new
      md.use(MotionMarkdownItPlugins::CheckboxReplace, {idPrefix: 'cb'})
      res = md.render('[X] test written')
      expect(res).to eq '<p>' +
        '<input type="checkbox" id="cb0" checked="true">' +
        '<label for="cb0">test written</label>' +
        "</p>\n"
    end
  end

end