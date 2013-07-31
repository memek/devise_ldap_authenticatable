require "net/ldap"

module Devise
  module LDAP
    #DEFAULT_GROUP_UNIQUE_MEMBER_LIST_KEY = 'uniqueMember'
    
    module Adapter
      def self.valid_credentials?(login, password_plaintext)
        options = {:login => login,
                   :password => password_plaintext,
                   :ldap_auth_username_builder => ::Devise.ldap_auth_username_builder,
                   :admin => ::Devise.ldap_use_admin_to_bind}

        resource = Devise::LDAP::Connection.new(options)
        resource.authorized? if resource.ldap_available?
      end

      #def self.update_password(login, new_password)
      #  options = {:login => login,
      #             :new_password => new_password,
      #             :ldap_auth_username_builder => ::Devise.ldap_auth_username_builder,
      #             :admin => ::Devise.ldap_use_admin_to_bind}

      #  resource = Devise::LDAP::Connection.new(options)
      #  resource.change_password! if new_password.present? and resource.ldap_available?
      #end

      #def self.update_own_password(login, new_password, current_password)
      #  set_ldap_param(login, :userpassword, Net::LDAP::Password.generate(:sha, new_password), current_password)
      #end

      #def self.ldap_connect(login)
      #  options = {:login => login,
      #             :ldap_auth_username_builder => ::Devise.ldap_auth_username_builder,
      #             :admin => ::Devise.ldap_use_admin_to_bind}

      #  Devise::LDAP::Connection.new(options)
      #end

      #def self.valid_login?(login)
      #  resource = self.ldap_connect(login)
      #  resource.valid_login? if resource.ldap_available?
      #end

      #def self.get_groups(login)
      #  resource = self.ldap_connect(login)
      #  resource.user_groups if resource.ldap_available?
      #end

      #def self.in_ldap_group?(login, group_name, group_attribute = nil)
      #  resource = self.ldap_connect(login)
      #  resource.in_group?(group_name, group_attribute) if resource.ldap_available?
      #end

      #def self.get_dn(login)
      #  resource = self.ldap_connect(login)
      #  resource.dn if resource.ldap_available?
      #end

      #def self.set_ldap_param(login, param, new_value, password = nil)
      #  options = { :login => login,
      #              :ldap_auth_username_builder => ::Devise.ldap_auth_username_builder,
      #              :password => password }

      #  resource = Devise::LDAP::Connection.new(options)
      #  resource.set_param(param, new_value) if resource.ldap_available?
      #end

      #def self.delete_ldap_param(login, param, password = nil)
      #  options = { :login => login,
      #              :ldap_auth_username_builder => ::Devise.ldap_auth_username_builder,
      #              :password => password }

      #  resource = Devise::LDAP::Connection.new(options)
      #  resource.delete_param(param) if resource.ldap_available?
      #end

      #def self.get_ldap_param(login,param)
      #  resource = self.ldap_connect(login)
      #  resource.ldap_param_value(param) if resource.ldap_available?
      #end

      #def self.get_ldap_entry(login)
      #  resource = self.ldap_connect(login)
      #  resource.search_for_login if resource.ldap_available?
      #end

    end

  end

end