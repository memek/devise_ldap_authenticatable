require 'devise_ldap_authenticatable/strategy'

module Devise
  module Models
    module LdapAuthenticatable
      extend ActiveSupport::Concern

      def login_with
        @login_with ||= Devise.mappings[self.class.to_s.underscore.to_sym].to.authentication_keys.first
        self[@login_with]
      end

      # Checks if a resource is valid upon authentication.
      def valid_ldap_authentication?(password)
        if Devise::LDAP::Adapter.valid_credentials?(login_with, password)
          return true
        else
          return false
        end
      end

      # # Called before the ldap record is saved automatically
      # def ldap_before_save
      # end

      module ClassMethods
        # Authenticate a user based on configured attribute keys. Returns the
        # authenticated user if it's valid or nil.
        def authenticate_with_ldap(attributes={})
          return nil if Devise::LDAP::Connection.build_config.blank?
          auth_key = self.authentication_keys.first
          return nil unless attributes[auth_key].present?
          auth_key_value = (self.case_insensitive_keys || []).include?(auth_key) ? attributes[auth_key].downcase : attributes[auth_key]

          return nil if not Devise::LDAP::Adapter.valid_credentials?(attributes[:email], attributes[:password])

          # resource = find_for_ldap_authentication(conditions)
          resource = where(auth_key => auth_key_value).first

          if resource.blank? and ::Devise.ldap_create_user
            resource = new
            resource[auth_key] = auth_key_value
            resource.password = Devise.friendly_token
            resource = Devise.ldap_user_post_create_builder.call resource
            resource.save!
          end
          return resource
        end

      end
    end
  end
end
