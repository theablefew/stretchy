module Stretchy
  # Shared lookups for the stretchy rake tasks.
  module RakeHelpers
    module_function

    # The classes a task acts on: the one named in ENV[env], or every descendant of base
    # that is not marked abstract.
    #
    # ```ruby
    #   # AGENT=SupportAgent rake stretchy:ml:agent:create
    #   Stretchy::RakeHelpers.resources(Stretchy::MachineLearning::Agent, env: 'AGENT') # => [SupportAgent]
    # ```
    def resources(base, env:)
      return [ENV[env].constantize] if ENV[env].present?
      ::Rails.application.eager_load! if defined?(::Rails)
      base.descendants.reject { |resource| resource.try(:abstract?) }
    end

    # Runs the block for each resource behind a spinner, stopping it with the block's status.
    def each_with_spinner(resources, label)
      resources.each do |resource|
        spinner = TTY::Spinner.new("#{label} #{resource} ".ljust(JUSTIFICATION) + ":spinner", format: :dots)
        spinner.auto_spin
        spinner.stop(yield(resource))
      end
    end
  end
end
