class Crypto {
  Crypto(
    this.id,
    this.name,
    this.symbol,
    this.changePer24hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );

  String id;
  String name;
  String symbol;
  double changePer24hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  factory Crypto.fromMapjson(Map<String, dynamic> jsonMapObject) {
    return Crypto(
      jsonMapObject['id'],
      jsonMapObject['name'],
      jsonMapObject['symbol'],
      double.parse(jsonMapObject['changePercent24Hr']),
      double.parse(jsonMapObject['priceUsd']),
      double.parse(jsonMapObject['marketCapUsd']),
      int.parse(jsonMapObject['rank']),
    );
  }
}
