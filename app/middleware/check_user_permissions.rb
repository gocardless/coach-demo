# frozen_string_literal: true

module Middleware
  class CheckUserPermissions < Coach::Middleware
    requires :user

    def call
      unless user.permissions.include?(required_permission)
        return invalid_permissions_error
      end

      next_middleware.call
    end

    private

    def required_permission
      config.fetch(:required_permission).to_s
    end

    def invalid_permissions_error
      [
        403,
        Constants::Api::RESPONSE_HEADERS,
        [{ error: I18n.translate("invalid_permissions") }.to_json],
      ]
    end
  end
end
