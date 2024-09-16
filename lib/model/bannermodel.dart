import 'package:shop/model/productmodel.dart';

class BannerData {
  final List<String> banners;
  final List<Product> products;

  BannerData({
    required this.banners,
    required this.products,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    var bannersJson = json['banner_one'] as List;
    var productsJson = json['products'] as List;

    List<String> banners =
        bannersJson.map((item) => item['banner'] as String).toList();
    List<Product> products =
        productsJson.map((item) => Product.fromJson(item)).toList();

    return BannerData(
      banners: banners,
      products: products,
    );
  }
}
