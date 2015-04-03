#------------------------------------------------------------------------------
describe 'coverage' do

  #------------------------------------------------------------------------------
  it 'marker coverage' do
    md = MarkdownIt::Parser.new
    md.use(MotionMarkdownItPlugins::Container, 'fox', 
            { marker: 'foo',
              validate: lambda {|params| expect(params).to eq 'fox'; return 1}
              })
    tok = md.parse("foofoofoofox\ncontent\nfoofoofoofoo\n", {})

    expect(tok[0].markup).to eq 'foofoofoo'
    expect(tok[0].info).to eq 'fox'
    expect(tok[4].markup).to eq 'foofoofoofoo'
  end
end
