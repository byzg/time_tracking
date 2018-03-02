module LoggerHelper
  def log(msg)
    config.logger.info ''
    config.logger.info "#{self.class.name}: #{msg}"
    block_result = nil
    if block_given?
      block_result = yield
      config.logger.info "\t#{block_result.inspect}"
    end
    config.logger.info ''
    block_result
  end
end