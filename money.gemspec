Gem::Specification.new do |spec|
  spec.name        = 'money'
  spec.version     = '1.0.0'
  spec.authors     = ['Mateusz Tuński']
  spec.email       = ['mateusz@tunski.net']
  spec.summary     = 'Library that adds support for money-related operations'
  spec.description = 'This is the best library in the world to operate on money!'
  spec.homepage    = 'http://cantaffordawebserver.poor'
  spec.license     = 'MIT'

  spec.files       = `git ls-files`.split("\n")
  spec.test_files  = `git ls-files -- test/*`.split("\n")

  spec.add_development_dependency 'bundler',  '~> 1.7'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.4'
end
