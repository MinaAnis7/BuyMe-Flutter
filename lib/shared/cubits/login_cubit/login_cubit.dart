import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/login_model.dart';
import 'package:shop_app/shared/cubits/login_cubit/login_states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isObscure = true;
  IconData passwordSuffixIcon = Icons.visibility_outlined;

  void changeVisibilityMode() {
    isObscure = !isObscure;
    passwordSuffixIcon =
        isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangeVisibilityState());
  }

  late LoginModel loginModel;

  void logIn({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());

    DioHelper.postData(
      method: kLogin,
      data: {
        "email": email,
        "password": password,
      },
      lang: 'en',
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel));
    }).catchError((error) {
      emit(LoginErrorState());
    });
  }
}
