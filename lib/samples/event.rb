# frozen_string_literal: true

module Samples
  class Event
    def self.load
      provinces = ::Location.where(kind: 'province')
      provinces.each do |province|
        districts = province.children.order('random()').limit(3)
        districts.each do |district|
          communes = district.children.order('random()').limit(5)
          communes.each do |commune|
            villages = commune.children.where.not(latitude: nil).limit(2)
            villages.each do |village|
              max_event = rand(1..5)
              (1..max_event).each do
                create_event(village.code)
              end
            end
          end
        end
      end
    end

    def self.simulation(count=2)
      (1..count).each do
        create_event(Pumi::Village.all.sample.id)
      end
    end

    class << self
      private
        def create_event(village_id)
          ::Program.where(name: 'CDC').each do |program|
            event_type_ids = program.event_types.pluck(:id)
            event = ::Event.create(
              creator_id: program.users.first.try(:id),
              event_type_id: event_type_ids.sample,
              field_values_attributes: event_field_value_attr(program, village_id)
            )
            create_event_milestones(event, program)
          end
        end

        def event_field_value_attr(program, village_id)
          village = Pumi::Village.find_by_id village_id
          field_values = {
            province_id: village.province_id,
            district_id: village.district_id,
            commune_id: village.commune_id,
            village_id: village.id,
            number_of_case: rand(1..20),
            number_of_death: rand(1..5),
            event_date: Date.today - rand(0..30),
            report_date: Date.today,
            source_of_information: ['hotline', 'facebook', 'website'].sample
          }

          field_values[:number_of_hospitalized] = rand(1..4) if program.name == 'CDC'

          field_values.map do |k, v|
            {
              field_id: program.milestones.root.fields.select { |f| f.code == k.to_s }.first.id,
              field_code: k,
              value: v
            }
          end
        end

        def create_event_milestones(event, program)
          milestones = program.milestones.select { |mi| !mi.root? }

          size = (1..milestones.length).to_a.sample
          milestones.take(size).each do |milestone|
            event.event_milestones.create(
              program_id: program.id,
              milestone_id: milestone.id,
              field_values_attributes: em_field_values_attr(milestone, event)
            )
          end
        end

        def em_field_values_attr(milestone, event)
          field_codes = milestone.fields.pluck(:code)
          values = []

          if milestone.verified?
            conducted_at = { code: 'conducted_at', value: event.field_values.find_by(field_code: 'report_date').value.to_date + (rand(1..5) * milestone.display_order).day }
          else
            mile = event.program.milestones.find_by display_order: milestone.display_order - 1
            em = event.event_milestones.find_by milestone_id: mile.id
            conducted_at = { code: 'conducted_at', value: em.field_values.find_by(field_code: 'conducted_at').value.to_date + (rand(1..5) * milestone.display_order).day }
          end

          fvs = [
            conducted_at,
            { code: 'risk_level', value: '' },
            { code: 'attendee_list', value: %w[Samnang Mealea Chenda].sample },
            { code: 'risk_assessment_conducted', value: %w(press_release web_site social_media).sample },
            { code: 'conducted_by_(lead)', value: %w[Tola Vichheka].sample }
          ]

          fvs.each do |obj|
            next unless field_codes.include? obj[:code]

            field = milestone.fields.select { |f| f.code == obj[:code] }.first
            option = field.field_options.sample

            values.push(
              field_id: field.id,
              field_code: obj[:code],
              value: option.try(:value) || obj[:value],
              color: option.try(:color)
            )
          end

          values
        end
    end
  end
end
