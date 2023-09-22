import '../modules/login_model.dart';

class ProfileModel {
  late bool status;
  late UserData data;

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    try {
      data = UserData.fromJson(json['data']);
      // ignore: empty_catches
    } catch (e) {}
  }
}
