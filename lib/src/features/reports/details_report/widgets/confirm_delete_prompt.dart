import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDeletePrompt extends StatelessWidget {
  const ConfirmDeletePrompt(
      {super.key, required this.onConfirm, required this.onCancel});

  final Function onConfirm;
  final Function onCancel;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.6),
      ),
      TapRegion(
          onTapOutside: (event) => onCancel.call(),
          child: Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Text(
                                L.of(context)!.delete_report,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              L.of(context)!.delete_report_confirmation,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w300),
                            ),
                          )
                        ]),
                    Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () => onCancel.call(),
                                  child: Text(
                                    L.of(context)!.cancel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.w400),
                                  )),
                              TextButton(
                                  onPressed: () => onConfirm.call(),
                                  child: Text(
                                    L.of(context)!.delete,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w400),
                                  )),
                            ]))
                  ],
                )),
          ))
    ]);
  }
}
