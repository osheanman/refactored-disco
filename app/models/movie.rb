class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    if ratings_list.nil?
      return self.all
    else
      return self.where(rating: ratings_list)
    end
  end
  
  def self.all_ratings()
    return ['G','PG','PG-13','R']
  end
end
