import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';

class AppwriteService extends GetxService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Storage storage;
  late final Realtime realtime;
  late final Functions functions;

  Future<AppwriteService> init() async {
    client = Client()
      ..setEndpoint(AppConstants.appwriteEndpoint)
      ..setProject(AppConstants.appwriteProjectId);

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    realtime = Realtime(client);
    functions = Functions(client);
    
    return this;
  }
  
  // Static getter for easy access if needed, though Get.find is preferred
  static AppwriteService get to => Get.find();
}
