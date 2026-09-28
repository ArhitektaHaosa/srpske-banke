# Security

Report issues privately. Do not open public tickets with exploit details.

Defaults:

- prepared statements
- output escaping
- CSRF on admin POST
- secure session cookie
- rate limit on /api and /admin/login
- CSP header
- no default admin password in seed
- API never returns admin tables

Do not scrape behind logins or bypass bank site controls.
