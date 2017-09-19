# frozen_string_literal: true

module Routes
  module SingleCoachMiddleware
    module Attendees
      class Show < Coach::Middleware
        def call
          I18n.with_locale(supplied_locale) do
            return missing_access_token_error unless access_token && bearer_token?
            user = User.find_by(access_token: access_token)

            # To send back an HTTP response, we just return a Rack-compliant response
            # (an array of a status code, headers and body) from our #call method
            return invalid_access_token_error unless user.present?

            unless user.permissions.include?("attendees")
              return invalid_permissions_error
            end

            attendee = Attendee.find_by(id: request.params["id"])
            return not_found_error unless attendee.present?

            [200, Constants::Api::RESPONSE_HEADERS, [attendee.to_json]]
          end
        end

        private

        def supplied_locale
          request.headers["Accept-Language"]
        end

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

        def invalid_permissions_error
          [
            403,
            Constants::Api::RESPONSE_HEADERS,
            [{ error: I18n.translate("invalid_permissions") }.to_json],
          ]
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
  end
end
