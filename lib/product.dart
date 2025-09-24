class Products {
  String name;
  double balance;
  double rate;

  Products({
    required this.name,
    required this.balance,
    required this.rate,
  });

  double get amount => balance * (rate / 100);

  Products copyWith({
    String? name,
    double? balance,
    double? rate,
  }) {
    return Products(
      name: name ?? this.name,
      balance: balance ?? this.balance,
      rate: rate ?? this.rate,
    );
  }
}