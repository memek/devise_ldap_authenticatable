# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_ldap_authenticatable/version"

Gem::Specification.new do |s|
  s.name     = 'devise_ldap_authenticatable'
  s.version  = DeviseLdapAuthenticatable::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.summary  = 'Devise extension to allow authentication via LDAP using multiple configs'
  s.email = 'przemyslaw.swiercz@gmail.com'
  s.homepage = 'https://github.com/memek/devise_ldap_authenticatable'
  s.description = 'This is modified version of devise_ldap_authenticatable by Curtis Schiewek'
  s.authors = ['Curtis Schiewek', 'Daniel McNevin', 'Steven Xu', 'Przemyslaw Swiercz']


  s.license = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('devise')
  s.add_dependency('net-ldap', '>= 0.3.1', '< 0.5.0')

  s.add_development_dependency('rake', '>= 0.9')
  s.add_development_dependency('rdoc', '>= 3')
  s.add_development_dependency('rails', '>= 4.0')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('factory_girl_rails', '~> 1.0')
  s.add_development_dependency('factory_girl', '~> 2.0')
  s.add_development_dependency('rspec-rails')

  %w{database_cleaner capybara launchy}.each do |dep|
    s.add_development_dependency(dep)
  end
end
