module Ronin
  module Web
    module SessionCookie
      #
      # Base class for all session cookie classes.
      #
      class Cookie

        include Enumerable

        # Regular expression for a URI decoded Base64 blob.
        STRICT_BASE64_REGEXP = /(?:[A-Za-z0-9+\/]{4})+(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?|[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=/

        # Regular expression for a URI escaped Base64 blob.
        URI_ENCODED_BASE64_REGEXP = /(?:[A-Za-z0-9+\/]{4})+(?:[A-Za-z0-9+\/]{2}%3D%3D|[A-Za-z0-9+\/]{3}%3D)?|[A-Za-z0-9+\/]{2}%3D|[A-Za-z0-9+\/]{3}%3D/

        # Regular expression for a URL-safe encoded Base64 blob.
        URL_SAFE_BASE64_REGEXP = /[A-Za-z0-9_-]{2,}/

        # The cookie params.
        #
        # @return [Hash]
        attr_reader :params

        #
        # Initializes the session cookie.
        #
        # @param [Hash] params
        #   The parsed contents of the session cookie.
        #
        # @api private
        #
        def initialize(params)
          @params = params
        end

        #
        # Determines if the given string is a valid session cookie.
        #
        # @param [String] string
        #
        # @return [Boolean]
        #
        # @api public
        #
        # @abstract
        #
        def self.identify?(string)
          raise(NotImplementedError,"#{self}.identify? was not implemented")
        end

        #
        # Parses a session cookie value.
        #
        # @param [String] string
        #
        # @return [Cookie]
        #
        # @abstract
        #
        # @api public
        #
        def self.parse(string)
          raise(NotImplementedError,"#{self}.parse was not implemented")
        end

        #
        # Determines if the session cookie contains the given param.
        #
        # @param [String] params
        #
        # @return [Boolean]
        #
        # @api public
        #
        def has_key?(params)
          @params.has_key?(params)
        end

        #
        # Returns the value for the given session cookie param.
        #
        # @param [String] key
        #
        # @return [Object, nil]
        #
        # @api public
        #
        def [](key)
          @params[key]
        end

        #
        # Enumerates over the params within the session cookie.
        #
        # @yield [key, value]
        #
        # @yieldparam [String] key
        #
        # @yieldparam [Object] value
        #
        # @return [Enumerator]
        #
        # @api public
        #
        def each(&block)
          @params.each(&block)
        end

        #
        # Converts the session cookie into a Hash.
        #
        # @return [Hash]
        #
        # @api public
        #
        def to_h
          @params
        end

      end
    end
  end
end
