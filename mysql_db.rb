#coding: utf-8
require 'mysql2'
require 'active_record'

# Connect to an in-memory sqlite3 database
ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  database: 'vehicle_db',
  encoding: 'utf8',
  reconnect: 'true',
  pool: 10,
  username: 'root',
  password: 'root'
)

# Define a minimal database schema
ActiveRecord::Schema.define do
  create_table :shows, force: true do |t|
    t.string :name
  end

  create_table :episodes, force: true do |t|
    t.string :name
    t.belongs_to :show, index: true
  end
end

# Define the models
class Show < ActiveRecord::Base
  has_many :episodes, inverse_of: :show
end

class Episode < ActiveRecord::Base
  belongs_to :show, inverse_of: :episodes, required: true
end

# Create a few records...
show = Show.create!(name: 'Big Bang Theory')

first_episode = show.episodes.create!(name: 'Pilot')
second_episode = show.episodes.create!(name: 'The Big Bran Hypothesis')

episode_names = show.episodes.pluck(:name)

puts "#{show.name} has #{show.episodes.size} episodes named #{episode_names.join(', ')}."
# => Big Bang Theory has 2 episodes named Pilot, The Big Bran Hypothesis.

# Use `binding.pry` here to experiment with this setup.
