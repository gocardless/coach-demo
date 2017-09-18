# frozen_string_literal: true

class Attendee < ApplicationRecord
  validates :first_name, :last_name, presence: true
end
