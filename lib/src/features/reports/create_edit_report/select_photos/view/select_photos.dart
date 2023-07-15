import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/features/reports/create_edit_report/select_photos/widgets/widgets.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SelectPhotosPage extends StatefulWidget {
  const SelectPhotosPage({super.key, this.id, required this.report});

  final String? id;
  final Report report;

  @override
  State<SelectPhotosPage> createState() => _SelectPhotosPageState();
}

class _SelectPhotosPageState extends State<SelectPhotosPage> {
  late Report report;
  bool _submitting = false;
  File? _imageFile;
  File? _bannerPhotoFile;
  Image? _bannerPhoto;
  final List<File> _additionalPhotosFiles = [];
  final List<Image> _additionalPhotos = [];
  bool _showBannerImageRequired = false;
  bool _showConfirmDialog = false;

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _imageFile = File(image.path);
      });
    } on PlatformException catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Falhou a selecionar a imagem!'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  Future<void> _onSubmit() async {
    setState(() {
      _submitting = true;
    });
    final doc = FirebaseFirestore.instance.collection("reports").doc(widget.id);
    report.timestamp = report.timestamp ?? DateTime.now();
    report.uid = FirebaseAuth.instance.currentUser!.uid;
    report.upvotes = report.upvotes ?? 0;
    if (_bannerPhotoFile != null) {
      await FirebaseStorage.instance
          .ref("reports_images/${doc.id}/banner")
          .putFile(_bannerPhotoFile!)
          .then((p0) => p0.ref
              .getDownloadURL()
              .then((value) => report.bannerPhotoURL = value));
    }
    List<String> addicionalPhotosURL = report.addicionalPhotosURL ?? [];
    await Future.wait(_additionalPhotosFiles.map((e) async {
      await FirebaseStorage.instance
          .ref(
              "reports_images/${doc.id}/add_photo_${_additionalPhotosFiles.indexOf(e)}")
          .putFile(e)
          .then((p0) => p0.ref
              .getDownloadURL()
              .then((value) => addicionalPhotosURL.add(value)));
    })).then((value) => report.setAdicionalPhotosURL(addicionalPhotosURL));
    Map<String, dynamic> json = report.toJson();
    if (widget.id != null) {
      json.addEntries([MapEntry("editTimestampt", DateTime.now())]);
    }
    await doc.set(json, SetOptions(merge: true)).then((value) => setState(() {
          _submitting = false;
          Navigator.of(context).popUntil((route) => route.isFirst);
          showSnackbar(
              context: context,
              message: widget.id != null
                  ? L.of(context)!.report_edited_successfully
                  : L.of(context)!.report_created_successfully,
              backgroundColor: Colors.green);
        }));
  }

  Future<void> _loadImages() async {
    _bannerPhoto = Image.network(widget.report.bannerPhotoURL ?? "");
    setState(() {
      for (var url in report.addicionalPhotosURL ?? []) {
        _additionalPhotos.add(Image.network(url));
      }
    });
  }

  @override
  void initState() {
    _submitting = true;
    report = widget.report;
    if (widget.id != null) {
      _loadImages().then((value) => setState(() {
            _submitting = false;
          }));
    } else {
      setState(() {
        _submitting = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(children: [
          const BackgroundImage(top: true, bottom: true),
          _submitting
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15,
                      bottom: MediaQuery.of(context).size.height * 0.15),
                  child: ListView(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        L.of(context)!.create_report,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                      )),
                                  const SizedBox(height: 10),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        L.of(context)!.select_images,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      )),
                                ])),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  L.of(context)!.banner_photo,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(height: 20),
                            if (_bannerPhoto == null)
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.gallery)
                                            .then((value) => setState(() {
                                                  _bannerPhotoFile = _imageFile;
                                                  _bannerPhoto = Image.file(
                                                      _bannerPhotoFile!,
                                                      height: 60,
                                                      width: 100,
                                                      fit: BoxFit.fill);
                                                  _showBannerImageRequired =
                                                      false;
                                                }));
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 10)),
                                        elevation: MaterialStateProperty.all(5),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                color: Colors.white),
                                            const SizedBox(width: 10),
                                            Text(L.of(context)!.add_photo,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary))
                                          ]),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.camera)
                                            .then((value) => setState(() {
                                                  _bannerPhotoFile = _imageFile;
                                                  _bannerPhoto = Image.file(
                                                      height: 60,
                                                      width: 100,
                                                      _bannerPhotoFile!,
                                                      fit: BoxFit.fill);
                                                  _showBannerImageRequired =
                                                      false;
                                                }));
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 10)),
                                        elevation: MaterialStateProperty.all(5),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                                Icons.photo_camera_outlined,
                                                color: Colors.white),
                                            const SizedBox(width: 10),
                                            Text(L.of(context)!.take_photo,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary))
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 25),
                            if (_showBannerImageRequired)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  L.of(context)!.banner_image_required,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                ),
                              ),
                            if (_bannerPhoto != null)
                              Row(children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                        width: 100,
                                        height: 60,
                                        child: _bannerPhoto!),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _bannerPhoto = null;
                                        _bannerPhotoFile = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove,
                                      size: 40,
                                    ))
                              ])
                          ]),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${L.of(context)!.additional_photos} (${L.of(context)!.optional.toLowerCase()})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(height: 20),
                            if (_additionalPhotos.length < 3)
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.gallery)
                                            .then((value) => setState(() {
                                                  _additionalPhotosFiles
                                                      .add(_imageFile!);
                                                  _additionalPhotos
                                                      .add(Image.file(
                                                    _imageFile!,
                                                    height: 60,
                                                    width: 100,
                                                    fit: BoxFit.fill,
                                                  ));
                                                }));
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 10)),
                                        elevation: MaterialStateProperty.all(5),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                color: Colors.white),
                                            const SizedBox(width: 10),
                                            Text(L.of(context)!.add_photo,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary))
                                          ]),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        pickImage(ImageSource.camera)
                                            .then((value) => setState(() {
                                                  _additionalPhotosFiles
                                                      .add(_imageFile!);
                                                  _additionalPhotos.add(
                                                    Image.file(_imageFile!,
                                                        height: 60,
                                                        width: 100,
                                                        fit: BoxFit.fill),
                                                  );
                                                }));
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 10)),
                                        elevation: MaterialStateProperty.all(5),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                                Icons.photo_camera_outlined,
                                                color: Colors.white),
                                            const SizedBox(width: 10),
                                            Text(L.of(context)!.take_photo,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary))
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 25),
                            _additionalPhotos.isNotEmpty
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      height: 70,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              _additionalPhotos.length + 1,
                                          itemBuilder: (context, index) {
                                            if (index ==
                                                _additionalPhotos.length) {
                                              return IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_additionalPhotos
                                                          .isNotEmpty) {
                                                        _additionalPhotos.remove(
                                                            _additionalPhotos
                                                                .last);
                                                      }
                                                      if (report
                                                          .addicionalPhotosURL!
                                                          .isNotEmpty) {
                                                        report
                                                            .addicionalPhotosURL!
                                                            .removeLast();
                                                      }
                                                      if (_additionalPhotosFiles
                                                          .isNotEmpty) {
                                                        _additionalPhotosFiles
                                                            .remove(
                                                                _additionalPhotosFiles
                                                                    .last);
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    size: 50,
                                                  ));
                                            } else {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: 60,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child:
                                                            _additionalPhotos[
                                                                index]),
                                                  ));
                                            }
                                          }),
                                    ),
                                  )
                                : const SizedBox(),
                          ]),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: CustomSubmitButton(
                              text: widget.id != null
                                  ? L.of(context)!.save_changes
                                  : L.of(context)!.publish_report,
                              color: Theme.of(context).colorScheme.primary,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              callback: () {
                                if (_bannerPhoto == null) {
                                  setState(() {
                                    _showBannerImageRequired = true;
                                  });
                                  return;
                                }
                                if (widget.id != null) {
                                  _onSubmit();
                                  return;
                                }

                                setState(() {
                                  _showConfirmDialog = true;
                                });
                              },
                            )),
                      ])),
          Padding(
              padding: const EdgeInsets.all(0),
              child: CustomBackButton(
                color: Theme.of(context).colorScheme.primary,
                text: L.of(context)!.back,
                callback: () => Navigator.of(context).pop(),
              )),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: CloseButton(
                      color: Colors.black,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                      ),
                      onPressed: () => {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                          }))),
          if (_showConfirmDialog)
            TapRegion(
                onTapOutside: (value) => setState(() {
                      _showConfirmDialog = false;
                    }),
                child: Center(
                  child: ConfirmPrompt(
                    onConfirm: () {
                      setState(() {
                        _showConfirmDialog = false;
                      });
                      _onSubmit();
                    },
                    onCancel: () {
                      setState(() {
                        _showConfirmDialog = false;
                      });
                    },
                  ),
                ))
        ])));
  }
}
