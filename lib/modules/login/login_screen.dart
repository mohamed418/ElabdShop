// ignore_for_file: avoid_print

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:top_shop/layout/shop_layout.dart';
import 'package:top_shop/models/components.dart';
import 'package:top_shop/modules/signup/signup_screen.dart';
import 'package:top_shop/network/local/cache_helper.dart';

import '../../bloc/cubit.dart';
import '../../bloc/states.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var formLoginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return BlocConsumer<TopShopCubit, TopShopStates>(
      listener: (context, state) {
        if (state is ShopLoginSuccessState) {
          if (state.loginModel.status == true) {
            print(state.loginModel.status);
            print(state.loginModel.message);
            print(state.loginModel.data!.token);
            CacheHelper.saveData(
              key: 'token',
              value: state.loginModel.data!.token,
            ).then((value) {
              TopShopCubit.get(context).getUserData();
              token = state.loginModel.data!.token!;
              navigateAndFinish(
                const ShopLayout(),
                context,
              );
            });
          } else {
            print(state.loginModel.message);
            String? m = state.loginModel.message;
            MotionToast.error(
              description: Text(
                m!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              ),
              animationType: ANIMATION.fromLeft,
              //layoutOrientation: ORIENTATION.rtl,
              position: MOTION_TOAST_POSITION.bottom,
              width: 300,
              height: 100,
            ).show(context);
          }
        }
      },
      builder: (context, state) {
        final cubit = TopShopCubit.get(context);
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //lottie
                  SizedBox(
                    child: Lottie.asset('assets/lotties/shop1.json'),
                    height: 90,
                    width: 90,
                  ),
                  Form(
                    key: formLoginKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.3),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _emailController,
                                validator:
                                    ValidationBuilder().email().build(),
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: 'enter your email',
                                  label: Text(
                                    'Email',
                                    // style: TextStyle(color: signup_bg),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                onFieldSubmitted: (v) {
                                  if (formLoginKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    TopShopCubit.get(context).login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                controller: _passwordController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      cubit.visible();
                                    },
                                    icon: Icon(cubit.icon),
                                  ),
                                  hintText: 'enter your password',
                                  label: const Text('Password'),
                                ),
                                obscureText: cubit.isVisible,
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                    onPressed: () {
                                      navigateAndFinish(
                                          SignUpScreen(), context);
                                    },
                                    child: const Text(
                                        'Don\'t have an account?')),
                              ),
                              const SizedBox(height: 30),
                              BuildCondition(
                                condition: state is! ShopLoginLoadingState,
                                builder: (context) => FlatButton(
                                  color: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minWidth: 500,
                                  onPressed: () {
                                    if (formLoginKey.currentState!
                                        .validate()) {
                                      FocusScope.of(context).unfocus();
                                      TopShopCubit.get(context).login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                    } else {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  child: Text('sign in'.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                                fallback: (context) => const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
