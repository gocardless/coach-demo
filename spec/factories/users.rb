# frozen_string_literal: true

require "securerandom"

FactoryGirl.define do
  factory :user do
    email "tim@gocardless.com"
    access_token { SecureRandom.hex }

    trait :can_manage_attendees do
      permissions ["attendees"]
    end
  end
end
