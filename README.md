# Coach Demo

This repository is a demo project for [Coach](https://github.com/gocardless/coach).

Coach makes it simple to build maintainable, testable, reliable and well-engineered HTTP
endpoints (especially APIs) in Ruby, moving away from monolithic `ActionController`
controllers towards chains of Coach middleware, each with a single responsibility.

This project is designed to make clear the challenges and pains that come from using
ActionController for anything beyond the most simple endpoints, and then show how you
can solve these problems using Coach.

## Where do I start?

This project does not contain an application you'd actually want to run! It contains
a simple, tested API built using Rails's ActionController (see
`app/controllers/attendees_controller.rb` and
`spec/controllers/attendees_controller_spec.rb`), and then that same API built
using modular Coach middleware (see `app/routes`, `spec/routes` and `spec/requests`).

All we've built is a simple API for viewing attendees of an event. But including
common functionality like authentication and internationalisation already begin to show
the growing pains that come with controllers.



