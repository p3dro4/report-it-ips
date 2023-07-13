import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class AppUser {
  AppUser({
    this.userType,
    this.name,
    this.birthdate,
    this.gender,
    this.school,
    this.course,
    this.schoolYear,
    this.department,
    this.position,
    this.profileCompleted = false,
  });

  //fields
  String? name;
  DateTime? birthdate;
  String? gender;
  AccountTypes? userType;
  School? school;
  String? course;
  int? schoolYear;
  String? department;
  String? position;
  bool profileCompleted;

  factory AppUser.fromSnapshot(Object? snapshot) {
    final user = snapshot as Map<Object?, Object?>;
    return AppUser(
      name: user[UserFields.name.name] as String?,
      birthdate: (user[UserFields.birthdate.name] as Timestamp).toDate(),
      gender: user[UserFields.gender.name] as String?,
      school: user[UserFields.school.name] != null
          ? School.values.firstWhere(
              (e) => e.shortName == user[UserFields.school.name] as String)
          : null,
      userType: user[UserFields.userType.name] != null
          ? AccountTypes.values.firstWhere(
              (e) => e.name == user[UserFields.userType.name] as String)
          : null,
      course: user[UserFields.course.name] as String?,
      schoolYear: user[UserFields.schoolYear.name] as int?,
      department: user[UserFields.department.name] as String?,
      position: user[UserFields.position.name] as String?,
      profileCompleted:
          user[UserFields.profileCompleted.name] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        UserFields.name.name: name,
        UserFields.birthdate.name: birthdate,
        UserFields.gender.name: gender,
        if (course != null) UserFields.school.name: school?.shortName,
        if (course != null) UserFields.course.name: course,
        if (schoolYear != null) UserFields.schoolYear.name: schoolYear,
        if (department != null) UserFields.department.name: department,
        if (position != null) UserFields.position.name: position,
        UserFields.userType.name: userType?.name,
        UserFields.profileCompleted.name: profileCompleted,
      };

  @override
  String toString() {
    return "### User ###\nName: $name\nBirthdate: $birthdate\nGender: $gender\nSchool: $school\nCourse: ${course ?? ""}\nSchool Year: ${schoolYear ?? ""}\nDepartment: ${department ?? ""}\nPosition: ${position ?? ""}\nUserType:$userType\nProfile Completed: $profileCompleted\n";
  }
}
