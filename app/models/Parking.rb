class Parking < ApplicationRecord

  def time
    (created_at - Time.zone.now) / 1.minutes
  end

end
