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
  # need to receive 1) the source_text, 2) exclusion list, 3) user guess, 4) authenticity hash
  result = verify_word_count params[:source_text], params[:exclude], params[:guess]
  if result
    status 200
    msg = ["Great job, you got it right!","I always knew you were human, sorry for putting you through that.","Looks good to me.","Thanks!  You got it!", "Great Scot, you did it!","Great Ceasers ghost, you really are human!","Your counting skills are impressive."]
  else # guess found to not match, error case
    status 400
    msg = ["You done goofed!","Nope, that ain't right!","Want to check again?","Can you even count?","That was pretty off.","Epic fail! I knew you were a robot!"]
  end
  erb :"post.json", locals: { source_text: params[:source_text], exclude: params[:exclude], guess: params[:guess], result: result, msg: msg.sample }
end

def load_source_text()
  # load one of the following stock texts (default implementation)
  files = %w(0 1 2 3 4 5)
  text_file = "texts/#{files.sample}"
  File.read(text_file).strip
end