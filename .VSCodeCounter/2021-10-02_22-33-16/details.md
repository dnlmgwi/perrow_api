# Details

Date : 2021-10-02 22:33:16

Directory c:\Users\Daniel\AndroidStudioProjects\perrow_api

Total : 57 files,  2464 codes, 663 comments, 537 blanks, all 3664 lines

[summary](results.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [CHANGELOG.md](/CHANGELOG.md) | Markdown | 5 | 0 | 5 | 10 |
| [PerrowAPI.code-workspace](/PerrowAPI.code-workspace) | JSON with Comments | 18 | 0 | 1 | 19 |
| [README.md](/README.md) | Markdown | 1 | 0 | 1 | 2 |
| [analysis_options.yaml](/analysis_options.yaml) | YAML | 4 | 5 | 2 | 11 |
| [bin/main.dart](/bin/main.dart) | Dart | 77 | 45 | 22 | 144 |
| [lib/packages/core.dart](/lib/packages/core.dart) | Dart | 3 | 1 | 2 | 6 |
| [lib/packages/dependencies.dart](/lib/packages/dependencies.dart) | Dart | 17 | 2 | 2 | 21 |
| [lib/packages/models.dart](/lib/packages/models.dart) | Dart | 8 | 4 | 5 | 17 |
| [lib/packages/perrow_api.dart](/lib/packages/perrow_api.dart) | Dart | 6 | 1 | 3 | 10 |
| [lib/packages/routes.dart](/lib/packages/routes.dart) | Dart | 5 | 0 | 2 | 7 |
| [lib/packages/services.dart](/lib/packages/services.dart) | Dart | 9 | 0 | 2 | 11 |
| [lib/src/api/account_api.dart](/lib/src/api/account_api.dart) | Dart | 124 | 17 | 11 | 152 |
| [lib/src/api/auth_api.dart](/lib/src/api/auth_api.dart) | Dart | 157 | 16 | 16 | 189 |
| [lib/src/api/blockchain_api.dart](/lib/src/api/blockchain_api.dart) | Dart | 37 | 0 | 6 | 43 |
| [lib/src/api/mailjet_api/mailjet_api.dart](/lib/src/api/mailjet_api/mailjet_api.dart) | Dart | 0 | 58 | 10 | 68 |
| [lib/src/api/mocean_api/mocean_api.dart](/lib/src/api/mocean_api/mocean_api.dart) | Dart | 0 | 32 | 8 | 40 |
| [lib/src/api/status_api.dart](/lib/src/api/status_api.dart) | Dart | 20 | 0 | 4 | 24 |
| [lib/src/api/twilio_api/twilio_api.dart](/lib/src/api/twilio_api/twilio_api.dart) | Dart | 34 | 33 | 17 | 84 |
| [lib/src/api/wallet_api.dart](/lib/src/api/wallet_api.dart) | Dart | 104 | 0 | 14 | 118 |
| [lib/src/config.dart](/lib/src/config.dart) | Dart | 35 | 22 | 25 | 82 |
| [lib/src/errors/account_exceptions.dart](/lib/src/errors/account_exceptions.dart) | Dart | 136 | 13 | 39 | 188 |
| [lib/src/errors/auth_exceptions.dart](/lib/src/errors/auth_exceptions.dart) | Dart | 55 | 5 | 15 | 75 |
| [lib/src/models/api/auth/user/account/account.dart](/lib/src/models/api/auth/user/account/account.dart) | Dart | 31 | 2 | 12 | 45 |
| [lib/src/models/api/auth/user/login/login_request.dart](/lib/src/models/api/auth/user/login/login_request.dart) | Dart | 16 | 2 | 6 | 24 |
| [lib/src/models/api/auth/user/register/register_request.dart](/lib/src/models/api/auth/user/register/register_request.dart) | Dart | 18 | 2 | 6 | 26 |
| [lib/src/models/api/auth/user/transaction/trans_account.dart](/lib/src/models/api/auth/user/transaction/trans_account.dart) | Dart | 19 | 0 | 9 | 28 |
| [lib/src/models/api/blockchain/transfer_request.dart](/lib/src/models/api/blockchain/transfer_request.dart) | Dart | 14 | 2 | 6 | 22 |
| [lib/src/models/block/block.dart](/lib/src/models/block/block.dart) | Dart | 23 | 0 | 11 | 34 |
| [lib/src/models/hive/0.transactionRecord/transaction_record.dart](/lib/src/models/hive/0.transactionRecord/transaction_record.dart) | Dart | 36 | 0 | 10 | 46 |
| [lib/src/models/hive/1.rechargeNotification/recharge_notification.dart](/lib/src/models/hive/1.rechargeNotification/recharge_notification.dart) | Dart | 25 | 0 | 7 | 32 |
| [lib/src/models/location/location.dart](/lib/src/models/location/location.dart) | Dart | 18 | 0 | 7 | 25 |
| [lib/src/models/mineResult/mine_result.dart](/lib/src/models/mineResult/mine_result.dart) | Dart | 22 | 0 | 9 | 31 |
| [lib/src/models/perrow_response/perrow_response.dart](/lib/src/models/perrow_response/perrow_response.dart) | Dart | 18 | 0 | 7 | 25 |
| [lib/src/models/tokenPair/token_pair.dart](/lib/src/models/tokenPair/token_pair.dart) | Dart | 15 | 0 | 7 | 22 |
| [lib/src/services/account_service.dart](/lib/src/services/account_service.dart) | Dart | 80 | 1 | 17 | 98 |
| [lib/src/services/api_services.dart](/lib/src/services/api_services.dart) | Dart | 14 | 13 | 8 | 35 |
| [lib/src/services/auth/auth_service.dart](/lib/src/services/auth/auth_service.dart) | Dart | 50 | 5 | 5 | 60 |
| [lib/src/services/automated_tasks.dart](/lib/src/services/automated_tasks.dart) | Dart | 79 | 3 | 8 | 90 |
| [lib/src/services/blockchain_service.dart](/lib/src/services/blockchain_service.dart) | Dart | 168 | 19 | 29 | 216 |
| [lib/src/services/database_service.dart](/lib/src/services/database_service.dart) | Dart | 15 | 0 | 3 | 18 |
| [lib/src/services/location_services.dart](/lib/src/services/location_services.dart) | Dart | 13 | 1 | 4 | 18 |
| [lib/src/services/notification_service.dart](/lib/src/services/notification_service.dart) | Dart | 0 | 202 | 23 | 225 |
| [lib/src/services/user_actvity_service.dart](/lib/src/services/user_actvity_service.dart) | Dart | 54 | 15 | 7 | 76 |
| [lib/src/services/wallet_services.dart](/lib/src/services/wallet_services.dart) | Dart | 442 | 31 | 39 | 512 |
| [lib/src/utils.dart](/lib/src/utils.dart) | Dart | 97 | 45 | 17 | 159 |
| [lib/src/validators/account_responses.dart](/lib/src/validators/account_responses.dart) | Dart | 19 | 2 | 3 | 24 |
| [lib/src/validators/account_validation.dart](/lib/src/validators/account_validation.dart) | Dart | 19 | 4 | 5 | 28 |
| [lib/src/validators/auth_responses.dart](/lib/src/validators/auth_responses.dart) | Dart | 2 | 17 | 2 | 21 |
| [lib/src/validators/auth_validation.dart](/lib/src/validators/auth_validation.dart) | Dart | 20 | 7 | 7 | 34 |
| [lib/src/validators/blockchain_responses.dart](/lib/src/validators/blockchain_responses.dart) | Dart | 2 | 18 | 3 | 23 |
| [lib/src/validators/blockchain_validation.dart](/lib/src/validators/blockchain_validation.dart) | Dart | 15 | 5 | 4 | 24 |
| [lib/src/validators/enum_values.dart](/lib/src/validators/enum_values.dart) | Dart | 11 | 7 | 2 | 20 |
| [lib/src/validators/validation/auth_validation_service.dart](/lib/src/validators/validation/auth_validation_service.dart) | Dart | 118 | 6 | 15 | 139 |
| [lib/src/validators/validation/blockchain_validation_service.dart](/lib/src/validators/validation/blockchain_validation_service.dart) | Dart | 66 | 0 | 15 | 81 |
| [pubspec.yaml](/pubspec.yaml) | YAML | 42 | 0 | 4 | 46 |
| [web/index.html](/web/index.html) | HTML | 16 | 0 | 5 | 21 |
| [web/styles.css](/web/styles.css) | CSS | 12 | 0 | 3 | 15 |

[summary](results.md)