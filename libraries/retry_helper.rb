class RetryHelper
  def self.retry_with_delay(retries=5, delay=20)
    attempts ||=retries
    return yield
  rescue => e
    if (attempts -= 1) > 0
      if(delay > 0)
        puts "Retries left: #{attempts}\n - sleeping #{delay} seconds because of #{e}"
        sleep delay
      end
      retry
    else
      puts 'no more attempts left'
    end
    raise
  end
end