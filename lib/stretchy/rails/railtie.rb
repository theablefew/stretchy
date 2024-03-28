module Stretchy
  module Rails
    class Railtie < ::Rails::Railtie

      rake_tasks do
        load "#{__dir__}/tasks/stretchy.rake"
      end

    end
  end
end