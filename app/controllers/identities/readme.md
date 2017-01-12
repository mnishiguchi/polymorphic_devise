## Continuing with OAuth that does not provide email

- 1. Assign temp email to the user's identity record

```
# An example of a temp email
"change@me-gcuftcptlnzw42tft9vm.com"
```

```
# app/models/identity.rb
# Identity model can identify temp emails using pre-defined prefix.
TEMP_EMAIL_PREFIX = 'change@me'
TEMP_EMAIL_REGEX = /\Achange@me/
```

- 2. Redirect the user to email_confirmations#show
  + Ask user to enter his/her email address.
  + Send a link to log in.

```
email_confirmations GET       /email_confirmations email_confirmations#show
                    PUT|PATCH /email_confirmations email_confirmations#update
```

- 3. User click on the log in link in his/her inbox
  + Update the user's email now that it is confirmed.
  + Log in this user.


## Scenarios where user get a password registered

- 1. Web developer manually create a record. <==
- 2. Sign up
  + `registrations#new`
  + `confirmations#show` <==
- 3. Forgot password
  + `password#new`
  + `password#edit` <==
