# frozen_string_literal: true

module Middleware
  class GetModelById < Coach::Middleware
    provides :model

    def call
      model = model_class.find_by(id: id)
      return not_found_error unless model.present?

      provide(model: model)
      next_middleware.call
    end

    private

    def model_class
      config.fetch(:model_class)
    end

    def id
      request.params["id"]
    end

    def not_found_error
      [
        404,
        Constants::Api::RESPONSE_HEADERS,
        [{ error: I18n.translate("not_found") }.to_json],
      ]
    end
  end
end
