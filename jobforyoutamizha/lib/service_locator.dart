import 'package:get_it/get_it.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service/payment_service.dart';
import 'package:jobforyoutamizha/service/user_info_service.dart';
GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<JobInfoService>(JobInfoService());
  locator.registerSingleton<UserInfoService>(UserInfoService());
  locator.registerSingleton<PaymentService>(PaymentService());
}