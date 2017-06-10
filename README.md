## User auth service

Rack compatible user authentication microservice. Can be run standalone or mounted into another rack app.

#### Dependencies

Ensure you have Sequel (> v.4.44.0) setup and connected in your application before attempting to mount UserAuth.

- Sequel (model plugins: :timestamps, :validation_helpers, :defaults_setter)
- Postgres (pg gem)
- Rack 2.0

## Usage

Add this line to your application's Gemfile:

```ruby
gem 'user-auth', git: 'https://github.com/dawsonandrews/services-user-auth'
```

And then execute:

```sh
$ bundle
```

### Import and run migrations

```ruby
# Add this to your Rakefile
require "bundler/setup"
require "user_auth/rake_tasks"
```

Copy migrations and migrate:

```sh
$ bin/rake user_auth:import_migrations
$ bin/rake db:migrate
```

### Map to a URL in config.ru

```ruby
require_relative "./config/boot"
require "user_auth/api"

# Somewhere after your middleware

map("/auth") { run UserAuth::Api }
```

### Configuration

```ruby
# config/initializers/user_auth.rb
UserAuth.configure do |config|
  config.jwt_exp = 3600 # Expire JWT tokens in 1 hour
  config.require_account_confirmations = false
  config.allow_signups = true

  # Lambda that gets called each time an email should be delivered
  # configure this with however your application sends email.
  config.deliver_mail = lambda do |params|
    # example params =>
    # {
    #   template: "user_signup",
    #   to: "email@email.com",
    #   user_id: 123,
    #   info: {
    #     email: "email@email.com",
    #     name: "Jane"
    #   }
    # }
    EmailDeliveryJob.new(params)
  end
end
```

That’s you all setup, see endpoints below for documentation on how to get a token etc.


## Endpoints

### `POST /signup`

**Params**

- **email** - Users email address
- **password** - Users password
- **info** - Basic key value json style object to store additional data about the user

```ruby
resp = HTTP.post("/signup", email: "test@example.org", password: "hunter2", info: { name: "Test" })

resp.parsed # =>

{
  token: "jwt-stateless-token-includes-user-data",
  refresh_token: "refresh-token"
}
```

### `POST /token`

**Params**

- **email** - Users email address
- **password** - Users password

```ruby
resp = HTTP.post("/token", email: "test@example.org", password: "hunter2")

resp.parsed # =>

{
  token: "jwt-stateless-token-includes-user-data",
  refresh_token: "refresh-token"
}
```

### `PUT /user`

**Params**

- **email** - Users email address
- **info** - Basic key value json style object to store additional data about the user

```ruby
resp = HTTP.put("/user", email: "newemail@example.org", info: { foo: "Bar" })

resp.parsed # =>

{
  token: "jwt-stateless-token-includes-user-data"
}
```

### `POST /logout`

Destroys all active refresh tokens (current JWT is still active for the standard timeout of 1 hour)

```ruby
resp = HTTP.post("/logout")

resp.parsed # =>

{}
```

### `POST /recover`

Delivers password reset emails

**Params**

- **email** - Users email address

```ruby
resp = HTTP.post("/recover", email: "test@example.org")

resp.parsed # =>

{}
```

### `PUT /user/attributes/password`

Update users password either by authenticating with a valid JWT or providing a password reset token (sent in the email from POST /recover)

**Params**

- **password** - Users new password

```ruby
resp = HTTP.put("/user/attributes/password", password: "new-password", token: "password-reset-token")

resp.parsed # =>

{
  token: "jwt-stateless-token-includes-user-data",
  refresh_token: "refresh-token"
}
```

### TODO:  `POST /verify`

Verify account, only required if confirmations are configured

```ruby
resp = HTTP.post("/verify", token: "confirmation-token")

resp.parsed # =>

{
  token: "jwt-stateless-token-includes-user-data",
  refresh_token: "refresh-token"
}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/user-auth.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
