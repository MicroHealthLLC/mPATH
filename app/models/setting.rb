class Setting < ApplicationRecord

  cattr_accessor :available_settings
  self.available_settings ||= {}

  def self.[](name)
    unless available_settings[name]["cached"].blank? || available_settings[name]["cached"].nil?
      return available_settings[name]["cached"]
    end
    available_settings[name]["default"]
  end

  def self.load_available_settings
    cached = first || new
    ['office365_key', 'office365_secret', 'google_map_key', 'google_oauth_key', 'google_oauth_secret'].each do |key|
      available_settings["#{key.upcase}"] = { 'default' => ENV["#{key.upcase}"], 'cached' => cached.send(key) || '' }
    end
  end
  load_available_settings
end
