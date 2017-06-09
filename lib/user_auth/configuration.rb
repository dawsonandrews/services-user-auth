module UserAuth
  class Configuration
    attr_accessor :deliver_mail, :account_confirmations, :signups

    def initialize
      @deliver_mail = lambda do |options|
        $logger.info("TODO: Deliver mail #{options.inspect}")
      end
      @account_confirmations = false
      @signups = true
    end
  end
end
