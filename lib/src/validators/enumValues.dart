enum AccountStatus { normal, processing }

enum TransactionType {
  /// DON'T CHANGE THE ORDER
  /// String TransactionTypes
  /// 0: Withdraw
  /// 1: Deposit
  /// 2: Transfer
  /// 3: ...
  withdraw,
  deposit,
  transfer,
  reversal,
  refund,
  reward,
  achievement,
  subscription,
}
