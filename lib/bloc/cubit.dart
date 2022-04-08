// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:top_shop/bloc/states.dart';
import 'package:top_shop/models/categories_model.dart';
import 'package:top_shop/models/components.dart';
import 'package:top_shop/models/home_model.dart';
import 'package:top_shop/models/search_model.dart';
import 'package:top_shop/modules/categories/categories_screen.dart';
import 'package:top_shop/modules/favorites/favorites_screen.dart';
import 'package:top_shop/modules/product/product_screen.dart';
import 'package:top_shop/modules/search/search_screen.dart';
import 'package:top_shop/modules/settings/settings_screen.dart';
import 'package:top_shop/network/remote/dio_helper.dart';

import '../models/favorites_model.dart';
import '../models/get_favorites_model.dart';
import '../models/login_model.dart';
import '../network/local/cache_helper.dart';

class TopShopCubit extends Cubit<TopShopStates> {
  TopShopCubit() : super(TopShopInitialState());

  static TopShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 2;

  List<NavigationBarButton> tabs = [
    NavigationBarButton(
      icon: Icons.favorite_outline_rounded,
      text: 'Favorites',
      backgroundGradient: gradient,
    ),
    NavigationBarButton(
      icon: Icons.category_outlined,
      text: 'Categories',
      backgroundGradient: gradient,
    ),
    NavigationBarButton(
      icon: Icons.shopping_cart_outlined,
      text: 'Shopping',
      backgroundGradient: gradient,
    ),
    NavigationBarButton(
      icon: Icons.search_outlined,
      text: 'Search',
      backgroundGradient: gradient,
    ),
    NavigationBarButton(
        icon: Icons.settings_rounded,
        text: 'Settings',
        backgroundGradient: gradient),
  ];

  List<Widget> screens = [
    const FavoritesScreen(),
    const CategoriesScreen(),
    const ProductScreen(),
    const SearchScreen(),
    SettingsScreen(),
  ];

  void changeBot(index) {
    currentIndex = index;
    emit(ChangeBotNavState());
  }

  HomeModel? homeModel;
  Map<int, bool>? favorites = {};
  List images = [];

  void getHomeData() {
    emit(TopShopLoadingState());
    DioHelper.getData(
      url: 'home',
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      // ignore: avoid_function_literals_in_foreach_calls
      homeModel!.data!.products.forEach((element) {
        favorites!.addAll(({element.id!: element.inFavorites!}));
      });
      homeModel!.data!.products.forEach((element) {
        images.addAll(({element.images}));
      });
      emit(TopShopSuccessState());
      printFullText(images[0].toString());

    }).catchError((error) {
      emit(TopShopErrorState());
      print(error.toString());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    emit(CategoriesLoadingState());
    DioHelper.getData(
      url: 'categories',
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(CategoriesSuccessState());
    }).catchError((error) {
      emit(CategoriesErrorState());
      print(error.toString());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites![productId] = !favorites![productId]!;
    emit(FavoritesChangeState());
    DioHelper.postData(
        url: 'favorites',
        data: {"product_id": productId},
        token: CacheHelper.getData(key: "token"))
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites![productId] = !favorites![productId]!;
      }else{
        getFavoritesData();
      }
      emit(FavoritesSuccessState(changeFavoritesModel!));
    }).catchError((error) {
      favorites![productId] = !favorites![productId]!;
      emit(FavoritesErrorState());
    });
  }

  FavoritesModel? favoritesModel;
  void getFavoritesData() {
    emit(GetFavoritesLoadingState());
    DioHelper.getData(
      token: CacheHelper.getData(key: "token"),
      url: 'favorites',
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(GetFavoritesSuccessState());
    }).catchError((error) {
      emit(GetFavoritesErrorState());
      print(error.toString());
    });
  }

  ShopLoginModel? loginModel;
  void getUserData() {
    emit(UserDataLoadingState());
    DioHelper.getData(
      token: CacheHelper.getData(key: "token"),
      url: 'profile',
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(UserDataSuccesState(loginModel!));
    }).catchError((error) {
      emit(UserDataErorrState());
      print(error.toString());
    });
  }

  void updateUserData({
  required String name,
  required String email,
  required String phone,
}) {
    emit(UpdateUserDataLoadingState());
    DioHelper.putData(
      token: CacheHelper.getData(key: "token"),
      url: 'update-profile',
      data: {
        'name' : name,
        'email' : email,
        'phone' : phone,
      },
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(UpdateUserDataSuccessState(loginModel!));
      print(loginModel!.data!.email);
    }).catchError((error) {
      emit(UpdateUserDataErrorState());
      print(error.toString());
    });
  }


  SearchModel? searchModel;

  void search({String? text}) {
    emit(SearchLoadingState());
    DioHelper.postData(
        url: 'products/search',
        data: {"text": text},
        token: CacheHelper.getData(key: "token"))
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      emit(SearchErrorState());
      print(error.toString());
    });
  }
}
