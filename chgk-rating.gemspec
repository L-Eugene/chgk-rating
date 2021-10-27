# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'chgk-rating'
  spec.version     = '0.1.0'
  spec.summary     = '"What? When? Where?" Rating API client'
  spec.description = 'API client for competitive What? Where? When? rating sites'
  spec.authors     = ['Eugene Lapeko']
  spec.email       = 'eugene@lapeko.info'
  spec.files       = [
    'Gemfile',
    'LICENSE',
    'lib/maii_rating.rb'
  ]
  spec.test_files = Dir['spec/**/*rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'json', '~> 2'
  spec.add_dependency 'rest-client', '~> 2.1'

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rubocop')

  spec.homepage = 'https://github.com/L-Eugene/chgk-rating'
  spec.license = 'MIT'
end
