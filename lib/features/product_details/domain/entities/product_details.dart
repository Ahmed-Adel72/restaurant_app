class ProductDetails {
  final int id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final double priceWithTax;
  final String? image;
  final bool onSale;
  final String type;
  final List<int> relatedIds;

  ProductDetails({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.priceWithTax,
    this.image,
    this.onSale = false,
    required this.type,
    this.relatedIds = const [],
  });
}
