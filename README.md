# template

This is a Rails 8 app.

## Documentation

This README describes the purpose of this repository and how to set up a development environment.

## Prerequisites

This project requires:

* Ruby 3.4.2, preferably managed using rvm
* PostgreSQL must be installed and accepting connections

If you need help setting up a Ruby development environment, check out this [Rails OS X Setup Guide](https://mattbrictson.com/rails-osx-setup-guide).

## Getting started

* run `docker compose build` in terminal
* run `docker compose run rails rails db:create` in terminal
* run `docker compose run rails rails db:migrate` in terminal
* run `docker compose run rails rails db:seed` in terminal
* run `docker compose up rails` in terminal
* Access the app at: `http://localhost:3000/`
