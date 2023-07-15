import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/models/models.dart';

class SelectTag extends StatelessWidget {
  const SelectTag({super.key, this.onTap});

  final void Function(ReportTag)? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5))
                ]),
            child: ListView(
              children: ReportTag.values
                  .map(
                    (e) => ListTile(
                        title: Text(e.getNameWithContext(context)),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          padding: EdgeInsets.zero,
                          onPressed: () => onTap?.call(e),
                        )),
                  )
                  .toList(),
            )));
  }
}
