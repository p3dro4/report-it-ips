import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class PromptSelectImage extends StatelessWidget {
  const PromptSelectImage({super.key, this.onCancel, this.onSelect});

  final Function()? onCancel;
  final Function(ImageSource)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.33,
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
          child: TapRegion(
              onTapOutside: (event) {
                if (onCancel != null) {
                  onCancel!();
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      L.of(context)!.select_image,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (onSelect != null) {
                                  onSelect!(ImageSource.camera);
                                }
                              },
                              icon: const Icon(Icons.camera_alt),
                            ),
                            Text(L.of(context)!.camera),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (onSelect != null) {
                                  onSelect!(ImageSource.gallery);
                                }
                              },
                              icon: const Icon(Icons.photo),
                            ),
                            Text(L.of(context)!.gallery),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )),
        )
      ],
    );
  }
}
