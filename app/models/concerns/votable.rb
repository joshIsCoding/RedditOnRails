require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    scope :with_votes, -> do
      select( "#{self.table_name}.*, COALESCE(SUM(votes.value), 0) AS vote_sum" )
      .left_joins(:votes)
      .group("#{self.table_name}.id")
    end

    # must be chained to ::with_votes
    scope :sort_by_votes, -> { order( vote_sum: :desc ) }
  end

  def vote( type = :up, user )
    return false if self.author == user
    value = ( type == :down || type == "down" ) ? -1 : 1
    vote = Vote.new(votable: self, voter: user, value: value)
    vote.save
  end
end