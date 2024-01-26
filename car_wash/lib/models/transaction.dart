class TransactionModel {
  final String dataQR;
  final String carwash;
  final String address;
  final double totalPrice;
  final String date;

  TransactionModel(
      {required this.dataQR,
      required this.carwash,
      required this.address,
      required this.totalPrice,
      required this.date});
}
