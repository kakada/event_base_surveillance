class MilestoneFieldOption < ApplicationRecord
  belongs_to :milestone_field

  before_validation :set_option_value

  private

  def set_option_value
    self.value = value.presence || name
  end
end
