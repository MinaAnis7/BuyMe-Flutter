import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/favorite_model.dart';
import 'package:shop_app/models/get_favorites_model.dart';
import 'package:shop_app/models/home_data_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/category_screen.dart';
import 'package:shop_app/modules/favorites_screen.dart';
import 'package:shop_app/modules/login_model.dart';
import 'package:shop_app/modules/products_screen.dart';
import 'package:shop_app/modules/settings_screen.dart';
import 'package:shop_app/shared/cubits/home_cubit/home_states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio.dart';
import 'package:shop_app/shared/network/styles/colors.dart';
import '../../../models/profile_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> navItems = [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home_outlined),
      label: 'Home',
      activeIcon: Icon(
        Icons.home,
        color: orange,
      ),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.category_outlined),
      label: 'Category',
      activeIcon: Icon(
        Icons.category,
        color: orange,
      ),
    ),
    BottomNavigationBarItem(
        icon: const Icon(
          Icons.favorite_outline,
        ),
        label: 'Favorites',
        activeIcon: Icon(
          Icons.favorite,
          color: orange,
        )),
    BottomNavigationBarItem(
      icon: const Icon(Icons.settings_outlined),
      label: 'Settings',
      activeIcon: Icon(
        Icons.settings,
        color: orange,
      ),
    ),
  ];

  List<Widget> screens = [
    const ProductsScreen(),
    const CategoryScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  int currentIndex = 0;

  void changeNavIndex(index) {
    currentIndex = index;
    emit(ChangeHomeNavIndexState());
  }

  HomeDataModel? homeDataModel;

  void getHomeData() {
    emit(GetHomeDataLoadingSate());

    DioHelper.getData(
      method: kHOME,
      token: CacheHelper.getData(key: 'token'),
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
    ).then((response) {
      homeDataModel = HomeDataModel.fromJson(response.data);
      emit(GetHomeDataSuccessSate());
    }).catchError((error) {
      emit(GetHomeDataErrorSate());
    });
  }

  late CategoryModel categoryModel;

  void getCategoryData() {
    DioHelper.getData(
            method: kGetCATEGORY,
            lang: CacheHelper.getData(key: 'lang') ?? 'en')
        .then((response) {
      categoryModel = CategoryModel.fromJson(response.data);
      emit(GetCategorySuccessSate());
    }).catchError((error) {
      emit(GetCategoryErrorSate());
    });
  }

  late FavoriteModel favoriteModel;

  void changeFavorite(int id) {
    emit(ChangeFavState());

    DioHelper.postData(
      method: kChangeFAV,
      data: {
        'product_id': id,
      },
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
      token: CacheHelper.getData(key: 'token'),
    ).then((response) {
      favoriteModel = FavoriteModel.fromJson(response.data);
      getHomeData();
      getFavorites();
      emit(ChangeFavSuccessState(favoriteModel));
    }).catchError((error) {
      emit(ChangeFavErrorState());
    });
  }

  late GetFavoriteModel getFavoriteModel;

  void getFavorites() {
    DioHelper.getData(
      method: kChangeFAV,
      token: CacheHelper.getData(key: 'token'),
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
    ).then((response) {
      getFavoriteModel = GetFavoriteModel.fromJson(response.data);
      emit(GetFavSuccessState());
    }).catchError((error) {
      emit(GetFavErrorState());
    });
  }

  bool isDark = false;

  void changeThemeMode(bool modeState) {
    isDark = modeState;
    emit(ChangeThemeMode());
  }

  ProfileModel? profileModel;

  void getProfileData() {
    DioHelper.getData(
      method: kGetPROFILE,
      token: CacheHelper.getData(key: 'token'),
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
    ).then((response) {
      profileModel = ProfileModel.fromJson(response.data);
      emit(GetProfileSuccessState());
    }).catchError((error) {
      emit(GetProfileErrorState());
    });
  }

  String editImage = CacheHelper.getData(key: 'image') ?? '';

  void changeImage(path) {
    editImage = path;
    emit(ChangeImage());
  }

  late LoginModel updateProfileModel;

  void updateProfile({
    required String name,
    required String phone,
    required String password,
    required String email,
  }) {
    emit(UpdateProfileLoadingState());

    DioHelper.putData(
      method: kUpdatePROFILE,
      data: {
        'name': name,
        'password': password,
        'phone': phone,
        'email': email,
      },
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
      token: CacheHelper.getData(key: 'token'),
    ).then((response) {
      updateProfileModel = LoginModel.fromJson(response.data);
      CacheHelper.saveData(key: 'image', value: editImage);
      getProfileData();

      emit(UpdateProfileSuccessState(updateProfileModel));
    }).catchError((error) {
      if (kDebugMode) print(error);
      emit(UpdateProfileErrorState());
    });
  }

  bool isObscure = true;
  IconData obscureIcon = Icons.visibility_outlined;

  void changeVisibility() {
    isObscure = !isObscure;
    obscureIcon = obscureIcon == Icons.visibility_outlined
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    emit(ChangeVisibility());
  }

  late LoginModel signUpModel;

  void signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(SignUpLoadingState());

    DioHelper.postData(
      method: kSignUp,
      data: {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
      },
      lang: CacheHelper.getData(key: 'lang') ?? 'en',
    ).then((response) {
      signUpModel = LoginModel.fromJson(response.data);
      emit(SignUpSuccessState(signUpModel));
    }).catchError((error) {
      if (kDebugMode) print(error);
      emit(SignUpErrorState());
    });
  }

  String lang = 'English';

  void changeLanguage(String language) {
    lang = lang == 'English' ? 'العربية' : 'English';
    CacheHelper.saveData(key: 'lang', value: language);
    getFavorites();
    getHomeData();
    getCategoryData();
    getProfileData();
    emit(ChangeLanguage());
  }

  SearchModel? searchModel;

  void getSearch(String text) {
    emit(GetSearchLoading());

    DioHelper.postData(
      method: kSEARCH,
      data: {
        "text": text,
      },
      token: CacheHelper.getData(key: 'token'),
    ).then((response) {
      searchModel = SearchModel.fromJson(response.data);
      emit(GetSearchSuccess());
    }).catchError((error) {
      if (kDebugMode) print(error);

      emit(GetSearchError());
    });
  }
}
