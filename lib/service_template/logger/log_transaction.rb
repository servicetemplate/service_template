module ServiceTemplate
  class LogTransaction
    class << self
      def id
        Thread.current[:service_template_tid].nil? ? Thread.current[:service_template_tid] = SecureRandom.hex(10) : Thread.current[:service_template_tid]
      end

      def id=(id)
        Thread.current[:service_template_tid] = id
      end

      def clear
        Thread.current[:service_template_tid] = nil
      end
    end
  end
end
