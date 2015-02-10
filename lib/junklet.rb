require "junklet/version"

module RSpec
  module Core
    module MemoizedHelpers
      module ClassMethods
        def junklet(*args)
          opts = args.size > 1 && !args.last.is_a?(Symbol) && args.pop || {}

          names = args.map(&:to_s)

          if opts.key?(:separator)
            names = names.map {|name| name.gsub(/_/, opts[:separator]) }
          end

          args.zip(names).each do |arg, name|
            let(arg) { "#{name}-#{junk}" }
          end
        end
      end

      def junk(size=32, options={})
        if :integer == options[:type]
          # TODO: We can actual know how many hex digits we need in
          # advance because of te ratio of the logs. We should totally
          # work that out sometime. The ratio is like 1.2 something. For
          # now, blah, just make it work.
          SecureRandom.hex.to_i(16).to_s[0..size]
        else
          # hex returns size*2 digits, because it returns a 0..255 byte
          # as a hex pair. But when we want junt, we want *bytes* of
          # junk. Get (size+1)/2 chars, which will be correct for even
          # sizes and 1 char too many for odds, so trim off with
          # [0...size] (note three .'s to trim off final char)
          SecureRandom.hex((size+1)/2)[0...size]
        end
      end
    end
  end
end
