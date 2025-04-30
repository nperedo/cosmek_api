class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :time, :duration, :status

  belongs_to :customer, serializer: CustomerSerializer
  belongs_to :stylist, serializer: StylistSerializer
end
