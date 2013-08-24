require 'sinatra'
require 'mongoid'

Mongoid.load!("mongoid.yml", :developement)

class Servers
    include Mongoid::Document
    field :server_name, type: String
    field :uri, type: String
    field :creation_date, type: String
    field :last_reset, type: String
    field :user, type: String
end

class User
    include Mongoid::Document
    field :user, type: String
    field :key, type: String
    field :limit, type: Integer
end

post '/:action/:server' do #Available actions: get, set, delete
    api_key = params[:api_key]

    if api_key.empty?
        "Missing API Key"
    else
        client = User.where(key: api_key).first
        if client.empty?
            "Invalid API Key"
        else
            server = Servers.where(server_name: :server, user: client.user).first
            date = Time.strftime("%%B %%d, %%Y") #Example Date Output: August 24th, 2013

            if server.empty?
                "No Server found under the name, #{:server} for user: #{client.user}, creating a new one if possible"

                if client.limit < Servers.where(user: client.user).count
                    new_uri = params[:new_uri]

                    if new_uri.empty?
                        Servers.where(server_name: :server, user: client.user, uri: "", creation_date: date, last_reset: date).create!
                        "Server created, please set a URI for it to use"
                    else
                        Servers.where(server_name: :server, user: client.user, uri: new_uri, creation_date: date, last_reset: date).create!
                    end
                else
                    "Server amount limit reached, please delete a server to make room"
                end
            else
                case :action
                    when "get"
                        server.uri
                    when "set"
                        new_uri = params[:new_uri]
                        if new_uri.empty?
                            "Missing new_uri param"
                        else
                            server.update(uri: new_uri, last_reset: date)
                        end
                    when "delete"
                        server.delete
                    else
                        "Unknown action #{:action}"
                end
            end
        end
    end
end