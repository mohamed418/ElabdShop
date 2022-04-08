// ignore_for_file: unnecessary_new, avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_shop/modules/login/login_screen.dart';
import 'package:top_shop/modules/on_boarding/on_boarding_screen.dart';
import 'package:top_shop/network/local/cache_helper.dart';
import 'package:top_shop/network/remote/dio_helper.dart';
import 'bloc/cubit.dart';
import 'layout/shop_layout.dart';
import 'network/local/bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  HttpOverrides.global = new MyHttpOverrides();

  Widget widget;

  late bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  late String? token = CacheHelper.getData(key: 'token');

  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    onBoarding = false;
    widget = OnBoardingScreen();
  }

  print(token);
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  const MyApp({Key? key, this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TopShopCubit()..getHomeData()..getCategoriesData()..getFavoritesData()..getUserData()..search(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            // systemOverlayStyle: SystemUiOverlayStyle(
            //   statusBarColor: Colors.deepOrange,
            //   statusBarIconBrightness: Brightness.light
            // ),
              titleTextStyle: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              titleSpacing: 20,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.deepOrange,
              backgroundColor: Colors.white,
              unselectedItemColor: Colors.grey,
              elevation: 20),
          textTheme: const TextTheme(
            bodyText1: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.deepOrange),
          ),
        ),
        home: startWidget,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


