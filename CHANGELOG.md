## [Unreleased]

- Require Ruby >= 3.2 and Rails >= 7.2, < 9
- Test against Rails 7.2, 8.0 and 8.1 with Appraisal
- Find the model for tables whose name does not `classify` to it, and add a `_fixture: model_class:` header so Rails can load them
- Write stable integer ids, not labels, for foreign keys in tables with no model

## [0.1.0] - 2022-11-17

- Initial release
