class Product {
  final String icon;
  final String offer;
  final String label;
  final String sublabel;

  Product({
    required this.icon,
    required this.offer,
    required this.label,
    this.sublabel = "",
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      icon: json['icon'] ?? '', // Ensure fallback for null values
      offer: json['offer'] ?? '',
      label: json['label'] ?? '',
      sublabel: json['Sublabel'] ??
          json['sublabel'] ??
          "", // Handle both capitalizations
    );
  }
}
