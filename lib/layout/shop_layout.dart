import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:top_shop/bloc/cubit.dart';
import 'package:top_shop/bloc/states.dart';
import 'package:top_shop/models/components.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = TopShopCubit.get(context);
    return BlocConsumer<TopShopCubit, TopShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: RichText(
              text: TextSpan(children: [
                if(TopShopCubit.get(context).currentIndex == 0)
                  const TextSpan(
                  text: 'Your fav products will appear here',
                  style: TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.w900,
                      color: Colors.deepOrange,
                      ),
                ),
                if(TopShopCubit.get(context).currentIndex != 0)
                const TextSpan(
                  text: 'top shop',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFFFFFF),
                      shadows: [
                        BoxShadow(
                          color: Colors.deepOrange,
                          blurRadius: 10,
                          spreadRadius: 20,
                        )
                      ]),
                ),
              ]),
            ),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: ResponsiveNavigationBar(
            selectedIndex: cubit.currentIndex,
            onTabChange: (index) {
              cubit.changeBot(index);
            },
            navigationBarButtons: cubit.tabs,
            backgroundGradient: gradient,
            inactiveIconColor: Colors.deepOrange,
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
