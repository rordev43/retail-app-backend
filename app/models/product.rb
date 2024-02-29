class Product < ApplicationRecord
  has_one :approval_queue 

  validates :name, presence: true
  validates :price, presence: true, numericality: { less_than_or_equal_to: 10_000 }
  validates :status, presence: true, inclusion: { in: %w(active pending_approval) }

  validate :validate_price

  private

  def validate_price
    if price > 10000
      errors.add(:price, "cannot exceed $10,000")
    elsif price > 5000
      self.status = 'pending_approval'
    end
  end
end
