require 'sinatra/base'
require 'slim'
require 'sequel'

DB = Sequel.connect('sqlite://signatures.db')

DB.create_table(:signatures) do
  primary_key :id
  String :email
end unless DB.tables.include?(:signatures)

class Signature < Sequel::Model
  plugin :validation_helpers
  def raise_on_save_failure
    false
  end

  def validate
    super
    validates_presence [:email]
    validates_unique :email
  end
end

class RubyDesignSignature < Sinatra::Base
  get '/' do
    slim :index
  end

  post '/sign' do
    puts params[:email]
  end
end

run RubyDesignSignature.new
