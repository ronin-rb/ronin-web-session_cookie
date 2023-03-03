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

require 'ronin/web/session_cookie/cookie'
require 'ronin/support/encoding/base64'
require 'ronin/support/encoding/base62'

require 'python/pickle'

module Ronin
  module Web
    module SessionCookie
      #
      # Represents a Django signed session cookie (JSON or Pickle serialized).
      #
      # ## Examples
      #
      # Parse a Django JSON session cookie:
      #
      #     Ronin::Web::SessionCookie.parse('sessionid=eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA')
      #     # =>
      #     # #<Ronin::Web::SessionCookie::Django:0x00007f29bb9c6b70
      #     #  @hmac=
      #     #   "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0",
      #     #  @params={"foo"=>"bar"},
      #     #  @salt=1676070425>
      #
      # Parse a Django Pickled session cookie:
      #
      #     Ronin::Web::SessionCookie.parse('sessionid=gAWVEAAAAAAAAAB9lIwDZm9vlIwDYmFylHMu:1pQcay:RjaK8DKN4xXQ_APIXXWEyFS08Q-PGo6UlRBFpedFk9M')
      #     # =>
      #     # #<Ronin::Web::SessionCookie::Django:0x00007f29b7aa6dc8
      #     #  @hmac=
      #     #   "F6\x8A\xF02\x8D\xE3\x15\xD0\xFC\x03\xC8]u\x84\xC8T\xB4\xF1\x0F\x8F\x1A\x8E\x94\x95\x10E\xA5\xE7E\x93\xD3",
      #     #  @params={"foo"=>"bar"},
      #     #  @salt=1676070860>
      #
      # @see https://docs.djangoproject.com/en/4.1/topics/http/sessions/#using-cookie-based-sessions
      #
      class Django < Cookie

        # The salt used to sign the cookie.
        #
        # @return [Integer]
        #
        # @api public
        attr_reader :salt

        # The SHA256 HMAC of the Base64 encoded serialized  {#params}.
        #
        # @return [String]
        #
        # @api public
        attr_reader :hmac

        #
        # Initializes the Django cookie.
        #
        # @param [Hash{String => Object}] params
        #   The deserialized params of the session cookie.
        #
        # @param [Integer] salt
        #   The Base62 decoded timestamp that is used to salt the HMAC.
        #
        # @param [Integer] hmac
        #   The SHA256 HMAC of the Base64 encoded serialized  {#params}.
        #
        # @api private
        #
        def initialize(params,salt,hmac)
          super(params)

          @salt = salt
          @hmac = hmac
        end

        # Regular expression to match Django session cookies.
        REGEXP = /\A(?:sessionid=)?#{URL_SAFE_BASE64_REGEXP}:#{URL_SAFE_BASE64_REGEXP}:#{URL_SAFE_BASE64_REGEXP}\z/

        #
        # Identifies if the cookie is a Django session cookie.
        #
        # @param [String] string
        #   The raw session cookie value.
        #
        # @return [Boolean]
        #   Indicates whether the session cookie value is a Django session
        #   cookie.
        #
        # @api public
        #
        def self.identify?(string)
          string =~ REGEXP
        end

        #
        # Parses a Django session cookie.
        #
        # @param [String] string
        #   The raw session cookie string to parse.
        #
        # @return [Django]
        #   The parsed and deserialized session cookie
        #
        # @api public
        #
        def self.parse(string)
          # remove any 'sessionid' prefix.
          string = string.sub(/\Asessionid=/,'')

          # split the cookie
          params, salt, hmac = string.split(':',3)

          params = Support::Encoding::Base64.decode(params, mode: :url_safe)
          params = if params.start_with?('{') && params.end_with?('}')
                     # JSON serialized cookie
                     JSON.parse(params)
                   else
                     # unpickle the Python Pickle serialized session cookie
                     Python::Pickle.load(params)
                   end

          salt = Support::Encoding::Base62.decode(salt)
          hmac = Support::Encoding::Base64.decode(hmac, mode: :url_safe)

          return new(params,salt,hmac)
        end

        #
        # Extracts the Django session cookie from the HTTP response.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Django, nil]
        #   The parsed Django session cookie, or `nil` if there was no
        #   `Set-Cookie` header containing a Django session cookie.
        #
        # @api public
        #
        def self.extract(response)
          if (set_cookie = response['Set-Cookie'])
            cookie = set_cookie.split(';',2).first

            if identify?(cookie)
              return parse(cookie)
            end
          end
        end

      end
    end
  end
end
