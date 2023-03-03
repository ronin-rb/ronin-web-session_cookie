require 'spec_helper'
require 'ronin/web/session_cookie'

require 'net/http'

describe Ronin::Web::SessionCookie do
  describe ".extract" do
    let(:response) { Net::HTTPSuccess.new('1.1', '200', 'OK') }

    subject { described_class.extract(response) }

    context "when the HTTP response contains an 'Set-Cookie' header" do
      before { response['Set-Cookie'] = cookie }

      context "and it contains '<base64>:<base64>:<base64>'" do
        context "and when the session cookie is a JSON serialized session cookie" do
          let(:cookie) do
            'eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA'
          end
          let(:params) do
            {"foo" => "bar"}
          end
          let(:salt) { 1676070425 }
          let(:hmac) { "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0".b }

          it "must return a #{described_class}::Django object" do
            expect(subject).to be_kind_of(described_class::Django)
          end

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
          let(:params) do
            {"foo" => "bar"}
          end
          let(:salt) { 1676070860 }
          let(:hmac) { "F6\x8A\xF02\x8D\xE3\x15\xD0\xFC\x03\xC8]u\x84\xC8T\xB4\xF1\x0F\x8F\x1A\x8E\x94\x95\x10E\xA5\xE7E\x93\xD3".b }

          it "must return a #{described_class}::Django object" do
            expect(subject).to be_kind_of(described_class::Django)
          end

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

      context "and it contains 'sessionid=<base64>:<base64>:<base64>'" do
        context "and when the session cookie is a JSON serialized session cookie" do
          let(:cookie) do
            'sessionid=eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA'
          end
          let(:params) do
            {"foo" => "bar"}
          end
          let(:salt) { 1676070425 }
          let(:hmac) { "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0".b }

          it "must return a #{described_class}::Django object" do
            expect(subject).to be_kind_of(described_class::Django)
          end

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
          let(:params) do
            {"foo" => "bar"}
          end
          let(:salt) { 1676070860 }
          let(:hmac) { "F6\x8A\xF02\x8D\xE3\x15\xD0\xFC\x03\xC8]u\x84\xC8T\xB4\xF1\x0F\x8F\x1A\x8E\x94\x95\x10E\xA5\xE7E\x93\xD3".b }

          it "must return a #{described_class}::Django object" do
            expect(subject).to be_kind_of(described_class::Django)
          end

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

      context "and it contains '<base64>--<sha1>'" do
        let(:cookie) do
          'BAh7CEkiD3Nlc3Npb25faWQGOgZFVG86HVJhY2s6OlNlc3Npb246OlNlc3Npb25JZAY6D0BwdWJsaWNfaWRJIkUyYWJkZTdkM2I0YTMxNDE5OThiYmMyYTE0YjFmMTZlNTNlMWMzYWJlYzhiYzc4ZjVhMGFlMGUwODJmMjJlZGIxBjsARkkiCWNzcmYGOwBGSSIxNHY1TmRCMGRVaklXdjhzR3J1b2ZhM2xwNHQyVGp5ZHptckQycjJRWXpIZz0GOwBGSSINdHJhY2tpbmcGOwBGewZJIhRIVFRQX1VTRVJfQUdFTlQGOwBUSSItOTkxNzUyMWYzN2M4ODJkNDIyMzhmYmI5Yzg4MzFmMWVmNTAwNGQyYwY7AEY=--02184e43850f38a46c8f22ffb49f7f22be58e272'
        end

        let(:params) do
          {
            "session_id" => Rack::Session::SessionId.new(
              "2abde7d3b4a3141998bbc2a14b1f16e53e1c3abec8bc78f5a0ae0e082f22edb1"
            ),
            "csrf"       => "4v5NdB0dUjIWv8sGruofa3lp4t2TjydzmrD2r2QYzHg=",
            "tracking"   => {
              "HTTP_USER_AGENT" => "9917521f37c882d42238fbb9c8831f1ef5004d2c"
            }
          }
        end
        let(:hmac) { '02184e43850f38a46c8f22ffb49f7f22be58e272' }

        it "must return a #{described_class}::Rack object" do
          expect(subject).to be_kind_of(described_class::Rack)
        end

        it "must decode and deserialize the session params" do
          expect(subject.params.keys).to eq(params.keys)
          expect(subject.params['session_id'].public_id).to eq(params['session_id'].public_id)
          expect(subject.params['csrf']).to eq(params['csrf'])
          expect(subject.params['tracking']).to eq(params['tracking'])
        end

        it "must parse the SHA1 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end

      context "and it contains '<uri-encoded-base64>--<sha1>'" do
        let(:cookie) do
          'BAh7CEkiD3Nlc3Npb25faWQGOgZFVG86HVJhY2s6OlNlc3Npb246OlNlc3Npb25JZAY6D0BwdWJsaWNfaWRJIkUyYWJkZTdkM2I0YTMxNDE5OThiYmMyYTE0YjFmMTZlNTNlMWMzYWJlYzhiYzc4ZjVhMGFlMGUwODJmMjJlZGIxBjsARkkiCWNzcmYGOwBGSSIxNHY1TmRCMGRVaklXdjhzR3J1b2ZhM2xwNHQyVGp5ZHptckQycjJRWXpIZz0GOwBGSSINdHJhY2tpbmcGOwBGewZJIhRIVFRQX1VTRVJfQUdFTlQGOwBUSSItOTkxNzUyMWYzN2M4ODJkNDIyMzhmYmI5Yzg4MzFmMWVmNTAwNGQyYwY7AEY%3D--02184e43850f38a46c8f22ffb49f7f22be58e272'
        end

        let(:params) do
          {
            "session_id" => Rack::Session::SessionId.new(
              "2abde7d3b4a3141998bbc2a14b1f16e53e1c3abec8bc78f5a0ae0e082f22edb1"
            ),
            "csrf"       => "4v5NdB0dUjIWv8sGruofa3lp4t2TjydzmrD2r2QYzHg=",
            "tracking"   => {
              "HTTP_USER_AGENT" => "9917521f37c882d42238fbb9c8831f1ef5004d2c"
            }
          }
        end
        let(:hmac) { '02184e43850f38a46c8f22ffb49f7f22be58e272' }

        it "must return a #{described_class}::Rack object" do
          expect(subject).to be_kind_of(described_class::Rack)
        end

        it "must decode and deserialize the session params" do
          expect(subject.params.keys).to eq(params.keys)
          expect(subject.params['session_id'].public_id).to eq(params['session_id'].public_id)
          expect(subject.params['csrf']).to eq(params['csrf'])
          expect(subject.params['tracking']).to eq(params['tracking'])
        end

        it "must parse the SHA1 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end

      context "and it contains 'rack.session=<base64>--<sha1>'" do
        let(:cookie) do
          'rack.session=BAh7CEkiD3Nlc3Npb25faWQGOgZFVG86HVJhY2s6OlNlc3Npb246OlNlc3Npb25JZAY6D0BwdWJsaWNfaWRJIkUyYWJkZTdkM2I0YTMxNDE5OThiYmMyYTE0YjFmMTZlNTNlMWMzYWJlYzhiYzc4ZjVhMGFlMGUwODJmMjJlZGIxBjsARkkiCWNzcmYGOwBGSSIxNHY1TmRCMGRVaklXdjhzR3J1b2ZhM2xwNHQyVGp5ZHptckQycjJRWXpIZz0GOwBGSSINdHJhY2tpbmcGOwBGewZJIhRIVFRQX1VTRVJfQUdFTlQGOwBUSSItOTkxNzUyMWYzN2M4ODJkNDIyMzhmYmI5Yzg4MzFmMWVmNTAwNGQyYwY7AEY=--02184e43850f38a46c8f22ffb49f7f22be58e272'
        end

        let(:params) do
          {
            "session_id" => Rack::Session::SessionId.new(
              "2abde7d3b4a3141998bbc2a14b1f16e53e1c3abec8bc78f5a0ae0e082f22edb1"
            ),
            "csrf"       => "4v5NdB0dUjIWv8sGruofa3lp4t2TjydzmrD2r2QYzHg=",
            "tracking"   => {
              "HTTP_USER_AGENT" => "9917521f37c882d42238fbb9c8831f1ef5004d2c"
            }
          }
        end
        let(:hmac) { '02184e43850f38a46c8f22ffb49f7f22be58e272' }

        it "must return a #{described_class}::Rack object" do
          expect(subject).to be_kind_of(described_class::Rack)
        end

        it "must decode and deserialize the session params" do
          expect(subject.params.keys).to eq(params.keys)
          expect(subject.params['session_id'].public_id).to eq(params['session_id'].public_id)
          expect(subject.params['csrf']).to eq(params['csrf'])
          expect(subject.params['tracking']).to eq(params['tracking'])
        end

        it "must parse the SHA1 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end

      context "and it contains 'rack.session=<uri-encoded-base64>--<sha1>'" do
        let(:cookie) do
          'rack.session=BAh7CEkiD3Nlc3Npb25faWQGOgZFVG86HVJhY2s6OlNlc3Npb246OlNlc3Npb25JZAY6D0BwdWJsaWNfaWRJIkUyYWJkZTdkM2I0YTMxNDE5OThiYmMyYTE0YjFmMTZlNTNlMWMzYWJlYzhiYzc4ZjVhMGFlMGUwODJmMjJlZGIxBjsARkkiCWNzcmYGOwBGSSIxNHY1TmRCMGRVaklXdjhzR3J1b2ZhM2xwNHQyVGp5ZHptckQycjJRWXpIZz0GOwBGSSINdHJhY2tpbmcGOwBGewZJIhRIVFRQX1VTRVJfQUdFTlQGOwBUSSItOTkxNzUyMWYzN2M4ODJkNDIyMzhmYmI5Yzg4MzFmMWVmNTAwNGQyYwY7AEY%3D--02184e43850f38a46c8f22ffb49f7f22be58e272'
        end

        let(:params) do
          {
            "session_id" => Rack::Session::SessionId.new(
              "2abde7d3b4a3141998bbc2a14b1f16e53e1c3abec8bc78f5a0ae0e082f22edb1"
            ),
            "csrf"       => "4v5NdB0dUjIWv8sGruofa3lp4t2TjydzmrD2r2QYzHg=",
            "tracking"   => {
              "HTTP_USER_AGENT" => "9917521f37c882d42238fbb9c8831f1ef5004d2c"
            }
          }
        end
        let(:hmac) { '02184e43850f38a46c8f22ffb49f7f22be58e272' }

        it "must return a #{described_class}::Rack object" do
          expect(subject).to be_kind_of(described_class::Rack)
        end

        it "must decode and deserialize the session params" do
          expect(subject.params.keys).to eq(params.keys)
          expect(subject.params['session_id'].public_id).to eq(params['session_id'].public_id)
          expect(subject.params['csrf']).to eq(params['csrf'])
          expect(subject.params['tracking']).to eq(params['tracking'])
        end

        it "must parse the SHA1 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end
    end

    context "when the HTTP response contains an 'Authorization' header" do
      before { response['Authorization'] = cookie }

      context "and it contains '<base64>.<base64>.<base64>'" do
        let(:cookie) do
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
        end

        let(:header) do
          {"alg" => "HS256", "typ" => "JWT"}
        end
        let(:params) do
          {"sub" => "1234567890", "name" => "John Doe", "iat" => 1516239022}
        end
        let(:hmac) { "I\xF9J\xC7\x04IH\xC7\x8A(]\x90O\x87\xF0\xA4\xC7\x89\x7F~\x8F:N\xB2%V\x9DB\xCB0\xE5".b }

        it "must return a #{described_class}::JWT object" do
          expect(subject).to be_kind_of(described_class::JWT)
        end

        it "must decode and deserialize the header information" do
          expect(subject.header).to eq(header)
        end

        it "must decode and deserialize the session params" do
          expect(subject.params).to eq(params)
        end

        it "must parse the SHA1 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end

      context "and it contains 'Bearer <base64>.<base64>.<base64>'" do
        let(:cookie) do
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
        end

        let(:header) do
          {"alg" => "HS256", "typ" => "JWT"}
        end
        let(:params) do
          {"sub" => "1234567890", "name" => "John Doe", "iat" => 1516239022}
        end
        let(:hmac) { "I\xF9J\xC7\x04IH\xC7\x8A(]\x90O\x87\xF0\xA4\xC7\x89\x7F~\x8F:N\xB2%V\x9DB\xCB0\xE5".b }

        it "must return a #{described_class}::JWT object" do
          expect(subject).to be_kind_of(described_class::JWT)
        end

        it "must decode and deserialize the header information" do
          expect(subject.header).to eq(header)
        end

        it "must decode and deserialize the session params" do
          expect(subject.params).to eq(params)
        end

        it "must parse the SHA1 HMAC" do
          expect(subject.hmac).to eq(hmac)
        end
      end
    end

    context "when the HTTP response does not contain a 'Set-Cookie' or 'Authorization' header" do
      it "must return nil" do
        expect(subject).to be(nil)
      end
    end
  end
end
