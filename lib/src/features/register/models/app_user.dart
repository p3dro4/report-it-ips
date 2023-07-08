import 'package:report_it_ips/src/features/register/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class AppUser {
  AppUser({this.userType, this.name, this.birthdate});

  String? name;
  DateTime? birthdate;
  String? gender;
  final AccountTypes? userType;
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json[UserFields.name.name] as String?,
      birthdate: json[UserFields.birthdate.name] as DateTime?,
      userType: AccountTypes.values.firstWhere(
          (element) => element.name == json[UserFields.userType.name]),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        UserFields.name.name: name,
        UserFields.birthdate.name: birthdate,
        UserFields.gender.name: gender,
        UserFields.userType.name: userType?.name,
      };
}
