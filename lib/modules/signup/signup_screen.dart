// ignore_for_file: avoid_print, deprecated_member_use

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:top_shop/models/components.dart';
import 'package:top_shop/modules/login/login_screen.dart';
import 'package:top_shop/modules/signup/register_cubit/register_cubit.dart';
import 'package:top_shop/modules/signup/register_cubit/register_states.dart';

import '../../layout/shop_layout.dart';
import '../../models/login_model.dart';
import '../../network/local/cache_helper.dart';
import '../login/cubit/login_states.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {

  SignUpScreen({Key? key}) : super(key: key);

  final _nameController1 = TextEditingController();
  final _emailController1 = TextEditingController();
  final _passwordController1 = TextEditingController();
  final _phoneController1 = TextEditingController();
  var formSignUpKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => ShopSignUpCubit(),
        child: BlocConsumer<ShopSignUpCubit, SignUpStates>(
          listener: (context, state) {
            if (state is SignUpSuccessState) {
              if (state.loginModel.status == true) {
                CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data!.token,
                ).then((value) {
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
            var cubit = ShopSignUpCubit.get(context);
            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: (){
                          navigateTo(LoginScreen(), context);
                        },
                        icon: const Icon(Icons.arrow_left_rounded, size: 60,),
                      ),
                    ),
                    SizedBox(
                      child: Lottie.asset('assets/lotties/shop3.json'),
                      height: 120,
                      width: 200,
                    ),
                    Form(
                      key: formSignUpKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.3),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), bottomRight: Radius.circular(50), topRight: Radius.circular(15), bottomLeft: Radius.circular(15))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailController1,
                                  validator: ValidationBuilder().email().build(),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: 'enter a valid email',
                                    label: Text(
                                      'Email',
                                      // style: TextStyle(color: signup_bg),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(onPressed: (){cubit.isVisible;}, icon: const Icon(Icons.visibility), ),
                                    hintText: 'enter a valid password',
                                    label: const Text('Password'),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _nameController1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    hintText: 'enter your name',
                                    label: Text(
                                      'Name',
                                      // style: TextStyle(color: signup_bg),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _phoneController1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your phone number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: 'enter your phone number',
                                    label: Text(
                                      'Phone',
                                      // style: TextStyle(color: signup_bg),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                BuildCondition(
                                  condition: state is! SignUpLoadingState,
                                  builder: (context) => FlatButton(
                                    color: Colors.deepOrange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minWidth: 500,
                                    onPressed: () {
                                      if (formSignUpKey.currentState!
                                          .validate()) {
                                        FocusScope.of(context).unfocus();
                                        ShopSignUpCubit.get(context).userSignUp(
                                          name: _nameController1.text,
                                          email: _emailController1.text,
                                          password: _passwordController1.text,
                                          phone: _phoneController1.text,
                                        );
                                      } else {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    child: Text('register'.toUpperCase(),
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
            );
          },
        ),
      ),
    );
  }
}


