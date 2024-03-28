require 'stretchy-model'

path = File.expand_path(__dir__)
Dir.glob("#{path}/**/*.rake").each { |f| import f }