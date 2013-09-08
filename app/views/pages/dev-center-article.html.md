# Finding the N nearest things to a point, using Rails and PostGIS on Heroku

Applications often need to find the N nearest things to a point, for example: a restaurant-finder might show the nearest 10 restaurants to its user’s location. This article explains how to use Rails and PostGIS on Heroku to perform fast ‘nearest things’ searches.

## Upgrade to a Production tier database

PostGIS is only available on Production tier databases. To upgrade to a Production tier database, [follow this guide](https://devcenter.heroku.com/articles/upgrade-heroku-postgres-with-pgbackups).

## Install PostGIS on your local machine

Ensure both [PostgreSQL](http://www.postgresql.org) and [PostGIS](http://postgis.org) are installed on your local machine.

>callout
>The most reliable way to get both on OSX is to download and install [Postgres.app](http://postgresapp.com).

## Enable PostGIS

PostGIS can be enabled using a Rails Migration or `psql`. Using a Rails Migration improves development, test, staging and production parity.

### Enabling PostGIS using a Rails Migration

Create a migration file using `rails`:

```term
$ rails g migration EnablePostGIS
      invoke  active_record
      create  db/migrate/20130908194644_enable_post_gis.rb
```

Edit the migration file depending on your version of Rails.

#### Rails 4

```ruby
class EnablePostGis < ActiveRecord::Migration
  def change
    enable_extension :postgis
  end
end
```

#### Rails 3

```ruby
class EnablePostGis < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION postgis;"
  end

  def down
    execute "DROP EXTENSION postgis;"
  end
end
```

>callout
>Don’t forget to run `rake db:migrate` after creating migrations!

### Enabling PostGIS using `psql`

Establish a `psql` session with your remote database using `$ heroku pg:psql`, create the PostGIS extension using `CREATE EXTENSION postgis;` then quit `psql` using `\q`.

```term
$ heroku pg:psql
psql (9.1.4, server 9.2.4)

SSL connection (cipher: DHE-RSA-AES256-SHA, bits: 256)
Type "help" for help.

dbn625oqb52h1v=> CREATE EXTENSION postgis;
CREATE EXTENSION
dbn625oqb52h1v=> \q
```

## Set up Rails for PostGIS

### Install `activerecord-postgis-adapter`

Add the following line to your `Gemfile` then run `bundle install`.

```
gem 'activerecord-postgis-adapter'
```

### Configure ActiveRecord to use the PostGIS adapter

Create an initializer for PostGIS at `config/initializers/postgis.rb`:

```ruby
Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    config = Rails.application.config.database_configuration[Rails.env]
    config['adapter'] = 'postgis'
    ActiveRecord::Base.establish_connection(config)
  end
end
```

Additionally, if Unicorn or any other process forking code is used where the connection is re-established, make sure to override the adapter to `postgis` as well. For example:

```ruby
# unicorn.rb
after_fork do |server, worker| 
  if defined?(ActiveRecord::Base) 
    config = Rails.application.config.database_configuration[Rails.env]
    config['adapter'] = 'postgis'
    ActiveRecord::Base.establish_connection(config)
  end 
end
```

## Set up your model for PostGIS

### Create a migration to add a location to your model

Let’s assume you have a `Restaurant` model and you want to save each restaurant’s location. Create a migration using `rails g migration AddLocationToRestaurants` then edit the file:

```ruby
class AddLonlatToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :lonlat, :point, :geographic => true
  end
end
```

>callout
>Don’t forget to run `rake db:migrate` after creating migrations!

### Update your model’s location

Add the following methods to your model, so its location can be updated using syntax such as `restaurant.lon = -0.1245748` or `Restaurant.new(lat:51.5007046, lon: -0.1245748)`.

```ruby
class Restaurant < ActiveRecord::Base
  attr_writer :lon, :lat

  def lon
    @lon ||= lonlat.try(:x)
  end

  def lat
    @lat ||= lonlat.try(:y)
  end

  before_save do
    self[:lonlat] = "POINT(#{lon} #{lat})"
  end
end
```

>callout
>Longitude (lon) runs north to south. Latitude (lat) runs east to west.

### Add a 'nearest' method

Add the `nearest` method to your model. `restaurant.nearest` will return `resturant’s` nearest neighbor; `restaurant.nearest 10` will return `resturant’s` 10 nearest neighbors, nearest first. 

```ruby
class Poi < ActiveRecord::Base
  #…
  def nearest(count=1)
    order = "lonlat::geometry <-> st_setsrid(st_makepoint(#{lon},#{lat}),4326)"
    Poi.order(order).offset(1).limit(count)
  end
  #…
end
```

### Speed up searches

Using a GiST index will significantly speed up nearest neighbor searches.

Create a migration using `rails g migration AddIndexToRestaurantLonlat` then edit the file:

```ruby
class AddIndexToRestaurantLonlat < ActiveRecord::Migration
  def change
    add_index :restaurants, :lonlat, using: 'GIST'
  end
end
```

>callout
>Don’t forget to run `rake db:migrate` after creating migrations!

