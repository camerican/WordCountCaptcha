# captcha.rb 
# implements functional requirements for implementing captcha tests on text data
#
# 

# Generate Exclusion Array
# Returns an exclusion list from a body of text
#
# @param text the body of text to analyze
# @param n desired size of exclusion list to return (optional)
# @returns an array exclusion list
def generate_exclusion_array( text, n = nil ) 
  a_w = generate_word_array(text)
  a_w.sample(number_of_words_to_exclude(a_w.length,n)) 
end


# Generate Word Array
# Converts string into an array of unique downcase words with punctuation removed
#
# @param text the body of text to analyze
# @returns an array of words
def generate_word_array( text )
  return [] unless text 
  text.downcase.split(" ").map{|w| w.tr('.?!-;:"()[]{}/','')}.uniq  # load array of unique words w/ downcase conversion
  # 1) convert to downcase, 2) split into array, 3) remove punctuation, 4) remove duplicates
end

# Number Of Words To Exclude
# Determines how many words to exclude based upon the size of the unique word array
# This number will be a random number between 1 and half the number of total elements
# unless there are one or less total words, in whicih case it will be 0
#
# @param size of the word array
# @param desired size of the exclusion array (optional)
# @returns the desired size of the exclusion array
def number_of_words_to_exclude( size, desired = nil )
  return 0 if size <= 1 || size.class != Fixnum # if we don't have a number or enough elements, no exclusion array
  if( desired.class == Fixnum && size > desired ) # only allow desired size if provided AND it's smaller than total word array size
    desired
  else
    (1..([(size/2),5].min)).to_a.sample  if size > 1 # else, let's specify an exclusion array size of at least 1 up to half the total number of words
    # up to a max of 5
  end
end