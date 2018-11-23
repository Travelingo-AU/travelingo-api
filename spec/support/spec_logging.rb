module SpecLogger
  def self.logger
    @__logger ||= SemanticLogger['RSPEC']
  end
end

module SpecHelpers
  module SpecLogging
    # These methods will be accessible from examples
    def logger
      SpecLogger.logger
    end

    def log_d(*args)
      logger.debug(*args)
    end

    def log_i(*args)
      logger.info(*args)
    end

    def log_w(*args)
      logger.warn(*args)
    end

    def log_e(*args)
      logger.error(*args)
    end
  end
end

RSpec.configuration.include(SpecHelpers::SpecLogging)
