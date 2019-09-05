class MilestoneAttributeOption < ApplicationRecord
  belongs_to :milestone_attribute

  before_validation :set_option_value

  private

  def set_option_value
    self.value = value.presence || name
  end
end
