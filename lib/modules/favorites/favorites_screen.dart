import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_shop/models/components.dart';
import '../../bloc/cubit.dart';
import '../../bloc/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopShopCubit, TopShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TopShopCubit.get(context);
        return BuildCondition(
          condition: state is! GetFavoritesLoadingState,
          builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildProItem(
                  cubit.favoritesModel!.data!.data![index].product!, context),
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
              itemCount: cubit.favoritesModel!.data!.data!.length),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
