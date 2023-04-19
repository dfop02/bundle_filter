module BundleFilter
  class Configuration
    PRETTY = true
    STYLE  = 'boxes'

    class << self
      def pretty
        PRETTY
      end

      def style
        STYLE
      end

      def default_style?
        STYLE == 'default'
      end

      def boxes_style?
        STYLE == 'boxes'
      end
    end
  end
end
