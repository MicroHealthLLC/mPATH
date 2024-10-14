class Setting < ApplicationRecord

  cattr_accessor :available_settings
  self.available_settings ||= {}

  def self.[](name)
    unless available_settings[name]["cached"].blank? || available_settings[name]["cached"].nil?
      return available_settings[name]["cached"]
    end
    available_settings[name]["default"]
  rescue
  end

  def self.load_available_settings
    cached = first || new
    ['office365_key', 'office365_secret', 'google_map_key', 'google_oauth_key', 'google_oauth_secret', 'passwords_key', 'keycloak_client_id', 'keycloak_client_secret'].each do |key|
      available_settings["#{key.upcase}"] = { 'default' => ENV["#{key.upcase}"], 'cached' => cached.send(key) || '' }
    end
  end

  begin
    load_available_settings
  rescue ActiveRecord::NoDatabaseError
  rescue => e
  end

  after_save do
    Setting.load_available_settings

    Devise.setup do |config|
      config.omniauth(:office365, 
        Setting['OFFICE365_KEY'], 
        Setting['OFFICE365_SECRET'], 
        :scope => 'openid profile email https://outlook.office.com/mail.read',
        :client_options => {
          :site => 'https://outlook.office.com/',
          :authorize_url => 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
          :token_url => 'https://login.microsoftonline.com/common/oauth2/v2.0/token'
        },
        provider_ignores_state: true, prompt: :select_account)

      config.omniauth(:okta,
        ENV['OKTA_CLIENT_ID'],
        ENV['OKTA_CLIENT_SECRET'],
        scope: 'openid profile email',
        fields: ['profile', 'email'],
        client_options: {
          site:          ENV['OKTA_SITE'],
          authorize_url: "#{ENV['OKTA_SITE']}/oauth2/default/v1/authorize",
          token_url:     "#{ENV['OKTA_SITE']}/oauth2/default/v1/token",
          user_info_url: "#{ENV['OKTA_SITE']}/oauth2/default/v1/userinfo",
          audience: ENV['OKTA_CLIENT_ID']
        },
        issuer: "#{ENV['OKTA_SITE']}/oauth2/default",
        strategy_class: OmniAuth::Strategies::Okta
      )
      
      # Add Keycloak provider configuration here
      config.omniauth(:keycloak_openid,   
        Setting['KEYCLOAK_CLIENT_ID'], 
        Setting['KEYCLOAK_CLIENT_SECRET'], 
        scope: 'openid, basic, email, profile',
        uid_field: "email",
        client_options: { 
          uid_field: "email",
          site: 'https://keycloak.microhealthllc.com',
          realm: 'master',
          authorization_endpoint: 'https://keycloak.microhealthllc.com/realms/master/protocol/openid-connect/auth',
          token_endpoint: 'https://keycloak.microhealthllc.com/realms/master/protocol/openid-connect/token',
          userinfo_endpoint: 'https://keycloak.microhealthllc.com/realms/master/protocol/openid-connect/userinfo'
        },
        issuer: "https://keycloak.microhealthllc.com/realms/master",
        strategy_class: OmniAuth::Strategies::KeycloakOpenId,
        # provider_ignores_state: true
      )

      config.omniauth :google_oauth2, Setting['GOOGLE_OAUTH_KEY'],  Setting['GOOGLE_OAUTH_SECRET'], provider_ignores_state: true

    end
  end
end
