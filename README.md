# QBank

The web service to receive bulk transfer requests from a single account.

# Installation on macOS

## 1 Install [Homebrew](https://brew.sh/)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

## 2 Install [PostgreSQL](https://www.postgresql.org/)

2.1 Run the following command to install PostgreSQL
```bash
brew install postgresql
```

2.2 Start PostgreSQL services with Homebrew and add autoload
```bash
brew services start postgresql
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
```

2.3 Create your default user database
```bash
createdb `whoami` 
```

2.4 Create user
```bash
createuser -s -r postgres
```

## 3 Install [Redis](https://redis.io/)

### 3.1 Install Redis
```bash
brew install redis
```

### 3.2 Launch Redis
```bash
brew services start redis
```

### 3.3 Launch Redis on boot
To have Redis launch on system boot, use:
```bash
ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
```

### 3.4 Test if Redis server is running
Ping your redis server to verify if it’s running:
```bash
redis-cli ping
```

## 4 Install [RVM](https://rvm.io/rvm/install) and [Ruby](https://www.ruby-lang.org/en/)

### 4.1 Install GPG keys
As a first step install GPG keys used to verify installation package:
```bash
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```
### 4.2 Install RVM (development version)
```bash
\curl -sSL https://get.rvm.io | bash
```

### 4.3 Install Ruby
```bash
rvm install "ruby-3.0.2"
```

## 5 Install the project

### 5.1 Install gems
```bash
gem install bundler -v 2.3.10
```
```bash
bundle install
```

### 5.2 Editing credentials
For edit **ENV** variables you have to use:
```bash
EDITOR="vim" rails credentials:edit --environment production
EDITOR="vim" rails credentials:edit --environment development
EDITOR="vim" rails credentials:edit --environment test
```

### 5.3 Create database

```bash
rails db:create db:migrate
```

### 5.4 Seed database with test data:

```bash
rails db:seed
```

### 5.5 Start your Rails server:

```bash
rails server
```

## 6 Start [Sidekiq](https://github.com/mperham/sidekiq)

```bash
bundle exec sidekiq -q default mailer
```

## 7 Request example to API

```bash
curl --location --request POST 'localhost:3000/api/v1/transfers' \
--header 'Content-Type: application/json' \
--data-raw '{
  "organization_name": "ACME Corp",
  "organization_bic": "OIVUSCLQXXX",
  "organization_iban": "FR10474608000002006107XXXXX",
  "credit_transfers": [
    {
      "amount": "14.5",
      "currency": "EUR",
      "counterparty_name": "Bip Bip",
      "counterparty_bic": "CRLYFRPPTOU",
      "counterparty_iban": "EE383680981021245685",
      "description": "Wonderland/4410"
    },
    {
      "amount": "61238",
      "currency": "EUR",
      "counterparty_name": "Wile E Coyote",
      "counterparty_bic": "ZDRPLBQI",
      "counterparty_iban": "DE9935420810036209081725212",
      "description": "//TeslaMotors/Invoice/12"
    }
  ]
}
'
```
## Fix "Warning! PATH is not properly set up" on macOS

Add this code to the bottom of the your `.bash_profile` file:

```bash
# RVM can encounter errors if it's not the last thing in .bash_profile
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to path for scripting (to manage Ruby versions)
export PATH="$GEM_HOME/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
```
