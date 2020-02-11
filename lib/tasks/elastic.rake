# frozen_string_literal: true

namespace :elastic do
  desc 'recreate indices and reindex all documents by a program'
  task :reindex_by_program, [:program_name] => :environment do |t, args|
    program = Program.find_by(name: args.program_name)
    return if program.nil?

    Elastic.new(program).reindex_documents
  end
end
