require 'spec_helper'
require 'ronin/web/session_cookie/jwt'

describe Ronin::Web::SessionCookie::JWT do
  let(:header) do
    {"alg" => "HS256", "typ" => "JWT"}
  end
  let(:params) do
    {"sub" => "1234567890", "name" => "John Doe", "iat" => 1516239022}
  end
  let(:hmac) { "I\xF9J\xC7\x04IH\xC7\x8A(]\x90O\x87\xF0\xA4\xC7\x89\x7F~\x8F:N\xB2%V\x9DB\xCB0\xE5".b }

  subject { described_class.new(header,params,hmac) }

  describe "#initialize" do
    it "must set #header" do
      expect(subject.header).to eq(header)
    end

    it "must set #params" do
      expect(subject.params).to eq(params)
    end

    it "must set #hmac" do
      expect(subject.hmac).to eq(hmac)
    end
  end

  describe ".identify?" do
    subject { described_class }

    it "must match '<base64>.<base64>.<base64>'" do
      cookie = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'

      expect(subject.identify?(cookie)).to be_truthy
    end

    it "must match 'Bearer <base64>.<base64>.<base64>'" do
      cookie = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'

      expect(subject.identify?(cookie)).to be_truthy
    end

    it "must not match '<base64>'" do
      cookie = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'

      expect(subject.identify?(cookie)).to be_falsy
    end

    it "must not match '<base64>.<base64>'" do
      cookie = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ'

      expect(subject.identify?(cookie)).to be_falsy
    end

    it "must not match 'Bearer <base64>'" do
      cookie = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'

      expect(subject.identify?(cookie)).to be_falsy
    end

    it "must not match 'Bearer <base64>.<base64>'" do
      cookie = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ'

      expect(subject.identify?(cookie)).to be_falsy
    end

    it "must not match an empty 'Bearer '" do
      cookie = 'Bearer '

      expect(subject.identify?(cookie)).to be_falsy
    end
  end

  describe ".parse" do
    context "when given '<base64>.<base64>.<base64>'" do
      let(:cookie) do
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
      end

      subject { described_class.parse(cookie) }

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

    context "when given 'Bearer <base64>.<base64>.<base64>'" do
      let(:cookie) do
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c'
      end

      subject { described_class.parse(cookie) }

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
end
