import 'package:get/get.dart';

class BookingStatusController extends GetxController {
  final RxMap _bike = {}.obs;
  Map get camp => _bike;
  set camp(Map n) => _bike.value = n;
}
