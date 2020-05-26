class ParkingSerializer < ActiveModel::Serializer
  attributes :id, :time, :paid, :left

end 