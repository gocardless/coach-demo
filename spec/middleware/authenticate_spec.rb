# frozen_string_literal: true

require "rails_helper"

RSpec.describe Middleware::Authenticate do
  subject(:instance) { described_class.new(context, null_middleware) }

  let(:context) do
    {
      request: instance_double(ActionDispatch::Request, headers: headers),
    }
  end

  let(:headers) do
    {
      "Authorization" => authorization_header,
    }
  end

  context "with a valid Authorization header" do
    let(:user) { FactoryGirl.create(:user) }
    let(:authorization_header) { "Bearer #{user.access_token}" }

    it { is_expected.to call_next_middleware }
    it { is_expected.to provide(user: user) }
  end

  context "with an Authorization header with an invalid bearer token" do
    let(:authorization_header) { "Bearer lol" }

    it { is_expected.to respond_with_status(401) }
    it { is_expected.to respond_with_body_that_matches(/Invalid access token/) }
  end

  context "with an Authorization header with a non-bearer token" do
    let(:authorization_header) { "lol" }

    it { is_expected.to respond_with_status(401) }
    it { is_expected.to respond_with_body_that_matches(/Missing access token/) }
  end

  context "with no Authorization header" do
    let(:headers) { {} }

    it { is_expected.to respond_with_status(401) }
    it { is_expected.to respond_with_body_that_matches(/Missing access token/) }
  end
end
