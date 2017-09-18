# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, :access_token, presence: true
end
