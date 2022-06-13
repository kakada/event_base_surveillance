# frozen_string_literal: true

class MigrateSectionAndFields < ActiveRecord::Migration[5.2]
  def up
    Milestone.all.each do |milestone|
      sections = [
        {
          name: "Primary Fields",
          is_default: true
        },
        {
          name: "Additional Fields",
          is_default: false
        }
      ]

      sections.each do |section|
        create_section(milestone, section)
      end
    end
  end

  def down
    Milestone.all.each do |milestone|
      Field.update_all(section_id: nil)
      Section.delete_all
    end
  end

  private
    def create_section(milestone, section = {})
      field_ids = milestone.fields.where(is_default: section[:is_default], section_id: nil).pluck(:id)
      return if field_ids.length == 0

      section = milestone.sections.new(name: section[:name], display: false, default: section[:is_default], field_ids: field_ids)
      section.save(validate: false)
    end
end
