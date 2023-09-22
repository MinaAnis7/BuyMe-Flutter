import 'package:shop_app/models/home_data_model.dart';

class GetFavoriteModel {
  late bool status;
  List<Product>? products;

  GetFavoriteModel.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      json['data']['data'].forEach((product) {
        products?.add(Product.fromJsonFav(product['product']));
      });
      // ignore: empty_catches
    } catch (e) {}
  }
}
