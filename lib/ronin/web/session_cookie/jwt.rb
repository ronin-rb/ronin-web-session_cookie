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

require 'base64'
require 'json'

module Ronin
  module Web
    module SessionCookie
      #
      # Represents a [JSON Web Token (JWT)][JWT].
      #
      # [JWT]: https://jwt.io
      #
      # ## Examples
      #
      #     Ronin::Web::SessionCookie.parse('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c')
      #     # =>
      #     # #<Ronin::Web::SessionCookie::JWT:0x00007f18d5a45e58
      #     #  @header={"alg"=>"HS256", "typ"=>"JWT"},
      #     #  @hmac=
      #     #   ":\x93\x92K\x0E\xDE\xE3\xCEK8\xFEO\xAF4\x9C\xC4v\xFBI\x1E\xAC\x00\xE3\x11rG\xC5\xC2.+\xA7\xBA",
      #     #  @params={"id"=>123456789, "name"=>"Joseph"}>
      #
      # @see https://jwt.io/
      #
      class JWT < Cookie

        # The parsed JWT header information.
        #
        # @return [Hash{String => Object}]
        #
        # @api public
        attr_reader :header

        # The SHA256 HMAC of the encoded {#header} + `.` +  the encoded
        # {#payload}.
        #
        # @return [String]
        #
        # @api public
        attr_reader :hmac

        alias payload params

        #
        # Initializes the parsed JWT session cookie.
        #
        # @param [Hash{String => Object}] header
        #   The parsed header information.
        #
        # @param [Hash{String => Object}] payload
        #   The parsed JWT payload.
        #
        # @param [String] hmac
        #   The SHA256 HMAC of the encoded header + `.` + the encoded payload.
        #
        # @api private
        #
        def initialize(header,payload,hmac)
          @header = header

          super(payload)

          @hmac = hmac
        end

        # Regular expression to match JWT session cookies.
        REGEXP = /\A(Bearer )?#{URL_SAFE_BASE64_REGEXP}\.#{URL_SAFE_BASE64_REGEXP}\.#{URL_SAFE_BASE64_REGEXP}\z/

        #
        # Identifies whether the string is a JWT session cookie.
        #
        # @param [String] string
        #   The raw session cookie value to identify.
        #
        # @return [Boolean]
        #   Indicates whether the session cookie value is a JWT session cookie.
        #
        # @api public
        #
        def self.identify?(string)
          string =~ REGEXP
        end

        #
        # Parses a JWT session cookie.
        #
        # @param [String] string
        #   The raw session cookie string to parse.
        #
        # @return [JWT]
        #   The parsed and deserialized session cookie
        #
        # @api public
        #
        def self.parse(string)
          # remove any 'Bearer ' prefix.
          string = string.sub(/\ABearer /,'')

          # split the string
          header, payload, hmac = string.split('.',3)

          header  = JSON.parse(Base64.decode64(header))
          payload = JSON.parse(Base64.decode64(payload))
          hmac    = Base64.decode64(hmac)

          return new(header,payload,hmac)
        end

        #
        # Extracts the JWT session cookie from the HTTP response.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [JWT, nil]
        #   The parsed JWT session cookie, or `nil` if there was no
        #   `Authorization` header containing a JWT session cookie.
        #
        # @api public
        #
        def self.extract(response)
          if (authorization = response['Authorization'])
            if (match = authorization.match(REGEXP))
              return parse(match[0])
            end
          end
        end

      end
    end
  end
end
