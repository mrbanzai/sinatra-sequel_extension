require 'spec_helper'

describe 'A Sinatra app with Sequel extensions' do
  let(:app) { Class.new(MockSinatraApp).set :migrations_log, File.open('/dev/null', 'wb') }

  before(:each) do
    File.unlink 'test.db' rescue nil
    ENV.delete('DATABASE_URL')
  end

  it 'exposes the Sequel database object' do
    expect(app).to respond_to :database
  end

  it 'uses the DATABASE_URL environment variable if set' do
    ENV['DATABASE_URL'] = 'sqlite://test-database-url.db'
    expect(app.database_url).to eql 'sqlite://test-database-url.db'
  end

  it 'uses sqlite://<environment>.db when no DATABASE_URL is defined' do
    app.environment = :foo
    expect(app.database_url).to eql "sqlite://foo.db"
  end

  it 'establishes a database connection when set' do
    app.database = 'sqlite://test.db'
    expect(app.database).to respond_to :table_exists?
  end

  describe 'migrations' do 
    context 'basic functionality' do 
      before(:each) do 
        app.database = 'sqlite://test.db'
        app.migration 'create the foos table' do |db|
          db.create_table :foos do 
            primary_key :id
            text :foo
            integer :bar
          end
        end
      end

      it 'creates the table' do
        expect(app.database.table_exists?(:foos)).to be true
      end

      it 'runs the migration' do 
        expect(app.database[:migrations].count).to eql 1
      end
    end
  end

  it 'does not run database migrations more than once' do
    app.database = 'sqlite://test.db'
    app.migration('this should run once') { }
    app.migration('this should run once') { fail }
    expect(app.database[:migrations].count).to eql 1
  end

  it 'allows you to query what adapter is being used' do
    app.database = 'sqlite://test.db'
    expect(app.sqlite?).to be true
  end


  it 'exposes a query for all available sequel adapters' do
    Sequel::Database::ADAPTERS.each do |adapter|
      expect(app).to respond_to "#{adapter}?"
    end
  end
end
