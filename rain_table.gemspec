Gem::Specification.new do |spec|
  spec.name = "rain_table"
  spec.version = "0.1.1"
  spec.summary = "text table generator"
  spec.email = "akicho8@gmail.com"
  spec.author = "akicho8"
  spec.homepage = ""
  spec.description = "text de table wo kantan ni tukurimasuyo"
  spec.rdoc_options = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]
  spec.platform = Gem::Platform::RUBY
  spec.files = %x[git ls-files].scan(/\S+/)
  spec.add_dependency("activesupport")
end
