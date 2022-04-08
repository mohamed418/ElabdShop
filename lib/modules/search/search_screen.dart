// ignore_for_file: must_be_immutable
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:top_shop/bloc/cubit.dart';
import 'package:top_shop/bloc/states.dart';
import 'package:top_shop/models/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopShopCubit, TopShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TopShopCubit.get(context);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (String value) {
                  cubit.search(text: value);
                },
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'enter any thing you want..',
                  label: Text(
                    'Search',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            if (state is SearchLoadingState)
              const LinearProgressIndicator(),
            if (state is SearchSuccessState)
              BuildCondition(
                condition: state is! SearchLoadingState,
                builder:(context)=> Expanded(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => buildProItem(
                          cubit.searchModel!.data!.data![index],
                          context, isOldPrice: false),
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: Container(
                            width: double.infinity,
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                        );
                      },
                      itemCount: cubit.searchModel!.data!.data!.length),
                ),
                fallback: (context) => const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
