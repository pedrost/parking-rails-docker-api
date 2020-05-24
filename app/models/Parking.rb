class Parking < ApplicationRecord

  def time
    "#{( (created_at - Time.zone.now) / 1.minutes ).abs.round(0) } #{I18n.t("tz.minutes")}"
  end

end
