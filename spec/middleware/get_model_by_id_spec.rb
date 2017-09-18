# frozen_string_literal: true

require "rails_helper"

RSpec.describe Middleware::GetModelById do
  subject(:instance) { described_class.new(context, null_middleware, config) }

  let(:context) do
    {
      request: instance_double(ActionDispatch::Request, params: params),
    }
  end

  let(:config) { { model_class: Attendee } }

  context "when a model can be found by ID for the provided class" do
    let(:attendee) { FactoryGirl.create(:attendee) }
    let(:params) { { "id" => attendee.id } }

    it { is_expected.to call_next_middleware }
    it { is_expected.to provide(model: attendee) }
  end

  context "when no model can be found by ID for the provided class" do
    let(:params) { { "id" => "non_existent_id" } }

    it { is_expected.to respond_with_status(404) }
    it { is_expected.to respond_with_body_that_matches(/Not found/) }
  end

  context "with no ID provided" do
    let(:params) { {} }

    it { is_expected.to respond_with_status(404) }
    it { is_expected.to respond_with_body_that_matches(/Not found/) }
  end
end
