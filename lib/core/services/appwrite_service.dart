import 'package:appwrite/appwrite.dart';
import '../constants/app_constants.dart';

class AppwriteService {
  static final Client _client = Client();
  static late final Account account;
  static late final Databases databases;
  static late final Storage storage;
  static late final Realtime realtime;
  static late final Functions functions;

  static Future<void> initialize() async {
    _client
      .setEndpoint(AppConstants.appwriteEndpoint)
      .setProject(AppConstants.appwriteProjectId);

    account   = Account(_client);
    databases = Databases(_client);
    storage   = Storage(_client);
    realtime  = Realtime(_client);
    functions = Functions(_client);
  }

  // Helper to access client if needed
  static Client get client => _client;
}
