// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_shop/models/login_model.dart';
import 'package:top_shop/modules/login/cubit/login_states.dart';
import 'package:top_shop/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel loginModel;

  void login({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: 'login',
      data: {'email': email, 'password': password},
    ).then((value) {
      //print(value.data['message']);
      loginModel = ShopLoginModel.fromJson(value.data);
      // print(loginModel.status);
      // print(loginModel.message);
      // print(loginModel.data?.token);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
      print('eeeeeeeee $error');
    });
  }


  IconData icon = Icons.visibility_off;
  bool isVisible = false;
  void visible(){
    isVisible = !isVisible;
    icon = isVisible? Icons.visibility : Icons.visibility_off;
    emit(ChangeBottomNavState());
  }
}
