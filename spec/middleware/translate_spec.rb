# frozen_string_literal: true

require "rails_helper"

RSpec.describe Middleware::Translate do
  subject(:instance) { described_class.new(context, next_middleware) }

  let(:context) do
    { request: instance_double(ActionDispatch::Request, headers: headers) }
  end

  let(:headers) { { "Accept-Language" => "fr" } }

  context "with a language set" do
    let(:next_middleware) { -> { expect(I18n.locale).to eq(:fr) } }

    it "sets the language" do
      # Our expectation is set in the `next_middleware` lambda, since the
      # I18n.locale setting is only very short-lived and returns to normal
      # before #call finishes
      instance.call
    end
  end

  context "with no language set" do
    let(:headers) { {} }

    let(:next_middleware) { -> { expect(I18n.locale).to eq(:en) } }

    it "doesn't the language" do
      instance.call
    end
  end
end
