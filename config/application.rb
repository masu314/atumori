require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Atumori
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #デフォルトの言語を日本語にする
    config.i18n.default_locale = :ja
    #複数のロケールファイルが読み込まれるようにpathを通す
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    #Rails自体のアプリケーション時刻を日本時間に設定
    config.time_zone = 'Tokyo'
    #DBに読み書きする際に、DBに記録されている時間をOSのタイムゾーンで読み込む設定
    config.active_record.default_timezone = :local
    #バリデーションエラーがあった際に、レイアウトが崩れないように設定
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
  end
end
