require 'sinatra'
require 'mongoid'

Mongoid.load!("mongoid.yml", :developement)


class Servers
    include Mongoid::Document
    field :server_name, type: String
    field :uri, type: String
    field :creation_date, type: Date
    field :last_reset, type: Date
    field :last_request, type: DateTime
    field :user, type: String
end

class User
    include Mongoid::Document
    field :user, type: String
    field :key, type: String
end

post '/set/:server' do
    api_key = params[:api_key]
    new_uri = params[:new_uri]

    if api_key.empty? or new_uri.empty?
        "Incorrect params, should have api_key and new_uri set."
    else
        client = User.find(key: api_key).first
        if client.empty?
            "Invalid API Key"
        else
            date = Time.strftime("%%b %%d, %%Y")
            server = Servers.where(server_name: :server, user: client.user).update(uri: new_uri, last_reset: date)
        end
    end
end

get '/get/:server' do
    server = Servers.find(server_name: :server).first
    if server.empty?
        "No server found under the name, #{:server}."
    else
        server.uri
    end
end
