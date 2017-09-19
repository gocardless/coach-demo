# frozen_string_literal: true

class AttendeesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  around_action :with_locale
  before_action :check_authorization_header
  before_action :check_access_token
  before_action :check_user_permissions
  before_action :find_attendee

  def show
    render json: @attendee
  end

  private

  def with_locale
    @locale = request.headers["HTTP_ACCEPT_LANGUAGE"]
    I18n.with_locale(@locale) { yield }
  end

  def check_authorization_header
    header_value = request.headers["HTTP_AUTHORIZATION"]

    unless header_value.present? && header_value.split(" ", 2).first == "Bearer"
      return missing_access_token_error
    end

    @access_token = header_value.split(" ", 2).last
  end

  def check_access_token
    @user = User.find_by(access_token: @access_token)

    return invalid_access_token_error unless @user.present?
  end

  def check_user_permissions
    return invalid_permissions_error unless @user.permissions.include?("attendees")
  end

  def find_attendee
    @attendee = Attendee.find(params[:id])
  end

  def not_found_error
    render json: { error: I18n.translate("not_found") }, status: 404
  end

  def missing_access_token_error
    render json: { error: I18n.translate("missing_access_token") }, status: 401
  end

  def invalid_access_token_error
    render json: { error: I18n.translate("invalid_access_token") }, status: 401
  end

  def invalid_permissions_error
    render json: { error: I18n.translate("invalid_permissions") }, status: 403
  end
end
