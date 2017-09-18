# frozen_string_literal: true

require "rails_helper"

RSpec.describe Middleware::CheckUserPermissions do
  subject(:instance) { described_class.new(context, null_middleware, config) }

  let(:context) do
    {
      request: instance_double(ActionDispatch::Request),
      user: user,
    }
  end

  let(:config) do
    {
      required_permission: required_permission,
    }
  end

  let(:user) { FactoryGirl.build(:user, :can_manage_attendees) }

  context "requesting a permission the user has" do
    let(:required_permission) { :attendees }

    it { is_expected.to call_next_middleware }
  end

  context "requesting a permission the user doesn't have" do
    let(:required_permission) { :widgets }

    it { is_expected.to respond_with_status(403) }
    it { is_expected.to respond_with_body_that_matches(/Invalid permissions/) }
  end
end
