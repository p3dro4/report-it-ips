import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class StaffFormPage extends StatefulWidget {
  const StaffFormPage({super.key, required this.user, this.onSubmit});
  final AppUser user;
  final Function? onSubmit;

  @override
  State<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends State<StaffFormPage> {
  final _formKey = GlobalKey<FormState>();
  School? _school;
  String? _position;
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
    user!.position = _position;
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
                items: {for (var e in School.values) e.shortName: e.fullName},
                label: L.of(context)!.school,
                prefixIcon: Icons.apartment,
                color: Theme.of(context).colorScheme.primary,
                errorColor: Theme.of(context).colorScheme.error,
                onChanged: (value) => {
                  setState(() {
                    _school = School.values.firstWhere((e) => e.shortName == value);
                  })
                },
                onSaved: (value) => {
                  _school = School.values.firstWhere((e) => e.shortName == value)
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
                items: {
                  "administration": L.of(context)!.administration,
                  "maintenance": L.of(context)!.maintenance,
                  "cleaning": L.of(context)!.cleaning,
                  "security": L.of(context)!.security,
                  "cook": L.of(context)!.cook,
                  "external": L.of(context)!.external_position,
                  "other": L.of(context)!.other,
                },
                label: L.of(context)!.position,
                prefixIcon: Icons.business_center_outlined,
                color: Theme.of(context).colorScheme.primary,
                errorColor: Theme.of(context).colorScheme.error,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return L.of(context)!.position_required;
                  }
                  return null;
                },
                onSaved: (value) => {
                  _position = value,
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
