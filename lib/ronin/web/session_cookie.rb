require 'ronin/web/session_cookie/rack'
require 'ronin/web/session_cookie/django'
require 'ronin/web/session_cookie/jwt'

module Ronin
  module Web
    module SessionCookie
      # All session cookie classes.
      #
      # @api private
      CLASSES = [
        Rack,
        JWT,
        Django
      ]

      #
      # Parses the session cookie.
      #
      # @param [String] string
      #   The raw session cookie to parse.
      #
      # @return [Rack, Django, JWT, nil]
      #   The parsed and deserialized session cookie data.
      #   Returns `nil` if the session cookie did not match any of the supported
      #   formats.
      #
      # @api public
      #
      def self.parse(string)
        CLASSES.each do |klass|
          if klass.identify?(string)
            return klass.parse(string)
          end
        end

        return nil
      end
    end
  end
end
