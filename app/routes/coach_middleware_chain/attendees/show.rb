# frozen_string_literal: true

module Routes
  module CoachMiddlewareChain
    module Attendees
      class Show < Coach::Middleware
        uses Middleware::Translate
        uses Middleware::Authenticate
        uses Middleware::CheckUserPermissions, required_permission: :attendees
        uses Middleware::GetModelById, model_class: Attendee

        requires :user, :model

        def call
          [200, Constants::Api::RESPONSE_HEADERS, [model.to_json]]
        end
      end
    end
  end
end
