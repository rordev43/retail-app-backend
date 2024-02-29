class ApprovalQueue < ApplicationRecord
  belongs_to :product

  validates :product, presence: true
  validates :status, presence: true, inclusion: { in: %w(pending_approval) }
end
