class Order < ApplicationRecord
  validates :qty, numericality: {only_integer: true}

  def public_method
    "#{name}: #{qty}"
  end

  def self.class_method
    true
  end
end
