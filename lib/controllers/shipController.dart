import 'package:get/get.dart';

class ShipController extends GetxController {
  final shipName = 'Ship Name'.obs;
  final dateVir = 'Date Vir'.obs;

  updateShipName(String name) {
    shipName.value = name;
  }

  updateDateVir(String date) {
    dateVir.value = date;
  }
}
