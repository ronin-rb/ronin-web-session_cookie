# frozen_string_literal: true
#
# Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
#
# ronin-web-session_cookie is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-web-session_cookie is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-web-session_cookie.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/web/session_cookie/rack'
require 'ronin/web/session_cookie/django'
require 'ronin/web/session_cookie/jwt'

module Ronin
  module Web
    #
    # Namespace for `ronin-web-session_cookie`.
    #
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

      #
      # Extracts and parses the session cookie from the HTTP response.
      #
      # @param [Net::HTTPResponse] response
      #   The HTTP response object.
      #
      # @return [Cookie, nil]
      #   The parsed session cookie or `nil` if no session cookie could be
      #   detected.
      #
      # @api public
      #
      def self.extract(response)
        CLASSES.each do |klass|
          if (session_cookie = klass.extract(response))
            return session_cookie
          end
        end

        return nil
      end
    end
  end
end
