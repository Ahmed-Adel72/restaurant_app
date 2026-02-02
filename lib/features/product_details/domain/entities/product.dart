class Product {
  final int id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final double priceWithTax;
  final String? image;
  final int categoryId;
  final bool onSale;

  Product({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.priceWithTax,
    this.image,
    required this.categoryId,
    this.onSale = false,
  });
}
