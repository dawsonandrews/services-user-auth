require "fileutils"

namespace :user_auth do
  desc "Import migrations for user-auth service"
  task :import_migrations do |t|
    import_to = File.join(t.application.original_dir, "db")
    import_form = File.expand_path(File.join(__dir__, "..", "..", "..", "db", "migrations"))

    FileUtils.cp_r(import_form, import_to, preserve: true)
  end
end
