import 'package:d_session/d_session.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_camping/common/info.dart';
import 'package:flutter_booking_camping/controller/detail_controller.dart';
import 'package:flutter_booking_camping/models/account.dart';
import 'package:flutter_booking_camping/models/camp.dart';
import 'package:flutter_booking_camping/models/chat.dart';
import 'package:flutter_booking_camping/sources/chat_source.dart';
import 'package:flutter_booking_camping/widgets/button_primary.dart';
import 'package:flutter_booking_camping/widgets/failed_ui.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.bikeId});
  final String bikeId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final detailController = Get.put(DetailController());

  late final Account account;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailController.fetchBike(widget.bikeId);
    });
    DSession.getUser().then((value) {
      account = Account.fromJson(Map.from(value!));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Gap(30 + MediaQuery.of(context).padding.top),
          buildHeader(),
          const Gap(20),
          Obx(() {
            String status = detailController.status;
            if (status == "") return const SizedBox();
            if (status == "loading") {
              return const Center(child: CircularProgressIndicator());
            }
            if (status != "success") {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: FailedUI(message: status),
              );
            }
            Camp camp = detailController.camp;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      camp.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff070623)),
                    ),
                  ),
                  const Gap(10),
                  buildStats(camp),
                  const Gap(30),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        "assets/ellipse.png",
                        fit: BoxFit.fitWidth,
                      ),
                      ExtendedImage.network(
                        camp.image,
                        height: 250,
                        fit: BoxFit.fitHeight,
                      )
                    ],
                  ),
                  const Gap(20),
                  const Text(
                    "About",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff070623)),
                  ),
                  const Gap(10),
                  Text(
                    camp.about,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff070623)),
                  ),
                  const Gap(40),
                  buildPrice(camp),
                  const Gap(16),
                  buildSendMessage(camp),
                  const Gap(30),
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  Widget buildSendMessage(Camp camp) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      color: const Color(0xffffffff),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          String uid = account.uid;
          Chat chat = Chat(
              roomId: uid,
              message: "Ready?",
              receiverId: "cs",
              senderId: uid,
              bikeDetail: {
                "image": camp.image,
                "name": camp.name,
                "category": camp.category,
                "id": camp.id,
              });
          Info.netral("Loading...");
          ChatSource.openChatRoom(uid, account.name).then((value) {
            ChatSource.send(chat, uid).then((value) {
              Navigator.pushNamed(context, "/chatting", arguments: {
                "uid": uid,
                "userName": account.name,
              });
            });
          });
        },
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/ic_message.png",
                width: 24,
                height: 24,
              ),
              const Gap(10),
              const Text("Send Message",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff070623))),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPrice(Camp camp) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: const Color(0xff070623),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NumberFormat.currency(
                          decimalDigits: 0, locale: "en_US", symbol: "\$")
                      .format(camp.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffffffff)),
                ),
                const Text(
                  "/day",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffffffff)),
                ),
              ],
            ),
          ),
          SizedBox(
              width: 132,
              child: ButtonPrimary(
                  text: "Book Now",
                  onTap: () {
                    Navigator.pushNamed(context, "/booking", arguments: camp);
                  }))
        ],
      ),
    );
  }

  Row buildStats(Camp camp) {
    final stats = [
      ["assets/ic_beach.png", camp.level],
      [],
      ["assets/ic_downhill.png", camp.category],
      [],
      ["assets/ic_star.png", "${camp.rating}/5"],
    ];
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: stats.map((e) {
          if (e.isEmpty) return const Gap(20);
          return Row(
            children: [
              Image.asset(
                e[0],
                width: 24,
                height: 24,
              ),
              const Gap(4),
              Text(
                e[1],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff070623)),
              ),
            ],
          );
        }).toList());
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
              "Details",
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
              "assets/ic_favorite.png",
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }
}
