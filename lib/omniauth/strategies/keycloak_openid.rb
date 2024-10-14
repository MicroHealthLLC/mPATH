require "omniauth/strategies/oauth2"

module OmniAuth
  module Strategies
    class KeycloakOpenId < OmniAuth::Strategies::OAuth2
      option :name, :keycloak_openid

      option :client_options, {
        site:          "https://keycloak.microhealthllc.com",
        authorize_url: "/realms/master/protocol/openid-connect/auth",
        token_url:     "/realms/master/protocol/openid-connect/token",
        user_info_url: "/realms/master/protocol/openid-connect/userinfo"
      }

      uid { raw_info["sub"] }

      info do
        {
          email: raw_info["email"],
          name: raw_info["name"],
          nickname: raw_info["preferred_username"]
        }
      end

      extra do
        {
          "raw_info" => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get(options.client_options.user_info_url).parsed
      end

      private

      # def callback_url
      #   options[:redirect_uri] || (full_host + script_name + callback_path)
      # end
    end
  end
end
