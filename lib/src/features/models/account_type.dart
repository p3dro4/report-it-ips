enum AccountTypes {
  student,
  teacher,
  staff,
  admin;
}

extension AccountTypesExtension on AccountTypes {
  String get name {
    return switch (this) {
      AccountTypes.student => "STUDENT",
      AccountTypes.teacher => "TEACHER",
      AccountTypes.staff => "STAFF",
      AccountTypes.admin => "ADMIN",
    };
  }
}
