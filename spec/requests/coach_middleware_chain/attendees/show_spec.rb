
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /coach_middleware_chain/attendees/:id", type: :request do
  let(:attendee) { FactoryGirl.create(:attendee) }
  let(:user) { FactoryGirl.create(:user, :can_manage_attendees) }

  let(:headers) do
    {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{user.access_token}",
    }
  end

  it "returns a JSON representation of the attendee" do
    get "/coach_middleware_chain/attendees/#{attendee.id}",
        headers: headers

    expect(response.status).to eq(200)
    expect(response.body).to eq(attendee.to_json)
  end

  context "requesting a non-existent ID" do
    it "returns an error" do
      get "/coach_middleware_chain/attendees/123",
          headers: headers

      expect(response.status).to eq(404)
      expect(response.body).to eq({ error: "Not found" }.to_json)
    end
  end

  describe "authentication" do
    context "with a user with insufficient permissions" do
      let(:user) { FactoryGirl.create(:user) }

      it "returns an error" do
        get "/coach_middleware_chain/attendees/#{attendee.id}",
            headers: headers

        expect(response.status).to eq(403)
        expect(response.body).to eq({ error: "Invalid permissions" }.to_json)
      end
    end

    context "not providing an Authorization header" do
      before { headers.delete("Authorization") }

      it "returns an error" do
        get "/coach_middleware_chain/attendees/#{attendee.id}",
            headers: headers

        expect(response.status).to eq(401)
        expect(response.body).to eq({ error: "Missing access token" }.to_json)
      end
    end

    context "providing an invalid access token" do
      before { headers["Authorization"] = "Bearer lolwut" }

      it "returns an error" do
        get "/coach_middleware_chain/attendees/#{attendee.id}",
            headers: headers

        expect(response.status).to eq(401)
        expect(response.body).to eq({ error: "Invalid access token" }.to_json)
      end

      context "requesting errors in French" do
        before { headers["Accept-Language"] = "fr" }

        it "returns an error in French" do
          get "/coach_middleware_chain/attendees/#{attendee.id}",
              headers: headers

          expect(response.status).to eq(401)
          expect(response.body).to eq({ error: "Jeton d'accès invalide" }.to_json)
        end
      end
    end
  end
end
