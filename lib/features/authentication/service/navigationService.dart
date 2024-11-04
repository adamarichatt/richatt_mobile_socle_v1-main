import 'package:get/get.dart';

class NavigationService extends GetxService {
  final previousRoute = Rx<String?>(null);
  final previousArguments = Rx<Map<String, dynamic>?>(null);

  void savePreviousRoute(String route, {Map<String, dynamic>? arguments}) {
    previousRoute.value = route;
    previousArguments.value = arguments;
  }

  void clearPreviousRoute() {
    previousRoute.value = null;
    previousArguments.value = null;
  }
}
