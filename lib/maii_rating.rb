# frozen_string_literal: true

require 'rest_client'
require 'json'

# This class is basic connection class to instantiate objects from
# https://rating.maii.li/api/
#
# @author Eugene Lapeko <eugene@lapeko.info>
class MaiiRating
  attr_reader :rating_model

  # release object
  class Release
    attr_reader :date, :id

    def initialize(hash)
      @date = Date.parse(hash[:date])
      @id = hash[:id].to_i
    end
  end

  # team object
  class Team
    attr_reader :place, :id, :rating, :rating_change, :tournaments

    def initialize(hash)
      @place = hash[:place]
      @id = hash[:team_id]
      @rating = hash[:rating]
      @rating_change = hash[:rating_change]
      @tournaments = hash[:tournaments] # TODO: define TeamTournamentResult class
    end
  end

  # player object
  class Player
    attr_reader :place, :id, :rating, :rating_change, :tournaments

    def initialize(hash)
      @place = hash[:place]
      @id = hash[:player_id]
      @rating = hash[:rating]
      @rating_change = hash[:rating_change]
      @tournaments = hash[:tournaments] # TODO: define PlayerTournamentResult class
    end
  end

  def initialize(model = :b)
    @rating_model = model

    @connection = RestClient::Resource.new("https://rating.maii.li/api/v1/#{rating_model}/")
  end

  def releases(&block)
    get_objects('releases.json', self.class::Release, &block)
  end

  def teams(release, &block)
    # Raise unless release is number or Release object
    id = release.is_a?(Numeric) ? release : release.id

    get_objects("teams/#{id}.json", self.class::Team, &block)
  end

  def players(release, &block)
    # Raise unless release is number or Release object
    id = release.is_a?(Numeric) ? release : release.id

    get_objects("players/#{id}.json", self.class::Player, &block)
  end

  private

  def get_objects(url, klass, &block)
    block ||= proc { true }
    page = 1
    result = []

    loop do
      response = @connection["#{url}?page=#{page}"].get
      # TODO: check response code

      data = JSON.parse(response.body, symbolize_names: true)
      result += data[:items].map { |item| klass.new(item) }.select(&block)

      break result unless data.key?(:pages) && data[:pages] > page

      page += 1
    end
  end
end
