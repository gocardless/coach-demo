# frozen_string_literal: true

Rails.application.routes.draw do
  router = Coach::Router.new(self)
  router.draw(Routes::Attendees, base: "/attendees", actions: [:show])
end
