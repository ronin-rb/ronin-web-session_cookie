### 0.1.1 / 2025-02-14

* Added the `base64` gem as a dependency for Bundler and Ruby 3.4.0.
* Use `require_relative` to improve load times.

### 0.1.0 / 2024-07-22

* Initial release:
  * Supports the following session cookie formats:
    * [Rack][rack-session]
    * [Django]
    * [JSON Web Token (JWT)][JWT]
  * Has 98% test coverage.
  * Has 97% documentation coverage.

[rack-session]: https://github.com/rack/rack-session
[Django]: https://docs.djangoproject.com/en/4.1/topics/http/sessions/#using-cookie-based-sessions
[JWT]: https://jwt.io
