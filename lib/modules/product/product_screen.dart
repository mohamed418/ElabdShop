import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:top_shop/bloc/cubit.dart';
import 'package:top_shop/bloc/states.dart';
import 'package:top_shop/models/categories_model.dart';
import 'package:top_shop/models/home_model.dart';
import 'package:top_shop/modules/product/product_datails.dart';
import '../../models/components.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopShopCubit, TopShopStates>(
      listener: (context, state) {
        if (state is FavoritesSuccessState) {
          if (!state.changeFavoritesModel.status!) {
            MotionToast.error(
              description: Text(
                state.changeFavoritesModel.message!,
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
        var cubit = TopShopCubit.get(context);
        return BuildCondition(
          condition: cubit.homeModel != null && cubit.categoriesModel != null,
          builder: (context) =>
              productBuilder(cubit.homeModel!, cubit.categoriesModel!, context),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productBuilder(HomeModel model, CategoriesModel? mo, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              items: model.data!.banners
                  .map(
                    (e) => CachedNetworkImage(
                      imageUrl: '${e.image}',
                      imageBuilder: (context, imageProvider) => Image(
                        image: CachedNetworkImageProvider('${e.image}'),
                        fit: BoxFit.fill,
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                //enlargeCenterPage: true,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shadeMask(
                    'Categories',
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCategoryItem(mo!.data!.data[index]),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemCount: mo!.data!.data.length,
                    ),
                  ),
                  const SizedBox(height: 10),
                  shadeMask(
                    "New Product",
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.6,
                crossAxisCount: 2,
                children: List.generate(
                  model.data!.products.length,
                  (index) =>
                      buildProductItem(model.data!.products[index], context),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildProductItem(ProductModel model, context) => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Hero(
                      tag: '${model.name}',
                      child: catchImage('${model.image}', details: false),
                    ),
                    if (model.discount != 0)
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          color: Colors.deepOrange,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3.5),
                          child: Text(
                            'discount',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 33,
                  child: Text(
                    model.name.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                              text: 'EGP ',
                              style: TextStyle(
                                fontSize: 12,
                                //fontWeight: FontWeight.w900,
                                color: Colors.deepOrange,
                              ),
                            ),
                            TextSpan(
                              text: model.price.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(width: 10),
                        if (model.discount != 0)
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                //decorationThickness: 1.3
                              ),
                              children: [
                                const TextSpan(
                                  text: 'EGP ',
                                ),
                                TextSpan(
                                  text: model.oldPrice.toString(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Expanded(
                      child: AnimatedIconButton(
                        onPressed: () {
                          TopShopCubit.get(context).changeFavorites(model.id!);
                        },
                        animationDirection: const AnimationDirection.bounce(),
                        duration: const Duration(milliseconds: 500),
                        splashColor: Colors.deepOrangeAccent,
                        icons: [
                          TopShopCubit.get(context).favorites![model.id!]!
                              ? const AnimatedIconItem(
                                  icon: Icon(Icons.favorite,
                                      color: Colors.deepOrange),
                                )
                              : const AnimatedIconItem(
                                  icon: Icon(Icons.favorite_outline_rounded,
                                      color: Colors.orange),
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      i: model.image,
                      n: model.name,
                      d: model.description,
                      D: model.discount,
                      id: model.id,
                      p: model.price,
                      op: model.oldPrice,
                    ),
                  ));
            },
          ),
        ),
      );

  Widget buildCategoryItem(DataModel? dataModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              gradient: gradient, borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(2.2),
            child: CachedNetworkImage(
              imageUrl: "${dataModel!.image}",
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider("${dataModel.image}"),
              ),
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          alignment: Alignment.center,
          width: 80,
          height: 30,
          child: Text(
            '${dataModel.name}',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

Future<bool?> onLikeButtonTapped(o, context) {
  TopShopCubit.get(context).changeFavorites(o);
  return o;
}
