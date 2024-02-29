class CreateApprovalQueues < ActiveRecord::Migration[6.1]
  def change
    create_table :approval_queues do |t|
      t.references :product, foreign_key: true, null: false
      t.string :status, default: 'pending_approval', null: false

      t.timestamps
    end
  end
end
