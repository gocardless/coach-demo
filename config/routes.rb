# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :controllers, module: nil do
    resources :attendees, only: :show
  end

  router = Coach::Router.new(self)
  router.draw(Routes::CoachMiddlewareChain::Attendees,
              base: "coach_middleware_chain/attendees",
              actions: [:show])

  router.draw(Routes::SingleCoachMiddleware::Attendees,
              base: "single_coach_middleware/attendees",
              actions: [:show])
end
