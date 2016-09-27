# Sinatra Sequel Extension 
[![Build Status](https://travis-ci.org/mrbanzai/sinatra-sequel_extension.svg?branch=master)](https://travis-ci.org/mrbanzai/sinatra-sequel_extension) [![Code Climate](https://codeclimate.com/github/mrbanzai/sinatra-sequel_extension/badges/gpa.svg)](https://codeclimate.com/github/mrbanzai/sinatra-sequel_extension) [![Coverage Status](https://img.shields.io/coveralls/mrbanzai/sinatra-sequel_extension.svg)](https://coveralls.io/r/mrbanzai/sinatra-sequel_extension) [![Inline docs](http://inch-ci.org/github/mrbanzai/sinatra-sequel_extension.svg?branch=master)](http://inch-ci.org/github/mrbanzai/sinatra-sequel_extension) [![Dependency Status](https://gemnasium.com/mrbanzai/sinatra-sequel_extension.svg)](https://gemnasium.com/mrbanzai/sinatra-sequel_extension) 

This is a fork of [danascheider's Sinatra Sequel extension](https://github.com/danascheider/sinatra-sequel_extension).

Extends [Sinatra](http://www.sinatrarb.com/) with a variety of extension methods
for dealing with a SQL database using the [Sequel ORM](http://sequel.rubyforge.org/).

As a courtesy to the gem's original author, `sinatra-sequel_extension` is not yet
published on https://rubygems.org pending the addition of substantial differentiating 
features. Instead, you will need to use the following code to install
Install the `sinatra-sequel_extension` gem along with one of the database adapters:

    sudo gem install sinatra-sequel_extension --source https://github.com/mrbanzai/sinatra-sequel_extension

If you are using Bundler, then add the source to your Gemfile:

    gem 'sinatra-sequel_extension', :git => 'git://github.com/mrbanzai/sinatra-sequel_extension.git'

Once listed in your Gemfile, this gem can be installed like other gems using 
`bundle install`. Be aware that `gem list` will not display gems added in this manner.

I like to split database configuration and migrations out into a separate
`database.rb` file and then require it from the main app file, but you can plop
the following code in about anywhere and it'll work just fine:

    require 'sinatra'
    require 'sinatra/sequel'

    # Establish the database connection; or, omit this and use the DATABASE_URL
    # environment variable as the connection string:
    set :database, 'sqlite://foo.db'

    # At this point, you can access the Sequel Database object using the
    # "database" object:
    puts "the foos table doesn't exist" if !database.table_exists?('foos')

    # define database migrations. pending migrations are run at startup and
    # are guaranteed to run exactly once per database.
    migration "create teh foos table" do
      database.create_table :foos do
        primary_key :id
        text        :bar
        integer     :baz, :default => 42
        timestamp   :bizzle, :null => false

        index :baz, :unique => true
      end
    end

    # you can also alter tables
    migration "everything's better with bling" do
      database.alter_table :foos do
        drop_column :baz
        add_column :bling, :float
      end
    end

    # models just work ...
    class Foo < Sequel::Model
      many_to_one :bar
    end

    # see:
    Foo.filter(:baz => 42).each { |foo| puts(foo.bar.name) }

    # access the database within the context of an HTTP request
    get '/foos/:id' do
      @foo = database[:foos].filter(:id => params[:id]).first
      erb :foos
    end

    # or, using the model
    delete '/foos/:id' do
      @foo = Foo[params[:id]]
      @foo.delete
    end

### Sequel Reference Material

  * The [Sequel README](http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html)
    and [CHEATSHEET](http://sequel.jeremyevans.net/rdoc/files/doc/cheat_sheet_rdoc.html)
    are quite useful.

  * Migrations are a light facade over Sequel's
    [Schema module](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html),
    like [create_table and alter_table](hhttp://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html).

  * The best reference on Sequel Models is [the README](http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html)
    and the [Associations](http://sequel.jeremyevans.net/rdoc/files/doc/advanced_associations_rdoc.html) doc.
    You might find this post on [many_to_many / one_to_one](http://steamcode.blogspot.com/2009/03/sequel-models-manytoone-onetomany.html)
    useful.
