import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_shop/bloc/cubit.dart';
import 'package:top_shop/models/categories_model.dart';
import 'package:top_shop/models/components.dart';

import '../../bloc/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopShopCubit, TopShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TopShopCubit.get(context).categoriesModel;
        return BuildCondition(
          condition: cubit != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) =>
                  buildCategoryItem(cubit!.data!.data[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: cubit!.data!.data.length,
            ),
          ),
          fallback: (context) =>
          const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildCategoryItem(DataModel? dataModel) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              gradient: gradient,
                borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.2),
              child: CachedNetworkImage(
                imageUrl: "${dataModel!.image}",
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: NetworkImage("${dataModel.image}"),
                ),
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('${dataModel.name}', style: const TextStyle(fontSize: 20),),
        const Spacer(),
        IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_rounded))
      ],
    );
  }
}
