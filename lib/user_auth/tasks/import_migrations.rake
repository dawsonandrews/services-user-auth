require "fileutils"

namespace :user_auth do
  desc "Import migrations for user-auth service"
  task :import_migrations do |t|
    import_to = File.join(t.application.original_dir, "db")
    import_form = File.expand_path(File.join(__dir__, "..", "..", "..", "db", "migrations"))
    # files_to_copy = Dir.glob("#{import_form}/*.rb")

    FileUtils.cp_r(import_form, import_to, preserve: true)

    # files_to_copy.each do |path|

    #   puts "Copied #{path} to #{import_to}"
    # end

  end
end
