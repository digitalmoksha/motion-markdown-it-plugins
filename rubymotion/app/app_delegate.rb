class AppDelegate

  # OS X entry point
  #------------------------------------------------------------------------------
  def applicationDidFinishLaunching(notification)
    usage
    true
  end

  # iOS entry point
  #------------------------------------------------------------------------------
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    usage
    true
  end

  def usage
    if RUBYMOTION_ENV == 'test'
      puts '------------------------------------------------------------------------------'
    else
      puts '------------------------------------------------------------------------------'
      puts 'Sample usage for simple testing in REPL:'
      puts
      puts 'md = MarkdownIt::Parser.new'
      puts 'md.use(MotionMarkdownItPlugins::Ins)'
      puts "md.render('++inserted++')"
      puts '------------------------------------------------------------------------------'
    end
  end

end