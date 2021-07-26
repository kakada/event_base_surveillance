class MedisysFeedsController < ApplicationController
  def index
    @medisies = policy_scope(Medisy.order("created_at ASC"))
    @pagy, @medisys_feeds = pagy(policy_scope(authorize MedisysFeed.filter(feed_params).order(pub_date: :DESC)))
  end

  private
    def feed_params
      @medisy_id = params[:medisy_id] || current_program.try(:medisies).try(:first).try(:id) || Medisy.first.try(:id)
      params.merge(medisy_id: @medisy_id)
    end
end
