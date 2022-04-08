import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_shop/modules/signup/register_cubit/register_states.dart';

import '../../../models/login_model.dart';
import '../../../network/remote/dio_helper.dart';

class ShopSignUpCubit extends Cubit<SignUpStates> {
  ShopSignUpCubit() : super(SignUpInitialState());

  static ShopSignUpCubit get(context) => BlocProvider.of(context);

  void userSignUp({
    String? name,
    String? email,
    String? password,
    String? phone,
  }) {
    emit(SignUpLoadingState());
    DioHelper.postData(url: 'register', data: {
      "name": name,
      "email": email,
      'password': password,
      "phone": phone
    }).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(SignUpSuccessState(loginModel!));
      print(loginModel!.message);
    }).catchError((error) {
      emit(SignUpErrorState(error.toString()));
    });
  }

  ShopLoginModel? loginModel;

  bool isVisible = true;
  IconData passIcon = Icons.visibility;

  void changePasswordVisability() {
    isVisible = !isVisible;
    passIcon = isVisible ? Icons.visibility : Icons.visibility_off;
    emit(ChangeBottomNavState1());
  }
}
