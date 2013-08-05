# encoding: utf-8
require 'devise'

require 'devise_ldap_authenticatable/exception'
require 'devise_ldap_authenticatable/logger'
require 'devise_ldap_authenticatable/ldap/adapter'
require 'devise_ldap_authenticatable/ldap/connection'

class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

# Get ldap information from config/ldap.yml now
module Devise
  # Allow logging
  mattr_accessor :ldap_logger
  @@ldap_logger = true
  
  # Add valid users to database
  mattr_accessor :ldap_create_user
  @@ldap_create_user = true

  mattr_accessor :ldap_use_admin_to_bind
  @@ldap_use_admin_to_bind = false

  mattr_accessor :ldap_config_builder
  @@ldap_config_builder = Proc.new() {Hash.new}

  mattr_accessor :ldap_user_post_create_builder
  @@ldap_user_post_create_builder = Proc.new() {|user| user}
  
  mattr_accessor :ldap_auth_username_builder
  @@ldap_auth_username_builder = Proc.new() {|attribute, login, ldap| "#{attribute}=#{login},#{ldap.base}" }

end

# Add ldap_authenticatable strategy to defaults.
#
Devise.add_module(:ldap_authenticatable,
                  :route => :session, ## This will add the routes, rather than in the routes.rb
                  :strategy   => true,
                  :controller => :sessions,
                  :model  => 'devise_ldap_authenticatable/model')