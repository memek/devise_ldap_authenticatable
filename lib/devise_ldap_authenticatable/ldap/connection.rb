module Devise
  module LDAP
    class Connection
      attr_reader :ldap, :login

      def self.build_config
        ::Devise.ldap_config_builder.call
      end

      def ldap_available?
        @ldap_available
      end


      def initialize(params = {})
        #ldap_config = YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
        ldap_config = Connection.build_config
        @ldap_available = (not ldap_config.blank?)
        return unless @ldap_available
        ldap_options = params
        ldap_config["ssl"] = :simple_tls if ldap_config["ssl"].to_bool
        ldap_options[:encryption] = ldap_config["ssl"].to_bool

        @ldap = Net::LDAP.new(ldap_options)
        @ldap.host = ldap_config["host"]
        @ldap.port = ldap_config["port"]
        @ldap.base = ldap_config["base"]
        @attribute = ldap_config["attribute"]
        @ldap_auth_username_builder = params[:ldap_auth_username_builder]

        @group_base = ldap_config["group_base"]

        @ldap.auth ldap_config["admin_user"], ldap_config["admin_password"] if params[:admin]

        @login = params[:login]
        @password = params[:password]
        @new_password = params[:new_password]
      end

      def dn
        DeviseLdapAuthenticatable::Logger.send("LDAP dn lookup: #{@attribute}=#{@login}")
        ldap_entry = search_for_login
        if ldap_entry.nil?
          @ldap_auth_username_builder.call(@attribute,@login,@ldap)
        else
          ldap_entry.dn
        end
      end

      def ldap_param_value(param)
        filter = Net::LDAP::Filter.eq(@attribute.to_s, @login.to_s)
        ldap_entry = nil
        @ldap.search(:filter => filter) {|entry| ldap_entry = entry}

        if ldap_entry
          unless ldap_entry[param].empty?
            value = ldap_entry.send(param)
            DeviseLdapAuthenticatable::Logger.send("Requested param #{param} has value #{value}")
            value
          else
            DeviseLdapAuthenticatable::Logger.send("Requested param #{param} does not exist")
            value = nil
          end
        else
          DeviseLdapAuthenticatable::Logger.send("Requested ldap entry does not exist")
          value = nil
        end
      end

      def authenticate!
        if @ldap_available
          @ldap.auth(dn, @password)
          @ldap.bind
        end
      end

      def authenticated?
        authenticate!
      end

      def authorized?
        DeviseLdapAuthenticatable::Logger.send("Authorizing user #{@login}")
        if !authenticated?
          DeviseLdapAuthenticatable::Logger.send("Not authorized because not authenticated.")
          return false
        else
          return true
        end
      end

      def valid_login?
        !search_for_login.nil?
      end

      # Searches the LDAP for the login
      #
      # @return [Object] the LDAP entry found; nil if not found
      def search_for_login
        DeviseLdapAuthenticatable::Logger.send("LDAP search for login: #{@attribute}=#{@login}")
        filter = Net::LDAP::Filter.eq(@attribute.to_s, @login.to_s)
        ldap_entry = nil
        match_count = 0
        @ldap.search(:filter => filter) {|entry| ldap_entry = entry; match_count+=1}
        DeviseLdapAuthenticatable::Logger.send("LDAP search yielded #{match_count} matches")
        ldap_entry
      end

      private

      def find_ldap_user(ldap)
        DeviseLdapAuthenticatable::Logger.send("Finding user: #{dn}")
        ldap.search(:base => dn, :scope => Net::LDAP::SearchScope_BaseObject).try(:first)
      end
    end
  end
end