// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names, avoid_print

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../bloc/cubit.dart';
import '../modules/product/product_datails.dart';

Color defaultColor = Colors.deepOrange;

void navigateTo(Widget, context) => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Widget),
    );

void navigateAndFinish(Widget, context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
      (route) => false,
    );

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';

LinearGradient gradient = const LinearGradient(
  // begin: Alignment.topLeft,
  // end: Alignment.bottomRight,
  colors: <Color>[
    Colors.yellow,
    Colors.amber,
    Colors.orangeAccent,
    Colors.orange,
    Colors.deepOrangeAccent,
    Colors.deepOrange,
  ],
);

ShaderMask shadeMask(text, style) => ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => const LinearGradient(
        // begin: Alignment.topLeft,
        // end: Alignment.bottomRight,
        colors: <Color>[
          Colors.amber,
          Colors.orangeAccent,
          Colors.orange,
          Colors.deepOrangeAccent,
          Colors.deepOrange,
        ],
      ).createShader(rect),
      child: Text(
        text,
        style: style,
      ),
    );

Widget catchImage(image, {bool? details}) => CachedNetworkImage(
      width: double.infinity,
      height: details! ? 400 : 200,
      imageUrl: image,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );

Widget buildProItem(model, context, {bool isOldPrice = true}) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        child: SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Hero(
                    tag: "${model.name}",
                    child: CachedNetworkImage(
                      height: 200,
                      width: 200,
                      imageUrl: "${model.image}",
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  // Image(
                  //     height: 200,
                  //     width: 200,
                  //     image: NetworkImage(
                  //       "${model.image}",
                  //     ),
                  // ),
                  if (model.discount != 0 && isOldPrice)
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
              //const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      //width: 180,
                      child: Text(
                        '${model.name}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
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
                              text: "${model.price}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (model.discount != 0 && isOldPrice)
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
                        const Spacer(),
                        if(isOldPrice == true)
                          Expanded(
                          child: AnimatedIconButton(
                            onPressed: () {
                              TopShopCubit.get(context)
                                  .changeFavorites(model.id!);
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
                    )
                  ],
                ),
              ),
            ],
          ),
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
    );

Widget defaultFormField({
  required TextEditingController? controller,
  required TextInputType? type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required Function validate,
  required String? label,
  required IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
  // ignore: use_function_type_syntax_for_parameters, non_constant_identifier_names
}) =>
    TextFormField(
      onTap: () {
        onTap!();
      },
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (s) {
        onSubmit!(s);
      },
      onChanged: (s) {
        onChange!(s);
      },
      validator: (value) {
        return validate(value);
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          /* borderSide: const BorderSide(
            color: MyColors.basColor,
            width: 2.0,
          ),*/
        ),
        labelText: label,
        labelStyle: const TextStyle(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );


Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.teal,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );