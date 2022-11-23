# frozen_string_literal: true

class AppConfig < SourcedConfig::ConfigContract
  params do
    required(:environment).filled(:string)
    required(:app_name).filled(:string)
    optional(:footer_color).maybe(:string)
  end
end
