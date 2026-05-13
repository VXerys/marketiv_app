abstract class Routes {
  static const splash        = '/splash';
  static const onboarding    = '/onboarding';
  static const login         = '/login';
  static const register      = '/register';
  static const roleSelection = '/role-selection';

  // UMKM
  static const umkmHome        = '/umkm/home';
  static const campaignCreate  = '/umkm/campaign/create';
  static const campaignList    = '/umkm/campaign';
  static const campaignDetail  = '/umkm/campaign/detail';
  static const kreatorDirectory = '/umkm/kreator';
  static const kreatorProfile  = '/umkm/kreator/detail';
  static const keuanganUMKM    = '/umkm/keuangan';

  // Kreator
  static const kreatorHome     = '/kreator/home';
  static const jobPool         = '/kreator/job-pool';
  static const jobPoolDetail   = '/kreator/job-pool/detail';
  static const pekerjaanAktif  = '/kreator/pekerjaan-aktif';
  static const submitBukti     = '/kreator/pekerjaan-aktif/submit';
  static const rateCardManage  = '/kreator/rate-card';
  static const keuanganKreator = '/kreator/keuangan';

  // Admin
  static const adminHome = '/admin';

  // Shared
  static const editProfile  = '/profile/edit';
  static const notification = '/notification';
}
