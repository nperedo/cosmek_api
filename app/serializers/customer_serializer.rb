class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :email
end
