# frozen_string_literal: true

module Routes
  module Attendees
    class Show < Coach::Middleware
      uses Middleware::Translate
      uses Middleware::Authenticate
      uses Middleware::CheckUserPermissions, required_permission: :attendees
      uses Middleware::GetModelById, model_class: Attendee

      requires :user, :model

      def call
        [200, model.to_json, Constants::Api::RESPONSE_HEADERS]
      end
    end
  end
end
