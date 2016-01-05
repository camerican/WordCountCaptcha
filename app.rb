require 'sinatra'
require "sinatra/reloader" if development?
load 'captcha.rb'

get '/' do

end

# get captcha data from the system, previously get '/'
get '/captcha' do
  # load one of the following stock texts (default implementation)
  files = %w(texts/0 texts/1 texts/2 texts/3 texts/4 texts/5)

  text_file = files.sample
  source_text = File.read(text_file).strip

  # replace previous implementation with captcha.rb function
  text_array = generate_word_array(source_text)

  exclude = []
  for i in (0...number_of_words_to_exclude(text_array.length))
     exclude << text_array[i]
  end
  
  erb :"get.json", locals: { source_text: source_text, exclude: exclude }
end

# process a user's response
post '/captcha' do

end