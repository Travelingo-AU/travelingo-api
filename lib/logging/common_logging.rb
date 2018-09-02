# NOTE: Previously called Logging, renamed due name conflict with Logging gem

module CommonLogging
  def self.extended(base)
    # puts "###: Base: #{base}"

    base.define_singleton_method(:logger) do
      # puts "Extended: Logger: #{@logger}, Current base: #{base}"
      @logger ||= LogBuilder.build(log_tag: base.to_s)
    end
  end

  def self.included(base)
    # Formatting the cases with `class << self` which will form `#<Class:XXX>`
    log_tag = %r{^#<Class:} =~ base.to_s ? base.to_s.split(':')[-1][0..-2] : base

    # puts "@@@: Base: #{base}"
    base.class_eval do
      define_method(:logger) do
        # puts "Included: Logger: #{@logger}, Current base: #{log_tag}"
        @logger ||= LogBuilder.build(log_tag: log_tag)
      end
    end
  end
end

