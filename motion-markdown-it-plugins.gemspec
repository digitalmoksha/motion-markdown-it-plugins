require File.expand_path('../lib/motion-markdown-it-plugins/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'motion-markdown-it-plugins'
  gem.version       = MotionMarkdownItPlugins::VERSION
  gem.authors       = ["Brett Walker"]
  gem.email         = 'github@digitalmoksha.com'
  gem.summary       = "Plugins for motion-markdown-it"
  gem.description   = "Plugins for use with motion-markdown-it"
  gem.homepage      = 'https://github.com/digitalmoksha/motion-markdown-it-plugins'
  gem.licenses      = ['MIT']

  gem.files         = Dir.glob('lib/**/*.rb')
  gem.files        << 'README.md'
  gem.test_files    = Dir["spec/**/*.rb"]

  gem.require_paths = ["lib"]

  gem.add_dependency 'motion-markdown-it', '~> 8.4'

  gem.add_development_dependency 'bacon-expect', '~> 1.0' # required for Travis build to work
end