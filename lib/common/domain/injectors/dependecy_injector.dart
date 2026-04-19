import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:servana_cleaner_mobile/core/api/auth_token_holder.dart';
import 'package:servana_cleaner_mobile/core/api/servana_api.dart';
import 'package:servana_cleaner_mobile/core/api/servana_api_config.dart';
import 'package:servana_cleaner_mobile/core/api/session_profile.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_cards_store.dart';

final dpLocator = GetIt.instance;

void initInjector() {
  dpLocator.registerLazySingleton<AuthTokenHolder>(() => AuthTokenHolder());
  dpLocator.registerLazySingleton<SessionProfile>(() => SessionProfile());
  dpLocator.registerLazySingleton<Dio>(
    () => ServanaApiConfig.createDio(dpLocator<AuthTokenHolder>()),
  );
  dpLocator.registerLazySingleton<ServanaApi>(
    () => ServanaApi(
      dpLocator<Dio>(),
      dpLocator<AuthTokenHolder>(),
      dpLocator<SessionProfile>(),
    ),
  );
  dpLocator.registerLazySingleton<JobCardsStore>(
    () => JobCardsStore(
      dpLocator<ServanaApi>(),
      dpLocator<SessionProfile>(),
    ),
  );
}
