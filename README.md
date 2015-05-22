# README

### Install dependencies

```
cd Speedlancer
bundle install
```

### We are using mysql, so copy the db configurations from database_sample.yml file into your database.yml file

```
cp config/database_sample.yml config/database.yml
```

### Database setup
```
rake db:create
rake db:migrate
```

### Reset db & populate test records
```
rake db:reset_and_populate
```

### Using delayed job for the sending emails

For development:-
```
RAILS_ENV=development bin/delayed_job start
```

For production:-

```
RAILS_ENV=production bin/delayed_job start
```

### Paypal Development Testing

* Install ngrok

* Run ngrok: ngrok 3000

* Copy output url, and update 'app_host' in secrets.yml file under development group


### Dependencies & Versions

* Ruby 2.2.0

* Rails 4.1.9

* Database: MySQL


