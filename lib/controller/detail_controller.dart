import 'package:flutter_booking_camping/models/camp.dart';
import 'package:flutter_booking_camping/sources/camp_source.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  final Rx<Camp> _bike = Camp.empty.obs;
  Camp get camp => _bike.value;
  set camp(Camp n) => _bike.value = n;

  final _status = "".obs;
  String get status => _status.value;
  set status(String n) => _status.value = n;

  fetchBike(String bikeId) async {
    status = "loading";

    final bikeDetail = await BikeSource.fetchBike(bikeId);
    if (bikeDetail == null) {
      status = "something wrong";
      return;
    }

    status = "success";
    camp = bikeDetail;
  }
}
