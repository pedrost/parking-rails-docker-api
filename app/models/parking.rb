class Parking < ApplicationRecord

  validates :plate, format: { with: /[A-Z]{3}-[0-9]{4}/,
  message: I18n.t("activerecord.errors.models.parking.attributes.plate.invalid") }, uniqueness: true

  def time
    "#{( (created_at - Time.zone.now) / 1.minutes ).abs.round(0) } #{I18n.t("tz.minutes")}"
  end

  def left!
    if paid?
      update(left: true)
    else
      errors.add(:base, I18n.t("activerecord.errors.models.parking.attributes.left.not_paid"))
    end
  end

  def pay!
    update(paid: true)
  end

end
