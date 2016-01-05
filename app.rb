require 'sinatra'
require "sinatra/reloader" if development?
load 'captcha.rb'

get '/' do
  source_text = load_source_text
  exclude = generate_exclusion_array(source_text)

  erb :index, locals: { source_text: source_text, exclude: exclude }
end

# get captcha data from the system in json format, previously get '/'
get '/captcha' do
  source_text = load_source_text
  exclude = generate_exclusion_array(source_text)

  erb :"get.json", locals: { source_text: source_text, exclude: exclude }
end

# process a user's response
post '/captcha' do

end

def load_source_text()
  # load one of the following stock texts (default implementation)
  files = %w(0 1 2 3 4 5)
  text_file = "texts/#{files.sample}"
  File.read(text_file).strip
end