require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @chars = Array.new()
    10.times do
      @chars << ("A".."Z").to_a.sample
    end
    session[:response] = @chars
  end

  def score
    @response = params[:response]
    @chars = session[:response]
    response_arr = @response.upcase.chars
    @result = ""
    @game_played = nil
    @score = nil
    session[:game_played] = session[:game_played].nil? ? 0 : session[:game_played]
    session[:score] = session[:score].nil? ? 0 : session[:score]
    if response_macth?(response_arr, @chars)
       if verify_reponse(@response)
        @result = "Congradulation! #{@response} is a world english"
        session[:score] += calculate_score(@response)
       else
        @result = "sorry but #{@response} does not seem to be a english world valid"
       end
    else
      @result = "sorry but #{@response} cannot be build with #{@chars}"
    end
    session[:game_played] += 1
    @score = session[:score]
    @game_played = session[:game_played]
  end

  private
  def response_macth?(response, chars)
    macth = false
    all_macth = []
    response.each_with_index do |element, element_id|
      macth = false
      chars.each_with_index do |char, char_id|
        if element == char && !macth
          chars[char_id] = nil
          macth = true
          all_macth << macth
        end
      end
    end
    # response.empty?
    response.size == all_macth.size
  end

  def verify_reponse(response)
    url = "https://dictionary.lewagon.com/#{response}"
    json_content = URI.open(url).read
    verification = JSON.parse(json_content)
    verification["found"] == true
  end

  def calculate_score(response)
    response.size * response.size
  end
end
