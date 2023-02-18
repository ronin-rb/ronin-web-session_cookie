require 'spec_helper'
require 'ronin/web/session_cookie/django'

describe Ronin::Web::SessionCookie::Django do
  let(:params) do
    {"foo" => "bar"}
  end
  let(:salt) { 1676070425 }
  let(:hmac) do
    "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0".b
  end

  subject { described_class.new(params,salt,hmac) }

  describe "#initialize" do
    it "must set #params" do
      expect(subject.params).to eq(params)
    end

    it "must set #salt" do
      expect(subject.salt).to eq(salt)
    end

    it "must set #hmac" do
      expect(subject.hmac).to eq(hmac)
    end
  end

  describe ".identify?" do
    subject { described_class }

    it "must match '<base64>:<base64>:<base64>'" do
      cookie = 'eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA'

      expect(subject.identify?(cookie)).to be_truthy
    end

    it "must match 'sessionid=<base64>:<base64>:<base64>'" do
      cookie = 'sessionid=eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA'

      expect(subject.identify?(cookie)).to be_truthy
    end

    it "must not match '<base64>'" do
      cookie = 'eyJmb28iOiJiYXIifQ'

      expect(subject.identify?(cookie)).to be_falsy
    end

    it "must not match 'sessionid=<base64>'" do
      cookie = 'sessionid=eyJmb28iOiJiYXIifQ'

      expect(subject.identify?(cookie)).to be_falsy
    end

    it "must not match 'sessionid=<base64>:<base64>'" do
      cookie = 'sessionid=eyJmb28iOiJiYXIifQ:1pQcTx'

      expect(subject.identify?(cookie)).to be_falsy
    end

    it "must not match an empty 'sessionid='" do
      cookie = 'rack.session='

      expect(subject.identify?(cookie)).to be_falsy
    end
  end

  describe ".parse" do
    context "when given '<base64>:<base64>:<base64>'" do
      context "and when the session cookie is a JSON serialized session cookie" do
        let(:cookie) do
          'eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA'
        end
        let(:salt) { 1676070425 }
        let(:hmac) { "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0".b }

        subject { described_class.parse(cookie) }

        it "must decode and deserialize the JSON session params" do
          expect(subject.params).to eq(params)
        end

        it "must Base62 decode the salt" do
          expect(subject.salt).to eq(salt)
        end

        it "must parse the SHA256 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end

      context "and when the session cookie is a Python Pickle serialized session cookie" do
        let(:cookie) do
          'gAWVEAAAAAAAAAB9lIwDZm9vlIwDYmFylHMu:1pQcay:RjaK8DKN4xXQ_APIXXWEyFS08Q-PGo6UlRBFpedFk9M'
        end
        let(:salt) { 1676070860 }
        let(:hmac) { "F6\x8A\xF02\x8D\xE3\x15\xD0\xFC\x03\xC8]u\x84\xC8T\xB4\xF1\x0F\x8F\x1A\x8E\x94\x95\x10E\xA5\xE7E\x93\xD3".b }

        subject { described_class.parse(cookie) }

        it "must decode and deserialize the Python Pickled session params" do
          expect(subject.params).to eq(params)
        end

        it "must Base62 decode the salt" do
          expect(subject.salt).to eq(salt)
        end

        it "must parse the SHA256 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end
    end

    context "when given 'sessionid=<base64>:<base64>:<base64>'" do
      context "and when the session cookie is a JSON serialized session cookie" do
        let(:cookie) do
          'sessionid=eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA'
        end
        let(:salt) { 1676070425 }
        let(:hmac) { "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0".b }

        subject { described_class.parse(cookie) }

        it "must decode and deserialize the JSON session params" do
          expect(subject.params).to eq(params)
        end

        it "must Base62 decode the salt" do
          expect(subject.salt).to eq(salt)
        end

        it "must parse the SHA256 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end

      context "and when the session cookie is a Python Pickle serialized session cookie" do
        let(:cookie) do
          'sessionid=gAWVEAAAAAAAAAB9lIwDZm9vlIwDYmFylHMu:1pQcay:RjaK8DKN4xXQ_APIXXWEyFS08Q-PGo6UlRBFpedFk9M'
        end
        let(:salt) { 1676070860 }
        let(:hmac) { "F6\x8A\xF02\x8D\xE3\x15\xD0\xFC\x03\xC8]u\x84\xC8T\xB4\xF1\x0F\x8F\x1A\x8E\x94\x95\x10E\xA5\xE7E\x93\xD3".b }

        subject { described_class.parse(cookie) }

        it "must decode and deserialize the Python Pickled session params" do
          expect(subject.params).to eq(params)
        end

        it "must Base62 decode the salt" do
          expect(subject.salt).to eq(salt)
        end

        it "must parse the SHA256 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end
    end
  end
end
