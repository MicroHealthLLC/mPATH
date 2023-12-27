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
    cached = new
    ['office365_key', 'office365_secret', 'google_map_key', 'google_oauth_key', 'google_oauth_secret', 'passwords_key'].each do |key|
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

      config.omniauth :google_oauth2, Setting['GOOGLE_OAUTH_KEY'],  Setting['GOOGLE_OAUTH_SECRET'], provider_ignores_state: true
    end
  end
end
