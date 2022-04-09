import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:top_shop/bloc/cubit.dart';
import 'package:top_shop/bloc/states.dart';
import '../../models/components.dart';
import '../../network/local/cache_helper.dart';
import '../login/login_screen.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  //String? profileImage;
  var formKey = GlobalKey<FormState>();

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopShopCubit, TopShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = TopShopCubit.get(context);
          nameController.text = cubit.userModel!.data!.name.toString();
          emailController.text = cubit.userModel!.data!.email.toString();
          phoneController.text = cubit.userModel!.data!.phone.toString();
          return Padding(
              padding: const EdgeInsets.all(20),
              child: BuildCondition(
                condition: cubit.userModel != null,
                builder: (context) => SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if (state is UpdateUserDataLoadingState)
                          const LinearProgressIndicator(),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          validator: ValidationBuilder().email().build(),
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            //hintText: 'enter your email',
                            label: Text(
                              'Email',
                            ),
                            prefix: Icon(
                              Icons.person,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            label: Text('Name'),
                            prefix: Icon(
                              Icons.drive_file_rename_outline,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            label: Text('Phone'),
                            prefix: Icon(
                              Icons.phone,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                CacheHelper.removeData(key: "token")
                                    .then((value) => navigateAndFinish(
                                  LoginScreen(),
                                  context,
                                ));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  color: Colors.deepOrange,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Log out',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                cubit.getUserData();
                                nameController.text = cubit.userModel!.data!.name.toString();
                                emailController.text = cubit.userModel!.data!.email.toString();
                                phoneController.text = cubit.userModel!.data!.phone.toString();
                                // if (formKey.currentState!.validate()) {
                                //   FocusScope.of(context).unfocus();
                                //   cubit.updateUserData(
                                //     name: nameController.text,
                                //     email: emailController.text,
                                //     phone: phoneController.text,
                                //   );
                                // }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  color: Colors.deepOrange,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'update',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
        });
  }
}
