require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    scope :sort_by_votes, -> do 
      select("#{self.table_name}.*, COALESCE(SUM(votes.value), 0) AS vote_sum")
      .left_joins(:votes)
      .order(vote_sum: :desc)
      .group("#{self.table_name}.id")
    end
  end
end