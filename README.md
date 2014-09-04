Sinatra Sequel Extension [![Build Status](https://travis-ci.org/danascheider/sinatra-sequel_extension.svg?branch=master)](https://travis-ci.org/danascheider/sinatra-sequel_extension) [![Code Climate](https://codeclimate.com/github/danascheider/sinatra-sequel_extension/badges/gpa.svg)](https://codeclimate.com/github/danascheider/sinatra-sequel_extension) [![Coverage Status](https://img.shields.io/coveralls/danascheider/sinatra-sequel_extension.svg)](https://coveralls.io/r/danascheider/sinatra-sequel_extension)
==============
Sequel Sinatra is a rebranded fork of [rtomayko's Sinatra Sequel extension](https://github.com/rtomayko/sinatra-sequel), which has apparently not been maintained since early 2013. This fork was
adopted for incorporation into my other project, [Canto](https://github.com/danascheider/canto).
Versioning starts at 0.9.0, the version of sinatra-sequel at the time of forking.

Extends [Sinatra](http://www.sinatrarb.com/) with a variety of extension methods
for dealing with a SQL database using the [Sequel ORM](http://sequel.rubyforge.org/).

Install the `sinatra-sequel_extension` gem along with one of the database adapters:

    sudo gem install sequel sinatra-sequel_extension
    sudo gem install sqlite3
    sudo gem install mysql
    sudo gem install postgres

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

Do note that you must require `'sinatra/sequel'`, not the other way around.

### Sequel Reference Material

  * The [Sequel README](http://sequel.rubyforge.org/rdoc/files/README_rdoc.html)
    and [CHEATSHEET](http://sequel.rubyforge.org/rdoc/files/doc/cheat_sheet_rdoc.html)
    are quite useful.

  * Migrations are a light facade over Sequel's
    [Schema module](http://sequel.rubyforge.org/rdoc/files/doc/schema_rdoc.html).
    Like, [create_table](http://sequel.rubyforge.org/rdoc/classes/Sequel/Schema/Generator.html)
    and [alter_table](http://sequel.rubyforge.org/rdoc/classes/Sequel/Schema/AlterTableGenerator.html).

  * The best reference on Sequel Models is [the README](http://sequel.rubyforge.org/rdoc/files/README_rdoc.html)
    and the [Associations](http://sequel.rubyforge.org/rdoc/files/doc/advanced_associations_rdoc.html) doc.
    You might find this post on [many_to_many / one_to_one](http://steamcode.blogspot.com/2009/03/sequel-models-manytoone-onetomany.html)
    useful.
