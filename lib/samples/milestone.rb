# frozen_string_literal: true

module Samples
  class Milestone
    def self.load
      load_cdc
      load_gdaph
    end

    class << self
      private

      def load_cdc
        milestones = JSON.parse(File.read('lib/samples/db/cdc_milestone.json'))
        update_cdc_root_milestone
        create_milestone('CDC', milestones)
      end

      def load_gdaph
        milestones = JSON.parse(File.read('lib/samples/db/gdaph_milestone.json'))
        update_gdaph_root_milestone
        create_milestone('GDAPH', milestones)
      end

      def create_milestone(program_name, milestones)
        program = ::Program.find_by name: program_name

        milestones.each do |milestone|
          milestone[:creator_id] = program.creator_id
          program.milestones.create(milestone)
        end
      end

      def update_gdaph_root_milestone
        mileston = ::Program.find_by(name: 'GDAPH').milestones.root
        mileston.update_attributes(
          fields_attributes: [
            { name: 'Source of information', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Hotline' }, { name: 'Facebook' }, { name: 'Website' }, { name: 'Newspaper' }] },
            { name: 'Contact information of reporter', field_type: 'Fields::TextField' },
            { name: 'Index case', field_type: 'Fields::IntegerField' },
            { name: 'Type of species', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Cow' }, { name: 'Buffalo' }, { name: 'Pig' }, { name: 'Chicken' }, { name: 'Duck' }, { name: 'Goose' }, { name: 'Dog' }] },
            { name: 'Animal sick date', field_type: 'Fields::DateField' },
            { name: 'Animal sick and death reference', field_type: 'Fields::FileField' },
            { name: 'Population at risk', field_type: 'Fields::IntegerField' },
            { name: 'New or on-going', field_type: 'Fields::SelectOneField', field_options_attributes: [{ name: 'Yes' }, { name: 'No' }] },
            { name: 'Clinical signs', field_type: 'Fields::SelectMultipleField', field_options_attributes:[{ name: "សំកុក ការស៊ីចំណីថយចុះ" }, { name: "ទិន្នផលស៊ុតធ្លាក់ចុះ" }, { name: "ប្រកាច់ងាប់ភ្លាមៗ" }, { name: "ជើងហើម និងមានជាំឈាមខ្មៅនៅតាមខ្នងជើង" }, { name: "ក្បាលមាន់ឡើងហើម និងមានជាំពណ៌ស្វាយនៅលើសិរ និងណង់" }, { name: "ពិបាកដកដង្ហើម ហូរទឹករងៃ ឬ សំបោរតាមរន្ធច្រមុះ និងមាត់" }, { name: "រាគពីពណ៌បៃតងទៅពណ៌ស" }, { name: "ពេលព្រឹកឡើងឃើញមាន់ងាប់នៅលើសំបុក" }, { name: "សត្វឈឺ អង្គុយ ឬ ឈរ ដោយមានសភាពពាក់កណ្តាលសន្លប់ (ងងុយដេក)" }, { name: "អន់ចំណី" }, { name: "ក្បាលសំយ៉ុងចុះទៅដី រយៈពេល ២ ទៅ ៤ ម៉ោង ហើយងាប់" }, { name: "ទន់ជើង" }, { name: "ភ្នែកពណ៌ស" }, { name: "រាគពណ៌ស" }, { name: "ដើរ​ ឬ ហែលទឹកវិលៗ រួចប្រកាច់ងាប់" }, { name: "គ្រុនក្តៅ" }, { name: "មិនស៊ីចំណី" }, { name: "ហៀរទឹកមាត់" }, { name: "ពងដោរនៅអណា្តត" }, { name: "ពងដោរនៅចុងច្រមុះ" }, { name: "ពងដោរនៅបបូរមាត់" }, { name: "ពងដោរនៅគល់ក្រចក" }, { name: "ពងដោរលើចង្វែកជើង" }, { name: "ពងដោរលើដោះ" }, { name: "សត្វនៅមួយកន្លែង មិនចង់ដើរ" }, { name: "គ្រុនក្តៅ ហៀរទឹកមាត់" }, { name: "ហូរសំបោរខ្លាំង" }, { name: "ហើមនៅក្បាល នៅក និងនៅជុំវិញតំបន់ទ្រូង" }, { name: "សត្វងាប់លឿន អំឡុងពេល ៦ ទៅ២៤ ម៉ោងក្រោយចេញរោគសញ្ញា" }, { name: "ហើមនៅក្បាល នៅក និងនៅជុំវិញតំបន់ទ្រូង និងក្តៅត្រង់កន្លែងដែលហើម" }, { name: "ខ្សោយ និងស្ពឹកស្រពន់" }, { name: "ចេញក្រហមកន្ទួលលើស្បេក" }, { name: "មានឈាមក្រោមស្បែក ពណ៌ក្រហមស្វាយ" }, { name: "ស្លឹកត្រចៀកឡើងក្រហមស្វាយ" }, { name: "រលាកកែវភ្នែក" }, { name: "ដើរទាន់ជើង ញាក់ញ័រ ទន់លោងក្រោយ" }, { name: "អង្គុយដង្ហក់" }, { name: "ក្អក" }, { name: "ក្អួត" }, { name: "ពោះឡើងក្រហម" }, { name: "មានស្នាមអុតៗនៅលើខ្លួន" }, { name: "រលូត" }, { name: "ការងាប់ភ្លាមៗ (ស្រួចស្រាវខ្លាំង)" }, { name: "ខ្សោយ និងដេកដួល" }, { name: "កន្ទួលក្រហមលើស្បែកជ្រូកស" }, { name: "ស្បែកជាំផ្ទាំងស្វាយលើត្រចៀក កន្ទុយ ជើងផ្នែកខាងក្រោម ឬ ភ្លៅ" }, { name: "រាក" }, { name: "ទល់លាមក" }, { name: "ហូរសំបោរ ហូរទឹកភ្នែក" }, { name: "រលូតកូន" }, { name: "ការស្លាប់អាចកើតមាននៅក្នុងរយៈពេល៧ ទៅ១០ថ្ងៃ" }, { name: "ដេកគរលើគ្នា" }, { name: "សត្វមានអាការៈចំលែក" }, { name: "ចេញទឹកមាត់ច្រើន" }, { name: "បែកពពុះមាត់" }, { name: "មិនស៊ីចំណី មិនអាចស៊ីអ្វីបាន" }, { name: "ដេញខាំមនុស្ស និងខាំរបស់អ្វីផ្សេងៗ" }, { name: "ខ្លាចទឹក" }, { name: "សត្វងាប់អាចងាប់នៅចន្លោះពី៥ ទៅ៧ ថ្ងៃ ក្រោយពេលចេញរោគសញ្ញា" }] },
            { name: 'Other description', field_type: 'Fields::NoteField' }
          ]
        )
      end

      def update_cdc_root_milestone
        milestone = ::Program.find_by(name: 'CDC').milestones.root
        milestone.update_attributes(
          fields_attributes: [
            {
              name: 'Number of hospitalized',
              code: 'number_of_hospitalized',
              field_type: 'Fields::IntegerField',
              tracking: true
            }
          ]
        )
      end
    end
  end
end
