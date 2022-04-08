import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_shop/bloc/cubit.dart';
import 'package:top_shop/bloc/states.dart';

import '../../models/components.dart';

class ProductDetailsScreen extends StatelessWidget {
  final dynamic i;
  final dynamic n;
  final dynamic d;
  final dynamic D;
  final dynamic id;
  final dynamic p;
  final dynamic op;

  ProductDetailsScreen({Key? key, this.i, this.n, this.d, this.D, this.id, this.p, this.op});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopShopCubit, TopShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TopShopCubit.get(context);
        var size = MediaQuery.of(context).size;
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Hero(
                          tag: '${n}',
                          child: catchImage('${i}', details: true),
                        ),
                        if (D != 0)
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: size.width*.7,
                          child: Text(
                            n,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedIconButton(
                            onPressed: () {
                              TopShopCubit.get(context).changeFavorites(id);
                            },
                            animationDirection: const AnimationDirection.bounce(),
                            duration: const Duration(milliseconds: 500),
                            splashColor: Colors.deepOrangeAccent,
                            icons: [
                              TopShopCubit.get(context).favorites![id!]!
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: shadeMask(
                        'Description',
                        const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Text(
                      d,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                  text: p.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(width: 10),
                            if (D != 0)
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
                                      text: op.toString(),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        TextButton(onPressed: (){}, child: Container(
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
                              'Add To card',
                              style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
