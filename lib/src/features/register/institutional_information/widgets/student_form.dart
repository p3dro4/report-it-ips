import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key, required this.user, this.onSubmit});
  final AppUser user;
  final Function? onSubmit;

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  School? _school;
  String? _course;
  String? _schoolYear;
  AppUser? user;
  Map<String, String> _courses = {};

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  _onSubmit() {
    _formKey.currentState?.save();
    if (!(_formKey.currentState?.validate() ?? false)) {
      showSnackbar(
          context: context,
          message: L.of(context)!.correct_errors,
          backgroundColor: Theme.of(context).colorScheme.error);
      return;
    }
    user!.school = _school;
    user!.course = _course;
    user!.schoolYear = int.parse(_schoolYear!);
    widget.onSubmit!(user!);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomDropdownButton(
                items: {for (var e in School.values) e.name: e.fullName},
                label: L.of(context)!.school,
                prefixIcon: Icons.apartment,
                color: Theme.of(context).colorScheme.primary,
                errorColor: Theme.of(context).colorScheme.error,
                onChanged: (value) => {
                  setState(() {
                    _school = School.values.firstWhere((e) => e.name == value);
                    _course = null;
                    _courses = switch (_school) {
                      School.ests => {
                          for (var e in ESTSCourses.values) e.name: e.fullName
                        },
                      School.ese => {
                          for (var e in ESECourses.values) e.name: e.fullName
                        },
                      School.ess => {
                          for (var e in ESSCourses.values) e.name: e.fullName
                        },
                      School.esce => {
                          for (var e in ESCECourses.values) e.name: e.fullName
                        },
                      _ => {}
                    };
                  })
                },
                onSaved: (value) => {
                  _school = School.values.firstWhere((e) => e.name == value)
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return L.of(context)!.school_required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              CustomDropdownButton(
                items: _courses,
                label: L.of(context)!.course,
                prefixIcon: Icons.school_outlined,
                color: Theme.of(context).colorScheme.primary,
                errorColor: Theme.of(context).colorScheme.error,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return L.of(context)!.course_required;
                  }
                  return null;
                },
                value: _course,
                onChanged: (value) => {
                  setState(() {
                    _course = value;
                  })
                },
                onSaved: (value) => {
                  _course = value,
                },
              ),
              const SizedBox(height: 15),
              CustomFormInputField(
                prefixIcon: Icons.numbers_outlined,
                labelText: L.of(context)!.school_year,
                color: Theme.of(context).colorScheme.primary,
                errorColor: Theme.of(context).colorScheme.error,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  try {
                    int.parse(value!);
                  } catch (e) {
                    return L.of(context)!.school_year_invalid;
                  }
                  if (value?.isEmpty ?? true) {
                    return L.of(context)!.school_year_required;
                  } else if (int.parse(value!) < 1 || int.parse(value!) > 10) {
                    return L.of(context)!.school_year_invalid;
                  }
                  return null;
                },
                onSaved: (value) => {_schoolYear = value},
                onFieldSubmitted: (value) => _onSubmit(),
              )
            ],
          ),
        ),
        const SizedBox(height: 50),
        CustomSubmitButton(
          text: L.of(context)!.finish_registration,
          color: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
          callback: _onSubmit,
        )
      ]),
    );
  }
}
