# frozen_string_literal: true

module Middleware
  class Authenticate < Coach::Middleware
    provides :user

    def call
      return missing_access_token_error unless access_token.present? && bearer_token?
      user = User.find_by(access_token: access_token)

      # To send back an HTTP response, we just return a Rack-compliant response
      # (an array of a status code, body and headers) from our #call method
      return invalid_access_token_error unless user.present?

      provide(user: user)
      next_middleware.call
    end

    private

    def access_token
      authorization_header&.split(" ", 2)&.second
    end

    def bearer_token?
      authorization_header&.split(" ", 2)&.first == "Bearer"
    end

    def authorization_header
      request.headers["Authorization"]
    end

    def invalid_access_token_error
      [
        401,
        Constants::Api::RESPONSE_HEADERS,
        [{ error: I18n.translate("invalid_access_token") }.to_json],
      ]
    end

    def missing_access_token_error
      [
        401,
        Constants::Api::RESPONSE_HEADERS,
        [{ error: I18n.translate("missing_access_token") }.to_json],
      ]
    end
  end
end
