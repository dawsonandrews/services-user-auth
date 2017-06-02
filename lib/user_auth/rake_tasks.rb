path = File.expand_path(File.join(__dir__, "tasks", "*.rake"))
Dir.glob(path).each { |r| import r }
