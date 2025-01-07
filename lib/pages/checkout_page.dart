import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_camping/models/camp.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage(
      {super.key,
      required this.camp,
      required this.startDate,
      required this.endDate});
  final Camp camp;
  final String startDate;
  final String endDate;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  num balance = 9500900;
  // num balance = 0;
  double grandTotal = 9200345;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Gap(20 + MediaQuery.of(context).padding.top),
          buildHeader(),
          const Gap(24),
          buildSnippetBike(),
          const Gap(24),
          buildDetails(),
        ],
      ),
    );
  }

  Widget buildDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
      child: Column(
        children: [
          buildItemDetail1("Price", "\$50,000", "/day"),
          const Gap(14),
          buildItemDetail2("Start Date", widget.startDate),
          const Gap(14),
          buildItemDetail2("End Date", widget.endDate),
          const Gap(14),
          buildItemDetail1("Duration", "15", " day"),
          const Gap(14),
          buildItemDetail2("Sub Total Price", "\$250,490"),
          const Gap(14),
          buildItemDetail2("Insurance 20%", "\$14,394"),
          const Gap(14),
          buildItemDetail2("Tax 20%", "\$3,394"),
          const Gap(14),
          buildItemDetail3(
              "Grand Total",
              NumberFormat.currency(
                decimalDigits: 0,
                locale: "en_us",
                symbol: "\$",
              ).format(grandTotal)),
        ],
      ),
    );
  }

  Widget buildItemDetail1(String title, String data, String unit) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff838384)),
        ),
        const Spacer(),
        Text(
          data,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623)),
        ),
        Text(
          unit,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff070623)),
        ),
      ],
    );
  }

  Widget buildItemDetail2(String title, String data) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff838384)),
        ),
        const Spacer(),
        Text(
          data,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff070623)),
        ),
      ],
    );
  }

  Widget buildItemDetail3(String title, String data) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff838384)),
        ),
        const Spacer(),
        Text(
          data,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff4a1dff)),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 46,
              width: 46,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              alignment: Alignment.center,
              child: Image.asset(
                "assets/ic_arrow_back.png",
                height: 24,
                width: 24,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              "Checkout",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff070623)),
            ),
          ),
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            alignment: Alignment.center,
            child: Image.asset(
              "assets/ic_more.png",
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSnippetBike() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        children: [
          ExtendedImage.network(
            widget.camp.image,
            width: 90,
            height: 70,
            fit: BoxFit.contain,
          ),
          const Gap(10),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.camp.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff070623)),
              ),
              Text(
                widget.camp.category,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff838384)),
              )
            ],
          )),
          Row(
            children: [
              Text(
                "${widget.camp.rating}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff070623)),
              ),
              const Gap(4),
              const Icon(
                Icons.star,
                size: 28,
                color: Color(0xffffbc1c),
              )
            ],
          )
        ],
      ),
    );
  }
}
