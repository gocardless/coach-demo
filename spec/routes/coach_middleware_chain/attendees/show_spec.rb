
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Routes::CoachMiddlewareChain::Attendees::Show do
  subject(:instance) { described_class.new(context) }

  let(:attendee) { FactoryGirl.create(:attendee) }
  let(:user) { FactoryGirl.create(:user, :can_manage_attendees) }

  let(:context) do
    {
      request: instance_double(ActionDispatch::Request),
      model: attendee,
      user: user,
    }
  end

  describe "#call" do
    it { is_expected.to respond_with_status(200) }
    it { is_expected.to respond_with_body_that_matches(attendee.to_json) }
  end
end
