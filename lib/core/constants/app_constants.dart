import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get appwriteEndpoint => dotenv.env['APPWRITE_ENDPOINT'] ?? '';
  static String get appwriteProjectId => dotenv.env['APPWRITE_PROJECT_ID'] ?? '';
  static String get databaseId => dotenv.env['APPWRITE_DATABASE_ID'] ?? '';

  // Collections
  static String get colUsers => dotenv.env['APPWRITE_COL_USERS'] ?? 'users';
  static String get colCampaigns => dotenv.env['APPWRITE_COL_CAMPAIGNS'] ?? 'campaigns';
  static String get colSubmissions => dotenv.env['APPWRITE_COL_SUBMISSIONS'] ?? 'submissions';
  static String get colRateCards => dotenv.env['APPWRITE_COL_RATE_CARDS'] ?? 'rate_cards';
  static String get colRateCardOrders => dotenv.env['APPWRITE_COL_RATE_CARD_ORDERS'] ?? 'rate_card_orders';
  static String get colTransactions => dotenv.env['APPWRITE_COL_TRANSACTIONS'] ?? 'transactions';
  static String get colMessages => dotenv.env['APPWRITE_COL_MESSAGES'] ?? 'messages';

  // Buckets
  static String get bucketProfile => dotenv.env['APPWRITE_BUCKET_PROFILE'] ?? 'profile_images';
  static String get bucketCampaign => dotenv.env['APPWRITE_BUCKET_CAMPAIGN'] ?? 'campaign_assets';
}
