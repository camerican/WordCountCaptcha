require "./spec/spec_helper"

describe 'Within the Captcha system,' do

  let(:text){ "Here is some text for you to look at.  It is text that I wrote myself, right?" }
  let(:text_len){ 15 }
  let(:a_text){ %w(here is some text for you to look at it that i wrote myself right) }

  context "generate_word_array" do
    it "returns an array upon receipt of text" do
      expect(generate_word_array(text).class).to eq(Array)
    end

    it "returns the correct number of unique words" do 
      expect(generate_word_array(text).length).to eq(text_len)
    end

    it "returns the correct array" do
      expect(generate_word_array(text)).to eq(a_text)
    end
  end

  context "number_of_words_to_exclude" do
    let(:a_len){ [15, 1, 0, 2, 6] }

    it "should return a number between 1 and 7 given a size of 15" do
      expect(number_of_words_to_exclude(a_len[0])).to satisfy {|v| v >= 1 && v <= 7 }
    end

    it "should return 0 given a size of 1" do
      expect(number_of_words_to_exclude(a_len[1])).to eq(0) 
    end

    it "should return 0 given a size of 0" do
      expect(number_of_words_to_exclude(a_len[2])).to eq(0) 
    end

    it "should return 1 given a size of 2" do
      expect(number_of_words_to_exclude(a_len[3])).to eq(1) 
    end

    it "should return a number between 1 and 3 given a size of 6" do
      expect(number_of_words_to_exclude(a_len[4])).to satisfy {|v| v >= 1 && v <= 3 }
    end
  end

  context "generate_exclusion_array" do
    let(:s_one){ "lonely" }
    let(:s_two){ "best friends" }
    let(:s_empty){ "" }
    let(:s_spaces){ "        " }
    let(:s_repeated){ "pretty please please please Please Please please please" }
    let(:s_ex1){ "It was the best of times, it was the worst of times.  Okay, that seems like a contradiction." }
    let(:s_ex2){ "The holidays wound up absorbing almost all available time, funny how that works, right?"}

    it "should return an empty exclusion array from a one-word paragraph" do
      expect(generate_exclusion_array(s_one)).to eq([])
    end

    it "should return a single element array from a two-word paragraph" do
      expect(generate_exclusion_array(s_two)).to satisfy{|a| a == ["best"] || a == ["friends"] }
    end

    # we should consider this an error case and handle it 
    it "should return an empty exclusion array from an empty paragraph" do
      expect(generate_exclusion_array(s_empty)).to eq([])
    end

    it "should return an empty exclusion array if given only spaces" do
      expect(generate_exclusion_array(s_empty)).to eq([])
    end

    it "should return a single element array from a paragraph with two unique words" do
      expect(generate_exclusion_array(s_repeated)).to satisfy{|a| a == ["pretty"] || a == ["please"] }
    end

    it "should return an exclusion array from between 1-6 elements for a paragraph with 13 unique words" do
      expect(generate_exclusion_array(s_ex1)).to satisfy{|a| a.length >= 1 && a.length <= 6 }
    end

    it "should return an exclusion array from between 1-7 elements for a paragraph with 14 unique words" do
      expect(generate_exclusion_array(s_ex2)).to satisfy{|a| a.length >= 1 && a.length <= 7 }
    end

    it "should return an exclusion array of 4 elements for a paragraph with 14 unique words when we specify 4 elements" do
      expect(generate_exclusion_array(s_ex2,4)).to satisfy{|a| a.length == 4 }
    end
  end

  context "verify_word_count" do
    let(:exclusion_array1){ ["here","is"]}
    let(:guess1_correct){ 13 }
    let(:guess1_incorrect){ 7 }
    let(:exclusion_array2){ ["here","is", "i", "myself", "right"]}
    let(:guess2_correct){ 10 }
    let(:guess2_incorrect){ 0 }
    let(:exclusion_array3){ []}
    let(:guess3_correct){ 15 }
    let(:guess3_incorrect){ 18 }

    it "should detect a correct guess when supplied source_text, exclude, and right guess" do
      expect(verify_word_count(text,exclusion_array1,guess1_correct)).to eq(true) 
      expect(verify_word_count(text,exclusion_array2,guess2_correct)).to eq(true) 
      expect(verify_word_count(text,exclusion_array3,guess3_correct)).to eq(true) 
    end

    it "should detect an incorrect guess when supplied source_text, exclude, and wrong guess" do
      expect(verify_word_count(text,exclusion_array1,guess1_incorrect)).to eq(false) 
      expect(verify_word_count(text,exclusion_array2,guess2_incorrect)).to eq(false) 
      expect(verify_word_count(text,exclusion_array3,guess3_incorrect)).to eq(false) 
    end
  end

end 