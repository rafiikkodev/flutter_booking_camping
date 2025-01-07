import 'package:flutter_booking_camping/models/camp.dart';
import 'package:flutter_booking_camping/sources/camp_source.dart';
import 'package:get/get.dart';

class BrowseFeaturedController extends GetxController {
  final _list = <Camp>[].obs;
  List<Camp> get list => _list;
  set list(List<Camp> n) => _list.value = n;

  final _status = "".obs;
  String get status => _status.value;
  set status(String n) => _status.value = n;

  fetchFeatured() async {
    status = "loading";

    final bikes = await BikeSource.fetchFeaturedBike();
    if (bikes == null) {
      status = "something wrong";
      return;
    }

    status = "success";
    list = bikes;
  }
}
