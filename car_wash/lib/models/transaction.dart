class TransactionModel {
  final String dataQR;
  final String carwash_ro;
  final String carwash_en;
  final String address_ro;
  final String address_en;
  final double totalPrice;
  final String date;

  TransactionModel(
      {required this.dataQR,
      required this.carwash_ro,
      required this.carwash_en,
      required this.address_ro,
      required this.address_en,
      required this.totalPrice,
      required this.date});
}
