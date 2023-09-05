# ronin-web-session_cookie

[![CI](https://github.com/ronin-rb/ronin-web-session_cookie/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-web-session_cookie/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-web-session_cookie.svg)](https://codeclimate.com/github/ronin-rb/ronin-web-session_cookie)

* [Website](https://ronin-rb.dev/)
* [Source](https://github.com/ronin-rb/ronin-web-session_cookie)
* [Issues](https://github.com/ronin-rb/ronin-web-session_cookie/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-web-session_cookie/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-web-session_cookie is a library for parsing and deserializing various
session cookie formats. It supports Rack, Django (JSON and Pickled), and JWT.

## Features

* Supports the following session cookie formats:
  * [Rack][rack-session]
  * [Django]
  * [JSON Web Token (JWT)][JWT]
* Has 98% test coverage.
* Has 97% documentation coverage.

## Examples

Parse a [Rack][rack-session] session cookie:

```ruby
require 'ronin/web/session_cookie'

Ronin::Web::SessionCookie.parse('rack.session=BAh7CEkiD3Nlc3Npb25faWQGOgZFVG86HVJhY2s6OlNlc3Npb246OlNlc3Npb25JZAY6D0BwdWJsaWNfaWRJIkUyYWJkZTdkM2I0YTMxNDE5OThiYmMyYTE0YjFmMTZlNTNlMWMzYWJlYzhiYzc4ZjVhMGFlMGUwODJmMjJlZGIxBjsARkkiCWNzcmYGOwBGSSIxNHY1TmRCMGRVaklXdjhzR3J1b2ZhM2xwNHQyVGp5ZHptckQycjJRWXpIZz0GOwBGSSINdHJhY2tpbmcGOwBGewZJIhRIVFRQX1VTRVJfQUdFTlQGOwBUSSItOTkxNzUyMWYzN2M4ODJkNDIyMzhmYmI5Yzg4MzFmMWVmNTAwNGQyYwY7AEY%3D--02184e43850f38a46c8f22ffb49f7f22be58e272')
# =>
# #<Ronin::Web::SessionCookie::Rack:0x00007ff67455ee30
#  @params=
#   {"session_id"=>"2abde7d3b4a3141998bbc2a14b1f16e53e1c3abec8bc78f5a0ae0e082f22edb1",
#    "csrf"=>"4v5NdB0dUjIWv8sGruofa3lp4t2TjydzmrD2r2QYzHg=",
#    "tracking"=>{"HTTP_USER_AGENT"=>"9917521f37c882d42238fbb9c8831f1ef5004d2c"}}>
```

Parse a Django JSON session cookie:

```ruby
Ronin::Web::SessionCookie.parse('sessionid=eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA')
# => 
# #<Ronin::Web::SessionCookie::Django:0x00007f29bb9c6b70
#  @hmac=
#   "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0",
#  @params={"foo"=>"bar"},
#  @salt=1676070425>
```

Parse a Django Pickled session cookie:

```ruby
Ronin::Web::SessionCookie.parse('sessionid=gAWVEAAAAAAAAAB9lIwDZm9vlIwDYmFylHMu:1pQcay:RjaK8DKN4xXQ_APIXXWEyFS08Q-PGo6UlRBFpedFk9M')
# =>
# #<Ronin::Web::SessionCookie::Django:0x00007f29b7aa6dc8
#  @hmac=
#   "F6\x8A\xF02\x8D\xE3\x15\xD0\xFC\x03\xC8]u\x84\xC8T\xB4\xF1\x0F\x8F\x1A\x8E\x94\x95\x10E\xA5\xE7E\x93\xD3",
#  @params={"foo"=>"bar"},
#  @salt=1676070860>
```

Parse a [JSON Web Token (JWT)][JWT] session cookie:

```ruby
Ronin::Web::SessionCookie.parse('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c')
# =>
# #<Ronin::Web::SessionCookie::JWT:0x00007f4e8ef0ff08
#  @header={"alg"=>"HS256", "typ"=>"JWT"},
#  @hmac=
#   "I\xF9J\xC7\x04IH\xC7\x8A(]\x90O\x87\xF0\xA4\xC7\x89\x7F~\x8F:N\xB2%V\x9DB\xCB0\xE5",
#  @params={"sub"=>"1234567890", "name"=>"John Doe", "iat"=>1516239022}>
```

## Requirements

* [Ruby] >= 3.0.0
* [ronin-support] ~> 1.0
* [rack-session] ~> 1.0
* [python-pickle] ~> 0.1

## Install

```shell
$ gem install ronin-web-session_cookie
```

### Gemfile

```ruby
gem 'ronin-web-session_cookie', '~> 0.1'
```

### gemspec

```ruby
gem.add_dependency 'ronin-web-session_cookie', '~> 0.1'
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-web-session_cookie/fork)
2. Clone It!
3. `cd ronin-web-session_cookie/`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)

ronin-web-session_cookie is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-web-session_cookie is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-web-session_cookie.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[rack-session]: https://github.com/rack/rack-session
[python-pickle]: https://github.com/postmodern/python-pickle#readme
[Django]: https://docs.djangoproject.com/en/4.1/topics/http/sessions/#using-cookie-based-sessions
[JWT]: https://jwt.io
