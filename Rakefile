require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'

spec = Gem::Specification.new do |s|
  s.name = "gaff"
  s.version = "0.3.4"
  s.author = "joe williams"
  s.email = "joe@joetify.com"
  s.homepage = "http://github.com/joewilliams/gaff"
  s.platform = Gem::Platform::RUBY
  s.summary = "cloud api's via amqp and json'"
  s.files = FileList["{bin,lib,config}/**/*"].to_a
  s.require_path = "lib"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  %w{yajl-ruby mixlib-config mixlib-log dynect amqp fog}.each { |gem| s.add_dependency gem }
  s.bindir = "bin"
  s.executables = %w( gaff )
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

Rake::RDocTask.new do |rd|
  rd.rdoc_files.include("lib/**/*.rb")
end
