class Setting < ApplicationRecord
  # Ensure these fields exist
  store :settings_data, accessors: [:keycloak_client_id, :keycloak_client_secret, :keycloak_realm, :keycloak_server_url], coder: JSON

  validates :keycloak_client_id, presence: true, if: -> { ENV["KEYCLOAK_CLIENT_ID"].present? }

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
    ['office365_key', 'office365_secret', 'google_map_key', 'google_oauth_key', 'google_oauth_secret', 'passwords_key', 'keycloak_client_id', 'keycloak_client_secret', 'keycloak_realm', 'keycloak_server_url'].each do |key|
      available_settings["#{key.upcase}"] = { 'default' => ENV["#{key.upcase}"], 'cached' => cached.send(key) || '' }
    end
  end

  begin
    load_available_settings
  rescue ActiveRecord::NoDatabaseError, StandardError => e
    Rails.logger.error("Failed to load settings: #{e.message}")
  end

  after_save do
    Setting.load_available_settings

    Devise.setup do |config|
      config.omniauth(:office365, 
        Setting['OFFICE365_KEY'], 
        Setting['OFFICE365_SECRET'], 
        scope: 'openid profile email https://outlook.office.com/mail.read',
        client_options: {
          site: 'https://outlook.office.com/',
          authorize_url: 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
          token_url: 'https://login.microsoftonline.com/common/oauth2/v2.0/token'
        },
        provider_ignores_state: true, prompt: :select_account
      )

      config.omniauth(:okta,
        ENV['OKTA_CLIENT_ID'],
        ENV['OKTA_CLIENT_SECRET'],
        scope: 'openid profile email',
        fields: ['profile', 'email'],
        client_options: {
          site: ENV['OKTA_SITE'],
          authorize_url: "#{ENV['OKTA_SITE']}/oauth2/default/v1/authorize",
          token_url: "#{ENV['OKTA_SITE']}/oauth2/default/v1/token",
          user_info_url: "#{ENV['OKTA_SITE']}/oauth2/default/v1/userinfo",
          audience: ENV['OKTA_CLIENT_ID']
        },
        issuer: "#{ENV['OKTA_SITE']}/oauth2/default",
        strategy_class: OmniAuth::Strategies::Okta
      )

      config.omniauth(:keycloak_openid,   
        Setting['KEYCLOAK_CLIENT_ID'], 
        Setting['KEYCLOAK_CLIENT_SECRET'], 
        scope: 'openid, basic, email, profile',
        client_options: { 
          site: Setting['KEYCLOAK_SERVER_URL'],
          realm: Setting['KEYCLOAK_REALM'],
          authorization_endpoint: "#{Setting['KEYCLOAK_SERVER_URL']}/realms/#{Setting['KEYCLOAK_REALM']}/protocol/openid-connect/auth",
          token_endpoint: "#{Setting['KEYCLOAK_SERVER_URL']}/realms/#{Setting['KEYCLOAK_REALM']}/protocol/openid-connect/token",
          userinfo_endpoint: "#{Setting['KEYCLOAK_SERVER_URL']}/realms/#{Setting['KEYCLOAK_REALM']}/protocol/openid-connect/userinfo"
        },
        issuer: "#{Setting['KEYCLOAK_SERVER_URL']}/realms/#{Setting['KEYCLOAK_REALM']}",
        strategy_class: OmniAuth::Strategies::KeycloakOpenId
      )

      config.omniauth :google_oauth2, Setting['GOOGLE_OAUTH_KEY'],  Setting['GOOGLE_OAUTH_SECRET'], provider_ignores_state: true
    end
  end
end
