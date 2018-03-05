module LoggerHelper
  def log(msg)
    config.logger.info ''
    config.logger.info "#{self.class.name}: #{msg}"
    block_result = nil
    if block_given?
      block_result = yield
      config.logger.info(config._log_pause ? '*'*20 : "\t#{block_result.inspect}")
    end
    config.logger.info ''
    block_result
  end
end