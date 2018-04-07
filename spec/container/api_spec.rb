#------------------------------------------------------------------------------
describe 'api' do

  #------------------------------------------------------------------------------
  it 'renderer' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::Container, 'spoiler',
      { render: lambda {|tokens, idx, _options, env, renderer|
                  tokens[idx].nesting == 1 ? "<details><summary>click me</summary>\n" : "</details>\n" }})
    res = md.render("::: spoiler\n*content*\n:::\n")
    expect(res).to eq "<details><summary>click me</summary>\n<p><em>content</em></p>\n</details>\n"
  end

  #------------------------------------------------------------------------------
  it '2 char marker' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::Container, 'spoiler', {marker: '->'})
    res = md.render("->->-> spoiler\n*content*\n->->->\n")
    expect(res).to eq "<div class=\"spoiler\">\n<p><em>content</em></p>\n</div>\n"
  end

  #------------------------------------------------------------------------------
  it 'marker should not collide with fence' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::Container, 'spoiler', {marker: '`'})
    res = md.render("``` spoiler\n*content*\n```\n")
    expect(res).to eq "<div class=\"spoiler\">\n<p><em>content</em></p>\n</div>\n"
  end

  #------------------------------------------------------------------------------
  it 'marker should not collide with fence #2' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::Container, 'spoiler', {marker: '`'})
    res = md.render("\n``` not spoiler\n*content*\n```\n")
    expect(res).to eq "<pre><code class=\"language-not\">*content*\n</code></pre>\n"
  end

  #------------------------------------------------------------------------------
  describe 'validator' do

    #------------------------------------------------------------------------------
    it 'should skip rule if return value is falsy' do
      md = MarkdownIt::Parser.new
      md.use(MotionMarkdownItPlugins::Container, 'name', {validate: lambda {|params| false} })
      res = md.render(":::foo\nbar\n:::\n")
      expect(res).to eq "<p>:::foo\nbar\n:::</p>\n"
    end

    #------------------------------------------------------------------------------
    it 'should accept rule if return value is true' do
      md = MarkdownIt::Parser.new
      md.use(MotionMarkdownItPlugins::Container, 'name', {validate: lambda {|params| true} })
      res = md.render(":::foo\nbar\n:::\n")
      expect(res).to eq "<div class=\"name\">\n<p>bar</p>\n</div>\n"
    end

    #------------------------------------------------------------------------------
    it 'rule should call it' do
      count = 0

      md = MarkdownIt::Parser.new
      md.use(MotionMarkdownItPlugins::Container, 'name', {validate: lambda {|params| count += 1} })
      md.parse(":\n::\n:::\n::::\n:::::\n", {})

      # called by paragraph and lheading 3 times each
      expect(count).to be > 0
      expect(count % 3).to eq 0
    end

    #------------------------------------------------------------------------------
    it 'should not trim params' do
      md = MarkdownIt::Parser.new
      md.use(MotionMarkdownItPlugins::Container, 'name',
           {validate: lambda do |params|
                        expect(params).to eq " \tname "
                        return 1
                      end
            })
      md.parse("::: \tname \ncontent\n:::\n", {})
     end
  end

end
