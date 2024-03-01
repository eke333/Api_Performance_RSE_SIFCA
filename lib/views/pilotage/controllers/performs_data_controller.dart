import 'package:get/get.dart';

class PerformsDataController extends GetxController {
  final annee = 0.obs;
  final isLoading = false.obs;

  void loadDataPerforms(int an) async {
    isLoading.value = true;
    annee.value = an;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  void initDate() {
    annee.value = DateTime.now().year;
  }

  @override
  void onInit() {
    initDate();
    super.onInit();
  }
}
