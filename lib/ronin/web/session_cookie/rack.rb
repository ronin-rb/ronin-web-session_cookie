# frozen_string_literal: true
#
# Copyright (c) 2023-2025 Hal Brodigan (postmodern.mod3@gmail.com)
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

require_relative 'cookie'

require 'base64'
require 'delegate'
require 'rack/session/cookie'

module Ronin
  module Web
    module SessionCookie
      #
      # Represents a [Rack][rack-session] session cookie.
      #
      # [rack-session]: https://github.com/rack/rack-session
      #
      # ## Examples
      #
      #     Ronin::Web::SessionCookie.parse('rack.session=BAh7CEkiD3Nlc3Npb25faWQGOgZFVG86HVJhY2s6OlNlc3Npb246OlNlc3Npb25JZAY6D0BwdWJsaWNfaWRJIkUyYWJkZTdkM2I0YTMxNDE5OThiYmMyYTE0YjFmMTZlNTNlMWMzYWJlYzhiYzc4ZjVhMGFlMGUwODJmMjJlZGIxBjsARkkiCWNzcmYGOwBGSSIxNHY1TmRCMGRVaklXdjhzR3J1b2ZhM2xwNHQyVGp5ZHptckQycjJRWXpIZz0GOwBGSSINdHJhY2tpbmcGOwBGewZJIhRIVFRQX1VTRVJfQUdFTlQGOwBUSSItOTkxNzUyMWYzN2M4ODJkNDIyMzhmYmI5Yzg4MzFmMWVmNTAwNGQyYwY7AEY%3D--02184e43850f38a46c8f22ffb49f7f22be58e272')
      #     # =>
      #     # #<Ronin::Web::SessionCookie::Rack:0x00007ff67455ee30
      #     #  @params=
      #     #   {"session_id"=>"2abde7d3b4a3141998bbc2a14b1f16e53e1c3abec8bc78f5a0ae0e082f22edb1",
      #     #    "csrf"=>"4v5NdB0dUjIWv8sGruofa3lp4t2TjydzmrD2r2QYzHg=",
      #     #    "tracking"=>{"HTTP_USER_AGENT"=>"9917521f37c882d42238fbb9c8831f1ef5004d2c"}}>
      #
      # @see https://github.com/rack/rack-session
      #
      class Rack < Cookie

        # The HMAC for the deserialized and Base64 encoded session cookie.
        #
        # @return [String]
        attr_reader :hmac

        #
        # Initializes the parsed Rack session cookie.
        #
        # @param [Hash{String => Object}] params
        #   The parsed params for the session cookie.
        #
        # @param [String] hmac
        #   The HMAC for the serialized and Base64 encoded session cookie.
        #
        # @api private
        #
        def initialize(params,hmac)
          super(params)

          @hmac = hmac
        end

        # Regular expression to match Rack session cookies.
        REGEXP = /\A(rack\.session=)?(?:#{STRICT_BASE64_REGEXP}|#{URI_ENCODED_BASE64_REGEXP})--[0-9a-f]{40}\z/

        #
        # Identifies if the cookie is a Rack session cookie.
        #
        # @param [String] string
        #   The raw session cookie value to identify.
        #
        # @return [Boolean]
        #   Indicates whether the session cookie is a Rack session cookie.
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
        # @return [Rack]
        #   The parsed and deserialized session cookie
        #
        # @api public
        #
        def self.parse(string)
          # remove any 'rack.session' prefix.
          string = string.sub(/\Arack\.session=/,'')

          payload, hmac = string.split('--',2)

          return new(Marshal.load(Base64.decode64(payload)),hmac)
        end

        #
        # Extracts the Rack session cookie from the HTTP response.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @return [Rack, nil]
        #   The parsed Rack session cookie, or `nil` if there was no
        #   `Set-Cookie` header containing a Rack session cookie.
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
