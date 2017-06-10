module UserAuth
  class Configuration
    attr_accessor :deliver_mail, :require_account_confirmations, :allow_signups,
                  :jwt_exp

    def initialize
      @deliver_mail = lambda do |options|
        $logger.info("TODO: Deliver mail #{options.inspect}")
      end
      @require_account_confirmations = false
      @allow_signups = true
      @jwt_exp = 3600
    end
  end
end
