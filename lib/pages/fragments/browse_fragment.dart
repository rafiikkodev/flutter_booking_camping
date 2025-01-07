import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_camping/controller/booking_status_controller.dart';
import 'package:flutter_booking_camping/controller/browse_featured_controller.dart';
import 'package:flutter_booking_camping/controller/browse_newest_controller.dart';
import 'package:flutter_booking_camping/models/camp.dart';
import 'package:flutter_booking_camping/widgets/failed_ui.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BrowseFragment extends StatefulWidget {
  const BrowseFragment({super.key});

  @override
  State<BrowseFragment> createState() => _BrowseFragmentState();
}

class _BrowseFragmentState extends State<BrowseFragment> {
  final browseFeaturedController = Get.put(BrowseFeaturedController());
  final browseNewestController = Get.put(BrowseNewestController());
  final bookingStatusController = Get.put(BookingStatusController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      browseFeaturedController.fetchFeatured();
      browseNewestController.fetchNewest();
      // bookingStatusController.camp = {
      //   "name": "Piaggoi Pro",
      //   "image":
      //       "https://s3-alpha-sig.figma.com/img/db6b/9160/f19e6360dc612f01a465244ab0d1c31d?Expires=1735516800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=HoK5Lx9KszFpYm4Z8hxuL5UvLvLYKQmJd-GpZKrTtnsw~yrhXJWAGHsav3VIWTyW1Ya3tqPCqtkiVSd1QBl5QkR3p-JVAuV5foucUhV2BYxKYV25eiikGd~RK4aLjcXHLZEJ7TTfqIhSyUPX4wuD-8YdvVR6INkxpKwWcBGeUXKkcfpajrR4NLBMOq0xH55j~1Wmcjedi3rlxYfLj4KwE4e68oIRYVh51sIirk88P~l9wjhUlpjJ3a7f2FyM-z5vzu1itwiJje6jnyEGhVBlcMyB6mPNbCuR27aTyQYDmZ444C2Yifv6Ya3I6luxHko8KjAkH-8aF5FPcqslfk7KVg__"
      // };
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BrowseFeaturedController>(force: true);
    Get.delete<BrowseNewestController>(force: true);
    Get.delete<BookingStatusController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Gap(30 + MediaQuery.of(context).padding.top),
        buildheader(),
        buildBookingStatus(),
        const Gap(30),
        buildCategories(),
        const Gap(30),
        buildFeatured(),
        const Gap(30),
        buildNewest(),
        const Gap(100),
      ],
    );
  }

  Widget buildBookingStatus() {
    return Obx(() {
      Map camp = bookingStatusController.camp;
      if (camp.isEmpty) return const SizedBox();
      return Container(
        height: 96,
        margin: const EdgeInsets.fromLTRB(24, 30, 24, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff4a1dff),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 16),
                  blurRadius: 20,
                  color: const Color(0xff4a1dff).withOpacity(0.25))
            ]),
        child: Stack(
          children: [
            Positioned(
              left: -20,
              top: 0,
              bottom: 0,
              child: ExtendedImage.network(
                camp["image"],
                width: 80,
                height: 80,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                        text: "Your booking ",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffffffff),
                            height: 1.5),
                        children: [
                          TextSpan(
                            text: camp["name"],
                            style: const TextStyle(
                              color: Color(0xffffbc1c),
                            ),
                          ),
                          const TextSpan(
                            text: "\nhas been delivered to.",
                          ),
                        ]),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget buildNewest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Newest Camping",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff070623)),
          ),
        ),
        Obx(() {
          String status = browseNewestController.status;
          if (status == "") return const SizedBox();
          if (status == "loading") {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (status != "success") {
            return Center(
              child: FailedUI(message: status),
            );
          }
          List<Camp> list = browseNewestController.list;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Camp camp = list[index];
              final margin = EdgeInsets.only(
                top: index == 0 ? 10 : 9,
                bottom: index == list.length - 1 ? 20 : 9,
              );
              return buildItemNewest(camp, margin);
            },
          );
        })
      ],
    );
  }

  Widget buildItemNewest(Camp camp, EdgeInsetsGeometry margin) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/detail", arguments: camp.id);
      },
      child: Container(
        height: 98,
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ExtendedImage.network(
              camp.image,
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
                    camp.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff070623)),
                  ),
                  const Gap(4),
                  Text(
                    camp.category,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff838384)),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(
                          decimalDigits: 0, locale: "en_US", symbol: "\$")
                      .format(camp.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff6747E9)),
                ),
                const Text(
                  "/day",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff838384)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeatured() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Featured",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff070623)),
          ),
        ),
        const Gap(10),
        Obx(() {
          String status = browseFeaturedController.status;
          if (status == "") return const SizedBox();
          if (status == "loading") {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (status != "success") {
            return Center(
              child: FailedUI(message: status),
            );
          }
          List<Camp> list = browseFeaturedController.list;
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "No Featured Camping Available.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return SizedBox(
            height: 295,
            child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Camp camp = list[index];
                final margin = EdgeInsets.only(
                  left: index == 0 ? 24 : 12,
                  right: index == list.length - 1 ? 24 : 12,
                );
                bool isTrending = index == 0;
                return buildItemFeatured(camp, margin, isTrending);
              },
            ),
          );
        })
      ],
    );
  }

  Widget buildItemFeatured(
    Camp camp,
    EdgeInsetsGeometry margin,
    bool isTrending,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/detail", arguments: camp.id);
      },
      child: Container(
        width: 252,
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ExtendedImage.network(
                  camp.image,
                  width: 220,
                  height: 170,
                ),
                if (isTrending)
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffff2056),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                              color: const Color(0xffff2056).withOpacity(0.5)),
                        ]),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    child: const Text(
                      "TRENDING",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        camp.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff070623)),
                      ),
                      const Gap(4),
                      Text(
                        camp.category,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff838384)),
                      ),
                    ],
                  ),
                ),
                RatingBar.builder(
                    initialRating: camp.rating.toDouble(),
                    itemPadding: const EdgeInsets.all(0),
                    itemSize: 16,
                    unratedColor: Colors.grey[300],
                    allowHalfRating: true,
                    itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Color(0xffffbc1c),
                        ),
                    ignoreGestures: true,
                    onRatingUpdate: (value) {})
              ],
            ),
            const Gap(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(
                          decimalDigits: 0, locale: "en_US", symbol: "\$")
                      .format(camp.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff6747E9)),
                ),
                const Text(
                  "/day",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff838384)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategories() {
    final categories = [
      ["Paket A", "assets/ic_city.png"],
      ["Paket B", "assets/ic_downhill.png"],
      ["Paket C", "assets/ic_beach.png"],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Categories",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff070623)),
          ),
        ),
        const Gap(10),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              children: categories.map((e) {
                return Container(
                  height: 52,
                  margin: const EdgeInsets.only(right: 24),
                  padding: const EdgeInsets.fromLTRB(16, 14, 30, 14),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset(
                        e[1],
                        width: 24,
                        height: 24,
                      ),
                      const Gap(10),
                      Text(
                        e[0],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff070623)),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget buildheader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/logo_camping.png",
            height: 38,
            fit: BoxFit.fitHeight,
          ),
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Image.asset(
              "assets/ic_notification.png",
              height: 24,
              width: 24,
            ),
          )
        ],
      ),
    );
  }
}
