class CategoryModel {
  late bool status;
  late CategoryDataModel data;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoryDataModel.fromJson(json["data"]);
  }
}

class CategoryDataModel {
  late int currentPage;
  List<DataModelC>? data = [];

  CategoryDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data?.add(DataModelC.fromJson(element));
    });
  }
}

class DataModelC {
  late int id;
  late String name;
  late String image;

  DataModelC.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
