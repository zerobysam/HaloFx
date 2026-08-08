class PipValueResult {
  final double pipValue;
  final String accountCurrency;
  final String lotTypeLabel;
  final double pipSize;
  final int contractSize;

  const PipValueResult({
    required this.pipValue,
    required this.accountCurrency,
    required this.lotTypeLabel,
    required this.pipSize,
    required this.contractSize,
  });
}
