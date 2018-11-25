# travelingo-api

This is Travelingo's API

## Before you begin

- make sure you have Ruby 2.5.1 installed on your computer. [Instructions](https://dev.to/andy/installing-ruby-250--2pe1)
- install gems with `bundle install`
- read carefully `/.env` file and make desirable corrections in `.env.*` files for each environment. For example, `APP_URL` should be set in production to make Slack notifications links lead to the correct URL.

# Firebase

## FIREBASE_PROJECT_ID

In order to run the app you will need to set this var in `.env` file (*done*)

## Cron task

Firebase certs are updated daily, so special task created ``firebase:get_current_certs``
To update certs, just run it, or set cron to update hourly (just to make sure) ``whenever --update-crontab`` (you definitely want to do it in production)

## Token decoder

Another useful rake task ``firebase:decode_jwt[<jwt>]`` can be used to debug token.
*NOTE: it doesn't verify token for ease of use. For example doesn't report if token outdated*

Don't forget to get fresh certs, of course

# Tests

``spec/spec_helper`` contains jwt-related test settings for my another project, this doesn't affect tests in any way, so you can keep them.

# Slack

*Don't forget to set valid env variables in order to this integration work*

- you can test slack notifications JSON [here](https://api.slack.com/docs/messages/builder)
- [message guidelines](https://api.slack.com/docs/message-guidelines)
- [attachments](https://api.slack.com/docs/message-attachments)
- [message formatting](https://api.slack.com/docs/message-formatting)
