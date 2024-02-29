# app/controllers/api/approval_queue_controller.rb
class Api::ApprovalQueueController < ApplicationController
  def index
    @approval_queue = ApprovalQueue.order(created_at: :asc)
    render json: @approval_queue
  end
end
