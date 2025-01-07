import 'package:flutter/material.dart';
import 'package:flutter_booking_camping/widgets/button_primary.dart';
import 'package:gap/gap.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(70),
          Image.asset(
            "assets/logo_camping.png",
            height: 38,
            width: 171,
          ),
          const Gap(30),
          const Text(
            "Camping & Be Happy!",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xff070623)),
          ),
          Expanded(
              child: Transform.translate(
            offset: const Offset(15, 0),
            child: Image.asset("assets/tent-1.png"),
          )),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "We provide all kinds of beautiful camping for your stay and the memories of your life.",
              style: TextStyle(
                  height: 1.7,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff070623)),
            ),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ButtonPrimary(
              text: "Explore Now",
              onTap: () {
                Navigator.pushReplacementNamed(context, "/signup");
              },
            ),
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
