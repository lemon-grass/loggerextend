require 'rubygems'
require 'rake'
require 'rake/gempackagetask'
require 'rake/rdoctask'

spec = Gem::Specification.new do |s|
  s.name = %q{loggerextend}
  s.version = "0.1.1"
  s.author = "Lemongrass"
  s.email = "lemongrass@lemongrass.org.uk"
  s.homepage = "http://github.com/lemon-grass/loggerextend"
  s.platform = Gem::Platform::RUBY
  s.summary = "Extend Ruby's Logger facility with custom levels"
  s.files = FileList["{lib}/**/*"].to_a
  s.require_path = "lib"
  s.autorequire = "name"
  s.test_files = FileList["{test}/**/{tc,ts}_*.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "example.rb"]
  # s.add_dependency("dependency", ">= 0.x.x")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

task :test do
  ruby "tests/tc_loggerextend.rb"
end
