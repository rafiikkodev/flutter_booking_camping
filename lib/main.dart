import 'package:d_session/d_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_booking_camping/firebase_options.dart';
import 'package:flutter_booking_camping/models/camp.dart';
import 'package:flutter_booking_camping/pages/booking_page.dart';
import 'package:flutter_booking_camping/pages/chatting_page.dart';
import 'package:flutter_booking_camping/pages/checkout_page.dart';
import 'package:flutter_booking_camping/pages/detail_page.dart';
import 'package:flutter_booking_camping/pages/discover_page.dart';
import 'package:flutter_booking_camping/pages/pin_page.dart';
import 'package:flutter_booking_camping/pages/signin_page.dart';
import 'package:flutter_booking_camping/pages/signup_page.dart';
import 'package:flutter_booking_camping/pages/splash_screen.dart';
import 'package:flutter_booking_camping/pages/success_booking_page.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((value) {
      runApp(const MyApp());
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffEFEFF0),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: FutureBuilder(
          future: DSession.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data == null) return const SplashScreen();
            return const DiscoverPage();
          }),
      routes: {
        "/discover": (context) => const DiscoverPage(),
        "/signup": (context) => const SignupPage(),
        "/signin": (context) => const SigninPage(),
        "/detail": (context) {
          String bikeId = ModalRoute.of(context)!.settings.arguments as String;
          return DetailPage(bikeId: bikeId);
        },
        "/booking": (context) {
          Camp camp = ModalRoute.of(context)!.settings.arguments as Camp;
          return BookingPage(camp: camp);
        },
        "/checkout": (context) {
          Map data = ModalRoute.of(context)!.settings.arguments as Map;
          Camp camp = data["camp"];
          String startDate = data["startDate"];
          String endDate = data["endDate"];
          return CheckoutPage(
              camp: camp, startDate: startDate, endDate: endDate);
        },
        "/pin": (context) {
          Camp camp = ModalRoute.of(context)!.settings.arguments as Camp;
          return PINPage(camp: camp);
        },
        "/success-booking": (context) {
          Camp camp = ModalRoute.of(context)!.settings.arguments as Camp;
          return SuccessBookingPage(camp: camp);
        },
        "/chatting": (context) {
          Map data = ModalRoute.of(context)!.settings.arguments as Map;
          String uid = data["uid"];
          String userName = data["userName"];
          return ChattingPage(uid: uid, userName: userName);
        },
      },
    );
  }
}
