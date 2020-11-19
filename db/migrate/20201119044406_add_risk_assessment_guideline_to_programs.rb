# frozen_string_literal: true

class AddRiskAssessmentGuidelineToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :risk_assessment_guideline, :string
  end
end
