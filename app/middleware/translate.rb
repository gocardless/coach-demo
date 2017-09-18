# frozen_string_literal: true

module Middleware
  class Translate < Coach::Middleware
    def call
      I18n.with_locale(supplied_locale) { next_middleware.call }
    end

    private

    def supplied_locale
      request.headers["Accept-Language"]
    end
  end
end
