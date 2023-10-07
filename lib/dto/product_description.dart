class ProductDescription {
  final String title;
  final String manufacturer;

  const ProductDescription({
    required this.title,
    required this.manufacturer
  });

  factory ProductDescription.fromJson(Map<String, dynamic> json) {
    return ProductDescription(
      title: json['products'][0]['title'],
      manufacturer: json['products'][0]['title']
    );
  }
}