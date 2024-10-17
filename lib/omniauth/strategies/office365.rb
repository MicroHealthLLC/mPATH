require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Office365 < OmniAuth::Strategies::OAuth2
      option :name, :office365

      option :client_options, {
        site: 'https://login.microsoftonline.com',
        authorize_url: '/common/oauth2/v2.0/authorize',
        token_url: '/common/oauth2/v2.0/token'
      }

      option :authorize_params, {
        scope: 'openid profile email User.Read'
      }

      option :token_params, {
        scope: 'openid profile email User.Read'
      }

      uid { raw_info['id'] }

      info do
        {
          email: raw_info['mail'] || raw_info['userPrincipalName'],
          name: raw_info['displayName'],
          first_name: raw_info['givenName'],
          last_name: raw_info['surname'],
          image: avatar_url
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://graph.microsoft.com/v1.0/me').parsed
      end

      def avatar_url
        "https://graph.microsoft.com/v1.0/me/photo/$value"
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def authorize_params
        super.tap do |params|
          %w[display scope auth_type].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      # Override to use Microsoft v2.0 token introspection endpoint
      def build_access_token
        options.token_params.merge!(:headers => {'Authorization' => basic_auth_header })
        super
      end

      protected

      def basic_auth_header
        "Basic " + Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")
      end
    end
  end
end

OmniAuth.config.add_camelization 'office365', 'Office365'