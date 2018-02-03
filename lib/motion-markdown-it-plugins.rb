# encoding: utf-8

if defined?(Motion::Project::Config)
  
  lib_dir_path = File.dirname(File.expand_path(__FILE__))
  Motion::Project::App.setup do |app|
    app.files.unshift(Dir.glob(File.join(lib_dir_path, "motion-markdown-it-plugins/**/*.rb")))
  end

  require 'motion-markdown-it'
  
else
  
  require 'motion-markdown-it'
  require 'motion-markdown-it-plugins/checkbox_replace/checkbox_replace'
  require 'motion-markdown-it-plugins/deflist/deflist'
  require 'motion-markdown-it-plugins/abbr/abbr'
  require 'motion-markdown-it-plugins/ins/ins'
  require 'motion-markdown-it-plugins/mark/mark'
  require 'motion-markdown-it-plugins/sub/sub'
  require 'motion-markdown-it-plugins/sup/sup'
  require 'motion-markdown-it-plugins/container/container'
  require 'motion-markdown-it-plugins/header_sections/header_sections'
  
end
