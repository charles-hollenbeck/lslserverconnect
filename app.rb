require 'sinatra'

class Servers
    include Mongoid::Document
    field :server_name, type :String
    field :uri, type: String
    field :creation_date, type: Date
    field :last_reset, type: Date
    field :last_request, type: DateTime
end

class API_Key
    include Mongo::Document
    field :user, type String
    field :key, type String
end

post '/set/:server' do
    #Wanting to set a server
end

get '/get/:server' do
    server = Servers.where(server_name: :server)
    if server.empty? do
        "BOOOOO IT WORKS"
    end
end