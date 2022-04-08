import 'package:top_shop/models/login_model.dart';

import '../models/favorites_model.dart';

abstract class TopShopStates{}

class TopShopInitialState extends TopShopStates{}

class ChangeBotNavState extends TopShopStates{}

class TopShopLoadingState extends TopShopStates{}

class TopShopSuccessState extends TopShopStates{}

class TopShopErrorState extends TopShopStates{}

class CategoriesLoadingState extends TopShopStates{}

class CategoriesSuccessState extends TopShopStates{}

class CategoriesErrorState extends TopShopStates{}

class FavoritesChangeState extends TopShopStates{}

class FavoritesSuccessState extends TopShopStates{
  final ChangeFavoritesModel changeFavoritesModel;

  FavoritesSuccessState(this.changeFavoritesModel);
}

class FavoritesErrorState extends TopShopStates{}

class GetFavoritesLoadingState extends TopShopStates{}

class GetFavoritesSuccessState extends TopShopStates{}

class GetFavoritesErrorState extends TopShopStates{}

class UserDataLoadingState extends TopShopStates {}

class UserDataSuccesState extends TopShopStates {
  final ShopLoginModel shopLoginModel;

  UserDataSuccesState(this.shopLoginModel);

}

class UserDataErorrState extends TopShopStates {}

class UpdateUserDataLoadingState extends TopShopStates {}

class UpdateUserDataSuccessState extends TopShopStates {
  final ShopLoginModel shopLoginModel;
  UpdateUserDataSuccessState(this.shopLoginModel);
}

class UpdateUserDataErrorState extends TopShopStates {}


class SearchLoadingState extends TopShopStates{}

class SearchSuccessState extends TopShopStates{}

class SearchErrorState extends TopShopStates{}
