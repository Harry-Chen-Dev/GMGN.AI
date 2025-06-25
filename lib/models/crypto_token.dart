class CryptoToken {
  final String symbol;
  final String name;
  final String price;
  final String marketCap;
  final double change24h;
  final double change1h;
  final double change5m;
  final String volume;
  final int holders;
  final String age;
  final String imageUrl;
  final bool isNew;

  CryptoToken({
    required this.symbol,
    required this.name,
    required this.price,
    required this.marketCap,
    required this.change24h,
    required this.change1h,
    required this.change5m,
    required this.volume,
    required this.holders,
    required this.age,
    required this.imageUrl,
    required this.isNew,
  });
}