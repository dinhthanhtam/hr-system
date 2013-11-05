require File.expand_path(File.join(File.dirname(__FILE__), '../master_importer'))

namespace :master do
  desc "Import master datas in 'db/masters'"
  task import: :environment do
    MasterImporter.new.run
  end
end
