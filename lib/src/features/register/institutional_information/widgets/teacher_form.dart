import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class TeacherFormPage extends StatefulWidget {
  const TeacherFormPage({super.key, required this.user, this.onSubmit});
  final AppUser user;
  final Function? onSubmit;

  @override
  State<TeacherFormPage> createState() => _TeacherFormPageState();
}

class _TeacherFormPageState extends State<TeacherFormPage> {
  final _formKey = GlobalKey<FormState>();
  School? _school;
  String? _department;
  AppUser? user;

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
    user!.department = _department;
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
                items: switch (_school) {
                  School.ests => {
                      for (var e in ESTSDepartments.values) e.name: e.fullName
                    },
                  School.ese => {
                      for (var e in ESEDepartments.values) e.name: e.fullName
                    },
                  School.ess => {
                      for (var e in ESSDepartments.values) e.name: e.fullName
                    },
                  School.esce => {
                      for (var e in ESCEDepartments.values) e.name: e.fullName
                    },
                  _ => {},
                },
                label: L.of(context)!.department,
                prefixIcon: Icons.corporate_fare,
                color: Theme.of(context).colorScheme.primary,
                errorColor: Theme.of(context).colorScheme.error,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return L.of(context)!.department_required;
                  }
                  return null;
                },
                onSaved: (value) => {
                  _department = value,
                },
              ),
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
