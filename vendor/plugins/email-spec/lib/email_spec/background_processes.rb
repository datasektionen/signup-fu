module EmailSpec
  module BackgroundProcesses
    module DelayedJob
      def work_off
        if Delayed::Job.respond_to?(:work_off)
          Delayed::Job.work_off
        else
          worker = Delayed::Worker.new(:quiet => true)
          worker.send(:work_off)
        end
        
      end
      def all_emails
        work_off
        super
      end

      def last_email_sent
        work_off
        super
      end

      def reset_mailer
        work_off
        super
      end

      def mailbox_for(address)
        work_off
        super
      end
    end

    module Compatibility
      if defined?(Delayed)
        include EmailSpec::BackgroundProcesses::DelayedJob
      end
    end
  end
end
