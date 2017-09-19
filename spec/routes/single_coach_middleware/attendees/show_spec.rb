
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Routes::SingleCoachMiddleware::Attendees::Show do
  subject(:instance) { described_class.new(context) }

  let(:attendee) { FactoryGirl.create(:attendee) }
  let(:user) { FactoryGirl.create(:user, :can_manage_attendees) }

  let(:context) do
    {
      request: instance_double(
        ActionDispatch::Request,
        params: params,
        headers: headers,
      ),
    }
  end

  let(:params) { { "id" => attendee.id } }
  let(:headers) { { "Authorization" => "Bearer #{user.access_token}" } }

  describe "#call" do
    it { is_expected.to respond_with_status(200) }
    it { is_expected.to respond_with_body_that_matches(attendee.to_json) }

    context "with an invalid access token" do
      let(:headers) { { "Authorization" => "Bearer not_a_real_token" } }

      it { is_expected.to respond_with_status(401) }

      it do
        is_expected.
          to respond_with_body_that_matches({ error: "Invalid access token" }.to_json)
      end

      context "specifying a non-default language" do
        before { headers["Accept-Language"] = "fr" }

        it do
          is_expected.
            to respond_with_body_that_matches({ error: "Jeton d'accès invalide" }.to_json)
        end
      end
    end

    context "with a user who doesn't have access" do
      let(:user) { FactoryGirl.create(:user) }

      it { is_expected.to respond_with_status(403) }

      it do
        is_expected.
          to respond_with_body_that_matches({ error: "Invalid permissions" }.to_json)
      end
    end

    context "with a non-existent attendee" do
      let(:params) { { id: "not_a_real_id" } }

      it { is_expected.to respond_with_status(404) }
      it { is_expected.to respond_with_body_that_matches({ error: "Not found" }.to_json) }
    end
  end
end
