import 'package:report_it_ips/src/utils/utils.dart';

class AppUser {
  const AppUser({this.userType});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userType: json[UserFields.userType.name] as String?,
    );
  }
  final String? userType;

  Map<String, dynamic> toJson() => <String, dynamic>{
        UserFields.userType.name: userType,
      };
}
